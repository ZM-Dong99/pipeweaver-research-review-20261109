"""Read-only recomputation of parameter results and predeclared held-out routing."""
import argparse
from collections import Counter
import json
from pathlib import Path
import statistics
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import load, save, sha
from eda.experiments.collect_parameter_study import CASE_IDS
from eda.experiments.collect_systematic_study import accepted
from eda.experiments.run_systematic_study import eligible


def retained(row, baseline):
    return row['metrics']['max_data_arrival_ns'] if row and row['accepted'] else baseline['max_data_arrival_ns']


def qualified(row, case, baseline):
    return (eligible(case, row['metrics'])
            and row['metrics']['mapped_area_um2'] <= baseline['mapped_area_um2'] * 1.1 + 1e-9
            and row['metrics']['tns_ns'] >= baseline['tns_ns'])


def summarize(study):
    protocol = load(study / 'protocol.json')
    if sha(study / 'protocol.json') != (study / 'protocol.sha256').read_text().strip():
        raise ValueError('Protocol checksum mismatch')
    for name, digest in protocol['source_dependencies'].items():
        if sha(ROOT / name.replace('\\', '/')) != digest:
            raise ValueError('Frozen source changed ' + name)
    plan = load(study / 'ROUTING_ANALYSIS_PLAN.json')
    if sha(study / 'ROUTING_ANALYSIS_PLAN.json') != (study / 'ROUTING_ANALYSIS_PLAN.sha256').read_text().strip():
        raise ValueError('Routing plan checksum mismatch')
    if plan['reserved_requests_at_freeze'] >= 18:
        raise ValueError('Routing plan was not frozen before held-out blocks')
    cases = {case['id']: case for case in protocol['cases']}
    if set(cases) != set(CASE_IDS):
        raise ValueError('Unexpected parameter cases')
    baselines = {name: load(study / 'baselines' / name / 'result.json') for name in cases}
    for case in cases.values():
        if sha(study / case['input']) != case['source_sha256']:
            raise ValueError('Input changed ' + case['id'])
    calls = []
    failure_records = []
    by_job = {}
    jobs = {job['id']: job for job in protocol['schedule']}
    response_ids = set()
    for path in sorted((study / 'calls').glob('request_*/RESULT.json')):
        row = load(path)
        slot = load(path.parent / 'slot.json')
        if (row['id'] not in jobs or slot['job'] != jobs[row['id']]
                or any(row[key] != jobs[row['id']][key] for key in ('case', 'strategy', 'repeat'))):
            raise ValueError('Call and frozen job schedule disagree')
        if row['id'] in by_job:
            raise ValueError('Repeated job response')
        by_job[row['id']] = row
        case, baseline = cases[row['case']], baselines[row['case']]
        if row['accepted'] != accepted(case, row['metrics'], baseline):
            raise ValueError('Saved candidate acceptance disagrees with recomputation')
        if row.get('rtl_sha256') and sha(path.parent / 'candidate.v') != row['rtl_sha256']:
            raise ValueError('Candidate source changed')
        if eligible(case, row['metrics']):
            proof = load(path.parent / 'definedness/result.json')
            log = (path.parent / 'definedness/definedness.log').read_text(encoding='utf-8')
            if not proof['passed'] or 'SAT proof finished - no model found: SUCCESS!' not in log:
                raise ValueError('Missing definedness proof')
        if row['accepted']:
            evaluation = path.parent / 'evaluation'
            if case['backend'] == 'crc_slang':
                evaluation /= 'eda'
            for name in ('formal.log', 'mapped_formal.log'):
                if 'SUCCESS!' not in (evaluation / name).read_text(encoding='utf-8'):
                    raise ValueError('Missing source/mapped proof success')
        else:
            proof_logs = []
            for folder in (path.parent / 'evaluation', path.parent / 'evaluation/eda'):
                for name in ('formal.log', 'mapped_formal.log'):
                    log_path = folder / name
                    if log_path.is_file():
                        proof_logs.append((log_path, log_path.read_text(encoding='utf-8')))
            counterexamples = [log.relative_to(study).as_posix() for log, text in proof_logs
                               if 'SAT proof finished - model found: FAIL!' in text]
            failure_records.append(dict(request=row['request'], case=row['case'], strategy=row['strategy'],
                reason=row['failure_class'] or row['rejection_reason'],
                counterexample_logs=counterexamples,
                proof_timeout=any('TIMEOUT' in text for _, text in proof_logs)
                              or 'timeout' in row['metrics'].get('failure_reason', '').lower()))
        response_path = path.parent / 'response.json'
        if response_path.exists():
            response = load(response_path)
            if response.get('id'):
                response_ids.add((response.get('model'), response['id']))
        calls.append(row)
    completed = list((study / 'runs').glob('job_*/RESULT.json'))
    if len(completed) != 54 or len(calls) != len(list((study / 'calls').glob('request_*/slot.json'))):
        raise ValueError('Collection remains incomplete')
    for job in protocol['schedule']:
        result = load(study / 'runs' / job['id'] / 'RESULT.json')
        if any(result[key] != job[key] for key in ('case', 'strategy', 'repeat')):
            raise ValueError('Job and schedule disagree')
    groups = []
    for case_id, case in cases.items():
        baseline = baselines[case_id]
        for strategy in ('direct', 'sta'):
            jobs = [job for job in protocol['schedule'] if job['case'] == case_id and job['strategy'] == strategy]
            selected = [by_job[job['id']] for job in jobs if job['id'] in by_job]
            values = [retained(by_job.get(job['id']), baseline) for job in jobs]
            improved = [row for row in selected if row['accepted']]
            best = min(improved, key=lambda row: row['metrics']['max_data_arrival_ns']) if improved else None
            groups.append(dict(case=case_id, strategy=strategy, scheduled=3, attempted=len(selected),
                baseline_arrival_ns=baseline['max_data_arrival_ns'], baseline_area_um2=baseline['mapped_area_um2'],
                qualified=sum(qualified(row, case, baseline) for row in selected), improvements=len(improved),
                median_retained_arrival_ns=statistics.median(values),
                median_retained_gain_percent=statistics.median(100 * (1 - value / baseline['max_data_arrival_ns']) for value in values),
                best_request=best['request'] if best else None,
                best_arrival_ns=retained(best, baseline),
                best_gain_percent=100 * (1 - retained(best, baseline) / baseline['max_data_arrival_ns']),
                best_area_change_percent=100 * (best['metrics']['mapped_area_um2'] / baseline['mapped_area_um2'] - 1) if best else 0))
    by_cell = {(row['case'], row['strategy'], row['repeat']): row for row in calls}
    preferences, evaluations = [], {name: [] for name in ('router', 'direct', 'sta')}
    for case_id, baseline in baselines.items():
        training = {strategy: by_cell.get((case_id, strategy, 1)) for strategy in ('direct', 'sta')}
        route = 'sta' if retained(training['sta'], baseline) < retained(training['direct'], baseline) else 'direct'
        preferences.append(dict(case=case_id, route=route,
            training_requests={strategy: row['request'] if row else None for strategy, row in training.items()}))
        for repeat in (2, 3):
            pair = {strategy: by_cell.get((case_id, strategy, repeat)) for strategy in ('direct', 'sta')}
            if not all(pair.values()):
                continue
            for policy, strategy in [('router', route), ('direct', 'direct'), ('sta', 'sta')]:
                row = pair[strategy]
                evaluations[policy].append(dict(case=case_id, repeat=repeat, strategy=strategy, request=row['request'],
                    improved=row['accepted'], gain_percent=100 * (1 - retained(row, baseline) / baseline['max_data_arrival_ns']),
                    usage=row['usage']))
    routing = {}
    for policy, rows in evaluations.items():
        usages = [row['usage']['total_tokens'] for row in rows if isinstance(row['usage'], dict)
                  and type(row['usage'].get('total_tokens')) is int]
        routing[policy] = dict(completed_pairs=len(rows), scheduled_pairs=18,
            improvements=sum(row['improved'] for row in rows),
            mean_gain_percent=statistics.mean(row['gain_percent'] for row in rows) if rows else None,
            median_gain_percent=statistics.median(row['gain_percent'] for row in rows) if rows else None,
            reported_tokens=sum(usages), usage_unknown=len(rows)-len(usages), rows=rows)
    historical = load(ROOT / 'output/hnu_midterm_form_20261109/ALL_VERIFIED_RESPONSE_LEDGER.json')
    old_ids = {(row['model'], row['id']) for row in historical['responses']}
    previous = ROOT / 'eda/experiments/systematic_engineering_20261116_v3'
    for path in (previous / 'calls').glob('request_*/response.json'):
        response = load(path)
        if response.get('id'):
            old_ids.add((response.get('model'), response['id']))
    known_usage = [row['usage']['total_tokens'] for row in calls if isinstance(row.get('usage'), dict)
                   and type(row['usage'].get('total_tokens')) is int]
    training_rows = [row for row in calls if row['repeat'] == 1]
    training_usage = [row['usage']['total_tokens'] for row in training_rows if isinstance(row.get('usage'), dict)
                      and type(row['usage'].get('total_tokens')) is int]
    return dict(scheduled=54, attempted=len(calls),
        api_attempt_markers=len(list((study / 'calls').glob('request_*/api_audit/attempt.json'))),
        generated=sum(row['status'] == 'GENERATED' for row in calls),
        distinct_rtl_hashes=len({row['rtl_sha256'] for row in calls if row.get('rtl_sha256')}),
        distinct_case_and_rtl=len({(row['case'], row['rtl_sha256']) for row in calls if row.get('rtl_sha256')}),
        qualified=sum(group['qualified'] for group in groups), improvements=sum(row['accepted'] for row in calls),
        failures=dict(Counter(row['failure_class'] or row['rejection_reason'] for row in calls if not row['accepted'])),
        failure_records=failure_records,
        new_saved_response_ids=len(response_ids), prior_saved_response_ids=len(old_ids),
        combined_saved_response_ids=len(old_ids | response_ids), groups=groups,
        reported_total_tokens=sum(known_usage), usage_unknown=len(calls)-len(known_usage),
        routing_training=dict(attempted=len(training_rows), reported_tokens=sum(training_usage),
                              usage_unknown=len(training_rows)-len(training_usage)),
        routing_preferences=preferences, held_out_routing=routing,
        scope='Nine parameter instances from three circuit families, three calls per strategy per instance; descriptive comparisons')


