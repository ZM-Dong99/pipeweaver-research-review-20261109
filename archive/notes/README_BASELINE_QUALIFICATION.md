# 多家族基线验证：查看与复现

已完成的运行：`eda/experiments/baseline_qualification_20261031_000748_731025/`。
先看该目录 `SUMMARY.md`，再用 `COVERAGE.json` 查每个配置；`cases/<实例>/` 保存工具原始日志，`AUDIT.json` 保存546项证据一致性检查。检查通过不代表546次独立实验。

这次冻结45个配置：28个完整通过、5个超时、1个前端不支持、11个时序设计暂缓。没有调用LLM，没有新增方法对照结果。源码级原样自比较仅是自检；通过实例另有映射网表对原始RTL的功能证明及OpenSTA结果。

256路优先编码器映射1145个标准单元，到达时间2.60ns；不是优化后的收益。447行LFSR两种配置均前端超时，没有完成验证。所有时间均为固定SKY130库的预布局估计。时序设计的端口/寄存器扫描不等于时序等价验证。

## 在PowerShell中查看已完成结果

```powershell
cd D:\verilog_lab\PipeWeaver
notepad eda\experiments\baseline_qualification_20261031_000748_731025\SUMMARY.md
python -B eda/experiments/audit_baseline_qualification.py eda/experiments/baseline_qualification_20261031_000748_731025
```

审计读取既有证据并重建汇总，不调用模型、不重新跑综合和STA。完整日志位置由逐案例记录指明。

## 如需完整新复现

先确认本机能运行Yosys和WSL中的OpenSTA，再创建新协议：

```powershell
cd D:\verilog_lab\PipeWeaver
python -B eda/experiments/run_baseline_qualification.py --timeout 120 --workers 2
```

程序会输出新实验目录。用实际输出替换下方占位符，不要执行旧的LLM九槽位协议：

```powershell
python -B eda/experiments/run_baseline_qualification.py --execute "<新实验目录>"
python -B eda/experiments/audit_baseline_qualification.py "<新实验目录>"
```

保留全部 `protocol.json`、`protocol.sha256`、`family_split.json`、`code_snapshot/`、`cases/`、`summary.json` 和 `AUDIT.json`。每工具120秒是冻结条件；超时不算通过，也不代表电路功能错误。不要修改冻结协议后继续同一次运行。

## 来源与研究边界

40个本地RTL-OPT原始设计，加上固定提交的公开工程模块配置；来源、原始许可证、下载地址和SHA-256保存在 `benchmark/engineering_sources_20261030/`。不使用上游优化参考作为功能真值。工程来源：

- https://github.com/alexforencich/verilog-lfsr
- https://github.com/alexforencich/verilog-axis

已通过配置覆盖9个家族，但未参与本项目提示调试的可用评估候选只有13个配置、4个家族。不同位宽不是独立家族；公开源码不能保证未进入模型训练。`mult_if` 分类规则的保守冻结误分已在运行报告披露，未事后挪入评估集。

下一优先任务是接通真正带寄存器、时钟、复位的验证后端：固定延迟和接口契约、复位/初态假设、完整时序等价及真实时钟约束，加入故意错误的反例验证检测能力。先从单时钟且保持周期行为的模块开始，不在此阶段引入改变延迟的流水线重写。通过后再冻结等预算模型比较。当前结果不证明STA反馈有效或无效。
