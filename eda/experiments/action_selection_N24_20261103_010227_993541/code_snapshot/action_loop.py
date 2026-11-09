"""Manual action replay through real EDA. No model call in this CLI path."""
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from agents.action_selector import parse_selection,REGISTRY
E=ROOT/'eda/experiments';BACKEND=E/'run_native_comb.py'
SOURCE=ROOT/'benchmark/rtl_opt_upstream_hkust/benchmark/comparator/comparator.v'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def evaluate(candidate,out,reference,width,timeout=120):
    if out.exists():raise ValueError('Refusing to overwrite EDA directory')
    cmd=[sys.executable,'-B',str(BACKEND),str(candidate),'--reference',str(reference),'--top','comparator',
         '--param',f'N={width}','--mapping-policy','buffer_size','--cleanup-before-buffer','--timeout',str(timeout),'--out',str(out)]
    env=os.environ.copy()
    for key in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(key,None)
    try:raw=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout*8).stdout
    except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
    out.mkdir(parents=True,exist_ok=True);(out/'runner.log').write_bytes(raw)
    return load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',eligible=False)
def choose(ids,results,baseline,cap):
    eligible=[i for i in ids if results[i].get('status')=='PASS' and results[i].get('eligible') and results[i].get('formal')==results[i].get('mapped_formal')=='PASS' and results[i]['mapped_area_um2']<=cap and results[i]['max_data_arrival_ns']<baseline['max_data_arrival_ns']-1e-9]
    eligible.sort(key=lambda i:(results[i]['max_data_arrival_ns'],results[i]['mapped_area_um2'],i))
    return eligible[0] if eligible else 'baseline'
def run(args):
    if args.width<1 or args.timeout<1:raise ValueError('Positive width and timeout required')
    source=args.source.resolve();selection=parse_selection(args.selection_json.read_text(encoding='utf-8'),source.read_text(encoding='utf-8'))
    out=args.out.resolve() if args.out else E/datetime.now().strftime('action_replay_%Y%m%d_%H%M%S_%f')
    out.mkdir(parents=True,exist_ok=False);(out/'inputs').mkdir();(out/'candidates').mkdir()
    shutil.copyfile(source,out/'inputs/original.v');shutil.copyfile(args.selection_json,out/'inputs/selection.json')
    for i,rtl in selection['rtl_by_action'].items():(out/'candidates'/(i+'.v')).write_text(rtl,encoding='utf-8')
    save(out/'protocol.json',dict(mode='MANUAL_JSON_REPLAY_NOT_MODEL_GENERATION',model_calls=0,width=args.width,source_sha256=sha(out/'inputs/original.v'),selection_sha256=sha(out/'inputs/selection.json'),action_ids=selection['action_ids'],candidate_sha256={i:sha(out/'candidates'/(i+'.v')) for i in selection['action_ids']},area_ratio_limit=1.10))
    base=evaluate(out/'inputs/original.v',out/'baseline',out/'inputs/original.v',args.width,args.timeout)
    if base.get('status')!='PASS':save(out/'SUMMARY.json',dict(status='BASELINE_FAILED',baseline=base));return 2
    results={i:evaluate(out/'candidates'/(i+'.v'),out/i,out/'inputs/original.v',args.width,args.timeout) for i in selection['action_ids']}
    selected=choose(selection['action_ids'],results,base,base['mapped_area_um2']*1.10)
    shutil.copyfile(out/'inputs/original.v' if selected=='baseline' else out/'candidates'/(selected+'.v'),out/'best.v')
    save(out/'SUMMARY.json',dict(status='COMPLETED',mode='MANUAL_JSON_REPLAY_NOT_MODEL_GENERATION',model_calls=0,baseline=base,results=results,selected=selected,selected_metrics=base if selected=='baseline' else results[selected]))
    print('Experiment: '+str(out));print('Selected: '+selected);return 0
def configure_parser(sub):
    p=sub.add_parser('actions',help='replay exactly two whitelisted action IDs through formal and EDA; no API call')
    p.add_argument('--source',type=Path,default=SOURCE);p.add_argument('--selection-json',type=Path,required=True)
    p.add_argument('--width',type=int,required=True);p.add_argument('--out',type=Path);p.add_argument('--timeout',type=int,default=120);p.set_defaults(func=run)
