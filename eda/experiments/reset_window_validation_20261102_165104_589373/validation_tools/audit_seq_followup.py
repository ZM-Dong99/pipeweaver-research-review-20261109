"""Check frozen follow-up artifacts against raw evidence, without rerunning EDA."""
import argparse
import json
from pathlib import Path
import re
from run_native_comb import digest, parse_electrical_report, save

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('study',type=Path)
    a=ap.parse_args();s=a.study.resolve()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'SUMMARY.json');checks=[]
    def check(label,value):checks.append(dict(label=label,passed=bool(value)))
    check('protocol hash',digest(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('complete cases',[c['id'] for c in p['cases']]==[r['id'] for r in summary['results']])
    check('zero model requests',p['llm_requests']==summary['llm_requests']==0)
    for f,h in p['dependencies'].items():check('snapshot '+Path(f).name,digest(s/'code_snapshot'/Path(f).name)==h)
    for c,row in zip(p['cases'],summary['results']):
        folder=s/c['id'];r=load(folder/'result.json');cp=load(folder/'protocol.json')
        check(c['id']+' summary',row['result']==r)
        check(c['id']+' runner',cp['runner_sha256']==p['dependencies'][str(Path(__file__).with_name('run_native_seq.py'))])
        check(c['id']+' protocol hash',digest(folder/'protocol.json')==(folder/'protocol.sha256').read_text().strip())
        for k in ['candidate','reference']:
            source=Path(c.get(k,c.get('source')))
            expected=c.get(k+'_sha256',c.get('sha256'))
            check(c['id']+' '+k,digest(source)==cp[k+'_sha256']==expected)
        check(c['id']+' warmup contract',cp['warmup_samples']==c.get('warmup',p.get('warmup_samples')))
        check(c['id']+' period',cp['period_ns']==p['period_ns'])
        if 'reset_cycles' in p:
            check(c['id']+' reset duration',cp['reset_cycles']==p['reset_cycles'])
            for stage in ['formal','mapped_formal']:
                script=folder/(stage+'.ys')
                if script.exists():
                    text=script.read_text()
                    constrained=[int(x) for x in re.findall(r'-set-at (\d+) ',text)]
                    check(c['id']+' '+stage+' finite reset assumptions',constrained==list(range(1,p['reset_cycles']+1)))
        if r['status']=='PASS':
            check(c['id']+' proof statuses',r['formal']==r['mapped_formal']=='PASS' and r['ppa']=='PASS' and r['eligible'])
            for stage in ['formal','mapped_formal']:
                text=(folder/(stage+'.log')).read_text()
                check(c['id']+' '+stage+' actual induction','Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            sta=(folder/'sta.log').read_text()
            check(c['id']+' clean electrical',parse_electrical_report(sta)==r['electrical'] and r['electrical']['status']=='PASS')
            for key,pat in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                m=re.search(pat,sta);check(c['id']+' '+key,bool(m) and float(m[1])==r[key])
            check(c['id']+' mapped hash',digest(folder/'mapped.v')==r['mapped_sha256'])
            check(c['id']+' SDC hash',digest(folder/'timing.sdc')==r['sdc_sha256'])
        elif r.get('formal')=='FAIL':
            text=(folder/'formal.log').read_text()
            check(c['id']+' actual counterexample','model found for base case: FAIL!' in text and (folder/'formal_counterexample.vcd').exists())
            check(c['id']+' no unsupported PPA',r['ppa']=='NOT_RUN' and not r['eligible'])
        else:
            check(c['id']+' no incomplete eligibility',not r['eligible'] and r['ppa']=='NOT_RUN')
            stage=r['stage'];text=(folder/(stage+'.log')).read_text()
            check(c['id']+' actual incomplete evidence','TIMEOUT' in text or 'timeout' in text.lower() or 'Reached maximum number' in text)
    audit=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,
               scope='Evidence consistency only; not an independent proof engine or independent experiment count')
    save(s/'AUDIT.json',audit)
    print(json.dumps({'passed':audit['passed'],'checks':len(checks),'failures':[c['label'] for c in checks if not c['passed']]}))
    return 0 if audit['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
