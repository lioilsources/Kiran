#!/usr/bin/env python3
"""Check the Play texts in marketing/googleplay-listing*.md against Play's limits.

    python3 marketing/tools/check_play_lengths.py

A text is a fenced block preceded by a marker line

    <!-- check: <name> <limit> -->

Counts are Unicode code points, which is what Play Console counts (each
Japanese character is one). Exits non-zero if anything is over its limit.
"""
import pathlib
import re
import sys

MARKETING = pathlib.Path(__file__).resolve().parents[1]
PATTERN = re.compile(r"<!-- check: (\S+) (\d+) -->\s*\n```[^\n]*\n(.*?)\n```", re.S)


def main():
    bad = 0
    for md in sorted(MARKETING.glob('googleplay-listing*.md')):
        found = PATTERN.findall(md.read_text(encoding='utf-8'))
        print(md.name + ('' if found else ': no <!-- check: --> markers'))
        for name, limit, body in found:
            n, limit = len(body), int(limit)
            bad += n > limit
            print(f"  {'OK ' if n <= limit else 'OVER'} {name:<20} {n:>5} / {limit}")
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
