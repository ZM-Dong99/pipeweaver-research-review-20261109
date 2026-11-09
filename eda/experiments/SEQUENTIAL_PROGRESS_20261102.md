# 2026-11-02 时序后端跟进：真实结果与范围

这轮不调用LLM。已有的2026-10-31时序后端经检查后复用，没有将旧结果包装成今天的新开发。

## 今天实际执行

1. 原有12项正反例在新代码下完整回归，全部符合原冻结预期；96项证据核对通过。
2. 新增原生寄存乘法器、售票状态机、乘加流水线3个基线资格检查。前两个全流程通过；乘加器在仅第一个采样点复位的契约下出现真实反例，原记录完整保留。
3. 为同步复位增加显式 `--reset-cycles`，默认仍为1。独立新协议固定复位前三个采样点有效、启动窗口4个采样点，此后复位及数据均任意。乘加器全流程通过；不同状态编码计数器通过；故意错误的乘加器复位值和计数到7后才出错的计数器均出现反例。
4. 新队列45项、复位窗口64项证据核对通过。核对数量不等于独立实验数量。

## 新运行的实际数值

下表WNS是10ns理想时钟的setup裕度，不是组合延迟，也不是优化收益；不同启动契约不应直接比较成功率。

| 实现/条件 | 实际状态 | WNS ns | 面积 µm² | 映射单元 |
|---|---|---:|---:|---:|
| mul | PASS | 7.25 | 5213.7504 | 807 |
| ticket_machine | PASS | 9.3 | 252.7424 | 28 |
| mac | FAILED | — | — | — |
| mac_three_reset_samples | PASS | 7.13 | 6334.8256 | 909 |
| mac_wrong_reset | FAILED | — | — | — |
| counter_three_reset_samples | PASS | 9.18 | 193.936 | 28 |
| late_error_after_reset_release | FAILED | — | — | — |

通过行的源级及映射后证明均完成完整基例和归纳步骤，TNS均0、电气报告违例均0。错误行无PPA结果。MAC的104秒左右运行时间是本机这一次工具耗时，不能解释为算法普遍效率。

## MAC为什么原样自比较也失败

原始MAC只复位累加器；输入寄存器和乘积寄存器没有复位。当前证明让两份实现从各自任意的已定义初态启动。若只复位一次，旧的乘积可能进入已释放复位的累加器，造成两个实例在后续输出不同。这反映证明初始化契约不够，不说明原始RTL本身算错，也不是候选优化失败。

新协议明确假设复位持续三个采样点，允许乘法流水级装入相同数据，再比较启动窗口之后的输出。它只证明该条件下的逐拍等价；没有证明一次复位足够，也没有修改源RTL、隐藏原失败或自动放宽候选契约。实际用户必须认可启动条件，后续所有候选共用同一条件，不能为某候选临时增加复位次数。

## 证据目录

- `sequential_queue_20261102_164852_718315/`：3个原始基线，包含MAC一次复位的失败及VCD。
- `reset_window_validation_20261102_165104_589373/`：4个固定复位窗口检查，含错误复位和延迟出现错误的反例VCD。
- `sequential_backend_regression_20261102_1651/`：今天重新执行的12项默认行为回归。

各目录包含运行前协议与哈希、实际代码快照、SUMMARY.json、AUDIT.json；逐案例目录包含formal.log、mapped_formal.log、mapping.log、timing.sdc、sta.log（只有执行到该阶段才有）。源码原样自比较只是基线资格检查；人工状态编码和错误注入用于后端测试，不能算模型优化候选。

## 系统进度与下一步

已验证的原生时序基线现包括adder、selector、saturating_add、mul、ticket_machine，以及在明确三次复位条件下的mac。这不是六个新的独立盲测家族。旧45例报告保持原始的11例暂缓分类，不回写历史成绩。

单时钟后端仍未接入默认LLM优化循环；异步复位、多时钟、存储器、依赖文件CLI及改变输出延迟的改写仍不支持。下一步应把明确时钟/复位/启动契约的后端接到候选评估入口，使模型候选在同一协议下验证；接通后先做少量端到端检查，再冻结等预算对照。不能据这轮基线结果声称STA反馈优于直接LLM。

全部时序为SKY130HD TT、理想时钟、零外部最大输入输出延迟、0.10ns转换、0.010pF负载的预布局估计，没有布线寄生、hold或功耗签核。本轮模型调用0次。

## 查看与复核命令

在项目根目录的PowerShell中运行以下命令；只复核既有证据，不调用模型，也不重跑EDA。

```powershell
notepad D:/verilog_lab/PipeWeaver/eda/experiments/SEQUENTIAL_PROGRESS_20261102.md
python -B eda/experiments/audit_seq_followup.py eda/experiments/sequential_queue_20261102_164852_718315
python -B eda/experiments/audit_seq_followup.py eda/experiments/reset_window_validation_20261102_165104_589373
python -B eda/experiments/audit_sequential_backend.py eda/experiments/sequential_backend_regression_20261102_1651
```
