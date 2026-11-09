"""Post-hoc fixed-netlist IO sensitivity on all previously returned RTL versions.

No LLM calls, new RTL, resynthesis, or added independent design samples.
"""
from concurrent.futures import ThreadPoolExecutor,as_completed
from datetime import datetime
import argparse
import json
import math
import os
from pathlib import Path
import re
import shutil
from run_native_comb import digest,execute,parse_electrical_report,save

ROOT=Path(__file__).resolve().parents[2]
PRIOR=ROOT/'eda/experiments/timing_feedback_ablation_priority256_20261102_193927_399076'

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--include-study',type=Path,action='append',default=[],help='Additional completed priority256 study; baseline and constraints must match')
    args=ap.parse_args()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    prior=load(PRIOR/'protocol.json');summary=load(PRIOR/'summary.json')
    out=ROOT/'eda/experiments'/datetime.now().strftime('priority256_io_sensitivity_%Y%m%d_%H%M%S_%f');out.mkdir()
    inputs=out/'inputs';inputs.mkdir();versions=[]
    entries=[('baseline','baseline',PRIOR/'baseline/evaluation/eda',prior['baseline_metrics'])]
    studies=[PRIOR]+[p.resolve() for p in args.include_study]
    assert len(set(studies))==len(studies),'Duplicate study'
    for index,study in enumerate(studies,1):
        rec=load(study/'protocol.json')
        assert all(rec[k]==prior[k] for k in ('baseline_sha256','liberty_sha256','top','parameter_overrides','mapping_policy','abc_cleanup_before_buffer'))
        for slot in rec['call_schedule']:
            folder=study/slot['arm']/slot['candidate_id'];r=load(folder/'result.json')
            if r.get('candidate_sha256'):
                m=r['metrics'];assert m['formal']==m['mapped_formal']==m['ppa']=='PASS'
                name=(f'study{index}_' if len(studies)>1 else '')+slot['arm']+'_'+slot['candidate_id']
                entries.append((name,slot['arm'],folder/'evaluation/eda',m))
    for name,arm,folder,m in entries:
        source=folder/'mapped_sta.v';assert digest(source)==m['sta_netlist_sha256']
        target=inputs/(name+'.v');shutil.copyfile(source,target)
        versions.append(dict(id=name,arm=arm,netlist=str(target),netlist_sha256=digest(target),
            original_evidence=str(folder),original_metrics=m,area_um2=m['mapped_area_um2']))
    lib=Path(prior['tool_conditions']['liberty']);assert digest(lib)==prior['liberty_sha256']
    frozenlib=inputs/'frozen.lib';shutil.copyfile(lib,frozenlib)
    conditions=[dict(id=f'slew{slew:.2f}_load{cap:.3f}',input_transition_ns=slew,output_load_pf=cap)
                for slew in (.05,.10,.20) for cap in (.005,.010,.020)]
    snapshot=out/'code_snapshot';snapshot.mkdir()
    for file in [Path(__file__),Path(__file__).with_name('run_native_comb.py')]:shutil.copyfile(file,snapshot/file.name)
    protocol=dict(scope='Post-hoc robustness check of fixed mapped netlists, not new candidates, model samples, or per-condition resynthesis',
       source_study=str(PRIOR),source_protocol_sha256=digest(PRIOR/'protocol.json'),versions=versions,conditions=conditions,
       all_source_studies=[dict(path=str(p),protocol_sha256=digest(p/'protocol.json')) for p in studies],
       frozen_library=str(frozenlib),library_sha256=digest(frozenlib),period_ns=100,timeout_seconds=60,workers=2,
       planned_sta_runs=len(versions)*len(conditions),llm_requests=0,
       area_caps_for_derived_selection=[1.05,1.10,1.15],original_mapping_output_load_pf=.010,
       runner_sha256=digest(Path(__file__)))
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n',encoding='ascii')
    print('Experiment: '+str(out),flush=True)
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(key,None)
    def wsl(p):
        text=p.resolve().as_posix();return '/mnt/'+text[0].lower()+text[2:]
    def verify():
        assert digest(frozenlib)==protocol['library_sha256']
        assert all(digest(Path(x['netlist']))==x['netlist_sha256'] for x in versions)
    execute(['wsl.exe','-d','Ubuntu','--','/home/easton1/OpenSTA/build/sta','-version'],ROOT,out/'opensta_version.log',env,30)
    def run(version,condition):
        verify();folder=out/'runs'/condition['id']/version['id'];folder.mkdir(parents=True)
        sdc=folder/'timing.sdc';sdc.write_text('\n'.join(['create_clock -name virtual_clk -period 100.0',
            'set_input_delay -max 0.0 -clock virtual_clk [all_inputs]',
            'set_output_delay -max 0.0 -clock virtual_clk [all_outputs]',
            f'set_input_transition {condition["input_transition_ns"]:.2f} [all_inputs]',
            f'set_load {condition["output_load_pf"]:.3f} [all_outputs]'])+'\n',encoding='ascii')
        tcl=folder/'run_sta.tcl';tcl.write_text('\n'.join([f'read_liberty {{{wsl(frozenlib)}}}',
            f'read_verilog {{{wsl(Path(version["netlist"]))}}}','link_design priority_encoder',f'read_sdc {{{wsl(sdc)}}}',
            'report_checks -path_delay max -format full_clock_expanded -group_path_count 10',
            'report_worst_slack -max','report_tns -max','puts {PW_ELECTRICAL_BEGIN}',
            'report_check_types -max_slew -max_capacitance -violators -digits 6','puts {PW_ELECTRICAL_END}'])+'\n',encoding='utf-8')
        row=dict(version=version['id'],arm=version['arm'],condition=condition,status='INCOMPLETE',area_um2=version['area_um2'],netlist_sha256=version['netlist_sha256'])
        try:
            text=execute(['wsl.exe','-d','Ubuntu','--','/home/easton1/OpenSTA/build/sta','-no_splash','-exit',wsl(tcl)],ROOT,folder/'sta.log',env,60)
            if re.search(r'^\s*(?:Error:|Warning:)',text,re.M|re.I):raise RuntimeError('STA warning/error, inspect original log')
            row['electrical']=parse_electrical_report(text)
            for key,pattern in [('arrival_ns',r'([-+\d.]+)\s+data arrival time'),('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                match=re.search(pattern,text)
                if not match or not math.isfinite(float(match[1])):raise RuntimeError('Missing finite timing metric')
                row[key]=float(match[1])
            row.update(status='PASS',electrically_eligible=row['electrical']['status']=='PASS',sta_sha256=digest(folder/'sta.log'),sdc_sha256=digest(sdc))
        except Exception as exc:row['error']=str(exc)
        save(folder/'result.json',row);return row
    results=[]
    with ThreadPoolExecutor(max_workers=2) as pool:
        futures=[pool.submit(run,v,c) for c in conditions for v in versions]
        for f in as_completed(futures):
            results.append(f.result())
            if len(results)%5==0:print('Actual STA completed: '+str(len(results))+'/'+str(protocol['planned_sta_runs']),flush=True)
    verify();results.sort(key=lambda x:(x['condition']['id'],x['version']))
    comparisons=[];base_area=versions[0]['area_um2']
    for c in conditions:
        rows=[r for r in results if r['condition']==c]
        for cap in protocol['area_caps_for_derived_selection']:
            selected={}
            for arm in ('no_timing_feedback','actual_paths'):
                allowed=[r for r in rows if r['arm'] in ('baseline',arm) and r['status']=='PASS' and r['electrically_eligible'] and r['area_um2']<=base_area*cap+1e-9]
                selected[arm]=min(allowed,key=lambda r:(r['arrival_ns'],r['area_um2'],r['version'])) if allowed else None
            comparisons.append(dict(condition=c,area_ratio_limit=cap,selected=selected))
    original=[]
    for r in results:
        if r['condition']['input_transition_ns']==.10 and r['condition']['output_load_pf']==.010:
            old=next(v['original_metrics'] for v in versions if v['id']==r['version'])
            original.append(dict(version=r['version'],passed=r['status']=='PASS' and r['arrival_ns']==old['max_data_arrival_ns'] and r['wns_ns']==old['wns_ns'] and r['electrical']==old['electrical']))
    save(out/'SUMMARY.json',dict(completed_sta_runs=len(results),planned_sta_runs=protocol['planned_sta_runs'],
        passed_sta_runs=sum(r['status']=='PASS' for r in results),llm_requests=0,new_candidate_count=0,
        original_condition_reproduction=original,results=results,derived_selections=comparisons))
    print('Saved '+str(len(results))+' actual STA runs; original-condition reproduction '+str(all(x['passed'] for x in original)),flush=True)
    return 0 if all(r['status']=='PASS' for r in results) and all(x['passed'] for x in original) else 1

if __name__=='__main__':raise SystemExit(main())
