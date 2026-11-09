"""Fixed CRC32 byte-update candidate evaluation through Slang and full EDA.

The reference is the locked, independently checked engineering source instance.
This module never generates RTL or invokes a model.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.portfolio_loop import evaluate,qualified

STUDY=ROOT/'eda/experiments/crc_transfer_qualification_20261107'
TOP='crc32_d8'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def reference():
    p=load(STUDY/'protocol.json')
    if sha(STUDY/'protocol.json')!=(STUDY/'protocol.sha256').read_text().strip():raise ValueError('Reference protocol changed')
    c=next(c for c in p['cases'] if c['data_width']==8)
    if sha(STUDY/c['source'])!=c['source_sha256']:raise ValueError('Original fixed source changed')
    compiled=STUDY/'crc32_d8_slang_invocation_fixed/elaborated.v'
    e=load(STUDY/'EVALUATION_PROTOCOL.json')
    if sha(compiled)!=e['elaborated_input_hashes'][TOP]:raise ValueError('Compiled reference changed')
    a=load(STUDY/'AFFINE_SOURCE_PROOF.json')
    proof=next(c for c in a['checks'] if c['case']==TOP)
    if not a['passed'] or not proof['equivalent_all_binary_inputs']:raise ValueError('Reference independent CRC proof missing')
    if sha(STUDY/'crc32_d8_slang_invocation_fixed/elaborated.json')!=proof['elaborated_json_sha256']:raise ValueError('Reference proof netlist changed')
    return compiled


def lexical_guard(text):
    # Preserve strings while removing comments, so a comment cannot disguise an
    # external include or formal assumption. Strings themselves cannot perform
    # synthesis-time I/O under the restrictions below.
    tokens=re.findall(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/|[^/"\n]+|[/"\n]',text)
    clean=''.join(' ' if t.startswith(('//','/*')) else t for t in tokens)
    if re.search(r'`\s*include\b|\$(?:readmem\w*|fopen|fread|system)\b|\bimport\s+"DPI',clean,re.I):
        raise ValueError('External source, file access and DPI are unsupported')
    without_strings=re.sub(r'"(?:\\.|[^"\\])*"','""',clean)
    if re.search(r'\b(?:assume|assert|cover|restrict)\b',without_strings):
        raise ValueError('Formal constraints/properties are forbidden in candidates')


def structural_guard(modules):
    if set(modules)!={TOP}:raise ValueError('Candidate must flatten to the fixed top')
    m=modules[TOP]
    expected={'data_in':('input',8),'state_in':('input',32),'data_out':('output',8),'state_out':('output',32)}
    if {n:(p['direction'],len(p['bits'])) for n,p in m['ports'].items()}!=expected:
        raise ValueError('Candidate CRC interface changed')
    if any(b in ('x','z') for p in m['ports'].values() for b in p['bits']):
        raise ValueError('Undefined outputs are unsupported')
    if m.get('memories'):raise ValueError('Memory is unsupported')
    drivers={}
    for c in m['cells'].values():
        if re.search(r'dff|latch|mem|ff$|anyseq|anyconst|assume|assert|initstate|\$check',c['type'],re.I):
            raise ValueError('State or formal cells are forbidden')
        directions=c.get('port_directions',{})
        if set(directions)!=set(c['connections']):raise ValueError('Unknown cell port directions')
        inputs=[b for pin,bits in c['connections'].items() if directions[pin]=='input' for b in bits]
        for pin,bits in c['connections'].items():
            if directions[pin] not in ('input','output'):raise ValueError('Unsupported cell direction')
            if directions[pin]=='output':
                for b in bits:
                    if type(b) is int:drivers.setdefault(b,[]).append(inputs)
    # Slang retains dead temporaries from constant functions before opt. Reject
    # undefined values in the conservative output cone, not in dead metadata.
    free={b for p in m['ports'].values() if p['direction']=='input' for b in p['bits']}
    pending=[b for p in m['ports'].values() if p['direction']=='output' for b in p['bits']];seen=set()
    while pending:
        b=pending.pop()
        if b in ('x','z'):raise ValueError('Undefined value can reach an output')
        if b in ('0','1') or b in free or b in seen:continue
        seen.add(b)
        if b not in drivers:raise ValueError('Undriven output dependency')
        for inputs in drivers[b]:pending.extend(inputs)
    if any('init' in n.get('attributes',{}) for n in m.get('netnames',{}).values()):
        raise ValueError('Initialization attributes are unsupported')


def run(candidate,out):
    locked_reference=reference();candidate=candidate.resolve();out=out.resolve()
    out.mkdir(parents=True,exist_ok=False);shutil.copyfile(candidate,out/'candidate.v');shutil.copyfile(locked_reference,out/'reference.v')
    result=dict(status='FAILED',stage='candidate_guard',formal='NOT_RUN',mapped_formal='NOT_RUN',ppa='NOT_RUN',model_requests=0)
    save=lambda name,obj:(out/name).write_text(json.dumps(obj,indent=2,ensure_ascii=False,allow_nan=False),encoding='utf-8')
    save('protocol.json',dict(candidate_sha256=sha(candidate),reference_sha256=sha(locked_reference),
         original_reference_protocol_sha256=sha(STUDY/'protocol.json'),candidate_frontend='Slang on raw candidate, then proc/flatten/opt',
         runner_sha256=sha(Path(__file__)),reference_scope='Exact CRC32/Galois/reflected/8-bit-data instance, all40 inputs and40 outputs',model_requests=0))
    try:
        lexical_guard((out/'candidate.v').read_text(encoding='utf-8-sig'))
        env=os.environ.copy();yosys=Path(os.environ.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
        env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
        for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
        temp=out/'frontend_tmp';temp.mkdir()
        for k in ('TMP','TEMP','TMPDIR'):env[k]=str(temp)
        script=out/'frontend.ys';script.write_text('read_slang --top crc32_d8 candidate.v\nhierarchy -check -top crc32_d8\nflatten\nwrite_json before_opt.json\nproc\nopt\ncheck -assert\nwrite_json after_opt.json\nwrite_verilog -noattr candidate_elaborated.v\n',encoding='ascii')
        result['stage']='candidate_frontend'
        try:
            p=subprocess.run([str(yosys),'-s',str(script)],cwd=out,env=env,capture_output=True,timeout=60)
            (out/'frontend.log').write_bytes(p.stdout+p.stderr)
        except subprocess.TimeoutExpired as e:
            (out/'frontend.log').write_bytes((e.stdout or b'')+(e.stderr or b''));raise ValueError('Candidate frontend timeout') from None
        if p.returncode:raise ValueError('Candidate frontend failed; inspect frontend.log')
        result['stage']='structural_guard'
        structural_guard(load(out/'before_opt.json')['modules']);structural_guard(load(out/'after_opt.json')['modules'])
        result=evaluate(out/'candidate_elaborated.v',out/'reference.v',{'top':TOP,'parameters':{}},out/'eda')
        result.update(model_requests=0,candidate_frontend='Slang',raw_candidate_sha256=sha(out/'candidate.v'),
                      candidate_elaborated_sha256=sha(out/'candidate_elaborated.v'),original_reference_sha256=sha(locked_reference))
    except (ValueError,OSError) as e:
        result['failure_reason']=str(e)
    save('result.json',result)
    print(json.dumps({k:result.get(k) for k in ('status','stage','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','model_requests')}),flush=True)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('candidate',type=Path);p.add_argument('--out',required=True,type=Path)
    a=p.parse_args();r=run(a.candidate,a.out)
    sys.exit(0 if qualified(r) else 1)
