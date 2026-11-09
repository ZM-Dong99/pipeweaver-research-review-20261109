"""Reproduce the A31OI pin issue using only original library views and deck."""
import json
import os
from pathlib import Path
import re
import subprocess
from run_fcs_independent_layout import OUT, PLATFORM, TOOLS, wsl, sha, save


def main():
    folder=OUT/'isolated_a31oi'
    folder.mkdir(exist_ok=False)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    prefix=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
            'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),'-b']
    def run(label,args):
        p=subprocess.run(prefix+args,cwd=folder,env=env,capture_output=True,timeout=180)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/(label+'.log')).write_text(log,encoding='utf-8')
        return p.returncode,log
    code,_=run('isolate',['-rd','in_gds='+wsl(PLATFORM/'gds/sky130_fd_sc_hd.gds'),'-rd','out_gds='+wsl(folder/'cell.gds'),
                        '-r',wsl(Path(__file__).with_name('isolate_fcs_library_cell.py'))])
    assert code==0
    lib=(PLATFORM/'cdl/sky130hd.cdl').read_text()
    block=next(m[0] for m in re.finditer(r'(?ims)^\.SUBCKT\s+(\S+)[^\n]*\n.*?^\.ENDS[^\n]*(?:\n|$)',lib) if m[1]=='sky130_fd_sc_hd__a31oi_1')
    (folder/'cell.cdl').write_text(block,encoding='ascii')
    code,log=run('lvs',['-rd','in_gds='+wsl(folder/'cell.gds'),'-rd','cdl_file='+wsl(folder/'cell.cdl'),
        '-rd','report_file='+wsl(folder/'lvs.lvsdb'),'-rd','target_netlist='+wsl(folder/'extracted.cir'),
        '-r',wsl(PLATFORM/'lvs/sky130hd.lylvs')])
    status='PASS' if code==0 and 'INFO : Congratulations! Netlists match.' in log else ('FAIL' if "ERROR : Netlists don't match" in log else 'INCOMPLETE')
    _,_=run('xref',['-rd','in_db='+wsl(folder/'lvs.lvsdb'),'-rd','out_json='+wsl(folder/'XREF.json'),
                   '-r',wsl(Path(__file__).with_name('inspect_fcs_lvs.py'))])
    save(folder/'RESULT.json',dict(status=status,tool_exit_code=code,original_library_gds_sha256=sha(PLATFORM/'gds/sky130_fd_sc_hd.gds'),
        original_library_cdl_sha256=sha(PLATFORM/'cdl/sky130hd.cdl'),deck_sha256=sha(PLATFORM/'lvs/sky130hd.lylvs'),
        scope='Single unchanged original library cell; no FCS layout, routing, CTS or generated top reference',new_model_calls=0))
    print('Isolated original-library A31OI LVS: '+status,flush=True)


if __name__=='__main__':
    main()
