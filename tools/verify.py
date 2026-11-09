"""Standard-library-only verification of the curated teacher review snapshot."""
import argparse
from collections import Counter
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def accepted(metrics, baseline):
    fields = ('max_data_arrival_ns', 'mapped_area_um2', 'tns_ns')
    valid = (metrics.get('status') == 'PASS'
             and metrics.get('formal') == metrics.get('mapped_formal') == metrics.get('ppa') == 'PASS'
             and metrics.get('electrical', {}).get('status') == 'PASS'
             and all(type(metrics.get(k)) in (int, float) and math.isfinite(metrics[k]) for k in fields)
             and metrics['mapped_area_um2'] > 0)
    return (valid and metrics['mapped_area_um2'] <= baseline['mapped_area_um2'] * 1.10 + 1e-9
            and metrics['tns_ns'] >= baseline['tns_ns']
            and metrics['max_data_arrival_ns'] < baseline['max_data_arrival_ns'])


def manifest_errors(root, entries):
    errors = []
    for item in entries:
        path = (root / item['path']).resolve()
        if root.resolve() not in path.parents:
            errors.append('Escaped path ' + item['path'])
        elif not path.is_file():
            errors.append('Missing ' + item['path'])
        elif path.stat().st_size != item['bytes'] or digest(path) != item['sha256']:
            errors.append('Hash mismatch ' + item['path'])
    return errors


