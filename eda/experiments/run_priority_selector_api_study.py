"""Twelve-request prospective/exposed priority action-selection study.

W64 is primary and candidate PPA is not inspected before model choices freeze.
W128 is explicitly exposed secondary. One action/request; static16 and static8
each receive one logical candidate slot; six-action enumeration is oracle only.
"""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import statistics
import sys
import time
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate,choose,sha,load,save,E,PRIORITY_SOURCE
from agents.action_selector import PRIORITY_REGISTRY,select_actions,LLMGenerationError
from agents.rtl_optimizer import request_parameters_for_model,http_transport,api_configured
from rewrite.priority_rewrites import materialize
ARMS=('no_sta','sta');WIDTHS=(64,128)
LIB=E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
DEPS=[Path(__file__).resolve(),ROOT/'agents/action_selector.py',ROOT/'agents/action_loop.py',ROOT/'agents/rtl_optimizer.py',ROOT/'rewrite/priority_rewrites.py',ROOT/'rewrite/comparator_rewrites.py',E/'run_native_comb.py',E/'trace_sta_rtl_cone.py']
def validate(s,p):
    assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip()
    for rel,h in p['code_sha256'].items():assert sha(ROOT/rel)==sha(s/'code_snapshot'/Path(rel).name)==h
    for name,h in p['input_sha256'].items():assert sha(s/'inputs'/name)==h
    for i,h in p['candidate_sha256'].items():assert sha(s/'candidates'/(i+'.v'))==h
    for name,h in p['prompt_sha256'].items():assert sha(s/'prompts'/name)==h
    for name,h in p['baseline_sha256'].items():assert sha(s/name)==h
    assert sha(LIB)==p['library_sha256']
