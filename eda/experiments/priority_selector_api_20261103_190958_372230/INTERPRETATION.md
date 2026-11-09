# 真实模型受限动作选择：12次请求结果

两种位宽、两种提示条件，每格3次独立请求，每次只选1个动作。所有选择冻结后才测量候选。原始设计始终作为回退；面积上限为原始的110%，这是实验约束，不是工程通用要求。

| 位宽 | 条件 | 有效选择/尝试 | 合格改进 | 延迟中位数(ns) | 各次保留后延迟(ns) |
|---|---|---|---|---|---|
| 64 | no_sta | 2/3 | 1/3 | 1.73 | [1.73, 1.73, 1.1] |
| 64 | sta | 3/3 | 2/3 | 1.10 | [1.1, 1.1, 1.73] |
| 128 | no_sta | 3/3 | 3/3 | 1.41 | [1.41, 1.41, 1.41] |
| 128 | sta | 3/3 | 3/3 | 1.41 | [1.41, 1.41, 1.41] |

## 所有请求

| 请求 | 位宽 | 条件 | 状态 | 选择动作 | 最终采用 | 延迟(ns) | 面积(µm²) |
|---|---|---|---|---|---|---|---|
| 1 | 64 | no_sta | SELECTED | group_factored_16 | baseline | 1.73 | 1557.7440 |
| 2 | 64 | sta | SELECTED | group_factored_8 | group_factored_8 | 1.10 | 1636.5696 |
| 7 | 64 | sta | SELECTED | group_factored_8 | group_factored_8 | 1.10 | 1636.5696 |
| 8 | 64 | no_sta | FAILED_SELECTION | 无 | baseline | 1.73 | 1557.7440 |

请求8失败记录：curl transport failed (exit 56); no automatic retry

| 9 | 64 | no_sta | SELECTED | group_factored_8 | group_factored_8 | 1.10 | 1636.5696 |
| 10 | 64 | sta | SELECTED | group_factored_16 | baseline | 1.73 | 1557.7440 |
| 3 | 128 | no_sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |
| 4 | 128 | sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |
| 5 | 128 | sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |
| 6 | 128 | no_sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |
| 11 | 128 | no_sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |
| 12 | 128 | sta | SELECTED | group_factored_16 | group_factored_16 | 1.41 | 4052.6368 |

## 固定策略与完整枚举参照

| 位宽 | 参照 | 最终采用 | 延迟(ns) | 面积(µm²) |
|---|---|---|---|---|
| 64 | 原始 | baseline | 1.73 | 1557.7440 |
| 64 | 预定static16 | baseline | 1.73 | 1557.7440 |
| 64 | 预定static8 | group_factored_8 | 1.10 | 1636.5696 |
| 64 | 六动作枚举（更大预算） | group_factored_8 | 1.10 | 1636.5696 |
| 128 | 原始 | baseline | 2.23 | 4267.8432 |
| 128 | 预定static16 | group_factored_16 | 1.41 | 4052.6368 |
| 128 | 预定static8 | group_factored_8 | 1.47 | 3301.9168 |
| 128 | 六动作枚举（更大预算） | group_factored_16 | 1.41 | 4052.6368 |

## 全部候选及面积淘汰

| 位宽 | 动作 | 延迟(ns) | 面积变化 | 预算内 |
|---|---|---|---|---|
| 64 | group_factored_8 | 1.10 | +5.06% | 是 |
| 64 | group_factored_16 | 1.23 | +49.96% | 否 |
| 64 | group_factored_32 | 1.27 | +57.51% | 否 |
| 64 | global_onehot_8 | 1.09 | +32.13% | 否 |
| 64 | global_onehot_16 | 1.14 | +37.75% | 否 |
| 64 | global_onehot_32 | 1.17 | +38.55% | 否 |
| 128 | group_factored_8 | 1.47 | -22.63% | 是 |
| 128 | group_factored_16 | 1.41 | -5.04% | 是 |
| 128 | group_factored_32 | 1.43 | +2.46% | 是 |
| 128 | global_onehot_8 | 1.54 | +3.05% | 是 |
| 128 | global_onehot_16 | 1.55 | +2.43% | 是 |
| 128 | global_onehot_32 | 1.50 | +16.92% | 否 |

## 网络失败的影响与可支持结论

64位无STA组含1次连接失败，失败按预定规则回退原始设计。成功返回的条件统计另列如下，不能删除失败后替代主结果。

| 位宽 | 条件 | 成功返回数 | 成功返回中的合格改进数 | 成功返回后的延迟中位数(ns) |
|---|---|---|---|---|
| 64 | no_sta | 2 | 1 | 1.415 |
| 64 | sta | 3 | 2 | 1.1 |
| 128 | no_sta | 3 | 3 | 1.41 |
| 128 | sta | 3 | 3 | 1.41 |

64位的8位分组动作把延迟从1.73ns降至1.10ns（-36.42%），面积增加5.06%，所有输出的源级和映射后等价证明通过。16位分组虽然延迟降到1.23ns，但面积增加约49.96%，超过预算，因此选择该动作时最终回退基线。这说明本实例选动作时必须同时考虑映射成本。

本轮64位STA组主指标更好，但仅3次/组，且无STA组多一次网络失败；无法证明因果优势。预先指定的固定8位分组每次都可取得1.10ns，优于本轮STA组最差试次，所以尚未证明模型或STA反馈优于简单固定策略。128位两组全部选择16位分组，结果完全相同。

首轮审计按列表位置错误配对请求与按位宽重排的汇总，出现8项不匹配；原失败记录保存在AUDIT_BEFORE_ID_ALIGNMENT_FIX.json和audit_before_id_alignment_fix.py。仅审计器改为按唯一call_index配对并增加身份检查，原始返回、测量、协议和主统计均未修改。

## 解释范围与证据

64位是本次主要实例，候选PPA在选择冻结之后测量；128位已用于动作开发，仅作已暴露案例重复。两位宽仍属同一电路家族，每格仅3次，不作统计普遍性或跨电路泛化结论。相同动作复用同一PPA测量，不视为独立RTL样本。

此处模型只选择注册动作，确定性改写器生成RTL；不是自由代码生成对照。六动作枚举使用更大候选预算，不能作为单候选模型的公平胜负参照。原始STA反馈进入请求可由request.json核查，无法从返回解释证明模型内部如何利用信息。

本轮使用第三方网关请求模型gpt-6.1-sol，无法独立验证后端身份。无自动重试或补抽。provider报告的token总数：34871；没有可靠单价，未编造费用。

审计289项通过；独立本地复跑3个去重案例通过。复跑不是新模型请求。性能为固定TT库与IO约束的布局布线前估计，不是芯片签核或实测频率。

原始证据：protocol.json、AUTHORIZATION.json、selection_manifest.json、各trial的api_audit/request.json和response.json、generation.json、各evaluations的formal.log/mapped_formal.log/sta.log/mapping.log、summary.json、AUDIT.json、REPRODUCTION.json。
