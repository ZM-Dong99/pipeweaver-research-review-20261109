"""Bounded, unauthenticated HTTPS probes; never invokes model inference."""
import concurrent.futures
import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess


def main():
    root = Path(__file__).resolve().parents[2]
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d_%H%M%S_%f')
    out = root / 'eda' / 'experiments' / ('gateway_connectivity_' + stamp)
    out.mkdir()
    curl = shutil.which('curl.exe') or shutil.which('curl')
    if not curl:
        raise SystemExit('curl unavailable')
    env = os.environ.copy()
    for name in list(env):
        if name.upper() in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY'):
            env.pop(name)
    specs = [('gateway_models', 'https://apinebula.ai/v1/models'),
             ('gateway_root', 'https://apinebula.ai/'),
             ('independent_control', 'https://curl.se/')]
    protocol = dict(timestamp_utc=stamp, inference_requests=0,
                    authentication=False, request_body=False, redirects=False,
                    certificate_verification=True, automatic_retries=0,
                    connect_timeout_seconds=10, total_timeout_seconds=25,
                    probes=[dict(name=n, url=u) for n, u in specs],
                    curl_path=curl, curl_sha256=hashlib.sha256(Path(curl).read_bytes()).hexdigest(),
                    script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                    proxy_environment_configured={n: bool(os.environ.get(n) or os.environ.get(n.lower()))
                                                  for n in ('HTTP_PROXY','HTTPS_PROXY','ALL_PROXY','NO_PROXY')})
    (out / 'protocol.json').write_text(json.dumps(protocol, indent=2), encoding='utf-8')
    def probe(spec):
        name, url = spec
        cmd = [curl, '-q', '--silent', '--show-error', '--proto', '=https',
               '--connect-timeout', '10', '--max-time', '25', '--retry', '0',
               '--output', os.devnull, '--write-out', '%{json}', url]
        result = dict(name=name, url=url)
        try:
            p = subprocess.run(cmd, capture_output=True, text=True, env=env,
                               timeout=30, creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
            result['exit_code'] = p.returncode
            try:
                raw = json.loads(p.stdout)
                for key in ('http_code','http_version','ssl_verify_result','time_namelookup',
                            'time_connect','time_appconnect','time_starttransfer','time_total','size_download'):
                    result[key] = raw.get(key)
            except (ValueError, TypeError):
                result['metrics_parse_failed'] = True
        except subprocess.TimeoutExpired:
            result['outer_timeout'] = True
        return result
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
        results = list(pool.map(probe, specs))
    report = dict(inference_requests=0, results=results,
                  curl_version=subprocess.run([curl,'--version'], capture_output=True, text=True,
                                              env=env, timeout=5).stdout.strip())
    (out / 'RESULT.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps(dict(output_directory=str(out), **report), indent=2))


if __name__ == '__main__':
    main()
