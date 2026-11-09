"""Audit frozen two-arm sequential studies from actual requests, RTL and EDA logs."""
import argparse
import ast
import json
from pathlib import Path
import re
import sys
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from agents.rtl_optimizer import _parse_content
from run_native_comb import digest,parse_electrical_report

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'));p=load(s/'protocol.json');summary=load(s/'summary.json');manifest=load(s/'candidate_manifest.json');checks=[]
    def check(k,v):checks.append(dict(check=k,passed=bool(v)))
    check('protocol linkage',digest(s/'protocol.json')==summary['protocol_sha256']==manifest['protocol_sha256']==(s/'protocol.sha256').read_text().strip())
    check('candidate manifest',digest(s/'candidate_manifest.json')==summary['manifest_sha256'])
    check('complete request slots',len(summary['results'])==len(manifest['slots'])==summary['request_attempts']==p['maximum_requests']==6)
    for rel,h in p['dependency_sha256'].items():check('snapshot '+rel,digest(s/'code_snapshot'/Path(rel).name)==h)
    for name,h in p['input_sha256'].items():check('input '+name,digest(s/'inputs'/name)==h)
    def parser(path):
        return [ast.dump(n,include_attributes=False) for n in ast.parse(path.read_text(encoding='utf-8')).body if isinstance(n,ast.FunctionDef) and n.name in ('_parse_content','_strip_verilog_fence')]
    check('frozen response parser',len(parser(ROOT/'agents/rtl_optimizer.py'))==2 and parser(ROOT/'agents/rtl_optimizer.py')==parser(s/'code_snapshot/rtl_optimizer.py'))
    prompts={a:(s/'prompts'/(a+'.txt')).read_text(encoding='utf-8') for a in p['arms']}
    check('same common prompt',prompts['actual_paths'].startswith(prompts['no_timing_feedback']))
    check('direct excludes measured timing','Startpoint:' not in prompts['no_timing_feedback'] and '"wns_ns"' not in prompts['no_timing_feedback'])
    for a,h in p['prompt_sha256'].items():check('prompt '+a,digest(s/'prompts'/(a+'.txt'))==h)
    base=p['baseline_metrics'];responses=0;tokens=0;contract=p['contract']
    def eda(folder,m,label):
        cp=load(folder/'protocol.json');check(label+' actual result',load(folder/'result.json')==m)
        check(label+' original reference',cp['reference_sha256']==p['input_sha256']['original.v'])
        check(label+' actual candidate hash',digest(Path(cp['candidate']))==cp['candidate_sha256'])
        check(label+' original helper',[x['sha256'] for x in cp['dependencies']]==[p['input_sha256']['priority_encoder.v']])
        check(label+' fixed timing/reset',all(cp[k]==contract[k] for k in ('clock','reset','reset_active','reset_cycles','warmup_samples','period_ns','parameter_overrides')))
        check(label+' same library',cp['liberty_sha256']==p['library_sha256'])
        if m.get('status')=='PASS':
            for stage in ['formal','mapped_formal']:
                text=(folder/(stage+'.log')).read_text();check(label+' '+stage,m[stage]=='PASS' and 'Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            text=(folder/'sta.log').read_text();check(label+' electrical',parse_electrical_report(text)==m['electrical'])
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                found=re.search(pattern,text);check(label+' raw '+key,bool(found) and float(found[1])==m[key])
            check(label+' mapped hash',digest(folder/'mapped.v')==m['mapped_sha256'])
            check(label+' SDC hash',digest(folder/'timing.sdc')==m['sdc_sha256'])
            area=float(re.findall(r'Chip area for (?:top )?module .*?:\s*([\d.]+)',(folder/'mapping.log').read_text())[-1])
            check(label+' raw area',area==m['mapped_area_um2'])
        elif m.get('formal')=='FAIL':check(label+' real counterexample','model found for base case: FAIL!' in (folder/'formal.log').read_text() and (folder/'formal_counterexample.vcd').exists() and m['ppa']=='NOT_RUN')
        else:check(label+' fail closed',not m.get('eligible'))
    eda(s/'baseline',base,'baseline')
    for slot,row in zip(manifest['slots'],summary['results']):
        f=s/row['arm']/row['candidate_id'];label=row['arm']+'/'+row['candidate_id'];g=load(f/'generation.json');check(label+' frozen generation',slot==g)
        req=load(f/'api_audit/request.json');check(label+' exact request',req['body']['messages'][-1]['content']==prompts[row['arm']] and (f/'prompt.txt').read_text(encoding='utf-8')==prompts[row['arm']])
        check(label+' endpoint and model',req['endpoint']==p['api_endpoint']+'/chat/completions' and req['body']['model']==p['model'])
        check(label+' sampling parameters',all(req['body'].get(k)==v for k,v in p['request_parameters'].items()))
        transport=f/'api_audit/transport.json'
        if transport.exists():check(label+' zero retries',load(transport)['retry_count']==0)
        response=f/'api_audit/response.json';body=None
        if response.exists():
            body=load(response);responses+=1;tokens+=body.get('usage',{}).get('total_tokens',0)
        if g['candidate_sha256']:
            if body is None:raise RuntimeError('Returned RTL has no recorded provider response: '+label)
            code,_=_parse_content(body['choices'][0]['message']['content'])
            check(label+' actual returned RTL',code==(f/'candidate.v').read_text(encoding='utf-8') and digest(f/'candidate.v')==g['candidate_sha256'])
            eda(f/'eda',row['metrics'],label)
            m=row['metrics'];valid=(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=p['area_cap_um2'] and m['tns_ns']>=base['tns_ns']-1e-9 and m['wns_ns']>base['wns_ns']+1e-9)
            check(label+' acceptance',row['accepted']==valid)
        else:check(label+' missing RTL retained',not row['accepted'] and row['metrics'] is None)
    for arm,group in summary['groups'].items():
        rows=[r for r in summary['results'] if r['arm']==arm];valid=[r for r in rows if r['accepted']];valid.sort(key=lambda r:(-r['metrics']['wns_ns'],r['metrics']['mapped_area_um2'],r['candidate_id']))
        chosen=valid[0] if valid else None
        check(arm+' complete denominator',len(rows)==group['scheduled']==3)
        check(arm+' selection',group['selected_metrics']==(chosen['metrics'] if chosen else base) and group['valid_improvements']==len(valid))
        origin=s/arm/chosen['candidate_id']/'candidate.v' if chosen else s/'inputs/original.v'
        check(arm+' export',digest(origin)==digest(s/'selected'/arm/'arbiter.v')==group['selected_rtl_sha256'])
    report=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,responses=responses,
        provider_reported_tokens=tokens,scope='Evidence consistency, not model identity, causal superiority or an independent proof engine')
    (s/'AUDIT.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k!='checks'}))
    return 0 if report['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
