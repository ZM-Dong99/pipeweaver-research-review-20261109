"""Audit frozen execution readiness and real manual candidates; no API or EDA."""
import argparse
import json
from pathlib import Path
import re
from run_stream_feedback import validate,sha,load,ROOT,eligible


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('batch',type=Path);ap.add_argument('acceptance',type=Path);a=ap.parse_args()
    s=a.batch.resolve();v=a.acceptance.resolve();p=validate(s);vp=load(v/'protocol.json');d=load(v/'SUMMARY.json');checks=[]
    def check(name,value):checks.append(dict(check=name,passed=bool(value)))
    check('Acceptance protocol hash',sha(v/'protocol.json')==(v/'protocol.sha256').read_text().strip())
    check('Acceptance uses exact batch',vp['batch_protocol_sha256']==sha(s/'protocol.json'))
    for rel,h in vp['dependencies'].items():check('Acceptance code '+rel,sha(v/'code_snapshot'/Path(rel).name)==h)
    check('All manual candidates retained',[r['id'] for r in d['results']]==[j['id'] for j in vp['jobs']])
    for case in p['cases']:
        folder=s/'baselines'/case['id'];m=load(folder/'result.json')
        check(case['id']+' actual fresh baseline',m==case['baseline'] and eligible(m))
        tool=load(folder/'protocol.json')
        check(case['id']+' no-init mapping',tool['initial_state_policy']=='reset-only' and tool['unmap_clock_enables'])
        for stage in ('formal','mapped_formal'):
            log=m[stage+'_decisive_log'];check(case['id']+' '+stage+' complete proof','Induction step proven: SUCCESS!' in (folder/log).read_text(encoding='utf-8'))
        sta=(folder/'sta.log').read_text(encoding='utf-8')
        check(case['id']+' numeric STA',float(re.search(r'worst slack max\s+([-+\d.]+)',sta)[1])==m['wns_ns'])
        check(case['id']+' electrical zero',m['electrical']['violation_rows']==0)
    for job,row in zip(vp['jobs'],d['results']):
        folder=v/job['id'];m=load(folder/'result.json');check(job['id']+' original candidate',sha(Path(job['candidate']))==job['candidate_sha256'])
        check(job['id']+' saved outcome',row['result']==m and row['matched'])
        if row['actual']=='PASS':
            for stage in ('formal','mapped_formal'):
                check(job['id']+' '+stage+' actual full proof','Induction step proven: SUCCESS!' in (folder/m[stage+'_decisive_log']).read_text(encoding='utf-8'))
            check(job['id']+' eligible same contract',eligible(m))
        elif row['actual']=='FORMAL_FAIL':
            decisive=m['formal_decisive_log'];script=(folder/(Path(decisive).stem+'.ys')).read_text(encoding='utf-8')
            check(job['id']+' genuine interface counterexample','model found for base case: FAIL!' in (folder/decisive).read_text(encoding='utf-8') and 'formal_interface_only' in decisive and 'expose ' not in script)
        else:
            check(job['id']+' not false functional failure',m['formal']=='INCOMPLETE' and m.get('formal_auxiliary_attempt_failed') and 'interface_only' in m['formal_decisive_log'])
        for stage in ('formal','mapped_formal'):
            if m.get(stage)!='PASS':continue
            decisive=Path(m[stage+'_decisive_log']).stem
            for name in ('pw_gold','pw_cand'):
                mod=load(folder/(decisive+'_'+name+'_noinit.json'))['modules'][name]
                check(job['id']+' '+stage+' '+name+' no init',all('init' not in net.get('attributes',{}) for net in mod['netnames'].values()))
    tests=load(s/'OFFLINE_VALIDATION.json')
    check('Offline acceptance passed',tests['passed'] and tests['tests']==10)
    check('Offline test record hash',sha(s/'validation_artifacts/tests.log')==tests['log_sha256'])
    check('Zero real attempts before new authorization',not list(s.glob('trials/*/attempt.json')))
    check('New batch authorization pending',load(s/'AUTHORIZATION.json')['status']=='PENDING')
    report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,
        real_model_requests=0,manual_candidate_cases=len(d['results']),offline_tests=10,
        scope='Execution readiness, not model results or independent RTL optimization gains')
    (s/'READINESS_AUDIT.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps(dict(passed=report['passed'],checks=len(checks))))
    return 0 if report['passed'] else 1


if __name__=='__main__':raise SystemExit(main())
