"""Frozen local backend controls and original RTL baselines; zero model calls."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys

from run_native_comb import digest, save

ROOT = Path(__file__).resolve().parents[2]
RUNNER = Path(__file__).with_name('run_native_seq.py')
DATA = ROOT / 'benchmark/rtl_opt_upstream_hkust/benchmark'


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out', required=True, type=Path)
    args = ap.parse_args()
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    fixtures = out / 'fixtures'
    fixtures.mkdir()
    reference = '''module seq_control(input clk, input rst, input en, output [3:0] q);
reg [3:0] state;
assign q = state;
always @(posedge clk) begin
 if (rst) state <= 0;
 else if (en) state <= state + 1'b1;
end
endmodule
'''
    encoded = '''module seq_control(input clk, input rst, input en, output [3:0] q);
reg [3:0] encoded;
assign q = ~encoded;
always @(posedge clk) begin
 if (rst) encoded <= 4'hf;
 else if (en) encoded <= encoded - 1'b1;
end
endmodule
'''
    texts = {'counter': reference, 'encoded': encoded,
             'wrong_reset': reference.replace('state <= 0;', "state <= 1;"),
             'wrong_enable': reference.replace('else if (en)', 'else if (!en)'),
             'late_error': reference.replace("state + 1'b1", "state == 7 ? 0 : state + 1'b1"),
             'extra_latency': reference.replace('assign q = state;', 'reg [3:0] delayed;\nassign q = delayed;\nalways @(posedge clk) delayed <= state;'),
             'async_reset': reference.replace('posedge clk)', 'posedge clk or posedge rst)'),
             'wrong_edge': reference.replace('posedge clk)', 'negedge clk)')}
    for name, text in texts.items():
        (fixtures / (name + '.v')).write_text(text, encoding='utf-8')
    adder = DATA / 'adder/adder.v'
    positive = fixtures / 'adder_rewrite.v'
    positive.write_text('''module adder #(parameter N=32)(input [N-1:0] DATA_1, DATA_2,
input SEL_0, SEL_1, clk, output reg [N-1:0] reg_0);
always @(posedge clk) reg_0 <= SEL_1 ? DATA_2 : SEL_0 ? DATA_1 + DATA_2 : DATA_1;
endmodule
''', encoding='utf-8')
    cases = []
    def add(name, candidate, ref, top, expected, reset=None, warmup=1):
        cases.append(dict(id=name, candidate=str(candidate), candidate_sha256=digest(candidate),
                          reference=str(ref), reference_sha256=digest(ref), top=top, expected=expected,
                          reset=reset, warmup=warmup))
    for name in texts:
        add(name, fixtures / (name + '.v'), fixtures / 'counter.v', 'seq_control',
            'PASS' if name in ('counter', 'encoded') else 'SCHEMA_REJECT' if name in ('async_reset', 'wrong_edge') else 'FORMAL_FAIL', 'rst')
    add('adder_baseline', adder, adder, 'adder', 'PASS')
    add('adder_rewrite', positive, adder, 'adder', 'PASS')
    selector = DATA / 'selector/selector.v'
    add('selector_baseline', selector, selector, 'selector', 'PASS')
    saturating = DATA / 'saturating_add/saturating_add.v'
    add('saturating_add_baseline', saturating, saturating, 'saturating_add', 'PASS', warmup=2)
    snapshot = out / 'code_snapshot'
    snapshot.mkdir()
    dependencies = [RUNNER, Path(__file__), RUNNER.with_name('run_native_comb.py'), RUNNER.with_name('trace_sta_rtl_cone.py')]
    for p in dependencies:
        shutil.copyfile(p, snapshot / p.name)
    protocol = dict(purpose='Backend validation, not model comparison or optimization claim',
                    cases=cases, llm_generation_requests=0, timeout_per_tool_seconds=120,
                    runner_sha256=digest(RUNNER), dependencies={str(p): digest(p) for p in dependencies},
                    independence='Synthetic controls are development tests; original cases are not held-out model evaluations',
                    warmup='One sample by default; saturating_add requires two because stored overflow drives the next result')
    save(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(digest(out / 'protocol.json') + '\n', encoding='ascii')
    results = []
    for c in cases:
        assert all(digest(Path(p)) == h for p, h in protocol['dependencies'].items())
        assert digest(Path(c['candidate'])) == c['candidate_sha256']
        assert digest(Path(c['reference'])) == c['reference_sha256']
        folder = out / c['id']
        cmd = [sys.executable, '-B', str(RUNNER), c['candidate'], '--reference', c['reference'],
               '--top', c['top'], '--clock', 'clk', '--warmup', str(c['warmup']), '--out', str(folder)]
        if c['reset']:
            cmd += ['--reset', c['reset']]
        try:
            proc = subprocess.run(cmd, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=900)
            (out / (c['id'] + '_runner.log')).write_bytes(proc.stdout)
            r = json.loads((folder / 'result.json').read_text(encoding='utf-8'))
            actual = 'PASS' if r['status'] == 'PASS' else 'FORMAL_FAIL' if r['formal'] == 'FAIL' else 'SCHEMA_REJECT' if r.get('stage') == 'schema' else 'INCOMPLETE'
        except (subprocess.TimeoutExpired, OSError, ValueError) as exc:
            r, actual = {'failure_reason': str(exc)}, 'INCOMPLETE'
        row = dict(id=c['id'], expected=c['expected'], actual=actual, matched=actual == c['expected'], result=r)
        results.append(row)
        save(out / 'SUMMARY.json', dict(llm_generation_requests=0, completed=len(results), planned=len(cases), results=results))
        print(c['id'] + ': ' + actual + ' expected=' + c['expected'], flush=True)
    return 0 if all(r['matched'] for r in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
