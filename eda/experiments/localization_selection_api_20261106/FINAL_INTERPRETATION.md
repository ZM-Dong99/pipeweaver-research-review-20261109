# 定位动作选择：真实请求结果

| 配置 | 组别 | 有效选择/尝试 | 合格改善 | 保留后中位延迟ns | 最优命中 |
|---|---|---:|---:|---:|---:|
| mux_delay050 | no_sta | 0/3 | 0/3 | 1.73 | 0/3 |
| mux_delay050 | sta | 3/3 | 3/3 | 1.54 | 3/3 |
| mux_delay090 | no_sta | 0/3 | 0/3 | 1.94 | 0/3 |
| mux_delay090 | sta | 3/3 | 3/3 | 1.73 | 3/3 |

主指标（STA减无STA的归一化中位收益）：10.903701个百分点。

Two correlated exposed development configurations; reused known PPA, no fresh EDA. Network/format failures remain in primary metrics. No generality or significance claim.

完整选择、失败、固定策略、反例和来源见summary.json及design/analysis_only。固定端点规则的已知结果必须一并报告；不以模型最好一次替代主指标。


## 全部真实尝试

| 请求 | 配置 | 组别 | 状态 | 动作 | 保留后延迟ns |
|---|---|---|---|---|---:|
| 1 | mux_delay050 | no_sta | FAILED_SELECTION | — | 1.73 |
| 2 | mux_delay050 | sta | SELECTED | rewrite_priority | 1.54 |
| 3 | mux_delay090 | sta | SELECTED | rewrite_mux | 1.73 |
| 4 | mux_delay090 | no_sta | FAILED_SELECTION | — | 1.94 |
| 5 | mux_delay050 | sta | SELECTED | rewrite_priority | 1.54 |
| 6 | mux_delay050 | no_sta | FAILED_SELECTION | — | 1.73 |
| 7 | mux_delay090 | no_sta | FAILED_SELECTION | — | 1.94 |
| 8 | mux_delay090 | sta | SELECTED | rewrite_mux | 1.73 |
| 9 | mux_delay050 | no_sta | FAILED_SELECTION | — | 1.73 |
| 10 | mux_delay050 | sta | SELECTED | rewrite_priority | 1.54 |
| 11 | mux_delay090 | sta | SELECTED | rewrite_mux | 1.73 |
| 12 | mux_delay090 | no_sta | FAILED_SELECTION | — | 1.94 |

## 预定确定性参照

| 配置 | 策略 | 动作 | 保留后延迟ns | 与单动作最优差距ns |
|---|---|---|---:|---:|
| mux_delay050 | fixed_mux | rewrite_mux | 1.73 | 0.19 |
| mux_delay050 | fixed_priority | rewrite_priority | 1.54 | 0.0 |
| mux_delay050 | largest_input_delay | rewrite_mux | 1.73 | 0.19 |
| mux_delay050 | baseline_sta_endpoint | rewrite_priority | 1.54 | 0.0 |
| mux_delay090 | fixed_mux | rewrite_mux | 1.73 | 0.0 |
| mux_delay090 | fixed_priority | rewrite_priority | 1.94 | 0.21 |
| mux_delay090 | largest_input_delay | rewrite_mux | 1.73 | 0.0 |
| mux_delay090 | baseline_sta_endpoint | rewrite_mux | 1.73 | 0.0 |

12个请求槽位；保存12份供应商可见响应、6份严格合法动作选择。全部12份用量记录报告token合计83755，不是独立核实账单。

原始summary.json的reported_tokens仅汇总6份严格接受的选择（45087tokens）；不能把它当全批次用量。全部响应口径以本报告和AUDIT.json为准。

证据一致性审计：True，94项核对；不是94次独立实验。

本轮没有生成新的RTL或重新跑候选EDA：模型只选动作，随后按此前已证明、测量且冻结的动作池评分。原始功能、门级证明和STA来源在design/analysis_only及其父实验，不把复用测量说成新证据。

通信/格式失败保留在主指标；成功返回条件统计见summary.json，不替代全槽位结果。两个场景是根据既有PPA选择的开发条件，不是盲测或两个独立家族。

若模型与STA端点规则持平，不能宣称模型带来额外收益；若无STA同样选对，则本轮没有建立STA增益。固定分块映射结论不替代此前失败的扁平映射假设。

请求1失败：Expected exactly one JSON object

请求4失败：Expected exactly one JSON object

请求6失败：Expected exactly one JSON object

请求7失败：Expected exactly one JSON object

请求9失败：Expected exactly one JSON object

请求12失败：Expected exactly one JSON object
