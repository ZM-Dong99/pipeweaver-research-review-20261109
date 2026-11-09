"""Read-only checks of saved model requests versus actual STA prompts; no network."""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from agents.rtl_optimizer import _parse_content, LLMGenerationError

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def request_matches(prompt_text,request,model,endpoint):
    body=request.get('body',{})
    messages=body.get('messages',[])
    users=[m.get('content') for m in messages if m.get('role')=='user']
    return users==[prompt_text] and body.get('model')==model and request.get('endpoint')==endpoint.rstrip('/')+'/chat/completions'

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('study',type=Path)
    ap.add_argument('--endpoint',required=True,help='Explicit expected compatible API base URL')
    a=ap.parse_args();s=a.study.resolve()
    load=lambda p:json.loads(p.read_text(encoding='utf-8'))
    p=load(s/'protocol.json');summary=load(s/'summary.json');checks=[];responses=0;tokens=0
    def check(label,value):checks.append(dict(check=label,passed=bool(value)))
    if p['mode']!='llm':ap.error('Only actual LLM-mode loop artifacts are accepted; manual runs are not model evidence')
    check('protocol hash',sha(s/'protocol.json')==summary['protocol_sha256']==(s/'protocol.sha256').read_text().strip())
    check('complete denominator',summary['status']=='COMPLETED' and len(summary['candidates'])==p['candidate_budget']==summary['llm_requests_attempted']<=p['request_budget'])
    for path,h in p['dependencies'].items():check('snapshot '+Path(path).name,sha(s/'code_snapshot'/Path(path).name)==h)
    for item in p['inputs']:check('frozen input '+Path(item['path']).name,sha(Path(item['path']))==item['sha256'])
    def parser_ast(path):
        tree=ast.parse(path.read_text(encoding='utf-8'))
        return [ast.dump(n,include_attributes=False) for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ('_parse_content','_strip_verilog_fence')]
    current_parser=parser_ast(ROOT/'agents/rtl_optimizer.py')
    check('parser functions match frozen adapter',len(current_parser)==2 and current_parser==parser_ast(s/'code_snapshot/rtl_optimizer.py'))
    for row in summary['candidates']:
        f=s/f'candidate_{row["index"]:03d}';text=(f/'prompt.json').read_text(encoding='utf-8');prompt=json.loads(text)
        check(f.name+' prompt hash',sha(f/'prompt.json')==row['prompt_sha256'])
        check(f.name+' actual request',request_matches(text,load(f/'generation/request.json'),p['requested_model'],a.endpoint))
        check(f.name+' frozen contract',prompt['startup_and_timing_contract']==p['contract'] and prompt['fixed_mapped_area_cap_um2']==summary['fixed_area_cap_um2'])
        feedback=Path(row['feedback_source']);sta=feedback/'sta.log'
        check(f.name+' feedback provenance',sha(sta)==row['feedback_sha256']==prompt['actual_eda_feedback']['sta_log_sha256'])
        check(f.name+' real paths in request',bool(prompt['actual_eda_feedback']['measured_paths']) and all(x in sta.read_text() for x in prompt['actual_eda_feedback']['measured_paths']))
        check(f.name+' measured metrics in request',load(feedback/'result.json')==prompt['actual_eda_feedback']['metrics'])
        if row['index']>1:
            prev=summary['candidates'][row['index']-2];given=prompt['previous_attempt']
            check(f.name+' prior attempt',given.get('metrics')==prev.get('metrics') and given['accepted']==prev['accepted'] and given.get('reason')==prev.get('reason'))
        response=f/'generation/response.json'
        if not response.exists():
            check(f.name+' missing response retained',row['status']=='GENERATION_FAILED' and not row['accepted'] and not (f/'candidate.v').exists())
            continue
        responses+=1;data=load(response);usage=data.get('usage',{});tokens+=usage.get('total_tokens',0)
        try:
            code,explanation=_parse_content(data['choices'][0]['message']['content'])
        except (LLMGenerationError,KeyError,IndexError,TypeError):
            check(f.name+' invalid response retained',row['status']=='GENERATION_FAILED' and not row['accepted'])
            continue
        check(f.name+' actual response RTL',code==(f/'candidate.v').read_text(encoding='utf-8') and sha(f/'candidate.v')==row['candidate_sha256'])
        metadata=load(f/'generation_metadata.json')
        check(f.name+' response metadata',metadata['explanation']==explanation and metadata['parameters']['usage']=={k:usage[k] for k in ('prompt_tokens','completion_tokens','total_tokens') if k in usage})
        cp=load(f/'eda/protocol.json');metrics=load(f/'eda/result.json')
        check(f.name+' original reference',cp['reference_sha256']==p['original_sha256'])
        check(f.name+' EDA results',row['metrics']==metrics)
        check(f.name+' exact proof contract',all(cp[k]==p['contract'][k] for k in ('clock','reset','reset_active','reset_cycles','warmup_samples','period_ns')))
        if metrics['status']=='PASS':
            for stage in ('formal','mapped_formal'):
                check(f.name+' '+stage,'Induction step proven: SUCCESS!' in (f/'eda'/(stage+'.log')).read_text() and metrics[stage]=='PASS')
        else:check(f.name+' failed candidate rejected',not row['accepted'])
    contract=p['contract'];best=summary['baseline'];selected=s/'inputs/original.v';selected_source='baseline'
    cap=best['mapped_area_um2']*p['area_limit']
    check('fixed original area cap',cap==summary['fixed_area_cap_um2'])
    evaluations=[(s/'baseline',best)]+[(s/f'candidate_{row["index"]:03d}'/'eda',row['metrics']) for row in summary['candidates'] if 'metrics' in row]
    for folder,metrics in evaluations:
        cp=load(folder/'protocol.json')
        check(str(folder)+' actual result',load(folder/'result.json')==metrics)
        check(str(folder)+' protocol hash',sha(folder/'protocol.json')==(folder/'protocol.sha256').read_text().strip())
        check(str(folder)+' frozen original',cp['reference_sha256']==p['original_sha256']==sha(Path(cp['reference'])))
        check(str(folder)+' source artifact',cp['candidate_sha256']==sha(Path(cp['candidate'])))
        check(str(folder)+' identical contract',all(cp[k]==contract[k] for k in ('clock','reset','reset_active','reset_cycles','warmup_samples','period_ns','input_delay_ns','output_delay_ns','input_transition_ns','output_load_pf')) and cp['liberty_sha256']==contract['library_sha256'])
        for stage in ('formal','mapped_formal'):
            script=folder/(stage+'.ys')
            if script.exists():
                check(str(folder)+' '+stage+' reset assumptions',[int(x) for x in re.findall(r'-set-at (\d+) ',script.read_text())]==list(range(1,contract['reset_cycles']+1)))
        if metrics['status']=='PASS':
            check(str(folder)+' full eligibility',metrics['eligible'] and all(metrics[k]=='PASS' for k in ('formal','mapped_formal','ppa')) and metrics['electrical']['status']=='PASS')
            for stage in ('formal','mapped_formal'):
                text=(folder/(stage+'.log')).read_text()
                check(str(folder)+' '+stage+' complete','Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text)
            text=(folder/'sta.log').read_text()
            check(str(folder)+' actual STA','Endpoint:' in text and not re.search(r'^\s*(?:Error:|Warning:)',text,re.M|re.I))
            block=text.split('PW_ELECTRICAL_BEGIN')[1].split('PW_ELECTRICAL_END')[0]
            check(str(folder)+' electrical raw','(VIOLATED)' not in block)
            for key,pattern in [('wns_ns',r'worst slack max\s+([-+\d.]+)'),('tns_ns',r'tns max\s+([-+\d.]+)')]:
                m=re.search(pattern,text);check(str(folder)+' '+key,bool(m) and float(m[1])==metrics[key])
            check(str(folder)+' mapped netlist hash',sha(folder/'mapped.v')==metrics['mapped_sha256'])
            check(str(folder)+' SDC hash',sha(folder/'timing.sdc')==metrics['sdc_sha256'])
        else:check(str(folder)+' no failed eligibility',not metrics['eligible'])
    for row in summary['candidates']:
        if row['status']=='GENERATION_FAILED':
            check('generation failure never selected '+str(row['index']),not row['accepted']);continue
        metrics=row['metrics']
        accepted=metrics['status']=='PASS' and metrics['eligible'] and metrics['mapped_area_um2']<=cap and metrics['tns_ns']>=best['tns_ns']-1e-9 and metrics['wns_ns']>best['wns_ns']+1e-9
        check('decision '+str(row['index']),row['accepted']==accepted)
        if accepted:
            best=metrics;selected=s/f'candidate_{row["index"]:03d}'/'candidate.v';selected_source=selected.parent.name
    index=load(s/'best.json')
    check('exported best',index['metrics']==best and index['source']==selected_source and sha(selected)==sha(s/'best.v')==index['sha256'])
    repro=s/'independent_reproduction'
    if (repro/'result.json').exists():
        actual=load(repro/'result.json')
        for key in ('status','formal','mapped_formal','ppa','wns_ns','tns_ns','mapped_area_um2','mapped_sha256','sdc_sha256','electrical'):
            check('independent reproduction '+key,actual[key]==best[key])
    audit=dict(passed=all(x['passed'] for x in checks),check_count=len(checks),checks=checks,
        responses_received=responses,provider_reported_total_tokens=tokens,
        limitations='Saved request/response consistency only. No proof of provider backend identity, internal model reasoning, bill amount or method superiority.')
    (s/'LLM_DISPATCH_AUDIT.json').write_text(json.dumps(audit,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps({k:v for k,v in audit.items() if k!='checks'},ensure_ascii=False))
    return 0 if audit['passed'] else 1

if __name__=='__main__':raise SystemExit(main())