def prepare(model):
    if not model:raise ValueError('Exact model ID required')
    s=E/datetime.now().strftime('priority_selector_api_%Y%m%d_%H%M%S_%f');s.mkdir()
    for name in ['inputs','prompts','candidates','code_snapshot']:(s/name).mkdir()
    shutil.copyfile(PRIORITY_SOURCE,s/'inputs/original.v');shutil.copyfile(PRIORITY_SOURCE.parents[1]/'COPYING',s/'inputs/LICENSE')
    source=(s/'inputs/original.v').read_text(encoding='utf-8')
    for i,spec in PRIORITY_REGISTRY.items():(s/'candidates'/(i+'.v')).write_text(materialize(source,spec),encoding='utf-8')
    def baseline(w):return w,evaluate(s/'inputs/original.v',s/f'W{w}'/'baseline',s/'inputs/original.v',w,top='priority_encoder',parameters={'WIDTH':w,'LSB_HIGH_PRIORITY':0})
    with ThreadPoolExecutor(max_workers=2) as pool:bases=dict(pool.map(baseline,WIDTHS))
    if any(m.get('status')!='PASS' for m in bases.values()):raise RuntimeError('Baseline failure; no requests made: '+str(s))
    for w,base in bases.items():
        common=dict(task='Choose exactly ONE structural action ID; do not return RTL.',source_rtl=source,top='priority_encoder',parameters={'WIDTH':w,'LSB_HIGH_PRIORITY':0},
            action_catalog=[dict(id=i,**spec) for i,spec in PRIORITY_REGISTRY.items()],
            semantics='Grouped MSB priority. Each group computes local winner and valid; groups enabled only when no higher group is valid. one-hot output directly uses winners, preserving empty-input index0. group_factored encodes low index bits within groups before group enable, and high bits from group winners. global_onehot encodes by OR masks of global one-hot winner.',
            objective='Minimize maximum combinational data arrival, with actual mapped area <= cap. Strict source/mapped equivalence, electrical checks, no latency changes. Original remains available. One candidate EDA slot per request.',
            mapped_area_cap_um2=base['mapped_area_um2']*1.10,baseline_area_um2=base['mapped_area_um2'],
            technology=dict(library='SKY130HD TT 025C 1v80',input_transition_ns=.10,output_load_pf=.010,virtual_clock_ns=100,mapping='ABC cleanup/buffer/upsize/dnsize'),
            response_schema=dict(action_ids=['ONE_ALLOWED_ID'],rationale='Short explanation; estimates are not measured results'),
            rules=['Exactly action_ids and rationale. No extra actions, RTL, commands, parameter edits or unsupported IDs.','No prior candidate measurements are supplied. Do not claim actual improvement before EDA.'])
        text=(s/f'W{w}'/'baseline/sta.log').read_text(encoding='utf-8')
        paths=['Startpoint: '+part.split('worst slack max',1)[0].split('PW_ELECTRICAL_BEGIN',1)[0].strip() for part in text.split('Startpoint: ')[1:4]]
        guided=dict(common);guided['actual_baseline_sta']=dict(max_data_arrival_ns=base['max_data_arrival_ns'],critical_startpoint=base['critical_startpoint'],critical_endpoint=base['critical_endpoint'],paths=paths,warning='Mapped names are not exact RTL source attribution. Only original baseline feedback, no candidate PPA.')
        for arm,payload in zip(ARMS,[common,guided]):save(s/'prompts'/f'W{w}_{arm}.json',payload)
    schedule=[]
    for rep in range(3):
        for w in (WIDTHS if rep%2==0 else WIDTHS[::-1]):
            for arm in (ARMS if rep%2==0 else ARMS[::-1]):schedule.append(dict(call_index=len(schedule)+1,width=w,arm=arm,trial=rep+1))
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    curl=shutil.which('curl.exe') if http_transport()=='curl' else None
    p=dict(client_date='2026-11-03',primary_width=64,secondary_exposed_width=128,model=model,
        api_endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),http_transport=http_transport(),transport_sha256=sha(Path(curl)) if curl else None,
        request_parameters=request_parameters_for_model(model),maximum_requests=12,actions_per_request=1,trials_per_arm_per_width=3,widths=list(WIDTHS),call_schedule=schedule,
        baseline_metrics={str(w):m for w,m in bases.items()},area_cap_um2={str(w):m['mapped_area_um2']*1.10 for w,m in bases.items()},
        fixed_primary_control='group_factored_16',fixed_secondary_control='group_factored_8',registry=PRIORITY_REGISTRY,
        input_sha256={f.name:sha(f) for f in (s/'inputs').iterdir()},candidate_sha256={i:sha(s/'candidates'/(i+'.v')) for i in PRIORITY_REGISTRY},
        prompt_sha256={f.name:sha(f) for f in (s/'prompts').iterdir()},baseline_sha256={str(f.relative_to(s)):sha(f) for w in WIDTHS for f in (s/f'W{w}'/'baseline').iterdir() if f.is_file()},
        code_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},library_sha256=sha(LIB),
        policy='One action/request, twelve interleaved independent requests, no retries/repairs/replacement draws. Freeze all selections before measuring W64 candidates. All six unique candidate PPAs per width shared after selection, not independent repeated RTL samples.',
        oracle='Six-action best is a larger-budget attainability reference, not a one-slot competing method. Model/static decisions get one slot and original fallback. Static16 primary and static8 secondary predeclared; do not select between them post-hoc.',
        primary='Median original-retained delay across 3 attempted requests per cell; also all individual choices, valid selections, oracle regret and hits. No inference from three draws on one family.',
        exposure='Public priority family and W128/W256/W17 operators developed and PPA inspected. W64 original baseline was previously exposed; new six-action W64 candidate PPA not inspected before this study. W128 is explicitly exposed development replication, not holdout.',
        authorization_basis='User explicitly requested more API calls; assistant announced a self-imposed maximum12, not an exact quoted user limit.',
        limitations='One family, two widths; candidate count equal, prompt tokens not equal. Requested gateway model identity unverified. No explicit output-token or currency hard cap. Pre-layout TT IO assumptions, no signoff.')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    validate(s,p);print('Prepared: '+str(s),flush=True)
