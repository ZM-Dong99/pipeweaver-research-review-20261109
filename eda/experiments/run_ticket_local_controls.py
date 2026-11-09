"""Four frozen post-hoc ticket-machine controls; zero model requests.

Not an additional arm of the previous model comparison. All candidates are
constructed after inspecting that comparison and proved against its original.
"""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
E=ROOT/'eda/experiments';PARENT=E/'ticket_feedback_study_20261102_234633_156134'
BACKEND=E/'run_native_seq.py'
LIB=E/'sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def once(text,old,new):
    if text.count(old)!=1:raise ValueError('Source guard failed: '+old[:50])
    return text.replace(old,new,1)

def variants(original,explicit,binary):
    # A matched ablation: only remove the redundant bill state/output register.
    no_bill,n=re.subn(r'^\s*bill\s*<=.*?;', '',explicit,flags=re.M|re.S)
    assert n==2
    no_bill=once(no_bill,'    always @* begin','    always @* begin\n        bill = (s_bill10 | s_bill20 | s_bill30) ? ON : OFF;')
    no_bill=re.sub(r'\s*// This is the bill indication of the state being entered,\n\s*// not a delayed copy of the current state\x27s bill indication\.', '',no_bill)
    # Reached states form an exhaustive partition under the frozen reset contract.
    complement=original
    complement,n=re.subn(r'^\s*bill\s*=\s*(?:ON|OFF);', '',complement,flags=re.M)
    assert n==7
    marker='    // next state logic'
    assert marker in complement
    before,after=complement.split(marker,1)
    pos=before.rfind('        endcase')
    assert pos!=-1
    insertion='        bill = ((State == RDY) || (State == DISP) || (State == RTN)) ? OFF : ON;\n'
    before=before[:pos]+before[pos:].replace('        endcase','        endcase\n'+insertion,1)
    complement=before+marker+after
    # Tool hint deliberately preserves the chosen state encoding; ordinary synth
    # otherwise recodes the earlier binary candidate back to six one-hot FFs.
    fixed=once(binary,'    reg [2:0] State, NextState;',
               '    (* fsm_encoding = "none" *) reg [2:0] State;\n    reg [2:0] NextState;')
    output_aware=fixed
    for name,old,new in [('BILL10',1,4),('BILL20',2,5),('BILL30',3,6),('DISP',4,1),('RTN',5,2)]:
        output_aware,n=re.subn(rf'(\b{name}\s*=\s*3\x27d){old}\b',rf'\g<1>{new}',output_aware)
        assert n==1
    pos=output_aware.index('    always @* begin')
    endcase=output_aware.index('        endcase',pos)
    output_aware=output_aware[:endcase]+output_aware[endcase:].replace('        endcase',
        '        endcase\n        bill = State[2] ? ON : OFF;',1)
    return [dict(id='explicit_onehot_without_bill_ff',rtl=no_bill,question='Remove only redundant bill FF and return to combinational bill decode in guided candidate03'),
            dict(id='original_complement_bill',rtl=complement,question='Use complement of non-billing states for bill under proved reached-state contract'),
            dict(id='binary_preserve_encoding',rtl=fixed,question='Disable automatic FSM recoding of the known binary-source candidate; preserve its actual three-state-bit encoding'),
            dict(id='billing_bit_preserve_encoding',rtl=output_aware,question='Encode billing states with high state bit set, drive bill directly from that bit; no extra FF')]

