# FCS普通体硅LVS配置资格完成

两版复位完整FCS的原始、已填充GDS及原始晶体管参考，在有独立源码依据的普通体硅提取配置下均通过LVS。无需改GDS或补画辅助衬底层。本轮新增模型调用0次。

配置依据是固定版本的Efabless SKY130 KLayout与OpenPDKs Magic提取源码：普通共享衬底和真实p-tap采用一致的衬底网络约定，并区分深阱/隔离结构。我们未执行Efabless完整规则或Magic流程，不能把源码依据写成这些流程已通过。

在另立的配置中，原ORFS规则仅增加一条PTAP到其已有VNB全局衬底的声明；没有直接强制VNB等于VSS，真实tap接触及金属连接仍必须成立。前置检查限制为当前固定低压FCS，禁止带深阱、SubstrateCut、高压/超高压、pwell block或双极器件标记的版图。

| 实际运行 | 结果 |
|---|---|
| 原始版未修改GDS/参考 | LVS通过 |
| 优化版未修改GDS/参考 | LVS通过 |
| 删除真实tap几何 | LVS失败，正确拒绝 |
| 删除参考中的逻辑门 | LVS失败，正确拒绝 |
| 加入SubstrateCut标记 | 前置拒绝，未运行LVS |

35项资格审计通过。原ORFS默认配置的失败及早期辅助衬底诊断仍完整保留，不改成通过。本结果仅支持具名普通体硅配置下的工程验证，不是制造商完整签核，也不能脱离前置检查当通用PDK配置使用。

此前独立公开DRC仍为两版145类别0违规；填充后重新提取WNS7.13→8.02ns、保持均0.49ns。非filler单元面积降低15.71%，含filler的总占用面积两版相同。原测量和RTL不改。

- [完整解读与独立源码链接](../../eda/experiments/fcs_bulk_profile_20261108/INTERPRETATION.md)
- [五项正反例结果](../../eda/experiments/fcs_bulk_profile_20261108/RESULT.json)
- [资格审计](../../eda/experiments/fcs_bulk_profile_20261108/AUDIT.json)
- [提取配置与适用范围](../../eda/experiments/fcs_bulk_profile_20261108/protocol.json)
- [复位完整RTL](README_FCS_RESET_COMPLETE.md)
- [完整GDS与原始独立检查](README_FCS_INDEPENDENT_LAYOUT.md)

下一步将当前固定FCS工程正例收敛为可复现验证基准，再在未参与开发的新电路上进行系统对照。完整流片签核的天线、IR压降和电迁移等结论仍未建立。
