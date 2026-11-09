"""Audit actual selection attempts against saved requests/responses and known PPA."""
import argparse
import json
from pathlib import Path
import statistics
import run_localization_selection as run


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('study', type=Path)
    args = ap.parse_args()
    out = args.study.resolve()
    p = run.validate(out)
    checks = []
    def check(label, value):
        checks.append(dict(label=label, passed=bool(value)))
    auth = run.load(out / 'AUTHORIZATION.json')
    check('Explicit destination consent', auth['status'] == 'EXPLICITLY_APPROVED' and auth['endpoint'] == p['endpoint'] and auth['maximum_requests'] == 12)
    manifest = run.load(out / 'selection_manifest.json')
    check('Manifest hash', run.sha(out / 'selection_manifest.json') == (out / 'selection_manifest.sha256').read_text().strip())
    check('Manifest protocol', manifest['protocol_sha256'] == run.sha(out / 'protocol.json'))
    check('All attempts, identities and order', [r['slot'] for r in manifest['rows']] == p['schedule'])
    attempts = list((out / 'trials').glob('*/attempt.json'))
    check('Exactly 12 attempt markers', len(attempts) == 12)
    response_count = 0
    response_usage_tokens = 0
    usage_record_count = 0
    response_models = set()
    valid = 0
    for row, slot in zip(manifest['rows'], p['schedule']):
        label = f"Call {slot['call_index']}"
        folder = run.trial_dir(out, slot)
        prompt = out / 'design' / slot['prompt']
        attempt = run.load(folder / 'attempt.json')
        generation = run.load(folder / 'generation.json')
        check(label + ' identity', attempt['slot'] == slot and generation == row)
        check(label + ' prompt hash', attempt['prompt_sha256'] == row['prompt_sha256'] == run.sha(prompt))
        request = run.load(folder / 'api_audit/request.json')
        expected = dict(model=p['model'], **p['request_parameters'], response_format={'type': 'json_object'},
                        messages=[dict(role='system', content=p['system_message']), dict(role='user', content=prompt.read_text(encoding='utf-8'))])
        check(label + ' actual exact request', request['body'] == expected and request['endpoint'] == p['endpoint']+'/chat/completions')
        check(label + ' no credential in request audit', request['credentials'] == 'Authorization header omitted' and 'headers' not in request)
        transport = run.load(folder / 'api_audit/transport.json')
        check(label + ' no retries', transport['retry_count'] == 0)
        response = folder / 'api_audit/response.json'
        if response.exists():
            response_count += 1
            saved = run.load(response)
            response_models.add(str(saved.get('model')))
            usage = saved.get('usage', {})
            value = usage.get('total_tokens') if isinstance(usage, dict) else None
            if type(value) is int and value >= 0:
                response_usage_tokens += value
                usage_record_count += 1
            try:
                selection = run.parse_selection(saved['choices'][0]['message']['content'])
            except (run.LLMGenerationError, KeyError, IndexError, TypeError):
                check(label + ' invalid response is retained', row['status'] == 'FAILED_SELECTION')
            else:
                valid += 1
                check(label + ' selection from actual response', row['status'] == 'SELECTED' and row['action_id'] == selection['action_id'] and row['selection']['rationale'] == selection['rationale'])
        else:
            check(label + ' absent response is a failure', row['status'] == 'FAILED_SELECTION')
    summary = run.load(out / 'summary.json')
    evidence = run.load(out / 'design/analysis_only/prior_mapping_and_sta.json')
    decisions = run.load(out / 'design/analysis_only/deterministic_controls.json')
    recomputed = run.summarize(manifest['rows'], evidence, decisions)
    check('Complete summary reproduces from stored selections', recomputed == summary)
    # Independent direct lookup checks for all trial retained outcomes.
    for row in summary['rows']:
        profile = row['slot']['profile']
        base = evidence['timings'][profile]['baseline']['max_data_arrival_ns']
        expected = base
        if row['status'] == 'SELECTED':
            action = row['action_id']
            m = evidence['timings'][profile][action]
            if m['electrical']['status'] == 'PASS' and evidence['mapping'][action]['mapped_formal'] == 'PASS' and m['mapped_area_um2'] <= evidence['area_cap_um2']:
                expected = min(base, m['max_data_arrival_ns'])
        check(f"Call {row['slot']['call_index']} independent retained delay", expected == row['score']['retained_delay_ns'])
    for profile in run.PROFILES:
        for arm in run.ARMS:
            values = [r['score']['retained_delay_ns'] for r in summary['rows'] if r['slot']['profile'] == profile and r['slot']['arm'] == arm]
            check(profile + '/' + arm + ' all-slot median', sorted(values)[1] == summary['groups'][profile][arm]['median_retained_delay_ns'])
    record = dict(passed=all(c['passed'] for c in checks), check_count=len(checks), checks=checks,
                  actual_attempt_markers=len(attempts), saved_provider_responses=response_count, valid_selections=valid,
                  all_response_reported_tokens=response_usage_tokens, all_response_usage_records=usage_record_count,
                  reported_response_models=sorted(response_models),
                  new_eda_runs=0, audit_runner_sha256=run.sha(Path(__file__)),
                  scope='Evidence consistency; audit items are not independent model samples or independent proof-engine results')
    (out / 'AUDIT.json').write_text(json.dumps(record, indent=2, ensure_ascii=False), encoding='utf-8')
    lines = [(out / 'INTERPRETATION.md').read_text(encoding='utf-8'),
             '\n## 全部真实尝试\n', '| 请求 | 配置 | 组别 | 状态 | 动作 | 保留后延迟ns |', '|---|---|---|---|---|---:|']
    for row in summary['rows']:
        s = row['slot']
        lines.append(f"| {s['call_index']} | {s['profile']} | {s['arm']} | {row['status']} | {row.get('action_id') or '—'} | {row['score']['retained_delay_ns']} |")
    lines += ['\n## 预定确定性参照\n', '| 配置 | 策略 | 动作 | 保留后延迟ns | 与单动作最优差距ns |', '|---|---|---|---:|---:|']
    for row in summary['deterministic_controls']:
        lines.append(f"| {row['profile']} | {row['policy']} | {row['action']} | {row['score']['retained_delay_ns']} | {row['score']['regret_ns']} |")
    lines += ['', f"12个请求槽位；保存{response_count}份供应商可见响应、{valid}份严格合法动作选择。全部{usage_record_count}份用量记录报告token合计{response_usage_tokens}，不是独立核实账单。",
              '', f"原始summary.json的reported_tokens仅汇总{summary['usage_records']}份严格接受的选择（{summary['reported_tokens']}tokens）；不能把它当全批次用量。全部响应口径以本报告和AUDIT.json为准。",
              '', f"证据一致性审计：{record['passed']}，{len(checks)}项核对；不是{len(checks)}次独立实验。",
              '', '本轮没有生成新的RTL或重新跑候选EDA：模型只选动作，随后按此前已证明、测量且冻结的动作池评分。原始功能、门级证明和STA来源在design/analysis_only及其父实验，不把复用测量说成新证据。',
              '', '通信/格式失败保留在主指标；成功返回条件统计见summary.json，不替代全槽位结果。两个场景是根据既有PPA选择的开发条件，不是盲测或两个独立家族。',
              '', '若模型与STA端点规则持平，不能宣称模型带来额外收益；若无STA同样选对，则本轮没有建立STA增益。固定分块映射结论不替代此前失败的扁平映射假设。']
    for row in summary['rows']:
        if row.get('error'):
            lines += ['', f"请求{row['slot']['call_index']}失败：{row['error']}"]
    # Separate audited report is idempotent; preserve the executor's initial interpretation.
    (out / 'FINAL_INTERPRETATION.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')
    print(json.dumps(dict(passed=record['passed'], checks=len(checks), responses=response_count, valid=valid)))
    return 0 if record['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
