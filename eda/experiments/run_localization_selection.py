"""Bounded two-region selection: freeze requests, journal attempts, score existing PPA."""
import argparse
from collections import Counter
from datetime import datetime
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import statistics
import sys
import time
from urllib.parse import urlsplit
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.rtl_optimizer import _curl_json, LLMGenerationError, request_parameters_for_model

ACTIONS = ('rewrite_mux', 'rewrite_priority')
PROFILES = ('mux_delay050', 'mux_delay090')
ARMS = ('no_sta', 'sta')
SYSTEM = 'Select exactly one of the two allowed structural actions. Return only action_id and rationale as JSON. Never return executable code.'
DEPS = (Path(__file__).resolve(), ROOT / 'agents/rtl_optimizer.py')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def exclusive(path, obj):
    with path.open('x', encoding='utf-8') as stream:
        json.dump(obj, stream, indent=2, ensure_ascii=False, allow_nan=False)


def require(condition, reason):
    if not condition:
        raise RuntimeError(reason)


def parse_selection(content):
    if not isinstance(content, str):
        raise LLMGenerationError('Visible selection must be a string')
    text = content.strip()
    normalized = False
    fence = re.fullmatch(r'```json\s*\n(.*?)\n```', text, re.S | re.I)
    if fence:
        text, normalized = fence[1], True
    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise LLMGenerationError('Duplicate JSON key')
            result[key] = value
        return result
    try:
        obj = json.loads(text, object_pairs_hook=unique)
    except (ValueError, TypeError) as exc:
        raise LLMGenerationError('Expected exactly one JSON object') from exc
    if type(obj) is not dict or set(obj) != {'action_id', 'rationale'}:
        raise LLMGenerationError('Exactly action_id and rationale required; code fields forbidden')
    if type(obj['action_id']) is not str or obj['action_id'] not in ACTIONS:
        raise LLMGenerationError('Unsupported action ID')
    if type(obj['rationale']) is not str or not obj['rationale'].strip():
        raise LLMGenerationError('Non-empty rationale required')
    return dict(**obj, normalized_json_fence=normalized)


def verify_design(design):
    p = load(design / 'protocol.json')
    require(sha(design / 'protocol.json') == (design / 'protocol.sha256').read_text().strip(), 'Design protocol changed')
    for rel, expected in p['frozen_files'].items():
        require(sha(design / rel) == expected, 'Design artifact changed: ' + rel)
    counts = Counter((s['profile'], s['arm']) for s in p['schedule'])
    require(counts == Counter({(f, a): 3 for f in PROFILES for a in ARMS}), 'Invalid schedule budget')
    require([s['call_index'] for s in p['schedule']] == list(range(1, 13)), 'Invalid call identity')
    for profile in PROFILES:
        common = (design / 'prompts' / (profile + '_no_sta.txt')).read_text(encoding='utf-8')
        guided = (design / 'prompts' / (profile + '_sta.txt')).read_text(encoding='utf-8')
        require(guided.startswith(common) and len(guided) > len(common), 'Prompt mismatch')
    return p


def prepare(design, out, model, endpoint):
    p = verify_design(design)
    u = urlsplit(endpoint)
    require(u.scheme == 'https' and u.hostname and not (u.username or u.password or u.query or u.fragment), 'Unsafe endpoint')
    curl = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    require(curl is not None and bool(model), 'Exact model and curl required')
    out.mkdir(parents=True, exist_ok=False)
    shutil.copytree(design, out / 'design')
    (out / 'code_snapshot').mkdir()
    for f in DEPS:
        shutil.copyfile(f, out / 'code_snapshot' / f.name)
    protocol = dict(created_at=datetime.now().astimezone().isoformat(), kind='EXPOSED_BLOCK_LOCALIZATION_SELECTION',
        maximum_requests=12, model=model, endpoint=endpoint.rstrip('/'), transport='curl', timeout_seconds=180,
        request_parameters=request_parameters_for_model(model), system_message=SYSTEM, schedule=p['schedule'],
        frozen_files={str(f.relative_to(out)): sha(f) for f in out.rglob('*') if f.is_file()},
        dependencies={str(f.relative_to(ROOT)): sha(f) for f in DEPS}, curl_path=str(Path(curl).resolve()), curl_sha256=sha(Path(curl)),
        scoring='All attempt-retained medians per profile/arm; mean paired profile-normalized median-gain contrast; strict baseline fallback for invalid/fail/over-area/non-improvement. All twelve slots retained.',
        limits='Previously observed two related configurations, exposed actions, reused PPA. No fresh candidate EDA, blind holdout, independent families or statistical significance. No fixed rule winner is hidden from final reporting.',
        request_policy='Exactly scheduled attempts at most; never retry. Unknown prior attempt aborts until explicitly recorded as unknown, never resent.')
    exclusive(out / 'protocol.json', protocol)
    (out / 'protocol.sha256').write_text(sha(out / 'protocol.json') + '\n', encoding='ascii')
    return protocol


