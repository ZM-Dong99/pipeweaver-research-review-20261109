from __future__ import annotations
import argparse, hashlib, json, os, subprocess
from datetime import datetime
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
CASES={"adder":("adder/adder.v","adder","adder_ref/adder_ref.v","adder_ref"),"mul":("mul/mul.v","mul","mul_ref/mul_ref.v","mul_ref"),"fsm":("fsm/fsm.v","fsm","fsm_ref/fsm_ref.v","fsm_ref")}
def run(cmd,cwd,log,timeout,env):
 p=subprocess.run(cmd,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout,env=env)
 s=p.stdout.decode("utf-8",errors="replace"); log.write_text(s,encoding="utf-8")
 if p.returncode: raise RuntimeError(f"exit {p.returncode}: {cmd}\n{s[-3000:]}")
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser(); ap.add_argument("--timeout",type=int,default=300); a=ap.parse_args()
 bench=ROOT/"benchmark/rtl_opt_upstream_hkust/benchmark"
 exp=ROOT/"eda/experiments"/datetime.now().strftime("rtlopt_preflight_%Y%m%d_%H%M%S_%f"); exp.mkdir(parents=True)
 yosys=Path(r"D:\oss-cad-suite\bin\yosys.exe"); suite=yosys.parent.parent
 env=os.environ.copy(); env["PATH"]=str(yosys.parent)+os.pathsep+str(suite/"lib")+os.pathsep+env.get("PATH","")
 results=[]
 for name,(bf,bt,rf,rt) in CASES.items():
  case=bench/bf; ref=bench/rf; out=exp/name; out.mkdir()
  for label,src,top in (("baseline",case,bt),("reference",ref,rt)):
   run([str(yosys),"-p",f"read_verilog {src}; hierarchy -check -top {top}; proc; check; stat"],ROOT,out/f"{label}_yosys.log",a.timeout,env)
  record={"case":name,"baseline":str(case.relative_to(ROOT)),"reference":str(ref.relative_to(ROOT)),"baseline_sha256":sha(case),"reference_sha256":sha(ref),"status":"TOOL_PREFLIGHT_PASS","formal":"NOT_RUN","sta":"NOT_RUN","note":"Syntax, hierarchy, process lowering, check, and generic stat only; no claimed PPA or equivalence."}
  (out/"result.json").write_text(json.dumps(record,indent=2),encoding="utf-8"); results.append(record)
 summary={"experiment":exp.name,"benchmark_source":"https://github.com/hkust-zhiyao/RTL-OPT","license":"MIT (upstream repository)","scope":"No LLM calls. Generic Yosys parser/synthesis preflight only; no formal or STA metrics.","results":results}
 (exp/"summary.json").write_text(json.dumps(summary,indent=2),encoding="utf-8")
 lines=["# RTL-OPT Multi-design Tool Preflight","","This run checks source parsing and generic Yosys synthesis only. It does not claim functional equivalence or PPA improvement, and makes no LLM API calls.","","| Design | Status | Baseline SHA-256 | Reference SHA-256 |","|---|---|---|---|"]
 for x in results: lines.append(f"| {x['case']} | {x['status']} | {x['baseline_sha256']} | {x['reference_sha256']} |")
 (exp/"SUMMARY.md").write_text("\n".join(lines)+"\n",encoding="utf-8")
 print(exp)
if __name__=="__main__": main()

