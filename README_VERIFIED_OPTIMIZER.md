# 四类固定实例的统一本地优化入口

新版入口：`python -B -m agents.verified_optimizer`。支持编码器、选择器、ALU和CRC32字节更新，统一建立基线、验证候选、按原始面积预算选择、输出best.v和拒绝报告；不调用模型、不需要密钥。

## 运行

在项目根目录执行：

```powershell
python -B -m agents.verified_optimizer list
python -B -m agents.verified_optimizer run --design crc32_d8
```

| 实例ID | 固定范围 | 本地验收选择延迟ns | 后端 |
|---|---|---:|---|
| priority256 | WIDTH256、LSB_HIGH_PRIORITY0 | 1.43 | 原组合流程 |
| mux10x8 | 10路8位、默认分支仍选block_a | 0.73 | 原组合流程 |
| alu64 | 原64位ALU接口和全部操作码 | 1.83 | 原组合流程 |
| crc32_d8 | CRC32/Galois/反射、8位输入、任意32位状态、全部输出 | 0.84 | 带保护的Slang与完整等价流程 |

这些数字是本地实际验收结果，不作为运行时查表答案。每次重新执行原始及候选的证明、映射、STA和电气检查；新环境不保证同样数值。

默认面积上限为本次原始基线的110%。禁止面积增长：

```powershell
python -B -m agents.verified_optimizer run --design mux10x8 --area-limit 1.0
```

验收中，该命令拒绝面积增加的0.73ns候选，改选0.77ns、878.3424µm²方案。

手工候选替换注册候选库，仍针对注册的固定原始实例验证：

```powershell
python -B -m agents.verified_optimizer run --design crc32_d8 --candidate-rtl path/to/candidate.v
```

自动创建新实验目录；也可用`--out`指定尚不存在的目录。无合格改善时best.v为原始；原始基线自己不合格则停止，不导出成功结果。

## CRC没有省略验证

CRC使用专用raw-candidate Slang入口，保留优化前的状态、形式假设、初始化及输出可达未知值检查。原始引用绑定已通过独立CRC数学检查的固定来源，再对每份候选做全40输入/40输出的源级SAT、实际门级SAT与STA/电气检查。

统一入口实际验收确认：state_out32位与data_out8位都进入完整向量等价比较。真实模型调用05的错误data_out仍会被SAT反例拒绝并回退原始；相同源码不会计作改善；条件X输出会在证明之前拒绝。

CRC新处理链基线0.98ns/2502.40µm²，不能换成旧直接展开链0.97ns参与选择。CRC还保留传统逐位参考1.29ns/1385.0784µm²：它更省面积但更慢，不被主时序目标接受；作为面积/延迟取舍留在pareto/。

## 输出与证据

- best.v：本次验证、测量和预算选择后的源码。
- REPORT.md、SUMMARY.json：所有候选、接受/拒绝原因、指标及回退。
- pareto/：预算内的面积/延迟取舍，可能有较慢参考；不代表主选择允许时序退化。
- protocol.json、inputs/、evaluations/：原始输入、来源、后端、代码/引用/库哈希与完整日志。

相同字节候选共享评估并披露。运行开始和结束检查后端依赖未改变。每个候选始终相对同一原始预算判断，不逐轮扩大面积限额。

新候选库在benchmark/verified_portfolio_v2_20261107，4个实例、13份候选/参考，记录来源和SHA256。旧三实例库及agents.portfolio_loop不改，旧80次与CRC20次冻结实验依赖保持原样。

[8项真实端到端验收](eda/experiments/verified_optimizer_acceptance_20261107/ACCEPTANCE.md)通过。本次模型调用0次；这些是已有成果的系统集成，不是新增模型样本或泛化实验。

第一轮验收有一个测试本身用单复数不同的描述字符串判断CRC输出范围而误报；原RESULT.json保留。测试修正为直接检查实际接口位宽和SAT比较电路后，独立REAUDIT.json确认8项通过，没有修改RTL、生产代码或重跑PPA来追数值。

## 支持边界

这是固定实例的已知候选评估与选择，不是任意RTL识别、生成或参数自动适配。CRC32位并行输入实例仍因门级证明未完成而不支持；地址计算未进入核心库。改变位宽、参数、接口、时序或工艺需要重新适配和验证。

测量为SKY130HD TT、固定IO/映射条件的综合后预布局结果，不含功耗、布线寄生或硅片签核。多个子模块集成后的系统收益仍需另外验证。
