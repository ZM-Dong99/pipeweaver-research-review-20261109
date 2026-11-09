"""Reconcile transmitted slots, frozen prompts, proof inputs and acceptance."""
import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from eda.experiments import run_multicircuit_feedback_144 as study


def audit(out):
    protocol = study.validate(out)
    checks = []
    def check(name, passed):
        checks.append(dict(name=name, passed=bool(passed)))
    cases = {c['id']: c for c in protocol['cases']}
    attempts = list((out / 'trials').glob('call_*/attempt.json'))
    results = list((out / 'trials').glob('call_*/result.json'))
    check('Total attempt budget at most144', len(attempts) <= 144)
    check('All144 planned attempts completed', len(attempts) == len(results) == 144)
    provider_ids = []
    fields = ('reference_sha256', 'top', 'reference_top', 'parameter_overrides', 'liberty_sha256',
              'mapping', 'abc_cleanup_before_buffer', 'mapping_policy', 'abc_driver', 'abc_output_load_ff',
              'mapped_netlist_proof_required', 'virtual_clock_period_ns', 'input_transition_ns',
              'output_load_pf', 'physical_parasitics', 'runner_sha256', 'tool_versions')
    for slot in protocol['schedule']:
        label = f'call_{slot["index"]:03d}'
        folder = out / 'trials' / label
        if not (folder / 'result.json').exists():
            continue
        row = study.load(folder / 'result.json')
        attempt = study.load(folder / 'attempt.json')
        check(label + ' identity', all(row[k] == attempt[k] == slot[k] for k in ('index', 'case', 'arm', 'trial', 'round')))
        api = folder / 'api_audit'
        request = study.load(api / 'request.json')
        body = request['body']
        check(label + ' authorized endpoint/model/bounds', request['endpoint'] == protocol['endpoint']
              and request['credentials'] == 'omitted' and body['model'] == protocol['model']
              and body['max_completion_tokens'] == 16000 and body['stream'] is True)
        check(label + ' sent prompt', body['messages'][0] == dict(role='system', content=protocol['system'])
              and body['messages'][1]['content'] == (folder / 'prompt.txt').read_text(encoding='utf-8'))
        if slot['round'] == 1:
            expected = (out / 'prompts' / f'{slot["case"]}_{slot["arm"]}.txt').read_text(encoding='utf-8')
            check(label + ' fixed primary prompt', body['messages'][1]['content'] == expected)
        else:
            parent = study.load(out / 'trials' / f'call_{slot["parent"]:03d}' / 'result.json')
            check(label + ' preselected feedback parent', parent['trial'] <= 2 and parent['round'] == 1
                  and (parent['case'], parent['arm'], parent['trial']) == (row['case'], row['arm'], row['trial']))
            feedback = '\nMeasured previous candidate feedback:\n' in body['messages'][1]['content']
            check(label + ' feedback arm separation', feedback == (slot['arm'] == 'sta'))
        transport = study.load(api / 'transport.json')
        check(label + ' zero retries', transport['retry_count'] == 0)
        if (api / 'response.json').exists():
            response = study.load(api / 'response.json')
            provider_ids.append((response.get('model'), response.get('id')))
            check(label + ' visible response identity', response.get('model') == protocol['model'] and bool(response.get('id')))
        check(label + ' recomputed qualification', all(row[k] == v for k, v in study.select(row['metrics'], cases[slot['case']]['baseline']).items()))
        if row['status'] != 'GENERATED':
            continue
        check(label + ' generated source hash', study.sha(folder / 'candidate.v') == row['rtl_sha256'])
        evaluation = folder / 'evaluation'
        check(label + ' saved evaluator result', study.load(evaluation / 'result.json') == row['metrics'])
        relative = 'eda' if slot['case'] == 'crc32_d8' else ''
        measured = evaluation / relative
        baseline = out / 'baselines' / slot['case'] / relative
        if (measured / 'protocol.json').exists():
            actual = study.load(measured / 'protocol.json')
            original = study.load(baseline / 'protocol.json')
            check(label + ' identical evaluation conditions', all(actual[k] == original[k] for k in fields))
        if row['improved']:
            if slot['case'] != 'crc32_d8':
                proof_path = out / 'definedness_checks' / label / 'result.json'
                proof = study.load(proof_path) if proof_path.exists() else {}
                check(label + ' semantic definedness proof', proof.get('passed') is True
                      and proof.get('source_sha256') == row['rtl_sha256'])
            check(label + ' actual source proof success', 'SUCCESS!' in (measured / 'formal.log').read_text(encoding='utf-8'))
            check(label + ' actual mapped proof success', 'SUCCESS!' in (measured / 'mapped_formal.log').read_text(encoding='utf-8'))
            electrical = study.load(measured / 'electrical.json')
            check(label + ' actual electrical success', electrical['status'] == 'PASS')
    check('Distinct provider response IDs', len(provider_ids) == len(set(provider_ids)))
    if (out / 'recovery_001').exists():
        recovery = out / 'recovery_001'
        manifest = study.load(recovery / 'protocol.json')
        auth = study.load(recovery / 'AUTHORIZATION.json')
        check('Recovery explicitly approved', auth['status'] == 'EXPLICITLY_APPROVED'
              and auth['recovery_protocol_sha256'] == study.sha(recovery / 'protocol.json'))
        check('Original stop evidence retained', study.sha(out / 'HALTED.json') == manifest['retained_stop_sha256'])
        check('Recovery kept total144 and lower concurrency', manifest['maximum_concurrency'] == 2
              and manifest['maximum_new_requests'] + len(manifest['completed_indices']) == 144)
    result = dict(passed=all(c['passed'] for c in checks), checks=len(checks),
        failed=[c for c in checks if not c['passed']], attempted=len(attempts), completed=len(results),
        distinct_complete_provider_responses=len(set(provider_ids)), model_requests_from_audit=0,
        protocol_sha256=study.sha(out / 'protocol.json'), items=checks)
    (out / 'AUDIT.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps({k: result[k] for k in ('passed', 'checks', 'attempted', 'completed', 'failed')}, ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('out', type=Path)
    audit(parser.parse_args().out.resolve())

