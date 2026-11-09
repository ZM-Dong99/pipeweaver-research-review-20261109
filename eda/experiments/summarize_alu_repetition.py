"""Combine two actual ALU studies without dropping failures. No API calls."""
import hashlib
import json
from pathlib import Path
import shutil

ROOT=Path(__file__).resolve().parents[2]
EX=ROOT/"eda/experiments"
studies=[EX/"timing_feedback_ablation_alu64_20261030_184826_215175",
         EX/"timing_feedback_ablation_alu64_20261030_213005_200350"]
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
protocols=[load(s/"protocol.json") for s in studies]
for key in ("prompt_sha256","request_parameters","baseline_sha256","liberty_sha256","mapping_policy","acceptance","call_schedule","dependency_sha256"):
    assert protocols[0][key]==protocols[1][key],key
allrows=[]
summaries=[]
for index,s in enumerate(studies):
    summary=load(s/"summary.json")
    audit=load(s/"AUDIT.json")
    vectors=load(s/"independent_vector_validation/SUMMARY.json")
    assert audit["status"]=="PASS" and all(r["status"]=="PASS" for r in vectors["results"])
    slots=load(s/"candidate_manifest.json")["slots"]
    assert len(slots)==6
    rr=[]
    for slot in slots:
        r=load(s/slot["arm"]/slot["candidate_id"]/"result.json")
        r["round_label"]="discovery" if index==0 else "repetition"
        r["study"]=str(s.relative_to(ROOT))
        rr.append(r)
    allrows.extend(rr)
    summaries.append(summary)
repeat=studies[1]
repeated=[r for r in allrows if r["round_label"]=="repetition"]
best={a:min((r for r in repeated if r["arm"]==a and r["eligible"]),key=lambda r:r["metrics"]["max_data_arrival_ns"])
      for a in protocols[1]["arms"]}
assert best["no_timing_feedback"]["metrics"]["max_data_arrival_ns"]==2.26
assert best["path_and_rtl_chain"]["metrics"]["max_data_arrival_ns"]==2.26
assert best["no_timing_feedback"]["metrics"]["mapped_sha256"]==best["path_and_rtl_chain"]["metrics"]["mapped_sha256"]
for name,r in (("best_no_timing",best["no_timing_feedback"]),("best_path_feedback",best["path_and_rtl_chain"])):
    independent=load(repeat/"independent_eda_reproduction"/name/"result.json")
    assert independent["status"]==independent["formal"]==independent["mapped_formal"]==independent["electrical"]["status"]=="PASS"
    for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256"):
        assert independent[k]==r["metrics"][k]
b=load(repeat/"independent_eda_reproduction/baseline/result.json")
assert b["max_data_arrival_ns"]==3.05 and b["electrical"]["status"]==b["mapped_formal"]=="PASS"
pooled={}
for arm in protocols[1]["arms"]:
    rr=[r for r in allrows if r["arm"]==arm]
    good=[r for r in rr if r["eligible"]]
    pooled[arm]={"requests":len(rr),"returned_rtls":sum(bool(r["candidate_sha256"]) for r in rr),
                 "network_failures":sum(not r["candidate_sha256"] for r in rr),
                 "formal_and_electrical_eligible":len(good),
                 "valid_improvements":sum(r["valid_improvement"] for r in rr),
                 "gains_ge5pct":sum(r["meaningful_gain"] for r in rr),
                 "best_delay_ns":min(r["metrics"]["max_data_arrival_ns"] for r in good),
                 "unique_exact_mapped_netlists":len({r["metrics"]["mapped_sha256"] for r in good})}
out=repeat/"best_verified_rtl"
out.mkdir(exist_ok=True)
winner=best["no_timing_feedback"]
src=repeat/winner["arm"]/winner["candidate_id"]/"candidate.v"
if (out/"alu_64bit.v").exists():
    assert sha(out/"alu_64bit.v")==sha(src), "Existing export differs; refusing overwrite"
