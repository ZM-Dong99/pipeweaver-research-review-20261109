"""Frozen multi-family baseline qualification. No LLM adapter or model requests."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor,as_completed
from datetime import datetime
import hashlib,json,os
from pathlib import Path
import re,shutil,subprocess,sys,time
ROOT=Path(__file__).resolve().parents[2]
DATA=ROOT/"benchmark/rtl_opt_upstream_hkust/benchmark"
ENGINEERING=ROOT/"benchmark/engineering_sources_20261030"
EVALUATOR=ROOT/"eda/experiments/run_native_comb.py"
LIB=ROOT/"eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding="utf-8-sig"))
def save(p,obj): p.write_text(json.dumps(obj,ensure_ascii=False,indent=2),encoding="utf-8")
def family(name):
    if name.startswith(("adder","sub_")) or name in ("add_sub","saturating_add"): return "add_subtract"
    if name.startswith("alu_"): return "alu"
    if name=="addr_calcu": return "address_arithmetic"
    if name.startswith("divider"): return "division"
    if name.startswith("mul") or name=="mac": return "multiplication"
    if name=="calculation": return "mixed_arithmetic"
    if name.startswith("comparator"): return "comparison"
    if name.startswith("decoder"): return "decoding"
    if name.startswith("mux") or name in ("mult_if","selector"): return "selection"
    if name in ("fsm","fsm_encode","gray","ticket_machine"): return "sequential_control"
    return "storage" if name=="register" else "other"
def properties(path):
    text=path.read_text(encoding="utf-8",errors="replace")
    stripped=re.sub(r"/\*.*?\*/|//[^\n]*","",text,flags=re.S)
    return {"physical_lines":len(text.splitlines()),"code_lines_approx":sum(bool(x.strip()) for x in stripped.splitlines()),
            "edge_trigger_hint":bool(re.search(r"\b(?:posedge|negedge)\b",stripped)),
            "declared_modules":re.findall(r"(?m)^\s*module\s+([A-Za-z_]\w*)",stripped)}
def strings(obj):
    if isinstance(obj,str): yield obj
    elif isinstance(obj,dict):
        for v in obj.values(): yield from strings(v)
    elif isinstance(obj,list):
        for v in obj: yield from strings(v)
def prepare(timeout=120,workers=2):
    study=ROOT/"eda/experiments"/datetime.now().strftime("baseline_qualification_%Y%m%d_%H%M%S_%f")
    study.mkdir()
    cases=[]
    for d in sorted(DATA.iterdir()):
        if not d.is_dir() or d.name.endswith("_ref"): continue
        sources=sorted([*d.glob("*.v"),*d.glob("*.sv")])
        if len(sources)!=1: raise RuntimeError("Expected one native source for "+d.name)
        path=sources[0]; meta=properties(path)
        if d.name not in meta["declared_modules"]: raise RuntimeError("Unexpected native top "+d.name)
        cases.append({"id":"rtlopt_"+d.name,"design":d.name,"source":str(path.relative_to(ROOT)),"top":d.name,
                      "parameters":{},"family":family(d.name),"source_sha256":sha(path),"origin":"RTL-OPT local original",**meta})
    for row in load(ENGINEERING/"PROVENANCE.json")["files"]:
        assert sha(ROOT/row["path"])==row["sha256"]
    extra=[
        ("engineering_lfsr_data8","verilog-lfsr/rtl/lfsr.v","lfsr",{"DATA_WIDTH":8},"linear_feedback"),
        ("engineering_lfsr_data32","verilog-lfsr/rtl/lfsr.v","lfsr",{"DATA_WIDTH":32},"linear_feedback"),
        ("engineering_priority64","verilog-axis/rtl/priority_encoder.v","priority_encoder",{"WIDTH":64},"priority_encoding"),
        ("engineering_priority256","verilog-axis/rtl/priority_encoder.v","priority_encoder",{"WIDTH":256},"priority_encoding"),
        ("engineering_arbiter","verilog-axis/rtl/arbiter.v","arbiter",{},"sequential_arbitration"),
    ]
    for cid,rel,top,params,fam in extra:
        path=ENGINEERING/rel
        cases.append({"id":cid,"design":top,"source":str(path.relative_to(ROOT)),"top":top,"parameters":params,
                      "family":fam,"source_sha256":sha(path),"origin":"Pinned public engineering source",**properties(path)})
    historical={}
    for path in sorted((ROOT/"eda/experiments").rglob("protocol.json")):
        if path.is_relative_to(study): continue
        try: vals=["/"+x.replace("\\","/") for x in strings(load(path))]
        except (OSError,ValueError): continue
        hit=[]
        for c in cases:
            if c["origin"]!="RTL-OPT local original": continue
            name=c["design"]
            if any("/benchmark/"+name+"/" in x or "/benchmark/"+name+"_ref/" in x for x in vals):
                hit.append(c["id"])
        if hit: historical[str(path.relative_to(ROOT))]={"sha256":sha(path),"designs":sorted(set(hit))}
    exposed={x for r in historical.values() for x in r["designs"]}
    dev_families={"add_subtract","alu","address_arithmetic","division","multiplication","mixed_arithmetic"}
    dev_families.update(c["family"] for c in cases if c["id"] in exposed)
    for c in cases:
        c["prior_project_protocol_exposure"]=c["id"] in exposed
        c["planned_split"]="development_family" if c["family"] in dev_families else "evaluation_candidate_family"
        c["split_scope"]="No prior use for this project's prompt tuning by recorded family evidence; public model training exposure is unknown"
        c["action"]="DEFERRED_SEQUENTIAL" if c["edge_trigger_hint"] else "RUN_COMBINATIONAL_QUALIFICATION"
        c["instance_scope"]="Declared integer parameter overrides only; all other parameters use source defaults"
        if c["id"]=="engineering_arbiter":
            c["dependencies"]=["benchmark/engineering_sources_20261030/verilog-axis/rtl/priority_encoder.v"]
    snapshot=study/"code_snapshot";snapshot.mkdir()
    deps=[Path(__file__).resolve(),EVALUATOR,EVALUATOR.with_name("trace_sta_rtl_cone.py")]
    for path in deps: shutil.copyfile(path,snapshot/path.name)
    git=lambda *a:subprocess.check_output(["git","-C",str(DATA.parent),*a],text=True).strip()
    protocol={"purpose":"Baseline scope/coverage qualification only; not an optimization-method experiment",
              "created_at":datetime.now().astimezone().isoformat(),"llm_generation_requests":0,
              "model_api_not_used":True,"cases":cases,"timeout_per_tool_seconds":timeout,"workers":workers,
              "mapping_policy":"buffer_size","cleanup_before_buffer":True,
              "liberty_sha256":sha(LIB),"input_transition_ns":0.10,"output_load_pf":0.010,
              "external_input_output_delay_ns":0,"virtual_clock_ns":100,"physical_parasitics":False,
              "qualification":"Complete native interface, source self-miter, mapped-to-source full proof, numeric STA, zero reported max-slew/max-capacitance violations",
              "self_proof_caveat":"Source baseline equals reference: source self-miter is infrastructure sanity, not proof of an optimization. Gate-level equality is separately checked.",
              "selection_policy":"Freeze all inputs/family splits before PPA; retain every fail/timeout/deferred case; no per-design repair or relaxation",
              "family_policy":"Width/configuration variants stay in one family and are not independent benchmark families",
              "evaluation_scope":"Family candidates not used for recorded project prompt tuning; not a guarantee of model training holdout or blind independent test",
              "source_repositories":{"rtlopt_commit":git("rev-parse","HEAD"),"rtlopt_worktree_changes":git("status","--short","--untracked-files=no"),
                                     "engineering_source_lock_sha256":sha(ENGINEERING/"SOURCE_LOCK.json"),
                                     "engineering_provenance_sha256":sha(ENGINEERING/"PROVENANCE.json")},
              "dependency_sha256":{str(p.relative_to(ROOT)):sha(p) for p in deps}}
    save(study/"prior_exposure_snapshot.json",historical)
    save(study/"family_split.json",{"development_families":sorted(dev_families),"cases":[{"id":c["id"],"family":c["family"],"planned_split":c["planned_split"],"action":c["action"]} for c in cases]})
    save(study/"protocol.json",protocol)
    (study/"protocol.sha256").write_text(sha(study/"protocol.json")+"\n",encoding="ascii")
    print(json.dumps({"prepared":str(study),"cases":len(cases),"run_combinational":sum(c["action"]=="RUN_COMBINATIONAL_QUALIFICATION" for c in cases),
                      "deferred_sequential":sum(c["action"]=="DEFERRED_SEQUENTIAL" for c in cases),
                      "evaluation_candidate_families":sorted({c["family"] for c in cases if c["planned_split"]=="evaluation_candidate_family"}),
                      "protocol_sha256":sha(study/"protocol.json")},ensure_ascii=False),flush=True)
    return study

def verify(study,p):
    if sha(study/"protocol.json")!=(study/"protocol.sha256").read_text().strip(): raise RuntimeError("Protocol changed")
    if sha(LIB)!=p["liberty_sha256"]: raise RuntimeError("Library changed")
    for rel,h in p["dependency_sha256"].items():
        if sha(ROOT/rel)!=h: raise RuntimeError("Frozen evaluator/driver changed: "+rel)
    for c in p["cases"]:
        if sha(ROOT/c["source"])!=c["source_sha256"]: raise RuntimeError("Frozen RTL changed: "+c["id"])

def classify(code,m,text):
    if code==0 and m.get("formal")==m.get("mapped_formal")==m.get("electrical",{}).get("status")=="PASS" and m.get("ppa")=="PASS":
        return "QUALIFIED"
    if m.get("electrical",{}).get("status")=="FAIL": return "ELECTRICAL_VIOLATIONS"
    if "rejects state or nondeterminism" in m.get("failure_reason",""): return "UNSUPPORTED_STATE_OR_MEMORY"
    if "Inout ports" in m.get("failure_reason",""): return "UNSUPPORTED_INTERFACE"
    if "timeout" in (text+m.get("failure_reason","")).lower(): return "INCOMPLETE_TIMEOUT"
    if "proof did fail" in text or m.get("formal")=="FAIL": return "EQUIVALENCE_FAIL"
    return "TOOL_OR_FLOW_ERROR"

def execute(study):
    p=load(study/"protocol.json");verify(study,p)
    env=os.environ.copy()
    for key in ("OPENAI_API_KEY","ANTHROPIC_API_KEY","DEEPSEEK_API_KEY"):env.pop(key,None)
    env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
    (study/"cases").mkdir(exist_ok=True);rows=[]
    for c in p["cases"]:
        if c["action"]!="RUN_COMBINATIONAL_QUALIFICATION":
            row={"id":c["id"],"family":c["family"],"planned_split":c["planned_split"],"status":"DEFERRED_SEQUENTIAL",
                 "reason":"Current evaluator is combinational only; no sequential correctness/timing claim"}
            save(study/"cases"/(c["id"]+".json"),row);rows.append(row)
    def run(c):
        verify(study,p)
        record=study/"cases"/(c["id"]+".json")
        if record.exists(): return load(record)
        out=study/"cases"/c["id"]
        cmd=[sys.executable,"-B",str(EVALUATOR),str(ROOT/c["source"]),"--reference",str(ROOT/c["source"]),
             "--top",c["top"],"--mapping-policy","buffer_size","--cleanup-before-buffer",
             "--timeout",str(p["timeout_per_tool_seconds"]),"--out",str(out)]
        for k,v in c["parameters"].items():cmd+=["--param",f"{k}={v}"]
        start=time.monotonic()
        try:
            proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                                timeout=p["timeout_per_tool_seconds"]*8)
            data=proc.stdout;code=proc.returncode
        except subprocess.TimeoutExpired as exc:
            data=(exc.stdout or b"")+b"\nOVERALL TIMEOUT";code=124
        (study/"cases"/(c["id"]+"_runner.log")).write_bytes(data)
        m=load(out/"result.json") if (out/"result.json").exists() else {}
        text=data.decode("utf-8",errors="replace")
        row={"id":c["id"],"family":c["family"],"planned_split":c["planned_split"],"status":classify(code,m,text),
             "exit_code":code,"elapsed_seconds":round(time.monotonic()-start,3),"metrics":m,
             "source_sha256":c["source_sha256"],"parameters":c["parameters"]}
        save(record,row)
        print(c["id"]+": "+row["status"]+" stage="+str(m.get("stage"))+
              " arrival="+str(m.get("max_data_arrival_ns"))+" cells="+str(m.get("mapped_cells")),flush=True)
        return row
    candidates=[c for c in p["cases"] if c["action"]=="RUN_COMBINATIONAL_QUALIFICATION"]
    with ThreadPoolExecutor(max_workers=p["workers"]) as pool:
        futures=[pool.submit(run,c) for c in candidates]
        for f in as_completed(futures):rows.append(f.result())
    verify(study,p)
    rows.sort(key=lambda r:r["id"])
    report={"status":"COMPLETED","protocol_sha256":sha(study/"protocol.json"),"llm_generation_requests":0,
            "planned_cases":len(p["cases"]),"attempted_combinational":len(candidates),
            "counts":dict(Counter(r["status"] for r in rows)),"results":rows,
            "interpretation":"Baseline qualification only; no generated candidates or method comparison. Failures/deferred cases remain visible."}
    save(study/"summary.json",report)
    print(json.dumps({"completed":str(study),"counts":report["counts"],"llm_generation_requests":0},ensure_ascii=False),flush=True)
    return 0

if __name__=="__main__":
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument("--execute",type=Path)
    ap.add_argument("--timeout",type=int,default=120);ap.add_argument("--workers",type=int,default=2)
    a=ap.parse_args()
    if a.execute:raise SystemExit(execute(a.execute.resolve()))
    if a.timeout<1 or not 1<=a.workers<=4:ap.error("Positive timeout and 1..4 workers required")
    prepare(a.timeout,a.workers)

