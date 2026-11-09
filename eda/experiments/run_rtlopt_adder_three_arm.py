"""Three-arm equal-budget experiment on RTL-OPT's 32-bit adder example."""
from __future__ import annotations
import argparse, hashlib, json, os, re, subprocess, sys, time
from datetime import datetime
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.optimization_loop import check_syntax, validate_candidate, parse_sta, redact_project_path
from agents.rtl_optimizer import api_configured, generate_from_prompt, LLMGenerationError

BENCH=ROOT/"benchmark/rtl_opt_upstream_hkust/benchmark"
BASE_SRC=BENCH/"adder/adder.v"
BASE_ADAPTER=ROOT/"eda/experiments/rtlopt_adder_paired_eval_20261028/baseline_flat.v"
BASE_METRICS=ROOT/"eda/experiments/rtlopt_adder_paired_eval_20261028/baseline_eval_retry/result.json"
STA_REPORT=ROOT/"eda/experiments/rtlopt_adder_paired_eval_20261028/baseline_eval_retry/sta.log"
EVAL=ROOT/"eda/experiments/sky130_optimize_20261027/run_experiment.py"
LIB=ROOT/"eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
SDC=ROOT/"eda/experiments/sky130_sta_20261027/timing_adder.sdc"
BUDGET=3
AREA_RATIO=1.10
TEMP=0.2

def sha_bytes(b): return hashlib.sha256(b).hexdigest()
def sha_file(p): return sha_bytes(p.read_bytes())
def writej(p,x): p.write_text(json.dumps(x,indent=2,ensure_ascii=False,allow_nan=False),encoding="utf-8")
def wrap_adder(native, module="adder"):
    return ("module timing_adder(\ninput wire clk,\ninput wire rst_n,\ninput wire [31:0] a,\ninput wire [31:0] b,\ninput wire [31:0] c,\noutput wire [31:0] y\n);\n"
            "wire [31:0] q;\n"
            + module + " #(.N(32)) dut(.DATA_1(a),.DATA_2(b),.SEL_0(c[0]),.SEL_1(c[1]),.clk(clk),.reg_0(q));\n"
            "assign y=q;\nendmodule\n\n" + native.rstrip() + "\n")
def gold_rtl(native):
    renamed=re.sub(r"\bmodule\s+adder\b","module adder_gold",native,count=1)
    return wrap_adder(renamed,"adder_gold")
def carry_module(width):
    ngrp=32//width
    lines=[f"module grouped_add32_{width}(input wire [31:0] a,b,output wire [31:0] sum);",
           f"wire [{ngrp-1}:0] p,g; wire [{ngrp}:0] carry;"]
    for i in range(ngrp):
        lo,hi=i*width,(i+1)*width-1
        lines += [f"wire [{width}:0] gen_{i};",
                  f"assign gen_{i}={{1'b0,a[{hi}:{lo}]}}+{{1'b0,b[{hi}:{lo}]}};",
                  f"assign g[{i}]=gen_{i}[{width}];",
                  f"assign p[{i}]=&(a[{hi}:{lo}]^b[{hi}:{lo}]);"]
    lines.append("assign carry[0]=1'b0;")
    for k in range(ngrp):
        terms=[]
        for j in range(k,-1,-1):
            terms.append("("+" & ".join([f"p[{q}]" for q in range(k,j,-1)]+[f"g[{j}]"])+")")
        lines.append(f"assign carry[{k+1}]="+" | ".join(terms)+";")
    for i in range(ngrp):
        lo,hi=i*width,(i+1)*width-1
        lines.append(f"assign sum[{hi}:{lo}]=a[{hi}:{lo}]+b[{hi}:{lo}]+carry[{i}];")
    lines.append("endmodule")
    return "\n".join(lines)+"\n"
