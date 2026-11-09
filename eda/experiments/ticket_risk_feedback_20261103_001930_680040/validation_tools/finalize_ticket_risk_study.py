"""Report the three-arm same-case development study without claiming holdout gains."""
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT=Path(r'D:\verilog_lab\PipeWeaver');E=ROOT/'eda/experiments'
S=E/'ticket_risk_feedback_20261103_001930_680040';HERE=Path(__file__).resolve().parent
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'summary.json');a=load(S/'AUDIT.json');replay=load(S/'REPRODUCTION.json')
assert a['passed'] and replay['passed'] and replay['planned_roles']==4
labels={'no_timing_feedback':'无反馈LLM','structured_timing_feedback':'原STA反馈','risk_aware_timing_feedback':'STA加路径竞争与成本指导'}
base=p['baseline_metrics'];groups=[];cases=[];duplicate_groups=defaultdict(list)
for r in s['results']:
    m=r.get('metrics') or {};ffs=None
    if m.get('status')=='PASS':
        cells=load(S/r['arm']/r['candidate_id']/'eda/mapped.json')['modules']['ticket_machine']['cells']
        ffs=sum('dfxtp' in c['type'] for c in cells.values())
        # Only report counted FF classes after confirming no other sequential cells.
        assert not any(re.search(r'__(?:df|sdff|dl)',c['type']) and 'dfxtp' not in c['type'] for c in cells.values())
        duplicate_groups[m['mapped_sha256']].append(r['arm']+'/'+r['candidate_id'])
    cases.append(dict(arm=r['arm'],candidate=r['candidate_id'],generation=r['status'],accepted=r['accepted'],metrics=m,mapped_ff_count=ffs,reason=r.get('reason')))
for arm,g in s['groups'].items():
    rows=[r for r in cases if r['arm']==arm];measured=[r for r in rows if r['metrics'].get('status')=='PASS'];m=g['selected_metrics']
    actual_rows=[r for r in s['results'] if r['arm']==arm]
    saved_responses=[load(path) for path in (S/arm).glob('candidate_*/api_audit/response.json')]
    groups.append(dict(arm=arm,attempted=5,returned=g['returned'],source_formal_pass=sum(r['metrics'].get('formal')=='PASS' for r in rows),
        mapped_formal_pass=sum(r['metrics'].get('mapped_formal')=='PASS' for r in rows),sta_complete=len(measured),
        area_eligible=sum(r['metrics']['mapped_area_um2']<=p['area_cap_um2'] for r in measured),valid_improvements=g['valid_improvements'],
        selected_origin=g['selected_origin'],selected_wns_ns=m['wns_ns'],selected_area_um2=m['mapped_area_um2'],
        selected_area_change_percent=100*(m['mapped_area_um2']/base['mapped_area_um2']-1),
        candidates_with_more_than_baseline_6_ff=sum(r['mapped_ff_count']>6 for r in measured),
        actual_mapped_ff_counts=[r['mapped_ff_count'] for r in measured],reported_tokens_for_successful_generations=g['reported_tokens'],
        tokens_from_all_saved_responses=sum(b.get('usage',{}).get('total_tokens',0) for b in saved_responses),
        recorded_generation_seconds=sum(r.get('seconds',0) for r in actual_rows),
        recorded_candidate_eda_seconds=sum(r['metrics'].get('elapsed_seconds',0) for r in actual_rows if r.get('metrics'))))
plain,sta,risk=[s['groups'][x]['selected_metrics']['wns_ns'] for x in p['arms']]
def compare(new,old,label):
    d=new-old
    if abs(d)<1e-9:return label+'的实际选择WNS相同。'
    return label+f'的实际选择WNS差为{d:+.2f}ns（前者减后者）。'
