"""Frozen N=24 action-selection pilot; independent prompts, two actions/request.

Prepare is local. Execute needs a new protocol-bound authorization receipt.
All model choices are frozen before the six-candidate oracle is measured.
"""
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import statistics
import sys
import time
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate,choose,sha,load,save,SOURCE,E
from agents.action_selector import REGISTRY,select_actions,LLMGenerationError
from agents.rtl_optimizer import request_parameters_for_model,http_transport
from rewrite.comparator_rewrites import materialize
ARMS=('no_timing_feedback','sta_feedback');LIB=E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
DEPS=[Path(__file__).resolve(),ROOT/'agents/action_loop.py',ROOT/'agents/action_selector.py',ROOT/'agents/rtl_optimizer.py',ROOT/'rewrite/comparator_rewrites.py',E/'run_native_comb.py',E/'trace_sta_rtl_cone.py']
def validate(s,p):
    assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip()
    for rel,h in p['code_sha256'].items():assert sha(ROOT/rel)==sha(s/'code_snapshot'/Path(rel).name)==h
    for name,h in p['input_sha256'].items():assert sha(s/'inputs'/name)==h
    for i,h in p['candidate_sha256'].items():assert sha(s/'candidates'/(i+'.v'))==h
    for arm,h in p['prompt_sha256'].items():assert sha(s/'prompts'/(arm+'.json'))==h
    for name,h in p['baseline_sha256'].items():assert sha(s/'baseline'/name)==h
    assert sha(LIB)==p['library_sha256']
def prepare(model):
    if not model:raise ValueError('Exact model ID required')
    s=E/datetime.now().strftime('action_selection_N24_%Y%m%d_%H%M%S_%f');s.mkdir()
    for name in ['inputs','candidates','prompts','code_snapshot']:(s/name).mkdir()
    shutil.copyfile(SOURCE,s/'inputs/original.v');shutil.copyfile(ROOT/'benchmark/rtl_opt_upstream_hkust/LICENSE',s/'inputs/LICENSE')
    source=(s/'inputs/original.v').read_text(encoding='utf-8')
    for i,spec in REGISTRY.items():(s/'candidates'/(i+'.v')).write_text(materialize(source,spec),encoding='utf-8')
    # Only the unchanged original is measured before model choices.
    base=evaluate(s/'inputs/original.v',s/'baseline',s/'inputs/original.v',24)
    if base.get('status')!='PASS':raise RuntimeError('Baseline failed: '+str(s))
    common=dict(task='Select exactly two distinct actions from the fixed catalog. Do not return RTL.',
        original_rtl=source,top='comparator',parameter_overrides={'N':24},hardware_width=24,
        action_catalog=[dict(id=i,**spec) for i,spec in REGISTRY.items()],
        action_semantics='Replace unsigned equality/greater comparison with chunk comparisons. Higher chunks dominate: gt=gt_high OR (eq_high AND gt_low); eq=eq_high AND eq_low. Balanced uses padded binary composition; linear folds chunks from low to high. All other selector/output behavior stays unchanged.',
        objective='Within fixed original area cap, minimize maximum combinational data arrival after complete source and mapped equivalence and electrical checks. Original stays available. Exactly two candidate EDA slots per selection; no repairs/replacement draws.',
        mapped_area_cap_um2=base['mapped_area_um2']*1.10,baseline_area_um2=base['mapped_area_um2'],
        technology=dict(library='SKY130HD TT 025C 1v80',input_transition_ns=.10,output_load_pf=.010,mapping='ABC map; cleanup; buffer; upsize; dnsize'),
        response_format=dict(action_ids=['one_allowed_ID','a_different_allowed_ID'],rationale='Non-empty short reason; estimates are not measured gains'),
        rules=['Return one JSON object with exactly action_ids and rationale, no markdown or wrappers.',
               'No arbitrary RTL, edits, extra actions, parameters, or commands. Do not claim measured improvements before EDA.'])
    text=(s/'baseline/sta.log').read_text(encoding='utf-8');parts=text.split('Startpoint: ')[1:4]
    paths=['Startpoint: '+part.split('worst slack max',1)[0].split('PW_ELECTRICAL_BEGIN',1)[0].strip() for part in parts]
    guided=dict(common);guided['actual_baseline_sta']=dict(max_data_arrival_ns=base['max_data_arrival_ns'],critical_startpoint=base['critical_startpoint'],critical_endpoint=base['critical_endpoint'],measured_paths=paths,warning='Mapped names are not an exact RTL source-line attribution. Only baseline measurements, no candidate outcomes.')
    for arm,payload in zip(ARMS,[common,guided]):save(s/'prompts'/(arm+'.json'),payload)
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    schedule=[dict(call_index=i*2+j+1,arm=arm,slot=f'selection_{i+1:02d}') for i in range(3) for j,arm in enumerate(ARMS if i%2==0 else ARMS[::-1])]
    curl=shutil.which('curl.exe') if http_transport()=='curl' else None
    p=dict(client_date='2026-11-03',scope='Prospective unmeasured N=24 parameter instance of an exposed comparator family; not a new family or model-training holdout.',
        model=model,api_endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),http_transport=http_transport(),transport_sha256=sha(Path(curl)) if curl else None,
        request_parameters=request_parameters_for_model(model),maximum_requests=6,requests_per_arm=3,actions_per_request=2,call_schedule=schedule,
        width=24,baseline_metrics=base,area_cap_um2=base['mapped_area_um2']*1.10,registry=REGISTRY,
        input_sha256={f.name:sha(f) for f in (s/'inputs').iterdir()},candidate_sha256={i:sha(s/'candidates'/(i+'.v')) for i in REGISTRY},
        prompt_sha256={arm:sha(s/'prompts'/(arm+'.json')) for arm in ARMS},baseline_sha256={f.name:sha(f) for f in (s/'baseline').iterdir() if f.is_file()},
        code_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},library_sha256=sha(LIB),
        primary='Per request best of exactly two selected candidate slots, original retained on invalid selection/failed generation/no eligible gain. Report all three trials per arm; no universal claim.',
        oracle='After all model selections frozen, measure all six actions once. Shared immutable results reused across slots; exhaustive best is a six-action upper bound, not an equal-budget method.',
        policy='No retries or repair calls. Duplicate/unknown/extra actions or RTL fields reject whole response. No selected candidate PPA before generation manifest. No prior candidate PPA sent.',
        exposure='N=1/13/32 measured and inspected during library development. N=24 predeclared here before any candidate measurement; family/source/operator choices exposed.',
        limits='Three requests per arm on one parameter instance. Same request/EDA-slot budgets but unequal prompt tokens; provider backend identity unverified. No explicit completion-token/currency hard cap. TT pre-layout.',
        state='PREPARED_PENDING_AUTHORIZATION')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    validate(s,p);print('Prepared: '+str(s));print('Actual model requests: 0; candidate EDA before selection: 0')
