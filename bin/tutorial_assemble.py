#!/usr/bin/env python3
"""Cut a lesson's vertical video in one language (Prompts/29 §6).

    bin/tutorial_assemble.py loop cs [en ja ...]

Inputs (all under run/tutorial/<id>/): capture/ from tutorial_capture.sh,
voice/<lang>/*.wav from tutorial_narrate.py (a missing voice is subtitles
only). Beats come from tutorial/lessons/<id>.json, words from
tutorial/narration/<lang>.json. Output: out/<id>_<lang>.mp4, 1080×1920,
60 fps, H.264 + AAC.

The frame: the game on top, the input panel below it — the stick, the
circle, the stroke being drawn — and the subtitle. A flight take is the
landscape capture turned back upright, 1080×1440, with the subtitle over its
foot; a duel take (Prompts/30 §10, `orientation: duel` in events.json) is
filmed upright already, 1080×1080, with a taller panel turned the way the
pad was. The subtitle sits over the foot of the game picture. The bottom
fifth and the right edge stay clear of TikTok's and Shorts' buttons.

Elastic beats: a take runs at its own length; a freeze or a card holds as
long as its sentence takes in this language (never shorter than "min").
That is how one cut fits fifteen languages of different lengths.

Sound: the voice on top; under it the game's own effects, placed where the
capture logged them (events.json, "s" per frame — the game films silent),
and the skin's boss theme. Both stay low and dip further while the voice
speaks, so the voice is never covered and a silent beat is never silent.
"""
import array
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
SKINS = os.path.join('tyrian_mobile', 'assets', 'skins')
BED_RATE = 24000          # the effects bed, mono: plenty for a bed under a voice
SFX_FLOOR = 0.07          # s between two of the same effect, as in the game
SFX_GAIN = {'fireBullet': 0.35, 'fireBeam': 0.4, 'explosionSmall': 0.7,
            'explosionLarge': 0.9}
