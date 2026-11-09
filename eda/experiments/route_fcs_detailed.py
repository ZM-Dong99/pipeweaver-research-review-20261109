"""Detailed signal routing and actual OpenRCX SPEF, with an ideal clock."""
import json
import os
from pathlib import Path
import re
import subprocess
import time

from run_fcs_physical import ROOT, SOURCE, PLATFORM, TOOLS, LIB, OPENROAD, wsl, sha, save

GLOBAL = ROOT/'eda/experiments/fcs_physical_20261107_initial'
OUT = ROOT/'eda/experiments/fcs_physical_20261107_detailed_empty_supply_fix'


def metrics(log, start, end):
    text = log.split(start)[-1].split(end)[0]
    result = {}
    for name, pattern in [('wns_ns',r'worst slack(?: max)?\s+([-+\d.]+)'),
                          ('tns_ns',r'tns(?: max)?\s+([-+\d.]+)'),
                          ('reported_area_um2',r'Design area\s+([\d.]+)')]:
        match = re.search(pattern,text)
        result[name] = float(match[1]) if match else None
    result['electrical_violation_rows'] = sum('VIOLATED' in line for line in text.splitlines())
    return result


def logical_graph(module):
    """Exact typed-instance/pin-net graph; collapse known tie cells to constants."""
    ties = {}
    for cell in module['cells'].values():
        if cell['type'] == 'sky130_fd_sc_hd__conb_1':
            for pin,value in [('HI','1'),('LO','0')]:
                for bit in cell['connections'].get(pin,[]):
                    if type(bit) is int:
                        ties[bit] = value
    terminals = {}
    def add(bit, terminal):
        bit = ties.get(bit,bit)
        key = ('bit',bit) if type(bit) is int else ('constant',bit)
        terminals.setdefault(key,[]).append(terminal)
    cells = {}
    for name,cell in module['cells'].items():
        if cell['type'] == 'sky130_fd_sc_hd__conb_1':
            continue
        cells[name] = dict(type=cell['type'],parameters=cell['parameters'])
        for pin,bits in cell['connections'].items():
            for i,bit in enumerate(bits):
                add(bit,('cell',name,pin,i))
    ports = {}
    for name,port in module['ports'].items():
        ports[name] = dict(direction=port['direction'],width=len(port['bits']))
        for i,bit in enumerate(port['bits']):
            add(bit,('port',name,i))
    nets = sorted((str(k[1]) if k[0]=='constant' else 'wire',tuple(sorted(v))) for k,v in terminals.items())
    return dict(cells=cells,ports=ports,nets=nets)


