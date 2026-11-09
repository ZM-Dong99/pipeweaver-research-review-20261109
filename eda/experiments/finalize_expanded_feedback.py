"""Export observed choices and independently re-run them; never calls an API."""
import hashlib
import json
from pathlib import Path
import shutil
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from eda.experiments.run_expanded_feedback import evaluate,validate

load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()


def finalize(out):
    p=validate(out);r=load(out/'RESULT.json');audit=load(out/'AUDIT.json')
    if not audit['passed']:raise RuntimeError('Audit must pass before export')
    exports=out/'exports';exports.mkdir(exist_ok=True)
    rows=[];reproductions=[];cache={}
    for case in p['cases']:
        c=case['id'];folder=exports/c;folder.mkdir(exist_ok=True)
        for role in ('baseline','no_sta','sta'):
            items=[t for t in r['trials'] if t['case']==c and t['arm']==role and t['improved']]
            if items:
                selected=min(items,key=lambda t:(t['metrics']['max_data_arrival_ns'],t['metrics']['mapped_area_um2'],t['index']))
                source=out/'trials'/f'call_{selected["index"]:03d}'/'candidate.v';expected=selected['metrics'];index=selected['index']
            else:
                source=out/'inputs'/f'{c}.v';expected=case['baseline'];index=None
            dest=folder/f'{role}.v'
            if dest.exists():
                if sha(dest)!=sha(source):raise RuntimeError('Refusing to replace prior export')
            else:shutil.copyfile(source,dest)
            key=(c,sha(source));repro_dir=out/'independent_reproduction'/f'{c}_{sha(source)}'
            if key not in cache:
                if repro_dir.exists() and not (repro_dir/'result.json').exists():
                    measured={'status':'INCOMPLETE','reason':'Interrupted reproduction is not silently rerun'}
                else:
                    measured=load(repro_dir/'result.json') if (repro_dir/'result.json').exists() else evaluate(dest,out/'inputs'/f'{c}.v',case,repro_dir)
                cache[key]=measured
            actual=cache[key]
            checks={k:actual.get(k)==expected.get(k) for k in ('status','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_cells','mapped_sha256','sdc_sha256','electrical')}
            entry=dict(case=c,role=role,source=str(source.relative_to(out)),export=str(dest.relative_to(out)),
                       source_sha256=sha(source),source_call=index,selected_delay_ns=expected['max_data_arrival_ns'],
                       selected_area_um2=expected['mapped_area_um2'])
            rows.append(entry);reproductions.append(dict(case=c,role=role,passed=all(checks.values()),checks=checks,result=str(repro_dir.relative_to(out))))
            print(f'Independent reproduction {c}/{role}: '+('PASS' if all(checks.values()) else 'FAIL'),flush=True)
    (out/'EXPORTS.json').write_text(json.dumps(dict(choices=rows,selection='Observed best eligible draw for supplementary export; primary remains all-slot median'),indent=2),encoding='utf-8')
    (out/'REPRODUCTION.json').write_text(json.dumps(dict(passed=all(x['passed'] for x in reproductions),new_model_requests=0,unique_eda_runs=len(cache),roles=reproductions),indent=2),encoding='utf-8')
    lines=['# 80次扩样实验：实际结果','',
        f'实际尝试{r["attempted"]}/80；剩余{80-r["attempted"]}。完整执行：{r["complete"]}。无自动重试。',
        '四种都是已暴露的正收益开发案例；本轮不是新工程电路、留出集或跨模型比较。','',
        '| 电路 | 条件 | 返回/尝试 | 合格改进/尝试 | 全10槽位回退后中位延迟ns | 独特门级网表 |',
        '|---|---|---:|---:|---:|---:|']
    for g in r['groups']:
        median=g['median_retained_delay_ns']
        lines.append(f'| {g["case"]} | {g["arm"]} | {g["generated"]}/{g["attempted"]} | {g["improvements"]}/{g["attempted"]} | {median if median is not None else "未完成，不报告主比较"} | {g["unique_mapped_netlists"]} |')
    lines += ['',f'完整响应中{audit["responses_reporting_usage"]}份报告total_tokens，合计{audit["reported_total_tokens"]}；失败或未报告用量的费用未知。',
              '只统计提供的token数，不估算人民币费用。协议请求完成token总上限不是实际账单，也不是已验证的网关强制上限。','',
              'exports/包含每种电路原始、无STA、STA的观察到的最好合格候选；没有合格改进则导出原始。最好候选用于补充展示，不替代中位数主指标。',
              f'独立复跑结果：{all(x["passed"] for x in reproductions)}；去重完整复跑{len(cache)}个RTL/案例组合。',
              '形式证明/EDA复跑不是新增模型样本。性能为固定库/约束下综合后预布局估计，不作普遍或统计显著优势断言。','',
              '证据：protocol.json、AUTHORIZATION.json、GENERATION_SUMMARY.json、RESULT.json、AUDIT.json、EXPORTS.json、REPRODUCTION.json、trials/和evaluations/。']
    (out/'RESULT_SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')


if __name__=='__main__':finalize(Path(sys.argv[1]).resolve())
