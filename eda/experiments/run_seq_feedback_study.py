"""Frozen independent no-STA versus STA comparison on native arbiter32 stateful RTL."""
import argparse
from datetime import datetime
import hashlib
import json
import math
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.sequential_loop import make_prompt,feedback,decision
from agents.rtl_optimizer import generate_from_prompt,api_configured,request_parameters_for_model,http_transport,LLMGenerationError

RUNNER=Path(__file__).with_name('run_native_seq.py')
UPSTREAM=ROOT/'benchmark/engineering_sources_20261030/verilog-axis'
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
PARAMS={'PORTS':32,'ARB_TYPE_ROUND_ROBIN':1,'ARB_BLOCK':1,'ARB_BLOCK_ACK':1}
ARMS=('no_timing_feedback','actual_paths')
DEPS=[Path(__file__).resolve(),RUNNER,RUNNER.with_name('run_native_comb.py'),RUNNER.with_name('trace_sta_rtl_cone.py'),ROOT/'agents/sequential_loop.py',ROOT/'agents/rtl_optimizer.py']

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):
    with p.open('x',encoding='utf-8') as f:json.dump(x,f,indent=2,ensure_ascii=False,allow_nan=False)

def evaluate(candidate,out,study,timeout):
    cmd=[sys.executable,'-B',str(RUNNER),str(candidate),'--reference',str(study/'inputs/original.v'),
        '--dependency',str(study/'inputs/priority_encoder.v'),'--top','arbiter','--clock','clk','--reset','rst',
        '--reset-cycles','1','--warmup','1','--period','10','--timeout',str(timeout),'--out',str(out)]
    for k,v in PARAMS.items():cmd+=['--param',f'{k}={v}']
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout*8)
        raw=p.stdout
    except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
    out.mkdir(exist_ok=True);(out/'runner.log').write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',eligible=False,formal='NOT_RUN',ppa='NOT_RUN')

def validate(s,p):
    assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip(),'Protocol changed'
    assert sha(LIB)==p['library_sha256'],'Library changed'
    for path,h in p['dependency_sha256'].items():assert sha(ROOT/path)==h and sha(s/'code_snapshot'/Path(path).name)==h
    for name,h in p['input_sha256'].items():assert sha(s/'inputs'/name)==h
    for arm,h in p['prompt_sha256'].items():assert sha(s/'prompts'/(arm+'.txt'))==h

