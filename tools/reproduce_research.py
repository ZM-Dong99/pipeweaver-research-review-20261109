"""One-command offline verification and fresh EDA replay of saved research RTL."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from agents.portfolio_loop import load, save, sha
from eda.experiments.run_systematic_study import evaluate, prepare, qualify, verify_protocol

DEFAULT_STUDY=ROOT/'eda/experiments/systematic_engineering_20261116_v3'


def compare(actual,expected):
    keys=('status','formal','mapped_formal','ppa','eligible','mapped_area_um2','max_data_arrival_ns','wns_ns','tns_ns')
    return {key:actual.get(key)==expected.get(key) for key in keys if key in expected}


def verify(study):
    protocol=load(study/'protocol.json')
    errors=[]
    checks=0
    if sha(study/'protocol.json')!=(study/'protocol.sha256').read_text().strip():
        errors.append('Systematic protocol checksum')
    for name,digest in protocol['source_dependencies'].items():
        path=ROOT/Path(name.replace('\\','/'))
        checks+=1
        if not path.is_file() or sha(path)!=digest:
            errors.append('Evaluator dependency '+name)
    for case in protocol['cases']:
        path=study/case['input']
        checks+=1
        if not path.is_file() or sha(path)!=case['source_sha256']:
            errors.append('Systematic input '+case['id'])
    for path in (study/'calls').glob('request_*/RESULT.json'):
        row=load(path)
        if row.get('rtl_sha256'):
            checks+=1
            if sha(path.parent/'candidate.v')!=row['rtl_sha256']:
                errors.append(str(path.relative_to(study))+' candidate hash')
        if row.get('accepted'):
            folder=path.parent/'evaluation'
            if row.get('shared_evaluation'):
                request=Path(row['evaluation'].replace('\\','/')).parent.name
                folder=study/'calls'/request/'evaluation'
            if not folder.exists():
                errors.append(str(path.relative_to(study))+' missing evaluation')
                continue
            for name in ('formal.log','mapped_formal.log'):
                log=folder/name
                checks+=1
                if not log.is_file() or 'SUCCESS!' not in log.read_text(encoding='utf-8',errors='replace'):
                    errors.append(str(path.relative_to(study))+' proof log '+name)
    summary=study/'ENGINEERING_RESULTS.json'
    if summary.is_file():
        from eda.experiments.summarize_systematic_study import summarize
        checks+=1
        if summarize(study)!=load(summary):
            errors.append('Engineering summary differs from raw-record recomputation')
    audit=study/'audits/definedness/RESULT.json'
    if audit.is_file():
        checks+=1
        result=load(audit)
        sequential_cases={case['id'] for case in protocol['cases'] if case['backend']=='sequential'}
        accepted_requests={path.parent.name for path in (study/'calls').glob('request_*/RESULT.json')
                           if load(path).get('accepted') and load(path)['case'] in sequential_cases}
        if (not result.get('passed') or {row['request'] for row in result['records']}!=accepted_requests
                or not all(row['expected']==row['actual'] for row in result['controls'])):
            errors.append('Accepted-candidate definedness audit incomplete')
    archive=ROOT if (ROOT/'MANIFEST.json').is_file() else ROOT/'output/teacher_review_20261109'
    parameter=ROOT/'eda/experiments/systematic_parameter_20261117'
    parameter_result=None
    if (parameter/'ANALYSIS.json').is_file():
        from eda.experiments.analyze_parameter_study import summarize as summarize_parameters
        recomputed=summarize_parameters(parameter)
        parameter_result=dict(attempted=recomputed['attempted'],improvements=recomputed['improvements'],
                              combined_saved_response_ids=recomputed['combined_saved_response_ids'])
        if recomputed!=load(parameter/'ANALYSIS.json'):
            errors.append('Parameter analysis differs from raw-record recomputation')
    archive_result=None
    if (archive/'tools/verify.py').is_file():
        result=subprocess.run([sys.executable,'-B',str(archive/'tools/verify.py')],
                              cwd=archive,capture_output=True,text=True,encoding='utf-8')
        archive_result=json.loads(result.stdout)
        if result.returncode or not archive_result.get('passed'):
            errors.append('Historical archive verification failed')
    return dict(passed=not errors,systematic_cases=len(protocol['cases']),candidate_hashes_checked=checks,
                historical_archive=archive_result,parameter_study=parameter_result,failures=errors,model_requests=0)


def systematic_replay(study,out,include_candidates,limit,selected_cases=None,check_definedness=False):
    protocol=verify_protocol(study)
    out.mkdir(parents=True,exist_ok=False)
    results=[]
    cases={case['id']:case for case in protocol['cases']}
    selected_cases=set(selected_cases or (case['id'] for case in protocol['cases']))
    unknown=selected_cases-set(cases)
    if unknown:
        raise ValueError('Unknown circuit cases '+repr(sorted(unknown)))
    for case in protocol['cases']:
        if case['id'] not in selected_cases:
            continue
        reference=study/case['input']
        metrics=evaluate(reference,reference,case,out/'baselines'/case['id'])
        expected_path=study/'baselines'/case['id']/'result.json'
        expected=load(expected_path) if expected_path.is_file() else {}
        results.append(dict(case=case['id'],kind='baseline',comparisons=compare(metrics,expected),metrics=metrics))
    if include_candidates:
        cache={}
        rows=sorted((study/'calls').glob('request_*/RESULT.json'))
        selected=[path for path in rows if (path.parent/'candidate.v').is_file()
                  and load(path)['case'] in selected_cases]
        for path in selected[:limit or None]:
            row=load(path)
            case=cases[row['case']]
            source=path.parent/'candidate.v'
            key=(case['id'],sha(source))
            if key not in cache:
                evaluation=out/'candidates'/path.parent.name
                metrics=evaluate(source,study/case['input'],case,evaluation)
                if check_definedness:
                    from eda.experiments.run_systematic_study import eligible
                    from eda.experiments.check_multicircuit_definedness import prove as prove_defined
                    if eligible(case,metrics):
                        try:
                            proof_source=source
                            schema=evaluation/'candidate_schema.json'
                            parameters=case['parameters']
                            if case['backend']=='crc_slang':
                                proof_source=evaluation/'candidate/elaborated.v'
                                schema=evaluation/'candidate/source.json'
                                parameters={}
                            ports=load(schema)['modules'][case['top']]['ports']
                            defined=prove_defined(proof_source,case['top'],parameters,ports,
                                                  out/'definedness'/path.parent.name)
                            if not defined['passed']:
                                metrics=dict(metrics,eligible=False,stage='definedness')
                        except Exception as error:
                            metrics=dict(status='INCOMPLETE',stage='evaluator',error_type=type(error).__name__)
                cache[key]=metrics
            metrics=cache[key]
            results.append(dict(case=case['id'],kind='candidate',request=path.parent.name,
                comparisons=compare(metrics,row['metrics']),metrics=metrics))
    report=dict(passed=all(all(row['comparisons'].values()) for row in results),
                model_requests=0,results=results,
                scope='Fresh local EDA of frozen RTL; tool/environment differences can alter metrics. Failed or incomplete baselines remain visible.')
    save(out/'REPRODUCTION.json',report)
    return report


def recent_replay(out,limit):
    from eda.experiments.run_multicircuit_feedback_144 import evaluate as evaluate_recent
    out.mkdir(parents=True,exist_ok=False)
    results=[]
    attempted=0
    studies=('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready',
             'multicircuit_feedback_144_20261109')
    for name in studies:
        study=ROOT/'eda/experiments'/name
        protocol=load(study/'protocol.json')
        cases=protocol.get('cases',[dict(id='crc32_d8',top='crc32_d8',params={})])
        cases={case['id']:case for case in cases}
        for row in load(study/'RESULT.json')['trials']:
            if row['status']!='GENERATED':
                results.append(dict(study=name,index=row['index'],kind='saved_generation_failure',
                                    automatic_generation_retry=False))
                continue
            if limit and attempted>=limit:
                break
            case=cases[row.get('case','crc32_d8')]
            source=study/'trials'/f'call_{row["index"]:03d}'/'candidate.v'
            reference=study/'inputs'/(case['id']+'.v')
            if not reference.is_file():
                reference=study/'inputs/original.v'
            metrics=evaluate_recent(source,case,out/name/f'call_{row["index"]:03d}',reference)
            results.append(dict(study=name,index=row['index'],kind='candidate',
                                comparisons=compare(metrics,row['metrics']),metrics=metrics))
            attempted+=1
        if limit and attempted>=limit:
            break
    report=dict(passed=all(all(row.get('comparisons',{}).values()) for row in results),
                evaluated_candidates=attempted,model_requests=0,results=results)
    save(out/'REPRODUCTION.json',report)
    return report


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode',choices=('verify','baselines','systematic','parameter','recent','all'))
    parser.add_argument('--study',type=Path)
    parser.add_argument('--out',type=Path)
    parser.add_argument('--limit',type=int,default=0,help='Optional candidate limit; zero replays all saved candidates')
    parser.add_argument('--case',action='append',default=[],help='Restrict systematic replay to a case ID; repeatable')
    args=parser.parse_args()
    if args.limit<0:
        parser.error('Limit must be nonnegative')
    default_study=ROOT/'eda/experiments/systematic_parameter_20261117' if args.mode=='parameter' else DEFAULT_STUDY
    study=(args.study or default_study).resolve()
    if args.mode=='verify':
        result=verify(study)
    else:
        if not args.out:
            parser.error('Fresh output directory is required for EDA reproduction')
        out=args.out.resolve()
        if args.mode=='baselines':
            prepare(out)
            result=qualify(out,[],2)
        elif args.mode in ('systematic','parameter'):
            result=systematic_replay(study,out,True,args.limit,args.case,args.mode=='parameter')
        elif args.mode=='recent':
            result=recent_replay(out,args.limit)
        else:
            out.mkdir(parents=True,exist_ok=False)
            result=dict(verification=verify(study),
                        systematic=systematic_replay(study,out/'systematic',True,args.limit,args.case),
                        recent=recent_replay(out/'recent',args.limit))
            result['passed']=all(section['passed'] for section in result.values())
            save(out/'ALL_REPRODUCTION.json',result)
    print(json.dumps(result,ensure_ascii=False,indent=2))
    if result.get('passed') is False:
        raise SystemExit(1)


if __name__=='__main__':
    main()
