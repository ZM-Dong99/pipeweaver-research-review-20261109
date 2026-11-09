"""Prepare, audit or execute an exploratory four-family, two-arm comparison.

Preparation runs local baseline EDA only. Model requests require --execute.
Existing frozen studies and evaluators are never modified.
"""
import argparse
from collections import Counter
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
from urllib.parse import urlsplit

from run_native_comb import digest, save

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.rtl_optimizer import (LLMGenerationError, api_configured, generate_from_prompt,
                                  request_parameters_for_model)

QUAL = ROOT / 'eda/experiments/baseline_qualification_20261031_000748_731025'
EVAL = Path(__file__).with_name('run_native_comb.py')
LIB = ROOT / 'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
ARMS = ('no_timing_feedback', 'sta_paths')
SELECTED = ('rtlopt_comparator_16bit', 'rtlopt_decoder_8bit',
            'engineering_priority256', 'rtlopt_mux_4to1_64bit')
CONTRACTS = {
    SELECTED[0]: 'All 16-bit unsigned A/B: preserve gt, eq and lt exactly.',
    SELECTED[1]: 'Default N=8: preserve the 256-bit one-hot output for every 8-bit input.',
    SELECTED[2]: 'Assess WIDTH=256, all other parameters at their original defaults, including LSB_HIGH_PRIORITY=0. Preserve all three outputs for every input, including encoded/unencoded values when output_valid=0; do not introduce don\'t-cares. Preserve parameter declarations/defaults; no claim for other parameter instances.',
    SELECTED[3]: 'Default WIDTH=64 and SEL_WIDTH=2: preserve the selected 64-bit word for every data0..data3 and every sel value.'}
DEPS = (Path(__file__).resolve(), EVAL, EVAL.with_name('trace_sta_rtl_cone.py'),
        ROOT / 'agents/rtl_optimizer.py')


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def exclusive(path, value):
    with path.open('x', encoding='utf-8') as stream:
        json.dump(value, stream, indent=2, ensure_ascii=False, allow_nan=False)
        stream.write('\n')


def schedule(cases):
    rows = []
    for slot in range(3):
        for index, case in enumerate(cases):
            order = ARMS if (index + slot) % 2 == 0 else ARMS[::-1]
            for arm in order:
                rows.append(dict(call_index=len(rows) + 1, case_id=case['id'], arm=arm,
                                 candidate_id=f'candidate_{slot+1:02d}'))
    return rows


def qualified(metrics):
    return (metrics.get('status') == 'PASS' and metrics.get('formal') == 'PASS'
            and metrics.get('mapped_formal') == 'PASS' and metrics.get('ppa') == 'PASS'
            and metrics.get('electrical', {}).get('status') == 'PASS')


def judge(metrics, baseline):
    eligible = qualified(metrics) and metrics['mapped_area_um2'] <= baseline['mapped_area_um2'] * 1.10 + 1e-9
    gain = 100 * (1 - metrics['max_data_arrival_ns'] / baseline['max_data_arrival_ns']) if qualified(metrics) else None
    return dict(eligible=eligible, valid_improvement=eligible and gain > 0,
                gain_at_least_5pct=eligible and gain >= 5, delay_gain_percent=gain)


def evaluate(source, reference, case, out, timeout):
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
        env.pop(key, None)
    cmd = [sys.executable, '-B', str(EVAL), str(source), '--reference', str(reference),
           '--top', case['top'], '--mapping-policy', 'buffer_size', '--cleanup-before-buffer',
           '--timeout', str(timeout), '--out', str(out)]
    for key, value in sorted(case['parameters'].items()):
        cmd += ['--param', f'{key}={value}']
    try:
        proc = subprocess.run(cmd, cwd=ROOT, env=env, stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT, timeout=timeout * 10)
        raw = proc.stdout
    except subprocess.TimeoutExpired as exc:
        raw = (exc.stdout or b'') + b'\nOVERALL TIMEOUT\n'
    out.parent.joinpath(out.name + '_runner.log').write_bytes(raw)
    result = out / 'result.json'
    return load(result) if result.exists() else {'status': 'INCOMPLETE', 'reason': 'No evaluator result'}