def main():
    OUT.mkdir(exist_ok=False)
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    runtime = json.loads((TOOLS/'RUNTIME.json').read_text())
    ld = ':'.join(runtime['library_paths'])
    yosys = Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    protocol = dict(driver_sha256=sha(Path(__file__)),parent_protocol_sha256=sha(GLOBAL/'protocol.json'),
         platform_manifest_sha256=sha(PLATFORM/'PROVENANCE.json'),liberty_sha256=sha(LIB),
         openroad_binary_sha256=sha(OPENROAD),runtime_sha256=sha(TOOLS/'RUNTIME.json'),
         rule_sha256=sha(PLATFORM/'sky130_shared_rcx.rules'),
         scope='Detailed signal routing and OpenRCX extraction; ideal clocks, no CTS, no PDN, no signoff',
         source_initialization='Preserve earlier logical RTL initial-state scope; physical initialization not established',
         same_geometry_and_rules=True,router_iterations=20,router_seed=42,threads=2,
         empty_supply_cleanup='Destroy only POWER/GROUND placeholder nets with exactly zero instance and port terminals; reject any connected supply net',
         decision='Both route without DRCs; full signal graph preserved; all finite metrics; no electrical violations; WNS strictly improves; area <=110% baseline',
         sources={case:dict(db_sha256=sha(GLOBAL/case/'global_routed.odb'),guide_sha256=sha(GLOBAL/case/'route.guide'),
                           sdc_sha256=sha(GLOBAL/case/'timing.sdc'),prepared_sha256=sha(GLOBAL/case/'prepared.json')) for case in ('baseline','optimized')},
         new_model_calls=0)
    save(OUT/'protocol.json',protocol)
    (OUT/'protocol.sha256').write_text(sha(OUT/'protocol.json')+'\n')
    results = {}
    for case in ('baseline','optimized'):
        folder = OUT/case
        folder.mkdir()
        tcl = f'''set_thread_count 2
read_liberty {{{wsl(LIB)}}}
read_db {{{wsl(GLOBAL/case/'global_routed.odb')}}}
read_sdc {{{wsl(GLOBAL/case/'timing.sdc')}}}
source {{{wsl(PLATFORM/'setRC.tcl')}}}
foreach net [[ord::get_db_block] getNets] {{
  if {{[$net getSigType] in {{POWER GROUND}}}} {{
    if {{[$net getITermCount] != 0 || [llength [$net getBTerms]] != 0}} {{
      error "Connected supply net unsupported in this signal-only experiment"
    }}
    puts "Removing empty supply placeholder [$net getName]"
    odb::dbNet_destroy $net
  }}
}}
read_guides {{{wsl(GLOBAL/case/'route.guide')}}}
set_routing_layers -signal met1-met5 -clock met3-met5
detailed_route -output_drc drc.rpt -output_maze maze.log -droute_end_iter 20 -or_seed 42 -verbose 1
write_db detailed.odb
write_def detailed.def
write_verilog detailed.v
report_wire_length -detailed_route -summary
define_process_corner -ext_model_index 0 X
extract_parasitics -ext_model_file {{{wsl(PLATFORM/'sky130_shared_rcx.rules')}}}
write_spef extracted.spef
read_spef extracted.spef
puts PW_EXTRACTED_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
report_design_area
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_EXTRACTED_END
puts PW_DETAILED_COMPLETE
'''
        (folder/'run.tcl').write_text(tcl,encoding='ascii')
        print('Detailed routing '+case,flush=True)
        started = time.monotonic()
        try:
            p = subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+ld,'QT_QPA_PLATFORM=offscreen',
                                wsl(OPENROAD),'-no_init','-exit',wsl(folder/'run.tcl')],cwd=folder,env=env,capture_output=True,timeout=600)
            log = (p.stdout+p.stderr).decode(errors='replace')
            (folder/'openroad.log').write_text(log,encoding='utf-8')
            result = dict(status='INCOMPLETE',tool_exit_code=p.returncode,elapsed_seconds=round(time.monotonic()-started,3))
            if p.returncode == 0 and 'PW_DETAILED_COMPLETE' in log and (folder/'extracted.spef').is_file():
                result.update(status='DETAILED_ROUTE_AND_EXTRACTION_COMPLETE',**metrics(log,'PW_EXTRACTED_BEGIN','PW_EXTRACTED_END'))
                drc = (folder/'drc.rpt').read_text() if (folder/'drc.rpt').is_file() else None
                result['drc_file_empty'] = drc == ''
                result['spef_sha256'] = sha(folder/'extracted.spef')
                result['spef_bytes'] = (folder/'extracted.spef').stat().st_size
                script = folder/'check_graph.ys'
                script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog detailed.v\nhierarchy -check -top axis_eth_fcs\nwrite_json routed.json\n')
                check = subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=60)
                (folder/'check_graph.log').write_bytes(check.stdout+check.stderr)
                result['graph_parse_passed'] = check.returncode == 0
                if check.returncode == 0:
                    before = json.loads((GLOBAL/case/'prepared.json').read_text())['modules']['axis_eth_fcs']
                    after = json.loads((folder/'routed.json').read_text())['modules']['axis_eth_fcs']
                    a,b = logical_graph(before),logical_graph(after)
                    result['exact_logical_graph_preserved'] = a == b
                    save(folder/'GRAPH_CHECK.json',dict(passed=a==b,cell_count_before=len(a['cells']),cell_count_after=len(b['cells']),
                         ports_equal=a['ports']==b['ports'],typed_instances_equal=a['cells']==b['cells'],pin_net_graph_equal=a['nets']==b['nets'],
                         scope='Exact original instance types and pin-net graph, known tie constants normalized; no state or output assumptions'))
            global_log = (GLOBAL/case/'openroad.log').read_text()
            result['global_route_estimated'] = metrics(global_log,'PW_GLOBAL_ROUTE_BEGIN','PW_GLOBAL_ROUTE_END')
        except subprocess.TimeoutExpired as exc:
            (folder/'openroad.log').write_bytes((exc.stdout or b'')+(exc.stderr or b''))
            result = dict(status='INCOMPLETE',reason='600-second timeout')
        results[case] = result
        save(folder/'RESULT.json',result)
        save(OUT/'RESULT.json',dict(cases=results,new_model_calls=0,clock_model='ideal',cts=False,pdn=False,full_physical_signoff=False))
        print(json.dumps(dict(case=case,**result)),flush=True)


if __name__ == '__main__':
    main()
