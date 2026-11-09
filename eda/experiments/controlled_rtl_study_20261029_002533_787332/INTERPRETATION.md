# Interpretation audit

This note interprets the frozen experiment; it does not modify `protocol.json`, candidate RTL, or raw tool logs.

## Decision rule

Count a candidate as a valid timing improvement only if it passes syntax validation, formal equivalence, and the same Yosys/OpenSTA PPA flow; stays at or below 110% of reproduced baseline mapped area; and has WNS strictly greater than the baseline. Every scheduled slot remains in the denominator.

## Measured results

Reproduced baseline: WNS 1.38 ns, TNS 0.00 ns, mapped area 4284.1088 µm². Baseline critical path starts at `b[0]`, ends at register `_541_`, has 27 reported path cells, and has 8.39 ns data arrival.

| Arm | Valid timing improvements | Formal/PPA observations | Best eligible WNS | Area change at best eligible candidate |
|---|---:|---|---:|---:|
| Direct LLM | 0/3 | 3/3 formal and PPA complete; one candidate exceeds the area cap; the others do not improve WNS | 1.38 ns | 0.00% |
| STA-guided LLM | 2/3 | 2/3 candidates passed validation, formal, and PPA; one candidate failed Yosys syntax validation before formal | 3.19 ns | +8.50% |
| Constrained search | 3/3 | 3/3 formal and PPA complete; all within the area cap | 4.89 ns | +5.26% |

The two valid STA-guided candidates have different RTL hashes but the same measured WNS (3.19 ns), TNS (0 ns), and area (4648.208 µm²). Their WNS is 1.81 ns better than baseline. The constrained candidates measured WNS 3.42, 4.89, and 1.41 ns; their average WNS is 3.24 ns.

## What this supports

For this one `timing_adder` design, under this model API route, SKY130HD TT library, SDC, and three candidate slots per arm, adding the baseline OpenSTA report was associated with more area-qualified, formally equivalent timing improvements than the direct-LLM prompt (2/3 versus 0/3). The guided candidates targeted the long carry chain described by the baseline report. The prompt files, hashes, model outputs, RTL, formal logs, and candidate STA logs are preserved in this directory.

The experiment does not show that STA-guided LLM beats constrained search: constrained search produced 3/3 valid improvements and the best WNS. Three candidates per arm are a small sample; this is a pilot observation, not a statistical significance claim or a general result.

## Model identity and runtime limits

The API was called with the requested model ID `deepseek-v4-pro`, and the API response reported that same ID. DeepSeek's official notice says that, starting 2026-09-14, requests using this ID are routed to V4.1-Flash. Therefore, describe this run as using the `deepseek-v4-pro` API alias under the provider's current routing, not as a pinned V4-Pro model build. See https://api-docs.deepseek.com/news/news260910/.

The six LLM calls used 117,014 total tokens according to the preserved per-candidate usage records. Do not compare the generated summary's average runtime figures: its syntax-failure path omits model-generation time from `total_runtime_seconds`, so the arm averages are not comparable.

## Limits

One small RTL design, one library corner, one exploratory SDC, and pre-layout cell-delay analysis were used. The result does not establish behavior on larger RTL or after placement and routing. Native-divider experiments are separate. A later native baseline completes mapping and STA, but makes no LLM optimization claim and is not part of this comparison. See README_NATIVE_COMB.md.