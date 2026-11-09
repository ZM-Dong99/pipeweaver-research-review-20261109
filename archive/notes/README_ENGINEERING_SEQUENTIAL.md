# 多模块、参数化时序设计入口

已完成结果：[工程仲裁器验证](../../eda/experiments/engineering_arbiter_validation_20261102_201724_713244/SUMMARY.md)。本轮没有模型请求。

先在PowerShell进入项目：

```powershell
cd D:/verilog_lab/PipeWeaver
python -B agents/optimization_loop.py seq --help
```

用真实32路轮询仲裁器做不调用模型的原样候选复现：

```powershell
python -B agents/optimization_loop.py seq --rtl benchmark/engineering_sources_20261030/verilog-axis/rtl/arbiter.v --dependency benchmark/engineering_sources_20261030/verilog-axis/rtl/priority_encoder.v --top arbiter --clock clk --reset rst --param PORTS=32 --param ARB_TYPE_ROUND_ROBIN=1 --param ARB_BLOCK=1 --param ARB_BLOCK_ACK=1 --candidate-rtl benchmark/engineering_sources_20261030/verilog-axis/rtl/arbiter.v
```

程序会创建新目录并先验证基线，再验证候选。原样候选不应报告时序改善，最佳应保留基线。查看summary.json、best.json、inputs/及各eda原始日志。该命令需要本机Yosys和WSL中的OpenSTA，但不读取密钥发请求。

--param可重复，值仅为非负整数；--dependency可重复，共享helper文件按字节复制冻结并应用于所有候选。候选文件保留原顶层参数声明，不重复定义共享helper。当前是明确列出的源码依赖，不是任意工程构建系统。

只复核已有证据、不重新EDA：

```powershell
python -B eda/experiments/audit_engineering_arbiter.py eda/experiments/engineering_arbiter_validation_20261102_201724_713244
python -B eda/experiments/audit_sequential_loop.py eda/experiments/engineering_arbiter_validation_20261102_201724_713244/round_robin_loop_integration
```

后续模型实验须另行确定外发内容与预算；本轮没有借用之前已经用完的调用额度。不同电路、参数或启动契约不能直接混在同一成绩里。
