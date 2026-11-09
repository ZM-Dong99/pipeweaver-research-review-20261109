"""Independently reproduce selections, then report the completed batch honestly."""
from pathlib import Path
import sys,json,hashlib,shutil,importlib.util
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate
S=ROOT/'eda/experiments/mux_feedback_study_20261104_155643_522144'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def save(name,x):(S/name).write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'summary.json');a=load(S/'AUDIT.json');assert a['passed']
base=p['baseline'];roles={'baseline':(S/'inputs/original.v',base)}
spec=importlib.util.spec_from_file_location('mux_visible_adapter',S/'code_snapshot/rtl_optimizer.py');adapter=importlib.util.module_from_spec(spec);sys.modules[spec.name]=adapter;spec.loader.exec_module(adapter)
trace=[]
for r in s['trials']:
    f=S/r['arm']/f"trial_{r['trial']:02d}";request=load(f/'api_audit/request.json');visible=None
    if r['status']=='GENERATED':visible=adapter._parse_content(load(f/'api_audit/response.json')['choices'][0]['message']['content'])[1]
    trace.append(dict(call_index=r['call_index'],arm=r['arm'],actual_request_sha256=sha(f/'api_audit/request.json'),actual_supplied_path_count=request['body']['messages'][-1]['content'].count('Startpoint:'),candidate_sha256=r['candidate_sha256'],visible_output_explanation=visible,actual_eda_result=r['raw_metrics'],selected=r['selected']))
save('FEEDBACK_TRACE.json',dict(scope='Transmitted paths, visible structured output, source hash and EDA linkage. Visible explanations are model claims, not internal reasoning or proof of causal benefit.',rows=trace))
for arm in ['no_sta','sta']:
    candidates=[r for r in s['trials'] if r['arm']==arm and r['selected']=='candidate']
    if candidates:
        r=min(candidates,key=lambda r:(r['retained_metrics']['max_data_arrival_ns'],r['retained_metrics']['mapped_area_um2'],r['call_index']))
        roles[arm]=(S/arm/f"trial_{r['trial']:02d}"/'candidate.v',r['retained_metrics'])
    else:roles[arm]=roles['baseline']
dev=ROOT/'eda/experiments/mux_action_development_20261104_154849_392802';manual=load(dev/'SUMMARY.json')['results']['decoded_masks']
roles['known_manual_reference']=(S/'development_reference/decoded_masks.v',manual)
cache={};cases=[];role_output={}
for role,(source,m) in roles.items():
    h=sha(source)
    if h not in cache:
        f=S/'independent_reproduction'/role
        new=load(f/'result.json') if (f/'result.json').exists() else evaluate(source,f,S/'inputs/original.v',0,top='mux_large',parameters={})
        keys=['status','formal','mapped_formal','max_data_arrival_ns','mapped_area_um2','mapped_sha256','electrical'];matches={k:new.get(k)==m.get(k) for k in keys}
        cache[h]=dict(role=role,source_sha256=h,result=str(f/'result.json'),passed=all(matches.values()),comparisons=matches)
        cases.append(cache[h]);print('Reproduction '+role+': '+str(cache[h]['passed']),flush=True)
    role_output[role]=dict(source=str(source),source_sha256=h,reproduced_by=cache[h]['role'],delay_ns=m['max_data_arrival_ns'],area_um2=m['mapped_area_um2'])
reproduction=dict(passed=all(r['passed'] for r in cases),model_requests=0,cases=cases,roles=role_output)
save('REPRODUCTION.json',reproduction)
if not reproduction['passed']:raise RuntimeError('Reproduction mismatch preserved; do not claim finalized reproducible results')
lines=['# 数据选择器：真实LLM有无STA反馈对照','',
       '公开10路8位mux_large，两个条件各5次独立请求，使用同一网关请求模型gpt-6.1-sol。每次自由生成一份RTL；所有生成冻结后，再统一进行源级/映射后等价验证和STA。失败、超面积或无严格改善均保留原始设计。没有重试、修复调用或补抽。', '',
       '| 条件 | 实际尝试 | 生成RTL | 源级形式通过 | 合格改进 | 至少5%改进 | 保留后中位延迟(ns) | 最佳保留延迟(ns) |', '|---|---|---|---|---|---|---|---|']
