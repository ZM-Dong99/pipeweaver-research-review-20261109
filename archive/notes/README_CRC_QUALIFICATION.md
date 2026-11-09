# CRC32工程更新核：验证范围

最新真实模型结果：[CRC20次对照已完成](../../eda/experiments/crc_feedback_20_20261107_ready/INTERPRETATION.md)。20份全部返回，16份合格改善，4份真实功能错误被拒绝并独立仿真复现；无STA中位0.870ns、STA0.955ns。两组最好均0.84ns/1580.2656µm²，相对新统一流基线延迟-14.29%、面积-36.85%，独立复跑一致。20次额度已用完；以下保留之前资格与准备阶段记录。

后续：[CRC模型对照入口已准备](../../eda/experiments/crc_feedback_20_20261107_ready/README.md)。统一带结构保护的新Slang处理链基线为0.98ns/2502.40µm²，保留原直接展开流0.97ns记录，二者不混用。7项真实正反例、条件X专项与4项预算离线检查通过；拟有无STA各10次，等待新外发/预算授权，新增模型请求0次。

最新结果：[固定CRC32实例资格报告](../../eda/experiments/crc_transfer_qualification_20261107/RESULT_SUMMARY.md)。新增模型调用0次；两个数据宽度中仅8位实例完整合格，32位实例的门级SAT未完成。

原始工程源码447行，来自锁定提交的verilog-lfsr。原始代码不改，固定包装指定CRC32多项式与8/32位并行输入。传统前端60秒超时，Slang展开同实例通过；保留失败和调用修正记录。

8位并行输入实例：源级/门级等价、STA和电气通过；基线0.97ns、2472.3712µm²、371映射单元，独立完整复跑一致。state_out与data_out故意翻转都被实际SAT反例拒绝。

源级另用白名单仿射网络的精确GF(2)系数与独立逐位CRC递推比较，覆盖任意状态和数据；这不是门级等价的替代。传统逐位参考为1.29ns/1385.0784µm²，面积更小但更慢，不计时序改善。

仅覆盖组合CRC更新功能，不是整个MAC或报文处理系统，也没有新LLM优化结果。此功能尚未加入三实例候选库；后续优化实验需单独冻结协议和调用预算。

从锁定原始源码重新展开并跑完整验证（输出目录必须不存在）：

```powershell
python -B eda/experiments/reproduce_crc_byte.py eda/experiments/my_crc_byte_reproduction
```

该入口已在[干净新目录](../../eda/experiments/crc_byte_clean_reproduction_20261107/RESULT.json)验收：独立CRC源级检查、源级/门级证明、STA、电气和原基线全部指标/网表哈希一致，模型调用0次。
