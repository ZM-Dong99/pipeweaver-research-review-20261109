"""Independently rerun baseline and the three actual selections, without API calls."""
from concurrent.futures import ThreadPoolExecutor
import json
import hashlib
import os
from pathlib import Path
import subprocess
import sys

ROOT=Path(r'D:\verilog_lab\PipeWeaver')
S=ROOT/'eda/experiments/ticket_risk_feedback_20261103_001930_680040'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
summary=load(S/'summary.json');protocol=load(S/'protocol.json')
OUT=S/'independent_reproduction'
if OUT.exists():raise ValueError('Refusing to overwrite old reproduction')
OUT.mkdir()
cases=[('baseline',S/'inputs/original.v',protocol['baseline_metrics'])]
cases.extend((arm,S/'selected'/arm/'ticket_machine.v',g['selected_metrics']) for arm,g in summary['groups'].items())
original_role_count=len(cases);unique=[];known={};aliases=[]
for role,source,expected in cases:
    source_sha=hashlib.sha256(source.read_bytes()).hexdigest()
    signature=(source_sha,expected['mapped_sha256'],expected['wns_ns'],expected['mapped_area_um2'])
    if signature in known:
        aliases.append(dict(role=role,replayed_as=known[signature],identical_source_sha256=source_sha))
    else:
        known[signature]=role;unique.append((role,source,expected))
cases=unique
def replay(case):
    role,source,expected=case;out=OUT/role
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    cmd=[sys.executable,'-B',str(ROOT/'eda/experiments/run_native_seq.py'),str(source),'--reference',str(S/'inputs/original.v'),
         '--top','ticket_machine','--clock','clk','--reset','clear','--reset-cycles','1','--warmup','1','--period','10','--timeout','120','--out',str(out)]
    p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=960)
    out.mkdir(exist_ok=True);(out/'runner.log').write_bytes(p.stdout)
    actual=load(out/'result.json')
    keys=['status','formal','mapped_formal','ppa','mapped_area_um2','mapped_cells','wns_ns','tns_ns','mapped_sha256','electrical']
    checks={k:actual.get(k)==expected.get(k) for k in keys}
    return dict(role=role,passed=p.returncode==0 and all(checks.values()),comparison=checks,metrics=actual)
with ThreadPoolExecutor(max_workers=2) as pool: rows=list(pool.map(replay,cases))
report=dict(passed=all(r['passed'] for r in rows),independent_eda_replays=len(rows),planned_roles=original_role_count,
            deduplicated_identical_roles=aliases,new_model_calls=0,rows=rows)
with (S/'REPRODUCTION.json').open('x',encoding='utf-8') as f:json.dump(report,f,ensure_ascii=False,indent=2)
print(json.dumps({k:v for k,v in report.items() if k!='rows'}))
if not report['passed']:raise SystemExit(1)