def constrained_candidate(native,width):
    pattern=r"\s*wire\s+\[N-1:0\]\s+Add_0\s*=\s*iso_DATA_1\s*\+\s*iso_DATA_2\s*;"
    repl=f"\n    wire [N-1:0] Add_0; grouped_add32_{width} add_grouped(.a(iso_DATA_1),.b(iso_DATA_2),.sum(Add_0));"
    changed,n=re.subn(pattern,repl,native,count=1)
    if n!=1: raise ValueError("Could not uniquely locate the baseline 32-bit addition")
    return changed+"\n"+carry_module(width)
def prompt(native,sta=None):
    text=("Optimize this RTL-OPT adder for mapped timing while preserving exact cycle behavior. "
          "Keep module name adder, parameter N, every port name/direction/width, clocked behavior, "
          "and modulo-2^N arithmetic. Do not add or remove pipeline stages, change latency, reset behavior, "
          "or input/output protocol. Return only the required JSON object with candidate_rtl, bottleneck, "
          "rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries. candidate_rtl must "
          "be synthesizable Verilog. It must define the native adder module; do not include the evaluator wrapper.\n\n"
          "Baseline RTL:\n"+native)
    if sta:
        text += "\n\nMeasured baseline OpenSTA report (use as evidence; do not assume an unreported bottleneck):\n"+sta
    return text