def verify(root):
    errors = []
    checks = 0
    def check(name, condition):
        nonlocal checks
        checks += 1
        if not condition:
            errors.append(name)
    manifest = read(root / 'MANIFEST.json')
    errors.extend(manifest_errors(root, manifest['files']))
    checks += len(manifest['files'])
    claims = read(root / 'CLAIMS.json')['claims']
    for claim in claims:
        for evidence in claim['evidence']:
            path = root / evidence['path']
            check(claim['id'] + ' evidence ' + evidence['path'], path.is_file() and digest(path) == evidence['sha256'])
    base = root / 'eda/experiments'
    specs = [('expanded_feedback_80_20261107', 80, 55, False),
             ('crc_feedback_20_20261107_ready', 20, 16, True),
             ('multicircuit_feedback_144_20261109', 144, 76, False)]
    totals = Counter()
    latest = None
    latest_rows = None
    for name, expected_n, expected_improved, crc in specs:
        folder = base / name
        protocol = read(folder / 'protocol.json')
        result = read(folder / 'RESULT.json')
        check(name + ' original protocol hash', digest(folder / 'protocol.json') == (folder / 'protocol.sha256').read_text().strip())
        rows = result['trials']
        check(name + ' cohort size', len(rows) == expected_n)
        check(name + ' unique scheduled indices', sorted(r['index'] for r in rows) == list(range(1, expected_n + 1)))
        cases = {'crc32_d8': {'baseline': protocol['baseline']}} if crc else {c['id']: c for c in protocol['cases']}
        calculated = Counter()
        retained = {}
        for row in rows:
            case = row.get('case', 'crc32_d8')
            baseline = cases[case]['baseline']
            measured = row.get('metrics', {})
            verdict = accepted(measured, baseline)
            check(name + f' call{row["index"]} accepted', verdict == row['improved'])
            delay = measured['max_data_arrival_ns'] if verdict else baseline['max_data_arrival_ns']
            check(name + f' call{row["index"]} retained', abs(delay - row['retained_delay_ns']) < 1e-9)
            if row.get('round', 1) == 1:
                calculated[(case, row['arm'])] += int(verdict)
                retained.setdefault((case, row['arm']), []).append(delay)
            if verdict:
                evaluation = folder / row['evaluation'] if 'evaluation' in row else folder / 'trials' / f'call_{row["index"]:03d}' / 'evaluation'
                measured_folder = evaluation / 'eda' if case == 'crc32_d8' else evaluation
                for label in ('formal', 'mapped_formal'):
                    log = measured_folder / (label + '.log')
                    check(name + f' call{row["index"]} {label} raw success', log.is_file() and 'SUCCESS!' in log.read_text(encoding='utf-8', errors='replace'))
        for group in result['groups']:
            key = (group.get('case', 'crc32_d8'), group['arm'])
            check(name + str(key) + ' improvement count', group['improvements'] == calculated[key])
            check(name + str(key) + ' complete denominator', len(retained[key]) == 10)
            check(name + str(key) + ' median', abs(statistics.median(retained[key]) - group['median_retained_delay_ns']) < 1e-9)
        improvement_count = sum(bool(row['improved']) for row in rows)
        check(name + ' improvement total', improvement_count == expected_improved)
        totals.update(attempted=len(rows), generated=sum(r['status'] == 'GENERATED' for r in rows), improved=improvement_count)
        if expected_n == 144:
            latest, latest_rows = folder, rows
    check('Three batch attempted total244', totals['attempted'] == 244)
    check('Three batch generated total216', totals['generated'] == 216)
    check('Three batch qualified call total147', totals['improved'] == 147)
    lookup = {r['index']: r for r in latest_rows}
    followups = [r for r in latest_rows if r['round'] == 2]
    further = Counter()
    for row in followups:
        parent = lookup[row['parent']]
        check(f'Followup{row["index"]} preselected parent', parent['trial'] <= 2
              and (parent['case'], parent['arm'], parent['trial']) == (row['case'], row['arm'], row['trial']))
        further[row['arm']] += int(row['retained_delay_ns'] < parent['retained_delay_ns'])
    check('Twenty-four dependent followups', len(followups) == 24)
    check('Further improvements5 per arm', further == Counter(no_sta=5, sta=5))
    recorded = read(latest / 'ANALYSIS.json')
    check('Latest exhaustive outcome classification', sum(recorded['categories'].values()) == 144)
    for rel in ('AUDIT.json', 'definedness_checks/AUDIT.json', 'independent_reproduction_final/AUDIT.json'):
        check('Archived audit passed ' + rel, read(latest / rel)['passed'])
    fcs = read(base / 'fcs_filled_layout_20261108/PRESERVATION.json')['cases']
    sta = read(base / 'fcs_filled_layout_20261108/REEXTRACTION.json')['cases']
    check('FCS setup7.13 to8.02', sta['baseline']['setup']['wns_ns'] == 7.13 and sta['optimized']['setup']['wns_ns'] == 8.02)
    check('FCS same filled area', fcs['baseline']['total_occupied_cell_area_um2'] == fcs['optimized']['total_occupied_cell_area_um2'] == 11911.424)
    reduction = 1 - fcs['optimized']['nonfiller_cell_area_um2'] / fcs['baseline']['nonfiller_cell_area_um2']
    check('FCS nonfiller area15.71pct', abs(reduction * 100 - 15.70889) < 0.005)
    lvs = read(base / 'fcs_bulk_profile_20261108/RESULT.json')['cases']
    check('Named bulk LVS positive cases', lvs['baseline']['status'] == lvs['optimized']['status'] == 'PASS')
    check('Named bulk LVS negatives', lvs['no_taps']['status'] == lvs['wrong_gate']['status'] == 'FAIL' and lvs['substrate_cut']['status'] == 'REJECT_UNSUPPORTED')
    ledger = read(root / 'output/hnu_midterm_form_20261109/ALL_VERIFIED_RESPONSE_LEDGER.json')
    ids = set()
    for item in ledger['responses']:
        path = root / item['paths'][0]
        response = read(path)
        check('Response ID source ' + item['paths'][0], (response['model'], response['id']) == (item['model'], item['id']))
        ids.add((response['model'], response['id']))
    check('Verifiable response ID lower bound327', len(ids) == ledger['combined_unique'] == 327)
    address = (base / 'expanded_feedback_80_20261107/inputs/addr128.v').read_text(encoding='utf-8')
    check('Address arithmetic source width correction', 'input [7:0] address' in address and 'output [15:0] count' in address)
    return dict(passed=not errors, checks=checks, failures=errors, archived_files=len(manifest['files']),
                claims=len(claims), batch_totals=dict(totals), verified_response_ids=len(ids),
                scope='Archive hashes, numeric recomputation and saved proof-success checks. Fresh EDA reproduction is a separate command.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--out', type=Path)
    args = parser.parse_args()
    report = verify(args.root.resolve())
    text = json.dumps(report, ensure_ascii=False, indent=2)
    if args.out:
        args.out.write_text(text + '\n', encoding='utf-8')
    print(text)
    sys.exit(0 if report['passed'] else 1)
