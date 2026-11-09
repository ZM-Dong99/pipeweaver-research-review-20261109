"""Reset-only, valid/keep-qualified interface proof. Separate from strict all-pin contract."""
import argparse
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

from run_native_comb import identifier,q
from run_native_seq_initialized import common_state_nets

ROOT=Path(__file__).resolve().parents[2]
PARENT=ROOT/'eda/experiments/stream_initialized_controls_20261106'
SRC=ROOT/'benchmark/engineering_sources_20261106'
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def save(p,d):p.write_text(json.dumps(d,indent=2,ensure_ascii=False),encoding='utf-8')


def miter(module,states,kind,strict):
    ports={n:(v['direction'],len(v['bits'])) for n,v in module['ports'].items()}
    ports.update({n:('output',w) for n,w in states.items()})
    declarations=[];gold=[];cand=[];inputs=[];g={};c={};aliases={}
    for i,(name,(direction,width)) in enumerate(ports.items()):
        if direction=='input':
            wire=f'in_{i}';aliases[name]=wire;inputs.append(wire)
            declarations.append(f'input [{width-1}:0] {wire};');g[name]=c[name]=wire
        else:
            g[name]=f'g_{i}';c[name]=f'c_{i}';declarations.append(f'wire [{width-1}:0] {g[name]}, {c[name]};')
        gold.append(f'.{identifier(name)}({g[name]})');cand.append(f'.{identifier(name)}({c[name]})')
    diffs=[];rules=[]
    def compare(name,guard='1\'b1',mask=None):
        if mask is None:diff=f'({g[name]} != {c[name]})'
        else:diff=f'(|(({g[name]} ^ {c[name]}) & ({mask})))'
        diffs.append(f'(({guard}) && {diff})');rules.append(dict(signal=name,guard=guard,mask=mask))
    def bytemask(keep,width,extra=None):
        return '{'+', '.join('{8{'+keep+f'[{j}]'+(f' && ({extra(j)})' if extra else '')+'}}' for j in reversed(range(width//8)))+'}'
    if strict:
        for name,v in module['ports'].items():
            if v['direction']=='output':compare(name)
    else:
        compare('s_axis_tready');compare('m_axis_tvalid')
        for name in ('m_axis_tkeep','m_axis_tlast','m_axis_tid','m_axis_tdest','m_axis_tuser'):
            compare(name,g['m_axis_tvalid'])
        compare('m_axis_tdata',g['m_axis_tvalid'],bytemask(g['m_axis_tkeep'],32))
        for name in states:
            if name.endswith(('tvalid_reg','tready_reg','seg_reg')):
                compare(name);continue
            if kind=='adapter':
                prefix='genblk1.upsize.'
                if '.s_axis_' in name:
                    compare(name,g[prefix+'s_axis_tvalid_reg']);continue
                valid=g[prefix+'m_axis_tvalid_reg'];seg=g[prefix+'seg_reg'];keep=g[prefix+'m_axis_tkeep_reg']
                if name.endswith('tdata_reg'):
                    compare(name,"1'b1",bytemask(keep,32,lambda j:f'{valid} || ({seg} > {j})'))
                elif name.endswith('tkeep_reg'):
                    compare(name,f'{valid} || ({seg} != 0)')
                else:compare(name,valid)
            else:
                prefix='genblk1.'+('temp_m_axis_' if '.temp_m_axis_' in name else 'm_axis_')
                valid=g[prefix+'tvalid_reg']
                if name.endswith('tdata_reg'):compare(name,valid,bytemask(g[prefix+'tkeep_reg'],32))
                else:compare(name,valid)
        if kind=='adapter' and states:
            # Reachability properties are PROVEN on each side, never assumed.
            # Speculative writes may set keep[seg], but bytes above seg are empty.
            for side,label in ((g,'gold'),(c,'candidate')):
                prefix='genblk1.upsize.'
                valid=side[prefix+'m_axis_tvalid_reg'];buffered=side[prefix+'s_axis_tvalid_reg']
                seg=side[prefix+'seg_reg'];keep=side[prefix+'m_axis_tkeep_reg']
                bad=[f'({valid} && ({seg} != 0))',f'({buffered} && ({seg} != 0))']
                bad += [f'(!{valid} && ({seg} != 0) && {keep}[{j}] && ({seg} < {j}))' for j in range(1,4)]
                for term in bad:
                    diffs.append(term)
                    rules.append(dict(reachability_side=label,forbidden_condition=term,assumed=False))
    text='\n'.join(['module pw_miter('+','.join(inputs+['mismatch'])+');',*declarations,'output mismatch;',
         'pw_gold gold('+','.join(gold)+');','pw_cand cand('+','.join(cand)+');','assign mismatch = '+' | '.join(diffs)+';','endmodule'])+'\n'
    return text,aliases,rules


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',required=True,type=Path);a=ap.parse_args()
    out=a.out.resolve();out.mkdir(parents=True,exist_ok=False);fixtures=out/'fixtures';fixtures.mkdir()
    parent=load(PARENT/'protocol.json')
    cases=[]
    for kind,filename,top,params in [('adapter','axis_adapter.v','axis_adapter',{'S_DATA_WIDTH':8,'M_DATA_WIDTH':32}),('skid','axis_register.v','axis_register',{'DATA_WIDTH':32,'REG_TYPE':2})]:
        source=SRC/filename;folder=PARENT/kind
        if load(folder/'result.json')['status']!='PASS':raise RuntimeError('Unqualified parent mapping')
        module=load(folder/'reference_schema.json')['modules'][top];mapped=load(folder/'mapped.json')['modules'][top]
        for label,is_gate,strict,expected in [('source',False,False,'PASS'),('gate',True,False,'PASS'),('all_pins',False,True,'FAIL')]:
            cases.append(dict(id=kind+'_'+label,kind=kind,top=top,params=params,source=str(source),candidate=str(folder/'mapped.v' if is_gate else source),mapped=is_gate,strict=strict,expected=expected,
                module=module,target_module=mapped if is_gate else module))
    original=(PARENT/'adapter/mapped.v').read_text(encoding='utf-8')
    mutations={
        'wrong_ready':('s_axis_tready',lambda rhs:'('+rhs+") ^ 1'b1",'FAIL'),
        'wrong_valid':('m_axis_tvalid',lambda rhs:'('+rhs+") ^ 1'b1",'FAIL'),
        'wrong_payload':('m_axis_tdata',lambda rhs:'('+rhs+") ^ 32'h1",'FAIL'),
        'invalid_payload_only':('m_axis_tdata',lambda rhs:"m_axis_tvalid ? ("+rhs+") : 32'hffffffff",'PASS'),
        'invalid_bytes_only':('m_axis_tdata',lambda rhs:'('+rhs+') ^ { {8{~m_axis_tkeep[3]}}, {8{~m_axis_tkeep[2]}}, {8{~m_axis_tkeep[1]}}, {8{~m_axis_tkeep[0]}} }','PASS'),
        'wrong_keep':('m_axis_tkeep',lambda rhs:'('+rhs+") ^ 4'h1",'FAIL')}
    template=next(c for c in cases if c['id']=='adapter_gate')
    for name,(port,change,expected) in mutations.items():
        text,n=re.subn(r'(assign\s+'+port+r'\s*=\s*)([^;]+);',lambda m:m[1]+change(m[2])+';',original)
        if name=='wrong_ready' and n==0:
            text,n=re.subn(r'(\.(?:Y|X|Q)\()s_axis_tready(\))',r'\1pw_raw_ready\2',original)
            text=text.replace('endmodule',"wire pw_raw_ready;\nassign s_axis_tready = ~pw_raw_ready;\nendmodule")
        if n!=1:raise RuntimeError('Expected exactly one mutation')
        dest=fixtures/(name+'.v');dest.write_text(text,encoding='utf-8')
        cases.append(dict(template,id=name,candidate=str(dest),expected=expected))
    for case in cases:
        folder=out/case['id'];folder.mkdir()
        states={} if case['strict'] else common_state_nets(case['module'],case['target_module'],case['mapped'])
        text,aliases,rules=miter(case['module'],states,case['kind'],case['strict'])
        mp=folder/'miter.v';mp.write_text(text,encoding='utf-8');save(folder/'comparison_rules.json',dict(rules=rules,extra_state_nets=states,state_equalities_assumed=0))
        def prepare(source,name,mapped):
            lines=([f'read_liberty -ignore_miss_func -ignore_miss_dir {q(LIB)}',f'read_verilog -formal -sv {q(Path(source))}'] if mapped else [f'read_verilog -formal -sv {q(Path(source))}']+[f'chparam -set {k} {v} {case["top"]}' for k,v in case['params'].items()])
            lines += [f'hierarchy -check -top {case["top"]}','proc','flatten','setattr -unset init']
            lines += [f'expose {case["top"]}/w:{n}' for n in states]
            lines += [f'rename {case["top"]} {name}',f'write_json {q(folder/(name+"_noinit.json"))}',f'design -stash {name}_design']
            return lines
        script=prepare(case['source'],'pw_gold',False)+prepare(case['candidate'],'pw_cand',case['mapped'])+[
            'design -reset','design -copy-from pw_gold_design pw_gold','design -copy-from pw_cand_design pw_cand',
            f'read_verilog -formal {q(mp)}','prep -top pw_miter -flatten','opt_clean',
            f'sat -verify -seq 2 -tempinduct -maxsteps 32 -set-init-def -set-def-inputs -set-at 1 {aliases["rst"]} 1 -prove mismatch 0 -show-ports -dump_vcd {q(folder/"counterexample.vcd")} -timeout 120']
        (folder/'prove.ys').write_text('\n'.join(script)+'\n',encoding='utf-8')
        case['source_sha256']=sha(Path(case['source']));case['candidate_sha256']=sha(Path(case['candidate']))
        case.pop('module');case.pop('target_module')
    snap=out/'code_snapshot';snap.mkdir();deps=[Path(__file__),Path(__file__).with_name('run_native_seq_initialized.py'),Path(__file__).with_name('run_native_comb.py')]
    for p in deps:shutil.copyfile(p,snap/p.name)
    protocol=dict(created_at=datetime.now().astimezone().isoformat(),cases=cases,model_requests=0,new_sta_runs=0,
        semantics='New reset-only observable interface contract, not original all-pin equality. Remove ALL source and gate init attributes; independently arbitrary defined initial state. rst asserted sample1 only, all inputs arbitrary afterwards. Compare ready/valid always; sidebands and tkeep when mvalid; data only valid lanes.',
        state_relations='Extra conditional state equalities are joint proof goals with complete SAT base+induction; never assumed.',
        adapter_partial_packet='Partially collected data compared only in earlier accepted segments and only enabled keep bytes; output-valid data uses all enabled bytes.',
        hardware_scope='Two-state edge-sampled interface relation only, not full AXI protocol correctness or physical power-up/CDC/signoff. No new PPA: same frozen parent mapped gates.',
        parent_protocol_sha256=sha(PARENT/'protocol.json'),parent_mapped={k:sha(PARENT/k/'mapped.v') for k in ('adapter','skid')},library_sha256=sha(LIB),
        frozen_files={str(p.relative_to(out)):sha(p) for p in out.rglob('*') if p.is_file()},dependencies={str(p.resolve().relative_to(ROOT)):sha(p) for p in deps})
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(key,None)
    env['PATH']='D:\\oss-cad-suite\\bin;D:\\oss-cad-suite\\lib;'+env.get('PATH','')
    results=[]
    for case in cases:
        for rel,h in protocol['dependencies'].items():
            if sha(ROOT/rel)!=h:raise RuntimeError('Frozen dependency changed')
        folder=out/case['id']
        try:
            p=subprocess.run(['D:/oss-cad-suite/bin/yosys.exe','-Q',str(folder/'prove.ys')],cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=150)
            raw=p.stdout;code=p.returncode
        except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+b'\nTIMEOUT';code=124
        (folder/'proof.log').write_bytes(raw)
        status='PASS' if code==0 and b'Induction step proven: SUCCESS!' in raw else 'FAIL' if b'model found for base case: FAIL!' in raw else 'INCOMPLETE'
        init_remaining={}
        for name in ('pw_gold','pw_cand'):
            jp=folder/(name+'_noinit.json')
            if jp.exists():
                module=load(jp)['modules'][name]
                init_remaining[name]=sum('init' in n.get('attributes',{}) for n in module['netnames'].values())
        row=dict(id=case['id'],expected=case['expected'],actual=status,matched=status==case['expected'],remaining_init_attributes=init_remaining,exit_code=code)
        if init_remaining!={'pw_gold':0,'pw_cand':0}:row['matched']=False
        results.append(row);save(out/'SUMMARY.json',dict(results=results,model_requests=0,new_sta_runs=0,passed=all(r['matched'] for r in results)))
        print(case['id']+': '+status+' expected='+case['expected'],flush=True)
    return 0 if all(r['matched'] for r in results) else 1


if __name__=='__main__':raise SystemExit(main())
