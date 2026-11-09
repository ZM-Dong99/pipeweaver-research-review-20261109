"""Frozen grouped-priority action transfer; primary WIDTH128 MSB, reference/boundary/fallback controls."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from rewrite.priority_rewrites import materialize,actions,SOURCE_SHA256 as CANONICAL_TEXT_SHA256
E=ROOT/'eda/experiments';BACKEND=E/'run_native_comb.py'
SOURCE=ROOT/'benchmark/engineering_sources_20261030/verilog-axis/rtl/priority_encoder.v'
LIB=E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def main():
    s=E/datetime.now().strftime('priority_action_transfer_%Y%m%d_%H%M%S_%f');s.mkdir()
    for name in ['inputs','candidates','code_snapshot']:(s/name).mkdir()
    shutil.copyfile(SOURCE,s/'inputs/original.v')
    shutil.copyfile(ROOT/'benchmark/engineering_sources_20261030/verilog-axis/COPYING',s/'inputs/LICENSE')
    source=(s/'inputs/original.v').read_text(encoding='utf-8')
    # Reject attempts to broaden the action API or source template, before EDA.
    valid=actions()[0];bad=[('extra_rtl',{**valid,'candidate_rtl':'arbitrary'},source),
        ('unknown_operator',{**valid,'operator':'free_rtl'},source),('bool_width',{**valid,'group_bits':True},source),
        ('zero_width',{**valid,'group_bits':0},source),('unknown_encoding',{**valid,'encoding':'arbitrary'},source),
        ('modified_source',valid,source+' '),('appended_module',valid,source+'\nmodule extra; endmodule\n')]
    tests=[]
    for name,spec,text in bad:
        try:materialize(text,spec)
        except ValueError:tests.append(dict(test=name,rejected=True))
        else:raise AssertionError('Unsafe action accepted: '+name)
    save(s/'GUARD_VALIDATION.json',dict(passed=True,negative_checks=tests,model_requests=0))
    candidates=[]
    for spec in actions():
        name=f"{spec['encoding']}_{spec['group_bits']}";out=s/'candidates'/(name+'.v')
        out.write_text(materialize(source,spec),encoding='utf-8');save(s/'candidates'/(name+'.action.json'),spec)
        candidates.append(dict(id=name,action=spec,sha256=sha(out),action_sha256=sha(s/'candidates'/(name+'.action.json'))))
    deps=[Path(__file__).resolve(),ROOT/'rewrite/priority_rewrites.py',BACKEND,E/'trace_sta_rtl_cone.py']
    for path in deps:shutil.copyfile(path,s/'code_snapshot'/path.name)
    profiles=[dict(id='primary_W128_msb',WIDTH=128,lsb=0,role='primary'),
        dict(id='reference_W256_msb',WIDTH=256,lsb=0,role='previously exposed reference width'),
        dict(id='boundary_W17_msb',WIDTH=17,lsb=0,role='non-power-of-two boundary'),
        dict(id='fallback_W32_lsb',WIDTH=32,lsb=1,role='original implementation fallback')]
    inspiration=E/'timing_feedback_ablation_priority256_20261102_203544_758268/actual_paths/candidate_03/candidate.v'
    shutil.copyfile(inspiration,s/'inputs/validated_model_reference.v')
    protocol=dict(client_date='2026-11-03',scope='One priority-encoding family, six source versions, four parameter instances; post-hoc operator development, not a fresh model comparison.',
        source_sha256=sha(s/'inputs/original.v'),canonical_lf_text_sha256=CANONICAL_TEXT_SHA256,
        validated_model_reference=dict(path=str(inspiration),sha256=sha(inspiration),record='Previously source/mapped proved WIDTH256 MSB proposal; template generalization is new and must be proved separately.'),
        library_sha256=sha(LIB),code_sha256={str(path.relative_to(ROOT)):sha(path) for path in deps},
        profiles=profiles,candidates=candidates,source_versions=6,planned_eda_cases=28,candidate_configuration_pairs=24,
        primary_profile='primary_W128_msb',primary_metric='Maximum combinational data arrival ns, lower is better',
        area_ratio_limit=1.10,mapping_policy='buffer_size',cleanup_before_buffer=True,input_transition_ns=.10,output_load_pf=.010,
        timeout_per_tool_seconds=120,workers=2,model_requests=0,
        selection='Per-profile original area cap110%. Full source/mapped proof, clean electrical STA, strictly lower arrival. Min delay then area; retain original otherwise.',
        policy='Freeze six action JSONs and RTLs before any measurement. No adaptive new candidates. MSB grouped fast path only; LSB and non-default LEVELS/W use unchanged source fallback.',
        prior_exposure='WIDTH256 LLM proposals and PPA inspected. Existing WIDTH64/256 baseline work exposed. WIDTH128 chosen as primary before new measurements. All belong to same public family, not training-data holdout.',
        limitations='No clocks, latency changes or input assumptions. Preserve all outputs even when output_valid=0, especially zero input. Only these frozen instances proved. Standard grouped priority logic, no novelty claim.')
    save(s/'protocol.json',protocol);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    print('Frozen experiment: '+str(s),flush=True)
    def evaluate(job):
        profile,name,source=job;folder=s/profile['id']/name
        assert all(sha(s/'candidates'/(c['id']+'.v'))==c['sha256'] for c in candidates)
        cmd=[sys.executable,'-B',str(BACKEND),str(source),'--reference',str(s/'inputs/original.v'),'--top','priority_encoder',
             '--param',f"WIDTH={profile['WIDTH']}",'--param',f"LSB_HIGH_PRIORITY={profile['lsb']}",'--mapping-policy','buffer_size','--cleanup-before-buffer','--timeout','120','--out',str(folder)]
        env=os.environ.copy()
        for key in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(key,None)
        try:raw=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=960).stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        folder.mkdir(parents=True,exist_ok=True);(folder/'runner.log').write_bytes(raw)
        result=load(folder/'result.json') if (folder/'result.json').exists() else dict(status='INCOMPLETE',eligible=False)
        print(profile['id'],name,json.dumps({k:result.get(k) for k in ['status','formal','mapped_formal','max_data_arrival_ns','mapped_area_um2']}),flush=True)
        return dict(profile=profile['id'],id=name,metrics=result)
    # Each profile has its own baseline and area cap; candidate outcomes never
    # influence which remaining candidates/configurations will be measured.
    jobs=[(profile,'baseline',s/'inputs/original.v') for profile in profiles]
    with ThreadPoolExecutor(max_workers=2) as pool:baselines=list(pool.map(evaluate,jobs))
    if any(b['metrics'].get('status')!='PASS' for b in baselines):
        save(s/'BASELINE_FAILURE.json',baselines);raise RuntimeError('Baseline failure; all evidence preserved, no candidates evaluated')
    jobs=[(profile,c['id'],s/'candidates'/(c['id']+'.v')) for profile in profiles for c in candidates]
    with ThreadPoolExecutor(max_workers=2) as pool:results=list(pool.map(evaluate,jobs))
    summaries=[]
    for profile in profiles:
        baseline=next(b['metrics'] for b in baselines if b['profile']==profile['id']);rows=[r for r in results if r['profile']==profile['id']]
        cap=baseline['mapped_area_um2']*protocol['area_ratio_limit']
        for row in rows:
            m=row['metrics'];row['strict_improvement']=bool(m.get('status')=='PASS' and m.get('eligible') and m.get('formal')==m.get('mapped_formal')=='PASS' and m['mapped_area_um2']<=cap and m['max_data_arrival_ns']<baseline['max_data_arrival_ns']-1e-9)
        qualified=sorted([r for r in rows if r['strict_improvement']],key=lambda r:(r['metrics']['max_data_arrival_ns'],r['metrics']['mapped_area_um2'],r['id']))
        chosen=qualified[0] if qualified else dict(id='baseline',metrics=baseline)
        source=s/'candidates'/(chosen['id']+'.v') if qualified else s/'inputs/original.v'
        shutil.copyfile(source,s/profile['id']/'best.v')
        summaries.append(dict(**profile,baseline=baseline,area_cap_um2=cap,results=rows,selected=chosen,selected_sha256=sha(s/profile['id']/'best.v')))
    save(s/'SUMMARY.json',dict(status='COMPLETED',model_requests=0,profiles=summaries));print('Experiment: '+str(s),flush=True)
if __name__=='__main__':main()
