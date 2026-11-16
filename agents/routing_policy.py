"""Retrospective, exact-context routing statistics from frozen RTL studies."""
import argparse
import hashlib
import json
import statistics
from pathlib import Path

from agents.portfolio_loop import decide, load, save, sha

ROOT = Path(__file__).resolve().parents[1]
STUDIES = (
    'expanded_feedback_80_20261107',
    'crc_feedback_20_20261107_ready',
    'multicircuit_feedback_144_20261109',
)


def context(reference, design, model):
    return dict(reference_sha256=sha(reference), top=design['top'],
                parameters=design['parameters'], backend=design['backend'], model=model)


def context_key(value):
    encoded = json.dumps(value, sort_keys=True, separators=(',', ':')).encode('utf-8')
    return hashlib.sha256(encoded).hexdigest()


def baseline_signature(metrics):
    return {key: metrics.get(key) for key in
            ('max_data_arrival_ns', 'mapped_area_um2', 'tns_ns', 'sdc_sha256')}


def read_study(folder):
    protocol = load(folder / 'protocol.json')
    if sha(folder / 'protocol.json') != (folder / 'protocol.sha256').read_text().strip():
        raise ValueError('Frozen protocol checksum mismatch: ' + str(folder))
    result = load(folder / 'RESULT.json')
    if not result['complete']:
        raise ValueError('Incomplete study: ' + str(folder))
    cases = protocol.get('cases')
    if cases is None:
        cases = [dict(id='crc32_d8', top='crc32_d8', params={}, baseline=protocol['baseline'])]
    cases = {case['id']: case for case in cases}
    seen = set()
    records = []
    for row in result['trials']:
        if row['index'] in seen:
            raise ValueError('Duplicate call index')
        seen.add(row['index'])
        if row.get('round', 1) != 1:
            continue
        case_id = row.get('case', 'crc32_d8')
        case = cases[case_id]
        source = folder / 'inputs' / (case_id + '.v')
        if not source.exists() and case_id == 'crc32_d8':
            source = folder / 'inputs/original.v'
        design = dict(top=case['top'], parameters=case['params'],
                      backend='crc_slang_fixed' if case_id == 'crc32_d8' else 'native_comb')
        accepted = decide(row.get('metrics', {}), case['baseline'], 1.1)['accepted']
        if accepted != row['improved']:
            raise ValueError('Saved qualification disagrees with recomputation')
        baseline_delay = case['baseline']['max_data_arrival_ns']
        delay = row['metrics']['max_data_arrival_ns'] if accepted else baseline_delay
        records.append(dict(study=folder.name, case=case_id, index=row['index'],
            arm=row['arm'], improved=accepted, gain=1 - delay / baseline_delay,
            retained_delay_ns=delay, usage=row.get('usage'),
            context=context(source, design, protocol['model']),
            baseline=baseline_signature(case['baseline'])))
    return records


def summarize(rows):
    usages = [row['usage'] for row in rows
              if isinstance(row['usage'], dict) and type(row['usage'].get('total_tokens')) is int]
    return dict(attempted=len(rows), improvements=sum(row['improved'] for row in rows),
                mean_gain=statistics.mean(row['gain'] for row in rows),
                median_retained_delay_ns=statistics.median(row['retained_delay_ns'] for row in rows),
                reported_tokens=sum(usage['total_tokens'] for usage in usages),
                usage_known=len(usages), usage_unknown=len(rows) - len(usages))


def fit(rows, minimum_samples=10, gain_margin=0.01):
    groups = {}
    for row in rows:
        key = context_key(row['context'])
        group = groups.setdefault(key, dict(context=row['context'], baseline=row['baseline'], rows=[]))
        if group['baseline'] != row['baseline']:
            raise ValueError('Same source context has incompatible baseline conditions')
        group['rows'].append(row)
    entries = {}
    for key, group in groups.items():
        arms = {arm: summarize([row for row in group['rows'] if row['arm'] == arm])
                for arm in ('no_sta', 'sta') if any(row['arm'] == arm for row in group['rows'])}
        supported = all(arm in arms and arms[arm]['attempted'] >= minimum_samples
                        for arm in ('no_sta', 'sta'))
        route = 'direct'
        if supported and arms['sta']['mean_gain'] > arms['no_sta']['mean_gain'] + gain_margin:
            route = 'sta'
        entries[key] = dict(context=group['context'], baseline=group['baseline'], arms=arms,
                            route=route, sufficient_samples=supported)
    return dict(schema_version=1, minimum_samples=minimum_samples, gain_margin=gain_margin,
                objective='Mean normalized strict timing gain per attempted first-round call; failures retain baseline',
                scope='Development-only exact source/parameter/backend/model/context preference; prospective efficiency untested',
                entries=entries)


