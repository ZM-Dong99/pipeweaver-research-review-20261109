"""Opt-in logical-initialization sequential qualification with proven state invariants.

Deliberately rejects asynchronous reset, latches, memories, generated clocks and
formal assumptions. Equality starts after an explicit warmup/reset contract.
"""
import argparse
import json
import math
import os
from pathlib import Path
import re
import time

from run_native_comb import digest, execute, identifier, parse_electrical_report, parse_parameter_overrides, q, save

ROOT = Path(__file__).resolve().parents[2]
LIB = ROOT / 'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'


def initial_attribute_commands(module, top):
    commands, records = [], []
    for name, net in sorted(module['netnames'].items()):
        value = net.get('attributes', {}).get('init')
        if value is None:
            continue
        if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_.$]*', name) or not re.fullmatch(r'[01x]+', value) or len(value) != len(net['bits']):
            raise ValueError('Unsupported initial attribute or internal name')
        commands.append(f"setattr -set init {len(value)}'b{value} {top}/w:{name}")
        records.append(dict(net=name, width=len(value), value=value))
    return commands, records


def state_nets(module, mapped=False):
    bits = set()
    for cell in module['cells'].values():
        if cell['type'] == '$dff' or (mapped and cell['type'].startswith('sky130_fd_sc_hd__df')):
            bits.update(cell['connections'].get('Q', []))
    return {n: len(v['bits']) for n, v in module['netnames'].items()
            if n not in module['ports'] and re.fullmatch(r'[A-Za-z_][A-Za-z0-9_.$]*', n)
            and v['bits'] and all(type(b) is int and b in bits for b in v['bits'])}


def common_state_nets(gold, candidate, mapped=False):
    a = state_nets(gold)
    # ABC may buffer a logical register signal. Its preserved named wire is
    # still a legitimate extra property to PROVE, even if not a direct Q pin.
    b = ({n: len(v['bits']) for n, v in candidate['netnames'].items()}
         if mapped else state_nets(candidate))
    return {n: a[n] for n in sorted(a.keys() & b.keys()) if a[n] == b[n]}


