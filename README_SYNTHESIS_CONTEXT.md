# 综合后结构反馈条件

新增条件 path_and_synthesis_context 只支持当前 addr_calcu 默认参数研究实例。它在原路径反馈提示后追加自动生成的综合后结构证据，不添加上一轮候选、已知优化答案或候选成绩。默认三个旧条件不变，需显式选择新条件。

证据来自本轮原始 RTL：执行与实际综合匹配的 coarse 和 fine 起始优化，读取资源共享日志，保存中间 JSON，并对中间设计与原始默认参数 RTL 做完整输入 SAT 等价。若证明不完整、未知结构类型、缺失路径或证据哈希变化，则在新调用前停止。

当前结构链是保守的整单元输入/输出连接，不是精确位级敏化路径、最终门级路径或已验证的门到源码映射。综合器创建的 mux 没有 src 属性，保留 null。不能把三个 $alu 直接解释成最终网表的三个串行加法器。

每次新准备均重新生成证据，不复用上一轮模型输出。基线、映射、面积上限、真实模型参数、curl 传输和预算对三组保持一致。新组比旧路径组多的仅是综合后结构事实及精度说明；提示长度/用量会增加，因此不是等 token 预算比较。

本次实验在发现旧路径组无改善后提出，属于开发阶段的机制测试，不是留出集验证，也不声称新颖性或保证收益。其目的在于测量加入这些证据后是否改善候选，不把重复改写的观察直接当作已证实的性能原因。

当前三组九槽位目录：eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837。

准备命令（仅准备，不调用模型）：

```powershell
$env:PIPEWEAVER_HTTP_TRANSPORT = 'curl'
python -B eda/experiments/run_feedback_ablation.py --profile addr_calcu --arms no_timing_feedback path_and_rtl_chain path_and_synthesis_context --model gpt-6.1-sol --mapping-policy buffer_size --timeout 180 --llm-timeout 300
```

九个槽位为三组各三候选，三轮交错排列，每组在首、中、末位置各一次。所有候选先生成并冻结，再统一评估。不得在看到候选成绩后修改提示。

2026-10-30 后续更新：发现一份功能正确候选在 ABC buffer 因悬空节点失败。现在可显式添加 --cleanup-before-buffer，在 map 后执行 cleanup -i -o。开关贯通基线、候选、冻结协议及审计，要求 buffer_size，默认关闭以保留旧行为。不得只为某组启用；应对全部候选和原基线统一使用，并以完整门级证明和电气检查兜底。本次统一复跑改变了最优比较，具体见三组实验 FINAL_INTERPRETATION.md。原先未启用的冻结协议不应直接混用修复代码续跑。
