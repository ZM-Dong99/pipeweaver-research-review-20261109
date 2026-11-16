"""Prepare and reproduce sequential/composite cases and parameter sweeps.

Preparation and qualification perform local EDA only. Model collection is a
separate, explicitly budgeted operation.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import math
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import evaluate as evaluate_comb, load, save, sha
from eda.experiments.prove_crc_affine import prove as prove_crc

BANK = ROOT / 'benchmark/systematic_20261116/rtl'
SEQUENTIAL = ROOT / 'eda/experiments/run_native_seq_reset_allpins.py'
LIB = ROOT / 'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'


def frozen_source(paths):
    return '\n\n'.join(path.read_text(encoding='utf-8-sig') for path in paths)


def prepare(out):
    out.mkdir(parents=True, exist_ok=False)
    (out / 'inputs').mkdir()
    alu = BANK / 'alu_param.v'
    pipeline = BANK / 'pipeline_alu.v'
    axis_root = ROOT / 'benchmark/engineering_sources_20261106'
    arbiter_root = ROOT / 'benchmark/engineering_sources_20261030/verilog-axis/rtl'
    upstream = ROOT / 'benchmark/rtl_opt_upstream_hkust/benchmark'
    fcs = ROOT / 'eda/experiments/fcs_reset_complete_20261107_induction_fixed/exports/baseline.v'
    cases = []

    def add(case_id, top, parameters, sources, backend, category, description, text=None):
        dest = out / 'inputs' / (case_id + '.v')
        dest.write_text(text if text is not None else frozen_source(sources), encoding='utf-8')
        cases.append(dict(id=case_id, top=top, parameters=parameters, backend=backend,
            category=category, description=description, input=dest.relative_to(out).as_posix(),
            source_sha256=sha(dest), source_lines=len(dest.read_text(encoding='utf-8').splitlines()),
            provenance=[dict(path=p.relative_to(ROOT).as_posix(), sha256=sha(p)) for p in sources],
            clock='clk' if backend == 'sequential' else None,
            reset='rst' if backend == 'sequential' else None, period_ns=10.0))

    for width, stages in ((16, 2), (32, 3)):
        add(f'pipeline_alu{width}_s{stages}', 'pw_pipeline_alu', dict(WIDTH=width, STAGES=stages),
            [alu, pipeline], 'sequential', 'pipeline',
            'Project-authored registered-operand ALU and registered-output pipeline, fixed cycle latency')
    fsm_source = upstream / 'fsm/fsm.v'
    fsm = fsm_source.read_text(encoding='utf-8-sig')
    fsm = fsm.replace('module fsm (', 'module pw_fsm_sync (')
    fsm = fsm.replace('always @(posedge clk or negedge rst_n)', 'always @(posedge clk)')
    fsm = fsm.replace('input rst_n,', 'input rst,').replace('if (!rst_n)', 'if (rst)')
    add('fsm9_sync', 'pw_fsm_sync', {}, [fsm_source], 'sequential', 'fsm',
        'Explicit new synchronous-reset variant of the public nine-state FSM; sampled-reset contract', fsm)
    cases[-1]['keep_fsm_encoding'] = True
    add('arbiter32', 'arbiter', dict(PORTS=32, ARB_TYPE_ROUND_ROBIN=1, ARB_BLOCK=1, ARB_BLOCK_ACK=1),
        [arbiter_root / 'priority_encoder.v', arbiter_root / 'arbiter.v'], 'sequential', 'composite',
        'Public round-robin arbiter with priority encoder, grant and acknowledge state')
    add('fcs_reset8', 'axis_eth_fcs_reset', {}, [fcs], 'sequential', 'composite',
        'Previously qualified reset-complete full FCS block specialized to eight-bit input')
    add('axis_chain8_32', 'pw_axis_chain', dict(M_DATA_WIDTH=32, M_KEEP_WIDTH=4),
        [axis_root / 'axis_adapter.v', axis_root / 'axis_register.v', BANK / 'axis_chain.v'],
        'sequential', 'composite',
        'Project-authored byte packer plus skid register; explicit zero invalid cycles and invalid bytes; all pins compared')
    cases[-1]['prove_state_invariants'] = False
    for width in (8, 16, 32, 64):
        add(f'alu{width}', 'pw_alu', dict(WIDTH=width), [alu], 'native_comb', 'parameter_scan',
            'Parameterized adaptation of public ALU; seven operations and zero default')
    for width in (32, 64, 128, 256):
        add(f'priority{width}', 'priority_encoder', dict(WIDTH=width, LSB_HIGH_PRIORITY=0),
            [arbiter_root / 'priority_encoder.v'], 'native_comb', 'parameter_scan',
            'Same public encoder and fixed priority direction across widths')
    lfsr = ROOT / 'benchmark/engineering_sources_20261030/verilog-lfsr/rtl/lfsr.v'
    for width in (4, 8, 16, 32):
        top = f'pw_crc32_d{width}'
        wrapper = f'''\nmodule {top}(input wire [{width-1}:0] data_in, input wire [31:0] state_in,
output wire [{width-1}:0] data_out, output wire [31:0] state_out);
lfsr #(.LFSR_WIDTH(32), .LFSR_POLY(32'h04c11db7), .LFSR_CONFIG("GALOIS"),
.LFSR_FEED_FORWARD(0), .REVERSE(1), .DATA_WIDTH({width}), .STYLE("REDUCTION")) core
(.data_in(data_in), .state_in(state_in), .data_out(data_out), .state_out(state_out));
endmodule
'''
        add(f'crc32_d{width}', top, {}, [lfsr], 'crc_slang', 'parameter_scan',
            'Public reflected CRC32 LFSR and fixed wrapper; arbitrary state and data, every output bit',
            frozen_source([lfsr]) + wrapper)
        cases[-1]['data_width'] = width
    protocol = dict(schema_version=1, purpose='Sequential coverage and engineering composition with parameter boundaries',
        cases=cases, model_requests=0, model_collection='Pending explicit new call limit',
        sequential_contract='Independent arbitrary defined initial states; strip init; first sample reset; compare every output from sample2; repeated reset and all other inputs unconstrained; fixed cycle latency',
        sequential_proof='Native outputs and optional common state relations are jointly proven with base cases and induction',
        acceptance='Source and mapped proof, PPA and electrical PASS; area <= original 110%; nondegrading TNS; strictly better WNS for sequential or arrival for combinational',
        planned_engineering=dict(cases=6, strategies=['direct', 'sta', 'adaptive'], repeats=3,
            max_calls_per_run=3, maximum_calls=162, sequential_target_wns_gain_ns=0.1),
        planned_parameter_scan=dict(cases=['alu16','alu32','alu64','priority64','priority128','priority256','crc32_d4','crc32_d8','crc32_d16'],
            strategies=['direct','sta'], repeats=3, max_calls_per_run=1, maximum_calls=54),
        budget_variants={'54':'One replicate of six engineering cases and three strategies, at most three calls each',
                         '162':'Three engineering replicates', '216':'Engineering replicates plus parameter scan'},
        generation=dict(model='gpt-6.1-sol', max_completion_tokens=16000, timeout_seconds=600,
            concurrency=2, automatic_retries=0, stop_after_consecutive_transport_failures=3),
        source_dependencies={str(p.relative_to(ROOT)):sha(p) for p in
            [Path(__file__), SEQUENTIAL, ROOT/'eda/experiments/run_native_comb.py',
             ROOT/'eda/experiments/trace_sta_rtl_cone.py', ROOT/'eda/experiments/prove_crc_affine.py']},
        liberty_sha256=sha(LIB))
    save(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(sha(out / 'protocol.json') + '\n', encoding='ascii')
    return protocol


def evaluate(source, reference, case, out, timeout=120):
    out.parent.mkdir(parents=True, exist_ok=True)
    if case['backend'] == 'native_comb':
        return evaluate_comb(source, reference, case, out)
    env = os.environ.copy()
    for name in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
        env.pop(name, None)
    if case['backend'] == 'sequential':
        command = [sys.executable, '-B', str(SEQUENTIAL), str(source), '--reference', str(reference),
            '--top', case['top'], '--clock', case['clock'], '--reset', case['reset'],
            '--initial-state-policy', 'reset-only', '--unmap-clock-enables',
            '--period', str(case['period_ns']), '--timeout', str(timeout), '--out', str(out)]
        if case.get('prove_state_invariants', True):
            command.append('--prove-state-invariants')
        if case.get('keep_fsm_encoding',False):
            command.append('--keep-fsm-encoding')
        for name, value in case['parameters'].items():
            command.extend(['--param', f'{name}={value}'])
        try:
            result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, timeout=timeout*5+60)
            log = result.stdout + result.stderr
        except subprocess.TimeoutExpired as error:
            log = (error.stdout or b'') + (error.stderr or b'') + b'\nOVERALL_TIMEOUT'
        (out.parent / (out.name + '_runner.log')).write_bytes(log)
        return load(out / 'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE', reason='No evaluator result')
    if case['backend'] != 'crc_slang':
        raise ValueError('Unsupported backend')
    out.mkdir(parents=True, exist_ok=False)
    yosys = Path(env.get('YOSYS', 'D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent) + os.pathsep + str(yosys.parent.parent/'lib') + os.pathsep + env.get('PATH','')
    expanded = []
    for label, path in (('reference',reference), ('candidate',source)):
        folder = out / label
        folder.mkdir()
        shutil.copyfile(path, folder/'source.v')
        commands = (f'read_slang --top {case["top"]} source.v\n'
            f'hierarchy -check -top {case["top"]}\nproc\nflatten\nopt\ncheck -assert\n'
            'write_json source.json\nwrite_verilog -noattr elaborated.v\n')
        (folder/'frontend.ys').write_text(commands, encoding='ascii')
        try:
            proc = subprocess.run([str(yosys), '-s', 'frontend.ys'], cwd=folder, env=env,
                                  capture_output=True, timeout=timeout)
            (folder/'frontend.log').write_bytes(proc.stdout+proc.stderr)
        except subprocess.TimeoutExpired:
            result=dict(status='INCOMPLETE', stage='frontend', label=label)
            save(out/'result.json',result)
            return result
        if proc.returncode:
            result=dict(status='FAILED', stage='frontend', label=label)
            save(out/'result.json',result)
            return result
        module = load(folder/'source.json')['modules'][case['top']]
        if label == 'reference':
            passed, matrix, types = prove_crc(module, case['data_width'])
            save(folder/'CRC_ORACLE.json',dict(passed=passed, data_width=case['data_width'],
                types=sorted(types), input_bits=32+case['data_width'], output_bits=32+case['data_width']))
            if not passed:
                raise ValueError('CRC baseline differs from independent recurrence')
        expanded.append(folder/'elaborated.v')
    metrics = evaluate_comb(expanded[1], expanded[0], case, out/'eda')
    save(out/'result.json',metrics)
    return metrics


def verify_protocol(out):
    if sha(out/'protocol.json') != (out/'protocol.sha256').read_text().strip():
        raise ValueError('Protocol changed')
    protocol=load(out/'protocol.json')
    if sha(LIB) != protocol['liberty_sha256']:
        raise ValueError('Library changed')
    for name, digest in protocol['source_dependencies'].items():
        if sha(ROOT/name) != digest:
            raise ValueError('Evaluator dependency changed: '+name)
    for case in protocol['cases']:
        if sha(out/case['input']) != case['source_sha256']:
            raise ValueError('Frozen input changed: '+case['id'])
    return protocol


def eligible(case, metrics):
    timing = 'wns_ns' if case['backend'] == 'sequential' else 'max_data_arrival_ns'
    return (metrics.get('status') == 'PASS'
            and all(metrics.get(key) == 'PASS' for key in ('formal','mapped_formal','ppa'))
            and metrics.get('electrical',{}).get('status') == 'PASS'
            and metrics.get('eligible',True)
            and all(type(metrics.get(key)) in (int,float) and math.isfinite(metrics[key])
                    for key in (timing,'tns_ns','mapped_area_um2'))
            and metrics['mapped_area_um2'] > 0)


def qualify(out, selected, workers):
    protocol=verify_protocol(out)
    cases=[case for case in protocol['cases'] if not selected or case['id'] in selected]
    if selected and set(selected) != {case['id'] for case in cases}:
        raise ValueError('Unknown case ID')
    def one(case):
        folder=out/'baselines'/case['id']
        if (folder/'result.json').is_file():
            metrics=load(folder/'result.json')
        elif folder.exists():
            metrics=dict(status='INCOMPLETE',reason='Interrupted local EDA directory')
        else:
            metrics=evaluate(out/case['input'],out/case['input'],case,folder)
        passed=eligible(case,metrics)
        print(case['id']+' '+metrics.get('status','INCOMPLETE'),flush=True)
        return dict(case=case['id'],backend=case['backend'],category=case['category'],
                    qualified=passed,metrics=metrics)
    with ThreadPoolExecutor(max_workers=workers) as pool:
        rows=list(pool.map(one,cases))
    report=dict(checked=len(rows),qualified=sum(row['qualified'] for row in rows),
                model_requests=0,cases=rows,protocol_sha256=sha(out/'protocol.json'))
    save(out/'QUALIFICATION.json',report)
    return report


def main(argv=None):
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode',choices=('prepare','qualify','check'))
    parser.add_argument('--out',type=Path,required=True)
    parser.add_argument('--case',action='append',default=[])
    parser.add_argument('--workers',type=int,choices=(1,2),default=2)
    args=parser.parse_args(argv)
    out=args.out.resolve()
    if args.mode == 'prepare':
        result=prepare(out)
        print(json.dumps(dict(prepared=len(result['cases']),model_requests=0)))
    elif args.mode == 'qualify':
        result=qualify(out,args.case,args.workers)
        print(json.dumps(dict(checked=result['checked'],qualified=result['qualified'],model_requests=0)))
    else:
        result=verify_protocol(out)
        print(json.dumps(dict(protocol_valid=True,cases=len(result['cases']),model_requests=0)))


if __name__=='__main__':
    main()