for arm,g in s['groups'].items():lines.append(f"| {arm} | {g['attempts']} | {g['generated']} | {g['formal_pass']} | {g['strict_improvements']} | {g['gains_at_least_5pct']} | {g['median_retained_delay_ns']} | {g['best_retained_delay_ns']} |")
lines += ['', f"原始基线：{base['max_data_arrival_ns']:.2f}ns、{base['mapped_area_um2']:.4f}µm²；面积上限{p['area_cap_um2']:.6f}µm²（原始110%，是实验约束而非通用工程标准）。", '',
          '| 请求 | 条件 | 状态 | 实测原始候选延迟(ns) | 面积(µm²) | 面积变化 | 最终采用 | 保留后延迟(ns) |', '|---|---|---|---|---|---|---|---|']
errors=[]
for r in sorted(s['trials'],key=lambda r:r['call_index']):
    m=r['raw_metrics'] or {};delay=m.get('max_data_arrival_ns');area=m.get('mapped_area_um2');change=f'{(area/base["mapped_area_um2"]-1)*100:+.2f}%' if area is not None else '—'
    lines.append(f"| {r['call_index']} | {r['arm']} | {r['status']}; EDA={m.get('status','未运行')} | {delay if delay is not None else '—'} | {area if area is not None else '—'} | {change} | {r['selected']} | {r['retained_metrics']['max_data_arrival_ns']} |")
    if r.get('error'):errors.append(f"- 请求{r['call_index']}：{r['error']}")
    if m.get('failure_reason'):errors.append(f"- 请求{r['call_index']} EDA失败：{m['failure_reason']}")
lines += ['', '失败记录：']+(errors or ['无生成/EDA失败记录。'])
unknown=sum(r['status']=='INTERRUPTED_UNKNOWN_OUTCOME' for r in s['trials'])
if unknown:
    lines += ['', f'执行中断影响{unknown}个请求槽位：已保存请求，但服务端处理、返回及计费状态未知。该槽位占用原授权额度，按规则回退基线，没有重发或补抽。INTERRUPTION.json保留观察与处理记录。10个槽位不等于10次已确认成功传输。']
lines += ['', '## 成功返回条件统计与手工参考', '',
          '主要结果包含全部尝试；以下成功返回条件统计只帮助识别通信混杂，不能替代主要结果。']
for arm,g in s['groups'].items():lines.append(f"- {arm}：成功生成{g['generated']}/5，成功生成子集保留后延迟中位数{g['successful_generation_median_delay_ns']}ns。")
lines += ['', '| 复跑角色 | 延迟(ns) | 面积(µm²) |', '|---|---|---|']
for role,m in role_output.items():lines.append(f"| {role} | {m['delay_ns']} | {m['area_um2']:.4f} |")
lines += ['', '手工decoded_masks参考来自本案例已完成的六动作开发，并非本轮模型生成；不能并入STA组，也不是同等开发成本的竞争方法。若模型结果仅达到手工参考，不能据此声称反馈产生独有结构创新。', '',
          '## 结论边界与可核查证据', '',
          '本轮在已做过手工动作开发的同一公开23行设计上开展，提示不含手工候选或其PPA，但属于开发条件探索，不是独立盲测。每组5次、单个短组合模块，不能证明统计显著、跨家族泛化或普遍优势。两组调用次数相同，STA组提示更长，token成本不相同。', '',
          'request.json可核查实际发送的RTL、契约以及STA组三条真实基线路径；response.json保存网关实际可见返回。它们不能证明模型内部的推理过程。第三方后端身份未独立核验；性能为SKY130HD TT固定IO条件的布局布线前估计，无功耗、物理寄生或硅片签核结论。', '',
          f"本轮10次尝试，保存provider响应{a['actual_provider_responses']}份；收到响应报告token合计{a['provider_reported_tokens']}，未据未知单价估算账单。{a['check_count']}项证据审计通过，{len(cases)}个去重角色来源完成新的独立完整复跑；复跑不是新模型样本。", '',
          'FEEDBACK_TRACE.json将每次实际发送的路径数、请求哈希、模型可见结构化解释、候选哈希及EDA结果连接起来，便于核查。解释仍是模型可见输出，不是内部推理证据。', '',
          '原始入口：protocol.json、AUTHORIZATION.json、prompts/、candidate_manifest.json、各trial的generation.json与api_audit/request.json/response.json/transport.json、evaluation/formal.log/mapped_formal.log/mapping.log/sta.log/result.json、summary.json、AUDIT.json、REPRODUCTION.json、FEEDBACK_TRACE.json。']
