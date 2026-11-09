"""Verified post-synthesis context for the default addr_calcu research profile."""
from collections import Counter, deque
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

ROOT=Path(__file__).resolve().parents[2]
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def save(path,value):
    path.write_text(json.dumps(value,ensure_ascii=False,indent=2),encoding="utf-8")

def potential_chain(module,start,end):
    allowed={"$alu","$mux"}
    unknown=sorted({c["type"] for c in module["cells"].values()}-allowed)
    if unknown:
        raise RuntimeError("Unsupported post-synthesis cells: "+", ".join(unknown))
    def resolve(name):
        m=re.fullmatch(r"([A-Za-z_]\w*)(?:\[(\d+)\])?",name)
        if not m or m.group(1) not in module["ports"]:
            raise RuntimeError("Expected an ordinary top-level endpoint")
        port=module["ports"][m.group(1)]
        if port.get("offset",0) or port.get("upto",0):
            raise RuntimeError("Nonzero offsets/ascending ports not supported by this context encoder")
        return port["bits"][int(m.group(2)) if m.group(2) is not None else 0]
    graph={}
    for name,c in module["cells"].items():
        node=("cell",name)
        for port,bits in c["connections"].items():
            for bit in bits:
                if not isinstance(bit,int): continue
                other=("bit",bit)
                u,v=(other,node) if c["port_directions"][port]=="input" else (node,other)
                graph.setdefault(u,[]).append(v)
    origin=("bit",resolve(start)); target=("bit",resolve(end))
    queue=deque([origin]); prev={origin:None}
    while queue:
        u=queue.popleft()
        if u==target: break
        for v in graph.get(u,[]):
            if v not in prev:
                prev[v]=u; queue.append(v)
    if target not in prev:
        raise RuntimeError("No conservative post-synthesis connection found")
    chain=[]; u=target
    while u is not None:
        if u[0]=="cell":
            c=module["cells"][u[1]]
            src=c.get("attributes",{}).get("src")
            if src: src=src.replace(ROOT.as_posix()+"/","")
            chain.append({"cell":u[1],"operator":c["type"],"source":src})
        u=prev[u]
    return list(reversed(chain))

def verify_context_artifacts(study,record):
    for rel,expected in record["artifacts_sha256"].items():
        path=(study/rel).resolve()
        if not path.is_relative_to(study.resolve()) or sha(path)!=expected:
            raise RuntimeError("Frozen synthesis evidence changed: "+rel)

def build_context(study,profile,baseline,timeout):
    if profile["top"]!="addr_calcu":
        raise RuntimeError("Verified synthesis context is currently scoped to addr_calcu only")
    eda=study/"baseline/evaluation/eda"
    out=study/"baseline/synthesis_context"
    out.mkdir(exist_ok=False)
    base=ROOT/profile["rtl"]
    lib=ROOT/"eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
    env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
    yosys=Path(os.environ.get("YOSYS",r"D:\oss-cad-suite\bin\yosys.exe"))
    env["PATH"]=os.pathsep.join([str(yosys.parent),str(yosys.parent.parent/"lib"),env.get("PATH","")])
    def run(label,lines):
        script=out/(label+".ys")
        script.write_text("\n".join(lines)+"\n",encoding="utf-8")
        p=subprocess.run([str(yosys),"-Q","-l",str(out/(label+".log")),str(script)],cwd=ROOT,env=env,
                         stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout)
        (out/(label+"_stdout.log")).write_bytes(p.stdout)
        if p.returncode:
            raise RuntimeError("Synthesis-context tool failed: "+label)
        return p.stdout.decode("utf-8",errors="replace")
    qp=lambda p:'"'+p.resolve().as_posix()+'"'
    middle=out/"post_resource_sharing.json"
    run("capture",[
        f"read_liberty -lib {qp(lib)}",f"read_verilog -sv {qp(base)}","hierarchy -check -top addr_calcu",
        "flatten","delete t:$scopeinfo","synth -top addr_calcu -noabc -run begin:fine",
        "opt -fast -full","memory_map","opt -full",f"write_json {qp(middle)}"])
    module=json.loads(middle.read_text())["modules"]["addr_calcu"]
    start=baseline["critical_startpoint"].split()[0]; end=baseline["critical_endpoint"].split()[0]
    chain=potential_chain(module,start,end)
    lines=(eda/"formal.ys").read_text(encoding="utf-8").splitlines()
    indices=[i for i,x in enumerate(lines) if x.startswith("read_verilog ")]
    if len(indices)!=3 or lines[indices[1]+2]!="flatten":
        raise RuntimeError("Unexpected baseline proof layout")
    idx=indices[1]
    lines[idx]=f"read_json {qp(middle)}"
    lines[idx+3:idx+3]=["techmap","opt"]
    proof=run("intermediate_formal",lines)
    if "SAT proof finished - no model found: SUCCESS!" not in proof:
        raise RuntimeError("Intermediate design proof incomplete")
    before=json.loads((eda/"candidate_schema.json").read_text())["modules"]["addr_calcu"]
    text=(eda/"mapping.log").read_text(encoding="utf-8").splitlines()
    events=[]
    for i,line in enumerate(text):
        if "Found cells that share an operand and can be merged by moving" in line:
            chunk="\n".join(x.strip() for x in text[i:i+7] if x.strip())
            events.append(chunk.replace(ROOT.as_posix()+"/",""))
    if not events:
        raise RuntimeError("No actual resource-sharing event found in baseline mapping log")
    context={
        "reference_rtl_sha256":sha(base),
        "scope":"Default base=128 configuration; all ordinary inputs unconstrained",
        "stage":"End of coarse plus fine initial opt/memory_map/opt prefix, before gate techmap",
        "not_final_mapped_netlist":True,
        "precision":"Conservative whole-cell input-to-output structural connectivity. Not sensitized bit-level STA and not an exact mapped-gate-to-RTL trace.",
        "pre_synthesis_operator_counts":dict(Counter(c["type"] for c in before["cells"].values())),
        "post_synthesis_operator_counts":dict(Counter(c["type"] for c in module["cells"].values())),
        "actual_baseline_optimization_events":events,
        "measured_sta_endpoints":{"start":start,"end":end},
        "one_potential_post_synthesis_chain":chain,
        "created_cells_without_source":sum(c["source"] is None for c in chain),
        "verification":"Intermediate representation proved equivalent to original RTL for all ordinary inputs, default parameter only",
        "intermediate_json_sha256":sha(middle),
        "intermediate_formal_log_sha256":sha(out/"intermediate_formal.log"),
        "interpretation_limit":"Already-performed sharing is a measured synthesis event, not proof that every further rewrite is redundant. No candidate outcomes or optimized reference RTL are supplied.",
    }
    save(out/"context.json",context)
    artifacts={str(p.relative_to(study)):sha(p) for p in out.iterdir() if p.is_file()}
    record={"path":str((out/"context.json").relative_to(study)),"artifacts_sha256":artifacts}
    verify_context_artifacts(study,record)
    return context,record