def prompt_pair(case, baseline, tool_protocol, rtl, sta):
    common = f'''Optimize this native combinational RTL for minimum mapped-cell maximum data arrival under a fixed mapped-area cap.
Preserve module name, native ports, widths, exact behavior and parameter declarations/defaults. No state, clocks, assumptions, restricted inputs or don't-cares. Helper modules are allowed. Only the explicitly stated fixed parameter instance is assessed.
Functional contract: {CONTRACTS[case['id']]}
Fixed top parameter overrides: {json.dumps(case['parameters'], sort_keys=True)}.
Identical tool conditions in both arms: Yosys/OpenSTA, SKY130HD TT 25C 1.80V, input transition 0.10ns, output load 0.010pF, external I/O delays 0ns, no wire parasitics. The 100ns virtual clock is only a reporting reference. Optimize maximum data arrival, not the virtual-clock period.
Mapping: {tool_protocol['mapping']}.
Baseline mapped area {baseline['mapped_area_um2']:.6f} um^2; cap {baseline['mapped_area_um2'] * 1.10:.6f} um^2. Complete all-input source equivalence, mapped-netlist equivalence and zero reported max-slew/max-capacitance violations are mandatory.
Give one candidate. Timing predictions are hypotheses, not measurements. Do not change output behavior based on comments or presumed typical inputs.
Return one JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries. candidate_rtl must be synthesizable Verilog.

Original RTL:
{rtl}
'''
    sections = sta.split('Startpoint:')[1:]
    if not sections:
        raise RuntimeError('No actual baseline paths available')
    paths = ''.join('Startpoint:' + chunk for chunk in sections[:3]).split('worst slack max')[0]
    timing = '\nMeasured baseline timing (ns):\n' + json.dumps({k: baseline[k] for k in ('max_data_arrival_ns', 'wns_ns', 'tns_ns')}, sort_keys=True)
    timing += '\nFirst up to three actual mapped baseline STA paths, in report order:\n' + paths
    timing += '\nThese are mapped-cell paths; no exact mapped-gate-to-RTL correspondence is asserted.\n'
    return {ARMS[0]: common, ARMS[1]: common + timing}


