"""Frozen timing-feedback ablation on an explicitly defined native combinational benchmark."""
from __future__ import annotations

import argparse
from collections import Counter
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import random
import shutil
import subprocess
import sys
import time

from run_native_mul_three_arm import ROOT, BASE, TOP, EVALUATOR, run_eval
from synthesis_context import build_context, verify_context_artifacts
sys.path.insert(0, str(ROOT))
from agents.rtl_optimizer import api_configured, generate_from_prompt, LLMGenerationError, request_parameters_for_model, http_transport

ARMS = ("no_timing_feedback", "metrics_only", "path_and_rtl_chain", "path_and_synthesis_context", "actual_paths")
PROFILES = {
    "priority256": {"rtl": "benchmark/engineering_sources_20261030/verilog-axis/rtl/priority_encoder.v",
                    "top": "priority_encoder", "description": "256-input combinational priority encoder with valid, encoded and one-hot outputs",
                    "parameters": {"WIDTH": 256, "LSB_HIGH_PRIORITY": 0},
                    "contract": "Evaluate WIDTH=256 and LSB_HIGH_PRIORITY=0, retaining original parameter names and defaults. All 256 input bits are arbitrary binary values. For nonzero input select the highest set index. Preserve EVERY output bit even when output_valid=0: all-zero input must produce valid=0, encoded=0 and output_unencoded=1, exactly as the original. Invalid outputs are NOT don't-cares. No new assumptions, state or masked invalid outputs. Proof covers only this fixed parameter instance.",
                    "prior_exposure": "Fixed historical MIT-licensed verilog-axis source. Priority-encoding family was an evaluation candidate before this study and only baseline qualification has been performed. No model candidates have been generated for this family in recorded project experiments. Public code may be in model training; this is not a blind or statistical test."},
    "mul8": {"rtl": "benchmark/rtl_opt_upstream_hkust/benchmark/mul_subexpression/mul_subexpression.v",
             "top": "mul_subexpression", "description": "unsigned combinational 8x8 multiplier",
             "contract": "Every pair of 8-bit unsigned operands must produce the exact full 16-bit unsigned product.",
             "prior_exposure": "One repeatedly studied small multiplier; not held-out evaluation."},
    "alu64": {"rtl": "benchmark/rtl_opt_upstream_hkust/benchmark/alu_64bit/alu_64bit.v",
              "top": "alu_64bit", "description": "64-bit ALU with a 3-bit operation select",
              "contract": "For every 64-bit a/b and all eight Oper values, preserve the original sum output exactly: add, a-b, b-a, bitwise OR/AND/XOR/XNOR, and zero for the default operation; arithmetic output wraps modulo 2^64. Internal carry is not an output port.",
              "prior_exposure": "Baseline and public-reference preflight completed before generation; public reference RTL is not supplied to any prompt. This is a public benchmark, not held-out evaluation."},
    "addr_calcu": {"rtl": "benchmark/rtl_opt_upstream_hkust/benchmark/addr_calcu/addr_calcu.v",
                   "top": "addr_calcu", "description": "8-bit address/pointer arithmetic with a control-selected 16-bit output",
                   "contract": "Optimize the default base=8'h80 parameter instance, keeping the parameter declaration/default. All 33 ordinary input bits remain unconstrained. control=1 selects ptr1, otherwise ptr2; offset=(base-selected_pointer) modulo 256, then count=(zero_extended_address-zero_extended_offset+zero_extended_b) modulo 65536. The 8-bit intermediate truncation is mandatory; do not replace it with an untruncated integer expression. Only the default parameter instance is formally assessed. The source comment about late control is not a timing constraint: the actual SDC uses equal zero external delays on every input, including control.",
                   "prior_exposure": "Second-design qualification was performed before any generation on this design. This public benchmark and its reference were previously inspected; it is not held out. Public reference RTL is not supplied to prompts."},
}
N = 3
LIB = ROOT / "eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
DEPS = [Path(__file__).resolve(), EVALUATOR, EVALUATOR.with_name("trace_sta_rtl_cone.py"),
        EVALUATOR.with_name("run_native_mul_three_arm.py"), ROOT / "agents/rtl_optimizer.py",
        EVALUATOR.with_name("synthesis_context.py")]


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(path: Path, value: dict, exclusive: bool = False) -> None:
    with path.open("x" if exclusive else "w", encoding="utf-8") as f:
        json.dump(value, f, ensure_ascii=False, indent=2, allow_nan=False)
        f.write("\n")


