"""Frozen local multi-module sequential controls; no LLM/network calls."""
from datetime import datetime
import json
from pathlib import Path
import shutil
import subprocess
import sys
from run_native_comb import digest,save

ROOT=Path(__file__).resolve().parents[2]
RUNNER=Path(__file__).with_name('run_native_seq.py')

def main():
    out=ROOT/'eda/experiments'/datetime.now().strftime('engineering_arbiter_validation_%Y%m%d_%H%M%S_%f');out.mkdir()
    upstream=ROOT/'benchmark/engineering_sources_20261030/verilog-axis'
    source=upstream/'rtl/arbiter.v';helper=upstream/'rtl/priority_encoder.v'
    fixtures=out/'fixtures';fixtures.mkdir()
    text=source.read_text(encoding='utf-8')
    assert text.count('assign grant = grant_reg;')==1
    bad=fixtures/'wrong_only_at_ports32.v'
    bad.write_text(text.replace('assign grant = grant_reg;','assign grant = grant_reg ^ ((PORTS == 32) ? 1 : 0);'),encoding='utf-8')
    old='''    grant_reg <= grant_next;
    grant_valid_reg <= grant_valid_next;
    grant_encoded_reg <= grant_encoded_next;
    mask_reg <= mask_next;

    if (rst) begin
        grant_reg <= 0;
        grant_valid_reg <= 0;
        grant_encoded_reg <= 0;
        mask_reg <= 0;
    end'''
    assert text.count(old)==1
    positive=fixtures/'explicit_sync_reset.v'
    positive.write_text(text.replace(old,'''    grant_reg <= rst ? 0 : grant_next;
    grant_valid_reg <= rst ? 0 : grant_valid_next;
    grant_encoded_reg <= rst ? 0 : grant_encoded_next;
    mask_reg <= rst ? 0 : mask_next;'''),encoding='utf-8')
    fixed={'PORTS':32,'ARB_TYPE_ROUND_ROBIN':0}
    rr={'PORTS':32,'ARB_TYPE_ROUND_ROBIN':1,'ARB_BLOCK':1,'ARB_BLOCK_ACK':1}
    cases=[dict(id='fixed_priority32',candidate=str(source),parameters=fixed,dependency=True,expected='PASS'),
           dict(id='round_robin_blocking32',candidate=str(source),parameters=rr,dependency=True,expected='PASS'),
           dict(id='wrong32_default4_positive_control',candidate=str(bad),parameters={},dependency=True,expected='PASS'),
           dict(id='wrong32_negative_control',candidate=str(bad),parameters=fixed,dependency=True,expected='FORMAL_FAIL'),
           dict(id='missing_helper',candidate=str(source),parameters=fixed,dependency=False,expected='SCHEMA_REJECT')]
    files=[RUNNER,RUNNER.with_name('run_native_comb.py'),RUNNER.with_name('trace_sta_rtl_cone.py'),Path(__file__),ROOT/'agents/sequential_loop.py',ROOT/'agents/optimization_loop.py',ROOT/'agents/rtl_optimizer.py']
    snapshot=out/'code_snapshot';snapshot.mkdir()
    for p in files:shutil.copyfile(p,snapshot/p.name)
    frozen={str(p):digest(p) for p in [source,helper,bad,positive,*files]}
    for c in cases:c['candidate_sha256']=digest(Path(c['candidate']))
    protocol=dict(cases=cases,reference=str(source),reference_sha256=digest(source),dependency=str(helper),
       dependency_sha256=digest(helper),frozen_files=frozen,clock='clk',reset='rst',reset_cycles=1,
       warmup_samples=1,period_ns=10,timeout_seconds=120,llm_requests=0,
       loop_candidate=str(positive),loop_parameters=fixed,
       purpose='Native parameter/dependency qualification, positive rewrite and deliberate negative controls. Not an optimization or model comparison.')
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(digest(out/'protocol.json')+'\n',encoding='ascii')
    print('Experiment: '+str(out),flush=True);rows=[]
    def verify():assert all(digest(Path(p))==h for p,h in frozen.items()),'Frozen source/code changed'
    for c in cases:
        verify();folder=out/c['id']
        cmd=[sys.executable,'-B',str(RUNNER),c['candidate'],'--reference',str(source),'--top','arbiter','--clock','clk','--reset','rst','--out',str(folder)]
        if c['dependency']:cmd+=['--dependency',str(helper)]
        for k,v in c['parameters'].items():cmd+=['--param',f'{k}={v}']
        try:
            proc=subprocess.run(cmd,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900)
            raw=proc.stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        (out/(c['id']+'_runner.log')).write_bytes(raw)
        r=json.loads((folder/'result.json').read_text(encoding='utf-8')) if (folder/'result.json').exists() else {}
        actual='PASS' if r.get('status')=='PASS' else 'FORMAL_FAIL' if r.get('formal')=='FAIL' else 'SCHEMA_REJECT' if r.get('stage')=='schema' else 'INCOMPLETE'
        rows.append(dict(id=c['id'],expected=c['expected'],actual=actual,matched=c['expected']==actual,result=r))
        save(out/'SUMMARY.json',dict(planned=6,completed=len(rows),llm_requests=0,results=rows))
        print(c['id']+': '+actual+' expected='+c['expected'],flush=True)
    verify()
    cmd=[sys.executable,'-B',str(ROOT/'agents/optimization_loop.py'),'seq','--rtl',str(source),'--top','arbiter','--clock','clk','--reset','rst','--dependency',str(helper),'--candidate-rtl',str(positive),'--candidate-rtl',str(bad),'--out',str(out/'loop_integration')]
    for k,v in fixed.items():cmd+=['--param',f'{k}={v}']
    proc=subprocess.run(cmd,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=1800)
    (out/'loop_runner.log').write_bytes(proc.stdout)
    summary=json.loads((out/'loop_integration/summary.json').read_text(encoding='utf-8'))
    matched=(proc.returncode==0 and summary['status']=='COMPLETED' and summary['llm_requests_attempted']==0 and len(summary['candidates'])==2
         and summary['candidates'][0]['metrics']['formal']=='PASS' and summary['candidates'][0]['metrics']['mapped_formal']=='PASS'
         and summary['candidates'][1]['metrics']['formal']=='FAIL' and not summary['candidates'][1]['accepted'])
    rows.append(dict(id='native_loop_integration',expected='PASS',actual='PASS' if matched else 'INCOMPLETE',matched=matched,result=summary))
    verify();save(out/'SUMMARY.json',dict(planned=6,completed=len(rows),llm_requests=0,results=rows))
    shutil.copyfile(upstream/'COPYING',out/'UPSTREAM_COPYING')
    print('native_loop_integration: '+str(matched),flush=True)
    return 0 if all(r['matched'] for r in rows) else 1

if __name__=='__main__':raise SystemExit(main())
