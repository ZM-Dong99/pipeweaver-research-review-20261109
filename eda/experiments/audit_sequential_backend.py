"""Read-only evidence checks; no tools rerun and no model requests."""
import argparse
import json
from pathlib import Path
import re

from run_native_comb import digest, parse_electrical_report, save


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('study', type=Path)
    args = ap.parse_args()
    study = args.study.resolve()
    load = lambda p: json.loads(p.read_text(encoding='utf-8'))
    checks = []
    def check(label, value):
        checks.append(dict(check=label, passed=bool(value)))
    protocol = load(study / 'protocol.json')
    check('suite protocol hash', digest(study / 'protocol.json') == (study / 'protocol.sha256').read_text().strip())
    for path, sha in protocol['dependencies'].items():
        check('snapshot ' + Path(path).name, digest(study / 'code_snapshot' / Path(path).name) == sha)
    summary = load(study / 'SUMMARY.json')
    check('complete case list', [r['id'] for r in summary['results']] == [c['id'] for c in protocol['cases']])
    for c, row in zip(protocol['cases'], summary['results']):
        folder = study / c['id']
        p, r = load(folder / 'protocol.json'), load(folder / 'result.json')
        check(c['id'] + ' protocol hash', digest(folder / 'protocol.json') == (folder / 'protocol.sha256').read_text().strip())
        check(c['id'] + ' frozen code', p['runner_sha256'] == protocol['runner_sha256'])
        check(c['id'] + ' source hashes', all(digest(Path(c[k])) == c[k + '_sha256'] == p[k + '_sha256'] for k in ('candidate', 'reference')))
        check(c['id'] + ' summary consistency', r == row['result'] and row['actual'] == c['expected'] and row['matched'])
        check(c['id'] + ' zero model calls', p['llm_generation_requests'] == 0)
        if c['expected'] == 'PASS':
            check(c['id'] + ' complete proofs', all('Induction step proven: SUCCESS!' in (folder / (s + '.log')).read_text() and r[s] == 'PASS' for s in ('formal', 'mapped_formal')))
            sta = (folder / 'sta.log').read_text()
            check(c['id'] + ' clean electrical', parse_electrical_report(sta) == r['electrical'] and r['electrical']['status'] == 'PASS')
            check(c['id'] + ' STA numeric', all(float(re.search(pattern, sta)[1]) == r[key] for key, pattern in [('wns_ns', r'worst slack max\s+([-+\d.]+)'), ('tns_ns', r'tns max\s+([-+\d.]+)')]))
            check(c['id'] + ' mapped and SDC hashes', digest(folder / 'mapped.v') == r['mapped_sha256'] and digest(folder / 'timing.sdc') == r['sdc_sha256'])
        elif c['expected'] == 'FORMAL_FAIL':
            check(c['id'] + ' actual base counterexample', 'model found for base case: FAIL!' in (folder / 'formal.log').read_text() and (folder / 'formal_counterexample.vcd').is_file() and r['formal'] == 'FAIL')
        else:
            check(c['id'] + ' rejected before proof', r['stage'] == 'schema' and r['formal'] == 'NOT_RUN')
    audit = dict(passed=all(c['passed'] for c in checks), checks=checks, check_count=len(checks),
                 scope='Evidence consistency, not independent formal-engine validation; check count is not experiment count')
    save(study / 'AUDIT.json', audit)
    print(json.dumps({'passed': audit['passed'], 'checks': len(checks)}))
    return 0 if audit['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