def prepare(args):
    s=ROOT/'eda/experiments'/datetime.now().strftime('seq_feedback_arbiter32_%Y%m%d_%H%M%S_%f');s.mkdir()
    (s/'inputs').mkdir();shutil.copyfile(UPSTREAM/'rtl/arbiter.v',s/'inputs/original.v');shutil.copyfile(UPSTREAM/'rtl/priority_encoder.v',s/'inputs/priority_encoder.v');shutil.copyfile(UPSTREAM/'COPYING',s/'inputs/UPSTREAM_COPYING')
    base=evaluate(s/'inputs/original.v',s/'baseline',s,args.timeout)
    if base.get('status')!='PASS' or not base.get('eligible'):raise RuntimeError('Baseline failed; no requests made: '+str(s))
    contract=dict(top='arbiter',clock='clk',reset='rst',reset_active=1,reset_cycles=1,warmup_samples=1,period_ns=10,
        parameter_overrides=PARAMS,fixed_dependencies=[dict(name='priority_encoder.v',sha256=sha(s/'inputs/priority_encoder.v'))],
        reset_after_startup='unconstrained',preserve_output_latency=True,input_delay_ns=0,output_delay_ns=0,
        input_transition_ns=.10,output_load_pf=.010,library_sha256=sha(LIB))
    cap=base['mapped_area_um2']*args.area_limit
    payload=make_prompt((s/'inputs/original.v').read_text(encoding='utf-8'),contract,None,None,cap,
        dependency_sources=[dict(name='priority_encoder.v',sha256=sha(s/'inputs/priority_encoder.v'),rtl=(s/'inputs/priority_encoder.v').read_text(encoding='utf-8'))])
    payload.pop('actual_eda_feedback');payload.pop('previous_attempt')
    payload['functional_contract']='All request and acknowledge bits are arbitrary, including simultaneous/multiple bits. Preserve exact edge-sampled grant, grant_valid, grant_encoded, blocking/acknowledge behavior and round-robin state of the original. Retain original parameter names/defaults and existing init semantics. No one-hot-input assumptions, latency changes, or fairness/liveness claims. You may replace helper uses with top-local logic, but do not redefine the frozen priority_encoder module. Only the specified parameter instance is proved.'
    common=json.dumps(payload,indent=2,ensure_ascii=False)
    measured=feedback(s/'baseline',base)
    measured['measured_paths']=measured['measured_paths'][:3]
    measured['metrics']={k:base[k] for k in ['wns_ns','tns_ns']}
    guided=common+'\n\nActual baseline timing metrics and three mapped paths (no exact source-line mapping claimed):\n'+json.dumps(measured,indent=2,ensure_ascii=False)
    (s/'prompts').mkdir()
    for arm,text in zip(ARMS,[common,guided]):(s/'prompts'/(arm+'.txt')).write_text(text,encoding='utf-8')
    (s/'code_snapshot').mkdir()
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    schedule=[dict(call_index=i*2+j+1,arm=arm,candidate_id=f'candidate_{i+1:02d}') for i in range(3) for j,arm in enumerate(ARMS if i%2==0 else ARMS[::-1])]
    transport=http_transport();binary=shutil.which('curl.exe') if transport=='curl' else None
    p=dict(purpose='Exploratory new-family sequential feedback comparison, not a universal-superiority test',
        model=args.model,api_endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),
        request_parameters=request_parameters_for_model(args.model),http_transport=transport,
        transport_binary_sha256=sha(Path(binary)) if binary else None,
        arms=list(ARMS),candidates_per_arm=3,maximum_requests=6,call_schedule=schedule,
        timeout_seconds=args.timeout,llm_timeout_seconds=180,contract=contract,baseline_metrics=base,area_cap_um2=cap,
        area_ratio_limit=args.area_limit,
        library_sha256=sha(LIB),input_sha256={f.name:sha(f) for f in (s/'inputs').iterdir()},
        dependency_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},prompt_sha256={a:sha(s/'prompts'/(a+'.txt')) for a in ARMS},
        policy='Independent interleaved requests, no previous candidate or outcomes in any prompt; no retries. Freeze all generations before candidate EDA. Every candidate directly compared to original. Fixed baseline area cap. Failed slots retained.',
        primary_metric='Best eligible WNS with original retained; strict gain required and TNS may not regress',
        exposure='Original source and manual controls previously inspected. No prior recorded model generation for arbiter top; priority_encoder helper previously studied. Public code, not model-training holdout.',
        limitations='Single synchronous positive-edge clock, startup reset sampled once, only frozen parameters, fixed helper, TT pre-layout ideal-clock/IO assumptions; no hold/power/CDC signoff')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    print('Prepared: '+str(s));print('Baseline WNS/area: '+str(base['wns_ns'])+' / '+str(base['mapped_area_um2']))

