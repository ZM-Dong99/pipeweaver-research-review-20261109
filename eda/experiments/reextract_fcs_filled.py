"""Re-extract and time the filled layouts with propagated clocks."""
import json
import os
from pathlib import Path
import subprocess
from fill_fcs_layout import ROOT, OUT, SOURCE, PLATFORM, LIB, TOOLS, OPENROAD, wsl, sha, save
from route_fcs_detailed import metrics


def main():
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    sdc_root=ROOT/'eda/experiments/fcs_reset_complete_20261107_induction_fixed/physical_inputs'
    results={}
    for case in ('baseline','optimized'):
        folder=OUT/case
        tcl=folder/'extract.tcl'
        tcl.write_text(f'''read_liberty {{{wsl(LIB)}}}
read_db {{{wsl(folder/'detailed.odb')}}}
read_sdc {{{wsl(sdc_root/case/'timing.sdc')}}}
source {{{wsl(PLATFORM/'setRC.tcl')}}}
set_propagated_clock [all_clocks]
define_process_corner -ext_model_index 0 X
extract_parasitics -ext_model_file {{{wsl(PLATFORM/'sky130_shared_rcx.rules')}}}
write_spef filled.spef
read_spef filled.spef
puts PW_SETUP_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 5
report_worst_slack -max
report_tns -max
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_SETUP_END
puts PW_HOLD_BEGIN
report_worst_slack -min
report_tns -min
puts PW_HOLD_END
puts PW_EXTRACTED_COMPLETE
''',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
            'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(tcl)],cwd=folder,env=env,capture_output=True,timeout=180)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'extract.log').write_text(log,encoding='utf-8')
        setup=metrics(log,'PW_SETUP_BEGIN','PW_SETUP_END')
        hold_text=log.split('PW_HOLD_BEGIN')[-1].split('PW_HOLD_END')[0].replace('worst slack min','worst slack max').replace('tns min','tns max')
        hold=metrics('PW_HOLD_BEGIN'+hold_text+'PW_HOLD_END','PW_HOLD_BEGIN','PW_HOLD_END')
        passed=p.returncode==0 and 'PW_EXTRACTED_COMPLETE' in log and all(isinstance(r['wns_ns'],(int,float)) and r['wns_ns']>=0 and r['tns_ns']==0 for r in (setup,hold)) and setup['electrical_violation_rows']==0
        results[case]=dict(passed=passed,setup=setup,hold=hold,tool_exit_code=p.returncode,
            source_db_sha256=sha(folder/'detailed.odb'),spef_sha256=sha(folder/'filled.spef') if (folder/'filled.spef').exists() else None,
            scope='New RC extraction after fillers; propagated-clock OpenROAD STA, separate earlier independent-STA evidence retained')
        print(case+' filled extraction '+str(passed),flush=True)
    save(OUT/'REEXTRACTION.json',dict(passed=all(r['passed'] for r in results.values()),cases=results,new_model_calls=0))


if __name__=='__main__':
    main()
