"""Assembles the trailer from gameplay clips, title cards and the sting.

    python3 store/steam/build_trailer.py                 # animatic: slates
    python3 store/steam/build_trailer.py -clips shots/   # real footage

Output: store/steam/video/kirian_trailer.mp4  (1920x1080, 60 fps, H.264)

Missing gameplay does not stop a build. Any shot without a clip becomes a slate
that states what belongs there, so the whole 75 seconds can be watched and the
pacing judged before a single frame is captured — which is the only way to find
out that a beat is four seconds too long while it is still cheap to change.

Drop clips into the -clips directory named by shot number (`1.mov`, `4.mp4`,
…); anything ffmpeg reads will do. They are trimmed to the timings in
trailer-script.md, so record long and let this cut.
"""
import argparse
import pathlib
import shutil
import subprocess
import sys
import tempfile

from PIL import Image, ImageDraw, ImageFont

ROOT = pathlib.Path(__file__).resolve().parents[2]
CARDS = ROOT / 'store/steam/cards'
VIDEO = ROOT / 'store/steam/video'
FONT = '/System/Library/Fonts/HelveticaNeue.ttc'

W, H, FPS = 1920, 1080, 60

# (shot, seconds, description, card file or None, card start within the shot)
SHOTS = [
    (1, 4.0, 'Cold open — mid-fight, ends on a cannon kill shattering into ice', None, 0),
    (2, 8.0, 'Three escalating combat cuts, different zones', '01_die_keep_everything.png', 4.0),
    (3, 10.0, 'Hull explodes, back to Sector 1, same upgraded loadout', '02_progress_permanent.png', 5.0),
    (4, 12.0, 'Elemental montage — water, ice, flame, lightning, plasma', None, 0),
    (5, 10.0, 'Com Center — gun goes up a tier, generator bar drops', '03_power_is_finite.png', 4.0),
    (6, 12.0, 'Campaign — route map, objective card, boss 1 vs boss 4', '04_campaign.png', 5.0),
    (7, 10.0, 'Skin riff — one held moment, style cut every 6-8 frames', '05_skins.png', 4.5),
    (8, 4.0, 'Co-op — two ships, one screen', '06_coop.png', 0.5),
]
STING = (9, 5.0, 'Sting — generated plate, logo, platforms', '07_coming_soon.png', 1.5)


def run(args):
    p = subprocess.run(args, capture_output=True, text=True)
    if p.returncode:
        sys.exit(f'ffmpeg failed:\n{" ".join(args[:6])}…\n{p.stderr[-1500:]}')


def slate(shot, seconds, text, dest):
    """A stand-in frame that says what is missing, rather than black."""
    im = Image.new('RGB', (W, H), (14, 16, 20))
    d = ImageDraw.Draw(im)
    d.text((W / 2, H / 2 - 150), f'SHOT {shot}',
           font=ImageFont.truetype(FONT, 150, index=9), anchor='ma',
           fill=(74, 222, 232))
    d.text((W / 2, H / 2 + 40), text,
           font=ImageFont.truetype(FONT, 46, index=4), anchor='ma',
           fill=(225, 228, 232))
    d.text((W / 2, H / 2 + 130), f'{seconds:.1f}s  ·  GAMEPLAY TO BE RECORDED',
           font=ImageFont.truetype(FONT, 34, index=4), anchor='ma',
           fill=(120, 128, 138))
    im.save(dest)


def segment(tmp, idx, shot, seconds, desc, card, card_at, clip):
    """One shot, normalised to 1920x1080@60 so concat never re-encodes twice."""
    out = tmp / f'seg{idx:02d}.mp4'
    overlays, inputs = [], []

    if clip:
        inputs += ['-t', str(seconds), '-i', str(clip)]
        base = (f'[0:v]scale={W}:{H}:force_original_aspect_ratio=increase,'
                f'crop={W}:{H},fps={FPS},setsar=1[bg]')
    else:
        png = tmp / f'slate{idx:02d}.png'
        slate(shot, seconds, desc, png)
        inputs += ['-loop', '1', '-t', str(seconds), '-i', str(png)]
        base = f'[0:v]fps={FPS},setsar=1[bg]'

    if card:
        inputs += ['-loop', '1', '-t', str(seconds), '-i', str(CARDS / card)]
        # Cards hold ~1.8 s and fade at both ends; a hard cut on type reads as
        # a glitch at 60 fps.
        hold = 1.8
        a, b = card_at, card_at + hold
        overlays.append(
            f'[1:v]fps={FPS},setsar=1,format=rgba,'
            f"fade=t=in:st={a:.2f}:d=0.25:alpha=1,"
            f"fade=t=out:st={b - 0.25:.2f}:d=0.25:alpha=1[cd];"
            f"[bg][cd]overlay=0:0:enable='between(t,{a:.2f},{b:.2f})'[v]")
    else:
        overlays.append('[bg]null[v]')

    run(['ffmpeg', '-y', *inputs, '-filter_complex', f'{base};{";".join(overlays)}',
         '-map', '[v]', '-an', '-c:v', 'libx264', '-preset', 'medium',
         '-crf', '17', '-pix_fmt', 'yuv420p', '-r', str(FPS), str(out)])
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-clips', type=pathlib.Path, default=None,
                    help='directory of gameplay clips named 1.*, 2.* …')
    ap.add_argument('-sting', type=pathlib.Path,
                    default=VIDEO / 'sting_v1.webm')
    ap.add_argument('-out', type=pathlib.Path,
                    default=VIDEO / 'kirian_trailer.mp4')
    args = ap.parse_args()

    if not shutil.which('ffmpeg'):
        sys.exit('ffmpeg not found')
    VIDEO.mkdir(parents=True, exist_ok=True)

    def find(shot):
        if not args.clips:
            return None
        hits = sorted(args.clips.glob(f'{shot}.*'))
        return hits[0] if hits else None

    tmp = pathlib.Path(tempfile.mkdtemp(prefix='kirian-trailer-'))
    try:
        segs, missing = [], []
        for i, (shot, secs, desc, card, at) in enumerate(SHOTS, 1):
            clip = find(shot)
            if not clip:
                missing.append(shot)
            segs.append(segment(tmp, i, shot, secs, desc, card, at, clip))
            print(f'shot {shot}: {"clip " + clip.name if clip else "SLATE"}', flush=True)

        shot, secs, desc, card, at = STING
        sting = args.sting if args.sting.exists() else None
        if not sting:
            missing.append(shot)
        segs.append(segment(tmp, 9, shot, secs, desc, card, at, sting))
        print(f'shot {shot}: {"sting" if sting else "SLATE"}', flush=True)

        lst = tmp / 'concat.txt'
        lst.write_text(''.join(f"file '{s}'\n" for s in segs))
        run(['ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', str(lst),
             '-c', 'copy', str(args.out)])

        total = sum(s[1] for s in SHOTS) + STING[1]
        print(f'\n{args.out.relative_to(ROOT)}  {total:.0f}s  {W}x{H}@{FPS}')
        if missing:
            print(f'slates still standing in for shots: '
                  f'{", ".join(str(m) for m in missing)}')
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == '__main__':
    main()
