"""Freeze the completed FCS group and verified facts for a text-only midterm."""
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'docs/midterm_20261108'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    exp=ROOT/'eda/experiments'
    checks={}
    for name in ('fcs_reset_complete_20261107_induction_fixed','fcs_reset_cts_pdn_20261107',
                 'fcs_filled_layout_20261108','fcs_filled_independent_layout_20261108','fcs_bulk_profile_20261108'):
        folder=exp/name
        manifest=load(folder/'ARTIFACTS.json')
        checks[name+':frozen_artifacts']=all(sha(folder/p)==digest for p,digest in manifest.items())
    bulk=load(exp/'fcs_bulk_profile_20261108/SUMMARY.json')
    reset=load(exp/'fcs_reset_complete_20261107_induction_fixed/SUMMARY.json')
    filled=load(exp/'fcs_filled_layout_20261108/PRESERVATION.json')
    timing=load(exp/'fcs_filled_layout_20261108/REEXTRACTION.json')
    drc=load(exp/'fcs_filled_independent_layout_20261108/RESULT.json')
    checks['fcs_reset_complete']=reset['status']=='PASS_RESET_ONLY_AND_PHYSICAL' and reset['initial_state_assumptions'] is False
    checks['fcs_named_lvs_qualified']=bulk['status']=='QUALIFIED_ORDINARY_BULK_LVS_PROFILE' and bulk['baseline_lvs']==bulk['optimized_lvs']=='PASS'
    checks['fcs_default_failure_retained']=bulk['unmodified_orfs_default_lvs_passed'] is False
    checks['fcs_no_foundry_signoff_claim']=bulk['full_foundry_signoff'] is False
    checks['fcs_fresh_filled_timing']=timing['passed']
    checks['fcs_filler_preserved_routes']=filled['passed']
    checks['fcs_both_drc_zero']=all(drc['cases'][c]['drc']['status']=='PASS' and drc['cases'][c]['drc']['violation_items']==0 for c in ('baseline','optimized'))
    eighty=exp/'expanded_feedback_80_20261107'
    crc=exp/'crc_feedback_20_20261107_ready'
    a,b=load(eighty/'RESULT.json'),load(crc/'RESULT.json')
    ba,bb=load(eighty/'BUDGET_STATUS.json'),load(crc/'BUDGET_STATUS.json')
    counts=load(eighty/'OUTCOME_CLASSIFICATION.json')['counts']
    checks['eighty_complete']=a['complete'] and a['attempted']==80 and load(eighty/'AUDIT.json')['passed']
    checks['crc_complete']=b['complete'] and b['attempted']==20 and load(crc/'AUDIT.json')['passed']
    checks['recent_budgets_exhausted']=ba['remaining']==bb['remaining']==0
    checks['eighty_classification']=counts==dict(qualified_improvement=55,area_exceeds_cap=11,electrical_violation=6,generation_transport_failure=8)
    checks['crc_correct_errors']=bb['qualified_improvements']==16 and bb['confirmed_functional_errors']==4
    checks['eighty_and_crc_reproductions']=load(eighty/'REPRODUCTION.json')['passed'] and load(crc/'REPRODUCTION.json')['passed']
    checks['offline_entry_acceptance']=load(exp/'verified_optimizer_acceptance_20261107/REAUDIT.json')['passed']
    checks['closeout_new_model_calls_zero']=bulk['new_model_calls']==0
    replay=load(ROOT/'output/fcs_closeout_reproduction_20261108/result.json')
    prior=load(exp/'fcs_reset_complete_20261107_induction_fixed/optimized/evaluation/result.json')
    replay_comparisons={k:replay.get(k)==prior.get(k) for k in ('status','formal','mapped_formal','ppa','electrical',
         'mapped_area_um2','mapped_cells','wns_ns','tns_ns','mapped_sha256','sdc_sha256')}
    checks['actual_export_reproduction_passed']=replay['status']=='PASS' and all(replay_comparisons.values())
    recent=dict(scope='Only the latest 80-request and 20-request experiments; NOT whole-project total',
        attempted=a['attempted']+b['attempted'],returned=ba['generated']+bb['generated'],
        qualified_improvements=counts['qualified_improvement']+bb['qualified_improvements'],
        source_functional_errors=bb['confirmed_functional_errors'],area_cap_rejections=counts['area_exceeds_cap'],
        electrical_rejections=counts['electrical_violation'],transport_failures=counts['generation_transport_failure'],
        reported_response_total_tokens=load(eighty/'AUDIT.json')['reported_total_tokens']+load(crc/'AUDIT.json')['reported_total_tokens'],
        statistical_scope='Heterogeneous fixed instances, descriptive counts only, no pooled generalization or significance claim')
    checks['recent_counts_partition']=sum(recent[k] for k in ('qualified_improvements','source_functional_errors','area_cap_rejections','electrical_rejections','transport_failures'))==recent['attempted']==100
    best=load(eighty/'BEST_OBSERVED.json')['choices']
    cases=[]
    for case in best:
        p=eighty/case['export']
        checks['best_export:'+case['case']]=sha(p)==case['rtl_sha256']
        cases.append({k:case[k] for k in ('case','arm','original_lines','candidate_lines','baseline_delay_ns','delay_ns','delay_reduction_pct','area_change_pct')})
    primary=[]
    for r in a['groups']:
        primary.append({k:r[k] for k in ('case','arm','scheduled','generated','improvements','median_retained_delay_ns')})
    fcs={}
    for case in ('baseline','optimized'):
        fcs[case]=dict(setup_wns_ns=timing['cases'][case]['setup']['wns_ns'],
            hold_wns_ns=timing['cases'][case]['hold']['wns_ns'],
            nonfiller_area_um2=filled['cases'][case]['nonfiller_cell_area_um2'],
            total_occupied_area_um2=filled['cases'][case]['total_occupied_cell_area_um2'],
            drc=drc['cases'][case]['drc']['status'],named_lvs=bulk[case+'_lvs'])
    source_files=[
      'eda/experiments/controlled_rtl_study_20261029_002533_787332/INTERPRETATION.md',
      'README_NATIVE_MUL_STUDY.md','eda/experiments/ALU_FEEDBACK_REPLICATION_20261030.md',
      'eda/experiments/timing_feedback_ablation_addr_calcu_20261030_230123_131837/FINAL_INTERPRETATION.md',
      'eda/experiments/seq_feedback_arbiter32_20261102_212936_005046/FINAL_INTERPRETATION.md',
      'eda/experiments/ticket_feedback_study_20261102_234633_156134/INTERPRETATION.md',
      'eda/experiments/ticket_risk_feedback_20261103_001930_680040/INTERPRETATION.md',
      'eda/experiments/stream_feedback_ready_20261106/RESULT_SUMMARY.md',
      'eda/experiments/expanded_feedback_80_20261107/INTERPRETATION.md',
      'eda/experiments/crc_feedback_20_20261107_ready/INTERPRETATION.md',
      'eda/experiments/rtlrewriter_feasibility_20261107/ASSESSMENT.md',
      'README_VERIFIED_OPTIMIZER.md','MODELS_AND_CIRCUITS_20261106.md',
      'eda/experiments/fcs_bulk_profile_20261108/INTERPRETATION.md',
      'eda/experiments/fcs_reset_complete_20261107_induction_fixed/INTERPRETATION.md']
    evidence=[]
    for name in source_files:
        p=ROOT/name
        checks['source_exists:'+name]=p.is_file()
        if p.is_file():
            evidence.append(dict(path=name,sha256=sha(p)))
    report=dict(date='2026-11-08',recent_two_batches=recent,primary_80=primary,
       best_80=cases,crc_groups=b['groups'],fcs=fcs,evidence=evidence,
       project_request_total='NOT_UNIFORMLY_DEDUPLICATED_DO_NOT_INFER',
       actual_export_reproduction=dict(path='output/fcs_closeout_reproduction_20261108/result.json',comparisons=replay_comparisons,
            scope='Actual delivered exports re-proved, re-mapped and timed; not a full physical rerun'),new_model_calls_for_closeout=0)
    (OUT/'EVIDENCE_INDEX.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    closure=dict(passed=all(checks.values()),checks=checks,check_count=len(checks),
       group_status='COMPLETE_WITH_DECLARED_ORDINARY_BULK_RESEARCH_SCOPE',
       whole_project_complete=False,full_foundry_signoff=False,new_model_calls=0)
    (OUT/'CLOSEOUT_CHECK.json').write_text(json.dumps(closure,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    if not closure['passed']:
        raise RuntimeError('Checks failed: '+str([k for k,v in checks.items() if not v]))
    print(json.dumps(dict(passed=True,checks=len(checks),recent_attempts=recent['attempted'],recent_qualified=recent['qualified_improvements'],new_model_calls=0)))


if __name__=='__main__':
    main()
