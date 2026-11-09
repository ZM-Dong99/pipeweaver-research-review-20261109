"""Frozen streaming RTL comparison. Local preparation is free; execution needs explicit authorization."""
import argparse
from collections import Counter
from datetime import datetime
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import statistics
import subprocess
import sys
import time
from urllib.parse import urlsplit
import urllib.request

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.rtl_optimizer import _curl_json, _parse_content, LLMGenerationError, request_parameters_for_model

EVALUATOR=Path(__file__).with_name('run_native_stream.py')
DESIGN=ROOT/'eda/experiments/stream_feedback_preparation_20261106'
ARMS=('no_sta','sta')
SYSTEM='Optimize one native streaming RTL conservatively under the exact reset-only interface contract. Return one requested JSON object. Never provide commands or external dependencies.'
DEPS=[Path(__file__).resolve(),EVALUATOR,EVALUATOR.with_name('run_native_seq_initialized.py'),EVALUATOR.with_name('validate_stream_reset_contract.py'),EVALUATOR.with_name('run_native_comb.py'),EVALUATOR.with_name('trace_sta_rtl_cone.py'),ROOT/'agents/rtl_optimizer.py']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def save(path,obj):path.write_text(json.dumps(obj,ensure_ascii=False,indent=2,allow_nan=False),encoding='utf-8')


def exclusive(path,obj):
    with path.open('x',encoding='utf-8') as f:json.dump(obj,f,ensure_ascii=False,indent=2,allow_nan=False)


def require(ok,reason):
    if not ok:raise RuntimeError(reason)


def parse_candidate(content):
    if not isinstance(content,str):raise LLMGenerationError('Visible content must be text')
    text=content.strip();normalized=[]
    if text.startswith('<think>'):
        end=text.find('</think>')
        if end<0:raise LLMGenerationError('Incomplete leading wrapper')
        text=text[end+8:].strip();normalized.append('Discarded one complete leading think wrapper')
    fence=re.fullmatch(r'```json\s*\n(.*?)\n```',text,re.S|re.I)
    if fence:text=fence[1];normalized.append('Removed one complete JSON fence')
    def unique(pairs):
        d={}
        for k,v in pairs:
            if k in d:raise LLMGenerationError('Duplicate JSON keys')
            d[k]=v
        return d
    def invalid_constant(value):raise LLMGenerationError('Nonfinite JSON values are forbidden')
    try:obj=json.loads(text,object_pairs_hook=unique,parse_constant=invalid_constant)
    except (TypeError,ValueError) as e:raise LLMGenerationError('Exactly one JSON object required') from e
    fields={'candidate_rtl','bottleneck','rewrite','expected_timing_gain','area_or_other_cost','functional_boundaries'}
    if type(obj) is not dict or set(obj)!=fields:raise LLMGenerationError('Exactly the six requested candidate fields required')
    rtl,explanation=_parse_content(json.dumps(obj,ensure_ascii=False))
    return dict(rtl=rtl,explanation=explanation,format_normalizations=normalized)


def eligible(m):
    return (m.get('status')=='PASS' and m.get('formal')==m.get('mapped_formal')==m.get('ppa')=='PASS'
            and m.get('electrical',{}).get('status')=='PASS' and m.get('no_declared_initial_values_relied_on') is True
            and all(type(m.get(k)) in (int,float) and math.isfinite(m[k]) for k in ('wns_ns','tns_ns','mapped_area_um2'))
            and m['mapped_area_um2']>0)


def choose(m,base):
    accepted=(eligible(m) and m['mapped_area_um2']<=1.10*base['mapped_area_um2']+1e-9
              and m['tns_ns']>=base['tns_ns'] and m['wns_ns']>base['wns_ns'])
    return dict(improved=bool(accepted),selected='candidate' if accepted else 'baseline',
                retained_wns_ns=m['wns_ns'] if accepted else base['wns_ns'],
                retained_area_um2=m['mapped_area_um2'] if accepted else base['mapped_area_um2'])


def evaluate(candidate,reference,case,out):
    require(not out.exists(),'Refusing to overwrite prior EDA')
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    cmd=[sys.executable,'-B',str(EVALUATOR),str(candidate),'--reference',str(reference),'--top',case['top'],'--clock','clk','--reset','rst',
         '--initial-state-policy','reset-only','--stream-contract',case['id'],'--prove-state-invariants','--unmap-clock-enables','--out',str(out)]
    for k,v in case['params'].items():cmd+=['--param',f'{k}={v}']
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900);raw=p.stdout
    except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+b'\nOVERALL TIMEOUT'
    out.parent.mkdir(parents=True,exist_ok=True);(out.parent/(out.name+'_runner.log')).write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',reason='No evaluator result; inspect runner log')


