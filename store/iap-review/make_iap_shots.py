"""Compose App Store Connect IAP review screenshots (640x920) from skin previews."""
import re, pathlib
from PIL import Image, ImageDraw, ImageFont

ROOT = pathlib.Path('/Users/ol1n/Dev/GitHub/Kiran')
SKINS = ROOT / 'tyrian_mobile/assets/skins'
OUT = ROOT / 'store/iap-review'

W, H = 640, 920
BG      = (248, 246, 233)
CARD    = (255, 255, 255)
BORDER  = (230, 226, 210)
TITLE   = (28, 28, 30)
SUB     = (111, 116, 99)
MUTED   = (150, 152, 140)
LOCKBG  = (243, 240, 228)

def font(name, size, bold=False):
    for path in (f'/System/Library/Fonts/{name}',):
        try:
            f = ImageFont.truetype(path, size)
            try:
                f.set_variation_by_name('Bold' if bold else 'Regular')
            except Exception:
                pass
            return f
        except OSError:
            pass
    alt = 'Arial Bold.ttf' if bold else 'Arial.ttf'
    return ImageFont.truetype(f'/System/Library/Fonts/Supplemental/{alt}', size)

F_HDR   = font('SFNS.ttf', 26, bold=True)
F_NAME  = font('SFNS.ttf', 40, bold=True)
F_YEAR  = font('SFNS.ttf', 28)
F_LOCK  = font('SFNS.ttf', 24, bold=True)
F_ID    = ImageFont.truetype('/System/Library/Fonts/SFNSMono.ttf', 20)

def centered(d, y, text, f, fill):
    w = d.textbbox((0, 0), text, font=f)[2]
    d.text(((W - w) // 2, y), text, font=f, fill=fill)

def rounded_mask(size, radius):
    m = Image.new('L', size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius, fill=255)
    return m

def padlock(d, cx, cy):
    """Small padlock glyph, ~22px tall, centred on (cx, cy)."""
    d.rounded_rectangle([cx - 9, cy - 1, cx + 9, cy + 11], 3, fill=SUB)
    d.arc([cx - 6, cy - 12, cx + 5, cy + 2], 180, 360, fill=SUB, width=3)

def shot(skin_id, name, year, product_id):
    im = Image.new('RGB', (W, H), BG)
    d = ImageDraw.Draw(im)

    centered(d, 40, 'KIRAN  ·  SKIN SELECTOR', F_HDR, MUTED)

    d.rounded_rectangle([48, 100, 592, 836], 32, fill=CARD, outline=BORDER, width=2)

    art = Image.open(SKINS / skin_id / 'ui/preview.png').convert('RGB').resize((512, 512), Image.LANCZOS)
    im.paste(art, (64, 132), rounded_mask((512, 512), 28))

    centered(d, 676, name, F_NAME, TITLE)
    centered(d, 730, str(year), F_YEAR, SUB)

    label = 'LOCKED  ·  IN-APP PURCHASE'
    lw = d.textbbox((0, 0), label, font=F_LOCK)[2]
    total = lw + 34
    x0 = (W - total) // 2
    d.rounded_rectangle([x0 - 22, 764, x0 + total + 22, 808], 22, fill=LOCKBG)
    padlock(d, x0 + 10, 784)
    d.text((x0 + 34, 773), label, font=F_LOCK, fill=SUB)

    centered(d, 870, product_id, F_ID, MUTED)

    out = OUT / f'{product_id}.png'
    im.save(out)
    return out

src = (ROOT / 'tyrian_mobile/lib/services/skin_registry.dart').read_text()
rows = re.findall(r"SkinInfo\(\s*'([a-z_]+)',\s*'([^']+)',?(.*?)(?=SkinInfo\(|\];)", src, re.S)
made = 0
for skin_id, label, rest in rows:
    if 'productId' not in rest:
        continue
    product_id = re.search(r"productId: '\$_iapPrefix\.(\w+)'", rest).group(1)
    product_id = f'com.ol1n.kiran.{product_id}'
    name, year = re.match(r'(.+?) \((\d{4})\)$', label).groups()
    print(shot(skin_id, name, year, product_id).name)
    made += 1
print(f'{made} screenshots -> {OUT}')
