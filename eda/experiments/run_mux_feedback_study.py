"""Prepare or explicitly execute ten frozen free-RTL generation attempts."""
import argparse,hashlib,json,os,shutil,statistics,sys,time
from pathlib import Path
from datetime import datetime
from urllib.parse import urlsplit
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate,choose
from agents.rtl_optimizer import api_configured,generate_from_prompt,request_parameters_for_model,LLMGenerationError,http_transport
SRC=ROOT/'benchmark/rtl_opt_upstream_hkust/benchmark/mux_large/mux_large.v'
DEV=ROOT/'eda/experiments/mux_action_development_20261104_154849_392802'
ARMS=['no_sta','sta']
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
DEPS=[Path(__file__).resolve(),ROOT/'agents/action_loop.py',ROOT/'agents/rtl_optimizer.py',ROOT/'eda/experiments/run_native_comb.py',ROOT/'eda/experiments/trace_sta_rtl_cone.py']
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def save(f,v):f.write_text(json.dumps(v,indent=2,ensure_ascii=False),encoding='utf-8')
def exclusive(f,v):
    with f.open('x',encoding='utf-8') as stream:json.dump(v,stream,indent=2,ensure_ascii=False)
def validate(s):
    p=load(s/'protocol.json');assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip()
    for rel,h in p['frozen_files'].items():assert sha(s/rel)==h,rel
    for rel,h in p['code_sha256'].items():assert sha(ROOT/rel)==h and sha(s/'code_snapshot'/Path(rel).name)==h,rel
    assert sha(LIB)==p['liberty_sha256']
    return p
