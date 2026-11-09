"""Source-backed ordinary-bulk LVS profile on unchanged manufacturing GDS."""
import json
import os
from pathlib import Path
import re
import subprocess

from run_fcs_independent_layout import ROOT, PLATFORM, TOOLS, wsl, sha, save

BASE=ROOT/'eda/experiments/fcs_substrate_basis_20261108'
SOURCE=ROOT/'eda/experiments/fcs_filled_independent_layout_20261108'
OUT=ROOT/'eda/experiments/fcs_bulk_profile_20261108'


def main():
    OUT.mkdir(exist_ok=False)
    source=PLATFORM/'lvs/sky130hd.lylvs'
    text=source.read_text()
    old='connect_global(SUB, "VNB")'
    assert text.count(old)==1
    addition='connect_global(PTAP, "VNB")'
    profile=text.replace(old,old+'\n'+addition)
    profile_file=OUT/'ordinary_bulk.lylvs'
    profile_file.write_text(profile,encoding='utf-8')
    source_records=json.loads((BASE/'SOURCES.json').read_text(encoding='utf-8-sig'))
    for record in source_records:
        assert sha(BASE/'sources'/record['file'])==record['sha256']
    efa=(BASE/'sources/efabless_sky130.lvs').read_text()
    assert 'connect_global(sub  , substrate_name)' in efa and 'connect_global(ptap_conn  , substrate_name)' in efa
    magic=(BASE/'sources/open_pdks_sky130_extract.tech').read_text()
    assert 'substrate *ppdiff,*mvppdiff,space/w,pwell well $SUB -dnwell,isosub' in magic
    protocol=dict(driver_sha256=sha(Path(__file__)),original_deck_sha256=sha(source),profile_sha256=sha(profile_file),
        normalized_diff=dict(after=old,inserted_one_line=addition),independent_sources=source_records,
        profile_scope='Ordinary low-voltage shared bulk, validated against absence of isolation markers; actual p+tap geometry and contact path must connect substrate to ground',
        policy='Unchanged positive GDS and transistor references; no explicit VNB=VSS equivalence, no tolerance/device/net waivers; changes only the declared PTAP global-bulk extraction convention',
        distinction='Original ORFS profile FAIL retained. This new named extraction profile is source-backed engineering qualification, not foundry signoff or a run of the full Efabless deck.',
        guards=['dnwell','substrate_cut','hvi','vhvi','uhvi','pwell_block','npn_id','pnp_id'],new_model_calls=0)
    save(OUT/'protocol.json',protocol)
    (OUT/'protocol.sha256').write_text(sha(OUT/'protocol.json')+'\n')
    runtime=json.loads((TOOLS/'RUNTIME.json').read_text())
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    prefix=['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+':'.join(runtime['library_paths']),
        'RUBYLIB='+runtime['ruby_library_path'],'QT_QPA_PLATFORM=offscreen',wsl(TOOLS/'extracted/usr/lib/klayout/klayout'),'-b']
    def run(folder,label,args):
        p=subprocess.run(prefix+args,cwd=folder,env=env,capture_output=True,timeout=300)
        log=(p.stdout+p.stderr).decode(errors='replace')
        (folder/(label+'.log')).write_text(log,encoding='utf-8')
        return p.returncode,log
    results={}
    for name,case,variant in [('baseline','baseline',None),('optimized','optimized',None),
                              ('no_taps','baseline','no_taps'),('wrong_gate','baseline','wrong_gate'),
                              ('substrate_cut','baseline','substrate_cut')]:
        folder=OUT/name
        folder.mkdir()
        gds=SOURCE/case/'design.gds'
        if variant in ('no_taps','substrate_cut'):
            code,_=run(folder,'negative_geometry',['-rd','in_gds='+wsl(gds),'-rd','out_gds='+wsl(folder/'negative.gds'),
                '-rd','variant='+variant,'-r',wsl(Path(__file__).with_name('fcs_bulk_profile_negative.py'))])
            assert code==0
            gds=folder/'negative.gds'
        code,_=run(folder,'preflight',['-rd','in_gds='+wsl(gds),'-rd','out_json='+wsl(folder/'PREFLIGHT.json'),
              '-r',wsl(Path(__file__).with_name('fcs_bulk_profile_preflight.py'))])
        assert code==0
        preflight=json.loads((folder/'PREFLIGHT.json').read_text())
        expected='REJECT_UNSUPPORTED' if variant=='substrate_cut' else ('FAIL' if variant else 'PASS')
        reference=SOURCE/case/'reference_complete.cdl'
        if not preflight['supported']:
            status='REJECT_UNSUPPORTED'
            code=None
        else:
            if variant=='wrong_gate':
                contents=reference.read_text()
                selected=next(m for m in re.finditer(r'(?im)^X_[^\n]*(?:\n\+[^\n]*)*',contents) if '__conb_' not in m[0])
                (folder/'bad_reference.cdl').write_text(contents[:selected.start()]+contents[selected.end():],encoding='ascii')
                reference=folder/'bad_reference.cdl'
            code,log=run(folder,'lvs',['-rd','in_gds='+wsl(gds),'-rd','cdl_file='+wsl(reference),
                 '-rd','report_file='+wsl(folder/'lvs.lvsdb'),'-rd','target_netlist='+wsl(folder/'extracted.cir'),'-r',wsl(profile_file)])
            status='PASS' if code==0 and 'INFO : Congratulations! Netlists match.' in log else ('FAIL' if "ERROR : Netlists don't match" in log else 'INCOMPLETE')
        results[name]=dict(status=status,expected=expected,as_expected=status==expected,tool_exit_code=code,
            gds_sha256=sha(gds),reference_sha256=sha(reference),supported=preflight['supported'],lvs_run=code is not None)
        save(folder/'RESULT.json',results[name])
        save(OUT/'RESULT.json',dict(all_as_expected=all(v['as_expected'] for v in results.values()),cases=results,
            source_backed_profile=True,unmodified_orfs_deck_pass=False,full_foundry_signoff=False,new_model_calls=0))
        print(name+' ordinary-bulk profile '+status+' expected '+expected,flush=True)


if __name__=='__main__':
    main()
