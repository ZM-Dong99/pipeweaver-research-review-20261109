# 自然流模块：复位后有效接口契约

后续已完成[候选与模型执行入口验收](README_STREAM_FEEDBACK.md)：新基线adapter WNS8.87ns、skid8.71ns，10项离线检查、6项真实手工候选分类及63项核对完成。新批次已冻结，等待新的明确授权；本轮API0次。

最新结果：[12项正反例与全部限制](eda/experiments/stream_reset_contract_20261106_reachable/INTERPRETATION.md)。这是一份新的接口观察契约，保留所有此前全引脚严格比较和声明初值模型的成绩。

已验证的固定实例为axis_register（32位、REG_TYPE=2）和axis_adapter（8→32位）。两份源RTL、两份实际映射网表均删除所有init属性，初始状态独立任意，仅首个时钟采样点复位。从第二个采样点起，ready/valid始终相等；有效输出的keep、last、id、dest、user相等；data只比较valid=1且tkeep=1的字节。没有假设输入遵守背压，也允许之后任意重新复位。

四项源级/门级正例证明完成完整基例与归纳。四种错误（ready、valid、有效payload、keep）均被反例检出；两个严格全引脚反例确认无效周期数据仍可能依赖初始状态；只改变无效周期数据和无效字节的两个案例允许通过。共12项符合运行前预期，没有新模型请求或新STA。

额外状态及打包器可达性性质均是被证明的目标，没有假定两份内部状态相同。证明成功不意味着支持任意重编码、事务重排、流水线变更或完整AXI正确性。FIFO仍未支持。数字逻辑初态独立性不等于物理复位时序、亚稳态或CDC签核。

本次沿用同一已测映射网表：adapter WNS8.83ns、面积2546.1920µm²；skid WNS8.71ns、面积3564.6688µm²。此处是补充复位/接口证明，没有新测时序或新优化收益。

```powershell
python -B eda/experiments/audit_stream_reset_contract.py eda/experiments/stream_reset_contract_20261106_reachable
```

完整本地重跑请使用不存在的新目录：

```powershell
python -B eda/experiments/validate_stream_reset_contract.py --out eda/experiments/my_new_stream_reset_check
```

运行脚本仅针对本次两个冻结实例和已知门级修改做证明验收，尚非任意候选的通用执行器。旧准备失败及归纳未完成运行分别保留在stream_reset_contract_20261106、stream_reset_contract_20261106_run2；可达性补充后成功运行另存，不覆盖原记录。

## 下一轮工程模块对照准备

[设计协议和四份提示](eda/experiments/stream_feedback_preparation_20261106/protocol.json)已经生成：两模块×有无STA×3次，拟12次独立请求。同一原始源码、固定参数、复位/valid/keep契约、统一使能展开映射及110%基线面积上限，STA组只增加实际基线路径。

准备阶段调用0次；上一轮定位的12次授权额度已用完，不能复用。新任务尚需任意候选验证接入、请求中断保护与统一格式处理的执行验收，再在新的明确预算与外发授权下调用。第二模型复核尚未执行，必须使用相同电路与协议，不能根据首轮好坏再挑配置。
