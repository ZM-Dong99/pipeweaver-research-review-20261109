"""Prepare a two-request SSE preflight; execution requires new explicit consent.

This is transport feasibility, not another randomized method comparison.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.sse_transport import curl_completion_stream
from eda.experiments.run_stream_feedback import DEPS, evaluate, parse_candidate, eligible

PARENT = ROOT / 'eda/experiments/stream_feedback_ready_20261106'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def save(path, value):
    with path.open('x', encoding='utf-8') as f:
        json.dump(value, f, ensure_ascii=False, indent=2, allow_nan=False)


def require(value, message):
    if not value:
        raise RuntimeError(message)


def prepare(out):
    require(sha(PARENT/'protocol.json') == (PARENT/'protocol.sha256').read_text().strip(), 'Parent protocol changed')
    parent = load(PARENT/'protocol.json')
    out.mkdir(parents=True, exist_ok=False)
    (out/'inputs').mkdir()
    (out/'requests').mkdir()
    schedule = []
    for case_id, prior_call in (('adapter', 2), ('skid', 11)):
        case = next(c for c in parent['cases'] if c['id'] == case_id)
        body = load(PARENT/f'trials/call_{prior_call:02d}/api_audit/request.json')['body']
        require(body['model'] == 'gpt-6.1-sol', 'Unexpected model')
        body.update(stream=True, stream_options={'include_usage': True}, max_completion_tokens=16000)
        save(out/'requests'/f'{case_id}.json', body)
        shutil.copyfile(PARENT/'inputs'/case['source'], out/'inputs'/case['source'])
        schedule.append(dict(case=case, request=f'requests/{case_id}.json', parent_call=prior_call))
    curl = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    require(curl, 'curl missing')
    dependencies = list(dict.fromkeys([Path(__file__).resolve(), ROOT/'agents/sse_transport.py', *DEPS]))
    (out/'code_snapshot').mkdir()
    for dep in dependencies:
        shutil.copyfile(dep, out/'code_snapshot'/dep.name)
    protocol = dict(status='PREPARED_NOT_AUTHORIZED', endpoint='https://apinebula.ai/v1/chat/completions',
                    model='gpt-6.1-sol', maximum_requests=2, timeout_seconds=180,
                    max_completion_tokens_per_request=16000, automatic_retries=0,
                    stop_on_first_generation_failure=True, schedule=schedule,
                    purpose='SSE transport feasibility only; not STA versus no-STA comparison or reliability estimate',
                    changes_from_parent='Same two STA prompts, new stream=true, include_usage=true and max_completion_tokens=16000',
                    token_limit_scope='Requested API cap, provider support/enforcement unverified; not a currency cap',
                    disclosure='Public axis_adapter/axis_register RTL, reset-only contract and baseline STA; configured key; possible charges',
                    parent_protocol_sha256=sha(PARENT/'protocol.json'),
                    dependencies={str(p.relative_to(ROOT)): sha(p) for p in dependencies},
                    curl_path=curl, curl_sha256=sha(Path(curl)),
                    frozen_files={str(p.relative_to(out)): sha(p) for p in out.rglob('*') if p.is_file()})
    save(out/'protocol.json', protocol)
    (out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n', encoding='ascii')
    save(out/'AUTHORIZATION.json', dict(status='PENDING', endpoint=protocol['endpoint'],
         model=protocol['model'], maximum_requests=2, protocol_sha256=sha(out/'protocol.json'),
         user_instruction=None))
    print('Prepared, zero API requests: '+str(out))


def execute(out):
    p, a = load(out/'protocol.json'), load(out/'AUTHORIZATION.json')
    require(sha(out/'protocol.json') == (out/'protocol.sha256').read_text().strip(), 'Protocol changed')
    require(a.get('status') == 'EXPLICITLY_APPROVED' and bool(a.get('user_instruction')), 'New explicit consent required')
    for key in ('endpoint', 'model', 'maximum_requests'):
        require(a.get(key) == p[key], 'Consent mismatch: '+key)
    require(a.get('protocol_sha256') == sha(out/'protocol.json'), 'Consent protocol mismatch')
    for rel, h in p['frozen_files'].items():
        require(sha(out/rel) == h, 'Frozen input changed: '+rel)
    for rel, h in p['dependencies'].items():
        require(sha(ROOT/rel) == h, 'Live code changed; prepare new protocol: '+rel)
    selected_curl = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    require(selected_curl and Path(selected_curl).resolve() == Path(p['curl_path']).resolve(), 'curl selection changed')
    require(sha(Path(selected_curl)) == p['curl_sha256'], 'curl changed')
    key = os.environ.get('OPENAI_API_KEY', '').strip()
    require(key, 'Configured key missing')
    # Exclusive run marker forbids accidental repeats even after a crash.
    save(out/'RUN_STARTED.json', dict(timestamp=datetime.now(timezone.utc).isoformat(), maximum_requests=2))
    records, generated = [], []
    for index, slot in enumerate(p['schedule'], 1):
        case = slot['case']
        record = dict(index=index, case=case['id'], status='ATTEMPTED')
        save(out/f'attempt_{index:02d}.json', record)
        try:
            response = curl_completion_stream(endpoint=p['endpoint'], body=load(out/slot['request']),
                        api_key=key, audit_dir=out/f'call_{index:02d}', timeout_s=p['timeout_seconds'])
            parsed = parse_candidate(response['choices'][0]['message']['content'])
            candidate = out/f'candidate_{index:02d}.v'
            candidate.write_text(parsed['rtl'], encoding='utf-8')
            record.update(status='GENERATED', usage=response.get('usage'), candidate=candidate.name)
            generated.append((record, candidate, case))
        except Exception as exc:
            # Do not echo unexpected exceptions that could contain provider content.
            record.update(status='GENERATION_FAILED', error_type=type(exc).__name__)
            records.append(record)
            break
        records.append(record)
    save(out/'GENERATION_SUMMARY.json', dict(maximum_requests=2, attempted=len(records),
         remaining=2-len(records), records=records, automatic_retries=0,
         resumption='Forbidden; exclusive run marker prevents unknown resend'))
    # Finish generation before EDA, matching the parent isolation policy.
    for record, candidate, case in generated:
        result = evaluate(candidate, out/'inputs'/case['source'], case, out/f'evaluation_{record["index"]:02d}')
        record['evaluation'] = result
        record['validation_passed'] = eligible(result)
    save(out/'RESULT.json', dict(purpose=p['purpose'], attempted=len(records), records=records,
         reliability_proven=False, old_batch_requests_reused=False))
    print('Preflight finished; inspect '+str(out/'RESULT.json'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('out', type=Path)
    parser.add_argument('--execute', action='store_true')
    args = parser.parse_args()
    execute(args.out.resolve()) if args.execute else prepare(args.out.resolve())
