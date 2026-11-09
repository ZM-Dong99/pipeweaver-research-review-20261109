"""Read-only evidence checks for the engineering arbiter development controls."""
import argparse
import json
from pathlib import Path
import re
from run_native_comb import digest,save,parse_electrical_report

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path)
    s=ap.parse_args().study.resolve();load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'SUMMARY.json');checks=[]
    def check(label,value):checks.append(dict(check=label,passed=bool(value)))
    check('protocol hash',digest(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('complete declared list',summary['completed']==summary['planned']==6 and len(summary['results'])==6)
    check('zero model calls',summary['llm_requests']==p['llm_requests']==0)
    for f,h in p['frozen_files'].items():
        check('frozen file '+f,digest(Path(f))==h)
        snapshot=s/'code_snapshot'/Path(f).name
        if snapshot.exists():check('code snapshot '+Path(f).name,digest(snapshot)==h)
    for c,row in zip(p['cases'],summary['results']):
        f=s/c['id'];cp=load(f/'protocol.json');r=load(f/'result.json')
        check(c['id']+' result',row['result']==r and row['matched'] and row['actual']==c['expected'])
        check(c['id']+' candidate',digest(Path(c['candidate']))==c['candidate_sha256']==cp['candidate_sha256'])
        check(c['id']+' reference',cp['reference_sha256']==p['reference_sha256'])
        check(c['id']+' parameters',cp['parameter_overrides']==c['parameters'])
        check(c['id']+' helper count',len(cp['dependencies'])==(1 if c['dependency'] else 0))
        check(c['id']+' fixed helper',all(d['sha256']==p['dependency_sha256']==digest(Path(d['path'])) for d in cp['dependencies']))
        if c['expected']=='PASS':
            module=load(f/'candidate_schema.json')['modules']['arbiter'];ports=module['ports'];width=c['parameters'].get('PORTS',4)
            check(c['id']+' actual elaborated width',len(ports['request']['bits'])==width and len(ports['grant']['bits'])==width and len(ports['grant_encoded']['bits'])==(width-1).bit_length())
            check(c['id']+' complete eligibility',r['formal']==r['mapped_formal']==r['ppa']=='PASS' and r['eligible'])
            for stage in ('formal','mapped_formal'):
                text=(f/(stage+'.log')).read_text()
                check(c['id']+' '+stage+' complete','Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            for stage,expected_count in [('formal',2),('mapped_formal',1),('mapping',1)]:
                script=(f/(stage+'.ys')).read_text()
                for name,value in c['parameters'].items():check(c['id']+' '+stage+' '+name,script.count(f'chparam -set {name} {value} arbiter')==expected_count)
            mapped=load(f/'mapped.json')['modules']['arbiter']['cells']
            check(c['id']+' actual standard cells',len(mapped)==r['mapped_cells'] and all(x['type'].startswith('sky130_fd_sc_hd__') for x in mapped.values()))
            check(c['id']+' mapped hash',digest(f/'mapped.v')==r['mapped_sha256'])
            text=(f/'sta.log').read_text()
            check(c['id']+' electrical raw',parse_electrical_report(text)==r['electrical'] and r['electrical']['status']=='PASS')
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                m=re.search(pattern,text);check(c['id']+' '+key,bool(m) and float(m[1])==r[key])
        elif c['expected']=='FORMAL_FAIL':
            check(c['id']+' actual witness',r['formal']=='FAIL' and 'model found for base case: FAIL!' in (f/'formal.log').read_text() and (f/'formal_counterexample.vcd').exists())
            check(c['id']+' PPA not run',r['ppa']=='NOT_RUN' and not r['eligible'])
        else:check(c['id']+' missing helper stops',r['stage']=='schema' and r['formal']==r['ppa']=='NOT_RUN' and 'priority_encoder' in (f/'candidate_schema.log').read_text())
    loop=load(s/'loop_integration/summary.json');contract=load(s/'loop_integration/protocol.json')['contract']
    check('loop fixed parameters',contract['parameter_overrides']==p['loop_parameters'])
    check('loop fixed helper',contract['fixed_dependencies'][0]['sha256']==p['dependency_sha256'])
    check('loop completed',loop['status']=='COMPLETED' and loop['llm_requests_attempted']==0 and len(loop['candidates'])==2)
    check('loop positive rewrite',loop['candidates'][0]['metrics']['formal']==loop['candidates'][0]['metrics']['mapped_formal']=='PASS')
    check('loop negative rejected',loop['candidates'][1]['metrics']['formal']=='FAIL' and not loop['candidates'][1]['accepted'])
    result=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,scope='Development qualification only, not model optimization results or independent experiment count')
    save(s/'AUDIT.json',result);print(json.dumps({k:v for k,v in result.items() if k!='checks'}))
    return 0 if result['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
