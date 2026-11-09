"""Re-evaluate every frozen native multiplier candidate after fixing helper-module handling."""
from __future__ import annotations
import argparse, hashlib, json, os, subprocess, sys, time
from datetime import datetime
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
EVALUATOR=ROOT/"eda/experiments/run_native_comb.py"
BASE=ROOT/"benchmark/rtl_opt_upstream_hkust/benchmark/mul_subexpression/mul_subexpression.v"
TOP="mul_subexpression"
def sha(p:Path)->str:return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p:Path,x:dict)->None:p.write_text(json.dumps(x,indent=2,ensure_ascii=False,allow_nan=False),encoding="utf-8")
def run(candidate:Path,out:Path,timeout:int)->tuple[int,str,float]:
    out.mkdir(parents=True,exist_ok=False)
    yosys=Path(os.environ.get("YOSYS",r"D:\oss-cad-suite\bin\yosys.exe")); env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    env["PATH"]=os.pathsep.join((str(yosys.parent),str(yosys.parent.parent/"lib"),env.get("PATH","")))
    cmd=[sys.executable,"-B",str(EVALUATOR),str(candidate),"--reference",str(BASE),"--top",TOP,"--timeout",str(timeout),"--out",str(out/"eda")]
    t=time.monotonic()
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=timeout*4)
        output=p.stdout; code=p.returncode
    except subprocess.TimeoutExpired as e:
        raw=e.stdout or ""; output=raw.decode("utf-8",errors="replace") if isinstance(raw,bytes) else raw
        output+=f"\nOVERALL_TIMEOUT after {timeout*4}s\n"; code=124
    (out/"runner.log").write_text(output,encoding="utf-8")
    return code,output,round(time.monotonic()-t,3)
