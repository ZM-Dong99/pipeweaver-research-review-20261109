"""Resume an interrupted RTL-OPT multiplier study without repeating completed API calls."""
from __future__ import annotations
import hashlib,json,sys,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.optimization_loop import check_syntax,validate_candidate,parse_sta,redact_project_path
from agents.rtl_optimizer import generate_from_prompt,LLMGenerationError
from eda.experiments import run_rtlopt_mul_three_arm as m

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def writej(p,x): p.write_text(json.dumps(x,indent=2,ensure_ascii=False,allow_nan=False),encoding="utf-8")
def main():
    study=ROOT/"eda/experiments/rtlopt_mul_three_arm_20261028_231755_630172"
    protocol=json.loads((study/"protocol.json").read_text(encoding="utf-8"))
    ph=sha(study/"protocol.json")
    model=protocol["requested_model"]; budget=protocol["candidate_budget_per_arm"]
    prompts={arm:(study/"prompts"/(arm+".txt")).read_text(encoding="utf-8") for arm in ("generic_llm","sta_guided_llm")}
    slots=[]
    for arm in ("generic_llm","sta_guided_llm"):
        for i in range(1,budget+1):
            folder=study/arm/f"candidate_{i:02d}"; folder.mkdir(exist_ok=True)
            gp=folder/"generation.json"
            if gp.is_file():
                rec=json.loads(gp.read_text(encoding="utf-8"))
                if rec.get("status")=="GENERATED" and (folder/"candidate.v").is_file():
                    slots.append(rec); continue
            (folder/"prompt.txt").write_text(prompts[arm],encoding="utf-8")
            rec={"arm":arm,"candidate_id":f"candidate_{i:02d}","requested_model":model,
                 "prompt_sha256":sha(study/"prompts"/(arm+".txt")),"status":"PENDING_GENERATION",
                 "formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
            st=time.monotonic()
            try:
                gen=generate_from_prompt(prompts[arm],model=model,temperature=protocol["temperature"],
                                         candidate_index=i,timeout_s=180)
                raw=folder/"model_candidate.v"; raw.write_text(gen.rtl,encoding="utf-8")
                cand=folder/"candidate.v"; cand.write_text(m.wrap_mul(gen.rtl),encoding="utf-8")
                rec.update({"status":"GENERATED","candidate_sha256":sha(cand),"native_candidate_sha256":sha(raw),
                    "response_model_id":gen.model,"generation_parameters":gen.generation_parameters,
                    "explanation":gen.explanation,"generation_runtime_seconds":round(time.monotonic()-st,3)})
            except LLMGenerationError as e:
                rec.update({"status":"FAILED_GENERATION","failure_reason":str(e),
                            "generation_runtime_seconds":round(time.monotonic()-st,3)})
            writej(gp,rec); slots.append(rec)
    (study/"constrained_search").mkdir(exist_ok=True)
    native=m.BASE_SRC.read_text(encoding="utf-8-sig")
    for i,(rule,rawrtl) in enumerate(m.constrained_variants(native),1):
        folder=study/"constrained_search"/f"candidate_{i:02d}"; folder.mkdir(exist_ok=True)
        cand=folder/"candidate.v"; cand.write_text(m.wrap_mul(rawrtl),encoding="utf-8")
        rec={"arm":"constrained_search","candidate_id":f"candidate_{i:02d}","status":"GENERATED",
             "candidate_sha256":sha(cand),"generation_parameters":{"rewrite_rule":rule},
             "formal_status":"NOT_RUN","ppa_status":"NOT_RUN"}
        writej(folder/"generation.json",rec); slots.append(rec)
    manifest={"protocol_sha256":ph,"frozen_at":__import__("datetime").datetime.now().astimezone().isoformat(),"candidate_slots":slots}
    writej(study/"candidate_manifest.json",manifest)
    (study/"candidate_manifest.sha256").write_text(sha(study/"candidate_manifest.json")+"  candidate_manifest.json\n",encoding="ascii")
    baseline=json.loads((study/"baseline/reproduction/result.json").read_text(encoding="utf-8"))
    results=[]
    for rec in slots:
        folder=study/rec["arm"]/rec["candidate_id"]
        st=time.monotonic()
        if rec["status"]!="GENERATED":
            rec["total_runtime_seconds"]=rec.get("generation_runtime_seconds"); writej(folder/"result.json",rec); results.append(rec); continue
        cand=folder/"candidate.v"
        try:
            rec["structure"]=validate_candidate(cand)
            rec["validation"]=check_syntax(cand,folder,300); rec["validation_status"]="PASS"
        except Exception as e:
            rec.update({"status":"FAILED_VALIDATION","validation_status":"FAIL",
                "failure_reason":f"{type(e).__name__}: {e}","ppa_status":"NOT_ELIGIBLE"})
            rec["total_runtime_seconds"]=round(time.monotonic()-st+rec.get("generation_runtime_seconds",0),3)
            writej(folder/"result.json",rec); results.append(rec); continue
        code,out,runtime=m.run_eval(cand,folder/"evaluation"/"eda",300)
        rec["pipeline_runtime_seconds"]=runtime
        rec["total_runtime_seconds"]=round(time.monotonic()-st+rec.get("generation_runtime_seconds",0),3)
        if code==0 and (folder/"evaluation/eda/result.json").is_file():
            metrics=json.loads((folder/"evaluation/eda/result.json").read_text(encoding="utf-8"))
            rec.update({"status":"PASS","formal_status":"PASS","ppa_status":"PASS","metrics":metrics,
                "sta_context":parse_sta(folder/"evaluation/eda/sta.log"),
                "area_within_limit":metrics["mapped_area_um2"]<=baseline["mapped_area_um2"]*protocol["area_cap_ratio"]+1e-9,
                "area_delta_percent":(metrics["mapped_area_um2"]/baseline["mapped_area_um2"]-1)*100})
        else:
            pl=folder/"evaluation/eda/formal_proof.log"
            passed=pl.is_file() and "Status: PASSED" in pl.read_text(encoding="utf-8",errors="replace")
            rec.update({"status":"FAILED_EVALUATION","formal_status":"PASS" if passed else "FAIL",
                "ppa_status":"FAIL" if passed else "NOT_ELIGIBLE","failure_reason":redact_project_path(out[-3000:])})
        writej(folder/"result.json",rec); results.append(rec)
    groups={}
    for arm in ("generic_llm","sta_guided_llm","constrained_search"):
        rows=[x for x in results if x["arm"]==arm]
        complete=[x for x in rows if x.get("formal_status")=="PASS" and x.get("ppa_status")=="PASS"]
        eligible=[x for x in complete if x.get("area_within_limit")]
        groups[arm]={"generated":sum(x.get("candidate_sha256") is not None for x in rows),
          "formal_passed":sum(x.get("formal_status")=="PASS" for x in rows),"ppa_complete":len(complete),
          "area_eligible":len(eligible),"best_eligible_wns_ns":max((x["metrics"]["wns_ns"] for x in eligible),default=None),
          "average_wns_ns":sum(x["metrics"]["wns_ns"] for x in complete)/len(complete) if complete else None,
          "average_area_delta_percent":sum(x["area_delta_percent"] for x in complete)/len(complete) if complete else None,
          "outcomes":[{"candidate":x["candidate_id"],"status":x["status"],"formal":x.get("formal_status"),
           "ppa":x.get("ppa_status"),"wns_ns":x.get("metrics",{}).get("wns_ns"),
           "area_um2":x.get("metrics",{}).get("mapped_area_um2"),"area_delta_percent":x.get("area_delta_percent"),
           "area_eligible":x.get("area_within_limit"),"failure":x.get("failure_reason")} for x in rows]}
    total_tokens=sum(x.get("generation_parameters",{}).get("usage",{}).get("total_tokens",0) for x in results)
    summary={"study":study.name,"protocol_sha256":ph,"baseline":baseline,"groups":groups,
             "llm_total_tokens":total_tokens,"interpretation_limit":protocol["interpretation_limit"]}
    writej(study/"summary.json",summary)
    lines=["# RTL-OPT multiplier three-arm study","","Protocol SHA-256: "+ph,"",
      "| Method | Generated | Formal pass | PPA complete | Area eligible | Best eligible WNS | Mean WNS | Mean area delta |",
      "|---|---:|---:|---:|---:|---:|---:|---:|"]
    for arm,g in groups.items():
        f=lambda v:"—" if v is None else f"{v:.3f}"
        lines.append(f"| {arm} | {g['generated']}/3 | {g['formal_passed']}/3 | {g['ppa_complete']} | {g['area_eligible']} | {f(g['best_eligible_wns_ns'])} | {f(g['average_wns_ns'])} | {f(g['average_area_delta_percent'])}% |")
    (study/"SUMMARY.md").write_text("\n".join(lines)+"\n\nAPI total tokens: "+str(total_tokens)+"\n",encoding="utf-8")
    print("Study:",study.relative_to(ROOT)); print(json.dumps(groups,indent=2,ensure_ascii=False))
if __name__=="__main__": main()

