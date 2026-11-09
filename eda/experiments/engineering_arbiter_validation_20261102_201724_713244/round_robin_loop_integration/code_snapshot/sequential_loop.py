"""Native single-clock candidate loop using the verified sequential EDA backend."""
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
from datetime import datetime

try:
    from agents.rtl_optimizer import api_configured, generate_from_prompt
except ImportError:
    from rtl_optimizer import api_configured, generate_from_prompt

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'eda/experiments'))
from run_native_comb import parse_parameter_overrides
BACKEND = ROOT / 'eda/experiments/run_native_seq.py'
LIB = ROOT / 'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def save(p, x):
    p.write_text(json.dumps(x, indent=2, ensure_ascii=False, allow_nan=False)+'\n', encoding='utf-8')

def decision(metrics, best, area_cap):
    if not (metrics.get('status') == 'PASS' and metrics.get('eligible') is True
            and all(metrics.get(k) == 'PASS' for k in ('formal','mapped_formal','ppa'))
            and metrics.get('electrical',{}).get('status') == 'PASS'):
        return False, 'Incomplete or failed proof/EDA/electrical checks'
    for k in ('wns_ns','tns_ns','mapped_area_um2'):
        if not isinstance(metrics.get(k),(int,float)) or not math.isfinite(metrics[k]):
            return False, 'Missing finite metric: '+k
    if metrics['mapped_area_um2'] > area_cap:
        return False, 'Exceeds fixed baseline-derived area cap'
    if metrics['tns_ns'] < best['tns_ns'] - 1e-9:
        return False, 'TNS regressed'
    if metrics['wns_ns'] <= best['wns_ns'] + 1e-9:
        return False, 'No strict WNS improvement at report precision'
    return True, 'Strict WNS improvement, no TNS regression, within fixed area cap'

def feedback(folder, result):
    log = folder/'sta.log'
    text = log.read_text(encoding='utf-8',errors='replace') if log.exists() else ''
    starts = list(re.finditer(r'^Startpoint:', text, re.M))
    paths = [text[m.start():starts[i+1].start() if i+1<len(starts) else len(text)]
             for i,m in enumerate(starts[:10])]
    paths = [p.split('worst slack max',1)[0].split('PW_ELECTRICAL_BEGIN',1)[0].strip() for p in paths]
    return dict(metrics=result, measured_paths=paths, sta_log_sha256=sha(log) if log.exists() else None,
                scope='Actual mapped OpenSTA paths; internal names are not claimed to map precisely to source lines')

def make_prompt(rtl, contract, measured, previous, cap, dependency_sources=None):
    return dict(task='Improve setup WNS of the native RTL without changing cycle-level behavior.',
        constraints=[
            'Preserve top name, native ports and widths, signedness, reset polarity, enables and exact output latency.',
            'Keep a single direct positive-edge clock; do not introduce async reset, latches, memories or generated clocks.',
            'Do not add assume/assert, initial assignments or unknown/high-impedance values to evade verification.',
            'The original frozen RTL is the functional reference for every candidate, not the last candidate.',
            'Startup assumptions are fixed and identical for the original and all candidates; never extend them.',
            'Top parameter overrides and shared dependency modules are frozen. Do not redefine those helper modules in candidate_rtl.',
            'WNS is measured at fixed clock/IO/library settings. Do not claim measured improvements before EDA.'],
        startup_and_timing_contract=contract, fixed_mapped_area_cap_um2=cap,
        current_rtl=rtl, actual_eda_feedback=measured, previous_attempt=previous,
        fixed_dependency_sources=dependency_sources or [],
        response_format={k:'string' for k in ('candidate_rtl','bottleneck','rewrite','expected_timing_gain','area_or_other_cost','functional_boundaries')})

def configure_parser(sub):
    p=sub.add_parser('seq',help='evaluate native single-clock candidates under one frozen startup/timing contract')
    p.add_argument('--rtl',required=True)
    p.add_argument('--top',required=True)
    p.add_argument('--clock',required=True)
    p.add_argument('--reset')
    p.add_argument('--reset-active',type=int,choices=(0,1),default=1)
    p.add_argument('--reset-cycles',type=int,default=1)
    p.add_argument('--warmup',type=int,default=1)
    p.add_argument('--period',type=float,default=10)
    p.add_argument('--area-limit',type=float,default=1.10)
    p.add_argument('--timeout',type=int,default=120)
    p.add_argument('--param',action='append',default=[],metavar='NAME=INTEGER')
    p.add_argument('--dependency',action='append',type=Path,default=[],help='Shared frozen helper RTL; repeatable')
    mode=p.add_mutually_exclusive_group(required=True)
    mode.add_argument('--candidate-rtl',action='append',help='ordered manual replay; repeatable; no API call')
    mode.add_argument('--use-llm',action='store_true',help='explicitly enable paid model generation')
    p.add_argument('--max-candidates',type=int,default=1,help='LLM request budget, no automatic retry')
    p.add_argument('--model',default=os.environ.get('PIPEWEAVER_LLM_MODEL'))
    p.add_argument('--llm-timeout',type=int,default=120)
    p.add_argument('--out',type=Path)
    p.set_defaults(func=run)