def recommend(policy, value, baseline=None):
    entry = policy.get('entries', {}).get(context_key(value))
    if entry is None:
        return dict(route='direct', reason='unseen_context', evidence=None)
    if baseline is not None and baseline_signature(baseline) != entry['baseline']:
        return dict(route='direct', reason='baseline_conditions_changed', evidence=None)
    if not entry['sufficient_samples']:
        return dict(route='direct', reason='insufficient_samples', evidence=entry)
    return dict(route=entry['route'], reason='historical_mean_gain_preference', evidence=entry)


def analyze(out):
    out.mkdir(parents=True, exist_ok=False)
    all_rows = []
    evidence = []
    for name in STUDIES:
        folder = ROOT / 'eda/experiments' / name
        all_rows.extend(read_study(folder))
        evidence.extend(dict(path=str(path.relative_to(ROOT)), sha256=sha(path))
                        for path in (folder / 'protocol.json', folder / 'RESULT.json'))
    training = [row for row in all_rows if row['study'] != STUDIES[-1]]
    testing = [row for row in all_rows if row['study'] == STUDIES[-1]]
    frozen = fit(training)
    strategies = {}
    for strategy in ('direct', 'sta', 'historical_router'):
        selected = []
        decisions = []
        for case_id in sorted({row['case'] for row in testing}):
            rows = [row for row in testing if row['case'] == case_id]
            decision = recommend(frozen, rows[0]['context'], rows[0]['baseline'])
            route = decision['route'] if strategy == 'historical_router' else strategy
            selected.extend(row for row in rows if row['arm'] == ('no_sta' if route == 'direct' else 'sta'))
            reason = decision['reason'] if strategy == 'historical_router' else 'fixed_strategy'
            decisions.append(dict(case=case_id, route=route, reason=reason))
        stats = summarize(selected)
        # Delays from different circuits are deliberately not pooled as a median.
        stats.pop('median_retained_delay_ns')
        strategies[strategy] = dict(**stats, decisions=decisions)
    policy = fit(all_rows)
    policy['source_evidence'] = evidence
    save(out / 'POLICY.json', policy)
    report = dict(primary_attempts=len(all_rows), excluded_dependent_feedback=24,
                  training_attempts=len(training), later_batch_attempts=len(testing),
                  temporal_replay=strategies, source_evidence=evidence,
                  scope='Retrospective one-call arm averages on already exposed development circuits; no sequential savings or held-out-family claim',
                  token_scope='Reported usage only; missing usage and prices prevent a complete monetary cost comparison',
                  model_calls=0)
    save(out / 'ANALYSIS.json', report)
    lines = ['# 路由开发数据分析', '',
             '220个首轮槽位用于开发分析，24个依赖续轮单独排除。失败保留基线。',
             '以早期100个槽位拟合规则，在后续120个槽位做历史批次回放。电路此前已被研究者接触，属于回顾性分析。', '',
             '| 单次调用策略 | 对应槽位数 | 合格改善 | 平均归一化延迟改善 | 用量缺失数 |',
             '|---|---:|---:|---:|---:|']
    for name, stats in strategies.items():
        lines.append(f'| {name} | {stats["attempted"]} | {stats["improvements"]} | {stats["mean_gain"]:.2%} | {stats["usage_unknown"]} |')
    lines.extend(['', '路由按精确源码、参数、后端和模型记录历史偏好，运行时另核对基线条件。未知上下文从直接生成开始。',
                  '策略目标为每次尝试的平均时序改善，用量缺失和定价信息不足，成本收益尚待前瞻实验。',
                  '本回放只比较首轮调用的边际结果。多轮调度的收益和调用节省需要实际运行评价。'])
    (out / 'REPORT.md').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    return report


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args(argv)
    print(json.dumps(analyze(args.out), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
