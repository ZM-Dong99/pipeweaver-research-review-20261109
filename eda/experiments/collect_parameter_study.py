"""Frozen 54-call width sweep with paired direct/STA first-round candidates."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import copy
import json
import os
from pathlib import Path
import random
import shutil
import statistics
import sys
import time
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.adaptive_optimizer import generate
from agents.portfolio_loop import load, save, sha
from agents.sse_transport import StreamError
from eda.experiments.check_multicircuit_definedness import prove as prove_defined
from eda.experiments.collect_systematic_study import CallBudget, accepted, atomic_save, build_prompt, rejection_reason
from eda.experiments.run_systematic_study import eligible, evaluate, verify_protocol

SOURCE = ROOT / 'eda/experiments/systematic_engineering_20261116_v3'
CASE_IDS = ('alu16', 'alu32', 'alu64', 'priority64', 'priority128', 'priority256',
            'crc32_d4', 'crc32_d8', 'crc32_d16')


def schedule():
    jobs = []
    randomizer = random.Random(20261117)
    for repeat in range(1, 4):
        block = [dict(case=case, strategy=strategy, repeat=repeat)
                 for case in CASE_IDS for strategy in ('direct', 'sta')]
        randomizer.shuffle(block)
        jobs.extend(block)
    for index, job in enumerate(jobs, 1):
        job['id'] = f'job_{index:03d}'
    return jobs


def prepare(study):
    original = verify_protocol(SOURCE)
    study.mkdir(parents=True, exist_ok=False)
    protocol = copy.deepcopy(original)
    protocol['purpose'] = 'Three width points per family, direct versus STA, three single-call repeats'
    protocol['cases'] = [case for case in original['cases'] if case['id'] in CASE_IDS]
    protocol['source_study'] = dict(path=SOURCE.relative_to(ROOT).as_posix(),
                                  protocol_sha256=sha(SOURCE / 'protocol.json'))
    protocol['schedule'] = schedule()
    protocol['maximum_requests'] = 54
    protocol['random_seed'] = 20261117
    protocol['grouping'] = 'Three randomized blocks, each has all nine cases and both strategies; one call per job'
    protocol['analysis'] = ('Keep all 54 scheduled jobs, including generation/validation failures. '
                            'Report distinct hashes and case/hash pairs, qualification, improvements, '
                            'median retained arrival and gain, failure distribution. All pins must be defined.')
    protocol['model_collection'] = 'Explicit user authorization received 2026-11-17'
    for name in ('planned_engineering', 'planned_parameter_scan', 'budget_variants'):
        protocol.pop(name, None)
    protocol['source_dependencies'][str(Path(__file__).relative_to(ROOT))] = sha(Path(__file__))
    protocol['source_dependencies']['eda/experiments/check_multicircuit_definedness.py'] = sha(
        ROOT / 'eda/experiments/check_multicircuit_definedness.py')
    for case in protocol['cases']:
        baseline = load(SOURCE / 'baselines' / case['id'] / 'result.json')
        if not eligible(case, baseline):
            raise ValueError('Unqualified baseline ' + case['id'])
        destination = study / case['input']
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(SOURCE / case['input'], destination)
        shutil.copytree(SOURCE / 'baselines' / case['id'], study / 'baselines' / case['id'],
                        ignore=shutil.ignore_patterns('tmp', 'yosys_tmp', 'slang_tmp'))
    save(study / 'protocol.json', protocol)
    (study / 'protocol.sha256').write_text(sha(study / 'protocol.json') + '\n', encoding='ascii')
    save(study / 'AUTHORIZATION.json', dict(date='2026-11-17',
        approval_text='允许参数扫描，新增最多54次', endpoint='https://apinebula.ai/v1',
        model='gpt-6.1-sol', maximum_requests=54, maximum_concurrency=2,
        max_completion_tokens=16000, timeout_seconds=600, automatic_retries=0,
        stop_after_consecutive_transport_failures=3, cases=list(CASE_IDS),
        materials='Public RTL, functional/mapping constraints, baseline STA reports for STA group',
        fees='May incur charges; actual cost pending provider billing'))
    return dict(cases=len(protocol['cases']), scheduled_jobs=len(protocol['schedule']), model_requests=0)


def audit_definedness(study, case, call):
    evaluation = call / 'evaluation'
    if case['backend'] == 'crc_slang':
        source = evaluation / 'candidate/elaborated.v'
        schema = evaluation / 'candidate/source.json'
        parameters = {}
    else:
        source = call / 'candidate.v'
        schema = evaluation / 'candidate_schema.json'
        parameters = case['parameters']
    ports = load(schema)['modules'][case['top']]['ports']
    return prove_defined(source, case['top'], parameters, ports, call / 'definedness')


def execute(study):
    protocol = verify_protocol(study)
    authorization = load(study / 'AUTHORIZATION.json')
    endpoint = os.environ.get('OPENAI_BASE_URL', '').rstrip('/')
    if endpoint != authorization['endpoint'] or not os.environ.get('OPENAI_API_KEY', '').strip():
        raise ValueError('Approved endpoint and configured key required')
    if authorization['maximum_requests'] != 54 or len(protocol['schedule']) != 54:
        raise ValueError('Authorized budget and frozen schedule disagree')
    expected_generation = dict(model='gpt-6.1-sol', max_completion_tokens=16000,
                               timeout_seconds=600, concurrency=2, automatic_retries=0,
                               stop_after_consecutive_transport_failures=3)
    if protocol['generation'] != expected_generation:
        raise ValueError('Generation settings differ from explicit authorization')
    if (study / 'EXECUTION_PLAN.json').exists() or (study / 'calls').exists():
        raise ValueError('Collection already started; inspect saved attempts, never resend')
    save(study / 'EXECUTION_PLAN.json', dict(maximum_requests=54, jobs=protocol['schedule'],
        model=authorization['model'], endpoint=endpoint, generation=protocol['generation'],
        protocol_sha256=sha(study / 'protocol.json'), collector_sha256=sha(Path(__file__)),
        runtime_dependencies={name: sha(ROOT / name) for name in
            ('agents/adaptive_optimizer.py', 'agents/rtl_optimizer.py', 'agents/sse_transport.py',
             'eda/experiments/run_stream_feedback.py', 'eda/experiments/collect_systematic_study.py')}))
    budget = CallBudget(study / 'calls', 54)
    run_root = study / 'runs'
    run_root.mkdir()
    cases = {case['id']: case for case in protocol['cases']}
    generation = protocol['generation']
    args = SimpleNamespace(model=authorization['model'], max_completion_tokens=16000, llm_timeout=600)

    def one(job):
        case = cases[job['case']]
        baseline = load(study / 'baselines' / case['id'] / 'result.json')
        folder = run_root / job['id']
        folder.mkdir()
        call = budget.reserve(job, 1)
        if call is None:
            save(folder / 'RESULT.json', dict(**job, status='NOT_ATTEMPTED_TRANSPORT_STOP',
                                             model_requests=0, accepted=False))
            return
        prompt = build_prompt(study, case, baseline, job['strategy'])
        (call / 'prompt.txt').write_text(prompt, encoding='utf-8')
        row = dict(**job, request=call.name, round=1, route=job['strategy'],
                   status='GENERATION_FAILED', failure_class=None, metrics={}, usage=None)
        started = time.monotonic()
        try:
            rtl, usage, model = generate(prompt, args, call)
            source = call / 'candidate.v'
            source.write_text(rtl, encoding='utf-8')
            row.update(status='GENERATED', usage=usage, reported_model=model,
                       rtl_sha256=sha(source), candidate=str(source))
        except Exception as error:
            row.update(error_type=type(error).__name__,
                       failure_class='TRANSPORT' if isinstance(error, StreamError) else 'FORMAT')
            if (call / 'response.json').is_file():
                row['usage'] = load(call / 'response.json').get('usage')
        row['generation_seconds'] = time.monotonic() - started
        budget.finish(row['failure_class'] == 'TRANSPORT')
        if row['status'] == 'GENERATED':
            started = time.monotonic()
            row['evaluation'] = str(call / 'evaluation')
            try:
                row['metrics'] = evaluate(Path(row['candidate']), study / case['input'], case, call / 'evaluation')
                if eligible(case, row['metrics']):
                    defined = audit_definedness(study, case, call)
                    row['definedness'] = defined
                    if not defined['passed']:
                        row['metrics'] = dict(row['metrics'], eligible=False, stage='definedness')
            except Exception as error:
                row['metrics'] = dict(status='INCOMPLETE', stage='evaluator', error_type=type(error).__name__)
            row['evaluation_seconds'] = time.monotonic() - started
        row['accepted'] = accepted(case, row['metrics'], baseline)
        row['rejection_reason'] = rejection_reason(case, row['metrics'], baseline)
        save(call / 'RESULT.json', row)
        shutil.copyfile(Path(row['candidate']) if row['accepted'] else study / case['input'], folder / 'best.v')
        save(folder / 'RESULT.json', dict(**row, baseline=baseline, model_requests=1))
        print(f'{call.name} {case["id"]} {job["strategy"]} repeat={job["repeat"]} '
              f'{row["status"]} EDA={row["metrics"].get("status")} accepted={row["accepted"]}', flush=True)

    with ThreadPoolExecutor(max_workers=generation['concurrency']) as pool:
        list(pool.map(one, protocol['schedule']))
    atomic_save(study / 'COMPLETION.json', dict(reserved_requests=budget.used, maximum_requests=54,
        halted=budget.halted, completed_jobs=len(list(run_root.glob('job_*/RESULT.json')))))
    return report(study)


def report(study):
    protocol = load(study / 'protocol.json')
    cases = {case['id']: case for case in protocol['cases']}
    calls = [load(path) for path in sorted((study / 'calls').glob('request_*/RESULT.json'))]
    groups = []
    for case_id, case in cases.items():
        baseline = load(study / 'baselines' / case_id / 'result.json')
        for strategy in ('direct', 'sta'):
            rows = [row for row in calls if row['case'] == case_id and row['strategy'] == strategy]
            qualified = [row for row in rows if eligible(case, row['metrics'])
                         and row['metrics']['mapped_area_um2'] <= baseline['mapped_area_um2'] * 1.1 + 1e-9
                         and row['metrics']['tns_ns'] >= baseline['tns_ns']]
            retained = [row['metrics']['max_data_arrival_ns'] if row['accepted'] else baseline['max_data_arrival_ns']
                        for row in rows]
            improvements = [row for row in rows if row['accepted']]
            best = min(improvements, key=lambda row: row['metrics']['max_data_arrival_ns']) if improvements else None
            groups.append(dict(case=case_id, strategy=strategy, scheduled=3, attempted=len(rows),
                generated=sum(row['status'] == 'GENERATED' for row in rows), qualified=len(qualified),
                improvements=len(improvements), baseline=baseline,
                median_retained_arrival_ns=statistics.median(retained) if retained else None,
                median_retained_gain_percent=statistics.median(
                    100 * (1 - value / baseline['max_data_arrival_ns']) for value in retained) if retained else None,
                best_request=best['request'] if best else None, best_metrics=best['metrics'] if best else baseline))
    usage = [row['usage']['total_tokens'] for row in calls if isinstance(row.get('usage'), dict)
             and type(row['usage'].get('total_tokens')) is int]
    result = dict(scheduled=54, attempted=len(list((study / 'calls').glob('request_*/slot.json'))),
        completed_call_records=len(calls), generated=sum(row['status'] == 'GENERATED' for row in calls),
        distinct_rtl_hashes=len({row['rtl_sha256'] for row in calls if row.get('rtl_sha256')}),
        distinct_case_and_rtl=len({(row['case'], row['rtl_sha256']) for row in calls if row.get('rtl_sha256')}),
        qualified=sum(group['qualified'] for group in groups), improvements=sum(row['accepted'] for row in calls),
        failure_distribution=dict(Counter(row['failure_class'] or row['rejection_reason'] for row in calls if not row['accepted'])),
        reported_total_tokens=sum(usage), usage_unknown=len(calls)-len(usage), groups=groups)
    atomic_save(study / 'RESULT.json', result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('prepare', 'execute', 'report'))
    parser.add_argument('--study', type=Path, required=True)
    args = parser.parse_args()
    result = {'prepare': prepare, 'execute': execute, 'report': report}[args.mode](args.study.resolve())
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
