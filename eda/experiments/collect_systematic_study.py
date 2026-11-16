"""Bounded model collection for the frozen systematic engineering study."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import random
import shutil
import statistics
import sys
import threading
import time
from types import SimpleNamespace

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.adaptive_optimizer import generate, timing_text
from agents.portfolio_loop import load, save, sha
from agents.sequential_loop import decision as sequential_decision
from agents.sse_transport import StreamError
from eda.experiments.run_systematic_study import eligible, evaluate, verify_protocol


def atomic_save(path,value):
    temporary=path.with_suffix(path.suffix+'.tmp')
    temporary.write_text(json.dumps(value,ensure_ascii=False,indent=2,allow_nan=False),encoding='utf-8')
    temporary.replace(path)


def accepted(case,metrics,baseline):
    if not eligible(case,metrics):
        return False
    if case['backend']=='sequential':
        return sequential_decision(metrics,baseline,baseline['mapped_area_um2']*1.1)[0]
    return (metrics['mapped_area_um2']<=baseline['mapped_area_um2']*1.1+1e-9
            and metrics['tns_ns']>=baseline['tns_ns']
            and metrics['max_data_arrival_ns']<baseline['max_data_arrival_ns'])


def better(case,first,second):
    if case['backend']=='sequential':
        return (first['wns_ns'],-first['mapped_area_um2'])>(second['wns_ns'],-second['mapped_area_um2'])
    return (first['max_data_arrival_ns'],first['mapped_area_um2'])<(second['max_data_arrival_ns'],second['mapped_area_um2'])


def target_reached(case,metrics,baseline):
    if case['backend']=='sequential':
        return metrics['wns_ns']-baseline['wns_ns']>=0.1-1e-9
    return 1-metrics['max_data_arrival_ns']/baseline['max_data_arrival_ns']>=0.05-1e-9


def rejection_reason(case,metrics,baseline):
    if not eligible(case,metrics):
        return 'VALIDATION_'+metrics.get('stage',metrics.get('status','INCOMPLETE'))
    if metrics['mapped_area_um2']>baseline['mapped_area_um2']*1.1+1e-9:
        return 'AREA_LIMIT'
    if metrics['tns_ns']<baseline['tns_ns']:
        return 'TNS_REGRESSION'
    if not accepted(case,metrics,baseline):
        return 'NO_TIMING_GAIN'
    return None


def schedule(protocol,maximum):
    if maximum not in (54,162,216):
        raise ValueError('Supported pilot/engineering/full limits are 54, 162 and 216')
    jobs=[]
    repeats=1 if maximum==54 else 3
    for repeat in range(1,repeats+1):
        for case in protocol['cases'][:6]:
            for strategy in ('direct','sta','adaptive'):
                jobs.append(dict(case=case['id'],strategy=strategy,repeat=repeat,max_rounds=3))
    if maximum==216:
        selected=set(protocol['planned_parameter_scan']['cases'])
        for repeat in range(1,4):
            for case in protocol['cases']:
                if case['id'] in selected:
                    for strategy in ('direct','sta'):
                        jobs.append(dict(case=case['id'],strategy=strategy,repeat=repeat,max_rounds=1))
    random.Random(20261116).shuffle(jobs)
    for index,job in enumerate(jobs,1):
        job['id']=f'job_{index:03d}'
    if sum(job['max_rounds'] for job in jobs)!=maximum:
        raise ValueError('Schedule and budget disagree')
    return jobs


def metrics_for_prompt(metrics):
    return {key:metrics[key] for key in ('status','formal','mapped_formal','ppa','electrical',
            'wns_ns','tns_ns','max_data_arrival_ns','mapped_area_um2','stage','failure_reason') if key in metrics}


def build_prompt(study,case,baseline,route,previous=None):
    contract=(
        'Preserve exact cycle-by-cycle behavior, clock, synchronous reset, registered latency, valid/ready and all outputs. '
        'All initial DUT states are independent arbitrary defined values. All initialization attributes are stripped. '
        'Reset is asserted at the first sample, and all outputs are compared from sample2 forever. '
        'All later inputs and repeated reset are unconstrained. No extra startup or input assumptions. '
        'Keep existing named register/state encodings where possible for the declared auxiliary proof targets. '
        if case['backend']=='sequential' else
        'Every input bit is arbitrary binary data and every output bit must match for every input. '
        'No state or added latency. CRC state_in is arbitrary; data_out and state_out must both match exactly. '
    )
    objective='Increase setup WNS' if case['backend']=='sequential' else 'Reduce maximum data arrival'
    prompt=(f'{objective} for module {case["top"]}, fixed parameter overrides '
        f'{json.dumps(case["parameters"],sort_keys=True)}. {contract}'
        'Preserve module name, ports, signedness, priority and default behavior, truncation and parameters. '
        'No latches, memories, generated clocks, asynchronous reset, includes, file access, formal assumptions, '
        'assertions or undefined outputs. Supply a complete design including required helper modules. '
        'Evaluation uses SKY130HD TT25C1.80V, fixed library/mapping and interface constraints. '
        f'Clock period for sequential cases is {case["period_ns"]}ns. '
        f'Original-relative area cap is {baseline["mapped_area_um2"]*1.1:.6f}um2. '
        'Source and mapped equivalence, STA and electrical checks must pass. '
        'Return exactly one JSON object with six string fields candidate_rtl, bottleneck, rewrite, '
        'expected_timing_gain, area_or_other_cost, functional_boundaries.\nOriginal reference RTL:\n'
        +(study/case['input']).read_text(encoding='utf-8-sig'))
    if route in ('sta','feedback'):
        prompt+='\nActual baseline measurements:\n'+json.dumps(metrics_for_prompt(baseline))
        prompt+='\nActual baseline STA paths, mapped names do not establish exact source attribution:\n'
        folder=study/'baselines'/case['id']
        prompt+=timing_text(folder/'eda' if case['backend']=='crc_slang' else folder)
    if route=='feedback' and previous is not None:
        if previous.get('candidate'):
            prompt+='\nPrevious candidate RTL:\n'+Path(previous['candidate']).read_text(encoding='utf-8-sig')
        prompt+='\nActual previous result:\n'+json.dumps(metrics_for_prompt(previous.get('metrics',{})))
        folder=Path(previous['evaluation']) if previous.get('evaluation') else None
        if folder and not eligible(case,previous.get('metrics',{})):
            for name in ('formal.log','mapped_formal.log','candidate_schema.log','frontend.log'):
                for log in (folder/name,folder/'eda'/name):
                    if log.is_file():
                        prompt+='\nValidation '+name+'\n'+log.read_text(encoding='utf-8',errors='replace')[-4000:]
    return prompt.replace(str(ROOT),'<PROJECT>').replace(ROOT.as_posix(),'<PROJECT>')


class CallBudget:
    def __init__(self,folder,maximum):
        self.folder=folder
        self.maximum=maximum
        self.used=0
        self.consecutive_failures=0
        self.halted=False
        self.lock=threading.Lock()
        folder.mkdir()

    def reserve(self,job,round_index):
        with self.lock:
            if self.halted or self.used>=self.maximum:
                return None
            self.used+=1
            folder=self.folder/f'request_{self.used:03d}'
            folder.mkdir()
            save(folder/'slot.json',dict(index=self.used,job=job,round=round_index,automatic_retries=0))
            return folder

    def finish(self,transport_failed):
        with self.lock:
            self.consecutive_failures=self.consecutive_failures+1 if transport_failed else 0
            if self.consecutive_failures>=3:
                self.halted=True
                atomic_save(self.folder.parent/'HALTED.json',dict(reason='Three consecutive completed transport failures',
                    reserved_requests=self.used,maximum_requests=self.maximum))


def execute(study,maximum):
    protocol=verify_protocol(study)
    if not os.environ.get('OPENAI_API_KEY','').strip():
        raise ValueError('Configured API key missing')
    jobs=schedule(protocol,maximum)
    plan_path=study/'EXECUTION_PLAN.json'
    if plan_path.exists() or (study/'calls').exists():
        raise ValueError('This collection already started; use report and inspect its saved attempts')
    model=protocol['generation']['model']
    save(plan_path,dict(maximum_requests=maximum,jobs=jobs,model=model,
        endpoint=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/'),
        generation=protocol['generation'],collector_sha256=sha(Path(__file__)),
        protocol_sha256=sha(study/'protocol.json'),
        runtime_dependencies={name:sha(ROOT/name) for name in
            ('agents/adaptive_optimizer.py','agents/rtl_optimizer.py','agents/sse_transport.py',
             'eda/experiments/run_stream_feedback.py')},
        policies='Direct and STA sample original-reference prompts. Adaptive starts direct and uses actual failures/metrics. All strategies share targets and stop rules.'))
    budget=CallBudget(study/'calls',maximum)
    run_root=study/'runs'
    run_root.mkdir()
    cases={case['id']:case for case in protocol['cases']}
    args=SimpleNamespace(model=model,max_completion_tokens=protocol['generation']['max_completion_tokens'],
                         llm_timeout=protocol['generation']['timeout_seconds'])

    def one(job):
        folder=run_root/job['id']
        folder.mkdir()
        case=cases[job['case']]
        baseline_path=study/'baselines'/case['id']/'result.json'
        baseline=load(baseline_path) if baseline_path.is_file() else {}
        reference=study/case['input']
        if not eligible(case,baseline):
            result=dict(**job,status='BASELINE_NOT_QUALIFIED',model_requests=0,candidates=[])
            save(folder/'RESULT.json',result)
            return result
        best=baseline
        best_source=reference
        cache={sha(reference):baseline}
        rows=[]
        previous=None
        route=job['strategy'] if job['strategy']!='adaptive' else 'direct'
        started=time.monotonic()
        stopped='budget_exhausted'
        for round_index in range(1,job['max_rounds']+1):
            prompt=build_prompt(study,case,baseline,route,previous)
            call=budget.reserve(job,round_index)
            if call is None:
                stopped='global_budget_or_transport_stop'
                break
            (call/'prompt.txt').write_text(prompt,encoding='utf-8')
            row=dict(request=call.name,case=case['id'],job=job['id'],round=round_index,route=route,
                     status='GENERATION_FAILED',failure_class='TRANSPORT',metrics={},usage=None)
            generation_started=time.monotonic()
            try:
                rtl,usage,reported_model=generate(prompt,args,call)
                candidate=call/'candidate.v'
                candidate.write_text(rtl,encoding='utf-8')
                row.update(status='GENERATED',failure_class=None,usage=usage,reported_model=reported_model,
                           candidate=str(candidate),rtl_sha256=sha(candidate))
                budget.finish(False)
            except Exception as error:
                row.update(error_type=type(error).__name__,
                           failure_class='TRANSPORT' if isinstance(error,StreamError) else 'FORMAT')
                if (call/'response.json').exists():
                    row['usage']=load(call/'response.json').get('usage')
                budget.finish(row['failure_class']=='TRANSPORT')
            row['generation_seconds']=time.monotonic()-generation_started
            if row['status']=='GENERATED':
                evaluation=call/'evaluation'
                row['evaluation']=str(evaluation)
                evaluation_started=time.monotonic()
                if row['rtl_sha256'] in cache:
                    row['metrics']=cache[row['rtl_sha256']]
                    row['shared_evaluation']=True
                else:
                    try:
                        row['metrics']=evaluate(Path(row['candidate']),reference,case,evaluation)
                    except Exception as error:
                        row['metrics']=dict(status='INCOMPLETE',stage='evaluator',error_type=type(error).__name__)
                    cache[row['rtl_sha256']]=row['metrics']
                    row['shared_evaluation']=False
                row['evaluation_seconds']=time.monotonic()-evaluation_started
            row['accepted']=accepted(case,row['metrics'],baseline)
            row['rejection_reason']=rejection_reason(case,row['metrics'],baseline)
            if row['accepted'] and better(case,row['metrics'],best):
                best=row['metrics']
                best_source=Path(row['candidate'])
            save(call/'RESULT.json',row)
            rows.append(row)
            previous=row
            atomic_save(folder/'PROGRESS.json',dict(rounds=len(rows),last_request=call.name,best=best))
            print(f'{call.name} {job["id"]} {case["id"]} {job["strategy"]} R{round_index} {row["status"]} EDA={row["metrics"].get("status")} accepted={row["accepted"]}',flush=True)
            if target_reached(case,best,baseline):
                stopped='target_reached'
                break
            if job['strategy']=='adaptive':
                route='sta' if route=='direct' and eligible(case,row['metrics']) else 'feedback'
        shutil.copyfile(best_source,folder/'best.v')
        result=dict(**job,status='COMPLETE',model_requests=len(rows),stopped=stopped,
                    baseline=baseline,best_metrics=best,best_sha256=sha(folder/'best.v'),
                    improved=accepted(case,best,baseline),elapsed_seconds=time.monotonic()-started,candidates=rows)
        save(folder/'RESULT.json',result)
        return result

    with ThreadPoolExecutor(max_workers=2) as pool:
        list(pool.map(one,jobs))
    return report(study)


def report(study):
    protocol=load(study/'protocol.json')
    cases={case['id']:case for case in protocol['cases']}
    runs=[load(path) for path in sorted((study/'runs').glob('job_*/RESULT.json'))]
    calls=[load(path) for path in sorted((study/'calls').glob('request_*/RESULT.json'))]
    groups=[]
    for case_id in sorted({run['case'] for run in runs}):
        case=cases[case_id]
        for strategy in ('direct','sta','adaptive'):
            rows=[run for run in runs if run['case']==case_id and run['strategy']==strategy]
            if not rows:
                continue
            completed=[run for run in rows if run['status']=='COMPLETE']
            key='wns_ns' if case['backend']=='sequential' else 'max_data_arrival_ns'
            values=sorted(run['best_metrics'][key] for run in completed)
            groups.append(dict(case=case_id,strategy=strategy,scheduled_runs=len(rows),
                completed_runs=len(completed),improved_runs=sum(run.get('improved',False) for run in rows),
                attempted_calls=sum(run['model_requests'] for run in rows),metric=key,
                median_retained_metric=statistics.median(values) if values else None))
    failures=Counter()
    for row in calls:
        if row.get('failure_class'):
            failures[row['failure_class']]+=1
        elif not row['accepted']:
            failures[row.get('rejection_reason','VALIDATION_UNKNOWN')]+=1
    known=[row['usage']['total_tokens'] for row in calls
           if isinstance(row.get('usage'),dict) and type(row['usage'].get('total_tokens')) is int]
    result=dict(reserved_attempts=len(list((study/'calls').glob('request_*/slot.json'))),
        model_attempt_markers=len(list((study/'calls').glob('request_*/api_audit/attempt.json'))),
        completed_call_records=len(calls),generated_rtl=sum(row['status']=='GENERATED' for row in calls),
        distinct_rtl_hashes=len({row['rtl_sha256'] for row in calls if row.get('rtl_sha256')}),
        distinct_case_and_rtl=len({(row['case'],row['rtl_sha256']) for row in calls if row.get('rtl_sha256')}),
        qualified_improvement_slots=sum(row['accepted'] for row in calls),
        reported_tokens=sum(known),usage_unknown=len(calls)-len(known),
        failures=dict(failures),groups=groups,
        scope='Within fixed tasks and contracts; candidate hashes count source diversity; repeated runs are not different circuit families')
    atomic_save(study/'MODEL_SUMMARY.json',result)
    return result


def main(argv=None):
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode',choices=('plan','execute','report'))
    parser.add_argument('--study',type=Path,required=True)
    parser.add_argument('--max-requests',type=int,choices=(54,162,216),default=54)
    args=parser.parse_args(argv)
    study=args.study.resolve()
    if args.mode=='plan':
        jobs=schedule(verify_protocol(study),args.max_requests)
        print(json.dumps(dict(jobs=len(jobs),maximum_requests=sum(job['max_rounds'] for job in jobs),
            model_requests=0),ensure_ascii=False))
    elif args.mode=='execute':
        print(json.dumps(execute(study,args.max_requests),ensure_ascii=False,indent=2))
    else:
        print(json.dumps(report(study),ensure_ascii=False,indent=2))


if __name__=='__main__':
    main()
