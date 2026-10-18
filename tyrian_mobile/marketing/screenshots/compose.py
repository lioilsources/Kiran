#!/usr/bin/env python3
"""Captioned store screenshots and App Store creative assets, per language.

    python3 marketing/screenshots/compose.py            # ja
    python3 marketing/screenshots/compose.py -lang ja

Input: raw simulator captures from tool/store_screenshots.sh
  build/store_screenshots/iphone/<scene>.png   (iPhone 17 Pro Max, 1320x2868)
  build/store_screenshots/ipad/<scene>.png     (iPad Pro 13", 2064x2752)

Output: marketing/screenshots-<lang>/
  appstore-iphone-6.9/NN_<scene>.png   1320x2868
  appstore-iphone-6.3/NN_<scene>.png   1206x2622
  appstore-ipad-13/NN_<scene>.png      2064x2752
  play-phone/NN_<scene>.png            1080x1920
  play-tablet7/NN_<scene>.png          1200x1920
  play-tablet10/NN_<scene>.png         1600x2560
  appstore-creative/header-3840x1646.png      product page header (21:9)
  appstore-creative/search-3840x2560.png      search results (3:2)

The game UI is English-only, so each shot is the real English screen under a
caption in the listing language — the standard way to localize a listing
without localizing the app. Every file is flattened RGB: App Store Connect
rejects alpha.

The header and search assets are new in App Store Connect (iOS 27+, both
optional, attached per localization). Apple publishes sizes but no crop rule,
so everything that matters is kept in the centre; check Preview in App Store
Connect on iPhone and iPad before submitting.
"""
import argparse
import pathlib

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = pathlib.Path(__file__).resolve().parents[2]
RAW = ROOT / 'build/store_screenshots'  # -raw overrides

# Hiragino Sans: W8 for headlines, W4 for the line under them. Ships with
# macOS; the file names are Japanese.
FONTS = pathlib.Path('/System/Library/Fonts')
HEAD = FONTS / 'ヒラギノ角ゴシック W8.ttc'
BODY = FONTS / 'ヒラギノ角ゴシック W4.ttc'

CYAN = (74, 222, 232)
BG_TOP = (10, 10, 46)      # the skin selector's gradient
BG_BOTTOM = (0, 0, 16)

# (scene, raw capture, headline, subline) per language, in store order.
# The first two carry the listing — most people never swipe past them.
SCENES = {
    # v2.9.1: 14 skins, no Campaign, no difficulty selection. The v3.7.0 set
    # (Campaign, enemy fire patterns, 24 skins) is in commit a4245b3.
    'ja': [
        ('roguelike', 'play_default_1',
         '死んでも、すべて持ち越し。', '武器もクレジットもスコアも。もっと深くへ。'),
        ('skins', 'play_neon_grid_0',
         '14種のスキンで、丸ごと変わる', '船・敵・背景・UI・サウンドまで一新'),
        ('comcenter', 'comcenter_default',
         '25段階の強化。出力をやりくりせよ', 'フロント、サイド、ジェネレーター、シールド'),
        ('elemental', 'play_default_0',
         '倒し方で、散り方が変わる', '水しぶき・氷・炎・稲妻・プラズマ'),
        ('endless', 'play_pixel_0',
         '18の手作りセクター、その先は無限', '5レベルごとにボスが待ち受ける'),
        ('nofree2play', 'skins',
         '広告なし。買い切りのみ。', '3種は無料、追加スキンは1つずつ買い切り'),
    ],
    # Google Play default listing (en-US); same scenes as ja.
    'en': [
        ('roguelike', 'play_default_1',
         'Die. Keep everything.', 'Weapons, credits, score. Push deeper.'),
        ('skins', 'play_neon_grid_0',
         '14 skins restyle everything', 'Ships, enemies, backgrounds, UI and sound'),
        ('comcenter', 'comcenter_default',
         '25 upgrade levels. Mind the power.', 'Front, side, generator, shield'),
        ('elemental', 'play_default_0',
         'Every weapon kills differently', 'Water, ice, fire, lightning, plasma'),
        ('endless', 'play_pixel_0',
         '18 hand-built sectors, then forever', 'A boss waits every fifth level'),
        ('nofree2play', 'skins',
         'No ads. Buy once.', 'Three skins free, the rest one-time purchases'),
    ],
}

