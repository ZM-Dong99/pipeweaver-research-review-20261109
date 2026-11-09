"""Offline preparation audit. No network/model generation or candidate EDA."""
import hashlib
import json
from pathlib import Path
import sys
from unittest.mock import patch

ROOT=Path(r'D:\verilog_lab\PipeWeaver')
sys.path.insert(0,str(ROOT/'eda/experiments'))
import run_ticket_feedback_study as runner

S=ROOT/'eda/experiments/ticket_feedback_study_20261102_234633_156134'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
p=load(S/'protocol.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
runner.validate(S,p);check('All frozen hashes validate',True)
plain=load(S/'prompts/no_timing_feedback.json');guided=load(S/'prompts/structured_timing_feedback.json')
timing=guided.pop('actual_structured_timing_feedback')
check('Common prompt JSON fields exactly identical',plain==guided)
check('Only guided prompt has actual timing feedback','actual_structured_timing_feedback' not in plain)
check('Ten scheduled slots',len(p['call_schedule'])==p['maximum_requests']==10)
check('Unique call indices',[s['call_index'] for s in p['call_schedule']]==list(range(1,11)))
check('Five distinct slots per arm',all(len([s for s in p['call_schedule'] if s['arm']==a])==5 and len({s['candidate_id'] for s in p['call_schedule'] if s['arm']==a})==5 for a in p['arms']))
check('Both arms represented in each adjacent pair',all({x['arm'] for x in p['call_schedule'][i:i+2]}==set(p['arms']) for i in range(0,10,2)))
check('No candidate or previous generation in prompt','previous_attempt' not in plain and not list(S.glob('*/candidate_*/attempt.json')))
check('Expert reference not copied',sorted(x.name for x in (S/'inputs').iterdir())==['LICENSE','original.v'])
base=load(S/'baseline/result.json');bp=load(S/'baseline/protocol.json')
check('Actual baseline complete',base['formal']==base['mapped_formal']==base['ppa']==base['status']=='PASS')
check('Baseline linked to frozen original',runner.sha(S/'inputs/original.v')==bp['candidate_sha256']==bp['reference_sha256'])
check('Area cap identical',plain['fixed_mapped_area_cap_um2']==p['area_cap_um2']==base['mapped_area_um2']*1.10)
check('No retiming or startup extension',plain['startup_and_timing_contract']['reset_cycles']==plain['startup_and_timing_contract']['warmup_samples']==1)
check('Three actual STA paths',len(timing['measured_paths'])==3 and all(path in (S/'baseline/sta.log').read_text(encoding='utf-8') for path in timing['measured_paths']))
check('FSM recode actual six rows',len(timing['fsm_recode_table_from_mapping_log'])==6)
check('BILL30 recode explicitly recorded',timing['worst_path']['original_state']=='BILL30' and any(x==dict(original_encoding='100000',mapped_encoding='----1-') for x in timing['fsm_recode_table_from_mapping_log']))
check('No currency or token cap misrepresented','No explicit token cap' in p['completion_token_cap'])
check('Current API destination',p['api_endpoint']=='https://apinebula.ai/v1' and p['model']=='gpt-6.1-sol' and p['http_transport']=='curl')
called=[]
def refuse_call(*a,**kw): called.append(True);raise AssertionError('Network/model call attempted')
try:
    with patch.object(runner,'generate_from_prompt',refuse_call):runner.execute(S)
except FileNotFoundError as exc:check('Missing new authorization blocks execution',Path(exc.filename).name=='AUTHORIZATION.json' and not called)
else:check('Missing new authorization blocks execution',False)
realsha=runner.sha
try:
    with patch.object(runner,'sha',lambda path:'BAD' if Path(path)==S/'prompts/no_timing_feedback.json' else realsha(path)):
        runner.validate(S,p)
except AssertionError:check('Changed prompt hash blocks execution',True)
else:check('Changed prompt hash blocks execution',False)
report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,model_requests=0)
with (S/'PREPARATION_AUDIT.json').open('x',encoding='utf-8') as f:json.dump(report,f,indent=2,ensure_ascii=False)
print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
for c in checks:
    if not c['passed']:print('FAILED: '+c['check'])
if not report['passed']:raise SystemExit(1)