else:
    shutil.copyfile(src,out/"alu_64bit.v")
record={"source":str(src.relative_to(ROOT)),"sha256":sha(src),
        "arrival_ns":2.26,"area_um2":winner["metrics"]["mapped_area_um2"],
        "tied_with":str((repeat/best["path_and_rtl_chain"]["arm"]/best["path_and_rtl_chain"]["candidate_id"]/"candidate.v").relative_to(ROOT)),
        "exact_same_mapped_netlist":True,"not_unique_to_sta_feedback":True,
        "reference_sha256":protocols[1]["baseline_sha256"],
        "selection":"Minimum eligible delay, equal-delay candidate exported from no-feedback arm; no RTL edits."}
(out/"SOURCE.json").write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding="utf-8")
evidence={"same_prompts_parameters_budget_and_evaluator":True,"studies":[str(s.relative_to(ROOT)) for s in studies],
          "pooled":pooled,"best_repetition_equal_delay":True,"best_repetition_same_mapped_netlist":True,
          "provider_reported_tokens_two_studies":sum(x["total_reported_tokens"] for x in summaries),
          "usage_is_not_verified_billing":True,"new_calls_this_turn":6,
          "returned_rtls_this_turn":4,"tls_failure_slots_this_turn":2,
          "repetition_audit_checks":load(repeat/"AUDIT.json")["passed_checks"],
          "repetition_vector_checks_per_rtl":6592,"independent_reproduction":"PASS",
          "new_best_export":record,
          "conclusion":"The discovery-round timing advantage did not persist in exact-prompt repetition. Network failures are imbalanced, so no method superiority or inferiority is established."}
(EX/"ALU_FEEDBACK_REPLICATION_20261030.json").write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding="utf-8")
labels={"no_timing_feedback":"无时序反馈","path_and_rtl_chain":"路径＋RTL 链反馈"}
lines=["# ALU 反馈优势的独立重复（2026-10-30）","",
       "**独立重复未复现上一轮 24.3% 的最佳时序优势。** 本轮两组最佳均为 2.26 ns、面积均为 10776.5856 µm²，且映射后网表 SHA-256 完全相同。不能只展示第一轮的正向结果。",
       "",
       "| 轮次 | 无反馈请求/返回 | 路径组请求/返回 | 无反馈最佳 | 路径组最佳 |",
       "|---|---:|---:|---:|---:|"]
for i,summary in enumerate(summaries):
    n=summary["groups"]["no_timing_feedback"]; p=summary["groups"]["path_and_rtl_chain"]
    lines.append(f"| {'首次观察' if i==0 else '独立重复'} | 3/{n['generated']} | 3/{p['generated']} | {n['best_eligible_delay_ns']:.2f} ns | {p['best_eligible_delay_ns']:.2f} ns |")
lines += ["",
          "两次均在同一个已研究的公开 64 位 ALU 上运行；提示哈希、实际请求参数、原始参考、库、候选预算、调用顺序、映射政策、资格规则和验证器代码哈希逐项一致。重复的计划在新增调用前写入 REPETITION_PLAN.json；选做重复的决定发生在观察第一轮之后，不能称为发现前的全局预注册。",
          "",
          "## 独立重复的全部槽位","",
          "| 组别/候选 | 生成 | 形式/门级/电气 | 延迟 ns | 面积 µm² | 有效改善 |",
          "|---|---|---|---:|---:|---|"]
for r in sorted(repeated,key=lambda r:(r["arm"],r["candidate_id"])):
    if not r["candidate_sha256"]:
        lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | TLS 失败 | 未运行 | — | — | 否 |")
    else:
        m=r["metrics"]
        lines.append(f"| {labels[r['arm']]}/{r['candidate_id']} | 返回 RTL | PASS/PASS/PASS | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {'是' if r['valid_improvement'] else '否'} |")
