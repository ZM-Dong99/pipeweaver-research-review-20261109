"""Freeze natural streaming feedback design materials only; no API, no new EDA."""
import argparse
from datetime import datetime
import hashlib
import json
from pathlib import Path
import shutil

ROOT=Path(__file__).resolve().parents[2]
PARENT=ROOT/'eda/experiments/stream_initialized_controls_20261106'
RESET=ROOT/'eda/experiments/stream_reset_contract_20261106_reachable'
SRC=ROOT/'benchmark/engineering_sources_20261106'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',required=True,type=Path);a=ap.parse_args()
    out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
    if not load(RESET/'SUMMARY.json')['passed'] or not load(RESET/'AUDIT.json')['passed']:raise RuntimeError('Reset contract must be validated')
    cases=[dict(id='adapter',top='axis_adapter',source='axis_adapter.v',params={'S_DATA_WIDTH':8,'M_DATA_WIDTH':32}),
           dict(id='skid',top='axis_register',source='axis_register.v',params={'DATA_WIDTH':32,'REG_TYPE':2})]
    for sub in ('inputs','prompts','evidence'):(out/sub).mkdir()
    for c in cases:
        base=load(PARENT/c['id']/'result.json');tool=load(PARENT/c['id']/'protocol.json')
        if base['status']!='PASS' or not tool['unmap_clock_enables']:raise RuntimeError('Uniform mapped baseline required')
        source=SRC/c['source'];shutil.copyfile(source,out/'inputs'/c['source'])
        shutil.copyfile(PARENT/c['id']/'sta.log',out/'evidence'/(c['id']+'_baseline_sta.log'))
        shutil.copyfile(PARENT/c['id']/'timing.sdc',out/'evidence'/(c['id']+'.sdc'))
        common=f'''Optimize this fixed native streaming module for strictly greater setup WNS under the common mapped-area cap. Produce exactly one RTL candidate, not a menu of alternatives.
Top: {c['top']}; fixed parameters: {json.dumps(c['params'],sort_keys=True)}. Preserve module name, native pins, widths and parameter declarations/defaults. No retiming, new latency, transaction reordering, extra clock domains, asynchronous reset, assumptions or input restrictions.
The explicit functional contract is reset-only observable-interface equality, not every-pin equality during invalid cycles. Logical initial register values are arbitrary and independent; all declared init attributes are removed during proof. rst=1 at sample1; from sample2 compare s_axis_tready and m_axis_tvalid unconditionally, compare output keep/last/id/dest/user whenever output valid=1, and compare data bytes only when valid=1 and the corresponding tkeep bit=1. After sample1 reset and every other input may vary arbitrarily; no assumption that upstream honors backpressure. All observations use the same clock cycles. You may not rely on a new initial value to establish correctness. Invalid-cycle data and keep=0 byte values are not observed by this new contract.
Use conservative local changes. Preserve useful internal register names/encoding where practical to help the finite proof engine; correctness must be proved, not assumed from names. A proof timeout/incomplete result does not qualify.
Both arms use fixed SKY130HD TT25C1.80V; 10ns ideal core clock, zero external I/O delays, input transition0.10ns, output load0.010pF, no wire parasitics. Same mapping: synth -noabc; dffunmap -ce-only; dfflibmap; ABC map/cleanup/buffer/upsize/dnsize. Candidate and baseline use this exact policy. Baseline area {base['mapped_area_um2']:.6f}um^2; area cap {base['mapped_area_um2']*1.10:.6f}um^2. Require complete source and mapped reset-contract proof, STA, zero max-slew/max-capacitance violations, area within cap, WNS strictly greater than baseline and TNS not worse. Otherwise retain original. No candidate measurements or example rewrites are provided.
Return one JSON object with candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries. Predictions are hypotheses, not measured results. Synthesizable Verilog2001 only; no external dependencies or code execution.

Original unmodified public RTL:
{source.read_text(encoding='utf-8')}
'''
        report=(PARENT/c['id']/'sta.log').read_text(encoding='utf-8');chunks=report.split('Startpoint:')[1:]
        if not chunks:raise RuntimeError('Missing actual baseline paths')
        paths=''.join('Startpoint:'+s for s in chunks[:3]).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]
        guided=common+'\nActual baseline STA feedback:\n'+json.dumps({k:base[k] for k in ('wns_ns','tns_ns')})+'\n'+paths+'\nMapped names are not an exact gate-to-RTL source mapping.\n'
        (out/'prompts'/(c['id']+'_no_sta.txt')).write_text(common,encoding='utf-8')
        (out/'prompts'/(c['id']+'_sta.txt')).write_text(guided,encoding='utf-8')
        c['baseline']=base;c['source_sha256']=sha(source)
    schedule=[]
    for trial in range(1,4):
        for i,c in enumerate(cases):
            for arm in (('no_sta','sta') if (trial+i)%2 else ('sta','no_sta')):
                schedule.append(dict(call_index=len(schedule)+1,case=c['id'],arm=arm,trial=trial,prompt='prompts/'+c['id']+'_'+arm+'.txt'))
    shutil.copyfile(RESET/'protocol.json',out/'evidence/reset_protocol.json')
    shutil.copyfile(RESET/'AUDIT.json',out/'evidence/reset_audit.json')
    shutil.copyfile(Path(__file__),out/'evidence/preparation_driver.py')
    protocol=dict(status='DESIGN_PREPARED_NO_REQUESTS',created_at=datetime.now().astimezone().isoformat(),model_requests=0,
        proposed_max_requests=12,proposed_requested_model='gpt-6.1-sol',cases=cases,schedule=schedule,
        authorization='Previous12-call localization authorization exhausted. This preparation grants no fresh API budget.',
        scope='Two natural streaming function types from the same public repository; baseline and reset validation already inspected, not an independent blind benchmark suite.',
        comparison='Same common prompt, STA arm adds actual baseline timing only; no candidate EDA before all generation frozen.',
        primary='Per case/arm median baseline-retained WNS over all3 attempts; failures/incomplete/area/electrical ineligibility retain baseline; also report mean paired case-normalized setup-critical-delay gain. No post-hoc switch to best draw.',
        controls='Original baseline and unchanged-RTL pipeline sanity control. No verified natural-stream action library yet; do not label prior synthetic endpoint rule a proven competitor here.',
        proof_limits='Reference reset/interface contract established for frozen instances. General candidate verifier and interruption-safe request executor still need implementation/acceptance before calls.',
        parser_policy='Prospectively normalize one complete leading think wrapper and one complete JSON fence, then strict schema. Save all original responses; no semantic editing or repeated requests.',
        next_model='A later second-model replication must use identical selected instances, constraints, prompts and slot budget; no second-model testing is claimed here.',
        frozen_files={str(p.relative_to(out)):sha(p) for p in out.rglob('*') if p.is_file()})
    (out/'protocol.json').write_text(json.dumps(protocol,indent=2,ensure_ascii=False),encoding='utf-8');(out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    for rel,h in protocol['frozen_files'].items():
        if sha(out/rel)!=h:raise RuntimeError('Frozen artifact mismatch')
    for c in cases:
        x=(out/'prompts'/(c['id']+'_no_sta.txt')).read_text(encoding='utf-8');y=(out/'prompts'/(c['id']+'_sta.txt')).read_text(encoding='utf-8')
        if not y.startswith(x) or len(y)==len(x):raise RuntimeError('Prompt fairness failure')
    print(json.dumps(dict(prepared=str(out),prompts=4,proposed_requests=len(schedule),model_requests=0)))


if __name__=='__main__':main()
