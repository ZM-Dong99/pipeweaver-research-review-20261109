"""Non-vacuous reset-window controls and native MAC; zero model calls."""
from datetime import datetime
import json
from pathlib import Path
import shutil
import subprocess
import sys
from run_native_comb import digest, save

ROOT = Path(__file__).resolve().parents[2]
RUNNER = Path(__file__).with_name('run_native_seq.py')

def main():
    out = ROOT / 'eda/experiments' / datetime.now().strftime('reset_window_validation_%Y%m%d_%H%M%S_%f')
    out.mkdir()
    fixtures = out / 'fixtures'
    fixtures.mkdir()
    mac = ROOT / 'benchmark/rtl_opt_upstream_hkust/benchmark/mac/mac.v'
    source = mac.read_text(encoding='utf-8')
    assert source.count('acc <= 0;') == 1
    bad = fixtures / 'wrong_mac_reset.v'
    bad.write_text(source.replace('acc <= 0;', 'acc <= 1;'), encoding='utf-8')
    old = ROOT / 'eda/experiments/sequential_backend_controls_20261031_final/fixtures'
    cases = [
        dict(id='mac_three_reset_samples', reference=str(mac), candidate=str(mac), top='mac', reset='reset', expected='PASS'),
        dict(id='mac_wrong_reset', reference=str(mac), candidate=str(bad), top='mac', reset='reset', expected='FORMAL_FAIL'),
        dict(id='counter_three_reset_samples', reference=str(old/'counter.v'), candidate=str(old/'encoded.v'), top='seq_control', reset='rst', expected='PASS'),
        dict(id='late_error_after_reset_release', reference=str(old/'counter.v'), candidate=str(old/'late_error.v'), top='seq_control', reset='rst', expected='FORMAL_FAIL')]
    files = [RUNNER, RUNNER.with_name('run_native_comb.py'), Path(__file__)]
    snapshots = out / 'code_snapshot'
    snapshots.mkdir()
    for f in files:
        shutil.copyfile(f, snapshots/f.name)
    dependencies = {str(f): digest(f) for f in files}
    for c in cases:
        for key in ('reference', 'candidate'):
            c[key+'_sha256'] = digest(Path(c[key]))
    save(out/'protocol.json', dict(cases=cases, dependencies=dependencies, reset_cycles=3,
         warmup_samples=4, period_ns=10, timeout_seconds=120, llm_requests=0,
         scope='Conditional startup contract validation, not an optimization study; reset and data unconstrained after sample 3. This is a distinct experiment, not a repair of past results.'))
    (out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n', encoding='ascii')
    print('Experiment: '+str(out), flush=True)
    rows=[]
    for c in cases:
        assert all(digest(Path(f))==h for f,h in dependencies.items())
        assert all(digest(Path(c[k]))==c[k+'_sha256'] for k in ('reference','candidate'))
        folder=out/c['id']
        cmd=[sys.executable,'-B',str(RUNNER),c['candidate'],'--reference',c['reference'],
             '--top',c['top'],'--clock','clk','--reset',c['reset'],'--reset-cycles','3',
             '--warmup','4','--period','10','--timeout','120','--out',str(folder)]
        try:
            proc=subprocess.run(cmd,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900)
            raw,code=proc.stdout,proc.returncode
        except subprocess.TimeoutExpired as exc:
            raw,code=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n',124
        (out/(c['id']+'_runner.log')).write_bytes(raw)
        r=json.loads((folder/'result.json').read_text()) if (folder/'result.json').exists() else {}
        actual='PASS' if r.get('status')=='PASS' else 'FORMAL_FAIL' if r.get('formal')=='FAIL' else 'INCOMPLETE'
        row=dict(id=c['id'],expected=c['expected'],actual=actual,matched=actual==c['expected'],exit_code=code,result=r)
        rows.append(row)
        save(out/'SUMMARY.json',dict(planned=len(cases),completed=len(rows),llm_requests=0,results=rows))
        print(c['id']+': '+actual+' expected='+c['expected'],flush=True)
    return 0 if all(r['matched'] for r in rows) else 1

if __name__=='__main__':
    raise SystemExit(main())