def markdown(result):
    lines = ['# 参数规模实验', '',
        '本轮模型调用名称为 `gpt-6.1-sol`。9个参数实例来自ALU、优先编码器、CRC三类电路，每个实例的两组各安排3次单次调用。失败和无改进时保留原始RTL，所有中位数按计划槽位计算。', '',
        f"54个计划槽位中实际调用 {result['attempted']} 次，API尝试标记 {result['api_attempt_markers']} 份，返回RTL {result['generated']} 份。不同源码哈希 {result['distinct_rtl_hashes']} 个，不同实例与源码哈希组合 {result['distinct_case_and_rtl']} 个。", '',
        f"满足源级、映射后等价、STA、电气、定义性、面积与TNS约束的候选 {result['qualified']} 份，有效时序优化 {result['improvements']} 份。失败分布为 `{json.dumps(result['failures'], ensure_ascii=False)}`。", '',
        f"新增可见响应ID {result['new_saved_response_ids']} 个，与前期去重合并后为 {result['combined_saved_response_ids']} 个。实际费用待账单核算。", '',
        f"已报告总token为 {result['reported_total_tokens']:,}，用量未知记录 {result['usage_unknown']} 份。生成失败路径的已知用量及生成时间仍保存在逐次记录中。", '',
        '## 各规模的STA组结果', '',
        '| 实例 | 合格/计划 | 改进/计划 | 原始延迟 ns | 中位保留延迟 ns | 中位收益 | 最好收益 | 最好候选面积变化 |',
        '|---|---:|---:|---:|---:|---:|---:|---:|']
    for row in result['groups']:
        if row['strategy'] == 'sta':
            lines.append(f"| {row['case']} | {row['qualified']}/3 | {row['improvements']}/3 | {row['baseline_arrival_ns']:.2f} | {row['median_retained_arrival_ns']:.3f} | {row['median_retained_gain_percent']:.2f}% | {row['best_gain_percent']:.2f}% | {row['best_area_change_percent']:+.2f}% |")
    lines += ['', '## 完整组别与候选归属', '',
        '| 实例 | 策略 | 实际/计划 | 合格/计划 | 改进/计划 | 中位保留收益 | 最好候选 |',
        '|---|---|---:|---:|---:|---:|---|']
    for row in result['groups']:
        request = f"[{row['best_request']}](calls/{row['best_request']}/RESULT.json)" if row['best_request'] else '原始RTL'
        lines.append(f"| {row['case']} | {row['strategy']} | {row['attempted']}/3 | {row['qualified']}/3 | {row['improvements']}/3 | {row['median_retained_gain_percent']:.2f}% | {request} |")
    lines += ['', '## 未获得有效优化的记录', '',
        '| 请求 | 实例 | 策略 | 原因 | 实际反例 | 证明超时 |', '|---|---|---|---|---|---|']
    for row in result['failure_records']:
        lines.append(f"| {row['request']} | {row['case']} | {row['strategy']} | {row['reason']} | {'有' if row['counterexample_logs'] else '—'} | {'是' if row['proof_timeout'] else '—'} |")
    lines += ['', '## 预先记录的路由评估', '',
        '规则在进入后两轮留出数据前冻结。各实例用第1轮两组结果选择保留延迟较小的提示策略，相等时选择直接提示，再在第2、3轮相同实例上核对。每种策略最多18个配对结果，按每次调用保留的归一化时序收益统计。', '',
        '| 策略 | 完成配对数 | 有效优化数 | 平均保留收益 | 中位保留收益 | 已报告token |',
        '|---|---:|---:|---:|---:|---:|']
    for name, row in result['held_out_routing'].items():
        mean = '—' if row['mean_gain_percent'] is None else f"{row['mean_gain_percent']:.2f}%"
        median = '—' if row['median_gain_percent'] is None else f"{row['median_gain_percent']:.2f}%"
        lines.append(f"| {name} | {row['completed_pairs']}/18 | {row['improvements']} | {mean} | {median} | {row['reported_tokens']} |")
    training = result['routing_training']
    lines += ['', f"训练阶段另有 {training['attempted']} 次调用，已报告 {training['reported_tokens']:,} token，用量未知 {training['usage_unknown']} 份。留出阶段的选择结果与训练成本分别记录，研究实际总调用数为 {result['attempted']} 次。", '']
    lines += ['', '## 范围与后续', '',
        '本轮为三个电路家族的参数对照，每个参数每组3次。宽度之间共享结构和源码，当前结果用于描述规模趋势及提示策略的适用边界。路由评估针对这些已测实例，跨电路泛化、较多重复次数及实际端到端效率仍需继续验证。', '',
        '协议、逐次提示、API响应、生成RTL、源级与映射后证明、STA、电气及定义性检查位于仓库 `eda/experiments/systematic_parameter_20261117/`。其中 `ANALYSIS.json` 保存候选归属、全部分组及路由配对结果。', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('report', 'verify'))
    parser.add_argument('--study', type=Path, required=True)
    args = parser.parse_args()
    study = args.study.resolve()
    result = summarize(study)
    if args.mode == 'verify':
        if result != load(study / 'ANALYSIS.json'):
            raise ValueError('Analysis differs from raw-record recomputation')
    else:
        save(study / 'ANALYSIS.json', result)
        (study / 'REPORT.md').write_text(markdown(result), encoding='utf-8')
    print(json.dumps(dict(passed=True, attempted=result['attempted'], improvements=result['improvements'],
                         combined_saved_response_ids=result['combined_saved_response_ids'], model_requests=0)))


if __name__ == '__main__':
    main()
