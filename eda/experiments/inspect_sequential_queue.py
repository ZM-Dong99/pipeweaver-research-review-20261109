"""Structure-only survey of the deferred sequential queue. No equivalence or STA claim."""
import argparse
from collections import Counter
import hashlib,json,os
from pathlib import Path
import re,subprocess
ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument("study",type=Path);args=ap.parse_args()
    s=args.study.resolve();p=load(s/"protocol.json")
    cases=[c for c in p["cases"] if c["action"]=="DEFERRED_SEQUENTIAL"]
    out=s/"sequential_interface_survey";out.mkdir(exist_ok=False)
    (out/"SCOPE.txt").write_text("Native syntax/proc/flatten/opt structural inspection only. No sequential functional proof, timing qualification or LLM generation. Main deferred classification is unchanged.\n",encoding="utf-8")
    env=os.environ.copy();env.pop("OPENAI_API_KEY",None)
    env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
    results=[]
    for c in cases:
        folder=out/c["id"];folder.mkdir()
        sources=[ROOT/x for x in c.get("dependencies",[])]+[ROOT/c["source"]]
        assert hashlib.sha256((ROOT/c["source"]).read_bytes()).hexdigest()==c["source_sha256"]
        jp=folder/"schema.json"
        lines=[f'read_verilog -sv "{x.as_posix()}"' for x in sources]
        lines += [f"hierarchy -check -top {c['top']}","proc","flatten","opt","check -assert",f'write_json "{jp.as_posix()}"']
        ys=folder/"inspect.ys";ys.write_text("\n".join(lines)+"\n",encoding="utf-8")
        q=subprocess.run([r"D:\oss-cad-suite\bin\yosys.exe","-Q",str(ys)],cwd=ROOT,env=env,
                          stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=120)
        (folder/"inspect.log").write_bytes(q.stdout)
        r={"id":c["id"],"status":"STRUCTURE_INSPECTED" if q.returncode==0 else "FRONTEND_ERROR",
           "sequential_equivalence":"NOT_RUN","sta":"NOT_RUN","source_sha256":c["source_sha256"]}
        if q.returncode==0:
            m=load(jp)["modules"][c["top"]]
            state={n:v for n,v in m["cells"].items() if re.search(r"dff|latch|mem|ff$",v["type"],re.I)}
            ports={n:{"direction":v["direction"],"width":len(v["bits"])} for n,v in m["ports"].items()}
            controls=[]
            for name,v in state.items():
                for pin in ("CLK","ARST","SRST"):
                    if pin in v["connections"]:
                        bits=v["connections"][pin]
                        aliases=[n for n,z in m["ports"].items() if set(bits)&set(z["bits"])]
                        controls.append({"state_cell":name,"type":v["type"],"pin":pin,"bits":bits,
                                         "top_port_aliases":aliases,
                                         "polarity_parameter":v.get("parameters",{}).get(pin+"_POLARITY")})
            r.update(ports=ports,state_cell_types=dict(Counter(v["type"] for v in state.values())),controls=controls)
        (folder/"inspection.json").write_text(json.dumps(r,ensure_ascii=False,indent=2),encoding="utf-8")
        results.append(r)
    report={"scope":"Structure inspection only; deferred baseline status unchanged","llm_generation_requests":0,
            "planned":len(cases),"inspected":sum(r["status"]=="STRUCTURE_INSPECTED" for r in results),
            "results":results}
    (out/"SUMMARY.json").write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding="utf-8")
    print(json.dumps({"structure_inspected":report["inspected"],"planned":len(cases),
                      "sequential_equivalence_runs":0,"sta_runs":0,"llm_generation_requests":0},ensure_ascii=False))
if __name__=="__main__":main()

