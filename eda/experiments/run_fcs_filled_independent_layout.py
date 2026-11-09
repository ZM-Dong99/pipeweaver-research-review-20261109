"""Independent full-GDS DRC and transistor LVS using a pinned public deck."""
import json
import csv
import re
import os
from pathlib import Path
import subprocess
import time
import xml.etree.ElementTree as ET

from run_fcs_physical import ROOT, TOOLS as ORTOOLS, LIB, OPENROAD, wsl, sha, save

TOOLS=ROOT/'eda/tools/klayout_linux_20261108'
PLATFORM=ROOT/'eda/physical_platforms/sky130hd_independent_aef47dd6'
SOURCE=ROOT/'eda/experiments/fcs_filled_layout_20261108'
OUT=ROOT/'eda/experiments/fcs_filled_independent_layout_20261108'


def main():
    OUT.mkdir(exist_ok=False)
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    assert runtime['status']=='PASS'
    provenance=json.loads((PLATFORM/'PROVENANCE.json').read_text(encoding='utf-8-sig'))
    for entry in provenance['files']:
        assert sha(Path(entry['path']))==entry['sha256']
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    def klayout(args,folder,label,timeout=600):
        cmd=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
             'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',
             wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),'-b',*args]
        started=time.monotonic()
        try:
            p=subprocess.run(cmd,cwd=folder,env=env,capture_output=True,timeout=timeout)
            log=(p.stdout+p.stderr).decode(errors='replace')
            (folder/(label+'.log')).write_text(log,encoding='utf-8')
            return dict(exit_code=p.returncode,elapsed_seconds=round(time.monotonic()-started,3)),log
        except subprocess.TimeoutExpired as exc:
            (folder/(label+'.log')).write_bytes((exc.stdout or b'')+(exc.stderr or b''))
            return dict(status='INCOMPLETE',reason='tool timeout',timeout_seconds=timeout),''
    protocol=dict(driver_sha256=sha(Path(__file__)),merge_driver_sha256=sha(Path(__file__).with_name('merge_fcs_gds.py')),
       runtime_sha256=sha(TOOLS/'RUNTIME.json'),platform=provenance,
       source_protocol_sha256=sha(SOURCE/'protocol.json'),source_verification_sha256=sha(ROOT/'eda/experiments/fcs_reset_cts_pdn_20261107/VERIFICATION.json'),
       inputs={case:dict(def_sha256=sha(SOURCE/case/'detailed.def'),db_sha256=sha(SOURCE/case/'detailed.odb')) for case in ('baseline','optimized')},
       scope='Real standard-cell GDS merged with untouched final DEF routing; independent public KLayout transistor LVS and DRC, not foundry signoff',
       policy='No empty GDS masters, no blackboxing, no disabled rules, no waiver or geometry edits. Exit zero alone does not establish DRC/LVS PASS.',
       deck_limits='Unmodified public ORFS sky130hd decks, coverage limited to these exact decks; no manufacturing certification claim',new_model_calls=0)
    save(OUT/'protocol.json',protocol)
    (OUT/'protocol.sha256').write_text(sha(OUT/'protocol.json')+'\n')
    results={}
    for case in ('baseline','optimized'):
        folder=OUT/case
        folder.mkdir()
        print('Independent layout '+case,flush=True)
        merge,log=klayout(['-rd','out_dir='+wsl(folder),'-rd','in_def='+wsl(SOURCE/case/'detailed.def'),
                           '-r',wsl(Path(__file__).with_name('merge_fcs_gds.py'))],folder,'merge')
        r=dict(merge=merge,drc=dict(status='NOT_RUN'),lvs=dict(status='NOT_RUN'))
        results[case]=r
        if merge.get('exit_code')!=0 or not (folder/'GDS_MERGE.json').is_file():
            save(OUT/'RESULT.json',dict(cases=results,new_model_calls=0))
            print(case+' GDS merge incomplete',flush=True)
            continue
        r['merge']['status']='PASS'
        drc,log=klayout(['-rd','in_gds='+wsl(folder/'design.gds'),'-rd','report_file='+wsl(folder/'drc.lyrdb'),
                         '-r',wsl(PLATFORM/'drc/sky130hd.lydrc')],folder,'drc')
        r['drc']=drc
        if drc.get('exit_code')==0 and (folder/'drc.lyrdb').is_file():
            tree=ET.parse(folder/'drc.lyrdb').getroot()
            items=list(tree.findall('.//items/item'))
            categories={}
            for item in items:
                category=item.findtext('category','UNKNOWN')
                categories[category]=categories.get(category,0)+1
            r['drc'].update(status='PASS' if not items else 'FAIL',violation_items=len(items),categories=categories,
                            report_sha256=sha(folder/'drc.lyrdb'))
        else:
            r['drc']['status']='INCOMPLETE'
        print(case+' DRC '+str(r['drc'].get('status'))+' '+str(r['drc'].get('violation_items')),flush=True)
        ort=json.loads((ORTOOLS/'RUNTIME.json').read_text())
        tcl=folder/'export_cdl.tcl'
        tcl.write_text(f'read_liberty {{{wsl(LIB)}}}\nread_db {{{wsl(SOURCE/case/"detailed.odb")}}}\nwrite_cdl -include_fillers -masters {{{wsl(PLATFORM/"cdl/sky130hd.cdl")}}} reference.cdl\n',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(ort['library_paths']),
                          'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(tcl)],cwd=folder,env=env,capture_output=True,timeout=120)
        (folder/'export_cdl.log').write_bytes(p.stdout+p.stderr)
        if p.returncode==0 and (folder/'reference.cdl').is_file():
            library=(PLATFORM/'cdl/sky130hd.cdl').read_text()
            definitions={m[1]:m[0] for m in re.finditer(r'(?ims)^\.SUBCKT\s+(\S+)[^\n]*\n.*?^\.ENDS[^\n]*(?:\n|$)',library)}
            with (SOURCE/case/'physical_cells.tsv').open() as f:
                used={row['master'] for row in csv.DictReader(f,delimiter='\t')}
            assert not used-set(definitions)
            blocks=[definitions[name] for name in sorted(used)]
            assert not any(re.search(r'(?im)^X',block) for block in blocks)
            (folder/'reference_complete.cdl').write_text('\n'.join(blocks)+'\n'+(folder/'reference.cdl').read_text(),encoding='ascii')
            lvs,log=klayout(['-rd','in_gds='+wsl(folder/'design.gds'),'-rd','report_file='+wsl(folder/'lvs.lvsdb'),
                '-rd','cdl_file='+wsl(folder/'reference_complete.cdl'),'-rd','target_netlist='+wsl(folder/'extracted.cir'),
                '-r',wsl(PLATFORM/'lvs/sky130hd.lylvs')],folder,'lvs')
            r['lvs']=lvs
            if lvs.get('exit_code')==0 and 'INFO : Congratulations! Netlists match.' in log and (folder/'lvs.lvsdb').is_file():
                r['lvs']['status']='PASS'
            elif "ERROR : Netlists don't match" in log:
                r['lvs']['status']='FAIL'
            else:
                r['lvs']['status']='INCOMPLETE'
        else:
            r['lvs']=dict(status='INCOMPLETE',reason='Reference CDL export failed')
        save(folder/'RESULT.json',r)
        save(OUT/'RESULT.json',dict(cases=results,new_model_calls=0))
        print(case+' LVS '+r['lvs']['status'],flush=True)


if __name__=='__main__':
    main()
