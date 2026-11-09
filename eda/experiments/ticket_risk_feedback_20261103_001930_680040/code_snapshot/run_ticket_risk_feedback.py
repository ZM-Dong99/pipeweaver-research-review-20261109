"""Freeze/execute a three-arm same-case risk-guidance development comparison.

Preparation is local only. Execute sends at most fifteen independently frozen
prompts, without retries or replacement slots. No expert/reference solution
is included in prompts. This is one exploratory control-logic family.
"""
import argparse
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.sequential_loop import make_prompt, feedback, decision
from agents.rtl_optimizer import generate_from_prompt, api_configured, request_parameters_for_model, http_transport, LLMGenerationError

E=ROOT/'eda/experiments'
SOURCE=ROOT/'benchmark/rtl_opt_upstream_hkust/benchmark/ticket_machine/ticket_machine.v'
LICENSE=ROOT/'benchmark/rtl_opt_upstream_hkust/LICENSE'
LIB=E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
BACKEND=E/'run_native_seq.py'
ARMS=('no_timing_feedback','structured_timing_feedback','risk_aware_timing_feedback')
DEPS=[Path(__file__).resolve(),BACKEND,E/'run_native_comb.py',E/'trace_sta_rtl_cone.py',ROOT/'agents/sequential_loop.py',ROOT/'agents/rtl_optimizer.py']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):
    with p.open('x',encoding='utf-8') as f:json.dump(x,f,indent=2,ensure_ascii=False,allow_nan=False)

def validate(s,p):
    assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip(),'Changed protocol'
    assert sha(LIB)==p['library_sha256'],'Changed library'
    for name,h in p['dependency_sha256'].items():
        assert sha(ROOT/name)==h and sha(s/'code_snapshot'/Path(name).name)==h,'Changed experiment code'
    for name,h in p['input_sha256'].items(): assert sha(s/'inputs'/name)==h,'Changed input'
    for name,h in p['prompt_sha256'].items(): assert sha(s/'prompts'/(name+'.json'))==h,'Changed prompt'
    for name,h in p['baseline_artifact_sha256'].items(): assert sha(s/'baseline'/name)==h,'Changed baseline evidence'
    assert sha(s/'RISK_FEATURES.json')==p['risk_features_sha256'],'Changed risk features'
    assert sha(Path(p['parent_study'])/'protocol.json')==p['parent_protocol_sha256'],'Changed parent protocol'

