"""Complete the exported top CDL with exact used, pinned transistor definitions."""
import csv
import json
import os
from pathlib import Path
import re
import subprocess

from run_fcs_independent_layout import ROOT, OUT, SOURCE, PLATFORM, TOOLS, wsl, sha, save


def main():
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    library=(PLATFORM/'cdl/sky130hd.cdl').read_text()
    definitions={match[1]:match[0] for match in re.finditer(r'(?ims)^\.SUBCKT\s+(\S+)[^\n]*\n.*?^\.ENDS[^\n]*(?:\n|$)',library)}
    results={}
    for case in ('baseline','optimized'):
        parent=OUT/case
        folder=parent/'complete_reference'
        folder.mkdir(exist_ok=False)
        with (SOURCE/case/'physical_cells.tsv').open() as f:
            used={row['master'] for row in csv.DictReader(f,delimiter='\t')}
        assert not used-set(definitions),'Missing master definitions'
        blocks=[definitions[name] for name in sorted(used)]
        assert not any(re.search(r'(?im)^X',block) for block in blocks),'Master has nested subcircuits; closure required'
        complete='\n'.join(blocks)+'\n'+(parent/'reference.cdl').read_text()
        (folder/'reference_complete.cdl').write_text(complete,encoding='ascii')
        save(folder/'protocol.json',dict(driver_sha256=sha(Path(__file__)),gds_sha256=sha(parent/'design.gds'),
             incomplete_top_reference_sha256=sha(parent/'reference.cdl'),library_sha256=sha(PLATFORM/'cdl/sky130hd.cdl'),
             used_masters=sorted(used),master_count=len(used),all_definitions_present=True,no_nested_subcircuits=True,
             complete_reference_sha256=sha(folder/'reference_complete.cdl'),deck_sha256=sha(PLATFORM/'lvs/sky130hd.lylvs'),
             policy='Append only original transistor definitions for all actual physical master types, no blackboxing or edits to deck/GDS/top connectivity',new_model_calls=0))
        command=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
            'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),
            '-b','-rd','in_gds='+wsl(parent/'design.gds'),'-rd','report_file='+wsl(folder/'lvs.lvsdb'),
            '-rd','cdl_file='+wsl(folder/'reference_complete.cdl'),'-rd','target_netlist='+wsl(folder/'extracted.cir'),
            '-r',wsl(PLATFORM/'lvs/sky130hd.lylvs')]
        p=subprocess.run(command,cwd=folder,env=env,capture_output=True,timeout=600)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'lvs.log').write_text(log,encoding='utf-8')
        status='PASS' if p.returncode==0 and 'INFO : Congratulations! Netlists match.' in log else ('FAIL' if "ERROR : Netlists don't match" in log else 'INCOMPLETE')
        results[case]=dict(status=status,tool_exit_code=p.returncode,master_count=len(used),report_exists=(folder/'lvs.lvsdb').is_file(),
                           gds_sha256=sha(parent/'design.gds'),reference_sha256=sha(folder/'reference_complete.cdl'))
        save(folder/'RESULT.json',results[case])
        save(OUT/'LVS_COMPLETE.json',dict(cases=results,new_model_calls=0))
        print(case+' complete-reference LVS: '+status,flush=True)


if __name__=='__main__':
    main()
