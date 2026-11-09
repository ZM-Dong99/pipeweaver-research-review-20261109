"""Audit frozen qualification results and write coverage report. No EDA or model calls."""
import argparse
from collections import Counter,defaultdict
import hashlib,json
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument("study",type=Path);a=ap.parse_args()
    s=a.study.resolve(); p=load(s/"protocol.json"); summary=load(s/"summary.json")
    checks=[]; failures=[]
    def check(ok,name):
        if not ok: raise ValueError(name)
        checks.append(name)
    check(sha(s/"protocol.json")==(s/"protocol.sha256").read_text().strip()==summary["protocol_sha256"],"frozen protocol linkage")
    for rel,h in p["dependency_sha256"].items():
        check(sha(s/"code_snapshot"/Path(rel).name)==h,"frozen code "+rel)
    spec={c["id"]:c for c in p["cases"]}
    check(len(summary["results"])==len(spec)==45,"complete 45-case denominator")
    check(len({r["id"] for r in summary["results"]})==45,"no duplicate or omitted case IDs")
    detail=[];qualified=[]
    for row in summary["results"]:
        cid=row["id"]; c=spec[cid]
        try:
            check(sha(ROOT/c["source"])==c["source_sha256"],cid+": source unchanged")
            check(row["planned_split"]==c["planned_split"] and row["family"]==c["family"],cid+": original family split retained")
            if row["status"]=="DEFERRED_SEQUENTIAL":
                check(c["action"]=="DEFERRED_SEQUENTIAL",cid+": deferred before PPA")
                detail.append({"id":cid,"family":c["family"],"split":c["planned_split"],"status":row["status"],
                               "source_lines":c["physical_lines"],"code_lines_approx":c["code_lines_approx"],"phase":"backend_not_supported"})
                continue
            check(c["action"]=="RUN_COMBINATIONAL_QUALIFICATION",cid+": planned evaluator attempt")
            folder=s/"cases"/cid
            e=load(folder/"protocol.json")
            check(e["candidate_sha256"]==e["reference_sha256"]==c["source_sha256"],cid+": native original self-reference")
            check(e["parameter_overrides"]==c["parameters"],cid+": fixed parameter instance")
            check(e["abc_cleanup_before_buffer"] and e["mapping_policy"]=="buffer_size",cid+": same cleaned buffered mapping")
            check(e["liberty_sha256"]==p["liberty_sha256"] and e["runner_sha256"]==p["dependency_sha256"][str(Path("eda/experiments/run_native_comb.py"))],cid+": same library/evaluator")
            m=row.get("metrics",{})
            phase=m.get("stage","candidate_schema")
            if row["status"]=="QUALIFIED":
                check(m["formal"]==m["mapped_formal"]==m["electrical"]["status"]==m["ppa"]==m["status"]=="PASS",cid+": complete eligibility")
                for name in ("formal.log","mapped_formal.log"):
                    check("SAT proof finished - no model found: SUCCESS!" in (folder/name).read_text(encoding="utf-8"),cid+": raw "+name)
                sta=(folder/"sta.log").read_text(encoding="utf-8")
                check(not re.search(r"(?m)^\s*(?:Error:|ERROR:)",sta),cid+": STA no error")
                check(sta.count("PW_ELECTRICAL_BEGIN")==sta.count("PW_ELECTRICAL_END")==1 and "(VIOLATED)" not in sta,cid+": raw electrical clean")
                arrival=float(re.search(r"([-+\d.]+)\s+data arrival time",sta).group(1))
                check(arrival==m["max_data_arrival_ns"],cid+": raw arrival")
                area=float(re.findall(r"Chip area for (?:top )?module .*?:\s*([\d.]+)",(folder/"mapping.log").read_text(encoding="utf-8"))[-1])
                check(area==m["mapped_area_um2"],cid+": raw area")
                module=load(folder/"mapped.json")["modules"][c["top"]]
                check(len(module["cells"])==m["mapped_cells"] and all(v["type"].startswith("sky130_fd_sc_hd__") for v in module["cells"].values()),cid+": actual standard cells")
                schemas=[load(folder/(label+"_schema.json"))["modules"][c["top"]]["ports"] for label in ("candidate","reference")]
                check({k:(v["direction"],len(v["bits"])) for k,v in schemas[0].items()}=={k:(v["direction"],len(v["bits"])) for k,v in schemas[1].items()},cid+": native schema agreement")
                if c["top"]=="priority_encoder":
                    width=c["parameters"]["WIDTH"]
                    check(len(schemas[0]["input_unencoded"]["bits"])==len(schemas[0]["output_unencoded"]["bits"])==width,cid+": engineering width actually elaborated")
                    check(len(schemas[0]["output_encoded"]["bits"])==(width-1).bit_length(),cid+": encoded width")
                qualified.append(row)
            elif row["status"]=="INCOMPLETE_TIMEOUT":
                logs=[x for x in folder.glob("*.log") if "TIMEOUT" in x.read_text(encoding="utf-8",errors="replace")]
                check(bool(logs),cid+": actual timeout evidence")
            elif cid=="rtlopt_mux_encode":
                check("syntax error" in (folder/"candidate_schema.log").read_text(encoding="utf-8"),cid+": actual unpacked-port syntax failure")
            detail.append({"id":cid,"family":c["family"],"split":c["planned_split"],"status":row["status"],
                           "source_lines":c["physical_lines"],"code_lines_approx":c["code_lines_approx"],"phase":phase,
                           "delay_ns":m.get("max_data_arrival_ns"),"area_um2":m.get("mapped_area_um2"),"mapped_cells":m.get("mapped_cells"),
                           "parameters":c["parameters"],"reason":m.get("failure_reason"),
                           "source_context_status":m.get("rtl_source_cone",{}).get("status")})
        except Exception as exc:
            failures.append({"id":cid,"error":str(exc)})
    q=ROOT/"eda/experiments/parameter_override_validation_20261031"
    positive=load(q/"positive/result.json");negative=load(q/"negative/result.json")
    check(positive["formal"]==positive["mapped_formal"]==positive["electrical"]["status"]=="PASS","synthetic WIDTH=8 positive full verification")
    check(negative["formal"]=="FAIL" and negative["ppa"]=="NOT_RUN","synthetic WIDTH=8 negative rejected before PPA")
    for label in ("candidate","reference"):
        ports=load(q/"positive"/(label+"_schema.json"))["modules"]["param_probe"]["ports"]
        check(len(ports["x"]["bits"])==len(ports["y"]["bits"])==8,"synthetic parameterized "+label+" port width")
    seq=load(s/"sequential_interface_survey/SUMMARY.json")
    check(seq["inspected"]==seq["planned"]==11,"all 11 sequential interfaces actually inspected")
    check(all(r["sequential_equivalence"]==r["sta"]=="NOT_RUN" for r in seq["results"]),"structure inspection not misreported as proof/STA")
    counts=dict(Counter(r["status"] for r in summary["results"]))
    check(counts==summary["counts"],"counts agree with all case records")
    evalq=[r for r in qualified if r["planned_split"]=="evaluation_candidate_family"]
    evalfamilies=sorted({r["family"] for r in evalq})
    stats={"status":"PASS" if not failures else "FAIL","passed_checks":len(checks),"failures":failures,
           "checks":checks,"llm_generation_requests":0,"counts":counts,
           "qualified_instances":len(qualified),"qualified_families":sorted({r["family"] for r in qualified}),
           "evaluation_candidate_qualified_instances":len(evalq),"evaluation_candidate_qualified_families":evalfamilies,
           "max_qualified_mapped_cells":max(r["metrics"]["mapped_cells"] for r in qualified),
           "qualified_instance_sizes":[{"id":r["id"],"cells":r["metrics"]["mapped_cells"]} for r in qualified],
           "independent_family_warning":"Parameter/width variants share one family; cases are not independent statistical samples.",
           "frozen_label_erratum":"mult_if was conservatively frozen as multiplication by a name-prefix heuristic; its source is conditional selection. It remains in the development split for this cohort and is not promoted into evaluation after seeing results.",
           "auditor_sha256":sha(Path(__file__))}
    (s/"AUDIT.json").write_text(json.dumps(stats,ensure_ascii=False,indent=2),encoding="utf-8")
    (s/"COVERAGE.json").write_text(json.dumps({"counts":counts,"cases":detail,"audit_status":stats["status"],
        "evaluation_candidate_qualified_families":evalfamilies,"taxonomy_note":stats["frozen_label_erratum"]},ensure_ascii=False,indent=2),encoding="utf-8")
    lines=["# 多家族基线资格检查（2026-10-31）","",
           f"本阶段没有调用 LLM。运行前冻结 45 个配置实例：34 个组合实例实际尝试，11 个时序实例因后端范围限制暂缓。实际结果为 {len(qualified)} 个组合实例完成资格检查、5 个超时、1 个前端语法不支持。","",
           f"已通过实例覆盖 {len(stats['qualified_families'])} 个冻结家族；其中 {len(evalq)} 个来自未参与本项目提示调试的评估候选家族，只有 {len(evalfamilies)} 个家族：{', '.join(evalfamilies)}。宽度变体不得当成独立家族，也不能把这些数字当成优化收益或统计显著性。","",
           "## 具体范围","",
           "- 采用原始源码、原生端口、固定参数实例；没有人为凑长代码或使用上游优化参考作为功能真值。",
           "- 同一 SKY130HD TT 库、0.10 ns 输入转换、0.010 pF 输出负载、零输入输出外部延迟、100 ns 虚拟时钟、buffer_size＋缓冲前 cleanup；每工具120秒，两并发。",
           "- 通过要求源级自比较、映射后对原始源的完整功能证明、真实 STA 数值及电气零报告违例。源级自比较只是流程自检，不是优化验证；门级证明另行执行。",
           "- “可评估”不是“时序已经达标”，更不是“STA 引导已有效”。未生成任何优化候选，没有方法对照结果。",
           "",
           "## 工程源码与复杂度",
           "",
           "- 从公开 verilog-axis 固定提交导入未修改的优先编码器：92 行物理源码、约45行非注释非空行。64/256路实例均完成原生参数展开及验证；256路实际映射1145个单元，说明源码短不必然代表电路小。",
           "- 从公开 verilog-lfsr 固定提交导入447行物理源码、约198行非注释非空行的模块；DATA_WIDTH=8/32 都在前端解析/展开阶段达到120秒上限，未获得功能证明或PPA。因此不能宣称已验证该447行工程模块。",
           "- 两个工程仓库的源码、README、COPYING原样保存，固定提交和下载SHA-256位于 benchmark/engineering_sources_20261030/。这些是固定历史工程来源，不是对上游当前维护状态的保证。",
           "",
           "## 失败与暂缓不能隐藏",
           "",
           "- calculation、divider_16bit、divider_32bit：映射后等价证明超时；不是已证明错误，也不能报告为验证成功。",
           "- lfsr 两种数据宽度：前端解析/展开超时。",
           "- mux_encode：当前 Yosys 前端拒绝解包数组形式的端口，原始语法错误日志保留；没有为了通过而改扁平接口。",
           "- 11个时序模块已单独完成语法/结构扫描，记录原生端口、寄存器类型和时钟复位来源；完整时序等价、时序约束与STA未运行，仍为暂缓。",
           "",
           "## 数据分组与统计边界",
           "",
           "历史项目协议暴露及开发家族在测量前写入 prior_exposure_snapshot.json / family_split.json。评估候选只表示未参与本项目的提示调试，不能保证公开代码不在模型训练数据中，也不是盲测保证。只做基线测量允许核查工具兼容性，不应据候选收益重新选案例。",
           "mult_if 的名字前缀导致它被保守冻结为乘法家族，但源码实际上是条件选择；本轮保留原开发分组，不根据测量结果把它挪进评估集。后续清单应修正名称规则。",
           f"目前真正可用的新评估候选只有 {len(evalfamilies)} 个家族。即使每个宽度多抽几次候选，也不能凭空扩大独立样本数。当前仍不足以声称方法的普遍统计优势，尤其没有覆盖完整流水线/握手模块。",
           "",
           "## 全部45个实例","",
           "| 实例 | 家族/冻结分组 | 源码行/近似代码行 | 状态 | 映射单元 | 到达时间ns |",
           "|---|---|---:|---|---:|---:|"]
    for d in sorted(detail,key=lambda x:x["id"]):
        delay=f"{d['delay_ns']:.2f}" if d.get("delay_ns") is not None else "—"
        lines.append(f"| {d['id']} | {d['family']} / {d['split']} | {d['source_lines']}/{d['code_lines_approx']} | {d['status']} | {d.get('mapped_cells') if d.get('mapped_cells') is not None else '—'} | {delay} |")
    lines += ["","## 下一步与停止条件","",
              "先补齐时序模块后端或更多独立工程家族，再做冻结的模型比较；不要马上把28个配置当成28个独立案例花钱跑模型。当前这一批基线不决定STA方向成立或失败。",
              "后续模型实验应在生成前固定电路家族、共同约束/映射、模型与预算、面积上限、失败处理、基线保留及主指标。以每电路/家族的配对结果分析，记录所有失败及费用；没有可重复收益就报告不支持，不追加提示直到获胜。",
              "若只在现有四个新家族做小试，应明确标为探索，不能包装成充分统计证据。已用ALU、地址计算和乘除法开发案例只能作为开发/回归集。",
              "",
              "文件：protocol.json / family_split.json（运行前冻结）；cases/（全部原始日志及逐案例结果）；summary.json；AUDIT.json；COVERAGE.json；sequential_interface_survey/（仅结构扫描）。",
              "全部时序是预布局固定库估计，没有真实布线寄生、功耗或物理签核；参数证明仅覆盖记录的实例。",""]
    (s/"SUMMARY.md").write_text("\n".join(lines),encoding="utf-8")
    print(json.dumps({k:v for k,v in stats.items() if k not in ("checks","qualified_instance_sizes")},ensure_ascii=False,indent=2))
    return 0 if not failures else 1
if __name__=="__main__":raise SystemExit(main())

