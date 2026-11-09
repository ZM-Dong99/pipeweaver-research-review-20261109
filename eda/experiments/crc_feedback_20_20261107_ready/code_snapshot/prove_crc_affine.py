"""Exact GF(2) qualification of fixed CRC32 updates, including shifted data.

Only explicit XOR/reduction-XOR/NOT combinational cells are accepted. Coefficient
equality proves all binary inputs; basis simulations alone would not establish
linearity. This checker is independent of the upstream mask-generator function.
"""
import copy
import hashlib
import json
from pathlib import Path
import sys


def coefficients(module, width):
    ports=module['ports']
    expected={'data_in':('input',width),'state_in':('input',32),'data_out':('output',width),'state_out':('output',32)}
    if {k:(p['direction'],len(p['bits'])) for k,p in ports.items()}!=expected:
        raise ValueError('Unexpected fixed CRC interface')
    if module.get('processes') or module.get('memories'):
        raise ValueError('Not a stateless combinational netlist')
    inputs=ports['data_in']['bits']+ports['state_in']['bits']
    if any(type(x) is not int for x in inputs) or len(set(inputs))!=len(inputs):
        raise ValueError('Input bits must be independent')
    constant=1<<len(inputs)
    values={b:1<<i for i,b in enumerate(inputs)}
    def value(b):
        if type(b) is int:return values[b]
        if b=='0':return 0
        if b=='1':return constant
        raise ValueError('Undefined net bit')
    pending=list(module['cells'].values());types={c['type'] for c in pending}
    if types-{'$reduce_xor','$xor','$not'}:
        raise ValueError('Non-affine or unsupported cell; no approximate proof')
    while pending:
        remaining=[]
        for c in pending:
            pins=c['connections'];kind=c['type']
            required={'A','Y'} if kind in ('$reduce_xor','$not') else {'A','B','Y'}
            if set(pins)!=required:raise ValueError('Unexpected affine cell pins')
            try:a=[value(b) for b in pins['A']];b=[value(x) for x in pins.get('B',[])]
            except KeyError:
                remaining.append(c);continue
            y=pins['Y']
            if kind=='$reduce_xor':
                if len(y)!=1:raise ValueError('Invalid reduction width')
                x=0
                for v in a:x^=v
                output=[x]
            else:
                def extend(bits,name):
                    signed=int(c.get('parameters',{}).get(name+'_SIGNED','0'),2)
                    return (bits+[bits[-1] if signed and bits else 0]*len(y))[:len(y)]
                a=extend(a,'A')
                output=[v^constant for v in a] if kind=='$not' else [u^v for u,v in zip(a,extend(b,'B'))]
            for net,v in zip(y,output):
                if type(net) is not int or net in values:raise ValueError('Multiply driven/invalid affine output')
                values[net]=v
        if len(remaining)==len(pending):raise ValueError('Unresolved or cyclic affine netlist')
        pending=remaining
    return {k:[value(b) for b in ports[k]['bits']] for k in ('data_out','state_out')},types


def independent_crc(width):
    # LSB-first reflected32-bit Galois CRC; state and input data remain arbitrary.
    state=[1<<(width+i) for i in range(32)];shifted=[]
    for i in range(width):
        feedback=state[0]^(1<<i);shifted.append(feedback)
        state=state[1:]+[0]
        for bit in range(32):
            if (0xedb88320>>bit)&1:state[bit]^=feedback
    return {'data_out':shifted,'state_out':state}


def prove(module,width):
    actual,types=coefficients(module,width);expected=independent_crc(width)
    return actual==expected,actual,types


def main(out):
    protocol=json.loads((out/'protocol.json').read_text());checks=[]
    for case in protocol['cases']:
        path=out/(case['id']+'_slang_invocation_fixed')/'elaborated.json'
        modules=json.loads(path.read_text())['modules']
        if set(modules)!={case['top']}:raise ValueError('Unflattened or missing module')
        module=modules[case['top']];ok,matrix,types=prove(module,case['data_width'])
        controls={}
        for port in ('data_out','state_out'):
            mutated=copy.deepcopy(module);mutated['ports'][port]['bits'][0]='0'
            controls[port+'_corruption_rejected']=not prove(mutated,case['data_width'])[0]
        bad=copy.deepcopy(module);first=next(iter(bad['cells']));bad['cells'][first]['type']='$and'
        try:prove(bad,case['data_width']);controls['unsupported_nonlinearity_rejected']=False
        except ValueError:controls['unsupported_nonlinearity_rejected']=True
        check=dict(case=case['id'],passed=ok and all(controls.values()),equivalent_all_binary_inputs=ok,
                   independent_input_bits=case['data_width']+32,checked_output_bits=case['data_width']+32,
                   cell_types=sorted(types),negative_controls=controls,matrix={k:[hex(v) for v in bits] for k,bits in matrix.items()},
                   elaborated_json_sha256=hashlib.sha256(path.read_bytes()).hexdigest())
        checks.append(check)
        print(case['id']+': '+('PASS' if check['passed'] else 'FAIL'))
    result=dict(passed=all(c['passed'] for c in checks),proof='Exact affine coefficient propagation over a whitelisted stateless graph versus independent bit-serial CRC; not randomized simulation',
                scope='Source elaboration only; mapped equivalence and electrical/PPA require separate qualification',
                checker_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),new_model_requests=0,checks=checks)
    (out/'AFFINE_SOURCE_PROOF.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    return 0 if result['passed'] else 1


if __name__=='__main__':sys.exit(main(Path(sys.argv[1]).resolve()))
