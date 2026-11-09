# Three-arm RTL timing study

The runner is `eda/experiments/run_three_arm_study.py`. It freezes a protocol and a budget of three candidates per arm, reproduces the baseline, records prompts and candidate hashes, then sends each available candidate independently through the existing syntax, formal, SKY130 mapping, and OpenSTA flow. Every candidate is compared with `benchmark/timing_adder.v` using the same SDC, Liberty, and 1.10x baseline area limit.

## Reproduce the no-key arm

```powershell
python -B eda/experiments/run_three_arm_study.py --timeout 300
```

This runs three constrained-search variants using 4-, 8-, and 16-bit carry groups. Without `OPENAI_API_KEY`, the two LLM arms retain their frozen prompts and are marked `PENDING_API_KEY`; no model calls or candidate results are fabricated.

## Run all three arms

Set `OPENAI_API_KEY` in the current PowerShell process, then supply the exact model ID:

```powershell
python -B eda/experiments/run_three_arm_study.py --model YOUR_MODEL_ID --timeout 300
```

This starts a new study and makes three independent calls for each LLM arm. Generic prompts contain the baseline RTL and functional requirements; STA-guided prompts add the frozen baseline OpenSTA report. The API-returned model ID is recorded. The API key is not stored and is removed from EDA subprocess environments.

Each `eda/experiments/controlled_rtl_study_*` directory contains `protocol.json` and its hash, prompts, frozen candidate manifest and hash, baseline reproduction, candidate RTL and generation records, per-candidate environment metadata, formal/mapping/STA logs, `result.json`, `summary.json`, and `SUMMARY.md`.

Formal pass rate is reported only when all three candidates in an arm were tested. Best WNS is selected among PPA-complete, formal-passing candidates within the area cap; average WNS and area change are reported alongside area eligibility. Conclusions apply only to this `timing_adder`, recorded models, selected SKY130HD TT library, and exploratory SDC. These are pre-layout results, not routed or silicon timing.