lines += ["",
          "本轮无反馈组三份 RTL 均返回并通过验证，路径组仅一份返回，另外两份均是约 5 秒的 SSL EOF 连接失败，没有补样。请求槽位预算相同，但有效返回预算不平衡；不能据 3/3 与 1/3 的端到端成功率认定路径反馈降低 RTL 质量。",
          "",
          "## 两轮合并描述（不是统计显著性证明）","",
          "| 组别 | 请求/返回 | 合格源级＋门级＋电气 | 严格时序改善 | 至少 5% 改善 | 最佳 |",
          "|---|---:|---:|---:|---:|---:|"]
for arm,g in pooled.items():
    lines.append(f"| {labels[arm]} | {g['requests']}/{g['returned_rtls']} | {g['formal_and_electrical_eligible']} | {g['valid_improvements']}/{g['requests']} | {g['gains_ge5pct']}/{g['requests']} | {g['best_delay_ns']:.2f} ns |")
lines += ["",
          "四次连接失败均保留，未当成错误 RTL；所有八份实际返回均完成原始参考下的全输入 SAT、映射后等价和 max-slew/max-capacitance 检查。两轮共报告 37594 tokens，保留供应商原始用量；部分分项与总数不一致，且 TLS 失败无用量记录，不能据此独立核算账单。",
          "",
          "## 独立复核",
          "",
          "- 本轮 147 项证据审计通过；原始请求、返回、候选、验证日志和汇总哈希可追溯。",
          "- 基线和四份真实返回各 6592 组独立真值仿真全部通过；有限仿真不替代全输入 SAT。",
          "- 基线、两组最佳在新目录又分别做完整 EDA，数值、单元数、SDC 和门级网表 SHA-256 均一致。",
          "- 最佳原字节 RTL 已导出到本轮 best_verified_rtl/，SOURCE.json 明确写出它来自无反馈组，同时与路径组最佳映射为同一网表。",
          "",
          "## 对研究结论的修正",
          "",
          "目前证据说明：路径反馈在首次观察中找到更低延迟候选，但直接 LLM 在完全相同提示的独立重复中也找到了相同的最佳工程实现。上轮优势不足以证明稳定收益；两轮合并也没有建立反馈的统计优势或劣势。中转站模型路由身份及版本未独立验证，仍是复现限制。",
          "下一步不是修改提示直到反馈组获胜，而是先减少传输故障，再在预先选定的第二电路上检验控制路径反馈。新的传输方式单独进入新协议，不混改这两轮结果。第二电路为地址计算电路，当前合格基线 2.38 ns；其默认 base=8'h80 配置中的 8 位截断必须保留。源码关于 late control 的注释不等于 SDC，实际仍使用相同零输入外部延迟。",
          "",
          "## 原始文件",
          "",
          f"- 首轮：{studies[0].name}/INTERPRETATION.md",
          f"- 重复：{repeat.name}/",
          "- 重复目录下的 AUDIT.json、independent_vector_validation/、independent_eda_reproduction/ 为原始复核入口。",
          "- 各组 candidate_XX/api_audit/ 为实际请求/可见响应；evaluation/eda/ 为形式、映射、时序和电气日志。",
          "- ALU_FEEDBACK_REPLICATION_20261030.json 为两轮合并的机器可读证据。",
          "",
          "以上仍是预布局结果，不是物理签核；没有声称新模型优于 DeepSeek，也没有将相同映射实现重复算成多个电路创新。",""]
(EX/"ALU_FEEDBACK_REPLICATION_20261030.md").write_text("\n".join(lines),encoding="utf-8")
(repeat/"INTERPRETATION.md").write_text("\n".join(lines),encoding="utf-8")
print(json.dumps({"report":str(EX/"ALU_FEEDBACK_REPLICATION_20261030.md"),"repetition_best_ns":2.26,
                  "same_best_netlist":True,"new_generation_requests":6,"returned":4,"network_failures":2,
                  "pooled":pooled},ensure_ascii=False))


