"""Restricted bulk-model diagnostic and actual tap-removal negative control."""
import json
import os
from pathlib import Path
import re
import subprocess
from run_fcs_independent_layout import ROOT, PLATFORM, TOOLS, wsl, sha, save

SOURCE=ROOT/'eda/experiments/fcs_filled_independent_layout_20261108'
OUT=SOURCE/'substrate_continuity_diagnostic'


def main():
    OUT.mkdir(exist_ok=False)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    prefix=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
        'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),'-b']
    def run(folder,label,args):
        p=subprocess.run(prefix+args,cwd=folder,env=env,capture_output=True,timeout=300)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/(label+'.log')).write_text(log,encoding='utf-8')
        return p.returncode,log
    results={}
    for variant,case,remove,wrong in [('baseline','baseline',False,False),('optimized','optimized',False,False),
                                    ('baseline_no_taps','baseline',True,False),('baseline_wrong_gate','baseline',False,True)]:
        folder=OUT/variant
        folder.mkdir()
        gds=SOURCE/case/'design.gds'
        code,_=run(folder,'model',['-rd','in_gds='+wsl(gds),'-rd','out_gds='+wsl(folder/'model.gds'),
          '-rd','out_json='+wsl(folder/'MODEL.json'),'-rd','remove_taps='+('yes' if remove else 'no'),
          '-r',wsl(Path(__file__).with_name('fcs_substrate_model.py'))])
        if code:
            raise RuntimeError('Model preconditions failed')
        reference=(SOURCE/case/'reference_complete.cdl').read_text()
        if wrong:
            selected=next(m for m in re.finditer(r'(?im)^X_[^\n]*(?:\n\+[^\n]*)*',reference) if '__conb_' not in m[0])
            reference=reference[:selected.start()]+reference[selected.end():]
        (folder/'reference.cdl').write_text(reference,encoding='ascii')
        code,log=run(folder,'lvs',['-rd','in_gds='+wsl(folder/'model.gds'),'-rd','cdl_file='+wsl(folder/'reference.cdl'),
           '-rd','report_file='+wsl(folder/'lvs.lvsdb'),'-rd','target_netlist='+wsl(folder/'extracted.cir'),
           '-r',wsl(PLATFORM/'lvs/sky130hd.lylvs')])
        status='PASS' if code==0 and 'INFO : Congratulations! Netlists match.' in log else ('FAIL' if "ERROR : Netlists don't match" in log else 'INCOMPLETE')
        expected='FAIL' if remove or wrong else 'PASS'
        results[variant]=dict(status=status,expected=expected,as_expected=status==expected,
            original_gds_sha256=sha(gds),reference_sha256=sha(folder/'reference.cdl'),tool_exit_code=code)
        save(OUT/'RESULT.json',dict(all_as_expected=all(v['as_expected'] for v in results.values()),cases=results,
          scope='Explicitly restricted substrate-model diagnostic, not unmodified-manufacturing-GDS LVS PASS',
          driver_sha256=sha(Path(__file__)),model_driver_sha256=sha(Path(__file__).with_name('fcs_substrate_model.py')),new_model_calls=0))
        print(variant+' substrate-model LVS: '+status+' expected '+expected,flush=True)


if __name__=='__main__':
    main()