def compact_cone(cone: dict) -> dict:
    def short_source(src: str | None) -> str | None:
        return src.replace(ROOT.as_posix() + "/", "") if src else None
    return {
        "status": cone["status"],
        "scope": "Conservative pre-ABC RTL operator cone for the measured top-level endpoints; not an exact standard-cell-to-RTL mapping.",
        "source_coverage_scope": cone.get("coverage_scope"),
        "start": cone.get("sta_startpoint"), "end": cone.get("sta_endpoint"),
        "operator_counts_in_possible_cone": dict(Counter(x["type"] for x in cone.get("candidate_cells", []))),
        "unsupported_cell_types": cone.get("unsupported_cell_types", {}),
        "chain_warning": cone.get("chain_warning"),
        "one_shortest_structural_chain": [{
            "operator": x["type"], "from_signal_aliases": x.get("from_net_aliases", []),
            "to_signal_aliases": x.get("to_net_aliases", []), "source": short_source(x.get("src")),
        } for x in cone.get("shortest_structural_dependency_path", [])],
    }


def prompts_for(study: Path, baseline: dict, profile: dict, synthesis_context: dict | None = None) -> dict[str, str]:
    eda = study / "baseline/evaluation/eda"
    rtl = (ROOT / profile["rtl"]).read_text(encoding="utf-8")
    mapping = json.loads((eda / "protocol.json").read_text(encoding="utf-8"))["mapping"]
    common = f"""Optimize this native combinational circuit ({profile['description']}) for shorter mapped-cell maximum data arrival while respecting the mapped-area cap. Preserve its exact module name, input/output ports, widths, and behavior for every input value. No clocks, state, input restrictions, assumptions, or don't-cares may be introduced.
Functional contract: {profile['contract']}
Fixed top parameter overrides applied identically to reference and candidate: {json.dumps(profile.get('parameters', {}), sort_keys=True)}.

All conditions use Yosys plus OpenSTA, SKY130HD TT 25C 1.80V, no physical wire parasitics, input transition 0.10 ns, output load 0.010 pF, and zero external I/O delays. Fixed mapping policy: {mapping}. Baseline area is {baseline['mapped_area_um2']} um^2; the area cap is {baseline['mapped_area_um2'] * 1.10:.6f} um^2. A 100 ns virtual clock is a reporting reference only; optimize maximum data arrival rather than the virtual-clock slack. Every candidate must pass full functional equivalence and max-slew/max-capacitance checks with zero violations under the fixed library and constraints. These area, eligibility and tool conditions are supplied identically in every arm.

Yosys can restructure arithmetic. Source-level adder counts do not establish serial adder counts in the final mapped netlist. Propose one candidate and state what available evidence supports the suspected bottleneck. Timing estimates are hypotheses to be checked by EDA, not measurements.

Return one JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, and functional_boundaries. candidate_rtl must be synthesizable Verilog; helper modules are allowed.

Original RTL:
{rtl}
"""
    metrics = json.dumps({k: baseline[k] for k in ("max_data_arrival_ns", "wns_ns", "tns_ns")}, indent=2)
    with_metrics = common + "\nMeasured baseline timing metrics (ns):\n" + metrics + "\n"
    report = (eda / "sta.log").read_text(encoding="utf-8")
    sections = ["Startpoint:" + chunk for chunk in report.split("Startpoint:")[1:]]
    if len(sections) < 3:
        raise RuntimeError("Expected at least three actual STA path reports")
    selected = "".join(sections[:3])
    cone = compact_cone(json.loads((eda / "rtl_source_cone.json").read_text(encoding="utf-8")))
    write(study / "baseline/compact_rtl_chain.json", cone)
    (study / "baseline/top3_sta_paths.txt").write_text(selected, encoding="utf-8")
    prompts = {
        ARMS[0]: common,
        ARMS[1]: with_metrics,
        ARMS[2]: with_metrics + "\nThree actual mapped baseline STA paths, ordered by the report:\n" + selected
            + "\nSource-localization evidence with explicit precision limits:\n" + json.dumps(cone, ensure_ascii=False, indent=2) + "\n",
    }
    prompts[ARMS[4]] = with_metrics + "\nThree actual mapped baseline STA paths, ordered by the report:\n" + selected + "\nThese are actual standard-cell paths; no exact mapping to RTL source lines is claimed.\n"
    if synthesis_context is not None:
        prompts[ARMS[3]] = prompts[ARMS[2]] + "\nAdditional verified baseline post-synthesis structure evidence:\n" + json.dumps(synthesis_context, ensure_ascii=False, indent=2) + "\n"
    return prompts


