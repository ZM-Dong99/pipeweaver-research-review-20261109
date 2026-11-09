"""Frozen same-family parameter transfer for existing local operators; zero LLM calls."""
import argparse
from concurrent.futures import ThreadPoolExecutor,as_completed
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from rewrite.arbiter_local_rewrites import control_candidates,reset_mux
from agents.sequential_loop import decision
from run_native_comb import digest,save

RUNNER=Path(__file__).with_name('run_native_seq.py')
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
PARENT=ROOT/'eda/experiments/local_arbiter_control_search_20261102_225202_506372'
PROFILES=[dict(id='ports16_msb',ports=16,lsb=0),dict(id='ports24_msb',ports=24,lsb=0),
          dict(id='ports64_msb',ports=64,lsb=0),dict(id='ports32_lsb',ports=32,lsb=1)]

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--timeout',type=int,default=120);a=ap.parse_args()
    if a.timeout<1:ap.error('Positive timeout required')
    out=ROOT/'eda/experiments'/datetime.now().strftime('arbiter_operator_transfer_%Y%m%d_%H%M%S_%f');out.mkdir();inputs=out/'inputs';inputs.mkdir()
    upstream=ROOT/'benchmark/engineering_sources_20261030/verilog-axis'
    source=inputs/'original.v';helper=inputs/'priority_encoder.v';known=inputs/'known_reset_reference.v'
    shutil.copyfile(upstream/'rtl/arbiter.v',source);shutil.copyfile(upstream/'rtl/priority_encoder.v',helper);shutil.copyfile(upstream/'COPYING',inputs/'COPYING')
    text=source.read_text(encoding='utf-8');known.write_text(reset_mux(text),encoding='utf-8')
    candidate_dir=out/'candidates';candidate_dir.mkdir();manifest=[]
    parent=json.loads((PARENT/'protocol.json').read_text(encoding='utf-8'));parent_hashes={c['id']:c['sha256'] for c in parent['candidates']}
    for c in control_candidates(text):
        file=candidate_dir/(c['id']+'.v');file.write_text(c['rtl'],encoding='utf-8')
        assert digest(file)==parent_hashes[c['id']],'Candidate changed from prior frozen library'
        manifest.append(dict(id=c['id'],path=str(file),sha256=digest(file)))
    deps=[Path(__file__),RUNNER,RUNNER.with_name('run_native_comb.py'),RUNNER.with_name('trace_sta_rtl_cone.py'),ROOT/'rewrite/arbiter_local_rewrites.py',ROOT/'agents/sequential_loop.py']
    snapshot=out/'code_snapshot';snapshot.mkdir()
    for f in deps:shutil.copyfile(f,snapshot/f.name)
    protocol=dict(scope='Same canonical arbiter, new parameter instances. Not four independent design families or a model comparison.',
       parent=str(PARENT),parent_protocol_sha256=digest(PARENT/'protocol.json'),profiles=PROFILES,candidates=manifest,
       candidate_source_versions=6,candidate_configuration_evaluations=24,baseline_and_known_reference_evaluations=8,
       total_planned_eda_runs=32,timeout_seconds=a.timeout,workers=2,llm_requests=0,area_ratio_limit=1.10,
       clock='clk',reset='rst',reset_active=1,reset_cycles=1,warmup_samples=1,period_ns=10,
       invariant='All four profiles and same six prior candidate hashes frozen before any new profile measurement. No per-profile editing or added variants. Known reset reference separate.',
       selection='Within fixed original area cap and non-regressed TNS: strictly improve original WNS, maximize WNS, break improved-WNS ties by smaller area. Keep original if no strict WNS gain.',
       source_sha256=digest(source),helper_sha256=digest(helper),known_reference_sha256=digest(known),library_sha256=digest(LIB),
       dependency_sha256={str(f.relative_to(ROOT)):digest(f) for f in deps})
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n',encoding='ascii')
    print('Experiment: '+str(out),flush=True)
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    def verify():
        assert digest(source)==protocol['source_sha256'] and digest(helper)==protocol['helper_sha256'] and digest(known)==protocol['known_reference_sha256'] and digest(LIB)==protocol['library_sha256']
        assert all(digest(Path(c['path']))==c['sha256'] for c in manifest)
        assert all(digest(ROOT/f)==h for f,h in protocol['dependency_sha256'].items())
    def evaluate(candidate,folder,parameters):
        verify();folder.resolve().relative_to(out)
        cmd=[sys.executable,'-B',str(RUNNER),str(candidate),'--reference',str(source),'--dependency',str(helper),
          '--top','arbiter','--clock','clk','--reset','rst','--reset-cycles','1','--warmup','1','--period','10',
          '--timeout',str(a.timeout),'--out',str(folder)]
        for k,v in parameters.items():cmd+=['--param',f'{k}={v}']
        try:proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=a.timeout*8);raw=proc.stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        folder.mkdir(exist_ok=True);(folder/'runner.log').write_bytes(raw);verify()
        return json.loads((folder/'result.json').read_text(encoding='utf-8')) if (folder/'result.json').exists() else dict(status='INCOMPLETE',formal='NOT_RUN',ppa='NOT_RUN',eligible=False)
    def run(profile):
        folder=out/profile['id'];folder.mkdir();params={'PORTS':profile['ports'],'ARB_LSB_HIGH_PRIORITY':profile['lsb'],'ARB_TYPE_ROUND_ROBIN':1,'ARB_BLOCK':1,'ARB_BLOCK_ACK':1}
        baseline=evaluate(source,folder/'baseline',params)
        if baseline.get('status')!='PASS':
            result=dict(id=profile['id'],status='BASELINE_FAILED',parameters=params,baseline=baseline,results=[]);save(folder/'SUMMARY.json',result);return result
        reference=evaluate(known,folder/'known_reference',params);cap=baseline['mapped_area_um2']*1.10
        best=baseline;best_id='baseline';best_path=source;rows=[]
        for c in manifest:
            m=evaluate(Path(c['path']),folder/c['id'],params)
            accepted,reason=decision(m,best,cap)
            gain=(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=cap+1e-9 and m['wns_ns']>baseline['wns_ns']+1e-9 and m['tns_ns']>=baseline['tns_ns']-1e-9)
            if gain and abs(m['wns_ns']-best['wns_ns'])<=1e-9 and m['tns_ns']>=best['tns_ns']-1e-9 and m['mapped_area_um2']<best['mapped_area_um2']:
                accepted=True;reason='Same improved WNS with smaller area'
            if accepted:best=m;best_id=c['id'];best_path=Path(c['path'])
            rows.append(dict(id=c['id'],source_sha256=c['sha256'],metrics=m,strict_baseline_improvement=bool(gain),accepted=accepted,reason=reason))
            result=dict(id=profile['id'],status='RUNNING',parameters=params,baseline=baseline,known_reference=reference,area_cap_um2=cap,results=rows)
            save(folder/'SUMMARY.json',result)
            print(profile['id']+'/'+c['id']+': '+m.get('status','INCOMPLETE')+' WNS='+str(m.get('wns_ns'))+' area='+str(m.get('mapped_area_um2')),flush=True)
        shutil.copyfile(best_path,folder/'best_new_search.v')
        known_ok=reference.get('status')=='PASS' and reference.get('eligible') and reference['mapped_area_um2']<=cap+1e-9 and reference['tns_ns']>=baseline['tns_ns']-1e-9
        better_known=bool(known_ok and (reference['wns_ns']>best['wns_ns']+1e-9 or abs(reference['wns_ns']-best['wns_ns'])<=1e-9 and reference['mapped_area_um2']<best['mapped_area_um2']))
        available=reference if better_known else best;available_path=known if better_known else best_path
        shutil.copyfile(available_path,folder/'best_available.v')
        result.update(status='COMPLETED',best_new_id=best_id,best_new_metrics=best,best_new_sha256=digest(folder/'best_new_search.v'),
            best_available_id='known_reset_reference' if better_known else best_id,best_available_metrics=available,best_available_sha256=digest(folder/'best_available.v'))
        save(folder/'SUMMARY.json',result);return result
    completed=[]
    with ThreadPoolExecutor(max_workers=2) as pool:
        for f in as_completed([pool.submit(run,p) for p in PROFILES]):
            completed.append(f.result());save(out/'SUMMARY.json',dict(planned_profiles=4,completed_profiles=len(completed),llm_requests=0,profiles=sorted(completed,key=lambda x:x['id'])))
    verify();print('All four parameter profiles finished; no new model requests.',flush=True)
    return 0 if all(x['status']=='COMPLETED' for x in completed) else 1

if __name__=='__main__':raise SystemExit(main())