def validate(out):
    p = load(out / 'protocol.json')
    require(sha(out / 'protocol.json') == (out / 'protocol.sha256').read_text().strip(), 'Run protocol changed')
    for rel, expected in p['frozen_files'].items():
        require(sha(out / rel) == expected, 'Frozen file changed: ' + rel)
    for rel, expected in p['dependencies'].items():
        require(sha(ROOT / rel) == expected, 'Execution code changed: ' + rel)
    require(sha(Path(p['curl_path'])) == p['curl_sha256'], 'curl changed')
    verify_design(out / 'design')
    require(p['schedule'] == load(out / 'design/protocol.json')['schedule'], 'Schedule changed')
    require(p['maximum_requests'] == 12, 'Invalid request ceiling')
    return p


def request_once(prompt, p, audit):
    key = os.environ.get('OPENAI_API_KEY', '').strip()
    require(bool(key), 'API credential missing')
    audit.mkdir(exist_ok=False)
    payload = dict(model=p['model'], **p['request_parameters'], response_format={'type': 'json_object'},
                   messages=[dict(role='system', content=p['system_message']), dict(role='user', content=prompt)])
    exclusive(audit / 'request.json', dict(endpoint=p['endpoint'] + '/chat/completions', body=payload,
                                         credentials='Authorization header omitted', transport='curl'))
    req = urllib.request.Request(p['endpoint'] + '/chat/completions', data=json.dumps(payload).encode('utf-8'),
                                 headers={'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}, method='POST')
    try:
        body = _curl_json(req, p['timeout_seconds'], audit_dir=audit)
    except (OSError, TimeoutError, ValueError) as exc:
        raise LLMGenerationError('Transport failed: ' + type(exc).__name__) from None
    if not isinstance(body, dict):
        raise LLMGenerationError('Invalid provider envelope')
    visible = {k: body[k] for k in ('id', 'model', 'created', 'usage', 'system_fingerprint') if k in body}
    choices = body.get('choices')
    visible['choices'] = [dict(index=c.get('index'), finish_reason=c.get('finish_reason'),
        message={k: c.get('message', {}).get(k) for k in ('role', 'content')}) for c in choices if isinstance(c, dict)] if isinstance(choices, list) else []
    exclusive(audit / 'response.json', visible)
    try:
        content = body['choices'][0]['message']['content']
    except (KeyError, IndexError, TypeError):
        raise LLMGenerationError('No visible response content') from None
    return dict(**parse_selection(content), provider_metadata=visible)


def trial_dir(out, slot):
    return out / 'trials' / f"call_{slot['call_index']:02d}"


def collect(out, p, sender=request_once, validator=validate):
    rows = []
    for slot in p['schedule']:
        validator(out)
        folder = trial_dir(out, slot)
        folder.mkdir(parents=True, exist_ok=True)
        result = folder / 'generation.json'
        if result.exists():
            row = load(result)
            require(row['slot'] == slot, 'Resumed generation identity mismatch')
            rows.append(row)
            continue
        require(not (out / 'selection_manifest.json').exists(), 'Frozen manifest missing generation record')
        require(not (folder / 'attempt.json').exists(), 'Uncertain prior request; refusing to resend ' + str(slot['call_index']))
        prompt_file = out / 'design' / slot['prompt']
        prompt = prompt_file.read_text(encoding='utf-8')
        exclusive(folder / 'attempt.json', dict(slot=slot, protocol_sha256=sha(out / 'protocol.json'),
                                               prompt_sha256=sha(prompt_file), started_at=datetime.now().astimezone().isoformat()))
        print(f"Calling {slot['call_index']}/12 {slot['profile']} {slot['arm']}", flush=True)
        row = dict(slot=slot, status='FAILED_SELECTION', action_id=None, prompt_sha256=sha(prompt_file))
        started = time.monotonic()
        try:
            selected = sender(prompt, p, folder / 'api_audit')
            require(selected['action_id'] in ACTIONS, 'Sender returned unsupported action')
            row.update(status='SELECTED', selection=selected, action_id=selected['action_id'])
        except LLMGenerationError as exc:
            row['error'] = str(exc)
        row['elapsed_seconds'] = round(time.monotonic() - started, 6)
        exclusive(result, row)
        rows.append(row)
        print('Completed attempt: ' + row['status'], flush=True)
    manifest = out / 'selection_manifest.json'
    document = dict(protocol_sha256=sha(out / 'protocol.json'), rows=rows)
    if not manifest.exists():
        exclusive(manifest, document)
        (out / 'selection_manifest.sha256').write_text(sha(manifest) + '\n', encoding='ascii')
    require(load(manifest) == document and sha(manifest) == (out / 'selection_manifest.sha256').read_text().strip(), 'Selection manifest changed')
    return rows


def score_action(evidence, profile, action):
    base = evidence['timings'][profile]['baseline']
    base_delay = base['max_data_arrival_ns']
    retained, chosen, eligible = base_delay, 'baseline', False
    if action in ACTIONS:
        mapped = evidence['mapping'][action]
        m = evidence['timings'][profile][action]
        eligible = (mapped['status'] == 'PASS' and mapped['mapped_formal'] == 'PASS'
                    and m['electrical']['status'] == 'PASS' and m['mapped_area_um2'] <= evidence['area_cap_um2'] + 1e-9)
        if eligible and m['max_data_arrival_ns'] < base_delay:
            retained, chosen = m['max_data_arrival_ns'], action
    possible = [base_delay]
    for candidate in ACTIONS:
        m = evidence['timings'][profile][candidate]
        mapped = evidence['mapping'][candidate]
        if mapped['status'] == 'PASS' and mapped['mapped_formal'] == 'PASS' and m['electrical']['status'] == 'PASS' and m['mapped_area_um2'] <= evidence['area_cap_um2'] + 1e-9:
            possible.append(m['max_data_arrival_ns'])
    best = min(possible)
    return dict(retained_delay_ns=retained, selected=chosen, eligible=eligible,
                improved=retained < base_delay, gain_percent=100 * (1 - retained / base_delay),
                regret_ns=round(retained - best, 9), optimal_retained=abs(retained-best) < 1e-9)


def summarize(rows, evidence, decisions):
    require(len(rows) == 12 and {r['slot']['call_index'] for r in rows} == set(range(1, 13)), 'Expected twelve distinct attempted slots')
    scored = []
    for row in rows:
        require(row['status'] != 'SELECTED' or row.get('action_id') in ACTIONS, 'Invalid selected action')
        action = row.get('action_id') if row['status'] == 'SELECTED' else None
        scored.append(dict(**row, score=score_action(evidence, row['slot']['profile'], action)))
    groups, contrasts = {}, []
    for profile in PROFILES:
        groups[profile] = {}
        for arm in ARMS:
            rr = [r for r in scored if r['slot']['profile'] == profile and r['slot']['arm'] == arm]
            require(len(rr) == 3, 'Expected three slots in each cell')
            valid = [r for r in rr if r['status'] == 'SELECTED']
            median = statistics.median(r['score']['retained_delay_ns'] for r in rr)
            groups[profile][arm] = dict(attempted=3, valid_selections=len(valid),
                improved=sum(r['score']['improved'] for r in rr), median_retained_delay_ns=median,
                median_gain_percent=100*(1-median/evidence['timings'][profile]['baseline']['max_data_arrival_ns']),
                optimal_hits=sum(r['score']['optimal_retained'] for r in rr),
                mean_regret_ns=statistics.mean(r['score']['regret_ns'] for r in rr),
                successful_selection_median_ns=statistics.median(r['score']['retained_delay_ns'] for r in valid) if valid else None)
        contrasts.append(groups[profile]['sta']['median_gain_percent'] - groups[profile]['no_sta']['median_gain_percent'])
    controls = [dict(**r, score=score_action(evidence, r['profile'], r['action'])) for r in decisions['decisions'] if r['profile'] in PROFILES]
    require(len(controls) == 8, 'Four deterministic controls required per profile')
    tokens = []
    for row in rows:
        usage = row.get('selection', {}).get('provider_metadata', {}).get('usage', {})
        value = usage.get('total_tokens') if isinstance(usage, dict) else None
        if type(value) is int and value >= 0:
            tokens.append(value)
    return dict(groups=groups, rows=scored, deterministic_controls=controls,
                primary_mean_median_gain_difference_percentage_points=statistics.mean(contrasts),
                reported_tokens=sum(tokens), usage_records=len(tokens),
                limits='Two correlated exposed development configurations; reused known PPA, no fresh EDA. Network/format failures remain in primary metrics. No generality or significance claim.')


def execute(out):
    p = validate(out)
    require(bool(os.environ.get('OPENAI_API_KEY', '').strip()), 'API credential missing')
    require(os.environ.get('OPENAI_BASE_URL', '').rstrip('/') == p['endpoint'], 'Endpoint changed')
    auth = load(out / 'AUTHORIZATION.json')
    require(auth['maximum_requests'] == 12 and auth['protocol_sha256'] == sha(out / 'protocol.json'), 'Authorization mismatch')
    os.environ['PATH'] = str(Path(p['curl_path']).parent) + os.pathsep + os.environ.get('PATH', '')
    rows = collect(out, p)
    result = summarize(rows, load(out / 'design/analysis_only/prior_mapping_and_sta.json'),
                       load(out / 'design/analysis_only/deterministic_controls.json'))
    for row in rows:
        if row['status'] == 'SELECTED':
            response = load(trial_dir(out, row['slot']) / 'api_audit/response.json')
            check = parse_selection(response['choices'][0]['message']['content'])
            require(check['action_id'] == row['action_id'], 'Stored action does not match response')
    (out / 'summary.json').write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding='utf-8')
    lines = ['# 定位动作选择：真实请求结果', '', '| 配置 | 组别 | 有效选择/尝试 | 合格改善 | 保留后中位延迟ns | 最优命中 |', '|---|---|---:|---:|---:|---:|']
    for profile, arms in result['groups'].items():
        for arm, g in arms.items():
            lines.append(f"| {profile} | {arm} | {g['valid_selections']}/3 | {g['improved']}/3 | {g['median_retained_delay_ns']} | {g['optimal_hits']}/3 |")
    lines += ['', f"主指标（STA减无STA的归一化中位收益）：{result['primary_mean_median_gain_difference_percentage_points']:.6f}个百分点。",
              '', result['limits'], '', '完整选择、失败、固定策略、反例和来源见summary.json及design/analysis_only。固定端点规则的已知结果必须一并报告；不以模型最好一次替代主指标。']
    (out / 'INTERPRETATION.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')
    print(json.dumps(result['groups'], ensure_ascii=False), flush=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument('--prepare', type=Path, metavar='DESIGN')
    mode.add_argument('--execute', type=Path)
    mode.add_argument('--validate', type=Path)
    ap.add_argument('--out', type=Path)
    ap.add_argument('--model', default=os.environ.get('PIPEWEAVER_LLM_MODEL'))
    ap.add_argument('--endpoint', default=os.environ.get('OPENAI_BASE_URL', ''))
    args = ap.parse_args()
    if args.prepare:
        require(args.out is not None, '--out required')
        prepare(args.prepare.resolve(), args.out.resolve(), args.model, args.endpoint)
        validate(args.out.resolve())
        print('Execution protocol prepared; zero model requests')
    elif args.validate:
        validate(args.validate.resolve())
        print('Frozen execution artifacts: PASS')
    else:
        execute(args.execute.resolve())


if __name__ == '__main__':
    main()
