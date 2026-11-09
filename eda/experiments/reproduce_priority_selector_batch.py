"""Independently rerun deduplicated selected hardware and predeclared primary control."""
import sys,json
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate
S=ROOT/'eda/experiments/priority_selector_api_20261103_190958_372230'
def load(f):return json.loads(f.read_text(encoding='utf-8'))
p=load(S/'protocol.json');s=load(S/'summary.json');assert load(S/'AUDIT.json')['passed']
jobs=set((r['width'],r['selected']) for r in s['trials'])
for w in p['widths']:jobs.add((w,s['controls'][str(w)]['static16']['selected']))
def run(job):
    w,i=job;f=S/'independent_reproduction'/f'W{w}_{i}'
    source=S/'inputs/original.v' if i=='baseline' else S/'candidates'/(i+'.v')
    expected=p['baseline_metrics'][str(w)] if i=='baseline' else s['action_results'][str(w)][i]
    m=load(f/'result.json') if (f/'result.json').exists() else evaluate(source,f,S/'inputs/original.v',w,top='priority_encoder',parameters={'WIDTH':w,'LSB_HIGH_PRIORITY':0})
    keys=['status','formal','mapped_formal','max_data_arrival_ns','mapped_area_um2','mapped_sha256','electrical']
    matches={k:m.get(k)==expected.get(k) for k in keys}
    result={'width':w,'action':i,'passed':all(matches.values()),'comparisons':matches,'result':str(f/'result.json')}
    print(json.dumps(result),flush=True);return result
with ThreadPoolExecutor(max_workers=2) as pool:rows=list(pool.map(run,sorted(jobs)))
r={'passed':all(row['passed'] for row in rows),'cases':rows,'model_requests':0,'scope':'Deduplicated independent full EDA reruns, same original and constraints; no additional model sampling.'}
(S/'REPRODUCTION.json').write_text(json.dumps(r,indent=2),encoding='utf-8')
if not r['passed']:raise SystemExit(1)
