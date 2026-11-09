"""Reconcile frozen primary results with uniform post-hoc EDA repair. No API."""
import hashlib,json
from pathlib import Path
import shutil
ROOT=Path(__file__).resolve().parents[2]
s=ROOT/"eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837"
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
p=load(s/"protocol.json")
for rel,h in p["dependency_sha256"].items():
    assert sha(s/"code_snapshot"/Path(rel).name)==h
for arm,h in p["prompt_sha256"].items():
    assert sha(s/"prompts"/(arm+".txt"))==h
for rel,h in p["synthesis_context"]["artifacts_sha256"].items():
    assert sha(s/rel)==h
u=s/"uniform_cleanup_reevaluation"
r=load(u/"SUMMARY.json")
plan=load(u/"protocol.json")
code_hashes={k.replace("\\","/"):v for k,v in plan["code_sha256"].items()}
assert plan["original_protocol_sha256"]==sha(s/"protocol.json")
assert plan["candidate_manifest_sha256"]==sha(s/"candidate_manifest.json")
assert r["new_llm_requests"]==0 and len(r["results"])==9
manifest=load(s/"candidate_manifest.json")
for slot in manifest["slots"]:
    assert sha(s/slot["arm"]/slot["candidate_id"]/"candidate.v")==slot["candidate_sha256"]
for row in r["results"]:
    ep=u/row["arm"]/row["candidate"]/"protocol.json"
    e=load(ep)
    assert e["abc_cleanup_before_buffer"] is True
    assert e["reference_sha256"]==p["baseline_sha256"]
    assert e["runner_sha256"]==code_hashes["eda/experiments/run_native_comb.py"]
    if row["eligible"]:
        m=row["metrics"]; folder=ep.parent
        assert m["formal"]==m["mapped_formal"]==m["electrical"]["status"]=="PASS"
        for name in ("formal.log","mapped_formal.log"):
            assert "SAT proof finished - no model found: SUCCESS!" in (folder/name).read_text(encoding="utf-8")
        sta=(folder/"sta.log").read_text(encoding="utf-8")
        assert "PW_ELECTRICAL_BEGIN" in sta and "PW_ELECTRICAL_END" in sta and "(VIOLATED)" not in sta
rep=load(u/"independent_best_no_timing/result.json")
chosen=next(x for x in r["results"] if x["arm"]=="no_timing_feedback" and x["candidate"]=="candidate_03")
for k in ("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256"):
    assert rep[k]==chosen["metrics"][k]
assert rep["max_data_arrival_ns"]==1.73 and rep["mapped_formal"]==rep["electrical"]["status"]=="PASS"
best=u/"best_verified_rtl"; best.mkdir(exist_ok=False)
src=s/"no_timing_feedback/candidate_03/candidate.v"
shutil.copyfile(src,best/"addr_calcu.v")
source={"source":str(src.relative_to(ROOT)),"source_sha256":sha(src),
        "secondary_posthoc_uniform_cleanup":True,"original_frozen_candidate":True,
        "delay_ns":1.73,"area_um2":1126.08,"default_base_only":128,
        "full_source_and_gate_proof":True,"electrical_pass":True,"independently_reproduced":True}
(best/"SOURCE.json").write_text(json.dumps(source,ensure_ascii=False,indent=2),encoding="utf-8")
base=r["baseline"]; n=r["groups"]["no_timing_feedback"]; c=r["groups"]["path_and_synthesis_context"]
evidence={"primary_protocol_preserved":True,"primary_request_count":9,
          "primary_audit":load(s/"AUDIT.json"),"secondary_uniform_cleanup_applied_to_all_nine":True,
          "secondary_new_llm_requests":0,"secondary_groups":r["groups"],
          "restored_candidate_independently_reproduced":True,
          "new_feedback_delay_change_vs_no_feedback_pct":100*(c["selected_delay_ns"]/n["selected_delay_ns"]-1),
          "new_feedback_area_change_vs_no_feedback_pct":100*(c["selected_area_um2"]/n["selected_area_um2"]-1),
          "best_delay_reduction_vs_baseline_pct":100*(base["max_data_arrival_ns"]-1.73)/base["max_data_arrival_ns"],
          "best_export":source,"conclusion":"The primary 4.66% apparent timing advantage did not survive uniform correction of a mapper failure. No robust superiority over direct LLM is established."}
