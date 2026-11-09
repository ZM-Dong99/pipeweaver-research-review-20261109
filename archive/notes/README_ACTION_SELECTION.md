# 模型选择结构动作：使用与证据

主入口新增actions子命令，手动JSON回放不调用API。模型适配器只接受两个动作ID与rationale，经规范化后仍严格校验字段、重复键、动作白名单与规范源码；不会执行模型返回代码。

真实六次请求、原始格式失败、修复后的存档响应重放与全部EDA证据，见[24位结果](../../eda/experiments/action_selection_N24_20261103_010227_993541/INTERPRETATION.md)。原严格实验与事后修复重放分别保存。本轮六动作空间无严格时序收益，不能据此评价STA是否改善选择。当前修复代码尚未用新的独立请求重新验证，未追加费用。

## 不收费的本机回放

以下JSON明确为手工示例，不是新的模型返回。每次创建新目录：

```powershell
Set-Location D:/verilog_lab/PipeWeaver
$actionReplayStamp = Get-Date -Format yyyyMMdd_HHmmss_ffff
$actionReplayDir = "D:/verilog_lab/PipeWeaver/eda/experiments/action_manual_$actionReplayStamp"
python -B D:/verilog_lab/PipeWeaver/agents/optimization_loop.py actions --selection-json D:/verilog_lab/PipeWeaver/eda/experiments/action_selection_N24_20261103_010227_993541/examples/manual_selection.json --width 24 --out $actionReplayDir
Get-Content -Encoding UTF8 "$actionReplayDir/SUMMARY.json"
```

程序生成两个候选，分别对原始RTL跑源级/映射后等价与OpenSTA，并按冻结的10%面积/严格到达时间改善规则保留候选或原始。当前支持固定无符号comparator模板，不是任意工程RTL。

只审计历史主结果，不新跑EDA或API：

```powershell
python -B D:/verilog_lab/PipeWeaver/eda/experiments/audit_action_selection_study.py
```

历史审计从code_snapshot加载原严格解析器。live_code_changed_since_freeze会列出已修复的action_selector.py；这是预期的版本差异。旧execute会因代码哈希变化拒绝重跑，不能改旧哈希绕过检查，真实新模型实验需要新协议与新的限定调用授权。

新增输出选择因式分解动作属于单独的事后本地开发，原模型目录不含该动作；其24位主实例面积更小但时序更慢，详见[开发结果](../../eda/experiments/selector_factoring_development_20261103_170211_609482/INTERPRETATION.md)。
