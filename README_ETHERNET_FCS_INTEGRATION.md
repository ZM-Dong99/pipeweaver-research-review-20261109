当前可使用的复位完整新版本与契约见[已验证RTL交付](README_FCS_RESET_COMPLETE.md)，下文保留原上游初值契约下的集成记录。

最新进展：候选已通过含CTS和供电网的实现验证，详见[CTS/PDN阶段结果](README_FCS_CTS_PDN.md)。

后续进展：已完成详细信号布线与实际寄生提取，理想时钟下WNS7.32→8.09ns；完整条件见[物理阶段结果](README_FCS_PHYSICAL.md)。下文保留原前布局集成结果。

# 真实以太网FCS模块集成

已把历史模型生成的CRC32字节更新候选接入公开的 `axis_eth_fcs`，固定8位接口，保留上层状态与帧尾控制。

| 指标 | 原始上层 | 优化上层 |
|---|---:|---:|
| WNS / ns | 7.68 | 8.55 |
| TNS / ns | 0 | 0 |
| 映射面积 / µm² | 4425.4944 | 3582.1856 |

面积降低19.06%，时序裕量增加0.87ns。源级/标准单元门级完整逐拍等价、电气检查、两版独立EDA复跑、2048拍原始RTL与独立CRC模型仿真及53项审计通过；故意错误校验值被真实SAT反例拒绝。新增模型调用0次。

证明保留原始RTL的逻辑初值，比较所有34位输出，包括无效期间的校验值；原始校验值寄存器没有复位赋值，因此本结果不等于任意上电状态下的复位后全输出保证。使用SKY130HD TT和前布局单元时序，没有寄生或物理签核。

- [完整结果、来源和适用条件](eda/experiments/ethernet_fcs_integration_20261107_safe_names/INTERPRETATION.md)
- [已验证固定参数RTL](eda/experiments/ethernet_fcs_integration_20261107_safe_names/exports/best.v)
- [原始基线RTL](eda/experiments/ethernet_fcs_integration_20261107_safe_names/exports/baseline.v)
- [机器审计](eda/experiments/ethernet_fcs_integration_20261107_safe_names/AUDIT.json)
- [独立复跑和仿真](eda/experiments/ethernet_fcs_integration_20261107_safe_names/independent_verification/RESULT.json)

这是已有候选的工程迁移验证，不是新模型样本；不增加CRC20次实验分母。下一步应比较布局布线后的物理收益，并明确实际产品的复位契约。
