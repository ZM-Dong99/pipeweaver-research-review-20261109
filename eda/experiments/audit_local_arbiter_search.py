"""Evidence checks for guarded local-development experiments; no EDA/model calls."""
import argparse
import json
from pathlib import Path
import re
from run_native_comb import digest,parse_electrical_report,save

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve();load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'SUMMARY.json');checks=[]
    def check(k,v):checks.append(dict(check=k,passed=bool(v)))
    check('protocol hash',digest(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('complete six slots',summary['status']=='COMPLETED' and summary['completed']==summary['candidate_budget']==p['candidate_budget']==len(p['candidates'])==len(summary['results'])==6)
    check('zero model calls',p['llm_requests']==summary['llm_requests']==0)
    check('original and helper',digest(s/'inputs/original.v')==p['original_sha256'] and digest(s/'inputs/priority_encoder.v')==p['helper_sha256'])
    check('known reference separate',digest(s/'inputs/known_reset_reference.v')==p['known_reference_sha256'])
    for rel,h in p['dependency_sha256'].items():check('frozen code '+rel,digest(s/'code_snapshot'/Path(rel).name)==h)
    cap=summary['baseline']['mapped_area_um2']*p['area_ratio_limit'];check('fixed area cap',cap==summary['area_cap_um2'])
    def qualified(m):return m.get('status')=='PASS' and m.get('eligible') and all(m.get(k)=='PASS' for k in ('formal','mapped_formal','ppa')) and m.get('electrical',{}).get('status')=='PASS' and m['mapped_area_um2']<=cap+1e-9
    def eda(folder,m,label):
        cp=load(folder/'protocol.json');check(label+' actual metrics',load(folder/'result.json')==m)
        check(label+' original reference',cp['reference_sha256']==p['original_sha256'])
        check(label+' same helper',[x['sha256'] for x in cp['dependencies']]==[p['helper_sha256']])
        check(label+' fixed parameters',cp['parameter_overrides']==p['contract']['parameters'])
        check(label+' same clock/reset',cp['clock']=='clk' and cp['reset']=='rst' and cp['warmup_samples']==cp['reset_cycles']==1 and cp['period_ns']==10)
        if m.get('status')=='PASS':
            for stage in ('formal','mapped_formal'):
                text=(folder/(stage+'.log')).read_text();check(label+' '+stage,m[stage]=='PASS' and 'Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            text=(folder/'sta.log').read_text();check(label+' electrical',parse_electrical_report(text)==m['electrical'])
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:check(label+' '+key,float(re.search(pattern,text)[1])==m[key])
            area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text())[-1]);check(label+' raw area',area==m['mapped_area_um2'])
            check(label+' mapped hash',digest(folder/'mapped.v')==m['mapped_sha256'])
        else:check(label+' fail closed',not m.get('eligible'))
    eda(s/'baseline',summary['baseline'],'baseline');eda(s/'known_reset_reference',summary['known_reference'],'known reference')
    best=summary['baseline'];best_id='baseline';best_path=s/'inputs/original.v';valid_improvements=0
    for c,row in zip(p['candidates'],summary['results']):
        check(c['id']+' frozen candidate',row['id']==c['id'] and digest(Path(c['path']))==c['sha256']==row['source_sha256'])
        m=row['metrics'];eda(Path(c['path']).parent/'eda',m,c['id'])
        eligible=bool(qualified(m));check(c['id']+' eligibility',row['eligible']==eligible)
        if eligible and m['wns_ns']>summary['baseline']['wns_ns']+1e-9 and m['tns_ns']>=summary['baseline']['tns_ns']-1e-9:valid_improvements+=1
        accepted=eligible and m['wns_ns']>best['wns_ns']+1e-9 and m['tns_ns']>=best['tns_ns']-1e-9
        check(c['id']+' ranking',row['accepted']==accepted)
        if accepted:best=m;best_id=c['id'];best_path=Path(c['path'])
    saved=load(s/'BEST.json');check('best matches selection',saved['id']==best_id and saved['metrics']==best and digest(best_path)==digest(s/'best.v')==saved['sha256'])
    check('known control not relabeled as discovery',saved['known_reference_excluded_from_selection'])
    report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,
        candidate_slots=6,strict_baseline_improvements=valid_improvements,scope='Post-hoc single-design development, not a fair independent method comparison')
    save(s/'AUDIT.json',report);print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
    return 0 if report['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
