后续进展：已交付不依赖DUT初值、经过一次同步复位后全输出保证的单独新版本，并重跑物理流程。见[复位完整FCS交付](README_FCS_RESET_COMPLETE.md)。下文保留旧逻辑初值契约的历史结果。

# FCS时钟树与供电实现结果

两版固定8位以太网FCS均已完成新流程：tap单元、供电网、放置、时钟树、详细布线、OpenRCX提取，以及传播时钟下的建立/保持时间检查。

| 指标 | 原始版 | 优化版 |
|---|---:|---:|
| 建立时间WNS / ns（越大越好） | 7.30 | 8.04 |
| 保持时间WNS / ns | 0.50 | 0.49 |
| 建立/保持TNS / ns | 0 / 0 | 0 / 0 |
| 总单元面积 / µm² | 4954.7520 | 4075.1584 |

建立时间裕量增加0.74ns，总单元面积降低17.75%，含147个tap、9个时钟树缓冲及各自的时钟虚负载。两版die/核心几何相同，没有宣称芯片面积已经缩小。新增模型调用0次。

原有数据与状态连接图在核实非反相时钟树后保持一致；所有物理单元PG引脚正确，详细布线后VDD/VSS连通检查通过。独立OpenSTA重读SPEF结果一致，所有有负载时钟和数据驱动均有寄生覆盖，建立/保持及电气检查通过。路由器支持范围内报告0违规；96项审计通过，6个时钟/数据接错的离线结构负例均被拒绝。

仍有明确边界：原功能证明依赖RTL逻辑初值，尚未保证任意物理上电后的行为；没有完整独立工艺DRC/LVS、GDS、天线签核、IR压降或电迁移结论。路由器不支持部分LEF58规则，因此0路由器违规不能当完整工艺签核。

- [完整报告与条件](../../eda/experiments/fcs_cts_pdn_20261107_initial/INTERPRETATION.md)
- [机器汇总](../../eda/experiments/fcs_cts_pdn_20261107_initial/SUMMARY.json)
- [96项审计](../../eda/experiments/fcs_cts_pdn_20261107_initial/AUDIT.json)
- [独立STA、连接及供电引脚核对](../../eda/experiments/fcs_cts_pdn_20261107_initial/VERIFICATION.json)
- [原始版物理DEF](../../eda/experiments/fcs_cts_pdn_20261107_initial/baseline/detailed.def) / [优化版物理DEF](../../eda/experiments/fcs_cts_pdn_20261107_initial/optimized/detailed.def)
- [原始版SPEF](../../eda/experiments/fcs_cts_pdn_20261107_initial/baseline/extracted.spef) / [优化版SPEF](../../eda/experiments/fcs_cts_pdn_20261107_initial/optimized/extracted.spef)

下一步优先处理不依赖物理初值的复位验证，再评估独立DRC/LVS和电源完整性。本轮是已有模型候选的实现迁移验证，不新增模型实验样本。
