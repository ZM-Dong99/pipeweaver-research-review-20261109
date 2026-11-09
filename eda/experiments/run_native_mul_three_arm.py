"""Frozen equal-budget three-arm study on the native 8x8 partial-product multiplier."""
from __future__ import annotations
import argparse, hashlib, json, os, re, subprocess, sys, time
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from agents.rtl_optimizer import LLMGenerationError, api_configured, generate_from_prompt

BASE = ROOT / "benchmark/rtl_opt_upstream_hkust/benchmark/mul_subexpression/mul_subexpression.v"
TOP = "mul_subexpression"
EVALUATOR = ROOT / "eda/experiments/run_native_comb.py"
CANDIDATES = 3
TEMP = 0.2
AREA_RATIO = 1.10
TIMEOUT = 180

def sha(path: Path) -> str: return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path: Path, obj: dict) -> None: path.write_text(json.dumps(obj, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8")
def common_prompt(rtl: str) -> str:
    return f"""Optimize this combinational unsigned 8x8 multiplier RTL for shorter mapped-cell delay while controlling area. Preserve the exact module name, all ports and widths, unsigned arithmetic, and product for every input value. No clocks, state, assumptions, don't-cares, or input restrictions may be introduced. Return one JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, and functional_boundaries. candidate_rtl must be synthesizable Verilog.\n\nBaseline RTL:\n{rtl}\n"""
def make_prompt(rtl: str, report: str | None, rtl_cone: dict | None = None) -> str:
    p = common_prompt(rtl)
    if report is None:
        return p
    p += "\nBaseline OpenSTA report for the mapped baseline (use its measured critical path as timing evidence):\n" + report
    if rtl_cone is not None:
        p += "\nConservative RTL operator-cone analysis for the exact STA start/end bits follows as JSON. It lists source-attributed RTLIL cells that may lie on a structural dependency path. This is NOT an exact mapping from ABC standard cells to RTL, and every listed cell is not guaranteed to lie on the measured gate path. Treat it as localization evidence with this limitation; do not claim more precision than the JSON supports.\n"
        p += json.dumps(rtl_cone, ensure_ascii=False, indent=2) + "\n"
    return p

def candidate_tree(kind: int) -> str:
    # Eight exact unsigned partial-product rows, combined using three distinct fixed trees.
    rows = [f"wire [15:0] r{i} = {{8'b0, (multiplicand & {{8{{multiplier[{i}]}}}})}} << {i};" for i in range(8)]
    if kind == 1:
        # Adjacent pair reduction.
        stages = [[(0,1),(2,3),(4,5),(6,7)], [(0,1),(2,3)], [(0,1)]]
    elif kind == 2:
        # Pair terms with matching low/high weight bands, then reduce.
        stages = [[(0,4),(1,5),(2,6),(3,7)], [(0,1),(2,3)], [(0,1)]]
    else:
        # Reduce odd and even bands separately, then combine their roots.
        stages = [[(0,2),(1,3),(4,6),(5,7)], [(0,1),(2,3)], [(0,1)]]
    current = [f"r{i}" for i in range(8)]
    lines = [f"module {TOP}(input [7:0] multiplicand, input [7:0] multiplier, output [15:0] product);", *rows]
    serial = 0
    for si, pairs in enumerate(stages):
        nxt=[]
        for left,right in pairs:
            name=f"s{serial}"; serial+=1
            lines.append(f"wire [15:0] {name} = {current[left]} + {current[right]};")
            nxt.append(name)
        current=nxt
    lines += [f"assign product = {current[0]};", "endmodule", ""]
    return "\n".join(lines)

def run_eval(candidate: Path, out: Path, timeout: int, *, reference: Path = BASE, top: str = TOP,
             mapping_policy: str = "legacy", cleanup_before_buffer: bool = False,
             parameters: dict | None = None) -> tuple[int,str,float]:
    out.mkdir(parents=True, exist_ok=False)
    yosys=Path(os.environ.get("YOSYS",r"D:\oss-cad-suite\bin\yosys.exe"))
    env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    env["PATH"]=os.pathsep.join([str(yosys.parent),str(yosys.parent.parent/"lib"),env.get("PATH","")])
    cmd=[sys.executable,"-B",str(EVALUATOR),str(candidate),"--reference",str(reference),"--top",top,"--timeout",str(timeout),"--out",str(out/"eda")]
    cmd += ["--mapping-policy", mapping_policy]
    for name,value in sorted((parameters or {}).items()):
        cmd += ["--param", f"{name}={value}"]
    if cleanup_before_buffer:
        cmd += ["--cleanup-before-buffer"]
    t=time.monotonic()
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=timeout*4)
        output=p.stdout; code=p.returncode
    except subprocess.TimeoutExpired as e:
        raw=e.stdout or ""; output=raw.decode("utf-8",errors="replace") if isinstance(raw,bytes) else raw
        output+=f"\nOVERALL TIMEOUT after {timeout*4}s\n"; code=124
    (out/"runner.log").write_text(output,encoding="utf-8")
    return code,output,round(time.monotonic()-t,3)

def main() -> int:
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--model",default=os.environ.get("PIPEWEAVER_LLM_MODEL"))
    ap.add_argument("--timeout",type=int,default=TIMEOUT)
    ap.add_argument("--llm-timeout",type=int,default=300)
    args=ap.parse_args()
    if not BASE.is_file(): ap.error(f"Missing baseline: {BASE}")
    if api_configured() and not args.model: ap.error("Pass exact --model; no API call has been made")
    study=ROOT/"eda"/"experiments"/datetime.now().strftime("native_mul_three_arm_%Y%m%d_%H%M%S_%f")
    study.mkdir(parents=True,exist_ok=False)
    (study/"baseline").mkdir(); rtl=BASE.read_text(encoding="utf-8")
    (study/"baseline"/"baseline.v").write_text(rtl,encoding="utf-8")
    report_file=study/"baseline"/"sta.log"
    code,out,elapsed=run_eval(BASE,study/"baseline"/"evaluation",args.timeout)
    if code or not (study/"baseline"/"evaluation"/"eda"/"result.json").is_file():
        (study/"baseline"/"baseline_runner.log").write_text(out,encoding="utf-8")
        print(f"Baseline failed; no candidates generated. See {study}"); return 1
    baseline=json.loads((study/"baseline"/"evaluation"/"eda"/"result.json").read_text(encoding="utf-8"))
    report_file.write_text((study/"baseline"/"evaluation"/"eda"/"sta.log").read_text(encoding="utf-8",errors="replace"),encoding="utf-8")
    base_sta=report_file.read_text(encoding="utf-8")
    cone_file=study/"baseline"/"evaluation"/"eda"/"rtl_source_cone.json"
    baseline_cone=json.loads(cone_file.read_text(encoding="utf-8")) if cone_file.is_file() else None
    (study/"prompts").mkdir()
    prompts={"generic_llm":make_prompt(rtl,None),"sta_guided_llm":make_prompt(rtl,base_sta,baseline_cone),
             "constrained_search":"Three deterministic partial-product reduction trees: adjacent pairs; low/high band pairs; even/odd band pairs. Preserve all eight unsigned partial-product rows and combine with balanced two-input addition trees. Every result must be proved against original RTL for all 65,536 input pairs."}
    for arm,p in prompts.items(): (study/"prompts"/f"{arm}.txt").write_text(p,encoding="utf-8")
    protocol={"study":"native combinational 8x8 unsigned multiplier three-arm equal-budget pilot","baseline":"benchmark/rtl_opt_upstream_hkust/benchmark/mul_subexpression/mul_subexpression.v","baseline_sha256":sha(BASE),"top":TOP,"candidate_budget_per_arm":CANDIDATES,"total_slots":9,"model_requested":args.model,"temperature":TEMP,"api_key_configured":api_configured(),"baseline_metrics":baseline,"baseline_runtime_seconds":elapsed,"baseline_sta_sha256":sha(report_file),"baseline_rtl_cone_sha256":sha(cone_file) if cone_file.is_file() else None,"evaluator":"eda/experiments/run_native_comb.py","evaluator_sha256":sha(EVALUATOR),"protocol_conditions":{"formal":"full combinational SAT equivalence for all input values; only formally passing candidates proceed to PPA","mapping_and_sta":"same evaluator, SKY130HD TT, ABC script, fixed virtual-clock SDC; max combinational data arrival is primary metric","sta_guidance":"raw baseline report plus conservative pre-ABC RTL operator cone when available; never described as exact gate-to-source mapping","area_cap_ratio":AREA_RATIO,"success":"formal PASS, PPA PASS, area <= 110% baseline, and max_data_arrival strictly below baseline","all_scheduled_slots_in_denominator":True},"prompt_sha256":{k:hashlib.sha256(v.encode()).hexdigest() for k,v in prompts.items()},"tool_versions":baseline.get("tool_versions"),"model_route_note":"Record API response identifier only; service aliases may route dynamically."}
    write(study/"protocol.json",protocol); ph=sha(study/"protocol.json"); (study/"protocol.sha256").write_text(ph+"  protocol.json\n",encoding="ascii")
    slots=[]
    for arm in ("generic_llm","sta_guided_llm"):
        for i in range(1,CANDIDATES+1):
            cid=f"candidate_{i:02d}"; folder=study/arm/cid; folder.mkdir(parents=True)
            prompt=prompts[arm]; (folder/"prompt.txt").write_text(prompt,encoding="utf-8")
            rec={"arm":arm,"candidate_id":cid,"prompt_sha256":hashlib.sha256(prompt.encode()).hexdigest(),"requested_model":args.model,"temperature":TEMP,"status":"PENDING_GENERATION","candidate_sha256":None,"formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
            t=time.monotonic()
            try:
                gen=generate_from_prompt(prompt,model=args.model,temperature=TEMP,candidate_index=i,timeout_s=args.llm_timeout)
                vf=folder/"candidate.v"; vf.write_text(gen.rtl,encoding="utf-8")
                rec.update({"status":"GENERATED","candidate_sha256":sha(vf),"response_model_id":gen.model,"generation_parameters":gen.generation_parameters,"explanation":gen.explanation,"generation_runtime_seconds":round(time.monotonic()-t,3)})
            except LLMGenerationError as e:
                rec.update({"status":"FAILED_GENERATION","failure_reason":str(e),"generation_runtime_seconds":round(time.monotonic()-t,3)})
            write(folder/"generation.json",rec); slots.append(rec)
    cprompt=prompts["constrained_search"]
    for i in range(1,CANDIDATES+1):
        cid=f"candidate_{i:02d}"; folder=study/"constrained_search"/cid; folder.mkdir(parents=True)
        (folder/"prompt.txt").write_text(cprompt,encoding="utf-8")
        vf=folder/"candidate.v"; vf.write_text(candidate_tree(i),encoding="utf-8")
        rec={"arm":"constrained_search","candidate_id":cid,"status":"GENERATED","prompt_sha256":hashlib.sha256(cprompt.encode()).hexdigest(),"candidate_sha256":sha(vf),"formal_status":"NOT_RUN","ppa_status":"NOT_RUN","rewrite":"one of three balanced reduction trees over exact unsigned partial-product rows","tree_id":i}
        write(folder/"generation.json",rec); slots.append(rec)
    manifest={"protocol_sha256":ph,"frozen_at":datetime.now().astimezone().isoformat(),"slots":slots}
    write(study/"candidate_manifest.json",manifest); (study/"candidate_manifest.sha256").write_text(sha(study/"candidate_manifest.json")+"  candidate_manifest.json\n",encoding="ascii")
    if sha(study/"protocol.json")!=ph: raise RuntimeError("Frozen protocol changed")
    results=[]
    for rec in slots:
        folder=study/rec["arm"]/rec["candidate_id"]; vf=folder/"candidate.v"; t=time.monotonic()
        if not vf.is_file(): rec.update({"status":"FAILED_GENERATION","formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}); write(folder/"result.json",rec); results.append(rec); continue
        code,out,run_time=run_eval(vf,folder/"evaluation",args.timeout)
        er=folder/"evaluation"/"eda"/"result.json"
        rec["evaluation_runtime_seconds"]=run_time
        if code==0 and er.is_file():
            metrics=json.loads(er.read_text(encoding="utf-8")); rec.update({"status":"PASS","formal_status":metrics.get("formal"),"ppa_status":metrics.get("ppa"),"metrics":metrics,"area_within_limit":metrics.get("mapped_area_um2",1e99)<=baseline["mapped_area_um2"]*AREA_RATIO+1e-9,"arrival_improved":metrics.get("max_data_arrival_ns",1e99)<baseline["max_data_arrival_ns"]})
        else:
            # Evaluator writes a structured result on failure; preserve accurate stage status.
            metrics=json.loads(er.read_text(encoding="utf-8")) if er.is_file() else {}
            rec.update({"status":"FAILED_EVALUATION","formal_status":metrics.get("formal","ERROR"),"ppa_status":metrics.get("ppa","NOT_RUN"),"metrics":metrics,"failure_reason":out[-2500:]})
        write(folder/"result.json",rec); results.append(rec)
    groups={}
    for arm in ("generic_llm","sta_guided_llm","constrained_search"):
        rr=[x for x in results if x["arm"]==arm]
        passes=[x for x in rr if x.get("formal_status")=="PASS" and x.get("ppa_status")=="PASS"]
        elig=[x for x in passes if x.get("area_within_limit")]
        improvements=[x for x in elig if x.get("arrival_improved")]
        groups[arm]={"scheduled":3,"generated":sum(x.get("candidate_sha256") is not None for x in rr),"formal_pass":sum(x.get("formal_status")=="PASS" for x in rr),"ppa_complete":len(passes),"area_eligible":len(elig),"valid_improvements":len(improvements),"best_max_data_arrival_ns":min((x["metrics"]["max_data_arrival_ns"] for x in elig),default=None),"failures":[{"candidate":x["candidate_id"],"formal":x.get("formal_status"),"ppa":x.get("ppa_status"),"reason":x.get("failure_reason")} for x in rr if x.get("status")!="PASS"]}
    summary={"protocol_sha256":ph,"baseline":baseline,"groups":groups,"interpretation_limit":"One unsigned 8x8 combinational multiplier, one library corner/SDC and three candidate slots per method; pre-layout only.","total_llm_tokens":sum(x.get("generation_parameters",{}).get("usage",{}).get("total_tokens",0) for x in slots)}
    write(study/"summary.json",summary)
    lines=["# Native 8x8 multiplier: three-arm study","",f"Protocol SHA-256: `{ph}`","",f"Baseline: max data arrival {baseline.get('max_data_arrival_ns')} ns, area {baseline.get('mapped_area_um2')} µm².","","| Method | Valid improvements | Formal pass | PPA complete | Best area-eligible data arrival (ns) |","|---|---:|---:|---:|---:|"]
    for a,g in groups.items(): lines.append(f"| {a} | {g['valid_improvements']}/3 | {g['formal_pass']}/3 | {g['ppa_complete']}/3 | {g['best_max_data_arrival_ns']} |")
    lines += ["","## Scope","",summary["interpretation_limit"],"", "Every slot and raw prompt, model record, candidate RTL, formal log and OpenSTA log is preserved. API generation failures and formal failures remain in the denominator.",""]
    (study/"SUMMARY.md").write_text("\n".join(lines),encoding="utf-8")
    print(f"Study: {study}"); print(f"Protocol SHA-256: {ph}"); print(json.dumps(groups,indent=2)); return 0
if __name__=="__main__": raise SystemExit(main())
