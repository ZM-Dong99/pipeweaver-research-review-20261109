"""Independent ledger/request/scoring audit; no API requests or source edits."""
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
    check('New exact consent',a['status']=='EXPLICITLY_APPROVED' and a.get('user_instruction'))
    check('Protocol digest',sha(out/'protocol.json')==(out/'protocol.sha256').read_text().strip()==a['protocol_sha256'])
    for k in ('endpoint','model','maximum_requests'):check('Approval '+k,a[k]==p[k])
    for rel,h in p['frozen_files'].items():check('Frozen '+rel,sha(out/rel)==h)
    for rel,h in p['dependencies'].items():check('Dependency '+rel,sha(ROOT/rel)==h)
    check('80 balanced slots',len(p['schedule'])==80 and Counter((s['case'],s['arm']) for s in p['schedule'])==Counter({(c['id'],a):10 for c in p['cases'] for a in ('no_sta','sta')}))
    attempts=sorted(out.glob('trials/call_*/attempt.json'))
    check('Counted attempts',len(attempts)==g['attempted']==r['attempted']<=80)
    check('Generation/evaluation identities',[x['index'] for x in g['records']]==[x['index'] for x in r['trials']]==list(range(1,g['attempted']+1)))
    check('Completion flag',g['complete']==r['complete']==(g['attempted']==80))
    observations=[];tokens=0;reported=0;streak=0;trigger=None
    for row in r['trials']:
        i=row['index'];slot=p['schedule'][i-1];d=out/'trials'/f'call_{i:03d}'
        record=load(d/'generation.json');attempt=load(d/'attempt.json');req=load(d/'api_audit/request.json');t=load(d/'api_audit/transport.json')
        check(f'Call{i} identity',all(obj.get(k)==slot[k] for obj in (row,record,attempt) for k in ('index','case','arm','trial')))
        expected=dict(model=p['model'],reasoning_effort=p['reasoning_effort'],response_format={'type':'json_object'},stream=True,
                      stream_options={'include_usage':True},max_completion_tokens=p['max_completion_tokens'],
                      messages=[dict(role='system',content=p['system']),dict(role='user',content=(out/'prompts'/f'{slot["case"]}_{slot["arm"]}.txt').read_text(encoding='utf-8'))])
        check(f'Call{i} exact request',req['endpoint']==p['endpoint'] and req['body']==expected)
        check(f'Call{i} no retry/temp cleanup',t['retry_count']==0 and not list((d/'api_audit').glob('transfer_*')))
        if t.get('complete'):
            response=load(d/'api_audit/response.json')
            check(f'Call{i} complete stream',t['exit_code']==0 and 200<=t['http_status']<300 and response['stream_audit']['complete'])
            check(f'Call{i} usage preserved',record.get('usage')==response.get('usage'))
        if row['status']=='GENERATED':
            text=load(d/'api_audit/response.json')['choices'][0]['message']['content']
            candidate=parse_candidate(text)['rtl']
            check(f'Call{i} candidate provenance',candidate==(d/'candidate.v').read_text(encoding='utf-8') and sha(d/'candidate.v')==row['rtl_sha256'])
            m=load(out/row['evaluation']/'result.json') if (out/row['evaluation']/'result.json').exists() else row['metrics']
            check(f'Call{i} evaluator record',m==row['metrics'])
        else:
            check(f'Call{i} failed generation not a candidate',not (d/'candidate.v').exists())
        base=next(c['baseline'] for c in p['cases'] if c['id']==slot['case'])
        m=row.get('metrics',{})
        valid=(m.get('status')=='PASS' and m.get('formal')==m.get('mapped_formal')==m.get('ppa')=='PASS'
               and m.get('electrical',{}).get('status')=='PASS'
               and all(type(m.get(k)) in (int,float) and math.isfinite(m[k]) for k in ('max_data_arrival_ns','mapped_area_um2','tns_ns')))
        accepted=bool(valid and 0<m['mapped_area_um2']<=base['mapped_area_um2']*1.1+1e-9 and m['tns_ns']>=base['tns_ns'] and m['max_data_arrival_ns']<base['max_data_arrival_ns'])
        delay=m['max_data_arrival_ns'] if accepted else base['max_data_arrival_ns']
        check(f'Call{i} independent acceptance',row['improved']==accepted and row['retained_delay_ns']==delay)
        u=row.get('usage');total=u.get('total_tokens') if isinstance(u,dict) else None
        if type(total) is int:tokens+=total;reported+=1
        streak=streak+1 if row['failure_class']=='TRANSPORT' else 0
        if streak>=3 and trigger is None:trigger=i
        observations.append(dict(index=i,case=row['case'],arm=row['arm'],status=row['status'],
            improved=accepted,http_status=t.get('http_status'),exit_code=t.get('exit_code'),
            elapsed_seconds=t.get('elapsed_seconds'),first_byte_seconds=t.get('first_byte_seconds'),
            reported_total_tokens=total))
    check('Stop policy respected',trigger is None or trigger==g['attempted'])
    check('Halt marker agrees',(out/'HALTED.json').exists()==(trigger is not None))
    for group in r['groups']:
        items=[x for x in r['trials'] if x['case']==group['case'] and x['arm']==group['arm']]
        median=statistics.median(x['retained_delay_ns'] for x in items) if g['complete'] else None
        check('Group '+group['case']+' '+group['arm'],group['scheduled']==10 and group['attempted']==len(items)
              and group['improvements']==sum(x['improved'] for x in items) and group['median_retained_delay_ns']==median)
    result=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,
                attempted=g['attempted'],remaining=80-g['attempted'],complete=g['complete'],
                responses_reporting_usage=reported,reported_total_tokens=tokens,
                token_scope='Only complete responses reporting total_tokens; missing/failed billing unknown',observations=observations)
    (out/'AUDIT.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k not in ('checks','observations')},indent=2))
    return result['passed']


if __name__=='__main__':sys.exit(0 if audit(Path(sys.argv[1]).resolve()) else 1)
