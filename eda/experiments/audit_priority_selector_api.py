"""Audit actual one-action API decisions and shared fixed-pool PPA results."""
from pathlib import Path
import importlib.util
import statistics
import re
import sys
ROOT=Path(__file__).resolve().parents[2];E=ROOT/'eda/experiments';sys.path.insert(0,str(ROOT));sys.path.insert(0,str(E))
from agents.action_loop import sha,load,save,choose
from run_native_comb import parse_electrical_report
S=E/'priority_selector_api_20261103_190958_372230'
p=load(S/'protocol.json');s=load(S/'summary.json');manifest=load(S/'selection_manifest.json')
spec=importlib.util.spec_from_file_location('frozen_priority_selector',S/'code_snapshot/action_selector.py');selector=importlib.util.module_from_spec(spec);spec.loader.exec_module(selector)
checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol linkage',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip()==manifest['protocol_sha256'])
auth=load(S/'AUTHORIZATION.json');check('bounded authorization',auth['maximum_requests']==p['maximum_requests']==12 and auth['protocol_sha256']==sha(S/'protocol.json'))
for rel,h in p['code_sha256'].items():check('code snapshot '+rel,sha(S/'code_snapshot'/Path(rel).name)==h)
for name,h in p['input_sha256'].items():check('input '+name,sha(S/'inputs'/name)==h)
for i,h in p['candidate_sha256'].items():check('candidate '+i,sha(S/'candidates'/(i+'.v'))==h)
for name,h in p['prompt_sha256'].items():check('prompt '+name,sha(S/'prompts'/name)==h)
check('fixed call order',[{k:r[k] for k in ['call_index','width','arm','trial']} for r in manifest['rows']]==p['call_schedule'] and len(s['trials'])==12)
source=(S/'inputs/original.v').read_text(encoding='utf-8');response_count=0;tokens=0
for width in p['widths']:
    plain=load(S/'prompts'/f'W{width}_no_sta.json');guided=load(S/'prompts'/f'W{width}_sta.json');guided.pop('actual_baseline_sta')
    check(f'W{width} same common payload',plain==guided)
trials_by_call={t['call_index']:t for t in s['trials']}
check('unique complete trial identifiers',len(trials_by_call)==12 and set(trials_by_call)=={g['call_index'] for g in manifest['rows']})
for g in manifest['rows']:
    t=trials_by_call[g['call_index']]
    check(str(g['call_index'])+' trial identity',all(t[k]==g[k] for k in ['call_index','width','arm','trial','status','action_ids']))
    f=S/f"W{g['width']}"/g['arm']/f"trial_{g['trial']:02d}";label=f"{g['call_index']} W{g['width']} {g['arm']}"
    check(label+' generation frozen',load(f/'generation.json')==g)
    req=load(f/'api_audit/request.json');prompt=(S/'prompts'/f"W{g['width']}_{g['arm']}.json").read_text(encoding='utf-8')
    check(label+' actual prompt',req['body']['messages'][-1]['content']==prompt and (f/'prompt.txt').read_text(encoding='utf-8')==prompt)
    check(label+' endpoint/model',req['endpoint']==p['api_endpoint']+'/chat/completions' and req['body']['model']==p['model'])
    check(label+' actual parameters',all(req['body'].get(k)==v for k,v in p['request_parameters'].items()))
    check(label+' one action required','exactly 1' in req['body']['messages'][0]['content'])
    transport=f/'api_audit/transport.json'
    if transport.exists():check(label+' zero retries',load(transport)['retry_count']==0)
    parsed=None;resp=f/'api_audit/response.json'
    if resp.exists():
        body=load(resp);response_count+=1;tokens+=body.get('usage',{}).get('total_tokens',0)
        try:parsed=selector.parse_selection(body['choices'][0]['message']['content'],source,template='priority_encoder',action_count=1)
        except selector.LLMGenerationError:pass
    check(label+' actual valid selection',(parsed is not None)==(g['status']=='SELECTED') and (parsed['action_ids'] if parsed else [])==g['action_ids'])
    if parsed:check(label+' exact deterministic RTL',all(parsed['rtl_by_action'][i]==(S/'candidates'/(i+'.v')).read_text(encoding='utf-8') for i in parsed['action_ids']))
    key=str(g['width']);base=p['baseline_metrics'][key];expected=choose(g['action_ids'],s['action_results'][key],base,p['area_cap_um2'][key])
    check(label+' same selection rule',t['selected']==expected and t['metrics']==(base if expected=='baseline' else s['action_results'][key][expected]))
def eda(folder,m,width,label):
    cp=load(folder/'protocol.json');check(label+' actual result',load(folder/'result.json')==m)
    check(label+' original/width',cp['reference_sha256']==p['input_sha256']['original.v'] and cp['parameter_overrides']=={'WIDTH':width,'LSB_HIGH_PRIORITY':0})
    check(label+' source hash',sha(Path(cp['candidate']))==cp['candidate_sha256'])
    if m.get('status')=='PASS':
        for stage in ['formal','mapped_formal']:check(label+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
        raw=(folder/'sta.log').read_text(encoding='utf-8');check(label+' measured delay',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns'])
        check(label+' electrical',parse_electrical_report(raw)==m['electrical'])
        area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1]);check(label+' area',area==m['mapped_area_um2'])
        check(label+' mapped hash',sha(folder/'mapped.v')==m['mapped_sha256'])
    else:check(label+' fail closed',not m.get('eligible'))
for width in p['widths']:
    key=str(width);base=p['baseline_metrics'][key];pool=s['action_results'][key];cap=p['area_cap_um2'][key]
    eda(S/f'W{width}'/'baseline',base,width,f'W{width} baseline')
    for i,m in pool.items():eda(S/f'W{width}'/'evaluations'/i,m,width,f'W{width} {i}')
    oracle=choose(list(pool),pool,base,cap);check(f'W{width} oracle',s['controls'][key]['oracle']==oracle)
    for role,action in [('static16',p['fixed_primary_control']),('static8',p['fixed_secondary_control'])]:
        expected=choose([action],pool,base,cap);check(f'W{width} {role} predeclared',s['controls'][key][role]['action']==action and s['controls'][key][role]['selected']==expected)
    for arm in ['no_sta','sta']:
        rows=[r for r in s['trials'] if r['width']==width and r['arm']==arm];g=s['groups'][key][arm]
        check(f'W{width} {arm} three attempts',len(rows)==g['attempts']==3)
        check(f'W{width} {arm} median',statistics.median(r['metrics']['max_data_arrival_ns'] for r in rows)==g['median_delay_ns'])
        check(f'W{width} {arm} valid/improved counts',g['valid_selections']==sum(r['status']=='SELECTED' for r in rows) and g['improved_trials']==sum(r['selected']!='baseline' for r in rows))
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,actual_provider_responses=response_count,provider_reported_tokens=tokens,
            scope='One family, W64 prospective candidate outcomes and W128 exposed replication. Twelve API slots, one action each; six-action oracle is not equal-budget method.')
save(S/'AUDIT.json',report);print({k:v for k,v in report.items() if k!='checks'})
if not report['passed']:print([c for c in checks if not c['passed']]);raise SystemExit(1)
