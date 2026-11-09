"""Single-DUT reset property and raw-source independent CRC simulation."""
import json
import os
from pathlib import Path
import random
import subprocess

from qualify_fcs_reset_complete import ROOT, OUT, TOP, sha, save
from run_native_comb import q
from run_fcs_physical import LIB


def main():
    folder=OUT/'independent_contract'
    folder.mkdir(exist_ok=False)
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    suite=Path('D:/oss-cad-suite')
    yosys=Path(env.get('YOSYS',str(suite/'bin/yosys.exe')))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    miter='''module pw_reset(input clk,rst,input [7:0] data,input keep,valid,last,user,output mismatch,
output [31:0] observed_fcs,observed_state,output observed_valid,observed_ready);
pw_dut dut(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),
.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(observed_fcs),.output_fcs_valid(observed_valid),
.s_axis_tready(observed_ready),.crc_state(observed_state));
assign mismatch=(observed_fcs != 32'b0) | (observed_state != 32'hffffffff) | observed_valid | !observed_ready;
endmodule
'''
    (folder/'reset_miter.v').write_text(miter,encoding='ascii')
    properties={}
    for case,mapped in [('baseline',False),('optimized',False),('baseline',True),('optimized',True),('missing_reset',False)]:
        label=case+('_mapped' if mapped else '_source')
        source=OUT/case/('evaluation/mapped.v' if mapped else 'elaborated.v')
        lines=([f'read_liberty -ignore_miss_func -ignore_miss_dir {q(LIB)}'] if mapped else [])
        lines += [f'read_verilog -formal -sv {q(source)}',f'hierarchy -check -top {TOP}',
           'proc','flatten','setattr -unset init w:*',f'expose {TOP}/w:crc_state',f'rename {TOP} pw_dut',
           f'read_verilog -formal {q(folder/"reset_miter.v")}','prep -top pw_reset -flatten','opt_clean',
           f'sat -verify -seq 2 -prove-skip 1 -set-at 1 rst 1 -set-init-def -set-def-inputs -prove mismatch 0 -show-ports -dump_vcd {q(folder/(label+".vcd"))} -timeout 120']
        script=folder/(label+'.ys')
        script.write_text('\n'.join(lines)+'\n',encoding='utf-8')
        p=subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=ROOT,env=env,capture_output=True,timeout=140)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/(label+'.log')).write_text(log,encoding='utf-8')
        expected='FAIL' if case=='missing_reset' else 'PASS'
        actual='PASS' if p.returncode==0 and 'SAT proof finished - no model found: SUCCESS!' in log else ('FAIL' if 'SAT proof finished - model found: FAIL!' in log else 'INCOMPLETE')
        properties[label]=dict(expected=expected,actual=actual,passed=actual==expected,
             scope='All 65 state bits and all 34 output bits fixed after exactly one reset edge; one DUT with arbitrary defined initial state, no cross-DUT relation',source_sha256=sha(source))
        print(label+' reset property: '+actual,flush=True)
    save(folder/'RESET_PROPERTY.json',dict(passed=all(r['passed'] for r in properties.values()),cases=properties))
    texts=[]
    for case,name in [('baseline','gold_fcs'),('optimized','opt_fcs')]:
        text=(OUT/case/'source.v').read_text()
        assert text.count('module '+TOP+' #')==1
        texts.append(text.replace('module '+TOP+' #','module '+name+' #',1))
    (folder/'both.v').write_text('\n'.join(texts),encoding='utf-8')
    ports='.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),'
    tb=['`timescale 1ns/1ps','module tb;','reg clk=0,rst=0; reg [7:0] data=0; reg keep=0,valid=0,last=0,user=0;',
        'wire [31:0] gf,cf; wire gv,cv,gr,cr;',
        'gold_fcs gold('+ports+'.output_fcs(gf),.output_fcs_valid(gv),.s_axis_tready(gr));',
        'opt_fcs cand('+ports+'.output_fcs(cf),.output_fcs_valid(cv),.s_axis_tready(cr));','initial begin']
    rng=random.Random(20261108)
    state,fcs=0xffffffff,0
    vectors=[]
    for index in range(4096):
        if index==0:
            rst,data,valid,last,keep,user=1,0x7a,1,1,0,1
        elif index<=9:
            rst,data,valid,last,keep,user=0,b'123456789'[index-1],1,int(index==9),1,0
        else:
            rst,data,valid,last,keep,user=int(rng.randrange(23)==0),rng.randrange(256),rng.randrange(2),int(rng.randrange(5)==0),rng.randrange(2),rng.randrange(2)
        fvalid=0
        if valid:
            state ^= data
            for _ in range(8):
                state=(state>>1)^(0xedb88320 if state&1 else 0)
            if last:
                fcs=state^0xffffffff
                state,fvalid=0xffffffff,1
        if rst:
            state,fcs,fvalid=0xffffffff,0,0
        if index==9:
            assert fcs==0xcbf43926
        vectors.append(dict(cycle=index,rst=rst,data=data,valid=valid,last=last,keep=keep,user=user,expected_fcs=fcs,expected_valid=fvalid))
        tb += [f'#5; clk=0; rst={rst}; data=8\'h{data:02x}; valid={valid}; last={last}; keep={keep}; user={user};',
               '#5; clk=1; #1;',
               f'if(gf !== 32\'h{fcs:08x} || cf !== 32\'h{fcs:08x} || gv !== 1\'b{fvalid} || cv !== 1\'b{fvalid} || gr !== 1\'b1 || cr !== 1\'b1) $fatal(1,"Mismatch at {index}");']
    tb += ['$display("PASS 4096 cycles, reset complete, standard CRC32 check and independent oracle");','$finish;','end','endmodule']
    (folder/'tb.v').write_text('\n'.join(tb)+'\n',encoding='ascii')
    save(folder/'vectors.json',vectors)
    for label,command in [('compile',[str(suite/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','tb.v','both.v']),
                           ('simulation',[str(suite/'bin/vvp.exe'),'sim.vvp'])]:
        p=subprocess.run(command,cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/(label+'.log')).write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError(label+' failed')
    save(folder/'RESULT.json',dict(passed=all(r['passed'] for r in properties.values()),raw_simulation_passed=True,
         cycles=4096,standard_check='cbf43926',first_reset_simultaneous_valid_last=True,
         driver_sha256=sha(Path(__file__)),new_model_calls=0))


if __name__=='__main__':
    main()
