# 数据选择器的受约束动作接口

已接入`agents/optimization_loop.py actions --template mux_large`。这是本地JSON动作回放路径，不调用API；模型动作选择适配器也可识别这个模板，但本轮没有执行新的真实模型动作选择请求。

目前仅支持仓库公开mux_large原始源码的精确指纹：10路8位数据、4位sel，sel0..9选择a..j，sel10..15回到a；84个输入位无额外约束。不是任意多路器或任意RTL的自动识别器。换源码、增加空行、改变端口或行为都会被拒绝；CRLF/LF换行归一化允许。二态全输入形式等价不等于X/Z四态仿真等价。

动作目录：

| 动作ID | 结构 | 已有测量延迟/面积 |
|---|---|---|
| masked_default_minimal | 显式化简默认使能 | 0.80ns / 792.0096µm² |
| masked_default_range | sel等于0或大于等于10 | 0.90ns / 830.7968µm² |
| masked_default_complement | 其余九路使能的补集 | 0.91ns / 865.8304µm² |
| masked_default_shared | 共享其他九路的2+2位译码 | 0.80ns / 793.2608µm² |

以上为同一固定SKY130HD TT库、IO与映射条件的预布局测量，不保证其他工艺或约束下相同。

## 初学者复跑命令

在PowerShell执行下面两行即可复跑两份注册动作。使用已有JSON输入，不需配置API或支付模型费用：

```powershell
Set-Location D:\verilog_lab\PipeWeaver
python -B agents/optimization_loop.py actions --template mux_large --width 8 --selection-json eda/experiments/mux_action_integration_20261105_133748_262400/inputs/mux.json
```

命令会建立新的action_replay实验目录，先验证原始基线，再对两候选分别做源级等价、映射后等价、综合、STA与电气检查，按延迟与原面积110%上限选择，生成SUMMARY.json与best.v。无合格严格改善时保留原始设计。`--width 8`只是统一命令接口要求，该源码本身无宽度参数；其他宽度或LSB设置会在EDA前被拒绝。

## 这次实际验证

27项离线边界与调度检查通过：包括四个生成模板逐字匹配既有已测量源码、错误源与未知动作拒绝、CRLF兼容、跨家族/重复动作拒绝，以及无效源在接触API前被拒绝。

真实命令行测试3组、共9个完整EDA案例通过：mux选择0.80ns/792.0096µm²；比较器回归保留1.21ns基线；优先编码器回归选择1.41ns/4052.6368µm²。53项集成核对通过，错误宽度与LSB设置均在创建EDA目录前被拒绝。

这些是软件集成与回归，不是9个新模型样本，也不证明STA优于无反馈模型。接口是手工JSON回放；真实模型选择新mux动作的请求仍未运行。原10槽模型对照的混合结果不变。

证据：[集成报告](../../eda/experiments/mux_action_integration_20261105_133748_262400/INTERPRETATION.md)、[审计](../../eda/experiments/mux_action_integration_20261105_133748_262400/AUDIT.json)、[代码差异](../../eda/experiments/mux_action_integration_20261105_133748_262400/CODE_DIFF.patch)。原文件备份在code_before/，新代码快照在code_after/；历史实验及代码快照保留，没有提交或推送。

来源：[真实模型返回与对照](../../eda/experiments/mux_feedback_study_20261104_155643_522144/INTERPRETATION.md)、[局部消融](../../eda/experiments/mux_default_ablation_20261104_173835_690775/INTERPRETATION.md)、[成对隔离说明](../../eda/experiments/mux_default_ablation_20261104_173835_690775/MECHANISM_NOTE.md)。这些是标准Boolean结构重写，不宣称新逻辑算法。原公开源码的MIT许可证保留在benchmark/rtl_opt_upstream_hkust/LICENSE。