def main()->int:
    ap=argparse.ArgumentParser(description=__doc__); ap.add_argument("study",type=Path); ap.add_argument("--timeout",type=int,default=180); a=ap.parse_args()
    study=a.study.resolve(); manifest_path=study/"candidate_manifest.json"; orig_protocol=study/"protocol.json"
    if not manifest_path.is_file() or not orig_protocol.is_file(): ap.error("Study is missing frozen protocol or candidate manifest")
    manifest=json.loads(manifest_path.read_text(encoding="utf-8")); protocol=json.loads(orig_protocol.read_text(encoding="utf-8"))
    frozen_manifest_hash=sha(manifest_path); frozen_protocol_hash=sha(orig_protocol)
    slots=manifest.get("slots") or manifest.get("candidate_slots")
    if not isinstance(slots,list) or len(slots)!=9: ap.error("Expected exactly nine frozen candidate slots")
    for s in slots:
        candidate=study/s["arm"]/s["candidate_id"]/"candidate.v"
        if not candidate.is_file() or sha(candidate)!=s.get("candidate_sha256"):
            ap.error(f"Candidate hash mismatch or missing: {candidate}")
    out=study/("reevaluation_fixed_helper_handling_"+datetime.now().strftime("%Y%m%d_%H%M%S"))
    out.mkdir(parents=True,exist_ok=False)
    rp={"reevaluation":"all frozen candidates, no new LLM calls","source_study":study.name,"source_protocol_sha256":frozen_protocol_hash,"source_manifest_sha256":frozen_manifest_hash,"candidate_hashes":[{"arm":s["arm"],"candidate_id":s["candidate_id"],"sha256":s["candidate_sha256"]} for s in slots],"reason":"The initial general RTL evaluator failed to flatten model-generated helper modules before equivalence/mapping. Updated evaluator separately hierarchizes and flattens candidate/reference; mapping deletes nonfunctional $scopeinfo cells. All nine frozen candidate RTL files are re-evaluated, not only failed slots.","evaluator":"eda/experiments/run_native_comb.py","evaluator_sha256":sha(EVALUATOR),"baseline_sha256":sha(BASE),"top":TOP,"candidate_budget_per_arm":3,"timeout_seconds":a.timeout,"acceptance":"formal PASS, PPA PASS, area <= 110% reproduced baseline, and max_data_arrival_ns strictly below baseline","input_protocol_sha256":protocol.get("protocol_sha256"),"no_api_calls":True}
    write(out/"reevaluation_protocol.json",rp); rph=sha(out/"reevaluation_protocol.json")
    code,txt,sec=run(BASE,out/"baseline",a.timeout); br=out/"baseline"/"eda"/"result.json"
    if code or not br.is_file():
        (out/"FAILED.md").write_text("Baseline reevaluation failed; no candidates were evaluated.\n",encoding="utf-8"); print(txt); return 1
    baseline=json.loads(br.read_text(encoding="utf-8"))
    if baseline.get("formal")!="PASS" or baseline.get("ppa")!="PASS": raise RuntimeError("Re-evaluated baseline did not pass formal+PPA")
    results=[]; base_area=baseline["mapped_area_um2"]
    for slot in slots:
        src=study/slot["arm"]/slot["candidate_id"]/"candidate.v"; dest=out/slot["arm"]/slot["candidate_id"]
        code,txt,elapsed=run(src,dest,a.timeout); ep=dest/"eda"/"result.json"
        rr={"arm":slot["arm"],"candidate_id":slot["candidate_id"],"candidate_sha256":sha(src),"source_generation_json":str((study/slot["arm"]/slot["candidate_id"]/"generation.json").relative_to(ROOT)),"exit_code":code,"elapsed_seconds":elapsed}
        if ep.is_file():
            er=json.loads(ep.read_text(encoding="utf-8")); rr.update({"status":er.get("status"),"formal_status":er.get("formal"),"ppa_status":er.get("ppa","NOT_RUN"),"metrics":er,"rtl_source_cone":er.get("rtl_source_cone")})
            if er.get("formal")=="PASS" and er.get("ppa")=="PASS":
                rr["area_within_limit"]=er["mapped_area_um2"]<=base_area*1.10+1e-9
                rr["arrival_improved"]=er["max_data_arrival_ns"]<baseline["max_data_arrival_ns"]
                rr["valid_improvement"]=rr["area_within_limit"] and rr["arrival_improved"]
        else: rr.update({"status":"NO_RESULT","formal_status":"ERROR","ppa_status":"NOT_RUN","failure_reason":txt[-2000:]})
        write(dest/"reevaluation_result.json",rr); results.append(rr)
    groups={}
    for arm in ("generic_llm","sta_guided_llm","constrained_search"):
        rows=[r for r in results if r["arm"]==arm]; complete=[r for r in rows if r.get("formal_status")=="PASS" and r.get("ppa_status")=="PASS"]
        eligible=[r for r in complete if r.get("area_within_limit")]
        groups[arm]={"scheduled":len(rows),"generated":sum(bool(r.get("candidate_sha256")) for r in rows),"formal_pass":sum(r.get("formal_status")=="PASS" for r in rows),"ppa_complete":len(complete),"area_eligible":len(eligible),"valid_improvements":sum(bool(r.get("valid_improvement")) for r in rows),"best_area_eligible_delay_ns":min((r["metrics"]["max_data_arrival_ns"] for r in eligible),default=None),"failed_or_ineligible":[{"candidate":r["candidate_id"],"status":r.get("status"),"formal":r.get("formal_status"),"ppa":r.get("ppa_status")} for r in rows if r not in eligible]}
    summary={"reevaluation_protocol_sha256":rph,"source_protocol_sha256":frozen_protocol_hash,"source_manifest_sha256":frozen_manifest_hash,"baseline":baseline,"groups":groups,"no_new_api_calls":True,"interpretation_limit":"Post-hoc uniform re-evaluation of the same nine frozen candidates after a mechanical evaluator repair; the original logs remain intact. One small combinational design, pre-layout only."}
    write(out/"summary.json",summary)
    lines=["# Uniform re-evaluation of frozen native multiplier candidates","",f"Re-evaluation protocol SHA-256: `{rph}`",f"Source study protocol SHA-256: `{frozen_protocol_hash}`",f"Source candidate manifest SHA-256: `{frozen_manifest_hash}`","", "No new model API calls were made. All nine previously frozen RTL files were re-evaluated after fixing helper-module flattening; initial logs remain unchanged.","",f"Baseline: {baseline['max_data_arrival_ns']} ns, {base_area} µm².","","| Method | Formal | PPA complete | Valid improvements | Best eligible max data arrival |","|---|---:|---:|---:|---:|"]
    for arm,g in groups.items(): lines.append(f"| {arm} | {g['formal_pass']}/{g['scheduled']} | {g['ppa_complete']}/{g['scheduled']} | {g['valid_improvements']}/{g['scheduled']} | {g['best_area_eligible_delay_ns']} ns |")
    lines += ["","## Scope and caveat","",summary["interpretation_limit"],""]
    (out/"REEVALUATION.md").write_text("\n".join(lines),encoding="utf-8")
    print(f"Reevaluation: {out}"); print(json.dumps(groups,indent=2)); return 0
if __name__=="__main__": raise SystemExit(main())