def validate(study: Path, protocol: dict) -> None:
    if protocol.get("synthesis_context"):
        verify_context_artifacts(study, protocol["synthesis_context"])
    for rel, expected in protocol["dependency_sha256"].items():
        if sha(ROOT / rel) != expected:
            raise RuntimeError(f"Frozen dependency changed: {rel}")
    for path, expected in ((ROOT / protocol["baseline_rtl"], protocol["baseline_sha256"]), (LIB, protocol["liberty_sha256"])):
        if sha(path) != expected:
            raise RuntimeError(f"Frozen design/library changed: {path.name}")
    for arm, expected in protocol["prompt_sha256"].items():
        if sha(study / "prompts" / f"{arm}.txt") != expected:
            raise RuntimeError(f"Frozen prompt changed: {arm}")


def prepare(model: str, timeout: int, llm_timeout: int, profile_name: str, arms: list[str], mapping_policy: str = "legacy", cleanup_before_buffer: bool = False) -> Path:
    if cleanup_before_buffer and mapping_policy != "buffer_size":
        raise ValueError("Buffer cleanup requires buffer_size mapping")
    if ARMS[3] in arms and profile_name != "addr_calcu":
        raise ValueError("Verified post-synthesis feedback currently supports addr_calcu only")
    profile = PROFILES[profile_name]
    base, top = ROOT / profile["rtl"], profile["top"]
    study = ROOT / "eda/experiments" / datetime.now().strftime(f"timing_feedback_ablation_{profile_name}_%Y%m%d_%H%M%S_%f")
    study.mkdir(parents=True)
    (study / "baseline").mkdir()
    shutil.copy2(base, study / "baseline/original.v")
    code, _, _ = run_eval(base, study / "baseline/evaluation", timeout, reference=base, top=top, mapping_policy=mapping_policy, cleanup_before_buffer=cleanup_before_buffer, parameters=profile.get('parameters'))
    ep = study / "baseline/evaluation/eda/result.json"
    if code or not ep.exists():
        raise RuntimeError(f"Baseline evaluation failed; no API calls made. See {study}")
    baseline = json.loads(ep.read_text(encoding="utf-8"))
    if baseline.get("formal") != "PASS" or baseline.get("ppa") != "PASS":
        raise RuntimeError("Baseline did not complete proof and STA")
    cone = json.loads((ep.parent / "rtl_source_cone.json").read_text(encoding="utf-8"))
    if any(a in arms for a in (ARMS[2], ARMS[3])) and (cone.get("status") != "CONSERVATIVE_RTL_OPERATOR_CONE_FOUND" or cone.get("unsupported_cell_types")):
        raise RuntimeError("This ablation requires a supported baseline RTL dependency cone")
    context, context_record = (build_context(study, profile, baseline, timeout) if ARMS[3] in arms else (None, None))
    prompts = {a: p for a, p in prompts_for(study, baseline, profile, context).items() if a in arms}
    if set(prompts) != set(arms):
        raise RuntimeError("Missing requested feedback condition; no API calls made")
    (study / "prompts").mkdir()
    for arm, prompt in prompts.items():
        (study / "prompts" / f"{arm}.txt").write_text(prompt, encoding="utf-8")
    order = list(arms)
    random.Random(20261029).shuffle(order)
    schedule = [{"call_index": i * len(order) + j + 1, "arm": arm,
                 "candidate_id": f"candidate_{i+1:02d}"}
                for i in range(N) for j, arm in enumerate(order[i % len(order):] + order[:i % len(order)])]
    (study / "code_snapshot").mkdir()
    for dep in DEPS:
        shutil.copy2(dep, study / "code_snapshot" / dep.name)
    tool_protocol = json.loads((ep.parent / "protocol.json").read_text(encoding="utf-8"))
    transport = http_transport()
    transport_binary = shutil.which("curl.exe" if os.name == "nt" else "curl") if transport == "curl" else None
    if transport == "curl" and not transport_binary:
        raise RuntimeError("curl transport selected but executable not found; no API calls made")
    transport_version = subprocess.check_output([transport_binary, "-q", "--version"], timeout=20).decode("utf-8", errors="replace").splitlines()[0] if transport_binary else None
    protocol = {
        "study": "Timing feedback ablation: no timing / metrics only / actual paths plus conservative named RTL chain",
        "created_at": datetime.now().astimezone().isoformat(), "model": model,
        "request_parameters": request_parameters_for_model(model, 0.2),
        "temperature": request_parameters_for_model(model, 0.2).get("temperature"),
        "mapping_policy": mapping_policy,
        "abc_cleanup_before_buffer": cleanup_before_buffer,
        "http_transport": transport,
        "http_transport_binary_sha256": sha(Path(transport_binary)) if transport_binary else None,
        "http_transport_version": transport_version,
        "profile": profile_name, "top": top, "arms": arms,
        "parameter_overrides": profile.get("parameters", {}),
        "baseline_retained_if_no_improvement": True,
        "synthesis_context": context_record,
        "synthesis_context_hypothesis": "Exploratory test after observing prior results: additional verified post-synthesis structure may reduce suggestions duplicating already-performed transformations. No predicted winner and no candidate solutions supplied." if context_record else None,
        "api_endpoint": os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/"),
        "baseline_rtl": str(base.relative_to(ROOT)), "baseline_sha256": sha(base),
        "liberty_sha256": sha(LIB), "baseline_metrics": baseline,
        "tool_conditions": tool_protocol, "candidates_per_arm": N, "call_schedule": schedule,
        "call_policy": "Independent calls in frozen rotating interleaved order; no retries and no prior candidate/EDA outcomes fed back during generation. Exact schedule is preserved; with two arms/three candidates, first-position counts are not perfectly balanced.",
        "budget_policy": "Equal candidate slots and same model/actual request parameters/per-call timeout; prompt token counts differ by condition and provider usage is preserved.",
        "timeout_per_tool_seconds": timeout, "llm_timeout_seconds": llm_timeout,
        "acceptance": {"formal": "full all-input combinational SAT proof", "area_cap_ratio": 1.10,
                       "electrical": "complete max_slew/max_capacitance checks with zero violation rows",
                       "mapped_netlist_proof": "required in buffer_size mode",
                       "valid_timing_improvement": "formal PASS and PPA PASS with electrical PASS (and mapped proof in buffer_size mode), area within cap, max arrival strictly lower than baseline",
                       "meaningful_gain_secondary": "same eligibility and at least 5% lower max arrival; preregistered secondary count"},
        "scope": f"Exploratory feedback comparison on {profile['description']}. {profile['prior_exposure']} Three candidates per condition; pre-layout only; no claim of general superiority.",
        "dependency_sha256": {str(p.relative_to(ROOT)): sha(p) for p in DEPS},
        "prompt_sha256": {arm: sha(study / "prompts" / f"{arm}.txt") for arm in prompts},
        "baseline_sta_sha256": sha(ep.parent / "sta.log"),
        "baseline_chain_sha256": sha(study / "baseline/compact_rtl_chain.json"),
    }
    write(study / "protocol.json", protocol, exclusive=True)
    (study / "protocol.sha256").write_text(sha(study / "protocol.json") + "  protocol.json\n", encoding="ascii")
    print(f"Prepared: {study}", flush=True)
    print(f"Protocol SHA-256: {sha(study / 'protocol.json')}", flush=True)
    return study