ng=s['groups']['no_sta'];sg=s['groups']['sta'];sm=role_output['sta'];nm=role_output['no_sta']
assessment=dict(primary_metric='median_retained_delay_ns',no_sta_primary=ng['median_retained_delay_ns'],sta_primary=sg['median_retained_delay_ns'],count_as_sta_group_win=False,
    sta_best_candidate_faster=sm['delay_ns']<nm['delay_ns'],sta_best_candidate_lower_area=sm['area_um2']<nm['area_um2'],causal_feedback_advantage_established=False,
    network_or_generation_failures_no_sta=sum(r['arm']=='no_sta' and r['status']=='FAILED_GENERATION' for r in s['trials']),network_or_generation_failures_sta=sum(r['arm']=='sta' and r['status']=='FAILED_GENERATION' for r in s['trials']),unknown_outcome_slots=unknown)
save('MIXED_RESULT.json',assessment)
lines[2:2]=['本轮标记：混合结果，不计作第三个STA整组胜出案例。预定主要指标（全部尝试保留后中位数）无STA为0.90ns，STA为1.04ns；最佳合格候选则STA为0.80ns/792.0096µm²，无STA为0.88ns/799.5168µm²。两组分别有一次连接失败，STA另有一次执行中断结果未知，小样本且返回数不同，不能建立因果优势。', '',
    '最佳STA候选通过显式one-hot数据掩码和化简默认输入选择条件重写。其block_a使能为(sel==0)或(sel[3]且(sel[2]或sel[1]))，仍完整保留sel=10～15输出block_a。相对原始延迟下降23.08%、面积下降13.41%；相对本轮无STA最佳延迟下降9.09%。这是本轮测量的最佳候选比较，不替代主要指标。', '']
counterexample=S/'formal_failure_reproduction/RESULT.json'
if counterexample.exists():
    assert load(counterexample)['expected_inequivalence_reproduced']
    lines += ['', '额外真实反例验证：无STA请求4（trial_02）源级SAT失败。独立Icarus仿真令sel=12、block_i=1、其余数据=0，原始输出0、候选输出1，确认默认分支被错误改写。见formal_failure_reproduction/RESULT.json及simulation.log。该结果确认候选有错，不是候选通过验证。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
(S/'exports').mkdir(exist_ok=True)
for role,(source,m) in roles.items():shutil.copyfile(source,S/'exports'/(role+'.v'))
shutil.copyfile(S/'inputs/LICENSE',S/'exports/LICENSE')
save('STATUS.json',dict(state='COMPLETED_AUDITED_REPRODUCED',attempted_request_slots=10,unknown_outcome_slots=unknown,actual_provider_responses=a['actual_provider_responses']))
evidence_files=['protocol.json','AUTHORIZATION.json','candidate_manifest.json','summary.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md','FEEDBACK_TRACE.json','MIXED_RESULT.json']
if (S/'INTERRUPTION.json').exists():evidence_files.append('INTERRUPTION.json')
if counterexample.exists():evidence_files.append('formal_failure_reproduction/RESULT.json')
save('FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_REPRODUCED',attempted_request_slots=10,unknown_outcome_slots=unknown,actual_provider_responses=a['actual_provider_responses'],provider_reported_tokens=a['provider_reported_tokens'],audit_checks=a['check_count'],independent_reproductions=len(cases),groups=s['groups'],selected_roles=role_output,hashes={f:sha(S/f) for f in evidence_files}))
(S/'README_PREPARATION.md').write_bytes((S/'README.md').read_bytes()) if not (S/'README_PREPARATION.md').exists() else None
(S/'README.md').write_text('# 本轮10次模型尝试已完成\n\n[完整真实结果与限制](INTERPRETATION.md)、[全部机器结果](summary.json)、[审计](AUDIT.json)、[独立复跑](REPRODUCTION.json)。准备状态保存在README_PREPARATION.md。\n',encoding='utf-8')
text='2026-11-04数据选择器真实模型对照完成：10次尝试，无重试补抽。'
for arm,g in s['groups'].items():text+=f" {arm}合格改进{g['strict_improvements']}/5，中位{g['median_retained_delay_ns']}ns，最佳{g['best_retained_delay_ns']}ns。"
text+=' 同一已暴露开发案例、小样本，完整保留失败与超面积，手工参考另列。'
rel=str(S.relative_to(ROOT)).replace('\\','/')
for file,prefix in [(ROOT/'EXPERIMENT_INDEX.md',''),(ROOT/'docs/CURRENT_STATUS.md','../')]:
    previous=file.read_text(encoding='utf-8');entry=text+' [完整真实证据]('+prefix+rel+'/INTERPRETATION.md)。\n\n'
    if entry not in previous:file.write_text(entry+previous,encoding='utf-8')
print(json.dumps(s['groups'],indent=2),flush=True);print('Report: '+str(S/'INTERPRETATION.md'),flush=True)
