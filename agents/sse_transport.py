"""Separate, opt-in Chat Completions SSE transport. No CLI or automatic retries.

Offline acceptance does not establish any gateway's streaming support. This does
not modify the transport used by frozen experiments or authorize new API calls.
"""
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import time
from urllib.parse import urlsplit

from agents.rtl_optimizer import LLMGenerationError


class StreamError(LLMGenerationError):
    pass


def parse_completion_stream(raw: bytes) -> dict:
    """Require fully dispatched events, one choice, stop, then [DONE].

    This deliberately stricter completion policy rejects truncated generation.
    SSE comments/heartbeats and multiline data follow the WHATWG framing rules.
    Provider reasoning fields are ignored and never copied into the result.
    """
    if len(raw) > 64 * 1024 * 1024:
        raise StreamError('Stream exceeds 64 MiB limit')
    try:
        text = raw.decode('utf-8-sig')
    except UnicodeError:
        raise StreamError('Invalid stream UTF-8') from None
    lines = re.split(r'\r\n|\r|\n', text)
    if lines[-1]:
        raise StreamError('Unterminated SSE line')
    data, event = [], ''
    content, metadata, usage = [], {}, None
    stopped = done = False
    event_count = 0
    for line in lines[:-1]:
        if line:
            if line.startswith(':'):
                continue
            field, sep, value = line.partition(':')
            if value.startswith(' '):
                value = value[1:]
            if field == 'data':
                data.append(value if sep else '')
            elif field == 'event':
                event = value
            continue
        if not data:
            event = ''
            continue
        payload = '\n'.join(data)
        data = []
        if done:
            raise StreamError('Data after stream terminator')
        if event not in ('', 'message'):
            raise StreamError('Unsupported or error SSE event')
        event = ''
        if payload == '[DONE]':
            if not stopped:
                raise StreamError('Terminator before normal completion')
            done = True
            continue
        try:
            def unique(pairs):
                result = {}
                for key, value in pairs:
                    if key in result:
                        raise ValueError('Duplicate key')
                    result[key] = value
                return result
            def invalid_constant(value):
                raise ValueError('Nonfinite JSON')
            obj = json.loads(payload, object_pairs_hook=unique, parse_constant=invalid_constant)
        except ValueError:
            raise StreamError('Invalid stream event JSON') from None
        if not isinstance(obj, dict) or 'error' in obj:
            raise StreamError('Provider returned stream error or invalid envelope')
        event_count += 1
        for key in ('id', 'model', 'created', 'system_fingerprint'):
            if key in obj:
                value = obj[key]
                if ((key == 'created' and (type(value) is not int or value < 0))
                        or (key in ('id', 'model') and (not isinstance(value, str) or not value))
                        or (key == 'system_fingerprint' and value is not None and not isinstance(value, str))):
                    raise StreamError('Invalid stream metadata')
                if key in metadata and metadata[key] != obj[key]:
                    raise StreamError('Stream identity changed')
                metadata[key] = obj[key]
        choices = obj.get('choices')
        if not isinstance(choices, list):
            raise StreamError('Stream choices must be a list')
        if obj.get('usage') is not None:
            u = obj['usage']
            if usage is not None or not isinstance(u, dict):
                raise StreamError('Invalid or duplicate usage event')
            usage = {}
            for key in ('prompt_tokens', 'completion_tokens', 'total_tokens'):
                if key in u:
                    if type(u[key]) is not int or u[key] < 0:
                        raise StreamError('Invalid token usage')
                    usage[key] = u[key]
        if not choices:
            if not stopped or obj.get('usage') is None:
                raise StreamError('Unexpected empty choices')
            continue
        if stopped or len(choices) != 1:
            raise StreamError('Unexpected additional choice')
        choice = choices[0]
        if not isinstance(choice, dict) or type(choice.get('index')) is not int or choice['index'] != 0:
            raise StreamError('Expected choice zero')
        delta = choice.get('delta')
        if not isinstance(delta, dict):
            raise StreamError('Invalid stream delta')
        if delta.get('role', 'assistant') != 'assistant':
            raise StreamError('Unexpected message role')
        if any(delta.get(k) for k in ('tool_calls', 'function_call', 'refusal')):
            raise StreamError('Non-text completion is unsupported')
        value = delta.get('content')
        if value is not None:
            if not isinstance(value, str):
                raise StreamError('Content delta must be text')
            content.append(value)
        reason = choice.get('finish_reason')
        if reason is not None:
            if reason != 'stop':
                raise StreamError('Completion did not finish normally')
            stopped = True
    if data or not done or not ''.join(content).strip():
        raise StreamError('Incomplete or empty completion stream')
    return {**metadata, 'object': 'chat.completion',
            'choices': [{'index': 0, 'finish_reason': 'stop',
                         'message': {'role': 'assistant', 'content': ''.join(content)}}],
            'usage': usage, 'stream_audit': {'complete': True, 'json_events': event_count,
                                           'usage_reported': usage is not None}}


