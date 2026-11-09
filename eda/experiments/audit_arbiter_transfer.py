"""Read-only checks of same-family operator transfer and frozen candidate bytes."""
import argparse
import json
from pathlib import Path
import re
from run_native_comb import digest,parse_electrical_report,save

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve();load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'SUMMARY.json');checks=[];totals={'source_formal_pass':0,'mapped_formal_pass':0,'sta_pass':0,'strict_baseline_improvements':0}
    def check(k,v):checks.append(dict(check=k,passed=bool(v)))
    check('protocol hash',digest(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('all four profiles',summary['planned_profiles']==summary['completed_profiles']==len(summary['profiles'])==len(p['profiles'])==4)
    check('zero model calls',summary['llm_requests']==p['llm_requests']==0)
    check('original/helper frozen',digest(s/'inputs/original.v')==p['source_sha256'] and digest(s/'inputs/priority_encoder.v')==p['helper_sha256'])
    parent=load(Path(p['parent'])/'protocol.json');parent_hashes={c['id']:c['sha256'] for c in parent['candidates']}
    check('parent unchanged',digest(Path(p['parent'])/'protocol.json')==p['parent_protocol_sha256'])
    for c in p['candidates']:check('same prior candidate '+c['id'],digest(Path(c['path']))==c['sha256']==parent_hashes[c['id']])
    for rel,h in p['dependency_sha256'].items():check('snapshot '+rel,digest(s/'code_snapshot'/Path(rel).name)==h)
    def eda(f,m,params,label):
        cp=load(f/'protocol.json');check(label+' actual result',load(f/'result.json')==m)
        check(label+' original',cp['reference_sha256']==p['source_sha256'])
        check(label+' actual source',digest(Path(cp['candidate']))==cp['candidate_sha256'])
        check(label+' helper',[x['sha256'] for x in cp['dependencies']]==[p['helper_sha256']])
        check(label+' parameters',cp['parameter_overrides']==params)
        check(label+' same contract',cp['clock']=='clk' and cp['reset']=='rst' and cp['warmup_samples']==cp['reset_cycles']==1 and cp['period_ns']==10 and cp['liberty_sha256']==p['library_sha256'])
        totals['source_formal_pass']+=m.get('formal')=='PASS';totals['mapped_formal_pass']+=m.get('mapped_formal')=='PASS';totals['sta_pass']+=m.get('ppa')=='PASS'
        if m.get('status')=='PASS':
            for stage in ('formal','mapped_formal'):
                text=(f/(stage+'.log')).read_text();check(label+' '+stage,'Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            text=(f/'sta.log').read_text();check(label+' electrical',parse_electrical_report(text)==m['electrical'])
            check(label+' raw WNS',float(re.search(r'worst slack max\s+([-+\d.]+)',text)[1])==m['wns_ns'])
            area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(f/'mapping.log').read_text())[-1]);check(label+' raw area',area==m['mapped_area_um2'])
            check(label+' mapped hash',digest(f/'mapped.v')==m['mapped_sha256'])
        else:check(label+' no false eligibility',not m.get('eligible'))
    for profile in summary['profiles']:
        f=s/profile['id'];params=profile['parameters'];frozen=next(x for x in p['profiles'] if x['id']==profile['id'])
        check(profile['id']+' declared parameters',params['PORTS']==frozen['ports'] and params['ARB_LSB_HIGH_PRIORITY']==frozen['lsb'])
        check(profile['id']+' complete six cases',profile['status']=='COMPLETED' and len(profile['results'])==6)
        eda(f/'baseline',profile['baseline'],params,profile['id']+' baseline');eda(f/'known_reference',profile['known_reference'],params,profile['id']+' known reference')
        schema=load(f/'baseline/candidate_schema.json')['modules']['arbiter']['ports']
        check(profile['id']+' actual native width',len(schema['request']['bits'])==len(schema['grant']['bits'])==params['PORTS'] and len(schema['grant_encoded']['bits'])==(params['PORTS']-1).bit_length())
        baseline=profile['baseline'];cap=baseline['mapped_area_um2']*p['area_ratio_limit'];check(profile['id']+' fixed area cap',profile['area_cap_um2']==cap)
        qualified=[]
        for row in profile['results']:
            m=row['metrics'];eda(f/row['id'],m,params,profile['id']+'/'+row['id'])
            eligible=(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=cap+1e-9 and m['tns_ns']>=baseline['tns_ns']-1e-9)
            gain=bool(eligible and m['wns_ns']>baseline['wns_ns']+1e-9)
            check(profile['id']+'/'+row['id']+' gain',row['strict_baseline_improvement']==gain)
            totals['strict_baseline_improvements']+=gain
            if gain:qualified.append(row)
        qualified.sort(key=lambda x:(-x['metrics']['wns_ns'],x['metrics']['mapped_area_um2'],x['id']))
        expected=qualified[0]['metrics'] if qualified else baseline
        check(profile['id']+' main selection',profile['best_new_metrics']==expected)
        check(profile['id']+' export hash',digest(f/'best_new_search.v')==profile['best_new_sha256'] and digest(f/'best_available.v')==profile['best_available_sha256'])
    check('32 actual EDA cases accounted',totals['source_formal_pass']<=p['total_planned_eda_runs']==32)
    report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,actual_case_statistics=totals,
        scope='Four parameter instances of one family; six unchanged source versions; not four independent families or 24 new RTLs')
    save(s/'AUDIT.json',report);print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
    return 0 if report['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
