"""Frozen six-action mux_large development; no LLM or API usage."""
import json,sys,shutil,hashlib,re
from pathlib import Path
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
ROOT=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate,choose
SRC=ROOT/'benchmark/rtl_opt_upstream_hkust/benchmark/mux_large/mux_large.v'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2),encoding='utf-8')
names=['block_'+c for c in 'abcdefghij'];leaves=names+[names[0]]*6
header='''module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output wire [7:0] block_out
);
'''
def tree(order):
    nodes={i:n for i,n in enumerate(leaves)};lines=[]
    for stage,bit in enumerate(order):
        out={}
        for k in sorted(nodes):
            if k&(1<<bit):continue
            name=f'n_{stage}_{k}';lines.append(f'wire [7:0] {name} = sel[{bit}] ? {nodes[k|(1<<bit)]} : {nodes[k]};');out[k]=name
        nodes=out
    return '\n'.join(lines)+'\nassign block_out = '+nodes[0]+';\n'
def decoded():
    lines=["wire take_a = (sel == 4'd0) | (sel >= 4'd10);"]
    for i in range(1,10):lines.append(f"wire take_{chr(97+i)} = sel == 4'd{i};")
    lines.append('assign block_out = '+' | '.join(f'({{8{{take_{chr(97+i)}}}}} & {n})' for i,n in enumerate(names))+';')
    return '\n'.join(lines)+'\n'
def split(low):
    lines=[];banks=[]
    for group in range(1<<(4-low)):
        bank=f'bank_{group}';banks.append(bank);lines += [f'reg [7:0] {bank};','always @* begin',f'case (sel[{low-1}:0])']
        for i in range(1<<low):lines.append(f"{low}'d{i}: {bank} = {leaves[(group<<low)+i]};")
        lines += [f'default: {bank} = block_a;','endcase','end']
    if low==3:lines.append(f'assign block_out = sel[3] ? {banks[1]} : {banks[0]};')
    else:lines.append(f'assign block_out = sel[3] ? (sel[2] ? {banks[3]} : {banks[2]}) : (sel[2] ? {banks[1]} : {banks[0]});')
    return '\n'.join(lines)+'\n'

S=ROOT/'eda/experiments'/datetime.now().strftime('mux_action_development_%Y%m%d_%H%M%S_%f');S.mkdir()
for sub in ['inputs','candidates','code_snapshot']:(S/sub).mkdir()
shutil.copyfile(SRC,S/'inputs/original.v');shutil.copyfile(SRC.parents[2]/'LICENSE',S/'inputs/LICENSE')
license_text=(S/'inputs/LICENSE').read_text(encoding='utf-8');prefix='/*\n'+license_text+'\n*/\n'
bodies={'tree_low_first':tree([0,1,2,3]),'tree_high_first':tree([3,2,1,0]),'tree_interleaved':tree([1,3,0,2]),'decoded_masks':decoded(),'split_low2':split(2),'split_low3':split(3)}
for i,body in bodies.items():(S/'candidates'/(i+'.v')).write_text(prefix+header+body+'endmodule\n',encoding='utf-8')
deps=[Path(__file__).resolve(),ROOT/'agents/action_loop.py',ROOT/'eda/experiments/run_native_comb.py',ROOT/'eda/experiments/trace_sta_rtl_cone.py']
for f in deps:shutil.copyfile(f,S/'code_snapshot'/f.name)
p=dict(client_date='2026-11-04',purpose='Local action-space development on a different family; no model-method comparison',family='selection',top='mux_large',parameters={},model_requests=0,
       original_source=str(SRC),source_sha256=sha(S/'inputs/original.v'),candidate_sha256={i:sha(S/'candidates'/(i+'.v')) for i in bodies},code_sha256={str(f):sha(f) for f in deps},
       actions=list(bodies),area_ratio_limit=1.10,primary='Minimize combinational maximum data arrival with strict improvement and mapped area cap; otherwise keep original',
       contract='All 84 input bits unconstrained, all 8 output bits exactly equal for every two-state input. sel0..9 select a..j; sel10..15 select a. No latency, port or default change. No X/Z simulation-equivalence claim.',
       exposure='Public source baseline previously qualified. Six candidate source bodies frozen together before new PPA. This is development, not an unexposed model evaluation.',
       limitations='One short 10x8 combinational source, not a large system. Existing SKY130HD TT pre-layout backend, no power/physical signoff.')
