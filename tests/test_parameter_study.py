"""Budget balance and saved-baseline prompt controls for the width sweep."""
from collections import Counter
import tempfile
from pathlib import Path
import unittest

from eda.experiments.collect_parameter_study import CASE_IDS, schedule
from eda.experiments.collect_systematic_study import CallBudget
from eda.experiments.analyze_parameter_study import retained


class ParameterStudyTests(unittest.TestCase):
    def test_failed_or_unqualified_slots_retain_original_delay(self):
        baseline = {'max_data_arrival_ns': 2.0}
        self.assertEqual(retained(None, baseline), 2.0)
        self.assertEqual(retained(dict(accepted=False, metrics={'max_data_arrival_ns': 0.1}), baseline), 2.0)
        self.assertEqual(retained(dict(accepted=True, metrics={'max_data_arrival_ns': 1.5}), baseline), 1.5)

    def test_three_complete_balanced_blocks(self):
        jobs = schedule()
        self.assertEqual(len(jobs), 54)
        self.assertEqual(len({job['id'] for job in jobs}), 54)
        self.assertEqual(Counter((job['case'], job['strategy']) for job in jobs),
                         Counter({(case, strategy): 3 for case in CASE_IDS for strategy in ('direct', 'sta')}))
        for repeat in range(1, 4):
            self.assertEqual(len([job for job in jobs if job['repeat'] == repeat]), 18)
        self.assertEqual(schedule(), jobs)

    def test_transport_stop_reserves_no_more_requests(self):
        with tempfile.TemporaryDirectory() as temporary:
            budget = CallBudget(Path(temporary) / 'calls', 54)
            for index in range(3):
                self.assertIsNotNone(budget.reserve(dict(id=str(index)), 1))
                budget.finish(True)
            self.assertTrue(budget.halted)
            self.assertIsNone(budget.reserve(dict(id='next'), 1))
            self.assertEqual(budget.used, 3)


if __name__ == '__main__':
    unittest.main()