conclusions=[compare(risk,sta,'风险指导组与原STA组'),compare(risk,plain,'风险指导组与无反馈组')]
failures=[dict(call_index=r['call_index'],arm=r['arm'],candidate=r['candidate_id'],status=r['status'],error=r.get('error'),seconds=r.get('seconds')) for r in s['results'] if not r.get('candidate_sha256')]
lines=['# 三组状态机风险反馈：真实模型开发实验','',
'本轮15次请求计划已执行完毕；三个方法各5次，使用同一网关请求模型ID、同一冻结原始RTL和同一EDA接受规则。候选生成全部结束后才统一验证和测量，不补抽。','',
'这是根据前轮负结果及手工消融设计的同案例开发实验，不能当作独立测试集或预先提出机制的验证。原有两个提示与前轮逐字节相同；新组只在原STA提示上增加基线推导的路径竞争/成本信息和生成指导，未提供候选答案或候选实测结果。','',
'## 主结果','',
'原始WNS9.30ns、TNS0ns、面积252.7424 µm²、28单元。固定面积上限278.01664 µm²；主选择须完整证明/STA/电气检查通过，WNS严格改善、TNS不退化。WNS越大越好。','',
'| 方法 | 返回RTL/请求 | 源级/门级/STA通过 | 面积合格 | 有效改进/请求 | 实际选择WNS(ns) | 选择面积变化 | 新增FF候选数* |',
'|---|---:|---|---:|---:|---:|---:|---:|']
for g in groups:
    lines.append(f"| {labels[g['arm']]} | {g['returned']}/5 | {g['source_formal_pass']}/{g['mapped_formal_pass']}/{g['sta_complete']} | {g['area_eligible']} | {g['valid_improvements']}/5 | {g['selected_wns_ns']:.2f} | {g['selected_area_change_percent']:+.2f}% | {g['candidates_with_more_than_baseline_6_ff']} |")
lines += ['', '*新增FF按完整测量候选的实际映射触发器数大于基线6计数；这只是观察项，不是新组的额外筛选门槛。','']+conclusions+['',
'差异只适用于这15次请求和这个小型电路。无论哪个方法本轮更好，均不据此声称普遍优势或充分统计显著性；新反馈还同时包含信息结构与生成指导，不能分别归因。','',
'本轮三组有效改进均为0。新组4份已返回RTL中3份仍增加了bill相关寄存器并超出面积上限；可见解释准确复述了20.0192 µm²单FF成本和5.25504 µm²余量，但仍选择了实测不佳的动作。另一份保持6个FF、面积250.2400 µm²，WNS9.27ns也低于基线。风险信息被发送和复述，不等于形成了有效的搜索约束。','',
'这轮不支持继续声称“增加风险提示即可提升成功率”。建议停止在同一小FSM上继续堆提示和抽样；后续应把改写动作及不变量设计成可检查的约束，并在不同电路上冻结测试，避免继续用暴露案例作主要验证。此前无反馈最佳9.36ns和手工互补译码9.35ns仍是历史结果，不并入本轮新采样。','',
'## 全部候选','',
'| 方法 | 候选 | 返回状态 | 源级/门级/STA | WNS(ns) | 面积变化 | 实际FF | 有效改进 |',
'|---|---|---|---|---:|---:|---:|---|']
for r in cases:
    m=r['metrics'];w=m.get('wns_ns');area=m.get('mapped_area_um2')
    ws=f'{w:.2f}' if w is not None else '—';ar=f'{100*(area/base["mapped_area_um2"]-1):+.2f}%' if area is not None else '—'
    states='/'.join(m.get(k,'NOT_RUN') for k in ['formal','mapped_formal','ppa'])
    lines.append(f"| {labels[r['arm']]} | {r['candidate']} | {r['generation']} | {states} | {ws} | {ar} | {r['mapped_ff_count'] if r['mapped_ff_count'] is not None else '—'} | {'是' if r['accepted'] else '否'} |")
lines += ['', '## 生成失败与比较偏差','']
if failures:
    lines += ['本轮存在未返回RTL的槽位，以下失败均保留且未补抽。各组返回数或可测候选数不等时，最佳值比较受样本数影响，不能把通信问题算作结构优化能力差异；每5次请求的结果与每份已返回RTL的结果须分开解释。','']
    for f in failures:lines.append(f"- 请求{f['call_index']}，{labels[f['arm']]}，{f['status']}：{f['error']}")
else:lines += ['本轮所有请求均返回可解析RTL，未发生需要补抽的失败。']
lines += ['', '## 本轮实际开销','',
'| 方法 | 存档响应报告token | 生成累计秒数（含失败） | 候选EDA累计秒数 |',
'|---|---:|---:|---:|']
for g in groups:
    lines.append(f"| {labels[g['arm']]} | {g['tokens_from_all_saved_responses']} | {g['recorded_generation_seconds']:.1f} | {g['recorded_candidate_eda_seconds']:.1f} |")
