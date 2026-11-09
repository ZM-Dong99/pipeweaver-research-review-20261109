"""Build a traceable interpretation from a completed frozen ALU study. No API calls."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[2]
def load(p):
    return json.loads(p.read_text(encoding="utf-8-sig"))
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("study",type=Path)
    args=ap.parse_args()
    s=args.study.resolve()
    protocol=load(s/"protocol.json")
    summary=load(s/"summary.json")
    manifest=load(s/"candidate_manifest.json")
    audit=load(s/"AUDIT.json")
    vectors=load(s/"independent_vector_validation/SUMMARY.json")
    assert audit["status"]=="PASS" and len(manifest["slots"])==6
    assert all(r["status"]=="PASS" for r in vectors["results"])
    baseline=protocol["baseline_metrics"]
    area_cap=baseline["mapped_area_um2"]*protocol["acceptance"]["area_cap_ratio"]
    rows=[]
    usage=[]
    for slot in manifest["slots"]:
        d=s/slot["arm"]/slot["candidate_id"]
        r=load(d/"result.json")
        rows.append(r)
        rp=d/"api_audit/response.json"
        if rp.exists():
            response=load(rp)
            u=response.get("usage",{})
            usage.append({"arm":slot["arm"],"candidate":slot["candidate_id"],
                          "provider_response_id":response.get("id"),"provider_reported_model":response.get("model"),
                          "provider_usage":u,"input_plus_output":u.get("prompt_tokens",0)+u.get("completion_tokens",0),
                          "reported_total_matches_input_plus_output":u.get("total_tokens")==u.get("prompt_tokens",0)+u.get("completion_tokens",0)})
    labels={"no_timing_feedback":"无时序反馈","path_and_rtl_chain":"STA 路径＋保守 RTL 链反馈"}
    best={}
    for arm in protocol["arms"]:
        rr=[r for r in rows if r["arm"]==arm]
        eligible=[r for r in rr if r["eligible"]]
        best[arm]=min(eligible,key=lambda r:r["metrics"]["max_data_arrival_ns"])
        for r in rr:
            if r.get("metrics",{}).get("ppa")=="PASS":
                m=r["metrics"]
                expected=(m["status"]=="PASS" and m["formal"]==m["mapped_formal"]=="PASS"
                          and m["electrical"]["status"]=="PASS" and m["mapped_area_um2"] <= area_cap+1e-9)
                assert bool(r["eligible"])==expected
                assert bool(r["valid_improvement"])==(expected and m["max_data_arrival_ns"] < baseline["max_data_arrival_ns"])
    original_files={
        "baseline":s/"baseline/evaluation/eda",
        "best_no_timing":s/"no_timing_feedback"/best["no_timing_feedback"]["candidate_id"]/"evaluation/eda",
        "best_path_feedback":s/"path_and_rtl_chain"/best["path_and_rtl_chain"]["candidate_id"]/"evaluation/eda",
    }
    reproduced={}
    for name,initial in original_files.items():
        a=load(initial/"result.json")
        out=s/"independent_eda_reproduction"/name
        b=load(out/"result.json")
        assert b["status"]==b["formal"]==b["mapped_formal"]==b["electrical"]["status"]=="PASS"
        for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256"):
            assert a[k]==b[k],(name,k)
        reproduced[name]={k:b[k] for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256")}
    no=best["no_timing_feedback"]["metrics"]
    path=best["path_and_rtl_chain"]["metrics"]
    delay_gain_vs_no=100*(no["max_data_arrival_ns"]-path["max_data_arrival_ns"])/no["max_data_arrival_ns"]
    area_cost_vs_no=100*(path["mapped_area_um2"]/no["mapped_area_um2"]-1)
    path_gain_vs_base=100*(baseline["max_data_arrival_ns"]-path["max_data_arrival_ns"])/baseline["max_data_arrival_ns"]
    mapped_sets={a:{r["metrics"]["mapped_sha256"] for r in rows if r["arm"]==a and r.get("metrics",{}).get("mapped_sha256")} for a in protocol["arms"]}
    genfails=[{"arm":r["arm"],"candidate":r["candidate_id"],"error":r.get("error")} for r in rows if not r["candidate_sha256"]]
    assert len(genfails)==2 and all("UNEXPECTED_EOF_WHILE_READING" in r["error"] for r in genfails)
    exported=s/"best_verified_rtl"
    exported.mkdir(exist_ok=False)
    chosen=best["path_and_rtl_chain"]
    src=s/chosen["arm"]/chosen["candidate_id"]/"candidate.v"
    shutil.copyfile(src,exported/"alu_64bit.v")
    source_record={"source":str(src.relative_to(ROOT)),"sha256":sha(src),
                   "original_reference_sha256":protocol["baseline_sha256"],"protocol_sha256":sha(s/"protocol.json"),
                   "selection":"Minimum measured arrival among all frozen eligible candidates; ties resolve to first recorded candidate",
                   "candidate_id":chosen["candidate_id"],"arm":chosen["arm"],
                   "arrival_ns":path["max_data_arrival_ns"],"area_um2":path["mapped_area_um2"],
                   "not_a_new_api_call":True,"not_production_signoff":True}
    assert sha(exported/"alu_64bit.v")==source_record["sha256"]
    (exported/"SOURCE.json").write_text(json.dumps(source_record,ensure_ascii=False,indent=2),encoding="utf-8")
    evidence={
        "api_request_attempts":len(rows),"returned_response_envelopes":len(usage),"network_failure_slots":genfails,
        "raw_provider_usage":usage,"provider_reported_total_tokens":summary["total_reported_tokens"],
        "usage_caveat":"Provider totals are preserved; mismatching token arithmetic and failed TLS requests prevent an independently verified charge total.",
        "baseline":{k:baseline[k] for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells")},
        "area_cap_um2":area_cap,"best_path_vs_best_no_timing_delay_reduction_pct":delay_gain_vs_no,
        "best_path_vs_best_no_timing_area_increase_pct":area_cost_vs_no,
        "best_path_vs_baseline_delay_reduction_pct":path_gain_vs_base,
        "unique_exact_mapped_netlist_hashes":{a:len(x) for a,x in mapped_sets.items()},
        "independent_reproduction":reproduced,
        "independent_vectors_per_rtl":vectors["vectors_per_rtl"],
        "independent_simulated_rtls":len(vectors["results"]),
        "independent_vector_evaluations":vectors["vectors_per_rtl"]*len(vectors["results"]),
        "audit_passed_checks":audit["passed_checks"],"best_export":source_record,
        "evidence_files":{str(p.relative_to(s)):sha(p) for p in (
            s/"protocol.json",s/"candidate_manifest.json",s/"summary.json",s/"AUDIT.json",
            s/"independent_vector_validation/SUMMARY.json")},
        "conclusion":"Exploratory within-study timing advantage under a common baseline-relative area cap; not equal-area superiority, statistical significance, model identity verification, or universal feedback benefit."}
    (s/"EVIDENCE_CHAIN.json").write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding="utf-8")
    lines=["# 修复后 ALU 的真实反馈对照（2026-10-30）","",
           "本次六个固定槽位已执行完毕，实际收到四份模型响应，两组各有一次 TLS 连接中断。失败保留在各组三槽位的分母中，没有自动重试或补样。",
           "模型由 APINebula 标识为 gpt-6.1-sol，底层身份未独立验证。两组均使用 reasoning_effort=medium、不传 temperature，所有候选生成完并冻结后才开始候选 EDA。","",
           "## 结果","",
           f"基线最大到达时间 {baseline['max_data_arrival_ns']:.2f} ns，面积 {baseline['mapped_area_um2']:.4f} µm²。两组共同面积上限为 {area_cap:.6f} µm²。","",
           "| 组别 | 请求/返回 RTL | 有效时序改善 | 至少 5% 改善 | 最佳合格延迟 | 最佳候选面积 |",
           "|---|---:|---:|---:|---:|---:|"]
    for arm in protocol["arms"]:
        g=summary["groups"][arm]
        m=best[arm]["metrics"]
        lines.append(f"| {labels[arm]} | 3 / {g['generated']} | {g['valid_improvements']}/3 | {g['meaningful_gains_at_least_5pct']}/3 | {m['max_data_arrival_ns']:.2f} ns | {m['mapped_area_um2']:.4f} µm² |")
    lines += ["",
              f"本次路径反馈组最佳延迟比无反馈组最佳低 **{delay_gain_vs_no:.4f}%**，比原始基线低 **{path_gain_vs_base:.4f}%**。四份生成候选均通过全输入源级等价、门级网表等价和电气检查。",
              f"**面积权衡必须一起报告：路径组最佳比无反馈组最佳多用 {area_cost_vs_no:.4f}% 面积。** 二者均低于同一基线对应的面积上限，但这不是同面积下的性能比较。追求更小面积时，本次无反馈组有价值；追求共同面积上限内最低延迟时，本次路径组更好。","",
              "## 六个槽位全部记录","",
              "| 组别/候选 | 生成 | 源级/门级形式 | 延迟 ns | 面积 µm² | 电气 | 合格/时序改善 |",
              "|---|---|---|---:|---:|---|---|"]
    for r in sorted(rows,key=lambda x:(x["arm"],x["candidate_id"])):
        if not r["candidate_sha256"]:
            lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | TLS 失败 | 未运行 | — | — | 未运行 | 否/否 |")
        else:
            m=r["metrics"]
            lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | 返回 RTL | {r['formal']}/{m['mapped_formal']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {m['electrical']['status']} | {'是' if r['eligible'] else '否'}/{'是' if r['valid_improvement'] else '否'} |")
    lines += ["","## 具体改了什么，反馈是否真的送到模型",
              "",
              "无反馈 candidate_02 使用共享加减法器、操作数交换和四位局部超前进位，但分组之间仍有串行依赖，实际延迟 3.80 ns，比基线差。无反馈 candidate_03 只显式共享一个加减法数据通路，实际 3.00 ns、面积更小。",
              "路径组使用共享加减法通路、按运算条件翻转操作数，并对十六个四位分组做四级并行前缀进位。它在可见说明中引用了真实 a[5] 到高位 sum 的路径、3.04–3.05 ns 延迟及后段选择逻辑，同时注明源码链不是精确门级路径。",
              "可以核对的证据链：实际基线 sta.log → 冻结提示 → api_audit/request.json 的实际 messages → api_audit/response.json → 候选 RTL 哈希 → 形式/映射/STA/电气日志。147 项一致性审计已通过。它证明反馈确实进入请求、返回说明与之对应，但不能观察模型内部推理，也不能排除随机采样及面积分配对结果的贡献。",
              "",
              "**路径组两份 RTL 虽然文件哈希不同，最终映射网表 SHA-256 完全相同。** 因而它们是两次调用落到同一个工程实现，不能当作两种独立结构的验证，也不能视为多个电路的成功案例。","",
              "## 独立验证",
              "",
              "1. 基线和两组最佳候选分别在独立目录重新做完整 EDA，延迟、面积、单元数、门级网表 SHA-256 和 SDC 哈希全部与第一次评估一致。",
              f"2. 使用独立 Python 整数真值计算，按模 2^64 编码八种操作，为原始 RTL 和全部四份模型 RTL 各运行 {vectors['vectors_per_rtl']} 组 Icarus 仿真，全部通过。覆盖边界值、各位进位/借位、随机输入以及全部 Oper 值。这是有限测试，不是穷举 131 位输入空间；全输入保证来自另行保存的 SAT 证明。",
              "3. 每个真实候选都验证了映射后网表与原始 RTL 等价，且固定库/SDC 下 max-slew/max-capacitance 无报告违例。上述检查不等同于布局布线签核。",
              "",
              "## 用量、失败及结论边界",
              "",
              f"- 六次请求尝试、四份响应。服务方报告的响应总用量为 {summary['total_reported_tokens']} tokens。每份原始 usage 均保存；部分服务方计数不满足输入+输出=总数，EVIDENCE_CHAIN.json 逐份披露，不据此伪算费用。",
              "- 两次失败均为 SSL UNEXPECTED_EOF_WHILE_READING。没有收到响应或用量记录，不能断言服务端是否处理或扣费。它们不是 RTL 错误，但保留在端到端成功率的分母。",
              "- 单个公开、此前已研究的 ALU；每组仅两份成功返回；同一模型别名可能由中转站 Auto 路由；反馈提示更长、用量不相同。这里只控制候选槽位、请求参数、超时与 EDA 条件，不是等 token 预算比较。",
              "- 本次支持的陈述是：在该 ALU、固定修复映射及共同面积上限下，路径反馈组取得了更低的最佳实测延迟。不能推广为 STA 总是有用，不能证明新模型优于 DeepSeek，也不能宣称方法原创或具有统计显著性。",
              "- 此轮没有实现新一轮根据候选结果反复修改的迭代搜索；这是独立生成的反馈条件对照。不要把一次对照夸大为多轮反馈收敛。",
              "",
              "## 文件入口",
              "",
              "- protocol.json / protocol.sha256：运行前冻结条件。",
              "- candidate_manifest.json：候选内容在评估前冻结。",
              "- 各组 candidate_XX/api_audit/：实际去除鉴权的请求和可见响应。",
              "- 各组 candidate_XX/evaluation/eda/：formal.log、mapped_formal.log、mapping.log、sta.log、electrical.json。",
              "- AUDIT.json：147 项一致性检查。",
              "- independent_eda_reproduction/：独立 EDA 复跑。",
              "- independent_vector_validation/：真值向量、测试平台、逐份编译和仿真日志。",
              "- best_verified_rtl/alu_64bit.v：本次最低延迟合格 RTL，原字节导出；SOURCE.json 可追溯原候选。",
              "- EVIDENCE_CHAIN.json：指标、权衡、用量异常、哈希和独立复现结果。",
              "",
              "下一步优先做预注册的独立重复与第二个电路/宽度，而不是修改提示直到 STA 组获胜。若做面积匹配对照，应另立协议，不更改本次共同基线面积上限的规则。",""]
    (s/"INTERPRETATION.md").write_text("\n".join(lines),encoding="utf-8")
    print(json.dumps({"report":str(s/"INTERPRETATION.md"),"attempts":len(rows),"responses":len(usage),
                      "best_no_timing_ns":no["max_data_arrival_ns"],"best_path_ns":path["max_data_arrival_ns"],
                      "delay_reduction_pct":delay_gain_vs_no,"area_increase_vs_no_pct":area_cost_vs_no,
                      "independent_reproduction":"PASS","exported_rtl_sha256":sha(exported/"alu_64bit.v")},ensure_ascii=False))

if __name__=="__main__":
    main()

