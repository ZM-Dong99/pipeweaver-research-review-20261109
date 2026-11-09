"""Run a frozen three-arm timing-adder RTL comparison."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.optimization_loop import (  # noqa: E402
    check_syntax, get_version, parse_sta, redact_project_path, validate_candidate,
)
from agents.rtl_optimizer import LLMGenerationError, api_configured, generate_from_prompt  # noqa: E402

BASELINE = ROOT / "benchmark/timing_adder.v"
RUNNER = ROOT / "eda/experiments/sky130_optimize_20261027/run_experiment.py"
LIB = ROOT / "eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
SDC = ROOT / "eda/experiments/sky130_sta_20261027/timing_adder.sdc"
REFERENCE_METRICS = ROOT / "eda/experiments/sky130_optimize_20261027/runs/baseline_approved3/result.json"
REFERENCE_STA = ROOT / "eda/experiments/sky130_sta_20261027/opensta_verified.log"
CANDIDATES_PER_ARM = 3
AREA_LIMIT_RATIO = 1.10
TEMPERATURE = 0.2


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_digest(path: Path) -> str:
    return digest(path.read_bytes())


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8")


def generate_grouped_adder(group_width: int) -> str:
    if group_width not in (4, 8, 16) or 32 % group_width:
        raise ValueError("Supported constrained-search widths are 4, 8, and 16")
    groups = 32 // group_width
    lines = [
        "module timing_adder(input wire clk, input wire rst_n, input wire [31:0] a, input wire [31:0] b, input wire [31:0] c, output reg [31:0] y);",
        "reg [31:0] sum1, sum2; wire [31:0] ab_sum, c_sum;",
        "grouped_adder32 add_ab(.a(a), .b(b), .sum(ab_sum));",
        "grouped_adder32 add_c(.a(sum1), .b(c), .sum(c_sum));",
        "always @(posedge clk or negedge rst_n) begin",
        "  if (!rst_n) begin sum1 <= 0; sum2 <= 0; y <= 0; end",
        "  else begin sum1 <= ab_sum; sum2 <= c_sum; y <= sum2; end",
        "end", "endmodule", "",
        "module grouped_adder32(input wire [31:0] a, b, output wire [31:0] sum);",
        f"wire [{groups-1}:0] p, g; wire [{groups}:0] carry;",
    ]
    for i in range(groups):
        lo, hi = i * group_width, (i + 1) * group_width - 1
        lines += [
            f"wire [{group_width}:0] gen_{i};",
            f"assign gen_{i} = {{1'b0, a[{hi}:{lo}]}} + {{1'b0, b[{hi}:{lo}]}};",
            f"assign g[{i}] = gen_{i}[{group_width}];",
            f"assign p[{i}] = &(a[{hi}:{lo}] ^ b[{hi}:{lo}]);",
        ]
    lines.append("assign carry[0] = 1'b0;")
    for k in range(groups):
        terms = []
        for j in range(k, -1, -1):
            propagate = [f"p[{q}]" for q in range(k, j, -1)]
            terms.append("(" + " & ".join(propagate + [f"g[{j}]"]) + ")")
        lines.append(f"assign carry[{k+1}] = " + " | ".join(terms) + ";")
    for i in range(groups):
        lo, hi = i * group_width, (i + 1) * group_width - 1
        lines.append(f"assign sum[{hi}:{lo}] = a[{hi}:{lo}] + b[{hi}:{lo}] + carry[{i}];")
    lines += ["endmodule", ""]
    return "\n".join(lines)


def common_prompt(rtl: str) -> str:
    return f"""Optimize this RTL for improved timing while controlling area.
Preserve the exact module name and ports. Preserve cycle-by-cycle output behavior,
active-low asynchronous reset semantics, arithmetic modulo 2^32, and latency.
Do not change the clock constraints or add/remove pipeline stages. Return one JSON
object containing candidate_rtl, bottleneck, rewrite, expected_timing_gain,
area_or_other_cost, and functional_boundaries. candidate_rtl must be synthesizable
Verilog/SystemVerilog only.

