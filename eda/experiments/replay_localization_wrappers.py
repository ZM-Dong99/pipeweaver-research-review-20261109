"""Post-hoc visible-format compatibility replay; no new API or EDA, strict result retained."""
import argparse
import json
from pathlib import Path
import run_localization_selection as run


def normalize_visible(content):
    if not isinstance(content, str):
        raise run.LLMGenerationError('Visible content must be a string')
    content = content.strip()
    removed = False
    if content.startswith('<think>'):
        end = content.find('</think>')
        if end < 0:
            raise run.LLMGenerationError('Unclosed leading wrapper')
        content = content[end + len('</think>'):].strip()
        removed = True
    selection = run.parse_selection(content)
    return selection, removed


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('study', type=Path)
    args = ap.parse_args()
    out = args.study.resolve()
    run.validate(out)
    manifest = run.load(out / 'selection_manifest.json')
    run.require(run.sha(out / 'selection_manifest.json') == (out / 'selection_manifest.sha256').read_text().strip(), 'Manifest changed')
    strict = run.load(out / 'summary.json')
    replayed, details = [], []
    for original in manifest['rows']:
        response = run.trial_dir(out, original['slot']) / 'api_audit/response.json'
        row = dict(original)
        removed = False
        if response.exists():
            raw = run.load(response)
            try:
                selected, removed = normalize_visible(raw['choices'][0]['message']['content'])
            except (run.LLMGenerationError, KeyError, IndexError, TypeError):
                pass
            else:
                selected['provider_metadata'] = {k: raw[k] for k in ('id', 'model', 'created', 'usage') if k in raw}
                row.update(status='SELECTED', action_id=selected['action_id'], selection=selected)
                row.pop('error', None)
        details.append(dict(call_index=original['slot']['call_index'], response_sha256=run.sha(response) if response.exists() else None,
                            strict_status=original['status'], replay_status=row['status'],
                            removed_complete_leading_wrapper=removed, action_id=row.get('action_id')))
        replayed.append(row)
    replay = run.summarize(replayed, run.load(out / 'design/analysis_only/prior_mapping_and_sta.json'),
                           run.load(out / 'design/analysis_only/deterministic_controls.json'))
    report = dict(kind='POST_HOC_FORMAT_COMPATIBILITY_REPLAY', new_api_requests=0, new_eda_runs=0,
        original_manifest_sha256=run.sha(out / 'selection_manifest.json'), strict_summary_sha256=run.sha(out / 'summary.json'),
        replay_runner_sha256=run.sha(Path(__file__)), parser='Remove at most one complete leading think wrapper, discard its contents, then apply unchanged exact action schema. Same transform applied to both arms; no semantic editing or retries.',
        interpretation='This is a post-hoc parser sensitivity check of the same responses, not independent model replication or a replacement for the frozen strict-format result.',
        changed_count=sum(d['strict_status'] != d['replay_status'] for d in details), details=details,
        strict_groups=strict['groups'], replay=replay)
    (out / 'FORMAT_REPLAY.json').write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding='utf-8')
    lines = ['# 返回格式兼容回放：不追加请求', '',
        '严格主结果保持原样。对全部存档响应统一移除至多一个完整前导think包装，丢弃包装内容，再使用原来的动作白名单、字段与重复键检查。没有补写答案、修改动作或重发请求。', '',
        '| 配置 | 组别 | 严格合法/3 | 兼容回放合法/3 | 回放保留后中位延迟ns | 最优命中/3 |', '|---|---|---:|---:|---:|---:|']
    for profile, arms in replay['groups'].items():
        for arm, g in arms.items():
            lines.append(f"| {profile} | {arm} | {strict['groups'][profile][arm]['valid_selections']} | {g['valid_selections']} | {g['median_retained_delay_ns']} | {g['optimal_hits']} |")
    lines += ['', f"共恢复{report['changed_count']}份原先被严格格式拒绝的响应；新增API0次、EDA0次。",
        '', '原始严格成绩混入了返回格式因素，不能直接解释为模型选择能力差异。此回放是观察后格式兼容分析，不是新独立实验。',
        '', '必须同时查看FINAL_INTERPRETATION.md的原始主结果、固定策略以及全部失败。若两组回放动作都达到同一最优，则本轮未显示STA在选动作上有额外优势。固定端点规则若同样最优，也不能宣称需要LLM。',
        '', f"兼容回放的归一化中位收益差：{replay['primary_mean_median_gain_difference_percentage_points']:.6f}个百分点。"]
    (out / 'FORMAT_REPLAY.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')
    print(json.dumps(dict(changed=report['changed_count'], groups=replay['groups']), ensure_ascii=False))


if __name__ == '__main__':
    main()
