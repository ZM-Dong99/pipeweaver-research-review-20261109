# Follow-up interpretation: STA plus RTL source-cone pilot

This follow-up uses the same nine candidate RTL files from the frozen native multiplier study. It adds the baseline STA report and an explicitly conservative, bit-level RTL operator cone to the guided prompt. The operator cone was derived before ABC mapping from Yosys JSON and includes only source-attributed cells that may lie between the reported STA startpoint and endpoint. It is not an exact mapping of standard-cell instances to RTL.

## Verified baseline localization

- Baseline STA start/end: `multiplicand[3]` to `product[11]`.
- Baseline maximum combinational data arrival: 2.78 ns; mapped area: 2965.344 µm².
- The conservative cone contains 13 RTLIL cells: 5 `$add` cells and 8 `$and` cells, with source attribution for all 13. Their source spans are the partial-product line and the row-accumulation line in the RTL.
- This confirms a plausible RTL operator cone for the endpoints. It does not prove that all 13 cells occur on the exact ABC standard-cell timing path.

## Corrected uniform re-evaluation

The first run's candidate 03 in the generic group instantiated a helper module. The evaluator had not flattened helper modules before formal checking and mapping, so that slot received a tool error. The unchanged candidate was proved equivalent and evaluated after fixing the evaluator; then all nine frozen candidates were re-evaluated with the same corrected flow. No new model API calls were made, and all original logs remain unchanged.

Baseline: 2.78 ns, 2965.344 µm². Eligibility required formal PASS, completed PPA, area at or below 110% of baseline, and strictly lower maximum combinational data arrival.

| Method | Formal/PPA complete | Valid improvements | Best eligible delay | Best candidate area |
|---|---:|---:|---:|---:|
| Generic LLM | 3/3 | 1/3 | 2.49 ns | 3163.0336 µm² |
| STA report + conservative RTL cone | 3/3 | 0/3 | 2.78 ns | 2969.0976 µm² |
| Constrained search | 3/3 | 0/3 | 2.78 ns | 2969.0976 µm² |

The valid generic candidate is a 3:2 Wallace compression tree. Its measured delay is 0.29 ns (10.4%) below baseline and its area is 6.7% above baseline, still under the frozen cap. STA-guided candidates used either an inferred `*` operator (2.81 ns) or a balanced row tree (2.78 ns); none beat baseline. These are measured outcomes, not proof that STA feedback generally hurts or that direct LLM is generally better.

## What this experiment says about STA feedback

The baseline raw STA report plus source-cone summary was genuinely supplied to the guided calls. However, the guided group did not find the best candidate in this three-slot sample; the direct group did. Adding source localization alone did not demonstrate a benefit on this multiplier. The prompt, API response metadata, candidate RTL, corrected formal logs, mapped netlists and OpenSTA logs are preserved.

The Yosys source-cone tracer supports a limited operator set and marks missing paths inconclusive when it encounters unsupported operators. A report of “no supported path” must not be interpreted as “no RTL dependency.” The flow remains a pre-layout study of one small unsigned multiplier.

## Audit files

- Re-evaluation summary and protocol: `reevaluation_fixed_helper_handling_20261029_190520/REEVALUATION.md`, `summary.json`, and `reevaluation_protocol.json`.
- Baseline source cone: `baseline/evaluation/eda/rtl_source_cone.json`.
- Example direct Wallace candidate: `reevaluation_fixed_helper_handling_20261029_190520/generic_llm/candidate_03/eda/`.
- Example source-cone-guided prompt: `sta_guided_llm/candidate_01/prompt.txt`.
- Original frozen candidate manifest and generation records remain at the study root.
