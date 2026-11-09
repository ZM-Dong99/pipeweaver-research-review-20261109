"""Offline parser, request-journal and all-slot selection tests; no network or EDA."""
import copy
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import Mock,patch

ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'eda/experiments'))
import run_stream_feedback as run
PLAN=run.load(ROOT/'eda/experiments/stream_feedback_preparation_20261106/protocol.json')


def metrics(wns=8.0):
    return dict(status='PASS',formal='PASS',mapped_formal='PASS',ppa='PASS',electrical={'status':'PASS'},
                no_declared_initial_values_relied_on=True,wns_ns=wns,tns_ns=0.,mapped_area_um2=100.,mapped_sha256='synthetic')


class StreamFeedbackTests(unittest.TestCase):
    def payload(self):
        return dict(candidate_rtl='module tiny(input a,output y); assign y=a; endmodule\n',
                    bottleneck='synthetic',rewrite='synthetic',expected_timing_gain='unknown',area_or_other_cost='unknown',functional_boundaries='synthetic')

    def fixture(self,root):
        (root/'protocol.json').write_text('{}',encoding='utf-8')
        p=dict(schedule=PLAN['schedule'],cases=[dict(id=c['id'],top=c['top'],source=c['source'],params=c['params'],baseline=metrics()) for c in PLAN['cases']])
        for slot in p['schedule']:
            f=root/slot['prompt'];f.parent.mkdir(parents=True,exist_ok=True);f.write_text('Offline synthetic prompt',encoding='utf-8')
        return p

    def test_prospective_format_compatibility_preserves_rtl(self):
        raw=json.dumps(self.payload());a=run.parse_candidate(raw);b=run.parse_candidate('<think>discard wrapper</think>\n```json\n'+raw+'\n```')
        self.assertEqual(a['rtl'],b['rtl']);self.assertEqual(len(b['format_normalizations']),2)

    def test_ambiguous_or_extra_outputs_rejected(self):
        raw=json.dumps(self.payload())
        for text in (raw+raw,'<think>unclosed',raw[:-1]+',"candidate_rtl":"replacement"}',
                     raw[:-1]+',"commands":"touch anything"}',raw.replace('"synthetic"','NaN',1)):
            with self.subTest(text=text),self.assertRaises(run.LLMGenerationError):run.parse_candidate(text)

    def test_unknown_attempt_never_resends(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root);sender=Mock(side_effect=KeyboardInterrupt)
            with self.assertRaises(KeyboardInterrupt):run.collect(root,p,sender,lambda _:None)
            never=Mock()
            with self.assertRaisesRegex(RuntimeError,'Unknown prior attempt'):run.collect(root,p,never,lambda _:None)
            never.assert_not_called()

    def test_completed_failures_consume_slots_and_resume_without_calls(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root);sender=Mock(side_effect=run.LLMGenerationError('synthetic transport failure'))
            rows=run.collect(root,p,sender,lambda _:None);self.assertEqual(sender.call_count,12)
            never=Mock();self.assertEqual(run.collect(root,p,never,lambda _:None),rows);never.assert_not_called()

    def test_pending_or_changed_destination_not_authorized(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);self.fixture(root);p=dict(endpoint='https://example.invalid/v1')
            a=dict(status='PENDING',endpoint=p['endpoint'],maximum_requests=12,protocol_sha256=run.sha(root/'protocol.json'))
            run.save(root/'AUTHORIZATION.json',a)
            with self.assertRaisesRegex(RuntimeError,'authorization'):run.authorized(root,p)
            a['status']='EXPLICITLY_APPROVED';run.save(root/'AUTHORIZATION.json',a)
            with patch.dict(os.environ,{'OPENAI_API_KEY':'synthetic-offline','OPENAI_BASE_URL':'https://different.invalid/v1'}):
                with self.assertRaisesRegex(RuntimeError,'Endpoint changed'):run.authorized(root,p)

    def test_rejected_physical_scope_or_regression_keeps_baseline(self):
        base=metrics()
        bad=[]
        for key,value in [('mapped_formal','FAIL'),('wns_ns',float('inf')),('no_declared_initial_values_relied_on',False),('mapped_area_um2',110.01),('tns_ns',-.01)]:
            m=metrics(9.0);m[key]=value;bad.append(m)
        m=metrics(9.0);m['electrical']={'status':'FAIL'};bad.append(m)
        for m in bad:self.assertEqual(run.choose(m,base)['selected'],'baseline')
        self.assertEqual(run.choose(metrics(),base)['selected'],'baseline')
        self.assertEqual(run.choose(metrics(8.01),base)['selected'],'candidate')

    def test_generation_freeze_required_before_eda(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root);never=Mock()
            with self.assertRaises(FileNotFoundError):run.evaluate_rows(root,p,[],never,lambda _:None)
            never.assert_not_called()

    def test_identical_candidates_share_eda_but_keep_twelve_attempts(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root);sender=Mock(return_value=run.parse_candidate(json.dumps(self.payload())))
            rows=run.collect(root,p,sender,lambda _:None);evaluator=Mock(return_value=metrics(9.0))
            result=run.evaluate_rows(root,p,rows,evaluator,lambda _:None)
            self.assertEqual(evaluator.call_count,2);self.assertEqual(result['unique_candidate_eda'],2)
            for arms in result['groups'].values():
                for group in arms.values():self.assertEqual(group['attempted'],3);self.assertEqual(group['strict_improvements'],3)

    def test_one_good_draw_cannot_replace_all_attempt_median(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root);sequence=[]
            for slot in p['schedule']:
                sequence.append(run.parse_candidate(json.dumps(self.payload())) if slot['trial']==1 else run.LLMGenerationError('synthetic failed attempt'))
            rows=run.collect(root,p,Mock(side_effect=sequence),lambda _:None)
            result=run.evaluate_rows(root,p,rows,Mock(return_value=metrics(9.0)),lambda _:None)
            for arms in result['groups'].values():
                for group in arms.values():self.assertEqual(group['strict_improvements'],1);self.assertEqual(group['median_retained_wns_ns'],8.)

    def test_candidate_tampering_stops_resume(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'tests') as tmp:
            root=Path(tmp);p=self.fixture(root)
            run.collect(root,p,Mock(return_value=run.parse_candidate(json.dumps(self.payload()))),lambda _:None)
            (root/'trials/call_01/candidate.v').write_text('tampered',encoding='utf-8');never=Mock()
            with self.assertRaisesRegex(RuntimeError,'Candidate changed'):run.collect(root,p,never,lambda _:None)
            never.assert_not_called()


if __name__=='__main__':unittest.main()