lines += ['', '以上只是本轮日志记录，不是稳定吞吐或模型速度排名。组间生成失败数、返回数量和提示长度不同；未返回用量的请求费用未知。未把token当金额，也未把失败请求记为零费用。']
lines += ['', '## 新反馈实际增加了什么','',
'三条真实基线路径的到达/要求时间、原始6个FF、Liberty中单FF面积20.0192 µm²，以及新增同类FF后剩余5.25504 µm²的条件预算。若其余路径保持不变，只消除旧最坏路径，下一条已报告路径给出的全局WNS条件上界为9.38ns。以上不是对新RTL性能的预测，也不是一般时序上界。','',
'生成指导要求同时考虑新寄存器D端、状态转移路径、译码/缓冲面积及自动FSM重编码，允许模型选择有依据的新增寄存器。实际接受标准对三组相同，模型自述成本不代替真实测量。','',
'## 真实性与限制','',
f'- [实际请求/返回与EDA审计](AUDIT.json)：{a["check_count"]}项核对通过；[独立复跑](REPRODUCTION.json)：四个选择角色按同源码及同测量去重，实际复跑{replay["independent_eda_replays"]}次。三组本轮都保留同一基线，三份导出哈希相同，不算三个新结构。',
'- 实际请求逐份与冻结提示核对；返回RTL从保存的可见provider响应重新解析并核对哈希。信息已发送可证，模型内部推理不可由此证明。',
'- [冻结协议](protocol.json)、[风险特征](RISK_FEATURES.json)、[全部结构化结果](summary.json)、[候选清单](candidate_manifest.json)、[实际选择](selected/)。各组/候选保存api_audit与eda原始日志。',
f'- 存档响应provider报告的token总数为{a["provider_reported_tokens"]}；三组提示长度不同，不等token或等费用。无金额硬上限，未推算未知价格或失败请求费用。',
'- 同源码或网表重复情况记录在FINAL_EVIDENCE.json；抽样次数不等于独立结构数量。前轮与本轮采用不同机制/时间段，不能直接合并为同一成功率。',
'- 单个公开小型控制设计，非训练数据盲测；固定默认参数、启动同步clear一次及之后任意定义输入。理想时钟、TT布局布线前，不包含功耗、时钟树、寄生参数和物理签核。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
(S/'validation_tools').mkdir(exist_ok=True)
for src in [HERE/'reproduce_ticket_risk_study.py',HERE/'finalize_ticket_risk_study.py',E/'audit_ticket_risk_study.py',E/'audit_ticket_risk_preparation.py']:
    shutil.copyfile(src,S/'validation_tools'/src.name)
evidence=dict(status='COMPLETED_AUDITED_REPRODUCED',actual_request_slots=15,returned_rtl=sum(g['returned'] for g in groups),groups=groups,
    conclusions=conclusions,generation_failures=failures,duplicate_mapped_files=[dict(mapped_sha256=k,candidates=v) for k,v in duplicate_groups.items() if len(v)>1],
    audit_passed=True,audit_checks=a['check_count'],independent_replays=replay['independent_eda_replays'],deduplicated_reproduction_roles=replay['deduplicated_identical_roles'],replays_passed=True,provider_reported_tokens=a['provider_reported_tokens'],
    scope='Post-hoc same-case development; not independent holdout or statistical universal superiority.',
    hashes={n:sha(S/n) for n in ['protocol.json','AUTHORIZATION.json','candidate_manifest.json','summary.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']})
save(S/'FINAL_EVIDENCE.json',evidence);save(S/'STATUS.json',dict(state='COMPLETED_AUDITED_REPRODUCED',actual_model_requests=15,approved_maximum=15,remaining_authorized_requests=0))
entry='2026-11-03三组风险反馈真实模型实验完成：'+'；'.join(labels[g['arm']]+f"合格改进{g['valid_improvements']}/5、选择WNS{g['selected_wns_ns']:.2f}ns" for g in groups)+f'。15次限额已用完，审计及去重后{replay["independent_eda_replays"]}次独立复跑通过；同案例事后开发，不能称独立泛化验证。'
for path,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=path.read_text(encoding='utf-8')
    if '三组风险反馈真实模型实验完成：' not in text:
        pos=text.find('\n\n')+2;path.write_text(text[:pos]+entry+f' [全部证据]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
print(json.dumps({k:v for k,v in evidence.items() if k not in ['hashes','duplicate_mapped_files']},ensure_ascii=False,indent=2))
