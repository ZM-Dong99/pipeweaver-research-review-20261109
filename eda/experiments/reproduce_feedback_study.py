"""Independently rerun the original baseline and each arm's best eligible RTL. No API."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[2]

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("study",type=Path)
    args=ap.parse_args(); s=args.study.resolve()
    load=lambda p:json.loads(p.read_text(encoding="utf-8"))
    protocol=load(s/"protocol.json")
    manifest=load(s/"candidate_manifest.json")
    rows=[load(s/r["arm"]/r["candidate_id"]/"result.json") for r in manifest["slots"]]
    out=s/"independent_eda_reproduction"; out.mkdir(exist_ok=False)
    cases=[{"label":"baseline","rtl":s/"baseline/original.v","original":protocol["baseline_metrics"]}]
    skipped=[]
    for arm in protocol["arms"]:
        eligible=[r for r in rows if r["arm"]==arm and r["eligible"]]
        if not eligible:
            skipped.append({"arm":arm,"reason":"No eligible generated RTL; baseline retention is separately verified"})
            continue
        r=min(eligible,key=lambda r:r["metrics"]["max_data_arrival_ns"])
        cases.append({"label":arm,"rtl":s/arm/r["candidate_id"]/"candidate.v","original":r["metrics"]})
    (out/"plan.json").write_text(json.dumps({"cases":[{"label":c["label"],"rtl":str(c["rtl"])} for c in cases],
                                             "skipped":skipped,"llm_generation_requests":0},indent=2),encoding="utf-8")
    env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
    def run(c):
        target=out/c["label"]
        cmd=[sys.executable,"-B",str(ROOT/"eda/experiments/run_native_comb.py"),str(c["rtl"]),
             "--reference",str(s/"baseline/original.v"),"--top",protocol["top"],
             "--mapping-policy",protocol.get("mapping_policy","legacy"),"--timeout",str(protocol["timeout_per_tool_seconds"]),
             "--out",str(target)]
        p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                         timeout=protocol["timeout_per_tool_seconds"]*6)
        (out/(c["label"]+"_runner.log")).write_bytes(p.stdout)
        result={"case":c["label"],"exit_code":p.returncode,"status":"FAIL"}
        if p.returncode==0 and (target/"result.json").exists():
            r=load(target/"result.json")
            keys=("max_data_arrival_ns","mapped_area_um2","mapped_cells","mapped_sha256","sdc_sha256")
            same=all(r.get(k)==c["original"].get(k) for k in keys)
            proof=r.get("formal")==r.get("mapped_formal")==r.get("electrical",{}).get("status")=="PASS"
            result.update(status="PASS" if same and proof else "MISMATCH",same_metrics_and_netlist=same,
                          formal_mapped_and_electrical_pass=proof,
                          max_data_arrival_ns=r.get("max_data_arrival_ns"),mapped_area_um2=r.get("mapped_area_um2"))
        return result
    with ThreadPoolExecutor(max_workers=4) as pool:
        results=list(pool.map(run,cases))
    report={"status":"PASS" if all(r["status"]=="PASS" for r in results) else "FAIL",
            "llm_generation_requests":0,"results":results,"skipped":skipped}
    (out/"SUMMARY.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
    print(json.dumps(report,indent=2))
    return 0 if report["status"]=="PASS" else 1
if __name__=="__main__":
    raise SystemExit(main())

