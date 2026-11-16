"""Synthetic offline streams only; these tests never call a model gateway."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from agents.sse_transport import StreamError, curl_completion_stream, parse_completion_stream


def chunk(content=None, finish=None, **extra):
    delta = {} if content is None else {'content': content}
    return {'id': 'synthetic', 'model': 'synthetic-test',
            'choices': [{'index': 0, 'delta': delta, 'finish_reason': finish}], **extra}


def event(obj):
    return 'data: ' + json.dumps(obj, ensure_ascii=False) + '\n\n'


def stream():
    return (': heartbeat\n\n' + event(chunk('模块')) + event(chunk('完整', 'stop'))
            + event({'choices': [], 'usage': {'total_tokens': 7}}) + 'data: [DONE]\n\n').encode('utf-8')


class StreamParser(unittest.TestCase):
    def test_complete_unicode_comments_usage_and_crlf(self):
        for raw in (stream(), b'\xef\xbb\xbf' + stream().replace(b'\n', b'\r\n'), stream().replace(b'\n', b'\r')):
            result = parse_completion_stream(raw)
            self.assertEqual(result['choices'][0]['message']['content'], '模块完整')
            self.assertEqual(result['usage']['total_tokens'], 7)
            self.assertTrue(result['stream_audit']['complete'])

    def test_usage_unknown_is_not_zero(self):
        raw = (event(chunk('ok', 'stop')) + 'data: [DONE]\n\n').encode()
        result = parse_completion_stream(raw)
        self.assertIsNone(result['usage'])
        self.assertFalse(result['stream_audit']['usage_reported'])

    def test_multiline_data_and_reasoning_omitted(self):
        c = chunk('ok', 'stop')
        c['choices'][0]['delta']['reasoning_content'] = 'SYNTHETIC_HIDDEN_FIELD'
        pretty = json.dumps(c, indent=2)
        raw = ('\n'.join('data: ' + s for s in pretty.splitlines()) + '\n\n'
               + 'data: [DONE]\n\n').encode()
        self.assertNotIn('SYNTHETIC_HIDDEN_FIELD', json.dumps(parse_completion_stream(raw)))

    def test_disconnect_and_missing_finish_fail(self):
        cases = [event(chunk('partial')), event(chunk('partial', 'stop')),
                 event(chunk('partial')) + 'data: [DONE]\n\n',
                 event(chunk('partial', 'stop')) + 'data: [DONE]\n',
                 event(chunk('partial', 'stop')) + 'data: [DONE]']
        for raw in cases:
            with self.subTest(raw=raw), self.assertRaises(StreamError):
                parse_completion_stream(raw.encode())

    def test_length_filter_tools_refusal_and_empty_fail(self):
        cases = [chunk('partial', 'length'), chunk('x', 'content_filter'), chunk('', 'stop')]
        for field in ('tool_calls', 'refusal', 'function_call'):
            c = chunk('x', 'stop'); c['choices'][0]['delta'][field] = ['unsupported']
            cases.append(c)
        for c in cases:
            with self.subTest(c=c), self.assertRaises(StreamError):
                parse_completion_stream((event(c) + 'data: [DONE]\n\n').encode())

    def test_malformed_identity_extra_choices_and_after_done_fail(self):
        changed = chunk('x', 'stop'); changed['model'] = 'changed'
        many = chunk('x', 'stop'); many['choices'].append(many['choices'][0].copy())
        cases = [b'\xff\n\n', b'data: {bad}\n\n', b'event: error\ndata: {}\n\n',
                 b'data: {"error":{"message":"PRIVATE_ERROR"}}\n\n',
                 b'data: {"choices":[],"choices":[]}\n\n',
                 b'data: {"choices":[],"usage":{"total_tokens":NaN}}\n\n',
                 (event(chunk('x')) + event(changed)).encode(),
                 (event(many) + 'data: [DONE]\n\n').encode(),
                 stream() + event(chunk('extra')).encode()]
        for raw in cases:
            with self.subTest(raw=raw), self.assertRaises(StreamError) as e:
                parse_completion_stream(raw)
            self.assertNotIn('PRIVATE_ERROR', str(e.exception))


class StreamTransport(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(dir=Path(__file__).resolve().parents[1])
        self.addCleanup(self.temp.cleanup)
        self.audit = Path(self.temp.name) / 'audit'

    def call(self, **kwargs):
        return curl_completion_stream(endpoint='https://unit-test.invalid/v1/chat/completions',
                                      body={'model': 'synthetic-test', 'stream': True},
                                      api_key='UNIT_SECRET', audit_dir=self.audit, **kwargs)

    def fake(self, raw=None, code=0, status=b'200', content_type=b'text/event-stream'):
        def run(cmd, **kwargs):
            self.assertNotIn('UNIT_SECRET', str(cmd))
            self.assertIn(b'UNIT_SECRET', kwargs['input'])
            self.assertNotIn('OPENAI_API_KEY', kwargs['env'])
            self.assertNotIn('--insecure', cmd)
            self.assertNotIn('--location', cmd)
            self.assertIn('--no-buffer', cmd)
            self.assertEqual(cmd[cmd.index('--retry') + 1], '0')
            self.assertTrue((self.audit / 'attempt.json').exists())
            response = Path(cmd[cmd.index('--output') + 1])
            response.write_bytes(stream() if raw is None else raw)
            self.assertNotIn('UNIT_SECRET', response.with_name('body.json').read_text())
            return subprocess.CompletedProcess(cmd, code, status + b'|0.03|0.2|0.3|' + content_type,
                                               b'UNIT_SECRET PRIVATE_STDERR')
        return run

    def test_success_and_credential_boundaries(self):
        with patch('shutil.which', return_value='fake-curl'), patch.dict(os.environ, {'OPENAI_API_KEY': 'UNIT_SECRET'}), patch('subprocess.run', side_effect=self.fake()) as run:
            self.assertEqual(self.call()['usage']['total_tokens'], 7)
        self.assertEqual(run.call_count, 1)
        self.assertTrue(json.loads((self.audit / 'transport.json').read_text())['complete'])
        self.assertFalse(any(self.audit.glob('transfer_*')))
        self.assertNotIn('UNIT_SECRET', ''.join(p.read_text() for p in self.audit.iterdir()))

    def test_failures_are_recorded_once_without_partial_candidate(self):
        cases = [(b'partial RTL', 56, b'000', b''), (b'PRIVATE_ERROR', 0, b'524', b'text/html'),
                 (stream(), 0, b'200', b'application/json'),
                 (event(chunk('partial RTL')).encode(), 0, b'200', b'text/event-stream')]
        for raw, code, status, mime in cases:
            self.audit = Path(self.temp.name) / ('audit' + str(cases.index((raw,code,status,mime))))
            with patch('shutil.which', return_value='fake-curl'), patch('subprocess.run', side_effect=self.fake(raw,code,status,mime)) as run:
                with self.assertRaises(StreamError) as e:
                    self.call()
            self.assertEqual(run.call_count, 1)
            self.assertNotIn('UNIT_SECRET', str(e.exception))
            self.assertFalse((self.audit / 'response.json').exists())
            audit = ''.join(p.read_text() for p in self.audit.iterdir())
            for secret in ('partial RTL', 'PRIVATE_STDERR', 'PRIVATE_ERROR', 'UNIT_SECRET'):
                self.assertNotIn(secret, audit)
            self.assertFalse(json.loads((self.audit / 'transport.json').read_text())['complete'])

    def test_timeout_is_not_retried(self):
        with patch('shutil.which', return_value='fake-curl'), patch('subprocess.run', side_effect=subprocess.TimeoutExpired(['fake-curl'],5)) as run:
            with self.assertRaises(StreamError):
                self.call(timeout_s=5)
        self.assertEqual(run.call_count, 1)
        self.assertTrue(json.loads((self.audit / 'transport.json').read_text())['client_timeout'])

    def test_existing_attempt_cannot_be_resumed(self):
        self.audit.mkdir()
        with patch('shutil.which', return_value='fake-curl'), patch('subprocess.run') as run:
            with self.assertRaises(FileExistsError):
                self.call()
        run.assert_not_called()

    def test_invalid_key_or_request_stops_before_transmission(self):
        for key, body in [('bad\nheader', {'stream': True}), ('ok', {'stream': False})]:
            with patch('subprocess.run') as run, self.assertRaises(StreamError):
                curl_completion_stream(endpoint='https://unit-test.invalid/v1/chat/completions',
                                       body=body,api_key=key,audit_dir=self.audit)
            run.assert_not_called()

    def test_preflight_requires_new_consent_before_network(self):
        import hashlib
        from eda.experiments.preflight_sse_generation import execute
        self.audit.mkdir()
        protocol = self.audit / 'protocol.json'
        protocol.write_text('{}', encoding='utf-8')
        (self.audit / 'protocol.sha256').write_text(hashlib.sha256(protocol.read_bytes()).hexdigest())
        (self.audit / 'AUTHORIZATION.json').write_text('{"status":"PENDING"}')
        with patch('subprocess.run') as run, self.assertRaisesRegex(RuntimeError, 'explicit consent'):
            execute(self.audit)
        run.assert_not_called()
        self.assertFalse((self.audit / 'RUN_STARTED.json').exists())


if __name__ == '__main__':
    unittest.main()