# Search results line per language. The header carries no text — Apple's
# guidance there is mood, not features, and the name and Get button sit right
# under it — so only the search asset is localized.
SEARCH_LINE = {
    'ja': '死んでも、すべて持ち越し。',
    'en': 'Die. Keep everything.',
}

# Raw captures for the creative assets, left to right.
# v2.9.1 walk: the biomech captures landed on the Com Center (the seeded ship
# had died by then), so they are not used.
HEADER_SHOTS = ['play_pixel_0', 'play_neon_grid_0', 'play_default_1',
                'play_dual_polarity_1', 'play_neon_grid_1']
SEARCH_SHOTS = ['play_neon_grid_0', 'play_default_1', 'play_pixel_0']

# name: (w, h, raw source folder)
TARGETS = {
    'appstore-iphone-6.9': (1320, 2868, 'iphone'),
    'appstore-iphone-6.3': (1206, 2622, 'iphone'),
    'appstore-ipad-13': (2064, 2752, 'ipad'),
    'play-phone': (1080, 1920, 'iphone'),
    'play-tablet7': (1200, 1920, 'ipad'),
    'play-tablet10': (1600, 2560, 'ipad'),
}


def gradient(w, h, top=BG_TOP, bottom=BG_BOTTOM):
    g = Image.new('RGB', (1, 256))
    for y in range(256):
        t = y / 255
        g.putpixel((0, y), tuple(round(a + (b - a) * t)
                                 for a, b in zip(top, bottom)))
    return g.resize((w, h), Image.BICUBIC)


def font(path, size):
    return ImageFont.truetype(str(path), size)


def fit_text(text, path, size, max_w):
    """Largest size <= size at which the line fits max_w. Japanese has no
    spaces to break on, so captions are written to fit one line each."""
    while size > 10:
        f = font(path, size)
        if f.getlength(text) <= max_w:
            return f
        size -= 2
    return font(path, size)


def rounded(im, radius):
    mask = Image.new('L', im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, im.width - 1, im.height - 1], radius=radius, fill=255)
    out = im.convert('RGBA')
    out.putalpha(mask)
    return out


