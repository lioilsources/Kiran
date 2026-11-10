#!/usr/bin/env python3
"""Cut a lesson's vertical video in one language (Prompts/29 §6).

    bin/tutorial_assemble.py loop cs [en ja ...]

Inputs (all under run/tutorial/<id>/): capture/ from tutorial_capture.sh,
voice/<lang>/*.wav from tutorial_narrate.py (a missing voice is subtitles
only). Beats come from tutorial/lessons/<id>.json, words from
tutorial/narration/<lang>.json. Output: out/<id>_<lang>.mp4, 1080×1920,
60 fps, H.264 + AAC.

The frame: the game on top (the landscape capture turned back upright,
1080×1440), the input panel below it — the stick, the circle, the stroke
being drawn — and the subtitle. The bottom fifth and the right edge stay
clear of TikTok's and Shorts' buttons.

Elastic beats: a take runs at its own length; a freeze or a card holds as
long as its sentence takes in this language (never shorter than "min").
That is how one cut fits fifteen languages of different lengths.
"""
import json
import math
import os
import shutil
import subprocess
import sys
import wave

from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
W, H = 1080, 1920
GAME_H = 1440
FPS = 60
FONT_PATHS = [
    '/Library/Fonts/Arial Unicode.ttf',
    '/System/Library/Fonts/Supplemental/Arial Unicode.ttf',
    '/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf',
]
LAYER = {'hull': (92, 242, 232), 'arms': (255, 184, 77), 'wing': (124, 255, 138)}
GOLD = (255, 224, 112)
MAX_SECONDS = 59.0


def font(size):
    for p in FONT_PATHS:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def load(*parts):
    return json.load(open(os.path.join(ROOT, *parts), encoding='utf-8'))


def wav_seconds(path):
    with wave.open(path) as w:
        return w.getnframes() / float(w.getframerate())


RING = [1, 2, 5, 8, 7, 6, 3, 0]


def dot_xy(dot, r):
    if dot == 4:
        return 0.0, 0.0
    a = RING.index(dot) * math.pi / 4
    return math.sin(a) * r, -math.cos(a) * r


