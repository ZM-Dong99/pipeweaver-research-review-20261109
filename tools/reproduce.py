"""Re-run fixed baseline/candidate pairs with installed Windows+WSL EDA tools."""
import argparse
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--case', default='comparator16')
    parser.add_argument('--registry', type=Path, default=Path('REVIEW_CASES.json'))
    parser.add_argument('--liberty', type=Path, required=True)
    parser.add_argument('--out', type=Path)
    args = parser.parse_args()
    registry = load(ROOT / args.registry)
    cases = registry['cases'] if args.case == 'all' else [c for c in registry['cases'] if c['id'] == args.case]
    if not cases:
        parser.error('Unknown case. Choose all or ' + ', '.join(c['id'] for c in registry['cases']))
    if os.name != 'nt':
        parser.error('The archived evaluator requires Windows with an Ubuntu WSL distribution. Offline verification supports ordinary Python on any OS.')
    if sha(args.liberty) != registry['liberty_sha256']:
        parser.error('Liberty hash differs from the frozen experiment. Use a matching library for exact reproduction.')
    staged = ROOT / 'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
    staged.parent.mkdir(parents=True, exist_ok=True)
    if staged.exists():
        if sha(staged) != registry['liberty_sha256']:
            parser.error('Existing local staged library has a different hash')
    else:
        shutil.copyfile(args.liberty, staged)
    output = args.out.resolve() if args.out else ROOT / 'runs' / datetime.now().strftime('%Y%m%d_%H%M%S_%f')
    output.mkdir(parents=True, exist_ok=False)
    env = os.environ.copy()
    for name in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY', 'GH_TOKEN', 'GITHUB_TOKEN'):
        env.pop(name, None)
    rows = []
    for case in cases:
        measured = {}
        for role in ('baseline', 'candidate'):
            source = ROOT / case[role]['path']
            if sha(source) != case[role]['sha256']:
                raise RuntimeError('Source changed ' + str(source))
            folder = output / case['id'] / role
            if case['id'] == 'crc32_d8':
                command = [sys.executable, '-B', str(ROOT / 'eda/experiments/evaluate_crc_candidate.py'), str(source), '--out', str(folder)]
            else:
                command = [sys.executable, '-B', str(ROOT / 'eda/experiments/run_native_comb.py'), str(source),
                    '--reference', str(ROOT / case['baseline']['path']), '--top', case['top'],
                    '--mapping-policy', 'buffer_size', '--cleanup-before-buffer', '--timeout', '120', '--out', str(folder)]
                for name, value in case['parameters'].items():
                    command.extend(('--param', f'{name}={value}'))
            folder.parent.mkdir(parents=True, exist_ok=True)
            proc = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, timeout=1200)
            (folder.parent / (role + '_runner.log')).write_bytes(proc.stdout + proc.stderr)
            path = folder / 'result.json'
            measured[role] = load(path) if path.exists() else {'status': 'INCOMPLETE'}
        fields = ('max_data_arrival_ns', 'mapped_area_um2', 'tns_ns')
        exact = all(all(type(measured[role].get(k)) in (int, float) and
                        abs(measured[role][k] - case[role]['expected'][k]) < 1e-9 for k in fields)
                    for role in ('baseline', 'candidate'))
        passed = all(m.get('status') == 'PASS' and m.get('formal') == m.get('mapped_formal') == m.get('ppa') == 'PASS'
                     and m.get('electrical', {}).get('status') == 'PASS' for m in measured.values())
        rows.append(dict(case=case['id'], proofs_and_ppa_passed=passed, exact_metrics_match=exact, measured=measured))
        print(case['id'], 'proofs_and_ppa=' + str(passed), 'exact_metrics=' + str(exact), flush=True)
    result = dict(passed=all(r['proofs_and_ppa_passed'] and r['exact_metrics_match'] for r in rows),
                  model_calls=0, scope='Selected fixed combinational instances, freshly measured in a new directory',
                  registry=str(args.registry), checks=rows)
    (output / 'REPRODUCTION.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    print('Saved ' + str(output / 'REPRODUCTION.json'))
    return 0 if result['passed'] else 1


if __name__ == '__main__':
    sys.exit(main())
