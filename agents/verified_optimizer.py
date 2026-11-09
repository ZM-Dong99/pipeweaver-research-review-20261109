"""Version2 offline verified portfolio: native combinational and guarded CRC.

Curated fixed instances only. No model inference, generic RTL recognition or
automatic parameter adaptation. The original experiment dependencies stay intact.
"""
import argparse
from datetime import datetime
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

from agents.portfolio_loop import qualified,decide,choose,pareto,sha,load,save,evaluate as native_evaluate

ROOT=Path(__file__).resolve().parents[1]
BANK=ROOT/'benchmark/verified_portfolio_v2_20261107'
CRC_EVALUATOR=ROOT/'eda/experiments/evaluate_crc_candidate.py'
LIB=ROOT/'eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'


def checked_asset(item):
    path=(BANK/item['file']).resolve()
    if BANK.resolve() not in path.parents or not path.is_file() or sha(path)!=item['sha256']:
        raise ValueError('Portfolio asset missing, modified or outside bank')
    return path


def registry():
    f=BANK/'registry.json'
    if sha(f)!=(BANK/'registry.sha256').read_text().strip():raise ValueError('Registry checksum mismatch')
    data=load(f);seen=set()
    for design in data['designs']:
        if design['id'] in seen or not re.fullmatch(r'[A-Za-z0-9_]+',design['id']):raise ValueError('Invalid design ID')
        seen.add(design['id']);checked_asset(design['reference']);ids=set()
        if design['backend'] not in ('native_comb','crc_slang_fixed'):raise ValueError('Unknown backend')
        if design['backend']=='crc_slang_fixed':
            from eda.experiments.evaluate_crc_candidate import STUDY,reference
            reference()
            p=load(STUDY/'protocol.json');c=next(c for c in p['cases'] if c['data_width']==8)
            if design['top']!='crc32_d8' or design['parameters'] or design['reference']['sha256']!=c['source_sha256']:
                raise ValueError('CRC adapter requires its locked original instance')
        for candidate in design['candidates']:
            if candidate['id'] in ids or not re.fullmatch(r'[A-Za-z0-9_]+',candidate['id']):raise ValueError('Invalid candidate ID')
            ids.add(candidate['id']);checked_asset(candidate)
    return data


def evaluate(candidate,reference,design,out):
    if design['backend']=='native_comb':return native_evaluate(candidate,reference,design,out)
    if design['backend']!='crc_slang_fixed':raise ValueError('Unsupported evaluator')
    if sha(reference)!=design['reference']['sha256']:raise ValueError('CRC reference changed')
    env=os.environ.copy()
    for name in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(name,None)
    try:
        p=subprocess.run([sys.executable,'-B',str(CRC_EVALUATOR),str(candidate),'--out',str(out)],cwd=ROOT,env=env,capture_output=True,timeout=1200)
        raw=p.stdout+p.stderr
    except subprocess.TimeoutExpired as e:raw=(e.stdout or b'')+(e.stderr or b'')+b'\nOVERALL_TIMEOUT'
    (out.parent/(out.name+'_runner.log')).write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',reason='No evaluator result')


def dependencies(design):
    files=[Path(__file__),ROOT/'agents/portfolio_loop.py',ROOT/'eda/experiments/run_native_comb.py',ROOT/'eda/experiments/trace_sta_rtl_cone.py']
    if design['backend']=='crc_slang_fixed':
        from eda.experiments.evaluate_crc_candidate import STUDY
        files += [CRC_EVALUATOR,STUDY/'protocol.json',STUDY/'protocol.sha256',STUDY/'EVALUATION_PROTOCOL.json',STUDY/'AFFINE_SOURCE_PROOF.json',
                  STUDY/'inputs/crc32_d8.v',STUDY/'crc32_d8_slang_invocation_fixed/elaborated.v',STUDY/'crc32_d8_slang_invocation_fixed/elaborated.json']
    return {str(p.relative_to(ROOT)):sha(p) for p in files}


