"""Re-run failed mapping with stage markers in a separate directory, no API."""
import json,os
from pathlib import Path
import shutil,subprocess
ROOT=Path(__file__).resolve().parents[2]
s=ROOT/"eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837"
old=s/"no_timing_feedback/candidate_03/evaluation/eda"
out=s/"mapping_failure_diagnostic"; out.mkdir(exist_ok=False)
script=(old/"mapping.ys").read_text(encoding="utf-8").replace(old.as_posix(),out.as_posix())
assert old.as_posix() not in script
for name in ("abc.constr",):
    shutil.copyfile(old/name,out/name)
commands=(old/"abc.script").read_text().splitlines()
marked=[]
for i,command in enumerate(commands):
    if command.strip():
        marked.extend([f"echo PW_ABC_STAGE_{i}_{command.replace(' ','_')}",command])
(out/"abc.script").write_text("\n".join(marked)+"\n",encoding="ascii")
(out/"mapping.ys").write_text(script,encoding="utf-8")
env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
p=subprocess.run([r"D:\oss-cad-suite\bin\yosys.exe","-Q","-l",str(out/"mapping.log"),str(out/"mapping.ys")],
                 cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
(out/"stdout.log").write_bytes(p.stdout)
lines=p.stdout.decode("utf-8",errors="replace").splitlines()
selected=[x for x in lines if "PW_ABC_STAGE" in x or "no fanout" in x or "command has failed" in x or "ERROR:" in x]
result={"api_calls":0,"original_failure_preserved":True,"diagnostic_only":True,
        "mapping_exit":p.returncode,"stage_messages":selected}
(out/"SUMMARY.json").write_text(json.dumps(result,indent=2),encoding="utf-8")
print(json.dumps(result,indent=2))

