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

    def test_over_the_shorts_limit_refuses(self):
        voice = os.path.join(self.run, 'voice', 'en')
        os.makedirs(voice)
        wav(os.path.join(voice, 'outro.wav'), 70)
        c = assemble.Cutter(self.lesson, 'en')
        with self.assertRaises(SystemExit):
            c.cut()


if __name__ == '__main__':
    unittest.main()
