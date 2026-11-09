"""Re-read detailed-route SPEF in the project's separate OpenSTA installation."""
import json
import os
from pathlib import Path
import subprocess

from route_fcs_detailed import OUT, GLOBAL, ROOT, LIB, wsl, sha, save, metrics


def main():
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    results = {}
    for case in ('baseline','optimized'):
        folder = OUT/case
        result = json.loads((folder/'RESULT.json').read_text())
        assert result['status'] == 'DETAILED_ROUTE_AND_EXTRACTION_COMPLETE'
        script = folder/'independent_sta.tcl'
        script.write_text(f'''read_liberty {{{wsl(LIB)}}}
read_verilog {{{wsl(folder/'detailed.v')}}}
link_design axis_eth_fcs
read_sdc {{{wsl(GLOBAL/case/'timing.sdc')}}}
read_spef {{{wsl(folder/'extracted.spef')}}}
report_parasitic_annotation -report_unannotated
check_setup
puts PW_INDEPENDENT_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_INDEPENDENT_END
''',encoding='ascii')
        p = subprocess.run(['wsl.exe','-d','Ubuntu','--','/home/easton1/OpenSTA/build/sta','-no_splash','-exit',wsl(script)],
                           cwd=ROOT,env=env,capture_output=True,timeout=120)
        log = (p.stdout+p.stderr).decode(errors='replace')
        (folder/'independent_sta.log').write_text(log,encoding='utf-8')
        m = metrics(log,'PW_INDEPENDENT_BEGIN','PW_INDEPENDENT_END')
        checks = dict(tool_exit_zero=p.returncode==0,wns_matches=m['wns_ns']==result['wns_ns'],
                      tns_matches=m['tns_ns']==result['tns_ns'],electrical_clean=m['electrical_violation_rows']==0,
                      timing_path_present='Endpoint:' in log,complete_marker='PW_INDEPENDENT_END' in log,
                      no_error_lines=not any(line.lstrip().startswith(('Error:','[ERROR')) for line in log.splitlines()))
        results[case] = dict(passed=all(checks.values()),checks=checks,metrics=m,
                             spef_sha256=sha(folder/'extracted.spef'))
        print(case+' independent STA: '+str(results[case]['passed']),flush=True)
    save(OUT/'INDEPENDENT_STA.json',dict(passed=all(r['passed'] for r in results.values()),cases=results,new_model_calls=0,
                                       driver_sha256=sha(Path(__file__))))


if __name__ == '__main__':
    main()
