"""Balanced one-call repetitions within the existing explicit total quota."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import random
import shutil
import sys
import threading
import time
from types import SimpleNamespace

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.adaptive_optimizer import generate
from agents.portfolio_loop import load, save, sha
from agents.sse_transport import StreamError
from eda.experiments.collect_systematic_study import accepted, atomic_save, build_prompt, rejection_reason
from eda.experiments.run_systematic_study import eligible, evaluate, verify_protocol


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--study',type=Path,required=True)
    args=parser.parse_args()
    study=args.study.resolve()
    protocol=verify_protocol(study)
    policy=load(study/'SUPPLEMENT_POLICY.json')
    authorization=load(study/'AUTHORIZATION.json')
    pilot=load(study/'EXECUTION_PLAN.json')
    if (study/'HALTED.json').exists():
        raise ValueError('Transport halt remains active')
    completed=list((study/'runs').glob('job_*/RESULT.json'))
    if len(completed)!=len(pilot['jobs']):
        raise ValueError('Pilot still running or incomplete')
    if (study/'SUPPLEMENT_PLAN.json').exists():
        raise ValueError('Supplement already started')
    maximum=min(authorization['maximum_requests'],policy['maximum_total_requests_including_pilot'])
    existing=len(list((study/'calls').glob('request_*/slot.json')))
    cases=[]
    for case in protocol['cases'][:6]:
        baseline=load(study/'baselines'/case['id']/'result.json')
        if eligible(case,baseline):
            cases.append((case,baseline))
    cohort_size=len(cases)*len(policy['strategies'])
    cohorts=min(policy['maximum_additional_cohorts'],(maximum-existing)//cohort_size)
    jobs=[]
    for repeat in range(2,2+cohorts):
        for case,baseline in cases:
            for strategy in policy['strategies']:
                jobs.append(dict(case=case,strategy=strategy,repeat=repeat,baseline=baseline))
    random.Random(policy['random_seed']).shuffle(jobs)
    save(study/'SUPPLEMENT_PLAN.json',dict(existing_requests=existing,maximum_total_requests=maximum,
        additional_requests=len(jobs),complete_cohorts=cohorts,policy_sha256=sha(study/'SUPPLEMENT_POLICY.json'),
        collector_sha256=sha(Path(__file__)),jobs=[dict(case=j['case']['id'],strategy=j['strategy'],repeat=j['repeat']) for j in jobs]))
    state=dict(used=existing,consecutive_failures=0,halted=False)
    lock=threading.Lock()
    run_root=study/'supplement_runs'
    run_root.mkdir()
    generation=protocol['generation']
    model_args=SimpleNamespace(model=generation['model'],max_completion_tokens=generation['max_completion_tokens'],
                               llm_timeout=generation['timeout_seconds'])

    def one(job):
        case=job['case']
        baseline=job['baseline']
        route='direct' if job['strategy']=='adaptive' else job['strategy']
        prompt=build_prompt(study,case,baseline,route)
        with lock:
            if state['halted'] or state['used']>=maximum:
                return
            state['used']+=1
            index=state['used']
            call=study/'calls'/f'request_{index:03d}'
            call.mkdir()
            save(call/'slot.json',dict(index=index,case=case['id'],strategy=job['strategy'],
                 repeat=job['repeat'],round=1,cohort='one_call_supplement',automatic_retries=0))
        (call/'prompt.txt').write_text(prompt,encoding='utf-8')
        row=dict(request=call.name,case=case['id'],strategy=job['strategy'],repeat=job['repeat'],round=1,
                 route=route,cohort='one_call_supplement',status='GENERATION_FAILED',metrics={},usage=None)
        started=time.monotonic()
        try:
            rtl,usage,reported_model=generate(prompt,model_args,call)
            source=call/'candidate.v'
            source.write_text(rtl,encoding='utf-8')
            row.update(status='GENERATED',usage=usage,reported_model=reported_model,
                       candidate=str(source),rtl_sha256=sha(source))
        except Exception as error:
            row.update(error_type=type(error).__name__,failure_class='TRANSPORT' if isinstance(error,StreamError) else 'FORMAT')
            if (call/'response.json').exists():
                row['usage']=load(call/'response.json').get('usage')
        row['generation_seconds']=time.monotonic()-started
        with lock:
            state['consecutive_failures']=state['consecutive_failures']+1 if row.get('failure_class')=='TRANSPORT' else 0
            if state['consecutive_failures']>=3:
                state['halted']=True
                atomic_save(study/'HALTED.json',dict(reason='Three consecutive completed transport failures',reserved_requests=state['used']))
        if row['status']=='GENERATED':
            evaluation=call/'evaluation'
            row['evaluation']=str(evaluation)
            started=time.monotonic()
            try:
                row['metrics']=evaluate(Path(row['candidate']),study/case['input'],case,evaluation)
            except Exception as error:
                row['metrics']=dict(status='INCOMPLETE',stage='evaluator',error_type=type(error).__name__)
            row['evaluation_seconds']=time.monotonic()-started
        row['accepted']=accepted(case,row['metrics'],baseline)
        row['rejection_reason']=rejection_reason(case,row['metrics'],baseline)
        save(call/'RESULT.json',row)
        run=run_root/f'run_{index:03d}'
        run.mkdir()
        shutil.copyfile(Path(row['candidate']) if row['accepted'] else study/case['input'],run/'best.v')
        save(run/'RESULT.json',dict(**row,baseline=baseline,max_rounds=1,model_requests=1))
        print(f'{call.name} {case["id"]} {job["strategy"]} repeat={job["repeat"]} {row["status"]} accepted={row["accepted"]}',flush=True)

    with ThreadPoolExecutor(max_workers=2) as pool:
        list(pool.map(one,jobs))
    atomic_save(study/'SUPPLEMENT_COMPLETION.json',dict(total_reserved_requests=state['used'],
        additional_completed=len(list(run_root.glob('run_*/RESULT.json'))),halted=state['halted'],maximum_total_requests=maximum))


if __name__=='__main__':
    main()
