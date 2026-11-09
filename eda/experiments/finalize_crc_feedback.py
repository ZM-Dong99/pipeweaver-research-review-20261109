"""Export CRC choices and independently repeat full validation; no model calls."""
import json
from pathlib import Path
import shutil
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from eda.experiments.run_crc_feedback import evaluate,validate,sha,load


def finalize(out):
    p=validate(out);r=load(out/'RESULT.json');a=load(out/'AUDIT.json')
    if not a['passed']:raise RuntimeError('Audit must pass before export')
    exports=out/'exports';exports.mkdir(exist_ok=True);choices=[];reproductions=[];cache={}
    for arm in ('baseline','no_sta','sta'):
        candidates=[t for t in r['trials'] if t['arm']==arm and t['improved']]
        if candidates:
            t=min(candidates,key=lambda t:(t['metrics']['max_data_arrival_ns'],t['metrics']['mapped_area_um2'],t['index']))
            source=out/'trials'/f'call_{t["index"]:02d}'/'candidate.v';expected=t['metrics'];call=t['index']
        else:source=out/'inputs/original.v';expected=p['baseline'];call=None
        dest=exports/f'{arm}.v'
        if dest.exists():
            if sha(dest)!=sha(source):raise RuntimeError('Refusing to replace existing choice')
        else:shutil.copyfile(source,dest)
        digest=sha(source);d=out/'independent_reproduction'/digest
        if digest not in cache:
            if d.exists() and not (d/'result.json').exists():
                actual=dict(status='INCOMPLETE',reason='Interrupted EDA not silently replaced')
            else:actual=load(d/'result.json') if (d/'result.json').exists() else evaluate(dest,d)
            cache[digest]=actual
        actual=cache[digest]
        checks={k:actual.get(k)==expected.get(k) for k in ('status','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_cells','mapped_sha256','sdc_sha256','electrical')}
        choices.append(dict(role=arm,source=str(source.relative_to(out)),export=str(dest.relative_to(out)),source_sha256=digest,source_call=call,
             delay_ns=expected['max_data_arrival_ns'],area_um2=expected['mapped_area_um2']))
        reproductions.append(dict(role=arm,passed=all(checks.values()),checks=checks,result=str(d.relative_to(out))))
        print('CRC independent reproduction '+arm+': '+('PASS' if all(checks.values()) else 'FAIL'),flush=True)
    best=min(choices,key=lambda t:(t['delay_ns'],t['area_um2'],t['role']))
    shutil.copyfile(out/best['export'],exports/'best.v')
    (out/'EXPORTS.json').write_text(json.dumps(dict(choices=choices,best_role=best['role'],best_sha256=sha(exports/'best.v'),
         selection='Supplementary observed best qualified candidate; primary remains all-slot median'),indent=2),encoding='utf-8')
    reproduced=all(x['passed'] for x in reproductions)
    (out/'REPRODUCTION.json').write_text(json.dumps(dict(passed=reproduced,new_model_requests=0,unique_eda_runs=len(cache),roles=reproductions),indent=2),encoding='utf-8')
    lines=['# CRC32字节更新：真实模型对照结果','',f'实际尝试{r["attempted"]}/20，剩余{20-r["attempted"]}，完整执行{r["complete"]}；无重试、修复或替换。',
        f'新统一Slang处理链基线{p["baseline"]["max_data_arrival_ns"]:.3f}ns / {p["baseline"]["mapped_area_um2"]:.4f}µm²；旧直接展开流0.97ns不参与本轮评分。','',
        '| 条件 | 返回/尝试 | 合格严格改善/尝试 | 全10槽位回退后中位延迟ns | 不同门级字节哈希 |','|---|---:|---:|---:|---:|']
    for g in r['groups']:
        median=g['median_retained_delay_ns'];formatted=f'{median:.3f}' if median is not None else '未完成，不报告主比较'
        lines.append(f'| {g["arm"]} | {g["generated"]}/{g["attempted"]} | {g["improvements"]}/{g["attempted"]} | {formatted} | {g["unique_mapped_netlists"]} |')
    lines+=['','以下最好候选仅为补充展示，不能替代预定中位数。','',
        '| 角色 | 最好合格延迟ns | 面积µm² | 来源调用 |','|---|---:|---:|---:|']
    for c in choices:lines.append(f'| {c["role"]} | {c["delay_ns"]:.3f} | {c["area_um2"]:.4f} | {c["source_call"] or "原始"} |')
    lines+=['',f'结果分类：{json.dumps(a["outcome_counts"],ensure_ascii=False)}。',
        f'完整响应中{a["responses_reporting_usage"]}份报告total_tokens，合计{a["reported_total_tokens"]}；失败/缺失用量的计费未知，没有金额估算。',
        f'原始及两组选择的独立复跑全部一致：{reproduced}；去重完整复跑{len(cache)}个源码。',
        '','传统逐位控制仅作面积/延迟参照，未提供给模型；其测量1.29ns / 1385.0784µm²，不能算作时序改善或模型结果。',
        '源级/门级未通过可能包含工具超时或结构拒绝，不能一概称功能错误；具体日志保留。',
        '只覆盖一个组合CRC32字节更新实例，不是完整MAC、较大工程系统、统计显著性或跨设计泛化证明；性能为固定SKY130HD TT/IO约束下预布局估计。',
        '','证据：protocol.json、AUTHORIZATION.json、GENERATION_SUMMARY.json、RESULT.json、AUDIT.json、EXPORTS.json、REPRODUCTION.json、trials/、evaluations/。',
        'exports/的原始及模型RTL需使用本实验统一Slang流程验证，不直接套用前三类候选库的旧前端。']
    (out/'RESULT_SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')


if __name__=='__main__':finalize(Path(sys.argv[1]).resolve())
