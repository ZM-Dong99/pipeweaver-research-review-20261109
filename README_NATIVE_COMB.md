# Native combinational RTL evaluator

`eda/experiments/run_native_comb.py` evaluates a combinational design at its original ports. It builds an output-equality miter, runs an unbounded combinational SAT proof against the specified source reference, and only then maps and runs OpenSTA. Sequential cells, latches, memories, inout ports, missing ports, and remaining unmapped cells are rejected. API credentials are removed from EDA subprocess environments.

Example, from the PipeWeaver root:

```powershell
python -B eda/experiments/run_native_comb.py benchmark/rtl_opt_upstream_hkust/benchmark/divider_32bit/divider_32bit.v --reference benchmark/rtl_opt_upstream_hkust/benchmark/divider_32bit/divider_32bit.v --top divider_32bit --timeout 120
```

For a generated candidate, replace the first path with its RTL file. The reference must remain the original design. `--reference-top` supports a different reference module name. `--out` selects a new, isolated output directory. Each tool has a finite timeout. A counterexample is `formal: FAIL`; an incomplete proof is `TIMEOUT`; other proof-tool failures are `ERROR`. None permits PPA evaluation.

## Frozen timing and mapping conditions

This evaluator uses SKY130HD TT, a 0.10 ns input transition, a 0.010 pF output load, zero external I/O delays, and a 100 ns virtual clock. The primary metric is maximum combinational data arrival, not an implemented chip clock frequency. No placement or wire parasitics are included.

ABC executes a real script with separate lines `strash`, `dretime`, and `map`. This is a different mapping recipe from the older timing-adder default flow. Compare candidates only after evaluating their baseline with this same recipe. Do not combine the two flows' absolute PPA values.

The installed Yosys rejects `abc -fast`. An earlier inline script mistakenly used commas as command separators, which Yosys converts to spaces; that run produced `$lut` cells and has no usable standard-cell PPA result. The new evaluator checks every mapped cell type and rejects such an output.

## Verified observations on 2026-10-29

- `native_comb_20261029_164733_399073`: original 32-bit divider baseline completed SAT, mapping, and STA. It contains 9,929 mapped standard cells, area 53,618.9248 µm², maximum data arrival 111.72 ns, virtual-clock WNS -11.72 ns and TNS -392.48 ns. This reproduces the preceding native preflight. Proving a source against itself checks pipeline operation; it does not prove a nontrivial optimization.
- `native_comb_20261029_164740_227662`: a deliberately incorrect candidate flips quotient bit zero. SAT found a counterexample, the evaluator recorded `formal: FAIL`, and mapping/STA did not run. This control is excluded from optimization candidate statistics.
- `native_comb_20261029_164453_382409`: the upstream 32-bit human reference did not complete full equivalence within 120 seconds. Its old result file says `NOT_RUN` while the log records a timeout; this status-label issue was corrected in the new runner. No equivalence or PPA claim is made for this attempt.
- `native_comb_20261029_164757_965763`: SAT disproved equivalence of the upstream 8-bit original and reference for an input with divisor zero. An independent Icarus exhaustive simulation in `divider_reference_audit_20261029` checked all 4,096 inputs: 128 mismatches at divisor zero and zero mismatches at nonzero divisors. For example, A=128, B=0 produces original quotient 254 and reference quotient 255. The reference therefore cannot replace the original as an all-input functional oracle.

All directories above are under `eda/experiments/`. The native work listed here made no LLM calls. It does not demonstrate native-divider optimization.

## Source provenance limitation

The mapped JSON is preserved for connectivity analysis. The verified 32-bit baseline has zero mapped cells with a `src` attribute and six source-attributed net names. This does not establish a cell-to-RTL-line mapping. A future path-localization module must reconstruct and validate that mapping; it must not invent source locations from cell names.

The next controlled native LLM study should freeze the original design, input domain including divisor-zero behavior, library, SDC, mapper, exact model/API route, prompts, candidate budgets, and acceptance rule before generation. Every candidate must use the original source as its proof reference. The existing timing-adder three-arm comparison remains a separate pilot study.

2026-10-30 更新：run_native_comb.py 已将 max_slew/max_capacitance 零违例纳入后续评估资格。result.json 中 ppa=PASS 只代表指标测量完成；必须同时要求退出码 0、status=PASS、eligible=true。历史冻结目录保持原样，新协议会使用更新后的验证器哈希。完整回归见 eda/experiments/electrical_gate_comb_20261030/SUMMARY.md。

2026-10-30 新增可选映射政策：--mapping-policy buffer_size。固定 ABC 驱动单元 sky130_fd_sc_hd__buf_2、10 fF 输出负载参考，并加入 buffer/upsize/dnsize；STA 的输入转换时间和输出负载保持原约束不变。该模式额外证明修复后的门级网表与原始 RTL 等价，失败则不通过。默认 legacy 保留以便追溯；旧冻结实验不能直接混用新政策。已知 ALU 可在新政策下消除电气违例，完整证据见 eda/experiments/abc_buffer_repair_20261030/SUMMARY.md。

2026-10-30 后续更新：发现一份功能正确候选在 ABC buffer 因悬空节点失败。现在可显式添加 --cleanup-before-buffer，在 map 后执行 cleanup -i -o。开关贯通基线、候选、冻结协议及审计，要求 buffer_size，默认关闭以保留旧行为。不得只为某组启用；应对全部候选和原基线统一使用，并以完整门级证明和电气检查兜底。本次统一复跑改变了最优比较，具体见三组实验 FINAL_INTERPRETATION.md。原先未启用的冻结协议不应直接混用修复代码续跑。
