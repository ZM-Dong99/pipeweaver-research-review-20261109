# 两个自然流模块：真实模型对照结果

用户明确授权的12个槽位已全部执行，无重试或补抽。全部生成先冻结，再进行候选EDA；同案例同RTL哈希复用一次EDA，所有请求仍在分母中。

| 模块 | 条件 | 返回RTL/尝试 | 源级通过 | 门级通过 | 合格改善 | 保留后中位WNS ns | 最佳保留WNS ns |
|---|---|---:|---:|---:|---:|---:|---:|
| axis_adapter | no_sta | 1/3 | 1/3 | 1/3 | 0/3 | 8.87 | 8.87 |
| axis_adapter | sta | 0/3 | 0/3 | 0/3 | 0/3 | 8.87 | 8.87 |
| axis_register | no_sta | 1/3 | 1/3 | 1/3 | 0/3 | 8.71 | 8.71 |
| axis_register | sta | 1/3 | 1/3 | 1/3 | 0/3 | 8.71 | 8.71 |

WNS越大越好。主指标是各模块全3次尝试保留后的中位WNS，最佳一次仅作辅助，不取代主指标。

| 请求 | 模块 | 条件 | 生成/验证 | 原始候选WNS ns | 原始面积µm² | 实际选择 | 保留WNS ns |
|---|---|---|---|---:|---:|---|---:|
| 1 | adapter | no_sta | GENERATED/PASS | 8.87 | 2574.9696 | baseline | 8.87 |
| 2 | adapter | sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.87 |
| 3 | skid | sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.71 |
| 4 | skid | no_sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.71 |
| 5 | adapter | sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.87 |
| 6 | adapter | no_sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.87 |
| 7 | skid | no_sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.71 |
| 8 | skid | sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.71 |
| 9 | adapter | no_sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.87 |
| 10 | adapter | sta | FAILED_GENERATION/未运行 | — | — | baseline | 8.87 |
| 11 | skid | sta | GENERATED/PASS | 8.71 | 3564.6688 | baseline | 8.71 |
| 12 | skid | no_sta | GENERATED/PASS | 8.71 | 3564.6688 | baseline | 8.71 |

## 通信因素与条件统计

| 模块 | 条件 | 成功返回RTL数 | 成功返回子集保留后中位WNS ns |
|---|---|---:|---:|
| axis_adapter | no_sta | 1 | 8.87 |
| axis_adapter | sta | 0 | 不可计算 |
| axis_register | no_sta | 1 | 8.71 |
| axis_register | sta | 1 | 8.71 |

这些成功返回条件统计只是通信敏感性描述，不替代包含全部失败的主结果。无返回不能判断RTL质量；有效样本过少或组间返回不等时，不能据主结果推断STA的因果收益。

| 请求 | HTTP | curl退出码 | 记录耗时秒 | 客户端超时 |
|---|---:|---:|---:|---|
| 1 | 200 | 0 | 79.69798 | False |
| 2 | 524 | 0 | 126.214091 | False |
| 3 | 524 | 0 | 125.519579 | False |
| 4 | 524 | 0 | 126.49541 | False |
| 5 | 524 | 0 | 126.252633 | False |
| 6 | 0 | 56 | 107.441625 | False |
| 7 | 0 | 35 | 5.081657 | False |
| 8 | 524 | 0 | 128.643881 | False |
| 9 | 0 | 56 | 136.203862 | False |
| 10 | 524 | 0 | 127.340107 | False |
| 11 | 200 | 0 | 66.464737 | False |
| 12 | 200 | 0 | 75.271882 | False |

## 契约、失败与限制

首个采样点同步复位，此后输入和复位任意；ready/valid逐拍比较，输出valid时比较边带和keep，data只比较有效keep字节。源级、综合和门级证明均移除声明初值，不依赖上电数据。不是旧的所有引脚每周期相等，也不是完整AXI规范证明。

两组共享固定原始RTL、参数、10ns时钟、TT库、零外部IO延迟、0.10ns输入转换、0.010pF负载、无init综合/使能展开映射和110%基线面积上限。STA组只追加原始基线路径。基线adapter WNS8.87ns/面积2574.9696，skid WNS8.71ns/面积3564.6688。

辅助状态关系失败不等于接口错误：再做接口专用证明。INCOMPLETE/超时不能算已证明错误，也不能算通过；均回退基线。两案例来自同一公开仓库且已用于契约开发，每格3次，不是盲测、统计显著性或跨模型普遍优势证明。

本轮保存3份供应商响应、3份用量记录，共报告23096tokens。分项用量不相加的请求编号：[1, 11, 12]。这些不是独立核实账单，不推算金额。请求模型ID为gpt-6.1-sol，第三方网关后端身份未独立验证。

实际唯一候选EDA数：3；独立重复核查另列，不作为新模型样本。证据核对124项，通过=True。

请求2：LLM API returned HTTP 524

请求3：LLM API returned HTTP 524

请求4：LLM API returned HTTP 524

请求5：LLM API returned HTTP 524

请求6：curl transport failed (exit 56); no automatic retry

请求7：curl transport failed (exit 35); no automatic retry

请求8：LLM API returned HTTP 524

请求9：curl transport failed (exit 56); no automatic retry

请求10：LLM API returned HTTP 524
