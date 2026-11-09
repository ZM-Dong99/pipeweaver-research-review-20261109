# 优先编码受限动作：真实结果与本机复现

本轮没有模型API调用。六个固定动作来自对先前已验证模型候选结构的人工参数化；本轮不是新LLM对照，也不是新优先编码算法。完整证据：[实验报告](eda/experiments/priority_action_transfer_20261103_174528_356729/INTERPRETATION.md)。

128位主实例：原始2.23ns/4267.8432 µm²，最快1.41ns/4052.6368 µm²（延迟-36.77%、面积-5.04%）；较小面积版本1.47ns/3301.9168 µm²（延迟-34.08%、面积-22.63%）。均有源级/门级证明、实际STA及独立复跑。

## 从主入口完整回放（不调用模型）

以下JSON明确是手工选择两个已登记动作，不是新模型返回。程序会生成RTL、验证原始基线和两候选、按原面积预算与全局延迟择优，每次输出到新目录：

```powershell
Set-Location D:/verilog_lab/PipeWeaver
$priorityStamp = Get-Date -Format yyyyMMdd_HHmmss_ffff
$priorityReplayDir = "D:/verilog_lab/PipeWeaver/eda/experiments/priority_manual_$priorityStamp"
python -B D:/verilog_lab/PipeWeaver/agents/optimization_loop.py actions --template priority_encoder --selection-json D:/verilog_lab/PipeWeaver/eda/experiments/priority_action_transfer_20261103_174528_356729/examples/manual_selection.json --width 128 --out $priorityReplayDir
Get-Content -Encoding UTF8 "$priorityReplayDir/SUMMARY.json"
```

应按实际输出核对source/mapped formal、PPA和电气状态，最佳选group_factored_16。已记录的同入口实际回放在eda/experiments/priority_action_cli_validation_20261103。遇到工具失败要看日志，不把失败目录当成功复现。

只核对冻结协议和原始日志，不新跑EDA或模型：

```powershell
python -B D:/verilog_lab/PipeWeaver/eda/experiments/audit_priority_action_transfer.py
```

## 导出代码与参数

exports/提供priority128_fast.v、priority128_small.v及priority256_fast.v，每份配同名JSON，记录top、参数、源哈希和测量。导出文件故意保留原模块默认参数；必须按JSON给出WIDTH=128/256、LSB_HIGH_PRIORITY=0，并保持LEVELS/W默认派生值。仅复制文件而不设置实例参数，不等于复现128/256位结果。许可证随代码保留。

## 范围

主实例128位，256位为已暴露参照，17位为非二次幂边界，32位LSB为原逻辑回退。全零输入valid=0时仍比较全部输出。28次计划评估、4次独立复跑、4个只包装对照分开计数；不同参数不是独立电路家族。

低位优先回退的0.02ns差异不计为架构收益；不据此声称精确识别了综合扰动根因。组合到达时间为布局布线前TT固定IO测量，不是芯片Fmax，也没有功耗/多角/寄生签核。

当前主入口支持两种精确源码模板，各自只接收两个合法动作ID，未知模板、源码或额外RTL被拒绝。尚未为这些新优先编码动作发起真实的有/无STA模型选择对照。后续若比较选择策略，应包含固定分组策略，并保持同候选预算，不能将当前全枚举成果直接当模型选择优势。
