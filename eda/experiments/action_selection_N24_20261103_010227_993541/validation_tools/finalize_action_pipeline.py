"""Archive actual model selection, parser repair replay and separate local action."""
import json
from pathlib import Path
import re
import shutil
ROOT=Path(r'D:\verilog_lab\PipeWeaver');E=ROOT/'eda/experiments'
import sys
sys.path.insert(0,str(ROOT))
from agents.action_loop import sha,load,save
S=E/'action_selection_N24_20261103_010227_993541';F=E/'selector_factoring_development_20261103_170211_609482'
p=load(S/'protocol.json');s=load(S/'summary.json');audit=load(S/'AUDIT.json');replay=load(S/'PARSER_FIX_REPLAY.json');repro=load(S/'REPRODUCTION.json')
assert audit['passed'] and repro['passed'] and replay['valid_replayed_selections']==6

# The additional hand-designed action is audited independently of the model pool.
fp=load(F/'protocol.json');fs=load(F/'SUMMARY.json');fr=load(F/'REPRODUCTION.json');checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('frozen local protocol',sha(F/'protocol.json')==(F/'protocol.sha256').read_text().strip())
check('fixed single source',sha(F/'candidate.v')==fp['candidate_sha256'] and sha(F/'inputs/original.v')==fp['source_sha256'])
for rel,h in fp['code_sha256'].items():check('code '+rel,sha(ROOT/rel)==sha(F/'code_snapshot'/Path(rel).name)==h)
for path,h in fp['baseline_artifact_sha256'].items():check('old evidence '+path,sha(Path(path))==h)
for row in fs['results']:
    folder=F/f"N{row['N']}";m=row['metrics'];cp=load(folder/'protocol.json')
    check(str(row['N'])+' fixed reference/width',cp['reference_sha256']==fp['source_sha256'] and cp['candidate_sha256']==fp['candidate_sha256'] and cp['parameter_overrides']=={'N':row['N']})
    check(str(row['N'])+' actual result',load(folder/'result.json')==m)
    for stage in ['formal','mapped_formal']:check(str(row['N'])+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
    text=(folder/'sta.log').read_text(encoding='utf-8')
    check(str(row['N'])+' measured arrival',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',text))==m['max_data_arrival_ns'])
    area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1])
    check(str(row['N'])+' measured area',area==m['mapped_area_um2'])
    check(str(row['N'])+' actual mapped hash',sha(folder/'mapped.v')==m['mapped_sha256'])
    b=row['baseline_metrics'];expected=m['status']=='PASS' and m['eligible'] and m['mapped_area_um2']<=b['mapped_area_um2']*1.10 and m['max_data_arrival_ns']<b['max_data_arrival_ns']-1e-9
    check(str(row['N'])+' unchanged acceptance',row['strict_improvement']==expected)
check('two independent local replays',fr['passed'] and fr['independent_replays']==2)
fa=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,scope='Post-hoc one-action local development, distinct from original model experiment')
save(F/'AUDIT.json',fa);assert fa['passed']
flines=['# 新增输出因式分解动作：事后本地开发','',
'该动作在原24位六动作空间无时序收益之后设计，候选源码在四个新测量前冻结。零模型调用，没有加入或替换原模型实验的六动作目录。单一源码分别测N24/1/13/32，不是四个独立电路家族。','',
'主开发实例24位没有时序改善：1.21→1.48ns；面积833.2992→733.2032 µm²（-12.01%）。这是面积与延迟折中，不是本轮时序目标的成功。1位边界得到0.68→0.55ns、面积178.9216→98.8448 µm²，仅为边界结果，不能替代主结论。','',
'| N | 原始到达ns | 新到达ns | 原面积 | 新面积 | 预算内时序改善 |','|---|---:|---:|---:|---:|---|']
for row in fs['results']:
    b,m=row['baseline_metrics'],row['metrics'];flines.append(f"| {row['N']} | {b['max_data_arrival_ns']:.2f} | {m['max_data_arrival_ns']:.2f} | {b['mapped_area_um2']:.4f} | {m['mapped_area_um2']:.4f} | {'是' if row['strict_improvement'] else '否'} |")
flines += ['', '四份参数实例均通过源级/实际门级SAT及STA，主实例与1位边界独立复跑一致。因式分解利用cmp_equal与cmp_greater不可能同时为真的语义，此性质来自比较定义，未对外部输入增加假设。全部SEL为定义二进制输入时等价；不声称SEL含X/Z时的四态仿真等价。标准布尔因式分解，不作算法首创主张。','',
f'[冻结协议](protocol.json)；[原始结果](SUMMARY.json)；[{fa["check_count"]}项审计](AUDIT.json)；[独立复跑](REPRODUCTION.json)。']
(F/'INTERPRETATION.md').write_text('\n'.join(flines)+'\n',encoding='utf-8')