def execute(s):
    p=load(s/'protocol.json');validate(s,p);auth=load(s/'AUTHORIZATION.json')
    assert auth['approved_maximum_requests']==p['maximum_requests']==6 and auth['protocol_sha256']==sha(s/'protocol.json')
    assert auth['endpoint']==p['api_endpoint'] and auth['model']==p['model']
    assert p['api_endpoint']==os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/') and p['http_transport']==http_transport()
    if p['transport_sha256']:assert sha(Path(shutil.which('curl.exe')))==p['transport_sha256']
    selections=[];source=(s/'inputs/original.v').read_text(encoding='utf-8')
    for slot in p['call_schedule']:
        validate(s,p);f=s/slot['arm']/slot['slot'];f.mkdir(parents=True,exist_ok=True)
        if (f/'generation.json').exists():selections.append(load(f/'generation.json'));continue
        if (f/'attempt.json').exists():raise RuntimeError('Uncertain previous attempt; no duplicate call')
        prompt=(s/'prompts'/(slot['arm']+'.json')).read_text(encoding='utf-8');(f/'prompt.txt').write_text(prompt,encoding='utf-8')
        save(f/'attempt.json',dict(slot=slot,protocol_sha256=sha(s/'protocol.json')));row=dict(**slot,action_ids=[]);start=time.monotonic()
        print('Calling '+str(slot['call_index'])+'/6 '+slot['arm'],flush=True)
        try:
            chosen=select_actions(prompt,model=p['model'],source=source,audit_dir=f/'api_audit')
            assert all(chosen['rtl_by_action'][i]==(s/'candidates'/(i+'.v')).read_text(encoding='utf-8') for i in chosen['action_ids'])
            row.update(status='SELECTED',action_ids=chosen['action_ids'],rationale=chosen['rationale'],provider_metadata=chosen['provider_metadata'])
        except LLMGenerationError as exc:row.update(status='FAILED_SELECTION',error=str(exc))
        row['seconds']=time.monotonic()-start;save(f/'generation.json',row);selections.append(row)
    if not (s/'selection_manifest.json').exists():save(s/'selection_manifest.json',dict(protocol_sha256=sha(s/'protocol.json'),selections=selections))
    validate(s,p);results={}
    for i in REGISTRY:
        f=s/'evaluations'/i
        results[i]=load(f/'result.json') if (f/'result.json').exists() else evaluate(s/'candidates'/(i+'.v'),f,s/'inputs/original.v',p['width'])
    trials=[];base=p['baseline_metrics']
    for row in selections:
        best=choose(row['action_ids'],results,base,p['area_cap_um2'])
        trials.append(dict(**row,selected=best,metrics=base if best=='baseline' else results[best]))
    oracle=choose(list(REGISTRY),results,base,p['area_cap_um2'])
    groups={arm:dict(requests=3,valid_selections=sum(r['status']=='SELECTED' for r in trials if r['arm']==arm),
        improved_trials=sum(r['selected']!='baseline' for r in trials if r['arm']==arm),
        trial_delays=[r['metrics']['max_data_arrival_ns'] for r in trials if r['arm']==arm],
        median_delay_ns=statistics.median(r['metrics']['max_data_arrival_ns'] for r in trials if r['arm']==arm)) for arm in ARMS}
    save(s/'summary.json',dict(status='COMPLETED',actual_request_slots=6,groups=groups,trials=trials,action_results=results,oracle_selected=oracle,oracle_metrics=base if oracle=='baseline' else results[oracle]))
    print(json.dumps(groups,indent=2));print('Oracle selected: '+oracle)
def main():
    import argparse
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--execute',type=Path);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));a=ap.parse_args()
    execute(a.execute.resolve()) if a.execute else prepare(a.model)
if __name__=='__main__':main()
