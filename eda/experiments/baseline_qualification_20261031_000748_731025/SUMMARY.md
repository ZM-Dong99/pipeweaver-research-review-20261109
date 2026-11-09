# 多家族基线资格检查（2026-10-31）

本阶段没有调用 LLM。运行前冻结 45 个配置实例：34 个组合实例实际尝试，11 个时序实例因后端范围限制暂缓。实际结果为 28 个组合实例完成资格检查、5 个超时、1 个前端语法不支持。

已通过实例覆盖 9 个冻结家族；其中 13 个来自未参与本项目提示调试的评估候选家族，只有 4 个家族：comparison, decoding, priority_encoding, selection。宽度变体不得当成独立家族，也不能把这些数字当成优化收益或统计显著性。

## 具体范围

- 采用原始源码、原生端口、固定参数实例；没有人为凑长代码或使用上游优化参考作为功能真值。
- 同一 SKY130HD TT 库、0.10 ns 输入转换、0.010 pF 输出负载、零输入输出外部延迟、100 ns 虚拟时钟、buffer_size＋缓冲前 cleanup；每工具120秒，两并发。
- 通过要求源级自比较、映射后对原始源的完整功能证明、真实 STA 数值及电气零报告违例。源级自比较只是流程自检，不是优化验证；门级证明另行执行。
- “可评估”不是“时序已经达标”，更不是“STA 引导已有效”。未生成任何优化候选，没有方法对照结果。

## 工程源码与复杂度

- 从公开 verilog-axis 固定提交导入未修改的优先编码器：92 行物理源码、约45行非注释非空行。64/256路实例均完成原生参数展开及验证；256路实际映射1145个单元，说明源码短不必然代表电路小。
- 从公开 verilog-lfsr 固定提交导入447行物理源码、约198行非注释非空行的模块；DATA_WIDTH=8/32 都在前端解析/展开阶段达到120秒上限，未获得功能证明或PPA。因此不能宣称已验证该447行工程模块。
- 两个工程仓库的源码、README、COPYING原样保存，固定提交和下载SHA-256位于 benchmark/engineering_sources_20261030/。这些是固定历史工程来源，不是对上游当前维护状态的保证。

## 失败与暂缓不能隐藏

- calculation、divider_16bit、divider_32bit：映射后等价证明超时；不是已证明错误，也不能报告为验证成功。
- lfsr 两种数据宽度：前端解析/展开超时。
- mux_encode：当前 Yosys 前端拒绝解包数组形式的端口，原始语法错误日志保留；没有为了通过而改扁平接口。
- 11个时序模块已单独完成语法/结构扫描，记录原生端口、寄存器类型和时钟复位来源；完整时序等价、时序约束与STA未运行，仍为暂缓。

## 数据分组与统计边界

历史项目协议暴露及开发家族在测量前写入 prior_exposure_snapshot.json / family_split.json。评估候选只表示未参与本项目的提示调试，不能保证公开代码不在模型训练数据中，也不是盲测保证。只做基线测量允许核查工具兼容性，不应据候选收益重新选案例。
mult_if 的名字前缀导致它被保守冻结为乘法家族，但源码实际上是条件选择；本轮保留原开发分组，不根据测量结果把它挪进评估集。后续清单应修正名称规则。
目前真正可用的新评估候选只有 4 个家族。即使每个宽度多抽几次候选，也不能凭空扩大独立样本数。当前仍不足以声称方法的普遍统计优势，尤其没有覆盖完整流水线/握手模块。

## 全部45个实例

