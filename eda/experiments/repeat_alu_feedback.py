"""Exact-prompt independent ALU repetition; stops before API if prompts differ."""
import json
from pathlib import Path
from run_feedback_ablation import prepare, execute, ROOT

old = ROOT / "eda/experiments/timing_feedback_ablation_alu64_20261030_184826_215175"
original = json.loads((old/"protocol.json").read_text(encoding="utf-8"))
study = prepare("gpt-6.1-sol",180,300,"alu64",
                ["no_timing_feedback","path_and_rtl_chain"],"buffer_size")
new = json.loads((study/"protocol.json").read_text(encoding="utf-8"))
assert new["prompt_sha256"] == original["prompt_sha256"], "Prompts changed; no API requests made"
assert new["request_parameters"] == original["request_parameters"]
assert new["api_endpoint"] == original["api_endpoint"]
assert new["call_schedule"] == original["call_schedule"]
for key in ("baseline_sha256","liberty_sha256","mapping_policy","acceptance"):
    assert new[key] == original[key]
(study/"REPETITION_PLAN.json").write_text(json.dumps({
    "purpose":"Exact-prompt independent repetition; not selective retries",
    "original_study":str(old.relative_to(ROOT)),
    "same_prompt_hashes":True,"same_budget_and_call_order":True,
    "same_requested_model_and_parameters":True,
    "fresh_attempts":6,"no_retries":True,
    "retain_all_outcomes":True,
    "interpretation":"Replication was chosen after observing first-round results, not preregistered before discovery. Same public ALU; not cross-design validation.",
    "backend_caveat":"Provider model ID is a routing alias; backend identity/version not independently verified.",
},ensure_ascii=False,indent=2),encoding="utf-8")
print("Exact prompt/budget equivalence PASS; starting six new request slots",flush=True)
execute(study)

