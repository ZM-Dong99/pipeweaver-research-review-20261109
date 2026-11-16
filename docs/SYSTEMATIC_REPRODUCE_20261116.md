# 2026年11月16日实验核查与复现

## 离线核查

在仓库根目录运行以下命令。Python 3.10及以上即可，默认模型调用数为0。

```sh
python tools/reproduce_research.py verify
```

该入口验证历史归档清单、新实验协议及评估程序哈希、输入和候选源码、合格候选的证明日志，重新计算工程实验统计，并核对输出定义性审计的覆盖范围。

新实验的完整结果在 `eda/experiments/systematic_engineering_20261116_v3/ENGINEERING_REPORT.md`，机器可读统计在同目录 `ENGINEERING_RESULTS.json`。`MODEL_SUMMARY.json` 为首轮采样结束时的统计快照，最终总数以 `ENGINEERING_RESULTS.json` 为准。

冻结协议中的 `model_requests=0` 记录建库阶段。真实执行次数由 `calls/request_*/slot.json`、响应和结果文件重新计算。工程初始计划与实际批准额度分别保留，执行计划和补充计划记录实际分配。

## 准备实际EDA依赖

当前实际验收环境为Windows、名为Ubuntu的WSL发行版、OSS CAD Suite中的Yosys和Slang、WSL内OpenSTA。历史生产脚本保留该环境的调用方式。GitHub自动检查只执行离线核查。

通过环境变量指定本机工具位置。

```powershell
$env:YOSYS = 'D:/oss-cad-suite/bin/yosys.exe'
$env:OPENSTA = '/home/easton1/OpenSTA/build/sta'
```

将合法获取的 `sky130_fd_sc_hd__tt_025C_1v80.lib` 放入仓库的 `eda/experiments/sky130_sta_20261027/lib/` 目录。要求SHA-256为 `92eb4e93a3d4c2563018ac81cdec2f02fdeaced9b39337ed5c141fa63e0ad8f8`。库文件和工具二进制均作为外部依赖提供。

## 重跑本轮全部实验

```powershell
python tools/reproduce_research.py systematic --out runs/systematic_20261116
```

该命令重跑18个基线以及全部已保存的模型RTL。相同电路和源码哈希共用一次实际测量，所有调用记录仍保留。每个候选继续与原始基线及原始面积预算比较。AXI组合和CRC32并行32位实例的未完成证明会保留实际结果，工具版本及超时边界可能改变本次状态。

结果写入新目录中的 `REPRODUCTION.json`。`passed` 汇总本次与冻结记录的状态、证明及数值匹配情况。查看每一项 `comparisons` 和 `metrics` 可定位差异。输出目录必须尚未存在。

## 快速验证流水线实例

```powershell
python tools/reproduce_research.py systematic --case pipeline_alu16_s2 --case pipeline_alu32_s3 --limit 2 --out runs/pipeline_smoke
```

`--case` 可重复使用。`--limit` 限制候选重测数量，所选基线仍逐一运行。省略这些参数时使用全部实例与全部已保存候选。

## 重跑既有244次调用中的保存RTL

```powershell
python tools/reproduce_research.py recent --out runs/recent_batches
```

此入口涵盖80次扩展对照、20次CRC以及144次多电路和反馈实验，重测其中216份完整RTL。历史生成失败作为原始记录保留。旧的代表性STA案例与FCS物理复现入口继续见 `REPRODUCE.md`。

## 已实际验收的范围

五个新工程基线和前五个保存候选已通过统一入口重新运行，共10次EDA，与冻结值一致。既有批次另完成2份候选的入口检查。具体输出见 `output/systematic_review_validation_20261116/`。

随后完成本轮全部18个基线和40个候选的全量重跑。58项结果的状态与已完成指标均匹配冻结记录，模型调用数为0，完整结果保存在同目录 `full_reproduction.json`。16个基线和40个候选完成验证及测量，两个未完成证明的基线继续保留实际失败状态。

28项资格判据、预算、自适应逻辑和SSE传输回归测试通过。错误流水线周期、错误数据位和错误FSM输出的三个实际形式验证负例均被拒绝。所有本轮合格优化候选另通过带undef跟踪的输出及状态定义性证明，正常控制样本与两种X注入负例保留结果。

全量新旧候选的重新执行入口已经提供。本轮新实验已完成全量重测，旧批次另做入口抽查。完整物理流程仍需各自的PDK、GDS及工具依赖。

## 预算与后续工作

本轮实际调用数及响应ID去重数见最终统计。首轮每个任务最多3次调用，达到固定收益目标后提前停止。补充实验使用完整的五电路×三策略批次，每个任务一次调用，分别保留预算口径。授权上限与执行计划随实验保存。

ALU、编码器及CRC参数扫描已经完成基线验证。新增参数实例的模型采样仍待安排，当前数据可描述基线随规模的变化。流水线自动切分、跨周期重定时、更多握手组合模块及多工艺角评估属于后续工作。