def glow_frame(shot, radius, color=CYAN, blur=None):
    """The screen with a soft cyan bloom behind it — the game's own accent."""
    blur = blur or max(8, shot.width // 40)
    pad = blur * 3
    canvas = Image.new('RGBA', (shot.width + 2 * pad, shot.height + 2 * pad),
                       (0, 0, 0, 0))
    halo = Image.new('RGBA', shot.size, color + (150,))
    halo.putalpha(Image.eval(shot.getchannel('A'), lambda a: a * 150 // 255))
    canvas.alpha_composite(halo, (pad, pad))
    canvas = canvas.filter(ImageFilter.GaussianBlur(blur))
    canvas.alpha_composite(shot, (pad, pad))
    return canvas, pad


def compose(raw, w, h, head, sub):
    im = gradient(w, h).convert('RGBA')
    d = ImageDraw.Draw(im)
    margin = round(w * 0.07)

    # Caption block: top ~19% of the canvas.
    head_f = fit_text(head, HEAD, round(w * 0.075), w - 2 * margin)
    sub_f = fit_text(sub, BODY, round(w * 0.036), w - 2 * margin)
    y_head = round(h * 0.085)
    y_sub = y_head + round(head_f.size * 0.95)
    d.text((w // 2, y_head), head, font=head_f, fill=(255, 255, 255),
           anchor='ms')
    d.text((w // 2, y_sub), sub, font=sub_f, fill=CYAN, anchor='ms')

    # The screen fills what is left, scaled to fit and centred.
    top = round(h * 0.16)
    box_w, box_h = w - 2 * margin, h - top - round(h * 0.03)
    scale = min(box_w / raw.width, box_h / raw.height)
    shot = raw.resize((round(raw.width * scale), round(raw.height * scale)),
                      Image.LANCZOS)
    shot = rounded(shot, round(shot.width * 0.06))
    framed, pad = glow_frame(shot, 0)
    im.alpha_composite(framed, ((w - shot.width) // 2 - pad,
                                top + (box_h - shot.height) // 2 - pad))
    return im.convert('RGB')


def cover(im, w, h, fx=0.5, fy=0.5):
    scale = max(w / im.width, h / im.height)
    im = im.resize((round(im.width * scale), round(im.height * scale)),
                   Image.LANCZOS)
    x = round((im.width - w) * fx)
    y = round((im.height - h) * fy)
    return im.crop((x, y, x + w, y + h))


def header(raws, w=3840, h=1646):
    """21:9 header: a row of real gameplay screens, each in a different skin,
    tallest in the middle. One idea — the same game in many looks — and no
    text, so a single image serves every localization. The middle three sit
    in the centre, where every device's crop keeps them; the outer ones may
    be cut and are only there to make the row run off the edge.

    Not the Steam library hero: its 3:1 plate would have to be stretched to
    21:9, and its ship sits at 72% across, where a centre crop loses it."""
    im = gradient(w, h).convert('RGBA')
    mid = len(raws) // 2
    gap = round(h * 0.04)
    sizes = []
    for i, raw in enumerate(raws):
        sh = round(h * (0.86 - 0.08 * abs(i - mid)))
        sizes.append((round(raw.width * sh / raw.height), sh))
    total = sum(s[0] for s in sizes) + gap * (len(raws) - 1)
    x = (w - total) // 2
    for raw, (sw, sh) in zip(raws, sizes):
        s = rounded(raw.resize((sw, sh), Image.LANCZOS), round(sw * 0.06))
        framed, pad = glow_frame(s, 0)
        im.alpha_composite(framed, (x - pad, (h - sh) // 2 - pad))
        x += sw + gap
    return im.convert('RGB')


def search(raws, line, w=3840, h=2560):
    """3:2 search asset: three real screens side by side, one short line.
    Apple's guidance for this slot is the actual app, clearly, plus a line
    that adds to it rather than describing it."""
    im = gradient(w, h).convert('RGBA')
    d = ImageDraw.Draw(im)
    f = fit_text(line, HEAD, round(h * 0.075), round(w * 0.8))
    d.text((w // 2, round(h * 0.15)), line, font=f, fill=(255, 255, 255),
           anchor='ms')

    top, bottom = round(h * 0.22), round(h * 0.96)
    shot_h = bottom - top
    gap = round(w * 0.03)
    shots = []
    for raw in raws:
        scale = shot_h / raw.height
        s = raw.resize((round(raw.width * scale), shot_h), Image.LANCZOS)
        shots.append(rounded(s, round(s.width * 0.06)))
    total = sum(s.width for s in shots) + gap * (len(shots) - 1)
    x = (w - total) // 2
    for s in shots:
        framed, pad = glow_frame(s, 0)
        im.alpha_composite(framed, (x - pad, top - pad))
        x += s.width + gap
    return im.convert('RGB')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-lang', default='ja')
    ap.add_argument('-raw', help='raw capture folder (default build/store_screenshots)')
    args = ap.parse_args()
    global RAW
    if args.raw:
        RAW = pathlib.Path(args.raw).resolve()

    out = ROOT / 'marketing' / f'screenshots-{args.lang}'
    for target, (w, h, src) in TARGETS.items():
        folder = out / target
        folder.mkdir(parents=True, exist_ok=True)
        for old in folder.glob('*.png'):
            old.unlink()  # numbering may have shifted
        for n, (scene, raw_name, head, sub) in enumerate(SCENES[args.lang], 1):
            raw_path = RAW / src / f'{raw_name}.png'
            if not raw_path.exists():
                print(f'skip {target}/{scene}: no {raw_path}')
                continue
            raw = Image.open(raw_path).convert('RGB')
            path = folder / f'{n:02d}_{scene}.png'
            compose(raw, w, h, head, sub).save(path, optimize=True)
            print(path.relative_to(ROOT))

    creative = out / 'appstore-creative'
    creative.mkdir(parents=True, exist_ok=True)

    def load(names):
        paths = [RAW / 'iphone' / f'{n}.png' for n in names]
        missing = [p.name for p in paths if not p.exists()]
        if missing:
            print(f'skip creative: missing {missing}')
            return None
        return [Image.open(p).convert('RGB') for p in paths]

    if raws := load(HEADER_SHOTS):
        header(raws).save(creative / 'header-3840x1646.png', optimize=True)
    if raws := load(SEARCH_SHOTS):
        search(raws, SEARCH_LINE[args.lang]).save(
            creative / 'search-3840x2560.png', optimize=True)
    print(f'{creative.relative_to(ROOT)}/ header + search')

if __name__ == '__main__':
    main()
