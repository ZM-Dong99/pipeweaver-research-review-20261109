# 有独立依据的普通体硅LVS配置

两版复位完整FCS的**原始已填充GDS**及原始完整晶体管参考，在明确、受约束的普通体硅提取配置下均通过LVS；无需修改GDS或补充236/0辅助面。这闭合了当前固定实例的工程提取配置问题，不是制造商完整签核。新增模型调用0次。

## 独立依据

[Efabless SKY130 KLayout源码](https://raw.githubusercontent.com/efabless/sky130_klayout_pdk/dace518392e9f0e98422359cc7063cd4e281b564/tech/sky130/lvs/sky130.lvs)，固定提交dace518392e9f0e98422359cc7063cd4e281b564，将sub与真实ptap_conn声明为同一全局衬底名称，并保留PTAP到licon再到金属的接触连接。这是本轮新配置的直接独立代码依据。本轮没有运行该完整Efabless规则，不能把本轮标成Efabless全流程签核。

[OpenPDKs SKY130 Magic提取源码](https://raw.githubusercontent.com/RTimothyEdwards/open_pdks/c6df28c1fccb05c286aa0a15e9c4c7dcd8502607/sky130/magic/sky130-extract.tech)，固定提交c6df28c1fccb05c286aa0a15e9c4c7dcd8502607，将p+扩散、普通pwell等列入衬底，并明确排除dnwell与isosub。这从另一工具实现支持了普通体硅与隔离结构应区分处理。本轮没有执行Magic提取，不声称Magic LVS通过。

[SkyWater工艺规则](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#dnwell)给出深N阱隔离pwell的用途；[工艺图层说明](https://skywater-pdk.readthedocs.io/en/main/rules/layers.html)将81/53标记为需单独考虑的SubstrateCut区域。这些资料支持限制适用范围，不能单凭文字资料代替实际提取。

[KLayout-PEX项目说明](https://iic-jku.github.io/klayout-pex-website/doc/doc.html#test-pattern-plate-20um-x-20um-li1-over-ptap)还解释了提取工具中p-tap与衬底可能采用不同网络表示。因此先前VNB/VSS不匹配需要明确提取约定，而不是直接归为RTL错误或忽略该网络。

## 本轮实际修改与运行

原ORFS规则、GDS和参考均未改。本轮另建ordinary_bulk.lylvs提取配置，完整比较原规则文本后确认仅增加一条PTAP到VNB的全局衬底声明，保留其已有SUB到VNB声明。这是移用上述Efabless的普通共享衬底约定，不是直接把VNB指定为VSS。实际tap及金属接触仍决定它是否接地。

运行入口先对真实GDS检查八类不支持的标记：深N阱、衬底隔离切分、高压/超高压、pwell block及双极器件标记。两版均无这些标记，只在本轮固定低压数字FCS实例上资格成立；配置文件不可脱离前置检查当通用PDK规则使用。

| 实际测试 | 结果 |
|---|---|
| 原始版原GDS + 原参考 | PASS |
| 优化版原GDS + 原参考 | PASS |
| 删除实际tap有源几何 | LVS FAIL，符合预期 |
| 从参考删除一个逻辑门 | LVS FAIL，符合预期 |
| 加入SubstrateCut标记 | 前置拒绝，未运行LVS |

完整器件、网络与引脚比较保留，未放宽器件参数容差、未黑盒替代、未跳过单元或网络。正例GDS和晶体管参考SHA与前轮逐字节相同。两项LVS负例均有原生报告及明确未匹配日志；隔离负例用于验证入口拒绝能力，不冒充完整隔离设计LVS测试。

## 结论边界与交付

本轮35项资格审计通过。旧ORFS默认配置直接运行仍为FAIL，旧诊断及失败记录原样冻结；新状态为“原始GDS在有独立源码依据的普通体硅配置下LVS通过”。不再需要靠修改辅助GDS几何来获得当前实例的匹配结果。

前轮公开DRC仍两版145类0违规；填充后新提取WNS7.13→8.02ns，保持均0.49ns。非filler单元面积下降15.71%，含filler总占用面积两版相同。这些旧测量未重算或改写。本轮只闭合提取配置与源代码依据，没有新增模型样本。

仍缺少制造商认证、完整工艺DRC/LVS、天线与IR/电迁移等检查，不给出流片保证。可以将当前固定普通体硅FCS作为工程研究正例，下一步收敛可复现验证链，并回到未参与开发的电路上做系统对照；无需把每项流片签核都当作LLM方法研究的前置结论。
