"""1024x1024 promo images for App Store Connect's optional IAP 'Image' field.

Source is the shipped 512px assets/skins/<id>/ui/preview.png, doubled. The
1024px renders under pipeline/output are *different* generations, not the
originals of what shipped, so they can't stand in for the real skin art.
"""
import re, pathlib
from PIL import Image, ImageFilter

ROOT = pathlib.Path('/Users/ol1n/Dev/GitHub/Kiran')
OUT = ROOT / 'store/iap-promo'

src = (ROOT / 'tyrian_mobile/lib/services/skin_registry.dart').read_text()
rows = re.findall(r"SkinInfo\(\s*'([a-z_]+)',\s*'([^']+)',?(.*?)(?=SkinInfo\(|\];)", src, re.S)

for skin_id, _label, rest in rows:
    if 'productId' not in rest:
        continue
    pid = 'com.ol1n.kiran.' + re.search(r"productId: '\$_iapPrefix\.(\w+)'", rest).group(1)
    pixel_art = 'pixelArt: true' in rest

    im = Image.open(ROOT / f'tyrian_mobile/assets/skins/{skin_id}/ui/preview.png').convert('RGB')
    if pixel_art:
        # Nearest keeps the hard edges the game itself renders with.
        im = im.resize((1024, 1024), Image.NEAREST)
    else:
        im = im.resize((1024, 1024), Image.LANCZOS)
        im = im.filter(ImageFilter.UnsharpMask(radius=2, percent=60, threshold=3))

    im.save(OUT / f'{pid}.png')  # RGB, no alpha — Apple rejects transparency
    print(f'{pid}.png  {"nearest" if pixel_art else "lanczos+sharpen"}')
