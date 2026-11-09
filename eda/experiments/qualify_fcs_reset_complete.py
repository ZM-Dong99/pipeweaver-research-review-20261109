"""Create and prove a separately named, reset-complete 8-bit FCS pair."""
import json
import os
from pathlib import Path
import re
import subprocess
import sys

from integrate_crc_fcs import ROOT, SOURCE, OUT as PRIOR, BEST, sha, save

OUT=ROOT/'eda/experiments/fcs_reset_complete_20261107_induction_fixed'
RUNNER=Path(__file__).with_name('run_native_seq_reset_allpins.py')
TOP='axis_eth_fcs_reset'


def main():
    OUT.mkdir(exist_ok=False)
    upstream=(SOURCE/'rtl/axis_eth_fcs.v').read_text()
    upstream,count=re.subn(r'module axis_eth_fcs #','module '+TOP+' #',upstream)
    assert count==1
    for declaration, replacement in [
        ("reg [31:0] crc_state = 32'hFFFFFFFF;","reg [31:0] crc_state;"),
        ("reg [31:0] fcs_reg = 32'h00000000;","reg [31:0] fcs_reg;"),
        ("reg fcs_valid_reg = 1'b0;","reg fcs_valid_reg;")]:
        assert upstream.count(declaration)==1
        upstream=upstream.replace(declaration,replacement)
    reset_line="    if (rst) begin\n        crc_state <= 32'hFFFFFFFF;"
    assert upstream.count(reset_line)==1
    baseline=upstream.replace(reset_line,reset_line+"\n        fcs_reg <= 32'h00000000;")
    optimized,count=re.subn(r'lfsr #\([\s\S]*?\)\s*eth_crc_inst','crc32_d8 eth_crc_inst',baseline)
    assert count==1
    cases=dict(baseline=baseline+'\n'+(SOURCE/'rtl/lfsr.v').read_text(),
               optimized=optimized+'\n'+BEST.read_text(),
               missing_reset=upstream+'\n'+(SOURCE/'rtl/lfsr.v').read_text(),
               wrong_output=optimized.replace('assign output_fcs = fcs_reg;',"assign output_fcs = fcs_reg ^ 32'h1;")+'\n'+BEST.read_text())
    for name,text in cases.items():
        folder=OUT/name
        folder.mkdir()
        (folder/'source.v').write_text(text,encoding='utf-8')
    protocol=dict(top=TOP,parameters=dict(DATA_WIDTH=8,KEEP_ENABLE=0,KEEP_WIDTH=1),
        driver_sha256=sha(Path(__file__)),runner_sha256=sha(RUNNER),
        runner_derived_from='run_native_seq_initialized.py, copied without modifying original',
        upstream_sha256=sha(SOURCE/'rtl/axis_eth_fcs.v'),old_study_protocol_sha256=sha(PRIOR/'protocol.json'),
        crc_origin_sha256=sha(BEST),sources={n:sha(OUT/n/'source.v') for n in cases},
        reset_contract='Active-high synchronous rst=1 at first sampled rising edge; compare all pins and proven auxiliary state relations from sample 2 forever; rst arbitrary afterwards',
        initial_state='Independent arbitrary defined DUT states, no init attributes in proof or synthesis; no equality assumption between initial states',
        behavior_change='New variant explicitly clears output_fcs register on every reset edge, overriding any simultaneous frame-end update; three declared register initializers removed in both arms',
        compatibility='Not full-output equivalence to unmodified upstream during reset/invalid FCS. Same CRC and control rules when not reset; established against independent recurrence separately',
        outputs='All 34 output bits, including invalid output_fcs; no valid/data masks or packet legality assumptions',
        decision='Both source and gate full proofs, STA/electrical PASS; <=110% new baseline area, strict WNS gain and no TNS regression',
        negatives=dict(missing_reset='Actual post-reset source SAT failure expected',wrong_output='Actual source SAT failure expected'),
        new_model_calls=0)
    save(OUT/'protocol.json',protocol)
    (OUT/'protocol.sha256').write_text(sha(OUT/'protocol.json')+'\n')
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    yosys=Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    results={}
    for case in cases:
        folder=OUT/case
        script=folder/'frontend.ys'
        script.write_text(f'read_slang --top {TOP} source.v\nhierarchy -check -top {TOP}\nproc\nflatten\nwrite_json before_opt.json\nsetattr -unset init w:*\nopt\nrename -unescape\ncheck -assert\nwrite_json elaborated.json\nwrite_verilog -noattr elaborated.v\n')
        p=subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/'frontend.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Frontend failed '+case)
        for filename in ('before_opt.json','elaborated.json'):
            module=json.loads((folder/filename).read_text())['modules'][TOP]
            assert not any('init' in net.get('attributes',{}) for net in module['netnames'].values()),'Unexpected initial-state attribute'
    for case in cases:
        folder=OUT/case
        print('Reset-only evaluation '+case,flush=True)
        command=[sys.executable,'-B',str(RUNNER),str(folder/'elaborated.v'),
             '--reference',str(OUT/'baseline/elaborated.v'),'--top',TOP,'--clock','clk','--reset','rst',
             '--out',str(folder/'evaluation'),'--initial-state-policy','reset-only',
             '--prove-state-invariants','--unmap-clock-enables','--timeout','120']
        p=subprocess.run(command,cwd=ROOT,env=env,capture_output=True,timeout=900)
        (folder/'driver.log').write_bytes(p.stdout+p.stderr)
        r=json.loads((folder/'evaluation/result.json').read_text())
        results[case]=r
        save(OUT/'RESULT.json',dict(cases=results,new_model_calls=0,initial_state_assumptions=False))
        print(json.dumps(dict(case=case,**r)),flush=True)


if __name__=='__main__':
    main()
