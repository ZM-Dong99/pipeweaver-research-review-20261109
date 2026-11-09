"""Freeze and evaluate three original synchronous modules; never calls an LLM."""
import argparse
from datetime import datetime
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
RUNNER = ROOT / 'eda/experiments/run_native_seq.py'

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def save(p, x):
    p.write_text(json.dumps(x, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--execute', type=Path)
    args = ap.parse_args()
    if not args.execute:
        out = ROOT / 'eda/experiments' / datetime.now().strftime('sequential_queue_%Y%m%d_%H%M%S_%f')
        out.mkdir()
        snapshots = out / 'code_snapshot'
        snapshots.mkdir()
        files = [RUNNER, RUNNER.with_name('run_native_comb.py'), Path(__file__)]
        dependencies = {str(p): sha(p) for p in files}
        for p in files:
            shutil.copyfile(p, snapshots / p.name)
        cases = []
        # Contracts fixed before measuring; no output latency changes allowed.
        for name, reset, warmup in [('mul', None, 1), ('ticket_machine', 'clear', 1), ('mac', 'reset', 4)]:
            p = ROOT / 'benchmark/rtl_opt_upstream_hkust/benchmark' / name / (name + '.v')
            cases.append(dict(id=name, source=str(p), sha256=sha(p), clock='clk', reset=reset, warmup=warmup))
        save(out / 'protocol.json', dict(cases=cases, dependencies=dependencies,
             timeout_per_tool_seconds=120, period_ns=10, llm_requests=0,
             purpose='Original baseline and reset-contract qualification; no optimizer comparison',
             caution='Self-comparison can fail if independent arbitrary initial states do not synchronize under the fixed reset contract. That does not prove the source itself incorrect.'))
        (out / 'protocol.sha256').write_text(sha(out / 'protocol.json') + '\n', encoding='ascii')
        print(out)
        return 0
    out = args.execute.resolve()
    assert sha(out / 'protocol.json') == (out / 'protocol.sha256').read_text().strip()
    p = json.loads((out / 'protocol.json').read_text(encoding='utf-8'))
    for path, h in p['dependencies'].items():
        assert sha(Path(path)) == h, 'Live dependency changed; prepare a new study'
        assert sha(out / 'code_snapshot' / Path(path).name) == h
    for c in p['cases']:
        assert sha(Path(c['source'])) == c['sha256']
    rows = []
    for c in p['cases']:
        folder = out / c['id']
        if folder.exists():
            raise RuntimeError('Refusing to overwrite previous attempt: ' + str(folder))
        cmd = [sys.executable, '-B', str(RUNNER), c['source'], '--reference', c['source'],
               '--top', c['id'], '--clock', c['clock'], '--warmup', str(c['warmup']),
               '--period', str(p['period_ns']), '--timeout', str(p['timeout_per_tool_seconds']), '--out', str(folder)]
        if c['reset']:
            cmd += ['--reset', c['reset']]
        try:
            proc = subprocess.run(cmd, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=900)
            raw, code = proc.stdout, proc.returncode
        except subprocess.TimeoutExpired as exc:
            raw, code = (exc.stdout or b'') + b'\nOVERALL_TIMEOUT\n', 124
        (out / (c['id'] + '_runner.log')).write_bytes(raw)
        result = json.loads((folder / 'result.json').read_text(encoding='utf-8')) if (folder / 'result.json').exists() else {'status': 'INCOMPLETE'}
        row = dict(id=c['id'], exit_code=code, result=result)
        rows.append(row)
        save(out / 'SUMMARY.json', dict(planned=len(p['cases']), completed=len(rows), llm_requests=0, results=rows))
        print(c['id'], result['status'], result.get('formal'), result.get('failure_reason', ''), flush=True)
    for c in p['cases']:
        assert sha(Path(c['source'])) == c['sha256']
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
