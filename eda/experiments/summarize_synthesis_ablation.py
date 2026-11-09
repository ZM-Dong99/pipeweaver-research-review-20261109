"""Summarize a completed three-arm synthesis-feedback study from raw records."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("study",type=Path)
    args=ap.parse_args(); s=args.study.resolve()
    protocol=load(s/"protocol.json"); raw=load(s/"summary.json"); audit=load(s/"AUDIT.json")
    vectors=load(s/"independent_vector_validation/SUMMARY.json")
    assert audit["status"]=="PASS"
    context=load(s/protocol["synthesis_context"]["path"])
    assert context["reference_rtl_sha256"]==protocol["baseline_sha256"]
    rows=[load(s/r["arm"]/r["candidate_id"]/"result.json") for r in load(s/"candidate_manifest.json")["slots"]]
    assert len(rows)==9
    simulated={r["candidate"]:r for r in vectors["results"]}
    assert simulated["baseline"]["status"]=="PASS"
    for r in rows:
        if r["candidate_sha256"] and r["formal"]=="PASS":
            assert simulated[r["arm"]+"_"+r["candidate_id"]]["status"]=="PASS", "Simulation contradicts source formal PASS"
    base=protocol["baseline_metrics"]; cap=base["mapped_area_um2"]*1.1
    labels={"no_timing_feedback":"无时序反馈","path_and_rtl_chain":"原路径反馈","path_and_synthesis_context":"路径＋综合后结构"}
    output=s/"selected_outputs"; output.mkdir(exist_ok=False)
    groups={}; selections={}; usage=[]
    for arm in protocol["arms"]:
        rr=[r for r in rows if r["arm"]==arm]
        eligible=[r for r in rr if r["eligible"]]
        best=min(eligible,key=lambda r:r["metrics"]["max_data_arrival_ns"]) if eligible else None
        improved=[r for r in rr if r["valid_improvement"]]
        selected=min(improved,key=lambda r:r["metrics"]["max_data_arrival_ns"]) if improved else None
        groups[arm]={"scheduled":len(rr),"generated":sum(bool(r["candidate_sha256"]) for r in rr),
                     "source_formal_pass":sum(r["formal"]=="PASS" for r in rr),
                     "mapped_formal_pass":sum(r.get("metrics",{}).get("mapped_formal")=="PASS" for r in rr),
                     "electrical_pass":sum(r.get("metrics",{}).get("electrical",{}).get("status")=="PASS" for r in rr),
                     "eligible":len(eligible),"strict_gains":sum(r["valid_improvement"] for r in rr),
                     "gains_ge5pct":sum(r["meaningful_gain"] for r in rr),
                     "best_candidate_id":best["candidate_id"] if best else None,
                     "best_candidate_delay_ns":best["metrics"]["max_data_arrival_ns"] if best else None,
                     "best_candidate_area_um2":best["metrics"]["mapped_area_um2"] if best else None}
        source=s/arm/selected["candidate_id"]/"candidate.v" if selected else s/"baseline/original.v"
        m=selected["metrics"] if selected else base
        rec={"source":"candidate" if selected else "baseline_retained","source_path":str(source.relative_to(ROOT)),
             "source_sha256":sha(source),"candidate":selected["candidate_id"] if selected else None,
             "delay_ns":m["max_data_arrival_ns"],"area_um2":m["mapped_area_um2"],
             "reason":"Strict eligible timing improvement" if selected else "No strict eligible improvement; baseline retained"}
        dst=output/arm; dst.mkdir()
        shutil.copyfile(source,dst/"addr_calcu.v")
        (dst/"SOURCE.json").write_text(json.dumps(rec,ensure_ascii=False,indent=2),encoding="utf-8")
        selections[arm]=rec
        if best:
            reproduction=load(s/"independent_eda_reproduction"/arm/"result.json")
            assert reproduction["status"]==reproduction["formal"]==reproduction["mapped_formal"]==reproduction["electrical"]["status"]=="PASS"
            for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256"):
                assert reproduction[k]==best["metrics"][k],(arm,k)
    for r in rows:
        m=r.get("metrics",{})
        if m.get("ppa")=="PASS":
            expected=(m["status"]=="PASS" and m["formal"]==m.get("mapped_formal")==m.get("electrical",{}).get("status")=="PASS"
                      and m["mapped_area_um2"]<=cap+1e-9)
            assert bool(r["eligible"])==expected
            assert bool(r["valid_improvement"])==(expected and m["max_data_arrival_ns"]<base["max_data_arrival_ns"])
        rp=s/r["arm"]/r["candidate_id"]/"api_audit/response.json"
        if rp.exists():
            response=load(rp); u=response.get("usage",{})
            usage.append({"arm":r["arm"],"candidate":r["candidate_id"],"raw":u,
                          "input_plus_output":u.get("prompt_tokens",0)+u.get("completion_tokens",0),
                          "reported_total_matches_input_plus_output":u.get("total_tokens")==u.get("prompt_tokens",0)+u.get("completion_tokens",0)})
    winner=min(selections,key=lambda a:selections[a]["delay_ns"])
    bestdir=s/"best_verified_rtl"; bestdir.mkdir(exist_ok=False)
    shutil.copyfile(ROOT/selections[winner]["source_path"],bestdir/"addr_calcu.v")
    (bestdir/"SOURCE.json").write_text(json.dumps({"arm":winner,**selections[winner]},ensure_ascii=False,indent=2),encoding="utf-8")
    reproduction_base=load(s/"independent_eda_reproduction/baseline/result.json")
    assert reproduction_base["max_data_arrival_ns"]==base["max_data_arrival_ns"]
    assert reproduction_base["mapped_sha256"]==base["mapped_sha256"]
    enhanced=selections["path_and_synthesis_context"]
    contrasts={}
    for other in ("no_timing_feedback","path_and_rtl_chain"):
        o=selections[other]
        contrasts[other]={"enhanced_delay_reduction_pct":100*(o["delay_ns"]-enhanced["delay_ns"])/o["delay_ns"],
                          "enhanced_area_change_pct":100*(enhanced["area_um2"]/o["area_um2"]-1)}
    evidence={"frozen_protocol_sha256":sha(s/"protocol.json"),"groups":groups,"selected_outputs":selections,
              "enhanced_vs_controls":contrasts,"winner_by_frozen_timing_objective":winner,
              "requests":len(rows),"response_envelopes":audit["response_envelopes"],
              "provider_reported_tokens":raw["total_reported_tokens"],"usage":usage,
              "verified_charge_total":None,"audit_passed_checks":audit["passed_checks"],
              "independent_vectors_per_rtl":vectors["vectors_per_rtl"],"simulated_rtls":len(vectors["results"]),
              "independent_reproduction":"PASS",
              "limitations":"Development case selected after observing previous results; three attempts per arm, unequal token counts, provider routing identity unverified, pre-layout only.",
              "synthesis_context_hash":sha(s/protocol["synthesis_context"]["path"])}
    (s/"EVIDENCE_CHAIN.json").write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding="utf-8")
    lines=["# 综合后结构反馈三组消融（2026-10-30）","",
           "三组各三次真实请求；同一模型标识、请求参数、curl 传输、原始 RTL、映射与约束、面积上限。全部候选先生成并冻结，再统一评估。没有重试、补样或根据中途成绩修改提示。",
           "",
           f"基线：{base['max_data_arrival_ns']:.2f} ns，面积 {base['mapped_area_um2']:.4f} µm²；固定上限 {cap:.6f} µm²。","",
           "| 条件 | 生成 | 面积/功能/电气合格 | 严格改善 | 至少5%改善 | 最佳合格候选 | 保留基线后选择 | 选择面积 µm² |",
           "|---|---:|---:|---:|---:|---:|---:|---:|"]
    for arm,g in groups.items():
        delay=f"{g['best_candidate_delay_ns']:.2f} ns" if g["best_candidate_delay_ns"] is not None else "无合格候选"
        selected=selections[arm]
        lines.append(f"| {labels[arm]} | {g['generated']}/3 | {g['eligible']}/3 | {g['strict_gains']}/3 | {g['gains_ge5pct']}/3 | {delay} | {selected['delay_ns']:.2f} ns | {selected['area_um2']:.4f} |")
    lines += ["","## 当前样本的比较",""]
    for other,c in contrasts.items():
        change=c["enhanced_delay_reduction_pct"]
        description="低" if change>0 else "高" if change<0 else "相同"
        lines.append(f"- 新反馈对比{labels[other]}的最终选择：延迟{'相同' if change==0 else description+f' {abs(change):.4f}%'}；面积变化 {c['enhanced_area_change_pct']:+.4f}%。面积权衡与延迟必须一起报告，不是同面积对照。")
    lines += ["",
              "正值时序收益只描述当前样本，不建立统计显著性；负值或打平也保留。最终选择保留原始基线，候选不改善或不合格时不会导出退化结果。",
              "",
              "## 全部九槽位","",
              "| 条件/候选 | 生成 | 源级/门级 | 电气 | 延迟 ns | 面积 µm² | 合格/严格改善 |",
              "|---|---|---|---|---:|---:|---|"]
    for r in sorted(rows,key=lambda r:(r["arm"],r["candidate_id"])):
        m=r.get("metrics",{})
        delay=f"{m['max_data_arrival_ns']:.2f}" if m.get("max_data_arrival_ns") is not None else "—"
        area=f"{m['mapped_area_um2']:.4f}" if m.get("mapped_area_um2") is not None else "—"
        lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | {r['status']} | {r['formal']}/{m.get('mapped_formal','未完成')} | {m.get('electrical',{}).get('status','未完成')} | {delay} | {area} | {'是' if r['eligible'] else '否'}/{'是' if r['valid_improvement'] else '否'} |")
    lines += ["",
              "## 新反馈实际包含什么",
              "",
              "新组的完整提示以原路径组提示为前缀，只追加当前原始基线重新生成的综合阶段事实：资源共享事件、中间结构计数、由控制端到输出的保守整单元连接链、源码属性缺失信息及额外完整输入等价证明。",
              "两组旧控制提示与上一轮地址电路的哈希相同。新证据没有上一轮生成 RTL、公开优化参考代码或候选成绩；提示不是在看到本轮结果后修改的。证据文件与新编码器均在运行前冻结。",
              "这个图位于 coarse/fine 起始优化后、门级 techmap 之前，不是最终标准单元图。整单元连接不是位级敏化路径，三个 $alu 不等于最终三个串行加法器；新建 mux 的源码归属缺失保留 null。",
              "",
              "## 核查与局限",
              "",
              f"- {audit['passed_checks']} 项实际文件/请求/响应/证明/映射/时序/电气及综合证据审计通过，收到 {audit['response_envelopes']} 份响应；未返回或解析失败仍在九槽位分母。",
              f"- 对基线与全部实际生成 RTL 各安排 {vectors['vectors_per_rtl']} 组独立 Python 真值/Icarus 仿真：{sum(r['status']=='PASS' for r in vectors['results'])} 份完整通过，{sum(r['status']!='PASS' for r in vectors['results'])} 份失败。失败日志保留；不会把功能错误的候选计为通过。有限仿真不代替全输入 SAT；默认 base=128，非默认参数不在本协议证明范围。",
              "- 基线与各组最佳合格候选在新目录完整重跑 EDA，指标和门级网表哈希一致。所有接受的候选要求源级与映射后完整等价、电气零报告违例、面积合格及严格时序改善。",
              f"- 服务方原始响应共报告 {raw['total_reported_tokens']} tokens。分项算术异常逐份保留，未独立核实账单；各组提示长度不同，不是等 token 或等模型计算量实验。",
              "- 这是在旧路径反馈负结果后提出的开发阶段测试，不是留出集。三次请求/组样本很小，不能证明因果机制、普遍胜率、模型身份或方法新颖性；增加结构事实与精度说明的影响尚未再拆分。",
              "- 中转站以 gpt-6.1-sol 标识模型，实际后端版本/路由未独立验证；全部结果为固定 SKY130HD 库/约束下的预布局结果，不是物理签核。",
              "",
              "## 文件入口",
              "",
              "- protocol.json、prompts/、candidate_manifest.json：冻结条件、完整提示与评估前候选。",
              "- baseline/synthesis_context/：真实综合阶段 JSON、变换日志、intermediate_formal.log、context.json。",
              "- 各条件 candidate_XX/api_audit/：真实请求/可见响应；evaluation/eda/：形式、映射、STA、电气原始日志。",
              "- AUDIT.json、independent_vector_validation/、independent_eda_reproduction/：审计、独立仿真、独立完整 EDA。",
              "- selected_outputs/：各组不退化的实际输出；best_verified_rtl/：按冻结时序目标选择的整体最低延迟设计。",
              "- EVIDENCE_CHAIN.json：完整数值、面积权衡、用量异常和选择追溯。",""]
    (s/"INTERPRETATION.md").write_text("\n".join(lines),encoding="utf-8")
    print(json.dumps({"report":str(s/"INTERPRETATION.md"),"groups":groups,"selected":selections,
                      "new_vs_controls":contrasts,"audit":audit["status"]},ensure_ascii=False))
if __name__=="__main__":
    main()