def execute(s):
    p=load(s/'protocol.json');validate(s,p)
    assert api_configured(),'No configured key'
    assert p['api_endpoint']==os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/')
    assert p['http_transport']==http_transport()
    if p['transport_binary_sha256']:assert sha(Path(shutil.which('curl.exe')))==p['transport_binary_sha256']
    generations=[]
    for slot in p['call_schedule']:
        validate(s,p);f=s/slot['arm']/slot['candidate_id'];f.mkdir(parents=True,exist_ok=True)
        if (f/'generation.json').exists():generations.append(load(f/'generation.json'));continue
        if (f/'attempt.json').exists():raise RuntimeError('Uncertain old request, refusing automatic duplicate')
        prompt=(s/'prompts'/(slot['arm']+'.txt')).read_text(encoding='utf-8');(f/'prompt.txt').write_text(prompt,encoding='utf-8')
        save(f/'attempt.json',dict(slot=slot,started_at=datetime.now().astimezone().isoformat()))
        row=dict(**slot,candidate_sha256=None);start=time.monotonic();print(f'Calling {slot["call_index"]}/6: {slot["arm"]}',flush=True)
        try:
            generated=generate_from_prompt(prompt,model=p['model'],candidate_index=slot['call_index'],timeout_s=p['llm_timeout_seconds'],audit_dir=f/'api_audit')
            (f/'candidate.v').write_text(generated.rtl,encoding='utf-8')
            row.update(status='GENERATED',candidate_sha256=sha(f/'candidate.v'),explanation=generated.explanation,parameters=generated.generation_parameters,response_model=generated.model)
        except LLMGenerationError as exc:row.update(status='FAILED_GENERATION',error=str(exc))
        row['seconds']=time.monotonic()-start;save(f/'generation.json',row);generations.append(row)
        print('Returned: '+row['status'],flush=True)
    manifest=s/'candidate_manifest.json'
    if not manifest.exists():save(manifest,dict(protocol_sha256=sha(s/'protocol.json'),slots=generations))
    base=p['baseline_metrics'];results=[];groups={}
    for row in generations:
        validate(s,p);f=s/row['arm']/row['candidate_id']
        if (f/'result.json').exists():results.append(load(f/'result.json'));continue
        r=dict(**row,accepted=False,metrics=None)
        if row['candidate_sha256']:
            assert sha(f/'candidate.v')==row['candidate_sha256']
            metrics=evaluate(f/'candidate.v',f/'eda',s,p['timeout_seconds'])
            accepted,reason=decision(metrics,base,p['area_cap_um2']);r.update(metrics=metrics,accepted=accepted,reason=reason)
        else:r['reason']='No returned RTL; generation failure retained'
        save(f/'result.json',r);results.append(r);print('Evaluated '+row['arm']+'/'+row['candidate_id']+': '+str(r['accepted']),flush=True)
    for arm in ARMS:
        rows=[r for r in results if r['arm']==arm];valid=[r for r in rows if r['accepted']]
        valid.sort(key=lambda r:(-r['metrics']['wns_ns'],r['metrics']['mapped_area_um2'],r['candidate_id']))
        best=valid[0] if valid else None;export=s/'selected'/arm;export.mkdir(parents=True,exist_ok=True)
        source=s/arm/best['candidate_id']/'candidate.v' if best else s/'inputs/original.v';shutil.copyfile(source,export/'arbiter.v')
        groups[arm]=dict(scheduled=3,returned=sum(r['candidate_sha256'] is not None for r in rows),valid_improvements=len(valid),
            selected_origin=best['candidate_id'] if best else 'baseline_retained',selected_metrics=best['metrics'] if best else base,
            selected_rtl_sha256=sha(export/'arbiter.v'),reported_tokens=sum(r.get('parameters',{}).get('usage',{}).get('total_tokens',0) for r in rows))
    save(s/'summary.json',dict(status='COMPLETED',request_attempts=6,protocol_sha256=sha(s/'protocol.json'),manifest_sha256=sha(manifest),groups=groups,results=results))
    print(json.dumps(groups,indent=2),flush=True)

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--execute',type=Path);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));ap.add_argument('--timeout',type=int,default=120)
    ap.add_argument('--area-limit',type=float,default=None,help='Area/baseline ratio for a NEW frozen study (default 1.10), e.g. 1.25; cannot override --execute')
    a=ap.parse_args()
    if a.execute:
        if a.area_limit is not None:ap.error('--execute uses its frozen area cap; create a new study to change the budget')
        execute(a.execute.resolve())
    else:
        a.area_limit=1.10 if a.area_limit is None else a.area_limit
        if not a.model or a.timeout<1:ap.error('Exact model and positive timeout required')
        if not math.isfinite(a.area_limit) or a.area_limit<1:ap.error('Area ratio must be finite and at least 1')
        prepare(a)

if __name__=='__main__':main()
