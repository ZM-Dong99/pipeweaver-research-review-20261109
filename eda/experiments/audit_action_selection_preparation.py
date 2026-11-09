"""Local preparation audit; no API call or N24 candidate timing measurement."""
import json
from pathlib import Path
import sys
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT));sys.path.insert(0,str(ROOT/'eda/experiments'))
import run_action_selection_study as driver
from agents.action_selector import parse_selection,LLMGenerationError
S=ROOT/'eda/experiments/action_selection_N24_20261103_010227_993541'
p=driver.load(S/'protocol.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
driver.validate(S,p);check('All source, code, baseline and prompt hashes validate',True)
direct=driver.load(S/'prompts/no_timing_feedback.json');guided=driver.load(S/'prompts/sta_feedback.json')
timing=guided.pop('actual_baseline_sta');check('Same common fields',guided==direct)
check('Parameter instance declared',direct['parameter_overrides']=={'N':24} and p['width']==24)
check('Six actions frozen',len(p['registry'])==len(p['candidate_sha256'])==6)
check('Two distinct actions requested',direct['response_format']['action_ids']==['one_allowed_ID','a_different_allowed_ID'] and p['actions_per_request']==2)
check('Six call slots and three per arm',[x['call_index'] for x in p['call_schedule']]==list(range(1,7)) and all(sum(x['arm']==arm for x in p['call_schedule'])==3 for arm in driver.ARMS))
check('Both arms in every pair',all({x['arm'] for x in p['call_schedule'][i:i+2]}==set(driver.ARMS) for i in range(0,6,2)))
check('No selected candidate timing before model choices',not (S/'evaluations').exists())
check('No actual request attempts',not list(S.glob('*/selection_*/attempt.json')))
check('No old candidate outcomes in common prompt','candidate_results' not in direct and 'actual_baseline_sta' not in direct)
base=driver.load(S/'baseline/result.json');check('Real baseline proofs and STA',base['status']==base['formal']==base['mapped_formal']==base['ppa']=='PASS')
check('Same baseline PPA',base==p['baseline_metrics'])
check('Baseline actual parameter',driver.load(S/'baseline/protocol.json')['parameter_overrides']=={'N':24})
check('Actual available paths, at most three',1<=len(timing['measured_paths'])<=3 and all(raw in (S/'baseline/sta.log').read_text(encoding='utf-8') for raw in timing['measured_paths']))
check('Actual path delay',timing['max_data_arrival_ns']==base['max_data_arrival_ns'])
source=(S/'inputs/original.v').read_text(encoding='utf-8')
good={'action_ids':['balanced_4','linear_8'],'rationale':'Manual fixture, not model output'}
check('Deterministic two-action generation',set(parse_selection(json.dumps(good),source)['rtl_by_action'])==set(good['action_ids']))
for name,payload in [('extra_RTL',{**good,'candidate_rtl':'arbitrary'}),('duplicate_ID',{**good,'action_ids':['balanced_4','balanced_4']}),('path_ID',{**good,'action_ids':['../outside','linear_8']}),('three_actions',{**good,'action_ids':['balanced_2','balanced_4','linear_8']})]:
    try:parse_selection(json.dumps(payload),source)
    except LLMGenerationError:check(name+' rejected',True)
    else:check(name+' rejected',False)
try:parse_selection('{"action_ids":["balanced_4","linear_8"],"rationale":"test","rationale":"duplicate"}',source)
except LLMGenerationError:check('Duplicate JSON keys rejected',True)
else:check('Duplicate JSON keys rejected',False)
called=[]
def no_call(*a,**kw):called.append(True);raise AssertionError('Unexpected network call')
try:
    with patch.object(driver,'select_actions',no_call):driver.execute(S)
except FileNotFoundError as exc:check('New authorization required',Path(exc.filename).name=='AUTHORIZATION.json' and not called)
else:check('New authorization required',False)
orig=driver.sha
try:
    with patch.object(driver,'sha',lambda path:'BAD' if Path(path)==S/'candidates/balanced_4.v' else orig(path)):driver.validate(S,p)
except AssertionError:check('Candidate tamper blocks execution',True)
else:check('Candidate tamper blocks execution',False)
report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,actual_model_calls=0,N24_candidate_evaluations=0)
with (S/'PREPARATION_AUDIT_v2.json').open('x',encoding='utf-8') as f:json.dump(report,f,ensure_ascii=False,indent=2)
print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
if not report['passed']:print([x for x in checks if not x['passed']]);raise SystemExit(1)
