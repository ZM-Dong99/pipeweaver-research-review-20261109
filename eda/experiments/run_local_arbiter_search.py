"""Freeze six guarded local candidates before EDA; development experiment, no LLM."""
import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from rewrite.arbiter_local_rewrites import candidates,control_candidates,reset_mux
from agents.sequential_loop import decision
from run_native_comb import digest,save

RUNNER=Path(__file__).with_name('run_native_seq.py')
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
PARAMETERS={'PORTS':32,'ARB_TYPE_ROUND_ROBIN':1,'ARB_BLOCK':1,'ARB_BLOCK_ACK':1}

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--timeout',type=int,default=120)
    ap.add_argument('--operator-set',choices=['mask','control'],default='mask')
    ap.add_argument('--development-parent',type=Path)
    a=ap.parse_args()
    if a.timeout<1:ap.error('Positive timeout required')
    out=ROOT/'eda/experiments'/datetime.now().strftime('local_arbiter_'+a.operator_set+'_search_%Y%m%d_%H%M%S_%f');out.mkdir();inputs=out/'inputs';inputs.mkdir()
    upstream=ROOT/'benchmark/engineering_sources_20261030/verilog-axis'
    source=inputs/'original.v';helper=inputs/'priority_encoder.v';shutil.copyfile(upstream/'rtl/arbiter.v',source);shutil.copyfile(upstream/'rtl/priority_encoder.v',helper);shutil.copyfile(upstream/'COPYING',inputs/'COPYING')
    text=source.read_text(encoding='utf-8');generated=candidates(text) if a.operator_set=='mask' else control_candidates(text)
    candidate_dir=out/'candidates';candidate_dir.mkdir();manifest=[]
    for item in generated:
        folder=candidate_dir/item['id'];folder.mkdir();path=folder/'candidate.v';path.write_text(item['rtl'],encoding='utf-8')
        manifest.append({k:v for k,v in item.items() if k!='rtl'}|dict(path=str(path),sha256=digest(path)))
    known=inputs/'known_reset_reference.v';known.write_text(reset_mux(text),encoding='utf-8')
    dependencies=[Path(__file__),ROOT/'rewrite/arbiter_local_rewrites.py',RUNNER,RUNNER.with_name('run_native_comb.py'),RUNNER.with_name('trace_sta_rtl_cone.py'),ROOT/'agents/sequential_loop.py']
    snap=out/'code_snapshot';snap.mkdir()
    for file in dependencies:shutil.copyfile(file,snap/file.name)
    p=dict(scope='Post-hoc development search motivated by previous area overruns. Not a blind/equal-method comparison or new LLM result.',
        candidate_budget=6,candidates=manifest,operator_set=a.operator_set,
        operators=['onehot_subtract','onehot_prefix','request_prefix'] if a.operator_set=='mask' else ['valid_from_grant','ack_from_index','valid_and_ack'],
        cross_product='three local operator choices x reset style unchanged/explicit mux',
        development_parent=str(a.development_parent.resolve()) if a.development_parent else None,
        development_parent_protocol_sha256=digest(a.development_parent.resolve()/'protocol.json') if a.development_parent else None,
        known_reference='Previously used reset-only development positive; excluded from six-candidate discovery budget',
        contract=dict(top='arbiter',parameters=PARAMETERS,clock='clk',reset='rst',reset_active=1,reset_cycles=1,warmup_samples=1,period_ns=10),
        area_ratio_limit=1.10,timeout_seconds=a.timeout,llm_requests=0,
        original_sha256=digest(source),helper_sha256=digest(helper),known_reference_sha256=digest(known),liberty_sha256=digest(LIB),
        dependency_sha256={str(f.relative_to(ROOT)):digest(f) for f in dependencies},
        invariant='All six candidates and their hashes frozen before baseline or candidate PPA; fixed helper, every source and mapped candidate proved against original; all failures kept. No adaptive added variants.')
    save(out/'protocol.json',p);(out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n',encoding='ascii')
    print('Experiment: '+str(out),flush=True)
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    def verify():
        assert digest(source)==p['original_sha256'] and digest(helper)==p['helper_sha256'] and digest(LIB)==p['liberty_sha256']
        assert all(digest(Path(c['path']))==c['sha256'] for c in manifest)
        assert all(digest(ROOT/f)==h for f,h in p['dependency_sha256'].items())
    def evaluate(candidate,folder):
        verify();cmd=[sys.executable,'-B',str(RUNNER),str(candidate),'--reference',str(source),'--dependency',str(helper),
            '--top','arbiter','--clock','clk','--reset','rst','--period','10','--warmup','1','--timeout',str(a.timeout),'--out',str(folder)]
        for k,v in PARAMETERS.items():cmd+=['--param',f'{k}={v}']
        try:proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=a.timeout*8);raw=proc.stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        folder.mkdir(exist_ok=True);(folder/'runner.log').write_bytes(raw);verify()
        return json.loads((folder/'result.json').read_text(encoding='utf-8')) if (folder/'result.json').exists() else dict(status='INCOMPLETE',formal='NOT_RUN',ppa='NOT_RUN',eligible=False)
    baseline=evaluate(source,out/'baseline')
    if baseline.get('status')!='PASS':save(out/'SUMMARY.json',dict(status='BASELINE_FAILED',baseline=baseline,llm_requests=0));return 1
    cap=baseline['mapped_area_um2']*1.10;known_metrics=evaluate(known,out/'known_reset_reference')
    best_path=source;best_metrics=baseline;best_id='baseline';rows=[]
    for item in manifest:
        folder=Path(item['path']).parent;m=evaluate(Path(item['path']),folder/'eda')
        eligible=bool(m.get('status')=='PASS' and m.get('eligible') and m.get('mapped_area_um2',float('inf'))<=cap+1e-9)
        accepted,reason=decision(m,best_metrics,cap)
        if accepted:best_path=Path(item['path']);best_metrics=m;best_id=item['id']
        rows.append(dict(id=item['id'],source_sha256=item['sha256'],eligible=eligible,accepted=accepted,reason=reason,metrics=m))
        save(out/'SUMMARY.json',dict(status='RUNNING',baseline=baseline,known_reference=known_metrics,area_cap_um2=cap,candidate_budget=6,completed=len(rows),llm_requests=0,results=rows))
        print(item['id']+': '+str(m.get('status'))+' WNS='+str(m.get('wns_ns'))+' area='+str(m.get('mapped_area_um2'))+' accepted='+str(accepted),flush=True)
    shutil.copyfile(best_path,out/'best.v')
    save(out/'BEST.json',dict(id=best_id,sha256=digest(out/'best.v'),metrics=best_metrics,known_reference_excluded_from_selection=True))
    save(out/'SUMMARY.json',dict(status='COMPLETED',baseline=baseline,known_reference=known_metrics,area_cap_um2=cap,candidate_budget=6,completed=len(rows),llm_requests=0,results=rows))
    return 0

if __name__=='__main__':raise SystemExit(main())
