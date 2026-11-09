"""Independent reproduction of primary retention and boundary positive selection."""
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess
import sys
ROOT=Path(r'D:\verilog_lab\PipeWeaver');E=ROOT/'eda/experiments';S=E/'comparator_action_study_20261103_004742_635275'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
d=load(S/'SUMMARY.json');out=S/'independent_reproduction'
if out.exists():raise ValueError('Refusing to overwrite reproduction')
out.mkdir()
cases=[p for p in d['profiles'] if p['id'] in ['primary_N32','boundary_N13']]
def replay(profile):
    dest=out/profile['id'];source=S/profile['id']/'best.v'
    cmd=[sys.executable,'-B',str(E/'run_native_comb.py'),str(source),'--reference',str(S/'inputs/original.v'),
         '--top','comparator','--param',f"N={profile['N']}",'--mapping-policy','buffer_size','--cleanup-before-buffer','--timeout','120','--out',str(dest)]
    env=os.environ.copy()
    for k in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(k,None)
    p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=960)
    dest.mkdir(exist_ok=True);(dest/'runner.log').write_bytes(p.stdout)
    actual=load(dest/'result.json');expected=profile['selected']['metrics']
    keys=['status','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_cells','mapped_sha256','electrical']
    checks={k:actual.get(k)==expected.get(k) for k in keys}
    return dict(profile=profile['id'],N=profile['N'],passed=p.returncode==0 and all(checks.values()),checks=checks,metrics=actual)
with ThreadPoolExecutor(max_workers=2) as pool:rows=list(pool.map(replay,cases))
report=dict(passed=all(r['passed'] for r in rows),independent_eda_replays=len(rows),model_calls=0,rows=rows)
(S/'REPRODUCTION.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in report.items() if k!='rows'}))
if not report['passed']:raise SystemExit(1)