| 实例 | 家族/冻结分组 | 源码行/近似代码行 | 状态 | 映射单元 | 到达时间ns |
|---|---|---:|---|---:|---:|
| engineering_arbiter | sequential_arbitration / evaluation_candidate_family | 159/108 | DEFERRED_SEQUENTIAL | — | — |
| engineering_lfsr_data32 | linear_feedback / evaluation_candidate_family | 447/198 | INCOMPLETE_TIMEOUT | — | — |
| engineering_lfsr_data8 | linear_feedback / evaluation_candidate_family | 447/198 | INCOMPLETE_TIMEOUT | — | — |
| engineering_priority256 | priority_encoding / evaluation_candidate_family | 92/45 | QUALIFIED | 1145 | 2.60 |
| engineering_priority64 | priority_encoding / evaluation_candidate_family | 92/45 | QUALIFIED | 270 | 1.73 |
| rtlopt_add_sub | add_subtract / development_family | 14/12 | QUALIFIED | 251 | 1.68 |
| rtlopt_adder | add_subtract / development_family | 20/18 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_adder_carry | add_subtract / development_family | 48/38 | QUALIFIED | 53 | 1.26 |
| rtlopt_adder_select | add_subtract / development_family | 14/12 | QUALIFIED | 533 | 1.59 |
| rtlopt_addr_calcu | address_arithmetic / development_family | 23/19 | QUALIFIED | 173 | 2.38 |
| rtlopt_alu_64bit | alu / development_family | 19/19 | QUALIFIED | 2237 | 3.05 |
| rtlopt_alu_8bit | alu / development_family | 23/20 | QUALIFIED | 249 | 1.53 |
| rtlopt_calculation | mixed_arithmetic / development_family | 22/21 | INCOMPLETE_TIMEOUT | — | — |
| rtlopt_comparator | comparison / evaluation_candidate_family | 28/24 | QUALIFIED | 70 | 1.08 |
| rtlopt_comparator_16bit | comparison / evaluation_candidate_family | 14/11 | QUALIFIED | 88 | 0.88 |
| rtlopt_comparator_2bit | comparison / evaluation_candidate_family | 8/8 | QUALIFIED | 16 | 0.38 |
| rtlopt_comparator_4bit | comparison / evaluation_candidate_family | 14/14 | QUALIFIED | 30 | 0.48 |
| rtlopt_comparator_8bit | comparison / evaluation_candidate_family | 23/23 | QUALIFIED | 63 | 0.74 |
| rtlopt_decoder_6bit | decoding / evaluation_candidate_family | 12/11 | QUALIFIED | 107 | 0.71 |
| rtlopt_decoder_8bit | decoding / evaluation_candidate_family | 12/11 | QUALIFIED | 414 | 1.06 |
| rtlopt_divider_16bit | division / development_family | 37/27 | INCOMPLETE_TIMEOUT | — | — |
| rtlopt_divider_32bit | division / development_family | 37/27 | INCOMPLETE_TIMEOUT | — | — |
| rtlopt_divider_4bit | division / development_family | 36/27 | QUALIFIED | 113 | 1.90 |
| rtlopt_divider_8bit | division / development_family | 36/27 | QUALIFIED | 564 | 7.23 |
| rtlopt_fsm | sequential_control / evaluation_candidate_family | 60/52 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_fsm_encode | sequential_control / evaluation_candidate_family | 85/75 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_gray | sequential_control / evaluation_candidate_family | 82/73 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_mac | multiplication / development_family | 25/20 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_mul | multiplication / development_family | 12/11 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_mul_const | multiplication / development_family | 17/16 | QUALIFIED | 92 | 0.86 |
| rtlopt_mul_subexpression | multiplication / development_family | 37/24 | QUALIFIED | 580 | 2.45 |
| rtlopt_mult_if | multiplication / development_family | 39/33 | QUALIFIED | 26 | 0.74 |
| rtlopt_mux_4to1_16bit | selection / evaluation_candidate_family | 22/18 | QUALIFIED | 92 | 0.50 |
| rtlopt_mux_4to1_64bit | selection / evaluation_candidate_family | 22/18 | QUALIFIED | 369 | 0.65 |
| rtlopt_mux_dead | selection / evaluation_candidate_family | 54/40 | QUALIFIED | 25 | 0.38 |
| rtlopt_mux_encode | selection / evaluation_candidate_family | 21/19 | TOOL_OR_FLOW_ERROR | — | — |
| rtlopt_mux_large | selection / evaluation_candidate_family | 23/22 | QUALIFIED | 162 | 1.04 |
| rtlopt_register | storage / evaluation_candidate_family | 64/50 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_saturating_add | add_subtract / development_family | 17/15 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_selector | selection / evaluation_candidate_family | 17/11 | DEFERRED_SEQUENTIAL | — | — |
| rtlopt_sub_16bit | add_subtract / development_family | 12/10 | QUALIFIED | 136 | 1.34 |
| rtlopt_sub_32bit | add_subtract / development_family | 24/21 | QUALIFIED | 264 | 4.30 |
| rtlopt_sub_4bit | add_subtract / development_family | 25/21 | QUALIFIED | 27 | 0.78 |
| rtlopt_sub_8bit | add_subtract / development_family | 25/21 | QUALIFIED | 60 | 1.20 |
| rtlopt_ticket_machine | sequential_control / evaluation_candidate_family | 135/112 | DEFERRED_SEQUENTIAL | — | — |

## 下一步与停止条件

先补齐时序模块后端或更多独立工程家族，再做冻结的模型比较；不要马上把28个配置当成28个独立案例花钱跑模型。当前这一批基线不决定STA方向成立或失败。
后续模型实验应在生成前固定电路家族、共同约束/映射、模型与预算、面积上限、失败处理、基线保留及主指标。以每电路/家族的配对结果分析，记录所有失败及费用；没有可重复收益就报告不支持，不追加提示直到获胜。
若只在现有四个新家族做小试，应明确标为探索，不能包装成充分统计证据。已用ALU、地址计算和乘除法开发案例只能作为开发/回归集。

文件：protocol.json / family_split.json（运行前冻结）；cases/（全部原始日志及逐案例结果）；summary.json；AUDIT.json；COVERAGE.json；sequential_interface_survey/（仅结构扫描）。
全部时序是预布局固定库估计，没有真实布线寄生、功耗或物理签核；参数证明仅覆盖记录的实例。
