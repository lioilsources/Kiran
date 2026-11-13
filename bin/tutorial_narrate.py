#!/usr/bin/env python3
"""Voice a lesson's beats in each language (Prompts/29 §7).

    bin/tutorial_narrate.py loop cs en ja

Reads tutorial/lessons/<id>.json for the beats that speak, the sentences
from tutorial/narration/<lang>.json and spoken forms from
tutorial/glossary.json, and asks the SPARK audio service for each sentence
(KIRIAN_AUDIO_URL, from the environment or the repo's .env). Commercially
licensed engines only. One WAV per beat lands in
run/tutorial/<id>/voice/<lang>/<key>.wav; a sentence already voiced with the
same text is skipped, so a changed line costs one call, not the lesson.

GPU-free for the pilot languages (Kokoro, Piper); run it under the broker
anyway, it is a SPARK service:

    sparkctl exec kiran tts 15 low "Kiran tutorial voices" -- bin/tutorial_narrate.py loop cs en ja
"""
import hashlib
import json
import os
import subprocess
import sys
import time
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def env(name):
    if name in os.environ:
        return os.environ[name]
    path = os.path.join(ROOT, '.env')
    if os.path.exists(path):
        for line in open(path, encoding='utf-8'):
            line = line.strip()
            if line.startswith(name + '='):
                return line.split('=', 1)[1].strip()
    sys.exit(f'{name} is not set (environment or .env, see .env.example)')


def load(*parts):
    return json.load(open(os.path.join(ROOT, *parts), encoding='utf-8'))


def call(url, payload=None):
    data = None if payload is None else json.dumps(payload).encode()
    req = urllib.request.Request(url, data=data,
                                 headers={'content-type': 'application/json'})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.load(r)


# The service's language codes; Traditional Chinese is voiced in Mandarin.
LANG = {'zh_Hant': 'zh'}

# Engines picked per language where the service's own choice fails: Kokoro
# reads Japanese one character at a time (pilot, 2026-11-11).
ENGINE = {'ja': 'chatterbox'}

# Characters a second a normal voice reads, per script (§7.4). A take more
# than SUSPECT times longer or shorter than that was not read, it was
# mangled — Kokoro reading Japanese one character at a time ran 20 s for a
# 4 s line. Such a take is kept as <key>.suspect.wav and the video falls
# back to the subtitle for that beat.
RATE = {'ja': 7.0, 'zh': 5.0, 'zh_Hant': 5.0, 'ko': 7.0, 'th': 12.0}
DEFAULT_RATE = 14.0
SUSPECT = 2.5


def plausible(text, lang, secs):
    expect = max(0.4, len(text) / RATE.get(lang, DEFAULT_RATE))
    return expect / SUSPECT <= secs <= expect * SUSPECT


def voice(base, text, lang, out):
    payload = {
        'text': text,
        'language': LANG.get(lang, lang),
        'commercial_only': True,
        'format': 'wav',
        'seed': 7,
    }
    if lang in ENGINE:
        payload['engine'] = ENGINE[lang]
    job = call(f'{base}/v1/audio/tts', payload)
    jid = job['job_id']
    for _ in range(600):
        st = call(f'{base}/v1/audio/jobs/{jid}')
        if st.get('status') in ('done', 'completed', 'succeeded'):
            o = st['outputs'][0]
            url = o['url'] if o['url'].startswith('http') else base + o['url']
            with urllib.request.urlopen(url, timeout=120) as r, open(out, 'wb') as f:
                f.write(r.read())
            return
        if st.get('status') in ('failed', 'error', 'cancelled'):
            raise RuntimeError(f'{lang}: {st}')
        time.sleep(1)
    raise TimeoutError(f'{lang}: job {jid} did not finish')


def seconds(path):
    out = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration',
                          '-of', 'default=nw=1:nk=1', path],
                         capture_output=True, text=True).stdout.strip()
    return float(out or 0)


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    lesson_id, langs = sys.argv[1], sys.argv[2:]
    base = env('KIRIAN_AUDIO_URL').rstrip('/')
    lesson = load('tutorial', 'lessons', f'{lesson_id}.json')
    glossary = load('tutorial', 'glossary.json')
    keys = [b['voice'] for b in lesson['beats'] if b.get('voice')]
    ok = failed = 0
    for lang in langs:
        lines = load('tutorial', 'narration', f'{lang}.json')
        spoken = glossary.get('spoken', {}).get(lang, {})
        folder = os.path.join(ROOT, 'run', 'tutorial', lesson_id, 'voice', lang)
        os.makedirs(folder, exist_ok=True)
        for key in keys:
            text = spoken.get(lines[key], lines[key])
            out = os.path.join(folder, f'{key}.wav')
            stamp = out + '.sha'
            digest = hashlib.sha256(text.encode()).hexdigest()
            if os.path.exists(out) and os.path.exists(stamp) and open(stamp).read() == digest:
                continue
            try:
                voice(base, text, lang, out)
                open(stamp, 'w').write(digest)
                secs = seconds(out)
                if not plausible(text, lang, secs):
                    os.replace(out, out.replace('.wav', '.suspect.wav'))
                    os.remove(stamp)
                    failed += 1
                    print(f'{lang} {key}: SUSPECT {secs:.2f}s  {text}', file=sys.stderr)
                    continue
                ok += 1
                print(f'{lang} {key}: {secs:.2f}s  {text}')
            except Exception as e:  # one bad line must not cost the rest
                failed += 1
                print(f'{lang} {key}: FAILED {e}', file=sys.stderr)
    print(json.dumps({'voices': {'ok': ok, 'failed': failed}}))
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
