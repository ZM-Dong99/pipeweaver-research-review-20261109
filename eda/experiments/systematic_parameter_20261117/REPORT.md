# 参数规模实验

本轮模型调用名称为 `gpt-6.1-sol`。9个参数实例来自ALU、优先编码器、CRC三类电路，每个实例的两组各安排3次单次调用。失败和无改进时保留原始RTL，所有中位数按计划槽位计算。

54个计划槽位中实际调用 54 次，API尝试标记 54 份，返回RTL 53 份。不同源码哈希 53 个，不同实例与源码哈希组合 53 个。

满足源级、映射后等价、STA、电气、定义性、面积与TNS约束的候选 49 份，有效时序优化 47 份。失败分布为 `{"FORMAT": 1, "VALIDATION_frontend": 1, "AREA_LIMIT": 2, "VALIDATION_formal": 1, "NO_TIMING_GAIN": 2}`。

新增可见响应ID 54 个，与前期去重合并后为 421 个。实际费用待账单核算。

已报告总token为 339,957，用量未知记录 0 份。生成失败路径的已知用量及生成时间仍保存在逐次记录中。

## 各规模的STA组结果

| 实例 | 合格/计划 | 改进/计划 | 原始延迟 ns | 中位保留延迟 ns | 中位收益 | 最好收益 | 最好候选面积变化 |
|---|---:|---:|---:|---:|---:|---:|---:|
| alu16 | 2/3 | 2/3 | 1.96 | 1.680 | 14.29% | 23.98% | +1.43% |
| alu32 | 3/3 | 3/3 | 2.49 | 1.680 | 32.53% | 32.53% | -0.29% |
| alu64 | 2/3 | 2/3 | 3.00 | 1.880 | 37.33% | 38.00% | -2.70% |
| priority64 | 2/3 | 2/3 | 1.73 | 1.210 | 30.06% | 34.68% | +6.35% |
| priority128 | 3/3 | 3/3 | 2.23 | 1.500 | 32.74% | 34.53% | -17.88% |
| priority256 | 3/3 | 3/3 | 2.60 | 1.480 | 43.08% | 43.85% | +5.59% |
| crc32_d4 | 2/3 | 1/3 | 0.82 | 0.820 | 0.00% | 14.63% | -31.73% |
| crc32_d8 | 3/3 | 3/3 | 0.97 | 0.950 | 2.06% | 10.31% | -43.37% |
| crc32_d16 | 3/3 | 3/3 | 1.06 | 1.040 | 1.89% | 2.83% | -53.43% |

## 完整组别与候选归属

| 实例 | 策略 | 实际/计划 | 合格/计划 | 改进/计划 | 中位保留收益 | 最好候选 |
|---|---|---:|---:|---:|---:|---|
| alu16 | direct | 3/3 | 3/3 | 3/3 | 27.04% | [request_043](calls/request_043/RESULT.json) |
| alu16 | sta | 3/3 | 2/3 | 2/3 | 14.29% | [request_051](calls/request_051/RESULT.json) |
| alu32 | direct | 3/3 | 3/3 | 3/3 | 20.88% | [request_046](calls/request_046/RESULT.json) |
| alu32 | sta | 3/3 | 3/3 | 3/3 | 32.53% | [request_015](calls/request_015/RESULT.json) |
| alu64 | direct | 3/3 | 3/3 | 3/3 | 24.67% | [request_052](calls/request_052/RESULT.json) |
| alu64 | sta | 3/3 | 2/3 | 2/3 | 37.33% | [request_013](calls/request_013/RESULT.json) |
| priority64 | direct | 3/3 | 3/3 | 3/3 | 33.53% | [request_037](calls/request_037/RESULT.json) |
| priority64 | sta | 3/3 | 2/3 | 2/3 | 30.06% | [request_033](calls/request_033/RESULT.json) |
| priority128 | direct | 3/3 | 3/3 | 3/3 | 35.87% | [request_045](calls/request_045/RESULT.json) |
| priority128 | sta | 3/3 | 3/3 | 3/3 | 32.74% | [request_006](calls/request_006/RESULT.json) |
| priority256 | direct | 3/3 | 3/3 | 3/3 | 43.85% | [request_001](calls/request_001/RESULT.json) |
| priority256 | sta | 3/3 | 3/3 | 3/3 | 43.08% | [request_004](calls/request_004/RESULT.json) |
| crc32_d4 | direct | 3/3 | 3/3 | 3/3 | 9.76% | [request_034](calls/request_034/RESULT.json) |
| crc32_d4 | sta | 3/3 | 2/3 | 1/3 | 0.00% | [request_011](calls/request_011/RESULT.json) |
| crc32_d8 | direct | 3/3 | 3/3 | 3/3 | 13.40% | [request_014](calls/request_014/RESULT.json) |
| crc32_d8 | sta | 3/3 | 3/3 | 3/3 | 2.06% | [request_026](calls/request_026/RESULT.json) |
| crc32_d16 | direct | 3/3 | 2/3 | 1/3 | 0.00% | [request_035](calls/request_035/RESULT.json) |
| crc32_d16 | sta | 3/3 | 3/3 | 3/3 | 1.89% | [request_012](calls/request_012/RESULT.json) |

## 未获得有效优化的记录

| 请求 | 实例 | 策略 | 原因 | 实际反例 | 证明超时 |
|---|---|---|---|---|---|
| request_003 | alu16 | sta | FORMAT | — | — |
| request_008 | crc32_d16 | direct | VALIDATION_frontend | — | — |
| request_016 | priority64 | sta | AREA_LIMIT | — | — |
| request_031 | crc32_d4 | sta | VALIDATION_formal | 有 | — |
| request_038 | alu64 | sta | AREA_LIMIT | — | — |
| request_039 | crc32_d16 | direct | NO_TIMING_GAIN | — | — |
| request_044 | crc32_d4 | sta | NO_TIMING_GAIN | — | — |

## 预先记录的路由评估

规则在进入后两轮留出数据前冻结。各实例用第1轮两组结果选择保留延迟较小的提示策略，相等时选择直接提示，再在第2、3轮相同实例上核对。每种策略最多18个配对结果，按每次调用保留的归一化时序收益统计。

| 策略 | 完成配对数 | 有效优化数 | 平均保留收益 | 中位保留收益 | 已报告token |
|---|---:|---:|---:|---:|---:|
| router | 18/18 | 15 | 21.36% | 26.28% | 117780 |
| direct | 18/18 | 17 | 24.63% | 26.62% | 97389 |
| sta | 18/18 | 15 | 19.70% | 20.02% | 128830 |

训练阶段另有 18 次调用，已报告 113,738 token，用量未知 0 份。留出阶段的选择结果与训练成本分别记录，研究实际总调用数为 54 次。


## 范围与后续

本轮为三个电路家族的参数对照，每个参数每组3次。宽度之间共享结构和源码，当前结果用于描述规模趋势及提示策略的适用边界。路由评估针对这些已测实例，跨电路泛化、较多重复次数及实际端到端效率仍需继续验证。

协议、逐次提示、API响应、生成RTL、源级与映射后证明、STA、电气及定义性检查位于仓库 `eda/experiments/systematic_parameter_20261117/`。其中 `ANALYSIS.json` 保存候选归属、全部分组及路由配对结果。