def execute(s):
    p=load(s/'protocol.json');validate(s,p);auth=load(s/'AUTHORIZATION.json')
    assert auth['maximum_requests']==p['maximum_requests']==12 and auth['protocol_sha256']==sha(s/'protocol.json')
    assert api_configured() and p['api_endpoint']==os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/') and p['http_transport']==http_transport()
    if p['transport_sha256']:assert sha(Path(shutil.which('curl.exe')))==p['transport_sha256']
    source=(s/'inputs/original.v').read_text(encoding='utf-8');rows=[]
    for slot in p['call_schedule']:
        validate(s,p);f=s/f"W{slot['width']}"/slot['arm']/f"trial_{slot['trial']:02d}";f.mkdir(parents=True,exist_ok=True)
        if (f/'generation.json').exists():rows.append(load(f/'generation.json'));continue
        if (f/'attempt.json').exists():raise RuntimeError('Uncertain old attempt: refusing duplicate')
        prompt=(s/'prompts'/f"W{slot['width']}_{slot['arm']}.json").read_text(encoding='utf-8');(f/'prompt.txt').write_text(prompt,encoding='utf-8')
        save(f/'attempt.json',dict(slot=slot,protocol_sha256=sha(s/'protocol.json')));r=dict(**slot,action_ids=[]);start=time.monotonic()
        print(f"Calling {slot['call_index']}/12 W{slot['width']} {slot['arm']}",flush=True)
        try:
            chosen=select_actions(prompt,model=p['model'],source=source,template='priority_encoder',action_count=1,audit_dir=f/'api_audit')
            i=chosen['action_ids'][0];assert chosen['rtl_by_action'][i]==(s/'candidates'/(i+'.v')).read_text(encoding='utf-8')
            r.update(status='SELECTED',action_ids=chosen['action_ids'],rationale=chosen['rationale'],normalizations=chosen['output_normalization'],provider_metadata=chosen['provider_metadata'])
        except LLMGenerationError as exc:r.update(status='FAILED_SELECTION',error=str(exc))
        r['seconds']=time.monotonic()-start;save(f/'generation.json',r);rows.append(r)
    if not (s/'selection_manifest.json').exists():save(s/'selection_manifest.json',dict(protocol_sha256=sha(s/'protocol.json'),rows=rows))
    def measure(job):
        w,i=job;f=s/f'W{w}'/'evaluations'/i
        m=load(f/'result.json') if (f/'result.json').exists() else evaluate(s/'candidates'/(i+'.v'),f,s/'inputs/original.v',w,top='priority_encoder',parameters={'WIDTH':w,'LSB_HIGH_PRIORITY':0})
        return w,i,m
    with ThreadPoolExecutor(max_workers=2) as pool:measured=list(pool.map(measure,[(w,i) for w in WIDTHS for i in PRIORITY_REGISTRY]))
    results={str(w):{i:m for width,i,m in measured if width==w} for w in WIDTHS};trials=[];controls={};groups={}
    for w in WIDTHS:
        key=str(w);base=p['baseline_metrics'][key];cap=p['area_cap_um2'][key];pool=results[key]
        oracle=choose(list(pool),pool,base,cap)
        controls[key]=dict(oracle=oracle,oracle_metrics=base if oracle=='baseline' else pool[oracle])
        for name,i in [('static16',p['fixed_primary_control']),('static8',p['fixed_secondary_control'])]:
            best=choose([i],pool,base,cap);controls[key][name]=dict(action=i,selected=best,metrics=base if best=='baseline' else pool[best])
        for r in [r for r in rows if r['width']==w]:
            best=choose(r['action_ids'],pool,base,cap);m=base if best=='baseline' else pool[best]
            trials.append(dict(**r,selected=best,metrics=m,regret_ns=m['max_data_arrival_ns']-controls[key]['oracle_metrics']['max_data_arrival_ns']))
        groups[key]={}
        for arm in ARMS:
            rr=[r for r in trials if r['width']==w and r['arm']==arm]
            groups[key][arm]=dict(attempts=3,valid_selections=sum(r['status']=='SELECTED' for r in rr),improved_trials=sum(r['selected']!='baseline' for r in rr),
                median_delay_ns=statistics.median(r['metrics']['max_data_arrival_ns'] for r in rr),delays_ns=[r['metrics']['max_data_arrival_ns'] for r in rr],
                oracle_hits=sum(abs(r['regret_ns'])<1e-9 for r in rr) if oracle!='baseline' else None)
    save(s/'summary.json',dict(status='COMPLETED',actual_request_slots=12,groups=groups,trials=trials,controls=controls,action_results=results))
    print(json.dumps(groups,indent=2),flush=True)
def main():
    import argparse
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));ap.add_argument('--execute',type=Path);a=ap.parse_args()
    execute(a.execute.resolve()) if a.execute else prepare(a.model)
if __name__=='__main__':main()
