"""Tests of bin/tutorial_assemble.py on a synthetic capture.

    python3 -m unittest discover -s tutorial/tests
"""
import importlib.util
import json
import os
import shutil
import struct
import tempfile
import unittest
import wave

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
spec = importlib.util.spec_from_file_location(
    'assemble', os.path.join(ROOT, 'bin', 'tutorial_assemble.py'))
assemble = importlib.util.module_from_spec(spec)
spec.loader.exec_module(assemble)


def wav(path, seconds):
    with wave.open(path, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(8000)
        w.writeframes(struct.pack('<h', 0) * int(8000 * seconds))


class AssembleTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.lesson = 'zz_test'
        self.run = os.path.join(self.tmp, 'run', 'tutorial', self.lesson)
        cap = os.path.join(self.run, 'capture')
        takes = {'hook': 6, 'slow': 10, 'use': 5}
        segs = []
        for name, n in takes.items():
            os.makedirs(os.path.join(cap, name))
            for i in range(n):
                Image.new('RGB', (40, 30), (i * 10, 0, 0)).save(
                    os.path.join(cap, name, f'frame_{i:05d}.png'))
            stick = [{'x': 0, 'y': 0, 'd': [], 'u': name == 'slow' and 4 <= i <= 6,
                      'l': None} for i in range(n)]
            segs.append({'name': name, 'frames': n, 'stick': stick, 'readings': []})
        json.dump({'segments': segs}, open(os.path.join(cap, 'events.json'), 'w'))
        os.makedirs(os.path.join(self.tmp, 'tutorial', 'lessons'))
        os.makedirs(os.path.join(self.tmp, 'tutorial', 'narration'))
        shutil.copy(os.path.join(ROOT, 'tutorial', 'lessons', 'loop.json'),
                    os.path.join(self.tmp, 'tutorial', 'lessons', f'{self.lesson}.json'))
        shutil.copy(os.path.join(ROOT, 'tutorial', 'narration', 'en.json'),
                    os.path.join(self.tmp, 'tutorial', 'narration', 'en.json'))
        shutil.copy(os.path.join(ROOT, 'tutorial', 'glossary.json'),
                    os.path.join(self.tmp, 'tutorial', 'glossary.json'))
        self._root = assemble.ROOT
        assemble.ROOT = self.tmp

    def tearDown(self):
        assemble.ROOT = self._root
        shutil.rmtree(self.tmp, ignore_errors=True)

    def test_takes_freeze_and_cards_in_order(self):
        c = assemble.Cutter(self.lesson, 'en')
        total = c.cut()
        fps = assemble.FPS
        # hook 6 + card ≥0.9 s + slow up to the phase (4) + freeze ≥1.6 s
        # + slow from the phase (6) + use 5 + outro ≥1.8 s.
        frames = 6 + round(0.9 * fps) + 4 + round(1.6 * fps) + 6 + 5 + round(1.8 * fps)
        self.assertEqual(c.n, frames)
        self.assertAlmostEqual(total, frames / fps)

    def test_a_long_sentence_stretches_its_freeze(self):
        voice = os.path.join(self.run, 'voice', 'en')
        os.makedirs(voice)
        wav(os.path.join(voice, 'loop.phase.wav'), 4.0)
        c = assemble.Cutter(self.lesson, 'en')
        c.cut()
        fps = assemble.FPS
        frames = 6 + round(0.9 * fps) + 4 + round(4.3 * fps) + 6 + 5 + round(1.8 * fps)
        self.assertEqual(c.n, frames)
        self.assertEqual(len(c.audio), 1)

    def _orient(self, orientation):
        path = os.path.join(self.run, 'capture', 'events.json')
        ev = json.load(open(path))
        ev['orientation'] = orientation
        json.dump(ev, open(path, 'w'))

    def test_a_flight_take_is_turned_upright(self):
        c = assemble.Cutter(self.lesson, 'en')
        im = c.game_image('hook', 0)
        # 40×30 landscape turned a quarter: taller than wide, filling 1440.
        self.assertEqual(im.size, (assemble.W, assemble.GAME_H))

    def test_a_duel_take_is_not_turned_and_is_square(self):
        # Prompts/30 §10: the duel is filmed upright, the game is 1080×1080.
        self._orient('duel')
        c = assemble.Cutter(self.lesson, 'en')
        self.assertTrue(c.duel)
        im = c.game_image('hook', 0)
        self.assertEqual(im.size, (assemble.W, 1080))
        # A 40×30 frame scaled to the width is 810 high: centred, not turned.
        px = im.getpixel((assemble.W // 2, 1080 // 2))
        self.assertEqual(px[1:], (0, 0))
        frame = c.frame('hook', 0)
        self.assertEqual(frame.size, (assemble.W, assemble.H))

    def test_a_duel_panel_turns_with_the_pad(self):
        self._orient('duel')
        c = assemble.Cutter(self.lesson, 'en')
        from PIL import ImageDraw
        a = Image.new('RGB', (assemble.W, assemble.H))
        b = Image.new('RGB', (assemble.W, assemble.H))
        stick = {'x': 0.0, 'y': -1.0, 'd': [1], 'l': 'hull'}
        c.panel(ImageDraw.Draw(a, 'RGBA'), dict(stick), None)
        c.panel(ImageDraw.Draw(b, 'RGBA'), dict(stick, a=1.5707963), None)
        self.assertNotEqual(a.tobytes(), b.tobytes())

    def test_effects_land_where_the_capture_logged_them(self):
        path = os.path.join(self.run, 'capture', 'events.json')
        ev = json.load(open(path))
        hook = next(s for s in ev['segments'] if s['name'] == 'hook')
        hook['stick'][2]['s'] = ['fireBullet', 'explosionSmall']
        hook['stick'][3]['s'] = ['fireBullet']  # 1/60 s later: under the floor
        json.dump(ev, open(path, 'w'))
        sfx = os.path.join(self.tmp, 'tyrian_mobile', 'assets', 'skins', 'default', 'sfx')
        os.makedirs(sfx)
        # A tone as the effect; ffmpeg reads it by its content.
        with wave.open(os.path.join(sfx, 'fire_bullet.ogg'), 'w') as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(8000)
            w.writeframes(struct.pack('<h', 12000) * 800)
        c = assemble.Cutter(self.lesson, 'en')
        total = c.cut()
        self.assertEqual([n for _, n in c.sfx], ['fireBullet', 'explosionSmall'])
        self.assertAlmostEqual(c.sfx[0][0], 2 / assemble.FPS)
        bed = c.effects_bed(total)
        with wave.open(bed) as w:
            frames = w.readframes(w.getnframes())
        loud = [abs(v) for v in struct.unpack(f'<{len(frames) // 2}h', frames)]
        at = int(2 / assemble.FPS * assemble.BED_RATE)
        self.assertGreater(max(loud[at:at + 1000]), 1000)
        self.assertEqual(max(loud[:at - 10]), 0, 'nothing before the shot')

    def test_over_the_shorts_limit_refuses(self):
        voice = os.path.join(self.run, 'voice', 'en')
        os.makedirs(voice)
        wav(os.path.join(voice, 'outro.wav'), 70)
        c = assemble.Cutter(self.lesson, 'en')
        with self.assertRaises(SystemExit):
            c.cut()


if __name__ == '__main__':
    unittest.main()
