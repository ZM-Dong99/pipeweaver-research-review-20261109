"""Regression controls for route selection, budgets and verified export."""
import json
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from agents import adaptive_optimizer as runner
from agents.portfolio_loop import load, sha
from agents.routing_policy import baseline_signature, fit, recommend
from agents.sse_transport import StreamError


def metrics(delay=2.0, area=100.0):
    return dict(status='PASS', formal='PASS', mapped_formal='PASS', ppa='PASS',
                electrical=dict(status='PASS'), max_data_arrival_ns=delay,
                mapped_area_um2=area, tns_ns=0.0, sdc_sha256='fixed-sdc')


class RoutingPolicyTests(unittest.TestCase):
    def test_exact_context_and_baseline_required(self):
        value = dict(reference_sha256='source', top='top', parameters={}, backend='native_comb', model='m')
        rows = [dict(context=value, baseline=baseline_signature(metrics()), arm=arm,
                     gain=gain, retained_delay_ns=2 * (1 - gain), improved=True, usage=None)
                for arm, gain in [('no_sta', 0.05)] * 10 + [('sta', 0.2)] * 10]
        policy = fit(rows)
        self.assertEqual(recommend(policy, value, metrics())['route'], 'sta')
        self.assertEqual(recommend(policy, dict(value, reference_sha256='new'))['reason'], 'unseen_context')
        self.assertEqual(recommend(policy, value, metrics(area=101))['reason'], 'baseline_conditions_changed')
        self.assertEqual(recommend(fit(rows[:11]), value)['route'], 'direct')

    def test_small_advantage_retains_direct_default(self):
        rows = [dict(context={}, baseline={}, arm=arm, gain=gain,
                     retained_delay_ns=1.0, improved=True, usage=None)
                for arm, gain in [('no_sta', 0.1)] * 10 + [('sta', 0.105)] * 10]
        self.assertEqual(recommend(fit(rows), {})['route'], 'direct')