(s/"FINAL_EVIDENCE.json").write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding="utf-8")
text=f"""# 三组反馈实验：最终核查与工具修复（2026-10-30）

**最终不能声称新反馈优于无反馈。** 原冻结流程中，新组最佳 1.84 ns、无反馈最佳可测候选 1.93 ns，表面上快 4.66%。但无反馈另有一份功能正确的 RTL 因 ABC buffer 遇到无扇出节点而未获得 PPA。该工具问题修复并统一作用于全部九候选后，该候选测得 1.73 ns，改变了比较结论。

原协议、九候选、所有失败与原结果均保留。下表是事后统一清理复跑，不是新的模型调用或独立生成重复。

| 条件 | 原流程最佳合格候选 | 统一清理后最终选择（含基线保留） | 选择面积 µm² | 统一清理后严格改善 |
|---|---:|---:|---:|---:|
| 无时序反馈 | 1.93 ns | 1.73 ns | 1126.0800 | 3/3 |
| 原路径反馈 | 2.49 ns | 2.38 ns（保留原始 RTL） | 1192.3936 | 0/3 |
| 路径＋综合后结构 | 1.84 ns | 1.84 ns | 1054.7616 | 1/3 |

新反馈比无反馈的最终延迟高 {evidence['new_feedback_delay_change_vs_no_feedback_pct']:.4f}%，面积低 {-evidence['new_feedback_area_change_vs_no_feedback_pct']:.4f}%。两者是不同面积/延迟权衡；原目标是在共同面积上限内最小延迟，因此当前工程选择为无反馈组 1.73 ns。不能换一个事后指标把新组描述成获胜。

## 完成的真实工作

- 九个固定生成槽位全部返回，三组各三次，相同模型别名、请求参数、curl、面积上限、映射与约束。原控制提示与上一轮相同，新组只追加原基线重新生成的综合后证据；候选先冻结后评估。
- 新组证据包含实际 OPT_SHARE 事件、综合中间结构及保守依赖链，额外完整输入 SAT 证明通过。它不是最终门级精确定位，缺失 src 保留 null。
- 原流程 274 项审计通过，保留一个源级功能错误、一个映射工具失败和一个面积超限；不会把这些槽位从分母删除。
- 对基线与全部九份 RTL 安排独立真值仿真：九份完整通过各 145408 组，原路径 candidate_02 在第一组输入即失败，与形式反例一致。实际错误例：全零普通输入时，正确 count=FF80，候选却给 0080。
- 原基线及各组原最佳合格候选在四个独立目录重跑 EDA，结果一致。

## ABC 故障与统一修复

mapping_failure_diagnostic/ 在独立目录加入阶段标记，复现错误出在 buffer，报 node 91 has no fanout。mapping_cleanup_probe/ 证明在 map 后、buffer 前加入 cleanup -i -o 可完成映射。

随后在 uniform_cleanup_reevaluation/ 运行前写入新协议，保存新验证器/输入哈希，并对原始基线和全部九候选统一使用该命令，不只补测失败候选。完整源级证明、门级证明、STA、电气和面积资格均重新执行。清理不移除接口端口，且接受结果均以门级功能证明兜底。

恢复的无反馈 candidate_03 测得 1.73 ns / 1126.08 µm²，源级、门级及电气检查通过；又在 independent_best_no_timing/ 独立完整复跑，数值与门级网表 SHA-256 一致。比同政策基线延迟低 {evidence['best_delay_reduction_vs_baseline_pct']:.4f}%。

原路径 candidate_02 仍因真实功能错误失败，没有“修好”或替换其 RTL。统一修复没有新增 LLM 调用。全部二次评价明示为事后工具稳健性检查，不能混成原预注册成绩。

## 对系统和研究的含义

综合后结构确实能通过真实日志和额外证明构造，但本次只改善了相对旧路径组的观察结果，没有建立优于无反馈的稳定优势。新组有一份仍重复提出共享、一份改写但没有时序收益、仅一份取得严格改善。源码和综合结构对齐不是自动获胜保证。

更关键的工程发现是：一个映射器故障曾掩盖了更好的有效 RTL。之后的实验必须明确记录、统一启用清理规则，不能把基础设施失败解释为某种生成方法性能差。新代码提供显式 --cleanup-before-buffer 开关，贯通基线、候选与审计，默认旧行为保留以便追溯。旧冻结协议不能绕过哈希检查拿新代码续跑。

下一步如继续检验反馈收益，应先冻结修复后的统一流程，再独立重复或换预先选定电路；不追加提示直到某组获胜。

## 文件入口

- FINAL_EVIDENCE.json：最终核查、两套条件和工程选择。
- INTERPRETATION.md：原冻结协议下的九槽位结果；其 4.66% 观察必须连同本文件阅读。
- AUDIT.json、各组 api_audit/、evaluation/eda/：实际生成与工具日志。
- baseline/synthesis_context/：真实结构证据、原始综合日志与额外证明。
- independent_vector_validation/：独立整数真值、145408 组向量及实际失败。
- mapping_failure_diagnostic/、mapping_cleanup_probe/：工具错误定位和修复探测。
- uniform_cleanup_reevaluation/protocol.json、SUMMARY.json：全部九份统一复跑。
- uniform_cleanup_reevaluation/best_verified_rtl/addr_calcu.v：目前在修复流程下最低延迟的实际合格 RTL，原字节复制，无人工逻辑修改。
- uniform_cleanup_reevaluation/independent_best_no_timing/：1.73 ns 的独立复现。

范围仍为 default base=128 的公开开发案例，每组三次请求，模型后端身份/版本未独立验证；提示长度及 token 不相等。全部为固定库与约束下的预布局结果，不是物理签核，也不声明方法原创或统计显著性。
"""
(s/"FINAL_INTERPRETATION.md").write_text(text,encoding="utf-8")
(u/"SUMMARY.md").write_text(text,encoding="utf-8")
print(json.dumps({"final_report":str(s/"FINAL_INTERPRETATION.md"),"uniform_cleanup_groups":r["groups"],
                  "best_delay_ns":1.73,"new_feedback_did_not_beat_no_feedback":True,
                  "primary_frozen_files_verified":True},ensure_ascii=False))