def prepare(out,model,endpoint):
    d=load(DESIGN/'protocol.json')
    require(sha(DESIGN/'protocol.json')==(DESIGN/'protocol.sha256').read_text().strip(),'Design protocol changed')
    for rel,h in d['frozen_files'].items():require(sha(DESIGN/rel)==h,'Design input changed')
    u=urlsplit(endpoint);require(bool(model) and u.scheme=='https' and u.hostname and not(u.username or u.password or u.query or u.fragment),'Exact model and HTTPS endpoint required')
    curl=shutil.which('curl.exe' if os.name=='nt' else 'curl');require(bool(curl),'curl required')
    out.mkdir(parents=True,exist_ok=False)
    for sub in ('inputs','prompts','code_snapshot'):(out/sub).mkdir()
    for f in DEPS:shutil.copyfile(f,out/'code_snapshot'/f.name)
    cases=[]
    for c in d['cases']:
        case={k:c[k] for k in ('id','top','source','params')};cases.append(case)
        shutil.copyfile(DESIGN/'inputs'/case['source'],out/'inputs'/case['source'])
        base=evaluate(out/'inputs'/case['source'],out/'inputs'/case['source'],case,out/'baselines'/case['id'])
        require(eligible(base),'Fresh baseline failed; no API calls')
        case['baseline']=base
        common=(DESIGN/'prompts'/(case['id']+'_no_sta.txt')).read_text(encoding='utf-8')
        # Re-freeze the same contract with measured no-init-mapping baseline values.
        common,n=re.subn(r'Baseline area [0-9.]+um\^2; area cap [0-9.]+um\^2\.',
            f"Baseline area {base['mapped_area_um2']:.6f}um^2; area cap {base['mapped_area_um2']*1.10:.6f}um^2.",common)
        require(n==1,'Could not refresh baseline area')
        common=common.replace('synth -noabc; dffunmap','proc/flatten/remove init; synth -noabc; dffunmap')
        sta=(out/'baselines'/case['id']/'sta.log').read_text(encoding='utf-8');chunks=sta.split('Startpoint:')[1:]
        require(bool(chunks),'Missing baseline paths')
        report=''.join('Startpoint:'+c for c in chunks[:3]).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]
        guided=common+'\nActual freshly reproduced baseline STA:\n'+json.dumps({k:base[k] for k in ('wns_ns','tns_ns')})+'\n'+report+'\nMapped names are not exact RTL attribution.\n'
        for arm,text in (('no_sta',common),('sta',guided)):(out/'prompts'/(case['id']+'_'+arm+'.txt')).write_text(text,encoding='utf-8')
        print('Fresh baseline '+case['id']+': '+str(base['wns_ns'])+'ns WNS',flush=True)
    p=dict(created_at=datetime.now().astimezone().isoformat(),status='PREPARED_PENDING_EXPLICIT_APPROVAL',model=model,endpoint=endpoint.rstrip('/'),
        maximum_requests=12,timeout_seconds=180,request_parameters=request_parameters_for_model(model),system_message=SYSTEM,cases=cases,schedule=d['schedule'],
        original_design_sha256=sha(DESIGN/'protocol.json'),old_baseline_refresh='Mapping removes init before synthesis; old8.83/8.71ns values are not silently reused',
        generation_policy='Freeze all12 generations before candidate EDA. No retries, repairs or replacement. Unknown attempted request blocks resume.',
        scoring='Three-attempt baseline-retained median WNS per case/arm is primary; all failures count. Report strict improvement counts, candidate area/TNS and unique netlist hashes. No switch to best draw.',
        candidate_eda='Identical case+RTL SHA reused once across repeated model slots, disclosed as shared PPA not independent RTL samples.',
        budget='No fixed token/currency cap;12 attempt ceiling and180s per request. Provider usage reported for all responses, including parse failures.',
        limitations='Two related streaming functions from one exposed public repository, fixed parameters, pre-layout. Candidate proof can be INCOMPLETE; state renaming falls back to output-only proof. No generic AXI compliance, FIFO, retiming or statistical superiority claim.',
        frozen_files={str(f.relative_to(out)):sha(f) for f in out.rglob('*') if f.is_file()},dependencies={str(f.relative_to(ROOT)):sha(f) for f in DEPS},
        reference_sources={str((ROOT/'benchmark/engineering_sources_20261106'/c['source']).relative_to(ROOT)):sha(out/'inputs'/c['source']) for c in cases},
        curl_path=str(Path(curl).resolve()),curl_sha256=sha(Path(curl)))
    exclusive(out/'protocol.json',p);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    exclusive(out/'AUTHORIZATION.json',dict(status='PENDING',protocol_sha256=sha(out/'protocol.json'),endpoint=p['endpoint'],maximum_requests=12,
        reason='Previous localization12-call budget exhausted; new destination/data/budget approval required before calls'))
    return p


