"""Post-hoc one-action development after the N24 old-pool zero-gain finding."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from pathlib import Path
import shutil
import sys
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from agents.action_loop import evaluate,sha,load,save,E
from rewrite.comparator_selector_rewrites import factor_selector

def main():
    parent=E/'action_selection_N24_20261103_010227_993541'
    other=E/'comparator_action_study_20261103_004742_635275'
    s=E/datetime.now().strftime('selector_factoring_development_%Y%m%d_%H%M%S_%f');s.mkdir()
    for name in ['inputs','code_snapshot']:(s/name).mkdir()
    shutil.copyfile(parent/'inputs/original.v',s/'inputs/original.v');shutil.copyfile(parent/'inputs/LICENSE',s/'inputs/LICENSE')
    (s/'candidate.v').write_text(factor_selector((s/'inputs/original.v').read_text(encoding='utf-8')),encoding='utf-8')
    profiles=[dict(N=24,role='primary development case',baseline=str(parent/'baseline')),
              dict(N=1,role='boundary',baseline=str(other/'boundary_N1/baseline')),
              dict(N=13,role='secondary width',baseline=str(other/'boundary_N13/baseline')),
              dict(N=32,role='secondary width',baseline=str(other/'primary_N32/baseline'))]
    # Direct Boolean check of all flag combinations realizable by comparisons.
    count=0
    for equal,greater in [(0,0),(0,1),(1,0)]:
        for sel in range(8):
            original=[0,1,equal,1-equal,equal|greater,1-greater,(1-equal)&(1-greater),greater][sel]
            b0,b1,b2=sel&1,(sel>>1)&1,(sel>>2)&1
            factored=(b1^(equal|(greater^b0))) if b2 else b0^(b1&equal)
            assert factored==original;count+=1
    deps=[Path(__file__).resolve(),ROOT/'rewrite/comparator_selector_rewrites.py',ROOT/'rewrite/comparator_rewrites.py',ROOT/'agents/action_loop.py',E/'run_native_comb.py',E/'trace_sta_rtl_cone.py']
    for f in deps:shutil.copyfile(f,s/'code_snapshot'/f.name)
    p=dict(client_date='2026-11-03',scope='One additional hand-designed action after inspecting old six-action N24 results. Not a predeclared LLM arm or independent method validation.',
           primary_width=24,profiles=profiles,source_sha256=sha(s/'inputs/original.v'),candidate_sha256=sha(s/'candidate.v'),
           code_sha256={str(f.relative_to(ROOT)):sha(f) for f in deps},
           baseline_artifact_sha256={str(Path(x['baseline'])/n):sha(Path(x['baseline'])/n) for x in profiles for n in ['protocol.json','result.json','mapped.v','sta.log']},
           area_ratio_limit=1.10,model_requests=0,source_versions=1,planned_candidate_evaluations=4,truth_table_checks=count,
           limitations='Original defined-binary-input comparator contract. Not equivalence for SEL containing X/Z. Only N1/13/24/32 measured. Standard Boolean factoring, no new-algorithm claim.',
           policy='Single candidate source frozen before all four candidate measurements. Original comparisons, ports, source parameters and no-latency behavior preserved. Old six-action results and catalog unchanged.')
    save(s/'protocol.json',p);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    def run(profile):
        baseline=load(Path(profile['baseline'])/'result.json');bp=load(Path(profile['baseline'])/'protocol.json')
        assert bp['candidate_sha256']==bp['reference_sha256']==p['source_sha256'] and bp['parameter_overrides']=={'N':profile['N']}
        m=evaluate(s/'candidate.v',s/f"N{profile['N']}",s/'inputs/original.v',profile['N'])
        ok=bool(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=baseline['mapped_area_um2']*1.10 and m['max_data_arrival_ns']<baseline['max_data_arrival_ns']-1e-9)
        row=dict(**profile,baseline_metrics=baseline,metrics=m,strict_improvement=ok)
        print(profile['N'],m.get('status'),m.get('max_data_arrival_ns'),m.get('mapped_area_um2'),ok,flush=True);return row
    with ThreadPoolExecutor(max_workers=2) as pool:rows=list(pool.map(run,profiles))
    assert all(sha(Path(path))==h for path,h in p['baseline_artifact_sha256'].items())
    save(s/'SUMMARY.json',dict(status='COMPLETED',model_requests=0,results=rows,old_artifacts_unchanged=True));print('Experiment: '+str(s))
if __name__=='__main__':main()
