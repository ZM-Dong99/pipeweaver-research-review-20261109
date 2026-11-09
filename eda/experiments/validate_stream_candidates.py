"""Real candidate-path acceptance with manual RTL, not synthetic model evidence."""
import argparse
import json
from pathlib import Path
import re
import shutil
from run_stream_feedback import validate,evaluate,eligible,choose,sha,save,load,ROOT,DEPS


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('batch',type=Path);ap.add_argument('--out',required=True,type=Path);a=ap.parse_args()
    batch=a.batch.resolve();p=validate(batch);out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
    fixtures=out/'fixtures';fixtures.mkdir();cases={c['id']:c for c in p['cases']}
    adapter=(batch/'inputs'/cases['adapter']['source']).read_text(encoding='utf-8')
    skid=(batch/'inputs'/cases['skid']['source']).read_text(encoding='utf-8')
    invalid,n=re.subn(r'(assign\s+m_axis_tdata\s*=\s*)([^;]+);',lambda m:m[1]+'m_axis_tvalid ? ('+m[2]+") : {M_DATA_WIDTH{1'b1}};",adapter)
    if not n:raise RuntimeError('No invalid-output mutation')
    initial=adapter.replace("m_axis_tdata_reg = {M_DATA_WIDTH{1'b0}};","m_axis_tdata_reg = {M_DATA_WIDTH{1'b1}};")
    boolean=skid.replace('m_axis_tready || (!temp_m_axis_tvalid_reg && (!m_axis_tvalid_reg || !s_axis_tvalid))',
                         'm_axis_tready || !(temp_m_axis_tvalid_reg || (m_axis_tvalid_reg && s_axis_tvalid))')
    bad_data,n=re.subn(r'(assign\s+m_axis_tdata\s*=\s*)([^;]+);',lambda m:m[1]+'('+m[2]+") ^ {{(M_DATA_WIDTH-1){1'b0}},1'b1};",adapter)
    bad_ready,n2=re.subn(r'(assign\s+s_axis_tready\s*=\s*)([^;]+);',lambda m:m[1]+'~('+m[2]+');',skid)
    hidden=adapter.replace('m_axis_tid_reg <= s_axis_tvalid_reg ? s_axis_tid_reg : s_axis_tid;',"m_axis_tid_reg <= (s_axis_tvalid_reg ? s_axis_tid_reg : s_axis_tid) ^ 8'h1;")
    if not n or not n2 or initial==adapter or boolean==skid:raise RuntimeError('Missing mutation targets')
    jobs=[('invalid_data_allowed','adapter',invalid,'PASS'),('different_declared_init','adapter',initial,'PASS'),
          ('boolean_rewrite','skid',boolean,'PASS'),('wrong_valid_data','adapter',bad_data,'FORMAL_FAIL'),('wrong_ready','skid',bad_ready,'FORMAL_FAIL')]
    if hidden==adapter:raise RuntimeError('Missing disabled-sideband mutation')
    jobs.append(('unobserved_internal_state','adapter',hidden,'PASS_OR_INCOMPLETE'))
    records=[]
    for name,kind,text,expected in jobs:
        f=fixtures/(name+'.v');f.write_text(text,encoding='utf-8');records.append(dict(id=name,case=kind,candidate=str(f),candidate_sha256=sha(f),expected=expected))
    snap=out/'code_snapshot';snap.mkdir()
    for f in [Path(__file__),*DEPS]:shutil.copyfile(f,snap/f.name)
    protocol=dict(batch_protocol_sha256=sha(batch/'protocol.json'),jobs=records,model_requests=0,scope='Manual real RTL acceptance of arbitrary-candidate entry, not model samples or method gains',
                  dependencies={str(f.resolve().relative_to(ROOT)):sha(f) for f in [Path(__file__),*DEPS]})
    save(out/'protocol.json',protocol);(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    results=[]
    for job in records:
        validate(batch)
        for rel,h in protocol['dependencies'].items():
            if sha(ROOT/rel)!=h:raise RuntimeError('Frozen validation code changed')
        case=cases[job['case']];candidate=Path(job['candidate'])
        if sha(candidate)!=job['candidate_sha256']:raise RuntimeError('Manual candidate changed')
        m=evaluate(candidate,batch/'inputs'/case['source'],case,out/job['id'])
        actual='PASS' if eligible(m) else 'FORMAL_FAIL' if m.get('formal')=='FAIL' else 'INCOMPLETE'
        results.append(dict(id=job['id'],expected=job['expected'],actual=actual,matched=(actual in ('PASS','INCOMPLETE') if job['expected']=='PASS_OR_INCOMPLETE' else actual==job['expected']),result=m,decision=choose(m,case['baseline'])))
        save(out/'SUMMARY.json',dict(results=results,passed=all(r['matched'] for r in results),model_requests=0))
        print(job['id']+': '+actual+' expected='+job['expected'],flush=True)
    return 0 if all(r['matched'] for r in results) else 1


if __name__=='__main__':raise SystemExit(main())
