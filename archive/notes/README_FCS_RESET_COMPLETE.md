当前LVS工程配置已完成有独立源码依据的普通体硅资格，两版原始GDS不改通过；不是制造商完整签核。见[具名提取配置资格](README_FCS_BULK_PROFILE.md)。

后续物理检查：已生成完整GDS并通过公开独立DRC；LVS仍需明确衬底模型条件，不能声称工艺签核通过。详见[独立版图检查与条件](README_FCS_INDEPENDENT_LAYOUT.md)。下文保留复位完整RTL及填充前实现结果。

# 复位完整FCS：已验证RTL与实现结果

新顶层 `axis_eth_fcs_reset` 已补齐复位保证：移除三个状态寄存器的声明初值，为原来未复位的校验值寄存器增加同步清零。原始CRC版和优化CRC版接受相同修改，重新证明、综合和物理实现。

至少一次上升沿采样到 `rst=1` 后，CRC状态为FFFFFFFF、校验值为0、校验有效信号为0、ready为1。复位优先于同拍帧尾；之后允许任意定义值输入和重复复位，比较全部34位输出，无效期间的校验值也不屏蔽。没有DUT初值或两个实现初态相等的假设。

这是单独命名的新版本，复位/无效数据期间的校验值行为有意改变，不能当作未修改上游的完全等价替换。

| 同一新复位契约，含CTS/PDN及实际布线寄生 | 新原始版 | 新优化版 |
|---|---:|---:|
| 建立时间WNS / ns | 7.13 | 8.02 |
| 保持时间WNS / ns | 0.49 | 0.49 |
| 建立/保持TNS / ns | 0 / 0 | 0 / 0 |
| 全部物理单元面积 / µm² | 5089.8816 | 4290.3648 |

建立时间裕量增加0.89ns，总单元面积降低15.71%。面积包含tap、时钟树缓冲和时钟虚负载；die和核心尺寸相同，没有宣称芯片面积已缩小。本轮新增模型调用0次。

源级/实际门级完成基础情形与归纳证明；独立单DUT性质证明65位状态和全部输出在一次复位后确定。缺失复位和错误输出负例均被真实SAT反例拒绝。Linux Icarus直接编译原始RTL，通过4096拍独立逐位CRC模型对照，包含标准CRC校验及复位与帧尾同时发生的情况。Windows编译器访问违例和后备仿真记录完整保留。

新物理实现通过数据/状态连接图核对、独立传播时钟STA、有负载寄生覆盖、全部PG引脚和最终PDN连通检查；73项最终审计通过。

- [已验证的优化RTL](../../eda/experiments/fcs_reset_complete_20261107_induction_fixed/exports/best.v)
- [同契约原始RTL](../../eda/experiments/fcs_reset_complete_20261107_induction_fixed/exports/baseline.v)
- [接口与复位契约](../../eda/experiments/fcs_reset_complete_20261107_induction_fixed/exports/CONTRACT.json)
- [完整报告](../../eda/experiments/fcs_reset_complete_20261107_induction_fixed/INTERPRETATION.md)
- [审计](../../eda/experiments/fcs_reset_complete_20261107_induction_fixed/AUDIT.json)
- [新物理实现证据](../../eda/experiments/fcs_reset_cts_pdn_20261107/VERIFICATION.json)

导出RTL固定为8位输入，已展开参数，顶层为 `axis_eth_fcs_reset`；必须在使用前提供至少一个有效同步复位边沿。没有复位时不承诺上电输出。

尚未完成独立工艺DRC/LVS、完整GDS、天线或电源完整性签核。路由器不支持部分LEF58规则，其0违规不等于完整制造规则通过。下一步可以对这对复位完整实现开展独立DRC/LVS和电源检查；研究方法的泛化仍需独立电路对照。
