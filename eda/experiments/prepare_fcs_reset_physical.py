"""Prepare only qualified reset-complete mapped netlists for fresh physical flow."""
import json
import os
from pathlib import Path
import shutil
import subprocess

from qualify_fcs_reset_complete import OUT, TOP, ROOT, sha, save
from run_fcs_physical import LIB


def main():
    out=OUT/'physical_inputs'
    out.mkdir(exist_ok=False)
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    yosys=Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    records={}
    for case in ('baseline','optimized'):
        evaluation=OUT/case/'evaluation'
        result=json.loads((evaluation/'result.json').read_text())
        assert all(result[k]=='PASS' for k in ('status','formal','mapped_formal','ppa'))
        assert result['electrical']['status']=='PASS'
        module=json.loads((evaluation/'mapped.json').read_text())['modules'][TOP]
        assert not any('init' in net.get('attributes',{}) for net in module['netnames'].values())
        assert sha(evaluation/'mapped.v')==result['mapped_sha256']
        folder=out/case
        folder.mkdir()
        shutil.copyfile(evaluation/'timing.sdc',folder/'timing.sdc')
        script=folder/'prepare.ys'
        script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog "{(evaluation/"mapped.v").as_posix()}"\nhierarchy -check -top {TOP}\nhilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO\nclean\nwrite_json prepared.json\nwrite_verilog -noattr prepared.v\n')
        p=subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=60)
        (folder/'prepare.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Physical preparation failed')
        records[case]=dict(proved_mapped_sha256=result['mapped_sha256'],prepared_sha256=sha(folder/'prepared.v'),sdc_sha256=sha(folder/'timing.sdc'))
    save(out/'protocol.json',dict(top=TOP,reset_qualification_protocol_sha256=sha(OUT/'protocol.json'),
         driver_sha256=sha(Path(__file__)),liberty_sha256=sha(LIB),cases=records,
         scope='Fresh physical inputs for reset-complete variant; no initialization assumptions; insert only constants',new_model_calls=0))
    print('Prepared both reset-complete physical inputs')


if __name__=='__main__':
    main()
