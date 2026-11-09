"""Freeze/execute an independent small-FSM no-STA vs structured-STA comparison.

Preparation is local only. Execute sends at most ten independently frozen
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
ARMS=('no_timing_feedback','structured_timing_feedback')
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

def prepare(args):
    if not args.model: raise ValueError('Exact model ID required')
    old=args.baseline.resolve();base=load(old/'result.json');bp=load(old/'protocol.json')
    assert base['status']=='PASS' and base['formal']==base['mapped_formal']==base['ppa']=='PASS'
    assert bp['candidate_sha256']==bp['reference_sha256']==sha(SOURCE)
    assert bp['clock']=='clk' and bp['reset']=='clear' and bp['reset_cycles']==bp['warmup_samples']==1 and bp['period_ns']==10
    assert bp['parameter_overrides']=={} and bp['reset_active']==1
    s=E/datetime.now().strftime('ticket_feedback_study_%Y%m%d_%H%M%S_%f');s.mkdir()
    (s/'inputs').mkdir();shutil.copyfile(SOURCE,s/'inputs/original.v');shutil.copyfile(LICENSE,s/'inputs/LICENSE')
    shutil.copytree(old,s/'baseline')
    contract=dict(top='ticket_machine',clock='clk',reset='clear',reset_active=1,reset_cycles=1,warmup_samples=1,
                  reset_after_startup='unconstrained',period_ns=10,parameter_overrides={},parameter_defaults=dict(ON=1,OFF=0),
                  input_delay_ns=0,output_delay_ns=0,input_transition_ns=.1,output_load_pf=.01,
                  preserve_output_latency=True,library='SKY130HD TT 025C 1v80',library_sha256=sha(LIB))
    cap=base['mapped_area_um2']*1.10
    common=make_prompt((s/'inputs/original.v').read_text(encoding='utf-8'),contract,None,None,cap)
    common.pop('actual_eda_feedback');common.pop('previous_attempt')
    common['functional_contract']='Preserve outputs ready, dispense, return_sig and bill for every sampled input sequence after the fixed startup reset, including ten=twenty=1 (ten has source-defined priority) and arbitrary later clear assertions. Preserve original module parameter declarations and defaults. No added init/assume, unreachable-state input assumptions, or latency changes. Proof applies to default ON=1 and OFF=0 only.'
    common['objective']='Strictly improve worst setup slack without regressing TNS, within fixed area budget. Original baseline remains available. No measured gain claim before EDA.'
    common['baseline_area_um2']=base['mapped_area_um2']
    mapping=(s/'baseline/mapping.log').read_text(encoding='utf-8')
    table=[dict(original_encoding=a,mapped_encoding=b) for a,b in re.findall(r'^\s*([01]{6})\s+->\s+([-01]{6})\s*$',mapping,re.M)]
    assert len(table)==6,'Missing actual FSM recoding table'
    code=(s/'baseline/mapped.v').read_text(encoding='utf-8')
    assert re.search(r'sky130_fd_sc_hd__dfxtp_1\s+_44_\s*\(\s*\.CLK\(clk\),\s*\.D\(_02_\),\s*\.Q\(State\[1\]\)',code)
    assert re.search(r'sky130_fd_sc_hd__or3_4\s+_39_\s*\(\s*\.A\(State\[1\]\),\s*\.B\(State\[3\]\),\s*\.C\(State\[2\]\),\s*\.X\(bill\)',code)
    assert next(r['original_encoding'] for r in table if r['mapped_encoding']=='----1-')=='100000'
    raw=feedback(s/'baseline',base)
    paths=raw['measured_paths'][:3]
    assert len(paths)==3 and 'Endpoint: bill ' in paths[0] and '_39_/X (sky130_fd_sc_hd__or3_4)' in paths[0]
    localization=dict(baseline_metrics={k:base[k] for k in ['wns_ns','tns_ns','mapped_area_um2']},measured_paths=paths,
        fsm_recode_table_from_mapping_log=table,
        worst_path=dict(mapped_startpoint='_44_/Q',mapped_start_signal='State[1]',original_state='BILL30',original_state_encoding='100000',
                        mapped_endpoint='bill',mapped_gate='sky130_fd_sc_hd__or3_4',mapped_gate_inputs=['State[1]','State[3]','State[2]'],
                        clock_to_q_ns=.30,or_gate_increment_ns=.40,data_arrival_ns=.70,data_required_ns=10.0,slack_ns=9.30),
        warning='Yosys recoded the FSM. Mapped State[i] indices are not original RTL State[i] indices. Encoding correspondence is from synthesis log; no general gate-to-source attribution or causal optimization guarantee.',
        evidence_sha256={n:sha(s/'baseline'/n) for n in ['sta.log','mapping.log','mapped.v','mapped.json']})
    guided=dict(common);guided['actual_structured_timing_feedback']=localization
    (s/'prompts').mkdir()
    for arm,payload in zip(ARMS,[common,guided]):save(s/'prompts'/(arm+'.json'),payload)
    (s/'code_snapshot').mkdir()
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    schedule=[dict(call_index=i*2+j+1,arm=a,candidate_id=f'candidate_{i+1:02d}') for i in range(5) for j,a in enumerate(ARMS if i%2==0 else ARMS[::-1])]
    transport=http_transport();binary=shutil.which('curl.exe') if transport=='curl' else None
    p=dict(status='FROZEN_PENDING_AUTHORIZATION',purpose='Exploratory small sequential-control family; no guarantee of optimization or feedback advantage',
           model=args.model,api_endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),
           request_parameters=request_parameters_for_model(args.model),http_transport=transport,
           transport_binary_sha256=sha(Path(binary)) if binary else None,
           arms=list(ARMS),candidates_per_arm=5,maximum_requests=10,call_schedule=schedule,
           llm_timeout_seconds=180,timeout_seconds=120,contract=contract,area_ratio_limit=1.10,area_cap_um2=cap,baseline_metrics=base,
           completion_token_cap='No explicit token cap in existing adapter; identical model defaults across arms. Timeout and request count do not impose a currency cap.',
           library_sha256=sha(LIB),input_sha256={f.name:sha(f) for f in (s/'inputs').iterdir()},
           dependency_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},
           baseline_artifact_sha256={f.name:sha(f) for f in (s/'baseline').iterdir() if f.is_file()},
           prompt_sha256={a:sha(s/'prompts'/(a+'.json')) for a in ARMS},
           baseline_reuse=dict(original_directory=str(old),note='Byte-copy of fresh local original-vs-original evaluation; protocol records original source location; source hashes checked equal to frozen input.'),
           selection='Strict WNS gain over original, TNS non-regressed, actual mapped area <=110% original. Rank gain candidates by WNS then area; retain original otherwise.',
           policy='Identical common prompt fields, guided-only measured feedback. Independent interleaved calls; no retries or replacement draws; no candidate history. Finish all requests before candidate EDA. All failures retained. No significance claim from 5/arm.',
           exposure='Public RTL-OPT source previously read and baseline-qualified; not used for current arbiter operator development. Not a model-training holdout. Do not send ticket_machine_ref or expert solution.',
           limitations='One small six-state design, baseline 28 mapped cells, positive slack. Not large-engineering or universal-method evidence. Ideal-clock TT pre-layout result, no power/hold/CDC signoff.')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    save(s/'STATUS.json',dict(state='READY_PENDING_USER_AUTHORIZATION',actual_model_requests=0,planned_maximum=10))
    validate(s,p)
    print('Prepared: '+str(s));print('Maximum model requests: 10; actual requests: 0')

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
    assert auth['approved_maximum_requests']==10 and auth['protocol_sha256']==sha(s/'protocol.json')
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
        print(f'Calling {slot["call_index"]}/10 {slot["arm"]}',flush=True)
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
    save(s/'summary.json',dict(status='COMPLETED',request_attempts=10,protocol_sha256=sha(s/'protocol.json'),groups=groups,results=results))
    print(json.dumps(groups,indent=2))

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--baseline',type=Path);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));ap.add_argument('--execute',type=Path)
    args=ap.parse_args()
    if args.execute:
        if args.baseline:ap.error('--baseline only applies to preparation')
        execute(args.execute.resolve())
    else:
        if not args.baseline:ap.error('--baseline required for local preparation')
        prepare(args)
if __name__=='__main__':main()
