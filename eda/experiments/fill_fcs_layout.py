"""Add physical filler cells to a separate copy of the routed reset-complete pair."""
import json
import os
from pathlib import Path
import subprocess

from run_fcs_physical import ROOT, TOOLS, LIB, OPENROAD, PLATFORM, wsl, sha, save
from run_fcs_cts_pdn import PDN_PLATFORM

SOURCE=ROOT/'eda/experiments/fcs_reset_cts_pdn_20261107'
OUT=ROOT/'eda/experiments/fcs_filled_layout_20261108'


def main():
    OUT.mkdir(exist_ok=False)
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    protocol=dict(driver_sha256=sha(Path(__file__)),sources={case:sha(SOURCE/case/'detailed.odb') for case in ('baseline','optimized')},
      cells=['sky130_fd_sc_hd__fill_'+str(i) for i in (8,4,2,1)],
      scope='Separate copy; fill placement gaps to restore continuous well/rail shapes; no data/clock rerouting or functional edits',
      input_stage='Existing fully routed CTS/PDN reset-complete pair',new_model_calls=0)
    save(OUT/'protocol.json',protocol)
    for case in ('baseline','optimized'):
        folder=OUT/case
        folder.mkdir()
        script=folder/'run.tcl'
        script.write_text(f'''read_liberty {{{wsl(LIB)}}}
read_db {{{wsl(SOURCE/case/'detailed.odb')}}}
filler_placement {{sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1}}
source {{{wsl(PDN_PLATFORM/'global_connect.tcl')}}}
global_connect
check_placement -verbose
check_power_grid -net VDD
check_power_grid -net VSS
write_db detailed.odb
write_def detailed.def
set block [ord::get_db_block]
set dbu [$block getDbUnitsPerMicron]
set f [open physical_cells.tsv w]
puts $f "instance\tmaster\tarea_um2"
foreach inst [$block getInsts] {{
 set master [$inst getMaster]
 set area [expr {{double([$master getWidth])*[$master getHeight]/$dbu/$dbu}}]
 puts $f "[$inst getName]\t[$master getName]\t$area"
}}
close $f
puts PW_FILLED_COMPLETE
''',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
              'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(script)],cwd=folder,env=env,capture_output=True,timeout=120)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'openroad.log').write_text(log,encoding='utf-8')
        passed=p.returncode==0 and 'PW_FILLED_COMPLETE' in log
        save(folder/'RESULT.json',dict(passed=passed,tool_exit_code=p.returncode,source_db_sha256=sha(SOURCE/case/'detailed.odb')))
        if not passed:
            raise RuntimeError('Filler stage failed: '+case)
        print(case+' filler placement PASS',flush=True)


if __name__=='__main__':
    main()
