# PipeWeaver 时序感知 RTL 优化闭环

闭环在现有 SKY130HD 实验脚本上运行：先建立基线并读取 OpenSTA 关键路径，再生成或接收候选，检查 `timing_adder` 接口和 Yosys 结构；每个候选直接与原始 `benchmark/timing_adder.v` 做 SMT 归纳等价证明，通过后复用既有 SKY130HD 综合映射和 OpenSTA 流程。LLM 提示会包含当前最佳 RTL、关键路径、当前指标和上一候选的 EDA 结果。每轮在新的 `eda/experiments/llm_loop_*` 目录留存提示、候选、解释、日志、指标和决策。

## 环境准备

已有 Windows/WSL EDA 环境沿用如下配置：

- Yosys 与 `yosys-smtbmc`：`D:\oss-cad-suite\bin\`
- Boolector：OSS CAD Suite 提供的 solver
- OpenSTA：WSL `Ubuntu` 中 `/home/easton1/OpenSTA/build/sta`
- SKY130HD TT Liberty 与探索性约束：现有 `sky130_sta_20261027` 实验文件
- Python 标准库；LLM 模式通过标准库 `urllib` 访问 OpenAI 兼容的 Chat Completions API，不新增依赖

检查工具和 API Key 是否已配置（只显示是否配置，不显示密钥）：

```powershell
python agents/optimization_loop.py check
```

LLM 模式从当前 PowerShell 进程的 `OPENAI_API_KEY` 读取密钥。可在交互会话中安全输入：

```powershell
$secure = Read-Host 'OPENAI_API_KEY' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try {
  $env:OPENAI_API_KEY = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  $modelId = Read-Host '准确模型 ID'
  python agents/optimization_loop.py run --rounds 2 --max-candidates 2 --model $modelId
} finally {
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  Remove-Item Env:OPENAI_API_KEY -ErrorAction SilentlyContinue
}
```

若使用兼容 API，可在当前 PowerShell 会话设置 `OPENAI_BASE_URL`。密钥、Base URL、请求头和完整 API 响应不会写入候选结果或运行日志。模型输出必须是含 RTL 和五项说明字段的 JSON；代码会严格提取，并作为文本送入 Yosys 检查，不会执行模型返回的脚本或命令。

## 运行

不需要 API Key 即可手动候选运行完整闭环：

```powershell
python agents/optimization_loop.py run `
  --rtl benchmark/timing_adder.v `
  --candidate-rtl eda/experiments/sky130_optimize_20261027/timing_adder_blocked.v
```

这会先重新测量并证明指定起始 RTL，再以该实现为当前最佳评估手动候选。候选通过形式证明后才进行映射和 STA。候选在默认面积上限 110% 内、TNS 不回退且 WNS 严格改善时更新最佳索引。

常用选项：

```text
--rounds N             LLM 优化轮数（默认 1）
--max-candidates N     每轮最多生成并评估的候选数（默认 1）
--area-limit R         面积 / 当前最佳面积上限（默认 1.10）
--model MODEL_ID       必须显式指定的准确 API 模型 ID；也可配置 PIPEWEAVER_LLM_MODEL
--rtl PATH             起始 RTL（默认 benchmark/timing_adder.v）
--candidate-rtl PATH   手动候选模式，不调用 API；限单轮单候选
--timeout SECONDS      每个 Yosys/SMT/STA 工具的超时时间（默认 600）
```

汇总实验：

```powershell
python agents/optimization_loop.py summary --experiment-root eda/experiments/llm_loop_YYYYMMDD_HHMMSS_xxxxxx
```

每个循环目录包含 `best.json`、历史最佳 RTL 副本、起始 RTL、候选源码、`generation.json`、语法检查文件、形式/映射/STA 原始日志、`result.json` 和机器可读的汇总。API 未配置时，LLM 模式会明确失败并提示 `--candidate-rtl` 用法，不会生成伪造候选。

## 筛选规则与结果解释

候选必须与当前最佳在 `y` 上逐周期形式等价。面积不得超过当前最佳映射面积乘 `--area-limit`；TNS 不得相对当前最佳劣化（从零开始时不能引入负 TNS）；WNS 必须严格提高。若当前最佳已有负 TNS，报告仍保留负值，不能宣称时序违规已解决。相同 WNS 按平局拒绝并保留原最佳。被拒绝、语法失败、形式失败、超时及 API 失败的候选仍留有记录，不会更改 `best.json`。起始 RTL 也会先与原始 `benchmark/timing_adder.v` 证明后，才成为初始最佳。

当前有证据的基线 WNS 为 1.38 ns、TNS 0 ns、面积 4284.1088 µm²；8 位分组进位候选为 WNS 4.47 ns、TNS 0 ns、面积 4499.3152 µm²（面积约 +5.02%）。该候选仅在默认面积上限下有资格接受。它是当前 SKY130HD TT Liberty、固定 SDC 下的综合后布局布线前单元延迟结果，不代表芯片流片或布局布线后的性能。约束仍包含探索性输入/输出延迟和不确定度假设，复位路径被 false-path 排除。

## 排错

- `OPENAI_API_KEY is not configured`：设置当前 PowerShell 会话环境变量，或用 `--candidate-rtl`。
- `Yosys not found` / `SMTBMC` 缺失：安装项目现用 OSS CAD Suite，或分别设置 `YOSYS`、`SMTBMC`。
- WSL/OpenSTA 启动失败：确认 `wsl.exe -d Ubuntu` 可用、OpenSTA 路径存在，并检查访问权限；失败运行目录会保留真实错误和阶段日志。
- `No module timing_adder` 或端口校验失败：候选须保留原模块名、方向和端口宽度。
- 形式失败：候选保留在实验目录，且不会执行正式映射/STA，也不会更新最佳版本。
- 面积或 TNS 限制导致拒绝：检查 `result.json` 中 `acceptance_checks`，需要改变面积约束时显式传入 `--area-limit`；不能用更改 SDC 的方式制造收益。
