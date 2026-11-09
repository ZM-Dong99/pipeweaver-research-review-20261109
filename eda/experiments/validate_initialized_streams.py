"""Freeze opt-in logical-init backend positives, broken RTL, and broken mapped output."""
import argparse
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
RUNNER=Path(__file__).with_name('run_native_seq_initialized.py')
SOURCES=ROOT/'benchmark/engineering_sources_20261106'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def save(p,v):
    p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',required=True,type=Path);a=ap.parse_args()
    out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
    fixtures=out/'fixtures';fixtures.mkdir()
    adapter=(SOURCES/'axis_adapter.v').read_text(encoding='utf-8')
    wrong_output,n=re.subn(r'(assign\s+m_axis_tdata\s*=\s*)([^;]+);',lambda m:m[1]+'('+m[2]+") ^ {{(M_DATA_WIDTH-1){1'b0}},1'b1};",adapter)
    if not n:raise RuntimeError('Missing output mutation target')
    wrong_init=adapter.replace("m_axis_tdata_reg = {M_DATA_WIDTH{1'b0}};","m_axis_tdata_reg = {M_DATA_WIDTH{1'b1}};")
    wrong_state=adapter.replace('seg_reg <= seg_reg + 1;','seg_reg <= seg_reg + 2;')
    if wrong_init==adapter or wrong_state==adapter:raise RuntimeError('Missing state mutation target')
    for name,text in [('wrong_output',wrong_output),('wrong_init',wrong_init),('wrong_state',wrong_state)]:
        (fixtures/(name+'.v')).write_text(text,encoding='utf-8')
    cases=[
        dict(id='adapter',candidate=str(SOURCES/'axis_adapter.v'),reference=str(SOURCES/'axis_adapter.v'),top='axis_adapter',params={'S_DATA_WIDTH':8,'M_DATA_WIDTH':32},expected='PASS'),
        dict(id='skid',candidate=str(SOURCES/'axis_register.v'),reference=str(SOURCES/'axis_register.v'),top='axis_register',params={'DATA_WIDTH':32,'REG_TYPE':2},expected='PASS')]
    for name in ('wrong_output','wrong_init','wrong_state'):
        cases.append(dict(id=name,candidate=str(fixtures/(name+'.v')),reference=str(SOURCES/'axis_adapter.v'),top='axis_adapter',params={'S_DATA_WIDTH':8,'M_DATA_WIDTH':32},expected='FORMAL_FAIL'))
    old=ROOT/'eda/experiments/sequential_backend_controls_20261031_final/fixtures'
    cases.append(dict(id='encoded_counter',candidate=str(old/'encoded.v'),reference=str(old/'counter.v'),top='seq_control',params={},expected='PASS'))
    cases.append(dict(id='fifo_rejected',candidate=str(SOURCES/'axis_fifo.v'),reference=str(SOURCES/'axis_fifo.v'),top='axis_fifo',params={'DEPTH':4,'DATA_WIDTH':8},expected='SCHEMA_REJECT'))
    for c in cases:
        c['candidate_sha256']=sha(Path(c['candidate']));c['reference_sha256']=sha(Path(c['reference']))
    deps=[Path(__file__),RUNNER,RUNNER.with_name('run_native_seq.py'),RUNNER.with_name('run_native_comb.py'),RUNNER.with_name('trace_sta_rtl_cone.py')]
    snap=out/'code_snapshot';snap.mkdir()
    for p in deps:shutil.copyfile(p,snap/p.name)
    protocol=dict(created_at=datetime.now().astimezone().isoformat(),cases=cases,model_requests=0,
        initial_state_policy='rtl-declared; logical initialization explicitly assumed, not physical power-up',
        state_relations='Compare common original register signals as additional targets; complete base+induction, no assumptions/cutpoints',
        mapping='Uniform dffunmap -ce-only then dfflibmap/ABC cleanup/buffer/upsize/dnsize',
        reset='rst for stream modules, rst for encoded counter, first sample asserted only; after one-sample warmup all outputs compared even invalid cycles',
        timeout_per_tool_seconds=120,period_ns=10,source_hashes={p.name:sha(p) for p in SOURCES.glob('*.v')},
        dependencies={str(p.resolve().relative_to(ROOT)):sha(p) for p in deps},
        extra_control='After adapter full PASS, invert mapped output bit0 and re-run exact mapped proof in new directory; must produce actual base counterexample',
        acceptance='All seven expected classifications plus broken mapped output detection; original stream failure report remains unchanged')
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(key,None)
    env['PATH']='D:\\oss-cad-suite\\bin;D:\\oss-cad-suite\\lib;'+env.get('PATH','')
    results=[]
    for c in cases:
        for rel,h in protocol['dependencies'].items():
            if sha(ROOT/rel)!=h:raise RuntimeError('Frozen dependency changed')
        if sha(Path(c['candidate']))!=c['candidate_sha256'] or sha(Path(c['reference']))!=c['reference_sha256']:raise RuntimeError('Frozen RTL changed')
        cmd=[sys.executable,'-B',str(RUNNER),c['candidate'],'--reference',c['reference'],'--top',c['top'],'--clock','clk','--reset','rst',
             '--initial-state-policy','rtl-declared','--prove-state-invariants','--unmap-clock-enables','--out',str(out/c['id'])]
        for k,v in c['params'].items():cmd+=['--param',f'{k}={v}']
        try:
            proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900)
            raw=proc.stdout
        except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+b'\nOVERALL TIMEOUT'
        (out/(c['id']+'_runner.log')).write_bytes(raw)
        rp=out/c['id']/'result.json';r=load(rp) if rp.exists() else dict(status='INCOMPLETE')
        actual='PASS' if r['status']=='PASS' else 'FORMAL_FAIL' if r.get('formal')=='FAIL' else 'SCHEMA_REJECT' if r.get('stage')=='schema' else 'INCOMPLETE'
        results.append(dict(id=c['id'],expected=c['expected'],actual=actual,matched=actual==c['expected'],result=r))
        save(out/'SUMMARY.json',dict(model_requests=0,results=results))
        print(c['id']+': '+actual+' expected='+c['expected'],flush=True)
    baseline=out/'adapter';diag=out/'broken_mapped_output';diag.mkdir()
    if load(baseline/'result.json')['status']!='PASS':raise RuntimeError('Cannot run mapped negative without successful baseline')
    original=(baseline/'mapped.v').read_text(encoding='utf-8')
    broken,n=re.subn(r'(assign\s+m_axis_tdata\s*=\s*)([^;]+);',lambda m:m[1]+'('+m[2]+") ^ 32'h1;",original)
    if n!=1:raise RuntimeError('Expected exactly one mapped output assignment')
    mapped=diag/'broken.v';mapped.write_text(broken,encoding='utf-8')
    script=(baseline/'mapped_formal.ys').read_text(encoding='utf-8').replace((baseline/'mapped.v').as_posix(),mapped.as_posix()).replace((baseline/'mapped_formal_counterexample.vcd').as_posix(),(diag/'counterexample.vcd').as_posix())
    yp=diag/'prove.ys';yp.write_text(script,encoding='utf-8')
    save(diag/'protocol.json',dict(original_mapped_sha256=sha(baseline/'mapped.v'),broken_mapped_sha256=sha(mapped),proof_script_sha256=sha(yp),mutation='Invert native m_axis_tdata bit0; state relations remain unchanged',model_requests=0))
    try:
        proc=subprocess.run(['D:/oss-cad-suite/bin/yosys.exe','-Q',str(yp)],cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=120)
        raw=proc.stdout;code=proc.returncode
    except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+b'\nTIMEOUT';code=124
    (diag/'proof.log').write_bytes(raw)
    caught=code!=0 and b'model found for base case: FAIL!' in raw
    save(diag/'RESULT.json',dict(caught_actual_base_counterexample=caught,exit_code=code,model_requests=0))
    summary=dict(model_requests=0,results=results,broken_mapped_output_detected=caught,
                 passed=all(r['matched'] for r in results) and caught,
                 scope='Logical declared-initial-state qualification and negative controls; not physical power-up or optimization benefit')
    save(out/'SUMMARY.json',summary)
    print('Acceptance: '+str(summary['passed'])+'; broken mapped output detected='+str(caught),flush=True)
    return 0 if summary['passed'] else 1


if __name__=='__main__':raise SystemExit(main())
