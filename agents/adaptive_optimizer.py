"""Budgeted RTL optimization with direct, STA and verification-feedback routes."""
import argparse
from datetime import datetime
import json
import math
import os
from pathlib import Path
import re
import shutil
import time

from agents.portfolio_loop import choose, decide, load, qualified, save, sha
from agents.routing_policy import context, recommend
from agents.verified_optimizer import LIB, checked_asset, dependencies, evaluate, registry

ROOT = Path(__file__).resolve().parents[1]


def design_inputs(args):
    if args.design:
        if args.top or args.param:
            raise ValueError('Registered designs fix top and parameters')
        design = next((item for item in registry()['designs'] if item['id'] == args.design), None)
        if design is None:
            raise ValueError('Unknown registered design')
        return design, checked_asset(design['reference'])
    if not args.top or not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_$]*', args.top):
        raise ValueError('Custom RTL requires a valid --top')
    parameters = {}
    for item in args.param:
        name, value = item.split('=', 1)
        if (not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_$]*', name) or name in parameters
                or not re.fullmatch(r'0[xX][0-9a-fA-F]+|[0-9]+', value)):
            raise ValueError('Invalid or duplicate parameter')
        parameters[name] = int(value, 16 if value.lower().startswith('0x') else 10)
    source = args.rtl.resolve()
    if not source.is_file():
        raise ValueError('RTL file missing')
    design = dict(id=args.top, top=args.top, parameters=parameters, backend='native_comb',
                  scope='User-supplied native combinational design under the existing binary all-input contract',
                  reference=dict(sha256=sha(source)))
    return design, source


def next_route(route, metrics):
    if route == 'direct' and qualified(metrics):
        return 'sta'
    return 'feedback'


def timing_text(folder):
    for relative in ('sta.log', 'eda/sta.log'):
        path = folder / relative
        if path.is_file():
            text = path.read_text(encoding='utf-8', errors='replace')
            parts = text.split('Startpoint:')[1:4]
            return ''.join('Startpoint:' + part for part in parts).split('PW_ELECTRICAL_BEGIN')[0][:16000]
    return 'No completed STA path report available.'


def prompt_for(route, reference, best, design, baseline, area_limit, previous, out):
    prompt = (
        f'Optimize combinational module {design["top"]}, parameter overrides '
        f'{json.dumps(design["parameters"], sort_keys=True)}. Minimize mapped maximum data arrival. '
        'Preserve ports, widths, signedness, truncation, priorities, default branches and parameter declarations. '
        'Every input bit is arbitrary binary data; every output must match for every input. '
        'No state, clocks, latches, added latency, memories, assumptions, assertions, undefined outputs, '
        'external dependencies or file access. Include all helper modules. '
        'Evaluation uses the existing SKY130HD TT25C1.80V buffer_size flow with cleanup, '
        '0ns external IO delays, 0.10ns input transition and 0.010pF output load. '
        'Both source and mapped equivalence and max-slew/max-capacitance checks must pass. '
        f'Original-relative mapped area cap is {baseline["mapped_area_um2"] * area_limit:.6f}um2. '
        'Return exactly one JSON object with six string fields candidate_rtl, bottleneck, rewrite, '
        'expected_timing_gain, area_or_other_cost, functional_boundaries.\n'
        'Original reference RTL:\n' + reference.read_text(encoding='utf-8-sig')
    )
    if best['id'] != 'baseline':
        prompt += '\nCurrent verified best RTL:\n' + (out / best['source']).read_text(encoding='utf-8-sig')
    if route in ('sta', 'feedback'):
        prompt += '\nMeasured best metrics:\n' + json.dumps(best['metrics'], ensure_ascii=False)
        prompt += '\nActual best STA paths, mapped names are not exact source attribution:\n'
        prompt += timing_text(out / 'evaluations' / best['id'])
    if route == 'feedback' and previous:
        prompt += '\nPrevious candidate RTL:\n' + (out / previous['source']).read_text(encoding='utf-8-sig')
        prompt += '\nActual previous validation and measurement:\n' + json.dumps(previous['metrics'], ensure_ascii=False)
        folder = out / 'evaluations' / previous['id']
        for name in ('formal.log', 'mapped_formal.log', 'candidate_schema.log', 'frontend.log'):
            for path in (folder / name, folder / 'eda' / name):
                if path.is_file() and not qualified(previous['metrics']):
                    prompt += '\nValidation log ' + name + ':\n' + path.read_text(encoding='utf-8', errors='replace')[-4000:]
    return prompt


