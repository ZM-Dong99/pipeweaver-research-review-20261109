# PipeWeaver 自动化 MVP

## 当前已经能做

RTL -> Python -> Yosys -> synthesized netlist -> metrics.json

## 运行

在 OSS CAD Suite CMD 中：

```cmd
cd /d D:\verilog_lab\PipeWeaver
python eda\run_eda.py benchmark\timing_adder.v
```

也可以指定顶层模块：

```cmd
python eda\run_eda.py benchmark\timing_adder.v timing_adder
```

## 输出

`eda/reports/`

- `*_synth.v`：综合网表
- `*_yosys.log`：完整 Yosys 日志
- `*_metrics.json`：结构化综合指标

## AST

```cmd
python parser\analyze_rtl.py benchmark\timing_adder.v
```

## 工具检查

```cmd
python eda\check_tools.py
```

## 重要限制

这个 MVP 不伪造 STA，也不会自动插入可能改变功能/延迟语义的流水线。

真正的 RAPID-Pipe 闭环需要：

1. OpenSTA 可执行文件；
2. 时钟约束 SDC；
3. Liberty 标准单元库；
4. STA -> WNS/TNS/critical path；
5. 功能等价/仿真检查；
6. 最后再接 LLM 生成候选结构重写。

因此当前版本已经把“自动 EDA 基础链路”做实，但不能把尚未具备真实 STA 数据的部分包装成已经完成。
