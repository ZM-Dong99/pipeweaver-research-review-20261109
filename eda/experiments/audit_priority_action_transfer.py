"""Check action materialization, all raw proofs/PPA and unchanged selection rules."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[2];E=ROOT/'eda/experiments';sys.path.insert(0,str(ROOT));sys.path.insert(0,str(E))
from rewrite.priority_rewrites import materialize
from run_native_comb import parse_electrical_report
S=E/'priority_action_transfer_20261103_174528_356729'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load(S/'protocol.json');s=load(S/'SUMMARY.json');checks=[]
def check(name,value):checks.append(dict(check=name,passed=bool(value)))
check('Frozen protocol',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip())
check('Original hash',sha(S/'inputs/original.v')==p['source_sha256'])
check('Canonical normalized text',hashlib.sha256((S/'inputs/original.v').read_text(encoding='utf-8').encode('utf-8')).hexdigest()==p['canonical_lf_text_sha256'])
for rel,h in p['code_sha256'].items():check('Code '+rel,sha(ROOT/rel)==sha(S/'code_snapshot'/Path(rel).name)==h)
check('Actual library',sha(E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib')==p['library_sha256'])
check('Zero model requests',p['model_requests']==s['model_requests']==0 and not list(S.glob('**/api_audit')))
check('Primary chosen in advance',p['primary_profile']=='primary_W128_msb' and p['profiles'][0]==dict(id='primary_W128_msb',WIDTH=128,lsb=0,role='primary'))
check('Fixed six actions and three profiles',len(p['candidates'])==p['source_versions']==6 and len(s['profiles'])==4 and p['planned_eda_cases']==28)
guards=load(S/'GUARD_VALIDATION.json');check('Seven rejection checks',guards['passed'] and len(guards['negative_checks'])==7 and all(x['rejected'] for x in guards['negative_checks']))
for c in p['candidates']:
    spec=load(S/'candidates'/(c['id']+'.action.json'));rtl=S/'candidates'/(c['id']+'.v')
    check(c['id']+' exact action',spec==c['action'] and sha(S/'candidates'/(c['id']+'.action.json'))==c['action_sha256'])
    check(c['id']+' exact materialized RTL',sha(rtl)==c['sha256'] and rtl.read_text(encoding='utf-8')==materialize((S/'inputs/original.v').read_text(encoding='utf-8'),spec))
stats=dict(source_formal_pass=0,mapped_formal_pass=0,sta_complete=0,strict_improved_pairs=0)
def eda(folder,m,N,label,lsb=0,include_stats=True):
    cp=load(folder/'protocol.json')
    check(label+' actual result',load(folder/'result.json')==m)
    check(label+' original reference',cp['reference_sha256']==p['source_sha256'])
    check(label+' candidate hash',sha(Path(cp['candidate']))==cp['candidate_sha256'])
    check(label+' actual parameter',cp['parameter_overrides']=={'WIDTH':N,'LSB_HIGH_PRIORITY':lsb})
    check(label+' fixed mapping',cp['mapping_policy']=='buffer_size' and cp['abc_cleanup_before_buffer'] is True and cp['mapped_netlist_proof_required'] is True)
    check(label+' library/IO',cp['liberty_sha256']==p['library_sha256'] and cp['input_transition_ns']==p['input_transition_ns'] and cp['output_load_pf']==p['output_load_pf'])
    ports=load(folder/'candidate_schema.json')['modules']['priority_encoder']['ports']
    check(label+' actual input/output shape',len(ports['input_unencoded']['bits'])==len(ports['output_unencoded']['bits'])==N and len(ports['output_encoded']['bits'])==(N-1).bit_length() and len(ports['output_valid']['bits'])==1)
    check(label+' all outputs ungated including invalid input', 'assign mismatch = (gold_1 != cand_1) | (gold_2 != cand_2) | (gold_3 != cand_3);' in (folder/'miter.v').read_text(encoding='utf-8'))
    if m.get('status')=='PASS':
        for stage in ['formal','mapped_formal']:
            check(label+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (folder/(stage+'.log')).read_text(encoding='utf-8'))
        raw=(folder/'sta.log').read_text(encoding='utf-8')
        arrivals=[float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw)]
        check(label+' raw arrival',bool(arrivals) and max(arrivals)==m['max_data_arrival_ns'])
        check(label+' electrical',parse_electrical_report(raw)==m['electrical'])
        area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text(encoding='utf-8'))[-1])
        check(label+' raw area',area==m['mapped_area_um2'])
        check(label+' mapped/SDC hashes',sha(folder/'mapped.v')==m['mapped_sha256'] and sha(folder/'mapped.json')==m['mapped_json_sha256'] and sha(folder/'timing.sdc')==m['sdc_sha256'])
    else:check(label+' fail closed',not m.get('eligible'))
    if include_stats:
        stats['source_formal_pass']+=m.get('formal')=='PASS';stats['mapped_formal_pass']+=m.get('mapped_formal')=='PASS';stats['sta_complete']+=m.get('ppa')=='PASS'
for profile in s['profiles']:
    folder=S/profile['id'];b=profile['baseline'];N=profile['WIDTH'];lsb=profile['lsb'];cap=b['mapped_area_um2']*1.10
    check(profile['id']+' frozen profile',any(x['id']==profile['id'] and x['WIDTH']==N and x['lsb']==lsb and x['role']==profile['role'] for x in p['profiles']))
    eda(folder/'baseline',b,N,profile['id']+'/baseline',lsb)
    check(profile['id']+' six evaluations',len(profile['results'])==6)
    check(profile['id']+' unchanged cap',profile['area_cap_um2']==cap)
    valid=[]
    for row in profile['results']:
        m=row['metrics'];eda(folder/row['id'],m,N,profile['id']+'/'+row['id'],lsb)
        qualified=bool(m.get('status')=='PASS' and m.get('eligible') and m.get('formal')==m.get('mapped_formal')=='PASS' and m['mapped_area_um2']<=cap and m['max_data_arrival_ns']<b['max_data_arrival_ns']-1e-9)
        check(profile['id']+'/'+row['id']+' acceptance',row['strict_improvement']==qualified)
        if qualified:valid.append(row);stats['strict_improved_pairs']+=1
    valid.sort(key=lambda r:(r['metrics']['max_data_arrival_ns'],r['metrics']['mapped_area_um2'],r['id']))
    selected=valid[0] if valid else dict(id='baseline',metrics=b)
    check(profile['id']+' exact selection',profile['selected']==selected)
    source=S/'candidates'/(selected['id']+'.v') if valid else S/'inputs/original.v'
    check(profile['id']+' export',sha(source)==sha(folder/'best.v')==profile['selected_sha256'])
replay=load(S/'REPRODUCTION.json');check('Two independent replays',replay['passed'] and replay['independent_eda_replays']==4)
for row in replay['rows']:eda(S/'independent_reproduction'/row['id'],row['metrics'],row['WIDTH'],'replay '+row['id'],row['lsb'],False)
controls=load(S/'no_op_controls/SUMMARY.json')
check('four posthoc no-op controls',len(controls['results'])==4)
cp=load(S/'no_op_controls/protocol.json'); check('no-op source frozen',sha(S/'no_op_controls/wrapped_original.v')==cp['source_sha256'] and "if (1'b0) begin : pw_grouped" in (S/'no_op_controls/wrapped_original.v').read_text(encoding='utf-8'))
for row in controls['results']:
    profile=next(p for p in s['profiles'] if p['id']==row['profile'])
    eda(S/'no_op_controls'/row['profile'],row['metrics'],profile['WIDTH'],'no-op '+row['profile'],profile['lsb'],False)
check('reference candidate provenance',sha(S/'inputs/validated_model_reference.v')==p['validated_model_reference']['sha256'])
report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,actual_case_statistics=stats,
            scope='One priority family, six sources, 24 candidate/parameter pairs, four baselines. No-op controls and replays separate. No new model calls or universal parameter proof.')
save(S/'AUDIT.json',report);print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
if not report['passed']:
    print([x for x in checks if not x['passed']]);raise SystemExit(1)