SFX_BUS = 0.5             # the effects under everything
MUSIC_BUS = 0.22          # the boss theme under everything
MUSIC_TIER = 5            # theme_5: the boss tier; every lesson is a duel
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
        self.sfx = []    # (start seconds, effect name)
        self._last_sfx = {}
        self.skin = self.events.get('skin') or 'default'
        self.f_title = font(64)
        self.f_sub = font(46)
        self.f_small = font(34)
        self.f_call = font(40)
        self.trail = []
        # A duel is filmed upright and square; the flight on its side.
        self.duel = self.events.get('orientation') == 'duel'
        self.game_h = 1080 if self.duel else GAME_H

    # ── one output frame ──

    def game_image(self, take, i):
        path = os.path.join(self.cap, take, f'frame_{i:05d}.png')
        im = Image.open(path).convert('RGB')
        game_h = self.game_h
        if not self.duel:
            # The landscape capture is the portrait field turned a quarter
            # counter-clockwise; a quarter clockwise turns it back upright.
            im = im.transpose(Image.Transpose.ROTATE_270)
        # Fill the width, keep the aspect, crop what overhangs top and bottom
        # evenly: the window is not always the size that was asked for.
        h = round(im.height * W / im.width)
        im = im.resize((W, h), Image.Resampling.LANCZOS)
        if h > game_h:
            top = (h - game_h) // 2
            im = im.crop((0, top, W, top + game_h))
        elif h < game_h:
            pad = Image.new('RGB', (W, game_h), (4, 6, 12))
            pad.paste(im, (0, (game_h - h) // 2))
            im = pad
        return im

    def panel(self, draw, stick, sub):
        cy = self.game_h + (210 if self.duel else 150)
        cx = W // 2
        r = 140 if self.duel else 105
        # A duel's pad turns with the nose: ship space onto the screen.
        a = stick.get('a', 0.0)
        ca, sa = math.cos(a), math.sin(a)

        def turn(x, y):
            return x * ca - y * sa, x * sa + y * ca

        layer = stick.get('l') or 'hull'
        col = LAYER.get(layer, LAYER['hull'])
        draw.ellipse([cx - r - 18, cy - r - 18, cx + r + 18, cy + r + 18], fill=(8, 12, 22))
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=col + (90,), width=2)
        picked = set(stick.get('d') or [])
        for d in range(9):
            x, y = turn(*dot_xy(d, r))
            rr = 11 if d in picked else 7
            draw.ellipse([cx + x - rr, cy + y - rr, cx + x + rr, cy + y + rr],
                         fill=col if d in picked else (130, 130, 140))
        if self.duel:
            # The nose: where forward is on the pad.
            nx, ny = turn(0, -(r + 30))
            bx, by = turn(0, -(r + 12))
            px, py = turn(9, 0)
            draw.polygon([(cx + nx, cy + ny), (cx + bx + px, cy + by + py),
                          (cx + bx - px, cy + by - py)], fill=(235, 235, 240))
        if len(self.trail) > 1:
            pts = [(cx + turn(x, y)[0] * r, cy + turn(x, y)[1] * r) for x, y in self.trail]
            draw.line(pts, fill=col, width=7, joint='curve')
        sx, sy = turn(stick.get('x', 0), stick.get('y', 0))
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
        # Over the foot of the game picture, clear of the bottom fifth.
        y = self.game_h - 40 - 58 * len(lines)
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
        cx, cy, r = W // 2, 760, 260
        col = LAYER['hull']
        for d in range(9):
            x, y = dot_xy(d, r)
            draw.ellipse([cx + x - 12, cy + y - 12, cx + x + 12, cy + y + 12], fill=(140, 140, 150))
        shape = self.lesson.get('shape') or RING
        if len(shape) % 8 == 0 and set(shape) == set(RING):
            # A circle sigil is a circle, not an octagon through its dots.
            draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=col, width=16)
        else:
            pts = [(cx, cy)] + [(cx + dot_xy(d, r)[0], cy + dot_xy(d, r)[1]) for d in shape]
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
                    self.effects(self.takes[take]['stick'][i].get('s'))
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

    # ── the bed under the voice ──

    def effects(self, names):
        """The effects the game asked for on the frame about to be emitted."""
        t = self.n / FPS
        for name in names or ():
            last = self._last_sfx.get(name)
            if last is not None and t - last < SFX_FLOOR:
                continue
            self._last_sfx[name] = t
            self.sfx.append((t, name))

    def asset(self, kind, name):
        """The skin's file, or the default skin's."""
        for skin in (self.skin, 'default'):
            p = os.path.join(ROOT, SKINS, skin, kind, name)
            if os.path.exists(p):
                return p
        return None

    @staticmethod
    def pcm(path):
        """A sound file as mono samples at BED_RATE."""
        raw = subprocess.run(
            ['ffmpeg', '-loglevel', 'error', '-i', path, '-ac', '1', '-ar', str(BED_RATE),
             '-f', 's16le', '-'], check=True, capture_output=True).stdout
        a = array.array('h')
        a.frombytes(raw)
        return a

    def effects_bed(self, total):
        """Every logged effect mixed into one mono WAV; None when there are none."""
        if not self.sfx:
            return None
        n = int(total * BED_RATE) + 1
        bed = array.array('f', bytes(4 * n))
        clips = {}
        for t, name in self.sfx:
            if name not in clips:
                file = re_snake(name) + '.ogg'
                path = self.asset('sfx', file)
                clips[name] = self.pcm(path) if path else array.array('h')
            clip = clips[name]
            g = SFX_GAIN.get(name, 0.6) / 32768.0
            at = int(t * BED_RATE)
            for k in range(min(len(clip), n - at)):
                bed[at + k] += clip[k] * g
        out = os.path.join(self.run, f'bed_{self.lang}.wav')
        pcm = array.array('h', (max(-32767, min(32767, int(v * 32767))) for v in bed))
        with wave.open(out, 'w') as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(BED_RATE)
            w.writeframes(pcm.tobytes())
        return out

    def encode(self, total):
        out_dir = os.path.join(self.run, 'out')
        os.makedirs(out_dir, exist_ok=True)
        out = os.path.join(out_dir, f'{self.id}_{self.lang}.mp4')
        cmd = ['ffmpeg', '-y', '-loglevel', 'error', '-framerate', str(FPS),
               '-i', os.path.join(self.frames_dir, 'f_%06d.png')]
        filt = []
        k = 0
        for start, wav in self.audio:
            k += 1
            cmd += ['-i', wav]
            ms = int(start * 1000)
            filt.append(f'[{k}:a]adelay={ms}|{ms},aformat=channel_layouts=stereo[a{k}]')
        voices = [f'[a{j}]' for j in range(1, k + 1)]
        bed = []
        fx = self.effects_bed(total)
        if fx:
            k += 1
            cmd += ['-i', fx]
            filt.append(f'[{k}:a]aformat=channel_layouts=stereo,volume={SFX_BUS}[fx]')
            bed.append('[fx]')
        theme = self.asset('music', f'theme_{MUSIC_TIER}.ogg')
        if theme:
            k += 1
            cmd += ['-stream_loop', '-1', '-i', theme]
            filt.append(f'[{k}:a]atrim=0:{total:.3f},aformat=channel_layouts=stereo,'
                        f'volume={MUSIC_BUS},afade=t=out:st={max(0.0, total - 1.5):.3f}:d=1.5[mus]')
            bed.append('[mus]')
        tail = f'apad,atrim=0:{total:.3f},loudnorm=I=-14:TP=-1.5[aout]'
        if voices and bed:
            # The voice dips the bed: a sidechain on the effects and the theme.
            filt.append(f'{"".join(voices)}amix=inputs={len(voices)}:normalize=0,asplit[v][vk]')
            filt.append(f'{"".join(bed)}amix=inputs={len(bed)}:normalize=0[b]')
            filt.append('[b][vk]sidechaincompress=threshold=0.015:ratio=6:attack=30:release=450[bd]')
            filt.append(f'[v][bd]amix=inputs=2:normalize=0,{tail}')
        elif voices or bed:
            src = voices or bed
            filt.append(f'{"".join(src)}amix=inputs={len(src)}:normalize=0,{tail}')
        if filt:
            cmd += ['-filter_complex', ';'.join(filt), '-map', '0:v', '-map', '[aout]',
                    '-c:a', 'aac', '-b:a', '160k']
        cmd += ['-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '18',
                '-preset', 'medium', '-movflags', '+faststart', out]
        subprocess.run(cmd, check=True)
        return out


def re_snake(name):
    """fireBullet → fire_bullet: the game's effect name as its file's."""
    return ''.join('_' + c.lower() if c.isupper() else c for c in name)


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    lesson_id = sys.argv[1]
    for lang in sys.argv[2:]:
        c = Cutter(lesson_id, lang)
        total = c.cut()
        out = c.encode(total)
        shutil.rmtree(c.frames_dir, ignore_errors=True)
        bed = os.path.join(c.run, f'bed_{lang}.wav')
        if os.path.exists(bed):
            os.remove(bed)
        print(f'{lang}: {total:.1f}s → {out}')


if __name__ == '__main__':
    main()
