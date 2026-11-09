"""Constructed two-region localization sanity experiment; zero API requests."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import sys,json,re,hashlib,shutil,os
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT));sys.path.insert(0,str(ROOT/'eda/experiments'))
from agents.action_loop import evaluate
from run_native_comb import execute,parse_electrical_report
OLD=ROOT/'eda/experiments/mux_action_development_20261104_154849_392802'
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def save(f,x):f.write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
def wsl(f):
    x=f.resolve().as_posix();return '/mnt/'+x[0].lower()+x[2:]
S=ROOT/'eda/experiments'/datetime.now().strftime('dual_mux_localization_%Y%m%d_%H%M%S_%f');S.mkdir()
for name in ['inputs','designs','profiles','code_snapshot']:(S/name).mkdir()
for source,target in [(OLD/'inputs/original.v','original_mux.v'),(OLD/'candidates/tree_low_first.v','tree_mux.v'),(OLD/'inputs/LICENSE','LICENSE')]:shutil.copyfile(source,S/'inputs'/target)
original=(S/'inputs/original_mux.v').read_text(encoding='utf-8');tree=(S/'inputs/tree_mux.v').read_text(encoding='utf-8')
def helper(text,name):return re.sub(r'\bmodule\s+mux_large\b','module '+name,text[text.index('module mux_large'):],count=1)
top='''module dual_mux (
    input wire [79:0] data_left, data_right,
    input wire [3:0] sel_left, sel_right,
    output wire [7:0] out_left, out_right
);
'''
for region in ['left','right']:
    ports=[f'.block_{c}(data_{region}[{8*i} +: 8])' for i,c in enumerate('abcdefghij')]+[f'.sel(sel_{region})',f'.block_out(out_{region})']
    top+=f'mux_region_{region} region_{region} ('+', '.join(ports)+');\n'
top+='endmodule\n'
choices={'baseline':(False,False),'rewrite_left':(True,False),'rewrite_right':(False,True),'rewrite_both':(True,True)}
license_header='/*\n'+(S/'inputs/LICENSE').read_text(encoding='utf-8')+'\n*/\n'
for i,(left,right) in choices.items():(S/'designs'/(i+'.v')).write_text(license_header+top+helper(tree if left else original,'mux_region_left')+'\n'+helper(tree if right else original,'mux_region_right'),encoding='utf-8')
profiles={'left_late':dict(left_delay_ns=.40,right_delay_ns=0.),'right_late':dict(left_delay_ns=0.,right_delay_ns=.40),'balanced':dict(left_delay_ns=0.,right_delay_ns=0.)}
for name,profile in profiles.items():
    sdc='''create_clock -name virtual_clk -period 100.0
set_input_delay -max 0.0 -clock virtual_clk [all_inputs]
set_output_delay -max 0.0 -clock virtual_clk [all_outputs]
set_input_transition 0.10 [all_inputs]
set_load 0.010 [all_outputs]
set left_ports [get_ports {data_left* sel_left*}]
set right_ports [get_ports {data_right* sel_right*}]
if {[llength $left_ports] != 84 || [llength $right_ports] != 84} {error "Input region selection count mismatch"}
if {[llength [all_inputs]] != 168 || [llength [all_outputs]] != 16} {error "Native interface count mismatch"}
'''+f"set_input_delay -max {profile['left_delay_ns']:.2f} -clock virtual_clk $left_ports\nset_input_delay -max {profile['right_delay_ns']:.2f} -clock virtual_clk $right_ports\n"
    (S/'profiles'/(name+'.sdc')).write_text(sdc,encoding='ascii')
deps=[Path(__file__).resolve(),ROOT/'agents/action_loop.py',ROOT/'eda/experiments/run_native_comb.py',ROOT/'eda/experiments/trace_sta_rtl_cone.py']
for f in deps:shutil.copyfile(f,S/'code_snapshot'/f.name)
p=dict(client_date='2026-11-05',model_requests=0,kind='CONSTRUCTED_TWO_REGION_DEVELOPMENT_SANITY_TEST',origin='Two independent copies of the public10x8 mux, manually composed. Not a new natural engineering benchmark or independent RTL family.',
    top='dual_mux',parameters={},inputs=168,outputs=16,designs=choices,profiles=profiles,area_ratio_limit=1.12,
    area_basis='Predeclared12% for this restricted tree-rewrite experiment; earlier isolated tree action costs about20.52% per region. Hypothesis: one of two regions fits, both exceed. Do not change cap after composite measurements.',
    scope='Restricted action: choose left or right for the same binary-tree rewrite. Known lower-area default-mask rewrites intentionally outside this localization action set, so area does not prohibit all possible dual-region optimizations.',
    timing='Map each design once with identical fixed ABC driver/load, then replay exact proven netlists under three frozen input-delay profiles. Not constraint-specific remapping, no layout parasitics, fixedTT library.',
    hypotheses='Baseline worst-path output switches left/right with late profile. Under12% area, correct-region rewrite has>=5% retained-delay benefit and beats opposite-region rewrite by>=0.05ns. Both rewrites over budget. Balanced is a negative-control profile, all results retained regardless of hypothesis.',
    fairness='Future no-STA and STA conditions must both receive full identical constraints and action catalogue. Symmetry and visible input delays may make correct choice obvious without STA. This sanity experiment cannot prove model/STA superiority and is not by itself justification to buy API samples.',
    source_sha256={f.name:sha(f) for f in (S/'inputs').iterdir()},design_sha256={i:sha(S/'designs'/(i+'.v')) for i in choices},sdc_sha256={name:sha(S/'profiles'/(name+'.sdc')) for name in profiles},liberty_sha256=sha(LIB),code_sha256={str(f):sha(f) for f in deps})
save(S/'protocol.json',p);(S/'protocol.sha256').write_text(sha(S/'protocol.json')+'\n',encoding='ascii');print('Frozen: '+str(S),flush=True)
def mapping(i):
    m=evaluate(S/'designs'/(i+'.v'),S/'mapping'/i,S/'designs/baseline.v',0,top='dual_mux',parameters={});print('Mapping '+i+': '+str(m.get('status'))+' delay='+str(m.get('max_data_arrival_ns'))+' area='+str(m.get('mapped_area_um2')),flush=True);return i,m
with ThreadPoolExecutor(max_workers=2) as pool:maps=dict(pool.map(mapping,choices))
save(S/'MAPPING_RESULTS.json',maps)
if not all(m.get('status')=='PASS' for m in maps.values()):raise RuntimeError('Mapping/proof qualification failed; frozen failed records retained, no API.')
env=os.environ.copy()
for key in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(key,None)
def timing(job,replay=False):
    profile,i=job;out=S/('independent_sta_replay' if replay else 'sta')/profile/i;out.mkdir(parents=True,exist_ok=False);sdc=S/'profiles'/(profile+'.sdc');netlist=S/'mapping'/i/'mapped_sta.v';m=maps[i]
    assert sha(netlist)==m['sta_netlist_sha256']
    tcl='\n'.join([f'read_liberty {{{wsl(LIB)}}}',f'read_verilog {{{wsl(netlist)}}}','link_design dual_mux',f'read_sdc {{{wsl(sdc)}}}','puts "PW_ALL_INPUT_COUNT [llength [all_inputs]]"','puts "PW_ALL_OUTPUT_COUNT [llength [all_outputs]]"','report_checks -path_delay max -format full_clock_expanded -group_path_count 10','report_worst_slack -max','report_tns -max','puts {PW_ELECTRICAL_BEGIN}','report_check_types -max_slew -max_capacitance -violators -digits 6','puts {PW_ELECTRICAL_END}',''])
    (out/'run_sta.tcl').write_text(tcl,encoding='utf-8')
    raw=execute(['wsl.exe','-d','Ubuntu','--',os.environ.get('OPENSTA','/home/easton1/OpenSTA/build/sta'),'-no_splash','-exit',wsl(out/'run_sta.tcl')],ROOT,out/'sta.log',env,120)
    assert not re.search(r'^\s*(?:Error:|ERROR:)',raw,re.M)
    arrival=max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw));electrical=parse_electrical_report(raw);assert electrical['status']=='PASS'
    result=dict(profile=profile,design=i,max_data_arrival_ns=arrival,wns_ns=float(re.search(r'worst slack max\s+([-+\d.]+)',raw).group(1)),tns_ns=float(re.search(r'tns max\s+([-+\d.]+)',raw).group(1)),critical_startpoint=re.search(r'Startpoint:\s*(.+)',raw).group(1),critical_endpoint=re.search(r'Endpoint:\s*(.+)',raw).group(1),mapped_area_um2=m['mapped_area_um2'],electrical=electrical,mapped_sha256=m['mapped_sha256'],sta_netlist_sha256=sha(netlist),sdc_sha256=sha(sdc),tool_protocol_sha256=sha(S/'mapping'/i/'protocol.json'),input_count_verified='PW_ALL_INPUT_COUNT 168' in raw,output_count_verified='PW_ALL_OUTPUT_COUNT 16' in raw)
    save(out/'result.json',result);print(('Replay ' if replay else 'STA ')+profile+' '+i+': '+str(arrival)+'ns',flush=True);return profile,i,result
with ThreadPoolExecutor(max_workers=2) as pool:rows=list(pool.map(timing,[(profile,i) for profile in profiles for i in choices]))
timings={profile:{i:m for pr,i,m in rows if pr==profile} for profile in profiles};cap=maps['baseline']['mapped_area_um2']*1.12;findings={}
for profile,pool in timings.items():
    eligible=[i for i in choices if pool[i]['mapped_area_um2']<=cap];eligible.sort(key=lambda i:(pool[i]['max_data_arrival_ns'],pool[i]['mapped_area_um2'],i));best=eligible[0]
    findings[profile]=dict(eligible_designs=eligible,best=best,baseline_delay_ns=pool['baseline']['max_data_arrival_ns'],best_delay_ns=pool[best]['max_data_arrival_ns'],critical_endpoint=pool['baseline']['critical_endpoint'])
hypotheses={}
for profile,region,opposite in [('left_late','left','right'),('right_late','right','left')]:
    pool=timings[profile];base=pool['baseline'];correct=pool['rewrite_'+region];wrong=pool['rewrite_'+opposite]
    hypotheses[profile]=dict(worst_region_switch=base['critical_endpoint'].startswith('out_'+region+'['),correct_rewrite_within_cap=correct['mapped_area_um2']<=cap,wrong_rewrite_within_cap=wrong['mapped_area_um2']<=cap,both_over_cap=pool['rewrite_both']['mapped_area_um2']>cap,correct_gain_at_least_5pct=correct['max_data_arrival_ns']<=base['max_data_arrival_ns']*.95,correct_beats_wrong_at_least_005ns=wrong['max_data_arrival_ns']-correct['max_data_arrival_ns']>=.05)
save(S/'SUMMARY.json',dict(model_requests=0,area_cap_um2=cap,mapping=maps,timings=timings,findings=findings,hypotheses=hypotheses,all_predeclared_hypotheses_met=all(all(h.values()) for h in hypotheses.values())))
replays=[]
for job in [('left_late','rewrite_left'),('right_late','rewrite_right')]:
    profile,i,m=timing(job,True);replays.append(dict(profile=profile,design=i,passed=m==timings[profile][i]))
save(S/'REPRODUCTION.json',dict(passed=all(r['passed'] for r in replays),model_requests=0,replayed_sta_cases=replays,scope='STA-only independent replay of identical proven mapped netlist and constraints; not fresh model draws or resynthesis.'))
checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol freeze',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip())
check('library frozen',sha(LIB)==p['liberty_sha256'])
for i,h in p['design_sha256'].items():check('design '+i,sha(S/'designs'/(i+'.v'))==h)
for profile,h in p['sdc_sha256'].items():check('constraints '+profile,sha(S/'profiles'/(profile+'.sdc'))==h)
for i,m in maps.items():
    f=S/'mapping'/i;tool=load(f/'protocol.json');check(i+' original reference',tool['reference_sha256']==p['design_sha256']['baseline'] and tool['top']=='dual_mux' and tool['parameter_overrides']=={})
    for stage in ['formal','mapped_formal']:check(i+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (f/(stage+'.log')).read_text(encoding='utf-8'))
    check(i+' mapped used by STA',sha(f/'mapped.v')==m['mapped_sha256'] and sha(f/'mapped_sta.v')==m['sta_netlist_sha256'])
    area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(f/'mapping.log').read_text(encoding='utf-8'))[-1]);check(i+' actual area',area==m['mapped_area_um2'])
for profile,i,m in rows:
    f=S/'sta'/profile/i;raw=(f/'sta.log').read_text(encoding='utf-8');check(profile+' '+i+' actual arrival',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns'])
    check(profile+' '+i+' electrical',parse_electrical_report(raw)==m['electrical'])
    check(profile+' '+i+' exact inputs/outputs',m['input_count_verified'] and m['output_count_verified'])
    check(profile+' '+i+' frozen mapping/SDC',m['sdc_sha256']==p['sdc_sha256'][profile] and m['sta_netlist_sha256']==maps[i]['sta_netlist_sha256'])
for r in replays:check('STA replay '+r['profile'],r['passed'])
audit=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks);save(S/'AUDIT.json',audit);assert audit['passed']
lines=['# 两区域定位实验：真实STA约束切换（零API）','',
    '手工构造的双区域组合电路：左右各一个公开10路8位选择器，总168个输入位、16个输出位。不是新的真实工程基准，不算独立家族。所有输入不受限，保留所有默认选择行为。', '',
    '动作仅限把某一区域改成二进制选择树。12%面积上限在复合电路映射前固定，依据已有单模块开发结果制定；不是通用工程标准。已知低面积默认掩码动作不在本定位测试集合内，不能说所有双区域优化都被面积禁止。', '',
    '先对四个设计分别进行完整源级与门级等价验证和统一映射，再用相同已证明网表做三个冻结约束的STA；未按各输入延迟配置重综合。虚拟时钟100ns，输入转换0.10ns，输出负载0.010pF，左晚/右晚配置分别将对应全部84个输入设置0.40ns延迟。面积固定不随STA配置改变。', '',
    f'共同面积上限：{cap:.6f}µm²。', '',
    '| 约束 | 版本 | 到达时间(ns) | 面积(µm²) | 面积内 | 最坏路径终点 |', '|---|---|---|---|---|---|']
for profile,pool in timings.items():
    for i,m in pool.items():lines.append(f"| {profile} | {i} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {'是' if m['mapped_area_um2']<=cap else '否'} | {m['critical_endpoint']} |")
lines += ['', '预先声明的假设检查（不满足也保留）：','',json.dumps(hypotheses,ensure_ascii=False,indent=2),'',
    f"证据审计{audit['check_count']}项通过。四个设计完整证明与映射、12个配置STA测量、2个STA独立复跑；这些不是18个独立模型样本。原始文件分别在mapping/、profiles/、sta/与independent_sta_replay/，协议及结果在protocol.json、SUMMARY.json、AUDIT.json、REPRODUCTION.json。", '',
    '重要限制：这是定位流程的构造性健全性检查。对称电路与显式延迟也许足以让无STA模型判断应改哪侧；未来两组必须同样看到完整约束，不能隐藏无STA组的约束来制造优势。即使所有假设满足，也不证明需要LLM、更不证明STA引导优于直接LLM。现在不购买模型样本，不记为新的STA胜出案例。只有当更复杂、约束本身不直接给出答案的实例准备好，才考虑真实模型对照。', '',
    '仅TT预布局、理想时钟与固定IO条件；没有布线寄生、功耗或物理签核结论。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
summary=load(S/'SUMMARY.json');save(S/'FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_STA_REPLAYED',model_requests=0,source_and_mapped_proven_designs=4,scenario_sta_measurements=12,independent_sta_replays=2,audit_checks=audit['check_count'],all_predeclared_hypotheses_met=summary['all_predeclared_hypotheses_met'],findings=findings,hashes={f:sha(S/f) for f in ['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']}))
rel=str(S.relative_to(ROOT)).replace('\\','/')
entry='2026-11-05双区域定位本地健全性实验：构造左右两个选择器，冻结四个设计、三套输入延迟约束与12%动作面积预算；四设计源级/门级证明、12次配置STA及2次STA复跑通过。定位假设满足='+str(summary['all_predeclared_hypotheses_met'])+'。对称构造不能证明STA模型优势，零API，不记新胜出案例。'
for file,prefix in [(ROOT/'EXPERIMENT_INDEX.md',''),(ROOT/'docs/CURRENT_STATUS.md','../')]:file.write_text(entry+' [真实证据]('+prefix+rel+'/INTERPRETATION.md)。\n\n'+file.read_text(encoding='utf-8'),encoding='utf-8')
print(json.dumps(findings,indent=2),flush=True);print('All predeclared hypotheses met: '+str(summary['all_predeclared_hypotheses_met']),flush=True);print('Report: '+str(S/'INTERPRETATION.md'),flush=True)
