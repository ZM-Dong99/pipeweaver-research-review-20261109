# 定位研究当前入口

2026-11-06真实模型对照已完成：[12次完整结果](eda/experiments/localization_selection_api_20261106/RESULT_SUMMARY.md)。12次均返回，无重试。严格解析误拒6份前导包装响应；全量统一兼容回放后STA选对6/6、无STA5/6，两场景中位延迟均持平，固定STA端点规则也全部最优。原严格成绩与事后格式回放分别保存，不能将表面格式优势报告成模型定位优势；本批额度已用完。

2026-11-06：已整理[全项目成果总账](PROJECT_SUMMARY_20261106.md)，并生成[下一轮两配置、拟12槽位的提示与协议](eda/experiments/localization_selection_preparation_20261106/README.md)。设计准备检查通过，零新模型请求；执行器验收与新批次授权仍待完成。后续只推进这项定位对照。

最新跟进2026-11-05：已完成非对称mux+优先编码器的本地开发与映射边界对照，零新API。分块固定映射下最优区域会随约束改变；扁平综合下定位假设未成立，两者分别保留。

[完整跟进与全部失败记录](eda/experiments/mixed_block_mapping_20261105_142005_822258/FOLLOWUP_SUMMARY.md)

[分块条件原始证据](eda/experiments/mixed_block_mapping_20261105_142005_822258/INTERPRETATION.md)

[扁平条件反例](eda/experiments/mixed_localization_20261105_141351_477871/INTERPRETATION.md)

[工具隔离修复、历史日志核对和四项真实回归](eda/experiments/tool_isolation_fix_20261105_141047_548029/INTERPRETATION.md)

尚未进行这套新定位任务的真实LLM分组，不能记作新的STA组胜出案例。
