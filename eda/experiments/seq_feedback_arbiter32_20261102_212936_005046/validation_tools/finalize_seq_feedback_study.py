"""Audit and independently reproduce sequential feedback selections; no model calls."""
import argparse
import json
from pathlib import Path
import shutil
from run_seq_feedback_study import validate,evaluate,load,save,sha

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve()
    p=load(s/'protocol.json');summary=load(s/'summary.json')
    if not load(s/'AUDIT.json')['passed']:raise RuntimeError('Evidence audit required before independent replay')
    validate(s,p)
    tasks=[('baseline',s/'inputs/original.v',p['baseline_metrics'])]
    for arm,group in summary['groups'].items():tasks.append((arm,s/'selected'/arm/'arbiter.v',group['selected_metrics']))
    replays=[]
    for label,source,metrics in tasks:
        validate(s,p);folder=s/'independent_reproduction'/label;folder.parent.mkdir(exist_ok=True)
        actual=evaluate(source,folder,s,p['timeout_seconds'])
        keys=['status','formal','mapped_formal','ppa','wns_ns','tns_ns','mapped_area_um2','mapped_cells','mapped_sha256','sdc_sha256','electrical']
        comparison={k:actual.get(k)==metrics.get(k) for k in keys}
        replays.append(dict(label=label,source=str(source),source_sha256=sha(source),passed=all(comparison.values()),comparison=comparison,actual=actual))
        print('Independent replay '+label+': '+str(replays[-1]['passed']),flush=True)
    save(s/'REPRODUCTION.json',dict(passed=all(x['passed'] for x in replays),replays=replays,new_model_requests=0))
    lines=['# 32路轮询仲裁器：真实反馈对照结果','',
        '公开原始arbiter.v＋固定priority_encoder.v；PORTS=32、轮询、应答阻塞。单正边沿时钟、同步高有效复位第1采样有效，此后输入任意；从第2采样点起保持原始逐拍输出。只有固定参数实例，不含公平性/无饥饿性质证明。','',
        '| 条件 | 返回/请求 | 合格严格改善 | 最终选中WNS ns | 选中面积µm² | 选择来源 |','|---|---:|---:|---:|---:|---|']
    for arm,g in summary['groups'].items():
        m=g['selected_metrics'];lines.append(f'| {arm} | {g["returned"]}/3 | {g["valid_improvements"]}/3 | {m["wns_ns"]:.2f} | {m["mapped_area_um2"]:.4f} | {g["selected_origin"]} |')
    b=p['baseline_metrics'];lines+=['',f'原始基线WNS {b["wns_ns"]:.2f}ns、面积{b["mapped_area_um2"]:.4f}µm²；固定面积上限{p["area_cap_um2"]:.5f}µm²。WNS越大越好，但不能用WNS百分比冒充频率提升，也不能与组合到达时间直接相加。','',
        '## 全部请求与候选','', '| 条件/槽位 | 生成 | 形式 | 门级证明 | PPA | WNS ns | 面积µm² | 严格改善 |','|---|---|---|---|---|---:|---:|---|']
    for r in summary['results']:
        m=r['metrics'] or {};lines.append(f'| {r["arm"]}/{r["candidate_id"]} | {r["status"]} | {m.get("formal","NOT_RUN")} | {m.get("mapped_formal","NOT_RUN")} | {m.get("ppa","NOT_RUN")} | {m.get("wns_ns","—")} | {m.get("mapped_area_um2","—")} | {r["accepted"]} |')
    lines+=['','## 失败、拒绝和边界','']
    for r in summary['results']:
        if not r['accepted']:lines.append('- '+r['arm']+'/'+r['candidate_id']+': '+r['reason']+'; '+str(r.get('error') or (r.get('metrics') or {}).get('failure_reason','')))
    lines+=['',
        '所有请求独立且交错，无前一候选或EDA结果进入提示。两组公共提示完全相同，STA组只增加基线时序与3条原始路径。全部候选生成并冻结后再统一评估，每份候选都对最初原始RTL证明。没有重试或补发；无合格改善时保留基线。',
        '', '原始调用在各槽位api_audit/；代码、源级/门级归纳证明、映射与STA在candidate.v和eda/；AUDIT.json核查实际请求/响应及测量，REPRODUCTION.json核查独立复跑。证据核对项不是独立实验数量。',
        '', '只有一个仲裁器配置，每组3次探索性请求；helper在此前优先编码器实验中出现过，不能视为完全独立的随机电路或模型训练盲测。即使某组胜出也不建立普遍或统计显著性结论。网关模型名不能独立证明实际后端身份。',
        '', '时序为固定SKY130HD TT、10ns理想时钟、零最大外部IO延迟、0.10ns转换和0.010pF负载的预布局估计，没有布线寄生/功耗/hold签核。完整等价仅在记录的启动和参数条件成立。','']
    (s/'FINAL_INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
    v=s/'validation_tools';v.mkdir(exist_ok=True)
    for f in [Path(__file__),Path(__file__).with_name('audit_seq_feedback_study.py')]:shutil.copyfile(f,v/f.name)
    return 0 if all(x['passed'] for x in replays) else 1

if __name__=='__main__':raise SystemExit(main())
