"""Recompute engineering results with separate one-call and multi-round budgets."""
import argparse
from collections import Counter
import json
from pathlib import Path
import statistics
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import load, save
from eda.experiments.collect_systematic_study import accepted, rejection_reason
from eda.experiments.run_systematic_study import eligible


def qualified(case, metrics, baseline):
    return (eligible(case, metrics)
            and metrics['mapped_area_um2'] <= baseline['mapped_area_um2'] * 1.1 + 1e-9
            and metrics['tns_ns'] >= baseline['tns_ns'])


def summarize(study):
    protocol = load(study / 'protocol.json')
    cases = {case['id']: case for case in protocol['cases']}
    baselines = {case: load(study / 'baselines' / case / 'result.json') for case in cases}
    runs = [load(path) for path in sorted((study / 'runs').glob('job_*/RESULT.json'))]
    calls = []
    for path in sorted((study / 'calls').glob('request_*/RESULT.json')):
        row = load(path)
        slot = load(path.parent / 'slot.json')
        row['strategy'] = slot.get('strategy', slot.get('job', {}).get('strategy'))
        row['repeat'] = slot.get('repeat', slot.get('job', {}).get('repeat'))
        row['cohort'] = slot.get('cohort', 'multi_round_pilot')
        expected = accepted(cases[row['case']], row['metrics'], baselines[row['case']])
        if row['accepted'] != expected:
            raise ValueError('Saved acceptance differs from recomputation ' + path.parent.name)
        calls.append(row)
    slots = list((study / 'calls').glob('request_*/slot.json'))
    if len(slots) != len(calls):
        raise ValueError('Requests remain incomplete')
    first_calls = [row for row in calls if row['round'] == 1]
    groups = []
    pilot_groups = []
    for case_id, case in cases.items():
        if case['category'] == 'parameter_scan':
            continue
        baseline = baselines[case_id]
        for strategy in ('direct', 'sta', 'adaptive'):
            selected = [row for row in first_calls if row['case'] == case_id and row['strategy'] == strategy]
            retained = [row['metrics']['wns_ns'] if row['accepted'] else baseline['wns_ns'] for row in selected]
            groups.append(dict(case=case_id, strategy=strategy, attempted=len(selected),
                               generated=sum(row['status'] == 'GENERATED' for row in selected),
                               qualified=sum(qualified(case, row['metrics'], baseline) for row in selected),
                               improvements=sum(row['accepted'] for row in selected),
                               median_retained_wns_ns=statistics.median(retained) if retained else None,
                               routes=dict(Counter(row['route'] for row in selected))))
            selected_runs = [run for run in runs if run['case'] == case_id and run['strategy'] == strategy]
            pilot_groups.append(dict(case=case_id, strategy=strategy, scheduled=len(selected_runs),
                                     attempts=sum(run['model_requests'] for run in selected_runs),
                                     improved=sum(run.get('improved', False) for run in selected_runs),
                                     retained_wns_ns=[run['best_metrics']['wns_ns'] for run in selected_runs
                                                      if run['status'] == 'COMPLETE']))
    best = []
    for case_id, case in cases.items():
        if case['category'] == 'parameter_scan':
            continue
        for strategy in ('direct', 'sta', 'adaptive'):
            selected = [row for row in calls if row['case'] == case_id and row['strategy'] == strategy and row['accepted']]
            if not selected:
                continue
            row = max(selected, key=lambda candidate: candidate['metrics']['wns_ns'])
            base = baselines[case_id]
            best.append(dict(case=case_id, strategy=strategy, request=row['request'], route=row['route'],
                             round=row['round'], baseline_wns_ns=base['wns_ns'],
                             candidate_wns_ns=row['metrics']['wns_ns'],
                             wns_gain_ns=round(row['metrics']['wns_ns'] - base['wns_ns'], 6),
                             area_change_percent=100 * (row['metrics']['mapped_area_um2'] / base['mapped_area_um2'] - 1),
                             rtl_sha256=row['rtl_sha256']))
    failures = Counter(row.get('failure_class') or rejection_reason(cases[row['case']], row['metrics'], baselines[row['case']])
                       for row in calls if not row['accepted'])
    known_usage = [row['usage'] for row in calls if isinstance(row.get('usage'), dict)
                   and type(row['usage'].get('total_tokens')) is int]
    responses = []
    for path in sorted((study / 'calls').glob('request_*/response.json')):
        response = load(path)
        if response.get('id'):
            responses.append((response.get('model'), response['id']))
    historical = load(ROOT / 'output/hnu_midterm_form_20261109/ALL_VERIFIED_RESPONSE_LEDGER.json')
    historical_ids = {(row['model'], row['id']) for row in historical['responses']}
    strategy_totals = []
    for strategy in ('direct', 'sta', 'adaptive'):
        selected = [row for row in groups if row['strategy'] == strategy]
        strategy_totals.append(dict(strategy=strategy,
                                    attempted=sum(row['attempted'] for row in selected),
                                    qualified=sum(row['qualified'] for row in selected),
                                    improvements=sum(row['improvements'] for row in selected)))
    return dict(attempted_calls=len(slots), completed_call_records=len(calls),
                generated_candidates=sum(row['status'] == 'GENERATED' for row in calls),
                distinct_rtl_hashes=len({row['rtl_sha256'] for row in calls if row.get('rtl_sha256')}),
                distinct_case_and_rtl=len({(row['case'], row['rtl_sha256']) for row in calls if row.get('rtl_sha256')}),
                validated_candidates=sum(eligible(cases[row['case']], row['metrics']) for row in calls),
                qualified_candidates=sum(qualified(cases[row['case']], row['metrics'], baselines[row['case']]) for row in calls),
                improvement_slots=sum(row['accepted'] for row in calls), failure_distribution=dict(failures),
                total_reported_tokens=sum(usage['total_tokens'] for usage in known_usage),
                usage_unknown=len(calls) - len(known_usage), unique_saved_response_ids=len(set(responses)),
                historical_saved_response_ids=len(historical_ids),
                combined_saved_response_ids=len(historical_ids | set(responses)),
                maximum_authorized_calls=load(study / 'AUTHORIZATION.json')['maximum_requests'],
                one_call_groups=groups, one_call_strategy_totals=strategy_totals,
                multi_round_pilot=pilot_groups, best_candidates=best,
                scope='Candidate slots include distinct model outputs, not independent circuit families. One-call adaptive uses direct prompts. Multi-round runs retain early stopping and actual budgets.')


