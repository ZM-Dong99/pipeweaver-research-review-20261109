"""Auditable descriptive report and exploratory paired randomization analysis."""
import argparse
from collections import Counter
import itertools
import json
import math
from pathlib import Path
import statistics
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from eda.experiments.run_multicircuit_feedback_144 import validate, eligible, sha


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def wilson(successes, total):
    if not total:
        return None
    z = 1.959963984540054
    proportion = successes / total
    denominator = 1 + z * z / total
    center = (proportion + z * z / (2 * total)) / denominator
    half = z * math.sqrt(proportion * (1 - proportion) / total + z * z / (4 * total * total)) / denominator
    return [max(0, center - half), min(1, center + half)]


def failure_class(row, baseline):
    metrics = row['metrics']
    if row['failure_class']:
        return row['failure_class']
    if metrics.get('formal') != 'PASS':
        return 'SOURCE_VALIDATION_OR_FORMAL'
    if metrics.get('mapped_formal') != 'PASS':
        return 'MAPPING_OR_MAPPED_FORMAL'
    if metrics.get('ppa') != 'PASS':
        return 'PPA_INCOMPLETE'
    if metrics.get('electrical', {}).get('status') != 'PASS':
        return 'ELECTRICAL'
    if not eligible(metrics):
        return 'OTHER_INELIGIBLE'
    if metrics['mapped_area_um2'] > baseline['mapped_area_um2'] * 1.10 + 1e-9:
        return 'AREA_CAP'
    return 'IMPROVEMENT' if row['improved'] else 'NO_STRICT_GAIN'


def paired_randomization(left, right):
    """Enumerate every within-trial arm swap for the difference in medians."""
    observed = statistics.median(left) - statistics.median(right)
    extreme = 0
    for swaps in itertools.product((False, True), repeat=len(left)):
        a = [y if swap else x for x, y, swap in zip(left, right, swaps)]
        b = [x if swap else y for x, y, swap in zip(left, right, swaps)]
        statistic = statistics.median(a) - statistics.median(b)
        extreme += abs(statistic) >= abs(observed) - 1e-12
    return dict(no_sta_minus_sta_median_ns=observed, exact_two_sided_p=extreme / (2 ** len(left)),
                permutations=2 ** len(left))


