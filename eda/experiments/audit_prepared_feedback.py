"""Check a frozen, unexecuted no-feedback/STA-feedback protocol; no network."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[2]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path)
    s=ap.parse_args().study.resolve();load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');checks=[]
    def check(name,value):checks.append(dict(check=name,passed=bool(value)))
    check('protocol hash',sha(s/'protocol.json')==(s/'protocol.sha256').read_text().split()[0])
    for rel,h in p['dependency_sha256'].items():
        check('live dependency '+rel,sha(ROOT/rel)==h)
        check('frozen dependency '+rel,sha(s/'code_snapshot'/Path(rel).name)==h)
    check('original input',sha(ROOT/p['baseline_rtl'])==p['baseline_sha256']==sha(s/'baseline/original.v'))
    check('two intended arms',set(p['arms'])=={'no_timing_feedback','actual_paths'})
    schedule=p['call_schedule'];counts=Counter(x['arm'] for x in schedule)
    check('equal budgets',len(schedule)==2*p['candidates_per_arm'] and all(counts[a]==p['candidates_per_arm'] for a in p['arms']))
    check('unique slots',len({(x['arm'],x['candidate_id']) for x in schedule})==len(schedule))
    check('fixed numbered order',[x['call_index'] for x in schedule]==list(range(1,len(schedule)+1)))
    check('no requests or generated candidates',not list(s.rglob('attempt.json')) and not list(s.rglob('generation.json')) and not list(s.rglob('candidate.v')) and not list(s.rglob('request.json')))
    prompts={a:(s/'prompts'/(a+'.txt')).read_text(encoding='utf-8') for a in p['arms']}
    for a,t in prompts.items():check('prompt hash '+a,sha(s/'prompts'/(a+'.txt'))==p['prompt_sha256'][a])
    common=prompts['no_timing_feedback'];guided=prompts['actual_paths']
    check('exact same common prompt',guided.startswith(common))
    check('direct arm no measured timing','Startpoint:' not in common and 'max_data_arrival_ns' not in common and 'Measured baseline timing metrics' not in common)
    check('actual source identical in both',(s/'baseline/original.v').read_text(encoding='utf-8') in common)
    check('exact parameters supplied',json.dumps(p['parameter_overrides'],sort_keys=True) in common)
    check('invalid outputs not masked', 'output_unencoded=1' in common and "Invalid outputs are NOT don't-cares" in common)
    check('no unsupported source attribution','Source-localization evidence' not in guided and 'no exact mapping to RTL source lines' in guided)
    ep=s/'baseline/evaluation/eda';bp=load(ep/'protocol.json');bm=load(ep/'result.json')
    check('same actual baseline',bm==p['baseline_metrics'])
    check('fixed parameter instance',bp['parameter_overrides']==p['parameter_overrides'])
    check('same actual source',bp['reference_sha256']==bp['candidate_sha256']==p['baseline_sha256'])
    check('same mapping',bp['mapping_policy']==p['mapping_policy'] and bp['abc_cleanup_before_buffer']==p['abc_cleanup_before_buffer'])
    check('same library',bp['liberty_sha256']==p['liberty_sha256'])
    check('baseline fully eligible',bm['formal']==bm['mapped_formal']==bm['ppa']=='PASS' and bm['electrical']['status']=='PASS')
    for stage in ['formal','mapped_formal']:
        check('actual '+stage,'SAT proof finished - no model found: SUCCESS!' in (ep/(stage+'.log')).read_text())
    sta=(ep/'sta.log').read_text();top3=(s/'baseline/top3_sta_paths.txt').read_text()
    check('actual top3 paths',top3 in sta and top3.count('Startpoint:')==3)
    check('STA timing exact',float(re.search(r'([-+\d.]+)\s+data arrival time',sta)[1])==bm['max_data_arrival_ns'])
    check('STA evidence hash',sha(ep/'sta.log')==p['baseline_sta_sha256'])
    check('top3 included exactly',top3 in guided)
    module=load(ep/'candidate_schema.json')['modules'][p['top']]
    check('actual width256 ports',len(module['ports']['input_unencoded']['bits'])==256 and len(module['ports']['output_encoded']['bits'])==8 and len(module['ports']['output_unencoded']['bits'])==256)
    report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,
        llm_requests=0,status='PREPARED_NOT_EXECUTED',scope='Protocol and baseline qualification only; no optimization results or statistical claim')
    (s/'PREPARATION_AUDIT.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k!='checks'},ensure_ascii=False))
    return 0 if report['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
