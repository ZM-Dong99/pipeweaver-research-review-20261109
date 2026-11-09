# 已验证RTL候选库：本地统一入口

新版四实例入口已完成，包含CRC专用验证：[README_VERIFIED_OPTIMIZER.md](README_VERIFIED_OPTIMIZER.md)。建议使用`python -B -m agents.verified_optimizer`。下文保留原三实例入口，其代码和库未修改，以便复核旧实验。

入口：`python -B -m agents.portfolio_loop`。此入口不调用模型、不需要密钥；复用已有候选，每次重新执行源级等价、映射后等价、STA和电气检查。旧模型实验和原有入口保持原样。

第一版支持三个已研究固定实例：

| 实例ID | 顶层/参数 | 注册候选数 |
|---|---|---:|
| priority256 | priority_encoder，WIDTH=256、LSB_HIGH_PRIORITY=0 | 4 |
| mux10x8 | mux_large，固定10路8位接口 | 3 |
| alu64 | alu_64bit，固定64位接口 | 3 |

候选包括本轮无STA和STA最好方案、历史优化参考；编码器另保留历史均衡方案。源码逐字复制，来源、物理行数和SHA256记录在benchmark/verified_portfolio_20261107/registry.json；运行前检查全部注册资产完整性。历史性能数字不参与本次选择。

## 使用

在项目根目录执行：

```powershell
python -B -m agents.portfolio_loop list
python -B -m agents.portfolio_loop run --design alu64
```

默认创建新的eda/experiments/portfolio_*目录。指定输出目录时，该目录必须尚不存在：

```powershell
python -B -m agents.portfolio_loop run --design mux10x8 --area-limit 1.0 --out eda/experiments/my_mux_no_area_growth
```

默认面积上限为本次原始基线的110%；`--area-limit 1.0`要求面积不增长。每个候选始终与同一原始基线比较，不逐轮扩大预算。源级/门级或电气未通过、面积超限、TNS退化、没有严格时序改善都不会被主选择接受；无合格候选则导出原始RTL。

手工候选替代默认候选库，仍使用注册的固定原始实例验证；可重复传入多个路径，不调用模型：

```powershell
python -B -m agents.portfolio_loop run --design mux10x8 --candidate-rtl path/to/candidate.v
```

## 输出

- `best.v`：本次重新测量后的最快合格方案；无改善则为原始。
- `REPORT.md`：前后指标、各候选接受/拒绝及原因。
- `SUMMARY.json`：指标、固定参数、来源、选择、共享评估和帕累托清单。
- `pareto/`：在面积/TNS/证明/电气资格内的延迟与面积取舍；可能包含较慢但面积更小的方案，不表示主选择允许时序退化。
- `protocol.json`、`inputs/`、`evaluations/`：原始输入、代码/库哈希、参数和完整工具证据。

字节完全相同的候选复用同一评估，并明确记录shared_evaluation；不计作新增模型或硬件样本。原始基线若验证不合格，停止并不导出“优化成功”的文件。

## 验收范围与限制

本地集成验收入口为eda/experiments/accept_portfolio_loop.py。覆盖三种默认实例、零面积增长时改选方案、相同候选回退，以及错误默认分支被真实SAT反例拒绝。具体结果见[本地验收记录](eda/experiments/portfolio_acceptance_20261107/RESULT.json)。

这是**固定实例上的已知候选重评与选择**，尚未实现任意新RTL的识别、结构改写或参数泛化。改变位宽、优先级、接口、工艺或时序约束须另做适配与验证；不能拿已知候选的历史成绩代替新测量。地址计算因本轮仅3/20合格，暂不进入核心候选库。

当前评估为SKY130HD TT、零外部IO延迟、0.10ns输入转换、0.010pF负载、100ns虚拟报告时钟，使用固定buffer_size及cleanup-before-buffer映射；不含物理寄生、布局布线或功耗结果。本地验收不是新模型实验，也不是未见工程模块上的泛化证据。
