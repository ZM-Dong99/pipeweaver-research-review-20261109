# 时序反馈消融实验

这轮专门检验“反馈包含哪些信息会改变 LLM 优化效果”，使用同一个无符号 8×8 组合乘法器。它与之前包含受约束搜索的三组比较分开记录。

| 条件 | 提供的信息 |
|---|---|
| `no_timing_feedback` | 原 RTL、相同工具条件与面积限制，不提供实测时序 |
| `metrics_only` | 上述输入，再加最大数据到达时间、虚拟时钟 WNS/TNS |
| `path_and_rtl_chain` | 上述输入，再加实际 Top-3 STA 路径和带信号名的保守 RTL 依赖链 |

每个条件安排 3 个独立候选，共 9 次 API 调用。调用顺序交错，使每个条件在每轮中各占一次第一、第二、第三顺位。所有候选在生成后冻结，再分别对原始 RTL 做完整组合等价证明；只有证明通过才进入 Yosys 映射和 OpenSTA。失败槽位保留在分母中，不自动重试。三个条件的提示长度不同，候选预算相等，token 用量不保证相等。

有效时序改进要求等价证明和 PPA 完成、面积不超过基线的 110%、最大组合延迟严格下降。另预先统计延迟至少下降 5% 的候选数。100 ns 虚拟时钟只用于报告，不能把该 WNS 解释为实际芯片频率。评估尚未包含布局布线。

RTL 来源锥是根据 Yosys 在 ABC 前保留的运算和信号构造的保守依赖分析。它显示可能相关的运算，不能当成实际门级最长路径的逐门源码映射。综合可能重组加法；源码中的加法数量不等于映射后的串行加法数量。不支持的运算会显式列出，找不到受支持路径时结论是不确定。

## 运行

在 PowerShell 中进入项目：

```powershell
cd D:\verilog_lab\PipeWeaver
$env:PATH = 'D:\oss-cad-suite\bin;D:\oss-cad-suite\lib;' + $env:PATH
```

准备新实验、运行基线和冻结协议。这个命令不调用 LLM：

```powershell
python -B eda/experiments/run_feedback_ablation.py --model deepseek-v4-pro --timeout 180 --llm-timeout 300
```

命令会打印新实验目录。检查后，用该目录启动 9 次真实 API 调用（会产生服务商费用）：

```powershell
python -B eda/experiments/run_feedback_ablation.py --execute eda/experiments/timing_feedback_ablation_20261029_200012_280805
```

上面的目录是本次已冻结实验的具体路径。重复实验应使用准备命令新建的目录。程序拒绝自动重复一个状态不明的既有 API 请求。

## 查看证据与不联网审计

实验结束后看该目录的 `SUMMARY.md` 和 `summary.json`。每个候选目录保存：

- `api_audit/request.json`：实际 API 请求正文，省略授权头。
- `api_audit/response.json`：服务商返回编号、模型 ID、token 用量与可见响应正文；不保存 reasoning 字段。
- `candidate.v`：由响应提取的 RTL。
- `evaluation/eda/formal.log`：完整组合等价证明输出。
- `evaluation/eda/mapping.log`、`mapped.json`：实际标准单元映射及面积。
- `evaluation/eda/sta.log`：OpenSTA 原始路径和时序输出。

运行独立文件审计，不调用 API：

```powershell
python -B eda/experiments/audit_feedback_ablation.py eda/experiments/timing_feedback_ablation_20261029_200012_280805
```

它核对冻结哈希、响应与 RTL 一致性、证明成功标志、标准单元类型、STA/面积数字与汇总的一致性，输出 `AUDIT.json`。这种审计检查文件证据之间的一致性，不能仅凭静态文件证明历史执行；独立重跑 EDA 是更强的复核。

对任一已有候选，可在不调用 LLM 的情况下独立重跑：

```powershell
python -B eda/experiments/run_native_comb.py eda/experiments/timing_feedback_ablation_20261029_200012_280805/path_and_rtl_chain/candidate_01/candidate.v --reference benchmark/rtl_opt_upstream_hkust/benchmark/mul_subexpression/mul_subexpression.v --top mul_subexpression --timeout 180
```

它会创建新的输出目录。若指定候选未生成，应选择另一个确实存在的 `candidate.v`。本实验只有一个反复研究的小乘法器、每组三个候选，是探索性结果；不据此声称统计显著或对其他电路普遍有效。

本轮统一提供面积测量值、面积上限和工具条件，属于新的提示条件；它与之前提示设置不同的试验应分别解读，不应直接合并成功率。附加电气诊断放在 `diagnostics/`，未注入这轮已经冻结的提示。
