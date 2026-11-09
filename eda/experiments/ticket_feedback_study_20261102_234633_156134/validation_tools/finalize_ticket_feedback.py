"""Publish descriptive measured results only after audit and independent replay."""
from collections import defaultdict
import difflib
import hashlib
import json
from pathlib import Path
import shutil

ROOT=Path(r'D:\verilog_lab\PipeWeaver'); E=ROOT/'eda/experiments';S=E/'ticket_feedback_study_20261102_234633_156134'
HERE=Path(__file__).resolve().parent
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'summary.json');a=load(S/'AUDIT.json');replay=load(S/'REPRODUCTION.json')
assert a['passed'] and replay['passed']
base=p['baseline_metrics'];groups=[];duplicates={}
labels={'no_timing_feedback':'无时序反馈','structured_timing_feedback':'结构化STA反馈'}
for arm,g in s['groups'].items():
    rows=[r for r in s['results'] if r['arm']==arm];m=g['selected_metrics']
    measured=[r for r in rows if r.get('metrics',{} ) and r['metrics'].get('status')=='PASS']
    groups.append(dict(arm=arm,scheduled=g['scheduled'],returned=g['returned'],
                       source_formal_pass=sum(r.get('metrics',{}).get('formal')=='PASS' for r in rows if r.get('metrics')),
                       mapped_formal_pass=sum(r.get('metrics',{}).get('mapped_formal')=='PASS' for r in rows if r.get('metrics')),
                       sta_complete=len(measured),area_eligible=sum(r['metrics']['mapped_area_um2']<=p['area_cap_um2'] for r in measured),
                       valid_improvements=g['valid_improvements'],selected_origin=g['selected_origin'],wns_ns=m['wns_ns'],
                       mapped_area_um2=m['mapped_area_um2'],area_change_percent=100*(m['mapped_area_um2']/base['mapped_area_um2']-1),
                       reported_tokens=g['reported_tokens']))
    bucket=defaultdict(list)
    for r in measured:bucket[r['metrics']['mapped_sha256']].append(r['candidate_id'])
    duplicates[arm]=[dict(mapped_sha256=k,candidates=v) for k,v in bucket.items() if len(v)>1]
    old=(S/'inputs/original.v').read_text(encoding='utf-8').splitlines(keepends=True)
    new=(S/'selected'/arm/'ticket_machine.v').read_text(encoding='utf-8').splitlines(keepends=True)
    (S/'selected'/arm/'rewrite.diff').write_text(''.join(difflib.unified_diff(old,new,fromfile='original.v',tofile='selected.v')),encoding='utf-8')
common=[]
for arm in s['groups']:
    g=s['groups'][arm];m=g['selected_metrics']
    common.append(f"{labels[arm]}合格改进{g['valid_improvements']}/5、选择WNS{m['wns_ns']:.2f}ns")
lines=['# 小型售票状态机：真实模型对照结果','',
'本轮已完成用户授权的最多10次请求计划、全部候选评估、证据核对及实际选择的独立复跑。原始RTL为135行（含注释和空行），映射后28个单元，是小型六状态控制电路，不是大型工程验证。','',
'## 主结果','',
'固定10ns时钟，WNS越大越好。主结果须源级/门级证明、STA及电气检查通过，面积≤278.01664 µm²且TNS不退化；未找到严格WNS改进则保留原始RTL。原始WNS9.30ns、TNS0ns、面积252.7424 µm²。','',
'| 方法 | 返回RTL/请求 | 源级/门级/STA通过 | 面积合格 | 有效改进/请求 | 实际选择WNS(ns) | 选择面积变化 |',
'|---|---:|---|---:|---:|---:|---:|']
for g in groups:
    lines.append(f"| {labels[g['arm']]} | {g['returned']}/5 | {g['source_formal_pass']}/{g['mapped_formal_pass']}/{g['sta_complete']} | {g['area_eligible']} | {g['valid_improvements']}/5 | {g['wns_ns']:.2f} | {g['area_change_percent']:+.2f}% |")
