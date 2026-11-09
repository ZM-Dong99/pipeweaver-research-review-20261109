"""Independent CRC20 request, provenance, budget and acceptance audit. No API."""
from collections import Counter
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from eda.experiments.run_stream_feedback import parse_candidate

load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()


def audit(out):
    checks=[]
    def check(name,ok):checks.append(dict(check=name,passed=bool(ok)))
    p,a,g,r=(load(out/n) for n in ('protocol.json','AUTHORIZATION.json','GENERATION_SUMMARY.json','RESULT.json'))
    check('New explicit CRC consent',a['status']=='EXPLICITLY_APPROVED' and bool(a.get('user_instruction')))
    check('Protocol checksum',sha(out/'protocol.json')==a['protocol_sha256']==(out/'protocol.sha256').read_text().strip())
    for k in ('endpoint','model','maximum_requests'):check('Consent '+k,p[k]==a[k])
    for rel,h in p['frozen_files'].items():check('Frozen '+rel,sha(out/rel)==h)
    for kind in ('dependencies','reference_locks'):
        for rel,h in p[kind].items():check(kind+' '+rel,sha(ROOT/rel)==h)
    check('20 independent balanced slots',len(p['schedule'])==20 and [s['index'] for s in p['schedule']]==list(range(1,21))
          and Counter((s['trial'],s['arm']) for s in p['schedule'])==Counter({(i,a):1 for i in range(1,11) for a in ('no_sta','sta')}))
    check('Actual attempts counted',len(list(out.glob('trials/call_*/attempt.json')))==g['attempted']==r['attempted']<=20)
    check('Complete flag',g['complete']==r['complete']==(r['attempted']==20))
    check('No reordered or duplicated results',[x['index'] for x in g['records']]==[x['index'] for x in r['trials']]==list(range(1,r['attempted']+1)))
    expected_reference=next(h for path,h in p['reference_locks'].items() if path.replace('\\','/')=='eda/experiments/crc_transfer_qualification_20261107/crc32_d8_slang_invocation_fixed/elaborated.v')
    observations=[];reported=0;tokens=0;streak=0;halt=None;b=p['baseline'];classifications=Counter()
    for row in r['trials']:
        i=row['index'];s=p['schedule'][i-1];d=out/'trials'/f'call_{i:02d}'
        attempt=load(d/'attempt.json');generation=load(d/'generation.json');request=load(d/'api_audit/request.json');transport=load(d/'api_audit/transport.json')
        check(f'Call{i} identity',all(obj.get(k)==s[k] for obj in (attempt,generation,row) for k in ('index','arm','trial')))
        expected=dict(model=p['model'],reasoning_effort=p['reasoning_effort'],response_format={'type':'json_object'},stream=True,
             stream_options={'include_usage':True},max_completion_tokens=p['max_completion_tokens'],
             messages=[dict(role='system',content=p['system']),dict(role='user',content=(out/'prompts'/f'{s["arm"]}.txt').read_text(encoding='utf-8'))])
        check(f'Call{i} exact request',request['endpoint']==p['endpoint'] and request['body']==expected)
        check(f'Call{i} no retry/temp cleanup',transport['retry_count']==0 and not list((d/'api_audit').glob('transfer_*')))
        if transport.get('complete'):
            response=load(d/'api_audit/response.json')
            check(f'Call{i} complete stream',transport['exit_code']==0 and 200<=transport['http_status']<300 and response['stream_audit']['complete'])
            check(f'Call{i} preserved usage',generation.get('usage')==response.get('usage'))
        if row['status']=='GENERATED':
            response=load(d/'api_audit/response.json');rtl=parse_candidate(response['choices'][0]['message']['content'])['rtl']
            check(f'Call{i} raw model RTL provenance',rtl==(d/'candidate.v').read_text(encoding='utf-8') and sha(d/'candidate.v')==row['rtl_sha256'])
            evaluation=out/row['evaluation'];metrics=load(evaluation/'result.json')
            check(f'Call{i} recorded actual evaluation',metrics==row['metrics'])
            check(f'Call{i} compiler input unchanged',sha(evaluation/'candidate.v')==row['rtl_sha256'])
            if metrics.get('formal')=='PASS':
                check(f'Call{i} full source chain',metrics['raw_candidate_sha256']==row['rtl_sha256'] and metrics['candidate_elaborated_sha256']==sha(evaluation/'candidate_elaborated.v')
                      and metrics['original_reference_sha256']==expected_reference)
        else:check(f'Call{i} failed generation no candidate',not (d/'candidate.v').exists())
        m=row.get('metrics',{})
        valid=(m.get('status')=='PASS' and m.get('formal')==m.get('mapped_formal')==m.get('ppa')=='PASS'
            and m.get('electrical',{}).get('status')=='PASS' and all(type(m.get(k)) in (int,float) and math.isfinite(m[k]) for k in ('max_data_arrival_ns','mapped_area_um2','tns_ns')))
        accepted=bool(valid and 0<m['mapped_area_um2']<=1.1*b['mapped_area_um2']+1e-9 and m['tns_ns']>=b['tns_ns'] and m['max_data_arrival_ns']<b['max_data_arrival_ns'])
        check(f'Call{i} independent qualification',row['improved']==accepted and row['retained_delay_ns']==(m['max_data_arrival_ns'] if accepted else b['max_data_arrival_ns']))
        if row['status']!='GENERATED':category='generation_'+str(row['failure_class']).lower()
        elif m.get('formal')!='PASS':category='source_validation_not_passed'
        elif m.get('mapped_formal')!='PASS':category='mapped_validation_not_passed'
        elif m.get('ppa')!='PASS':category='ppa_incomplete'
        elif m.get('electrical',{}).get('status')!='PASS':category='electrical_violation'
        elif m['mapped_area_um2']>b['mapped_area_um2']*1.1+1e-9:category='area_exceeds_cap'
        elif m['tns_ns']<b['tns_ns']:category='tns_regression'
        elif not accepted:category='no_strict_timing_gain'
        else:category='qualified_improvement'
        classifications[category]+=1
        total=(row.get('usage') or {}).get('total_tokens')
        if type(total) is int:tokens+=total;reported+=1
        streak=streak+1 if row['failure_class']=='TRANSPORT' else 0
        if streak>=3 and halt is None:halt=i
        observations.append(dict(index=i,arm=row['arm'],status=row['status'],category=category,improved=accepted,
            http_status=transport.get('http_status'),exit_code=transport.get('exit_code'),elapsed_seconds=transport.get('elapsed_seconds'),reported_total_tokens=total))
    check('First transport stop honored',halt is None or halt==g['attempted'])
    check('Stop marker consistent',(out/'HALTED.json').exists()==(halt is not None))
    for group in r['groups']:
        items=[t for t in r['trials'] if t['arm']==group['arm']]
        median=statistics.median(t['retained_delay_ns'] for t in items) if r['complete'] else None
        check('Group '+group['arm'],group['attempted']==len(items) and group['scheduled']==10 and group['improvements']==sum(t['improved'] for t in items) and group['median_retained_delay_ns']==median)
    result=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,attempted=r['attempted'],remaining=20-r['attempted'],complete=r['complete'],
        outcome_counts=dict(classifications),responses_reporting_usage=reported,reported_total_tokens=tokens,
        token_scope='Only complete provider responses reporting usage; failed or missing billing unknown',observations=observations)
    (out/'AUDIT.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k not in ('checks','observations')},indent=2))
    return result['passed']


if __name__=='__main__':sys.exit(0 if audit(Path(sys.argv[1]).resolve()) else 1)
