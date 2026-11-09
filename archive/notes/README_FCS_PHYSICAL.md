后续进展：已完成包含时钟树和供电网的独立新基线，传播时钟下WNS7.30→8.04ns，总单元面积降低17.75%。见[CTS/PDN阶段结果](README_FCS_CTS_PDN.md)。下文保留先前理想时钟数据路径结果。

# FCS详细信号布线与寄生验证

已完成两版固定8位以太网FCS的放置、全局布线、详细信号布线和OpenRCX提取。独立OpenSTA重读实际SPEF，确认历史CRC优化在加入数据连线寄生后仍有收益。

| 指标 | 原始版 | 优化版 |
|---|---:|---:|
| 提取后WNS / ns（越大越好） | 7.32 | 8.09 |
| TNS / ns | 0 | 0 |
| 单元面积，含常量单元 / µm² | 4429.2480 | 3585.9392 |
| 路由器报告总线长 / µm | 12505 | 12316 |

WNS改善0.77ns，单元面积降低19.04%。两版核心尺寸相同，不能将单元面积减少称为芯片面积已经缩小。新增模型调用0次。

原始已证明网表→准备网表→详细布线网表的单元类型与完整引脚连接图一致。两版详细路由器报告均为0条违规，电气检查通过，独立STA结果一致；寄生覆盖核实全部有负载驱动均被覆盖。90项审计通过。

**范围：理想时钟下的详细信号布线验证。** 尚无CTS、PDN或物理上电保证。路由器警告部分LEF58规则不受支持，0条路由器违规不代表完整工艺DRC/LVS签核。原功能证明仍保留RTL逻辑初值条件。一次固定布局和种子也不代表跨布局或跨工艺泛化。

- [完整解读、实现条件和失败记录](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/INTERPRETATION.md)
- [机器结果](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/SUMMARY.json)
- [审计](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/AUDIT.json)
- [独立OpenSTA](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/INDEPENDENT_STA.json)
- [基线布线DEF](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/baseline/detailed.def) / [优化版DEF](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/optimized/detailed.def)
- [基线SPEF](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/baseline/extracted.spef) / [优化版SPEF](../../eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix/optimized/extracted.spef)

本轮补齐项目隔离OpenROAD安装及固定公开SKY130HD物理平台，未安装或升级系统软件包。既有模型实验和验证后端不改。

下一步：加入CTS与供电/合法物理单元，建立相同条件的下一阶段比较；并明确实际产品对复位和上电初态的要求。
