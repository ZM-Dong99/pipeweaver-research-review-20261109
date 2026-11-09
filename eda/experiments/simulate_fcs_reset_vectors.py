"""Replay the frozen reset/CRC vectors using a compact Icarus testbench."""
import json
import os
from pathlib import Path
import shutil
import subprocess

from qualify_fcs_reset_complete import OUT, sha, save


def main():
    folder=OUT/'independent_contract'
    vectors=json.loads((folder/'vectors.json').read_text())
    assert len(vectors)==4096
    if not (folder/'tb_inline_first.v').exists():
        shutil.copyfile(folder/'tb.v',folder/'tb_inline_first.v')
        shutil.copyfile(folder/'compile.log',folder/'compile_first.log')
    lines=[]
    for v in vectors:
        word=(v['rst']<<45)|(v['data']<<37)|(v['valid']<<36)|(v['last']<<35)|(v['keep']<<34)|(v['user']<<33)|(v['expected_fcs']<<1)|v['expected_valid']
        lines.append(f'{word:012x}')
    (folder/'vectors.hex').write_text('\n'.join(lines)+'\n',encoding='ascii')
    tb='''`timescale 1ns/1ps
module tb;
reg clk=0,rst=0; reg [7:0] data=0; reg keep=0,valid=0,last=0,user=0;
wire [31:0] gf,cf; wire gv,cv,gr,cr;
reg [45:0] vectors[0:4095]; reg [31:0] expected; reg expected_valid; integer i;
gold_fcs gold(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(gf),.output_fcs_valid(gv),.s_axis_tready(gr));
opt_fcs cand(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(cf),.output_fcs_valid(cv),.s_axis_tready(cr));
initial begin
  $readmemh("vectors.hex",vectors);
  for(i=0;i<4096;i=i+1) begin
    #5; clk=0; {rst,data,valid,last,keep,user,expected,expected_valid}=vectors[i];
    #5; clk=1; #1;
    if(gf !== expected || cf !== expected || gv !== expected_valid || cv !== expected_valid || gr !== 1'b1 || cr !== 1'b1) $fatal(1,"Mismatch at %0d",i);
  end
  $display("PASS 4096 cycles, reset complete, standard CRC32 check and independent oracle");
  $finish;
end
endmodule
'''
    (folder/'tb.v').write_text(tb,encoding='ascii')
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    suite=Path('D:/oss-cad-suite')
    env['PATH']=str(suite/'bin')+os.pathsep+str(suite/'lib')+os.pathsep+env.get('PATH','')
    checks={}
    for label,command in [('compile',[str(suite/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','tb.v','both.v']),
                           ('simulation',[str(suite/'bin/vvp.exe'),'sim.vvp'])]:
        p=subprocess.run(command,cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/(label+'.log')).write_bytes(p.stdout+p.stderr)
        checks[label]=p.returncode==0
        if p.returncode:
            raise RuntimeError(label+' failed '+str(p.returncode))
    checks['all_cycles_reported']='PASS 4096 cycles' in (folder/'simulation.log').read_text()
    checks['standard_crc_value']=vectors[9]['expected_fcs']==0xcbf43926
    checks['reset_overrides_simultaneous_frame_end']=all(vectors[0][k]==1 for k in ('rst','valid','last')) and vectors[0]['expected_fcs']==0
    save(folder/'SIMULATION.json',dict(passed=all(checks.values()),checks=checks,cycles=4096,
         raw_source_sha256=sha(folder/'both.v'),vectors_sha256=sha(folder/'vectors.json'),
         driver_sha256=sha(Path(__file__)),scope='Same frozen vectors and raw RTL; compact loop avoids native compiler crash on long inline statements',new_model_calls=0))
    print('Independent raw RTL simulation: '+str(all(checks.values())))


if __name__=='__main__':
    main()