def main():
    old=load(PARENT/'protocol.json');assert sha(PARENT/'protocol.json')==(PARENT/'protocol.sha256').read_text().strip()
    s=E/datetime.now().strftime('ticket_local_controls_%Y%m%d_%H%M%S_%f');s.mkdir()
    (s/'inputs').mkdir();(s/'candidates').mkdir();(s/'code_snapshot').mkdir()
    inputs={'original.v':PARENT/'inputs/original.v','guided_reference.v':PARENT/'structured_timing_feedback/candidate_03/candidate.v',
            'known_model_best.v':PARENT/'no_timing_feedback/candidate_05/candidate.v','LICENSE':PARENT/'inputs/LICENSE'}
    for name,source in inputs.items():shutil.copyfile(source,s/'inputs'/name)
    cases=variants(*( (s/'inputs'/name).read_text(encoding='utf-8') for name in ['original.v','guided_reference.v','known_model_best.v']))
    for c in cases:
        path=s/'candidates'/(c['id']+'.v');path.write_text(c.pop('rtl'),encoding='utf-8');c.update(sha256=sha(path))
    deps=[Path(__file__).resolve(),BACKEND,E/'run_native_comb.py',E/'trace_sta_rtl_cone.py']
    for path in deps:shutil.copyfile(path,s/'code_snapshot'/path.name)
    protocol=dict(scope='Post-hoc four-candidate development controls, not an independent LLM comparison or guaranteed improvement',
        parent=str(PARENT),parent_protocol_sha256=sha(PARENT/'protocol.json'),client_date='2026-11-03',
        input_sha256={name:sha(s/'inputs'/name) for name in inputs},candidate_count=4,candidates=cases,
        code_sha256={str(path.relative_to(ROOT)):sha(path) for path in deps},library_sha256=sha(LIB),
        clock='clk',reset='clear',reset_active=1,reset_cycles=1,warmup_samples=1,period_ns=10,parameter_overrides={},
        area_ratio_limit=1.10,area_cap_um2=old['area_cap_um2'],model_requests=0,
        expected_baseline=old['baseline_metrics'],expected_known_model_best=load(PARENT/'summary.json')['groups']['no_timing_feedback']['selected_metrics'],
        selection='Every candidate vs frozen original. Strict WNS gain, TNS no regression, original area cap unchanged. Best WNS then area; known prior model best separately retained.',
        limitations='Only reached states after reset are proved. Output-aware encoding changes invalid-state combinational outputs; no new input assumptions. Synthesis hint is an actual encoding constraint, not an equivalence bypass. One small design, post-hoc development.',
        policy='All four source candidates frozen before any new EDA measurement. No adaptive additions, API calls, or modifying parent results.')
    save(s/'protocol.json',protocol);(s/'protocol.sha256').write_text(sha(s/'protocol.json')+'\n',encoding='ascii')
    def evaluate(case):
        label,source=case;out=s/label
        assert all(sha(s/'candidates'/(c['id']+'.v'))==c['sha256'] for c in cases)
        command=[sys.executable,'-B',str(BACKEND),str(source),'--reference',str(s/'inputs/original.v'),
                 '--top','ticket_machine','--clock','clk','--reset','clear','--reset-cycles','1','--warmup','1','--period','10',
                 '--timeout','120','--out',str(out)]
        env=os.environ.copy()
        for k in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):env.pop(k,None)
        try:raw=subprocess.run(command,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=960).stdout
        except subprocess.TimeoutExpired as exc:raw=(exc.stdout or b'')+b'\nOVERALL_TIMEOUT\n'
        out.mkdir(exist_ok=True);(out/'runner.log').write_bytes(raw)
        result=load(out/'result.json') if (out/'result.json').exists() else dict(status='INCOMPLETE',eligible=False)
        print(label,json.dumps(result),flush=True)
        return dict(id=label,source_sha256=sha(source),metrics=result)
    original=evaluate(('baseline',s/'inputs/original.v'))
    if original['metrics']['status']!='PASS':raise RuntimeError('Baseline failed; candidates not run: '+str(s))
    for k in ['wns_ns','tns_ns','mapped_area_um2','mapped_sha256']:assert original['metrics'][k]==protocol['expected_baseline'][k]
    jobs=[('known_model_best',s/'inputs/known_model_best.v')]+[(c['id'],s/'candidates'/(c['id']+'.v')) for c in cases]
    with ThreadPoolExecutor(max_workers=2) as pool:rows=list(pool.map(evaluate,jobs))
    b=original['metrics'];qualified=[]
    for r in rows:
        m=r['metrics'];ok=(m.get('status')=='PASS' and m.get('eligible') and m['mapped_area_um2']<=protocol['area_cap_um2'] and m['tns_ns']>=b['tns_ns']-1e-9 and m['wns_ns']>b['wns_ns']+1e-9)
        r['strict_baseline_improvement']=bool(ok)
        if ok and r['id']!='known_model_best':qualified.append(r)
    qualified.sort(key=lambda r:(-r['metrics']['wns_ns'],r['metrics']['mapped_area_um2'],r['id']))
    chosen=qualified[0] if qualified else original
    source=s/'candidates'/(chosen['id']+'.v') if qualified else s/'inputs/original.v'
    shutil.copyfile(source,s/'best_new.v')
    save(s/'SUMMARY.json',dict(status='COMPLETED',model_requests=0,baseline=original,rows=rows,best_new=chosen,best_new_sha256=sha(s/'best_new.v')))
    print('Experiment: '+str(s),flush=True)
if __name__=='__main__':main()
