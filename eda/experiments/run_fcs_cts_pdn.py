"""Fresh, equal-geometry FCS implementation with CTS, tap cells and PDN."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import time

from route_fcs_detailed import GLOBAL, metrics
from run_fcs_physical import ROOT, SOURCE, PLATFORM, TOOLS, LIB, OPENROAD, wsl, sha, save

PDN_PLATFORM = ROOT/'eda/physical_platforms/sky130hd_cts_pdn_aef47dd6'


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('out',type=Path)
    args = ap.parse_args()
    out = args.out.resolve()
    out.mkdir(exist_ok=False)
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    runtime = json.loads((TOOLS/'RUNTIME.json').read_text())
    pdn_platform = json.loads((PDN_PLATFORM/'PROVENANCE.json').read_text(encoding='utf-8-sig'))
    for record in pdn_platform['files']:
        assert sha(Path(record['path'])) == record['sha256']
    protocol = dict(driver_sha256=sha(Path(__file__)),source_study=str(SOURCE),
        prior_physical_protocol_sha256=sha(GLOBAL/'protocol.json'),
        source_result_sha256=sha(SOURCE/'RESULT.json'),liberty_sha256=sha(LIB),
        openroad_binary_sha256=sha(OPENROAD),runtime_sha256=sha(TOOLS/'RUNTIME.json'),
        platform_sha256=sha(PLATFORM/'PROVENANCE.json'),pdn_platform=pdn_platform,
        scope='Fresh floorplan/taps/PDN/placement/CTS/global and detailed route/OpenRCX; propagated clocks',
        geometry=dict(die=[0,0,130,130],core=[10,10,120,120],density=0.60),
        clock_buffers=['sky130_fd_sc_hd__clkbuf_4','sky130_fd_sc_hd__clkbuf_8','sky130_fd_sc_hd__clkbuf_16'],
        root_buffer='sky130_fd_sc_hd__clkbuf_16',clock_period_ns=10,
        tapcell='sky130_fd_sc_hd__tapvpwrvgnd_1',tap_distance_um=14,
        pdn='Unmodified fixed upstream sky130hd PDN and global connections; check VDD/VSS connectivity',
        routing=dict(signal='met1-met5',clock='met3-met5',capacity_adjustment=0.2,seed=42,iterations=20,threads=2),
        decision='Both complete; zero supported-router DRC; loaded parasitics covered; data/state graph preserved after noninverting clock-buffer contraction; setup WNS strictly improves, hold WNS nonnegative, no setup/hold TNS or electrical violations, total cell area <=110% fresh baseline',
        no_timing_repair_or_data_logic_changes=True,
        limits='No signoff DRC/LVS, GDS, dynamic power or IR-drop claim. Earlier logical RTL initialization scope retained.',
        inputs={case:dict(prepared_sha256=sha(GLOBAL/case/'prepared.v'),sdc_sha256=sha(GLOBAL/case/'timing.sdc')) for case in ('baseline','optimized')},
        new_model_calls=0)
    save(out/'protocol.json',protocol)
    (out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n')
    results = {}
    for case in ('baseline','optimized'):
        folder = out/case
        folder.mkdir()
        tcl = f'''set_thread_count 2
read_lef {{{wsl(PLATFORM/'lef/sky130_fd_sc_hd.tlef')}}}
read_lef {{{wsl(PLATFORM/'lef/sky130_fd_sc_hd_merged.lef')}}}
read_liberty {{{wsl(LIB)}}}
read_verilog {{{wsl(GLOBAL/case/'prepared.v')}}}
link_design axis_eth_fcs
read_sdc {{{wsl(GLOBAL/case/'timing.sdc')}}}
initialize_floorplan -die_area {{0 0 130 130}} -core_area {{10 10 120 120}} -site unithd
source {{{wsl(PLATFORM/'make_tracks.tcl')}}}
source {{{wsl(PLATFORM/'setRC.tcl')}}}
foreach net [[ord::get_db_block] getNets] {{
  if {{[$net getSigType] in {{POWER GROUND}}}} {{
    if {{[$net getITermCount] != 0 || [llength [$net getBTerms]] != 0}} {{error "Unexpected connected imported supply"}}
    odb::dbNet_destroy $net
  }}
}}
set ::env(TAP_CELL_NAME) sky130_fd_sc_hd__tapvpwrvgnd_1
source {{{wsl(PDN_PLATFORM/'tapcell.tcl')}}}
source {{{wsl(PDN_PLATFORM/'global_connect.tcl')}}}
global_connect
source {{{wsl(PDN_PLATFORM/'pdn.tcl')}}}
pdngen -failed_via_report failed_vias.rpt
place_pins -hor_layers met3 -ver_layers met2
global_placement -density 0.60
detailed_placement
check_placement -verbose
estimate_parasitics -placement
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 -buf_list {{sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16}} -sink_clustering_enable -sink_clustering_size 20 -sink_clustering_max_diameter 50
detailed_placement
global_connect
check_placement -verbose
report_cts -out_file cts.rpt
write_db cts_pdn.odb
check_power_grid -net VDD -error_file vdd_errors.rpt
check_power_grid -net VSS -error_file vss_errors.rpt
puts PW_POWER_CONNECTIVITY_COMPLETE
set_propagated_clock [all_clocks]
set_routing_layers -signal met1-met5 -clock met3-met5
set_global_routing_layer_adjustment met1-met5 0.2
global_route -guide_file route.guide -congestion_iterations 50 -verbose
write_db global_routed.odb
detailed_route -output_drc drc.rpt -output_maze maze.log -droute_end_iter 20 -or_seed 42 -verbose 1
write_db detailed.odb
write_def detailed.def
write_verilog -remove_cells {{sky130_fd_sc_hd__tapvpwrvgnd_1}} detailed_signal.v
set block [ord::get_db_block]
set dbu [$block getDbUnitsPerMicron]
set meta [open physical_cells.tsv w]
puts $meta "instance\tmaster\tarea_um2"
foreach inst [$block getInsts] {{
  set master [$inst getMaster]
  set area [expr {{double([$master getWidth])*[$master getHeight]/$dbu/$dbu}}]
  puts $meta "[$inst getName]\t[$master getName]\t$area"
}}
close $meta
set pg [open pg_pins.tsv w]
puts $pg "instance\tpin\ttype\tnet"
foreach inst [$block getInsts] {{
  foreach iterm [$inst getITerms] {{
    set mterm [$iterm getMTerm]
    if {{[$mterm getSigType] in {{POWER GROUND}}}} {{
      set net [$iterm getNet]
      if {{$net == "NULL"}} {{error "Unconnected PG pin"}}
      puts $pg "[$inst getName]\t[$mterm getName]\t[$mterm getSigType]\t[$net getName]"
    }}
  }}
}}
close $pg
report_wire_length -detailed_route -summary
define_process_corner -ext_model_index 0 X
extract_parasitics -ext_model_file {{{wsl(PLATFORM/'sky130_shared_rcx.rules')}}}
write_spef extracted.spef
read_spef extracted.spef
set_propagated_clock [all_clocks]
report_parasitic_annotation -report_unannotated
puts PW_SETUP_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
report_design_area
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_SETUP_END
puts PW_HOLD_BEGIN
report_checks -path_delay min -format full_clock_expanded -group_path_count 5
report_worst_slack -min
report_tns -min
report_clock_skew -setup
puts PW_HOLD_END
puts PW_CTS_PDN_COMPLETE
'''
        (folder/'run.tcl').write_text(tcl,encoding='ascii')
        print('CTS/PDN implementation '+case,flush=True)
        started = time.monotonic()
        try:
            p = subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
                                'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(folder/'run.tcl')],
                               cwd=folder,env=env,capture_output=True,timeout=900)
            log = (p.stdout+p.stderr).decode(errors='replace')
            (folder/'openroad.log').write_text(log,encoding='utf-8')
            r = dict(status='INCOMPLETE',tool_exit_code=p.returncode,elapsed_seconds=round(time.monotonic()-started,3))
            if p.returncode==0 and 'PW_CTS_PDN_COMPLETE' in log:
                r.update(status='CTS_PDN_ROUTED_EXTRACTED',setup=metrics(log,'PW_SETUP_BEGIN','PW_SETUP_END'))
                hold = log.split('PW_HOLD_BEGIN')[1].split('PW_HOLD_END')[0].replace('worst slack min','worst slack max').replace('tns min','tns max')
                r['hold'] = metrics('PW_HOLD_BEGIN'+hold+'PW_HOLD_END','PW_HOLD_BEGIN','PW_HOLD_END')
                r['power_grid_connectivity_passed'] = 'PW_POWER_CONNECTIVITY_COMPLETE' in log
                r['drc_file_empty'] = (folder/'drc.rpt').is_file() and (folder/'drc.rpt').stat().st_size==0
                r['spef_sha256'] = sha(folder/'extracted.spef')
        except subprocess.TimeoutExpired as exc:
            (folder/'openroad.log').write_bytes((exc.stdout or b'')+(exc.stderr or b''))
            r = dict(status='INCOMPLETE',reason='900-second tool timeout')
        results[case] = r
        save(folder/'RESULT.json',r)
        save(out/'RESULT.json',dict(cases=results,new_model_calls=0,full_physical_signoff=False))
        print(json.dumps(dict(case=case,**r)),flush=True)


if __name__ == '__main__':
    main()
