"""Real positive/negative acceptance of the new raw-candidate CRC frontend."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
STUDY=ROOT/'eda/experiments/crc_transfer_qualification_20261107'


def main(out):
    out=out.resolve();out.mkdir(parents=True,exist_ok=False)
    ports='input wire [7:0] data_in,input wire [31:0] state_in,output wire [7:0] data_out,output wire [31:0] state_out'
    assumption=out/'assumption.v';assumption.write_text('module crc32_d8('+ports+"); always @* assume(1'b0); assign state_out=0;assign data_out=0;endmodule\n",encoding='ascii')
    stateful=out/'stateful.v';stateful.write_text('module crc32_d8('+ports+'); reg [31:0] state;always @(posedge data_in[0])state<=state_in;assign state_out=state;assign data_out=data_in;endmodule\n',encoding='ascii')
    undefined=out/'undefined.v';undefined.write_text('module crc32_d8('+ports+");assign state_out=32'bx;assign data_out=0;endmodule\n",encoding='ascii')
    cases=[('original',STUDY/'inputs/crc32_d8.v',True,None),('bitserial',STUDY/'inputs/crc32_d8_oracle.v',True,None),
           ('wrong_state',STUDY/'inputs/bad_state_out.v',False,'formal'),('wrong_data',STUDY/'inputs/bad_data_out.v',False,'formal'),
           ('assumption',assumption,False,'candidate_guard'),('stateful',stateful,False,'structural_guard'),('undefined',undefined,False,'structural_guard')]
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    records=[]
    for label,source,expected,stage in cases:
        d=out/label
        p=subprocess.run([sys.executable,'-B',str(Path(__file__).with_name('evaluate_crc_candidate.py')),str(source),'--out',str(d)],cwd=ROOT,env=env,capture_output=True,timeout=1200)
        (out/(label+'_runner.log')).write_bytes(p.stdout+p.stderr)
        if not (d/'result.json').exists():raise RuntimeError('Missing CRC acceptance result '+label)
        r=json.loads((d/'result.json').read_text())
        checks=dict(expected_exit=(p.returncode==0)==expected,model_requests_zero=r['model_requests']==0)
        if expected:
            checks['full_validation_passed']=r['status']=='PASS' and r['formal']==r['mapped_formal']==r['ppa']=='PASS' and r['electrical']['status']=='PASS'
            # Versioned guarded Slang flow differs from the earlier direct
            # elaboration flow; do not silently substitute its0.97ns baseline.
            checks['expected_delay']=r.get('max_data_arrival_ns')==(0.98 if label=='original' else 1.29)
        else:
            checks['expected_rejection_stage']=r['stage']==stage
            checks['not_validated_as_correct']=r.get('formal')!='PASS'
            checks['no_ppa_success']=r.get('ppa')!='PASS'
            if label.startswith('wrong_'):
                f=d/'eda/formal.log';text=f.read_text(encoding='utf-8',errors='replace') if f.exists() else ''
                checks['real_counterexample']='model found: FAIL' in text or 'proof did fail' in text
        records.append(dict(case=label,passed=all(checks.values()),checks=checks));print(label+': '+('PASS' if records[-1]['passed'] else 'FAIL'),flush=True)
    result=dict(passed=all(r['passed'] for r in records),new_model_requests=0,cases=records)
    (out/'RESULT.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    return 0 if result['passed'] else 1


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('out',type=Path)
    sys.exit(main(p.parse_args().out))