def validate_schema(module, clock):
    ports = module['ports']
    if clock not in ports or ports[clock]['direction'] != 'input' or len(ports[clock]['bits']) != 1:
        raise ValueError('Clock must be a scalar input')
    if any(p['direction'] not in ('input', 'output') for p in ports.values()):
        raise ValueError('Inout ports are unsupported')
    state = 0
    for cell in module['cells'].values():
        kind = cell['type']
        if kind != '$dff' and re.search(r'dff|latch|mem|ff$|anyseq|anyconst|assume|assert|initstate', kind, re.I):
            raise ValueError('Unsupported state/formal cell: ' + kind)
        for pin, bits in cell['connections'].items():
            if ports[clock]['bits'][0] in bits and not (kind == '$dff' and pin == 'CLK'):
                raise ValueError('Clock used as data or derived clock is unsupported')
        if kind == '$dff':
            state += 1
            if cell['connections']['CLK'] != ports[clock]['bits'] or int(cell['parameters']['CLK_POLARITY'], 2) != 1:
                raise ValueError('Only direct positive-edge single-clock state is supported')
        elif re.search(r'dff|latch|mem|ff$|anyseq|anyconst|assume|assert|initstate', kind, re.I):
            raise ValueError('Unsupported state/formal cell: ' + kind)
    if not state:
        raise ValueError('No supported state found')
    return {n: (p['direction'], len(p['bits'])) for n, p in ports.items()}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('candidate', type=Path)
    ap.add_argument('--reference', required=True, type=Path)
    ap.add_argument('--top', required=True)
    ap.add_argument('--clock', required=True)
    ap.add_argument('--out', required=True, type=Path)
    ap.add_argument('--reset', help='Optional synchronous scalar reset, asserted for an explicit startup window')
    ap.add_argument('--reset-active', type=int, choices=(0, 1), default=1)
    ap.add_argument('--reset-cycles', type=int, default=1,
                    help='Initial samples with reset asserted; requires reset when greater than one; afterwards reset is unconstrained')
    ap.add_argument('--warmup', type=int, default=1, help='Samples excluded from equality; explicit interface contract')
    ap.add_argument('--period', type=float, default=10.0)
    ap.add_argument('--timeout', type=int, default=120)
    ap.add_argument('--param', action='append', default=[], metavar='NAME=INTEGER', help='Fixed top parameters, identical for reference and candidate')
    ap.add_argument('--dependency', action='append', type=Path, default=[], help='Fixed shared helper source; repeatable, not an include-path search')
    ap.add_argument('--initial-state-policy', required=True, choices=['rtl-declared'],
                    help='Explicit logical RTL init assumptions, including mapped Q nets; not physical power-up verification')
    ap.add_argument('--prove-state-invariants', action='store_true',
                    help='Strengthen equality with common named register Q nets; prove these relations, never assume them')
    ap.add_argument('--unmap-clock-enables', action='store_true',
                    help='Uniform mapping alternative: expand clock enables into input muxes before liberty mapping')
    args = ap.parse_args()
    try:
        parameters = parse_parameter_overrides(args.param)
    except ValueError as exc:
        ap.error(str(exc))
    for name in (args.top, args.clock, args.reset):
        if name and not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', name):
            ap.error('Only plain identifiers are supported')
    if args.warmup < 1 or args.timeout < 1 or not math.isfinite(args.period) or args.period <= 0:
        ap.error('Warmup, timeout and finite clock period must be positive')
    if args.reset_cycles < 1 or args.reset_cycles > args.warmup:
        ap.error('Reset cycles must be positive and no greater than the explicit warmup window')
    if args.reset_cycles != 1 and not args.reset:
        ap.error('Multiple reset cycles require --reset')
    candidate, reference, out = args.candidate.resolve(), args.reference.resolve(), args.out.resolve()
    dependencies = [p.resolve() for p in args.dependency]
    if len(set(dependencies)) != len(dependencies) or any(p in (candidate, reference) for p in dependencies):
        ap.error('Dependencies must be distinct helper sources, separate from top RTL')
    if not all(p.is_file() for p in [candidate, reference, LIB, *dependencies]):
        ap.error('Missing candidate, reference, library or fixed dependency')
    def reads(source):
        return [f'read_verilog -formal -sv {q(p)}' for p in [*dependencies, source]]
    param_commands = [f'chparam -set {name} {value} {args.top}' for name, value in parameters.items()]
    out.mkdir(parents=True, exist_ok=False)
    yosys = os.environ.get('YOSYS', r'D:\oss-cad-suite\bin\yosys.exe')
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
        env.pop(key, None)
    env['PATH'] = os.pathsep.join((str(Path(yosys).parent), str(Path(yosys).parent.parent / 'lib'), env.get('PATH', '')))
    protocol = dict(scope='Single-clock edge-sampled equality; no retiming or latency changes; no asynchronous reset',
                    candidate=str(candidate), candidate_sha256=digest(candidate), reference=str(reference),
                    reference_sha256=digest(reference), runner_sha256=digest(Path(__file__)),
                    parameter_overrides=parameters,
                    parameter_scope='Only this fixed parameter instance; no proof for other values',
                    dependencies=[dict(path=str(p), sha256=digest(p)) for p in dependencies],
                    helper_sha256=digest(Path(__file__).with_name('run_native_comb.py')),
                    liberty_sha256=digest(LIB), clock=args.clock, period_ns=args.period,
                    warmup_samples=args.warmup, initial_state='Independent arbitrary defined states, plus preserved RTL init attributes on source and mapped logical state',
                    initial_state_policy=args.initial_state_policy,
                    initialization_scope='Logical model only; no physical standard-cell power-up initialization guarantee',
                    prove_common_named_state_invariants=args.prove_state_invariants,
                    state_relation_scope='Additional compared outputs with complete SAT base and induction; no state equality assumption or cutpoints',
                    unmap_clock_enables=args.unmap_clock_enables,
                    parent_runner_sha256=digest(Path(__file__).with_name('run_native_seq.py')),
                    reset=args.reset, reset_active=args.reset_active,
                    reset_cycles=args.reset_cycles if args.reset else 0,
                    reset_contract=f'Reset asserted at samples 1..{args.reset_cycles}; unconstrained afterwards' if args.reset else 'No reset assumption',
                    proof='Full base case plus temporal induction; strict equality after warmup; all defined inputs',
                    input_delay_ns=0, output_delay_ns=0, input_transition_ns=0.10, output_load_pf=0.010,
                    mapping=('dffunmap -ce-only; ' if args.unmap_clock_enables else '') + 'dfflibmap; ABC map, cleanup, buffer, upsize, dnsize',
                    timeout_per_tool_seconds=args.timeout, max_induction_steps=32,
                    llm_generation_requests=0, physical_parasitics=False)
    save(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(digest(out / 'protocol.json') + '\n', encoding='ascii')
    result = dict(status='FAILED', formal='NOT_RUN', mapped_formal='NOT_RUN', ppa='NOT_RUN', eligible=False)
    started = time.monotonic()

    def run(label, lines):
        if any(digest(Path(item['path'])) != item['sha256'] for item in protocol['dependencies']):
            raise RuntimeError('Fixed dependency changed during evaluation')
        path = out / (label + '.ys')
        path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
        return execute([yosys, '-Q', str(path)], ROOT, out / (label + '.log'), env, args.timeout)

    def prepare(source, name, mapped=False, extra_state=None):
        additions = []
        if mapped:
            additions, records = initial_attribute_commands(json.loads((out / 'mapped.json').read_text())['modules'][args.top], args.top)
            save(out / 'mapped_initial_state.json', dict(attributes=records, scope=protocol['initialization_scope']))
        exposed = [f'expose {args.top}/w:{n}' for n in (extra_state or {})]
        return (([f'read_liberty -ignore_miss_func -ignore_miss_dir {q(LIB)}', f'read_verilog -formal -sv {q(source)}']
                 if mapped else reads(source) + param_commands) + [f'hierarchy -check -top {args.top}',
            'proc', 'flatten', *additions, *exposed, f'rename {args.top} {name}', f'design -stash {name}_design']
                )

    try:
        execute([yosys, '-V'], ROOT, out / 'yosys_version.log', env, args.timeout)
        result['stage'] = 'schema'
        schemas, modules = [], []
        for label, source in (('candidate', candidate), ('reference', reference)):
            jp = out / (label + '_schema.json')
            run(label + '_schema', reads(source) + param_commands + [f'hierarchy -check -top {args.top}',
                                   'proc', 'flatten', 'check -assert', f'write_json {q(jp)}'])
            module = json.loads(jp.read_text())['modules'][args.top]
            modules.append(module)
            schemas.append(validate_schema(module, args.clock))
        if schemas[0] != schemas[1]:
            raise ValueError('Native port schemas differ')
        schema = schemas[0]
        if any(not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', n) for n in schema):
            raise ValueError('Only plain port identifiers are supported')
        if args.reset and schema.get(args.reset) != ('input', 1):
            raise ValueError('Reset must be a scalar input')
        if args.reset == args.clock:
            raise ValueError('Reset and clock must differ')
        native_schema = schema.copy()

        def write_miter(schema, path):
            declarations, gold, cand, diffs, inputs, aliases = [], [], [], [], [], {}
            for i, (name, (direction, width)) in enumerate(schema.items()):
                if direction == 'input':
                    alias = 'in_' + str(i)
                    aliases[name] = alias
                    inputs.append(alias)
                    declarations.append(f'input [{width-1}:0] {alias};')
                    g = c = alias
                else:
                    g, c = f'g_{i}', f'c_{i}'
                    declarations.append(f'wire [{width-1}:0] {g}, {c};')
                    diffs.append(f'({g} != {c})')
                gold.append(f'.{identifier(name)}({g})')
                cand.append(f'.{identifier(name)}({c})')
            if not diffs:
                raise ValueError('No output ports')
            path.write_text('\n'.join(['module pw_miter(' + ','.join(inputs + ['mismatch']) + ');',
                *declarations, 'output mismatch;', 'pw_gold gold(' + ','.join(gold) + ');',
                'pw_cand cand(' + ','.join(cand) + ');', 'assign mismatch = ' + ' | '.join(diffs) + ';', 'endmodule']), encoding='utf-8')
            return aliases

        def prove(label, source, mapped=False):
            result['stage'] = label
            target_module = json.loads((out / 'mapped.json').read_text())['modules'][args.top] if mapped else modules[0]
            states = common_state_nets(modules[1], target_module, mapped) if args.prove_state_invariants else {}
            proof_schema = dict(native_schema)
            proof_schema.update({name: ('output', width) for name, width in states.items()})
            label_miter = out / (label + '_miter.v')
            proof_aliases = write_miter(proof_schema, label_miter)
            save(out / (label + '_state_invariants.json'), dict(compared_state_nets=states, assumed_state_equalities=0,
                 meaning='Joint equality property includes native outputs and these states, with complete base case and induction'))
            reset = ''.join(f' -set-at {sample} {proof_aliases[args.reset]} {args.reset_active}'
                            for sample in range(1, args.reset_cycles + 1)) if args.reset else ''
            log = run(label, prepare(reference, 'pw_gold', extra_state=states) + prepare(source, 'pw_cand', mapped, states) + [
                'design -reset', 'design -copy-from pw_gold_design pw_gold', 'design -copy-from pw_cand_design pw_cand',
                f'read_verilog -formal {q(label_miter)}', 'prep -top pw_miter -flatten', 'opt_clean',
                f'sat -verify -seq {args.warmup+1} -tempinduct -maxsteps 32'
                f' -set-init-def -set-def-inputs -prove mismatch 0{reset} -show-ports'
                f' -dump_vcd {q(out / (label + "_counterexample.vcd"))} -timeout {args.timeout}'])
            if 'Induction step proven: SUCCESS!' not in log:
                raise RuntimeError('No complete temporal induction proof')
            result[label] = 'PASS'

        prove('formal', candidate)
        result['stage'] = 'mapping'
        abc = out / 'abc.script'
        abc.write_text('strash\nmap\ncleanup -i -o\nbuffer\nupsize\ndnsize\nstime -p\n', encoding='ascii')
        constr = out / 'abc.constr'
        constr.write_text('set_driving_cell sky130_fd_sc_hd__buf_2\nset_load 10.0\n', encoding='ascii')
        mapped, jp = out / 'mapped.v', out / 'mapped.json'
        log = run('mapping', [f'read_liberty -lib {q(LIB)}'] + reads(candidate) + param_commands + [
            f'hierarchy -check -top {args.top}', 'flatten', 'delete t:$scopeinfo', f'synth -top {args.top} -noabc',
            *(['dffunmap -ce-only'] if args.unmap_clock_enables else []),
            f'dfflibmap -liberty {q(LIB)}',
            f'abc -script {q(abc)} -constr {q(constr)} -liberty {q(LIB)} -dont_use sky130_fd_sc_hd__lpflow_*',
            'clean', 'check -assert', f'stat -liberty {q(LIB)}', f'write_json {q(jp)}', f'write_verilog -noattr {q(mapped)}'])
        cells = json.loads(jp.read_text())['modules'][args.top]['cells']
        if any(not c['type'].startswith('sky130_fd_sc_hd__') for c in cells.values()):
            raise RuntimeError('Unmapped cells remain')
        prove('mapped_formal', mapped, True)
        result['mapped_area_um2'] = float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)', log)[-1])
        result['mapped_cells'] = len(cells)
        compatible = re.sub(r'(?m)^(\s*(?:wire|input|output|inout))\s+signed\b', r'\1', mapped.read_text())
        sta_v = out / 'mapped_sta.v'
        sta_v.write_text(compatible, encoding='utf-8')
        sdc = out / 'timing.sdc'
        sdc.write_text('\n'.join([f'create_clock -name core_clk -period {args.period} [get_ports {{{args.clock}}}]',
            'set data_inputs [get_ports {' + ' '.join(n for n, (d, _) in schema.items() if d == 'input' and n != args.clock) + '}]',
            'set_input_delay -max 0 -clock core_clk $data_inputs',
            'set_output_delay -max 0 -clock core_clk [all_outputs]',
            'set_input_transition 0.10 $data_inputs', 'set_load 0.010 [all_outputs]']) + '\n', encoding='ascii')
        def wsl(p):
            s = p.resolve().as_posix()
            return '/mnt/' + s[0].lower() + s[2:]
        tcl = out / 'run_sta.tcl'
        tcl.write_text('\n'.join([f'read_liberty {{{wsl(LIB)}}}', f'read_verilog {{{wsl(sta_v)}}}',
            f'link_design {args.top}', f'read_sdc {{{wsl(sdc)}}}', 'check_setup',
            'report_checks -path_delay max -format full_clock_expanded -group_path_count 10',
            'report_worst_slack -max', 'report_tns -max', 'puts {PW_ELECTRICAL_BEGIN}',
            'report_check_types -max_slew -max_capacitance -violators -digits 6', 'puts {PW_ELECTRICAL_END}']) + '\n', encoding='utf-8')
        result['stage'] = 'sta'
        execute(['wsl.exe', '-d', 'Ubuntu', '--', os.environ.get('OPENSTA', '/home/easton1/OpenSTA/build/sta'),
                 '-version'], ROOT, out / 'opensta_version.log', env, args.timeout)
        sta = execute(['wsl.exe', '-d', 'Ubuntu', '--', os.environ.get('OPENSTA', '/home/easton1/OpenSTA/build/sta'),
                       '-no_splash', '-exit', wsl(tcl)], ROOT, out / 'sta.log', env, args.timeout)
        result['electrical'] = parse_electrical_report(sta)
        for key, pattern in [('wns_ns', r'worst slack max\s+([-+\d.]+)'), ('tns_ns', r'tns max\s+([-+\d.]+)')]:
            match = re.search(pattern, sta)
            if not match or not math.isfinite(float(match[1])):
                raise RuntimeError('Missing finite STA metric: ' + key)
            result[key] = float(match[1])
        if not re.search(r'Endpoint:.*\n', sta) or re.search(r'^\s*Warning:', sta, re.M | re.I):
            raise RuntimeError('Timing coverage incomplete; inspect sta.log')
        result.update(ppa='PASS', mapped_sha256=digest(mapped), sdc_sha256=digest(sdc))
        result['eligible'] = result['electrical']['status'] == 'PASS'
        result['eligibility_scope'] = 'Fixed logical RTL-initialization model only; physical power-up not verified'
        result['physical_power_up_verified'] = False
        result['status'] = 'PASS' if result['eligible'] else 'ELECTRICAL_FAIL'
    except Exception as exc:
        result['failure_reason'] = f'{type(exc).__name__}: {exc}'
        stage = result.get('stage')
        if stage in ('formal', 'mapped_formal'):
            logpath = out / (stage + '.log')
            log = logpath.read_text(errors='replace') if logpath.exists() else ''
            result[stage] = 'FAIL' if 'model found for base case: FAIL!' in log else 'INCOMPLETE'
    result['elapsed_seconds'] = round(time.monotonic() - started, 3)
    save(out / 'result.json', result)
    print(json.dumps(result, ensure_ascii=False), flush=True)
    return 0 if result['status'] == 'PASS' else 1


if __name__ == '__main__':
    raise SystemExit(main())
