"""Independent output-definedness audit of saved sequential candidates after reset."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import load, save, sha


def run_yosys(script, out):
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
        env.pop(key, None)
    yosys = Path(env.get('YOSYS', 'D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent) + os.pathsep + str(yosys.parent.parent / 'lib') + os.pathsep + env.get('PATH', '')
    temp = out / 'tmp'
    temp.mkdir(exist_ok=True)
    for key in ('TMP', 'TEMP', 'TMPDIR'):
        env[key] = str(temp)
    process = subprocess.run([str(yosys), '-Q', str(script)], cwd=ROOT, env=env,
                             capture_output=True, timeout=150)
    return process.returncode, (process.stdout + process.stderr).decode('utf-8', errors='replace')


def prove(schema, top, reset, out):
    out.mkdir(parents=True, exist_ok=False)
    design = load(schema)
    module = design['modules'][top]
    ports = module['ports']
    # Strengthen the induction property with definedness of every state bit.
    # These are proved jointly with outputs and are never assumed as invariants.
    for index, cell in enumerate(module['cells'].values()):
        if cell['type'] == '$dff':
            name = f'pw_audit_state_{index}'
            if name in ports:
                raise ValueError('Audit port name collision')
            ports[name] = dict(direction='output', bits=cell['connections']['Q'])
    audited_schema = out / 'audit_schema.json'
    save(audited_schema, design)
    declarations, connections, inputs, properties = [], [], [], []
    reset_alias = None
    for index, (name, port) in enumerate(ports.items()):
        alias = f'signal_{index}'
        width = len(port['bits'])
        if port['direction'] == 'input':
            inputs.append(alias)
            declarations.append(f'input [{width - 1}:0] {alias};')
        else:
            declarations.append(f'wire [{width - 1}:0] {alias};')
            properties.append(f'((^{alias}) !== 1\'bx)')
        connections.append(f'.\\{name} ({alias})')
        if name == reset:
            reset_alias = alias
    if reset_alias is None or not properties:
        raise ValueError('Missing reset or outputs')
    wrapper = out / 'definedness.v'
    wrapper.write_text('\n'.join([
        'module pw_definedness(' + ', '.join(inputs + ['defined']) + ');',
        *declarations, 'output defined;',
        f'{top} dut(' + ', '.join(connections) + ');',
        'assign defined = ' + ' & '.join(properties) + ';', 'endmodule']), encoding='utf-8')
    quote = lambda path: '"' + path.resolve().as_posix() + '"'
    script = out / 'definedness.ys'
    script.write_text('\n'.join([
        f'read_json {quote(audited_schema)}', 'setattr -unset init w:*',
        f'read_verilog -formal {quote(wrapper)}', 'prep -top pw_definedness -flatten',
        'sat -enable_undef -set-init-def -set-def-inputs -verify -seq 2'
        ' -tempinduct -maxsteps 32 -prove defined 1'
        f' -set-at 1 {reset_alias} 1 -timeout 120']), encoding='utf-8')
    returncode, log = run_yosys(script, out)
    (out / 'definedness.log').write_text(log, encoding='utf-8')
    result = dict(passed=returncode == 0 and 'Induction step proven: SUCCESS!' in log,
                  returncode=returncode,
                  schema_sha256=sha(schema), checker_sha256=sha(Path(__file__)), model_requests=0,
                  scope='Every output defined after one sampled reset, defined binary inputs and arbitrary defined initial state; undef tracking and temporal induction')
    save(out / 'result.json', result)
    return result


def controls(out):
    records = []
    for name, expression, expected in [('binary', 'a', True), ('constant_x', "1'bx", False),
                                       ('conditional_x', "a ? 1'b1 : 1'bx", False)]:
        folder = out / name
        folder.mkdir(parents=True)
        source = folder / 'control.v'
        source.write_text('module control(input clk, rst, a, output reg y);\n'
                          f'always @(posedge clk) if (rst) y <= 0; else y <= {expression};\n'
                          'endmodule\n', encoding='ascii')
        schema = folder / 'schema.json'
        script = folder / 'schema.ys'
        script.write_text(f'read_verilog -formal "{source.as_posix()}"\n'
                          f'prep -top control\nwrite_json "{schema.as_posix()}"\n', encoding='utf-8')
        code, log = run_yosys(script, folder)
        (folder / 'schema.log').write_text(log, encoding='utf-8')
        if code:
            raise RuntimeError('Control elaboration failed')
        result = prove(schema, 'control', 'rst', folder / 'proof')
        records.append(dict(name=name, expected=expected, actual=result['passed']))
    if not all(row['expected'] == row['actual'] for row in records):
        raise RuntimeError('Definedness controls failed')
    return records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--study', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    study, out = args.study.resolve(), args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    control_records = controls(out / 'controls')
    cases = {case['id']: case for case in load(study / 'protocol.json')['cases']}
    selected = []
    for path in sorted((study / 'calls').glob('request_*/RESULT.json')):
        row = load(path)
        if row.get('accepted') and cases[row['case']]['backend'] == 'sequential':
            selected.append((path, row))

    def one(item):
        path, row = item
        case = cases[row['case']]
        evaluation = path.parent / 'evaluation'
        if row.get('shared_evaluation'):
            request = Path(row['evaluation'].replace('\\', '/')).parent.name
            evaluation = study / 'calls' / request / 'evaluation'
        result = prove(evaluation / 'candidate_schema.json', case['top'], case['reset'], out / path.parent.name)
        return dict(request=path.parent.name, case=row['case'], **result)

    with ThreadPoolExecutor(max_workers=2) as pool:
        records = list(pool.map(one, selected))
    save(out / 'RESULT.json', dict(passed=bool(records) and all(row['passed'] for row in records),
                                  checked=len(records), model_requests=0, controls=control_records, records=records))
    print(json.dumps(dict(checked=len(records), passed=all(row['passed'] for row in records))))


if __name__ == '__main__':
    main()