def finalize(out):
    protocol = validate(out)
    rows = [load(path) for path in sorted((out / 'trials').glob('call_*/result.json'))]
    lookup = {row['index']: row for row in rows}
    groups = []
    comparisons = []
    selected = []
    followups = []
    repaired_formal_failures = []
    categories = Counter()
    for case in protocol['cases']:
        case_rows = [row for row in rows if row['case'] == case['id']]
        for row in case_rows:
            row['classification'] = failure_class(row, case['baseline'])
            categories[row['classification']] += 1
        for arm in ('no_sta', 'sta'):
            items = [r for r in case_rows if r['arm'] == arm and r['round'] == 1]
            count = sum(r['improved'] for r in items)
            groups.append(dict(case=case['id'], arm=arm, scheduled=10, completed=len(items),
                generated=sum(r['status'] == 'GENERATED' for r in items), improvements=count,
                improvement_wilson95=wilson(count, len(items)),
                median_retained_delay_ns=statistics.median(r['retained_delay_ns'] for r in items) if len(items) == 10 else None,
                unique_rtl=len({r['rtl_sha256'] for r in items if r.get('rtl_sha256')}),
                unique_mapped=len({r['metrics']['mapped_sha256'] for r in items if r['metrics'].get('mapped_sha256')})))
        if sum(r['round'] == 1 for r in case_rows) == 20:
            a = sorted((r for r in case_rows if r['round'] == 1 and r['arm'] == 'no_sta'), key=lambda r: r['trial'])
            b = sorted((r for r in case_rows if r['round'] == 1 and r['arm'] == 'sta'), key=lambda r: r['trial'])
            comparisons.append(dict(case=case['id'], **paired_randomization(
                [r['retained_delay_ns'] for r in a], [r['retained_delay_ns'] for r in b])))
        improved = [r for r in case_rows if r['improved']]
        if improved:
            best = min(improved, key=lambda r: (r['metrics']['max_data_arrival_ns'], r['metrics']['mapped_area_um2'], r['index']))
            source = out / 'trials' / f'call_{best["index"]:03d}' / 'candidate.v'
            selected.append(dict(case=case['id'], call=best['index'], arm=best['arm'], round=best['round'],
                baseline_delay_ns=case['baseline']['max_data_arrival_ns'], delay_ns=best['metrics']['max_data_arrival_ns'],
                delay_reduction_pct=100 * (1 - best['metrics']['max_data_arrival_ns'] / case['baseline']['max_data_arrival_ns']),
                area_change_pct=100 * (best['metrics']['mapped_area_um2'] / case['baseline']['mapped_area_um2'] - 1),
                original_lines=len((out / 'inputs' / (case['id'] + '.v')).read_text(encoding='utf-8').splitlines()),
                candidate_lines=len(source.read_text(encoding='utf-8').splitlines()),
                source=str(source.relative_to(out)), source_sha256=sha(source)))
        for row in case_rows:
            if row['round'] == 2:
                parent = lookup[row['parent']]
                retained = min(parent['retained_delay_ns'], row['retained_delay_ns'])
                followups.append(dict(case=row['case'], arm=row['arm'], call=row['index'], parent=row['parent'],
                    parent_generated=parent['status'] == 'GENERATED',
                    parent_eda_status=parent['metrics'].get('status'),
                    parent_retained_delay_ns=parent['retained_delay_ns'], second_retained_delay_ns=retained,
                    improved_over_parent=retained < parent['retained_delay_ns'],
                    improved_over_original=row['improved'], classification=row['classification']))
                if parent['metrics'].get('formal') == 'FAIL' and row['improved']:
                    repaired_formal_failures.append(dict(case=row['case'], parent=parent['index'],
                        call=row['index'], delay_ns=row['metrics']['max_data_arrival_ns']))
    ordered = sorted(comparisons, key=lambda r: r['exact_two_sided_p'])
    adjusted = 0
    for position, comparison in enumerate(ordered):
        adjusted = max(adjusted, min(1, (len(ordered) - position) * comparison['exact_two_sided_p']))
        comparison['holm_adjusted_p'] = adjusted
    analysis = dict(complete=len(rows) == 144, completed=len(rows), categories=dict(categories), groups=groups,
        exploratory_paired_median_tests=comparisons, selected=selected, followups=followups,
        followup_improvements_over_parent=sum(r['improved_over_parent'] for r in followups),
        repaired_formal_failures=repaired_formal_failures,
        validation_failures=dict(Counter(
            'SOURCE_EQUIVALENCE_COUNTEREXAMPLE' if r['metrics'].get('formal') == 'FAIL' else 'FRONTEND_OR_STRUCTURE'
            for r in rows if r['classification'] == 'SOURCE_VALIDATION_OR_FORMAL')),
        reported_total_tokens=sum((r.get('usage') or {}).get('total_tokens', 0) for r in rows),
        reported_models=dict(Counter(r.get('reported_model') for r in rows if r.get('reported_model'))),
        execution_segments=dict(Counter(r.get('execution_segment', 'initial') for r in rows)),
        protocol_sha256=sha(out / 'protocol.json'),
        statistical_scope='Wilson intervals and paired-swap median tests are exploratory analyses added after execution started. Six exposed instances; dependent follow-ups excluded from primary tests. Provider failures retained at baseline. No unseen-design or universal causal claim.')
    (out / 'ANALYSIS.json').write_text(json.dumps(analysis, ensure_ascii=False, indent=2, allow_nan=False), encoding='utf-8')
    text = ['# 六类电路扩样与反馈结果', '', f'已完成{len(rows)}/144个计划槽位。第一轮120次独立固定提示，第二轮24次预先指定的反馈续轮。', '',
        '## 第一轮结果', '', '| 电路 | 组别 | 完成 | 合格改进 | 回退后延迟中位数 ns | 不同RTL / 映射网表 |', '|---|---|---|---|---|---|']
    for group in groups:
        median = group['median_retained_delay_ns']
        text.append(f'| {group["case"]} | {group["arm"]} | {group["completed"]}/10 | {group["improvements"]}/10 | {median if median is not None else "待完整批次"} | {group["unique_rtl"]} / {group["unique_mapped"]} |')
    text += ['', '## 探索性统计', '',
        '按同一电路、同一trial交换两组标签，穷举1024种安排，检验回退后延迟中位数差异，并对六项比较作Holm校正。差值为无STA中位数减STA中位数，负值表示本批无STA组较低。分析在实验启动后加入，采用开发实例，适合描述本批结果。', '',
        '| 电路 | 中位数差值 ns | 双侧精确p | Holm校正p |', '|---|---|---|---|']
    for comparison in comparisons:
        text.append(f'| {comparison["case"]} | {comparison["no_sta_minus_sta_median_ns"]:.3f} | {comparison["exact_two_sided_p"]:.4f} | {comparison["holm_adjusted_p"]:.4f} |')
    text += ['', '每组10次的有效率区间仍较宽。例如0/10对应95% Wilson区间约0%至27.8%，4/10对应约16.8%至68.7%。各组完整区间保存在ANALYSIS.json。']
    text += ['', '## 本轮最佳合格候选', '', '| 电路 | 调用 | 原始→候选延迟 ns | 延迟下降 | 面积变化 | 原始→候选行数 |', '|---|---|---|---|---|---|']
    for best in selected:
        text.append(f'| {best["case"]} | {best["call"]} | {best["baseline_delay_ns"]:.2f}→{best["delay_ns"]:.2f} | {best["delay_reduction_pct"]:.2f}% | {best["area_change_pct"]:+.2f}% | {best["original_lines"]}→{best["candidate_lines"]} |')
    text += ['', '行数包括注释和空行。不同映射文件按SHA-256计数，结构等价类别另需专门核对。']
    text += ['', '## 第二轮反馈', '', f'完成{len(followups)}/24次，{analysis["followup_improvements_over_parent"]}次进一步改善父候选回退后的已保留延迟。其中{sum(r["parent_generated"] for r in followups)}次有父候选RTL，其余按预定方案从原始设计重新生成。第二轮允许保留第一轮合格候选，不能把退化续轮替换成更差结果。', '',
        '## 失败和用量', '', f'互斥分类为{json.dumps(dict(categories), ensure_ascii=False)}。可见完整响应报告合计{analysis["reported_total_tokens"]} tokens，传输失败的实际用量和账单未知。', '',
        '## 统计与解释范围', '', '主表包含所有计划槽位，失败回退到原始基线。ANALYSIS.json另给出每组改进率的Wilson区间与按trial交换组标签的精确中位数检验，并对六个比较做Holm校正。这些检验在实验启动后加入，属于探索性分析。', '',
        '六个公开固定实例属于开发扩样。相同设计的多次调用反映生成波动，不能替代跨独立电路的泛化样本。24个续轮依赖其父候选，独立列出。本轮单一请求模型标识，未建立公平跨模型比较。', '',
        '前48次以最多6并发执行，触发连续传输失败后按协议停止。用户明确批准后，仅剩余96个未尝试槽位降至2并发继续，原失败和停止标记保留。执行分段及传输失败会影响端到端结果，完整返回后的条件分析仅作为补充。', '',
        '正式完成标记、原始证据和统计以protocol.json、trials、RESULT.json和ANALYSIS.json为准。']
    text += ['', '## 具体修复与复核', '']
    for repair in repaired_formal_failures:
        text.append(f'{repair["case"]}的父调用{repair["parent"]}源级等价失败，反馈续轮{repair["call"]}通过完整接受规则，候选延迟{repair["delay_ns"]:.2f}ns。该实例属于开发案例。')
    text += ['', f'前端或结构检查失败{analysis["validation_failures"].get("FRONTEND_OR_STRUCTURE", 0)}次，源级等价反例{analysis["validation_failures"].get("SOURCE_EQUIVALENCE_COUNTEREXAMPLE", 0)}次。分类总数与全部调用记录逐项对齐。', '']
    for rel, label in (('AUDIT.json', '调用、提示与评价证据核对'),
                       ('definedness_checks/AUDIT.json', '输出确定性正负例与语义证明'),
                       ('independent_reproduction_final/AUDIT.json', '六组最终最佳候选及基线独立复测')):
        path = out / rel
        if path.exists():
            audit = load(path)
            text.append(f'- {label} {"通过" if audit["passed"] else "待处理"}，记录为 [{rel}]({rel})。')
    (out / 'INTERPRETATION.md').write_text('\n'.join(text) + '\n', encoding='utf-8')
    print(json.dumps({k: analysis[k] for k in ('complete', 'completed', 'categories', 'reported_total_tokens')}, ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('out', type=Path)
    finalize(parser.parse_args().out.resolve())
