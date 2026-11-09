"""Four exposed combinational designs, 10 requests/arm/design, 80 total.

prepare is local only. collect requires new exact consent; no automatic retries.
"""
import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
import math
import os
from pathlib import Path
import random
import shutil
import statistics
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.sse_transport import curl_completion_stream
from eda.experiments.run_stream_feedback import parse_candidate, DEPS as STREAM_DEPS

EVALUATOR = ROOT/'eda/experiments/run_native_comb.py'
LIBERTY = ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
SYSTEM = 'Conservatively optimize combinational RTL. Preserve all defined input/output behavior. Return exactly the requested JSON object.'
CASES = [
    dict(id='priority256', top='priority_encoder', params={'WIDTH':256,'LSB_HIGH_PRIORITY':0},
         source='eda/experiments/timing_feedback_ablation_priority256_20261102_193927_399076/baseline/original.v',
         control='eda/experiments/priority256_replication_20261102/pareto_exports/priority_encoder_choice_01.v'),
    dict(id='mux10x8', top='mux_large', params={},
         source='eda/experiments/mux_feedback_study_20261104_155643_522144/inputs/original.v',
         control='eda/experiments/mux_feedback_study_20261104_155643_522144/exports/sta.v'),
    dict(id='alu64', top='alu_64bit', params={},
         source='eda/experiments/timing_feedback_ablation_alu64_20261030_213005_200350/baseline/original.v',
         control='eda/experiments/timing_feedback_ablation_alu64_20261030_213005_200350/no_timing_feedback/candidate_02/candidate.v'),
    dict(id='addr128', top='addr_calcu', params={'base':128},
         source='eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837/baseline/original.v',
         control='eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837/uniform_cleanup_reevaluation/best_verified_rtl/addr_calcu.v')]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def save(path, obj):
    with path.open('x',encoding='utf-8') as f:
        json.dump(obj,f,ensure_ascii=False,indent=2,allow_nan=False)


def require(ok, reason):
    if not ok:
        raise RuntimeError(reason)


def eligible(r):
    return (r.get('status') == 'PASS' and r.get('formal') == r.get('mapped_formal') == r.get('ppa') == 'PASS'
            and r.get('electrical',{}).get('status') == 'PASS'
            and all(type(r.get(k)) in (int,float) and math.isfinite(r[k]) for k in
                    ('max_data_arrival_ns','mapped_area_um2','tns_ns')) and r['mapped_area_um2'] > 0)


def select(r, b):
    accepted = (eligible(r) and r['mapped_area_um2'] <= b['mapped_area_um2']*1.10 + 1e-9
                and r['tns_ns'] >= b['tns_ns'] and r['max_data_arrival_ns'] < b['max_data_arrival_ns'])
    return dict(improved=bool(accepted),retained_delay_ns=r['max_data_arrival_ns'] if accepted else b['max_data_arrival_ns'])


def evaluate(candidate, reference, case, out):
    require(not out.exists(),'Existing EDA directory must not be overwritten')
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(k,None)
    command=[sys.executable,'-B',str(EVALUATOR),str(candidate),'--reference',str(reference),
             '--top',case['top'],'--mapping-policy','buffer_size','--cleanup-before-buffer',
             '--timeout','120','--out',str(out)]
    for k,v in case['params'].items():
        command += ['--param',f'{k}={v}']
    out.parent.mkdir(parents=True,exist_ok=True)
    try:
        p=subprocess.run(command,cwd=ROOT,env=env,capture_output=True,timeout=900)
        raw=p.stdout+p.stderr
    except subprocess.TimeoutExpired as e:
        raw=(e.stdout or b'')+(e.stderr or b'')+b'\nOVERALL_TIMEOUT'
    (out.parent/(out.name+'_runner.log')).write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',reason='No evaluator result')


def schedule():
    rng=random.Random(20261107); rows=[]
    for trial in range(1,11):
        cases=[c['id'] for c in CASES];rng.shuffle(cases)
        for case in cases:
            arms=['no_sta','sta'];rng.shuffle(arms)
            for arm in arms:
                rows.append(dict(index=len(rows)+1,case=case,arm=arm,trial=trial))
    return rows


