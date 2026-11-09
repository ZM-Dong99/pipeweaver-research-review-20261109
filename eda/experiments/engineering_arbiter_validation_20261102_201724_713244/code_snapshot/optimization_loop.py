"""Timing-aware RTL optimization loop for the PipeWeaver timing_adder."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from urllib.parse import urlsplit

try:
    from agents.rtl_optimizer import (LLMGenerationError, api_configured,
                                      build_candidate_prompt, generate_candidate,
                                      request_parameters_for_model)
except ImportError:
    from rtl_optimizer import (LLMGenerationError, api_configured,
                               build_candidate_prompt, generate_candidate,
                               request_parameters_for_model)

ROOT = Path(__file__).resolve().parents[1]
OPT_DIR = ROOT / "eda/experiments/sky130_optimize_20261027"
RUNNER = OPT_DIR / "run_experiment.py"
DEFAULT_RTL = ROOT / "benchmark/timing_adder.v"
LIB = ROOT / "eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
SDC = ROOT / "eda/experiments/sky130_sta_20261027/timing_adder.sdc"
EXPECTED_PORTS = {
    "clk": ("input", 1), "rst_n": ("input", 1), "a": ("input", 32),
    "b": ("input", 32), "c": ("input", 32), "y": ("output", 32),
}


class CandidatePipelineFailure(RuntimeError):
    def __init__(self, message: str, record: dict):
        super().__init__(message)
        self.record = record


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def redact_project_path(text: str) -> str:
    root = str(ROOT)
    posix = f"/mnt/{ROOT.drive[0].lower()}{ROOT.as_posix()[2:]}"
    return text.replace(root, "<PROJECT>").replace(root.replace("\\", "/"), "<PROJECT>").replace(posix, "<PROJECT>")


def safe_api_endpoint() -> str:
    raw = os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1")
    try:
        parsed = urlsplit(raw)
        host = parsed.hostname or "<invalid-host>"
        port = f":{parsed.port}" if parsed.port else ""
        return f"{parsed.scheme}://{host}{port}{parsed.path.rstrip('/')}"
    except ValueError:
        return "<invalid-endpoint-config>"


def decode_process_output(data: bytes | None) -> str:
    if not data:
        return ""
    if data.startswith((b"\xff\xfe", b"\xfe\xff")):
        return data.decode("utf-16", errors="replace")
    if data.count(b"\x00") > len(data) // 5:
        return data.decode("utf-16-le", errors="replace")
    return data.decode("utf-8", errors="replace")


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8")


def parse_ports(rtl: str) -> dict[str, tuple[str, int]]:
    match = re.search(r"\bmodule\s+timing_adder\s*\((.*?)\)\s*;", rtl, re.S)
    if not match:
        raise ValueError("RTL must declare ANSI-style module timing_adder(...) ports")
    ports = {}
    for item in match.group(1).split(","):
        item = re.sub(r"//[^\n]*|/\*.*?\*/", " ", item, flags=re.S).strip()
        m = re.fullmatch(
            r"(input|output|inout)\s+(?:(?:wire|reg|logic)\s+)*(?:signed\s+)?(?:\[(\d+)\s*:\s*(\d+)\]\s*)?([A-Za-z_]\w*)",
            item,
        )
        if not m:
            raise ValueError(f"Unsupported or malformed top-level port declaration: {item!r}")
        direction, left, right, name = m.groups()
        width = abs(int(left) - int(right)) + 1 if left is not None else 1
        if name in ports:
            raise ValueError(f"Duplicate top-level port: {name}")
        ports[name] = (direction, width)
    return ports


def validate_candidate(path: Path) -> dict:
    try:
        rtl = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        raise ValueError(f"Cannot read candidate RTL: {exc}") from exc
    ports = parse_ports(rtl)
    if ports != EXPECTED_PORTS:
        raise ValueError(f"Top-level timing_adder ports must match {EXPECTED_PORTS}; got {ports}")
    modules = re.findall(r"\bmodule\s+([A-Za-z_]\w*)", rtl)
    if modules.count("timing_adder") != 1:
        raise ValueError("Candidate must define exactly one timing_adder top module")
    return {"ports": {k: list(v) for k, v in ports.items()}, "modules": modules}


def find_yosys() -> Path:
    configured = os.environ.get("YOSYS")
    if configured:
        return Path(configured)
    default = Path(r"D:\oss-cad-suite\bin\yosys.exe")
    if default.is_file():
        return default
    found = shutil.which("yosys")
    if found:
        return Path(found)
    raise FileNotFoundError("Yosys not found; configure YOSYS or install OSS CAD Suite")


def tool_status() -> dict:
    yosys = find_yosys()
    smtbmc = Path(os.environ.get("SMTBMC", str(yosys.parent / "yosys-smtbmc.exe")))
    wsl = shutil.which("wsl.exe") or shutil.which("wsl")
    opensta_probe = {"available": False, "version": None, "error": None}
    if wsl:
        env = os.environ.copy()
        env.pop("OPENAI_API_KEY", None)
        sta = os.environ.get("OPENSTA", "/home/easton1/OpenSTA/build/sta")
        try:
            probe = subprocess.run([wsl, "-d", "Ubuntu", "--", sta, "-version"],
                                   cwd=ROOT, env=env, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT, timeout=20)
            output = decode_process_output(probe.stdout).strip()
            if probe.returncode == 0:
                opensta_probe.update(available=True,
                                     version=output.splitlines()[0] if output else "version output unavailable")
            elif "E_ACCESSDENIED" in output:
                opensta_probe["error"] = "WSL returned Wsl/Service/E_ACCESSDENIED"
            else:
                opensta_probe["error"] = next((line.strip() for line in output.splitlines() if line.strip()),
                                                f"WSL probe exited with code {probe.returncode}")[:240]
        except subprocess.TimeoutExpired:
            opensta_probe["error"] = "WSL/OpenSTA version probe timed out after 20 seconds"
        except OSError as exc:
            opensta_probe["error"] = f"WSL/OpenSTA probe failed: {type(exc).__name__}"
    return {
        "workspace": "project root",
        "yosys": {"binary": yosys.name, "exists": yosys.is_file()},
        "smtbmc": {"binary": smtbmc.name, "exists": smtbmc.is_file()},
        "wsl": {"executable_available": bool(wsl), "opensta_probe": opensta_probe},
        "opensta_configured": True,
        "liberty_exists": LIB.is_file(), "sdc_exists": SDC.is_file(),
        "api_key_configured": api_configured(),
        "api_base_url_configured": bool(os.environ.get("OPENAI_BASE_URL")),
        "api_endpoint": safe_api_endpoint(),
        "model_configured": bool(os.environ.get("PIPEWEAVER_LLM_MODEL", "").strip()),
    }


def check_syntax(candidate: Path, out: Path, timeout_s: int) -> dict:
    yosys = find_yosys()
    suite = yosys.parent.parent
    env = os.environ.copy()
    env.pop("OPENAI_API_KEY", None)
    env["PATH"] = os.pathsep.join([str(yosys.parent), str(suite / "lib"), env.get("PATH", "")])
    script, log = out / "syntax.ys", out / "syntax.log"
    candidate_arg = candidate.resolve().relative_to(ROOT).as_posix()
    script.write_text("\n".join([
        f"read_verilog -sv {candidate_arg}", "hierarchy -check -top timing_adder",
        "proc", "check -assert", ""
    ]), encoding="utf-8")
    try:
        proc = subprocess.run([str(yosys), "-Q", "-l", str(log), str(script)], cwd=ROOT,
                              env=env, text=True, encoding="utf-8", errors="replace", stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT, timeout=timeout_s)
    except subprocess.TimeoutExpired as exc:
        log.write_text(f"Syntax/structure check timed out after {timeout_s} seconds\n", encoding="utf-8")
        raise RuntimeError("Yosys syntax/structure check timed out") from exc
    (out / "syntax.stdout.log").write_text(proc.stdout.replace(str(ROOT), "<PROJECT>"), encoding="utf-8")
    if proc.returncode:
        raise RuntimeError(f"Yosys syntax/structure check failed (exit {proc.returncode}); see syntax.log")
    return {"status": "PASS", "script": "syntax.ys", "log": "syntax.log"}


def parse_sta(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    starts = list(re.finditer(r"^Startpoint:\s+(.+)$", text, re.M))
    start = starts[0] if starts else None
    path_text = text[start.start():starts[1].start()] if len(starts) > 1 else text[start.start():] if start else ""
    end = re.search(r"^Endpoint:\s+(.+)$", path_text, re.M)
    wns = re.search(r"worst slack max\s+([-+\d.]+)", text)
    tns = re.search(r"tns max\s+([-+\d.]+)", text)
    arrival = re.search(r"([-+\d.]+)\s+data arrival time", path_text)
    cells = re.findall(r"\((sky130_fd_sc_hd__[^)]+)\)", path_text)
    contributions = []
    for line in path_text.splitlines():
        m = re.match(r"\s*(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+.*\((sky130_fd_sc_hd__[^)]+)\)", line)
        if m:
            contributions.append({"incremental_delay_ns": float(m.group(1)),
                                  "arrival_ns": float(m.group(2)), "cell": m.group(3)})
    if not (start and end and wns and tns):
        raise ValueError(f"STA report lacks parsable critical-path/WNS/TNS data: {path.name}")
    return {
        "startpoint": start.group(1), "endpoint": end.group(1),
        "wns_ns": float(wns.group(1)), "tns_ns": float(tns.group(1)),
        "data_arrival_ns": float(arrival.group(1)) if arrival else None,
        "cell_count_on_reported_paths": len(cells),
        "cell_types_on_reported_paths": list(dict.fromkeys(cells)),
        "path_cell_contributions": contributions[:100],
    }


def get_version(command: list[str], timeout_s: int = 20) -> str:
    try:
        env = os.environ.copy()
        env.pop("OPENAI_API_KEY", None)
        if command and Path(command[0]).suffix.lower() == ".exe":
            executable = Path(command[0])
            env["PATH"] = os.pathsep.join([str(executable.parent), str(executable.parent.parent / "lib"), env.get("PATH", "")])
        p = subprocess.run(command, cwd=ROOT, text=True, encoding="utf-8", errors="replace", stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT, timeout=timeout_s, env=env)
        return p.stdout.strip().splitlines()[0][:300] if p.stdout.strip() else f"exit={p.returncode}, no version output"
    except (OSError, subprocess.TimeoutExpired) as exc:
        return f"unavailable: {type(exc).__name__}"


def load_best(experiment: Path) -> tuple[Path, dict]:
    data = json.loads((experiment / "best.json").read_text(encoding="utf-8"))
    rtl_path = experiment / data["rtl"]
    if sha256(rtl_path) != data["rtl_sha256"]:
        raise RuntimeError("Best RTL checksum mismatch; refusing to continue")
    return rtl_path, data["metrics"]


def judge_candidate(metrics: dict, best_metrics: dict, area_limit: float,
                     absolute_area_cap_um2: float | None = None) -> tuple[bool, dict, str]:
    area_cap_um2 = best_metrics["mapped_area_um2"] * area_limit
    if absolute_area_cap_um2 is not None:
        area_cap_um2 = min(area_cap_um2, absolute_area_cap_um2)
    area_ok = metrics.get("mapped_area_um2") is not None and metrics["mapped_area_um2"] <= area_cap_um2 + 1e-9
    prior_tns = best_metrics.get("tns_ns", 0.0)
    tns_ok = metrics.get("tns_ns") is not None and metrics["tns_ns"] >= prior_tns - 1e-9
    if prior_tns >= -1e-9:
        tns_ok = tns_ok and metrics.get("tns_ns", -float("inf")) >= -1e-9
    wns_better = metrics.get("wns_ns") is not None and metrics["wns_ns"] > best_metrics["wns_ns"] + 1e-9
    checks = {"formal_pass": metrics.get("formal") == "PASS", "area_within_limit": area_ok,
              "tns_non_regression": tns_ok, "wns_strict_improvement": wns_better}
    if not checks["formal_pass"]:
        reason = "REJECT: formal equivalence did not pass"
    elif not area_ok:
        reason = "REJECT: mapped area exceeds configured limit"
    elif not tns_ok:
        reason = "REJECT: TNS regresses or introduces negative slack"
    elif not wns_better:
        reason = "REJECT: WNS does not strictly improve; ties keep the existing best"
    else:
        reason = "ACCEPT: formal, area, TNS, and strict WNS checks passed"
    return reason.startswith("ACCEPT"), checks, reason


def run_candidate(*, experiment: Path, candidate: Path, reference: Path, candidate_dir: Path,
                  kind: str, round_index: int, candidate_index: int, explanation: dict,
                  generation: dict, best_metrics: dict | None, area_limit: float,
                  timeout_s: int, is_initial: bool = False,
                  absolute_area_cap_um2: float | None = None) -> dict:
    candidate_dir.mkdir(parents=True, exist_ok=False)
    total_started = time.monotonic()
    snapshot = candidate_dir / "candidate.v"
    shutil.copy2(candidate, snapshot)
    record = {
        "round": round_index, "candidate_index": candidate_index, "source": kind,
        "candidate_sha256": sha256(snapshot), "reference_sha256": sha256(reference),
        "model": generation.get("model"), "generation_parameters": generation,
        "explanation": explanation, "status": "FAILED", "accepted": False,
        "failure_reason": None, "validation_status": "NOT_RUN", "formal_status": "NOT_RUN",
        "ppa_status": "NOT_RUN", "started_at": datetime.now().astimezone().isoformat(),
        "best_before": best_metrics,
    }
    write_json(candidate_dir / "generation.json", {
        "source": kind, "round": round_index, "candidate_index": candidate_index,
        "model": generation.get("model"), "generation_parameters": generation,
        "explanation": explanation,
    })
    try:
        structure = validate_candidate(snapshot)
        syntax = check_syntax(snapshot, candidate_dir, timeout_s)
        record["validation_status"] = "PASS"
        record["structure"] = structure
        record["syntax_check"] = syntax
        record["formal_status"] = "RUNNING"
        record["ppa_status"] = "WAITING_FOR_FORMAL"
        runner_out = candidate_dir / "eda"
        cmd = [sys.executable, str(RUNNER), str(snapshot), "--reference-rtl", str(reference),
               "--out-dir", str(runner_out), "--timeout", str(timeout_s)]
        runner_log = candidate_dir / "runner.log"
        started = time.monotonic()
        env = os.environ.copy()
        env.pop("OPENAI_API_KEY", None)
        yosys = find_yosys()
        env["PATH"] = os.pathsep.join([str(yosys.parent), str(yosys.parent.parent / "lib"), env.get("PATH", "")])
        try:
            proc = subprocess.run(cmd, cwd=ROOT, env=env, text=True, encoding="utf-8", errors="replace", stdout=subprocess.PIPE,
                                  stderr=subprocess.STDOUT, timeout=timeout_s * 4)
        except subprocess.TimeoutExpired as exc:
            output = exc.stdout or ""
            if isinstance(output, bytes):
                output = output.decode("utf-8", errors="replace")
            runner_log.write_text(output.replace(str(ROOT), "<PROJECT>") + "\nOVERALL RUNNER TIMEOUT\n", encoding="utf-8")
            raise RuntimeError("candidate pipeline timed out") from exc
        output = proc.stdout.replace(str(ROOT), "<PROJECT>").replace(str(ROOT).replace("\\", "/"), "<PROJECT>")
        runner_log.write_text(output, encoding="utf-8")
        record["pipeline_runtime_seconds"] = round(time.monotonic() - started, 3)
        if proc.returncode:
            proof_log = runner_out / "formal_proof.log"
            if proof_log.is_file() and "Status: PASSED" in proof_log.read_text(encoding="utf-8", errors="replace"):
                record["formal_status"] = "PASS"
                record["ppa_status"] = "FAILED_AFTER_FORMAL"
            else:
                record["formal_status"] = "FAIL_OR_INCOMPLETE"
                record["ppa_status"] = "NOT_ELIGIBLE"
            record["failure_reason"] = output[-3000:].strip() or f"runner exit code {proc.returncode}"
            raise CandidatePipelineFailure(record["failure_reason"], record)
        runner_result = json.loads((runner_out / "result.json").read_text(encoding="utf-8"))
        record["formal_status"] = runner_result["formal"]
        record["ppa_status"] = "PASS"
        record["metrics"] = runner_result
        record["sta_context"] = parse_sta(runner_out / "sta.log")
        record["tool_versions"] = {
            "yosys": get_version([str(yosys), "-V"]),
            "smtbmc_binary": Path(os.environ.get("SMTBMC", str(yosys.parent / "yosys-smtbmc.exe"))).name,
            "opensta": get_version(["wsl.exe", "-d", "Ubuntu", "--",
                                    os.environ.get("OPENSTA", "/home/easton1/OpenSTA/build/sta"), "-version"]),
        }
        area_limit_um2 = best_metrics["mapped_area_um2"] * area_limit if best_metrics else None
        if area_limit_um2 is not None and absolute_area_cap_um2 is not None:
            area_limit_um2 = min(area_limit_um2, absolute_area_cap_um2)
        record["experiment_parameters"] = {
            "area_limit_ratio": area_limit,
            "area_limit_um2": round(area_limit_um2, 4) if area_limit_um2 is not None else None,
            "absolute_area_cap_um2": absolute_area_cap_um2,
            "sdc_sha256": runner_result.get("sdc_sha256"),
            "liberty_sha256": runner_result.get("liberty_sha256"),
            "timeout_per_tool_seconds": timeout_s,
        }
        if is_initial:
            record["acceptance_checks"] = {"formal_pass": runner_result["formal"] == "PASS",
                                           "initial_design_evaluated": True}
            record["accepted"] = runner_result["formal"] == "PASS"
            record["status"] = "ACCEPTED" if record["accepted"] else "FAILED"
            record["decision_reason"] = "INITIAL: selected RTL proved against canonical baseline and measured" if record["accepted"] else "REJECT: initial RTL is not equivalent"
        else:
            accepted, checks, reason = judge_candidate(
                runner_result, best_metrics, area_limit, absolute_area_cap_um2)
            record["acceptance_checks"] = checks
            record["accepted"] = accepted
            record["status"] = "ACCEPTED" if accepted else "REJECTED"
            record["decision_reason"] = reason
        if not is_initial and record["accepted"]:
            best_number = len(list((experiment / "best_versions").glob("best_r*.v"))) + 1
            best_rel = Path("best_versions") / f"best_r{best_number}.v"
            best_dest = experiment / best_rel
            shutil.copy2(snapshot, best_dest)
            write_json(experiment / "best.json", {
                "rtl": str(best_rel), "rtl_sha256": sha256(best_dest), "round": round_index,
                "candidate_index": candidate_index, "metrics": runner_result,
                "updated_at": datetime.now().astimezone().isoformat(),
            })
    except CandidatePipelineFailure as exc:
        record = exc.record
    except Exception as exc:
        record["failure_reason"] = f"{type(exc).__name__}: {exc}"
        record["decision_reason"] = "REJECT: validation or tool flow did not complete"
        record["status"] = "FAILED"
    record["finished_at"] = datetime.now().astimezone().isoformat()
    record["runtime_seconds"] = round(time.monotonic() - total_started, 3)
    write_json(candidate_dir / "result.json", record)
    return record


def _stage_description(candidate_dir: Path) -> tuple[str, str]:
    runner_out = candidate_dir / "eda"
    proof_log = runner_out / "formal_proof.log"
    if proof_log.is_file() and "Status: PASSED" in proof_log.read_text(encoding="utf-8", errors="replace"):
        formal, ppa = "PASS", "FAILED_AFTER_FORMAL"
    elif (runner_out / "formal_build.log").exists() or (runner_out / "formal_proof.log").exists():
        formal, ppa = "FAIL_OR_INCOMPLETE", "NOT_ELIGIBLE"
    else:
        formal, ppa = "NOT_RUN", "NOT_ELIGIBLE"
    return formal, ppa


def cmd_check(args) -> int:
    try:
        status = tool_status()
    except FileNotFoundError as exc:
        print(json.dumps({"error": str(exc), "api_key_configured": api_configured()}, indent=2))
        return 2
    print(json.dumps(status, indent=2, ensure_ascii=False))
    required = (status["yosys"]["exists"] and status["smtbmc"]["exists"]
                and status["wsl"]["opensta_probe"]["available"]
                and status["liberty_exists"] and status["sdc_exists"])
    return 0 if required else 2


def cmd_summary(args) -> int:
    root = Path(args.experiment_root).resolve()
    rows = []
    for p in root.rglob("result.json"):
        try:
            item = json.loads(p.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        if "accepted" not in item or p.parent.name == "evaluation":
            continue
        metrics = item.get("metrics", {})
        rows.append({"round": item.get("round"), "candidate": p.parent.name,
                     "status": item.get("status"), "accepted": item.get("accepted"),
                     "wns_ns": metrics.get("wns_ns"), "tns_ns": metrics.get("tns_ns"),
                     "area_um2": metrics.get("mapped_area_um2"),
                     "decision": item.get("decision_reason") or item.get("failure_reason")})
    rows.sort(key=lambda x: (x["round"] or 0, x["candidate"]))
    best_index = root / "best.json"
    best = json.loads(best_index.read_text(encoding="utf-8")) if best_index.is_file() else None
    try:
        display_root = root.relative_to(ROOT).as_posix()
    except ValueError:
        display_root = root.name
    print(json.dumps({"experiment_root": display_root, "best": best, "candidates": rows}, indent=2, ensure_ascii=False))
    return 0


def cmd_run(args) -> int:
    if args.rounds < 1 or args.max_candidates < 1 or args.timeout < 1 or args.llm_timeout < 1:
        print("Rounds, candidate count, and timeouts must be positive.", file=sys.stderr)
        return 2
    if args.candidate_rtl and args.rounds != 1:
        print("Manual --candidate-rtl mode supports one round; use LLM mode for multiple rounds.", file=sys.stderr)
        return 2
    if args.candidate_rtl and args.max_candidates != 1:
        print("Manual --candidate-rtl mode requires --max-candidates 1.", file=sys.stderr)
        return 2
    if not args.candidate_rtl and not api_configured():
        print("OPENAI_API_KEY is not configured; provide --candidate-rtl PATH for manual mode.", file=sys.stderr)
        return 2
    if not args.candidate_rtl and not args.model:
        print("No model ID configured; pass --model MODEL_ID or set PIPEWEAVER_LLM_MODEL.", file=sys.stderr)
        return 2
    if args.area_limit <= 0.0:
        print("--area-limit must be greater than 0.", file=sys.stderr)
        return 2
    if args.area_cap_um2 is not None and args.area_cap_um2 <= 0.0:
        print("--area-cap-um2 must be greater than 0.", file=sys.stderr)
        return 2
    start_rtl = Path(args.rtl).resolve()
    if not start_rtl.is_file():
        print(f"Starting RTL not found: {start_rtl.name}", file=sys.stderr)
        return 2
    if args.candidate_rtl and not Path(args.candidate_rtl).is_file():
        print(f"Manual candidate not found: {Path(args.candidate_rtl).name}", file=sys.stderr)
        return 2
    experiment = ROOT / "eda" / "experiments" / datetime.now().strftime("llm_loop_%Y%m%d_%H%M%S_%f")
    experiment.mkdir(parents=True, exist_ok=False)
    (experiment / "candidates").mkdir()
    (experiment / "best_versions").mkdir()
    initial = experiment / "initial.v"
    shutil.copy2(start_rtl, initial)
    print(f"Experiment: {experiment.relative_to(ROOT)}")

    # Evaluate the starting RTL against the canonical baseline before using it as the best.
    initial_record = run_candidate(
        experiment=experiment, candidate=initial, reference=DEFAULT_RTL,
        candidate_dir=experiment / "candidates" / "initial", kind="initial_rtl",
        round_index=0, candidate_index=0, explanation={"source": "user-selected starting RTL"},
        generation={"model": None, "parameters": {}},
        best_metrics=None, area_limit=args.area_limit, timeout_s=args.timeout, is_initial=True,
        absolute_area_cap_um2=args.area_cap_um2)
    if initial_record.get("status") != "ACCEPTED":
        print(f"Starting RTL evaluation failed: {initial_record.get('failure_reason') or initial_record.get('decision_reason')}", file=sys.stderr)
        return 1
    initial_metrics = initial_record["metrics"]
    initial_rel = Path("best_versions") / "best_r1.v"
    shutil.copy2(initial, experiment / initial_rel)
    write_json(experiment / "best.json", {
        "rtl": str(initial_rel), "rtl_sha256": sha256(experiment / initial_rel),
        "round": 0, "candidate_index": 0, "metrics": initial_metrics,
    })

    operational_failures = 0
    for round_index in range(1, args.rounds + 1):
        for candidate_index in range(1, args.max_candidates + 1):
            best_path, best_metrics = load_best(experiment)
            folder = experiment / "candidates" / f"round_{round_index:02d}" / f"candidate_{candidate_index:02d}"
            folder.mkdir(parents=True, exist_ok=False)
            generation_info = {"model": None, "parameters": {"mode": "manual"}}
            explanation = {"source": "manual candidate supplied by user"}
            generated_path = folder / "candidate_input.v"
            if args.candidate_rtl:
                shutil.copy2(Path(args.candidate_rtl).resolve(), generated_path)
            else:
                try:
                    artifact = best_metrics["artifact_dir"]
                    artifact_path = Path(artifact)
                    if not artifact_path.is_absolute():
                        artifact_path = ROOT / artifact_path
                    sta_context = parse_sta(artifact_path / "sta.log")
                    llm_started = time.monotonic()
                    previous_feedback = None
                    previous_candidate = (candidate_index - 1) if candidate_index > 1 else args.max_candidates
                    previous_round = round_index if candidate_index > 1 else round_index - 1
                    if previous_round > 0:
                        previous_path = (experiment / "candidates" / f"round_{previous_round:02d}" /
                                         f"candidate_{previous_candidate:02d}" / "result.json")
                        if previous_path.is_file():
                            previous = json.loads(previous_path.read_text(encoding="utf-8"))
                            previous_feedback = {
                                "status": previous.get("status"),
                                "decision_reason": previous.get("decision_reason") or previous.get("failure_reason"),
                                "metrics": previous.get("metrics"),
                            }
                    prompt_payload = build_candidate_prompt(
                        current_rtl=best_path.read_text(encoding="utf-8"),
                        sta_context=sta_context, metrics=best_metrics,
                        candidate_index=candidate_index, feedback=previous_feedback,
                        area_cap_um2=args.area_cap_um2)
                    write_json(folder / "prompt.json", {
                        "prompt": prompt_payload, "requested_model": args.model,
                        "request_parameters": request_parameters_for_model(args.model, 0.2),
                        "response_format": "json_object",
                        "api_endpoint": safe_api_endpoint(),
                    })
                    prompt_sha256 = sha256(folder / "prompt.json")
                    generated = generate_candidate(
                        current_rtl=best_path.read_text(encoding="utf-8"),
                        sta_context=sta_context, metrics=best_metrics, model=args.model,
                        candidate_index=candidate_index, timeout_s=args.llm_timeout,
                        feedback=previous_feedback, area_cap_um2=args.area_cap_um2,
                        audit_dir=folder / "api_audit")
                    generated_path.write_text(generated.rtl, encoding="utf-8")
                    generation_info = {"model": generated.model, **generated.generation_parameters,
                                       "api_endpoint": safe_api_endpoint(),
                                       "prompt_sha256": prompt_sha256,
                                       "generation_runtime_seconds": round(time.monotonic() - llm_started, 3)}
                    explanation = generated.explanation
                except (LLMGenerationError, OSError, ValueError) as exc:
                    operational_failures += 1
                    failure = {"round": round_index, "candidate_index": candidate_index,
                               "source": "llm", "model": args.model, "status": "FAILED",
                               "accepted": False, "failure_reason": str(exc),
                               "decision_reason": "REJECT: candidate generation failed",
                               "started_at": datetime.now().astimezone().isoformat(),
                               "finished_at": datetime.now().astimezone().isoformat()}
                    write_json(folder / "generation.json", failure)
                    write_json(folder / "result.json", failure)
                    print(f"round {round_index} candidate {candidate_index}: generation failed: {exc}")
                    continue
            record = run_candidate(
                experiment=experiment, candidate=generated_path, reference=DEFAULT_RTL,
                candidate_dir=folder / "evaluation", kind="manual" if args.candidate_rtl else "llm",
                round_index=round_index, candidate_index=candidate_index,
                explanation=explanation, generation=generation_info, best_metrics=best_metrics,
                area_limit=args.area_limit, timeout_s=args.timeout,
                absolute_area_cap_um2=args.area_cap_um2)
            shutil.copy2(generated_path, folder / "candidate.v")
            write_json(folder / "generation.json", {
                "source": "manual" if args.candidate_rtl else "llm",
                "round": round_index, "candidate_index": candidate_index,
                "model": generation_info.get("model"), "generation_parameters": generation_info,
                "explanation": explanation,
            })
            write_json(folder / "result.json", record)
            if record.get("status") == "FAILED":
                operational_failures += 1
            print(f"round {round_index} candidate {candidate_index}: {record.get('status')} — {record.get('decision_reason') or record.get('failure_reason')}")
    print(f"Completed. Summary: python agents/optimization_loop.py summary --experiment-root {experiment.relative_to(ROOT)}")
    print(f"Best index: {experiment.relative_to(ROOT) / 'best.json'}")
    return 1 if operational_failures else 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    try:
        from agents.sequential_loop import configure_parser
    except ImportError:
        from sequential_loop import configure_parser
    configure_parser(sub)
    check = sub.add_parser("check", help="check tools and API-key configuration")
    check.set_defaults(func=cmd_check)
    run = sub.add_parser("run", help="run manual or LLM-driven timing optimization")
    run.add_argument("--rtl", default=str(DEFAULT_RTL), help="starting best RTL")
    run.add_argument("--candidate-rtl", help="manual candidate path; no API key needed")
    run.add_argument("--rounds", type=int, default=1)
    run.add_argument("--max-candidates", type=int, default=1)
    run.add_argument("--area-limit", type=float, default=1.10, help="maximum area/current-best ratio")
    run.add_argument("--area-cap-um2", type=float, default=None,
                     help="fixed absolute mapped-area cap in square microns; combined with --area-limit")
    run.add_argument("--model", default=os.environ.get("PIPEWEAVER_LLM_MODEL"),
                     help="exact model ID (or set PIPEWEAVER_LLM_MODEL); required in LLM mode")
    run.add_argument("--llm-timeout", type=int, default=120)
    run.add_argument("--timeout", type=int, default=600, help="per-tool timeout in seconds")
    run.set_defaults(func=cmd_run)
    summary = sub.add_parser("summary", help="summarize an experiment and its current best")
    summary.add_argument("--experiment-root", required=True)
    summary.set_defaults(func=cmd_summary)
    return parser


def main(argv=None) -> int:
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
