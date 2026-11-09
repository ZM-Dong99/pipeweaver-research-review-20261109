"""Explicitly authorized low-concurrency continuation of unattempted slots only."""
import argparse
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from eda.experiments import run_multicircuit_feedback_144 as base


def prepare(out):
    protocol = base.validate(out)
    if not (out / 'HALTED.json').exists():
        raise RuntimeError('Expected retained original stop marker')
    completed = []
    remaining = []
    for slot in protocol['schedule']:
        folder = out / 'trials' / f'call_{slot["index"]:03d}'
        if folder.exists():
            if not (folder / 'result.json').exists():
                raise RuntimeError('Original task still running or uncertain. No resends.')
            completed.append(slot['index'])
        else:
            remaining.append(slot['index'])
    recovery = out / 'recovery_001'
    recovery.mkdir(exist_ok=False)
    shutil.copyfile(Path(__file__), recovery / 'runner_used.py')
    manifest = dict(original_protocol_sha256=base.sha(out / 'protocol.json'),
        retained_stop_sha256=base.sha(out / 'HALTED.json'), completed_indices=completed,
        remaining_indices=remaining, maximum_new_requests=len(remaining), maximum_total_requests=144,
        maximum_concurrency=2, automatic_retries=0, stop_after_consecutive_transport_failures=3,
        endpoint=protocol['endpoint'], model=protocol['model'], timeout_seconds=600, max_completion_tokens=16000,
        runner_sha256=base.sha(Path(__file__)),
        scope='Only previously unattempted schedule slots. Original protocol, baseline, prompts, failures and stop marker retained. New stop counter applies to this explicitly approved recovery.')
    base.save(recovery / 'protocol.json', manifest)
    base.save(recovery / 'AUTHORIZATION.json', dict(status='PENDING', user_instruction=None,
        recovery_protocol_sha256=base.sha(recovery / 'protocol.json')))
    print('Prepared continuation', len(remaining), 'unattempted slots. No model call.', flush=True)


