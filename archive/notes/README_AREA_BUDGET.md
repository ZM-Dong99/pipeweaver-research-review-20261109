# 面积预算不是固定10%：项目口径与可复核数据

10%是此前对照实验预先选定的相对原始模块面积上限，不是工程通用强制要求。工程项目按实际时序目标、模块/整芯片面积及功耗/实现约束选择预算。我们当前量的是映射标准单元面积，不是整芯片裸片面积。

例如OpenROAD支持可配置的面积利用率限制，并说明不同算术架构有不同的时序/面积取舍：[官方Gate Resizer文档](https://openroad.readthedocs.io/en/latest/main/src/rsz/README.html)。注意其核心利用率和本实验相对模块基线的面积增幅是两个指标，不能混用百分比。

## 当前已经完成的本地分析

1. [现有候选在0/5/10/15/20/25/30%预算下的选择](../../eda/experiments/arbiter32_budget_sensitivity_20261102/INTERPRETATION.md)。不新增模型或EDA，仅重排已核实数据。并导出4个帕累托候选及原固定helper和契约。
2. [21次真实时钟目标STA复测](../../eda/experiments/arbiter_clock_budget_followup_20261102/INTERPRETATION.md)。2.0ns/15%时STA池有达标版本；1.9ns/25%时无反馈池有达标版本。均是事后示例，不改写原主结果。

“超10%”应读作“未满足本轮预设面积预算”，不等于功能不正确或工程上永远不可用。六份仲裁器候选全部功能证明通过，选择取决于具体目标。

## 后续新实验如何指定预算

统一候选入口原有--area-limit；新的仲裁器对照准备入口也已支持此选项，默认仍为1.10。以下只准备新协议并运行本地基线，不发模型请求：

```powershell
cd D:/verilog_lab/PipeWeaver
$env:PIPEWEAVER_HTTP_TRANSPORT='curl'
python -B eda/experiments/run_seq_feedback_study.py --model gpt-6.1-sol --area-limit 1.15
```

1.15表示模块映射面积不超过原始115%。准备后预算进入两组相同提示和冻结协议；实际模型执行仍需明确的新请求预算。--execute不允许追加--area-limit覆盖旧协议，需要创建新实验。非有限值、低于1的比例会拒绝。

之后应该事先固定一组预算或目标并完整报告，不能看到哪组赢了才选那个阈值。旧候选重排也不代表改变提示预算后模型会生成同样代码。

本轮新增付费模型请求0次。原先10%对照实验及全部原始证据保持不变。
