"""Focused negative controls for the reviewer verifier."""
import importlib.util
from pathlib import Path
import tempfile
import unittest

path = Path(__file__).with_name('verify.py')
spec = importlib.util.spec_from_file_location('review_verify', path)
verify = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verify)


class ReviewerControls(unittest.TestCase):
    def test_hash_change_detected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            file = root / 'evidence.txt'
            file.write_text('original', encoding='utf-8')
            entry = dict(path='evidence.txt', bytes=file.stat().st_size, sha256=verify.digest(file))
            self.assertEqual(verify.manifest_errors(root, [entry]), [])
            file.write_text('modified', encoding='utf-8')
            self.assertTrue(verify.manifest_errors(root, [entry]))

    def test_path_escape_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            errors = verify.manifest_errors(Path(temporary), [dict(path='../outside.txt', bytes=0, sha256='unused')])
            self.assertTrue(errors)

    def test_qualification_requires_all_gates(self):
        baseline = dict(mapped_area_um2=100, max_data_arrival_ns=2, tns_ns=0)
        valid = dict(status='PASS', formal='PASS', mapped_formal='PASS', ppa='PASS',
            electrical={'status': 'PASS'}, mapped_area_um2=110, max_data_arrival_ns=1.9, tns_ns=0)
        self.assertTrue(verify.accepted(valid, baseline))
        for changed in (dict(formal='FAIL'), dict(mapped_formal='FAIL'), dict(mapped_area_um2=111),
                        dict(max_data_arrival_ns=2), dict(tns_ns=-1), dict(electrical={'status': 'FAIL'})):
            self.assertFalse(verify.accepted({**valid, **changed}, baseline))


if __name__ == '__main__':
    unittest.main()
