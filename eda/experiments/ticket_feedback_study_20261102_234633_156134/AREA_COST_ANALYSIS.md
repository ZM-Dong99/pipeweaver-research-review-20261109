# 面积超限定位：实际工艺单元分解

所有面积由mapped.json的真实实例数乘以同一Liberty单元面积求和，与EDA报告总面积核对一致。该分析在结果之后进行，不修改原10%面积约束或选择。

| 版本 | WNS ns | 时序单元数 | 时序单元面积 | buffer/inverter面积 | 其他组合面积 | 总面积 |
|---|---:|---:|---:|---:|---:|---:|
| baseline | 9.30 | 6 | 120.1152 | 7.5072 | 125.1200 | 252.7424 |
| no_timing_feedback/candidate_01 | 9.29 | 6 | 120.1152 | 15.0144 | 121.3664 | 256.4960 |
| structured_timing_feedback/candidate_01 | 8.79 | 7 | 140.1344 | 48.7968 | 286.5248 | 475.4560 |
| structured_timing_feedback/candidate_02 | 8.79 | 7 | 140.1344 | 48.7968 | 286.5248 | 475.4560 |
| no_timing_feedback/candidate_02 | 9.29 | 6 | 120.1152 | 15.0144 | 121.3664 | 256.4960 |
| no_timing_feedback/candidate_03 | 9.29 | 6 | 120.1152 | 15.0144 | 121.3664 | 256.4960 |
| structured_timing_feedback/candidate_03 | 9.22 | 7 | 140.1344 | 33.7824 | 147.6416 | 321.5584 |
| structured_timing_feedback/candidate_04 | 9.22 | 7 | 140.1344 | 41.2896 | 143.8880 | 325.3120 |
| no_timing_feedback/candidate_04 | 9.29 | 6 | 120.1152 | 15.0144 | 121.3664 | 256.4960 |
| no_timing_feedback/candidate_05 | 9.36 | 6 | 120.1152 | 11.2608 | 127.6224 | 258.9984 |
| structured_timing_feedback/candidate_05 | 9.22 | 7 | 140.1344 | 33.7824 | 152.6464 | 326.5632 |

分类依据Liberty中的ff/latch组及buffer/inverter单元名；不推断RTL哪一行造成了面积，不把buffer面积当功耗。每个候选新增最多的单元面积贡献在AREA_COST_ANALYSIS.json保留。

这些数据用于设计后续受约束改写策略。不能根据本轮结果事后放宽面积上限或补挑候选，不能将手工开发正例当成新的独立对照组。
