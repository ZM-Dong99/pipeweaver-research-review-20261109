"""Offline validation of the frozen three-arm development protocol."""
import json
from pathlib import Path
import sys
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT/'eda/experiments'))
import run_ticket_risk_feedback as r
S=ROOT/'eda/experiments/ticket_risk_feedback_20261103_001930_680040'
p=r.load(S/'protocol.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
r.validate(S,p);check('All frozen hashes validate',True)
parent=Path(p['parent_study'])
prompts={a:r.load(S/'prompts'/(a+'.json')) for a in p['arms']}
for a in p['arms'][:2]:check(a+' byte-identical to prior',r.sha(S/'prompts'/(a+'.json'))==r.sha(parent/'prompts'/(a+'.json')))
risk=prompts['risk_aware_timing_feedback'].copy();guard=risk.pop('path_competition_and_cost_guidance')
check('New arm equals old STA arm plus one field',risk==prompts['structured_timing_feedback'])
sta=prompts['structured_timing_feedback'].copy();timing=sta.pop('actual_structured_timing_feedback')
check('STA arm equals no-STA common fields',sta==prompts['no_timing_feedback'])
check('Three actual paths',len(guard['competing_baseline_paths'])==len(timing['measured_paths'])==3)
check('Path timings match actual raw report',all(raw in (S/'baseline/sta.log').read_text(encoding='utf-8') for raw in timing['measured_paths']))
check('Actual baseline FF count',guard['baseline_mapped_ff_count']==sum('dfxtp' in c['type'] for c in r.load(S/'baseline/mapped.json')['modules']['ticket_machine']['cells'].values())==6)
check('Library FF area',abs(guard['dfxtp_1_area_um2']-20.0192)<1e-9)
check('Remaining area arithmetic',abs(guard['remaining_mapped_area_budget_um2']-(p['area_cap_um2']-p['baseline_metrics']['mapped_area_um2']))<1e-9)
check('One-FF cost arithmetic',abs(guard['budget_if_one_same_type_ff_added_and_no_other_changes_um2']-(guard['remaining_mapped_area_budget_um2']-guard['dfxtp_1_area_um2']))<1e-9)
check('Unchanged-path ceiling is conditional',guard['best_possible_wns_if_only_first_path_removed_and_all_others_unchanged_ns']==min(x['slack_ns'] for x in guard['competing_baseline_paths'][1:]))
check('Guard data identical to archived features',guard==r.load(S/'RISK_FEATURES.json'))
check('No observed candidate PPA or reference code passed','candidate_03' not in json.dumps(guard) and 'candidate_rtl' not in guard and not list((S/'inputs').glob('*ref*')))
check('Guidance not new acceptance filter','not an automatic acceptance filter' in guard['name'])
check('Common functional and timing contract',all(x['startup_and_timing_contract']==p['contract'] and x['fixed_mapped_area_cap_um2']==p['area_cap_um2'] for x in prompts.values()))
check('Fifteen unique call slots',[x['call_index'] for x in p['call_schedule']]==list(range(1,16)) and p['maximum_requests']==15)
check('Five candidate slots per arm',all(len([x for x in p['call_schedule'] if x['arm']==arm])==len({x['candidate_id'] for x in p['call_schedule'] if x['arm']==arm})==5 for arm in p['arms']))
check('Each consecutive block covers all three arms',all({x['arm'] for x in p['call_schedule'][i:i+3]}==set(p['arms']) for i in range(0,15,3)))
check('Post-hoc development scope disclosed','post-hoc' in p['purpose'] and 'not a holdout' in p['development_exposure'])
check('No token/currency hard cap claim','No explicit token cap' in p['completion_token_cap'])
check('Zero new model attempts',not list(S.glob('*/candidate_*/attempt.json')))
called=[]
def no_network(*a,**kw):called.append(True);raise AssertionError('Unexpected model call')
try:
    with patch.object(r,'generate_from_prompt',no_network):r.execute(S)
except FileNotFoundError as exc:check('No authorization blocks calls',Path(exc.filename).name=='AUTHORIZATION.json' and not called)
else:check('No authorization blocks calls',False)
original_sha=r.sha
try:
    with patch.object(r,'sha',lambda path:'BAD' if Path(path)==S/'RISK_FEATURES.json' else original_sha(path)):r.validate(S,p)
except AssertionError:check('Risk-feature tamper rejected',True)
else:check('Risk-feature tamper rejected',False)
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,actual_model_requests=0)
with (S/'PREPARATION_AUDIT.json').open('x',encoding='utf-8') as f:json.dump(report,f,ensure_ascii=False,indent=2)
print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
for c in checks:
    if not c['passed']:print('FAILED:',c['check'])
if not report['passed']:raise SystemExit(1)
