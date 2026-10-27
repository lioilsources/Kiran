"""Renders the trailer's title cards as 1920x1080 RGBA overlays.

    python3 store/steam/make_cards.py

Output: store/steam/cards/<nn>_<slug>.png

Transparent, so each card composites over the gameplay clip it belongs to
rather than cutting to black — the film keeps moving underneath the text. Each
card carries its own scrim, sized to the type, because a full-frame dim would
flatten the footage the card is supposed to be selling.

Type matches the capsules (Helvetica Neue Condensed Black, cyan accent) so the
trailer and the store page read as one thing.
"""
import pathlib

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / 'store/steam/cards'

W, H = 1920, 1080
FONT = '/System/Library/Fonts/HelveticaNeue.ttc'
FACE_BLACK, FACE_BOLD = 9, 4
CYAN = (74, 222, 232)

# (slug, main line, accent line or None) — order matches trailer-script.md.
CARDS = [
    ('die_keep_everything', 'DIE. KEEP EVERYTHING.', None),
    ('progress_permanent', 'PROGRESS IS PERMANENT', 'ONLY YOUR HULL RESETS'),
    ('power_is_finite', 'POWER IS FINITE', 'EVERY LOADOUT IS A TRADE'),
    ('campaign', '20 NODES. 4 BOSSES', 'EACH BUILT ON THE LAST'),
    ('skins', '24 GAMES IN ONE', 'ALL INCLUDED'),
    ('coop', 'LOCAL TWO-PLAYER CO-OP', None),
]
# The end card is not one of these: it is the only place the game's name
# appears in the whole film, so it gets the wordmark lockup rather than a
# line of copy. See end_card().
END = ('07_coming_soon', 'KIRIAN', 'COMING SOON',
       'WINDOWS  ·  LINUX  ·  STEAM DECK')


def card(main, accent):
    im = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    main_size = 132 if len(main) <= 22 else 108
    accent_size = 52

    f_main = ImageFont.truetype(FONT, main_size, index=FACE_BLACK)
    f_acc = ImageFont.truetype(FONT, accent_size, index=FACE_BOLD)

    measure = ImageDraw.Draw(im)
    mw = measure.textbbox((0, 0), main, font=f_main)[2]
    aw = measure.textbbox((0, 0), accent, font=f_acc)[2] if accent else 0

    block_h = main_size + (accent_size + 28 if accent else 0)
    top = (H - block_h) // 2

    # Scrim: a soft dark band only as wide as it needs to be. Blurred edges so
    # it reads as shading rather than as a rectangle laid on the picture.
    pad_x, pad_y = 90, 70
    band = Image.new('L', (W, H), 0)
    ImageDraw.Draw(band).rounded_rectangle(
        (W / 2 - max(mw, aw) / 2 - pad_x, top - pad_y,
         W / 2 + max(mw, aw) / 2 + pad_x, top + block_h + pad_y),
        radius=40, fill=150)
    band = band.filter(ImageFilter.GaussianBlur(55))
    im.alpha_composite(Image.merge('RGBA', (
        Image.new('L', (W, H), 0), Image.new('L', (W, H), 0),
        Image.new('L', (W, H), 0), band)))

    d = ImageDraw.Draw(im)
    d.text((W / 2 + 4, top + 4), main, font=f_main, anchor='ma', fill=(0, 0, 0, 190))
    d.text((W / 2, top), main, font=f_main, anchor='ma', fill=(255, 255, 255, 255))
    if accent:
        ay = top + main_size + 28
        d.text((W / 2 + 3, ay + 3), accent, font=f_acc, anchor='ma', fill=(0, 0, 0, 190))
        d.text((W / 2, ay), accent, font=f_acc, anchor='ma', fill=CYAN + (255,))
    return im


def end_card(word, line2, line3):
    """Wordmark lockup for the last five seconds — the only time the game is
    named on screen, so it is set at the size the capsules use rather than as
    another line of body copy."""
    im = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    f_word = ImageFont.truetype(FONT, 210, index=FACE_BLACK)
    f_two = ImageFont.truetype(FONT, 66, index=FACE_BLACK)
    f_three = ImageFont.truetype(FONT, 40, index=FACE_BOLD)

    measure = ImageDraw.Draw(im)
    widest = max(measure.textbbox((0, 0), t, font=f)[2]
                 for t, f in ((word, f_word), (line2, f_two), (line3, f_three)))
    top = (H - (210 + 40 + 66 + 34 + 40)) // 2

    band = Image.new('L', (W, H), 0)
    ImageDraw.Draw(band).rounded_rectangle(
        (W / 2 - widest / 2 - 120, top - 90,
         W / 2 + widest / 2 + 120, top + 400),
        radius=48, fill=165)
    band = band.filter(ImageFilter.GaussianBlur(70))
    z = Image.new('L', (W, H), 0)
    im.alpha_composite(Image.merge('RGBA', (z, z, z, band)))

    d = ImageDraw.Draw(im)
    for text, font, y, fill in (
            (word, f_word, top, (255, 255, 255, 255)),
            (line2, f_two, top + 250, CYAN + (255,)),
            (line3, f_three, top + 350, (206, 212, 220, 255))):
        d.text((W / 2 + 4, y + 4), text, font=font, anchor='ma', fill=(0, 0, 0, 200))
        d.text((W / 2, y), text, font=font, anchor='ma', fill=fill)
    return im


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for i, (slug, m, a) in enumerate(CARDS, 1):
        dest = OUT / f'{i:02d}_{slug}.png'
        card(m, a).save(dest)
        print(dest.name)
    slug, w, l2, l3 = END
    dest = OUT / f'{slug}.png'
    end_card(w, l2, l3).save(dest)
    print(dest.name)


if __name__ == '__main__':
    main()
