"""Post-hoc deterministic policy replay using actual baseline STA endpoints; no API/EDA."""
from pathlib import Path
import json,re,hashlib
R=Path(r'D:\verilog_lab\PipeWeaver');S=R/'eda/experiments/dual_mux_mask_localization_20261105_134952_477600';FIRST=R/'eda/experiments/dual_mux_localization_20261105_134811_658238'
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def save(f,x):f.write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
p=load(S/'protocol.json');summary=load(S/'SUMMARY.json');assert load(S/'AUDIT.json')['passed']
def endpoint_rule(raw):
    match=re.search(r'Endpoint:\s*out_(left|right)\[\d+\]',raw)
    return 'rewrite_'+match.group(1) if match else 'baseline'
decisions=[]
for profile in p['profiles']:
    raw_path=S/'sta'/profile/'baseline/sta.log';raw=raw_path.read_text(encoding='utf-8')
    for policy,action in [('fixed_left','rewrite_left'),('fixed_right','rewrite_right'),('baseline_endpoint_rule',endpoint_rule(raw))]:
        assert sum(p['designs'][action])<=p['action_count_budget']
        decisions.append(dict(profile=profile,policy=policy,action=action,baseline_sta_sha256=sha(raw_path),scope='Native output endpoint identifies a known independent region in this constructed top. No exact mapped-gate/RTL-source trace.'))
# Freeze these post-hoc controller outputs before looking up candidate measurements.
decision_path=S/'POLICY_DECISIONS.json'
if decision_path.exists():assert load(decision_path)['decisions']==decisions
else:save(decision_path,dict(post_hoc=True,model_requests=0,decisions=decisions))
rows=[]
for choice in decisions:
    profile=choice['profile'];action=choice['action'];base=summary['timings'][profile]['baseline'];m=summary['timings'][profile][action]
    eligible=m['mapped_area_um2']<=summary['area_cap_um2'] and sum(p['designs'][action])<=1
    retained=m if eligible and m['max_data_arrival_ns']<base['max_data_arrival_ns'] else base
    rows.append(dict(**choice,raw_delay_ns=m['max_data_arrival_ns'],retained_delay_ns=retained['max_data_arrival_ns'],baseline_delay_ns=base['max_data_arrival_ns'],gain_percent=(1-retained['max_data_arrival_ns']/base['max_data_arrival_ns'])*100,area_um2=m['mapped_area_um2'],eligible=eligible))
counts={policy:sum(r['profile']!='balanced' and r['policy']==policy and r['gain_percent']>=5 for r in rows) for policy in ['fixed_left','fixed_right','baseline_endpoint_rule']}
save(S/'POLICY_REPLAY.json',dict(kind='POST_HOC_OFFLINE_COUNTERFACTUAL_POLICY_REPLAY',model_requests=0,new_eda_runs=0,decisions_sha256=sha(decision_path),late_profiles_at_least5pct_improvement_counts=counts,rows=rows,limitations='Only two symmetric constructed timing conditions, not independent benchmark samples. Full candidate pool measured for diagnostics, not charged as extra per-policy candidates. Each policy picks one region, original baseline fallback allowed. Constraints themselves may reveal correct choice. This is not a generic-LLM versus STA-LLM experiment.'))
lines=['# 本地定位流程验证：两轮开发完整记录','',
       '日期2026-11-05。本次没有调用API。第一轮与第二轮均完整保留，不只展示成功版本。', '',
       '| 开发轮次 | 改写动作 | 预算 | 关键路径是否随约束切换 | 是否获得预算内定位收益 |', '|---|---|---|---|---|',
       '| 第一轮 | 二进制选择树 | 面积上限原112% | 是 | 否；单处改写反而更慢，保留原始 |',
       '| 第二轮（根据第一轮结果调整） | 默认掩码化简 | 面积上限原110%且最多改一个区域 | 是 | 是；正确位置1.42→1.33ns，错误位置1.41ns |', '',
       '第二轮面积限制与动作次数限制是独立规则。该动作省面积；双区域版本也满足面积上限，但动作数2超过本实验预算，因此只列为更大预算诊断参照，不参与单动作选择。不是面积禁止所有双区域优化。', '',
       '| 第二轮约束 | 原始(ns) | 改左(ns) | 改右(ns) | 单处最优 |', '|---|---|---|---|---|']
