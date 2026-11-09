"""Interpret actual address-circuit study and export only non-regressing selections."""
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
    args=ap.parse_args()
    s=args.study.resolve()
    p=load(s/"protocol.json"); summary=load(s/"summary.json")
    audit=load(s/"AUDIT.json"); vectors=load(s/"independent_vector_validation/SUMMARY.json")
    diagnosis=load(s/"diagnostics_posthoc/DIAGNOSIS.json")
    assert audit["status"]=="PASS" and audit["response_envelopes"]==6
    assert all(r["status"]=="PASS" for r in vectors["results"])
    assert diagnosis["intermediate_json_equivalence_to_original_default_instance"]=="FULL_INPUT_SAT_PASS"
    baseline=p["baseline_metrics"]; cap=baseline["mapped_area_um2"]*1.10
    rows=[load(s/r["arm"]/r["candidate_id"]/"result.json") for r in load(s/"candidate_manifest.json")["slots"]]
    assert len(rows)==6 and all(r["candidate_sha256"] for r in rows)
    best={}; chosen={}
    for arm in p["arms"]:
        rr=[r for r in rows if r["arm"]==arm]
        eligible=[r for r in rr if r["eligible"]]
        best[arm]=min(eligible,key=lambda r:r["metrics"]["max_data_arrival_ns"])
        improved=[r for r in rr if r["valid_improvement"]]
        chosen[arm]=min(improved,key=lambda r:r["metrics"]["max_data_arrival_ns"]) if improved else None
        for r in rr:
            m=r["metrics"]
            assert m["formal"]==m["mapped_formal"]==m["electrical"]["status"]=="PASS"
            assert r["eligible"]==(m["mapped_area_um2"]<=cap+1e-9)
            assert r["valid_improvement"]==(r["eligible"] and m["max_data_arrival_ns"]<baseline["max_data_arrival_ns"])
    reproductions={}
    for name,r in (("best_no_timing",best["no_timing_feedback"]),("best_path_feedback",best["path_and_rtl_chain"])):
        b=load(s/"independent_eda_reproduction"/name/"result.json")
        assert b["formal"]==b["mapped_formal"]==b["electrical"]["status"]=="PASS"
        for key in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256"):
            assert b[key]==r["metrics"][key]
        reproductions[name]={k:b[k] for k in ("max_data_arrival_ns","mapped_area_um2","mapped_sha256")}
    rb=load(s/"independent_eda_reproduction/baseline/result.json")
    assert rb["max_data_arrival_ns"]==baseline["max_data_arrival_ns"] and rb["mapped_sha256"]==baseline["mapped_sha256"]
    selections={}
    output=s/"selected_outputs"; output.mkdir(exist_ok=False)
    for arm,r in chosen.items():
        src=s/arm/r["candidate_id"]/"candidate.v" if r else s/"baseline/original.v"
        dst=output/arm; dst.mkdir()
        shutil.copyfile(src,dst/"addr_calcu.v")
        m=r["metrics"] if r else baseline
        selections[arm]={"source":"candidate" if r else "baseline_retained",
                         "source_path":str(src.relative_to(ROOT)),"source_sha256":sha(src),
                         "delay_ns":m["max_data_arrival_ns"],"area_um2":m["mapped_area_um2"],
                         "reason":"Strict eligible improvement" if r else "No candidate improved delay under fixed eligibility; retain original"}
        assert sha(dst/"addr_calcu.v")==sha(src)
        (dst/"SOURCE.json").write_text(json.dumps(selections[arm],ensure_ascii=False,indent=2),encoding="utf-8")
    winner=min((r for r in rows if r["valid_improvement"]),key=lambda r:r["metrics"]["max_data_arrival_ns"])
    export=s/"best_verified_rtl"; export.mkdir(exist_ok=False)
    source=s/winner["arm"]/winner["candidate_id"]/"candidate.v"
    shutil.copyfile(source,export/"addr_calcu.v")
    best_record={"source":str(source.relative_to(ROOT)),"sha256":sha(source),
                 "arm":winner["arm"],"candidate":winner["candidate_id"],"delay_ns":winner["metrics"]["max_data_arrival_ns"],
                 "area_um2":winner["metrics"]["mapped_area_um2"],"scope":"Default base=128 only; not physical signoff",
                 "no_rtl_edits_during_export":True}
    (export/"SOURCE.json").write_text(json.dumps(best_record,ensure_ascii=False,indent=2),encoding="utf-8")
    counts={"attempted":6,"received":6,"generation_failed":0,"all_source_mapped_formal_electrical_pass":6,
            "area_rejected":sum(not r["eligible"] for r in rows),
            "independent_vectors_per_rtl":vectors["vectors_per_rtl"],"simulated_rtls":len(vectors["results"]),
            "audit_checks":audit["passed_checks"]}
    usage=[]
    for r in rows:
        response=load(s/r["arm"]/r["candidate_id"]/"api_audit/response.json")
        u=response.get("usage",{})
        usage.append({"arm":r["arm"],"candidate":r["candidate_id"],"raw_provider_usage":u,
                      "input_plus_output":u.get("prompt_tokens",0)+u.get("completion_tokens",0),
                      "reported_total_matches_input_plus_output":u.get("total_tokens")==u.get("prompt_tokens",0)+u.get("completion_tokens",0)})
    evidence={"counts":counts,"baseline":{k:baseline[k] for k in ("max_data_arrival_ns","mapped_area_um2")},
              "area_cap_um2":cap,"per_arm_selected_outputs":selections,"exported_best":best_record,
              "independent_reproductions":reproductions,"raw_provider_usage":usage,
              "provider_reported_total_tokens":summary["total_reported_tokens"],"verified_charge_total":None,
              "diagnostic_is_posthoc":True,"diagnostic_causal_benefit_not_tested":True,
              "diagnosis_sha256":sha(s/"diagnostics_posthoc/DIAGNOSIS.json"),
              "frozen_protocol_sha256":sha(s/"protocol.json")}
    (s/"EVIDENCE_CHAIN.json").write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding="utf-8")
    labels={"no_timing_feedback":"无时序反馈","path_and_rtl_chain":"STA 路径＋源码链"}
    lines=["# 地址计算电路真实对照（2026-10-30）","",
           "**本次路径反馈组没有取得时序改善；无反馈组找到了更快且更小的候选。** 六个请求均收到真实 RTL，没有连接失败或补样。","",
           f"原始基线：到达时间 {baseline['max_data_arrival_ns']:.2f} ns，面积 {baseline['mapped_area_um2']:.4f} µm²。固定共同面积上限 {cap:.6f} µm²。","",
           "| 组别 | 返回 RTL | 形式/门级/电气通过 | 面积合格 | 严格改善 | 最佳面积合格候选 | 保留基线后的最终选择 |",
           "|---|---:|---:|---:|---:|---:|---:|"]
    for arm in p["arms"]:
        g=summary["groups"][arm]
        lines.append(f"| {labels[arm]} | {g['generated']}/3 | 3/3 | {g['area_eligible']}/3 | {g['valid_improvements']}/3 | {best[arm]['metrics']['max_data_arrival_ns']:.2f} ns | {selections[arm]['delay_ns']:.2f} ns |")
    m=winner["metrics"]
    delay_gain=100*(baseline["max_data_arrival_ns"]-m["max_data_arrival_ns"])/baseline["max_data_arrival_ns"]
    area_gain=100*(baseline["mapped_area_um2"]-m["mapped_area_um2"])/baseline["mapped_area_um2"]
    lines += ["",f"最佳无反馈候选比基线延迟下降 {delay_gain:.4f}%，面积下降 {area_gain:.4f}%。路径组最佳候选 2.49 ns 比基线 2.38 ns 慢，不能接受为优化；selected_outputs/path_and_rtl_chain/ 已原字节保留基线，避免输出退化电路。",
              "", "## 全部候选","",
              "| 组别/候选 | 延迟 ns | 面积 µm² | 形式/门级/电气 | 面积资格 | 时序改善 |",
              "|---|---:|---:|---|---|---|"]
    for r in sorted(rows,key=lambda r:(r["arm"],r["candidate_id"])):
        m=r["metrics"]
        lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | PASS/PASS/PASS | {'通过' if r['eligible'] else '超限'} | {'是' if r['valid_improvement'] else '否'} |")
    lines += ["",
              "每组各一份面积超限，全部保留并排除。路径组 candidate_02 虽为 2.41 ns，但面积超限，既不能忽略资格，也不能把它算成改善。",
              "",
              "## 实际改写",
              "",
              "无反馈最佳 candidate_03 利用默认 base=0x80、8 位回绕关系改写指针项，将主要进位解析限制在 8 位，并用进位保存压缩、并行前缀进位和高位译码代替宽算术链。它不是压缩代码行数，而是改变综合后的运算结构。",
              "路径组部分返回明确引用 control→count[10]、2.38 ns 的实际报告，但主要建议将末端选择前移并共享算术。请求日志证明 STA 真实进入提示、返回说明与它对应；并不意味着这种解释或改写一定有效。",
              "",
              "## 找到的反馈缺口（事后诊断，不是已证实的因果结论）",
              "",
              "实际综合日志已经记录 OPT_SHARE 把选择器前移并合并运算。综合前反馈图显示 control 到输出只有一个末端 mux；按实际 coarse/fine 起始阶段捕获的图则包含一个综合器创建的 mux 和三个算术 $alu，保守控制依赖链为 mux→alu→alu→alu。后者已额外通过完整输入 SAT，与原始默认参数 RTL 等价。",
              "因此模型可能把源码形态误当成综合后结构，重复提出综合器已经做过的动作。综合器新建 mux 没有源码 src 属性，也不能伪造源码行。该中间图不等于最终标准单元关键路径，整单元连接是保守近似，不证明具体路径敏化。",
              "该诊断没有出现在当前冻结提示里，不能回填当前实验，也不能据此声称它解释了全部性能差异。下一步应对照测试“加入综合后结构及已执行变换的反馈”，而不是继续无依据地换更强模型。",
              "",
              "## 证据与独立复现",
              "",
              "- 六次真实生成的请求/可见响应、提示和候选哈希均保留；本机 curl 传输在本轮观察到 6/6 返回，但小样本不能保证以后不失败。",
              f"- {audit['passed_checks']} 项一致性审计通过；默认 base=128 下六份 RTL 均通过无输入限制的源级 SAT、修复后门级 SAT、电气检查。",
              f"- 基线和六份候选各 {vectors['vectors_per_rtl']} 组独立整数真值/Icarus 仿真全部通过，合计 {vectors['vectors_per_rtl']*len(vectors['results'])} 次检查；这是有限测试，不是穷举 33 位输入。非默认 base 参数未被本协议验证。",
              "- 基线、无反馈最佳及路径组最佳候选在三个新目录完整复跑 EDA，延迟、面积、单元数和门级网表/SDC 哈希均与首次评估一致。路径组复跑只用于核实失败结果，不代表推荐使用。",
              f"- 服务方报告的响应总用量 {summary['total_reported_tokens']} tokens，原始分项逐份保存。部分计数存在分项/总数不一致，未独立核算账单。",
              "",
              "## 文件入口",
              "",
              "- protocol.json：原始冻结条件与 curl 二进制版本/哈希。",
              "- candidate_manifest.json：评估前冻结的六候选。",
              "- 各组 candidate_XX/api_audit/：实际请求与可见响应。",
              "- 各组 candidate_XX/evaluation/eda/：formal.log、mapped_formal.log、mapping.log、sta.log、electrical.json、result.json。",
              "- AUDIT.json、independent_vector_validation/、independent_eda_reproduction/：独立核查。",
              "- diagnostics_posthoc/DIAGNOSIS.md：综合变换证据、保守图的精度限制及额外功能证明。",
              "- selected_outputs/：各组按严格改善规则选择的实际输出；路径组保留基线。",
              "- best_verified_rtl/addr_calcu.v：本轮最低延迟的合格 RTL，来自无反馈 candidate_03，SOURCE.json 可追溯。",
              "- EVIDENCE_CHAIN.json：资格、用量异常、复现与选择记录。",
              "",
              "单个已研究公开电路、每组三次调用、同一服务方模型别名及固定库/约束；不声明统计显著性或方法普遍优劣。预布局时序未包含实际布线寄生、拥塞与签核。",""]
    (s/"INTERPRETATION.md").write_text("\n".join(lines),encoding="utf-8")
    print(json.dumps({"report":str(s/"INTERPRETATION.md"),"requests":6,"returned":6,
                      "best_no_timing_candidate_ns":1.93,"best_path_candidate_ns":2.49,
                      "path_final_selected_ns":selections["path_and_rtl_chain"]["delay_ns"],
                      "best_delay_reduction_vs_baseline_pct":delay_gain,"best_area_reduction_pct":area_gain,
                      "audit_checks":audit["passed_checks"],"full_vector_checks":vectors["vectors_per_rtl"]*len(vectors["results"])},ensure_ascii=False))
if __name__=="__main__":
    main()

