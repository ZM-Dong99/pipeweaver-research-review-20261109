"""End-to-end acceptance for the four-instance version2 local entry point."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def crc_outputs_checked(folder):
    evaluation=folder/'evaluations/sampled_no_sta'
    ports=load(evaluation/'after_opt.json')['modules']['crc32_d8']['ports']
    miter=(evaluation/'eda/miter.v').read_text(encoding='utf-8')
    for name,width in (('data_out',8),('state_out',32)):
        if ports[name]['direction']!='output' or len(ports[name]['bits'])!=width:return False
        match=re.search(r'\.'+name+r'\(gold_(\d+)\)',miter)
        if not match:return False
        index=match[1]
        if f'(gold_{index} != cand_{index})' not in miter:return False
        if not re.search(rf'wire\s+\[{width-1}:0\]\s+gold_{index},\s*cand_{index}\s*;',miter):return False
    return True


def main(out):
    out=out.resolve();out.mkdir(parents=True,exist_ok=False)
    bank=ROOT/'benchmark/verified_portfolio_v2_20261107'
    crc=ROOT/'eda/experiments/crc_feedback_20_20261107_ready'
    cases=[('priority_default','priority256',1.1,None,'sampled_no_sta',1.43),
       ('mux_default','mux10x8',1.1,None,'sampled_no_sta',0.73),
       ('alu_default','alu64',1.1,None,'sampled_no_sta',1.83),
       ('crc_default','crc32_d8',1.1,None,'sampled_no_sta',0.84),
       ('mux_no_area_growth','mux10x8',1.0,None,'sampled_sta',0.77),
       ('crc_data_error_rejected','crc32_d8',1.1,crc/'trials/call_05/candidate.v','baseline',0.98),
       ('crc_equal_fallback','crc32_d8',1.1,bank/'crc32_d8/original.v','baseline',0.98),
       ('crc_conditional_x_rejected','crc32_d8',1.1,ROOT/'eda/experiments/crc_conditional_undefined_guard_20261107/candidate.v','baseline',0.98)]
    env=os.environ.copy()
    for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
    records=[]
    for label,design,area,manual,expected,delay in cases:
        folder=out/label;cmd=[sys.executable,'-B','-m','agents.verified_optimizer','run','--design',design,'--area-limit',str(area),'--out',str(folder)]
        if manual:cmd+=['--candidate-rtl',str(manual)]
        print('V2 acceptance '+label,flush=True)
        p=subprocess.run(cmd,cwd=ROOT,env=env,capture_output=True,timeout=3600)
        (out/(label+'_runner.log')).write_bytes(p.stdout+p.stderr)
        if not (folder/'SUMMARY.json').exists():raise RuntimeError('Missing summary '+label)
        s=load(folder/'SUMMARY.json');m=s.get('best_metrics',{})
        checks=dict(exit_ok=p.returncode==0,complete=s.get('status')=='COMPLETE',model_requests_zero=s.get('model_requests')==0,
             expected_choice=s.get('selected')==expected,expected_delay=m.get('max_data_arrival_ns')==delay,
             full_best_proof=m.get('formal')==m.get('mapped_formal')==m.get('ppa')=='PASS',best_electrical=m.get('electrical',{}).get('status')=='PASS',
             backend=s.get('backend')==('crc_slang_fixed' if design=='crc32_d8' else 'native_comb'),dependencies_stable=s.get('dependencies_unchanged') is True)
        selected=next((r for r in s.get('candidates',[]) if r['id']==expected),None)
        checks['export_exact_source']=selected is not None and (folder/'best.v').read_bytes()==(folder/selected['source']).read_bytes()
        if label=='crc_default':
            control=next(r for r in s['candidates'] if r['id']=='bitserial_control')
            checks['slow_area_reference_not_timing_win']=not control['accepted'] and 'no_strict_timing_gain' in control['reasons']
            checks['area_tradeoff_retained']='bitserial_control' in s['pareto']
            checks['both_crc_outputs']=crc_outputs_checked(folder)
        if label=='mux_no_area_growth':
            fast=next(r for r in s['candidates'] if r['id']=='sampled_no_sta')
            checks['fast_but_large_rejected']=not fast['accepted'] and 'area_limit' in fast['reasons']
        if label=='crc_data_error_rejected':
            row=next(r for r in s['candidates'] if r['id']=='manual_01');log=(folder/'evaluations/manual_01/eda/formal.log').read_text(encoding='utf-8',errors='replace')
            checks['real_counterexample_rejected']=not row['accepted'] and ('model found: FAIL' in log or 'proof did fail' in log)
            checks['baseline_preserved']=s['baseline_retained']
        if label=='crc_equal_fallback':
            row=next(r for r in s['candidates'] if r['id']=='manual_01')
            checks['equal_not_improvement']=not row['accepted'] and 'no_strict_timing_gain' in row['reasons'] and row['shared_evaluation']=='baseline' and s['unique_evaluations']==1
        if label=='crc_conditional_x_rejected':
            row=next(r for r in s['candidates'] if r['id']=='manual_01')
            checks['unknown_output_rejected_before_proof']=not row['accepted'] and row['metrics'].get('stage')=='structural_guard' and row['metrics'].get('formal')!='PASS'
        records.append(dict(case=label,passed=all(checks.values()),checks=checks,selected=s.get('selected'),delay_ns=m.get('max_data_arrival_ns'),
            area_um2=m.get('mapped_area_um2'),unique_evaluations=s.get('unique_evaluations')))
        print(label+': '+('PASS' if records[-1]['passed'] else 'FAIL'),flush=True)
        (out/'PROGRESS.json').write_text(json.dumps(records,indent=2),encoding='utf-8')
    report=dict(passed=all(r['passed'] for r in records),new_model_requests=0,portfolio_runs=len(records),unique_evaluation_tasks=sum(r['unique_evaluations'] for r in records),
        evaluation_scope='Includes source counterexample and early structural rejection, not all full PPA completions',cases=records)
    (out/'RESULT.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    return 0 if report['passed'] else 1


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('out',type=Path);sys.exit(main(ap.parse_args().out))
