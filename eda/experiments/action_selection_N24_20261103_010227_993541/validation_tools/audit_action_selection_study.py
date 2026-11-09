"""Audit frozen strict-parser results using the frozen parser, not later fixes."""
import importlib.util
import json
from pathlib import Path
import re
import sys
ROOT=Path(__file__).resolve().parents[2];E=ROOT/'eda/experiments';sys.path.insert(0,str(ROOT));sys.path.insert(0,str(E))
from agents.action_loop import sha,load,save,choose
from run_native_comb import parse_electrical_report
S=E/'action_selection_N24_20261103_010227_993541';p=load(S/'protocol.json');s=load(S/'summary.json');manifest=load(S/'selection_manifest.json')
spec=importlib.util.spec_from_file_location('frozen_action_selector',S/'code_snapshot/action_selector.py');frozen=importlib.util.module_from_spec(spec);spec.loader.exec_module(frozen)
checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol hash',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip()==manifest['protocol_sha256'])
auth=load(S/'AUTHORIZATION.json');check('six-call authorization',auth['approved_maximum_requests']==p['maximum_requests']==6 and auth['protocol_sha256']==sha(S/'protocol.json') and auth['endpoint']==p['api_endpoint'] and auth['model']==p['model'])
for rel,h in p['code_sha256'].items():check('frozen code '+rel,sha(S/'code_snapshot'/Path(rel).name)==h)
for name,h in p['input_sha256'].items():check('input '+name,sha(S/'inputs'/name)==h)
for i,h in p['candidate_sha256'].items():check('candidate '+i,sha(S/'candidates'/(i+'.v'))==h)
prompts={a:(S/'prompts'/(a+'.json')).read_text(encoding='utf-8') for a in ['no_timing_feedback','sta_feedback']}
for arm,h in p['prompt_sha256'].items():check('prompt '+arm,sha(S/'prompts'/(arm+'.json'))==h)
guided=json.loads(prompts['sta_feedback']);guided.pop('actual_baseline_sta');check('same common prompt',guided==json.loads(prompts['no_timing_feedback']))
check('all frozen slots',[{k:r[k] for k in ['call_index','arm','slot']} for r in manifest['selections']]==p['call_schedule'] and len(s['trials'])==6)
source=(S/'inputs/original.v').read_text(encoding='utf-8');tokens=0;formats=[]
for g,t in zip(manifest['selections'],s['trials']):
    f=S/g['arm']/g['slot'];label=g['arm']+'/'+g['slot'];check(label+' generation',load(f/'generation.json')==g)
    req=load(f/'api_audit/request.json');resp=load(f/'api_audit/response.json');content=resp['choices'][0]['message']['content'];tokens+=resp.get('usage',{}).get('total_tokens',0)
    check(label+' exact request',req['body']['messages'][-1]['content']==prompts[g['arm']] and req['endpoint']==p['api_endpoint']+'/chat/completions' and req['body']['model']==p['model'])
    check(label+' request settings',all(req['body'].get(k)==v for k,v in p['request_parameters'].items()))
    check(label+' no retry',load(f/'api_audit/transport.json')['retry_count']==0)
    try:
        parsed=frozen.parse_selection(content,source);valid=True
    except frozen.LLMGenerationError:parsed=None;valid=False
    check(label+' strict primary parser',valid==(g['status']=='SELECTED') and (parsed['action_ids'] if parsed else [])==g['action_ids'])
    if parsed:
        check(label+' deterministic RTL',all(parsed['rtl_by_action'][i]==(S/'candidates'/(i+'.v')).read_text(encoding='utf-8') for i in parsed['action_ids']))
    expected=choose(g['action_ids'],s['action_results'],p['baseline_metrics'],p['area_cap_um2'])
    check(label+' same two-action choice',t['selected']==expected and t['metrics']==(p['baseline_metrics'] if expected=='baseline' else s['action_results'][expected]))
    formats.append(dict(call_index=g['call_index'],arm=g['arm'],valid_strict=valid,complete_leading_think_wrapper=content.lstrip().startswith('<think>') and '</think>' in content))
def eda(folder,m,label):
    cp=load(folder/'protocol.json');check(label+' actual result',load(folder/'result.json')==m)
    check(label+' N24 original reference',cp['parameter_overrides']=={'N':24} and cp['reference_sha256']==p['input_sha256']['original.v'])
    check(label+' actual candidate',sha(Path(cp['candidate']))==cp['candidate_sha256'])
    if m.get('status')=='PASS':
        for stage in ['formal','mapped_formal']:check(label+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
        text=(folder/'sta.log').read_text(encoding='utf-8');check(label+' raw arrival',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',text))==m['max_data_arrival_ns'])
        check(label+' electrical',parse_electrical_report(text)==m['electrical'])
        area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1]);check(label+' area',area==m['mapped_area_um2'])
        check(label+' mapped hash',sha(folder/'mapped.v')==m['mapped_sha256'])
    else:check(label+' fail closed',not m.get('eligible'))
eda(S/'baseline',p['baseline_metrics'],'baseline')
for i,m in s['action_results'].items():eda(S/'evaluations'/i,m,i)
oracle=choose(list(p['registry']),s['action_results'],p['baseline_metrics'],p['area_cap_um2']);check('exhaustive fixed-pool oracle',oracle==s['oracle_selected'])
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,actual_response_count=len(formats),provider_reported_tokens=tokens,format_diagnostics=formats,
            primary_parser='Frozen strict JSON parser, including failures; future normalization does not replace primary results',live_code_changed_since_freeze=[rel for rel,h in p['code_sha256'].items() if sha(ROOT/rel)!=h])
save(S/'AUDIT.json',report);print(json.dumps({k:v for k,v in report.items() if k not in ['checks','format_diagnostics']}))
if not report['passed']:print([c for c in checks if not c['passed']]);raise SystemExit(1)