def prepare(args):
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    qp = load(QUAL / 'protocol.json')
    cases_by_id = {c['id']: c for c in qp['cases']}
    cases = [cases_by_id[cid] for cid in SELECTED]
    for c in cases:
        if c['planned_split'] != 'evaluation_candidate_family' or c['edge_trigger_hint']:
            raise RuntimeError('Selection must use previously frozen candidate combinational families')
        if digest(ROOT / c['source']) != c['source_sha256']:
            raise RuntimeError('Qualification source changed: ' + c['id'])
        if load(QUAL / 'cases' / (c['id'] + '.json'))['status'] != 'QUALIFIED':
            raise RuntimeError('Previously unqualified selection: ' + c['id'])
    if len({c['family'] for c in cases}) != 4:
        raise RuntimeError('Expected four distinct families')
    endpoint = args.endpoint.rstrip('/')
    parsed = urlsplit(endpoint)
    if parsed.scheme != 'https' or parsed.username or parsed.password or parsed.query or parsed.fragment:
        raise ValueError('Endpoint must be HTTPS without credentials, query or fragment')
    curl = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    if not curl:
        raise RuntimeError('Verified curl transport required')
    # Freeze selection and budget before fresh baseline measurements; do not substitute failures.
    selection = dict(cases=cases, selected_at=datetime.now().astimezone().isoformat(),
                     reason='One explicit width/configuration per candidate family; larger available width of the standard comparator/decoder/4:1 mux forms and the pinned 256-way engineering encoder. Selected after prior baseline qualification, before optimization generation; not a blind holdout.',
                     qualification_protocol_sha256=digest(QUAL / 'protocol.json'),
                     qualification_audit_sha256=digest(QUAL / 'AUDIT.json'),
                     slots_per_arm=3, arms=list(ARMS), total_generation_slots=24,
                     model=args.model, endpoint=endpoint, request_parameters=request_parameters_for_model(args.model, 0.2),
                     transport='curl', timeout_per_tool_seconds=120, llm_timeout_seconds=300,
                     failure_policy='Keep every slot/family; no retries, replacement, per-design prompt repair or silent baseline substitution')
    exclusive(out / 'SELECTION.json', selection)
    snapshots = out / 'code_snapshot'
    snapshots.mkdir()
    for dep in DEPS:
        shutil.copyfile(dep, snapshots / dep.name)
    print('Frozen selection: ' + str(out), flush=True)
    for c in cases:
        folder = out / 'cases' / c['id']
        folder.mkdir(parents=True)
        shutil.copyfile(ROOT / c['source'], folder / 'reference.v')
        metrics = evaluate(folder / 'reference.v', folder / 'reference.v', c, folder / 'baseline', 120)
        print(c['id'] + ': ' + str(metrics.get('status')), flush=True)
        if not qualified(metrics):
            save(out / 'PREPARATION_STATUS.json', dict(status='BASELINE_FAILED', case_id=c['id'], llm_generation_requests=0))
            raise RuntimeError('Baseline failed; selection retained, no API calls made')
        baseline = folder / 'baseline'
        prompts = prompt_pair(c, metrics, load(baseline / 'protocol.json'),
                              (folder / 'reference.v').read_text(encoding='utf-8'), (baseline / 'sta.log').read_text(encoding='utf-8'))
        for arm, prompt in prompts.items():
            (folder / (arm + '.txt')).write_text(prompt, encoding='utf-8')
    frozen = {str(p.relative_to(out)): digest(p) for p in out.rglob('*') if p.is_file()}
    protocol = dict(**selection, selection_sha256=digest(out / 'SELECTION.json'),
                    call_schedule=schedule(cases), file_sha256=frozen,
                    dependency_sha256={str(p.relative_to(ROOT)): digest(p) for p in DEPS},
                    liberty_sha256=digest(LIB), curl_path=str(Path(curl).resolve()), curl_sha256=digest(Path(curl)),
                    common_prefix_rule='STA arm is exact no-feedback prompt plus timing-only suffix; no reference solutions or extra synthesis feedback',
                    acceptance=dict(area_cap_ratio=1.10, primary='Per family/arm select minimum qualified delay including original baseline; family gain=100*(1-selected_delay/baseline_delay). Primary contrast is mean across four families of STA gain minus no-feedback gain, in percentage points.',
                                    secondary='Strictly improved slot fraction and >=5% improved slot fraction; all three slots per arm remain denominator',
                                    duplicates='Report identical mapped netlist hashes, not independent inventions'),
                    analysis_limits='Four exploratory paired families, three requests/arm. Public training exposure unknown; prompts differ in tokens; no generality, stable benefit or statistical significance claim. Provider model alias/build not independently verified.',
                    stopping='Exactly 24 requests maximum; no request retries. Freeze all generation before candidate EDA. Unexpected interruption with attempt marker aborts instead of silently duplicating a request.')
    exclusive(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(digest(out / 'protocol.json') + '\n', encoding='ascii')
    save(out / 'PREPARATION_STATUS.json', dict(status='PREPARED_NOT_EXECUTED', llm_generation_requests=0))
    return out


def audit(out, live=True):
    p = load(out / 'protocol.json')
    checks = []
    def check(label, passed):
        checks.append(dict(label=label, passed=bool(passed)))
    check('Protocol hash', digest(out / 'protocol.json') == (out / 'protocol.sha256').read_text().strip())
    check('Selection hash', digest(out / 'SELECTION.json') == p['selection_sha256'])
    for rel, expected in p['file_sha256'].items():
        check('Artifact ' + rel, (out / rel).is_file() and digest(out / rel) == expected)
    if live:
        for rel, expected in p['dependency_sha256'].items():
            check('Live dependency ' + rel, digest(ROOT / rel) == expected)
        check('Library', digest(LIB) == p['liberty_sha256'])
        check('Transport binary', digest(Path(p['curl_path'])) == p['curl_sha256'])
    check('Schedule regeneration', p['call_schedule'] == schedule(p['cases']))
    check('Slot counts', Counter((r['case_id'], r['arm']) for r in p['call_schedule']) == Counter({(c['id'], a): 3 for c in p['cases'] for a in ARMS}))
    for c in p['cases']:
        folder = out / 'cases' / c['id']
        check(c['id'] + ' baseline qualification', qualified(load(folder / 'baseline/result.json')))
        no, sta = ((folder / (a + '.txt')).read_text(encoding='utf-8') for a in ARMS)
        check(c['id'] + ' prompt prefix', sta.startswith(no) and len(sta) > len(no))
        check(c['id'] + ' fixed parameter overrides', load(folder / 'baseline/protocol.json')['parameter_overrides'] == c['parameters'])
    record = dict(passed=all(c['passed'] for c in checks), check_count=len(checks), checks=checks,
                  scope='Artifact consistency audit; check count is not independent experiment count')
    save(out / 'PREPARATION_AUDIT.json', record)
    if not record['passed']:
        raise RuntimeError('Frozen study audit failed')
    return p


def summarize(out, protocol, rows):
    groups, contrasts = {}, []
    for c in protocol['cases']:
        folder = out / 'cases' / c['id']
        base = load(folder / 'baseline/result.json')
        groups[c['id']] = {}
        for arm in ARMS:
            rr = [r for r in rows if r['case_id'] == c['id'] and r['arm'] == arm]
            valid = [r for r in rr if r['eligible']]
            selected = min([base['max_data_arrival_ns']] + [r['metrics']['max_data_arrival_ns'] for r in valid])
            groups[c['id']][arm] = dict(scheduled=3, generated=sum(r.get('candidate_sha256') is not None for r in rr),
                strict_improvements=sum(r['valid_improvement'] for r in rr),
                gains_at_least_5pct=sum(r['gain_at_least_5pct'] for r in rr),
                selected_delay_ns=selected, baseline_retained=selected == base['max_data_arrival_ns'],
                selected_gain_percent=100 * (1 - selected / base['max_data_arrival_ns']),
                unique_mapped_hashes=len({r['metrics']['mapped_sha256'] for r in valid}))
        contrasts.append(groups[c['id']][ARMS[1]]['selected_gain_percent'] - groups[c['id']][ARMS[0]]['selected_gain_percent'])
    save(out / 'summary.json', dict(groups=groups, primary_mean_gain_difference_percentage_points=sum(contrasts) / 4,
                                    inference_limit=protocol['analysis_limits'], results=rows))


def execute(out):
    p = audit(out)
    if not api_configured():
        raise RuntimeError('API credential missing; prepared study unchanged')
    if os.environ.get('OPENAI_BASE_URL', 'https://api.openai.com/v1').rstrip('/') != p['endpoint']:
        raise RuntimeError('Endpoint changed since freeze')
    if request_parameters_for_model(p['model'], 0.2) != p['request_parameters']:
        raise RuntimeError('Request parameters changed since freeze')
    os.environ['PIPEWEAVER_HTTP_TRANSPORT'] = p['transport']
    # Put the exact hashed curl executable first, without persisting the API key.
    os.environ['PATH'] = str(Path(p['curl_path']).parent) + os.pathsep + os.environ.get('PATH', '')
    rows = []
    for item in p['call_schedule']:
        audit(out)
        folder = out / 'cases' / item['case_id'] / item['arm'] / item['candidate_id']
        folder.mkdir(parents=True, exist_ok=True)
        genpath = folder / 'generation.json'
        if genpath.exists():
            row = load(genpath)
            if row.get('candidate_sha256') and digest(folder / 'candidate.v') != row['candidate_sha256']:
                raise RuntimeError('Previously generated candidate changed')
            rows.append(row)
            continue
        if (folder / 'attempt.json').exists():
            raise RuntimeError('Uncertain prior request; refusing to retry ' + str(folder))
        prompt = out / 'cases' / item['case_id'] / (item['arm'] + '.txt')
        exclusive(folder / 'attempt.json', dict(**item, started_at=datetime.now().astimezone().isoformat()))
        row = dict(**item, status='FAILED_GENERATION', candidate_sha256=None, prompt_sha256=digest(prompt))
        started = time.monotonic()
        try:
            gen = generate_from_prompt(prompt.read_text(encoding='utf-8'), model=p['model'],
                                       candidate_index=item['call_index'], timeout_s=p['llm_timeout_seconds'], audit_dir=folder / 'api_audit')
            (folder / 'candidate.v').write_text(gen.rtl, encoding='utf-8')
            row.update(status='GENERATED', candidate_sha256=digest(folder / 'candidate.v'),
                       response_model_id=gen.model, generation_parameters=gen.generation_parameters)
        except LLMGenerationError as exc:
            row['error'] = str(exc)
        row['generation_seconds'] = round(time.monotonic() - started, 3)
        exclusive(genpath, row)
        rows.append(row)
        print(f"Generation {item['call_index']}/24: {row['status']}", flush=True)
    manifest = out / 'candidate_manifest.json'
    if not manifest.exists():
        exclusive(manifest, dict(protocol_sha256=digest(out / 'protocol.json'), slots=rows))
        (out / 'candidate_manifest.sha256').write_text(digest(manifest) + '\n', encoding='ascii')
    if digest(manifest) != (out / 'candidate_manifest.sha256').read_text().strip() or load(manifest)['slots'] != rows:
        raise RuntimeError('Candidate manifest changed')
    cases = {c['id']: c for c in p['cases']}
    results = []
    for row in rows:
        audit(out)
        c = cases[row['case_id']]
        casefolder = out / 'cases' / c['id']
        folder = casefolder / row['arm'] / row['candidate_id']
        resultpath = folder / 'result.json'
        if resultpath.exists():
            results.append(load(resultpath))
            continue
        result = dict(**row, eligible=False, valid_improvement=False, gain_at_least_5pct=False)
        if row['candidate_sha256']:
            if digest(folder / 'candidate.v') != row['candidate_sha256']:
                raise RuntimeError('Frozen candidate changed')
            if (folder / 'evaluation').exists():
                raise RuntimeError('Unfinished prior EDA; refusing to overwrite evidence')
            metrics = evaluate(folder / 'candidate.v', casefolder / 'reference.v', c, folder / 'evaluation', p['timeout_per_tool_seconds'])
            result.update(metrics=metrics, **judge(metrics, load(casefolder / 'baseline/result.json')))
        exclusive(resultpath, result)
        results.append(result)
    summarize(out, p, results)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    action = ap.add_mutually_exclusive_group(required=True)
    action.add_argument('--prepare', action='store_true')
    action.add_argument('--audit', type=Path)
    action.add_argument('--execute', type=Path)
    ap.add_argument('--out', type=Path)
    ap.add_argument('--model', default=os.environ.get('PIPEWEAVER_LLM_MODEL'))
    ap.add_argument('--endpoint', default=os.environ.get('OPENAI_BASE_URL', 'https://api.openai.com/v1'))
    args = ap.parse_args()
    if args.prepare:
        if not args.out or not args.model:
            ap.error('--prepare requires --out and a precise model ID')
        out = prepare(args)
        p = audit(out)
        print(json.dumps(dict(prepared=str(out), scheduled=len(p['call_schedule']), model_calls=0)), flush=True)
    elif args.audit:
        audit(args.audit.resolve())
        print('Frozen protocol and preparation evidence: PASS')
    else:
        execute(args.execute.resolve())
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