def prepare(args):
    if not args.model:raise ValueError('Exact model ID required')
    parent=E/'ticket_feedback_study_20261102_234633_156134'
    previous=load(parent/'protocol.json')
    assert sha(parent/'protocol.json')==(parent/'protocol.sha256').read_text().strip()
    s=E/datetime.now().strftime('ticket_risk_feedback_%Y%m%d_%H%M%S_%f');s.mkdir()
    (s/'inputs').mkdir();(s/'prompts').mkdir();(s/'code_snapshot').mkdir()
    for name,h in previous['input_sha256'].items():
        assert sha(parent/'inputs'/name)==h
        shutil.copyfile(parent/'inputs'/name,s/'inputs'/name)
    shutil.copytree(parent/'baseline',s/'baseline')
    for arm in ARMS[:2]:shutil.copyfile(parent/'prompts'/(arm+'.json'),s/'prompts'/(arm+'.json'))
    base=load(s/'baseline/result.json');assert base['status']=='PASS'
    guided=load(s/'prompts/structured_timing_feedback.json')
    measured=guided['actual_structured_timing_feedback'];paths=measured['measured_paths']
    competitors=[]
    for text in paths:
        competitors.append(dict(startpoint=re.search(r'Startpoint: ([^\n]+)',text)[1],endpoint=re.search(r'Endpoint: ([^\n]+)',text)[1],
            data_arrival_ns=float(re.search(r'([\d.]+)\s+data arrival time',text)[1]),
            data_required_ns=float(re.search(r'([\d.]+)\s+data required time',text)[1]),slack_ns=float(re.search(r'([-+\d.]+)\s+slack \(',text)[1])))
    library=LIB.read_text(encoding='utf-8');cell=re.search(r'\bcell\s*\(\s*"?sky130_fd_sc_hd__dfxtp_1"?\s*\)\s*\{',library)
    assert cell
    block=library[cell.end():];block=block.split('    cell (',1)[0]
    ff_area=float(re.search(r'\barea\s*:\s*([\d.]+)\s*;',block)[1])
    mapped=load(s/'baseline/mapped.json')['modules']['ticket_machine']['cells']
    assert all(c['type']=='sky130_fd_sc_hd__dfxtp_1' for c in mapped.values() if 'dfxtp' in c['type'])
    ff_count=sum('dfxtp' in c['type'] for c in mapped.values())
    cap=previous['area_cap_um2'];remaining=cap-base['mapped_area_um2']
    guard=dict(name='Path-competition and incremental-cost generation guidance; not an automatic acceptance filter',
        baseline_mapped_ff_count=ff_count,dfxtp_1_area_um2=ff_area,remaining_mapped_area_budget_um2=remaining,
        budget_if_one_same_type_ff_added_and_no_other_changes_um2=remaining-ff_area,
        competing_baseline_paths=competitors,
        best_possible_wns_if_only_first_path_removed_and_all_others_unchanged_ns=min(x['slack_ns'] for x in competitors[1:]),
        interpretation='These are baseline measurements and arithmetic risk features, not candidate timing predictions. Adding a register moves logic to its D cone and introduces setup time; it can expose a worse path. Fewer flops can require more decode logic. Do not treat source state width as final mapped FF count: automatic FSM recoding may change it.',
        generation_policy=[
            'Assess both the modified output path and the new/modified register-input and state-transition paths before choosing a rewrite.',
            'Prefer a rewrite reusing existing state or shared decode unless a new register has a justified global timing and area case. New registers are allowed and all candidates use the same EDA acceptance rule.',
            'In area_or_other_cost, state expected mapped register change, assumptions, and uncertainty; account for combinational/buffer cost as well as FF area.',
            'In expected_timing_gain, name a likely competing path and why it may become critical. Estimates are not measured results.',
            'Do not assume eliminating the old critical output gate improves global WNS. Return exactly one complete RTL candidate; no new input assumptions or startup extension.'])
    guided['path_competition_and_cost_guidance']=guard
    save(s/'prompts/risk_aware_timing_feedback.json',guided)
    save(s/'RISK_FEATURES.json',guard)
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    schedule=[]
    for i in range(5):
        order=ARMS[i%3:]+ARMS[:i%3]
        for j,arm in enumerate(order):schedule.append(dict(call_index=i*3+j+1,arm=arm,candidate_id=f'candidate_{i+1:02d}'))
    transport=http_transport();binary=shutil.which('curl.exe') if transport=='curl' else None
    p=dict(status='FROZEN_PENDING_AUTHORIZATION',client_date='2026-11-03',
        purpose='Same-family post-hoc development test of generation guidance, not independent validation or a promise of feedback superiority',
        model=args.model,api_endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),
        request_parameters=request_parameters_for_model(args.model),http_transport=transport,transport_binary_sha256=sha(Path(binary)) if binary else None,
        arms=list(ARMS),candidates_per_arm=5,maximum_requests=15,call_schedule=schedule,llm_timeout_seconds=180,timeout_seconds=120,
        contract=previous['contract'],area_ratio_limit=1.10,area_cap_um2=cap,baseline_metrics=base,library_sha256=sha(LIB),
        input_sha256={f.name:sha(f) for f in (s/'inputs').iterdir()},dependency_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},
        baseline_artifact_sha256={f.name:sha(f) for f in (s/'baseline').iterdir() if f.is_file()},
        prompt_sha256={arm:sha(s/'prompts'/(arm+'.json')) for arm in ARMS},
        parent_study=str(parent),parent_protocol_sha256=sha(parent/'protocol.json'),risk_features_sha256=sha(s/'RISK_FEATURES.json'),
        reused_prompt_policy='First two prompts byte-identical to parent. New arm equals structured baseline prompt plus one added guidance field. No candidate/example RTL or observed candidate outcomes included.',
        development_exposure='Rule designed after prior 10-call same-family comparison and four hand-developed controls, including observed bottleneck migration. Thus this is post-hoc development on an exposed case, not a holdout. Only baseline-derived numeric facts enter the new guidance.',
        policy='Five independent requests per arm; fixed rotating three-arm schedule, no retries or replacement draws. Freeze all generations before EDA. Every candidate vs original; all failures retained. Generation guidance differs, EDA acceptance does not.',
        primary_metric='Per-arm best eligible WNS with original retained; report valid improvements per 5 attempted requests, all returned PPA, proof failures and costs.',
        completion_token_cap=previous['completion_token_cap'],
        limitations='One 28-cell six-state design with positive slack; insufficient for large-engineering or statistical universal advantage. Guideline arm changes feedback interpretation AND generation policy, so cannot isolate those two effects. Provider model identity unverified; longer prompts mean unequal token cost.')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    save(s/'STATUS.json',dict(state='READY_PENDING_USER_AUTHORIZATION',actual_model_requests=0,planned_maximum=15))
    validate(s,p);print('Prepared: '+str(s));print('Maximum new requests 15; actual requests 0')

