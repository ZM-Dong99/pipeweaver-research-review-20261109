# 参数规模实验核查与复现

本轮计划包含9个参数实例，每个实例的直接提示和STA提示各3次，共54次。实例来自ALU、优先编码器和CRC三个家族。随机调度分为3个完整区块，每个区块覆盖所有实例及两组。

冻结协议中的 `model_requests=0` 描述建库阶段。实际调用数通过执行计划、`calls/request_*/slot.json` 和API尝试记录核对，最终统计见 `ANALYSIS.json`。

## 离线核查

在仓库根目录执行以下命令，使用Python 3.10或以上，模型调用数为0。

```sh
python tools/reproduce_research.py verify
python eda/experiments/analyze_parameter_study.py verify --study eda/experiments/systematic_parameter_20261117
```

第一条入口校验历史清单、工程模块实验及本轮参数统计。第二条单独重算本轮分组、资格、中位数、候选归属、响应ID及预先记录的留出路由评估，同时核对源码与证明记录。

## 实际EDA重跑

当前验收环境使用Windows、Ubuntu WSL、Yosys及其Slang前端、OpenSTA。需要相同哈希的SKY130HD TT25°C 1.80 V Liberty。工具与库配置沿用 `SYSTEMATIC_REPRODUCE.md`。

```powershell
$env:YOSYS = 'D:/oss-cad-suite/bin/yosys.exe'
$env:OPENSTA = '/home/easton1/OpenSTA/build/sta'
python tools/reproduce_research.py parameter --out runs/parameter_replay
```

该入口重测9个原始基线与本轮全部已保存RTL，包括源级和映射后等价、STA、电气及输出定义性检查。CRC使用Slang展开，原始基线另通过独立GF(2)递推核对。生成失败保留原始调用记录，重跑入口产生0次模型调用。

```powershell
python tools/reproduce_research.py parameter --case priority64 --limit 1 --out runs/parameter_smoke
```

`--case` 可重复使用。`--limit` 控制候选数量，所选基线仍逐个重测。新输出目录必须尚未存在。`REPRODUCTION.json` 保存本次状态、实际指标及与冻结结果的逐项比较。

## 已完成的实际验收

本轮9个基线与53份保存RTL已通过统一入口全量重跑，共62项结果的状态及已完成指标均与冻结记录一致。前端失败和实际形式反例也被重现。复跑过程新增模型调用数为0，结果见 `output/parameter_review_validation_20261117/full_reproduction.json`。

31项离线回归测试通过，覆盖预算与分组、连续传输失败停止、失败槽位回退、自适应生成及SSE传输行为。9个基线均完成输出定义性和提示差异检查，所有通过源级与映射后评价的生成候选继续接受输出定义性证明。

## 统计口径

- 每个参数实例每组3个计划槽位。生成失败、前端失败、等价失败、面积超限、时序无改进均保留在分母。
- 同时报告实际API尝试、不同源码哈希及实例与源码哈希组合。多个宽度实例可共享原始参数化源码。
- 合格候选要求源级与映射后证明、STA、电气、输出定义性均通过，面积至多原始基线的110%，TNS不退化。
- 有效优化还要求最大组合数据到达时间严格降低。无有效优化时保留原始实现，中位保留延迟和收益按计划槽位计算。
- 原始候选源码、严格格式失败响应、生成时间及已知用量都保留。费用以实际账单为准。

## 留出路由评估

`ROUTING_ANALYSIS_PLAN.json` 在后两个区块开始前记录规则。第1轮用于每个实例选择提示策略，第2、3轮用于核对所选策略，比较固定使用直接提示、固定使用STA和选择策略的结果。每个策略最多18个完整配对。

该评估使用已有54次调用中的数据，额外模型调用数为0。每个实例只有1对训练响应和2对留出响应，结果用于描述这些固定上下文的初步路由表现。跨电路泛化和较大样本评估仍待继续。

## 证据导航

完整人工阅读报告为 `PARAMETER_REPORT.md`，机器可读结果为 `PARAMETER_ANALYSIS.json`。对应原始记录位于 `eda/experiments/systematic_parameter_20261117/`，包括冻结协议、授权、执行计划、逐次提示、响应、RTL与全部验证日志。
