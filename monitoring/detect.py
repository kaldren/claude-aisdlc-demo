#!/usr/bin/env python3
"""Deterministic control-band detection. No model involved.

Reads a metric series on stdin, one number per line, oldest first. The last
`--window` points before the evaluated tail form the rolling baseline.
Prints JSON: {"tier": "none|1sigma|2sigma|3sigma", "rule": ..., "value": ..., "mean": ..., "std": ...}

Western Electric rules, mapped to the tiers in bands.yaml:
  rule 1: one point beyond 3 sigma                       -> 3sigma (act)
  rule 2: 2 of the last 3 beyond 2 sigma, same side      -> 2sigma (diagnose)
  rule 4: 8 in a row on the same side of the mean (drift)-> 2sigma (diagnose)
  rule 3: 4 of the last 5 beyond 1 sigma, same side      -> 1sigma (log)

Unit-test this script; it is the gate that decides when Claude is invoked.
"""
import argparse
import json
import statistics
import sys

TIER_ORDER = ["none", "1sigma", "2sigma", "3sigma"]


def evaluate(series, window):
    if len(series) < window + 8:
        return {"tier": "none", "rule": "insufficient_data"}
    baseline = series[-(window + 8):-8]
    tail = series[-8:]
    mean = statistics.fmean(baseline)
    std = statistics.pstdev(baseline) or 1e-9
    z = [(x - mean) / std for x in tail]

    def same_side_count(values, limit):
        return max(sum(v > limit for v in values), sum(v < -limit for v in values))

    hits = []
    if abs(z[-1]) > 3:
        hits.append(("3sigma", "rule1_beyond_3sigma"))
    if same_side_count(z[-3:], 2) >= 2:
        hits.append(("2sigma", "rule2_2of3_beyond_2sigma"))
    if all(v > 0 for v in z) or all(v < 0 for v in z):
        hits.append(("2sigma", "rule4_8_same_side"))
    if same_side_count(z[-5:], 1) >= 4:
        hits.append(("1sigma", "rule3_4of5_beyond_1sigma"))

    tier, rule = max(hits, key=lambda h: TIER_ORDER.index(h[0]), default=("none", None))
    return {"tier": tier, "rule": rule, "value": tail[-1], "mean": round(mean, 4), "std": round(std, 4)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--window", type=int, default=30, help="baseline points (e.g. 30 days)")
    args = parser.parse_args()
    series = [float(line) for line in sys.stdin if line.strip()]
    print(json.dumps(evaluate(series, args.window)))


if __name__ == "__main__":
    main()