Baseline RTL follows:
{rtl}
"""


def guided_prompt(rtl: str, sta_report: str) -> str:
    return common_prompt(rtl) + "\nBaseline OpenSTA critical-path report (use this report as the timing evidence):\n" + sta_report


def launch_runner(candidate: Path, out: Path, timeout_s: int) -> tuple[int, str, float]:
    out.mkdir(parents=True, exist_ok=False)
    cmd = [sys.executable, str(RUNNER), str(candidate), "--reference-rtl", str(BASELINE),
           "--out-dir", str(out / "eda"), "--timeout", str(timeout_s)]
    env = os.environ.copy()
    env.pop("OPENAI_API_KEY", None)
    yosys = Path(os.environ.get("YOSYS", r"D:\oss-cad-suite\bin\yosys.exe"))
    env["PATH"] = os.pathsep.join([str(yosys.parent), str(yosys.parent.parent / "lib"), env.get("PATH", "")])
    started = time.monotonic()
    try:
        proc = subprocess.run(cmd, cwd=ROOT, env=env, text=True, stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT, timeout=timeout_s * 4)
        output, code = proc.stdout, proc.returncode
    except subprocess.TimeoutExpired as exc:
        output = exc.stdout or ""
        if isinstance(output, bytes):
            output = output.decode("utf-8", errors="replace")
        output += f"\nOVERALL TIMEOUT after {timeout_s*4} seconds\n"
        code = 124
    elapsed = round(time.monotonic() - started, 3)
    (out / "runner.log").write_text(redact_project_path(output), encoding="utf-8")
    return code, output, elapsed


def initial_plan(study: Path, requested_model: str | None, report_text: str,
                 ref_metrics: dict) -> dict:
    base_rtl = BASELINE.read_text(encoding="utf-8")
    generic = common_prompt(base_rtl)
    guided = guided_prompt(base_rtl, report_text)
    (study / "prompts").mkdir()
    (study / "prompts/generic_llm.txt").write_text(generic, encoding="utf-8")
    (study / "prompts/sta_guided_llm.txt").write_text(guided, encoding="utf-8")
    (study / "prompts/constrained_search.txt").write_text(
        "Fixed search: independently generate grouped carry adders at widths 4, 8, and 16 bits. "
        "Only replace the combinational implementation of each 32-bit addition; retain all "
        "registers, reset, top-level ports, and cycle latency. Evaluate all candidates against "
        "the original RTL, never against another candidate.\n", encoding="utf-8")
    return {
        "study": "three-arm timing_adder RTL comparison",
        "created_at": datetime.now().astimezone().isoformat(),
        "baseline_rtl": "benchmark/timing_adder.v",
        "baseline_rtl_sha256": file_digest(BASELINE),
        "baseline_reference_result": "eda/experiments/sky130_optimize_20261027/runs/baseline_approved3/result.json",
        "baseline_reference_result_sha256": file_digest(REFERENCE_METRICS),
        "baseline_reference_metrics": {k: ref_metrics.get(k) for k in ("wns_ns", "tns_ns", "mapped_area_um2", "mapped_cells", "mapped_reset_flops", "formal")},
        "baseline_sta_report": "eda/experiments/sky130_sta_20261027/opensta_verified.log",
        "baseline_sta_report_sha256": file_digest(REFERENCE_STA),
        "candidate_budget_per_arm": CANDIDATES_PER_ARM,
        "total_candidate_slots": 3 * CANDIDATES_PER_ARM,
        "arms": {
            "generic_llm": {"input": ["baseline RTL", "functional constraints"], "sta_report_provided": False,
                            "prompt_sha256": digest((study / "prompts/generic_llm.txt").read_bytes()),
                            "independent_from_previous_candidates": True},
            "sta_guided_llm": {"input": ["same baseline RTL", "baseline OpenSTA report", "same functional constraints"],
                               "sta_report_provided": True,
                               "prompt_sha256": digest((study / "prompts/sta_guided_llm.txt").read_bytes()),
                               "independent_from_previous_candidates": True},
            "constrained_search": {"allowed_rule": "grouped carry-lookahead adder; preserve state and latency",
                                   "candidate_parameter_values": [4, 8, 16],
                                   "candidate_budget": 3,
                                   "prompt_sha256": digest((study / "prompts/constrained_search.txt").read_bytes()),
                                   "independent_from_previous_candidates": True},
        },
        "generation": {"requested_model": requested_model, "temperature": TEMPERATURE,
                       "response_format": "json_object", "per_candidate_call": True,
                       "api_key_configured": api_configured()},
        "tool_versions": {
            "yosys": get_version([os.environ.get("YOSYS", r"D:\oss-cad-suite\bin\yosys.exe"), "-V"]),
            "yosys_smtbmc": "bundled with the Yosys OSS CAD Suite listed above",
            "opensta": get_version(["wsl.exe", "-d", "Ubuntu", "--",
                                    os.environ.get("OPENSTA", "/home/easton1/OpenSTA/build/sta"), "-version"]),
        },
        "study_runner_sha256": file_digest(Path(__file__).resolve()),
        "candidate_runner_sha256": file_digest(RUNNER),
        "evaluation": {
            "reference_rtl_for_every_candidate": "benchmark/timing_adder.v",
            "formal": "yosys-smtbmc temporal induction; assert y equality; initial rst_n asserted",
            "mapping_and_sta": "eda/experiments/sky130_optimize_20261027/run_experiment.py",
            "sdc": "eda/experiments/sky130_sta_20261027/timing_adder.sdc",
            "sdc_sha256": file_digest(SDC), "liberty": "eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib",
            "liberty_sha256": file_digest(LIB), "area_limit_ratio": AREA_LIMIT_RATIO,
            "acceptance_eligibility": "formal pass and area <= baseline area * 1.10",
            "all_candidates_retained": True,
        },
        "model_version_policy": "record only the model identifier returned by the API; do not infer a version",
        "result_statistics": {
            "formal_pass_rate_denominator": CANDIDATES_PER_ARM,
            "best_wns": "best PPA-complete formal-pass candidate within area cap",
            "average_wns": "mean over PPA-complete formal-pass candidates; area eligibility reported separately",
            "average_area_delta": "mean mapped-area percent change from reproduced baseline over PPA-complete formal-pass candidates",
            "runtime": "per-candidate elapsed generation and/or validation+formal+PPA time, reported separately",
        },
    }


def summarize(study: Path, baseline_metrics: dict, candidate_records: list[dict]) -> dict:
    groups = {}
    for arm in ("generic_llm", "sta_guided_llm", "constrained_search"):
        rows = [r for r in candidate_records if r["arm"] == arm]
        proof = [r for r in rows if r.get("formal_status") in ("PASS", "FAIL")]
        complete = [r for r in rows if r.get("ppa_status") == "PASS" and r.get("formal_status") == "PASS"]
        eligible = [r for r in complete if r.get("area_within_limit")]
        groups[arm] = {
            "scheduled": CANDIDATES_PER_ARM,
            "generated": sum(r.get("candidate_sha256") is not None for r in rows),
            "formal_tested": len(proof),
            "formal_passed": sum(r.get("formal_status") == "PASS" for r in rows),
            "formal_pass_rate": (sum(r.get("formal_status") == "PASS" for r in rows) / CANDIDATES_PER_ARM) if len(proof) == CANDIDATES_PER_ARM else None,
            "formal_pass_rate_among_tested": (sum(r.get("formal_status") == "PASS" for r in rows) / len(proof)) if proof else None,
            "ppa_complete": len(complete),
            "area_eligible": len(eligible),
            "best_wns_ns": max((r["metrics"]["wns_ns"] for r in eligible), default=None),
            "average_wns_ns": (sum(r["metrics"]["wns_ns"] for r in complete) / len(complete)) if complete else None,
            "average_tns_ns": (sum(r["metrics"]["tns_ns"] for r in complete) / len(complete)) if complete else None,
            "average_area_delta_percent": (sum((r["metrics"]["mapped_area_um2"] / baseline_metrics["mapped_area_um2"] - 1) * 100 for r in complete) / len(complete)) if complete else None,
            "average_runtime_seconds": (sum(r["total_runtime_seconds"] for r in rows if r.get("total_runtime_seconds") is not None) / sum(r.get("total_runtime_seconds") is not None for r in rows)) if any(r.get("total_runtime_seconds") is not None for r in rows) else None,
            "failures": [{"candidate": r["candidate_id"], "status": r["status"], "reason": r.get("failure_reason")} for r in rows if r["status"] not in ("PASS", "PENDING_API_KEY")],
            "pending_reasons": [{"candidate": r["candidate_id"], "reason": r.get("failure_reason")} for r in rows if r["status"] == "PENDING_API_KEY"],
            "pending": sum(r["status"] == "PENDING_API_KEY" for r in rows),
        }
    return {
        "study_dir": study.name,
        "protocol_sha256": file_digest(study / "protocol.json"),
        "baseline": baseline_metrics,
        "groups": groups,
        "interpretation_limit": "One timing_adder design, one selected SKY130HD TT library, and one exploratory SDC; no generalization beyond these tested conditions.",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", help="required requested model ID when OPENAI_API_KEY is configured")
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--llm-timeout", type=int, default=120)
    args = parser.parse_args()
    requested_model = args.model or os.environ.get("PIPEWEAVER_LLM_MODEL")
    if api_configured() and not requested_model:
        parser.error("OPENAI_API_KEY is configured; pass --model explicitly so the requested model is recorded")
    if not BASELINE.is_file() or not LIB.is_file() or not SDC.is_file() or not REFERENCE_METRICS.is_file() or not REFERENCE_STA.is_file():
        parser.error("A required baseline, prior result, Liberty, SDC, or STA report is missing")
    ref_metrics = json.loads(REFERENCE_METRICS.read_text(encoding="utf-8"))
    if file_digest(BASELINE) != ref_metrics["candidate_sha256"]:
        parser.error("Baseline RTL hash does not match the preserved baseline result")
    report_text = REFERENCE_STA.read_text(encoding="utf-8", errors="replace")
    study = ROOT / "eda" / "experiments" / datetime.now().strftime("controlled_rtl_study_%Y%m%d_%H%M%S_%f")
    study.mkdir(parents=True, exist_ok=False)
    (study / "baseline").mkdir()
    plan = initial_plan(study, requested_model, report_text, ref_metrics)
    write_json(study / "protocol.json", plan)
    protocol_hash = file_digest(study / "protocol.json")
    (study / "protocol.sha256").write_text(protocol_hash + "  protocol.json\n", encoding="ascii")

    # Reproduce baseline under the same runner; candidate arms cannot start if the reference drifts.
    baseline_out = study / "baseline" / "reproduction"
    code, output, baseline_runtime = launch_runner(BASELINE, baseline_out, args.timeout)
    baseline_note = {"exit_code": code, "runtime_seconds": baseline_runtime,
                     "log": "baseline/reproduction/runner.log"}
    if code == 0 and (baseline_out / "eda/result.json").is_file():
        fresh = json.loads((baseline_out / "eda/result.json").read_text(encoding="utf-8"))
        baseline_note["metrics"] = fresh
        same = all(fresh.get(k) == ref_metrics.get(k) for k in ("wns_ns", "tns_ns", "mapped_area_um2", "mapped_cells", "mapped_reset_flops"))
        baseline_note["matches_preserved_reference"] = same
        baseline_metrics = fresh if same else fresh
    else:
        baseline_note.update({"matches_preserved_reference": False, "failure_reason": redact_project_path(output[-3000:])})
        write_json(study / "baseline/reproduction.json", baseline_note)
        print(f"Baseline reproduction failed; candidates not evaluated. See {study.relative_to(ROOT) / 'baseline/reproduction'}")
        return 1
    write_json(study / "baseline/reproduction.json", baseline_note)
    if not baseline_note["matches_preserved_reference"]:
        print("Fresh baseline differs from the preserved reference; stopping candidate evaluation for fairness.")
        return 1

    slots: list[dict] = []
    common = common_prompt(BASELINE.read_text(encoding="utf-8"))
    guided = guided_prompt(BASELINE.read_text(encoding="utf-8"), report_text)
    for arm, template in (("generic_llm", common), ("sta_guided_llm", guided)):
        for i in range(1, CANDIDATES_PER_ARM + 1):
            cid = f"candidate_{i:02d}"
            folder = study / arm / cid
            folder.mkdir(parents=True)
            (folder / "prompt.txt").write_text(template, encoding="utf-8")
            rec = {"arm": arm, "candidate_id": cid, "prompt_sha256": file_digest(folder / "prompt.txt"),
                   "prompt": f"{arm}/{cid}/prompt.txt", "requested_model": requested_model,
                   "temperature": TEMPERATURE, "status": "PENDING_API_KEY" if not api_configured() else "PENDING_GENERATION",
                   "candidate_sha256": None, "formal_status": "NOT_RUN", "ppa_status": "NOT_RUN",
                   "failure_reason": "OPENAI_API_KEY is not configured; no model call was made" if not api_configured() else None}
            if api_configured():
                started = time.monotonic()
                try:
                    generated = generate_from_prompt(template, model=requested_model, temperature=TEMPERATURE,
                                                     candidate_index=i, timeout_s=args.llm_timeout)
                    rtl = folder / "candidate.v"
                    rtl.write_text(generated.rtl, encoding="utf-8")
                    rec.update({"status": "GENERATED", "candidate_sha256": file_digest(rtl),
                                "response_model_id": generated.model,
                                "generation_parameters": generated.generation_parameters,
                                "explanation": generated.explanation,
                                "generation_runtime_seconds": round(time.monotonic() - started, 3)})
                except LLMGenerationError as exc:
                    rec.update({"status": "FAILED_GENERATION", "failure_reason": str(exc),
                                "generation_runtime_seconds": round(time.monotonic() - started, 3)})
            write_json(folder / "generation.json", rec)
            slots.append(rec)

    (study / "constrained_search").mkdir()
    for i, width in enumerate((4, 8, 16), 1):
        cid = f"candidate_{i:02d}"
        folder = study / "constrained_search" / cid
        folder.mkdir()
        prompt = (study / "prompts/constrained_search.txt").read_text(encoding="utf-8")
        (folder / "prompt.txt").write_text(prompt, encoding="utf-8")
        rtl = folder / "candidate.v"
        rtl.write_text(generate_grouped_adder(width), encoding="utf-8")
        explanation = {
            "method": "constrained_search", "rewrite_rule": "replace both combinational 32-bit additions with grouped carry-lookahead adders",
            "group_width_bits": width,
            "expected_timing_effect": "reduce serial carry depth across group boundaries; outcome must be measured",
            "expected_cost": "group generate/propagate logic may increase mapped area, especially for smaller groups",
            "functional_boundaries": "asynchronous reset, cycle alignment, modulo-2^32 wraparound, every input sequence",
        }
        rec = {"arm": "constrained_search", "candidate_id": cid, "prompt": "prompts/constrained_search.txt",
               "prompt_sha256": file_digest(study / "prompts/constrained_search.txt"),
               "candidate_sha256": file_digest(rtl), "requested_model": None, "response_model_id": None,
               "generation_parameters": {"group_width_bits": width, "rule": "grouped carry-lookahead", "candidate_budget": 3},
               "explanation": explanation, "status": "GENERATED", "formal_status": "NOT_RUN", "ppa_status": "NOT_RUN"}
        write_json(folder / "generation.json", rec)
        slots.append(rec)

    # Candidate contents, hashes, prompts, and model records are frozen before the first candidate PPA run.
    manifest = {"protocol_sha256": protocol_hash, "frozen_at": datetime.now().astimezone().isoformat(), "candidate_slots": slots}
    write_json(study / "candidate_manifest.json", manifest)
    (study / "candidate_manifest.sha256").write_text(file_digest(study / "candidate_manifest.json") + "  candidate_manifest.json\n", encoding="ascii")
    if file_digest(study / "protocol.json") != protocol_hash:
        raise RuntimeError("Frozen protocol was modified before candidate evaluation")

    records: list[dict] = []
    baseline_area = baseline_metrics["mapped_area_um2"]
    for rec in slots:
        folder = study / rec["arm"] / rec["candidate_id"]
        started = time.monotonic()
        if rec["status"] in ("PENDING_API_KEY", "FAILED_GENERATION"):
            rec["total_runtime_seconds"] = rec.get("generation_runtime_seconds")
            write_json(folder / "result.json", rec)
            records.append(rec)
            continue
        candidate = folder / "candidate.v"
        try:
            rec["structure"] = validate_candidate(candidate)
            rec["validation"] = check_syntax(candidate, folder, args.timeout)
            rec["validation_status"] = "PASS"
        except Exception as exc:
            rec["status"] = "FAILED_VALIDATION"
            rec["validation_status"] = "FAIL"
            rec["failure_reason"] = f"{type(exc).__name__}: {exc}"
            rec["ppa_status"] = "NOT_ELIGIBLE"
            rec["total_runtime_seconds"] = round(time.monotonic() - started, 3)
            write_json(folder / "result.json", rec)
            records.append(rec)
            continue
        runner_out = folder / "evaluation"
        code, output, runner_runtime = launch_runner(candidate, runner_out, args.timeout)
        rec["pipeline_runtime_seconds"] = runner_runtime
        rec["total_runtime_seconds"] = round(time.monotonic() - started + rec.get("generation_runtime_seconds", 0.0), 3)
        if code == 0 and (runner_out / "eda/result.json").is_file():
            metrics = json.loads((runner_out / "eda/result.json").read_text(encoding="utf-8"))
            rec.update({"status": "PASS", "formal_status": "PASS", "ppa_status": "PASS", "metrics": metrics,
                        "sta_context": parse_sta(runner_out / "eda/sta.log"),
                        "area_within_limit": metrics["mapped_area_um2"] <= baseline_area * AREA_LIMIT_RATIO + 1e-9,
                        "area_delta_percent": (metrics["mapped_area_um2"] / baseline_area - 1) * 100})
        else:
            proof_log = runner_out / "eda/formal_proof.log"
            formal_pass = proof_log.is_file() and "Status: PASSED" in proof_log.read_text(encoding="utf-8", errors="replace")
            rec["status"] = "FAILED_EVALUATION"
            rec["formal_status"] = "PASS" if formal_pass else "FAIL"
            rec["ppa_status"] = "NOT_ELIGIBLE" if not formal_pass else "FAIL"
            rec["failure_reason"] = redact_project_path(output[-3000:])
        write_json(folder / "result.json", rec)
        records.append(rec)

    summary = summarize(study, baseline_metrics, records)
    summary["baseline_reproduction_runtime_seconds"] = baseline_runtime
    summary["llm_end_to_end_complete"] = all(r.get("status") == "PASS" for r in records if r["arm"] in ("generic_llm", "sta_guided_llm")) and all(r["arm"] != "generic_llm" or r.get("status") == "PASS" for r in records)
    write_json(study / "summary.json", summary)
    (study / "SUMMARY.md").write_text(render_summary(summary), encoding="utf-8")
    print(f"Study: {study.relative_to(ROOT)}")
    print(f"Protocol SHA-256: {protocol_hash}")
    print(json.dumps(summary["groups"], indent=2, ensure_ascii=False))
    return 0


def render_summary(summary: dict) -> str:
    lines = ["# Three-arm RTL timing study", "", f"Protocol SHA-256: `{summary['protocol_sha256']}`", "",
             "| Arm | Generated | Formal pass | PPA complete | Area eligible | Best eligible WNS (ns) | Average WNS (ns) | Avg area delta | Avg runtime (s) |",
             "|---|---:|---:|---:|---:|---:|---:|---:|---:|"]
    for name, g in summary["groups"].items():
        fmt = lambda x: "—" if x is None else f"{x:.3f}"
        pass_rate = "—" if g["formal_pass_rate"] is None else f"{g['formal_pass_rate']:.0%} ({g['formal_passed']}/{g['formal_tested']})"
        lines.append(f"| {name} | {g['generated']}/3 | {pass_rate} | {g['ppa_complete']} | {g['area_eligible']} | {fmt(g['best_wns_ns'])} | {fmt(g['average_wns_ns'])} | {fmt(g['average_area_delta_percent'])}% | {fmt(g['average_runtime_seconds'])} |")
    lines += ["", "## Scope", "", summary["interpretation_limit"], ""]
    return "\n".join(lines)


if __name__ == "__main__":
    raise SystemExit(main())
