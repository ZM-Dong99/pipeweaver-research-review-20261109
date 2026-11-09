"""Audit native sequential loop artifacts; no model or EDA execution."""
import argparse
import hashlib
import json
from pathlib import Path
import re

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path)
    s=ap.parse_args().study.resolve()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'summary.json');checks=[]
    if p['mode']!='manual_replay':
        ap.error('This audit currently supports completed manual replay studies only')
    def check(name,value):checks.append(dict(check=name,passed=bool(value)))
    check('frozen protocol',sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip()==summary['protocol_sha256'])
    for f,h in p['dependencies'].items():check('snapshot '+Path(f).name,sha(s/'code_snapshot'/Path(f).name)==h)
    for item in p['inputs']:check('frozen input '+Path(item['path']).name,sha(Path(item['path']))==item['sha256'])
    check('all candidate slots',summary['status']=='COMPLETED' and len(summary['candidates'])==p['candidate_budget'])
    if p['mode']=='manual_replay':
        check('no model calls or responses',summary['llm_requests_attempted']==0 and not list(s.glob('candidate_*/generation')))
    contract=p['contract'];selected=s/'inputs/original.v';selected_source='baseline';best_folder=s/'baseline';best=summary['baseline']
    backend_hash=next(h for f,h in p['dependencies'].items() if Path(f).name=='run_native_seq.py')
    cap=best['mapped_area_um2']*p['area_limit']
    check('fixed baseline cap',cap==summary['fixed_area_cap_um2'])
    evaluations=[(s/'baseline',best)]+[(s/f'candidate_{row["index"]:03d}'/'eda',row['metrics']) for row in summary['candidates'] if 'metrics' in row]
    for folder,r in evaluations:
        cp=load(folder/'protocol.json')
        check(str(folder)+' backend protocol',sha(folder/'protocol.json')==(folder/'protocol.sha256').read_text().strip())
        check(str(folder)+' candidate source',sha(Path(cp['candidate']))==cp['candidate_sha256'])
        check(str(folder.name)+' reference original',cp['reference_sha256']==p['original_sha256'] and Path(cp['reference']).resolve()==(s/'inputs/original.v').resolve())
        check(str(folder)+' backend code',cp['runner_sha256']==backend_hash)
        check(str(folder)+' frozen timing/startup',all(cp[k]==contract[k] for k in ['clock','reset','reset_active','warmup_samples','period_ns']) and cp['reset_cycles']==contract['reset_cycles'])
        if 'parameter_overrides' in contract:
            check(str(folder)+' fixed top parameters',cp.get('parameter_overrides')==contract['parameter_overrides'])
            check(str(folder)+' fixed helper hashes',[x['sha256'] for x in cp.get('dependencies',[])]==[x['sha256'] for x in contract.get('fixed_dependencies',[])])
            check(str(folder)+' actual helper bytes',all(sha(Path(x['path']))==x['sha256'] for x in cp.get('dependencies',[])))
        check(str(folder)+' fixed library/IO',cp['liberty_sha256']==contract['library_sha256'] and all(cp[k]==contract[k] for k in ['input_delay_ns','output_delay_ns','input_transition_ns','output_load_pf']))
        for stage in ['formal','mapped_formal']:
            script=folder/(stage+'.ys')
            if script.exists():
                times=[int(x) for x in re.findall(r'-set-at (\d+) ',script.read_text())]
                check(str(folder)+' '+stage+' reset assumptions',times==list(range(1,contract['reset_cycles']+1)))
        check(str(folder)+' actual metrics',load(folder/'result.json')==r)
        if r['status']=='PASS':
            check(str(folder)+' complete checks',r['eligible'] and all(r[k]=='PASS' for k in ['formal','mapped_formal','ppa']) and r['electrical']['status']=='PASS')
            for stage in ['formal','mapped_formal']:
                log=(folder/(stage+'.log')).read_text()
                check(str(folder)+' '+stage,'Induction step proven: SUCCESS!' in log and 'Base case for induction length' in log)
            sta=(folder/'sta.log').read_text()
            check(str(folder)+' real STA',not re.search(r'^\s*(?:Error:|Warning:)',sta,re.M|re.I) and 'Endpoint:' in sta)
            block=sta.split('PW_ELECTRICAL_BEGIN')[1].split('PW_ELECTRICAL_END')[0]
            check(str(folder)+' electrical raw','(VIOLATED)' not in block)
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                m=re.search(pattern,sta);check(str(folder)+' '+key,bool(m) and float(m[1])==r[key])
            check(str(folder)+' mapped hash',sha(folder/'mapped.v')==r['mapped_sha256'])
        else:
            check(str(folder)+' no false eligibility',not r['eligible'])
            if r.get('formal')=='FAIL':
                check(str(folder)+' actual failure','model found for base case: FAIL!' in (folder/'formal.log').read_text() and (folder/'formal_counterexample.vcd').exists() and r['ppa']=='NOT_RUN')
    for row in summary['candidates']:
        folder=s/f'candidate_{row["index"]:03d}';prompt=load(folder/'prompt.json')
        check(folder.name+' prompt hash',sha(folder/'prompt.json')==row['prompt_sha256'])
        check(folder.name+' contract prompt',prompt['startup_and_timing_contract']==contract and prompt['fixed_mapped_area_cap_um2']==cap)
        if 'fixed_dependencies' in contract:
            payload=prompt.get('fixed_dependency_sources',[])
            expected=contract['fixed_dependencies']
            check(folder.name+' helper content in prompt',len(payload)==len(expected) and all(
                x['name']==y['name'] and x['sha256']==y['sha256'] and x['rtl']==(s/'inputs'/y['name']).read_text(encoding='utf-8')
                for x,y in zip(payload,expected)))
        check(folder.name+' measured feedback',prompt['actual_eda_feedback']['metrics']==best and row['feedback_sha256']==sha(best_folder/'sta.log')==prompt['actual_eda_feedback']['sta_log_sha256'])
        check(folder.name+' raw path in prompt',bool(prompt['actual_eda_feedback']['measured_paths']) and all(path in (best_folder/'sta.log').read_text() for path in prompt['actual_eda_feedback']['measured_paths']))
        check(folder.name+' current best RTL',prompt['current_rtl']==selected.read_text(encoding='utf-8'))
        check(folder.name+' candidate hash',sha(folder/'candidate.v')==row['candidate_sha256'])
        if row['index']>1:
            prev=summary['candidates'][row['index']-2]
            check(folder.name+' previous attempt feedback',prompt['previous_attempt']['metrics']==prev['metrics'] and prompt['previous_attempt']['accepted']==prev['accepted'])
        m=row['metrics']
        accept=m['status']=='PASS' and m['eligible'] and m['mapped_area_um2']<=cap and m['tns_ns']>=best['tns_ns']-1e-9 and m['wns_ns']>best['wns_ns']+1e-9
        check(folder.name+' decision',row['accepted']==accept)
        if accept:selected=folder/'candidate.v';selected_source=folder.name;best_folder=folder/'eda';best=m
    index=load(s/'best.json')
    check('best export',index['source']==selected_source and index['metrics']==best and sha(s/'best.v')==sha(selected)==index['sha256'])
    audit=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,
        scope='Artifact consistency; not an independent proof engine or model superiority test')
    (s/'AUDIT.json').write_text(json.dumps(audit,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps({'passed':audit['passed'],'checks':len(checks),'failures':[c['check'] for c in checks if not c['passed']]}))
    return 0 if audit['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
