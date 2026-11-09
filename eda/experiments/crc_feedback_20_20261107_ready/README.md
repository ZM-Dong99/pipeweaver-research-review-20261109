本轮已完成，20次额度已用完：20份返回，16个合格改善，4个真实功能错误被拒绝；独立复跑一致。见[最终结果解释](INTERPRETATION.md)。以下保留执行前方案与阶段记录。

# CRC32字节更新：拟20次模型对照，准备完成

状态：用户已明确批准CRC材料外发并调用最多20次，AUTHORIZATION.json=EXPLICITLY_APPROVED，正在按冻结方案执行。实际尝试和确定结果分别见trials/call_*/attempt.json与generation.json；最终以RESULT_SUMMARY.md为准。旧80次额度已用完，本轮不复用该额度或早期预检剩余槽位。下文保留执行前验收及授权范围。

## 准确范围

一个CRC32字节并行更新实例：data_in8位、state_in32位、data_out8位、state_out32位，全40输入和40输出位在任意二进制输入下比较。原始公开LFSR源码447行，加固定Galois/反射CRC32多项式0x04c11db7包装。两个条件都收到相同原始源码、固定契约和面积限制；STA组仅额外收到基线指标与Top3路径。

这是本项目尚未做过LLM优化的功能，但源码此前用于资格诊断；不称完全未暴露基准，也不保证模型训练未见。只包含一个组合核，不是整个Ethernet MAC或大型工程系统。

## 已完成本地验收

- 新raw-candidate入口evaluate_crc_candidate.py，对每个原始候选统一执行Slang展开、优化前后的结构检查、源级SAT、实际门级SAT、STA和电气检查。
- 7个真实正反例通过：原始和传统逐位参考完整验证；错误state_out和data_out均检出实际SAT反例；assume、寄存器、未定义输出均在前端/结构阶段拒绝。另有条件X分支在被优化成don't-care之前拒绝的专项检查。
- 4项合成离线检查通过：20独立配对槽位、无授权不发请求、连续3失败停止且保留17次未用、未知尝试不重发。这些不是模型样本。
- 本目录原始基线和传统参考分别与独立验收目录完整复跑比较，指标、单元数、SDC和网表SHA相同。见READINESS.json。

## 基线版本变化必须披露

新候选入口增加优化前结构检查，处理链为Slang/hierarchy/flatten/前置快照/proc/opt/check。原始设计在此统一流程中为 **0.98ns、2502.4000µm²**，固定110%面积上限2752.6400µm²；传统逐位参考为1.29ns、1385.0784µm²。

旧直接展开流程为0.97ns、2472.3712µm²，原始资料保留。两种流的功能验证都通过，映射结果不同，未逐pass隔离内部原因。旧0.97数字不用于本轮评分或宣称模型收益。

最初验收因仍期待旧0.97而失败，记录留在crc_evaluator_acceptance_20261107/。中间版本对死临时X过严误拒原始代码，记录留在crc_evaluator_acceptance_20261107_guarded/，未发任何模型请求。最终使用输出依赖锥检查，保留无影响的常量函数临时值，同时拒绝可能影响输出的未知值；验收在crc_evaluator_acceptance_20261107_final/通过。早期未完成准备目录crc_feedback_20_20261107没有可执行协议，不继续使用。

## 待批准的新调用范围

- 目的地：https://apinebula.ai/v1/chat/completions。
- 模型请求ID：gpt-6.1-sol；第三方底层构建未独立验证。
- 材料：公开原始LFSR+固定CRC32包装、功能/映射约束、基线面积，STA组追加基线时序报告。传统参考RTL及PPA不进入提示。
- 最多20次，有无STA各10次。冻结随机配对顺序，先冻结全部生成再评估候选，不根据中途结果改变提示。
- stream=true、include_usage=true、reasoning_effort=medium，每次600秒上限，请求max_completion_tokens16000，无重试、修复或补抽。连续3传输/不完整流失败停止；未知尝试禁止恢复补发。
- 请求完成token上限合计32万，网关支持/执行情况未独立核实；另有输入token和可能的失败计费。不是人民币费用上限，没有可靠金额估算。
- 20次都耗满600秒的纯请求上限为3小时20分，另加本地EDA，不是时长承诺。

主指标：全部10尝试回退后的中位到达时间。候选须源级/门级证明、电气通过，面积≤原始110%、TNS不退化、到达时间严格改善；否则回退原始。若提前停止，不作完整队列方法结论。最佳单次、合格数、面积、用量和门级字节哈希多样性作辅助。没有新功耗或布局布线结论。

## 入口

```powershell
python -B eda/experiments/run_crc_feedback.py check eda/experiments/crc_feedback_20_20261107_ready
python -B eda/experiments/run_crc_feedback.py collect eda/experiments/crc_feedback_20_20261107_ready
python -B eda/experiments/run_crc_feedback.py score eda/experiments/crc_feedback_20_20261107_ready
```

collect必须有本协议哈希匹配的新EXPLICITLY_APPROVED授权；已实际检查PENDING状态会阻止执行。候选、源码、提示、依赖、参考证明、基线、库和工具已冻结，不改旧协议继续跑。
