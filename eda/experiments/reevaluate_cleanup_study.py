"""Uniform post-hoc cleanup robustness check on the entire frozen candidate pool. No API."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib,json,os
from pathlib import Path
import shutil,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__); ap.add_argument("study",type=Path)
    args=ap.parse_args(); s=args.study.resolve()
    primary=load(s/"protocol.json"); manifest=load(s/"candidate_manifest.json")
    out=s/"uniform_cleanup_reevaluation"; out.mkdir(exist_ok=False)
    snapshot=out/"code_snapshot"; snapshot.mkdir()
    evaluator=ROOT/"eda/experiments/run_native_comb.py"
    frozen={}
    for p in (evaluator,evaluator.with_name("trace_sta_rtl_cone.py"),Path(__file__).resolve()):
        shutil.copyfile(p,snapshot/p.name); frozen[str(p.relative_to(ROOT))]=sha(p)
    slots=[r for r in manifest["slots"] if r["candidate_sha256"]]
    assert len(slots)==9
    for r in slots:
        assert sha(s/r["arm"]/r["candidate_id"]/"candidate.v")==r["candidate_sha256"]
    plan={"scope":"Post-hoc uniform EDA cleanup robustness check, not a new model comparison",
          "original_protocol_sha256":sha(s/"protocol.json"),"candidate_manifest_sha256":sha(s/"candidate_manifest.json"),
          "all_frozen_candidates":True,"candidate_count":len(slots),"new_llm_requests":0,
          "only_mapping_change":"cleanup -i -o after map and before buffer; all cases use the same flag",
          "selection":"Full source and mapped proof, zero electrical violations, area <=110% freshly remeasured original baseline, strict delay gain",
          "code_sha256":frozen,"area_ratio":1.1,"slots":slots}
    (out/"protocol.json").write_text(json.dumps(plan,ensure_ascii=False,indent=2),encoding="utf-8")
    env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
    def evaluate(label,rtl):
        for rel,h in frozen.items():
            assert sha(ROOT/rel)==h
        cmd=[sys.executable,"-B",str(evaluator),str(rtl),"--reference",str(s/"baseline/original.v"),
             "--top",primary["top"],"--mapping-policy","buffer_size","--cleanup-before-buffer",
             "--timeout",str(primary["timeout_per_tool_seconds"]),"--out",str(out/label)]
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                         timeout=primary["timeout_per_tool_seconds"]*6)
        (out/(label.replace("/","_")+"_runner.log")).write_bytes(p.stdout)
        metrics=load(out/label/"result.json") if (out/label/"result.json").exists() else {}
        return p.returncode,metrics
    code,base=evaluate("baseline",s/"baseline/original.v")
    assert code==0 and base["formal"]==base["mapped_formal"]==base["electrical"]["status"]=="PASS"
    cap=base["mapped_area_um2"]*1.1
    def run(slot):
        label=slot["arm"]+"/"+slot["candidate_id"]
        code,m=evaluate(label,s/slot["arm"]/slot["candidate_id"]/"candidate.v")
        eligible=(code==0 and m.get("formal")==m.get("mapped_formal")==m.get("electrical",{}).get("status")=="PASS" and m.get("mapped_area_um2",float("inf"))<=cap)
        return {"arm":slot["arm"],"candidate":slot["candidate_id"],"exit_code":code,
                "metrics":m,"eligible":eligible,
                "strict_improvement":bool(eligible and m["max_data_arrival_ns"]<base["max_data_arrival_ns"])}
    with ThreadPoolExecutor(max_workers=3) as pool:
        results=list(pool.map(run,slots))
    groups={}
    exported=out/"selected_outputs"; exported.mkdir()
    for arm in primary["arms"]:
        rr=[r for r in results if r["arm"]==arm]
        eligible=[r for r in rr if r["eligible"]]
        best=min(eligible,key=lambda r:r["metrics"]["max_data_arrival_ns"]) if eligible else None
        improvements=[r for r in rr if r["strict_improvement"]]
        choice=min(improvements,key=lambda r:r["metrics"]["max_data_arrival_ns"]) if improvements else None
        groups[arm]={"scheduled":len(rr),"source_formal_pass":sum(r["metrics"].get("formal")=="PASS" for r in rr),
                     "ppa_complete":sum(r["metrics"].get("ppa")=="PASS" for r in rr),"eligible":len(eligible),
                     "strict_improvements":len(improvements),
                     "best_eligible_candidate_ns":best["metrics"]["max_data_arrival_ns"] if best else None,
                     "selected_delay_ns":choice["metrics"]["max_data_arrival_ns"] if choice else base["max_data_arrival_ns"],
                     "selected_area_um2":choice["metrics"]["mapped_area_um2"] if choice else base["mapped_area_um2"],
                     "selected_candidate":choice["candidate"] if choice else "baseline"}
        src=s/arm/choice["candidate"]/"candidate.v" if choice else s/"baseline/original.v"
        target=exported/arm; target.mkdir()
        shutil.copyfile(src,target/"addr_calcu.v")
        (target/"SOURCE.json").write_text(json.dumps({"source":str(src.relative_to(ROOT)),"sha256":sha(src),
             "secondary_uniform_cleanup_evaluation":True,**groups[arm]},ensure_ascii=False,indent=2),encoding="utf-8")
    report={"status":"COMPLETED","new_llm_requests":0,"primary_results_unchanged":True,
            "baseline":base,"area_cap_um2":cap,"groups":groups,"results":results,
            "qualification_scope":"Functional/electrical/area eligibility; failures remain in denominator",
            "limitation":"This is a post-hoc mapping robustness check of frozen candidates, not an independent LLM replication"}
    (out/"SUMMARY.json").write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding="utf-8")
    print(json.dumps({"status":report["status"],"groups":groups,"new_llm_requests":0},ensure_ascii=False,indent=2))
    return 0
if __name__=="__main__":
    raise SystemExit(main())