lines=['# 真实模型只选动作：24位比较器先导实验','',
'本轮完成6次真实请求，两组各3次。每次只能选择两个不同动作ID；程序从固定目录生成RTL，模型没有提供可执行RTL。全部选择结束并冻结后，才统一测量六个固定动作。本轮请求额度已用完。','',
'## 结论先行','',
'原始基线1.21ns、833.2992 µm²。完整六动作枚举也没有在原10%面积预算内找到严格更快版本，保留原始。此动作空间在N24没有可达的时序收益，因此本轮不能检验STA是否帮助模型选到更好的电路，也不能将零收益解释为模型能力差。','',
'两组模型最终选择都指向balanced_4和balanced_8（部分顺序相反），没有观察到STA改变动作集合。balanced_4为1.21ns且面积更大；balanced_8为1.30ns、面积更小，均不是时序改进。','',
'## 格式问题与修复，分别记录','',
'冻结的严格JSON解析器只接受2/6份响应；另4份可见响应有完整leading think包裹而被拒绝。这是适配器兼容问题。保存原始结果summary.json和冻结解析器，未修改四个失败槽位，也未重发请求。','',
'当前适配器只规范化完整的前导包裹或单一JSON代码围栏，再执行原字段/重复键/动作白名单/源码校验。11项正反例通过；六份存档真实响应离线重放均解析出合法动作。重放明确标记POSTHOC，不是新模型调用或原冻结实验的替代主结果。修复后尚未发起新的独立联网验证。','',
'| 组别 | 实际请求 | 冻结严格解析通过 | 修复后存档重放通过 | 时序改善试验 |','|---|---:|---:|---:|---:|',
'| 无STA | 3 | 1 | 3 | 0 |','| 有STA | 3 | 1 | 3 | 0 |','',
'## 六动作实际测量','',
'| 动作 | 最大到达ns | 面积µm² |','|---|---:|---:|']
for i,m in s['action_results'].items():lines.append(f"| {i} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} |")
lines += ['',
'原始基线和六个动作共7次源级SAT、实际门级SAT和STA全部通过，且保留的基线独立复跑一致。每次选择两个动作的逻辑预算不变；相同动作的PPA复用一次测量，不能把12个选择槽位当成12份独立RTL。六动作枚举是更大预算的空间最优参考，不是同预算对照方法。','',
'## 下一步应改变什么','',
'当前问题是可用改写动作的覆盖与收益。继续在这个零收益空间内更换模型或增加同类提示，不能产生空间外的电路。离线基准设计需要同时记录“有可达收益”和“无可达收益”的样例，评估动作覆盖及选择效率，而不是只看最终最好值。此处不据已知结果隐藏或删除N24负例。','',
'后续单独测试了一个输出选择因式分解动作，24位仍更慢，仅面积更小；它没有加入本轮目录，也不能倒推模型本应选择它。[独立事后开发结果](../'+F.name+'/INTERPRETATION.md)。','',
'## 证据与复现范围','',
f'- [冻结主结果审计](AUDIT.json)：{audit["check_count"]}项通过，使用code_snapshot中的原严格解析器；[原始选择与结果](summary.json)、[原始清单](selection_manifest.json)、[格式修复离线重放](PARSER_FIX_REPLAY.json)、[基线复跑](REPRODUCTION.json)。',
'- 原始请求和可见返回在各组/selection_*/api_audit/；候选原始证明、映射、STA在evaluations/。密钥未写入项目文件。存档响应provider报告总token为9042，未推算未知价格。',
'- code_snapshot保留冻结旧解析器。当前agents/action_selector.py已修复，因此旧execute的代码哈希检查会拒绝在新代码上重跑；不要改旧哈希绕过检查。历史审计从冻结快照解析，修复前审计另存AUDIT_BEFORE_PARSER_FIX.json。',
'- 公开比较器家族此前已开发过N1/13/32，N24只是此前未测候选的新参数，不是新家族或训练数据盲测。三次/组只做工程先导，不能声称统计或普遍优势。TT布局布线前、组合最大到达时间、固定IO，不含功耗和物理签核。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
(S/'examples').mkdir(exist_ok=True);save(S/'examples/manual_selection.json',dict(action_ids=['balanced_4','balanced_8'],rationale='Manual replay example, not model-generated output'))
for folder in [S,F]:(folder/'validation_tools').mkdir(exist_ok=True)
shutil.copyfile(E/'audit_action_selection_study.py',S/'validation_tools/audit_action_selection_study.py')
shutil.copyfile(Path(__file__).resolve(),S/'validation_tools/finalize_action_pipeline.py')
save(S/'STATUS.json',dict(state='COMPLETED_PRIMARY_AUDITED_PARSER_FIXED_OFFLINE',actual_model_requests=6,approved_maximum_requests=6,remaining_authorized_requests=0,strict_primary_valid_selections=2,posthoc_replay_valid_selections=6,primary_oracle='No strict timing gain in fixed pool'))
save(S/'FINAL_EVIDENCE.json',dict(actual_model_requests=6,actual_responses=6,provider_reported_tokens=9042,source_versions=6,unique_candidate_evaluations=6,baseline_evaluations=1,baseline_independent_replays=1,
    audit_passed=True,audit_checks=audit['check_count'],strict_primary_valid=2,posthoc_parser_replay_valid=6,posthoc_replay_new_api_calls=0,
    hashes={n:sha(S/n) for n in ['protocol.json','summary.json','selection_manifest.json','AUDIT.json','PARSER_FIX_REPLAY.json','REPRODUCTION.json','INTERPRETATION.md']}))
save(F/'FINAL_EVIDENCE.json',dict(model_calls=0,source_versions=1,candidate_parameter_evaluations=4,primary_width=24,primary_timing_improvement=False,independent_replays=2,audit_passed=True,audit_checks=fa['check_count'],
    hashes={n:sha(F/n) for n in ['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']}))
entry='2026-11-03真实模型动作选择完成：6次请求均返回，旧严格JSON解析仅2份接受；兼容修复后6份存档响应离线重放均合法，未重发。N24六动作完整测量无预算内时序收益，两组均保留1.21ns基线，不能比较选择优势。另一个事后输出因式分解动作在N24降低面积但延迟变差，原池及主结果不变。'
for file,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=file.read_text(encoding='utf-8')
    if '真实模型动作选择完成：' not in text:
        pos=text.find('\n\n')+2;file.write_text(text[:pos]+entry+f' [完整真实证据]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
print('Primary and post-hoc results saved separately. Main audit:',audit['check_count'],'local audit:',fa['check_count'],'new API calls: 0')
