"""Check action materialization, all raw proofs/PPA and unchanged selection rules."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[2];E=ROOT/'eda/experiments';sys.path.insert(0,str(ROOT));sys.path.insert(0,str(E))
from rewrite.comparator_rewrites import materialize
from run_native_comb import parse_electrical_report
S=E/'comparator_action_study_20261103_004742_635275'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'SUMMARY.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
check('Frozen protocol',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip())
check('Original hash',sha(S/'inputs/original.v')==p['source_sha256'])
check('Canonical normalized text',hashlib.sha256((S/'inputs/original.v').read_text(encoding='utf-8').encode('utf-8')).hexdigest()==p['canonical_lf_text_sha256'])
for rel,h in p['code_sha256'].items():check('Code '+rel,sha(ROOT/rel)==sha(S/'code_snapshot'/Path(rel).name)==h)
check('Actual library',sha(E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')==p['library_sha256'])
check('Zero model requests',p['model_requests']==s['model_requests']==0 and not list(S.glob('**/api_audit')))
check('Primary chosen in advance',p['primary_profile']=='primary_N32' and p['profiles'][0]==dict(id='primary_N32',N=32,role='primary'))
check('Fixed six actions and three profiles',len(p['candidates'])==p['source_versions']==6 and len(s['profiles'])==3 and p['planned_eda_cases']==21)
guards=load(S/'GUARD_VALIDATION.json');check('Seven rejection checks',guards['passed'] and len(guards['negative_checks'])==7 and all(x['rejected'] for x in guards['negative_checks']))
for c in p['candidates']:
    spec=load(S/'candidates'/(c['id']+'.action.json'));rtl=S/'candidates'/(c['id']+'.v')
    check(c['id']+' exact action',spec==c['action'] and sha(S/'candidates'/(c['id']+'.action.json'))==c['action_sha256'])
    check(c['id']+' exact materialized RTL',sha(rtl)==c['sha256'] and rtl.read_text(encoding='utf-8')==materialize((S/'inputs/original.v').read_text(encoding='utf-8'),spec))
stats=dict(source_formal_pass=0,mapped_formal_pass=0,sta_complete=0,strict_improved_pairs=0)
def eda(folder,m,N,label,include_stats=True):
    cp=load(folder/'protocol.json')
    check(label+' actual result',load(folder/'result.json')==m)
    check(label+' original reference',cp['reference_sha256']==p['source_sha256'])
    check(label+' candidate hash',sha(Path(cp['candidate']))==cp['candidate_sha256'])
    check(label+' actual parameter',cp['parameter_overrides']=={'N':N})
    check(label+' fixed mapping',cp['mapping_policy']=='buffer_size' and cp['abc_cleanup_before_buffer'] is True and cp['mapped_netlist_proof_required'] is True)
    check(label+' library/IO',cp['liberty_sha256']==p['library_sha256'] and cp['input_transition_ns']==p['input_transition_ns'] and cp['output_load_pf']==p['output_load_pf'])
    ports=load(folder/'candidate_schema.json')['modules']['comparator']['ports']
    check(label+' actual input/output shape',len(ports['value1']['bits'])==len(ports['value2']['bits'])==N and len(ports['SEL']['bits'])==3 and len(ports['OUT']['bits'])==1 and not ports['value1'].get('signed') and not ports['value2'].get('signed'))
    if m.get('status')=='PASS':
        for stage in ['formal','mapped_formal']:
            check(label+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
        raw=(folder/'sta.log').read_text(encoding='utf-8')
        arrivals=[float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw)]
        check(label+' raw arrival',bool(arrivals) and max(arrivals)==m['max_data_arrival_ns'])
        check(label+' electrical',parse_electrical_report(raw)==m['electrical'])
        area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1])
        check(label+' raw area',area==m['mapped_area_um2'])
        check(label+' mapped/SDC hashes',sha(folder/'mapped.v')==m['mapped_sha256'] and sha(folder/'mapped.json')==m['mapped_json_sha256'] and sha(folder/'timing.sdc')==m['sdc_sha256'])
    else:check(label+' fail closed',not m.get('eligible'))
    if include_stats:
        stats['source_formal_pass']+=m.get('formal')=='PASS';stats['mapped_formal_pass']+=m.get('mapped_formal')=='PASS';stats['sta_complete']+=m.get('ppa')=='PASS'
for profile in s['profiles']:
    folder=S/profile['id'];b=profile['baseline'];N=profile['N'];cap=b['mapped_area_um2']*1.10
    check(profile['id']+' frozen profile',any(x['id']==profile['id'] and x['N']==N and x['role']==profile['role'] for x in p['profiles']))
    eda(folder/'baseline',b,N,profile['id']+'/baseline')
    check(profile['id']+' six evaluations',len(profile['results'])==6)
    check(profile['id']+' unchanged cap',profile['area_cap_um2']==cap)
    valid=[]
    for row in profile['results']:
        m=row['metrics'];eda(folder/row['id'],m,N,profile['id']+'/'+row['id'])
        qualified=bool(m.get('status')=='PASS' and m.get('eligible') and m.get('formal')==m.get('mapped_formal')=='PASS' and m['mapped_area_um2']<=cap and m['max_data_arrival_ns']<b['max_data_arrival_ns']-1e-9)
        check(profile['id']+'/'+row['id']+' acceptance',row['strict_improvement']==qualified)
        if qualified:valid.append(row);stats['strict_improved_pairs']+=1
    valid.sort(key=lambda r:(r['metrics']['max_data_arrival_ns'],r['metrics']['mapped_area_um2'],r['id']))
    selected=valid[0] if valid else dict(id='baseline',metrics=b)
    check(profile['id']+' exact selection',profile['selected']==selected)
    source=S/'candidates'/(selected['id']+'.v') if valid else S/'inputs/original.v'
    check(profile['id']+' export',sha(source)==sha(folder/'best.v')==profile['selected_sha256'])
replay=load(S/'REPRODUCTION.json');check('Two independent replays',replay['passed'] and replay['independent_eda_replays']==2)
for row in replay['rows']:eda(S/'independent_reproduction'/row['profile'],row['metrics'],row['N'],'replay '+row['profile'],False)
report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,actual_case_statistics=stats,
            scope='One comparison family, six whitelisted source versions, eighteen parameter/candidate pairs, three baselines. No model comparison or universal parameter proof.')
save(S/'AUDIT.json',report);print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
if not report['passed']:
    print([x for x in checks if not x['passed']]);raise SystemExit(1)

lines=['# 可检查的比较器重写动作：实现与实测','',
'本轮实现了一个受限结构动作接口，运行21次源级/门级证明及STA，另独立复跑2次。零模型调用。主实验固定为32位；1位和13位只作为边界验证，不算独立电路家族。','',
'## 主结果优先','',
'32位主实验没有在固定10%面积预算内找到更快版本，保留原始RTL：到达时间1.25ns、面积1069.7760 µm²。balanced_4实测1.23ns，但面积1188.6400 µm²（+11.11%），超出原上限1176.7536 µm²，不计有效改进。没有事后改预算。','',
'13位边界实例的balanced_2通过相同规则：到达时间1.16→1.10ns（-5.17%），面积520.4992→559.2864 µm²（+7.45%），独立复跑一致。这是次要边界结果，不能替代32位主实验结论。1位各候选均与基线同为0.68ns，无严格收益。','',
'全部21次源级/实际门级证明和STA通过，包括非整分组和最小宽度。18个候选—参数组合来自6份源码，不是18份独立生成RTL；没有证明所有N参数，也没有直接LLM对照。','',
'## 全部实测结果','',
'| 实例 | 版本 | 最大到达时间ns | 面积µm² | 固定预算内严格时序改进 |','|---|---|---:|---:|---|']
pareto=[]
for profile in s['profiles']:
    pool=[dict(id='baseline',metrics=profile['baseline'],strict_improvement=False)]+profile['results']
    for row in pool:
        m=row['metrics'];lines.append(f"| {profile['id']} | {row['id']} | {m.get('max_data_arrival_ns',float('nan')):.2f} | {m.get('mapped_area_um2',float('nan')):.4f} | {'是' if row['strict_improvement'] else '否'} |")
        if m.get('status')!='PASS':continue
        dominated=any(o['metrics'].get('status')=='PASS' and o['metrics']['max_data_arrival_ns']<=m['max_data_arrival_ns'] and o['metrics']['mapped_area_um2']<=m['mapped_area_um2'] and (o['metrics']['max_data_arrival_ns']<m['max_data_arrival_ns'] or o['metrics']['mapped_area_um2']<m['mapped_area_um2']) for o in pool)
        if not dominated:pareto.append(dict(profile=profile['id'],candidate=row['id'],delay_ns=m['max_data_arrival_ns'],area_um2=m['mapped_area_um2']))
save(S/'PARETO.json',dict(scope='Post-hoc tradeoffs within this fixed measured pool, not changed primary area budget',points=pareto))
lines += ['', '## 接口实际约束了什么','',
'动作只接受operator、chunk_bits、topology三个字段，分组宽度仅2/4/8，组合方式仅balanced/linear。源代码须匹配已核查的无符号comparator模板（统一LF后SHA-256），由确定性代码只替换两条比较结果定义，保留原端口、SEL行为和延迟。未知源码、signed改动、额外RTL字段及不支持的动作均被拒绝，7项拒绝检查通过。','',
'每份动作和生成RTL在测量前冻结，后续逐份对原始RTL做SAT等价及实际映射网表等价。动作通过接口检查后，仍须满足证明、延迟和面积规则才会采纳；约束接口不保证PPA收益。','',
'这是精确模板上的结构动作库，不是通用AST重写器。现有自由RTL生成的LLM入口没有被全局替换；本轮没有真实模型选择动作，因此不宣称LLM+受约束搜索已在本电路取得优势。分组比较与平衡树是标准结构，不是本项目发明。','',
'## 证据与范围','',
f'- [冻结协议](protocol.json)、[7项接口拒绝检查](GUARD_VALIDATION.json)、[{report["check_count"]}项数据核对](AUDIT.json)、[独立复跑](REPRODUCTION.json)、[全部原始结果](SUMMARY.json)、[面积/延迟折中](PARETO.json)。',
'- candidates/保存动作JSON与RTL，实例目录保存原始SAT、映射和STA日志。组合电路主指标是最大到达时间，越小越好；虚拟时钟100ns的WNS不能与此前10ns原生时序实验混比。',
'- 固定SKY130HD TT、0.10ns输入转换、0.010pF输出负载、同一ABC映射与电气检查。布局布线前，不含功耗和物理签核。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
(S/'validation_tools').mkdir(exist_ok=True);shutil.copyfile(Path(__file__).resolve(),S/'validation_tools'/Path(__file__).name)
save(S/'FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_REPRODUCED',model_calls=0,source_versions=6,candidate_parameter_pairs=18,planned_eda_cases=21,independent_replays=2,audit_checks=report['check_count'],audit_passed=True,
    primary_N32='No strict timing improvement inside frozen area budget; retain original',secondary_N13='balanced_2 1.16 to 1.10ns, area +7.45%',
    hashes={n:sha(S/n) for n in ['protocol.json','SUMMARY.json','GUARD_VALIDATION.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md','PARETO.json']}))
entry='2026-11-03可检查比较器动作接口完成：6份冻结候选在32/13/1位共21次源级/门级证明和STA全部通过；32位主实验无预算内时序收益，13位边界1.16→1.10ns、面积+7.45%。7项非法动作拒绝、2次独立复跑和数据审计通过。本轮零模型调用，尚未接入真实模型动作选择。'
for path,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=path.read_text(encoding='utf-8')
    if '可检查比较器动作接口完成：' not in text:
        pos=text.find('\n\n')+2;path.write_text(text[:pos]+entry+f' [真实结果]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
