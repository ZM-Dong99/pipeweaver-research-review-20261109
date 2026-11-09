"""Fixed-netlist byte FCS physical data-path comparison; ideal clock, no CTS."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time

from integrate_crc_fcs import ROOT, OUT as SOURCE, sha, save

PLATFORM = ROOT/'eda/physical_platforms/sky130hd_orfs_aef47dd6'
TOOLS = ROOT/'eda/tools/openroad_26Q2_20261107'
LIB = ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
OPENROAD = TOOLS/'extracted/usr/bin/openroad'
LD_PATH = ':'.join(w for w in (
    '/mnt/d/verilog_lab/PipeWeaver/eda/tools/openroad_26Q2_20261107/runtime/usr/lib/x86_64-linux-gnu',
    '/mnt/d/verilog_lab/PipeWeaver/eda/tools/openroad_26Q2_20261107/runtime/usr/lib/tcltk/x86_64-linux-gnu/tclreadline2.3.8',
    '/mnt/d/verilog_lab/PipeWeaver/eda/tools/openroad_26Q2_20261107/extracted/opt/or-tools/lib'))


def wsl(p):
    text = p.resolve().as_posix()
    return '/mnt/'+text[0].lower()+text[2:]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('out',type=Path)
    args = ap.parse_args()
    out = args.out.resolve()
    out.mkdir(exist_ok=False)
    env = os.environ.copy()
    for name in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(name,None)
    yosys = Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    runtime = json.loads((TOOLS/'RUNTIME.json').read_text())
    assert runtime['status'] == 'PASS'
    library_path = ':'.join(runtime['library_paths'])
    provenance = json.loads((PLATFORM/'PROVENANCE.json').read_text(encoding='utf-8-sig'))
    for entry in provenance['files']:
        assert sha(Path(entry['path'])) == entry['sha256']
    protocol = dict(scope='Fixed mapped logic: placement and signal routing, ideal clocks, no CTS, no PDN or signoff',
        source_study=str(SOURCE),source_result_sha256=sha(SOURCE/'RESULT.json'),
        driver_sha256=sha(Path(__file__)),liberty_sha256=sha(LIB),physical_platform=provenance,
        openroad_binary_sha256=sha(OPENROAD),runtime_manifest_sha256=sha(TOOLS/'RUNTIME.json'),clock_period_ns=10,
        die_um=[0,0,130,130],core_um=[10,10,120,120],place_density=0.60,
        geometry_scope='Identical absolute die/core for both; actual cell utilization differs with measured area',
        pin_placement='OpenROAD deterministic pin placer, met3 horizontal / met2 vertical',
        placement='Same deterministic non-timing-driven global and detailed placement; 2 threads',
        routing='met1-met5, clock met3-met5, global capacity adjustment 0.2',
        rc_scope='Global-route estimated RC, then attempt detailed-route and OpenRCX extraction; report stages separately',
        initial_state_scope='Physical timing experiment does not establish physical power-up values; retain source-study logical initial-state qualification',
        decision='Both stages complete, no electrical violations, optimized WNS strictly higher and area <= 110% baseline',
        repair_or_resizing=False,new_model_calls=0)
    save(out/'protocol.json',protocol)
    (out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n')
    results = {}
    for case in ('baseline','optimized'):
        folder = out/case
        folder.mkdir()
        source = SOURCE/case/'evaluation/mapped.v'
        shutil.copyfile(source,folder/'original_mapped.v')
        shutil.copyfile(SOURCE/case/'evaluation/timing.sdc',folder/'timing.sdc')
        script = folder/'prepare.ys'
        script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog "{source.as_posix()}"\nhierarchy -check -top axis_eth_fcs\nhilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO\nclean\nwrite_verilog -noattr prepared.v\nwrite_json prepared.json\n')
        p = subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=60)
        (folder/'prepare.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Netlist preparation failed '+case)
        tcl = f'''set_thread_count 2
read_lef {{{wsl(PLATFORM/'lef/sky130_fd_sc_hd.tlef')}}}
read_lef {{{wsl(PLATFORM/'lef/sky130_fd_sc_hd_merged.lef')}}}
read_liberty {{{wsl(LIB)}}}
read_verilog prepared.v
link_design axis_eth_fcs
read_sdc timing.sdc
initialize_floorplan -die_area {{0 0 130 130}} -core_area {{10 10 120 120}} -site unithd
source {{{wsl(PLATFORM/'make_tracks.tcl')}}}
source {{{wsl(PLATFORM/'setRC.tcl')}}}
place_pins -hor_layers met3 -ver_layers met2
global_placement -density 0.60
detailed_placement
check_placement -verbose
write_db placed.odb
estimate_parasitics -placement
puts PW_PLACEMENT_BEGIN
report_worst_slack -max
report_tns
report_design_area
puts PW_PLACEMENT_END
set_routing_layers -signal met1-met5 -clock met3-met5
set_global_routing_layer_adjustment met1-met5 0.2
global_route -guide_file route.guide -congestion_iterations 50 -verbose
estimate_parasitics -global_routing
puts PW_GLOBAL_ROUTE_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns
report_design_area
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_GLOBAL_ROUTE_END
write_db global_routed.odb
write_def global_routed.def
write_verilog global_routed.v
write_spef global_estimated.spef
puts PW_GLOBAL_ROUTE_COMPLETE
'''
        (folder/'run.tcl').write_text(tcl,encoding='ascii')
        print('Physical evaluation '+case,flush=True)
        started = time.monotonic()
        try:
            p = subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+library_path,
                                'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(folder/'run.tcl')],
                               cwd=folder,env=env,capture_output=True,timeout=600)
            log = (p.stdout+p.stderr).decode(errors='replace')
            (folder/'openroad.log').write_text(log,encoding='utf-8')
            result = dict(status='INCOMPLETE',tool_exit_code=p.returncode,elapsed_seconds=round(time.monotonic()-started,3))
            if p.returncode == 0 and 'PW_GLOBAL_ROUTE_COMPLETE' in log:
                section = log.split('PW_GLOBAL_ROUTE_BEGIN')[1].split('PW_GLOBAL_ROUTE_END')[0]
                def metric(pattern):
                    match = re.search(pattern,section)
                    return float(match[1]) if match else None
                result.update(status='GLOBAL_ROUTE_COMPLETE',wns_ns=metric(r'worst slack\s+([-+\d.]+)'),
                              tns_ns=metric(r'tns\s+([-+\d.]+)'),
                              area_um2=metric(r'Design area\s+([\d.]+)'),
                              parasitics='global_route_estimated',clock='ideal')
        except subprocess.TimeoutExpired as exc:
            (folder/'openroad.log').write_bytes((exc.stdout or b'')+(exc.stderr or b''))
            result = dict(status='INCOMPLETE',reason='600-second tool timeout')
        save(folder/'RESULT.json',result)
        results[case] = result
        save(out/'RESULT.json',dict(cases=results,new_model_calls=0,full_physical_signoff=False))
        print(json.dumps(dict(case=case,**result)),flush=True)


if __name__ == '__main__':
    main()
