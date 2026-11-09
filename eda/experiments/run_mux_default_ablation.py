"""Local post-hoc ablation of the actual STA-arm mux candidate; never calls API."""
from pathlib import Path
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
import sys,json,re,hashlib,shutil
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT));sys.path.insert(0,str(ROOT/'eda/experiments'))
from agents.action_loop import evaluate
from run_native_comb import parse_electrical_report
PARENT=ROOT/'eda/experiments/mux_feedback_study_20261104_155643_522144'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def save(f,x):f.write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
S=ROOT/'eda/experiments'/datetime.now().strftime('mux_default_ablation_%Y%m%d_%H%M%S_%f');S.mkdir()
for sub in ['inputs','candidates','code_snapshot']:(S/sub).mkdir()
shutil.copyfile(PARENT/'inputs/original.v',S/'inputs/original.v');shutil.copyfile(PARENT/'inputs/LICENSE',S/'inputs/LICENSE')
shutil.copyfile(PARENT/'sta/trial_05/candidate.v',S/'inputs/model_candidate.v')
text=(S/'inputs/model_candidate.v').read_text(encoding='utf-8')
def change_default(rhs):
    result,n=re.subn(r'assign select_a\s*=.*?;',f'assign select_a = {rhs};',text,count=1,flags=re.S);assert n==1;return result
variants={'model_control':text,'default_range':change_default("(sel == 4'd0) | (sel >= 4'd10)"),
          'default_complement':change_default('~(select_b | select_c | select_d | select_e | select_f | select_g | select_h | select_i | select_j)')}
shared=[]
for i in range(4):shared.append(f'wire low_{i} = '+('sel[1]' if i&2 else '~sel[1]')+' & '+('sel[0]' if i&1 else '~sel[0]')+';')
for i in range(3):shared.append(f'wire high_{i} = '+('sel[3]' if i&2 else '~sel[3]')+' & '+('sel[2]' if i&1 else '~sel[2]')+';')
factored=text.replace('    assign select_a =','    '+'\n    '.join(shared)+'\n    assign select_a =',1)
for i,c in enumerate('bcdefghij',1):
    factored,n=re.subn(r'assign select_'+c+r'\s*=\s*\(sel == 4\x27d'+str(i)+r'\);',f'assign select_{c} = high_{i//4} & low_{i%4};',factored,count=1);assert n==1
variants['shared_predecode']=factored
variants['rename_only']=re.sub(r'\bselect_[a-j]\b',lambda m:'pw_'+m.group(),text)
for i,rtl in variants.items():(S/'candidates'/(i+'.v')).write_text(rtl,encoding='utf-8')
deps=[Path(__file__).resolve(),ROOT/'agents/action_loop.py',ROOT/'eda/experiments/run_native_comb.py',ROOT/'eda/experiments/trace_sta_rtl_cone.py']
for f in deps:shutil.copyfile(f,S/'code_snapshot'/f.name)
parent_evidence=load(PARENT/'FINAL_EVIDENCE.json')
p=dict(client_date='2026-11-04',purpose='Post-hoc mechanism development on a real model candidate, not another model-method experiment',model_requests=0,parent=str(PARENT),parent_evidence_sha256=sha(PARENT/'FINAL_EVIDENCE.json'),top='mux_large',parameters={},source_sha256=sha(S/'inputs/original.v'),model_candidate_sha256=sha(S/'inputs/model_candidate.v'),candidate_sha256={i:sha(S/'candidates'/(i+'.v')) for i in variants},code_sha256={str(f):sha(f) for f in deps},
    planned_changes={'model_control':'Exact actual STA candidate, unchanged','default_range':'Only select_a RHS changed to equality-or-range','default_complement':'Only select_a RHS changed to NOT OR of other nine enables','shared_predecode':'Only select_b..j replaced with shared2+2bit decoder; select_a and output logic unchanged','rename_only':'Only internal enable identifiers renamed, no Boolean logic change'},
    selection='All five variants frozen before PPA, original reference fixed. Independent repeats predeclared for model_control and default_range regardless of outcome.',
    contract='All84 two-state inputs unrestricted, all8 outputs equal to original, including sel10..15 default block_a. No X/Z equivalence claim.',
    limits='One already-exposed23-line mux; post-hoc local development, not a third STA group win. Fixed SKY130HD TT prelayout and original110% area cap. Synthesis sensitivity is not a universal circuit theorem.')
p['liberty_sha256']=sha(ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')
save(S/'protocol.json',p);(S/'protocol.sha256').write_text(sha(S/'protocol.json')+'\n',encoding='ascii');print('Frozen: '+str(S),flush=True)
def measure(i):
    source=S/'inputs/original.v' if i=='baseline' else S/'candidates'/(i+'.v')
    m=evaluate(source,S/'evaluations'/i,S/'inputs/original.v',0,top='mux_large',parameters={});print(i,m.get('status'),m.get('max_data_arrival_ns'),m.get('mapped_area_um2'),flush=True);return i,m
with ThreadPoolExecutor(max_workers=2) as pool:results=dict(pool.map(measure,['baseline']+list(variants)))
save(S/'SUMMARY.json',dict(model_requests=0,results=results));checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol freeze',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip())
check('parent original retained',p['source_sha256']==sha(PARENT/'inputs/original.v'))
check('actual model source retained',p['model_candidate_sha256']==parent_evidence['selected_roles']['sta']['source_sha256'])
for i,h in p['candidate_sha256'].items():check(i+' RTL frozen',sha(S/'candidates'/(i+'.v'))==h)
for i,m in results.items():
    f=S/'evaluations'/i;check(i+' complete',m.get('status')=='PASS')
    if m.get('status')!='PASS':continue
    tool=load(f/'protocol.json');check(i+' unchanged reference',tool['reference_sha256']==p['source_sha256'] and tool['top']=='mux_large' and tool['parameter_overrides']=={} and tool['liberty_sha256']==p['liberty_sha256'])
    check(i+' source hash',sha(Path(tool['candidate']))==tool['candidate_sha256'])
    for stage in ['formal','mapped_formal']:check(i+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (f/(stage+'.log')).read_text(encoding='utf-8'))
    raw=(f/'sta.log').read_text(encoding='utf-8');check(i+' actual delay',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns'])
    check(i+' actual area',float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(f/'mapping.log').read_text(encoding='utf-8'))[-1])==m['mapped_area_um2'])
    check(i+' mapped used for STA',sha(f/'mapped.v')==m['mapped_sha256']==m['sta_netlist_sha256'])
    check(i+' electrical',parse_electrical_report(raw)==m['electrical'] and m['electrical']['status']=='PASS')
