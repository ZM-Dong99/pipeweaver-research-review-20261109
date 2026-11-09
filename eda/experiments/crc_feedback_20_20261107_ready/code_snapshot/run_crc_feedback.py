"""Twenty frozen CRC32 byte-update requests; preparation is local only."""
import argparse
from collections import Counter
from datetime import datetime,timezone
import hashlib
import json
import math
import os
from pathlib import Path
import random
import shutil
import subprocess
import sys
import statistics

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.sse_transport import curl_completion_stream
from agents.portfolio_loop import qualified
from eda.experiments.evaluate_crc_candidate import STUDY,reference
from eda.experiments.run_stream_feedback import parse_candidate,DEPS as PRIOR_DEPS

EVALUATOR=Path(__file__).with_name('evaluate_crc_candidate.py')
SYSTEM='Optimize the given fixed combinational CRC32 update conservatively. Preserve all input/output semantics. Return exactly the six requested JSON fields.'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def save(path,obj):
    with path.open('x',encoding='utf-8') as f:json.dump(obj,f,ensure_ascii=False,indent=2,allow_nan=False)


def require(ok,reason):
    if not ok:raise RuntimeError(reason)


def evaluate(candidate,out):
    require(not out.exists(),'Refusing to overwrite prior EDA')
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    try:
        p=subprocess.run([sys.executable,'-B',str(EVALUATOR),str(candidate),'--out',str(out)],cwd=ROOT,env=env,capture_output=True,timeout=1200)
        raw=p.stdout+p.stderr
    except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+(e.stderr or b'')+b'\nOVERALL_TIMEOUT'
    out.parent.mkdir(parents=True,exist_ok=True);(out.parent/(out.name+'_runner.log')).write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',reason='No evaluator result')


def select(m,b):
    accepted=(qualified(m) and m['mapped_area_um2']<=b['mapped_area_um2']*1.1+1e-9
              and m['tns_ns']>=b['tns_ns'] and m['max_data_arrival_ns']<b['max_data_arrival_ns'])
    return dict(improved=bool(accepted),retained_delay_ns=m['max_data_arrival_ns'] if accepted else b['max_data_arrival_ns'])


def schedule():
    rng=random.Random(20261108);result=[]
    for trial in range(1,11):
        arms=['no_sta','sta'];rng.shuffle(arms)
        for arm in arms:result.append(dict(index=len(result)+1,arm=arm,trial=trial))
    return result


