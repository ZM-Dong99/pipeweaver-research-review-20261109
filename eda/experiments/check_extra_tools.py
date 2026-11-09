"""Exercise existing OSS CAD tools with positive and negative examples. No model calls."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out', required=True, type=Path)
    ap.add_argument('--suite', type=Path, default=Path(r'D:\oss-cad-suite'))
    args = ap.parse_args()
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    suite = args.suite.resolve()
    env = os.environ.copy()
    env['PATH'] = os.pathsep.join((str(suite / 'bin'), str(suite / 'lib'), env.get('PATH', '')))
    env['VERILATOR_ROOT'] = str(suite / 'share/verilator')
    env['YOSYSHQ_ROOT'] = str(suite)
    records = []

    def run(label, command, expected_codes=(0,), marker=None, cwd=ROOT):
        try:
            proc = subprocess.run([str(x) for x in command], cwd=cwd, env=env, stdout=subprocess.PIPE,
                                  stderr=subprocess.STDOUT, timeout=120)
            raw, code = proc.stdout, proc.returncode
            passed = code in expected_codes and (marker is None or marker in raw.decode('utf-8', errors='replace'))
        except (OSError, subprocess.TimeoutExpired) as exc:
            raw, code, passed = str(exc).encode(), None, False
        (out / (label + '.log')).write_bytes(raw)
        records.append(dict(label=label, command=[str(x) for x in command], exit_code=code, passed=passed))
        print(label + ': ' + ('PASS' if passed else 'FAILED'), flush=True)

    for exe in ('sby', 'eqy', 'z3', 'slang', 'verilator_bin'):
        run(exe + '_version', [suite / ('bin/' + exe + '.exe'), '--version'])
    run('verilator_lint', [suite / 'bin/verilator_bin.exe', '--lint-only', '--top-module', 'minimal_and', ROOT / 'tests/minimal.v'])
    bad = out / 'bad.v'
    bad.write_text('module bad(input a, output y); assign y = ; endmodule\n', encoding='utf-8')
    run('verilator_reject_bad', [suite / 'bin/verilator_bin.exe', '--lint-only', bad], (1,), '%Error')
    # Native unpacked-array ports rejected by the legacy Yosys frontend.
    mux = next((ROOT / 'benchmark/rtl_opt_upstream_hkust/benchmark/mux_encode').glob('*.sv'))
    run('slang_native_mux', [suite / 'bin/slang.exe', '--top', 'mux_encode', mux])
    for name, increment, expected in (('correct', 1, 0), ('wrong', 2, 2)):
        source = out / (name + '.sv')
        source.write_text('''module counter(input clk);
reg [3:0] q = 0;
reg valid = 0;
always @(posedge clk) begin
 q <= q + 4'd1;
 valid <= 1;
 if (valid) assert(q == $past(q) + 4'd''' + str(increment) + ''');
end
endmodule
''', encoding='utf-8')
        sby = out / (name + '.sby')
        sby.write_text('[options]\nmode prove\ndepth 12\n\n[engines]\nsmtbmc z3\n\n[script]\nread -formal ' + source.name + '\nprep -top counter\n\n[files]\n' + source.name + '\n', encoding='utf-8')
        run('sby_' + name, [suite / 'bin/sby.exe', '-d', out / (name + '_proof'), sby], (expected,),
            'DONE (PASS' if expected == 0 else 'DONE (FAIL', out)
    report = dict(passed=all(r['passed'] for r in records), checks=records, suite=str(suite),
                  suite_version=(suite / 'VERSION').read_text().strip(), llm_generation_requests=0,
                  downloaded_packages=0, runner_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  limits='Verilator lint only, not C++ simulation; Slang elaboration only, not mapped PPA; GTKWave discovered but GUI not launched; SBY synthetic proof only')
    (out / 'SUMMARY.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
