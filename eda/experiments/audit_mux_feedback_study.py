"""Verify actual responses, frozen inputs, raw proofs/STA and reported statistics."""
import sys,json,hashlib,importlib.util,re,statistics
from pathlib import Path
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT));sys.path.insert(0,str(ROOT/'eda/experiments'))
from agents.action_loop import choose
from run_native_comb import parse_electrical_report
S=ROOT/'eda/experiments/mux_feedback_study_20261104_155643_522144'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
p=load(S/'protocol.json');s=load(S/'summary.json');manifest=load(S/'candidate_manifest.json');checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
spec=importlib.util.spec_from_file_location('frozen_mux_adapter',S/'code_snapshot/rtl_optimizer.py');adapter=importlib.util.module_from_spec(spec);sys.modules[spec.name]=adapter;spec.loader.exec_module(adapter)
check('protocol linkage',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip()==manifest['protocol_sha256'])
auth=load(S/'AUTHORIZATION.json');check('bounded consent',auth['maximum_requests']==p['maximum_requests']==10 and auth['protocol_sha256']==sha(S/'protocol.json'))
for rel,h in p['frozen_files'].items():check('frozen '+rel,sha(S/rel)==h)
for rel,h in p['code_sha256'].items():check('code '+rel,sha(S/'code_snapshot'/Path(rel).name)==h)
check('exact schedule',[{k:r[k] for k in ['call_index','arm','trial']} for r in manifest['rows']]==p['call_schedule'])
check('ten attempts',len(list(S.glob('*/trial_*/attempt.json')))==10)
a=(S/'prompts/no_sta.txt').read_text(encoding='utf-8');b=(S/'prompts/sta.txt').read_text(encoding='utf-8');paths=(S/'baseline/top3_supplied.txt').read_text(encoding='utf-8')
check('common prompt identical',b.startswith(a) and b!=a)
check('three actual supplied paths',paths.count('Startpoint:')==3 and paths in b and (S/'baseline/sta.log').read_text(encoding='utf-8').startswith(paths))
responses=tokens=0;trial_map={r['call_index']:r for r in s['trials']};check('unique trials',len(trial_map)==10)
def audit_eda(folder,m,label):
    check(label+' actual result',load(folder/'result.json')==m)
    tool=load(folder/'protocol.json');check(label+' original contract',tool['reference_sha256']==sha(S/'inputs/original.v') and tool['top']=='mux_large' and tool['parameter_overrides']=={} and tool['liberty_sha256']==p['liberty_sha256'])
    check(label+' candidate input hash',sha(Path(tool['candidate']))==tool['candidate_sha256'])
    for stage in ['formal','mapped_formal']:
        if m.get(stage)=='PASS':check(label+' '+stage+' raw proof','SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
    if m.get('status')=='PASS':
        raw=(folder/'sta.log').read_text(encoding='utf-8');check(label+' raw delay',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns'])
        check(label+' raw area',float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1])==m['mapped_area_um2'])
        check(label+' netlist used by STA',sha(folder/'mapped.v')==m['mapped_sha256']==m['sta_netlist_sha256'])
        check(label+' electrical',parse_electrical_report(raw)==m['electrical'])
audit_eda(S/'baseline',p['baseline'],'baseline')
for g in manifest['rows']:
    f=S/g['arm']/f"trial_{g['trial']:02d}";r=trial_map[g['call_index']];label=str(g['call_index'])
    check(label+' manifest generation',load(f/'generation.json')==g)
    check(label+' generation identity',all(r[k]==v for k,v in g.items()))
    req=load(f/'api_audit/request.json');prompt=S/'prompts'/(g['arm']+'.txt')
    check(label+' actual endpoint',req['endpoint']==p['endpoint']+'/chat/completions')
    check(label+' actual model parameters',req['body']['model']==p['model'] and all(req['body'].get(k)==v for k,v in p['request_parameters'].items()))
    check(label+' actual prompt',req['body']['messages'][-1]['content']==prompt.read_text(encoding='utf-8') and sha(prompt)==g['prompt_sha256'])
    transport=f/'api_audit/transport.json'
    if transport.exists():check(label+' zero retries',load(transport)['retry_count']==0)
    response=f/'api_audit/response.json';parsed=None
    if response.exists():
        v=load(response);responses+=1;tokens+=v.get('usage',{}).get('total_tokens',0)
        try:parsed=adapter._parse_content(v['choices'][0]['message']['content'])[0]
        except (adapter.LLMGenerationError,KeyError,IndexError,TypeError):pass
    check(label+' actual parsed generation',(parsed is not None)==(g['status']=='GENERATED'))
    if parsed is not None:
        check(label+' returned source',parsed==(f/'candidate.v').read_text(encoding='utf-8') and sha(f/'candidate.v')==g['candidate_sha256'])
        audit_eda(f/'evaluation',r['raw_metrics'],label)
    else:check(label+' failed generation not evaluated',r['raw_metrics'] is None and not (f/'evaluation').exists())
    pool={'candidate':r['raw_metrics']} if r['raw_metrics'] else {};expected=choose(list(pool),pool,p['baseline'],p['area_cap_um2'])
    check(label+' original-retained decision',r['selected']==expected and r['retained_metrics']==(p['baseline'] if expected=='baseline' else r['raw_metrics']))
for arm in ['no_sta','sta']:
    rr=[r for r in s['trials'] if r['arm']==arm];g=s['groups'][arm];valid=[r for r in rr if r['status']=='GENERATED']
    check(arm+' equal five attempts',g['attempts']==len(rr)==5)
    check(arm+' generated count',g['generated']==len(valid))
    check(arm+' strict improvement count',g['strict_improvements']==sum(r['selected']!='baseline' for r in rr))
    check(arm+' median',g['median_retained_delay_ns']==statistics.median(r['retained_metrics']['max_data_arrival_ns'] for r in rr))
    check(arm+' best',g['best_retained_delay_ns']==min(r['retained_metrics']['max_data_arrival_ns'] for r in rr))
    check(arm+' successful subset',g['successful_generation_median_delay_ns']==(statistics.median(r['retained_metrics']['max_data_arrival_ns'] for r in valid) if valid else None))
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),actual_provider_responses=responses,provider_reported_tokens=tokens,checks=checks)
(S/'AUDIT.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print({k:v for k,v in report.items() if k!='checks'})
if not report['passed']:print([c for c in checks if not c['passed']]);raise SystemExit(1)
