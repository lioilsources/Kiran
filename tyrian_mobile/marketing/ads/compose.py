#!/usr/bin/env python3
"""Google Ads App campaign assets (images + video) from real gameplay captures.

    python3 marketing/ads/compose.py -reel <reel dir> -boss <boss dir> \
        -icon <icon.png> -out marketing/ads/2026-11 [-music theme_5.ogg]

Input, all from the v2.10.1 app on an iPhone 17 Pro Max simulator (1320x2868):
  <reel dir>/<skin id>/reel.mov, play_N.png   SHOTS_SCENE=reel, one skin per run
  <boss dir>/boss.mov, play_boss_N.png         SHOTS_SCENE=boss (Kiran skin)
See README.md next to the output for how they were captured.

Output:
  images/landscape_{1,2,3}.png  1200x628   action / skin collage / big wave
  images/square_{1,2,3}.png     1200x1200  the same, rearranged
  images/portrait_{1,2,3}.png   1200x1500  action / three skins / boss
  images/logo.png               1200x1200  the app icon
  video/kirian_{9x16,1x1,16x9}.mp4         silent, 27 s
  video/with-game-music/…                  the same with the game's theme

Text stays minimal and English, no buttons or fake UI (Google rejects both),
and what matters is kept in the centre since Google crops images.
"""
import argparse
import pathlib
import shutil
import subprocess
import tempfile

from PIL import Image, ImageDraw, ImageFilter, ImageFont

FONTS = pathlib.Path('/System/Library/Fonts')
SF = FONTS / 'SFNS.ttf'
CYAN = (74, 222, 232)
CLAIM = '40 YEARS OF ARCADE'

# Gameplay area of a 1320x2868 capture: below the status bar, above the HUD.
GAME_TOP, GAME_BOTTOM = 150, 2380

# Skin id -> (era year, densest still). The stills are ~47-54 s into each
# reel, when the level-10 waves stack up.
SKINS = {
    'asteroids': (1979, 8),
    'galaga': (1981, 8),
    'tyrian_dos': (1995, 8),
    'ikaruga': (2001, 9),
    'geometry_wars': (2003, 8),
    'nex_machina': (2017, 8),
}
# The icon of the release the ads point at; main carries the 3.x icon, so the
# 2.10.1 one comes in from git: git show v2.10.1:tyrian_mobile/assets/icon/icon.png
ICON = None  # -icon
ACTION = 'galaga'  # red-on-black swarm: reads best at thumbnail size
BOSS_STILL = 'play_boss_2'  # boss centred over the ship, mid-fight
WAVE = 'nex_machina'  # set 3 in landscape/square: a wide wave reads better than
                      # the lone boss, which needs the portrait frame

# Video: (source, start s, length s, year tag or None). Densest action first,
# then one era per cut, then the boss going down.
SEGMENTS = [
    ('galaga', 47.0, 3.0, 1981),
    ('asteroids', 47.0, 3.0, 1979),
    ('tyrian_dos', 50.0, 3.0, 1995),
    ('ikaruga', 49.0, 3.0, 2001),
    ('geometry_wars', 48.0, 3.0, 2003),
    ('nex_machina', 49.0, 3.0, 2017),
    ('boss', 144.5, 5.0, None),
]
CLAIM_AT = (3.0, 9.0)  # seconds the claim is on screen
END_CARD = 4.0
FPS = 30


def font(size, weight=860):
    f = ImageFont.truetype(str(SF), size)
    # SFNS axes: Width, Optical Size, GRAD, Weight.
    f.set_variation_by_axes([100, min(96, max(17, size)), 400, weight])
    return f


def game(img):
    return img.crop((0, GAME_TOP, img.width, GAME_BOTTOM))


def crop_aspect(img, w, h, cy=0.5):
    """Largest w:h window of img, centred horizontally, at height fraction cy."""
    W, H = img.size
    if W / H > w / h:
        cw, ch = round(H * w / h), H
    else:
        cw, ch = W, round(W * h / w)
    x = (W - cw) // 2
    y = min(max(0, round(cy * H - ch / 2)), H - ch)
    return img.crop((x, y, x + cw, y + ch)).resize((w, h), Image.LANCZOS)


