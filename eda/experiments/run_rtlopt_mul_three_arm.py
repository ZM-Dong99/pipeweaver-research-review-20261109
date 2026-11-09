"""Equal-budget three-arm study on RTL-OPT's signed 8x8 multiplier."""
from __future__ import annotations
import argparse, hashlib, json, os, re, subprocess, sys, time
from datetime import datetime
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.optimization_loop import check_syntax,validate_candidate,parse_sta,redact_project_path
from agents.rtl_optimizer import api_configured,generate_from_prompt,LLMGenerationError

BENCH=ROOT/"benchmark/rtl_opt_upstream_hkust/benchmark"
BASE_SRC=BENCH/"mul/mul.v"
BASE_ADAPTER=ROOT/"eda/experiments/rtlopt_pair_eval_20261028/mul_mul_cand.v"
BASE_GOLD=ROOT/"eda/experiments/rtlopt_pair_eval_20261028/mul_mul_gold.v"
BASE_METRICS=ROOT/"eda/experiments/rtlopt_pair_eval_20261028/mul_baseline_final/result.json"
STA_REPORT=ROOT/"eda/experiments/rtlopt_pair_eval_20261028/mul_baseline_final/sta.log"
EVAL=ROOT/"eda/experiments/sky130_optimize_20261027/run_experiment.py"
LIB=ROOT/"eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
SDC=ROOT/"eda/experiments/sky130_sta_20261027/timing_adder.sdc"
BUDGET=3; AREA_RATIO=1.10; TEMP=0.2

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def writej(p,x): p.write_text(json.dumps(x,indent=2,ensure_ascii=False,allow_nan=False),encoding="utf-8")
def wrap_mul(native,module="mul"):
    return ("module timing_adder(\ninput wire clk,\ninput wire rst_n,\ninput wire [31:0] a,\ninput wire [31:0] b,\ninput wire [31:0] c,\noutput wire [31:0] y\n);\n"
      "wire signed [7:0] q;\n"+module+" dut(.clk(clk),.a($signed(a[7:0])),.b($signed(b[7:0])),.z(q));\n"
      "assign y={24'b0,q};\nendmodule\n\n"+native.rstrip()+"\n")
def prompt_mul(native,sta=None):
    s=("Optimize this signed 8-bit pipelined multiplier for mapped timing and area. Preserve module name mul, "
       "exact ports and signedness, one-cycle registered output behavior, and exact output bits for every input. "
       "Do not change latency or protocol. Return one JSON object with candidate_rtl, bottleneck, rewrite, "
       "expected_timing_gain, area_or_other_cost, functional_boundaries. candidate_rtl must define the native "
       "module mul and contain synthesizable Verilog only; do not include the evaluator wrapper.\n\nBaseline RTL:\n"+native)
    if sta: s+="\n\nMeasured baseline OpenSTA critical-path report. Use it as evidence; do not claim unreported path behavior:\n"+sta
    return s
def split_product():
    return """wire signed [15:0] pp_hh = $signed(a[7:4]) * $signed(b[7:4]);
wire signed [15:0] pp_hl = $signed(a[7:4]) * $signed({1'b0,b[3:0]});
wire signed [15:0] pp_lh = $signed({1'b0,a[3:0]}) * $signed(b[7:4]);
wire signed [15:0] pp_ll = $signed({8'b0,(a[3:0] * b[3:0])});
"""
def constrained_variants(native):
    ref=Path(BENCH/"mul_ref/mul_ref.v").read_text(encoding="utf-8-sig")
    ref=re.sub(r"\bmodule\s+mul_ref\b","module mul",ref,count=1)
    parts=split_product()
    product="""wire signed [15:0] product;
assign product = (pp_hh <<< 8) + ((pp_hl + pp_lh) <<< 4) + pp_ll;
"""
    decl="""wire signed [15:0] pp_hh = $signed(a[7:4]) * $signed(b[7:4]);
wire signed [15:0] pp_hl = $signed(a[7:4]) * $signed({1'b0,b[3:0]});
wire signed [15:0] pp_lh = $signed({1'b0,a[3:0]}) * $signed(b[7:4]);
wire signed [15:0] pp_ll = $signed({8'b0,(a[3:0] * b[3:0])});
"""
    partial=decl+product+"assign t = product + 16'sd128;"
    partial=re.sub(r"assign t = a \* b \+ \(1<<7\);",partial,native,count=1)
    partial_roundbit=partial.replace("assign t = product + 16'sd128;","assign t = product;\n    wire signed [7:0] z_next = t[15:8] + t[7];",1)
    partial_roundbit=partial_roundbit.replace("z <= t[15:8];","z <= z_next;",1)
    return [("round_bit_rewrite",ref),("4x4_partial_product_baseline_round",partial),
            ("4x4_partial_product_round_bit",partial_roundbit)]
