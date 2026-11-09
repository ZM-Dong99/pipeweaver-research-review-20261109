# 32路轮询仲裁器：真实反馈对照结果

公开原始arbiter.v＋固定priority_encoder.v；PORTS=32、轮询、应答阻塞。单正边沿时钟、同步高有效复位第1采样有效，此后输入任意；从第2采样点起保持原始逐拍输出。只有固定参数实例，不含公平性/无饥饿性质证明。

| 条件 | 返回/请求 | 合格严格改善 | 最终选中WNS ns | 选中面积µm² | 选择来源 |
|---|---:|---:|---:|---:|---|
| no_timing_feedback | 3/3 | 0/3 | 7.80 | 4436.7552 | baseline_retained |
| actual_paths | 3/3 | 0/3 | 7.80 | 4436.7552 | baseline_retained |

原始基线WNS 7.80ns、面积4436.7552µm²；固定面积上限4880.43072µm²。WNS越大越好，但不能用WNS百分比冒充频率提升，也不能与组合到达时间直接相加。

## 全部请求与候选

| 条件/槽位 | 生成 | 形式 | 门级证明 | PPA | WNS ns | 面积µm² | 严格改善 |
|---|---|---|---|---|---:|---:|---|
| no_timing_feedback/candidate_01 | GENERATED | PASS | PASS | PASS | 8.2 | 5571.5936 | False |
| actual_paths/candidate_01 | GENERATED | PASS | PASS | PASS | 8.06 | 5074.8672 | False |
| actual_paths/candidate_02 | GENERATED | PASS | PASS | PASS | 8.19 | 5729.2448 | False |
| no_timing_feedback/candidate_02 | GENERATED | PASS | PASS | PASS | 8.25 | 5388.9184 | False |
| no_timing_feedback/candidate_03 | GENERATED | PASS | PASS | PASS | 8.29 | 5415.1936 | False |
| actual_paths/candidate_03 | GENERATED | PASS | PASS | PASS | 8.22 | 5580.352 | False |

## 失败、拒绝和边界

- no_timing_feedback/candidate_01: Exceeds fixed baseline-derived area cap; 
- actual_paths/candidate_01: Exceeds fixed baseline-derived area cap; 
- actual_paths/candidate_02: Exceeds fixed baseline-derived area cap; 
- no_timing_feedback/candidate_02: Exceeds fixed baseline-derived area cap; 
- no_timing_feedback/candidate_03: Exceeds fixed baseline-derived area cap; 
- actual_paths/candidate_03: Exceeds fixed baseline-derived area cap; 

所有请求独立且交错，无前一候选或EDA结果进入提示。两组公共提示完全相同，STA组只增加基线时序与3条原始路径。全部候选生成并冻结后再统一评估，每份候选都对最初原始RTL证明。没有重试或补发；无合格改善时保留基线。

原始调用在各槽位api_audit/；代码、源级/门级归纳证明、映射与STA在candidate.v和eda/；AUDIT.json核查实际请求/响应及测量，REPRODUCTION.json核查独立复跑。证据核对项不是独立实验数量。

只有一个仲裁器配置，每组3次探索性请求；helper在此前优先编码器实验中出现过，不能视为完全独立的随机电路或模型训练盲测。即使某组胜出也不建立普遍或统计显著性结论。网关模型名不能独立证明实际后端身份。

时序为固定SKY130HD TT、10ns理想时钟、零最大外部IO延迟、0.10ns转换和0.010pF负载的预布局估计，没有布线寄生/功耗/hold签核。完整等价仅在记录的启动和参数条件成立。

## 正式结论：六份均正确、时序均改善，但六份均超面积

本轮两组3/3正常返回，没有网关失败；六份均通过源级与门级归纳证明、真实OpenSTA及电气检查。面积增加范围14.38%～29.13%，全部超过预先冻结的10%上限，因此两组最终均保留7.80ns、4436.7552µm²原始基线。不能将8.29ns或8.22ns的越界版本算作合格优化。

163项证据一致性核对通过。原始基线和两组实际选择三次独立复跑一致；另对两组时序最好的越界候选分别复跑，测量和网表哈希也一致，但仍保持排除。核对数和复跑数都不是新增独立模型样本。

## 面积为什么增加

AREA_COST_ANALYSIS.md/json由实际mapped.json实例数与同一Liberty单元面积计算，总和与所有原EDA面积一致。原始时序单元70个、面积1401.3440µm²；候选69～70个，没有增加寄存器。buffer/inverter面积从262.7520增加到410.3936～594.3200µm²，其他组合逻辑从2772.6592增加到3263.1296～3883.7248µm²。这里定位的是单元类别，不是精确源码行或功耗。

可复现证据支持：本轮的直接淘汰原因是组合逻辑及缓冲成本过高，不是功能验证失败或服务未返回。仅向独立请求提供基线STA，并未在该面积预算下生成合格结果；不能靠放宽主实验上限改变结论。

## 已有开发正例说明什么

先前手工同步复位写法在相同原始源码、参数、helper、库和启动契约下，WNS7.80→7.88ns，面积4573.1360µm²（约+3.07%），独立复跑一致；本轮重新核对契约匹配，见DEVELOPMENT_REFERENCE_CHECK.json。这说明至少存在小幅且预算内的改写空间，但该正例已用于开发，绝不作为新独立方法组或学术创新计入比较。

下一步应研究限制局部结构变化、共享组合逻辑和使用真实面积反馈的候选生成，而不是继续无约束地整体并行化；首先在开发例上完成机制验证，再冻结新的独立对照。这个方向是据本轮结果提出的后续假设，不是已经证明的新方法。

本轮提供方报告45255 tokens，不是独立核实账单。六次授权全部用完，没有重试或第七次调用。所有失败或超限记录保留；原编码器的正向结果也未据此撤销或夸大。
