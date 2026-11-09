"""Read and audit a completed two-request preflight; never invokes a model."""
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def audit(out):
    checks = []
    def check(name, value):
        checks.append(dict(check=name, passed=bool(value)))
    p, a, r = (load(out/n) for n in ('protocol.json','AUTHORIZATION.json','RESULT.json'))
    check('Protocol hash', sha(out/'protocol.json') == (out/'protocol.sha256').read_text().strip())
    check('New explicit consent', a['status'] == 'EXPLICITLY_APPROVED' and bool(a.get('user_instruction')))
    check('Consent protocol', a['protocol_sha256'] == sha(out/'protocol.json'))
    for k in ('endpoint','model','maximum_requests'):
        check('Consent '+k, a[k] == p[k])
    for rel, h in p['frozen_files'].items():
        check('Frozen '+rel, sha(out/rel) == h)
    for rel, h in p['dependencies'].items():
        check('Dependency '+rel, sha(ROOT/rel) == h)
    markers = sorted(out.glob('attempt_*.json'))
    check('At most two attempt markers', len(markers) == r['attempted'] <= p['maximum_requests'] == 2)
    check('Exclusive run marker', (out/'RUN_STARTED.json').exists())
    check('No automatic retries', p['automatic_retries'] == 0)
    check('No reliability claim', r['reliability_proven'] is False)
    observations = []
    for record in r['records']:
        i = record['index']; folder = out/f'call_{i:02d}'
        t = load(folder/'transport.json')
        request = load(folder/'request.json')
        slot = p['schedule'][i-1]
        check(f'Call{i} exact request', request['body'] == load(out/slot['request']) and request['endpoint'] == p['endpoint'])
        check(f'Call{i} no retries', t['retry_count'] == 0)
        check(f'Call{i} temporary events removed', not list(folder.glob('transfer_*')))
        obs = dict(index=i, case=record['case'], status=record['status'], transport=t)
        if record['status'] == 'GENERATED':
            resp = load(folder/'response.json')
            check(f'Call{i} complete transport', t['complete'] and t['exit_code'] == 0 and 200 <= t['http_status'] < 300)
            check(f'Call{i} complete response', resp['stream_audit']['complete'] and resp['choices'][0]['finish_reason'] == 'stop')
            check(f'Call{i} candidate exists', (out/record['candidate']).exists())
            check(f'Call{i} evaluation exists', 'evaluation' in record)
            obs['usage'] = resp.get('usage')
            obs['validation_passed'] = record.get('validation_passed')
            obs['evaluation'] = {k:record['evaluation'].get(k) for k in
                                 ('status','formal','mapped_formal','ppa','wns_ns','tns_ns','mapped_area_um2','mapped_sha256')}
        else:
            check(f'Call{i} failure is last', i == r['attempted'])
            check(f'Call{i} failed response not accepted', not (folder/'response.json').exists() or record['error_type'] != 'StreamError')
        observations.append(obs)
    result = dict(passed=all(c['passed'] for c in checks), check_count=len(checks),
                  checks=checks, observations=observations)
    (out/'AUDIT.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(dict(passed=result['passed'],check_count=len(checks),observations=observations),indent=2))
    return result['passed']


if __name__ == '__main__':
    sys.exit(0 if audit(Path(sys.argv[1]).resolve()) else 1)