def validate(out):
    p=load(out/'protocol.json');require(sha(out/'protocol.json')==(out/'protocol.sha256').read_text().strip(),'Protocol changed')
    for rel,h in p['frozen_files'].items():require(sha(out/rel)==h,'Frozen artifact changed: '+rel)
    for rel,h in p['dependencies'].items():require(sha(ROOT/rel)==h,'Live execution code changed: '+rel)
    for rel,h in p['reference_sources'].items():require(sha(ROOT/rel)==h,'Pinned reference changed: '+rel)
    require(sha(Path(p['curl_path']))==p['curl_sha256'],'curl changed')
    require(p['maximum_requests']==12 and len(p['schedule'])==12,'Invalid ceiling')
    require(Counter((s['case'],s['arm']) for s in p['schedule'])==Counter({(c['id'],a):3 for c in p['cases'] for a in ARMS}),'Invalid schedule cells')
    require([s['call_index'] for s in p['schedule']]==list(range(1,13)),'Invalid call identity')
    for c in p['cases']:
        no=(out/'prompts'/(c['id']+'_no_sta.txt')).read_text(encoding='utf-8');sta=(out/'prompts'/(c['id']+'_sta.txt')).read_text(encoding='utf-8')
        require(sta.startswith(no) and len(sta)>len(no),'Prompt prefix mismatch')
    return p


def authorized(out,p):
    a=load(out/'AUTHORIZATION.json')
    require(a.get('status')=='EXPLICITLY_APPROVED' and a.get('endpoint')==p['endpoint'] and a.get('maximum_requests')==12
        and a.get('protocol_sha256')==sha(out/'protocol.json'),'New batch lacks explicit endpoint/data/12-request authorization')
    require(bool(os.environ.get('OPENAI_API_KEY','').strip()),'API credential missing')
    require(os.environ.get('OPENAI_BASE_URL','').rstrip('/')==p['endpoint'],'Endpoint changed')


def request_once(prompt,p,folder):
    folder.mkdir(exist_ok=False)
    payload=dict(model=p['model'],**p['request_parameters'],response_format={'type':'json_object'},
        messages=[dict(role='system',content=p['system_message']),dict(role='user',content=prompt)])
    exclusive(folder/'request.json',dict(endpoint=p['endpoint']+'/chat/completions',body=payload,credentials='Authorization header omitted'))
    req=urllib.request.Request(p['endpoint']+'/chat/completions',data=json.dumps(payload).encode('utf-8'),
        headers={'Authorization':'Bearer '+os.environ['OPENAI_API_KEY'],'Content-Type':'application/json'},method='POST')
    try:body=_curl_json(req,p['timeout_seconds'],audit_dir=folder)
    except (OSError,TimeoutError,ValueError) as e:raise LLMGenerationError('Transport failed: '+type(e).__name__) from None
    if not isinstance(body,dict):raise LLMGenerationError('Invalid provider envelope')
    visible={k:body[k] for k in ('id','created','model','usage','system_fingerprint') if k in body}
    choices=body.get('choices');visible['choices']=[dict(index=c.get('index'),finish_reason=c.get('finish_reason'),message={k:c.get('message',{}).get(k) for k in ('role','content')}) for c in choices if isinstance(c,dict)] if isinstance(choices,list) else []
    exclusive(folder/'response.json',visible)
    try:content=body['choices'][0]['message']['content']
    except (KeyError,IndexError,TypeError):raise LLMGenerationError('Missing visible response') from None
    return dict(**parse_candidate(content),provider_metadata={k:visible[k] for k in ('id','model','usage','created') if k in visible})