def evaluate(source,folder,s,p):
    command=[sys.executable,'-B',str(BACKEND),str(source),'--reference',str(s/'inputs/original.v'),
             '--top','ticket_machine','--clock','clk','--reset','clear','--reset-cycles','1','--warmup','1',
             '--period','10','--timeout','120','--out',str(folder)]
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    try:raw=subprocess.run(command,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=960).stdout
    except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
    folder.mkdir(exist_ok=True);(folder/'runner.log').write_bytes(raw)
    return load(folder/'result.json') if (folder/'result.json').exists() else dict(status='INCOMPLETE',eligible=False)

def execute(s):
    p=load(s/'protocol.json');validate(s,p)
    auth=load(s/'AUTHORIZATION.json')
    assert auth['approved_maximum_requests']==p['maximum_requests']==15 and auth['protocol_sha256']==sha(s/'protocol.json')
    assert auth['endpoint']==p['api_endpoint'] and auth['model']==p['model']
    assert api_configured() and p['api_endpoint']==os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/')
    assert p['http_transport']==http_transport()
    if p['transport_binary_sha256']:assert sha(Path(shutil.which('curl.exe')))==p['transport_binary_sha256']
    generations=[]
    for slot in p['call_schedule']:
        validate(s,p);f=s/slot['arm']/slot['candidate_id'];f.mkdir(parents=True,exist_ok=True)
        if (f/'generation.json').exists():generations.append(load(f/'generation.json'));continue
        if (f/'attempt.json').exists():raise RuntimeError('Uncertain old request; refusing automatic duplicate')
        prompt=(s/'prompts'/(slot['arm']+'.json')).read_text(encoding='utf-8');(f/'prompt.txt').write_text(prompt,encoding='utf-8')
        save(f/'attempt.json',dict(slot=slot,started_at=datetime.now().astimezone().isoformat()))
        row=dict(**slot,candidate_sha256=None);start=time.monotonic()
        print(f'Calling {slot["call_index"]}/15 {slot["arm"]}',flush=True)
        try:
            g=generate_from_prompt(prompt,model=p['model'],candidate_index=slot['call_index'],timeout_s=p['llm_timeout_seconds'],audit_dir=f/'api_audit')
            (f/'candidate.v').write_text(g.rtl,encoding='utf-8')
            row.update(status='GENERATED',candidate_sha256=sha(f/'candidate.v'),explanation=g.explanation,parameters=g.generation_parameters,response_model=g.model)
        except LLMGenerationError as exc:row.update(status='FAILED_GENERATION',error=str(exc))
        row['seconds']=time.monotonic()-start;save(f/'generation.json',row);generations.append(row)
    if not (s/'candidate_manifest.json').exists():save(s/'candidate_manifest.json',dict(protocol_sha256=sha(s/'protocol.json'),slots=generations))
    results=[];base=p['baseline_metrics']
    for row in generations:
        validate(s,p);f=s/row['arm']/row['candidate_id']
        if (f/'result.json').exists():results.append(load(f/'result.json'));continue
        r=dict(**row,accepted=False,metrics=None)
        if row['candidate_sha256']:
            assert sha(f/'candidate.v')==row['candidate_sha256']
            if (f/'eda').exists():raise RuntimeError('Incomplete old EDA preserved; do not overwrite')
            m=evaluate(f/'candidate.v',f/'eda',s,p);accepted,reason=decision(m,base,p['area_cap_um2'])
            r.update(metrics=m,accepted=accepted,reason=reason)
        else:r['reason']='No RTL returned; failure retained without replacement'
        save(f/'result.json',r);results.append(r)
    groups={}
    for arm in ARMS:
        rows=[r for r in results if r['arm']==arm];valid=sorted([r for r in rows if r['accepted']],key=lambda r:(-r['metrics']['wns_ns'],r['metrics']['mapped_area_um2'],r['candidate_id']))
        best=valid[0] if valid else None;out=s/'selected'/arm;out.mkdir(parents=True,exist_ok=True)
        source=s/arm/best['candidate_id']/'candidate.v' if best else s/'inputs/original.v';shutil.copyfile(source,out/'ticket_machine.v')
        groups[arm]=dict(scheduled=5,returned=sum(r['candidate_sha256'] is not None for r in rows),valid_improvements=len(valid),
                         selected_origin=best['candidate_id'] if best else 'baseline_retained',selected_metrics=best['metrics'] if best else base,
                         selected_sha256=sha(out/'ticket_machine.v'),reported_tokens=sum(r.get('parameters',{}).get('usage',{}).get('total_tokens',0) for r in rows))
    save(s/'summary.json',dict(status='COMPLETED',request_attempts=len(generations),protocol_sha256=sha(s/'protocol.json'),groups=groups,results=results))
    print(json.dumps(groups,indent=2))

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));ap.add_argument('--execute',type=Path)
    args=ap.parse_args()
    if args.execute:
        execute(args.execute.resolve())
    else:
        prepare(args)
if __name__=='__main__':main()
