"""Check initialized-backend proof, mapping, electrical and negative evidence; no tool reruns."""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);a=ap.parse_args();s=a.study.resolve()
    p=load(s/'protocol.json');d=load(s/'SUMMARY.json');checks=[]
    def check(name,value):checks.append(dict(check=name,passed=bool(value)))
    check('Frozen protocol',sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('Expected cases retained',[r['id'] for r in d['results']]==[c['id'] for c in p['cases']])
    for rel,h in p['dependencies'].items():check('Snapshot '+rel,sha(s/'code_snapshot'/Path(rel).name)==h)
    for c,row in zip(p['cases'],d['results']):
        folder=s/c['id'];r=load(folder/'result.json');cp=load(folder/'protocol.json')
        check(c['id']+' exact result',row['result']==r and row['matched'] and row['expected']==c['expected'])
        check(c['id']+' original inputs',sha(Path(c['candidate']))==c['candidate_sha256'] and sha(Path(c['reference']))==c['reference_sha256'])
        check(c['id']+' protocol hash',sha(folder/'protocol.json')==(folder/'protocol.sha256').read_text().strip())
        check(c['id']+' explicit policy',cp['initial_state_policy']=='rtl-declared' and cp['unmap_clock_enables'] and cp['prove_common_named_state_invariants'])
        check(c['id']+' fixed parameters',cp['parameter_overrides']==c['params'])
        if c['expected']=='PASS':
            check(c['id']+' full source and mapped proofs',all('Induction step proven: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8') and r[stage]=='PASS' for stage in ('formal','mapped_formal')))
            for stage in ('formal','mapped_formal'):
                info=load(folder/(stage+'_state_invariants.json'));script=(folder/(stage+'.ys')).read_text(encoding='utf-8')
                check(c['id']+' '+stage+' no assumed state equality',info['assumed_state_equalities']==0 and '-set-assumes' not in script and ' -cut' not in script and '-set-init-zero' not in script and '-tempinduct-skip' not in script)
            init=load(folder/'mapped_initial_state.json')['attributes']
            mapped=load(folder/'mapped.json')['modules'][c['top']]
            expected=[dict(net=n,width=len(v['bits']),value=v['attributes']['init']) for n,v in sorted(mapped['netnames'].items()) if 'init' in v.get('attributes',{})]
            check(c['id']+' init exactly from candidate mapping',init==expected)
            sta=(folder/'sta.log').read_text(encoding='utf-8')
            check(c['id']+' electrical eligibility',r['electrical']['status']=='PASS' and r['electrical']['violation_rows']==0 and '(VIOLATED)' not in sta)
            check(c['id']+' WNS from STA',float(re.search(r'worst slack max\s+([-+\d.]+)',sta)[1])==r['wns_ns'])
            check(c['id']+' logical qualification scope',r['physical_power_up_verified'] is False and 'logical' in r['eligibility_scope'])
        elif c['expected']=='FORMAL_FAIL':
            check(c['id']+' real source counterexample',r['formal']=='FAIL' and 'model found for base case: FAIL!' in (folder/'formal.log').read_text(encoding='utf-8') and (folder/'formal_counterexample.vcd').exists())
        else:
            check(c['id']+' unsupported memory clearly reported',r['stage']=='schema' and 'Unsupported state/formal cell: $mem' in r['failure_reason'])
    check('Broken mapped output detected',d['broken_mapped_output_detected'] and load(s/'broken_mapped_output/RESULT.json')['caught_actual_base_counterexample'] and 'model found for base case: FAIL!' in (s/'broken_mapped_output/proof.log').read_text(encoding='utf-8'))
    check('No model requests',d['model_requests']==p['model_requests']==0)
    result=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,
                model_requests=0,scope='Consistency audit, not new independent EDA or physical power-up validation')
    (s/'AUDIT.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps(dict(passed=result['passed'],checks=len(checks))))
    return 0 if result['passed'] else 1


if __name__=='__main__':raise SystemExit(main())