def curl_completion_stream(*, endpoint: str, body: dict, api_key: str,
                           audit_dir: Path, timeout_s: int = 180) -> dict:
    """One paid-capable attempt; caller must obtain authorization/budget first.

    No default selection, retry, redirects, or insecure TLS mode. curl receives
    events while the request runs; parsing is after transfer, not a live UI.
    Raw events (possibly provider reasoning) exist only in temporary storage.
    Failure audits keep a byte count/hash, never stderr or a partial candidate.
    """
    url = urlsplit(endpoint)
    if (url.scheme != 'https' or not url.hostname or url.username or url.password
            or url.query or url.fragment or not url.path.endswith('/chat/completions')):
        raise StreamError('Expected HTTPS chat completions endpoint without credentials or query')
    if not api_key or any(c in api_key for c in ('\r', '\n', '\x00')):
        raise StreamError('Invalid API key')
    if type(timeout_s) is not int or not 1 <= timeout_s <= 600:
        raise StreamError('Timeout must be 1 through 600 seconds')
    if not isinstance(body, dict) or body.get('stream') is not True or body.get('n', 1) != 1:
        raise StreamError('Explicit stream=true and one choice required')
    request_bytes = json.dumps(body, ensure_ascii=False, allow_nan=False).encode('utf-8')
    executable = shutil.which('curl.exe' if os.name == 'nt' else 'curl')
    if not executable:
        raise StreamError('curl executable unavailable')
    audit_dir = Path(audit_dir)
    audit_dir.mkdir(parents=True, exist_ok=False)
    def save(name, value):
        (audit_dir / name).write_text(json.dumps(value, ensure_ascii=False, indent=2,
                                               allow_nan=False), encoding='utf-8')
    save('request.json', {'endpoint': endpoint, 'body': body, 'credentials': 'omitted'})
    # This marker is written before any possible transmission. Never resume it.
    save('attempt.json', {'attempted': True, 'automatic_retries': 0,
                         'timestamp_unix': time.time(), 'transport': 'curl-sse-v1'})
    env = os.environ.copy()
    for name in list(env):
        if name.upper() in ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY'):
            env.pop(name)
    escaped = api_key.replace('\\', '\\\\').replace('"', '\\"')
    config = f'header = "Authorization: Bearer {escaped}"\n'.encode('utf-8')
    report = {'transport': 'curl-sse-v1', 'complete': False, 'retry_count': 0}
    start = time.monotonic()
    try:
        with tempfile.TemporaryDirectory(prefix='transfer_', dir=audit_dir) as tmp:
            folder = Path(tmp)
            request = folder / 'body.json'
            response = folder / 'events.sse'
            request.write_bytes(request_bytes)
            command = [executable, '-q', '--config', '-', '--silent', '--show-error',
                       '--no-buffer', '--proto', '=https', '--request', 'POST',
                       '--url', endpoint, '--header', 'Content-Type: application/json',
                       '--header', 'Accept: text/event-stream', '--output', str(response),
                       '--data-binary', '@' + str(request), '--max-filesize', str(64 * 1024 * 1024),
                       '--connect-timeout', str(min(30, timeout_s)), '--max-time', str(timeout_s),
                       '--retry', '0', '--write-out',
                       '%{http_code}|%{time_connect}|%{time_starttransfer}|%{time_total}|%{content_type}']
            try:
                proc = subprocess.run(command, input=config, env=env, capture_output=True,
                                      timeout=timeout_s + 10,
                                      creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
            except subprocess.TimeoutExpired:
                report['client_timeout'] = True
                raise StreamError('Stream transport timed out; no automatic retry') from None
            finally:
                if response.exists():
                    raw = response.read_bytes()
                    report.update(response_bytes=len(raw), response_sha256=hashlib.sha256(raw).hexdigest())
            report['exit_code'] = proc.returncode
            parts = proc.stdout.decode('ascii', errors='replace').strip().split('|')
            status = int(parts[0]) if parts[0].isdigit() else None
            report['http_status'] = status
            for index, key in enumerate(('connect_seconds', 'first_byte_seconds', 'total_seconds'), 1):
                try:
                    value = float(parts[index])
                    report[key] = value if math.isfinite(value) and value >= 0 else None
                except (IndexError, ValueError):
                    report[key] = None
            if proc.returncode:
                raise StreamError(f'Stream transport failed (exit {proc.returncode}); no automatic retry')
            if status is None or not 200 <= status < 300:
                raise StreamError(f'Stream API returned HTTP {status}')
            if len(parts) != 5 or parts[4].split(';', 1)[0].strip().lower() != 'text/event-stream':
                raise StreamError('Expected text/event-stream response')
            if not response.exists():
                raise StreamError('Missing stream response')
            result = parse_completion_stream(raw)
            save('response.json', result)
            report['complete'] = True
            return result
    except OSError:
        raise StreamError('Stream local I/O or process launch failed; do not retry automatically') from None
    finally:
        report['elapsed_seconds'] = round(time.monotonic() - start, 6)
        save('transport.json', report)