def markdown(study, result):
    protocol = load(study / 'protocol.json')
    qualification = load(study / 'QUALIFICATION.json')
    labels = {'pipeline_alu16_s2': '16位两级流水线ALU', 'pipeline_alu32_s3': '32位三级流水线ALU',
              'fsm9_sync': '9状态同步复位FSM', 'arbiter32': '32路轮询仲裁器',
              'fcs_reset8': '完整复位FCS', 'axis_chain8_32': 'AXI字节打包与skid寄存器组合'}
    lines = ['# 流水线与工程模块实验', '',
             '本轮更新于2026年11月16日。使用模型名称为 `gpt-6.1-sol`。源代码、提示、响应、候选与工具日志均通过同目录记录定位。', '',
             '## 覆盖与验收', '',
             '新增18个固定参数实例，16个基线完成验证。六个工程实例覆盖固定周期流水线、同步FSM、轮询仲裁、完整FCS和AXI组合。另有ALU、优先编码器、CRC共12个规模实例。', '',
             '时序模块要求源级和映射后等价证明、综合、STA与电气检查通过，面积至多原始基线的110%，TNS不退化，WNS严格改善。固定10 ns时钟，固定周期延迟和端口功能。初态采用任意已定义值，移除RTL初始化属性，首次采样复位后比较所有输出。FSM为由公开源码改编的同步复位变体。', '',
             'AXI组合基线在源级证明处超时，CRC32并行32位实例在映射后证明处未完成。两者保留记录，后续扩大覆盖需要解决证明能力。', '',
             '## 调用与失败统计', '',
             f"实际调用 {result['attempted_calls']} 次，返回RTL {result['generated_candidates']} 份，不同源码哈希 {result['distinct_rtl_hashes']} 个。形式验证与PPA全流程通过 {result['validated_candidates']} 个，进一步满足面积与TNS约束的合格候选 {result['qualified_candidates']} 个，有效优化槽位 {result['improvement_slots']} 个。已保存唯一响应ID {result['unique_saved_response_ids']} 个。授权上限 {result['maximum_authorized_calls']} 次。", '',
             f"此前已核查响应ID下界为 {result['historical_saved_response_ids']} 个，与本轮去重合并后为 {result['combined_saved_response_ids']} 个。响应ID计数、实际请求次数、不同源码哈希及合格优化样本各自保留统计口径。", '',
             f"已报告总token为 {result['total_reported_tokens']:,}，用量未知记录 {result['usage_unknown']} 份。实际费用待账单核算。未通过优化判据的分布为 `{json.dumps(result['failure_distribution'], ensure_ascii=False)}`。", '',
             '首轮每个电路和策略安排一个最多3次调用的任务，达到0.1 ns WNS改善即可提前结束。剩余额度按完整的五电路×三策略批次增加单次调用重复。不同调用预算的结果分别统计。', '',
             '首轮实际25次调用，加上补充15次，共40次。单次调用比较使用首轮的15个首次响应及15个补充响应，共30个；它们已包含在40次总数中。冻结协议中 `model_requests=0` 描述建库阶段，真实执行以调用槽位、响应和结果文件为准。', '',
             '## STA组代表性候选', '',
             '| 实例 | 基线WNS ns | 候选WNS ns | WNS增加 ns | 面积变化 | 请求 |',
             '|---|---:|---:|---:|---:|---|']
    for row in result['best_candidates']:
        if row['strategy'] == 'sta':
            lines.append(f"| {labels[row['case']]} | {row['baseline_wns_ns']:.2f} | {row['candidate_wns_ns']:.2f} | {row['wns_gain_ns']:.2f} | {row['area_change_percent']:+.2f}% | [{row['request']}](calls/{row['request']}/RESULT.json) |")
    lines += ['', '以上为各实例STA组的最好合格候选。WNS增加量按相同约束计算。样本数量及分布见下表。', '',
              '## 相同单次调用预算的结果', '',
              '将首轮任务的第一次调用与补充实验分别保留来源后汇总。失败或无改进时保留基线指标，计算每个实例的中位保留WNS。自适应策略的第一次调用使用直接提示，反馈调度的效果需要结合多轮记录评估。每个合格电路每种策略仅2个首次响应，当前统计用于探索性比较。', '',
              '| 策略 | 调用数 | 合格数 | 有效优化数 |', '|---|---:|---:|---:|']
    for row in result['one_call_strategy_totals']:
        lines.append(f"| {row['strategy']} | {row['attempted']} | {row['qualified']} | {row['improvements']} |")
    lines += ['',
              '| 实例 | 策略 | 返回/调用 | 合格/调用 | 改进/调用 | 中位保留WNS ns |',
              '|---|---|---:|---:|---:|---:|']
    for row in result['one_call_groups']:
        metric = '—' if row['median_retained_wns_ns'] is None else f"{row['median_retained_wns_ns']:.3f}"
        total = row['attempted']
        lines.append(f"| {labels[row['case']]} | {row['strategy']} | {row['generated']}/{total} | {row['qualified']}/{total} | {row['improvements']}/{total} | {metric} |")
    lines += ['', '## 最多三次调用的首轮任务', '',
              '| 实例 | 策略 | 已安排任务 | 实际调用 | 改进任务 | 最终保留WNS ns |',
              '|---|---|---:|---:|---:|---|']
    for row in result['multi_round_pilot']:
        lines.append(f"| {labels[row['case']]} | {row['strategy']} | {row['scheduled']} | {row['attempts']} | {row['improved']} | {', '.join(f'{value:.2f}' for value in row['retained_wns_ns']) or '—'} |")
    lines += ['', '## 实际反馈优化案例', '',
              '32路轮询仲裁器的自适应任务前两轮均超过原始面积上限。第三轮接收上一候选及实际验证指标后，得到request_009，WNS由7.79增加到8.23 ns，面积相对原始基线增加7.74%，通过源级、映射后等价与时序检查。该实例展示了反馈路径的实际运行记录，策略整体效率仍需更多均衡任务评估。', '']
    lines += ['', '## 参数扫描进度与适用边界', '',
              'ALU和编码器各4个规模基线全部通过，CRC的4/8/16位数据输入实例通过。以下数值仅描述原始基线的规模变化。本轮尚未对这些参数实例采集模型优化候选，优化收益随规模的变化仍待实验。', '',
              '| 实例 | 基线合格 | 数据到达 ns | 映射面积 μm² |',
              '|---|---|---:|---:|']
    for case, row in zip(protocol['cases'], qualification['cases']):
        if case['category'] != 'parameter_scan':
            continue
        metrics = row['metrics']
        arrival = metrics.get('max_data_arrival_ns')
        area = metrics.get('mapped_area_um2')
        lines.append(f"| {case['id']} | {'是' if row['qualified'] else '未完成'} | {arrival if arrival is not None else '—'} | {area if area is not None else '—'} |")
    lines += ['', '## 证据、复现与结论范围', '',
              '错误周期、错误数据位和错误FSM输出的三个实际负例均被形式验证拒绝。合格候选另接受带undef跟踪的输出定义性审计，其正常样本及两种X注入负例保留在审计记录中。', '',
              '新实验支持在所测流水线和工程模块上获得保持周期功能的合格时序优化。当前电路种类及重复次数仍有限，策略之间的总体优势需要更多均衡实验。新增流水线实验保留原有周期延迟，流水线自动切分和插入仍待开发。预布局时序与既有FCS物理验证分别归档。', '',
              '在仓库根目录运行 `python tools/reproduce_research.py verify` 可执行离线核查。运行 `python tools/reproduce_research.py systematic --out runs/systematic` 可重新验证18个基线和全部已保存候选。实际EDA需要Yosys、Slang、OpenSTA及相同哈希的Liberty，默认产生0次模型调用。详见仓库 `SYSTEMATIC_REPRODUCE.md`。', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--study', type=Path, required=True)
    args = parser.parse_args()
    study = args.study.resolve()
    result = summarize(study)
    save(study / 'ENGINEERING_RESULTS.json', result)
    (study / 'ENGINEERING_REPORT.md').write_text(markdown(study, result), encoding='utf-8')
    print(json.dumps({key: value for key, value in result.items() if isinstance(value, (int, str))}, ensure_ascii=False))


if __name__ == '__main__':
    main()
