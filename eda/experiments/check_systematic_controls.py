"""Actual EDA negative controls for fixed pipeline latency and FSM outputs."""
import argparse
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.portfolio_loop import save
from eda.experiments.run_systematic_study import evaluate, verify_protocol


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--study',type=Path,required=True)
    args=parser.parse_args()
    study=args.study.resolve()
    protocol=verify_protocol(study)
    cases={case['id']:case for case in protocol['cases']}
    out=study/'negative_controls'
    out.mkdir(exist_ok=False)
    controls=[
        ('pipeline_wrong_latency','pipeline_alu32_s3',
         'assign result = stage_data[STAGES-2];','assign result = stage_data[0];'),
        ('pipeline_wrong_payload','pipeline_alu16_s2',
         'assign result = stage_data[STAGES-2];',"assign result = stage_data[STAGES-2] ^ 1'b1;"),
        ('fsm_wrong_done','fsm9_sync',
         "S_DONE:  {data_out, done} = {data_in, 1'b1};","S_DONE:  {data_out, done} = {data_in, 1'b0};"),
    ]
    results=[]
    for name,case_id,original,replacement in controls:
        case=cases[case_id]
        reference=study/case['input']
        text=reference.read_text(encoding='utf-8-sig')
        if text.count(original)!=1:
            raise ValueError('Negative control location changed')
        source=out/(name+'.v')
        source.write_text(text.replace(original,replacement),encoding='utf-8')
        metrics=evaluate(source,reference,case,out/name)
        rejected_by_actual_counterexample=metrics.get('formal')=='FAIL'
        results.append(dict(control=name,case=case_id,passed=rejected_by_actual_counterexample,metrics=metrics))
        print(name+' '+str(rejected_by_actual_counterexample),flush=True)
    report=dict(passed=all(row['passed'] for row in results),checks=results,model_requests=0)
    save(out/'RESULT.json',report)
    return 0 if report['passed'] else 1


if __name__=='__main__':
    raise SystemExit(main())
