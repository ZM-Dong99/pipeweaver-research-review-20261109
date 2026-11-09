"""Post-hoc fixed-netlist timing-target scenarios, not new model experiments."""
from concurrent.futures import ThreadPoolExecutor,as_completed
from datetime import datetime
import argparse
import json
import math
import os
from pathlib import Path
import re
import shutil
from run_native_comb import digest,execute,parse_electrical_report

ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'eda/experiments/seq_feedback_arbiter32_20261102_212936_005046'

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',required=True,type=Path)
    args=ap.parse_args()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'));p=load(SOURCE/'protocol.json');x=load(SOURCE/'summary.json')
    out=args.out.resolve()
    if out==SOURCE.resolve() or SOURCE.resolve() in out.parents or out in SOURCE.resolve().parents:
        raise ValueError('Output must be independent of the original evidence tree')
    if out.exists():raise FileExistsError('Output already exists; no overwrite is permitted')
    out.mkdir(parents=True,exist_ok=False);inputs=out/'inputs';inputs.mkdir()
    def save_new(path,payload):
        path.resolve().relative_to(out)
        with path.open('x',encoding='utf-8') as stream:json.dump(payload,stream,indent=2,ensure_ascii=False)
    versions=[dict(id='baseline',arm='baseline',folder=SOURCE/'baseline',metrics=p['baseline_metrics'])]
    versions += [dict(id=r['arm']+'_'+r['candidate_id'],arm=r['arm'],folder=SOURCE/r['arm']/r['candidate_id']/'eda',metrics=r['metrics']) for r in x['results']]
    protected={str(f):digest(f) for f in [SOURCE/'protocol.json',SOURCE/'summary.json',*[Path(v['folder'])/'result.json' for v in versions]]}
    for v in versions:
        assert re.fullmatch(r'[A-Za-z0-9_]+',v['id'])
        assert v['metrics']['formal']==v['metrics']['mapped_formal']==v['metrics']['ppa']=='PASS'
        raw=(v['folder']/'mapped.v').read_text(encoding='utf-8');sta=(v['folder']/'mapped_sta.v').read_text(encoding='utf-8')
        assert digest(v['folder']/'mapped.v')==v['metrics']['mapped_sha256']
        assert re.sub(r'(?m)^(\s*(?:wire|input|output|inout))\s+signed\b',r'\1',raw)==sta
        dest=inputs/(v['id']+'.v');dest.write_text(sta,encoding='utf-8');v['netlist']=str(dest);v['sha256']=digest(dest);v['folder']=str(v['folder'])
    lib=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib';assert digest(lib)==p['library_sha256']
    periods=[10.,2.,1.9];budgets=[0,10,15,20,25,30]
    protocol=dict(scope='Post-hoc engineering target scenarios, same mapped netlists; no new RTL, resynthesis or primary-result changes',source_study=str(SOURCE),source_protocol_sha256=digest(SOURCE/'protocol.json'),versions=versions,periods_ns=periods,budgets_percent=budgets,library_sha256=digest(lib),planned_sta_runs=len(versions)*len(periods),new_model_requests=0)
    save_new(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n',encoding='ascii');shutil.copyfile(Path(__file__),out/'runner_used.py')
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(key,None)
    def wsl(path):
        t=path.resolve().as_posix();return '/mnt/'+t[0].lower()+t[2:]
    print('Experiment: '+str(out),flush=True)
    def run(v,period):
        assert digest(Path(v['netlist']))==v['sha256'];folder=out/'runs'/f'period_{period:g}'/v['id'];folder.resolve().relative_to(out);folder.mkdir(parents=True,exist_ok=False)
        sdc=folder/'timing.sdc'
        sdc.write_text('\n'.join([f'create_clock -name core_clk -period {period} [get_ports {{clk}}]',
            'set data_inputs [get_ports {rst request acknowledge}]',
            'set_input_delay -max 0 -clock core_clk $data_inputs',
            'set_output_delay -max 0 -clock core_clk [all_outputs]',
            'set_input_transition 0.10 $data_inputs','set_load 0.010 [all_outputs]'])+'\n',encoding='ascii')
        tcl=folder/'run_sta.tcl'
        tcl.write_text('\n'.join([f'read_liberty {{{wsl(lib)}}}',f'read_verilog {{{wsl(Path(v["netlist"]))}}}',
            'link_design arbiter',f'read_sdc {{{wsl(sdc)}}}','check_setup',
            'report_checks -path_delay max -format full_clock_expanded -group_path_count 10',
            'report_worst_slack -max','report_tns -max','puts {PW_ELECTRICAL_BEGIN}',
            'report_check_types -max_slew -max_capacitance -violators -digits 6','puts {PW_ELECTRICAL_END}'])+'\n',encoding='utf-8')
        row=dict(id=v['id'],arm=v['arm'],period_ns=period,area_um2=v['metrics']['mapped_area_um2'],sta_status='INCOMPLETE')
        try:
            log=execute(['wsl.exe','-d','Ubuntu','--','/home/easton1/OpenSTA/build/sta','-no_splash','-exit',wsl(tcl)],ROOT,folder/'sta.log',env,60)
            if re.search(r'^\s*(?:Error:|Warning:)',log,re.M|re.I):raise RuntimeError('STA warning/error')
            row['electrical']=parse_electrical_report(log)
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                m=re.search(pattern,log)
                if not m or not math.isfinite(float(m[1])):raise RuntimeError('Missing finite metric')
                row[key]=float(m[1])
            row.update(sta_status='PASS',meets_timing=row['wns_ns']>0 and row['tns_ns']>=0,sta_sha256=digest(folder/'sta.log'),sdc_sha256=digest(sdc))
        except Exception as exc:row['error']=str(exc)
        save_new(folder/'result.json',row);return row
    rows=[]
    with ThreadPoolExecutor(max_workers=2) as pool:
        for f in as_completed([pool.submit(run,v,t) for t in periods for v in versions]):rows.append(f.result())
    rows.sort(key=lambda r:(r['period_ns'],r['id']));selection=[];base_area=p['baseline_metrics']['mapped_area_um2']
    for period in periods:
        for budget in budgets:
            chosen={}
            for arm in p['arms']:
                allowed=[r for r in rows if r['period_ns']==period and r['arm'] in (arm,'baseline') and r['sta_status']=='PASS' and r['electrical']['status']=='PASS' and r['meets_timing'] and r['area_um2']<=base_area*(1+budget/100)+1e-9]
                chosen[arm]=min(allowed,key=lambda r:(r['area_um2'],-r['wns_ns'],r['id'])) if allowed else None
            selection.append(dict(period_ns=period,area_increase_limit_percent=budget,selection=chosen))
    original=[r for r in rows if r['period_ns']==10.]
    assert all(r['sta_status']=='PASS' and r['wns_ns']==next(v['metrics']['wns_ns'] for v in versions if v['id']==r['id']) for r in original)
    assert digest(lib)==p['library_sha256']
    assert all(digest(Path(f))==h for f,h in protected.items()),'Original evidence changed'
    save_new(out/'ORIGINAL_EVIDENCE_UNCHANGED.json',dict(passed=True,source_file_sha256=protected))
    save_new(out/'SUMMARY.json',dict(completed_sta_runs=len(rows),new_model_requests=0,new_candidates=0,original_10ns_reproduced=True,rows=rows,minimum_area_meeting_target=selection))
    print('Actual STA runs: '+str(len(rows))+'; successful measurements: '+str(sum(r['sta_status']=='PASS' for r in rows)),flush=True)
    return 0 if all(r['sta_status']=='PASS' for r in rows) else 1

if __name__=='__main__':raise SystemExit(main())