def execute(study: Path) -> None:
    protocol = json.loads((study / "protocol.json").read_text(encoding="utf-8"))
    validate(study, protocol)
    if protocol.get("http_transport", "urllib") != http_transport():
        raise RuntimeError("HTTP transport changed since protocol freeze")
    if protocol.get("http_transport_binary_sha256"):
        executable = shutil.which("curl.exe" if os.name == "nt" else "curl")
        if not executable or sha(Path(executable)) != protocol["http_transport_binary_sha256"]:
            raise RuntimeError("HTTP transport executable changed since protocol freeze")
    if not api_configured():
        raise RuntimeError("API key not configured; frozen experiment remains prepared")
    if protocol["api_endpoint"] != os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/"):
        raise RuntimeError("API endpoint changed since protocol freeze")
    rows = []
    for item in protocol["call_schedule"]:
        folder = study / item["arm"] / item["candidate_id"]
        folder.mkdir(parents=True, exist_ok=True)
        generation = folder / "generation.json"
        if generation.exists():
            rows.append(json.loads(generation.read_text(encoding="utf-8")))
            continue
        if (folder / "attempt.json").exists():
            raise RuntimeError(f"Uncertain prior request, refusing to duplicate automatically: {folder}")
        validate(study, protocol)
        prompt_path = study / "prompts" / f"{item['arm']}.txt"
        shutil.copy2(prompt_path, folder / "prompt.txt")
        write(folder / "attempt.json", {**item, "started_at": datetime.now().astimezone().isoformat()}, exclusive=True)
        row = {**item, "prompt_sha256": sha(prompt_path), "candidate_sha256": None}
        started = time.monotonic()
        print(f"Calling {item['call_index']}/{len(protocol['call_schedule'])}: {item['arm']}/{item['candidate_id']}", flush=True)
        try:
            gen = generate_from_prompt(prompt_path.read_text(encoding="utf-8"), model=protocol["model"],
                                       temperature=protocol["temperature"], candidate_index=item["call_index"],
                                       timeout_s=protocol["llm_timeout_seconds"], audit_dir=folder / "api_audit")
            (folder / "candidate.v").write_text(gen.rtl, encoding="utf-8")
            row.update(status="GENERATED", candidate_sha256=sha(folder / "candidate.v"),
                       response_model_id=gen.model, generation_parameters=gen.generation_parameters,
                       explanation=gen.explanation)
        except LLMGenerationError as exc:
            row.update(status="FAILED_GENERATION", error=str(exc))
        row["generation_seconds"] = round(time.monotonic() - started, 3)
        for filename in ("request.json", "response.json"):
            p = folder / "api_audit" / filename
            if p.exists():
                row[filename + "_sha256"] = sha(p)
        write(generation, row, exclusive=True)
        rows.append(row)
        print(f"Returned: {row['status']} ({row['generation_seconds']} s)", flush=True)
    manifest = study / "candidate_manifest.json"
    if not manifest.exists():
        write(manifest, {"protocol_sha256": sha(study / "protocol.json"), "slots": rows}, exclusive=True)
        (study / "candidate_manifest.sha256").write_text(sha(manifest) + "  candidate_manifest.json\n", encoding="ascii")
    results = []
    base = protocol["baseline_metrics"]
    for row in rows:
        validate(study, protocol)
        folder = study / row["arm"] / row["candidate_id"]
        result_path = folder / "result.json"
        if result_path.exists():
            results.append(json.loads(result_path.read_text(encoding="utf-8")))
            continue
        result = {**row, "formal": "NOT_RUN", "ppa": "NOT_RUN", "eligible": False,
                  "valid_improvement": False, "meaningful_gain": False}
        if row["candidate_sha256"] is not None:
            if sha(folder / "candidate.v") != row["candidate_sha256"]:
                raise RuntimeError("Frozen candidate content changed")
            code, _, elapsed = run_eval(folder / "candidate.v", folder / "evaluation", protocol["timeout_per_tool_seconds"],
                                        reference=ROOT / protocol["baseline_rtl"], top=protocol["top"],
                                        mapping_policy=protocol.get("mapping_policy", "legacy"),
                                        cleanup_before_buffer=protocol.get("abc_cleanup_before_buffer", False),
                                        parameters=protocol.get("parameter_overrides", {}))
            result["evaluation_seconds"] = elapsed
            ep = folder / "evaluation/eda/result.json"
            if ep.exists():
                metrics = json.loads(ep.read_text(encoding="utf-8"))
                result.update(formal=metrics.get("formal", "ERROR"), ppa=metrics.get("ppa", "NOT_RUN"), metrics=metrics)
                if code == 0 and result["formal"] == result["ppa"] == "PASS":
                    result["eligible"] = metrics["mapped_area_um2"] <= base["mapped_area_um2"] * 1.10 + 1e-9
                    result["delay_gain_percent"] = 100 * (base["max_data_arrival_ns"] - metrics["max_data_arrival_ns"]) / base["max_data_arrival_ns"]
                    result["valid_improvement"] = result["eligible"] and result["delay_gain_percent"] > 0
                    result["meaningful_gain"] = result["eligible"] and result["delay_gain_percent"] >= 5
            else:
                result.update(formal="ERROR", ppa="NOT_RUN", error="Evaluator did not leave result.json")
        write(result_path, result, exclusive=True)
        results.append(result)
        print(f"Evaluated {row['arm']}/{row['candidate_id']}: formal={result['formal']}, ppa={result['ppa']}", flush=True)
    groups = {}
    for arm in protocol["arms"]:
        rr = [r for r in results if r["arm"] == arm]
        eligible = [r for r in rr if r["eligible"]]
        total_tokens = 0
        for row in rr:
            ap = study / arm / row["candidate_id"] / "api_audit/response.json"
            if ap.exists():
                total_tokens += json.loads(ap.read_text(encoding="utf-8")).get("usage", {}).get("total_tokens", 0)
        groups[arm] = {"scheduled": N, "generated": sum(bool(r["candidate_sha256"]) for r in rr),
                       "formal_pass": sum(r["formal"] == "PASS" for r in rr),
                       "ppa_complete": sum(r["ppa"] == "PASS" for r in rr), "area_eligible": len(eligible),
                       "valid_improvements": sum(r["valid_improvement"] for r in rr),
                       "meaningful_gains_at_least_5pct": sum(r["meaningful_gain"] for r in rr),
                       "best_eligible_delay_ns": min((r["metrics"]["max_data_arrival_ns"] for r in eligible), default=None),
                       "selected_delay_with_baseline_ns": min([base["max_data_arrival_ns"]] + [r["metrics"]["max_data_arrival_ns"] for r in eligible]),
                       "reported_total_tokens": total_tokens,
                       "generation_seconds": round(sum(r["generation_seconds"] for r in rr), 3),
                       "unique_rtl_hashes": len({r["candidate_sha256"] for r in rr if r["candidate_sha256"]}),
                       "unique_measured_ppa_profiles": len({(r["metrics"]["max_data_arrival_ns"], r["metrics"]["mapped_area_um2"], r["metrics"]["mapped_cells"]) for r in rr if r["ppa"] == "PASS"})}
    summary = {"protocol_sha256": sha(study / "protocol.json"), "manifest_sha256": sha(manifest),
               "baseline": base, "groups": groups, "total_reported_tokens": sum(g["reported_total_tokens"] for g in groups.values()),
               "scope": protocol["scope"], "inference_limit": "Independent stochastic calls, three slots per condition; counts are exploratory and no statistical significance or causal mechanism claim is made."}
    write(study / "summary.json", summary)
    lines = ["# Timing feedback ablation", "", f"Protocol: `{summary['protocol_sha256']}`", "",
             f"Baseline max data arrival: {base['max_data_arrival_ns']} ns; mapped area: {base['mapped_area_um2']} um².", "",
             "| Feedback | Generated | Formal | PPA | Valid gains | Gains >=5% | Best eligible delay | Tokens |",
             "|---|---:|---:|---:|---:|---:|---:|---:|"]
    for arm, g in groups.items():
        lines.append(f"| {arm} | {g['generated']}/3 | {g['formal_pass']}/3 | {g['ppa_complete']}/3 | {g['valid_improvements']}/3 | {g['meaningful_gains_at_least_5pct']}/3 | {g['best_eligible_delay_ns']} ns | {g['reported_total_tokens']} |")
    lines += ["", summary["scope"], "", summary["inference_limit"], "",
              "All scheduled failures are retained in denominators. Candidate content was frozen before candidate PPA evaluation. API request bodies and visible responses are preserved with credentials omitted.", ""]
    (study / "SUMMARY.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"Completed: {study}", flush=True)
    print(json.dumps(groups, indent=2), flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--execute", type=Path, help="execute a previously prepared, hash-frozen study")
    parser.add_argument("--model", default=os.environ.get("PIPEWEAVER_LLM_MODEL"))
    parser.add_argument("--profile", choices=PROFILES, default="mul8")
    parser.add_argument("--arms", nargs="+", choices=ARMS, default=list(ARMS[:3]))
    parser.add_argument("--timeout", type=int, default=180)
    parser.add_argument("--llm-timeout", type=int, default=300)
    parser.add_argument("--mapping-policy", choices=("legacy", "buffer_size"), default="legacy")
    parser.add_argument("--cleanup-before-buffer", action="store_true")
    args = parser.parse_args()
    if args.execute:
        execute(args.execute.resolve())
    else:
        if not args.model:
            parser.error("A precise requested model identifier is required")
        if len(set(args.arms)) != len(args.arms) or len(args.arms) < 2:
            parser.error("Choose at least two distinct feedback arms")
        prepare(args.model, args.timeout, args.llm_timeout, args.profile, args.arms, args.mapping_policy, args.cleanup_before_buffer)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