def shade(canvas, top, bottom, alpha=200):
    """Dark gradient from y=top (opaque) to y=bottom (clear), for text."""
    over = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(over)
    span = bottom - top
    for i in range(abs(span)):
        a = round(alpha * (1 - i / abs(span)))
        y = top + (i if span > 0 else -i)
        d.line([(0, y), (canvas.width, y)], fill=(0, 0, 16, a))
    canvas.alpha_composite(over)


def text_c(canvas, y, s, size, fill=(255, 255, 255), weight=860, glow=True):
    """Centred text at y (top), with a soft cyan glow behind it."""
    f = font(size, weight)
    d = ImageDraw.Draw(canvas)
    w = d.textlength(s, font=f)
    x = (canvas.width - w) / 2
    if glow:
        g = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
        ImageDraw.Draw(g).text((x, y), s, font=f, fill=CYAN + (170,))
        canvas.alpha_composite(g.filter(ImageFilter.GaussianBlur(size / 6)))
    d.text((x, y), s, font=f, fill=fill)


def tag(canvas, cx, y, year, size):
    """A year label on a dark pill, centred on cx."""
    f = font(size, 700)
    d = ImageDraw.Draw(canvas)
    s = str(year)
    w = d.textlength(s, font=f)
    pad = size * 0.35
    box = (cx - w / 2 - pad, y - pad * 0.4, cx + w / 2 + pad, y + size * 1.05 + pad * 0.4)
    over = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(over).rounded_rectangle(box, radius=size * 0.5,
                                           fill=(0, 0, 16, 190), outline=CYAN + (200,), width=2)
    canvas.alpha_composite(over)
    d.text((cx - w / 2, y), s, font=f, fill=(255, 255, 255))


def strips(stills, w, h, cols, rows, gap=6):
    """Grid of gameplay crops, one per skin, with its year under each."""
    canvas = Image.new('RGBA', (w, h), (0, 0, 16, 255))
    cw = (w - gap * (cols - 1)) / cols
    ch = (h - gap * (rows - 1)) / rows
    for i, (img, year) in enumerate(stills):
        c, r = i % cols, i // cols
        x, y = round(c * (cw + gap)), round(r * (ch + gap))
        cell = crop_aspect(img, round(cw), round(ch), 0.55)
        canvas.paste(cell, (x, y))
        size = round(min(cw, ch) * 0.13)
        tag(canvas, x + cw / 2, y + ch - size * 1.9, year, size)
    return canvas


def images(reel, boss, out):
    out.mkdir(parents=True, exist_ok=True)
    still = {s: game(Image.open(reel / s / f'play_{n}.png').convert('RGB'))
             for s, (_, n) in SKINS.items()}
    years = {s: y for s, (y, _) in SKINS.items()}
    action = still[ACTION]
    boss_img = game(Image.open(boss / f'{BOSS_STILL}.png').convert('RGB'))
    order6 = list(SKINS)

    def save(img, name):
        img.convert('RGB').save(out / name, optimize=True)

    def claim_on(canvas, size):
        shade(canvas, 0, round(size * 3.2))
        text_c(canvas, round(size * 0.7), CLAIM, size)
        return canvas

    # 1.91:1
    save(crop_aspect(action, 1200, 628, 0.25), 'landscape_1.png')
    save(claim_on(strips([(still[s], years[s]) for s in order6], 1200, 628, 6, 1), 46),
         'landscape_2.png')
    save(crop_aspect(still[WAVE], 1200, 628, 0.3), 'landscape_3.png')
    # 1:1
    save(crop_aspect(action, 1200, 1200, 0.42), 'square_1.png')
    save(claim_on(strips([(still[s], years[s]) for s in order6], 1200, 1200, 3, 2), 64),
         'square_2.png')
    save(crop_aspect(still[WAVE], 1200, 1200, 0.4), 'square_3.png')
    # 4:5
    save(crop_aspect(action, 1200, 1500, 0.45), 'portrait_1.png')
    three = ['asteroids', 'ikaruga', 'nex_machina']
    save(claim_on(strips([(still[s], years[s]) for s in three], 1200, 1500, 3, 1), 72),
         'portrait_2.png')
    save(crop_aspect(boss_img, 1200, 1500, 0.38), 'portrait_3.png')
    # Logo: the store icon already sits on a clean dark-blue field.
    save(Image.open(ICON).convert('RGB').resize((1200, 1200), Image.LANCZOS), 'logo.png')


