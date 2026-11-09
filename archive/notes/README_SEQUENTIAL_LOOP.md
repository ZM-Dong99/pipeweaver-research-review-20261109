> 2026-11-02后续增量：已新增固定参数与共享依赖支持，并完成32路工程仲裁器的真实验证。见[工程入口](README_ENGINEERING_SEQUENTIAL.md)。下文旧“默认参数/依赖CLI尚不支持”描述保留为历史记录；异步和多时钟等限制仍有效。

# 原生时序候选评估入口

2026-11-02后续：新入口两次真实模型请求已完成，含第二轮实际EDA反馈及最佳独立复现。[真实闭环结果](../../eda/experiments/native_seq_loop_20261102_192804_400321/SUMMARY.md)。下面原有“尚未验证”描述是本次实际调用前的历史准备状态。

查看已完成结果：[真实接入验证报告](../../eda/experiments/SEQUENTIAL_LOOP_INTEGRATION_20261102.md)。本次只有手动回放，新入口真实模型生成尚未验证。

所有命令先在PowerShell进入项目根目录：

```powershell
cd D:/verilog_lab/PipeWeaver
python -B agents/optimization_loop.py seq --help
```

## 不花模型费用的真实EDA复现

```powershell
python -B agents/optimization_loop.py seq --rtl benchmark/rtl_opt_upstream_hkust/benchmark/adder/adder.v --top adder --clock clk --candidate-rtl eda/experiments/sequential_backend_controls_20261031_final/fixtures/adder_rewrite.v
```

程序输出新的独立实验目录；查看summary.json、best.json和best.v。候选可重复指定--candidate-rtl，按顺序评估。每个候选都直接对原始RTL证明；没有合格改善时best.v保留原始版本。错误候选记录在分母，不伪装成工具通过。

同步复位须明确--reset及极性；默认只假设第一次采样复位有效。需要多次复位时，在所有候选生成之前固定--reset-cycles及--warmup。例：--reset reset --reset-cycles 3 --warmup 4。不能为某个候选临时放宽。异步复位、多时钟和改变输出延迟不支持。

## 未来真实模型调用

以下命令会产生模型费用；本次没有执行。先确认当前进程Key、网关和准确模型ID已安全配置，不要把密钥写进命令或文件。

```powershell
python -B agents/optimization_loop.py seq --rtl benchmark/rtl_opt_upstream_hkust/benchmark/adder/adder.v --top adder --clock clk --use-llm --model $env:PIPEWEAVER_LLM_MODEL --max-candidates 2 --llm-timeout 120 --timeout 120
```

预算为两次请求尝试，不自动重试；先评估原始基线，失败即停止。之后每次使用当前最佳RTL和真实STA路径，并带入上一候选结果。必须检查generation/request.json、response.json、generation_metadata.json、prompt.json及原始EDA日志，才能报告真实生成、用量与结果。网关返回的模型名称不能独立证明后端身份。传入STA报告不证明模型内部如何推理，只能证实实际发送的信息和返回结果。

目前选择指标是固定面积上限内WNS严格提高且TNS不变差；不是功耗或最终物理签核。

## 仅核查已有手动运行，不重跑EDA

```powershell
python -B eda/experiments/audit_sequential_loop.py eda/experiments/seq_loop_integration_20261102_native_adder
```

该审计当前只支持已完成的手动回放，不能用它宣称真实模型实验已通过。
