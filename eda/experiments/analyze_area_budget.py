"""Post-hoc budgets and Pareto choices from existing sequential measurements only."""
import argparse
import hashlib
import json
import math
from pathlib import Path
import shutil

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def qualified(m):
    return (m.get('status')=='PASS' and m.get('eligible') is True and
            all(m.get(k)=='PASS' for k in ('formal','mapped_formal','ppa')) and
            m.get('electrical',{}).get('status')=='PASS')
def choose(points,baseline,percent):
    cap=baseline['area_um2']*(1+percent/100)
    valid=[p for p in points if p['area_um2']<=cap+1e-9 and p['tns_ns']>=baseline['tns_ns']-1e-9]
    return min(valid,key=lambda p:(-p['wns_ns'],p['area_um2'],p['id']))

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path)
    ap.add_argument('--out',type=Path,required=True)
    ap.add_argument('--budgets',nargs='+',type=float,default=[0,5,10,15,20,25,30])
    a=ap.parse_args();s=a.study.resolve();out=a.out.resolve()
    if not all(math.isfinite(x) and x>=0 for x in a.budgets):ap.error('Budgets must be finite nonnegative percentages')
    p=load(s/'protocol.json');summary=load(s/'summary.json')
    original={name:sha(s/name) for name in ('protocol.json','summary.json','candidate_manifest.json')}
    assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().strip()
    assert load(s/'AUDIT.json')['passed']
    assert qualified(p['baseline_metrics'])
    out.mkdir(parents=True,exist_ok=False)
    base=dict(id='baseline',arm='baseline',source=str(s/'inputs/original.v'),wns_ns=p['baseline_metrics']['wns_ns'],tns_ns=p['baseline_metrics']['tns_ns'],area_um2=p['baseline_metrics']['mapped_area_um2'])
    points=[base]
    for row in summary['results']:
        m=row['metrics']
        # Use actual proof/electrical eligibility, not the original area-dependent acceptance.
        if m is None or not qualified(m):continue
        source=s/row['arm']/row['candidate_id']/'candidate.v'
        assert sha(source)==row['candidate_sha256']
        points.append(dict(id=row['arm']+'/'+row['candidate_id'],arm=row['arm'],source=str(source),wns_ns=m['wns_ns'],tns_ns=m['tns_ns'],area_um2=m['mapped_area_um2']))
    budgets=sorted(set(a.budgets));sweep=[]
    for budget in budgets:
        selected={arm:choose([x for x in points if x['arm'] in (arm,'baseline')],base,budget) for arm in p['arms']}
        sweep.append(dict(maximum_area_increase_percent=budget,area_cap_um2=base['area_um2']*(1+budget/100),selected=selected))
    front=[x for x in points if not any(y['area_um2']<=x['area_um2'] and y['wns_ns']>=x['wns_ns'] and (y['area_um2']<x['area_um2'] or y['wns_ns']>x['wns_ns']) for y in points if y is not x)]
    front.sort(key=lambda x:x['area_um2'])
    exports=out/'pareto_choices';exports.mkdir()
    for i,x in enumerate(front,1):
        dest=exports/f'arbiter_choice_{i:02d}.v';shutil.copyfile(x['source'],dest);x['export']=str(dest.relative_to(out));x['export_sha256']=sha(dest)
    shutil.copyfile(s/'inputs/priority_encoder.v',exports/'priority_encoder.v');shutil.copyfile(s/'inputs/UPSTREAM_COPYING',exports/'UPSTREAM_COPYING')
    (exports/'CONTRACT.json').write_text(json.dumps(p['contract'],indent=2),encoding='utf-8')
    minimum={}
    for arm in p['arms']:
        improvements=[x for x in points if x['arm']==arm and x['wns_ns']>base['wns_ns']+1e-9]
        minimum[arm]=min((100*(x['area_um2']/base['area_um2']-1) for x in improvements),default=None)
    result=dict(scope='Post-hoc re-ranking of the same six actual candidates; no new generation, synthesis or STA',
        new_model_requests=0,new_rtl_candidates=0,new_eda_runs=0,original_study=str(s),source_sha256=original,
        original_area_cap_um2=p['area_cap_um2'],budgets=sweep,pareto_front=front,
        minimum_measured_area_increase_for_strict_gain_percent=minimum,
        caution='Old prompts specified the old budget. Re-ranking cannot predict what a model would generate under a different prompt/budget. Original primary results remain unchanged.')
    (out/'RESULTS.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
    lines=['# 面积预算敏感性：同一批真实仲裁器候选','',
        '10%来自原实验的预设对照规则，不是行业标准。本分析只重排已经验证的候选，不重跑模型或EDA，不改写原10%主实验结论。','',
        '| 允许模块面积增加 | 无反馈组选中WNS ns | 实际面积增加 | STA组选中WNS ns | 实际面积增加 |','|---:|---:|---:|---:|---:|']
    for row in sweep:
        l=row['selected']['no_timing_feedback'];g=row['selected']['actual_paths']
        lines.append(f'| {row["maximum_area_increase_percent"]:g}% | {l["wns_ns"]:.2f} | {100*(l["area_um2"]/base["area_um2"]-1):+.2f}% | {g["wns_ns"]:.2f} | {100*(g["area_um2"]/base["area_um2"]-1):+.2f}% |')
    lines+=['','WNS越大越好；基线7.80ns已满足记录的10ns时钟，改善WNS不等于已验证相同比例的频率提升。','',
        '## 真实权衡','',
        f'这批候选首次出现严格时序收益所需的额外面积：无反馈约{minimum["no_timing_feedback"]:.2f}%，STA约{minimum["actual_paths"]:.2f}%。这些是所采候选的门槛，不是电路的理论最优下界。',
        '', '15%预算时STA组可选8.06ns，原无反馈候选仍超限；25%预算时无反馈组可选8.29ns、STA组8.06ns；30%时分别8.29与8.22ns。哪组更好随预算而变，不能事后挑一个预算宣称普遍获胜。',
        '', 'pareto_choices导出未被其他实际候选同时在面积与WNS上压过的原始RTL字节，保留固定helper与CONTRACT.json；这叫面积/时序帕累托选择，不是新的自动生成算法。',
        '', '## 解释边界','',
        '原六次请求的提示包含10%预算；本分析不代表如果一开始提示15%或25%，模型仍会生成同样的代码。下一次比较须提前固定预算，两组用同一规则，报告全部结果。',
        '', '硬件工程根据具体时序目标、模块/芯片面积、功耗及实现可行性确定预算，没有统一的模块面积增加10%规则；这里的面积是映射单元估计，不是芯片裸片面积或布局布线签核。',
        '', '官方工具也支持可配置的约束与时序/面积权衡，参见[OpenROAD Gate Resizer](https://openroad.readthedocs.io/en/latest/main/src/rsz/README.html)。其中max_utilization指核心利用率，不等于本实验相对基线的面积增幅，不能混为同一百分比。','']
    (out/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
    assert all(sha(s/name)==h for name,h in original.items()),'Original results changed'
    shutil.copyfile(Path(__file__),out/'analysis_used.py')
    print(json.dumps({'minimum_area_increase':minimum,'pareto_choices':len(front),'original_preserved':True,'new_model_requests':0},ensure_ascii=False))

if __name__=='__main__':main()
