"""Steam client and shortcut icons, from the mark the mobile stores already use.

    python3 store/steam/make_icons.py

Output: store/steam/icons/client_icon_32x32.png
        store/steam/icons/shortcut_icon.ico

Why not just resize the source: the shipped icon is RGB on a white square,
which is correct for iOS and Play — both draw it inside their own rounded mask.
Steam draws it raw, small, against a dark library list, and the shortcut icon
lands on whatever wallpaper the player has. A white square in either place
looks like a bug, so the white has to become alpha.
"""
import pathlib

from PIL import Image

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / 'tyrian_mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png'
OUT = ROOT / 'store/steam/icons'

# Alpha is keyed off how far a pixel is from pure white, not off an exact white
# match: the blue outer glow fades *into* the white, so a hard key leaves a
# torn edge around it. min(r,g,b) is the right measure because every coloured
# part of the mark — orange ring, blue glow, steel facets — has at least one
# low channel, while the surround has all three at 255.
#
# SOFT is the width of that ramp. Anything more than SOFT below white is fully
# opaque, so the pale steel highlights (min channel ~170) stay solid.
WHITE_FLOOR = 205
SOFT = 50

ICO_SIZES = [16, 24, 32, 48, 64, 128, 256]


def keyed():
    im = Image.open(SRC).convert('RGB')
    alpha = Image.new('L', im.size)
    px, ap = im.load(), alpha.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b = px[x, y]
            lo = min(r, g, b)
            if lo >= 255:
                a = 0
            elif lo <= WHITE_FLOOR - SOFT:
                a = 255
            else:
                a = round(255 * (WHITE_FLOOR - lo) / SOFT)
                a = max(0, min(255, a))
            ap[x, y] = a
    im = im.convert('RGBA')
    im.putalpha(alpha)
    return im


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    mark = keyed()

    # Trim the transparent margin so the mark fills the icon; at 32px every
    # wasted pixel of padding is one the mark does not get.
    box = mark.getbbox()
    if box:
        mark = mark.crop(box)
    side = max(mark.size)
    square = Image.new('RGBA', (side, side), (0, 0, 0, 0))
    square.alpha_composite(mark, ((side - mark.width) // 2,
                                  (side - mark.height) // 2))

    client = OUT / 'client_icon_32x32.png'
    square.resize((32, 32), Image.LANCZOS).save(client)
    print(f'{client.name}')

    shortcut = OUT / 'shortcut_icon.ico'
    square.resize((256, 256), Image.LANCZOS).save(
        shortcut, format='ICO', sizes=[(s, s) for s in ICO_SIZES])
    print(f'{shortcut.name}  ({", ".join(str(s) for s in ICO_SIZES)})')


if __name__ == '__main__':
    main()