def run(args):
    parameters=parse_parameter_overrides(args.param)
    dependency_sources=[p.resolve() for p in args.dependency]
    if not all(re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*',s) for s in (args.top,args.clock,args.reset or 'unused')):
        raise ValueError('Only plain native identifiers are supported')
    if args.reset == args.clock:
        raise ValueError('Clock and reset must differ')
    if args.warmup<1 or not 1<=args.reset_cycles<=args.warmup or (not args.reset and args.reset_cycles!=1):
        raise ValueError('Invalid fixed startup contract')
    if not math.isfinite(args.period) or args.period<=0 or not math.isfinite(args.area_limit) or args.area_limit<1:
        raise ValueError('Period must be positive; fixed area ratio must be finite and at least 1')
    if min(args.timeout,args.llm_timeout,args.max_candidates)<1 or args.max_candidates>20:
        raise ValueError('Positive tool limits and at most 20 LLM requests required')
    sources=[Path(args.rtl).resolve()]+[Path(p).resolve() for p in (args.candidate_rtl or [])]
    if not all(p.is_file() for p in sources+dependency_sources):
        raise ValueError('Missing original RTL or manual candidate')
    if len(set(dependency_sources))!=len(dependency_sources) or any(p in sources for p in dependency_sources):
        raise ValueError('Shared dependencies must be distinct helper files')
    if args.use_llm and (not api_configured() or not args.model):
        raise ValueError('LLM mode requires configured key and exact model ID')
    out=args.out.resolve() if args.out else ROOT/'eda/experiments'/datetime.now().strftime('native_seq_loop_%Y%m%d_%H%M%S_%f')
    out.mkdir(parents=True,exist_ok=False)
    inputs=out/'inputs';inputs.mkdir()
    copies=[]
    for i,p in enumerate(sources):
        target=inputs/('original.v' if i==0 else f'manual_{i:03d}.v')
        shutil.copyfile(p,target);copies.append(target)
    frozen_dependencies=[]
    for i,p in enumerate(dependency_sources,1):
        target=inputs/f'dependency_{i:03d}.v';shutil.copyfile(p,target);frozen_dependencies.append(target)
    snapshot=out/'code_snapshot';snapshot.mkdir()
    deps=[BACKEND,BACKEND.with_name('run_native_comb.py'),BACKEND.with_name('trace_sta_rtl_cone.py'),
          Path(__file__),Path(__file__).with_name('rtl_optimizer.py'),Path(__file__).with_name('optimization_loop.py')]
    hashes={str(p):sha(p) for p in deps}
    for p in deps:shutil.copyfile(p,snapshot/p.name)
    contract=dict(top=args.top,clock=args.clock,reset=args.reset,reset_active=args.reset_active,
                  parameter_overrides=parameters,
                  fixed_dependencies=[dict(name=p.name,sha256=sha(p)) for p in frozen_dependencies],
                  reset_cycles=args.reset_cycles if args.reset else 0,warmup_samples=args.warmup,period_ns=args.period,
                  reset_after_startup='unconstrained',preserve_output_latency=True,
                  input_delay_ns=0,output_delay_ns=0,input_transition_ns=0.10,output_load_pf=0.010,
                  library_sha256=sha(LIB),scope='Edge sampled only; no asynchronous reset, hold, parasitics or power signoff')
    protocol=dict(mode='llm' if args.use_llm else 'manual_replay',contract=contract,
        original_sha256=sha(copies[0]),inputs=[dict(path=str(p),sha256=sha(p)) for p in copies+frozen_dependencies],
        dependencies=hashes,area_limit=args.area_limit,timeout_per_tool_seconds=args.timeout,
        llm_timeout=args.llm_timeout,requested_model=args.model if args.use_llm else None,
        request_budget=args.max_candidates if args.use_llm else 0,candidate_budget=args.max_candidates if args.use_llm else len(copies)-1,
        selection='Strict WNS gain, TNS no worse, fixed original area ratio; preserve baseline when no candidate improves')
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    summary=dict(status='RUNNING',llm_requests_attempted=0,candidates=[],protocol_sha256=sha(out/'protocol.json'))
    save(out/'summary.json',summary)
    print('Experiment: '+str(out),flush=True)
    def verify():
        assert sha(out/'protocol.json')==summary['protocol_sha256'],'Protocol changed'
        assert all(sha(Path(p))==h for p,h in hashes.items()),'Code changed during run'
        assert all(sha(Path(p['path']))==p['sha256'] for p in protocol['inputs']),'Frozen input changed'
        assert sha(LIB)==contract['library_sha256'],'Library changed'
    def evaluate(source,folder):
        verify()
        cmd=[sys.executable,'-B',str(BACKEND),str(source),'--reference',str(copies[0]),'--top',args.top,
             '--clock',args.clock,'--warmup',str(args.warmup),'--period',str(args.period),
             '--timeout',str(args.timeout),'--out',str(folder)]
        for name,value in parameters.items():cmd+=['--param',f'{name}={value}']
        for p in frozen_dependencies:cmd+=['--dependency',str(p)]
        if args.reset:cmd+=['--reset',args.reset,'--reset-active',str(args.reset_active),'--reset-cycles',str(args.reset_cycles)]
        env=os.environ.copy()
        for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(key,None)
        try:
            proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=args.timeout*8)
            raw=proc.stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        folder.mkdir(exist_ok=True);(folder/'runner.log').write_bytes(raw)
        verify()
        return json.loads((folder/'result.json').read_text(encoding='utf-8')) if (folder/'result.json').exists() else dict(status='INCOMPLETE',eligible=False)
    baseline=evaluate(copies[0],out/'baseline');summary['baseline']=baseline
    if baseline.get('status')!='PASS' or not baseline.get('eligible'):
        summary['status']='BASELINE_FAILED';save(out/'summary.json',summary);return 1
    cap=baseline['mapped_area_um2']*args.area_limit
    summary['fixed_area_cap_um2']=cap
    best_path,best_folder,best=copies[0],out/'baseline',baseline
    best_index=dict(rtl='best.v',source='baseline',metrics=best)
    shutil.copyfile(best_path,out/'best.v');best_index['sha256']=sha(out/'best.v');save(out/'best.json',best_index)
    previous=None
    for i in range(1,protocol['candidate_budget']+1):
        verify();folder=out/f'candidate_{i:03d}';folder.mkdir()
        measured=feedback(best_folder,best)
        prompt=make_prompt(best_path.read_text(encoding='utf-8'),contract,measured,previous,cap,
            dependency_sources=[dict(name=p.name,sha256=sha(p),rtl=p.read_text(encoding='utf-8')) for p in frozen_dependencies])
        prompt_text=json.dumps(prompt,ensure_ascii=False,indent=2)
        (folder/'prompt.json').write_text(prompt_text,encoding='utf-8')
        row=dict(index=i,origin=protocol['mode'],accepted=False,prompt_sha256=sha(folder/'prompt.json'),
                 feedback_source=str(best_folder),feedback_sha256=measured['sta_log_sha256'])
        candidate=folder/'candidate.v'
        if args.use_llm:
            summary['llm_requests_attempted']+=1;save(out/'summary.json',summary)
            try:
                generated=generate_from_prompt(prompt_text,model=args.model,candidate_index=i,
                    timeout_s=args.llm_timeout,audit_dir=folder/'generation')
                candidate.write_text(generated.rtl,encoding='utf-8')
                save(folder/'generation_metadata.json',dict(explanation=generated.explanation,
                     response_model=generated.model,parameters=generated.generation_parameters))
            except Exception as exc:
                row.update(status='GENERATION_FAILED',reason=str(exc));previous=row
                summary['candidates'].append(row);save(folder/'decision.json',row);save(out/'summary.json',summary);continue
        else:shutil.copyfile(copies[i],candidate)
        row['candidate_sha256']=sha(candidate)
        metrics=evaluate(candidate,folder/'eda')
        accepted,reason=decision(metrics,best,cap)
        row.update(status=metrics['status'],metrics=metrics,accepted=accepted,reason=reason)
        if accepted:
            best_path,best_folder,best=candidate,folder/'eda',metrics
            shutil.copyfile(candidate,out/'best.v')
            save(out/'best.json',dict(rtl='best.v',source=folder.name,sha256=sha(out/'best.v'),metrics=best))
        previous=dict(index=i,accepted=accepted,reason=reason,metrics=metrics)
        save(folder/'decision.json',row);summary['candidates'].append(row);save(out/'summary.json',summary)
        print(f'Candidate {i}: {metrics["status"]}; accepted={accepted}; {reason}',flush=True)
    verify();summary['status']='COMPLETED';save(out/'summary.json',summary)
    print('Best: '+str(out/'best.json'),flush=True)
    return 0
