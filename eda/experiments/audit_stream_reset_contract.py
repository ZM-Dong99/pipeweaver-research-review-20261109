"""Read-only proof audit for the separate reset-only valid/keep contract."""
import argparse
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);a=ap.parse_args();s=a.study.resolve()
    p=load(s/'protocol.json');summary=load(s/'SUMMARY.json');checks=[]
    def check(label,value):checks.append(dict(check=label,passed=bool(value)))
    check('Protocol hash',sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('Library hash',sha(ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')==p['library_sha256'])
    check('Parent protocol hash',sha(ROOT/'eda/experiments/stream_initialized_controls_20261106/protocol.json')==p['parent_protocol_sha256'])
    for rel,h in p['frozen_files'].items():check('Frozen artifact '+rel,sha(s/rel)==h)
    for rel,h in p['dependencies'].items():check('Code snapshot '+rel,sha(s/'code_snapshot'/Path(rel).name)==h)
    check('Every predeclared case',[r['id'] for r in summary['results']]==[c['id'] for c in p['cases']])
    check('No new model or STA requests',summary['model_requests']==p['model_requests']==0 and summary['new_sta_runs']==p['new_sta_runs']==0)
    for case,row in zip(p['cases'],summary['results']):
        folder=s/case['id'];text=(folder/'proof.log').read_text(encoding='utf-8');script=(folder/'prove.ys').read_text(encoding='utf-8')
        check(case['id']+' outcome',row['expected']==case['expected'] and row['actual']==case['expected'] and row['matched'])
        check(case['id']+' input bytes',sha(Path(case['source']))==case['source_sha256'] and sha(Path(case['candidate']))==case['candidate_sha256'])
        check(case['id']+' no initial attributes',row['remaining_init_attributes']=={'pw_gold':0,'pw_cand':0})
        for name in ('pw_gold','pw_cand'):
            module=load(folder/(name+'_noinit.json'))['modules'][name]
            check(case['id']+' '+name+' independent initial model',not any('init' in v.get('attributes',{}) for v in module['netnames'].values()))
        check(case['id']+' no state assumptions/cuts','-set-assumes' not in script and '-set-init-zero' not in script and '-set-init ' not in script and '-tempinduct-skip' not in script and ' -cut' not in script)
        check(case['id']+' actual full proof or counterexample',('Induction step proven: SUCCESS!' in text) if case['expected']=='PASS' else ('model found for base case: FAIL!' in text and (folder/'counterexample.vcd').exists()))
        if not case['strict']:
            rule=load(folder/'comparison_rules.json')
            control=[r for r in rule['rules'] if r.get('signal') in ('s_axis_tready','m_axis_tvalid')]
            check(case['id']+' control never masked',len(control)==2 and all(r['guard']=="1'b1" for r in control))
            check(case['id']+' state relations not assumed',rule['state_equalities_assumed']==0 and all(not r.get('assumed',False) for r in rule['rules']))
    record=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,model_requests=0,new_sta_runs=0,
                scope='Proof artifact consistency, not independent AXI compliance or physical validation')
    (s/'AUDIT.json').write_text(json.dumps(record,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps(dict(passed=record['passed'],checks=len(checks))))
    return 0 if record['passed'] else 1


if __name__=='__main__':raise SystemExit(main())
