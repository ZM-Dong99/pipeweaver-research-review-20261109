"""Contract noninverting CTS wires and verify unchanged FCS plus independent STA."""
import argparse
import copy
import csv
import json
import os
from pathlib import Path
import re
import subprocess

from route_fcs_detailed import logical_graph, metrics
from run_fcs_reset_cts_pdn import GLOBAL
from run_fcs_physical import ROOT, LIB, wsl, sha, save
from finalize_fcs_physical import unannotated_coverage


def normalize_clock(original, routed, modules):
    routed=copy.deepcopy(routed)
    pg_ports={n:p for n,p in routed['ports'].items() if n not in original['ports']}
    assert set(pg_ports)=={'VDD','VSS'}, 'Unexpected additional ports'
    pg_bits={bit for p in pg_ports.values() for bit in p['bits']}
    assert all(p['direction']=='inout' and len(p['bits'])==1 for p in pg_ports.values())
    assert not any(bit in pg_bits for c in routed['cells'].values() for bits in c['connections'].values() for bit in bits), 'PG port used in digital signal logic'
    for name in pg_ports:
        del routed['ports'][name]
    original_cells = original['cells']
    added = set(routed['cells'])-set(original_cells)
    assert set(original_cells)<=set(routed['cells']), 'Original instance removed'
    assert original['ports'].keys()==routed['ports'].keys(), 'Ports changed'
    clock = routed['ports']['clk']['bits'][0]
    clock_bits = {clock}
    buffer_types = {'sky130_fd_sc_hd__clkbuf_'+str(n) for n in (4,8,16)}
    libtext = LIB.read_text()
    for kind in buffer_types:
        block = libtext.split('cell ("'+kind+'") {',1)[1].split('\n    cell (',1)[0]
        functions=re.findall(r'(?m)^\s*function\s*:\s*"([^"]+)"',block)
        assert functions in (['A'],['(A)']), 'Buffer function not the expected identity'
    buffers = {n:routed['cells'][n] for n in added if routed['cells'][n]['type'] in buffer_types and routed['cells'][n]['connections'].get('X')}
    pending = dict(buffers)
    while pending:
        ready = []
        for name,cell in pending.items():
            assert set(cell['connections'])=={'A','X'}, 'Unexpected buffer pins'
            assert len(cell['connections']['A'])==len(cell['connections']['X'])==1
            if cell['connections']['A'][0] in clock_bits:
                clock_bits.add(cell['connections']['X'][0])
                ready.append(name)
        assert ready, 'Clock buffer not reachable from clk or cyclic clock tree'
        for name in ready:
            del pending[name]
    loads = {}
    for cell in routed['cells'].values():
        for pin,bits in cell['connections'].items():
            if cell['port_directions'][pin]=='input':
                for bit in bits:
                    loads[bit]=loads.get(bit,0)+1
    for port in routed['ports'].values():
        if port['direction']=='output':
            for bit in port['bits']:
                loads[bit]=loads.get(bit,0)+1
    dummy_types={'sky130_fd_sc_hd__bufinv_16','sky130_fd_sc_hd__clkinv_2','sky130_fd_sc_hd__clkinv_4','sky130_fd_sc_hd__inv_6'} | buffer_types
    dummy = {}
    for name in added-set(buffers):
        cell = routed['cells'][name]
        assert cell['type'] in dummy_types or re.fullmatch(r'sky130_fd_sc_hd__(?:bufinv|clkinv|clkinvlp|inv)_[1-9][0-9]*',cell['type']), 'Unexpected newly inserted cell: '+cell['type']
        for pin,bits in cell['connections'].items():
            if cell['port_directions'][pin]=='input':
                assert all(bit in clock_bits for bit in bits), 'Dummy driven by nonclock signal'
            else:
                assert all(loads.get(bit,0)==0 for bit in bits), 'Dummy output has logical load'
        dummy[name]=cell['type']
    normalized = copy.deepcopy(routed)
    for name in added:
        del normalized['cells'][name]
    for cell in normalized['cells'].values():
        for pin,bits in cell['connections'].items():
            cell['connections'][pin]=[clock if bit in clock_bits else bit for bit in bits]
    return normalized,dict(clock_buffer_instances={n:c['type'] for n,c in buffers.items()},
                           unloaded_clock_dummy_instances=dummy,clock_tree_nets=len(clock_bits),
                           identity_clock_buffer_functions_checked=True,
                           additional_power_ports_checked_and_separated=sorted(pg_ports),
                           scope='Only positive identity clock buffers contracted; all added dummy outputs proven unloaded. Actual delays retained in separate propagated-clock STA.')


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('out',type=Path)
    args=ap.parse_args()
    out=args.out.resolve()
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    yosys=Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    results={}
    for case in ('baseline','optimized'):
        folder=out/case
        implementation=json.loads((folder/'RESULT.json').read_text())
        assert implementation['status']=='CTS_PDN_ROUTED_EXTRACTED'
        script=folder/'parse_graphs.ys'
        script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog "{(GLOBAL/case/"prepared.v").as_posix()}"\nhierarchy -check -top axis_eth_fcs_reset\nwrite_json original.json\ndesign -reset\nread_liberty -lib "{LIB.as_posix()}"\nread_verilog detailed_signal.v\nhierarchy -check -top axis_eth_fcs_reset\nwrite_json routed.json\ndelete axis_eth_fcs_reset/w:VDD axis_eth_fcs_reset/w:VSS\nwrite_verilog -noattr timing_signal.v\nwrite_json timing.json\n')
        p=subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/'parse_graphs.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Graph parsing failed: '+case)
        original=json.loads((folder/'original.json').read_text())['modules']['axis_eth_fcs_reset']
        modules=json.loads((folder/'routed.json').read_text())['modules']
        routed=modules['axis_eth_fcs_reset']
        normalized,clock=normalize_clock(original,routed,modules)
        checks=dict(normalized_data_state_graph_equal=logical_graph(original)==logical_graph(normalized),
                    original_instances_preserved=set(original['cells'])<=set(routed['cells']))
        save(folder/'CLOCK_GRAPH.json',dict(passed=all(checks.values()),checks=checks,**clock))
        tcl=folder/'independent_sta.tcl'
        tcl.write_text(f'''read_liberty {{{wsl(LIB)}}}
read_verilog {{{wsl(folder/'timing_signal.v')}}}
link_design axis_eth_fcs_reset
read_sdc {{{wsl(GLOBAL/case/'timing.sdc')}}}
read_spef {{{wsl(folder/'extracted.spef')}}}
set_propagated_clock [all_clocks]
report_parasitic_annotation -report_unannotated
check_setup
puts PW_SETUP_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_SETUP_END
puts PW_HOLD_BEGIN
report_worst_slack -min
report_tns -min
report_clock_skew -setup
puts PW_HOLD_END
''',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','/home/easton1/OpenSTA/build/sta','-no_splash','-exit',wsl(tcl)],
                         cwd=ROOT,env=env,capture_output=True,timeout=120)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'independent_sta.log').write_text(log,encoding='utf-8')
        setup=metrics(log,'PW_SETUP_BEGIN','PW_SETUP_END')
        hold_text=log.split('PW_HOLD_BEGIN')[-1].split('PW_HOLD_END')[0].replace('worst slack min','worst slack max').replace('tns min','tns max')
        hold=metrics('PW_HOLD_BEGIN'+hold_text+'PW_HOLD_END','PW_HOLD_BEGIN','PW_HOLD_END')
        timing_modules=json.loads((folder/'timing.json').read_text())['modules']
        timing=timing_modules['axis_eth_fcs_reset']
        expected=copy.deepcopy(routed)
        del expected['ports']['VDD']
        del expected['ports']['VSS']
        checks['timing_view_only_removes_disconnected_pg_ports']=logical_graph(expected)==logical_graph(timing)
        coverage=unannotated_coverage(timing,log,timing_modules)
        save(folder/'ANNOTATION_COVERAGE.json',coverage)
        checks.update(independent_sta_exit_zero=p.returncode==0,complete_marker='PW_HOLD_END' in log,
                      no_sta_errors=not any(line.lstrip().startswith(('Error:','[ERROR')) for line in log.splitlines()),
                      setup_wns_matches=setup['wns_ns']==implementation['setup']['wns_ns'],
                      hold_wns_matches=hold['wns_ns']==implementation['hold']['wns_ns'],
                      setup_tns_matches=setup['tns_ns']==implementation['setup']['tns_ns'],
                      hold_tns_matches=hold['tns_ns']==implementation['hold']['tns_ns'],
                      electrical_clean=setup['electrical_violation_rows']==0,
                      loaded_parasitic_coverage=coverage['passed'])
        with (folder/'physical_cells.tsv').open() as f:
            physical=list(csv.DictReader(f,delimiter='\t'))
        with (folder/'pg_pins.tsv').open() as f:
            pg=list(csv.DictReader(f,delimiter='\t'))
        pg_by_inst={}
        for pin in pg:
            pg_by_inst.setdefault(pin['instance'],set()).add(pin['type'])
        checks['all_power_pins_on_expected_nets']=all(p['net']=={'POWER':'VDD','GROUND':'VSS'}[p['type']] for p in pg)
        checks['every_physical_cell_has_both_supplies']=set(pg_by_inst)=={c['instance'] for c in physical} and all(v=={'POWER','GROUND'} for v in pg_by_inst.values())
        results[case]=dict(passed=all(checks.values()),checks=checks,setup=setup,hold=hold,
            physical_cell_area_um2=round(sum(float(c['area_um2']) for c in physical),4),physical_cell_count=len(physical),
            tap_count=sum(c['master']=='sky130_fd_sc_hd__tapvpwrvgnd_1' for c in physical),
            clock_buffer_count=len(clock['clock_buffer_instances']),clock_dummy_count=len(clock['unloaded_clock_dummy_instances']),
            power_ground_pin_count=len(pg),spef_sha256=sha(folder/'extracted.spef'))
        save(folder/'VERIFICATION.json',results[case])
        print(case+' verification: '+str(results[case]['passed']),flush=True)
    save(out/'VERIFICATION.json',dict(passed=all(r['passed'] for r in results.values()),cases=results,
                                    driver_sha256=sha(Path(__file__)),new_model_calls=0))


if __name__=='__main__':
    main()