def prepare():
    assert http_transport()=='curl','Set PIPEWEAVER_HTTP_TRANSPORT=curl for frozen transport'
    model=os.environ.get('PIPEWEAVER_LLM_MODEL');endpoint=os.environ.get('OPENAI_BASE_URL','').rstrip('/');u=urlsplit(endpoint)
    assert model and u.scheme=='https' and u.hostname and not(u.username or u.password or u.query or u.fragment)
    curl=Path(shutil.which('curl.exe'));s=ROOT/'eda/experiments'/datetime.now().strftime('mux_feedback_study_%Y%m%d_%H%M%S_%f');s.mkdir()
    for sub in ['inputs','prompts','code_snapshot','development_reference']:(s/sub).mkdir()
    shutil.copyfile(SRC,s/'inputs/original.v');shutil.copyfile(SRC.parents[2]/'LICENSE',s/'inputs/LICENSE')
    shutil.copyfile(DEV/'exports/best.v',s/'development_reference/decoded_masks.v');shutil.copyfile(DEV/'FINAL_EVIDENCE.json',s/'development_reference/FINAL_EVIDENCE.json')
    print('Preparing '+str(s),flush=True)
    base=evaluate(s/'inputs/original.v',s/'baseline',s/'inputs/original.v',0,top='mux_large',parameters={})
    assert base['status']=='PASS'
    tool=load(s/'baseline/protocol.json');rtl=(s/'inputs/original.v').read_text(encoding='utf-8');raw=(s/'baseline/sta.log').read_text(encoding='utf-8')
    chunks=raw.split('Startpoint:')[1:];assert len(chunks)>=3
    paths=''.join('Startpoint:'+chunk for chunk in chunks[:3]).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0].strip()
    common=f'''Optimize this native combinational mux_large module for minimum mapped maximum data arrival while keeping area within the fixed cap. Give exactly one candidate RTL, not multiple alternatives.
Preserve module name, all port names, directions and bit widths. All 84 input bits are unconstrained and all 8 output bits must match for every two-state input. sel=0..9 selects block_a..block_j respectively; sel=10..15 selects block_a. No clocks, state, latency, assumptions or don't-cares may be introduced. Use synthesizable Verilog-2001. Helper modules are allowed. No include files or external dependencies.
Both conditions use Yosys/OpenSTA, SKY130HD TT 25C 1.80V, input transition 0.10ns, output load 0.010pF, external IO delays 0ns and no physical wire parasitics. The 100ns virtual clock is only a reporting reference; optimize maximum data arrival.
Fixed mapping: {tool['mapping']}.
Baseline mapped area {base['mapped_area_um2']:.6f} um^2; mapped-area cap {base['mapped_area_um2']*1.10:.6f} um^2. Complete source and mapped equivalence proofs and zero reported max-slew/max-capacitance violations are mandatory. No candidate PPA is supplied. Timing/area estimates are hypotheses to be measured by EDA.
Return a single JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries. candidate_rtl must contain one complete design, not pseudocode.
Original RTL:
{rtl}
'''
    feedback='\nMeasured original baseline timing (ns):\n'+json.dumps({k:base[k] for k in ['max_data_arrival_ns','wns_ns','tns_ns']},sort_keys=True)+'\nFirst three actual mapped STA paths in report order:\n'+paths+'\nThese are mapped-cell paths, not a verified exact gate-to-RTL source mapping.\n'
    for arm,text in [('no_sta',common),('sta',common+feedback)]:(s/'prompts'/(arm+'.txt')).write_text(text,encoding='utf-8')
    (s/'baseline/top3_supplied.txt').write_text(paths,encoding='utf-8')
    for f in DEPS:shutil.copyfile(f,s/'code_snapshot'/f.name)
    schedule=[dict(call_index=2*rep+j+1,arm=arm,trial=rep+1) for rep in range(5) for j,arm in enumerate(ARMS if rep%2==0 else ARMS[::-1])]
    files={str(f.relative_to(s)):sha(f) for sub in ['inputs','prompts','baseline','development_reference'] for f in (s/sub).rglob('*') if f.is_file()}
    p=dict(client_date='2026-11-04',family='selection',design='mux_large',top='mux_large',parameters={},model=model,endpoint=endpoint,transport='curl',curl_path=str(curl),curl_sha256=sha(curl),
        request_parameters=request_parameters_for_model(model),maximum_requests=10,trials_per_arm=5,call_schedule=schedule,baseline=base,area_cap_um2=base['mapped_area_um2']*1.10,primary='Median original-retained maximum arrival across all five attempted slots in each arm; failed/invalid/over-area/non-improving slots retain original.',
        secondary='Best original-retained delay, functional pass rates, strict improvement and >=5% improvement counts; all returned and failed slots; successful-return-only metrics as labeled diagnostics.',
        policies='One independent candidate per call, no history sharing, retries, replacement, repairs or extra draws. Freeze all generation before candidate EDA. All candidates proved against unchanged original; one EDA slot per returned candidate.',
        exposure='Public 23-line source baseline previously qualified; six hand-designed actions measured on same source and one known effective action. Free-generation prompts contain none of those candidate sources or PPA. This is exposed development-case comparison, not independent holdout or unbiased generalization evidence.',
        manual_reference='Previously hand-developed decoded_masks, delay0.90ns and area830.7968um2, separately labeled reference. Six-action development budget is not equal to one model candidate; never pool it with the STA arm.',
        inference='One short combinational instance, five attempts/arm, public training exposure unknown. Unequal successful returns may confound. No guaranteed win, causal/significance claim, sequential/pipeline claim or silicon signoff.',
        spending='Maximum10 requests, per-request timeout180s, no automatic retry; no explicit monetary or output-token hard cap. Third-party requested model identity unverified. No requests before explicit batch authorization.',
        frozen_files=files,code_sha256={str(f.relative_to(ROOT)):sha(f) for f in DEPS},liberty_sha256=sha(LIB))
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii');validate(s)
    checks=[]
    def check(k,v):checks.append(dict(check=k,passed=bool(v)))
    check('ten scheduled slots',len(schedule)==10)
    for arm in ARMS:check(arm+' five trials',sum(r['arm']==arm for r in schedule)==5)
    check('identical common prompt',(s/'prompts/sta.txt').read_text(encoding='utf-8')==common+feedback)
    check('no STA content in common','Startpoint:' not in common and 'Measured original baseline timing' not in common)
    check('no hand candidate or PPA in prompts',all(x not in common+feedback for x in ['decoded_masks','0.90ns','830.7968','wire take_a']))
    check('all three real paths',paths.count('Startpoint:')==3 and all(('Startpoint:'+chunk).strip() in raw for chunk in chunks[:2]))
    for stage in ['formal','mapped_formal']:check('baseline '+stage,base[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (s/'baseline'/(stage+'.log')).read_text(encoding='utf-8'))
    check('baseline complete electrical',base['eligible'] and base['electrical']['status']=='PASS')
    check('exact original retained',sha(SRC)==sha(s/'inputs/original.v'))
    check('zero network attempts',not list(s.glob('*/trial_*/attempt.json')))
    save(s/'PREPARATION_AUDIT.json',dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,actual_model_requests=0));assert all(c['passed'] for c in checks)
    save(s/'STATUS.json',dict(state='PREPARED_AWAITING_EXPLICIT_BATCH_AUTHORIZATION',actual_model_requests=0,maximum_requests=10))
    (s/'README.md').write_text('# 数据选择器真实模型对照：准备完成，尚未调用\n\n两组各5次，共最多10次。无反馈/真实基线路径反馈，自由生成RTL；相同模型、功能、面积与EDA契约。候选全部生成冻结后再评估。\n\n原始基线已真实复现1.04ns、914.6272µm²。手工参考0.90ns另列；不向模型提供候选或PPA，不混入STA组。同源手工开发已暴露，不能称独立盲测。\n\n全部提示见prompts/；固定协议见protocol.json。无重试、修复或补抽；没有金额硬上限。当前无AUTHORIZATION.json，实际调用0次。\n',encoding='utf-8')
    print('Prepared: '+str(s),flush=True);print('Preparation checks: '+str(len(checks)),flush=True)
