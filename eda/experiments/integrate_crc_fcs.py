"""Fixed 8-bit upstream Ethernet FCS integration, without model requests."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'benchmark/ethernet_fcs_integration_20261107'
OUT = ROOT / 'eda/experiments/ethernet_fcs_integration_20261107_safe_names'
BEST = ROOT / 'eda/experiments/crc_feedback_20_20261107_ready/exports/best.v'
RUNNER = Path(__file__).with_name('run_native_seq_initialized.py')


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def save(p, value):
    p.write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')


def main():
    OUT.mkdir(exist_ok=False)
    provenance = json.loads((SOURCE/'PROVENANCE.json').read_text(encoding='utf-8-sig'))
    for entry in provenance['files']:
        assert sha(Path(entry['path'])) == entry['sha256']
    top = (SOURCE/'rtl/axis_eth_fcs.v').read_text()
    pattern = r'lfsr #\([\s\S]*?\)\s*eth_crc_inst'
    candidate, count = re.subn(pattern, 'crc32_d8 eth_crc_inst', top)
    assert count == 1
    cases = {
        'baseline': top + '\n' + (SOURCE/'rtl/lfsr.v').read_text(),
        'optimized': candidate + '\n' + BEST.read_text(),
        'negative_output': re.sub(r'assign output_fcs = fcs_reg;',
                                 "assign output_fcs = fcs_reg ^ 32'h1;", candidate) + '\n' + BEST.read_text(),
    }
    for name, text in cases.items():
        folder = OUT/name
        folder.mkdir()
        (folder/'source.v').write_text(text, encoding='utf-8')
    save(OUT/'protocol.json', dict(
        upstream=provenance, candidate_origin=str(BEST), candidate_sha256=sha(BEST),
        driver_sha256=sha(Path(__file__)), runner_sha256=sha(RUNNER),
        sources={name:sha(OUT/name/'source.v') for name in cases},
        top='axis_eth_fcs', parameters={'DATA_WIDTH':8,'KEEP_ENABLE':0,'KEEP_WIDTH':1},
        specialization='Upstream default parameters only; other widths unsupported by this integration',
        scope='Full top-level output equality every sampled cycle; no output masking or latency changes',
        state_policy='Preserve upstream logical RTL init attributes. Reset asserted first sample, arbitrary afterwards. Not physical power-up verification.',
        period_ns=10, area_cap_ratio=1.1, decision='Both proofs, STA and electrical PASS; area <= 110% fresh baseline; WNS strictly improves; TNS does not regress',
        negative_control='Flip output_fcs bit 0; must yield an actual source-level base-case counterexample',
        mapping='Same existing initialized sequential runner for baseline and candidate; expand clock enables',
        name_normalization='Yosys rename -unescape on internal objects in both arms; ports and logical init preserved',
        model_calls=0))
    (OUT/'protocol.sha256').write_text(sha(OUT/'protocol.json')+'\n')
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key, None)
    yosys = Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    for name in cases:
        folder = OUT/name
        script = folder/'frontend.ys'
        script.write_text('read_slang --top axis_eth_fcs source.v\nhierarchy -check -top axis_eth_fcs\nproc\nflatten\nopt\nrename -unescape\ncheck -assert\nwrite_json elaborated.json\nwrite_verilog elaborated.v\n')
        p = subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=90)
        (folder/'frontend.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Frontend failure: '+name)
    results = {}
    for name in cases:
        print('Evaluating '+name, flush=True)
        folder = OUT/name
        command = [sys.executable,'-B',str(RUNNER),str(folder/'elaborated.v'),
                   '--reference',str(OUT/'baseline/elaborated.v'),'--top','axis_eth_fcs',
                   '--clock','clk','--reset','rst','--warmup','1','--out',str(folder/'evaluation'),
                   '--initial-state-policy','rtl-declared','--prove-state-invariants',
                   '--unmap-clock-enables','--timeout','120']
        p = subprocess.run(command,cwd=ROOT,env=env,capture_output=True,timeout=900)
        (folder/'evaluation_driver.log').write_bytes(p.stdout+p.stderr)
        results[name] = json.loads((folder/'evaluation/result.json').read_text())
        save(OUT/'PROGRESS.json',results)
        print(json.dumps(dict(case=name,**results[name])),flush=True)
    baseline, optimized, negative = [results[k] for k in cases]
    qualified = all(r.get('status')=='PASS' and r.get('formal')=='PASS' and
                    r.get('mapped_formal')=='PASS' and r.get('ppa')=='PASS' and
                    r.get('electrical',{}).get('status')=='PASS' for r in (baseline,optimized))
    improvement = (qualified and optimized['mapped_area_um2'] <= 1.1*baseline['mapped_area_um2']
                   and optimized['wns_ns'] > baseline['wns_ns'] and optimized['tns_ns'] >= baseline['tns_ns'])
    save(OUT/'RESULT.json',dict(results=results,qualified=qualified,valid_timing_improvement=improvement,
                              negative_control_passed=negative.get('formal')=='FAIL',model_calls=0,
                              logical_initialization_only=True))
    return 0


if __name__ == '__main__':
    sys.exit(main())
