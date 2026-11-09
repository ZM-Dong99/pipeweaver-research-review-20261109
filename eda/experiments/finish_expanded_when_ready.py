"""Follow one authorized collection job into local EDA/audit/export. No API calls."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]


def main(out):
    out=out.resolve()
    if ROOT not in out.parents:raise RuntimeError('Experiment must be inside workspace')
    marker=out/'LOCAL_FINISH_STARTED.json'
    with marker.open('x',encoding='utf-8') as f:
        json.dump(dict(pid=os.getpid(),script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),api_requests=0),f)
    last=None
    while True:
        completed=list(out.glob('trials/call_*/generation.json'))
        if len(completed)!=last:
            print(f'Generation records: {len(completed)}/80',flush=True);last=len(completed)
        summary=out/'GENERATION_SUMMARY.json'
        if summary.exists():
            try:
                data=json.loads(summary.read_text(encoding='utf-8'))
            except (ValueError,OSError):
                time.sleep(1);continue
            if len(data.get('records',[]))==len(completed):break
        time.sleep(5)
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    steps=[('score',['run_expanded_feedback.py','score',str(out)]),
           ('audit',['audit_expanded_feedback.py',str(out)]),
           ('finalize',['finalize_expanded_feedback.py',str(out)])]
    for label,args in steps:
        print('Local stage: '+label,flush=True)
        cmd=[sys.executable,'-B',str(ROOT/'eda/experiments'/args[0]),*args[1:]]
        with (out/f'LOCAL_{label.upper()}.log').open('wb') as log:
            p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT)
        with (out/f'LOCAL_{label.upper()}_STATUS.json').open('x',encoding='utf-8') as f:
            json.dump(dict(exit_code=p.returncode,api_requests=0),f)
        if p.returncode:
            print('Local stage failed; inspect '+str(out/f'LOCAL_{label.upper()}.log'),flush=True)
            return p.returncode
    print('Local verification and report complete: '+str(out/'RESULT_SUMMARY.md'),flush=True)
    return 0


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('out',type=Path)
    sys.exit(main(ap.parse_args().out))