def execute(out):
    protocol = base.validate(out)
    recovery = out / 'recovery_001'
    manifest = base.load(recovery / 'protocol.json')
    authorization = base.load(recovery / 'AUTHORIZATION.json')
    if authorization['status'] != 'EXPLICITLY_APPROVED' or not authorization.get('user_instruction'):
        raise RuntimeError('Explicit recovery approval required')
    if authorization['recovery_protocol_sha256'] != base.sha(recovery / 'protocol.json'):
        raise RuntimeError('Recovery approval hash mismatch')
    if manifest['runner_sha256'] != base.sha(Path(__file__)):
        raise RuntimeError('Recovery code changed')
    if manifest['original_protocol_sha256'] != base.sha(out / 'protocol.json'):
        raise RuntimeError('Original protocol changed')
    if manifest['retained_stop_sha256'] != base.sha(out / 'HALTED.json'):
        raise RuntimeError('Original stop evidence changed')
    if (recovery / 'HALTED.json').exists():
        raise RuntimeError('Recovery stopped. No automatic restart.')
    key = os.environ.get('OPENAI_API_KEY', '').strip()
    if not key:
        raise RuntimeError('Configured API key missing')
    cases = {c['id']: c for c in protocol['cases']}
    def one(slot):
        folder = out / 'trials' / f'call_{slot["index"]:03d}'
        if folder.exists():
            raise RuntimeError('Recovery never resends or replaces an existing slot')
        folder.mkdir()
        case = cases[slot['case']]
        prompt = (out / 'prompts' / f'{slot["case"]}_{slot["arm"]}.txt').read_text(encoding='utf-8')
        if slot['round'] == 2:
            parent_folder = out / 'trials' / f'call_{slot["parent"]:03d}'
            parent = base.load(parent_folder / 'result.json')
            prompt += '\nSecond round. Improve your previous candidate, keeping the original contract and area cap.\n'
            if (parent_folder / 'candidate.v').exists():
                prompt += '\nYour previous candidate RTL:\n' + (parent_folder / 'candidate.v').read_text(encoding='utf-8')
            else:
                prompt += '\nPrevious generation did not provide a usable candidate. Start from the original.\n'
            if slot['arm'] == 'sta':
                prompt += '\nMeasured previous candidate feedback:\n' + json.dumps(parent.get('metrics', {}), ensure_ascii=False)
                prompt += '\nActual previous candidate paths:\n' + base.timing_excerpt(parent_folder / 'evaluation', case)
                for name in ('formal.log', 'mapped_formal.log', 'candidate_schema.log', 'frontend.log'):
                    for log in (parent_folder / 'evaluation' / name, parent_folder / 'evaluation' / 'eda' / name):
                        if log.exists() and parent.get('metrics', {}).get('status') != 'PASS':
                            prompt += '\nValidation feedback ' + name + ':\n' + log.read_text(encoding='utf-8', errors='replace')[-5000:]
        (folder / 'prompt.txt').write_text(prompt, encoding='utf-8')
        base.save(folder / 'attempt.json', {**slot, 'timestamp': datetime.now(timezone.utc).isoformat(),
            'automatic_retries': 0, 'execution_segment': 'recovery_001'})
        body = dict(model=protocol['model'], reasoning_effort=protocol['reasoning_effort'],
            response_format={'type': 'json_object'}, stream=True, stream_options={'include_usage': True},
            max_completion_tokens=protocol['max_completion_tokens'], messages=[
                dict(role='system', content=protocol['system']), dict(role='user', content=prompt)])
        row = {**slot, 'status': 'FAILED_GENERATION', 'failure_class': 'TRANSPORT', 'usage': None,
               'execution_segment': 'recovery_001'}
        try:
            response = base.curl_completion_stream(endpoint=protocol['endpoint'], body=body, api_key=key,
                audit_dir=folder / 'api_audit', timeout_s=protocol['timeout_seconds'])
            row.update(failure_class='FORMAT', usage=response.get('usage'), reported_model=response.get('model'))
            parsed = base.parse_candidate(response['choices'][0]['message']['content'])
            (folder / 'candidate.v').write_text(parsed['rtl'], encoding='utf-8')
            row.update(status='GENERATED', failure_class=None, rtl_sha256=base.sha(folder / 'candidate.v'))
        except Exception as error:
            row.update(error_type=type(error).__name__, error_summary=str(error)[:400])
        base.save(folder / 'generation.json', row)
        metrics = {}
        if row['status'] == 'GENERATED':
            metrics = base.evaluate(folder / 'candidate.v', case, folder / 'evaluation', out / 'inputs' / (case['id'] + '.v'))
        row.update(metrics=metrics, **base.select(metrics, case['baseline']))
        base.save(folder / 'result.json', row)
        print(f'CALL {slot["index"]:03d}/144 {slot["case"]} {slot["arm"]} R{slot["round"]} {row["status"]} EDA={metrics.get("status")} improved={row["improved"]}', flush=True)
        return row
    remaining = set(manifest['remaining_indices'])
    for index in manifest['completed_indices']:
        if not (out / 'trials' / f'call_{index:03d}' / 'result.json').exists():
            raise RuntimeError('Original completed record missing')
    if len(remaining) + len(manifest['completed_indices']) != 144:
        raise RuntimeError('Invalid total request budget')
    failures = 0
    halted = False
    for round_id in (1, 2):
        slots = iter(s for s in protocol['schedule'] if s['round'] == round_id and s['index'] in remaining)
        with ThreadPoolExecutor(max_workers=2) as pool:
            pending = {}
            def submit_next():
                slot = next(slots, None)
                if slot is not None:
                    pending[pool.submit(one, slot)] = slot
            for _ in range(2):
                submit_next()
            while pending:
                done, _ = wait(pending, return_when=FIRST_COMPLETED)
                for future in done:
                    pending.pop(future)
                    row = future.result()
                    failures = failures + 1 if row['failure_class'] == 'TRANSPORT' else 0
                    if failures >= 3 and not halted:
                        halted = True
                        base.save(recovery / 'HALTED.json', dict(reason='Three consecutive new completed transport failures', timestamp=datetime.now(timezone.utc).isoformat()))
                if not halted:
                    for _ in done:
                        submit_next()
        if halted:
            break
    base.summarize(out)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('prepare', 'execute'))
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.mode == 'prepare':
        prepare(args.out.resolve())
    else:
        execute(args.out.resolve())
