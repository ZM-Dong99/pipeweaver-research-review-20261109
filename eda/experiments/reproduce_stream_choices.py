"""Independently rerun each case's best retained engineering choice, without model calls."""
import argparse
import json
from pathlib import Path
import shutil
from run_stream_feedback import validate,load,sha,save,evaluate,eligible


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('batch',type=Path);a=ap.parse_args();s=a.batch.resolve()
    p=validate(s);summary=load(s/'summary.json');require_audit=load(s/'AUDIT.json')
    if not require_audit['passed']:raise RuntimeError('Main evidence audit must pass first')
    out=s/'independent_choice_reproduction';out.mkdir(exist_ok=False)
    jobs=[]
    for case in p['cases']:
        rows=[r for r in summary['rows'] if r['slot']['case']==case['id']]
        best=max(rows,key=lambda r:r['decision']['retained_wns_ns'])
        selected=best['decision']['selected']
        source=(s/'trials'/f"call_{best['slot']['call_index']:02d}"/'candidate.v') if selected=='candidate' else s/'inputs'/case['source']
        expected=best['metrics'] if selected=='candidate' else case['baseline']
        jobs.append(dict(case=case,source=str(source),source_sha256=sha(source),selected=selected,
            original_call=best['slot']['call_index'] if selected=='candidate' else None,expected=expected))
    save(out/'protocol.json',dict(batch_protocol_sha256=sha(s/'protocol.json'),jobs=jobs,model_requests=0,
        policy='One independently repeated best retained choice per case, not new model samples or substituted main scores'))
    results=[]
    for job in jobs:
        validate(s);source=Path(job['source'])
        if sha(source)!=job['source_sha256']:raise RuntimeError('Selected source changed')
        case=job['case'];f=out/case['id'];f.mkdir();copy=f/'candidate.v';shutil.copyfile(source,copy)
        m=evaluate(copy,s/'inputs'/case['source'],case,f/'evaluation');expected=job['expected']
        values=('wns_ns','tns_ns','mapped_area_um2','mapped_cells')
        same={k:m.get(k)==expected.get(k) for k in values}
        row=dict(case=case['id'],selected=job['selected'],original_call=job['original_call'],
            passed=eligible(m) and all(same.values()),numeric_matches=same,netlist_sha256_matches=m.get('mapped_sha256')==expected.get('mapped_sha256'),result=m)
        results.append(row);save(s/'REPRODUCTION.json',dict(passed=all(r['passed'] for r in results),results=results,model_requests=0))
        print(case['id']+': reproduction '+str(row['passed']),flush=True)
    return 0 if all(r['passed'] for r in results) else 1


if __name__=='__main__':raise SystemExit(main())
