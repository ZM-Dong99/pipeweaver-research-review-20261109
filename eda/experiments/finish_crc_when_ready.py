"""Continue this authorized CRC generation into local score/audit/export only."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]


def main(out):
    out=out.resolve()
    if ROOT not in out.parents:raise ValueError('Experiment must be in workspace')
    with (out/'LOCAL_FINISH_STARTED.json').open('x',encoding='utf-8') as f:json.dump(dict(pid=os.getpid(),model_requests=0),f)
    last=None
    while True:
        records=list(out.glob('trials/call_*/generation.json'))
        if len(records)!=last:print(f'CRC generation records: {len(records)}/20',flush=True);last=len(records)
        if (out/'GENERATION_SUMMARY.json').exists():
            try:g=json.loads((out/'GENERATION_SUMMARY.json').read_text(encoding='utf-8'))
            except (OSError,ValueError):time.sleep(1);continue
            if len(g.get('records',[]))==len(records):break
        time.sleep(5)
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    for label,args in [('score',['run_crc_feedback.py','score',str(out)]),('audit',['audit_crc_feedback.py',str(out)]),('finalize',['finalize_crc_feedback.py',str(out)])]:
        print('CRC local stage: '+label,flush=True)
        with (out/f'LOCAL_{label.upper()}.log').open('wb') as log:
            p=subprocess.run([sys.executable,'-B',str(ROOT/'eda/experiments'/args[0]),*args[1:]],cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT)
        with (out/f'LOCAL_{label.upper()}_STATUS.json').open('x',encoding='utf-8') as f:json.dump(dict(exit_code=p.returncode,model_requests=0),f)
        if p.returncode:print('CRC local stage failed: '+label,flush=True);return p.returncode
    print('CRC local report complete: '+str(out/'RESULT_SUMMARY.md'),flush=True);return 0


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('out',type=Path);sys.exit(main(p.parse_args().out))