def run(args):
    if not math.isfinite(args.area_limit) or args.area_limit<1:raise ValueError('Area ratio must be finite and at least1')
    design=next((d for d in registry()['designs'] if d['id']==args.design),None)
    if design is None:raise ValueError('Unsupported fixed instance; use list')
    sources=([dict(id=f'manual_{i:02d}',path=Path(f).resolve(),origin='Manual candidate') for i,f in enumerate(args.candidate_rtl,1)]
             if args.candidate_rtl else [dict(id=c['id'],path=checked_asset(c),origin=c['origin']) for c in design['candidates']])
    for c in sources:
        if not c['path'].is_file():raise ValueError('Candidate missing')
    out=(args.out or ROOT/'eda/experiments'/('verified_'+datetime.now().strftime('%Y%m%d_%H%M%S_%f'))).resolve()
    out.mkdir(parents=True,exist_ok=False);(out/'inputs').mkdir();(out/'evaluations').mkdir()
    ref=out/'inputs/original.v';shutil.copyfile(checked_asset(design['reference']),ref);local=[]
    for c in sources:
        dest=out/'inputs'/(c['id']+'.v');shutil.copyfile(c['path'],dest)
        local.append(dict(id=c['id'],path=dest,origin=c['origin'],sha256=sha(dest)))
    before=dependencies(design)
    save(out/'protocol.json',dict(design=design['id'],top=design['top'],parameters=design['parameters'],backend=design['backend'],scope=design['scope'],
         model_requests=0,area_ratio=args.area_limit,registry_sha256=sha(BANK/'registry.json'),reference_sha256=sha(ref),dependencies=before,
         liberty_sha256=sha(LIB),candidates=[dict(id=c['id'],file=str(c['path'].relative_to(out)),origin=c['origin'],sha256=c['sha256']) for c in local],
         selection='Full original-relative proof/electrical qualification, area cap, nondegrading TNS and strict arrival improvement; otherwise original'))
    baseline=evaluate(ref,ref,design,out/'evaluations/baseline')
    if not qualified(baseline):
        save(out/'SUMMARY.json',dict(status='BASELINE_NOT_QUALIFIED',model_requests=0,baseline=baseline))
        print('Baseline not qualified; no optimized export. '+str(out/'SUMMARY.json'));return 2
    rows=[dict(id='baseline',accepted=True,reasons=[],metrics=baseline,source=str(ref.relative_to(out)),shared_evaluation=None)]
    cache={sha(ref):('baseline',baseline)}
    for c in local:
        if c['sha256'] in cache:
            shared,m=cache[c['sha256']]
        else:
            m=evaluate(c['path'],ref,design,out/'evaluations'/c['id']);cache[c['sha256']]=(c['id'],m);shared=None
        row=dict(id=c['id'],source=str(c['path'].relative_to(out)),metrics=m,shared_evaluation=shared,**decide(m,baseline,args.area_limit));rows.append(row)
        print(c['id']+': '+('ACCEPTED' if row['accepted'] else 'REJECTED '+','.join(row['reasons'])),flush=True)
    if dependencies(design)!=before:raise RuntimeError('Dependencies changed during run; refusing export')
    best=choose(rows);shutil.copyfile(out/best['source'],out/'best.v');front=pareto(rows,baseline,args.area_limit);(out/'pareto').mkdir()
    for row in rows:
        if row['id'] in front:shutil.copyfile(out/row['source'],out/'pareto'/(row['id']+'.v'))
    summary=dict(status='COMPLETE',design=design['id'],backend=design['backend'],top=design['top'],parameters=design['parameters'],scope=design['scope'],
         model_requests=0,area_ratio=args.area_limit,baseline=baseline,selected=best['id'],best_metrics=best['metrics'],best_sha256=sha(out/'best.v'),
         baseline_retained=best['id']=='baseline',candidates=rows,pareto=front,unique_evaluations=len(cache),dependencies_unchanged=True,
         pareto_scope='Budget-qualified delay/area alternatives may include slower references; primary best never regresses')
    save(out/'SUMMARY.json',summary)
    lines=['# 已验证候选统一评估','',f'固定实例：{design["id"]}；模型调用0次。',
         f'选择：{best["id"]}；到达时间{baseline["max_data_arrival_ns"]:.3f}→{best["metrics"]["max_data_arrival_ns"]:.3f}ns；面积{best["metrics"]["mapped_area_um2"]:.4f}µm²。','',
         '| 候选 | 选择资格 | 延迟ns | 面积µm² | 拒绝原因 |','|---|---|---:|---:|---|']
    for row in rows:
        m=row['metrics'];lines.append(f'| {row["id"]} | {"通过" if row["accepted"] else "拒绝"} | {m.get("max_data_arrival_ns","—")} | {m.get("mapped_area_um2","—")} | {",".join(row["reasons"])} |')
    lines+=['','best.v为本次验证与测量后的选择。pareto/保存预算内的面积/时序取舍，较慢方案不等于主目标改善。',
        '固定实例及后端见protocol.json；完整证明、编译和工具日志见evaluations/。',
        '本入口复用已知候选，不生成新RTL，不证明任意新参数或大型工程系统上的泛化。']
    (out/'REPORT.md').write_text('\n'.join(lines)+'\n',encoding='utf-8');print('Selected '+best['id']+'; '+str(out/'best.v'),flush=True);return 0


def main(argv=None):
    ap=argparse.ArgumentParser(description=__doc__);sub=ap.add_subparsers(dest='command',required=True);sub.add_parser('list')
    p=sub.add_parser('run');p.add_argument('--design',required=True);p.add_argument('--area-limit',type=float,default=1.1);p.add_argument('--out',type=Path);p.add_argument('--candidate-rtl',action='append',default=[])
    a=ap.parse_args(argv)
    if a.command=='list':
        for d in registry()['designs']:print(d['id']+' top='+d['top']+' backend='+d['backend']+' candidates='+str(len(d['candidates'])))
        return 0
    return run(a)


if __name__=='__main__':sys.exit(main())