def collect(out,p,sender=request_once,validator=validate):
    rows=[]
    for slot in p['schedule']:
        validator(out);folder=out/'trials'/f"call_{slot['call_index']:02d}";folder.mkdir(parents=True,exist_ok=True)
        result=folder/'generation.json'
        if result.exists():
            row=load(result);require(row['slot']==slot,'Resume identity mismatch')
            if row.get('candidate_sha256'):require(sha(folder/'candidate.v')==row['candidate_sha256'],'Candidate changed')
            rows.append(row);continue
        require(not (folder/'attempt.json').exists(),'Unknown prior attempt; refusing to resend')
        require(not (out/'candidate_manifest.json').exists(),'Frozen manifest missing generation')
        prompt=out/slot['prompt'];exclusive(folder/'attempt.json',dict(slot=slot,prompt_sha256=sha(prompt),protocol_sha256=sha(out/'protocol.json')))
        row=dict(slot=slot,status='FAILED_GENERATION',candidate_sha256=None);started=time.monotonic()
        print(f"Calling {slot['call_index']}/12 {slot['case']} {slot['arm']}",flush=True)
        try:
            generated=sender(prompt.read_text(encoding='utf-8'),p,folder/'api_audit')
            (folder/'candidate.v').write_text(generated['rtl'],encoding='utf-8')
            row.update(status='GENERATED',candidate_sha256=sha(folder/'candidate.v'),explanation=generated['explanation'],
                format_normalizations=generated.get('format_normalizations',[]),provider_metadata=generated.get('provider_metadata',{}))
        except LLMGenerationError as e:row['error']=str(e)
        row['generation_seconds']=round(time.monotonic()-started,6);exclusive(result,row);rows.append(row)
    document=dict(protocol_sha256=sha(out/'protocol.json'),rows=rows);mp=out/'candidate_manifest.json'
    if not mp.exists():exclusive(mp,document);(out/'candidate_manifest.sha256').write_text(sha(mp)+'\n',encoding='ascii')
    require(load(mp)==document and sha(mp)==(out/'candidate_manifest.sha256').read_text().strip(),'Manifest changed')
    return rows


def evaluate_rows(out,p,rows,evaluator=evaluate,validator=validate):
    require(load(out/'candidate_manifest.json')['rows']==rows,'All generation must be frozen first')
    require([r['slot'] for r in rows]==p['schedule'],'Candidate identities differ from schedule')
    cases={c['id']:c for c in p['cases']};results=[];cache={}
    for row in rows:
        validator(out);case=cases[row['slot']['case']];base=case['baseline'];m={}
        if row['status']=='GENERATED':
            source=out/'trials'/f"call_{row['slot']['call_index']:02d}"/'candidate.v'
            require(sha(source)==row['candidate_sha256'],'Candidate changed before EDA')
            key=(case['id'],row['candidate_sha256'])
            if key not in cache:
                folder=out/'evaluations'/case['id']/row['candidate_sha256']
                if folder.exists():
                    require((folder/'result.json').exists(),'Incomplete EDA: refusing overwrite')
                    m=load(folder/'result.json')
                else:m=evaluator(source,out/'inputs'/case['source'],case,folder)
                cache[key]=m
            m=cache[key]
        results.append(dict(**row,metrics=m,decision=choose(m,base)))
    groups={}
    for c in p['cases']:
        groups[c['id']]={}
        for arm in ARMS:
            rr=[r for r in results if r['slot']['case']==c['id'] and r['slot']['arm']==arm]
            require(len(rr)==3,'Missing slots')
            groups[c['id']][arm]=dict(attempted=3,generated=sum(r['status']=='GENERATED' for r in rr),
                strict_improvements=sum(r['decision']['improved'] for r in rr),median_retained_wns_ns=statistics.median(r['decision']['retained_wns_ns'] for r in rr),
                unique_measured_netlists=len({r['metrics'].get('mapped_sha256') for r in rr if eligible(r['metrics'])}))
    result=dict(groups=groups,rows=results,unique_candidate_eda=len(cache),baseline_fallback=True,scope=p.get('limitations','Offline acceptance'))
    save(out/'summary.json',result);return result


def execute(out):
    p=validate(out);authorized(out,p)
    os.environ['PATH']=str(Path(p['curl_path']).parent)+os.pathsep+os.environ.get('PATH','')
    rows=collect(out,p);result=evaluate_rows(out,p,rows)
    print(json.dumps(result['groups'],ensure_ascii=False),flush=True)


def main():
    ap=argparse.ArgumentParser(description=__doc__);g=ap.add_mutually_exclusive_group(required=True)
    g.add_argument('--prepare',action='store_true');g.add_argument('--execute',type=Path);g.add_argument('--validate',type=Path)
    ap.add_argument('--out',type=Path);ap.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'));ap.add_argument('--endpoint',default=os.environ.get('OPENAI_BASE_URL',''))
    a=ap.parse_args()
    if a.prepare:require(a.out is not None,'--out required');prepare(a.out.resolve(),a.model,a.endpoint);validate(a.out.resolve());print('Prepared; authorization pending; API requests0',flush=True)
    elif a.validate:validate(a.validate.resolve());print('Frozen stream batch: PASS')
    else:execute(a.execute.resolve())


if __name__=='__main__':main()