for profile,pool in summary['timings'].items():lines.append(f"| {profile} | {pool['baseline']['max_data_arrival_ns']:.2f} | {pool['rewrite_left']['max_data_arrival_ns']:.2f} | {pool['rewrite_right']['max_data_arrival_ns']:.2f} | {summary['findings'][profile]['best']} |")
lines += ['', '第二轮左右较晚配置中，正确定位各降低0.09ns（6.34%），改错位置仅降低0.01ns；平衡配置两种局部改写都只有0.01ns收益（约0.98%），未达到预先使用的5%有效收益阈值。', '',
          '## 确认反馈被实际读取的规则回放', '',
          '另增加一个事后本地规则回放：直接读取原始sta.log的第一条Endpoint，out_left选左、out_right选右；不按profile名字判断、不查看候选PPA来决定动作。这里只能成立于构造电路的已知独立输出分区，不能称任意RTL定位器。动作选择先写入POLICY_DECISIONS.json，再查已测量候选结果，未新增EDA。', '',
          '| 策略 | 左晚延迟(ns) | 右晚延迟(ns) | 达到5%改进的晚到配置 |', '|---|---|---|---|']
for policy in counts:
    matches={r['profile']:r for r in rows if r['policy']==policy};lines.append(f"| {policy} | {matches['left_late']['retained_delay_ns']:.2f} | {matches['right_late']['retained_delay_ns']:.2f} | {counts[policy]}/2 |")
lines += ['',
          '这证明实际STA端点能驱动当前构造电路的局部位置选择，以及选对位置确实影响延迟。但策略比较是事后离线回放，没有模型请求；两个配置来自同一对称设计，不提供统计独立性。完整约束本身也可能让无STA模型直接判断答案，因此本结果不能当成第三个STA组胜出案例，现阶段不值得仅为这个简单对称例子购买模型样本。', '',
          '后续应先准备非对称、多个路径竞争的实例，并确认固定位置/直接读约束的简单规则不已解决问题。模型对照必须保持完整约束、候选次数、改写次数和面积规则一致。', '',
          '两轮合计：8个设计实例各完成源级、映射后等价验证与统一映射；24个配置STA；4次独立STA复跑。两轮各79项审计通过。这些是同家族开发和复用网表测量，不是8个新RTL家族或32个模型样本。', '',
          f'第一轮完整失败证据：[报告](../{FIRST.name}/INTERPRETATION.md)。第二轮：[完整报告](INTERPRETATION.md)、[冻结协议](protocol.json)、[实际规则选择](POLICY_DECISIONS.json)、[离线回放结果](POLICY_REPLAY.json)、[审计](AUDIT.json)、[STA复跑](REPRODUCTION.json)。原始STA日志在sta/与independent_sta_replay/。', '',
          '固定TT库、理想时钟、固定IO转换/负载，未按输入延迟重新映射、没有布线寄生或物理签核结论。']
(S/'DEVELOPMENT_SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
e=load(S/'FINAL_EVIDENCE.json')
for f in ['POLICY_DECISIONS.json','POLICY_REPLAY.json','DEVELOPMENT_SUMMARY.md']:e['hashes'][f]=sha(S/f)
e['policy_replay_scope']='Post-hoc, zero new API/EDA, deterministic baseline-endpoint rule, not a model comparison.';save(S/'FINAL_EVIDENCE.json',e)
assert all(sha(S/f)==h for f,h in e['hashes'].items())
rel=str(S.relative_to(R)).replace('\\','/')
for file,prefix in [(R/'EXPERIMENT_INDEX.md',''),(R/'docs/CURRENT_STATUS.md','../')]:
    text=file.read_text(encoding='utf-8');entry='2026-11-05定位开发结论：首轮失败保留，第二轮在单区域动作预算下验证正确位置1.42→1.33ns、错误位置1.41ns；真实STA端点规则离线回放在两晚到配置取得2/2有效改进，固定左右各1/2。对称构造与事后回放不能证明LLM/STA优势，不计新胜出。零API。 [两轮完整记录]('+prefix+rel+'/DEVELOPMENT_SUMMARY.md)。\n\n'
    if entry not in text:file.write_text(entry+text,encoding='utf-8')
print(json.dumps(counts));print('Two-phase development summary and all evidence hashes saved:',S/'DEVELOPMENT_SUMMARY.md')
