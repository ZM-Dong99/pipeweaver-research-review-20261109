"""Independent raw-RTL simulation and fresh EDA reruns of fixed byte FCS."""
import json
import os
from pathlib import Path
import random
import subprocess
import sys

from integrate_crc_fcs import OUT, ROOT, RUNNER, sha, save


def main():
    folder = OUT/'independent_verification'
    folder.mkdir(exist_ok=False)
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key, None)
    suite = Path('D:/oss-cad-suite')
    env['PATH'] = str(suite/'bin')+os.pathsep+str(suite/'lib')+os.pathsep+env.get('PATH','')
    # Compile actual raw source, not the Yosys-generated netlist.
    texts = []
    for name, renamed in [('baseline','gold_fcs'),('optimized','opt_fcs')]:
        source = (OUT/name/'source.v').read_text()
        assert source.count('module axis_eth_fcs #') == 1
        texts.append(source.replace('module axis_eth_fcs #','module '+renamed+' #',1))
    (folder/'both.v').write_text('\n'.join(texts),encoding='utf-8')
    ports = '.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),'
    tb = ['module tb;', 'reg clk=0; reg rst=0; reg [7:0] data=0; reg keep=0,valid=0,last=0,user=0;',
          'wire [31:0] gf,cf; wire gv,cv,gr,cr;',
          'gold_fcs gold('+ports+'.output_fcs(gf),.output_fcs_valid(gv),.s_axis_tready(gr));',
          'opt_fcs cand('+ports+'.output_fcs(cf),.output_fcs_valid(cv),.s_axis_tready(cr));',
          'initial begin']
    rng = random.Random(20261107)
    state, fcs = 0xffffffff, 0
    vectors = []
    # First nine bytes form the standard CRC32 check message, then exercise
    # stalls, ignored keep/user, frame ends and repeated arbitrary reset.
    for index in range(2048):
        if index == 0:
            rst,data,valid,last,keep,user = 1,0,0,0,1,0
        elif index <= 9:
            rst,data,valid,last,keep,user = 0,b'123456789'[index-1],1,int(index==9),1,0
        else:
            rst = int(rng.randrange(31)==0)
            data,valid,last,keep,user = rng.randrange(256),rng.randrange(2),int(rng.randrange(7)==0),rng.randrange(2),rng.randrange(2)
        fvalid = 0
        if valid:
            next_state = state ^ data
            for _ in range(8):
                next_state = (next_state >> 1) ^ (0xedb88320 if next_state & 1 else 0)
            state = next_state
            if last:
                fcs = next_state ^ 0xffffffff
                state, fvalid = 0xffffffff, 1
        # Upstream reset clears state and validity, but does not override a
        # simultaneous frame-end write to fcs_reg. Compare that behavior too.
        if rst:
            state, fvalid = 0xffffffff, 0
        if index == 9:
            assert fcs == 0xcbf43926
        vectors.append(dict(cycle=index,rst=rst,data=data,valid=valid,last=last,keep=keep,user=user,fcs=fcs,fcs_valid=fvalid))
        tb += [f'#5; clk=0; rst={rst}; data=8\'h{data:02x}; valid={valid}; last={last}; keep={keep}; user={user};',
               '#5; clk=1; #1;',
               f'if (gf !== 32\'h{fcs:08x} || cf !== 32\'h{fcs:08x} || gv !== 1\'b{fvalid} || cv !== 1\'b{fvalid} || gr !== 1\'b1 || cr !== 1\'b1) $fatal(1,"Mismatch at cycle {index}");']
    tb += ['$display("PASS 2048 cycles, raw baseline and optimized vs independent bitserial oracle");','$finish;','end','endmodule']
    (folder/'tb.v').write_text('\n'.join(tb)+'\n',encoding='ascii')
    save(folder/'vectors.json',vectors)
    for label,command in [('compile',[str(suite/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','tb.v','both.v']),
                          ('simulation',[str(suite/'bin/vvp.exe'),'sim.vvp'])]:
        p = subprocess.run(command,cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/(label+'.log')).write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError(label+' failed; inspect log')
    comparisons = {}
    for name in ('baseline','optimized'):
        command = [sys.executable,'-B',str(RUNNER),str(OUT/name/'elaborated.v'),
                   '--reference',str(OUT/'baseline/elaborated.v'),'--top','axis_eth_fcs',
                   '--clock','clk','--reset','rst','--warmup','1','--out',str(folder/name),
                   '--initial-state-policy','rtl-declared','--prove-state-invariants',
                   '--unmap-clock-enables','--timeout','120']
        p = subprocess.run(command,cwd=ROOT,env=env,capture_output=True,timeout=900)
        (folder/(name+'_driver.log')).write_bytes(p.stdout+p.stderr)
        old = json.loads((OUT/name/'evaluation/result.json').read_text())
        new = json.loads((folder/name/'result.json').read_text())
        comparisons[name] = {k:old.get(k)==new.get(k) for k in ('status','formal','mapped_formal','ppa','electrical','wns_ns','tns_ns','mapped_area_um2','mapped_cells','mapped_sha256','sdc_sha256')}
        print(name+' reproduced: '+str(all(comparisons[name].values())),flush=True)
    save(folder/'RESULT.json',dict(passed=all(all(v.values()) for v in comparisons.values()),
         raw_simulation_passed=True,cycles=2048,standard_check_value='cbf43926',
         comparisons=comparisons,driver_sha256=sha(Path(__file__)),model_calls=0))


if __name__ == '__main__':
    main()
