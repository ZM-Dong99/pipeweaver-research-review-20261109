> 2026-11-02后续增量：已新增固定参数与共享依赖支持，并完成32路工程仲裁器的真实验证。见[工程入口](README_ENGINEERING_SEQUENTIAL.md)。下文旧“默认参数/依赖CLI尚不支持”描述保留为历史记录；异步和多时钟等限制仍有效。

# 单时钟时序验证后端

2026-11-06新增独立可选后端：[保留逻辑初值的工程流模块验证](README_INITIALIZED_STREAMS.md)。两个工程实例在显式RTL初值和统一使能展开条件下完成证明、STA及电气检查，8项正反例符合预期；不是物理上电验证。旧后端与旧冻结成绩保持原样，默认模型循环尚未切换。

2026-10-31：新增 `eda/experiments/run_native_seq.py`，已完成真实 Yosys/OpenSTA 正反例验证。它是单独的实验后端，不改变旧冻结协议，也没有接入默认 LLM 优化循环。

支持原生接口、默认参数、直接正边沿单时钟的 `$dff` 状态，包括用数据 mux 实现的同步复位与使能。拒绝异步复位、负边沿、派生/多时钟、时钟作为数据、锁存器、未展开存储器和形式假设单元。固定参数覆盖、依赖文件 CLI、握手协议及改变延迟的改写尚不支持。

## 证明契约

每个 SAT 时间步代表同一时钟的一次采样，比较同一拍的所有输出。初始状态为两份设计各自任意的已定义状态，同时保留 RTL 的初值属性。默认忽略第一个采样点，从第二个采样点开始要求严格相等；`--warmup N` 明确改变接口契约，不能为使候选通过而事后增加。没有证明启动窗口的输出相等，也没有证明采样间毛刺或异步行为。

可选 `--reset rst --reset-active 1` 只在第一个采样点约束该输入为有效值，此后复位任意，不要求一直释放。仅支持同步复位。无复位时不人为把寄存器清零。`saturating_add` 原始 RTL 使用上一拍的 overflow/underflow，验证明确使用两个采样点的启动窗口，未按模块名字擅自修正其行为。

采用 Yosys `sat -seq N+1 -tempinduct`，要求完整基例和归纳步骤成功；最大归纳深度32，每工具默认120秒。达到上限或工具失败记为 INCOMPLETE；只有基例实际反例记为 FAIL，不把有限深度无反例当作通过。随后进行 `dfflibmap` 和固定 ABC 映射，对实际映射网表重新执行同一时序证明。

## STA 与边界

真实时钟端口默认10ns；数据输入/输出最大外部延迟0ns，输入转换0.10ns，输出负载0.010pF。时钟为理想时钟，固定 SKY130HD TT 库，无布线寄生。记录 setup WNS/TNS，并要求完整 max-slew/max-capacitance 报告无违例；OpenSTA 错误、警告或缺失数值均不算合格。该资格不表示满足任意用户时钟，也不包含 hold、CDC、恢复/移除、功耗或物理签核。

```powershell
python -B eda/experiments/run_native_seq.py benchmark/rtl_opt_upstream_hkust/benchmark/adder/adder.v --reference benchmark/rtl_opt_upstream_hkust/benchmark/adder/adder.v --top adder --clock clk --out eda/experiments/my_new_seq_baseline
```

输出目录必须不存在。Windows 需要可用的 OSS CAD Suite，以及 WSL Ubuntu 中的 OpenSTA；沙箱可能限制 WSL 服务访问。

## 已完成验证

结果入口：`eda/experiments/sequential_backend_controls_20261031_final/`。12项全部符合运行前冻结的预期：6项完成源级/门级归纳证明、映射、STA及电气检查；4项功能错误提供真实基例反例与VCD；2项不支持的时序结构在证明前拒绝。源码自比较只是基线自检；改变状态编码的合成正例和手工加法器改写另行验证不同实现。没有模型调用，也不是新方法比较。

```powershell
python -B eda/experiments/audit_sequential_backend.py eda/experiments/sequential_backend_controls_20261031_final
python -B eda/experiments/validate_sequential_backend.py --out eda/experiments/my_new_seq_controls
```

第一条只读已有证据并写入 AUDIT.json；第二条重新冻结输入和代码快照，再完整运行本地工具。早期 `sequential_backend_validation_20261031/` 与不带 `_final` 的控制目录保留调试和首次结果，正式报告指向 `_final`。

下一步是补齐异步复位的显式行为契约与证明后端，再对暂缓队列建立新的资格协议。原有45例资格检查及其11例暂缓分类保持历史事实，不能用此次3个原生基线的结果改写旧成绩。


## 2026-11-02补充：显式同步复位持续时间

`--reset-cycles 3 --reset reset --warmup 4` 表示前三个采样点复位有效，从第5个采样点开始比较输出；复位在前三点以后任意。默认reset-cycles仍为1，无reset时没有复位假设。reset-cycles必须为正且不大于warmup；多次复位必须指定reset。此条件必须在生成候选之前固定，不能按候选修改。

[新增真实运行与限制](../../eda/experiments/SEQUENTIAL_PROGRESS_20261102.md)。MAC仅一次复位的失败保留，三次复位通过是独立新契约的结论，不替代原始结果。
