"""Regression controls for sequential/combinational qualification and budgets."""
import math
import unittest

from eda.experiments.run_systematic_study import eligible
from eda.experiments.collect_systematic_study import accepted, rejection_reason, schedule, target_reached


class SystematicStudyTests(unittest.TestCase):
    def setUp(self):
        self.metrics=dict(status='PASS',formal='PASS',mapped_formal='PASS',ppa='PASS',
                          eligible=True,electrical={'status':'PASS'},wns_ns=2.0,
                          tns_ns=0.0,mapped_area_um2=100.0)

    def test_sequential_uses_wns_and_does_not_require_arrival(self):
        self.assertTrue(eligible({'backend':'sequential'},self.metrics))
        self.assertFalse(eligible({'backend':'native_comb'},self.metrics))
        self.assertTrue(eligible({'backend':'native_comb'},dict(self.metrics,max_data_arrival_ns=1.0)))

    def test_full_proofs_and_electrical_required(self):
        for field in ('formal','mapped_formal','ppa'):
            self.assertFalse(eligible({'backend':'sequential'},dict(self.metrics,**{field:'FAIL'})))
        self.assertFalse(eligible({'backend':'sequential'},dict(self.metrics,electrical={'status':'FAIL'})))

    def test_nonfinite_or_missing_metrics_rejected(self):
        for value in (None,math.inf,math.nan,True):
            self.assertFalse(eligible({'backend':'sequential'},dict(self.metrics,wns_ns=value)))

    def test_budgets_and_strategy_balance(self):
        cases=[{'id':str(index)} for index in range(15)]
        protocol=dict(cases=cases,planned_parameter_scan={'cases':[str(index) for index in range(6,15)]})
        for limit in (54,162,216):
            jobs=schedule(protocol,limit)
            self.assertEqual(sum(job['max_rounds'] for job in jobs),limit)
            self.assertEqual(len({job['id'] for job in jobs}),len(jobs))
            self.assertEqual(jobs,schedule(protocol,limit))
            repeats=1 if limit==54 else 3
            for strategy in ('direct','sta','adaptive'):
                self.assertEqual(sum(job['case']=='0' and job['strategy']==strategy for job in jobs),repeats)

    def test_original_area_limit_and_target(self):
        case={'backend':'sequential'}
        better=dict(self.metrics,wns_ns=2.2,mapped_area_um2=109)
        self.assertTrue(accepted(case,better,self.metrics))
        self.assertTrue(target_reached(case,better,self.metrics))
        self.assertFalse(accepted(case,dict(better,mapped_area_um2=111),self.metrics))
        self.assertEqual(rejection_reason(case,dict(better,mapped_area_um2=111),self.metrics),'AREA_LIMIT')
        self.assertEqual(rejection_reason(case,self.metrics,self.metrics),'NO_TIMING_GAIN')


if __name__=='__main__':
    unittest.main()
