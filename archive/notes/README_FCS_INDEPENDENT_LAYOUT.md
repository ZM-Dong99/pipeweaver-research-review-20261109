后续资格完成：两版原始GDS已在有独立源码依据、带隔离结构前置拒绝的普通体硅提取配置下通过LVS，无需修改GDS。见[具名配置资格与负例](README_FCS_BULK_PROFILE.md)。下文保留原ORFS默认失败及早期辅助衬底诊断记录。

# 独立GDS检查：DRC通过，LVS需明确衬底模型

已把两版复位完整FCS的真实标准单元GDS与最终布线合并，并完成独立KLayout检查。本轮新增模型调用0次。

| 检查 | 原始版 | 优化版 |
|---|---|---|
| 独立公开DRC，145个规则类别 | 0违规 | 0违规 |
| 原始规则直接运行LVS | 未通过 | 未通过 |
| 明确连续普通体硅衬底模型的诊断LVS | 通过 | 通过 |

独立DRC负例加入过窄金属，确实检出违规。原始LVS失败保留，不能用退出码0或诊断结果把它改记为通过。

新增标准filler后，所有原有单元位置、信号连接、布线几何和顶层引脚均保持不变，叶级标准单元全部匹配；剩余顶层问题集中在衬底VNB与地VSS的提取连接。

诊断副本仅补充辅助层236/0的普通体硅连续衬底模型，检查无深阱及高压隔离；制造多边形层逐层核对未改，未直接强制VNB等于VSS。此条件下两版LVS匹配，删除实际tap接触或逻辑门均被拒绝。**这是有明确建模假设的结果，尚非完整工艺签核。**

填充后重新提取的建立WNS仍为7.13→8.02ns，保持WNS均0.49ns。非filler单元面积降低15.71%；两版核心相同并被filler填满，含填充后的总占用面积均为11911.424µm²，不能再称含填充总面积下降15.71%。

- [完整结果、假设与失败记录](../../eda/experiments/fcs_filled_independent_layout_20261108/INTERPRETATION.md)
- [机器汇总](../../eda/experiments/fcs_filled_independent_layout_20261108/SUMMARY.json)
- [原始版GDS](../../eda/experiments/fcs_filled_independent_layout_20261108/baseline/design.gds)
- [优化版GDS](../../eda/experiments/fcs_filled_independent_layout_20261108/optimized/design.gds)
- [独立DRC报告](../../eda/experiments/fcs_filled_independent_layout_20261108/optimized/drc.lyrdb)
- [有明确衬底模型的LVS及负例](../../eda/experiments/fcs_filled_independent_layout_20261108/substrate_continuity_diagnostic/RESULT.json)
- [复位完整RTL与接口契约](README_FCS_RESET_COMPLETE.md)

下一步应以独立工艺依据确认衬底/体端提取约定，再继续完整工艺DRC/LVS、天线与电源完整性验证。40项证据一致性检查通过，包含对失败记录的保留核对，不表示设计签核完成。
