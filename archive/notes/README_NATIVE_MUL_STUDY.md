# Native multiplier controlled study

The first native multiplier comparison is in `eda/experiments/native_mul_three_arm_20261029_182342_906220/`; it used direct LLM, raw-STA-guided LLM, and three fixed partial-product trees. None of its nine candidates improved the 2.78 ns baseline.

A follow-up adds a conservative RTL operator cone derived from the actual STA start/end bits. Its original run, prompts, six real API responses, and candidate RTL are in `eda/experiments/native_mul_three_arm_20261029_184742_786215/`. An evaluator bug affected one helper-module candidate, so all nine frozen RTLs were re-evaluated uniformly, without new API calls, in `reevaluation_fixed_helper_handling_20261029_190520/`. That follow-up found one valid direct-LLM Wallace-tree improvement (2.49 ns, 3163.0336 µm²; baseline 2.78 ns, 2965.344 µm²), versus 0/3 for STA-plus-cone and 0/3 for constrained search. This is a small pre-layout pilot and does not establish general superiority.

For a fresh API run, from the repository root:

```powershell
$env:PATH = 'D:\oss-cad-suite\bin;D:\oss-cad-suite\lib;' + $env:PATH
python -B eda/experiments/run_native_mul_three_arm.py --model deepseek-v4-pro --timeout 180 --llm-timeout 300
```

The run creates a new timestamped folder. It uses the configured API and may incur provider charges. Every prompt, API record, candidate, formal log, mapped netlist and STA log is retained. The protocol explicitly describes the RTL source cone as conservative and not an exact gate-to-source mapping.
