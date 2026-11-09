# 比较器受限结构动作入口

实现：rewrite/comparator_rewrites.py。真实实验与全部日志：[结果解释](../../eda/experiments/comparator_action_study_20261103_004742_635275/INTERPRETATION.md)。

本入口只支持已核查的公开RTL-OPT无符号comparator模板。动作包含operator=unsigned_chunk_compare、chunk_bits=2/4/8和topology=balanced/linear。未知源码、signed修改、额外candidate_rtl字段及其他动作均拒绝。它不是通用RTL解析器，也尚未接入真实模型的动作选择。

三种固定N=1/13/32的21次源级/门级证明及STA通过，另有2次独立复跑、7项接口拒绝检查和357项证据核对。N32是预先冻结的主实验，无预算内严格时序收益；N13的次要边界正例不能改写主结论。

## 本机完整复现一个动作

在PowerShell粘贴以下命令。不需要API密钥，不会访问模型。每次使用新目录，避免覆盖历史记录：

```powershell
Set-Location D:/verilog_lab/PipeWeaver
$comparisonStamp = Get-Date -Format yyyyMMdd_HHmmss_ffff
$comparisonCandidate = "D:/verilog_lab/PipeWeaver/eda/experiments/comparator_demo_$comparisonStamp.v"
$comparisonReplayDir = "D:/verilog_lab/PipeWeaver/eda/experiments/comparator_demo_$comparisonStamp"
python -B D:/verilog_lab/PipeWeaver/rewrite/comparator_rewrites.py --source D:/verilog_lab/PipeWeaver/benchmark/rtl_opt_upstream_hkust/benchmark/comparator/comparator.v --spec D:/verilog_lab/PipeWeaver/eda/experiments/comparator_action_study_20261103_004742_635275/candidates/balanced_4.action.json --out $comparisonCandidate
python -B D:/verilog_lab/PipeWeaver/eda/experiments/run_native_comb.py $comparisonCandidate --reference D:/verilog_lab/PipeWeaver/benchmark/rtl_opt_upstream_hkust/benchmark/comparator/comparator.v --top comparator --param N=32 --mapping-policy buffer_size --cleanup-before-buffer --timeout 120 --out $comparisonReplayDir
Get-Content -Encoding UTF8 "$comparisonReplayDir/result.json"
```

这条示例会复现32位balanced_4：已记录延迟1.23ns、面积1188.6400 µm²，相比原始1.25ns/1069.7760 µm²时序略好但面积+11.11%，超出冻结的10%预算，主搜索保留原始版本。只有满足功能证明、电气、延迟及面积规则的候选才会被采纳，单看result.json的PASS不足以判定优化有效。

检查完整实验的协议与原始日志一致性，不新跑EDA或模型：

```powershell
python -B D:/verilog_lab/PipeWeaver/eda/experiments/audit_comparator_action_study.py
```

审计脚本会重写同目录的审计/解释派生文件，保留冻结协议、候选和原始EDA日志。严格SAT证明针对当前固定N的全部定义二进制输入，不证明所有参数值或四态X语义。组合电路用最大到达时间评价；100ns虚拟时钟WNS不能与旧时序实验混比。已有两种结构都是标准算法，不作首创主张。
