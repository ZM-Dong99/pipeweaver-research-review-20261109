# 四实例统一入口验收

最终独立复核REAUDIT.json：8项端到端用例通过，26个去重评估任务，新增模型请求0次。任务包含源级反例拒绝和前端提前拒绝，不等于26个全部完成PPA的成功设计。

| 用例 | 真实结果 |
|---|---|
| 编码器默认库 | 选择无STA存档候选，1.43ns |
| 选择器默认库 | 选择无STA存档候选，0.73ns |
| ALU默认库 | 选择无STA存档候选，1.83ns |
| CRC默认库 | 选择无STA存档候选，0.84ns；传统较慢省面积参考只进取舍集合 |
| 选择器面积不增长 | 拒绝0.73ns面积增长方案，选择0.77ns方案 |
| CRC真实错误data_out候选 | 实际SAT反例拒绝，导出原始0.98ns |
| CRC与原始相同的候选 | 无严格改善，导出原始；按字节共享原始评估 |
| CRC条件X输出 | 结构检查拒绝，导出原始0.98ns |

所有最终选择均完成源级/门级等价、STA和电气检查。CRC输出覆盖通过实际after_opt接口和eda/miter.v验证：data_out8位、state_out32位均以完整向量参与mismatch，不根据描述文字推定。

初次RESULT.json保留一个测试误报：测试字符串写成input/output单数，而真实协议描述是inputs/outputs，导致CRC默认项both_crc_outputs=false。生产选择、完整证明和PPA都已通过。修正测试后不重复EDA，直接复核实际比较电路、全部导出SHA与当时依赖SHA，结果见REAUDIT.json；旧失败文件未覆盖。

证据包括各用例SUMMARY.json、protocol.json、REPORT.md、best.v、evaluations/、各runner.log及REAUDIT.json。历史模型样本不增加，原有两个模型实验的冻结代码和原始日志未修改。
