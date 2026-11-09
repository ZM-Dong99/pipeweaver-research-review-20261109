# 非对称定位：分块固定映射的机制对照

零API，手工组合既有公开10路8位选择器和64路优先编码器。两个不同结构、148个输入位、79个输出位；所有输出完整等价，包括无有效请求时的编码器输出默认值。属于已暴露组件的开发性构造，不是新自然工程基准或独立盲测。

父实验采用整体扁平映射，单动作最优位置未发生切换，失败假设完整保留。本次事后机制对照只改变映射边界：四个组件版本独立映射后固定复用，未修改区域网表保持完全相同，顶层组合不再调用全局ABC。四份拼接门级网表均直接对完整原始RTL证明全部79个输出；源级组件证明和门级组件证明也完成。固定完整五套原约束、原动作与原110%面积上限，每次至多改一区域。双改只是更大次数预算参照。不是独立盲测，也不冒充原扁平流程结果。

| 配置 | mux输入延迟(ns) | priority输入延迟(ns) | 原始(ns) | 改mux(ns) | 改priority(ns) | 单动作实测最优 |
|---|---|---|---|---|---|---|
| balanced | 0.00 | 0.00 | 1.73 | 1.73 | 1.10 | rewrite_priority |
| mux_delay050 | 0.50 | 0.00 | 1.73 | 1.73 | 1.54 | rewrite_priority |
| mux_delay090 | 0.90 | 0.00 | 1.94 | 1.73 | 1.94 | rewrite_mux |
| both_offset | 0.60 | 0.20 | 1.93 | 1.93 | 1.64 | rewrite_priority |
| priority_delay030 | 0.00 | 0.30 | 2.03 | 2.03 | 1.40 | rewrite_priority |

| 策略 | 配置 | 选择 | 保留后延迟(ns) | 改进 | 与单动作最优差距(ns) |
|---|---|---|---|---|---|
| fixed_mux | balanced | rewrite_mux | 1.73 | 0.00% | 0.63 |
| fixed_priority | balanced | rewrite_priority | 1.10 | 36.42% | 0.00 |
| largest_input_delay | balanced | rewrite_mux | 1.73 | 0.00% | 0.63 |
| baseline_sta_endpoint | balanced | rewrite_priority | 1.10 | 36.42% | 0.00 |
| fixed_mux | mux_delay050 | rewrite_mux | 1.73 | 0.00% | 0.19 |
| fixed_priority | mux_delay050 | rewrite_priority | 1.54 | 10.98% | 0.00 |
| largest_input_delay | mux_delay050 | rewrite_mux | 1.73 | 0.00% | 0.19 |
| baseline_sta_endpoint | mux_delay050 | rewrite_priority | 1.54 | 10.98% | 0.00 |
| fixed_mux | mux_delay090 | rewrite_mux | 1.73 | 10.82% | 0.00 |
| fixed_priority | mux_delay090 | rewrite_priority | 1.94 | 0.00% | 0.21 |
| largest_input_delay | mux_delay090 | rewrite_mux | 1.73 | 10.82% | 0.00 |
| baseline_sta_endpoint | mux_delay090 | rewrite_mux | 1.73 | 10.82% | 0.00 |
| fixed_mux | both_offset | rewrite_mux | 1.93 | 0.00% | 0.29 |
| fixed_priority | both_offset | rewrite_priority | 1.64 | 15.03% | 0.00 |
| largest_input_delay | both_offset | rewrite_mux | 1.93 | 0.00% | 0.29 |
| baseline_sta_endpoint | both_offset | rewrite_priority | 1.64 | 15.03% | 0.00 |
| fixed_mux | priority_delay030 | rewrite_mux | 2.03 | 0.00% | 0.63 |
| fixed_priority | priority_delay030 | rewrite_priority | 1.40 | 31.03% | 0.00 |
| largest_input_delay | priority_delay030 | rewrite_priority | 1.40 | 31.03% | 0.00 |
| baseline_sta_endpoint | priority_delay030 | rewrite_priority | 1.40 | 31.03% | 0.00 |

假设检查（测量前写入protocol.json，不满足也保留）：{"mux_and_priority_both_preferred_in_nonbalanced": true, "sta_beats_largest_input_by005_in_at_least_two": true}

四个组件版本分别完成源级/门级证明与映射，四个顶层拼接门级设计完成全输出等价证明、20个配置STA、4次独立STA复跑、127项审计通过。这些不是独立模型样本。面积上限2719.608320µm²。

规则选择先根据实际原始STA端点或完整输入约束写入POLICY_DECISIONS.json，再测量候选场景时序，未用候选PPA决定规则输出。端点只关联到这个构造顶层的已知独立区域，不是通用逐门RTL归因器。

局限：五个配置相关、组件已暴露，且较聪明的无STA模型可能从RTL结构与约束估算瓶颈。largest_input_delay规则失败只排除了一个简单解释，不证明无STA LLM必然失败。无新模型请求，不是STA组胜出案例，不保证后续对照胜利。固定TT库、理想时钟、无物理寄生与功耗签核。

证据：protocol.json、POLICY_DECISIONS.json、SUMMARY.json、AUDIT.json、REPRODUCTION.json；mapping/保存源级/门级证明、综合和映射；profiles/保存SDC，sta/及independent_sta_replay/保存实际TCL、STA日志与结果。
