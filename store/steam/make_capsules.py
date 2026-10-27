"""Composites the Steam capsule set from the generated plates.

Run gen_capsule_art.py first; this turns store/steam/art/*.png into every size
Steamworks asks for, with the ship and wordmark laid on top rather than baked
into the generated art — so copy changes cost a rerun, not a regeneration.

    python3 store/steam/make_capsules.py
    python3 store/steam/make_capsules.py -plate wide_v3   # try another plate

Output: store/steam/out/<name>_<w>x<h>.png
"""
import argparse
import pathlib

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter, ImageFont

ROOT = pathlib.Path(__file__).resolve().parents[2]
ART = ROOT / 'store/steam/art'
OUT = ROOT / 'store/steam/out'

# The shipped sprite, not the 1024px pipeline render: those are different
# generations, so they show a ship nobody actually flies. 272px is small, hence
# the layouts below keep the ship under ~1.8x upscale.
SHIP = ROOT / 'tyrian_mobile/assets/skins/default/sprites/falcon1.png'

FONT = '/System/Library/Fonts/HelveticaNeue.ttc'
FACE_BLACK = 9   # Condensed Black — the wordmark
FACE_BOLD = 4    # Condensed Bold — the subtitle

CYAN = (74, 222, 232)
WORDMARK = 'KIRIAN'
SUBTITLE = 'ROGUELIKE ARCADE SHMUP'

# name: (w, h, plate, layout)
TARGETS = [
    ('main_capsule',    1232, 706,  'wide',     'hero_left'),
    ('header_capsule',   920, 430,  'wide',     'hero_left'),
    ('small_capsule',    462, 174,  'wide',     'wordmark_only'),
    ('vertical_capsule', 748, 896,  'portrait', 'stacked'),
    ('library_capsule',  600, 900,  'portrait', 'stacked'),
    ('library_hero',    3840, 1240, 'hero',     'art_only'),
]


def cover(im, w, h, focus_x=0.5, focus_y=0.5):
    """Scale to fill w x h and crop, keeping (focus_x, focus_y) in frame."""
    scale = max(w / im.width, h / im.height)
    im = im.resize((round(im.width * scale), round(im.height * scale)), Image.LANCZOS)
    left = min(max(0, round(im.width * focus_x - w / 2)), im.width - w)
    top = min(max(0, round(im.height * focus_y - h / 2)), im.height - h)
    return im.crop((left, top, left + w, top + h))


def grade(im):
    """Push the plate toward the look the game wears: darker, more contrast,
    and a vignette so the wordmark has somewhere quiet to sit."""
    im = ImageEnhance.Contrast(im).enhance(1.12)
    im = ImageEnhance.Brightness(im).enhance(0.92)

    mask = Image.new('L', im.size, 0)
    d = ImageDraw.Draw(mask)
    pad_x, pad_y = im.width * 0.18, im.height * 0.18
    d.ellipse((-pad_x, -pad_y, im.width + pad_x, im.height + pad_y), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(min(im.size) * 0.12))
    return Image.composite(im, ImageEnhance.Brightness(im).enhance(0.45), mask)


def ship(height):
    """The sprite plus the cyan bloom it has in-game — without the glow it
    reads as a dark blob against dark art."""
    s = Image.open(SHIP).convert('RGBA')
    w = round(s.width * height / s.height)
    s = s.resize((w, height), Image.LANCZOS)

    glow = Image.new('RGBA', (w, height), (0, 0, 0, 0))
    glow.paste(Image.new('RGBA', (w, height), CYAN + (255,)), (0, 0), s)
    glow = glow.filter(ImageFilter.GaussianBlur(height * 0.05))

    pad = round(height * 0.2)
    out = Image.new('RGBA', (w + 2 * pad, height + 2 * pad), (0, 0, 0, 0))
    out.alpha_composite(glow, (pad, pad))
    out.alpha_composite(glow, (pad, pad))  # twice: one pass is too faint
    out.alpha_composite(s, (pad, pad))
    return out


