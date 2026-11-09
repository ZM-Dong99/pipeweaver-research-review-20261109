"""Audit/report the post-hoc ticket controls and measured bottleneck migration."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[2];E=ROOT/'eda/experiments'
sys.path.insert(0,str(E))
from run_native_comb import parse_electrical_report
S=E/'ticket_local_controls_20261103_001025_427041'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'SUMMARY.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
check('frozen protocol',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip())
parent=Path(p['parent']);check('parent protocol unchanged',sha(parent/'protocol.json')==p['parent_protocol_sha256'])
for name,h in p['input_sha256'].items():check('input '+name,sha(S/'inputs'/name)==h)
for rel,h in p['code_sha256'].items():check('code '+rel,sha(ROOT/rel)==sha(S/'code_snapshot'/Path(rel).name)==h)
check('library unchanged',sha(E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')==p['library_sha256'])
check('zero model requests',p['model_requests']==s['model_requests']==0 and not list(S.glob('**/api_audit')))
check('four frozen candidates',len(p['candidates'])==p['candidate_count']==4 and len(s['rows'])==5)
for c in p['candidates']:check('candidate '+c['id'],sha(S/'candidates'/(c['id']+'.v'))==c['sha256'])
check('original lineage',sha(S/'inputs/original.v')==sha(parent/'inputs/original.v'))
check('guided lineage',sha(S/'inputs/guided_reference.v')==sha(parent/'structured_timing_feedback/candidate_03/candidate.v'))
check('known model lineage',sha(S/'inputs/known_model_best.v')==sha(parent/'no_timing_feedback/candidate_05/candidate.v'))
def eda(folder,m,label):
    cp=load(folder/'protocol.json')
    check(label+' result',load(folder/'result.json')==m)
    check(label+' original reference',cp['reference_sha256']==p['input_sha256']['original.v'])
    check(label+' actual candidate',sha(Path(cp['candidate']))==cp['candidate_sha256'])
    check(label+' fixed contract',all(cp[k]==p[k] for k in ['clock','reset','reset_active','reset_cycles','warmup_samples','period_ns','parameter_overrides']) and not cp['dependencies'])
    check(label+' library',cp['liberty_sha256']==p['library_sha256'])
    if m.get('status')=='PASS':
        for stage in ['formal','mapped_formal']:
            raw=(folder/(stage+'.log')).read_text(encoding='utf-8')
            check(label+' '+stage,m[stage]=='PASS' and 'Induction step proven: SUCCESS!' in raw and 'Base case for induction length' in raw)
        raw=(folder/'sta.log').read_text(encoding='utf-8')
        for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
            match=re.search(pattern,raw);check(label+' raw '+key,bool(match) and float(match[1])==m[key])
        check(label+' electrical',parse_electrical_report(raw)==m['electrical'])
        area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text())[-1])
        check(label+' raw area',area==m['mapped_area_um2'])
        check(label+' mapped hash',sha(folder/'mapped.v')==m['mapped_sha256'])
        check(label+' SDC hash',sha(folder/'timing.sdc')==m['sdc_sha256'])
    else:check(label+' failure retained',not m.get('eligible'))
eda(S/'baseline',s['baseline']['metrics'],'baseline')
for row in s['rows']:
    eda(S/row['id'],row['metrics'],row['id'])
    m=row['metrics'];b=s['baseline']['metrics']
    gain=(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=p['area_cap_um2'] and m['tns_ns']>=b['tns_ns']-1e-9 and m['wns_ns']>b['wns_ns']+1e-9)
    check(row['id']+' strict acceptance',row['strict_baseline_improvement']==bool(gain))
known=next(r['metrics'] for r in s['rows'] if r['id']=='known_model_best')
check('known model control matches prior',all(known[k]==p['expected_known_model_best'][k] for k in ['wns_ns','tns_ns','mapped_area_um2','mapped_sha256']))
gains=sorted([r for r in s['rows'] if r['id']!='known_model_best' and r['strict_baseline_improvement']],key=lambda r:(-r['metrics']['wns_ns'],r['metrics']['mapped_area_um2'],r['id']))
check('selection',s['best_new']==(gains[0] if gains else s['baseline']))
check('export hash',sha(S/'best_new.v')==s['best_new_sha256']==s['best_new']['source_sha256'])
replay=load(S/'REPRODUCTION.json');check('independent replay',replay['passed'] and all(replay['checks'].values()))
eda(S/'independent_reproduction',replay['metrics'],'replay')
target=load(S/'targeted_sta/SUMMARY.json');tp=load(S/'targeted_sta/protocol.json')
check('seven targeted measurements',target['passed'] and target['cases']==len(target['results'])==len(tp['cases'])==7 and target['new_candidates']==target['model_calls']==0)
for item,row in zip(tp['cases'],target['results']):
    check(item['id']+' old artifacts unchanged',all(sha(Path(item['folder'])/name)==h for name,h in item['sha256'].items()))
    rawpath=S/'targeted_sta'/row['id']/'sta.log';raw=rawpath.read_text(encoding='utf-8')
    check(item['id']+' targeted log hash',sha(rawpath)==row['raw_log_sha256'])
    for key,begin,end in [('global_path','PW_GLOBAL_BEGIN','PW_GLOBAL_END'),('bill_output_path','PW_BILL_BEGIN','PW_BILL_END')]:
        text=raw.split(begin,1)[1].split(end,1)[0]
        check(item['id']+' '+key,all(float(re.search(pattern,text)[1])==row[key][k] for k,pattern in [('data_arrival_ns',r'([\d.]+)\s+data arrival time'),('data_required_ns',r'([\d.]+)\s+data required time'),('slack_ns',r'([-+\d.]+)\s+slack \(')]))
    check(item['id']+' global WNS repeated',row['global_path']['slack_ns']==load(Path(item['folder'])/'result.json')['wns_ns'])
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,scope='Artifact consistency of post-hoc development and targeted STA; not new LLM samples or causal superiority.')
save(S/'AUDIT.json',report)
print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
if not report['passed']:raise SystemExit(1)

labels={'baseline':'原始基线','known_model_best':'既有无反馈LLM最佳','explicit_onehot_without_bill_ff':'移除冗余bill寄存器',
        'original_complement_bill':'互补输出译码','binary_preserve_encoding':'保留普通三位编码','billing_bit_preserve_encoding':'保留计费位编码','guided_with_bill_ff':'既有反馈候选03'}
lines=['# 状态机改写成本与瓶颈转移：本地开发实验','',
'本轮零模型调用。看过上一轮LLM实验结果后，预先冻结四份手工开发源码，统一对原始RTL完成证明和测量。新跑6次完整评估（原始、既有无反馈最佳及4候选），最优新增版本另复跑1次；再对7个已有网表做定向STA。不能称为新的模型对照，也不能把这些测量当独立模型样本。','',
'## 实测结果','',
'| 版本 | 全局WNS(ns) | bill输出WNS(ns) | FF数 | 面积(µm²) |','|---|---:|---:|---:|---:|']
for row in target['results']:
    lines.append(f"| {labels[row['id']]} | {row['global_path']['slack_ns']:.2f} | {row['bill_output_path']['slack_ns']:.2f} | {row['mapped_ff_count']} | {row['measured_area_um2']:.4f} |")
lines += ['',
'四份候选都通过源级和实际门级归纳等价证明、STA与记录的电气检查。原面积上限仍为278.01664 µm²。互补输出译码是唯一在该预算内严格改善原始WNS的新候选：9.30→9.35ns、面积252.7424→246.4864 µm²（-2.48%），独立复跑各指标和网表哈希相同。它仍未超过既有无反馈LLM最佳9.36ns；不宣称新方法击败LLM。','',
'## 为什么旧路径改善了，全局却更慢','',
'反馈候选03的bill输出路径到达时间由0.70ns降为0.33ns，对应输出裕量9.30→9.67ns，局部改善是真实的。但其全局裕量为9.22ns，瓶颈转移到寄存器输入路径。移除新增bill寄存器后，FF数7→6、面积321.5584→256.4960 µm²，全局裕量9.22→9.29ns，仍未超过原始9.30ns。这个匹配消融支持冗余寄存器及其驱动逻辑有实际代价；并不把所有差异都归因于单一门。','',
'把计费状态直接编码为高位后，bill输出路径裕量达到9.59ns，实际只有3个FF；全局裕量却为8.95ns。减少寄存器数量、改善输出路径都不能替代全局STA。普通三位编码的总面积甚至增加到319.0560 µm²，说明寄存器省下来的面积可能被组合译码抵消。','',
'下一步反馈机制应同时提供“原目标路径”和“最坏竞争路径”的类别、到达/要求时间及候选寄存器/译码成本；候选评估要重新找最坏路径，不能只追旧端点。以上是后续机制设计依据，尚未验证该反馈机制能提升LLM成功率。','',
'## 范围与证据','',
f'- [冻结协议](protocol.json)、[全部6次评估](SUMMARY.json)、[{report["check_count"]}项核对](AUDIT.json)、[独立复跑](REPRODUCTION.json)、[七次定向STA](targeted_sta/SUMMARY.json)。每个版本目录保留原始日志。',
'- [新增候选RTL](best_new.v)。互补译码和计费位编码在某些非法内部状态下的输出与原始不同；证明范围为固定启动同步clear之后的可达行为，不包含软错误注入或任意非法状态恢复的等价。没有增加one-hot输入假设或缩短验证窗口。',
'- fsm_encoding="none" 是明确的综合编码约束，实际FF数由映射结果核对；未改变参考设计、面积预算或验证工具以绕过证明。',
'- 单个小型公开控制电路，TT布局布线前、理想时钟与固定IO负载；非物理签核或统计普遍优势。此前模型对照的1/5与0/5原结果保持不变。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
pool=[s['baseline']]+s['rows'];front=[]
for row in pool:
    m=row['metrics']
    if m.get('status')!='PASS':continue
    dominated=any(other['metrics'].get('status')=='PASS' and other['metrics']['mapped_area_um2']<=m['mapped_area_um2'] and other['metrics']['wns_ns']>=m['wns_ns'] and (other['metrics']['mapped_area_um2']<m['mapped_area_um2'] or other['metrics']['wns_ns']>m['wns_ns']) for other in pool)
    if not dominated:front.append(row)
(S/'pareto').mkdir(exist_ok=True)
for row in front:
    source=S/'inputs/known_model_best.v' if row['id']=='known_model_best' else S/'candidates'/(row['id']+'.v')
    shutil.copyfile(source,S/'pareto'/(row['id']+'.v'))
save(S/'PARETO.json',dict(scope='Only this measured six-case pool; post-hoc area/timing choices, original model study unchanged.',rows=front))
(S/'validation_tools').mkdir(exist_ok=True)
shutil.copyfile(Path(__file__).resolve(),S/'validation_tools'/Path(__file__).name)
evidence=dict(status='COMPLETED_AUDITED_REPRODUCED',model_requests=0,new_source_candidates=4,full_eda_cases=6,independent_replays=1,targeted_fixed_netlist_sta_cases=7,
              audit_passed=True,audit_checks=report['check_count'],known_model_timing_best_unchanged=True,
              hashes={n:sha(S/n) for n in ['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','PARETO.json','INTERPRETATION.md','targeted_sta/SUMMARY.json']})
save(S/'FINAL_EVIDENCE.json',evidence)
entry='2026-11-03状态机局部开发：四份冻结手工候选全部通过源级/门级证明及STA；互补译码WNS9.35ns、面积-2.48%，独立复跑一致，仍未超过已有无反馈LLM的9.36ns。七次定向STA确认旧bill路径改善但全局瓶颈转移。零模型调用，属于事后开发，原LLM对照不变。'
for path,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=path.read_text(encoding='utf-8')
    if '状态机局部开发：' not in text:
        pos=text.find('\n\n')+2;path.write_text(text[:pos]+entry+f' [全部证据]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
print(json.dumps(evidence,ensure_ascii=False))
