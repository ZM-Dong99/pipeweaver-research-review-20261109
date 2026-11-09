"""Check a completed feedback study against saved API content and raw EDA outputs; no network calls."""
import argparse
import hashlib
import json
from pathlib import Path
import re


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def audit(study):
    checks, failures = [], []

    def check(value, label):
        if not value:
            raise ValueError(label)
        checks.append(label)

    protocol = load(study / "protocol.json")
    dependencies = {k.replace("\\", "/"): v for k, v in protocol["dependency_sha256"].items()}
    manifest = load(study / "candidate_manifest.json")
    summary = load(study / "summary.json")
    root = study.parents[2]
    check((study / "protocol.sha256").read_text().split()[0] == sha(study / "protocol.json"), "protocol hash")
    check((study / "candidate_manifest.sha256").read_text().split()[0] == sha(study / "candidate_manifest.json"), "manifest hash")
    check(manifest["protocol_sha256"] == summary["protocol_sha256"] == sha(study / "protocol.json"), "protocol linkage")
    check(summary["manifest_sha256"] == sha(study / "candidate_manifest.json"), "summary manifest linkage")
    for rel, expected in protocol["dependency_sha256"].items():
        check(sha(study / "code_snapshot" / Path(rel).name) == expected, f"snapshot {rel}")
    prompts = {arm: (study / "prompts" / f"{arm}.txt").read_text(encoding="utf-8") for arm in protocol["prompt_sha256"]}
    for arm, expected in protocol["prompt_sha256"].items():
        check(sha(study / "prompts" / f"{arm}.txt") == expected, f"prompt hash {arm}")
    if "metrics_only" in prompts and "no_timing_feedback" in prompts:
        check(prompts["metrics_only"].startswith(prompts["no_timing_feedback"]), "metrics arm shares exact common prompt")
    if "path_and_rtl_chain" in prompts and "metrics_only" in prompts:
        check(prompts["path_and_rtl_chain"].startswith(prompts["metrics_only"]), "path arm shares exact metrics prompt")
    elif "path_and_rtl_chain" in prompts and "no_timing_feedback" in prompts:
        check(prompts["path_and_rtl_chain"].startswith(prompts["no_timing_feedback"]), "path arm shares exact common prompt")
    if "metrics_only" in prompts:
        check("Startpoint:" not in prompts["metrics_only"], "metrics arm excludes paths")
    if "no_timing_feedback" in prompts:
        check("max_data_arrival_ns" not in prompts["no_timing_feedback"], "no-timing arm excludes measured timing")
    if "actual_paths" in prompts:
        check(prompts["actual_paths"].startswith(prompts["no_timing_feedback"]), "STA arm shares exact common prompt")
        check("Startpoint:" in prompts["actual_paths"], "STA arm includes actual paths")
        check((study / "baseline/top3_sta_paths.txt").read_text(encoding="utf-8") in prompts["actual_paths"], "STA paths match raw extracted baseline")
        check("Source-localization evidence" not in prompts["actual_paths"], "no unsupported source attribution supplied")
    if "path_and_rtl_chain" in prompts:
        check("from_signal_aliases" in prompts["path_and_rtl_chain"], "path arm includes named source chain")
    if protocol.get("synthesis_context"):
        rec = protocol["synthesis_context"]
        for rel, expected in rec["artifacts_sha256"].items():
            check(sha(study / rel) == expected, f"synthesis evidence hash {rel}")
        context = load(study / rec["path"])
        check(context["reference_rtl_sha256"] == protocol["baseline_sha256"], "synthesis context uses original reference")
        check(prompts["path_and_synthesis_context"].startswith(prompts["path_and_rtl_chain"]), "enhanced arm preserves exact path prompt")
        check(json.dumps(context, ensure_ascii=False, indent=2) in prompts["path_and_synthesis_context"], "enhanced prompt includes exact verified context")
        check("post_synthesis_operator_counts" not in prompts["no_timing_feedback"] and "post_synthesis_operator_counts" not in prompts["path_and_rtl_chain"], "extra synthesis evidence isolated from controls")
        check("SAT proof finished - no model found: SUCCESS!" in (study / "baseline/synthesis_context/intermediate_formal.log").read_text(encoding="utf-8"), "synthesis context raw full-input proof")
    by_arm = {}
    total_tokens = 0
    returned_responses = 0
    for slot in manifest["slots"]:
        arm, cid = slot["arm"], slot["candidate_id"]
        folder = study / arm / cid
        try:
            g = load(folder / "generation.json")
            r = load(folder / "result.json")
            by_arm.setdefault(arm, []).append(r)
            check(g == slot, f"{arm}/{cid}: generation frozen in manifest")
            check(sha(folder / "prompt.txt") == g["prompt_sha256"] == protocol["prompt_sha256"][arm], f"{arm}/{cid}: prompt linkage")
            req = load(folder / "api_audit/request.json")
            check(req["body"]["messages"][-1]["content"] == prompts[arm], f"{arm}/{cid}: exact API user message")
            check(req["body"]["model"] == protocol["model"], f"{arm}/{cid}: model request")
            if "http_transport" in protocol:
                check(req.get("http_transport") == protocol["http_transport"], f"{arm}/{cid}: frozen HTTP transport")
            check(req["body"].get("temperature") == protocol["temperature"], f"{arm}/{cid}: temperature")
            if "request_parameters" in protocol:
                for name in ("temperature", "reasoning_effort"):
                    check(req["body"].get(name) == protocol["request_parameters"].get(name), f"{arm}/{cid}: actual {name}")
            check(sha(folder / "api_audit/request.json") == g["request.json_sha256"], f"{arm}/{cid}: request audit hash")
            ap = folder / "api_audit/response.json"
            if ap.exists():
                response = load(ap)
                returned_responses += 1
                total_tokens += response.get("usage", {}).get("total_tokens", 0)
                check(sha(ap) == g["response.json_sha256"], f"{arm}/{cid}: response audit hash")
            if g["candidate_sha256"] is None:
                check(r["formal"] == r["ppa"] == "NOT_RUN", f"{arm}/{cid}: failed generation excluded from EDA")
                continue
            check(sha(folder / "candidate.v") == g["candidate_sha256"] == r["candidate_sha256"], f"{arm}/{cid}: RTL hash")
            visible = response["choices"][0]["message"]["content"].strip()
            if visible.startswith("<think>"):
                check("</think>" in visible, f"{arm}/{cid}: complete leading wrapper")
                visible = visible.split("</think>", 1)[1].strip()
            content = json.loads(visible)["candidate_rtl"].strip()
            if "\n" not in content and r"\n" in content:
                check('"' not in content and "\\" not in content.replace(r"\n", ""), f"{arm}/{cid}: unambiguous newline serialization")
                content = content.replace(r"\n", "\n")
            fenced = re.fullmatch(r"```(?:verilog|systemverilog|sv)?\s*\n?(.*?)\n?```", content, re.I | re.S)
            if fenced:
                content = fenced.group(1).strip()
            check(folder.joinpath("candidate.v").read_text(encoding="utf-8") == content + "\n", f"{arm}/{cid}: RTL equals provider content")
            check(g["response_model_id"] == response.get("model"), f"{arm}/{cid}: response model ID")
            ep = folder / "evaluation/eda"
            er = load(ep / "result.json")
            check(r["metrics"] == er, f"{arm}/{cid}: metrics equal evaluator output")
            eprotocol = load(ep / "protocol.json")
            check(eprotocol["candidate_sha256"] == g["candidate_sha256"], f"{arm}/{cid}: evaluator candidate hash")
            check(eprotocol["reference_sha256"] == protocol["baseline_sha256"], f"{arm}/{cid}: original RTL oracle")
            check(eprotocol["runner_sha256"] == dependencies["eda/experiments/run_native_comb.py"], f"{arm}/{cid}: same evaluator")
            if "mapping_policy" in protocol:
                check(eprotocol["mapping_policy"] == protocol["mapping_policy"], f"{arm}/{cid}: fixed mapping policy")
            if "parameter_overrides" in protocol:
                check(eprotocol.get("parameter_overrides", {}) == protocol["parameter_overrides"], f"{arm}/{cid}: fixed parameter instance")
            if "abc_cleanup_before_buffer" in protocol:
                check(eprotocol.get("abc_cleanup_before_buffer", False) == protocol["abc_cleanup_before_buffer"], f"{arm}/{cid}: fixed ABC cleanup rule")
            if r["formal"] == "PASS":
                check("SAT proof finished - no model found: SUCCESS!" in (ep / "formal.log").read_text(encoding="utf-8"), f"{arm}/{cid}: raw SAT success")
            if r["ppa"] == "PASS":
                sta = (ep / "sta.log").read_text(encoding="utf-8")
                check(not re.search(r"(?m)^\s*(?:Error:|ERROR:)", sta), f"{arm}/{cid}: STA no error markers")
                arrival = float(re.search(r"([-+\d.]+)\s+data arrival time", sta).group(1))
                check(arrival == er["max_data_arrival_ns"], f"{arm}/{cid}: delay equals raw STA")
                if "electrical" in protocol.get("acceptance", {}):
                    block = sta.split("PW_ELECTRICAL_BEGIN", 1)[1].split("PW_ELECTRICAL_END", 1)[0]
                    check(block.count("(VIOLATED)") == er["electrical"]["violation_rows"], f"{arm}/{cid}: raw electrical violations")
                    if r["eligible"]:
                        check(er["electrical"]["status"] == "PASS" and er["eligible"], f"{arm}/{cid}: electrical eligibility")
                    else:
                        check(not r["valid_improvement"], f"{arm}/{cid}: ineligible cannot count as gain")
                    if protocol.get("mapping_policy") == "buffer_size":
                        check(er.get("mapped_formal") == "PASS" and "SAT proof finished - no model found: SUCCESS!" in (ep / "mapped_formal.log").read_text(encoding="utf-8"), f"{arm}/{cid}: mapped netlist proof")
                area = float(re.findall(r"Chip area for (?:top )?module .*?:\s*([\d.]+)", (ep / "mapping.log").read_text(encoding="utf-8"))[-1])
                check(area == er["mapped_area_um2"], f"{arm}/{cid}: area equals mapping log")
                check(sha(ep / "mapped.json") == er["mapped_json_sha256"], f"{arm}/{cid}: mapped JSON hash")
                cells = load(ep / "mapped.json")["modules"][protocol["tool_conditions"]["top"]]["cells"]
                check(len(cells) == er["mapped_cells"] and all(c["type"].startswith("sky130_fd_sc_hd__") for c in cells.values()), f"{arm}/{cid}: actual standard-cell netlist")
        except Exception as exc:
            failures.append({"slot": f"{arm}/{cid}", "error": str(exc)})
    for arm, rows in by_arm.items():
        group = summary["groups"][arm]
        try:
            check(len(rows) == protocol["candidates_per_arm"] == group["scheduled"], f"{arm}: complete denominator")
            check(sum(r["valid_improvement"] for r in rows) == group["valid_improvements"], f"{arm}: success count")
            check(sum(r["meaningful_gain"] for r in rows) == group["meaningful_gains_at_least_5pct"], f"{arm}: >=5% count")
        except Exception as exc:
            failures.append({"arm": arm, "error": str(exc)})
    check(total_tokens == summary["total_reported_tokens"], "token total from API envelopes")
    report = {"status": "PASS" if not failures else "FAIL", "passed_checks": len(checks),
              "response_envelopes": returned_responses, "total_reported_tokens": total_tokens,
              "checks": checks, "failures": failures, "auditor_sha256": sha(Path(__file__)),
              "scope": "File-consistency audit against preserved provider content and raw EDA logs; not cryptographic proof of historical execution. Independent EDA reproduction remains the stronger check."}
    (study / "AUDIT.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: v for k, v in report.items() if k != "checks"}, indent=2, ensure_ascii=False))
    return 0 if not failures else 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("study", type=Path)
    args = parser.parse_args()
    raise SystemExit(audit(args.study.resolve()))