def generate(prompt, args, folder):
    from agents.sse_transport import curl_completion_stream
    from agents.rtl_optimizer import request_parameters_for_model
    from eda.experiments.run_stream_feedback import parse_candidate
    base = os.environ.get('OPENAI_BASE_URL', 'https://api.openai.com/v1').rstrip('/')
    body = dict(model=args.model, **request_parameters_for_model(args.model),
                stream=True, stream_options={'include_usage': True},
                response_format={'type': 'json_object'}, max_completion_tokens=args.max_completion_tokens,
                messages=[dict(role='system', content='Optimize synthesizable combinational RTL under the exact contract.'),
                          dict(role='user', content=prompt)])
    response = curl_completion_stream(endpoint=base + '/chat/completions', body=body,
        api_key=os.environ['OPENAI_API_KEY'], audit_dir=folder / 'api_audit', timeout_s=args.llm_timeout)
    save(folder / 'response.json', response)
    parsed = parse_candidate(response['choices'][0]['message']['content'])
    return parsed['rtl'], response.get('usage'), response.get('model')


def run(args, design, source):
    if not math.isfinite(args.area_limit) or args.area_limit < 1:
        raise ValueError('Area ratio must be finite and at least 1')
    if not math.isfinite(args.target_gain) or not 0 < args.target_gain < 1:
        raise ValueError('Target gain must be between 0 and 1')
    if args.use_llm and (not args.model or not os.environ.get('OPENAI_API_KEY', '').strip()):
        raise ValueError('Live generation requires a model and configured API key')
    if args.use_llm and (args.max_requests < 1 or not 1 <= args.max_completion_tokens <= 16000
                         or not 1 <= args.llm_timeout <= 600):
        raise ValueError('Explicit positive call budget, up to 16000 completion tokens and 600 seconds required')
    manual = [Path(name).resolve() for name in args.candidate_rtl]
    if any(not path.is_file() for path in manual):
        raise ValueError('Replay candidate missing')
    if not manual and not args.use_llm:
        raise ValueError('Supply replay candidates or explicitly enable live generation')
    out = (args.out or ROOT / 'output' / ('adaptive_' + datetime.now().strftime('%Y%m%d_%H%M%S_%f'))).resolve()
    out.mkdir(parents=True, exist_ok=False)
    (out / 'inputs').mkdir()
    (out / 'evaluations').mkdir()
    reference = out / 'inputs/original.v'
    shutil.copyfile(source, reference)
    policy_path = out / 'inputs/policy.json'
    if args.policy and args.policy.is_file():
        shutil.copyfile(args.policy, policy_path)
        policy = load(policy_path)
    else:
        policy = dict(entries={})
    for index, path in enumerate(manual, 1):
        shutil.copyfile(path, out / 'inputs' / f'candidate_{index:03d}.v')
    before = dependencies(design)
    library_sha256 = sha(LIB)
    budget = args.max_requests if args.use_llm else len(manual)
    save(out / 'protocol.json', dict(design=design, reference_sha256=sha(reference), dependencies=before,
        mode='live' if args.use_llm else 'replay', maximum_requests=budget if args.use_llm else 0,
        automatic_retries=0, maximum_concurrency=1, max_completion_tokens=args.max_completion_tokens,
        area_ratio=args.area_limit, target_gain=args.target_gain,
        policy_sha256=sha(policy_path) if policy_path.is_file() else None,
        candidate_inputs=[dict(path=f'inputs/candidate_{i:03d}.v',
            sha256=sha(out / 'inputs' / f'candidate_{i:03d}.v')) for i in range(1, len(manual) + 1)],
        liberty_sha256=library_sha256,
        source_sha256=sha(Path(__file__)), model=args.model))
    start = time.monotonic()
    baseline = evaluate(reference, reference, design, out / 'evaluations/baseline')
    if not qualified(baseline):
        save(out / 'SUMMARY.json', dict(status='BASELINE_NOT_QUALIFIED', baseline=baseline, model_requests=0))
        return 2
    if dependencies(design) != before or sha(LIB) != library_sha256:
        raise RuntimeError('Evaluator dependencies changed during baseline evaluation')
    if baseline['max_data_arrival_ns'] <= 0:
        shutil.copyfile(reference, out / 'best.v')
        save(out / 'SUMMARY.json', dict(status='NO_POSITIVE_TIMING_BASELINE', baseline=baseline,
             model_requests=0, baseline_retained=True, selected='baseline', best_sha256=sha(reference)))
        return 0
    decision = recommend(policy, context(reference, design, args.model), baseline)
    save(out / 'ROUTING.json', decision)
    route = args.route if args.route != 'auto' else decision['route']
    rows = [dict(id='baseline', source='inputs/original.v', metrics=baseline, accepted=True, reasons=[])]
    cache = {sha(reference): ('baseline', baseline)}
    requests = 0
    transport_failures = 0
    stopped = 'budget_exhausted'
    previous = None
    attempts = []
    shutil.copyfile(reference, out / 'best.v')
    for index in range(1, budget + 1):
        best = choose(rows)
        candidate_id = f'candidate_{index:03d}'
        folder = out / candidate_id
        folder.mkdir()
        candidate = out / 'inputs' / (candidate_id + '.v')
        save(out / 'PROGRESS.json', dict(stage='before_candidate', index=index, route=route,
             selected=best['id'], model_requests=requests, automatic_resume=False))
        usage = None
        reported_model = None
        generation_started = time.monotonic()
        if args.use_llm:
            prompt = prompt_for(route, reference, best, design, baseline, args.area_limit, previous, out)
            (folder / 'prompt.txt').write_text(prompt, encoding='utf-8')
            requests += 1
            save(out / 'PROGRESS.json', dict(stage='generation_attempt', index=index, route=route,
                 selected=best['id'], model_requests=requests, automatic_resume=False))
            try:
                rtl, usage, reported_model = generate(prompt, args, folder)
                candidate.write_text(rtl, encoding='utf-8')
                transport_failures = 0
            except Exception as error:
                from agents.sse_transport import StreamError
                failure = 'transport' if isinstance(error, StreamError) else 'format_or_generation'
                transport_failures = transport_failures + 1 if failure == 'transport' else 0
                failed_response = load(folder / 'response.json') if (folder / 'response.json').is_file() else {}
                failed = dict(status='GENERATION_FAILED', route=route,
                     error_type=type(error).__name__, failure_class=failure, automatic_retry=False,
                     usage=failed_response.get('usage'),
                     generation_seconds=time.monotonic() - generation_started)
                attempts.append(failed)
                save(folder / 'RESULT.json', failed)
                if transport_failures >= 3:
                    stopped = 'consecutive_transport_failures'
                    break
                route = 'sta'
                continue
        digest = sha(candidate)
        evaluation_start = time.monotonic()
        if digest in cache:
            shared, metrics = cache[digest]
        else:
            shared = None
            metrics = evaluate(candidate, reference, design, out / 'evaluations' / candidate_id)
            cache[digest] = (candidate_id, metrics)
        row = dict(id=candidate_id, source=candidate.relative_to(out).as_posix(), route=route,
                   metrics=metrics, shared_evaluation=shared, usage=usage, reported_model=reported_model,
                   evaluation_seconds=time.monotonic() - evaluation_start,
                   generation_seconds=evaluation_start - generation_started if args.use_llm else 0,
                   **decide(metrics, baseline, args.area_limit))
        rows.append(row)
        attempts.append(row)
        previous = row
        save(folder / 'RESULT.json', row)
        best = choose(rows)
        if dependencies(design) != before or sha(LIB) != library_sha256:
            raise RuntimeError('Evaluator dependencies changed; export stopped')
        shutil.copyfile(out / best['source'], out / 'best.v')
        gain = 1 - best['metrics']['max_data_arrival_ns'] / baseline['max_data_arrival_ns']
        save(out / 'PROGRESS.json', dict(stage='candidate_evaluated', index=index, route=route,
             selected=best['id'], model_requests=requests, retained_gain=gain))
        print(f'{candidate_id} route={route} accepted={row["accepted"]} retained_gain={gain:.2%}', flush=True)
        if gain >= args.target_gain:
            stopped = 'target_reached'
            break
        route = next_route(route, metrics)
    if dependencies(design) != before or sha(LIB) != library_sha256:
        raise RuntimeError('Evaluator dependencies changed; final export stopped')
    best = choose(rows)
    known_usage = [(row.get('usage') or {}).get('total_tokens') for row in attempts
                   if type((row.get('usage') or {}).get('total_tokens')) is int]
    summary = dict(status='COMPLETE', mode='live' if args.use_llm else 'replay',
        design=design['id'], selected=best['id'], best_sha256=sha(out / 'best.v'),
        baseline=baseline, best_metrics=best['metrics'], candidates=rows, stopped=stopped,
        model_requests=requests, evaluated_candidates=len(rows) - 1, unique_evaluations=len(cache),
        elapsed_seconds=time.monotonic() - start, baseline_retained=best['id'] == 'baseline',
        attempts=attempts,
        reported_tokens=sum(known_usage),
        usage_unknown=len(attempts) - len(known_usage) if args.use_llm else 0,
        efficiency_scope='Actual current-run counts; comparative routing efficiency requires prospective evaluation')
    save(out / 'SUMMARY.json', summary)
    lines = ['# 自适应RTL优化运行报告', '',
             f'模式 {summary["mode"]}，选择 {best["id"]}，停止原因 {stopped}。',
             f'实际模型调用 {requests} 次，唯一EDA评价 {len(cache)} 次。',
             f'到达时间 {baseline["max_data_arrival_ns"]} → {best["metrics"]["max_data_arrival_ns"]} ns。', '',
             '| 候选 | 路径 | 合格改善 | 延迟ns | 拒绝原因 |', '|---|---|---|---:|---|']
    for row in rows[1:]:
        lines.append(f'| {row["id"]} | {row["route"]} | {row["accepted"]} | {row["metrics"].get("max_data_arrival_ns", "—")} | {", ".join(row["reasons"])} |')
    lines.extend(['', 'best.v保存本次已验证选择。所有候选相对同一原始功能和面积预算评价。',
                  'replay使用用户提供的代码检查调度与验证。策略标签表示调度状态，候选实际生成来源按原始记录另行追溯。'])
    (out / 'REPORT.md').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(str(out / 'REPORT.md'), flush=True)
    return 0


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=('plan', 'run'))
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument('--design')
    source.add_argument('--rtl', type=Path)
    parser.add_argument('--top')
    parser.add_argument('--param', action='append', default=[])
    parser.add_argument('--policy', type=Path, help='Optional development policy; default starts direct')
    parser.add_argument('--model', default=os.environ.get('PIPEWEAVER_LLM_MODEL', 'gpt-6.1-sol'))
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--candidate-rtl', action='append', default=[])
    mode.add_argument('--use-llm', action='store_true')
    parser.add_argument('--route', choices=('auto', 'direct', 'sta'), default='auto')
    parser.add_argument('--max-requests', type=int, default=0)
    parser.add_argument('--max-completion-tokens', type=int, default=16000)
    parser.add_argument('--llm-timeout', type=int, default=600)
    parser.add_argument('--target-gain', type=float, default=0.05)
    parser.add_argument('--area-limit', type=float, default=1.1)
    parser.add_argument('--out', type=Path)
    args = parser.parse_args(argv)
    design, reference = design_inputs(args)
    if args.command == 'plan':
        policy = load(args.policy) if args.policy and args.policy.is_file() else dict(entries={})
        print(json.dumps(dict(design=design['id'], model_calls=0,
            decision=recommend(policy, context(reference, design, args.model)),
            workflow='Initial route; valid but insufficient gain -> STA; validation failure -> feedback; target or budget -> stop',
            runtime_baseline_check_required=True), ensure_ascii=False, indent=2))
        return 0
    return run(args, design, reference)


if __name__ == '__main__':
    raise SystemExit(main())