delta=s['groups']['structured_timing_feedback']['selected_metrics']['wns_ns']-s['groups']['no_timing_feedback']['selected_metrics']['wns_ns']
if abs(delta)<1e-9:conclusion='两组实际选择的WNS相同，本轮没有观察到反馈组的最佳时序优势。'
elif delta>0:conclusion=f'本轮反馈组实际选择WNS高出无反馈组{delta:.2f}ns；只适用于这个固定实验，不证明一般优势。'
else:conclusion=f'本轮无反馈组实际选择WNS高出反馈组{-delta:.2f}ns；这项结果同样保留，不改评价规则。'
lines += ['',conclusion,'',
'## 失败原因：反馈引导了动作，但动作没有改善全局时序','',
'反馈组五份可见解释均引用原始bill输出的OR瓶颈，并生成bill的前瞻寄存器逻辑；实际映射后五份候选都是7个触发器，原始为6个。五份候选WNS均低于原始9.30ns，面积均超限，因此不是仅因10%预算被排除；放宽面积预算也不会使这些版本的时序优于原始。','',
'例如反馈组candidate_01实际最坏路径变为ready触发器_107_/Q→多级组合逻辑→bill触发器_106_/D，到达时间1.14ns、要求时间9.93ns、WNS8.79ns，面积475.4560 µm²。旧输出OR路径被处理后，新的寄存器输入路径反而更差。此为具体测量，不等于已经通过独立干预证明全部根因。','',
'实际Liberty面积分解表明，反馈组candidate_01比原始增加222.7136 µm²，其中新增触发器仅贡献20.0192 µm²，其余为组合及缓冲/反相逻辑净增加202.6944 µm²。因此不能将面积增长全归结为多了一个寄存器。见[实际单元分解](AREA_COST_ANALYSIS.md)。','',
'无反馈组最优candidate_05的可见解释预计用三位二进制状态减少寄存器，但实际映射仍为6个触发器。模型预计的微架构成本不能当测量结果。该版本实际WNS9.36ns、面积258.9984 µm²，功能与门级证明通过。','',
'这轮应改进的环节是重写动作的成本与新瓶颈预测，以及候选的全局评估。再增加未经约束的同类动作，不会自动解决问题；不能仅凭本轮把失败归因于模型没有收到STA。','',
'## 全部候选','',
'| 方法 | 候选 | 返回状态 | 源级证明 | 门级证明 | STA | WNS(ns) | 面积变化 | 有效改进 |',
'|---|---|---|---|---|---|---:|---:|---|']
for r in s['results']:
    m=r.get('metrics') or {};w=m.get('wns_ns');area=m.get('mapped_area_um2')
    ws=f'{w:.2f}' if w is not None else '—';ar=f'{100*(area/base["mapped_area_um2"]-1):+.2f}%' if area is not None else '—'
    lines.append(f"| {labels[r['arm']]} | {r['candidate_id']} | {r['status']} | {m.get('formal','NOT_RUN')} | {m.get('mapped_formal','NOT_RUN')} | {m.get('ppa','NOT_RUN')} | {ws} | {ar} | {'是' if r['accepted'] else '否'} |")
lines += ['', '## 怎样确认STA反馈真的发给了模型','',
'两组公共JSON逐字段相同。反馈组额外字段包含实际三条路径、WNS/TNS和Yosys状态编码转换表。逐份核对 `api_audit/request.json` 的实际消息与冻结提示完全一致；返回RTL从保存的provider响应重新解析并核对哈希。模型可见的解释只能作为文字证据，不能证明模型内部思考过程。','',
'最坏基线路径为映射状态触发器 _44_/Q→or3_4→bill。Yosys实际把原始BILL30的100000编码转换为----1-，所以映射State[1]不能当作原始位号解释。该信息来自实际mapping.log和mapped.v，未冒充通用逐门源码映射。','',
'## 复现与限制','',
f'- [证据审计](AUDIT.json)：{a["check_count"]}项检查通过；[独立复跑](REPRODUCTION.json)：基线及两组实际选择共3次，指标和网表哈希核对通过。重复执行不增加独立模型样本。',
'- [冻结协议](protocol.json)、[全部结构化结果](summary.json)、[原始输入](inputs/original.v)、[两组实际选择与diff](selected/)、[候选清单](candidate_manifest.json)。每个候选的api_audit/与eda/保存原始证据。',
'- 相同网表文件哈希的重复候选详见FINAL_EVIDENCE.json；不同文件哈希也不保证不同逻辑结构。',
'- 两组各5次、单个小型设计、公开源码，未进行独立家族层面的统计检验。不得将本轮与不同提示/模型/约束的历史结果直接合并成同一成功率。',
'- 同一请求模型ID及请求参数，反馈组输入更长，token用量不必相等。网关模型身份不可独立验证；token为provider报告，不据此推算未知计费。',
f'- provider返回中记录的token总数：{a["provider_reported_tokens"]}。失败请求可能存在未返回的费用，不能擅自补算。',
'- 单时钟、同步启动clear复位一次，之后输入和复位任意；保持原始输出采样行为，默认ON=1/OFF=0。布局布线前TT理想时钟结果，非物理签核。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
(S/'validation_tools').mkdir(exist_ok=True)
for src in [HERE/'reproduce_ticket_study.py',HERE/'finalize_ticket_feedback.py',E/'audit_ticket_feedback_study.py',E/'audit_ticket_preparation.py',E/'analyze_ticket_area_cost.py']:
    shutil.copyfile(src,S/'validation_tools'/src.name)
evidence=dict(status='COMPLETED_AUDITED_REPRODUCED',request_slots=10,returned_rtl=sum(g['returned'] for g in groups),
              groups=groups,conclusion=conclusion,identical_mapped_netlists=duplicates,audit_passed=a['passed'],audit_checks=a['check_count'],
              independent_replays=3,replays_passed=replay['passed'],provider_reported_tokens=a['provider_reported_tokens'],
              hashes={name:sha(S/name) for name in ['protocol.json','AUTHORIZATION.json','candidate_manifest.json','summary.json','AUDIT.json','REPRODUCTION.json','AREA_COST_ANALYSIS.json','INTERPRETATION.md']})
save(S/'FINAL_EVIDENCE.json',evidence)
save(S/'STATUS.json',dict(state='COMPLETED_AUDITED_REPRODUCED',actual_model_requests=10,approved_maximum=10,remaining_authorized_requests=0))
entry='2026-11-03状态机模型对照完成：'+ '；'.join(common)+'。基线9.30ns；10次限额已用完，全部失败/越界结果保留，审计及3次独立复跑一致。单个28单元控制设计，不代表大型工程或统计普遍优势。'
for path,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=path.read_text(encoding='utf-8')
    if '状态机模型对照完成：' not in text:
        pos=text.find('\n\n')+2;path.write_text(text[:pos]+entry+f' [完整真实结果]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
print(json.dumps({k:v for k,v in evidence.items() if k not in ['hashes','identical_mapped_netlists']},ensure_ascii=False,indent=2))
