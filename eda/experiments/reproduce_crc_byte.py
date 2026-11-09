"""Rebuild the qualified CRC32 byte-update baseline from locked source; no LLM."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.portfolio_loop import evaluate,qualified
from eda.experiments.prove_crc_affine import prove

STUDY=ROOT/'eda/experiments/crc_transfer_qualification_20261107'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def main(out):
    protocol=load(STUDY/'protocol.json')
    if sha(STUDY/'protocol.json')!=(STUDY/'protocol.sha256').read_text().strip():raise ValueError('Source protocol changed')
    case=next(c for c in protocol['cases'] if c['data_width']==8)
    source=STUDY/case['source']
    if sha(source)!=case['source_sha256']:raise ValueError('Locked original/wrapper changed')
    out=out.resolve();out.mkdir(parents=True,exist_ok=False);shutil.copyfile(source,out/'source.v')
    env=os.environ.copy();yosys=Path(os.environ.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    # Simple relative names avoid plugin-specific quotation handling, including
    # when the containing workspace path has spaces.
    script=out/'frontend.ys';script.write_text('read_slang --top crc32_d8 source.v\nhierarchy -check -top crc32_d8\nproc\nflatten\nopt\ncheck -assert\nwrite_json source.json\nwrite_verilog -noattr elaborated.v\n',encoding='ascii')
    (out/'REPRODUCTION_PROTOCOL.json').write_text(json.dumps(dict(source_sha256=sha(source),
         source_protocol_sha256=sha(STUDY/'protocol.json'),driver_sha256=sha(Path(__file__)),
         affine_checker_sha256=sha(Path(__file__).with_name('prove_crc_affine.py')),new_model_requests=0),indent=2),encoding='utf-8')
    p=subprocess.run([str(yosys),'-s',str(script)],cwd=out,env=env,capture_output=True,timeout=60)
    (out/'frontend.log').write_bytes(p.stdout+p.stderr)
    if p.returncode:raise RuntimeError('Slang frontend failed; inspect frontend.log')
    modules=load(out/'source.json')['modules']
    if set(modules)!={'crc32_d8'}:raise ValueError('Unexpected module scope')
    ok,matrix,types=prove(modules['crc32_d8'],8)
    (out/'SOURCE_AFFINE_PROOF.json').write_text(json.dumps(dict(passed=ok,input_bits=40,output_bits=40,
        types=sorted(types),coefficients={k:[hex(v) for v in values] for k,values in matrix.items()}),indent=2),encoding='utf-8')
    if not ok:raise RuntimeError('Independent CRC model mismatch')
    result=evaluate(out/'elaborated.v',out/'elaborated.v',{'top':'crc32_d8','parameters':{}},out/'evaluation')
    previous=load(STUDY/'crc32_d8_baseline/result.json')
    comparisons={k:result.get(k)==previous.get(k) for k in ('status','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_cells','mapped_sha256','sdc_sha256','electrical')}
    report=dict(passed=qualified(result),independent_crc_source_proof=ok,new_model_requests=0,result=result,
                historical_metrics_equal=all(comparisons.values()),comparisons=comparisons)
    (out/'RESULT.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps(dict(passed=report['passed'],historical_metrics_equal=report['historical_metrics_equal'],
         delay_ns=result.get('max_data_arrival_ns'),area_um2=result.get('mapped_area_um2'),new_model_requests=0)))
    return 0 if report['passed'] else 1


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('out',type=Path)
    sys.exit(main(ap.parse_args().out))