def text(draw, xy, s, size, face, fill, anchor='ls'):
    f = ImageFont.truetype(FONT, size, index=face)
    x, y = xy
    # A soft black pad under the type; the plates are busy and pure white on
    # fire loses its edges without it.
    draw.text((x + max(2, size // 24), y + max(2, size // 24)), s,
              font=f, fill=(0, 0, 0, 170), anchor=anchor)
    draw.text((x, y), s, font=f, fill=fill, anchor=anchor)
    return f


def build(name, w, h, plate_img, layout):
    if layout == 'art_only':
        im = grade(cover(plate_img, w, h, 0.5, 0.5)).convert('RGBA')
    elif layout == 'stacked':
        im = grade(cover(plate_img, w, h, 0.5, 0.42)).convert('RGBA')
    elif layout == 'wordmark_only':
        # Crop toward the fire so the thumbnail is not a black rectangle.
        im = grade(cover(plate_img, w, h, 0.62, 0.55)).convert('RGBA')
    else:
        im = grade(cover(plate_img, w, h, 0.55, 0.5)).convert('RGBA')

    d = ImageDraw.Draw(im)

    def place(sprite, cx, cy):
        """Position by centre. The sprite carries a transparent pad for its
        glow, so anchoring by corner pushes it off the edge."""
        im.alpha_composite(sprite, (round(w * cx - sprite.width / 2),
                                    round(h * cy - sprite.height / 2)))

    if layout == 'hero_left':
        s = ship(round(h * 0.62))
        place(s, 0.83, 0.47)
        text(d, (round(w * 0.06), round(h * 0.56)), WORDMARK,
             round(h * 0.30), FACE_BLACK, (255, 255, 255, 255))
        text(d, (round(w * 0.065), round(h * 0.70)), SUBTITLE,
             round(h * 0.075), FACE_BOLD, CYAN + (255,))

    elif layout == 'wordmark_only':
        s = ship(round(h * 0.72))
        place(s, 0.86, 0.45)
        text(d, (round(w * 0.05), round(h * 0.70)), WORDMARK,
             round(h * 0.44), FACE_BLACK, (255, 255, 255, 255))

    elif layout == 'stacked':
        s = ship(round(h * 0.40))
        place(s, 0.5, 0.36)
        text(d, (w // 2, round(h * 0.80)), WORDMARK,
             round(h * 0.16), FACE_BLACK, (255, 255, 255, 255), anchor='ms')
        text(d, (w // 2, round(h * 0.86)), SUBTITLE,
             round(h * 0.040), FACE_BOLD, CYAN + (255,), anchor='ms')

    elif layout == 'art_only':
        # The hero sits behind Steam's own logo overlay, so it carries no type.
        # 0.40 rather than something bolder: at 1240px tall anything larger
        # pushes the 272px sprite past ~1.9x upscale and it goes visibly soft,
        # which the library shows at full size.
        s = ship(round(h * 0.40))
        place(s, 0.72, 0.52)

    return im.convert('RGB')


def logo(w=1280, h=720):
    """Transparent library logo — Steam lays this over the hero itself."""
    im = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    text(d, (w // 2, round(h * 0.56)), WORDMARK,
         round(h * 0.34), FACE_BLACK, (255, 255, 255, 255), anchor='ms')
    text(d, (w // 2, round(h * 0.68)), SUBTITLE,
         round(h * 0.075), FACE_BOLD, CYAN + (255,), anchor='ms')
    return im


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-plate', action='append', default=[],
                    help='override a plate, e.g. -plate wide=wide_v3')
    args = ap.parse_args()
    override = dict(p.split('=', 1) for p in args.plate)

    OUT.mkdir(parents=True, exist_ok=True)
    cache = {}
    for name, w, h, plate, layout in TARGETS:
        stem = override.get(plate, f'{plate}_v2')
        src = ART / f'{stem}.png'
        if not src.exists():
            print(f'skip {name}: {src.name} missing — run gen_capsule_art.py')
            continue
        if stem not in cache:
            cache[stem] = Image.open(src).convert('RGB')
        dest = OUT / f'{name}_{w}x{h}.png'
        build(name, w, h, cache[stem], layout).save(dest)
        print(f'{dest.name}  from {src.name}')

    dest = OUT / 'library_logo_1280x720.png'
    logo().save(dest)
    print(f'{dest.name}  (transparent)')


if __name__ == '__main__':
    main()
