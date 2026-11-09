"""Bounded six-circuit replication plus preselected second-round feedback."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import random
import shutil
import statistics
import sys
import threading
import time

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from eda.experiments.run_expanded_feedback import evaluate as evaluate_comb, eligible, select
from eda.experiments.run_crc_feedback import evaluate as evaluate_crc
from eda.experiments.run_stream_feedback import parse_candidate
from agents.sse_transport import curl_completion_stream

PUBLIC = 'benchmark/rtl_opt_upstream_hkust/benchmark'
CASES = [
    dict(id='priority256', top='priority_encoder', params={'WIDTH': 256, 'LSB_HIGH_PRIORITY': 0}, source='eda/experiments/timing_feedback_ablation_priority256_20261102_193927_399076/baseline/original.v'),
    dict(id='alu64', top='alu_64bit', params={}, source=f'{PUBLIC}/alu_64bit/alu_64bit.v'),
    dict(id='crc32_d8', top='crc32_d8', params={}, source='eda/experiments/crc_transfer_qualification_20261107/inputs/crc32_d8.v'),
    dict(id='comparator16', top='comparator_16bit', params={}, source=f'{PUBLIC}/comparator_16bit/comparator_16bit.v'),
    dict(id='decoder8', top='decoder_8bit', params={'N': 8}, source=f'{PUBLIC}/decoder_8bit/decoder_8bit.v'),
    dict(id='multiply8', top='mul_subexpression', params={}, source=f'{PUBLIC}/mul_subexpression/mul_subexpression.v'),
]
SYSTEM = 'Optimize the specified combinational RTL under its exact all-input equivalence contract. Return exactly the requested JSON object.'
ENDPOINT = 'https://apinebula.ai/v1/chat/completions'
INSTRUCTION = '内容太少 总结不够详细 模型调用次数只有100次也太少 没有统计意义 接下来两三小时内 你需要持续调用大模型 至少再调用100多次 然后对不同电路进行反馈调用 现在你开始'


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    with path.open('x', encoding='utf-8') as handle:
        json.dump(value, handle, ensure_ascii=False, indent=2, allow_nan=False)


def evaluate(source, case, out, reference):
    if (out / 'result.json').exists():
        return load(out / 'result.json')
    if out.exists():
        return dict(status='INCOMPLETE', reason='Interrupted EDA directory retained')
    if case['id'] == 'crc32_d8':
        return evaluate_crc(source, out)
    return evaluate_comb(source, reference, case, out)


def timing_excerpt(folder, case):
    report = folder / ('eda/sta.log' if case['id'] == 'crc32_d8' else 'sta.log')
    if not report.exists():
        return 'No STA report available because validation or mapping did not complete.'
    paths = report.read_text(encoding='utf-8').split('Startpoint:')[1:4]
    return ''.join('Startpoint:' + part for part in paths).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]


def prepare(out):
    out.mkdir(parents=True, exist_ok=False)
    for name in ('inputs', 'prompts', 'baselines', 'code_snapshot'):
        (out / name).mkdir()
    for case in CASES:
        shutil.copyfile(ROOT / case['source'], out / 'inputs' / (case['id'] + '.v'))
    def baseline(case):
        source = out / 'inputs' / (case['id'] + '.v')
        metrics = evaluate(source, case, out / 'baselines' / case['id'], source)
        if not eligible(metrics):
            raise RuntimeError('Baseline not qualified: ' + case['id'])
        print('BASELINE PASS ' + case['id'], flush=True)
        return {**case, 'baseline': metrics}
    with ThreadPoolExecutor(max_workers=3) as pool:
        cases = list(pool.map(baseline, CASES))
    for case in cases:
        common = (
            f'Optimize module {case["top"]}, fixed parameter overrides {json.dumps(case["params"], sort_keys=True)}. '
            'Minimize mapped maximum data arrival. Preserve module name, ports, widths, signedness, '
            'truncations, priority, default outputs and parameter declarations/defaults. '
            'All input bits are arbitrary binary values. Every output bit must match for all inputs. '
            'Do not rely on presumed typical operation or comments. No clocks, storage, latency, latches, '
            'memories, assumptions, assertions, external includes, file access, dependencies or undefined outputs. '
            'Return a complete synthesizable design including helper modules. Only this fixed parameter instance is assessed.\n'
            'Evaluation uses SKY130HD TT25C1.80V, Yosys source and mapped all-input equivalence, '
            'flatten/synth-noabc and ABC buffer_size with cleanup-before-buffer, OpenSTA, '
            '0ns external IO delays, input transition0.10ns, output load0.010pF, '
            '100ns virtual reporting clock and no physical wire parasitics. '
            'Zero reported max-slew and max-capacitance violations required. '
            f'Original mapped area {case["baseline"]["mapped_area_um2"]:.6f}um2; '
            f'area cap {case["baseline"]["mapped_area_um2"] * 1.1:.6f}um2. '
            'CRC candidates use the same Slang frontend as their baseline. '
            'CRC state_in is arbitrary and data_out must also match exactly.\n'
            'Return exactly one JSON object with six string fields candidate_rtl, bottleneck, rewrite, '
            'expected_timing_gain, area_or_other_cost, functional_boundaries.\nOriginal RTL:\n'
            + (out / 'inputs' / (case['id'] + '.v')).read_text(encoding='utf-8')
        )
        appendix = '\nActual baseline STA. Mapped names do not establish exact source attribution.\n'
        appendix += json.dumps({k: case['baseline'][k] for k in ('max_data_arrival_ns', 'wns_ns', 'tns_ns')})
        appendix += '\n' + timing_excerpt(out / 'baselines' / case['id'], case)
        for arm in ('no_sta', 'sta'):
            (out / 'prompts' / f'{case["id"]}_{arm}.txt').write_text(common + (appendix if arm == 'sta' else ''), encoding='utf-8')
    rng = random.Random(20261109)
    schedule = []
    for trial in range(1, 11):
        order = [case['id'] for case in cases]
        rng.shuffle(order)
        for case_id in order:
            arms = ['no_sta', 'sta']
            rng.shuffle(arms)
            for arm in arms:
                schedule.append(dict(index=len(schedule) + 1, case=case_id, arm=arm, trial=trial, round=1))
    for parent in list(schedule):
        if parent['trial'] <= 2:
            schedule.append({**parent, 'index': len(schedule) + 1, 'round': 2, 'parent': parent['index']})
    dependencies = [Path(__file__).resolve(), ROOT / 'agents/sse_transport.py', ROOT / 'agents/rtl_optimizer.py',
                    ROOT / 'eda/experiments/run_stream_feedback.py', ROOT / 'eda/experiments/run_expanded_feedback.py',
                    ROOT / 'eda/experiments/run_crc_feedback.py', ROOT / 'eda/experiments/evaluate_crc_candidate.py',
                    ROOT / 'eda/experiments/run_native_comb.py', ROOT / 'eda/experiments/trace_sta_rtl_cone.py',
                    ROOT / 'agents/portfolio_loop.py']
    for path in dependencies:
        shutil.copyfile(path, out / 'code_snapshot' / path.name)
    protocol = dict(created_at=datetime.now(timezone.utc).isoformat(), endpoint=ENDPOINT, model='gpt-6.1-sol',
        maximum_requests=144, timeout_seconds=600, max_completion_tokens=16000, reasoning_effort='medium',
        maximum_concurrency=6, automatic_retries=0, stop_after_consecutive_transport_failures=3,
        requested_completion_token_cap=2304000, currency_budget='No currency price estimate; input tokens additional; failures may be billed',
        cases=cases, schedule=schedule, system=SYSTEM,
        primary='120 independent fixed-prompt generations, 10 per arm per circuit; failures retained at original baseline',
        secondary='24 preselected trial1/2 follow-ups. STA arm receives measured candidate feedback; no_sta sees its previous RTL without candidate metrics. Parent-relative and original-relative gains reported separately.',
        no_candidate_parent='If generation failed, follow-up uses original RTL and a generation-failure notice without invented STA',
        scope='Six exposed/public fixed combinational instances. Development replication, not unseen-circuit generalization. One requested gateway model alias.',
        stopping='Stop scheduling on 3 consecutive completed transport failures. In-flight requests finish, no retries or replacement slots.',
        dependencies={str(path.relative_to(ROOT)): sha(path) for path in dependencies},
        frozen_files={str(path.relative_to(out)): sha(path) for path in out.rglob('*') if path.is_file()})
    save(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(sha(out / 'protocol.json') + '\n', encoding='ascii')
    save(out / 'AUTHORIZATION.json', dict(status='USER_REQUESTED_NEW_BATCH', user_instruction=INSTRUCTION,
        model=protocol['model'], endpoint=ENDPOINT, maximum_requests=144, protocol_sha256=sha(out / 'protocol.json'),
        source='Current user explicitly requests at least100 additional model calls and circuit feedback. Established same gateway and public RTL workflow retained.'))
    print('PREPARED 144 request slots, 0 model calls', flush=True)


def validate(out):
    protocol = load(out / 'protocol.json')
    if sha(out / 'protocol.json') != (out / 'protocol.sha256').read_text().strip():
        raise RuntimeError('Protocol changed')
    for rel, expected in protocol['frozen_files'].items():
        if sha(out / rel) != expected:
            raise RuntimeError('Frozen artifact changed: ' + rel)
    for rel, expected in protocol['dependencies'].items():
        if sha(ROOT / rel) != expected:
            raise RuntimeError('Dependency changed: ' + rel)
    if len(protocol['schedule']) != 144:
        raise RuntimeError('Invalid budget')
    expected = Counter({(c['id'], arm): 10 for c in protocol['cases'] for arm in ('no_sta', 'sta')})
    if Counter((s['case'], s['arm']) for s in protocol['schedule'] if s['round'] == 1) != expected:
        raise RuntimeError('Unbalanced primary cohort')
    auth = load(out / 'AUTHORIZATION.json')
    if auth['protocol_sha256'] != sha(out / 'protocol.json') or not auth['user_instruction']:
        raise RuntimeError('Authorization mismatch')
    return protocol


def execute(out):
    protocol = validate(out)
    if (out / 'HALTED.json').exists():
        raise RuntimeError('Stopped batch requires review, no automatic restart')
    key = os.environ.get('OPENAI_API_KEY', '').strip()
    if not key:
        raise RuntimeError('Configured API key missing')
    (out / 'trials').mkdir(exist_ok=True)
    cases = {case['id']: case for case in protocol['cases']}
    def one(slot):
        folder = out / 'trials' / f'call_{slot["index"]:03d}'
        if (folder / 'result.json').exists():
            return load(folder / 'result.json')
        if folder.exists() and not (folder / 'generation.json').exists():
            raise RuntimeError('Uncertain prior transmission must not be resent: ' + folder.name)
        folder.mkdir(exist_ok=True)
        case = cases[slot['case']]
        if (folder / 'generation.json').exists():
            result = load(folder / 'generation.json')
        else:
            prompt = (out / 'prompts' / f'{slot["case"]}_{slot["arm"]}.txt').read_text(encoding='utf-8')
            if slot['round'] == 2:
                parent_folder = out / 'trials' / f'call_{slot["parent"]:03d}'
                parent = load(parent_folder / 'result.json')
                prompt += '\nSecond round. Improve your previous candidate, keeping the original contract and area cap.\n'
                if (parent_folder / 'candidate.v').exists():
                    prompt += '\nYour previous candidate RTL:\n' + (parent_folder / 'candidate.v').read_text(encoding='utf-8')
                else:
                    prompt += '\nPrevious generation did not provide a usable candidate. Start from the original.\n'
                if slot['arm'] == 'sta':
                    prompt += '\nMeasured previous candidate feedback:\n' + json.dumps(parent.get('metrics', {}), ensure_ascii=False)
                    prompt += '\nActual previous candidate paths:\n' + timing_excerpt(parent_folder / 'evaluation', case)
                    for log_name in ('formal.log', 'mapped_formal.log', 'candidate_schema.log', 'frontend.log'):
                        candidates = [parent_folder / 'evaluation' / log_name, parent_folder / 'evaluation' / 'eda' / log_name]
                        for log in candidates:
                            if log.exists() and parent.get('metrics', {}).get('status') != 'PASS':
                                prompt += '\nValidation feedback ' + log_name + ':\n' + log.read_text(encoding='utf-8', errors='replace')[-5000:]
            (folder / 'prompt.txt').write_text(prompt, encoding='utf-8')
            save(folder / 'attempt.json', {**slot, 'timestamp': datetime.now(timezone.utc).isoformat(), 'automatic_retries': 0})
            body = dict(model=protocol['model'], reasoning_effort=protocol['reasoning_effort'],
                response_format={'type': 'json_object'}, stream=True, stream_options={'include_usage': True},
                max_completion_tokens=protocol['max_completion_tokens'],
                messages=[dict(role='system', content=protocol['system']), dict(role='user', content=prompt)])
            result = {**slot, 'status': 'FAILED_GENERATION', 'failure_class': 'TRANSPORT', 'usage': None}
            try:
                response = curl_completion_stream(endpoint=protocol['endpoint'], body=body, api_key=key,
                    audit_dir=folder / 'api_audit', timeout_s=protocol['timeout_seconds'])
                result.update(failure_class='FORMAT', usage=response.get('usage'), reported_model=response.get('model'))
                parsed = parse_candidate(response['choices'][0]['message']['content'])
                (folder / 'candidate.v').write_text(parsed['rtl'], encoding='utf-8')
                result.update(status='GENERATED', failure_class=None, rtl_sha256=sha(folder / 'candidate.v'))
            except Exception as error:
                result['error_type'] = type(error).__name__
            save(folder / 'generation.json', result)
        metrics = {}
        if result['status'] == 'GENERATED':
            metrics = evaluate(folder / 'candidate.v', case, folder / 'evaluation', out / 'inputs' / (case['id'] + '.v'))
        result = {**result, 'metrics': metrics, **select(metrics, case['baseline'])}
        save(folder / 'result.json', result)
        print(f'CALL {slot["index"]:03d}/144 {slot["case"]} {slot["arm"]} R{slot["round"]} {result["status"]} EDA={metrics.get("status")} improved={result["improved"]}', flush=True)
        return result
    failures = 0
    halted = False
    for round_id in (1, 2):
        slots = iter(slot for slot in protocol['schedule'] if slot['round'] == round_id)
        with ThreadPoolExecutor(max_workers=protocol['maximum_concurrency']) as pool:
            pending = {}
            def submit_next():
                slot = next(slots, None)
                if slot is not None:
                    pending[pool.submit(one, slot)] = slot
            for _ in range(protocol['maximum_concurrency']):
                submit_next()
            while pending:
                done, _ = wait(pending, return_when=FIRST_COMPLETED)
                for future in done:
                    pending.pop(future)
                    result = future.result()
                    failures = failures + 1 if result['failure_class'] == 'TRANSPORT' else 0
                    if failures >= 3 and not halted:
                        halted = True
                        save(out / 'HALTED.json', dict(reason='Three consecutive completed transport failures', timestamp=datetime.now(timezone.utc).isoformat()))
                if not halted:
                    for _ in done:
                        submit_next()
        if halted:
            break
    summarize(out)


def summarize(out):
    protocol = validate(out)
    rows = [load(path) for path in sorted((out / 'trials').glob('call_*/result.json'))]
    groups = []
    for case in protocol['cases']:
        for arm in ('no_sta', 'sta'):
            items = [r for r in rows if r['case'] == case['id'] and r['arm'] == arm and r['round'] == 1]
            groups.append(dict(case=case['id'], arm=arm, scheduled=10, completed=len(items),
                generated=sum(r['status'] == 'GENERATED' for r in items), improvements=sum(r['improved'] for r in items),
                median_retained_delay_ns=statistics.median(r['retained_delay_ns'] for r in items) if len(items) == 10 else None,
                unique_rtl=len({r['rtl_sha256'] for r in items if 'rtl_sha256' in r}),
                unique_mapped=len({r['metrics']['mapped_sha256'] for r in items if r['metrics'].get('mapped_sha256')})))
    result = dict(complete=len(rows) == 144, completed=len(rows), scheduled=144, groups=groups, trials=rows,
        reported_total_tokens=sum((r.get('usage') or {}).get('total_tokens', 0) for r in rows))
    path = out / 'RESULT.json'
    temporary = out / 'RESULT.tmp'
    temporary.write_text(json.dumps(result, ensure_ascii=False, indent=2, allow_nan=False), encoding='utf-8')
    temporary.replace(path)
    print(f'SUMMARY completed={len(rows)}/144', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('prepare', 'check', 'execute', 'summarize'))
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    out = args.out.resolve()
    if args.mode == 'prepare':
        prepare(out)
    elif args.mode == 'check':
        validate(out)
        print('PASS frozen protocol and balanced144-slot budget; no API call')
    elif args.mode == 'execute':
        execute(out)
    else:
        summarize(out)
