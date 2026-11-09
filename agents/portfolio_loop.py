"""Offline verified RTL portfolio for three fixed development instances.

Every run remeasures the original and candidates; historical PPA is never a
selection input. This is curated replay, not generic RTL recognition/generation.
"""
import argparse
from datetime import datetime
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
BANK=ROOT/'benchmark/verified_portfolio_20261107'
EVALUATOR=ROOT/'eda/experiments/run_native_comb.py'
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def save(path,value):
    path.write_text(json.dumps(value,ensure_ascii=False,indent=2,allow_nan=False),encoding='utf-8')


def checked_asset(item):
    p=(BANK/item['file']).resolve()
    if BANK.resolve() not in p.parents or not p.is_file() or sha(p)!=item['sha256']:
        raise ValueError('Missing, changed or escaped portfolio asset')
    return p


def registry():
    f=BANK/'registry.json'
    if sha(f)!=(BANK/'registry.sha256').read_text().strip():raise ValueError('Portfolio registry changed')
    data=load(f);ids=set()
    for d in data['designs']:
        if d['id'] in ids or not re.fullmatch(r'[a-zA-Z0-9_]+',d['id']):raise ValueError('Invalid design ID')
        ids.add(d['id']);checked_asset(d['reference']);seen=set()
        for c in d['candidates']:
            if c['id'] in seen or not re.fullmatch(r'[a-zA-Z0-9_]+',c['id']):raise ValueError('Invalid candidate ID')
            seen.add(c['id']);checked_asset(c)
    return data


def qualified(m):
    return (m.get('status')=='PASS' and m.get('formal')==m.get('mapped_formal')==m.get('ppa')=='PASS'
            and m.get('electrical',{}).get('status')=='PASS'
            and all(type(m.get(k)) in (int,float) and math.isfinite(m[k]) for k in
                    ('max_data_arrival_ns','mapped_area_um2','tns_ns')) and m['mapped_area_um2']>0)


def decide(m,baseline,area_ratio):
    reasons=[]
    if not qualified(m):reasons.append('validation_or_electrical_not_passed')
    else:
        if m['mapped_area_um2']>baseline['mapped_area_um2']*area_ratio+1e-9:reasons.append('area_limit')
        if m['tns_ns']<baseline['tns_ns']:reasons.append('tns_regression')
        if m['max_data_arrival_ns']>=baseline['max_data_arrival_ns']:reasons.append('no_strict_timing_gain')
    return dict(accepted=not reasons,reasons=reasons)


def choose(rows):
    allowed=[r for r in rows if r['id']=='baseline' or r['accepted']]
    return min(allowed,key=lambda r:(r['metrics']['max_data_arrival_ns'],r['metrics']['mapped_area_um2'],r['id']))


def pareto(rows,baseline,area_ratio):
    valid=[r for r in rows if qualified(r['metrics']) and r['metrics']['mapped_area_um2']<=baseline['mapped_area_um2']*area_ratio+1e-9
           and r['metrics']['tns_ns']>=baseline['tns_ns']]
    def dominates(a,b):
        am,bm=a['metrics'],b['metrics'];keys=('max_data_arrival_ns','mapped_area_um2')
        return all(am[k]<=bm[k] for k in keys) and any(am[k]<bm[k] for k in keys)
    return [r['id'] for r in valid if not any(dominates(other,r) for other in valid)]


def evaluate(candidate,reference,design,out):
    env=os.environ.copy()
    for name in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(name,None)
    cmd=[sys.executable,'-B',str(EVALUATOR),str(candidate),'--reference',str(reference),'--top',design['top'],
         '--mapping-policy','buffer_size','--cleanup-before-buffer','--timeout','120','--out',str(out)]
    for k,v in design['parameters'].items():cmd+=['--param',f'{k}={v}']
    try:
        p=subprocess.run(cmd,cwd=ROOT,env=env,capture_output=True,timeout=900);raw=p.stdout+p.stderr
    except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+(e.stderr or b'')+b'\nOVERALL_TIMEOUT'
    (out.parent/(out.name+'_runner.log')).write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',reason='No evaluator result')