def run_eval(candidate,out,timeout):
    env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    yosys=Path(os.environ.get("YOSYS",r"D:\\oss-cad-suite\\bin\\yosys.exe"))
    env["PATH"]=os.pathsep.join([str(yosys.parent),str(yosys.parent.parent/"lib"),env.get("PATH","")])
    cmd=[sys.executable,"-B",str(EVAL),str(candidate),"--reference-rtl",str(BASE_GOLD),"--out-dir",str(out),"--timeout",str(timeout)]
    st=time.monotonic()
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,text=True,encoding="utf-8",errors="replace",stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout*4)
        return p.returncode,p.stdout,round(time.monotonic()-st,3)
    except subprocess.TimeoutExpired as e:
        outtxt=e.stdout or ""
        if isinstance(outtxt,bytes): outtxt=outtxt.decode("utf-8",errors="replace")
        return 124,outtxt+"\nOVERALL_TIMEOUT\n",round(time.monotonic()-st,3)
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--model",default=os.environ.get("PIPEWEAVER_LLM_MODEL"))
    ap.add_argument("--timeout",type=int,default=300); ap.add_argument("--llm-timeout",type=int,default=180)
    a=ap.parse_args()
    if not api_configured(): ap.error("OPENAI_API_KEY is not configured")
    if not a.model: ap.error("Pass the exact model ID")
    for f in (BASE_SRC,BASE_ADAPTER,BASE_GOLD,BASE_METRICS,STA_REPORT,LIB,SDC,EVAL):
        if not f.is_file(): ap.error(f"Required input missing: {f}")
    native=BASE_SRC.read_text(encoding="utf-8-sig"); old=json.loads(BASE_METRICS.read_text(encoding="utf-8"))
    sta=STA_REPORT.read_text(encoding="utf-8",errors="replace")
    study=ROOT/"eda/experiments"/datetime.now().strftime("rtlopt_mul_three_arm_%Y%m%d_%H%M%S_%f")
    study.mkdir(parents=True,exist_ok=False); (study/"baseline").mkdir()
    code,out,elapsed=run_eval(BASE_ADAPTER,study/"baseline"/"reproduction",a.timeout)
    if code or not (study/"baseline/reproduction/result.json").is_file():
        writej(study/"baseline/failure.json",{"exit_code":code,"output":redact_project_path(out[-3000:])})
        raise SystemExit("Baseline reproduction failed; stopped before API calls.")
    baseline=json.loads((study/"baseline/reproduction/result.json").read_text(encoding="utf-8"))
    fields=("formal","wns_ns","tns_ns","mapped_area_um2","mapped_cells")
    same=all(baseline.get(k)==old.get(k) for k in fields)
    writej(study/"baseline/reproduction.json",{"matches_preserved_reference":same,"runtime_seconds":elapsed,"metrics":baseline})
    if not same: raise SystemExit("Baseline changed; no API calls made.")
    (study/"prompts").mkdir()
    prompts={"generic_llm":prompt_mul(native),"sta_guided_llm":prompt_mul(native,sta)}
    for arm,text in prompts.items(): (study/"prompts"/(arm+".txt")).write_text(text,encoding="utf-8")
    constraint=("Fixed 3-candidate search grammar: (1) round-bit extraction after product slice; "
      "(2) 4x4 signed/unsigned partial-product decomposition with baseline rounding; "
      "(3) same decomposition with round-bit extraction. Preserve signed arithmetic and one-cycle output.\n")
    (study/"prompts/constrained_search.txt").write_text(constraint,encoding="utf-8")
    protocol={"study":"RTL-OPT signed 8x8 multiplier three-arm equal-budget study","created_at":datetime.now().astimezone().isoformat(),
      "baseline_rtl":"benchmark/rtl_opt_upstream_hkust/benchmark/mul/mul.v","baseline_sha256":sha(BASE_SRC),
      "baseline_adapter_sha256":sha(BASE_ADAPTER),"reference_adapter_sha256":sha(BASE_GOLD),
      "baseline_metrics":{k:baseline.get(k) for k in fields},"candidate_budget_per_arm":BUDGET,
      "arms":{"generic_llm":{"sta_report_provided":False},"sta_guided_llm":{"sta_report_provided":True,"report_sha256":sha(STA_REPORT)},
      "constrained_search":{"candidate_rules":["round_bit_rewrite","4x4_partial_product_baseline_round","4x4_partial_product_round_bit"]}},
      "requested_model":a.model,"temperature":TEMP,"area_cap_ratio":AREA_RATIO,
      "formal":"Yosys temporal induction, cycle-output miter; initial reset warm-up",
      "mapping_sta":"Yosys + OpenSTA, SKY130HD TT Liberty and inherited timing_adder SDC",
      "sdc_sha256":sha(SDC),"liberty_sha256":sha(LIB),
      "adapter":{"a":"signed a[7:0]","b":"signed b[7:0]","z":"zero-extended to y[7:0]"},
      "interpretation_limit":"One multiplier design, adapter-based, pre-layout; no generalization."}
    writej(study/"protocol.json",protocol); ph=sha(study/"protocol.json")
    (study/"protocol.sha256").write_text(ph+"  protocol.json\n",encoding="ascii")
    slots=[]
    for arm in ("generic_llm","sta_guided_llm"):
      (study/arm).mkdir()
      for i in range(1,BUDGET+1):
        folder=study/arm/f"candidate_{i:02d}"; folder.mkdir(); (folder/"prompt.txt").write_text(prompts[arm],encoding="utf-8")
        rec={"arm":arm,"candidate_id":f"candidate_{i:02d}","requested_model":a.model,"status":"PENDING_GENERATION","formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
        st=time.monotonic()
        try:
          gen=generate_from_prompt(prompts[arm],model=a.model,temperature=TEMP,candidate_index=i,timeout_s=a.llm_timeout)
          raw=folder/"model_candidate.v"; raw.write_text(gen.rtl,encoding="utf-8")
          cand=folder/"candidate.v"; cand.write_text(wrap_mul(gen.rtl),encoding="utf-8")
          rec.update({"status":"GENERATED","candidate_sha256":sha(cand),"native_candidate_sha256":sha(raw),
            "response_model_id":gen.model,"generation_parameters":gen.generation_parameters,"explanation":gen.explanation,
            "generation_runtime_seconds":round(time.monotonic()-st,3)})
        except LLMGenerationError as e: rec.update({"status":"FAILED_GENERATION","failure_reason":str(e),"generation_runtime_seconds":round(time.monotonic()-st,3)})
        writej(folder/"generation.json",rec); slots.append(rec)
    (study/"constrained_search").mkdir()
    for i,(rule,rawrtl) in enumerate(constrained_variants(native),1):
      folder=study/"constrained_search"/f"candidate_{i:02d}"; folder.mkdir()
      cand=folder/"candidate.v"; cand.write_text(wrap_mul(rawrtl),encoding="utf-8")
      rec={"arm":"constrained_search","candidate_id":f"candidate_{i:02d}","status":"GENERATED","candidate_sha256":sha(cand),
           "generation_parameters":{"rewrite_rule":rule},"formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
      writej(folder/"generation.json",rec); slots.append(rec)
    manifest={"protocol_sha256":ph,"frozen_at":datetime.now().astimezone().isoformat(),"candidate_slots":slots}
    writej(study/"candidate_manifest.json",manifest)
    (study/"candidate_manifest.sha256").write_text(sha(study/"candidate_manifest.json")+"  candidate_manifest.json\n",encoding="ascii")
    results=[]
    for rec in slots:
      folder=study/rec["arm"]/rec["candidate_id"]
      if rec["status"]!="GENERATED": rec["total_runtime_seconds"]=rec.get("generation_runtime_seconds"); writej(folder/"result.json",rec); results.append(rec); continue
      st=time.monotonic(); cand=folder/"candidate.v"
      try:
        rec["structure"]=validate_candidate(cand); rec["validation"]=check_syntax(cand,folder,a.timeout); rec["validation_status"]="PASS"
      except Exception as e:
        rec.update({"status":"FAILED_VALIDATION","validation_status":"FAIL","failure_reason":f"{type(e).__name__}: {e}","ppa_status":"NOT_ELIGIBLE"})
        writej(folder/"result.json",rec); results.append(rec); continue
      code,out,runtime=run_eval(cand,folder/"evaluation"/"eda",a.timeout)
      rec["pipeline_runtime_seconds"]=runtime
      if code==0 and (folder/"evaluation/eda/result.json").is_file():
        m=json.loads((folder/"evaluation/eda/result.json").read_text(encoding="utf-8"))
        rec.update({"status":"PASS","formal_status":"PASS","ppa_status":"PASS","metrics":m,"sta_context":parse_sta(folder/"evaluation/eda/sta.log"),
          "area_within_limit":m["mapped_area_um2"]<=baseline["mapped_area_um2"]*AREA_RATIO+1e-9,
          "area_delta_percent":(m["mapped_area_um2"]/baseline["mapped_area_um2"]-1)*100})
      else:
        pl=folder/"evaluation/eda/formal_proof.log"; ok=pl.is_file() and "Status: PASSED" in pl.read_text(encoding="utf-8",errors="replace")
        rec.update({"status":"FAILED_EVALUATION","formal_status":"PASS" if ok else "FAIL","ppa_status":"FAIL" if ok else "NOT_ELIGIBLE","failure_reason":redact_project_path(out[-3000:])})
      rec["total_runtime_seconds"]=round(time.monotonic()-st+rec.get("generation_runtime_seconds",0),3)
      writej(folder/"result.json",rec); results.append(rec)
    groups={}
    for arm in ("generic_llm","sta_guided_llm","constrained_search"):
      rows=[r for r in results if r["arm"]==arm]; complete=[r for r in rows if r.get("formal_status")=="PASS" and r.get("ppa_status")=="PASS"]
      eligible=[r for r in complete if r.get("area_within_limit")]
      groups[arm]={"generated":sum(r.get("candidate_sha256") is not None for r in rows),"formal_passed":sum(r.get("formal_status")=="PASS" for r in rows),
        "ppa_complete":len(complete),"area_eligible":len(eligible),"best_eligible_wns_ns":max((r["metrics"]["wns_ns"] for r in eligible),default=None),
        "average_wns_ns":sum(r["metrics"]["wns_ns"] for r in complete)/len(complete) if complete else None,
        "average_area_delta_percent":sum(r["area_delta_percent"] for r in complete)/len(complete) if complete else None,
        "outcomes":[{"candidate":r["candidate_id"],"status":r["status"],"formal":r.get("formal_status"),"ppa":r.get("ppa_status"),
          "wns_ns":r.get("metrics",{}).get("wns_ns"),"area_um2":r.get("metrics",{}).get("mapped_area_um2"),
          "area_delta_percent":r.get("area_delta_percent"),"area_eligible":r.get("area_within_limit"),"failure":r.get("failure_reason")} for r in rows]}
    total_tokens=sum(r.get("generation_parameters",{}).get("usage",{}).get("total_tokens",0) for r in results)
    summary={"study":study.name,"protocol_sha256":ph,"baseline":baseline,"groups":groups,"llm_total_tokens":total_tokens,
      "interpretation_limit":protocol["interpretation_limit"]}
    writej(study/"summary.json",summary)
    lines=["# RTL-OPT multiplier three-arm study","","Protocol SHA-256: "+ph,"","| Method | Generated | Formal pass | PPA complete | Area eligible | Best eligible WNS | Mean WNS | Mean area delta |",
      "|---|---:|---:|---:|---:|---:|---:|---:|"]
    for arm,g in groups.items():
      f=lambda x:"—" if x is None else f"{x:.3f}"
      lines.append(f"| {arm} | {g['generated']}/3 | {g['formal_passed']}/3 | {g['ppa_complete']} | {g['area_eligible']} | {f(g['best_eligible_wns_ns'])} | {f(g['average_wns_ns'])} | {f(g['average_area_delta_percent'])}% |")
    lines += ["","Baseline: WNS "+str(baseline["wns_ns"])+" ns, area "+str(baseline["mapped_area_um2"])+" um^2. Area cap is baseline +10%.",
      "LLM API usage recorded in generation.json; summed total tokens: "+str(total_tokens)+".",protocol["interpretation_limit"]]
    (study/"SUMMARY.md").write_text("\n".join(lines)+"\n",encoding="utf-8")
    print("Study:",study.relative_to(ROOT)); print("Protocol:",ph); print(json.dumps(groups,indent=2,ensure_ascii=False))
if __name__=="__main__": main()

