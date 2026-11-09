"""Independent semantic definedness check with defined binary top inputs."""
from concurrent.futures import ThreadPoolExecutor
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from eda.experiments import run_multicircuit_feedback_144 as study


def prove(source, top, params, ports, out):
    if (out / 'result.json').exists():
        result = study.load(out / 'result.json')
        if result['source_sha256'] != study.sha(source):
            raise RuntimeError('Definedness source changed')
        return result
    out.mkdir(parents=True, exist_ok=False)
    declarations = []
    connections = []
    names = []
    outputs = []
    for i, (name, port) in enumerate(ports.items()):
        signal = f'pw_signal_{i}'
        width = len(port['bits'])
        if port['direction'] == 'input':
            declarations.append(f'input [{width-1}:0] {signal};')
            names.append(signal)
        else:
            declarations.append(f'wire [{width-1}:0] {signal};')
            outputs.append(f'((^{signal}) !== 1\'bx)')
        connections.append(f'.{name}({signal})')
    overrides = ', '.join(f'.{key}({value})' for key, value in params.items())
    parameter_text = f'#({overrides})' if overrides else ''
    wrapper = out / 'definedness.v'
    wrapper.write_text('\n'.join([
        'module pw_definedness(' + ', '.join(names + ['defined']) + ');',
        *declarations, 'output defined;',
        f'{top} {parameter_text} dut(' + ', '.join(connections) + ');',
        'assign defined = ' + ' & '.join(outputs) + ';', 'endmodule']), encoding='utf-8')
    q = lambda path: '"' + path.resolve().as_posix() + '"'
    script = out / 'definedness.ys'
    script.write_text('\n'.join([
        f'read_verilog -formal -sv {q(source)} {q(wrapper)}',
        'prep -top pw_definedness -flatten',
        'sat -enable_undef -set-def-inputs -verify -prove defined 1 -show-inputs -timeout 120']), encoding='utf-8')
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
        env.pop(key, None)
    yosys = Path(env.get('YOSYS', 'D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent) + os.pathsep + str(yosys.parent.parent / 'lib') + os.pathsep + env.get('PATH', '')
    temp = out / 'tmp'
    temp.mkdir()
    for key in ('TMP', 'TEMP', 'TMPDIR'):
        env[key] = str(temp)
    proc = subprocess.run([str(yosys), '-Q', str(script)], cwd=out, env=env, capture_output=True, timeout=150)
    log = (proc.stdout + proc.stderr).decode('utf-8', errors='replace')
    (out / 'definedness.log').write_text(log, encoding='utf-8')
    passed = proc.returncode == 0 and 'SAT proof finished - no model found: SUCCESS!' in log
    result = dict(passed=passed, source_sha256=study.sha(source), model_calls=0,
                  scope='All top inputs defined binary; every output bit must be defined under explicit Yosys undef modeling',
                  script_sha256=study.sha(script), checker_sha256=study.sha(Path(__file__)))
    study.save(out / 'result.json', result)
    return result


def check(out):
    protocol = study.validate(out)
    target = out / 'definedness_checks'
    target.mkdir(exist_ok=True)
    controls = []
    ports = {'a': {'direction': 'input', 'bits': [2]}, 'y': {'direction': 'output', 'bits': [3]}}
    for name, expression, expected in (('defined', 'a', True), ('constant_x', "1'bx", False),
                                       ('conditional_x', "a ? 1'b1 : 1'bx", False)):
        source = target / (name + '.v')
        text = f'module control(input a, output y); assign y = {expression}; endmodule\n'
        if not source.exists():
            source.write_text(text, encoding='ascii')
        result = prove(source, 'control', {}, ports, target / name)
        controls.append(dict(name=name, expected=expected, actual=result['passed']))
    if not all(c['expected'] == c['actual'] for c in controls):
        raise RuntimeError('Definedness positive/negative controls failed')
    cases = {c['id']: c for c in protocol['cases']}
    tasks = []
    for path in sorted((out / 'trials').glob('call_*/result.json')):
        row = study.load(path)
        if row['improved'] and row['case'] != 'crc32_d8':
            tasks.append((row, path.parent))
    def one(item):
        row, folder = item
        case = cases[row['case']]
        ports = study.load(folder / 'evaluation' / 'candidate_schema.json')['modules'][case['top']]['ports']
        result = prove(folder / 'candidate.v', case['top'], case['params'], ports, target / folder.name)
        return dict(call=row['index'], passed=result['passed'])
    with ThreadPoolExecutor(max_workers=3) as pool:
        records = list(pool.map(one, tasks))
    result = dict(passed=all(r['passed'] for r in records), checked=len(records), model_calls=0,
                  controls=controls, checks=records)
    (target / 'AUDIT.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('out', type=Path)
    check(parser.parse_args().out.resolve())
