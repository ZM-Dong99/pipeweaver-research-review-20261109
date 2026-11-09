"""Fetch only pinned public RTL, README and license files. No model API."""
from concurrent.futures import ThreadPoolExecutor
import hashlib,json,os
from pathlib import Path
import shutil,subprocess
ROOT=Path(__file__).resolve().parents[2]
out=ROOT/"benchmark/engineering_sources_20261030"
out.mkdir(exist_ok=False)
repos=[
 {"name":"verilog-lfsr","url":"https://github.com/alexforencich/verilog-lfsr",
  "commit":"c1f86d036745935f3812ec6ddc7821c70ef4c9de","files":["rtl/lfsr.v","COPYING","README.md"]},
 {"name":"verilog-axis","url":"https://github.com/alexforencich/verilog-axis",
  "commit":"48ff7a7e2ef782cf778d47910cf85835c64b1bce","files":["rtl/priority_encoder.v","rtl/arbiter.v","COPYING","README.md"]},
]
(out/"SOURCE_LOCK.json").write_text(json.dumps({"purpose":"Research qualification inputs, not production dependency recommendation",
    "llm_generation_requests":0,"repositories":repos},indent=2),encoding="utf-8")
env=os.environ.copy();env.pop("OPENAI_API_KEY",None)
curl=shutil.which("curl.exe")
assert curl
jobs=[(r,f) for r in repos for f in r["files"]]
def fetch(job):
    r,f=job
    p=out/r["name"]/f;p.parent.mkdir(parents=True,exist_ok=True)
    url="https://raw.githubusercontent.com/alexforencich/"+r["name"]+"/"+r["commit"]+"/"+f
    result=subprocess.run([curl,"-q","--fail","--silent","--show-error","--proto","=https",
        "--retry","0","--max-time","60","--output",str(p),url],env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=70)
    if result.returncode:
        (p.parent/(p.name+".fetch_error.log")).write_bytes(result.stderr)
        raise RuntimeError("Pinned source download failed: "+r["name"]+"/"+f)
    return {"repository":r["name"],"commit":r["commit"],"path":str(p.relative_to(ROOT)),
            "url":url,"sha256":hashlib.sha256(p.read_bytes()).hexdigest(),"bytes":p.stat().st_size}
with ThreadPoolExecutor(max_workers=3) as pool:
    rows=list(pool.map(fetch,jobs))
for r in repos:
    license_text=(out/r["name"]/"COPYING").read_text(encoding="utf-8")
    assert "Permission is hereby granted" in license_text
(out/"PROVENANCE.json").write_text(json.dumps({"source_lock":"SOURCE_LOCK.json","files":rows,
    "original_sources_unmodified":True,"license_files_preserved":True,"llm_generation_requests":0},indent=2),encoding="utf-8")
print(json.dumps({"downloaded_files":len(rows),"repositories":len(repos),"out":str(out),"llm_generation_requests":0}))

