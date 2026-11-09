"""Actual bad-layout and missing-gate reference controls for independent checks."""
import json
import os
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

from run_fcs_independent_layout import ROOT, OUT, PLATFORM, TOOLS, wsl, sha, save


def main():
    folder=OUT/'controls'
    folder.mkdir(exist_ok=False)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    prefix=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
            'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),'-b']
    def run(label,args):
        p=subprocess.run(prefix+args,cwd=folder,env=env,capture_output=True,timeout=600)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/(label+'.log')).write_text(log,encoding='utf-8')
        return p.returncode,log
    source=OUT/'baseline/design.gds'
    code,log=run('create_bad_gds',['-rd','in_gds='+wsl(source),'-rd','out_gds='+wsl(folder/'bad_met1.gds'),
             '-r',wsl(Path(__file__).with_name('fcs_layout_negative_gds.py'))])
    assert code==0 and 'PW_NEGATIVE_GDS_WRITTEN' in log
    code,log=run('bad_drc',['-rd','in_gds='+wsl(folder/'bad_met1.gds'),'-rd','report_file='+wsl(folder/'bad_drc.lyrdb'),
             '-r',wsl(PLATFORM/'drc/sky130hd.lydrc')])
    items=ET.parse(folder/'bad_drc.lyrdb').getroot().findall('.//items/item') if code==0 and (folder/'bad_drc.lyrdb').exists() else []
    original=(OUT/'baseline/complete_reference/reference_complete.cdl').read_text()
    candidates=list(re.finditer(r'(?im)^X_[^\n]*(?:\n\+[^\n]*)*',original))
    selected=next(m for m in candidates if not any(token in m[0] for token in ('__conb_','__tapvpwrvgnd_')))
    bad=original[:selected.start()]+original[selected.end():]
    (folder/'bad_reference.cdl').write_text(bad,encoding='ascii')
    code,lvslog=run('bad_lvs',['-rd','in_gds='+wsl(source),'-rd','report_file='+wsl(folder/'bad_lvs.lvsdb'),
        '-rd','cdl_file='+wsl(folder/'bad_reference.cdl'),'-rd','target_netlist='+wsl(folder/'bad_extracted.cir'),
        '-r',wsl(PLATFORM/'lvs/sky130hd.lylvs')])
    result=dict(passed=len(items)>0 and "ERROR : Netlists don't match" in lvslog,
        drc_negative_detected=len(items)>0,drc_violation_items=len(items),drc_categories=sorted({i.findtext('category') for i in items}),
        lvs_negative_detected="ERROR : Netlists don't match" in lvslog,lvs_tool_exit_code=code,
        removed_top_reference_instance=selected[0],original_gds_sha256=sha(source),
        original_reference_sha256=sha(OUT/'baseline/complete_reference/reference_complete.cdl'),
        scope='Only separate negative copies modified; original GDS, reference and decks remain unchanged',new_model_calls=0)
    save(folder/'RESULT.json',result)
    print(json.dumps(result),flush=True)


if __name__=='__main__':
    main()
