import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(__file__))
from detect import evaluate  # noqa: E402

BASE = [0.10, 0.12, 0.08, 0.11, 0.09, 0.10, 0.13, 0.07, 0.10, 0.10] * 3  # 30 points, mean 0.10


class EvaluateTest(unittest.TestCase):
    def test_insufficient_data(self):
        self.assertEqual(evaluate([0.1] * 20, 30)["tier"], "none")
        self.assertEqual(evaluate([0.1] * 20, 30)["rule"], "insufficient_data")

    def test_stable_series_is_quiet(self):
        tail = [0.10, 0.11, 0.09, 0.10, 0.12, 0.08, 0.10, 0.09]
        self.assertEqual(evaluate(BASE + tail, 30)["tier"], "none")

    def test_spike_is_3sigma(self):
        tail = [0.10, 0.11, 0.09, 0.10, 0.12, 0.08, 0.10, 0.60]
        result = evaluate(BASE + tail, 30)
        self.assertEqual(result["tier"], "3sigma")
        self.assertEqual(result["rule"], "rule1_beyond_3sigma")

    def test_slow_drift_is_2sigma(self):
        tail = [0.12] * 8  # small but persistent: 8 in a row above the mean
        result = evaluate(BASE + tail, 30)
        self.assertEqual(result["tier"], "2sigma")
        self.assertEqual(result["rule"], "rule4_8_same_side")

    def test_two_of_three_beyond_2sigma(self):
        tail = [0.10, 0.09, 0.11, 0.10, 0.08, 0.15, 0.10, 0.15]
        self.assertEqual(evaluate(BASE + tail, 30)["rule"], "rule2_2of3_beyond_2sigma")


if __name__ == "__main__":
    unittest.main()
