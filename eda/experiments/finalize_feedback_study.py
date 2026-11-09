"""Export fixed-policy selections and independently repeat EDA, never calling an LLM."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
from run_native_mul_three_arm import ROOT, run_eval
from audit_feedback_ablation import audit

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):p.write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path)
    s=ap.parse_args().study.resolve();p=load(s/'protocol.json');summary=load(s/'summary.json')
    if p.get('profile')!='priority256':raise ValueError('This report template currently covers the frozen priority256 profile only')
    if audit(s):raise RuntimeError('Raw experiment evidence audit failed')
    def verify():
        assert sha(s/'protocol.json')==(s/'protocol.sha256').read_text().split()[0]
        assert all(sha(ROOT/f)==h for f,h in p['dependency_sha256'].items())
        assert sha(ROOT/p['baseline_rtl'])==p['baseline_sha256']
    verify()
    out=s/'verified_selections';out.mkdir(exist_ok=False)
    shutil.copyfile(Path(__file__),out/'finalizer_used.py')
    save(out/'finalizer_sha256.json',{'sha256':sha(Path(__file__))})
    base=p['baseline_metrics'];cap=base['mapped_area_um2']*1.10
    selections=[dict(label='baseline',source=s/'baseline/original.v',metrics=base,origin='baseline')]
    rows=[]
    for arm in p['arms']:
        candidates=[]
        for slot in p['call_schedule']:
            if slot['arm']!=arm:continue
            folder=s/arm/slot['candidate_id'];r=load(folder/'result.json');m=r.get('metrics',{})
            usable=(r.get('eligible') and m.get('formal')=='PASS' and m.get('mapped_formal')=='PASS'
                    and m.get('ppa')=='PASS' and m.get('electrical',{}).get('status')=='PASS'
                    and m['mapped_area_um2']<=cap+1e-9)
            if usable:candidates.append((m['max_data_arrival_ns'],m['mapped_area_um2'],slot['candidate_id'],folder/'candidate.v',m))
            rows.append(dict(arm=arm,candidate_id=slot['candidate_id'],generation_status=r['status'],
                formal=r['formal'],ppa=r['ppa'],eligible=bool(usable),metrics=m,error=r.get('error')))
        candidates.sort(key=lambda x:x[:3])
        if candidates and candidates[0][0]<base['max_data_arrival_ns']:
            _,_,cid,source,m=candidates[0];selections.append(dict(label=arm,source=source,metrics=m,origin=cid))
        else:selections.append(dict(label=arm,source=s/'baseline/original.v',metrics=base,origin='baseline_retained'))
    exported=[]
    for item in selections:
        verify();folder=out/item['label'];folder.mkdir()
        target=folder/(p['top']+'.v');shutil.copyfile(item['source'],target)
        save(folder/'selection.json',dict(source=str(item['source']),origin=item['origin'],
             sha256=sha(target),metrics=item['metrics'],fixed_area_cap_um2=cap))
        code,_,elapsed=run_eval(target,folder/'independent_reproduction',p['timeout_per_tool_seconds'],
            reference=ROOT/p['baseline_rtl'],top=p['top'],mapping_policy=p['mapping_policy'],
            cleanup_before_buffer=p.get('abc_cleanup_before_buffer',False),parameters=p.get('parameter_overrides',{}))
        actual=load(folder/'independent_reproduction/eda/result.json')
        keys=['formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_cells','electrical','mapped_sha256','sdc_sha256']
        comparison={k:actual.get(k)==item['metrics'].get(k) for k in keys}
        repeated=code==0 and all(comparison.values())
        exported.append(dict(label=item['label'],origin=item['origin'],rtl=str(target.relative_to(s)),
            rtl_sha256=sha(target),metrics=item['metrics'],reproduction_passed=repeated,
            reproduction_comparison=comparison,reproduction_seconds=elapsed))
        save(out/'REPRODUCTION.json',dict(all_passed=all(x['reproduction_passed'] for x in exported),selections=exported))
        print('Independent reproduction '+item['label']+': '+str(repeated),flush=True)
    verify()
    lines=['# 新家族反馈对照：真实结果与独立复现','',
        '本轮仅执行预先批准的两组各3次独立请求；没有反馈迭代或追加请求。公开priority_encoder的固定WIDTH=256、LSB_HIGH_PRIORITY=0实例，所有输出包括无效输入时的输出均须精确等价。','',
        '| 条件 | 生成RTL | 源级证明通过 | 面积/电气合格 | 保留基线后选中到达时间ns | 选中面积µm² |','|---|---:|---:|---:|---:|---:|']
    for item in exported[1:]:
        g=summary['groups'][item['label']];m=item['metrics']
        lines.append(f'| {item["label"]} | {g["generated"]}/3 | {g["formal_pass"]}/3 | {g["area_eligible"]}/3 | {m["max_data_arrival_ns"]:.2f} | {m["mapped_area_um2"]:.4f} |')
    left,right=exported[1:];lm,rm=left['metrics'],right['metrics']
    difference=100*(lm['max_data_arrival_ns']-rm['max_data_arrival_ns'])/lm['max_data_arrival_ns']
    lines+=['',f'原始基线：{base["max_data_arrival_ns"]:.2f}ns，面积{base["mapped_area_um2"]:.4f}µm²；共同面积上限{cap:.5f}µm²。',
        f'按协议的最佳合格结果，STA组相对无反馈组的到达时间差为{difference:+.2f}%（正数表示STA组更短，负数表示更长）。必须同时查看面积，不能把时间差说成所有指标都更优。','',
        '## 全部六个槽位','', '| 条件/槽位 | 生成状态 | 形式 | PPA | 面积/电气合格 | 到达时间ns | 面积µm² |','|---|---|---|---|---|---:|---:|']
    for row in rows:
        m=row['metrics'];lines.append(f'| {row["arm"]}/{row["candidate_id"]} | {row["generation_status"]} | {row["formal"]} | {row["ppa"]} | {row["eligible"]} | {m.get("max_data_arrival_ns","—")} | {m.get("mapped_area_um2","—")} |')
    failures=[row for row in rows if row['error']]
    if failures:
        lines+=['','## 请求失败及解释边界','']
        for row in failures:lines.append(f'- {row["arm"]}/{row["candidate_id"]}: {row["error"]}')
        lines+=['', '这些槽位没有有效RTL，不能计作功能错误或性能劣化，也没有额外补请求。若两组实际返回数量不同，固定请求预算下的结果仍可记录，但不能把最佳值差异单独归因于STA信息；服务失败或生成耗时可能影响可用候选数量，原因无法从错误码独立判定。']
    lines+=['','## 证据与限制','',
        '- protocol.json与code_snapshot是运行前冻结条件；prompts是两组待发送全文，公共前缀完全相同。无反馈组只缺少测量时序和路径，工具、功能、参数与面积信息相同。',
        '- 每槽位api_audit/request.json和response.json保存实际调用；candidate.v与返回内容的对应由AUDIT.json核对。模型名称只是网关声明。',
        '- candidate_manifest.json在所有候选生成之后、EDA评估之前冻结；各evaluation/eda保留源级与门级证明、映射及OpenSTA原始日志。失败留在分母中。',
        '- verified_selections每组导出最佳合格RTL；无改善时保留原基线。REPRODUCTION.json逐项记录独立重跑是否一致，失败不会改写为成功。',
        f'- 提供方响应共报告{summary["total_reported_tokens"]} tokens，不是独立核实账单。相同请求预算不等于相同tokens或费用。',
        '- 只有一个新家族、每组3次随机调用。最好值差异不是统计显著性，也不能单独证明一般方法优势；源代码公开，无法保证未进入模型训练。',
        '- 默认工艺角的预布局估计，无布线寄生或功耗签核。仅证明记录的256位实例，不泛化到所有参数。',
        '- 本次检验的是基线STA信息的价值，不是新的约束搜索算法或自适应闭环的完整对照。没有预设获胜组，也不因结果增加提示或请求。','']
    (s/'FINAL_INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
    return 0 if all(x['reproduction_passed'] for x in exported) else 1

if __name__=='__main__':raise SystemExit(main())