def run(args):
    if not math.isfinite(args.area_limit) or args.area_limit<1:raise ValueError('Area ratio must be finite and at least1')
    designs=registry()['designs'];design=next((d for d in designs if d['id']==args.design),None)
    if design is None:raise ValueError('Unsupported fixed design; use list')
    chosen=([dict(id=f'manual_{i:02d}',path=Path(f).resolve(),origin='User-supplied manual candidate') for i,f in enumerate(args.candidate_rtl,1)]
            if args.candidate_rtl else [dict(id=c['id'],path=checked_asset(c),origin=c['origin']) for c in design['candidates']])
    for c in chosen:
        if not c['path'].is_file():raise ValueError('Candidate file missing')
    out=(args.out or ROOT/'eda/experiments'/('portfolio_'+datetime.now().strftime('%Y%m%d_%H%M%S_%f'))).resolve()
    out.mkdir(parents=True,exist_ok=False);(out/'inputs').mkdir();(out/'evaluations').mkdir()
    reference=out/'inputs/original.v';shutil.copyfile(checked_asset(design['reference']),reference)
    sources=[]
    for c in chosen:
        dest=out/'inputs'/(c['id']+'.v');shutil.copyfile(c['path'],dest)
        sources.append(dict(id=c['id'],path=dest,origin=c['origin'],sha256=sha(dest)))
    save(out/'protocol.json',dict(design=design['id'],top=design['top'],parameters=design['parameters'],scope=design['scope'],
         model_requests=0,network_inference=False,area_ratio=args.area_limit,reference_sha256=sha(reference),
         candidates=[{k:str(v) if isinstance(v,Path) else v for k,v in c.items()} for c in sources],
         registry_sha256=sha(BANK/'registry.json'),runner_sha256=sha(Path(__file__)),evaluator_sha256=sha(EVALUATOR),
         cone_runner_sha256=sha(EVALUATOR.with_name('trace_sta_rtl_cone.py')),liberty_sha256=sha(LIB),
         selection='Original-relative fixed area budget; strict arrival improvement and nondegrading TNS; full proof/electrical qualification'))
    baseline=evaluate(reference,reference,design,out/'evaluations/baseline')
    if not qualified(baseline):
        save(out/'SUMMARY.json',dict(status='BASELINE_NOT_QUALIFIED',model_requests=0,baseline=baseline))
        print('Baseline qualification failed; no optimized export. '+str(out/'SUMMARY.json'));return 2
    rows=[dict(id='baseline',accepted=True,reasons=[],metrics=baseline,source=str(reference.relative_to(out)),shared_evaluation=None)]
    cache={sha(reference):('baseline',baseline)}
    for c in sources:
        if c['sha256'] in cache:
            evaluation_id,m=cache[c['sha256']];shared=evaluation_id
        else:
            m=evaluate(c['path'],reference,design,out/'evaluations'/c['id']);cache[c['sha256']]=(c['id'],m);shared=None
        row=dict(id=c['id'],metrics=m,source=str(c['path'].relative_to(out)),shared_evaluation=shared,**decide(m,baseline,args.area_limit));rows.append(row)
        print(c['id']+': '+('ACCEPTED' if row['accepted'] else 'REJECTED '+','.join(row['reasons'])),flush=True)
    best=choose(rows);shutil.copyfile(out/best['source'],out/'best.v')
    front=pareto(rows,baseline,args.area_limit);(out/'pareto').mkdir()
    for row in rows:
        if row['id'] in front:shutil.copyfile(out/row['source'],out/'pareto'/(row['id']+'.v'))
    summary=dict(status='COMPLETE',design=design['id'],top=design['top'],parameters=design['parameters'],model_requests=0,
                 scope=design['scope'],area_ratio=args.area_limit,baseline=baseline,selected=best['id'],best_metrics=best['metrics'],
                 best_sha256=sha(out/'best.v'),baseline_retained=best['id']=='baseline',candidates=rows,pareto=front,
                 pareto_scope='Budget-qualified delay/area tradeoffs; slower designs may appear, primary best never regresses',unique_eda_runs=len(cache))
    save(out/'SUMMARY.json',summary)
    lines=['# 本地候选库评估','',f'固定实例：{design["id"]}；模型调用0次。',
           f'选择：{best["id"]}；延迟{baseline["max_data_arrival_ns"]:.3f}→{best["metrics"]["max_data_arrival_ns"]:.3f}ns；面积{best["metrics"]["mapped_area_um2"]:.4f}µm²。',
           '','| 候选 | 结果 | 延迟ns | 面积µm² | 原因 |','|---|---|---:|---:|---|']
    for row in rows:
        m=row['metrics'];lines.append(f'| {row["id"]} | {"通过" if row["accepted"] else "拒绝"} | {m.get("max_data_arrival_ns","—")} | {m.get("mapped_area_um2","—")} | {",".join(row["reasons"])} |')
    lines+=['','best.v为本次重新测量后的选择；pareto/保存预算内面积/延迟取舍。',
            '只覆盖注册的固定参数实例；来源、哈希、证明和工具日志见protocol.json、SUMMARY.json及evaluations/。',
            '这是已有候选的本地验证与选择，不是新模型实验或任意RTL自动优化。']
    (out/'REPORT.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print('Selected '+best['id']+'; '+str(out/'best.v'),flush=True);return 0


def main(argv=None):
    ap=argparse.ArgumentParser(description=__doc__);sub=ap.add_subparsers(dest='command',required=True)
    sub.add_parser('list');p=sub.add_parser('run');p.add_argument('--design',required=True);p.add_argument('--out',type=Path)
    p.add_argument('--area-limit',type=float,default=1.1);p.add_argument('--candidate-rtl',action='append',default=[],help='Manual files replace the registered portfolio; no model calls')
    a=ap.parse_args(argv)
    if a.command=='list':
        for d in registry()['designs']:print(d['id']+' top='+d['top']+' params='+json.dumps(d['parameters'])+' candidates='+str(len(d['candidates'])))
        return 0
    return run(a)


if __name__=='__main__':sys.exit(main())
