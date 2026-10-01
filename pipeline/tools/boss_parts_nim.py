"""Tier-0 drafts of the campaign boss parts, via the AiStack flux-schnell NIM.

    python3 pipeline/tools/boss_parts_nim.py -dry-run     # prompts only
    python3 pipeline/tools/boss_parts_nim.py              # generate

Output: pipeline/output/drafts/boss_parts/<skin>/<part>_v<N>.png

Why this exists next to cmd/generate rather than inside it: the ComfyUI box is
scheduled, and in the LLM window it is off. The NIM endpoint is up instead, so
these drafts take the pipeline's prompts to a different backend. They are
drafts — 4-step schnell output, no background removal, not atlas material.
Promoting one means rerunning it through cmd/generate + postprocess properly.

Prompts are NOT written here. They come from `cmd/generate -dry-run`, so a
draft is made from exactly the text the real pipeline would send; duplicating
the templates would guarantee the two drift apart.
"""
import argparse
import concurrent.futures as futures
import datetime as dt
import json
import pathlib
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[2]
PIPELINE = ROOT / 'pipeline'
SKINS = ROOT / 'tyrian_mobile/assets/skins'
OUT = PIPELINE / 'output/drafts/boss_parts'

NIM = 'http://192.168.88.66:8091/nim/flux-schnell'
SIZE = 1024
STEPS = 4

# The box is shared and scheduled by the Director session; authoritative hours
# live in AiStack PLAN-spark-scheduler.md §3. Starting outside the window steals
# the GPU from whatever owns it, so the guard is on by default.
WINDOW_START = dt.time(19, 15)
WINDOW_END = dt.time(1, 0)


def in_window(now=None):
    t = (now or dt.datetime.now()).time()
    return t >= WINDOW_START or t < WINDOW_END


def skins():
    return sorted(p.name for p in SKINS.iterdir()
                  if p.is_dir() and p.name != 'default')


def prompts_for(skin):
    """Harvest the pipeline's own boss_part prompts for one skin."""
    p = subprocess.run(
        ['go', 'run', './cmd/generate', '-skin', skin,
         '-asset-type', 'boss_part', '-dry-run'],
        cwd=PIPELINE, capture_output=True, text=True, timeout=300)
    if p.returncode:
        print(f'  {skin}: dry-run failed: {p.stderr[-300:]}', file=sys.stderr)
        return {}
    out, found = {}, re.split(r'^\[\d+\] sprites/', p.stdout, flags=re.M)[1:]
    for block in found:
        name = block.splitlines()[0].strip()
        m = re.search(r'^\s*Prompt:\s*\n(.*?)(?=\n\s*\[\d+\]|\Z)',
                      block, re.S | re.M)
        if m:
            out[name] = '\n'.join(l.strip() for l in m.group(1).strip().splitlines())
    return out


def post(prompt, seed):
    req = urllib.request.Request(
        f'{NIM}/v1/infer',
        data=json.dumps({'prompt': prompt, 'width': SIZE, 'height': SIZE,
                         'seed': seed, 'steps': STEPS}).encode(),
        headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=60) as r:
        if r.status != 202:
            raise RuntimeError(f'expected 202, got {r.status}')
        return json.loads(r.read())['id']


def collect(job_id, timeout=600):
    deadline = time.time() + timeout
    while time.time() < deadline:
        with urllib.request.urlopen(f'{NIM}/jobs/{job_id}', timeout=30) as r:
            st = json.loads(r.read())
        state = (st.get('status') or st.get('state') or '').lower()
        if state in ('failed', 'error'):
            raise RuntimeError(f'{job_id} failed: {st}')
        if state in ('done', 'succeeded', 'completed', 'finished'):
            with urllib.request.urlopen(f'{NIM}/jobs/{job_id}/result', timeout=120) as r:
                return r.read()
        time.sleep(3)
    raise TimeoutError(f'{job_id} not done in {timeout}s')


def one(skin, part, prompt, variant, seed):
    dest = OUT / skin / f'{part}_v{variant}.png'
    if dest.exists():
        return f'{skin}/{part}_v{variant}  (already there)'
    dest.parent.mkdir(parents=True, exist_ok=True)
    try:
        dest.write_bytes(collect(post(prompt, seed)))
        return f'{skin}/{part}_v{variant}  {dest.stat().st_size // 1024} KB'
    except Exception as e:
        return f'{skin}/{part}_v{variant}  FAILED: {type(e).__name__}: {e}'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-dry-run', action='store_true',
                    help='harvest and print prompts, call nothing')
    ap.add_argument('-skin', action='append', default=[],
                    help='limit to these skins (repeatable)')
    ap.add_argument('-n', type=int, default=1, help='variants per part')
    ap.add_argument('-jobs', type=int, default=2, help='concurrency')
    ap.add_argument('-ignore-window', action='store_true',
                    help='run outside the scheduled window (do not)')
    args = ap.parse_args()

    targets = args.skin or skins()
    print(f'{len(targets)} skins x 4 parts x {args.n} = '
          f'{len(targets) * 4 * args.n} images', flush=True)

    harvested = {}
    for s in targets:
        harvested[s] = prompts_for(s)
        print(f'  {s}: {len(harvested[s])} prompts', flush=True)

    if args.dry_run:
        first = next((s for s in targets if harvested.get(s)), None)
        if first:
            part, text = next(iter(harvested[first].items()))
            print(f'\n--- sample: {first}/{part} ---\n{text}')
        return

    if not in_window() and not args.ignore_window:
        sys.exit(f'outside the {WINDOW_START:%H:%M}-{WINDOW_END:%H:%M} window; '
                 'the box belongs to something else right now')

    work = [(s, part, text, v, abs(hash((s, part, v))) % 2**31)
            for s in targets for part, text in harvested[s].items()
            for v in range(1, args.n + 1)]

    done = 0
    with futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for line in pool.map(lambda a: one(*a), work):
            done += 1
            print(f'[{done}/{len(work)}] {line}', flush=True)

    made = sum(1 for p in OUT.rglob('*.png'))
    print(f'\n{made} PNGs under {OUT.relative_to(ROOT)}')


if __name__ == '__main__':
    main()
