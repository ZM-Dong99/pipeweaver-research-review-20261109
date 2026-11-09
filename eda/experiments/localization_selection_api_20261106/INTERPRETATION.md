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
