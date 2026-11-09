"""Prove and evaluate a native combinational RTL module without an interface wrapper."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import subprocess
import time
from datetime import datetime
from pathlib import Path
from trace_sta_rtl_cone import trace as trace_rtl_cone


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path: Path, value: dict) -> None:
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8")


def q(path: Path) -> str:
    return '"' + path.resolve().as_posix().replace('"', '\\"') + '"'


def execute(command: list[str], root: Path, log: Path, env: dict, timeout: int) -> str:
    try:
        proc = subprocess.run(command, cwd=root, env=env, stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT, timeout=timeout)
        raw = proc.stdout
    except subprocess.TimeoutExpired as exc:
        raw = exc.stdout or b""
        log.write_text(raw.decode("utf-8", errors="replace") + "\nTIMEOUT\n", encoding="utf-8")
        raise RuntimeError(f"Tool timeout; see {log.name}") from None
    encoding = "utf-16" if raw.startswith((b"\xff\xfe", b"\xfe\xff")) else "utf-8"
    output = raw.decode(encoding, errors="replace")
    log.write_text(output, encoding="utf-8")
    if proc.returncode:
        raise RuntimeError(f"Tool exit {proc.returncode}; see {log.name}")
    return output


def identifier(name: str) -> str:
    return name if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", name) else "\\" + name + " "


def parse_electrical_report(text: str) -> dict:
    if re.search(r"^\s*(?:Error:|ERROR:)", text, re.M):
        raise RuntimeError("OpenSTA reported an error; electrical checks are incomplete")
    begin, end = "PW_ELECTRICAL_BEGIN", "PW_ELECTRICAL_END"
    if text.count(begin) != 1 or text.count(end) != 1:
        raise RuntimeError("Missing or duplicate OpenSTA electrical check markers")
    if text.index(begin) >= text.index(end):
        raise RuntimeError("OpenSTA electrical check markers are out of order")
    block = text.split(begin, 1)[1].split(end, 1)[0]
    count = block.count("(VIOLATED)")
    return {"status": "PASS" if count == 0 else "FAIL", "violation_rows": count,
            "checks": ["max_slew", "max_capacitance"],
            "scope": "Library limits under recorded SDC; not physical signoff"}


def parse_parameter_overrides(items: list[str]) -> dict[str, int]:
    parameters = {}
    for item in items:
        match = re.fullmatch(r"([A-Za-z_][A-Za-z0-9_$]*)=(0[xX][0-9a-fA-F]+|[0-9]+)", item)
        if not match:
            raise ValueError("Parameters must be NAME=nonnegative_integer; no strings or expressions")
        name, raw = match.groups()
        if name in parameters:
            raise ValueError(f"Duplicate parameter override: {name}")
        parameters[name] = int(raw, 16 if raw.lower().startswith("0x") else 10)
    return dict(sorted(parameters.items()))


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("candidate", type=Path)
    ap.add_argument("--reference", type=Path, required=True)
    ap.add_argument("--top", required=True)
    ap.add_argument("--reference-top")
    ap.add_argument("--out", type=Path)
    ap.add_argument("--timeout", type=int, default=120)
    ap.add_argument("--param", action="append", default=[], metavar="NAME=VALUE",
                    help="same fixed nonnegative integer top-parameter override for candidate/reference; repeatable")
    ap.add_argument("--mapping-policy", choices=("legacy", "buffer_size"), default="legacy",
                    help="buffer_size adds ABC buffering/sizing with fixed driver and 10 fF output load; uses extra mapped-netlist proof")
    ap.add_argument("--cleanup-before-buffer", action="store_true",
                    help="opt-in ABC cleanup -i -o after map and before buffer; preserve input/output interface")
    args = ap.parse_args()
    try:
        parameters = parse_parameter_overrides(args.param)
    except ValueError as exc:
        ap.error(str(exc))
    def parameter_commands(top: str) -> list[str]:
        return [f"chparam -set {name} {value} {top}" for name, value in parameters.items()]
    if args.cleanup_before_buffer and args.mapping_policy != "buffer_size":
        ap.error("--cleanup-before-buffer requires --mapping-policy buffer_size")
    root = Path(__file__).resolve().parents[2]
    reference_top = args.reference_top or args.top
    for name in (args.top, reference_top):
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", name):
            ap.error("Top names must be plain Verilog identifiers")
    if args.timeout < 1:
        ap.error("Timeout must be positive")
    candidate, reference = args.candidate.resolve(), args.reference.resolve()
    lib = root / "eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
    for source in (candidate, reference, lib):
        if not source.is_file():
            ap.error(f"Missing file: {source}")
    out = args.out.resolve() if args.out else root / "eda/experiments" / datetime.now().strftime("native_comb_%Y%m%d_%H%M%S_%f")
    out.mkdir(parents=True, exist_ok=False)
    yosys = Path(os.environ.get("YOSYS", r"D:\oss-cad-suite\bin\yosys.exe"))
    env = os.environ.copy()
    env.pop("OPENAI_API_KEY", None)
    env["PATH"] = os.pathsep.join((str(yosys.parent), str(yosys.parent.parent / "lib"), env.get("PATH", "")))
    result = {"status": "RUNNING", "formal": "NOT_RUN", "ppa": "NOT_RUN", "out": str(out)}
    started = time.monotonic()
    versions = {}
    for name, command in (("yosys", [str(yosys), "-V"]), ("opensta", ["wsl.exe", "-d", "Ubuntu", "--",
                          os.environ.get("OPENSTA", "/home/easton1/OpenSTA/build/sta"), "-version"])):
        try:
            versions[name] = execute(command, root, out / f"{name}_version.log", env, min(20, args.timeout)).strip()
        except RuntimeError as exc:
            versions[name] = str(exc)
    protocol = {
        "scope": "native combinational RTL only; no wrapper, no sequential retiming",
        "candidate": str(candidate), "candidate_sha256": digest(candidate),
        "reference": str(reference), "reference_sha256": digest(reference),
        "top": args.top, "reference_top": reference_top,
        "parameter_overrides": parameters,
        "parameter_scope": "Only this fixed parameter instance; no proof for other parameter values",
        "liberty": str(lib), "liberty_sha256": digest(lib),
        "mapping": "hierarchy; flatten; synth -noabc; ABC script: strash; dretime; map" +
                   (("; cleanup -i -o" if args.cleanup_before_buffer else "") + "; buffer; upsize; dnsize; stime -p with fixed driver/output load" if args.mapping_policy == "buffer_size" else ""),
        "abc_cleanup_before_buffer": args.cleanup_before_buffer,
        "rtl_trace": "conservative bit-dependency cone from pre-ABC Yosys JSON; not an exact mapped-gate-to-source trace",
        "rtl_trace_runner_sha256": digest(Path(__file__).with_name("trace_sta_rtl_cone.py")),
        "electrical_eligibility": "Require complete max_slew/max_capacitance report and zero violation rows; fail closed on tool error or missing markers",
        "mapping_policy": args.mapping_policy,
        "abc_driver": "sky130_fd_sc_hd__buf_2" if args.mapping_policy == "buffer_size" else None,
        "abc_output_load_ff": 10.0 if args.mapping_policy == "buffer_size" else None,
        "mapped_netlist_proof_required": args.mapping_policy == "buffer_size",
        "formal": "unbounded combinational SAT proof of equality at every output, all input values; designs are separately hierarchized, flattened, stashed, and merged to support helper modules",
        "timeout_per_tool_seconds": args.timeout,
        "virtual_clock_period_ns": 100.0, "input_transition_ns": 0.10, "output_load_pf": 0.010,
        "primary_metric": "maximum combinational data arrival; virtual-clock slack is exploratory",
        "physical_parasitics": "not included", "runner_sha256": digest(Path(__file__)),
        "tool_versions": versions,
    }
    save(out / "protocol.json", protocol)
    result["protocol_sha256"] = digest(out / "protocol.json")
    print(f"Experiment: {out}", flush=True)

    def run_yosys(label: str, lines: list[str]) -> str:
        script = out / f"{label}.ys"
        script.write_text("\n".join(lines) + "\n", encoding="utf-8")
        return execute([str(yosys), "-Q", str(script)], root, out / f"{label}.log", env, args.timeout)

    try:
        schemas = []
        for label, source, top in (("candidate", candidate, args.top), ("reference", reference, reference_top)):
            metadata = out / f"{label}_schema.json"
            run_yosys(label + "_schema", [f"read_verilog -sv {q(source)}", *parameter_commands(top), f"hierarchy -check -top {top}",
                      "proc", "flatten", "opt", "check -assert", f"write_json {q(metadata)}"])
            module = json.loads(metadata.read_text())["modules"][top]
            cell_types = {cell["type"] for cell in module["cells"].values()}
            forbidden = sorted(t for t in cell_types if re.search(r"dff|latch|mem|ff$|anyseq|anyconst", t, re.I))
            if forbidden:
                raise RuntimeError(f"Combinational evaluator rejects state or nondeterminism: {forbidden}")
            schema = {name: (port["direction"], len(port["bits"])) for name, port in module["ports"].items()}
            if any(direction not in ("input", "output") for direction, width in schema.values()):
                raise RuntimeError("Inout ports are unsupported")
            schemas.append(schema)
        if schemas[0] != schemas[1]:
            raise RuntimeError("Candidate and reference native port schemas differ")
        schema = schemas[0]
        declarations, gold_ports, cand_ports, differences = [], [], [], []
        for index, (name, (direction, width)) in enumerate(schema.items()):
            bits = f"[{width-1}:0] "
            if direction == "input":
                declarations.append(f"input {bits}in_{index};")
                gold_ports.append(f".{identifier(name)}(in_{index})")
                cand_ports.append(f".{identifier(name)}(in_{index})")
            else:
                declarations.append(f"wire {bits}gold_{index}, cand_{index};")
                gold_ports.append(f".{identifier(name)}(gold_{index})")
                cand_ports.append(f".{identifier(name)}(cand_{index})")
                differences.append(f"(gold_{index} != cand_{index})")
        if not differences:
            raise RuntimeError("No output ports")
        inputs = [f"in_{i}" for i, (_, (direction, _)) in enumerate(schema.items()) if direction == "input"]
        miter = out / "miter.v"
        miter.write_text("\n".join(["module pw_miter(" + ", ".join(inputs + ["mismatch"]) + ");",
            *declarations, "output mismatch;", "pw_gold gold(" + ", ".join(gold_ports) + ");",
            "pw_cand cand(" + ", ".join(cand_ports) + ");",
            "assign mismatch = " + " | ".join(differences) + ";", "endmodule", ""]), encoding="utf-8")
        result["stage"] = "formal"
        formal = run_yosys("formal", [
            f"read_verilog -formal -sv {q(reference)}", *parameter_commands(reference_top), f"hierarchy -check -top {reference_top}",
            "flatten", f"rename {reference_top} pw_gold", "design -stash pw_gold_design",
            f"read_verilog -formal -sv {q(candidate)}", *parameter_commands(args.top), f"hierarchy -check -top {args.top}",
            "flatten", f"rename {args.top} pw_cand", "design -stash pw_cand_design", "design -reset",
            "design -copy-from pw_gold_design pw_gold", "design -copy-from pw_cand_design pw_cand",
            f"read_verilog -formal -sv {q(miter)}", "prep -top pw_miter -flatten",
            f"sat -verify -prove mismatch 0 -show-inputs -timeout {args.timeout}"])
        if "SAT proof finished - no model found: SUCCESS!" not in formal:
            raise RuntimeError("SAT command did not report a complete proof")
        result["formal"] = "PASS"
        result["stage"] = "mapping"
        abc = out / "abc.script"
        abc_text = "strash\ndretime\nmap\n"
        abc_constraints = ""
        if args.mapping_policy == "buffer_size":
            constraints = out / "abc.constr"
            constraints.write_text("set_driving_cell sky130_fd_sc_hd__buf_2\nset_load 10.0\n", encoding="ascii")
            abc_constraints = f" -constr {q(constraints)}"
            if args.cleanup_before_buffer:
                abc_text += "cleanup -i -o\n"
            abc_text += "buffer\nupsize\ndnsize\nstime -p\n"
        abc.write_text(abc_text, encoding="ascii")
        mapped, mapped_json = out / "mapped.v", out / "mapped.json"
        mapping = run_yosys("mapping", [f"read_liberty -lib {q(lib)}", f"read_verilog -sv {q(candidate)}",
            *parameter_commands(args.top), f"hierarchy -check -top {args.top}", "flatten", "delete t:$scopeinfo", f"synth -top {args.top} -noabc",
            f"abc -script {q(abc)} -liberty {q(lib)}{abc_constraints} -dont_use sky130_fd_sc_hd__lpflow_*",
            "clean", "check -assert", f"stat -liberty {q(lib)}", f"write_json {q(mapped_json)}",
            f"write_verilog -noattr {q(mapped)}"])
        netlist = json.loads(mapped_json.read_text())["modules"][args.top]
        invalid = sorted({c["type"] for c in netlist["cells"].values() if not c["type"].startswith("sky130_fd_sc_hd__")})
        if invalid:
            raise RuntimeError(f"Unmapped cells prohibit STA/PPA claims: {invalid}")
        if args.mapping_policy == "buffer_size":
            result["stage"] = "mapped_formal"
            mapped_proof = run_yosys("mapped_formal", [
                f"read_verilog -formal -sv {q(reference)}", *parameter_commands(reference_top), f"hierarchy -check -top {reference_top}",
                "flatten", f"rename {reference_top} pw_gold", "design -stash pw_gold_design",
                f"read_liberty -ignore_miss_func -ignore_miss_dir {q(lib)}",
                f"read_verilog -formal -sv {q(mapped)}", f"hierarchy -check -top {args.top}",
                "flatten", "delete t:$scopeinfo", f"rename {args.top} pw_cand",
                "design -stash pw_cand_design", "design -reset",
                "design -copy-from pw_gold_design pw_gold", "design -copy-from pw_cand_design pw_cand",
                f"read_verilog -formal -sv {q(miter)}", "prep -top pw_miter -flatten",
                f"sat -verify -prove mismatch 0 -show-inputs -timeout {args.timeout}"])
            if "SAT proof finished - no model found: SUCCESS!" not in mapped_proof:
                raise RuntimeError("Mapped netlist proof incomplete")
            result["mapped_formal"] = "PASS"
        areas = re.findall(r"Chip area for (?:top )?module .*?:\s*([\d.]+)", mapping)
        if not areas:
            raise RuntimeError("No mapped area reported")
        raw = mapped.read_text(encoding="utf-8")
        compatible, count = re.subn(r"(?m)^(\s*(?:wire|input|output|inout))\s+signed\b", r"\1", raw)
        sta_netlist = out / "mapped_sta.v"
        sta_netlist.write_text(compatible, encoding="utf-8")
        sdc = out / "timing.sdc"
        sdc.write_text("\n".join(["create_clock -name virtual_clk -period 100.0",
            "set_input_delay -max 0.0 -clock virtual_clk [all_inputs]",
            "set_output_delay -max 0.0 -clock virtual_clk [all_outputs]",
            "set_input_transition 0.10 [all_inputs]", "set_load 0.010 [all_outputs]", ""]), encoding="ascii")
        def wsl(path: Path) -> str:
            text = path.resolve().as_posix()
            return "/mnt/" + text[0].lower() + text[2:]
        tcl = out / "run_sta.tcl"
        tcl.write_text("\n".join([f"read_liberty {{{wsl(lib)}}}", f"read_verilog {{{wsl(sta_netlist)}}}",
            f"link_design {args.top}", f"read_sdc {{{wsl(sdc)}}}",
            "report_checks -path_delay max -format full_clock_expanded -group_path_count 10",
            "report_worst_slack -max", "report_tns -max",
            "puts {PW_ELECTRICAL_BEGIN}",
            "report_check_types -max_slew -max_capacitance -violators -digits 6",
            "puts {PW_ELECTRICAL_END}", ""]), encoding="utf-8")
        result["stage"] = "sta"
        sta = execute(["wsl.exe", "-d", "Ubuntu", "--", os.environ.get("OPENSTA", "/home/easton1/OpenSTA/build/sta"),
                       "-no_splash", "-exit", wsl(tcl)], root, out / "sta.log", env, args.timeout)
        if re.search(r"(?m)^\s*(?:Error:|ERROR:)", sta):
            raise RuntimeError("OpenSTA reported errors; see sta.log")
        def number(pattern: str) -> float:
            match = re.search(pattern, sta)
            if not match or not math.isfinite(float(match.group(1))):
                raise RuntimeError("Missing or nonfinite STA metric")
            return float(match.group(1))
        result.update(status="PASS", ppa="PASS", mapped_area_um2=float(areas[-1]), mapped_cells=len(netlist["cells"]),
            max_data_arrival_ns=number(r"([-+\d.]+)\s+data arrival time"),
            wns_ns=number(r"worst slack max\s+([-+\d.]+)"), tns_ns=number(r"tns max\s+([-+\d.]+)"),
            critical_startpoint=re.search(r"Startpoint:\s*(.+)", sta).group(1),
            critical_endpoint=re.search(r"Endpoint:\s*(.+)", sta).group(1),
            normalized_signed_declarations=count, mapped_sha256=digest(mapped), sta_netlist_sha256=digest(sta_netlist),
            sdc_sha256=digest(sdc), mapped_json_sha256=digest(mapped_json))
        result["stage"] = "electrical_checks"
        electrical = parse_electrical_report(sta)
        save(out / "electrical.json", electrical)
        result["electrical"] = electrical
        result["eligible"] = electrical["status"] == "PASS"
        source_cells = sum(bool(cell.get("attributes", {}).get("src")) for cell in netlist["cells"].values())
        source_nets = sum(bool(net.get("attributes", {}).get("src")) for net in netlist["netnames"].values())
        result["source_provenance"] = {"cells_with_src_attribute": source_cells,
            "total_mapped_cells": len(netlist["cells"]), "nets_with_src_attribute": source_nets,
            "cell_to_rtl_line_mapping": "not established; src coverage alone is not a verified mapping"}
        # Relate the measured top-level STA endpoints to source-attributed RTLIL operator cells.
        # This is deliberately separate from the ABC cell path and must not be called an exact gate mapping.
        try:
            schema_data = json.loads((out / "candidate_schema.json").read_text(encoding="utf-8"))
            cone = trace_rtl_cone(schema_data["modules"][args.top], args.top,
                                  result["critical_startpoint"], result["critical_endpoint"])
            cone_path = out / "rtl_source_cone.json"
            save(cone_path, cone)
            result["rtl_source_cone"] = {
                "status": cone.get("status"), "artifact": cone_path.name,
                "sha256": digest(cone_path),
                "possible_rtl_operator_cells": cone.get("rtl_operator_cells_on_possible_cone_paths"),
                "source_attribution_coverage": cone.get("source_attribution_coverage"),
                "precision": cone.get("precision", cone.get("meaning")),
            }
        except Exception as trace_exc:
            result["rtl_source_cone"] = {"status": "TRACE_ERROR", "reason": f"{type(trace_exc).__name__}: {trace_exc}"}
        if not result["eligible"]:
            result.update(status="NOT_ELIGIBLE_ELECTRICAL_VIOLATIONS",
                          failure_reason="Electrical violations: measured PPA is not an eligible optimization result")
    except Exception as exc:
        result.update(status="FAILED", failure_reason=f"{type(exc).__name__}: {exc}")
        if result.get("stage") == "formal":
            proof_log = out / "formal.log"
            proof_text = proof_log.read_text(encoding="utf-8", errors="replace") if proof_log.exists() else ""
            if "proof did fail" in proof_text or "model found: FAIL!" in proof_text:
                result["formal"] = "FAIL"
            elif "TIMEOUT" in proof_text or "timeout" in str(exc).lower():
                result["formal"] = "TIMEOUT"
            else:
                result["formal"] = "ERROR"
    result["elapsed_seconds"] = round(time.monotonic() - started, 3)
    save(out / "result.json", result)
    print(json.dumps(result, indent=2, ensure_ascii=False), flush=True)
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