for i,role in [('baseline','baseline'),('model_control','sta')]:
    m=results[i];expected=parent_evidence['selected_roles'][role];check(i+' previous timing/area reproduced',m.get('max_data_arrival_ns')==expected['delay_ns'] and m.get('mapped_area_um2')==expected['area_um2'])
replays=[]
for i in ['model_control','default_range']:
    fresh=evaluate(S/'candidates'/(i+'.v'),S/'independent_reproduction'/i,S/'inputs/original.v',0,top='mux_large',parameters={});keys=['status','formal','mapped_formal','max_data_arrival_ns','mapped_area_um2','mapped_sha256','electrical'];matches={k:fresh.get(k)==results[i].get(k) for k in keys}
    replays.append(dict(action=i,passed=all(matches.values()),comparisons=matches));check(i+' independent replay',all(matches.values()))
save(S/'REPRODUCTION.json',dict(passed=all(r['passed'] for r in replays),cases=replays,model_requests=0))
audit=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks);save(S/'AUDIT.json',audit)
assert audit['passed'],[c for c in checks if not c['passed']]
base=results['baseline'];control=results['model_control'];same_rename=all(results['rename_only'][k]==control[k] for k in ['max_data_arrival_ns','mapped_area_um2'])
lines=['# 数据选择器：真实STA候选的默认译码消融','',
    '本轮零API。以已返回且验证的STA最佳候选为起点，冻结五个版本后统一运行完整验证和STA；全部直接对原始RTL证明。后续两次复跑对象在测量前指定，不按结果挑选。', '',
    '| 版本 | 到达时间(ns) | 面积(µm²) | 相对原始面积 | 超过10%上限 |', '|---|---|---|---|---|']
for i,m in results.items():
    delta=(m['mapped_area_um2']/base['mapped_area_um2']-1)*100;lines.append(f"| {i} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {delta:+.2f}% | {'是' if delta>10 else '否'} |")
lines+=['','逐项变化：']
for i,desc in p['planned_changes'].items():lines.append('- '+i+'：'+desc)
lines += ['',
    '默认使能的写法变化对照中，其他使能、输出掩码、模块接口均保持模型版本；共享译码对照保留默认使能及输出逻辑，仅改变其他九个使能的计算。即使PPA有变化，也只能说明这些RTL表达在当前综合映射条件下产生不同结果，不能认定某种等价表达在所有工艺中都更快。', '',
    '仅重命名对照的延迟和面积'+('与模型原版一致；这不排除其他结构或命名变换的综合敏感性。' if same_rename else '也发生变化，说明本流程存在命名/中间表示相关的映射敏感性，不能把差异全部归因于Boolean结构。'), '',
    f"本轮6个完整EDA案例，{audit['check_count']}项核查通过，预先指定的2个案例独立复跑一致。原始与真实模型候选也复现上轮指标。不是新增模型样本，也不改变上轮主要指标STA组未胜出的混合结论。", '',
    '全部证据：[冻结协议](protocol.json)、[结果](SUMMARY.json)、[审计](AUDIT.json)、[复跑](REPRODUCTION.json)。evaluations与independent_reproduction各目录保存原始证明、综合、STA和电气日志。标准TT库、固定IO、无布局布线寄生，不是物理签核。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
save(S/'FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_REPRODUCED',model_requests=0,complete_eda_cases=6,independent_reproductions=2,audit_checks=audit['check_count'],rename_only_same_delay_area=same_rename,metrics={i:dict(delay_ns=m['max_data_arrival_ns'],area_um2=m['mapped_area_um2']) for i,m in results.items()},hashes={f:sha(S/f) for f in ['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']}))
rel=str(S.relative_to(ROOT)).replace('\\','/')
entry='2026-11-04默认译码消融完成：真实STA返回的0.80ns候选为起点，冻结默认条件、共享译码和仅重命名对照；6次完整EDA、2次预定独立复跑、'+str(audit['check_count'])+'项审计通过。零模型调用，不计为新的STA组优势案例。'
for file,prefix in [(ROOT/'EXPERIMENT_INDEX.md',''),(ROOT/'docs/CURRENT_STATUS.md','../')]:
    file.write_text(entry+' [全部真实证据]('+prefix+rel+'/INTERPRETATION.md)。\n\n'+file.read_text(encoding='utf-8'),encoding='utf-8')
print('Completed report: '+str(S/'INTERPRETATION.md'),flush=True)
