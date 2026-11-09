# 项目现有 EDA 工具与启用方式

2026-10-31 检查发现 `D:\oss-cad-suite`（套件标记20260829）已包含多个此前未被项目入口识别的工具。本次没有下载或重新安装软件，也未改系统 PATH、套件文件或旧冻结实验。

| 工具 | 用途 | 本轮验证 |
|---|---|---|
| Verilator 5.051 devel | RTL 静态检查，可扩展为 C++ 仿真 | 正确 RTL 检查通过；语法错误被拒绝。尚未验证 C++ 编译仿真链 |
| SymbiYosys / SBY v0.68 + Z3 4.15.5 | 管理形式证明任务、生成反例 | 正确计数器性质归纳证明 PASS；错误性质 FAIL 并生成轨迹 |
| Slang 11.0.448 | SystemVerilog 解析与展开 | 原生 mux_encode 数组端口解析展开通过；不等于该模块已完成映射或 PPA |
| EQY | 等价验证任务管理 | 版本命令通过，尚未跑 EQY 等价任务 |
| GTKWave | 打开 VCD/FST 波形定位反例 | 文件已发现，未自动打开 GUI或验证显示 |
| Yosys / OpenSTA | 综合映射、静态时序分析 | 继续沿用现有实验后端；OpenSTA 位于 WSL |

Verilator 的现有二进制直接运行时会查找构建机器上的 `/yosyshq/...` 路径。本次启用脚本显式设置 `VERILATOR_ROOT` 为本机套件目录，实际 lint 已通过。工具发现脚本现已能自动识别默认套件目录，不再简单把未配置PATH的工具报告成未安装。

PowerShell 在项目根目录运行：

```powershell
. .\eda\activate_tools.ps1
python -B eda/check_tools.py
verilator_bin --lint-only --top-module minimal_and tests/minimal.v
```

启用只影响当前 PowerShell 会话。无需管理员权限，无需重装套件。GTKWave 可在需要查看反例时手动运行，例如 `gtkwave <反例.vcd>`；本次没有启动可见窗口。

验证日志和结果位于 `eda/experiments/extra_tools_readiness_20261031/`，10项检查全部符合预期。`correct_proof/` 为 SBY 正例，`wrong_proof/` 为故意失败的性质及实际反例。重跑需指定新目录：

```powershell
python -B eda/experiments/check_extra_tools.py --out eda/experiments/my_new_tool_check
```

这批工具补充了 lint、任务式形式证明、现代 SystemVerilog 前端和波形查看入口。它们尚未全部接入默认优化循环，不代表异步复位、多时钟或通用时序等价已解决。下一步应围绕选定电路使用这些能力，Slang 前端若进入评估器，应另立协议统一验证基线和候选，不能改写旧实验成绩。

官方资料：[SBY安装与套件组成](https://symbiyosys.readthedocs.io/en/latest/install.html)、[SBY证明引擎和求解器](https://symbiyosys.readthedocs.io/en/latest/reference.html)、[Verilator安装说明](https://verilator.org/guide/latest/install.html)。
