"""Audit fixed-netlist STA sweeps from raw logs and actual SDC, no tool reruns."""
import argparse
from pathlib import Path
import json
import re
from run_native_comb import digest,parse_electrical_report,save

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'));p=load(s/'protocol.json');x=load(s/'SUMMARY.json');checks=[]
    def check(k,v):checks.append(dict(check=k,passed=bool(v)))
    check('protocol hash',digest(s/'protocol.json')==(s/'protocol.sha256').read_text().strip())
    check('frozen library',digest(Path(p['frozen_library']))==p['library_sha256'])
    check('complete unique rows',len(x['results'])==p['planned_sta_runs'] and len({(z['condition']['id'],z['version']) for z in x['results']})==p['planned_sta_runs'])
    check('zero new candidates or requests',x['llm_requests']==x['new_candidate_count']==0)
    for v in p['versions']:check('frozen netlist '+v['id'],digest(Path(v['netlist']))==v['netlist_sha256'])
    for row in x['results']:
        folder=s/'runs'/row['condition']['id']/row['version'];sta=(folder/'sta.log').read_text(encoding='utf-8');sdc=(folder/'timing.sdc').read_text();key=row['condition']['id']+'/'+row['version']
        check(key+' actual metrics',load(folder/'result.json')==row and row['status']=='PASS')
        check(key+' actual load',f'set_load {row["condition"]["output_load_pf"]:.3f} [all_outputs]' in sdc)
        check(key+' actual transition',f'set_input_transition {row["condition"]["input_transition_ns"]:.2f} [all_inputs]' in sdc)
        check(key+' raw arrival',float(re.search(r'([-+\d.]+)\s+data arrival time',sta)[1])==row['arrival_ns'])
        check(key+' electrical raw',parse_electrical_report(sta)==row['electrical'])
        check(key+' log hashes',digest(folder/'sta.log')==row['sta_sha256'] and digest(folder/'timing.sdc')==row['sdc_sha256'])
    check('original settings reproduced',len(x['original_condition_reproduction'])==len(p['versions']) and all(z['passed'] for z in x['original_condition_reproduction']))
    baseline_area=p['versions'][0]['area_um2']
    for item in x['derived_selections']:
        for arm,selected in item['selected'].items():
            allowed=[z for z in x['results'] if z['condition']==item['condition'] and z['arm'] in ('baseline',arm) and z['status']=='PASS' and z['electrically_eligible'] and z['area_um2']<=baseline_area*item['area_ratio_limit']+1e-9]
            expected=min(allowed,key=lambda z:(z['arrival_ns'],z['area_um2'],z['version'])) if allowed else None
            check(item['condition']['id']+' cap '+str(item['area_ratio_limit'])+' '+arm,selected==expected)
    audit=dict(passed=all(z['passed'] for z in checks),check_count=len(checks),checks=checks,scope='Fixed-netlist IO sweep only; not new candidate or model sample count')
    save(s/'AUDIT.json',audit);print(json.dumps({k:v for k,v in audit.items() if k!='checks'}))
    return 0 if audit['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
