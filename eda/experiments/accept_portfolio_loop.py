"""Real local integration acceptance. Six portfolio runs; zero model requests."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()


def main(out):
    out=out.resolve();out.mkdir(parents=True,exist_ok=False);(out/'inputs').mkdir()
    original=ROOT/'benchmark/verified_portfolio_20261107/mux10x8/original.v'
    text=original.read_text(encoding='utf-8');needle='default: block_out = block_a;'
    assert text.count(needle)==1
    bad=out/'inputs/mux_wrong_default.v';bad.write_text(text.replace(needle,'default: block_out = block_i;'),encoding='utf-8')
    cases=[('priority_default','priority256',1.1,[], 'sampled_no_sta',1.43),
           ('mux_default','mux10x8',1.1,[], 'sampled_no_sta',0.73),
           ('alu_default','alu64',1.1,[], 'sampled_no_sta',1.83),
           ('mux_no_area_growth','mux10x8',1.0,[], 'sampled_sta',0.77),
           ('mux_equal_fallback','mux10x8',1.1,[str(original)],'baseline',1.04),
           ('mux_wrong_default_rejected','mux10x8',1.1,[str(bad)],'baseline',1.04)]
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    results=[]
    for label,design,area,manual,expected,delay in cases:
        folder=out/label
        cmd=[sys.executable,'-B','-m','agents.portfolio_loop','run','--design',design,'--area-limit',str(area),'--out',str(folder)]
        for f in manual:cmd+=['--candidate-rtl',f]
        print('Acceptance starting: '+label,flush=True)
        p=subprocess.run(cmd,cwd=ROOT,env=env,capture_output=True,timeout=3600)
        (out/(label+'_runner.log')).write_bytes(p.stdout+p.stderr)
        if not (folder/'SUMMARY.json').exists():raise RuntimeError('Missing summary '+label)
        s=load(folder/'SUMMARY.json')
        checks=dict(exit_ok=p.returncode==0,complete=s['status']=='COMPLETE',model_requests_zero=s['model_requests']==0,
                    expected_choice=s['selected']==expected,expected_delay=abs(s['best_metrics']['max_data_arrival_ns']-delay)<1e-9,
                    export_hash=s['best_sha256']==sha(folder/'best.v'),
                    export_source=(folder/'best.v').read_bytes()==(folder/next(r['source'] for r in s['candidates'] if r['id']==s['selected'])).read_bytes())
        if label=='mux_no_area_growth':
            first=next(r for r in s['candidates'] if r['id']=='sampled_no_sta')
            checks['fastest_rejected_by_area']=not first['accepted'] and 'area_limit' in first['reasons']
        if label=='mux_equal_fallback':
            manual_row=next(r for r in s['candidates'] if r['id']=='manual_01')
            checks['equal_not_counted_gain']=not manual_row['accepted'] and manual_row['shared_evaluation']=='baseline' and s['unique_eda_runs']==1
        if label=='mux_wrong_default_rejected':
            m=next(r for r in s['candidates'] if r['id']=='manual_01')
            formal=folder/'evaluations/manual_01/formal.log'
            log=formal.read_text(encoding='utf-8',errors='replace') if formal.exists() else ''
            checks['actual_counterexample']='model found: FAIL' in log or 'proof did fail' in log
            checks['bad_not_selected']=not m['accepted'] and m['metrics'].get('formal')!='PASS' and s['baseline_retained']
        result=dict(case=label,passed=all(checks.values()),checks=checks,selected=s['selected'],delay_ns=s['best_metrics']['max_data_arrival_ns'],
                    area_um2=s['best_metrics']['mapped_area_um2'],unique_eda_runs=s['unique_eda_runs'])
        results.append(result);print(label+': '+('PASS' if result['passed'] else 'FAIL'),flush=True)
        (out/'PROGRESS.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
    report=dict(passed=all(r['passed'] for r in results),new_model_requests=0,portfolio_runs=len(results),
                unique_eda_runs=sum(r['unique_eda_runs'] for r in results),cases=results)
    (out/'RESULT.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print('Acceptance finished: '+str(out/'RESULT.json'),flush=True)
    return 0 if report['passed'] else 1


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('out',type=Path)
    sys.exit(main(ap.parse_args().out))