# --- video -----------------------------------------------------------------

ASPECTS = {  # name -> (w, h)
    '9x16': (1080, 1920),
    '1x1': (1080, 1080),
    '16x9': (1920, 1080),
}


def overlay_png(path, w, h, year=None, claim=False):
    canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    short = min(w, h)
    if claim:
        size = round(short * 0.065)
        shade(canvas, 0, round(size * 3.4))
        text_c(canvas, round(size * 0.8), CLAIM, size)
    if year:
        size = round(short * 0.06)
        tag(canvas, w / 2, h - size * 2.6, year, size)
    canvas.save(path)


def end_card(path, w, h):
    canvas = Image.new('RGBA', (w, h), (0, 0, 0, 255))
    grad = Image.new('RGBA', (1, 2))
    grad.putpixel((0, 0), (10, 10, 46, 255))
    grad.putpixel((0, 1), (0, 0, 16, 255))
    canvas.alpha_composite(grad.resize((w, h), Image.BILINEAR))
    short = min(w, h)
    icon_size = round(short * 0.36)
    icon = Image.open(ICON).convert('RGBA').resize((icon_size, icon_size), Image.LANCZOS)
    mask = Image.new('L', icon.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, icon_size, icon_size),
                                           radius=round(icon_size * 0.22), fill=255)
    title = round(short * 0.1)
    sub = round(short * 0.055)
    block = icon_size + title * 0.5 + title * 1.2 + sub * 1.4
    top = round((h - block) / 2)
    canvas.paste(icon, ((w - icon_size) // 2, top), mask)
    y = top + icon_size + round(title * 0.5)
    text_c(canvas, y, 'KIRIAN', title)
    text_c(canvas, y + round(title * 1.3), 'Free to Play', sub, fill=CYAN, weight=600,
           glow=False)
    canvas.convert('RGB').save(path)


def video_filter(seg_inputs, aspect):
    """filter_complex for one aspect: crop/scale each segment, overlay its
    PNG, concat with the end card."""
    w, h = ASPECTS[aspect]
    gw, gh = 1320, GAME_BOTTOM - GAME_TOP
    parts = []
    labels = []
    for i, (vin, start, length, png_in, cy) in enumerate(seg_inputs):
        base = (f'[{vin}:v]trim=start={start}:duration={length},setpts=PTS-STARTPTS,'
                f'fps={FPS},crop={gw}:{gh}:0:{GAME_TOP}')
        if aspect == '9x16':
            ch = round(gw * 16 / 9)  # 2347: a little more than the game area
            parts.append(f'[{vin}:v]trim=start={start}:duration={length},setpts=PTS-STARTPTS,'
                         f'fps={FPS},crop={gw}:{ch}:0:{GAME_TOP},scale={w}:{h},setsar=1[s{i}]')
        elif aspect == '1x1':
            y = GAME_TOP + round(gh * cy - gw / 2)
            parts.append(f'[{vin}:v]trim=start={start}:duration={length},setpts=PTS-STARTPTS,'
                         f'fps={FPS},crop={gw}:{gw}:0:{y},scale={w}:{h},setsar=1[s{i}]')
        else:  # 16x9: gameplay in the middle, its own blurred frame behind
            fw = round(h * gw / gh / 2) * 2
            parts.append(f'{base},split[a{i}][b{i}]')
            parts.append(f'[a{i}]scale={w}:-2,crop={w}:{h},boxblur=30:3,'
                         f'eq=brightness=-0.18[bg{i}]')
            parts.append(f'[b{i}]scale={fw}:{h}[fg{i}]')
            parts.append(f'[bg{i}][fg{i}]overlay=(W-w)/2:0,setsar=1[s{i}]')
        parts.append(f'[s{i}][{png_in}:v]overlay=0:0:shortest=0:eof_action=repeat,'
                     f'format=yuv420p[v{i}]')
        labels.append(f'[v{i}]')
    return parts, labels


def videos(reel, boss, out, music):
    out.mkdir(parents=True, exist_ok=True)
    (out / 'with-game-music').mkdir(exist_ok=True)
    total = sum(s[2] for s in SEGMENTS) + END_CARD
    with tempfile.TemporaryDirectory() as tmp:
        tmp = pathlib.Path(tmp)
        for aspect, (w, h) in ASPECTS.items():
            args = ['ffmpeg', '-y', '-loglevel', 'error']
            sources = {}
            seg_inputs = []
            t = 0.0
            for i, (src, start, length, year) in enumerate(SEGMENTS):
                if src not in sources:
                    mov = boss / 'boss.mov' if src == 'boss' else reel / src / 'reel.mov'
                    sources[src] = len(sources)
                    args += ['-i', str(mov)]
                png = tmp / f'{aspect}_{i}.png'
                claim = t < CLAIM_AT[1] and t + length > CLAIM_AT[0]
                overlay_png(png, w, h, year, claim)
                seg_inputs.append((src, start, length, png))
                t += length
            n_vid = len(sources)
            fixed = []
            for i, (src, start, length, png) in enumerate(seg_inputs):
                args += ['-loop', '1', '-t', str(length), '-i', str(png)]
                # Square crop height: the boss sits high, waves fill the middle.
                fixed.append((sources[src], start, length, n_vid + i,
                              0.32 if src == 'boss' else 0.55))
            card = tmp / f'{aspect}_card.png'
            end_card(card, w, h)
            card_in = n_vid + len(seg_inputs)
            args += ['-loop', '1', '-t', str(END_CARD), '-i', str(card)]
            parts, labels = video_filter(fixed, aspect)
            parts.append(f'[{card_in}:v]fps={FPS},format=yuv420p,'
                         f'fade=t=in:d=0.4,setsar=1[vend]')
            labels.append('[vend]')
            parts.append(f'{"".join(labels)}concat=n={len(labels)}:v=1:a=0[v]')
            silent = out / f'kirian_{aspect}.mp4'
            subprocess.run(args + [
                '-filter_complex', ';'.join(parts), '-map', '[v]',
                '-c:v', 'libx264', '-profile:v', 'high', '-pix_fmt', 'yuv420p',
                '-r', str(FPS), '-crf', '21', '-maxrate', '8M', '-bufsize', '16M',
                '-movflags', '+faststart', str(silent)], check=True)
            if music:
                subprocess.run([
                    'ffmpeg', '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(music),
                    '-filter_complex',
                    f'[1:a]atrim=duration={total},afade=t=in:d=0.3,'
                    f'afade=t=out:st={total - 2.5}:d=2.5[a]',
                    '-map', '0:v', '-map', '[a]', '-c:v', 'copy',
                    '-c:a', 'aac', '-b:a', '160k', '-ac', '2', '-ar', '48000',
                    '-shortest', '-movflags', '+faststart',
                    str(out / 'with-game-music' / silent.name)], check=True)
            print('video', aspect)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('-reel', required=True, type=pathlib.Path)
    p.add_argument('-boss', required=True, type=pathlib.Path)
    p.add_argument('-out', required=True, type=pathlib.Path)
    p.add_argument('-music', type=pathlib.Path,
                   help="the game's theme for the with-game-music variants")
    p.add_argument('-icon', required=True, type=pathlib.Path)
    p.add_argument('-only', choices=['images', 'video'])
    a = p.parse_args()
    global ICON
    ICON = a.icon
    if a.only != 'video':
        images(a.reel, a.boss, a.out / 'images')
        print('images')
    if a.only != 'images':
        if not shutil.which('ffmpeg'):
            raise SystemExit('ffmpeg not found')
        videos(a.reel, a.boss, a.out / 'video', a.music)


if __name__ == '__main__':
    main()