save(S/'protocol.json',p);(S/'protocol.sha256').write_text(sha(S/'protocol.json')+'\n',encoding='ascii');print('Frozen: '+str(S),flush=True)
def measure(i):
    source=S/'inputs/original.v' if i=='baseline' else S/'candidates'/(i+'.v')
    result=evaluate(source,S/'evaluations'/i,S/'inputs/original.v',0,top='mux_large',parameters={})
    print(i,result.get('status'),result.get('max_data_arrival_ns'),result.get('mapped_area_um2'),flush=True);return i,result
with ThreadPoolExecutor(max_workers=2) as pool:rows=dict(pool.map(measure,['baseline']+list(bodies)))
baseline=rows.pop('baseline');selected=choose(list(bodies),rows,baseline,baseline['mapped_area_um2']*1.10) if baseline.get('status')=='PASS' else 'BASELINE_FAILED'
save(S/'SUMMARY.json',dict(baseline=baseline,results=rows,selected=selected,model_requests=0))
checks=[]
def check(k,v):checks.append(dict(check=k,passed=bool(v)))
check('protocol freeze',sha(S/'protocol.json')==(S/'protocol.sha256').read_text().strip());check('original unchanged',sha(SRC)==p['source_sha256'])
for i,h in p['candidate_sha256'].items():check(i+' frozen RTL',sha(S/'candidates'/(i+'.v'))==h)
for i,m in {'baseline':baseline,**rows}.items():
    f=S/'evaluations'/i;check(i+' complete',m.get('status')=='PASS')
    if m.get('status')!='PASS':continue
    for stage in ['formal','mapped_formal']:check(i+' '+stage,m[stage]=='PASS' and 'SAT proof finished - no model found: SUCCESS!' in (f/(stage+'.log')).read_text(encoding='utf-8'))
    raw=(f/'sta.log').read_text(encoding='utf-8');check(i+' measured delay',max(float(x) for x in re.findall(r'([-+\d.]+)\s+data arrival time',raw))==m['max_data_arrival_ns'])
    area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(f/'mapping.log').read_text(encoding='utf-8'))[-1]);check(i+' raw mapped area',area==m['mapped_area_um2'])
    check(i+' mapped hash',sha(f/'mapped.v')==m['mapped_sha256']==m['sta_netlist_sha256'])
    check(i+' electrical',m['electrical']['status']=='PASS' and m['electrical']['violation_rows']==0)
save(S/'AUDIT.json',dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks))
repros=[]
if selected!='BASELINE_FAILED':
    for i in dict.fromkeys(['baseline',selected]):
        source=S/'inputs/original.v' if i=='baseline' else S/'candidates'/(i+'.v');m=baseline if i=='baseline' else rows[i]
        fresh=evaluate(source,S/'independent_reproduction'/i,S/'inputs/original.v',0,top='mux_large',parameters={})
        keys=['status','formal','mapped_formal','max_data_arrival_ns','mapped_area_um2','mapped_sha256','electrical'];match={k:m.get(k)==fresh.get(k) for k in keys}
        repros.append(dict(action=i,passed=all(match.values()),comparisons=match))
save(S/'REPRODUCTION.json',dict(passed=bool(repros) and all(r['passed'] for r in repros),cases=repros,model_requests=0))
print('Selected: '+selected,flush=True)
print('Audit: '+str(all(c['passed'] for c in checks))+' checks='+str(len(checks)),flush=True)
