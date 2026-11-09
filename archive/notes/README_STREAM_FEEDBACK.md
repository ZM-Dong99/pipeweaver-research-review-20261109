# 自然流模块模型对照：执行入口已验收

**2026-11-06已执行完成。** [本批实际结果](../../eda/experiments/stream_feedback_ready_20261106/RESULT_SUMMARY.md)：12次尝试中3份RTL返回、9次通信失败，无重试；三个返回均验证通过但映射为原始网表，没有时序改善。124项核对、两个最终基线独立复跑一致。额度已用完，不能把返回不足造成的持平解释为两方法等效。下文保留执行前准备说明；AUTHORIZATION已由用户明确批准，当前实际请求不再是0。

当前可执行批次：`eda/experiments/stream_feedback_ready_20261106/`。模型请求0次，AUTHORIZATION.json为PENDING；以前定位实验的12次额度已经用完。当前批次拟两模块×有无STA×3次，共12次，默认请求ID及具体外部目的地以protocol.json为准。

## 已完成的候选入口

`run_native_stream.py`接受本次两个固定原生接口和参数实例，按reset-only valid/keep契约验证任意给定候选文件。共同命名状态只是可选证明增强；增强失败后还会做不含内部关系的接口证明。只有接口本身的实际基例反例才归类功能FAIL；无法证明则为INCOMPLETE并保留基线。

每个候选都独立执行源级证明、去init综合、使能展开、映射后证明、真实时钟STA和电气检查；有独立工作目录和临时目录。没有把RTL声明初值当作硬件上电假设，也不执行模型返回的命令或外部依赖。

新入口在综合前也移除init，可能改变优化。因而两个基线已重新完整跑过，旧提示数值未复用：

| 实例 | 固定参数 | 新基线WNS ns | 面积µm² |
|---|---|---:|---:|
| axis_adapter | 8→32位 | 8.87 | 2574.9696 |
| axis_register | 32位skid | 8.71 | 3564.6688 |

均为10ns理想时钟、固定TT库、源级/门级证明和零电气违例下的基线，不是模型优化收益。共同面积上限为各自基线110%。

## 验收结果

- 10项无网络测试通过：前导包装/完整JSON围栏兼容、重复键和额外代码字段拒绝、未知中断不重发、失败计入槽位、授权/目的地匹配、候选防篡改、生成先冻结后EDA、重复RTL共享PPA及中位数回退。
- 三种实际合法变化完成源级/门级证明与STA：仅修改无效周期数据、修改声明初值、等价布尔改写。均未取得严格时序改善，实际选择保持基线。
- 两个错误候选（有效数据、ready）产生不含辅助状态关系的真实接口反例。
- 一个仅改变不可观察内部状态的候选触发辅助关系失败，接口证明未完成，正确标为INCOMPLETE；未伪称已证明功能错误或已证明等价。这也保留了当前证明能力的限制。
- 63项批次和候选证据核对通过。测试项数不是模型样本数；验收中没有API请求。

原始验收：[六项手工候选结果](../../eda/experiments/stream_candidate_acceptance_20261106_final/SUMMARY.json)、[执行准备核对](../../eda/experiments/stream_feedback_ready_20261106/READINESS_AUDIT.json)、[10项离线验收](../../eda/experiments/stream_feedback_ready_20261106/OFFLINE_VALIDATION.json)。早期探针和开发批次分别保留，当前批次冻结了最终代码快照。

## 运行方式

检查当前批次，不调用API：

```powershell
python -B eda/experiments/run_stream_feedback.py --validate eda/experiments/stream_feedback_ready_20261106
python -B eda/experiments/audit_stream_readiness.py eda/experiments/stream_feedback_ready_20261106 eda/experiments/stream_candidate_acceptance_20261106_final
```

取得对当前目的地、材料和最多12次请求的明确授权并记录后，执行：

```powershell
python -B eda/experiments/run_stream_feedback.py --execute eda/experiments/stream_feedback_ready_20261106
```

PENDING状态下执行会在任何请求标记创建前拒绝。不得把旧授权复制到新批次，也不得修改冻结哈希后继续旧运行。

全部12份生成先冻结，再统一评估；通信/格式失败无重试、无补抽。某请求已留下attempt但结果未知时停止，避免重复付费。相同案例/RTL的EDA可复用但所有模型槽位保留。主结果为各案例每组3次全部尝试的基线保留后中位WNS，不事后换成最佳一次。

范围仍是两个已暴露的固定自然工程实例、同一仓库、预布局估计。接口等价不代表完整AXI协议验证，FIFO、异步/多时钟和改变延迟仍未支持。需要新授权才能向第三方网关发送这些新的RTL与STA材料；模型身份和账单金额也不能由请求别名或token记录独立保证。