class AdaptiveRunnerTests(unittest.TestCase):
    def setUp(self):
        self.temp = TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.reference = self.root / 'original.v'
        self.reference.write_text('original RTL', encoding='utf-8')
        self.library = self.root / 'library.lib'
        self.library.write_text('test library', encoding='utf-8')
        self.design = dict(id='test', top='top', parameters={}, backend='native_comb',
                           reference=dict(sha256=sha(self.reference)))
        self.args = SimpleNamespace(use_llm=False, candidate_rtl=[], area_limit=1.1,
            target_gain=0.05, model='m', max_requests=0, max_completion_tokens=16000,
            llm_timeout=600, policy=None, out=self.root / 'run', route='auto')
        self.patches = [patch.object(runner, 'LIB', self.library),
                        patch.object(runner, 'dependencies', return_value={'test': 'fixed'})]
        for item in self.patches:
            item.start()
            self.addCleanup(item.stop)

    def candidate(self, name, text):
        path = self.root / name
        path.write_text(text, encoding='utf-8')
        self.args.candidate_rtl.append(str(path))
        return path

    def test_bad_formal_rejected_then_target_stops(self):
        self.candidate('bad.v', 'bad')
        good = self.candidate('good.v', 'good')
        self.candidate('unused.v', 'unused')
        bad = dict(metrics(delay=0.1), formal='FAIL')
        with patch.object(runner, 'evaluate', side_effect=[metrics(), bad, metrics(delay=1.5)]) as evaluator:
            self.assertEqual(runner.run(self.args, self.design, self.reference), 0)
        report = load(self.args.out / 'SUMMARY.json')
        self.assertEqual(evaluator.call_count, 3)
        self.assertEqual(report['selected'], 'candidate_002')
        self.assertEqual(report['candidates'][2]['route'], 'feedback')
        self.assertEqual(report['model_requests'], 0)
        self.assertEqual(report['stopped'], 'target_reached')
        self.assertEqual(sha(self.args.out / 'best.v'), sha(good))

    def test_original_relative_area_cap_never_ratchets(self):
        self.args.target_gain = 0.8
        first = self.candidate('first.v', 'first')
        self.candidate('second.v', 'second')
        with patch.object(runner, 'evaluate', side_effect=[metrics(), metrics(1.8, 105), metrics(1, 114)]):
            runner.run(self.args, self.design, self.reference)
        report = load(self.args.out / 'SUMMARY.json')
        self.assertEqual(report['selected'], 'candidate_001')
        self.assertIn('area_limit', report['candidates'][2]['reasons'])
        self.assertEqual(sha(self.args.out / 'best.v'), sha(first))

    def test_duplicate_source_reuses_evaluation_and_retains_original(self):
        self.candidate('same.v', 'original RTL')
        with patch.object(runner, 'evaluate', return_value=metrics()) as evaluator:
            runner.run(self.args, self.design, self.reference)
        self.assertEqual(evaluator.call_count, 1)
        report = load(self.args.out / 'SUMMARY.json')
        self.assertTrue(report['baseline_retained'])
        self.assertEqual(report['candidates'][1]['shared_evaluation'], 'baseline')
        with self.assertRaises(FileExistsError):
            runner.run(self.args, self.design, self.reference)

    def test_unqualified_baseline_has_no_success_export(self):
        self.candidate('candidate.v', 'candidate')
        with patch.object(runner, 'evaluate', return_value=dict(status='INCOMPLETE')):
            self.assertEqual(runner.run(self.args, self.design, self.reference), 2)
        self.assertFalse((self.args.out / 'best.v').exists())

    def test_zero_delay_baseline_does_not_divide_by_zero_or_generate(self):
        self.candidate('candidate.v', 'candidate')
        with patch.object(runner, 'evaluate', return_value=metrics(delay=0)) as evaluator:
            self.assertEqual(runner.run(self.args, self.design, self.reference), 0)
        self.assertEqual(evaluator.call_count, 1)
        self.assertEqual(sha(self.args.out / 'best.v'), sha(self.reference))

    def test_live_transport_stop_and_attempt_budget(self):
        self.args.use_llm = True
        self.args.max_requests = 5
        with patch.dict('os.environ', {'OPENAI_API_KEY': 'unit-test-placeholder'}), \
                patch.object(runner, 'evaluate', return_value=metrics()), \
                patch.object(runner, 'generate', side_effect=StreamError('synthetic failure')) as generator:
            runner.run(self.args, self.design, self.reference)
        report = load(self.args.out / 'SUMMARY.json')
        self.assertEqual(generator.call_count, 3)
        self.assertEqual(report['model_requests'], 3)
        self.assertEqual(report['stopped'], 'consecutive_transport_failures')
        self.assertEqual(report['usage_unknown'], 3)
        self.assertTrue(report['baseline_retained'])

    def test_format_failure_usage_included_and_budget_exhausted(self):
        self.args.use_llm = True
        self.args.max_requests = 1
        def fail(prompt, args, folder):
            (folder / 'response.json').write_text(json.dumps(dict(usage=dict(total_tokens=123))))
            raise ValueError('synthetic invalid response')
        with patch.dict('os.environ', {'OPENAI_API_KEY': 'unit-test-placeholder'}), \
                patch.object(runner, 'evaluate', return_value=metrics()), \
                patch.object(runner, 'generate', side_effect=fail) as generator:
            runner.run(self.args, self.design, self.reference)
        report = load(self.args.out / 'SUMMARY.json')
        self.assertEqual(generator.call_count, 1)
        self.assertEqual(report['reported_tokens'], 123)
        self.assertEqual(report['model_requests'], 1)

    def test_live_requires_explicit_positive_budget(self):
        self.args.use_llm = True
        with patch.dict('os.environ', {'OPENAI_API_KEY': 'unit-test-placeholder'}), \
                patch.object(runner, 'generate') as generator:
            with self.assertRaises(ValueError):
                runner.run(self.args, self.design, self.reference)
        generator.assert_not_called()

    def test_direct_prompt_excludes_timing_report(self):
        best = dict(id='baseline', source='original.v', metrics=metrics())
        prompt = runner.prompt_for('direct', self.reference, best, self.design, metrics(), 1.1, None, self.root)
        self.assertNotIn('Actual best STA paths', prompt)
        self.assertNotIn('Measured best metrics', prompt)
        self.assertIn('Original reference RTL', prompt)


if __name__ == '__main__':
    unittest.main()