class Cutter:
    def __init__(self, lesson_id, lang):
        self.id, self.lang = lesson_id, lang
        self.run = os.path.join(ROOT, 'run', 'tutorial', lesson_id)
        self.cap = os.path.join(self.run, 'capture')
        self.events = json.load(open(os.path.join(self.cap, 'events.json')))
        self.takes = {s['name']: s for s in self.events['segments']}
        self.lesson = load('tutorial', 'lessons', f'{lesson_id}.json')
        self.words = load('tutorial', 'narration', f'{lang}.json')
        self.subs = load('tutorial', 'glossary.json').get('subtitle', {}).get(lang, {})
        self.frames_dir = os.path.join(self.run, f'cut_{lang}')
        shutil.rmtree(self.frames_dir, ignore_errors=True)
        os.makedirs(self.frames_dir)
        self.n = 0
        self.audio = []  # (start seconds, wav path)
        self.f_title = font(64)
        self.f_sub = font(46)
        self.f_small = font(34)
        self.f_call = font(40)
        self.trail = []

    # ── one output frame ──

    def game_image(self, take, i):
        path = os.path.join(self.cap, take, f'frame_{i:05d}.png')
        im = Image.open(path).convert('RGB')
        # The landscape capture is the portrait field turned a quarter
        # counter-clockwise; a quarter clockwise turns it back upright.
        im = im.transpose(Image.Transpose.ROTATE_270)
        return im.resize((W, GAME_H), Image.Resampling.LANCZOS)

    def panel(self, draw, stick, sub):
        cy = GAME_H + 150
        cx = W // 2
        r = 105
        layer = stick.get('l') or 'hull'
        col = LAYER.get(layer, LAYER['hull'])
        draw.ellipse([cx - r - 18, cy - r - 18, cx + r + 18, cy + r + 18], fill=(8, 12, 22))
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=col + (90,), width=2)
        picked = set(stick.get('d') or [])
        for d in range(9):
            x, y = dot_xy(d, r)
            rr = 11 if d in picked else 7
            draw.ellipse([cx + x - rr, cy + y - rr, cx + x + rr, cy + y + rr],
                         fill=col if d in picked else (130, 130, 140))
        if len(self.trail) > 1:
            pts = [(cx + x * r, cy + y * r) for x, y in self.trail]
            draw.line(pts, fill=col, width=7, joint='curve')
        sx, sy = stick.get('x', 0), stick.get('y', 0)
        draw.ellipse([cx + sx * r - 15, cy + sy * r - 15, cx + sx * r + 15, cy + sy * r + 15],
                     fill=(255, 255, 255), outline=col, width=4)
        if sub:
            self.subtitle(draw, sub)

    def subtitle(self, draw, text):
        # Wrapped to the safe width, above the bottom fifth.
        words = text.split(' ')
        lines, line = [], ''
        if ' ' not in text:
            # CJK: wrap by characters.
            for ch in text:
                if draw.textlength(line + ch, font=self.f_sub) > W - 160:
                    lines.append(line)
                    line = ch
                else:
                    line += ch
        else:
            for w in words:
                t = (line + ' ' + w).strip()
                if draw.textlength(t, font=self.f_sub) > W - 160:
                    lines.append(line)
                    line = w
                else:
                    line = t
        lines.append(line)
        y = GAME_H - 40 - 58 * len(lines)
        for ln in lines:
            tw = draw.textlength(ln, font=self.f_sub)
            x = (W - 60 - tw) / 2
            draw.text((x, y), ln, font=self.f_sub, fill=(255, 255, 255),
                      stroke_width=5, stroke_fill=(0, 0, 0))
            y += 58

    def emit(self, im):
        im.save(os.path.join(self.frames_dir, f'f_{self.n:06d}.png'))
        self.n += 1

    def frame(self, take, i, sub=None, callouts=()):
        canvas = Image.new('RGB', (W, H), (4, 6, 12))
        canvas.paste(self.game_image(take, i), (0, 0))
        stick = self.takes[take]['stick'][i]
        if stick.get('d'):
            self.trail.append((stick['x'], stick['y']))
        else:
            self.trail = []
        draw = ImageDraw.Draw(canvas, 'RGBA')
        self.panel(draw, stick, sub)
        for k, c in enumerate(callouts):
            self.callout(draw, c, k)
        return canvas

    def callout(self, draw, text, k):
        y = 110 + k * 70
        tw = draw.textlength(text, font=self.f_call)
        draw.rounded_rectangle([60, y - 8, 60 + tw + 36, y + 52], radius=10,
                               fill=(0, 0, 0, 170), outline=GOLD, width=3)
        draw.text((78, y), text, font=self.f_call, fill=GOLD)

    def card(self, title, line, seconds):
        canvas = Image.new('RGB', (W, H), (6, 8, 18))
        draw = ImageDraw.Draw(canvas, 'RGBA')
        # The sigil's shape, big, upright: forward is up in a vertical video.
        sigil = self.lesson['sigil']
        cx, cy, r = W // 2, 760, 260
        col = LAYER['hull']
        for d in range(9):
            x, y = dot_xy(d, r)
            draw.ellipse([cx + x - 12, cy + y - 12, cx + x + 12, cy + y + 12], fill=(140, 140, 150))
        shape = load('tutorial', 'lessons', f'{self.id}.json').get('shape') or RING
        pts = [(cx, cy)] + [(cx + dot_xy(d, r)[0], cy + dot_xy(d, r)[1]) for d in shape]
        if sigil == 'loop':
            pts = [(cx + dot_xy(d, r)[0], cy + dot_xy(d, r)[1]) for d in RING + [RING[0]]]
        draw.line(pts, fill=col, width=16, joint='curve')
        tw = draw.textlength(title, font=self.f_title)
        draw.text(((W - tw) / 2, 1150), title, font=self.f_title, fill=col)
        if line:
            lw = draw.textlength(line, font=self.f_small)
            draw.text(((W - lw) / 2, 1240), line, font=self.f_small, fill=(220, 220, 230))
        for _ in range(max(1, round(seconds * FPS))):
            self.emit(canvas)

    # ── beats ──

    def phase_frame(self, take):
        for i, s in enumerate(self.takes[take]['stick']):
            if s.get('u'):
                return i
        return len(self.takes[take]['stick']) // 2

    def voice(self, key):
        if not key:
            return None, 0.0
        path = os.path.join(self.run, 'voice', self.lang, f'{key}.wav')
        if not os.path.exists(path):
            return None, 0.0
        return path, wav_seconds(path)

    def text(self, key):
        if not key:
            return None
        t = self.words.get(key)
        return self.subs.get(t, t)

    def cut(self):
        for b in self.lesson['beats']:
            start = self.n / FPS
            wav, secs = self.voice(b.get('voice'))
            if wav:
                self.audio.append((start, wav))
            sub = self.text(b.get('voice'))
            kind = b['kind']
            if kind == 'take':
                take = b['take']
                frames = self.takes[take]['frames']
                lo = self.phase_frame(take) if b.get('from') == 'phase' else 0
                hi = self.phase_frame(take) if b.get('until') == 'phase' else frames
                for i in range(lo, hi):
                    self.emit(self.frame(take, i, sub))
            elif kind == 'freeze':
                take = b['take']
                i = self.phase_frame(take)
                calls = [self.words.get(f'callout.{c}', c) for c in b.get('callouts', [])]
                still = self.frame(take, i, sub, calls)
                for _ in range(round(max(b.get('min', 1.2), secs + 0.3) * FPS)):
                    self.emit(still)
            elif kind == 'card':
                self.card(self.lesson['sigil'].upper(), None, max(b.get('min', 0.9), secs + 0.2))
            elif kind == 'outro':
                self.card('KIRIAN', self.words.get('card.platform', ''),
                          max(b.get('min', 1.5), secs + 0.3))
        total = self.n / FPS
        if total > MAX_SECONDS:
            sys.exit(f'{self.lang}: {total:.1f}s is over the {MAX_SECONDS}s Shorts limit')
        return total

    def encode(self, total):
        out_dir = os.path.join(self.run, 'out')
        os.makedirs(out_dir, exist_ok=True)
        out = os.path.join(out_dir, f'{self.id}_{self.lang}.mp4')
        cmd = ['ffmpeg', '-y', '-loglevel', 'error', '-framerate', str(FPS),
               '-i', os.path.join(self.frames_dir, 'f_%06d.png')]
        filt = []
        for k, (start, wav) in enumerate(self.audio):
            cmd += ['-i', wav]
            ms = int(start * 1000)
            filt.append(f'[{k + 1}:a]adelay={ms}|{ms}[a{k}]')
        if self.audio:
            mix = ''.join(f'[a{k}]' for k in range(len(self.audio)))
            filt.append(f'{mix}amix=inputs={len(self.audio)}:normalize=0,'
                        f'apad,atrim=0:{total:.3f},loudnorm=I=-14:TP=-1.5[aout]')
            cmd += ['-filter_complex', ';'.join(filt), '-map', '0:v', '-map', '[aout]',
                    '-c:a', 'aac', '-b:a', '160k']
        cmd += ['-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '18',
                '-preset', 'medium', '-movflags', '+faststart', out]
        subprocess.run(cmd, check=True)
        return out


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    lesson_id = sys.argv[1]
    for lang in sys.argv[2:]:
        c = Cutter(lesson_id, lang)
        total = c.cut()
        out = c.encode(total)
        shutil.rmtree(c.frames_dir, ignore_errors=True)
        print(f'{lang}: {total:.1f}s → {out}')


if __name__ == '__main__':
    main()