def prepare(out):
    reference();out.mkdir(parents=True,exist_ok=False)
    for name in ('inputs','prompts','code_snapshot'):(out/name).mkdir()
    original=STUDY/'inputs/crc32_d8.v';shutil.copyfile(original,out/'inputs/original.v')
    shutil.copyfile(STUDY/'inputs/crc32_d8_oracle.v',out/'inputs/bitserial_reference.v')
    baseline=evaluate(out/'inputs/original.v',out/'baseline');require(qualified(baseline),'Fresh original baseline failed')
    control=evaluate(out/'inputs/bitserial_reference.v',out/'bitserial_control');require(qualified(control),'Deterministic comparison validation failed')
    common=('Optimize this fixed CRC32 byte update instance for minimum mapped maximum data arrival. '
        'The top must be crc32_d8, with data_in[7:0], state_in[31:0], data_out[7:0], state_out[31:0], preserving directions. '
        'All40 input bits are unconstrained and all40 output bits must match the supplied original for every binary input. '
        'state_in is arbitrary; do not assume CRC initialization, packet framing, reset, final inversion or valid gating. '
        'data_out is part of the exact interface and must not be omitted or treated as unobserved. '
        'This is a combinational GALOIS reflected CRC32, polynomial0x04c11db7, data width8, feed-forward0. '
        'You may specialize helpers for this fixed top instance; no behavior at other LFSR parameter settings is being scored. '
        'No clocks, internal sequential state, latches, memories, formal assumptions/assertions, includes, external files or extra dependencies. '
        'Return one complete synthesizable Verilog/SystemVerilog design, including any helpers.\n'
        'Both groups use the same Slang frontend on every candidate, native source/mapped SAT proof, Yosys buffer_size mapping '
        'with cleanup-before-buffer, SKY130HD TT25C1.80V, input transition0.10ns, output load0.010pF, zero external IO delays, '
        '100ns virtual reporting clock and no physical parasitics. Full proof and zero reported electrical violations are mandatory.\n'
        f'Baseline mapped area {baseline["mapped_area_um2"]:.6f}um^2; fixed area cap {baseline["mapped_area_um2"]*1.1:.6f}um^2. '
        'No candidate RTL, candidate results or optimization suggestions are supplied.\n'
        'Return exactly one JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries.\n'
        'Original engineering source and exact fixed instance wrapper:\n'+original.read_text(encoding='utf-8'))
    report=(out/'baseline/eda/sta.log').read_text(encoding='utf-8');paths=report.split('Startpoint:')[1:4];require(paths,'Baseline paths missing')
    sta=''.join('Startpoint:'+s for s in paths).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]
    extra='\nActual baseline STA; mapped names are not exact source attribution:\n'+json.dumps({k:baseline[k] for k in ('max_data_arrival_ns','wns_ns','tns_ns')})+'\n'+sta
    for arm,text in (('no_sta',common),('sta',common+extra)):(out/'prompts'/f'{arm}.txt').write_text(text,encoding='utf-8')
    deps=list(dict.fromkeys([Path(__file__).resolve(),EVALUATOR,ROOT/'agents/portfolio_loop.py',ROOT/'agents/sse_transport.py',
         Path(__file__).with_name('prove_crc_affine.py'),*PRIOR_DEPS]))
    for f in deps:shutil.copyfile(f,out/'code_snapshot'/f.name)
    locks=[STUDY/'protocol.json',STUDY/'protocol.sha256',STUDY/'EVALUATION_PROTOCOL.json',STUDY/'AFFINE_SOURCE_PROOF.json',
           STUDY/'crc32_d8_slang_invocation_fixed/elaborated.v',STUDY/'crc32_d8_slang_invocation_fixed/elaborated.json',original]
    curl=shutil.which('curl.exe' if os.name=='nt' else 'curl');require(curl,'curl missing')
    yosys=Path(os.environ.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    lib=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
    p=dict(status='PREPARED_PENDING_EXPLICIT_APPROVAL',endpoint='https://apinebula.ai/v1/chat/completions',model='gpt-6.1-sol',
           maximum_requests=20,timeout_seconds=600,max_completion_tokens=16000,reasoning_effort='medium',automatic_retries=0,
           stop_after_consecutive_transport_failures=3,system=SYSTEM,schedule=schedule(),baseline=baseline,deterministic_control=control,
           primary='Per-arm all10-attempt baseline-retained median arrival; failures remain. Full-cohort conclusion only after20 attempts.',
           secondary='Qualified improvement count, >=5pct gain count, area, unique mapped hashes, token reports and failure breakdown',
           isolation='All responses frozen before candidate EDA. No repair, resampling, replacement or prompt changes.',
           scope='One new-to-project-LLM-optimization functional family and one byte-update instance, not a large streaming module or statistical generalization claim',
           exposure='Source existed in qualification work; no prior project LLM optimization on this CRC instance. Public model training exposure unknown.',
           controls='Original baseline and conventional unrolled bit-serial area/timing tradeoff; control RTL/PPA excluded from both prompts',
           cost='Requested completion cap320000 total; provider enforcement unverified, input tokens additional, failures may be billed. No currency cap or price estimate.',
           disclosure='Public447-line LFSR source plus fixed CRC32 byte wrapper, functional/mapping constraints, baseline area, and STA-arm baseline timing report',
           dependencies={str(f.relative_to(ROOT)):sha(f) for f in deps},reference_locks={str(f.relative_to(ROOT)):sha(f) for f in locks},
           curl_path=curl,curl_sha256=sha(Path(curl)),yosys_path=str(yosys.resolve()),yosys_sha256=sha(yosys),liberty_sha256=sha(lib),
           frozen_files={str(f.relative_to(out)):sha(f) for f in out.rglob('*') if f.is_file()})
    save(out/'protocol.json',p);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    save(out/'AUTHORIZATION.json',dict(status='PENDING',protocol_sha256=sha(out/'protocol.json'),endpoint=p['endpoint'],model=p['model'],maximum_requests=20,user_instruction=None))
    print('Prepared20 CRC requests;0 model calls. '+str(out),flush=True)


def validate(out,consent=False):
    p=load(out/'protocol.json');require(sha(out/'protocol.json')==(out/'protocol.sha256').read_text().strip(),'Protocol changed')
    for rel,h in p['frozen_files'].items():require(sha(out/rel)==h,'Frozen input changed: '+rel)
    for kind in ('dependencies','reference_locks'):
        for rel,h in p[kind].items():require(sha(ROOT/rel)==h,kind+' changed: '+rel)
    require(Counter(s['arm'] for s in p['schedule'])==Counter(no_sta=10,sta=10) and len(p['schedule'])==p['maximum_requests']==20,'Unbalanced schedule')
    require([s['index'] for s in p['schedule']]==list(range(1,21)) and Counter((s['trial'],s['arm']) for s in p['schedule'])==Counter({(i,a):1 for i in range(1,11) for a in ('no_sta','sta')}),'Schedule identity mismatch')
    curl=shutil.which('curl.exe' if os.name=='nt' else 'curl')
    require(curl and Path(curl).resolve()==Path(p['curl_path']).resolve() and sha(Path(curl))==p['curl_sha256'],'curl changed')
    require(sha(Path(p['yosys_path']))==p['yosys_sha256'],'Yosys changed')
    require(sha(ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')==p['liberty_sha256'],'Library changed')
    if consent:
        a=load(out/'AUTHORIZATION.json');require(a.get('status')=='EXPLICITLY_APPROVED' and a.get('user_instruction'),'New explicit CRC disclosure/20-call approval required')
        require(a.get('protocol_sha256')==sha(out/'protocol.json'),'Approval checksum mismatch')
        for k in ('endpoint','model','maximum_requests'):require(a.get(k)==p[k],'Approval mismatch: '+k)
    return p


def collect(out):
    p=validate(out,True);require(not (out/'HALTED.json').exists(),'Batch halted; no automatic restart')
    key=os.environ.get('OPENAI_API_KEY','').strip();require(key,'Configured key missing')
    folder=out/'trials';folder.mkdir(exist_ok=True);records=[];streak=0
    for slot in p['schedule']:
        d=folder/f'call_{slot["index"]:02d}'
        if d.exists():
            require((d/'generation.json').exists(),'Unknown attempted request; never resend')
            r=load(d/'generation.json')
        else:
            d.mkdir();save(d/'attempt.json',{**slot,'attempted':True,'timestamp':datetime.now(timezone.utc).isoformat()})
            body=dict(model=p['model'],reasoning_effort=p['reasoning_effort'],response_format={'type':'json_object'},stream=True,stream_options={'include_usage':True},max_completion_tokens=p['max_completion_tokens'],
                      messages=[dict(role='system',content=p['system']),dict(role='user',content=(out/'prompts'/f'{slot["arm"]}.txt').read_text(encoding='utf-8'))])
            r={**slot,'status':'FAILED_GENERATION','failure_class':'TRANSPORT','usage':None}
            try:
                response=curl_completion_stream(endpoint=p['endpoint'],body=body,api_key=key,audit_dir=d/'api_audit',timeout_s=p['timeout_seconds'])
                r.update(failure_class='FORMAT',usage=response.get('usage'));parsed=parse_candidate(response['choices'][0]['message']['content'])
                (d/'candidate.v').write_text(parsed['rtl'],encoding='utf-8');r.update(status='GENERATED',failure_class=None,rtl_sha256=sha(d/'candidate.v'),normalizations=parsed['format_normalizations'])
            except Exception as e:r['error_type']=type(e).__name__
            save(d/'generation.json',r);print(f'CRC call{slot["index"]}/20 {slot["arm"]}: {r["status"]}',flush=True)
        records.append(r);streak=streak+1 if r['failure_class']=='TRANSPORT' else 0
        if streak>=3:
            save(out/'HALTED.json',dict(reason='Three consecutive transport/incomplete-stream failures',attempted=len(records),remaining=20-len(records)));break
    if not (out/'GENERATION_SUMMARY.json').exists():save(out/'GENERATION_SUMMARY.json',dict(attempted=len(records),remaining=20-len(records),complete=len(records)==20,records=records))


def score(out):
    p=validate(out);g=load(out/'GENERATION_SUMMARY.json');rows=[];cache={};(out/'evaluations').mkdir(exist_ok=True)
    for record in g['records']:
        row=dict(record);m={}
        if record['status']=='GENERATED':
            key=record['rtl_sha256'];dest=out/'evaluations'/key
            if key not in cache:cache[key]=load(dest/'result.json') if (dest/'result.json').exists() else evaluate(out/'trials'/f'call_{record["index"]:02d}'/'candidate.v',dest)
            m=cache[key];row.update(metrics=m,evaluation=str(dest.relative_to(out)))
        row.update(select(m,p['baseline']));rows.append(row)
    groups=[]
    for arm in ('no_sta','sta'):
        items=[r for r in rows if r['arm']==arm]
        groups.append(dict(arm=arm,scheduled=10,attempted=len(items),generated=sum(r['status']=='GENERATED' for r in items),
             improvements=sum(r['improved'] for r in items),median_retained_delay_ns=statistics.median(r['retained_delay_ns'] for r in items) if g['complete'] else None,
             unique_mapped_netlists=len({r['metrics']['mapped_sha256'] for r in items if r.get('metrics',{}).get('mapped_sha256')})))
    save(out/'RESULT.json',dict(complete=g['complete'],attempted=g['attempted'],groups=groups,trials=rows,scope=p['scope']))


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('mode',choices=('prepare','check','collect','score'));ap.add_argument('out',type=Path);a=ap.parse_args();out=a.out.resolve()
    if a.mode=='prepare':prepare(out)
    elif a.mode=='check':validate(out);print('CRC protocol and20-slot balance PASS;0 API calls')
    elif a.mode=='collect':collect(out)
    else:score(out)