def run_eval(candidate,out,timeout):
    env=os.environ.copy()
    env.pop("OPENAI_API_KEY",None)
    yosys=Path(os.environ.get("YOSYS",r"D:\\oss-cad-suite\\bin\\yosys.exe"))
    env["PATH"]=os.pathsep.join([str(yosys.parent),str(yosys.parent.parent/"lib"),env.get("PATH","")])
    cmd=[sys.executable,"-B",str(EVAL),str(candidate),"--reference-rtl",str(BASE_ADAPTER),
         "--out-dir",str(out),"--timeout",str(timeout)]
    start=time.monotonic()
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,text=True,encoding="utf-8",errors="replace",
                         stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout*4)
        output=p.stdout; code=p.returncode
    except subprocess.TimeoutExpired as e:
        output=(e.stdout or "")
        if isinstance(output,bytes): output=output.decode("utf-8",errors="replace")
        output+="\nOVERALL_TIMEOUT\n"; code=124
    return code,output,round(time.monotonic()-start,3)
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--model",default=os.environ.get("PIPEWEAVER_LLM_MODEL"))
    ap.add_argument("--timeout",type=int,default=300)
    ap.add_argument("--llm-timeout",type=int,default=180)
    ap.add_argument("--reuse-generations",type=Path,help="reuse saved raw LLM outputs from a prior run; makes no API calls")
    a=ap.parse_args()
    if a.reuse_generations: a.reuse_generations=a.reuse_generations.resolve()
    if not a.reuse_generations and not api_configured(): ap.error("OPENAI_API_KEY is not configured; no experiment was started")
    if not a.model: ap.error("Pass the exact model ID using --model")
    for p in (BASE_SRC,BASE_ADAPTER,BASE_METRICS,STA_REPORT,LIB,SDC,EVAL):
        if not p.is_file(): ap.error(f"Required input missing: {p}")
    native=BASE_SRC.read_text(encoding="utf-8-sig")
    baseline=json.loads(BASE_METRICS.read_text(encoding="utf-8"))
    sta=STA_REPORT.read_text(encoding="utf-8",errors="replace")
    study=ROOT/"eda/experiments"/datetime.now().strftime("rtlopt_adder_three_arm_%Y%m%d_%H%M%S_%f")
    study.mkdir(parents=True,exist_ok=False)
    (study/"baseline").mkdir()
    # Reproduce the frozen baseline before spending API calls.
    code,out,elapsed=run_eval(BASE_ADAPTER,study/"baseline"/"reproduction",a.timeout)
    if code or not (study/"baseline/reproduction/result.json").is_file():
        writej(study/"baseline/reproduction_failure.json",{"exit_code":code,"output":redact_project_path(out[-4000:])})
        raise SystemExit("Baseline reproduction failed; no LLM API calls were made.")
    fresh=json.loads((study/"baseline/reproduction/result.json").read_text(encoding="utf-8"))
    keys=("formal","wns_ns","tns_ns","mapped_area_um2","mapped_cells")
    same=all(fresh.get(k)==baseline.get(k) for k in keys)
    writej(study/"baseline/reproduction.json",{"matches_preserved_reference":same,"runtime_seconds":elapsed,"metrics":fresh})
    if not same: raise SystemExit("Baseline differs from preserved reference; stopped before API calls.")
    prompts={"generic_llm":prompt(native),"sta_guided_llm":prompt(native,sta)}
    (study/"prompts").mkdir()
    for k,v in prompts.items(): (study/"prompts"/(k+".txt")).write_text(v,encoding="utf-8")
    cprompt=("Constrained search rule: preserve all state, ports, mux behavior, and cycle latency; replace only "
             "the 32-bit combinational adder with a grouped carry-lookahead implementation. Independently test "
             "group widths 4, 8, and 16 bits. All candidates are compared against the original RTL.\n")
    (study/"prompts/constrained_search.txt").write_text(cprompt,encoding="utf-8")
    protocol={"study":"RTL-OPT adder, equal-budget three-arm comparison","created_at":datetime.now().astimezone().isoformat(),
      "baseline_rtl":"benchmark/rtl_opt_upstream_hkust/benchmark/adder/adder.v","baseline_sha256":sha_file(BASE_SRC),
      "baseline_adapter_sha256":sha_file(BASE_ADAPTER),"baseline_metrics":{k:fresh.get(k) for k in keys},
      "candidate_budget_per_arm":BUDGET,"arms":{"generic_llm":{"sta_report_provided":False},
      "sta_guided_llm":{"sta_report_provided":True,"sta_report_sha256":sha_file(STA_REPORT)},
      "constrained_search":{"rule":"grouped carry-lookahead replacing only Add_0","widths":[4,8,16]}},
      "requested_model":a.model,"temperature":TEMP,"area_limit_ratio":AREA_RATIO,
      "formal":"Yosys temporal induction; compare wrapped output cycle-by-cycle after initial warm-up",
      "mapping_sta":"Yosys + OpenSTA; SKY130HD TT; fixed timing_adder SDC",
      "liberty_sha256":sha_file(LIB),"sdc_sha256":sha_file(SDC),
      "adapter_mapping":{"SEL_0":"c[0]","SEL_1":"c[1]","DATA_1":"a","DATA_2":"b"},
      "candidate_wrapper_interface":"explicit one-port-per-declaration to satisfy strict structural validation",
      "reused_model_outputs_from":str(a.reuse_generations.relative_to(ROOT)) if a.reuse_generations else None,
      "limitations":"One RTL-OPT adder design, inherited wrapper/SDC, no placement or routing."}
    writej(study/"protocol.json",protocol); ph=sha_file(study/"protocol.json")
    (study/"protocol.sha256").write_text(ph+"  protocol.json\n",encoding="ascii")
    slots=[]
    for arm in ("generic_llm","sta_guided_llm"):
      (study/arm).mkdir()
      for i in range(1,BUDGET+1):
        folder=study/arm/f"candidate_{i:02d}"; folder.mkdir()
        (folder/"prompt.txt").write_text(prompts[arm],encoding="utf-8")
        rec={"arm":arm,"candidate_id":f"candidate_{i:02d}","requested_model":a.model,
             "status":"PENDING_GENERATION","formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
        start=time.monotonic()
        try:
          if a.reuse_generations:
            oldfolder=a.reuse_generations/arm/f"candidate_{i:02d}"
            oldrec=json.loads((oldfolder/"generation.json").read_text(encoding="utf-8"))
            native_rtl=(oldfolder/"model_candidate.v").read_text(encoding="utf-8")
            raw=folder/"model_candidate.v"; raw.write_text(native_rtl,encoding="utf-8")
            wrapped=folder/"candidate.v"; wrapped.write_text(wrap_adder(native_rtl),encoding="utf-8")
            rec.update({"status":"GENERATED","candidate_sha256":sha_file(wrapped),"native_candidate_sha256":sha_file(raw),
              "response_model_id":oldrec.get("response_model_id"),"generation_parameters":oldrec.get("generation_parameters"),
              "explanation":oldrec.get("explanation"),"generation_runtime_seconds":oldrec.get("generation_runtime_seconds",0),
              "reused_from":str(oldfolder.relative_to(ROOT))})
          else:
            gen=generate_from_prompt(prompts[arm],model=a.model,temperature=TEMP,candidate_index=i,timeout_s=a.llm_timeout)
            raw=folder/"model_candidate.v"; raw.write_text(gen.rtl,encoding="utf-8")
            wrapped=folder/"candidate.v"; wrapped.write_text(wrap_adder(gen.rtl),encoding="utf-8")
            rec.update({"status":"GENERATED","candidate_sha256":sha_file(wrapped),"native_candidate_sha256":sha_file(raw),
              "response_model_id":gen.model,"generation_parameters":gen.generation_parameters,
              "explanation":gen.explanation,"generation_runtime_seconds":round(time.monotonic()-start,3)})
        except (LLMGenerationError, OSError, ValueError) as e:
          rec.update({"status":"FAILED_GENERATION","failure_reason":str(e),"generation_runtime_seconds":round(time.monotonic()-start,3)})
        writej(folder/"generation.json",rec); slots.append(rec)
    (study/"constrained_search").mkdir()
    for i,w in enumerate((4,8,16),1):
      folder=study/"constrained_search"/f"candidate_{i:02d}"; folder.mkdir()
      raw=constrained_candidate(native,w)
      wrapped=folder/"candidate.v"; wrapped.write_text(wrap_adder(raw),encoding="utf-8")
      rec={"arm":"constrained_search","candidate_id":f"candidate_{i:02d}","status":"GENERATED",
           "candidate_sha256":sha_file(wrapped),"requested_model":None,"generation_parameters":{"group_width_bits":w},
           "formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
      writej(folder/"generation.json",rec); slots.append(rec)
    writej(study/"candidate_manifest.json",{"protocol_sha256":ph,"frozen_at":datetime.now().astimezone().isoformat(),"candidate_slots":slots})
    results=[]
    for rec in slots:
      folder=study/rec["arm"]/rec["candidate_id"]
      if rec["status"]!="GENERATED":
        rec["total_runtime_seconds"]=rec.get("generation_runtime_seconds"); writej(folder/"result.json",rec); results.append(rec); continue
      start=time.monotonic(); cand=folder/"candidate.v"
      try:
        rec["structure"]=validate_candidate(cand)
        rec["validation"]=check_syntax(cand,folder,a.timeout); rec["validation_status"]="PASS"
      except Exception as e:
        rec.update({"status":"FAILED_VALIDATION","validation_status":"FAIL","failure_reason":f"{type(e).__name__}: {e}","ppa_status":"NOT_ELIGIBLE"})
        rec["total_runtime_seconds"]=round(time.monotonic()-start+rec.get("generation_runtime_seconds",0),3)
        writej(folder/"result.json",rec); results.append(rec); continue
      code,out,runsec=run_eval(cand,folder/"evaluation"/"eda",a.timeout)
      rec["pipeline_runtime_seconds"]=runsec
      rec["total_runtime_seconds"]=round(time.monotonic()-start+rec.get("generation_runtime_seconds",0),3)
      if code==0 and (folder/"evaluation/eda/result.json").is_file():
        m=json.loads((folder/"evaluation/eda/result.json").read_text(encoding="utf-8"))
        rec.update({"status":"PASS","formal_status":"PASS","ppa_status":"PASS","metrics":m,
          "sta_context":parse_sta(folder/"evaluation/eda/sta.log"),
          "area_within_limit":m["mapped_area_um2"]<=fresh["mapped_area_um2"]*AREA_RATIO+1e-9,
          "area_delta_percent":(m["mapped_area_um2"]/fresh["mapped_area_um2"]-1)*100})
      else:
        pl=folder/"evaluation/eda/formal_proof.log"
        passed=pl.is_file() and "Status: PASSED" in pl.read_text(encoding="utf-8",errors="replace")
        rec.update({"status":"FAILED_EVALUATION","formal_status":"PASS" if passed else "FAIL",
          "ppa_status":"FAIL" if passed else "NOT_ELIGIBLE","failure_reason":redact_project_path(out[-3000:])})
      writej(folder/"result.json",rec); results.append(rec)
    groups={}
    for arm in ("generic_llm","sta_guided_llm","constrained_search"):
      rows=[r for r in results if r["arm"]==arm]
      complete=[r for r in rows if r.get("formal_status")=="PASS" and r.get("ppa_status")=="PASS"]
      eligible=[r for r in complete if r.get("area_within_limit")]
      groups[arm]={"slots":BUDGET,"generated":sum(r.get("candidate_sha256") is not None for r in rows),
        "formal_passed":sum(r.get("formal_status")=="PASS" for r in rows),"ppa_complete":len(complete),
        "area_eligible":len(eligible),"best_eligible_wns_ns":max((r["metrics"]["wns_ns"] for r in eligible),default=None),
        "average_wns_ns":sum(r["metrics"]["wns_ns"] for r in complete)/len(complete) if complete else None,
        "average_area_delta_percent":sum(r["area_delta_percent"] for r in complete)/len(complete) if complete else None,
        "outcomes":[{"candidate":r["candidate_id"],"status":r["status"],"formal":r.get("formal_status"),
          "ppa":r.get("ppa_status"),"wns_ns":r.get("metrics",{}).get("wns_ns"),
          "area_um2":r.get("metrics",{}).get("mapped_area_um2"),"area_eligible":r.get("area_within_limit"),
          "failure":r.get("failure_reason")} for r in rows]}
    summary={"study":study.name,"protocol_sha256":ph,"baseline":fresh,"groups":groups,
      "interpretation_limit":"Single adder RTL, adapter-based constraints, SKY130HD pre-layout PPA; no generalization."}
    writej(study/"summary.json",summary)
    lines=["# RTL-OPT adder three-arm study","","Protocol SHA-256: "+ph,"","| Method | Generated / 3 | Formal pass | PPA complete | Area eligible | Best WNS (ns) | Mean WNS (ns) | Mean area delta |","|---|---:|---:|---:|---:|---:|---:|---:|"]
    for arm,g in groups.items():
      f=lambda x:"—" if x is None else f"{x:.3f}"
      lines.append(f"| {arm} | {g['generated']}/3 | {g['formal_passed']}/3 | {g['ppa_complete']} | {g['area_eligible']} | {f(g['best_eligible_wns_ns'])} | {f(g['average_wns_ns'])} | {f(g['average_area_delta_percent'])}% |")
    lines += ["","Baseline WNS "+str(fresh["wns_ns"])+" ns; area "+str(fresh["mapped_area_um2"])+" um^2.",
      "Area eligibility cap: baseline mapped area * 1.10. Generated candidates and failures are retained.",
      "Scope: "+summary["interpretation_limit"]+"."]
    (study/"SUMMARY.md").write_text("\n".join(lines)+"\n",encoding="utf-8")
    print("Study:",study.relative_to(ROOT)); print("Protocol SHA-256:",ph); print(json.dumps(groups,indent=2,ensure_ascii=False))
if __name__=="__main__": main()

