# 12次真实API实验已完成

本轮12次尝试、11次有效返回、1次连接失败；无重试或补抽。12个候选参数配置的源级/映射后等价证明与STA通过；289项审计、3个去重案例独立复跑一致。

64位STA组保留后延迟中位数1.10ns，无STA组1.73ns；无STA含一次网络失败，样本过小，不证明STA因果优势。固定8位分组也取得1.10ns，尚无相对固定策略优势。128位两组均1.41ns。

详见[全部结果与限制](INTERPRETATION.md)、[汇总](summary.json)、[审计](AUDIT.json)、[独立复跑](REPRODUCTION.json)。全部请求和真实返回保存在各trial的api_audit/。初始待授权状态保存在README_PREPARATION.md，审计器修正前记录也保留。
