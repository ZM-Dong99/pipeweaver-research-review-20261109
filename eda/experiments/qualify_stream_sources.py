"""Acquire fixed public streaming RTL and qualify three frozen native instances; no API."""
import argparse
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
COMMIT = '48ff7a7e2ef782cf778d47910cf85835c64b1bce'
RUNNER = ROOT / 'eda/experiments/run_native_seq.py'
BASE = ROOT / 'benchmark/engineering_sources_20261106'
FILES = ('axis_register.v', 'axis_adapter.v', 'axis_fifo.v')
CASES = (
    dict(id='stream_skid32', file='axis_register.v', top='axis_register', family='stream_elastic_buffer', parameters={'DATA_WIDTH':32, 'REG_TYPE':2}),
    dict(id='stream_pack8to32', file='axis_adapter.v', top='axis_adapter', family='stream_width_conversion', parameters={'S_DATA_WIDTH':8,'M_DATA_WIDTH':32}),
    dict(id='stream_fifo4x8', file='axis_fifo.v', top='axis_fifo', family='stream_fifo_storage', parameters={'DEPTH':4,'DATA_WIDTH':8}),
)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def save(p, d):
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False), encoding='utf-8')


def fetch():
    BASE.mkdir(parents=True, exist_ok=True)
    if (BASE / 'PROVENANCE.json').exists():
        raise RuntimeError('Completed source collection already exists; refusing overwrite')
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key, None)
    curl = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    if not curl:
        raise RuntimeError('curl required')
    lock = dict(repository='https://github.com/alexforencich/verilog-axis', commit=COMMIT,
                files=list(FILES), reason='Expand natural functional coverage before any new model generation; not three independent model samples', model_requests=0)
    if (BASE / 'SOURCE_LOCK.json').exists() and load(BASE / 'SOURCE_LOCK.json') != lock:
        raise RuntimeError('Interrupted source selection changed')
    save(BASE / 'SOURCE_LOCK.json', lock)
    rows = []
    for name in FILES:
        url = f'https://raw.githubusercontent.com/alexforencich/verilog-axis/{COMMIT}/rtl/{name}'
        p = BASE / name
        result = subprocess.run([curl, '-q', '--fail', '--silent', '--show-error', '--proto', '=https', '--retry', '0',
                                 '--max-time', '60', '--output', str(p), url], env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=70)
        if result.returncode:
            (BASE / (name + '.download_error.log')).write_bytes(result.stderr)
            raise RuntimeError('Public source download failed: ' + name)
        rows.append(dict(file=name, url=url, sha256=sha(p), bytes=p.stat().st_size, physical_lines=len(p.read_text(encoding='utf-8').splitlines())))
    old = ROOT / 'benchmark/engineering_sources_20261030/verilog-axis'
    for name in ('COPYING','README.md'):
        shutil.copyfile(old / name, BASE / name)
        rows.append(dict(file=name, url=f'https://raw.githubusercontent.com/alexforencich/verilog-axis/{COMMIT}/{name}', sha256=sha(BASE/name), copied_from_same_pinned_repository=True))
    save(BASE / 'PROVENANCE.json', dict(files=rows, unmodified_upstream_sources=True, model_requests=0))
    print('Pinned public sources acquired: ' + str(BASE), flush=True)


def execute(out):
    for row in load(BASE / 'PROVENANCE.json')['files']:
        if sha(BASE / row['file']) != row['sha256']:
            raise RuntimeError('Pinned source changed')
    out.mkdir(parents=True, exist_ok=False)
    snap = out / 'code_snapshot'
    snap.mkdir()
    deps = [Path(__file__), RUNNER, RUNNER.with_name('run_native_comb.py'), RUNNER.with_name('trace_sta_rtl_cone.py')]
    for p in deps:
        shutil.copyfile(p, snap / p.name)
    protocol = dict(created_at=datetime.now().astimezone().isoformat(), cases=CASES, clock='clk', reset='rst', reset_active=1,
        reset_cycles=1, warmup=1, period_ns=10, timeout_per_tool_seconds=120,
        no_input_restrictions='All input pins arbitrary after startup; ready/valid protocol not assumed. Require strict cycle-by-cycle equality of all outputs, even when valid=0.',
        mapping='Existing full flat sequential backend, not the synthetic block-fixed mapping experiment',
        purpose='Native baseline qualification only, no optimization or model comparison', model_requests=0,
        provenance_sha256=sha(BASE/'PROVENANCE.json'), sources={n:sha(BASE/n) for n in FILES},
        dependency_sha256={str(p.resolve().relative_to(ROOT)):sha(p) for p in deps},
        failure_policy='Keep all unsupported/memory/timeout/electrical failures, do not change RTL or warmup to obtain a pass',
        caveat='Source self-comparison is infrastructure sanity; mapped-to-source proof separately checks actual synthesis. This does not establish AXI compliance, transaction-only equivalence, CDC or physical signoff.')
    save(out / 'protocol.json', protocol)
    (out/'protocol.sha256').write_text(sha(out/'protocol.json')+'\n',encoding='ascii')
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    results = []
    for case in CASES:
        for rel,h in protocol['dependency_sha256'].items():
            if sha(ROOT/rel)!=h:raise RuntimeError('Frozen code changed')
        cmd=[sys.executable,'-B',str(RUNNER),str(BASE/case['file']),'--reference',str(BASE/case['file']),
             '--top',case['top'],'--clock','clk','--reset','rst','--out',str(out/case['id']),'--timeout','120']
        for key,value in case['parameters'].items():cmd+=['--param',f'{key}={value}']
        try:
            proc=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900)
            raw=proc.stdout
        except subprocess.TimeoutExpired as exc:
            raw=(exc.stdout or b'')+b'\nOVERALL TIMEOUT\n'
        (out/(case['id']+'_runner.log')).write_bytes(raw)
        p=out/case['id']/'result.json'
        m=load(p) if p.exists() else dict(status='INCOMPLETE',failure_reason='No result')
        results.append(dict(case=case,result=m))
        save(out/'SUMMARY.json',dict(results=results,model_requests=0,purpose=protocol['purpose']))
        print(case['id']+': '+m['status']+' '+m.get('failure_reason',''),flush=True)
    lines=['# 新增自然工程流处理模块基线资格','', '零模型请求。三个功能类别来自同一公开仓库，不等于三个模型样本，也不构成独立盲测。', '',
           '| 模块 | 功能 | 状态 | WNS ns | 面积um² |', '|---|---|---|---:|---:|']
    for r in results:
        c,m=r['case'],r['result'];lines.append(f"| {c['top']} | {c['family']} | {m['status']} | {m.get('wns_ns','—')} | {m.get('mapped_area_um2','—')} |")
    lines+=['','基线资格通过不等于优化收益。失败、固定参数、复位和任意输入契约详见protocol.json及逐模块result.json。未放宽面积、电气或功能要求，也未修改源RTL。']
    (out/'SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    mode=ap.add_mutually_exclusive_group(required=True)
    mode.add_argument('--fetch',action='store_true')
    mode.add_argument('--out',type=Path)
    a=ap.parse_args()
    if a.fetch:fetch()
    else:execute(a.out.resolve())


if __name__=='__main__':main()
