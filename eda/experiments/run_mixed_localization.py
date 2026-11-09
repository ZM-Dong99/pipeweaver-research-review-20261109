"""Heterogeneous mux/encoder localization development; no model calls."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import sys,json,re,hashlib,shutil,os
R=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(R));sys.path.insert(0,str(R/'eda/experiments'))
from agents.action_loop import evaluate
from rewrite.mux_rewrites import materialize as mux_rewrite
from rewrite.priority_rewrites import materialize as priority_rewrite
from run_native_comb import execute,parse_electrical_report
LIB=R/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def save(f,x):f.write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
def wsl(f):
    x=f.resolve().as_posix();return '/mnt/'+x[0].lower()+x[2:]
def endpoint_action(endpoint):
    if endpoint.startswith('selected_data['):return 'rewrite_mux'
    if endpoint.startswith(('request_valid ','request_index[','request_onehot[')):return 'rewrite_priority'
    return 'baseline'
S=R/'eda/experiments'/datetime.now().strftime('mixed_localization_%Y%m%d_%H%M%S_%f');S.mkdir()
for sub in ['inputs','designs','profiles','code_snapshot']:(S/sub).mkdir()
source_files={'mux.v':R/'benchmark/rtl_opt_upstream_hkust/benchmark/mux_large/mux_large.v','priority.v':R/'benchmark/engineering_sources_20261030/verilog-axis/rtl/priority_encoder.v','MUX_LICENSE':R/'benchmark/rtl_opt_upstream_hkust/LICENSE','PRIORITY_LICENSE':R/'benchmark/engineering_sources_20261030/verilog-axis/COPYING'}
for name,f in source_files.items():shutil.copyfile(f,S/'inputs'/name)
mux=(S/'inputs/mux.v').read_text(encoding='utf-8');priority=(S/'inputs/priority.v').read_text(encoding='utf-8')
mux_new=mux_rewrite(mux,dict(operator='masked_mux_default',encoding='minimal'));pri_new=priority_rewrite(priority,dict(operator='grouped_priority',encoding='group_factored',group_bits=8))
top='''module mixed_datapath (
    input wire [79:0] mux_data,
    input wire [3:0] mux_sel,
    input wire [63:0] requests,
    output wire [7:0] selected_data,
    output wire request_valid,
    output wire [5:0] request_index,
    output wire [63:0] request_onehot
);
'''
ports=[f'.block_{c}(mux_data[{8*i} +: 8])' for i,c in enumerate('abcdefghij')]+['.sel(mux_sel)','.block_out(selected_data)']
top+='choice_block choice ('+', '.join(ports)+');\n'
top+='''request_block #(.WIDTH(64), .LSB_HIGH_PRIORITY(0)) request_path (
    .input_unencoded(requests), .output_valid(request_valid),
    .output_encoded(request_index), .output_unencoded(request_onehot)
);
endmodule
'''
choices={'baseline':(False,False),'rewrite_mux':(True,False),'rewrite_priority':(False,True),'rewrite_both':(True,True)}
for name,(m,p) in choices.items():
    a,n=re.subn(r'\bmodule\s+mux_large\b','module choice_block',mux_new if m else mux,count=1);assert n==1
    b,n=re.subn(r'\bmodule\s+priority_encoder\b','module request_block',pri_new if p else priority,count=1);assert n==1
    (S/'designs'/(name+'.v')).write_text(top+'\n'+a+'\n'+b,encoding='utf-8')
profiles={'balanced':dict(mux=0.,priority=0.),'mux_delay050':dict(mux=.50,priority=0.),'mux_delay090':dict(mux=.90,priority=0.),'both_offset':dict(mux=.60,priority=.20),'priority_delay030':dict(mux=0.,priority=.30)}
for name,v in profiles.items():
    sdc='''create_clock -name virtual_clk -period 100.0
set_input_delay -max 0.0 -clock virtual_clk [all_inputs]
set_output_delay -max 0.0 -clock virtual_clk [all_outputs]
set_input_transition 0.10 [all_inputs]
set_load 0.010 [all_outputs]
set mux_ports [get_ports {mux_data* mux_sel*}]
set priority_ports [get_ports {requests*}]
if {[llength $mux_ports] != 84 || [llength $priority_ports] != 64} {error "Region input count mismatch"}
if {[llength [all_inputs]] != 148 || [llength [all_outputs]] != 79} {error "Top interface count mismatch"}
'''+f"set_input_delay -max {v['mux']:.2f} -clock virtual_clk $mux_ports\nset_input_delay -max {v['priority']:.2f} -clock virtual_clk $priority_ports\n"
    (S/'profiles'/(name+'.sdc')).write_text(sdc,encoding='ascii')
deps=[Path(__file__).resolve(),R/'agents/action_loop.py',R/'rewrite/mux_rewrites.py',R/'rewrite/priority_rewrites.py',R/'eda/experiments/run_native_comb.py',R/'eda/experiments/trace_sta_rtl_cone.py']
for f in deps:shutil.copyfile(f,S/'code_snapshot'/f.name)
protocol=dict(client_date='2026-11-05',kind='HETEROGENEOUS_CONSTRUCTED_LOCALIZATION_DEVELOPMENT',model_requests=0,top='mixed_datapath',parameters={},inputs=148,outputs=79,
    origin='Manual independent composition of public10x8 mux and64-way MSB encoder. Both components and rewrites already exposed during development, not a new natural benchmark or independent holdout.',
    earlier_failed_attempt='mixed_localization_20261105_140731_693499: baseline mapping failed with foreign ABC script reference. No candidate/constraint substitution; rerun after per-output cwd/tmp isolation and Windows path normalization. Old records retained.',
    choices=choices,profiles=profiles,area_ratio_limit=1.10,action_count_budget=1,
    contract='All148 two-state inputs unrestricted, all79 outputs preserved including encoder encoded/onehot values when valid0, mux sel10..15 default a. No latency/state/assumptions, no X/Z equivalence claim.',
    timing='One fixed mapping per design with identical ABC driver/load; replay exact proven netlists across five predeclared input-delay profiles. No constraint-aware remapping or physical parasitics.',
    policies=['fixed_mux','fixed_priority','largest_input_delay','baseline_sta_endpoint'],tie_policy='largest_input_delay chooses mux on ties; original retained if chosen action gives no strict eligible improvement',
    hypotheses='At least one nonbalanced profile prefers mux and one prefers priority under one action. At least two profiles have STA endpoint policy >=0.05ns better than largest_input_delay. Primary is per-profile retained delay and >=5% gain counts, never statistical inference from five correlated configurations.',
    fairness='Future both LLM arms must receive same full RTL, explicit delay/IO constraints, action semantics, action budget and area cap. STA arm only adds actual baseline paths. Simplistic rule failure does not prove no-STA LLM cannot infer internal depth. Do not buy API solely because one heuristic fails.',
    both_rewrite='Diagnostic larger-budget reference only, excluded by action count even if lower area. Action budget is separate from area budget.',
    independent_replays='Predeclared mux_delay050 and mux_delay090: repeat baseline and baseline-endpoint-policy selected mapping/constraints, not newly synthesized candidates.',
    source_sha256={f.name:sha(f) for f in (S/'inputs').iterdir()},design_sha256={n:sha(S/'designs'/(n+'.v')) for n in choices},sdc_sha256={n:sha(S/'profiles'/(n+'.sdc')) for n in profiles},liberty_sha256=sha(LIB),code_sha256={str(f):sha(f) for f in deps})
save(S/'protocol.json',protocol);(S/'protocol.sha256').write_text(sha(S/'protocol.json')+'\n',encoding='ascii');print('Frozen: '+str(S),flush=True)
def mapping(n):
    m=evaluate(S/'designs'/(n+'.v'),S/'mapping'/n,S/'designs/baseline.v',0,top='mixed_datapath',parameters={});print('Mapping '+n+': '+str(m.get('status'))+' area='+str(m.get('mapped_area_um2')),flush=True);return n,m
with ThreadPoolExecutor(max_workers=2) as pool:maps=dict(pool.map(mapping,choices))
save(S/'MAPPING_RESULTS.json',maps)
if not all(m.get('status')=='PASS' for m in maps.values()):raise RuntimeError('Qualification failed; retain all frozen inputs and results, no API calls')
env=os.environ.copy()
for k in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(k,None)
def timing(job,replay=False):
    profile,n=job;out=S/('independent_sta_replay' if replay else 'sta')/profile/n;out.mkdir(parents=True,exist_ok=False);sdc=S/'profiles'/(profile+'.sdc');netlist=S/'mapping'/n/'mapped_sta.v';assert sha(netlist)==maps[n]['sta_netlist_sha256']
    tcl='\n'.join([f'read_liberty {{{wsl(LIB)}}}',f'read_verilog {{{wsl(netlist)}}}','link_design mixed_datapath',f'read_sdc {{{wsl(sdc)}}}','puts "PW_INPUT_COUNT [llength [all_inputs]]"','puts "PW_OUTPUT_COUNT [llength [all_outputs]]"','report_checks -path_delay max -format full_clock_expanded -group_path_count 10','report_worst_slack -max','report_tns -max','puts {PW_ELECTRICAL_BEGIN}','report_check_types -max_slew -max_capacitance -violators -digits 6','puts {PW_ELECTRICAL_END}',''])
    (out/'run_sta.tcl').write_text(tcl,encoding='utf-8');raw=execute(['wsl.exe','-d','Ubuntu','--',os.environ.get('OPENSTA','/home/easton1/OpenSTA/build/sta'),'-no_splash','-exit',wsl(out/'run_sta.tcl')],R,out/'sta.log',env,120)
    electrical=parse_electrical_report(raw);assert electrical['status']=='PASS';m=dict(profile=profile,design=n,max_data_arrival_ns=max(float(v) for v in re.findall(r'([-+\d.]+)\s+data arrival time',raw)),mapped_area_um2=maps[n]['mapped_area_um2'],critical_startpoint=re.search(r'Startpoint:\s*(.+)',raw).group(1),critical_endpoint=re.search(r'Endpoint:\s*(.+)',raw).group(1),wns_ns=float(re.search(r'worst slack max\s+([-+\d.]+)',raw).group(1)),tns_ns=float(re.search(r'tns max\s+([-+\d.]+)',raw).group(1)),electrical=electrical,sta_netlist_sha256=sha(netlist),sdc_sha256=sha(sdc),input_count_verified='PW_INPUT_COUNT 148' in raw,output_count_verified='PW_OUTPUT_COUNT 79' in raw)
    save(out/'result.json',m);print(('Replay ' if replay else 'STA ')+profile+' '+n+': '+str(m['max_data_arrival_ns']),flush=True);return profile,n,m
# Freeze policy decisions using only baseline STA, not candidate timing outcomes.
with ThreadPoolExecutor(max_workers=2) as pool:base_rows=list(pool.map(timing,[(profile,'baseline') for profile in profiles]))
baseline={profile:m for profile,n,m in base_rows};decisions=[]
for profile,v in profiles.items():
    raw=(S/'sta'/profile/'baseline/sta.log').read_text(encoding='utf-8');endpoint=re.search(r'Endpoint:\s*(.+)',raw).group(1)
    for policy,action in [('fixed_mux','rewrite_mux'),('fixed_priority','rewrite_priority'),('largest_input_delay','rewrite_mux' if v['mux']>=v['priority'] else 'rewrite_priority'),('baseline_sta_endpoint',endpoint_action(endpoint))]:decisions.append(dict(profile=profile,policy=policy,action=action,baseline_endpoint=endpoint))
save(S/'POLICY_DECISIONS.json',dict(frozen_before_candidate_scenario_sta=True,decisions=decisions))
with ThreadPoolExecutor(max_workers=2) as pool:rows=base_rows+list(pool.map(timing,[(profile,n) for profile in profiles for n in choices if n!='baseline']))
timings={profile:{n:m for pr,n,m in rows if pr==profile} for profile in profiles};cap=maps['baseline']['mapped_area_um2']*1.10;policy_rows=[];oracle={}
for profile,pool in timings.items():
    eligible=[n for n in choices if sum(choices[n])<=1 and pool[n]['mapped_area_um2']<=cap];eligible.sort(key=lambda n:(pool[n]['max_data_arrival_ns'],pool[n]['mapped_area_um2'],n));oracle[profile]=eligible[0]
for d in decisions:
    profile=d['profile'];action=d['action'];pool=timings[profile];base=pool['baseline'];m=pool[action];eligible=sum(choices[action])<=1 and m['mapped_area_um2']<=cap
    retained=m if eligible and m['max_data_arrival_ns']<base['max_data_arrival_ns'] else base
    policy_rows.append(dict(**d,eligible=eligible,retained_delay_ns=retained['max_data_arrival_ns'],gain_percent=100*(1-retained['max_data_arrival_ns']/base['max_data_arrival_ns']),oracle=oracle[profile],regret_ns=retained['max_data_arrival_ns']-pool[oracle[profile]]['max_data_arrival_ns']))
by={(r['profile'],r['policy']):r for r in policy_rows};distinct={oracle[k] for k in profiles if k!='balanced'}
hypotheses=dict(mux_and_priority_both_preferred_in_nonbalanced={'rewrite_mux','rewrite_priority'}<=distinct,sta_beats_largest_input_by005_in_at_least_two=sum(by[pr,'largest_input_delay']['retained_delay_ns']-by[pr,'baseline_sta_endpoint']['retained_delay_ns']>=.05 for pr in profiles)>=2)
save(S/'SUMMARY.json',dict(model_requests=0,mapping=maps,timings=timings,area_cap_um2=cap,oracle=oracle,policies=policy_rows,hypotheses=hypotheses,all_predeclared_hypotheses_met=all(hypotheses.values())))
replays=[]
for profile in ['mux_delay050','mux_delay090']:
    for n in dict.fromkeys(['baseline',by[profile,'baseline_sta_endpoint']['action']]):
        pr,n,m=timing((profile,n),True);replays.append(dict(profile=profile,design=n,passed=m==timings[profile][n]))
save(S/'REPRODUCTION.json',dict(passed=all(r['passed'] for r in replays),cases=replays,model_requests=0,scope='Independent STA-only reruns on identical proven mapping/SDC, not fresh synthesis or model samples.'))
checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol frozen',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip());check('library frozen',sha(LIB)==protocol['liberty_sha256'])
for n,h in protocol['design_sha256'].items():check('design '+n,sha(S/'designs'/(n+'.v'))==h)
for pr,h in protocol['sdc_sha256'].items():check('SDC '+pr,sha(S/'profiles'/(pr+'.sdc'))==h)
for n,m in maps.items():
    f=S/'mapping'/n;t=load(f/'protocol.json');check(n+' reference',t['reference_sha256']==protocol['design_sha256']['baseline'] and t['top']=='mixed_datapath' and t['parameter_overrides']=={})
    for stage in ['formal','mapped_formal']:check(n+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (f/(stage+'.log')).read_text(encoding='utf-8'))
    check(n+' mapped hash',sha(f/'mapped.v')==m['mapped_sha256'] and sha(f/'mapped_sta.v')==m['sta_netlist_sha256'])
    check(n+' measured area',float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(f/'mapping.log').read_text(encoding='utf-8'))[-1])==m['mapped_area_um2'])
for profile,n,m in rows:
    raw=(S/'sta'/profile/n/'sta.log').read_text(encoding='utf-8');label=profile+' '+n
    check(label+' raw arrival',max(float(v) for v in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns']);check(label+' electrical',parse_electrical_report(raw)==m['electrical']);check(label+' interface',m['input_count_verified'] and m['output_count_verified']);check(label+' frozen mapping/SDC',m['sta_netlist_sha256']==maps[n]['sta_netlist_sha256'] and m['sdc_sha256']==protocol['sdc_sha256'][profile])
for replay in replays:check('replay '+replay['profile']+' '+replay['design'],replay['passed'])
audit=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks);save(S/'AUDIT.json',audit);assert audit['passed']
lines=['# 非对称多路径定位开发：选择器与优先编码器','',
    '零API，手工组合既有公开10路8位选择器和64路优先编码器。两个不同结构、148个输入位、79个输出位；所有输出完整等价，包括无有效请求时的编码器输出默认值。属于已暴露组件的开发性构造，不是新自然工程基准或独立盲测。', '',
    '四个设计映射前一次冻结；每次至多改一个区域、面积不超过原110%。双改版本仅为更大次数预算诊断参照。相同已证明网表用五套预先冻结约束运行STA，不按约束重新综合。模型对照如开展，两组必须同样获得完整约束与动作契约。', '',
    '| 配置 | mux输入延迟(ns) | priority输入延迟(ns) | 原始(ns) | 改mux(ns) | 改priority(ns) | 单动作实测最优 |', '|---|---|---|---|---|---|---|']
for profile,v in profiles.items():
    pool=timings[profile];lines.append(f"| {profile} | {v['mux']:.2f} | {v['priority']:.2f} | {pool['baseline']['max_data_arrival_ns']:.2f} | {pool['rewrite_mux']['max_data_arrival_ns']:.2f} | {pool['rewrite_priority']['max_data_arrival_ns']:.2f} | {oracle[profile]} |")
lines += ['', '| 策略 | 配置 | 选择 | 保留后延迟(ns) | 改进 | 与单动作最优差距(ns) |', '|---|---|---|---|---|---|']
for r in policy_rows:lines.append(f"| {r['policy']} | {r['profile']} | {r['action']} | {r['retained_delay_ns']:.2f} | {r['gain_percent']:.2f}% | {r['regret_ns']:.2f} |")
lines += ['', '假设检查（测量前写入protocol.json，不满足也保留）：'+json.dumps(hypotheses,ensure_ascii=False), '',
    f'四个完整源级/门级证明与映射、20个配置STA、{len(replays)}次独立STA复跑、{audit["check_count"]}项审计通过。这些不是24个独立设计或模型样本。完整两区域与双改的面积、时序结果均在SUMMARY.json；面积上限{cap:.6f}µm²。', '',
    '规则选择先根据实际原始STA端点或完整输入约束写入POLICY_DECISIONS.json，再测量候选场景时序，未用候选PPA决定规则输出。端点只关联到这个构造顶层的已知独立区域，不是通用逐门RTL归因器。', '',
    '局限：五个配置相关、组件已暴露，且较聪明的无STA模型可能从RTL结构与约束估算瓶颈。largest_input_delay规则失败只排除了一个简单解释，不证明无STA LLM必然失败。无新模型请求，不是STA组胜出案例，不保证后续对照胜利。固定TT库、理想时钟、无物理寄生与功耗签核。', '',
    '证据：protocol.json、POLICY_DECISIONS.json、SUMMARY.json、AUDIT.json、REPRODUCTION.json；mapping/保存源级/门级证明、综合和映射；profiles/保存SDC，sta/及independent_sta_replay/保存实际TCL、STA日志与结果。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
save(S/'FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_STA_REPLAYED',model_requests=0,complete_mapped_proofs=4,scenario_sta_measurements=20,independent_sta_replays=len(replays),audit_checks=audit['check_count'],hypotheses=hypotheses,hashes={f:sha(S/f) for f in ['protocol.json','POLICY_DECISIONS.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']}))
rel=str(S.relative_to(R)).replace('\\','/')
entry='2026-11-05非对称选择器+优先编码器定位开发完成：四设计完整证明、20配置STA和预定复跑通过，零API。单动作最优位置切换及简单约束规则对照详见原始结果，不作LLM优势或统计独立性结论。'
for file,prefix in [(R/'EXPERIMENT_INDEX.md',''),(R/'docs/CURRENT_STATUS.md','../')]:file.write_text(entry+' [真实证据]('+prefix+rel+'/INTERPRETATION.md)。\n\n'+file.read_text(encoding='utf-8'),encoding='utf-8')
print(json.dumps(hypotheses),flush=True);print('Report: '+str(S/'INTERPRETATION.md'),flush=True)
