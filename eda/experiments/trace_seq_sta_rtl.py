"""Trace recorded register-to-register STA paths using existing Yosys artifacts.

Strictly supports the flat scalar-cell Verilog format emitted by this backend.
Registers map through preserved Q signal names and JSON bit identity. RTL
cones are conservative all-input dependencies, not a gate-to-source mapping.
"""
import argparse
from collections import defaultdict, Counter
import hashlib
import json
from pathlib import Path
import re

def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return json.loads(p.read_text(encoding='utf-8'))
def bit_of(module, expression):
    match=re.fullmatch(r'([A-Za-z_][\w.$]*)(?:\[(\d+)\])?', expression)
    if not match: raise ValueError('Unsupported signal expression: '+expression)
    name,index=match.groups(); net=module['netnames'][name]
    indices=list(range(net.get('offset',0),net.get('offset',0)+len(net['bits'])))
    if net.get('upto',0): indices.reverse()
    pos=0 if index is None and len(indices)==1 else indices.index(int(index))
    return net['bits'][pos], net.get('attributes',{}).get('src')

def analyze(folder):
    mapped=read(folder/'mapped.json')['modules']['arbiter']
    schema=read(folder/'candidate_schema.json')['modules']['arbiter']
    text=(folder/'mapped.v').read_text(encoding='utf-8')
    instances={}
    for match in re.finditer(r'^\s*(sky130_\w+)\s+(\w+)\s*\((.*?)\);',text,re.M|re.S):
        kind,name,body=match.groups()
        pairs=re.findall(r'\.(\w+)\(([^()]*)\)',body)
        instances[name]=dict(type=kind,pins={p:re.sub(r'\s+','',v) for p,v in pairs})
    if len(instances)!=len(mapped['cells']): raise ValueError('Incomplete mapped Verilog cell parse')
    parent={}
    def root(x):
        parent.setdefault(x,x)
        if parent[x]!=x: parent[x]=root(parent[x])
        return parent[x]
    def union(a,b): parent[root(a)]=root(b)
    # Only scalar aliases are needed by the data-path connection checks. Vector
    # aliases remain unexpanded; a path needing one must fail closed.
    for a,b in re.findall(r'^\s*assign\s+([^=;]+)\s*=\s*([^;]+);',text,re.M):
        a,b=re.sub(r'\s+','',a),re.sub(r'\s+','',b)
        if re.fullmatch(r'[\w.$]+(?:\[\d+\])?',a) and re.fullmatch(r'[\w.$]+(?:\[\d+\])?',b): union(a,b)
    directions={}
    for c in mapped['cells'].values():
        old=directions.setdefault(c['type'],c['port_directions'])
        if old!=c['port_directions']: raise ValueError('Inconsistent library cell pin directions')
    first=(folder/'sta.log').read_text(encoding='utf-8').split('Startpoint: ')[1].split('Startpoint: ')[0]
    start=first.splitlines()[0].split()[0]; end=re.search(r'Endpoint: (\S+)',first)[1]
    rows=[]
    for match in re.finditer(r'^\s*([-+\d.]+)\s+([-+\d.]+)\s+[\^v]\s+(\w+)/(\w+)\s+\(([^)]+)\)',first,re.M):
        delay,time,cell,pin,kind=match.groups()
        # Skip clock rows, including endpoint capture clock.
        if pin=='CLK': continue
        actual=instances[cell]
        if actual['type']!=kind or pin not in actual['pins']: raise ValueError('STA/Verilog pin mismatch')
        rows.append(dict(cell=cell,pin=pin,type=kind,net=actual['pins'][pin],increment_ns=float(delay),time_ns=float(time)))
    if rows[0]['cell']!=start or rows[0]['pin']!='Q' or rows[-1]['cell']!=end or rows[-1]['pin']!='D':
        raise ValueError('Only register Q to register D paths supported')
    connection_checks=[]
    for previous,current in zip(rows,rows[1:]):
        c=instances[current['cell']]
        if directions[c['type']][current['pin']]=='input': targets=[c['pins'][current['pin']]]
        else: targets=[c['pins'][p] for p,d in directions[c['type']].items() if d=='input']
        connected=any(root(previous['net'])==root(t) for t in targets)
        connection_checks.append(connected)
        if not connected: raise ValueError('STA path not structurally connected in mapped netlist')
    def register(name):
        expr=instances[name]['pins']['Q']
        mapped_bit,mapped_src=bit_of(mapped,expr); schema_bit,schema_src=bit_of(schema,expr)
        mapped_ff=[(n,c) for n,c in mapped['cells'].items() if c['type']==instances[name]['type'] and c['connections'].get('Q')==[mapped_bit]]
        ff=[(n,c) for n,c in schema['cells'].items() if c['type']=='$dff' and schema_bit in c['connections']['Q']]
        if len(mapped_ff)!=1 or len(ff)!=1: raise ValueError('Ambiguous register match')
        n,c=ff[0]; pos=c['connections']['Q'].index(schema_bit)
        return dict(sta_cell=name,rtl_q=expr,mapped_bit=mapped_bit,schema_bit=schema_bit,
                    declaration_src=schema_src,mapped_declaration_src=mapped_src,
                    mapped_cell=mapped_ff[0][0],schema_cell=n,rtl_process_src=c.get('attributes',{}).get('src'),
                    schema_d_bit=c['connections']['D'][pos])
    a,b=register(start),register(end)
    drivers=defaultdict(list)
    for name,c in schema['cells'].items():
        for port,direction in c['port_directions'].items():
            if direction=='output':
                for bit in c['connections'][port]:
                    if isinstance(bit,int): drivers[bit].append((name,c))
    queue=[b['schema_d_bit']]; seen=set(); cells={}; leaves=set()
    while queue:
        bit=queue.pop()
        if not isinstance(bit,int) or bit in seen: continue
        seen.add(bit)
        if not drivers[bit]: leaves.add(bit)
        for name,c in drivers[bit]:
            if c['type']=='$dff': leaves.add(bit); continue
            if re.search(r'dff|latch|mem',c['type'],re.I): raise ValueError('Unsupported sequential cone cell')
            cells[name]=c
            queue.extend(v for p,d in c['port_directions'].items() if d=='input' for v in c['connections'][p])
    aliases=[]
    for name,net in schema['netnames'].items():
        if net.get('hide_name') or name.startswith('$'): continue
        hits=[i+net.get('offset',0) for i,bit in enumerate(net['bits']) if bit in leaves]
        if hits: aliases.append(dict(name=name,indices=hits,src=net.get('attributes',{}).get('src')))
    reachable=a['schema_bit'] in leaves
    if not reachable: raise ValueError('Mapped start register absent from conservative RTL endpoint cone')
    return dict(folder=str(folder),start=a,end=b,data_path=rows,connection_checks=len(connection_checks),
                start_register_in_conservative_cone=reachable,
                conservative_cone=dict(cell_count=len(cells),cell_types=dict(Counter(c['type'] for c in cells.values())),
                                       boundary_signals=aliases,source_spans=sorted({c.get('attributes',{}).get('src') for c in cells.values() if c.get('attributes',{}).get('src')})),
                artifact_sha256={n:digest(folder/n) for n in ['mapped.v','mapped.json','candidate_schema.json','sta.log']},
                limitations='Exact STA endpoints and mapped connectivity; RTL cone over-approximates dependencies. No per-gate RTL attribution, sensitization proof or causal optimization claim.')

def main():
    ap=argparse.ArgumentParser(description=__doc__); ap.add_argument('study',type=Path);ap.add_argument('--out',type=Path,required=True);args=ap.parse_args()
    if args.out.exists(): raise ValueError('Refusing to overwrite output')
    summary=read(args.study/'SUMMARY.json'); results=[]
    for p in summary['profiles']:
        for name in ['baseline','known_reference']+[r['id'] for r in p['results']]:
            row=analyze(args.study/p['id']/name);row.update(profile=p['id'],case=name);results.append(row)
    report=dict(passed=True,paths=len(results),connection_checks=sum(r['connection_checks'] for r in results),
                model_calls=0,new_eda_calls=0,results=results)
    args.out.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k!='results'}))
    for r in results:
        if r['case']=='baseline' or r['case']==next(p['best_new_id'] for p in summary['profiles'] if p['id']==r['profile']):
            print(r['profile'],r['case'],r['start']['rtl_q'],'->',r['end']['rtl_q'])
if __name__=='__main__': main()