def prepare(out):
    out.mkdir(parents=True,exist_ok=False)
    for name in ('inputs','controls','prompts','code_snapshot'):
        (out/name).mkdir()
    cases=[]
    for original in CASES:
        c=dict(original)
        reference=out/'inputs'/(c['id']+'.v')
        control=out/'controls'/(c['id']+'.v')
        shutil.copyfile(ROOT/c['source'],reference);shutil.copyfile(ROOT/c['control'],control)
        c['baseline']=evaluate(reference,reference,c,out/'baselines'/c['id'])
        require(eligible(c['baseline']),'Unqualified fresh baseline '+c['id'])
        c['historical_control_result']=evaluate(control,reference,c,out/'control_evaluations'/c['id'])
        require(eligible(c['historical_control_result']),'Historical control failed validation '+c['id'])
        common=(f'Optimize this fixed combinational instance: module {c["top"]}, parameters {json.dumps(c["params"],sort_keys=True)}. '
            'Minimize mapped maximum data arrival. Give one complete synthesizable Verilog-2001 design. '
            'Keep module, parameters, ports, widths, signedness, truncations, priority and default-case behavior. '
            'All inputs are unconstrained, all outputs must match for every two-state input. No clocks, storage, latency, '
            'assumptions, external includes, or new dependencies. Helper modules are allowed.\n'
            'Common evaluation: SKY130HD TT25C1.80V; zero external IO delays; input transition0.10ns; output load0.010pF; '
            '100ns virtual reporting clock; no physical wire parasitics. Yosys flatten/synth-noabc; '
            'ABC strash/dretime/map/cleanup-i-o/buffer/upsize/dnsize/stime-p with fixed driver and load. '
            'Full source and mapped equivalence and zero electrical violations required.\n'
            f'Baseline mapped area {c["baseline"]["mapped_area_um2"]:.6f}um^2; fixed cap {c["baseline"]["mapped_area_um2"]*1.10:.6f}um^2. '
            'No candidate results are supplied.\n'
            'Return exactly one JSON object with these six fields: candidate_rtl, bottleneck, rewrite, '
            'expected_timing_gain, area_or_other_cost, functional_boundaries.\nOriginal RTL:\n'+reference.read_text(encoding='utf-8'))
        sta=(out/'baselines'/c['id']/'sta.log').read_text(encoding='utf-8')
        paths=sta.split('Startpoint:')[1:4]
        require(paths,'Missing baseline STA paths')
        appendix=''.join('Startpoint:'+s for s in paths).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]
        appendix='\nActual baseline STA (mapped names are not exact source attribution):\n'+json.dumps({k:c['baseline'][k] for k in ('max_data_arrival_ns','wns_ns','tns_ns')})+'\n'+appendix
        for arm,text in (('no_sta',common),('sta',common+appendix)):
            (out/'prompts'/f'{c["id"]}_{arm}.txt').write_text(text,encoding='utf-8')
        cases.append(c)
        print('Fresh baseline/control ready: '+c['id'],flush=True)
    deps=list(dict.fromkeys([Path(__file__).resolve(),ROOT/'agents/sse_transport.py',*STREAM_DEPS]))
    for f in deps:
        shutil.copyfile(f,out/'code_snapshot'/f.name)
    curl=shutil.which('curl.exe' if os.name=='nt' else 'curl');require(curl,'curl missing')
    yosys=Path(os.environ.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    p=dict(status='PREPARED_PENDING_EXPLICIT_DISCLOSURE_APPROVAL',created_at=datetime.now(timezone.utc).isoformat(),
           endpoint='https://apinebula.ai/v1/chat/completions',model='gpt-6.1-sol',maximum_requests=80,
           timeout_seconds=600,max_completion_tokens=16000,reasoning_effort='medium',
           automatic_retries=0,stream=True,include_usage=True,stop_after_consecutive_transport_failures=3,
           cases=cases,schedule=schedule(),system=SYSTEM,
           purpose='Larger within-design replication on four already exposed positive development cases; not held-out generalization',
           primary='Per-design baseline-retained median arrival over all10 scheduled slots per arm, only after all80 attempts complete',
           secondary='Area-qualified strict improvements, >=5pct gains, reported tokens, failures and unique mapped netlists',
           incomplete_batch='Report attempted and unattempted separately; no full-cohort method conclusion',
           controls='Original and historically selected optimized RTL; exposed post-hoc development references, not independent search competitors',
           isolation='Prompts fixed; all generations frozen before candidate EDA; no repairs, replacement or adaptive feedback',
           cost='At most80 requests and requested1,280,000 completion tokens; provider support/enforcement unverified, not a currency cap. Input tokens and failed-request charges additional/unknown.',
           disclosure='Four public original RTL modules, fixed functional/parameter/mapping constraints and baseline STA; no historical optimized controls or candidate PPA in prompts',
           dependencies={str(f.relative_to(ROOT)):sha(f) for f in deps},liberty_sha256=sha(LIBERTY),
           curl_path=curl,curl_sha256=sha(Path(curl)),yosys_path=str(yosys.resolve()),yosys_sha256=sha(yosys),
           frozen_files={str(f.relative_to(out)):sha(f) for f in out.rglob('*') if f.is_file()})
    save(out/'protocol.json',p);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    save(out/'AUTHORIZATION.json',dict(status='PENDING',protocol_sha256=sha(out/'protocol.json'),endpoint=p['endpoint'],model=p['model'],maximum_requests=80,user_instruction=None,
         note='User selected80-call budget; exact disclosure and600s policy not yet approved. Previous2-call approval is not reused.'))
    print('Prepared80 slots; no model requests. '+str(out),flush=True)


def validate(out, consent=False):
    p=load(out/'protocol.json')
    require(sha(out/'protocol.json')==(out/'protocol.sha256').read_text().strip(),'Protocol changed')
    for rel,h in p['frozen_files'].items():require(sha(out/rel)==h,'Frozen artifact changed: '+rel)
    for rel,h in p['dependencies'].items():require(sha(ROOT/rel)==h,'Dependency changed: '+rel)
    for path,h in ((LIBERTY,p['liberty_sha256']),(Path(p['yosys_path']),p['yosys_sha256']),(Path(p['curl_path']),p['curl_sha256'])):
        require(sha(path)==h,'Tool/library changed')
    require(Path(shutil.which('curl.exe' if os.name=='nt' else 'curl')).resolve()==Path(p['curl_path']).resolve(),'curl selection changed')
    require(len(p['schedule'])==p['maximum_requests']==80,'Invalid schedule')
    require(Counter((s['case'],s['arm']) for s in p['schedule'])==Counter({(c['id'],a):10 for c in p['cases'] for a in ('no_sta','sta')}),'Unbalanced schedule')
    if consent:
        a=load(out/'AUTHORIZATION.json')
        require(a.get('status')=='EXPLICITLY_APPROVED' and bool(a.get('user_instruction')),'Exact new disclosure approval required')
        require(a.get('protocol_sha256')==sha(out/'protocol.json'),'Approval hash mismatch')
        for k in ('endpoint','model','maximum_requests'):require(a.get(k)==p[k],'Approval mismatch: '+k)
    return p


def collect(out):
    p=validate(out,consent=True)
    require(not (out/'HALTED.json').exists(),'Batch halted by transport stop policy; no automatic restart')
    key=os.environ.get('OPENAI_API_KEY','').strip();require(key,'Configured key missing')
    slots=out/'trials';slots.mkdir(exist_ok=True)
    records=[];consecutive=0
    for slot in p['schedule']:
        d=slots/f'call_{slot["index"]:03d}'
        if d.exists():
            require((d/'generation.json').exists(),'Unknown attempted request blocks continuation; never resend')
            r=load(d/'generation.json')
        else:
            d.mkdir();save(d/'attempt.json',{**slot,'timestamp':datetime.now(timezone.utc).isoformat(),'attempted':True})
            body=dict(model=p['model'],reasoning_effort=p['reasoning_effort'],response_format={'type':'json_object'},
                      stream=True,stream_options={'include_usage':True},max_completion_tokens=p['max_completion_tokens'],
                      messages=[dict(role='system',content=p['system']),dict(role='user',content=(out/'prompts'/f'{slot["case"]}_{slot["arm"]}.txt').read_text(encoding='utf-8'))])
            r={**slot,'status':'FAILED_GENERATION','failure_class':'TRANSPORT','usage':None}
            try:
                response=curl_completion_stream(endpoint=p['endpoint'],body=body,api_key=key,audit_dir=d/'api_audit',timeout_s=p['timeout_seconds'])
                r.update(failure_class='FORMAT',usage=response.get('usage'))
                parsed=parse_candidate(response['choices'][0]['message']['content'])
                (d/'candidate.v').write_text(parsed['rtl'],encoding='utf-8')
                r.update(status='GENERATED',failure_class=None,rtl_sha256=sha(d/'candidate.v'),normalizations=parsed['format_normalizations'])
            except Exception as exc:
                r['error_type']=type(exc).__name__
            save(d/'generation.json',r)
            print(f'Call{slot["index"]}/80 {slot["case"]} {slot["arm"]}: {r["status"]}',flush=True)
        records.append(r)
        consecutive=consecutive+1 if r['failure_class']=='TRANSPORT' else 0
        if consecutive>=p['stop_after_consecutive_transport_failures']:
            save(out/'HALTED.json',dict(reason='Three consecutive transport/incomplete-stream failures',attempted=len(records),remaining=80-len(records)))
            break
    if not (out/'GENERATION_SUMMARY.json').exists():
        save(out/'GENERATION_SUMMARY.json',dict(attempted=len(records),remaining=80-len(records),complete=len(records)==80,records=records))


def score(out):
    p=validate(out);g=load(out/'GENERATION_SUMMARY.json');rows=[];cache={}
    for r in g['records']:
        c=next(c for c in p['cases'] if c['id']==r['case']);row=dict(r)
        metrics={}
        if r['status']=='GENERATED':
            key=(r['case'],r['rtl_sha256']);evaluation=out/'evaluations'/f'{r["case"]}_{r["rtl_sha256"]}'
            if key not in cache:
                cache[key]=load(evaluation/'result.json') if (evaluation/'result.json').exists() else evaluate(out/'trials'/f'call_{r["index"]:03d}'/'candidate.v',out/'inputs'/f'{r["case"]}.v',c,evaluation)
            metrics=cache[key];row['evaluation']=str(evaluation.relative_to(out));row['metrics']=metrics
        row.update(select(metrics,c['baseline']));rows.append(row)
    groups=[]
    for c in p['cases']:
        for arm in ('no_sta','sta'):
            items=[r for r in rows if r['case']==c['id'] and r['arm']==arm]
            groups.append(dict(case=c['id'],arm=arm,scheduled=10,attempted=len(items),
                generated=sum(r['status']=='GENERATED' for r in items),improvements=sum(r['improved'] for r in items),
                median_retained_delay_ns=statistics.median(r['retained_delay_ns'] for r in items) if g['complete'] else None,
                unique_mapped_netlists=len({r['metrics']['mapped_sha256'] for r in items if r.get('metrics',{}).get('mapped_sha256')})))
    save(out/'RESULT.json',dict(complete=g['complete'],attempted=g['attempted'],groups=groups,trials=rows,
         shared_eda_for_exact_case_and_rtl=True,scope=p['purpose']))


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('mode',choices=('prepare','check','collect','score'));ap.add_argument('out',type=Path)
    a=ap.parse_args();out=a.out.resolve()
    if a.mode=='prepare':prepare(out)
    elif a.mode=='check':validate(out);print('Frozen inputs, dependencies and80-slot schedule PASS; no API request')
    elif a.mode=='collect':collect(out)
    else:score(out)
