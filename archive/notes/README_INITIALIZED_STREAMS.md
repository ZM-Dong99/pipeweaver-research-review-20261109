# 保留逻辑初值的自然流模块验证

后续已另行完成[复位后有效接口证明](README_STREAM_RESET_CONTRACT.md)：两个模块的源与实际门级均可在无init假设下验证valid/keep限定的观察等价，12项正反例通过。这不是本文件“全部引脚逐拍相等”契约的替换。

新增独立后端 `eda/experiments/run_native_seq_initialized.py`，旧 `run_native_seq.py` 和此前冻结成绩保持原样。本后端要求显式 `--initial-state-policy rtl-declared`，只在源RTL声明的逻辑初值假设下验证；不保证标准单元具有物理上电初始化能力。

本次没有忽略valid=0的数据或其他输出，没有改变原生源码、接口、启动窗口或复位次数。所有输入在首采样复位约束之外任意，所有原始输出从同一启动窗口之后逐拍比较。

三项变化：

1. 从实际候选的mapped.json恢复导出结构Verilog未携带的init属性，用于映射后逻辑状态证明。初值来自候选映射本身，不能直接拿参考的值覆盖候选。
2. 可选 `--prove-state-invariants`：共同命名的原寄存器信号作为额外比较输出，与原始输出一起通过完整基例和归纳证明。没有假设状态相等、切断状态或跳过归纳基例。ABC后的逻辑状态线即使经过缓冲，也可作为待证明目标。
3. 可选 `--unmap-clock-enables`：在工艺映射前用 `dffunmap -ce-only` 展开使能逻辑，再让ABC进行统一映射/缓冲。它是新的映射条件，必须统一作用于同轮基线和候选，不能与旧映射直接算优化收益。

原缓冲映射得到80条使能高扇出相关电气违例；新条件下为0条，映射面积也改变。新数值是基线资格，不是模型优化结果。FIFO仍不支持；错误信息现明确指向存储单元，不再误报为已证实的派生时钟。

## 已完成结果

正式证据：`eda/experiments/stream_initialized_controls_20261106/`。

| 真实设计 | 固定配置 | 结果 | WNS ns | 面积µm² |
|---|---|---|---:|---:|
| axis_adapter | 8→32位 | 源级/门级归纳、STA、电气通过 | 8.83 | 2546.1920 |
| axis_register | 32位、REG_TYPE=2 | 源级/门级归纳、STA、电气通过 | 8.71 | 3564.6688 |
| 不同状态编码计数器 | 原固定配置 | 回归通过 | 9.18 | 193.9360 |

另有三份故意错误RTL（输出、初值、状态更新）均产生真实基例反例；原始映射网表输出bit0翻转的独立反例也被检出；FIFO结构拒绝符合预期。七项主用例加一项映射反例共8项预期全部满足，模型请求0次。

```powershell
python -B eda/experiments/audit_initialized_streams.py eda/experiments/stream_initialized_controls_20261106
```

复核仅读取已有证据并写AUDIT.json。完整重跑使用新目录：

```powershell
python -B eda/experiments/validate_initialized_streams.py --out eda/experiments/my_new_initialized_stream_check
```

该独立后端尚未接入默认LLM循环。命名状态关系是可选证明增强，不保证任意内部状态重编码都能证明；无法完成时必须返回INCOMPLETE，不得假定关系成立。RAM、异步/多时钟、任意握手时序变换、hold、物理寄生及物理上电行为仍未验证。后续模型实验必须在请求前明确同一逻辑初态和统一映射条件。