def execute(s):
    p=validate(s);auth=load(s/'AUTHORIZATION.json');assert auth['maximum_requests']==p['maximum_requests']==10 and auth['protocol_sha256']==sha(s/'protocol.json')
    assert api_configured() and os.environ.get('OPENAI_BASE_URL','').rstrip('/')==p['endpoint'] and http_transport()==p['transport'] and sha(Path(shutil.which('curl.exe')))==p['curl_sha256']
    assert request_parameters_for_model(p['model'])==p['request_parameters'];rows=[]
    for slot in p['call_schedule']:
        validate(s);f=s/slot['arm']/f"trial_{slot['trial']:02d}";f.mkdir(parents=True,exist_ok=True)
        if (f/'generation.json').exists():
            r=load(f/'generation.json')
            if r.get('candidate_sha256'):assert sha(f/'candidate.v')==r['candidate_sha256']
            rows.append(r);continue
        if (f/'attempt.json').exists():raise RuntimeError('Uncertain previous attempt; refusing duplicate')
        prompt=s/'prompts'/(slot['arm']+'.txt');exclusive(f/'attempt.json',dict(**slot,protocol_sha256=sha(s/'protocol.json')))
        r=dict(**slot,status='FAILED_GENERATION',candidate_sha256=None,prompt_sha256=sha(prompt));start=time.monotonic();print(f"Calling {slot['call_index']}/10 {slot['arm']}",flush=True)
        try:
            generated=generate_from_prompt(prompt.read_text(encoding='utf-8'),model=p['model'],candidate_index=slot['call_index'],timeout_s=180,audit_dir=f/'api_audit')
            (f/'candidate.v').write_text(generated.rtl,encoding='utf-8');r.update(status='GENERATED',candidate_sha256=sha(f/'candidate.v'),generation_parameters=generated.generation_parameters)
        except LLMGenerationError as exc:r['error']=str(exc)
        r['generation_seconds']=time.monotonic()-start;exclusive(f/'generation.json',r);rows.append(r)
    manifest=dict(protocol_sha256=sha(s/'protocol.json'),rows=rows)
    if not (s/'candidate_manifest.json').exists():exclusive(s/'candidate_manifest.json',manifest)
    assert load(s/'candidate_manifest.json')==manifest
    results=[]
    for r in rows:
        validate(s);f=s/r['arm']/f"trial_{r['trial']:02d}";m=None
        if r['candidate_sha256']:
            assert sha(f/'candidate.v')==r['candidate_sha256']
            m=load(f/'evaluation/result.json') if (f/'evaluation/result.json').exists() else evaluate(f/'candidate.v',f/'evaluation',s/'inputs/original.v',0,top='mux_large',parameters={})
        pool={'candidate':m} if m else {};chosen=choose(list(pool),pool,p['baseline'],p['area_cap_um2']);metrics=p['baseline'] if chosen=='baseline' else m
        results.append(dict(**r,raw_metrics=m,selected=chosen,retained_metrics=metrics))
    groups={}
    for arm in ARMS:
        rr=[r for r in results if r['arm']==arm];valid=[r for r in rr if r['status']=='GENERATED']
        groups[arm]=dict(attempts=len(rr),generated=len(valid),formal_pass=sum(bool(r['raw_metrics']) and r['raw_metrics'].get('formal')=='PASS' for r in rr),strict_improvements=sum(r['selected']!='baseline' for r in rr),gains_at_least_5pct=sum(r['retained_metrics']['max_data_arrival_ns']<=p['baseline']['max_data_arrival_ns']*.95 for r in rr),
            median_retained_delay_ns=statistics.median(r['retained_metrics']['max_data_arrival_ns'] for r in rr),best_retained_delay_ns=min(r['retained_metrics']['max_data_arrival_ns'] for r in rr),
            successful_generation_median_delay_ns=statistics.median(r['retained_metrics']['max_data_arrival_ns'] for r in valid) if valid else None)
    save(s/'summary.json',dict(state='COMPLETED_PENDING_AUDIT',actual_request_slots=10,groups=groups,trials=results));print(json.dumps(groups,indent=2),flush=True)
if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--execute',type=Path);a=ap.parse_args();execute(a.execute.resolve()) if a.execute else prepare()
