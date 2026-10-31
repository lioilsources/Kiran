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

Since 2.9.3 the game UI is localized, so each language gets its own raw
captures (simulator set to that language) under a caption in the same
language. Every file is flattened RGB: App Store Connect rejects alpha.

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

# (path, ttc index, weight for variable fonts) for headline and subline, per
# script. Hiragino Sans (W8 / W4, file names in Japanese) for Japanese; SF for
# Latin and Cyrillic — Hiragino has no Latin Extended-A (č, ř, ğ, ş);
# Sukhumvit for Thai, which needs Pillow with libraqm (brew install libraqm)
# or its marks stack wrong.
FONTS = pathlib.Path('/System/Library/Fonts')
SF = ((FONTS / 'SFNS.ttf', 0, 860), (FONTS / 'SFNS.ttf', 0, 400))
LANG_FONTS = {
    'ja': ((FONTS / 'ヒラギノ角ゴシック W8.ttc', 0, None),
           (FONTS / 'ヒラギノ角ゴシック W4.ttc', 0, None)),
    'ko': ((FONTS / 'AppleSDGothicNeo.ttc', 14, None),   # ExtraBold
           (FONTS / 'AppleSDGothicNeo.ttc', 0, None)),   # Regular
    'th': ((FONTS / 'Supplemental/SukhumvitSet.ttc', 5, None),  # Bold
           (FONTS / 'Supplemental/SukhumvitSet.ttc', 2, None)),  # Text
    'zh-Hant': ((FONTS / 'Hiragino Sans GB.ttc', 2, None),  # W6
                (FONTS / 'Hiragino Sans GB.ttc', 0, None)),  # W3
}
HEAD, BODY = SF  # set per language in main()

CYAN = (74, 222, 232)
BG_TOP = (10, 10, 46)      # the skin selector's gradient
BG_BOTTOM = (0, 0, 16)

# (scene, raw capture) in store order, then (headline, subline) per listing
# locale. 2.10.1 (ASO pass): the first shot is the densest wave of a
# level-10 run, picked from the boss scene's stills — the page has to sell
# the action before anything else — and headlines are 3–4
# words. Each language's captions sit over shots captured with the simulator
# in that language, and name things the way the game's own ARB does.
SCENE_IDS = [
    ('action', 'play_action'),
    ('roguelike', 'play_default_1'),
    ('skins', 'play_neon_grid_0'),
    ('comcenter', 'comcenter_default'),
    ('elemental', 'play_default_0'),
    ('endless', 'play_pixel_0'),
    ('nofree2play', 'skins'),
]
CAPTIONS = {
    'en': [  # Google Play default listing (en-US) and App Store en-US
        ('Blast through the swarm', 'A boss waits every fifth level'),
        ('Die. Keep everything.', 'Weapons, credits and score carry over'),
        ('14 skins. Total restyle.', 'Ships, enemies, backgrounds and sound'),
        ('Upgrade. Mind the power.', 'Weapons you own swap in for free'),
        ('Every weapon kills differently', 'Water, ice, fire, lightning, plasma'),
        ('Endless deep space', '18 hand-built sectors, then forever'),
        ('No ads. Buy once.', 'Three skins free, the rest one-time'),
    ],
    'cs': [
        ('Prostřílej se rojem', 'Každý pátý level čeká boss'),
        ('Zemřeš. Všechno si necháš.', 'Zbraně, kredity i skóre zůstávají'),
        ('14 vzhledů. Všechno jinak.', 'Lodě, nepřátelé, pozadí i zvuk'),
        ('Vylepšuj. Hlídej energii.', 'Zbraně, které máš, přezbrojíš zdarma'),
        ('Každá zbraň zabíjí jinak', 'Voda, led, oheň, blesky, plazma'),
        ('Vesmír bez konce', '18 ručních sektorů, pak donekonečna'),
        ('Žádné reklamy. Koupíš jednou.', 'Tři vzhledy zdarma, ostatní jednorázově'),
    ],
    'de': [
        ('Durch den Schwarm ballern', 'Jedes fünfte Level wartet ein Boss'),
        ('Stirb. Behalte alles.', 'Waffen, Credits und Punkte bleiben'),
        ('14 Skins. Alles neu.', 'Schiffe, Gegner, Hintergründe und Sound'),
        ('Aufrüsten. Energie im Blick.', 'Eigene Waffen wechselst du gratis'),
        ('Jede Waffe tötet anders', 'Wasser, Eis, Feuer, Blitz, Plasma'),
        ('Weltraum ohne Ende', '18 handgebaute Sektoren, dann endlos'),
        ('Keine Werbung. Einmal kaufen.', 'Drei Skins gratis, der Rest per Einmalkauf'),
    ],
    'es': [
        ('Arrasa con el enjambre', 'Un jefe te espera cada cinco niveles'),
        ('Muere. Consérvalo todo.', 'Armas, créditos y puntos se quedan'),
        ('14 aspectos. Todo cambia.', 'Naves, enemigos, fondos y sonido'),
        ('Mejora. Ojo a la energía.', 'Cambia gratis entre tus armas'),
        ('Cada arma mata distinto', 'Agua, hielo, fuego, rayos, plasma'),
        ('Espacio sin fin', '18 sectores artesanales, luego infinito'),
        ('Sin anuncios. Pago único.', 'Tres aspectos gratis, el resto de pago único'),
    ],
    'fr': [
        ('Pulvérise l’essaim', 'Un boss tous les cinq niveaux'),
        ('Meurs. Garde tout.', 'Armes, crédits et score restent'),
        ('14 apparences. Tout change.', 'Vaisseaux, ennemis, décors et son'),
        ('Améliore. Gère l’énergie.', 'Change gratuitement entre tes armes'),
        ('Chaque arme tue autrement', 'Eau, glace, feu, foudre, plasma'),
        ('L’espace sans fin', '18 secteurs faits main, puis l’infini'),
        ('Sans pub. Un seul achat.', 'Trois apparences gratuites, les autres à l’unité'),
    ],
    'id': [
        ('Tembus kawanan musuh', 'Bos menanti setiap lima level'),
        ('Mati. Bawa semuanya.', 'Senjata, kredit, dan skor tetap'),
        ('14 skin. Semua berubah.', 'Kapal, musuh, latar, dan suara'),
        ('Upgrade. Jaga dayamu.', 'Ganti senjata milikmu secara gratis'),
        ('Tiap senjata beda efek', 'Air, es, api, petir, plasma'),
        ('Angkasa tanpa akhir', '18 sektor buatan, lalu tak berujung'),
        ('Tanpa iklan. Sekali beli.', 'Tiga skin gratis, sisanya sekali beli'),
    ],
    'it': [
        ('Sfonda lo sciame', 'Un boss ogni cinque livelli'),
        ('Muori. Tieni tutto.', 'Armi, crediti e punti restano'),
        ('14 skin. Tutto cambia.', 'Navi, nemici, sfondi e suoni'),
        ('Potenzia. Occhio all’energia.', 'Cambi gratis tra le tue armi'),
        ('Ogni arma uccide diversamente', 'Acqua, ghiaccio, fuoco, fulmini, plasma'),
        ('Spazio senza fine', '18 settori fatti a mano, poi all’infinito'),
        ('Niente pubblicità. Paghi una volta.', 'Tre skin gratis, le altre con acquisto singolo'),
    ],
    'ja': [
        ('敵の大群を撃ち抜け', '5レベルごとにボスが待ち受ける'),
        ('死んでも、すべて持ち越し。', '武器もクレジットもスコアも'),
        ('14種のスキンで一新', '船・敵・背景・サウンドまで'),
        ('強化せよ。出力に注意。', '持っている武器は無料で付け替え'),
        ('武器ごとに散り方が違う', '水しぶき・氷・炎・稲妻・プラズマ'),
        ('果てしない宇宙', '18の手作りセクター、その先は無限'),
        ('広告なし。買い切りのみ。', '3種は無料、追加スキンは1つずつ買い切り'),
    ],
    'ko': [
        ('적 떼를 뚫고 나가라', '다섯 레벨마다 보스가 기다린다'),
        ('죽어도 모든 것은 그대로', '무기, 크레딧, 점수가 남는다'),
        ('14가지 스킨, 완전히 새롭게', '함선, 적, 배경, 사운드까지'),
        ('강화하라. 전력을 관리하라.', '보유한 무기는 무료로 교체'),
        ('무기마다 다른 최후', '물, 얼음, 불, 번개, 플라스마'),
        ('끝없는 우주', '직접 만든 18개 섹터, 그 너머는 무한'),
        ('광고 없음. 한 번만 구매.', '스킨 3종 무료, 나머지는 개별 구매'),
    ],
    'pt-BR': [
        ('Detone o enxame', 'Um chefe a cada cinco níveis'),
        ('Morra. Fique com tudo.', 'Armas, créditos e pontos ficam'),
        ('14 visuais. Tudo muda.', 'Naves, inimigos, cenários e som'),
        ('Melhore. Cuide da energia.', 'Troque de graça entre suas armas'),
        ('Cada arma mata diferente', 'Água, gelo, fogo, raios, plasma'),
        ('Espaço sem fim', '18 setores feitos à mão, depois sem fim'),
        ('Sem anúncios. Compra única.', 'Três visuais grátis, os outros em compra única'),
    ],
    'ru': [
        ('Прорвись сквозь рой', 'Каждый пятый уровень — босс'),
        ('Умри. Сохрани всё.', 'Оружие, кредиты и очки остаются'),
        ('14 скинов. Всё по-новому.', 'Корабли, враги, фоны и звук'),
        ('Улучшай. Следи за энергией.', 'Своё оружие меняется бесплатно'),
        ('Каждое оружие убивает по-своему', 'Вода, лёд, огонь, молнии, плазма'),
        ('Бесконечный космос', '18 секторов, дальше — бесконечность'),
        ('Без рекламы. Покупка один раз.', 'Три скина бесплатно, остальные — разовая покупка'),
    ],
    'th': [
        ('ฝ่าฝูงศัตรู', 'บอสรออยู่ทุกห้าเลเวล'),
        ('ตายแล้ว ทุกอย่างยังอยู่', 'อาวุธ เครดิต คะแนน ยังอยู่ครบ'),
        ('14 สกิน เปลี่ยนทุกอย่าง', 'ยาน ศัตรู ฉากหลัง และเสียง'),
        ('อัปเกรด คุมพลังงานให้ดี', 'สลับอาวุธที่มีอยู่ได้ฟรี'),
        ('อาวุธแต่ละแบบ ทำลายต่างกัน', 'น้ำ น้ำแข็ง ไฟ สายฟ้า พลาสมา'),
        ('อวกาศไร้ที่สิ้นสุด', '18 เซกเตอร์ทำมือ จากนั้นไม่มีที่สิ้นสุด'),
        ('ไม่มีโฆษณา ซื้อครั้งเดียว', 'ฟรี 3 สกิน ที่เหลือซื้อครั้งเดียว'),
    ],
    'tr': [
        ('Sürüyü delip geç', 'Her beş seviyede bir boss bekler'),
        ('Öl. Hepsi seninle kalır.', 'Silahlar, kredi ve puan kalır'),
        ('14 görünüm. Her şey yeni.', 'Gemiler, düşmanlar, arka planlar ve ses'),
        ('Geliştir. Enerjiye dikkat.', 'Sahip olduğun silahlar ücretsiz değişir'),
        ('Her silah farklı öldürür', 'Su, buz, ateş, şimşek, plazma'),
        ('Sonsuz uzay', '18 elle yapılmış sektör, sonra sonsuzluk'),
        ('Reklam yok. Bir kez al.', 'Üç görünüm ücretsiz, gerisi tek seferlik'),
    ],
    'vi': [
        ('Xuyên thủng bầy địch', 'Trùm chờ sẵn sau mỗi năm cấp'),
        ('Chết. Giữ lại tất cả.', 'Vũ khí, tín dụng, điểm số còn nguyên'),
        ('14 giao diện. Đổi mới hết.', 'Tàu, kẻ thù, hình nền và âm thanh'),
        ('Nâng cấp. Chớ quá tải.', 'Đổi vũ khí đã có miễn phí'),
        ('Mỗi vũ khí một kiểu', 'Nước, băng, lửa, sét, plasma'),
        ('Vũ trụ vô tận', '18 khu vực làm thủ công, rồi vô tận'),
        ('Không quảng cáo. Mua một lần.', 'Ba giao diện miễn phí, còn lại mua một lần'),
    ],
    'zh-Hant': [
        ('殺出敵群重圍', '每五關都有頭目等著你'),
        ('陣亡也一切保留', '武器、點數、分數全帶著'),
        ('14 款外觀，全面翻新', '戰機、敵人、背景與音效'),
        ('強化武裝，管好電力', '已擁有的武器可免費切換'),
        ('每種武器，擊破各異', '水花、冰、火焰、閃電、電漿'),
        ('無盡星空', '18 個手工星區，之後無限延伸'),
        ('無廣告，一次買斷', '3 款外觀免費，其餘單次購買'),
    ],
}
SCENES = {lang: [(scene, raw, head, sub)
                 for (scene, raw), (head, sub) in zip(SCENE_IDS, caps)]
          for lang, caps in CAPTIONS.items()}

# Search results line: each language's first headline. The header carries no
# text — Apple's guidance there is mood, not features, and the name and Get
# button sit right under it — so only the search asset is localized.
SEARCH_LINE = {lang: caps[0][0] for lang, caps in CAPTIONS.items()}

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


# iPhone 17 Pro Max: simctl sometimes bakes the Dynamic Island into a capture
# as an exact-black pill over the game. Where its core is pure black it is
# painted over with the strip just below it, mirrored — the starfield there
# reads as the same sky.
ISLAND = (452, 24, 864, 168)  # search box around the pill


def hide_island(raw):
    if raw.size != (1320, 2868):
        return raw
    core = raw.crop((500, 60, 816, 132))
    if core.getextrema() != ((0, 0), (0, 0), (0, 0)):
        return raw
    x0, y0, x1, y1 = ISLAND
    h = y1 - y0
    # The pill and its anti-aliased rim: every near-black pixel in the box,
    # grown a little so no dark outline survives.
    box = raw.crop(ISLAND)
    mask = box.convert('L').point(lambda v: 255 if v < 40 else 0)
    mask = mask.filter(ImageFilter.MaxFilter(7)).filter(
        ImageFilter.GaussianBlur(1.5))
    patch = raw.crop((x0, y1, x1, y1 + h)).transpose(Image.FLIP_TOP_BOTTOM)
    out = raw.copy()
    out.paste(patch, (x0, y0), mask)
    return out

def gradient(w, h, top=BG_TOP, bottom=BG_BOTTOM):
    g = Image.new('RGB', (1, 256))
    for y in range(256):
        t = y / 255
        g.putpixel((0, y), tuple(round(a + (b - a) * t)
                                 for a, b in zip(top, bottom)))
    return g.resize((w, h), Image.BICUBIC)


def font(spec, size):
    path, index, weight = spec
    f = ImageFont.truetype(str(path), size, index=index)
    if weight is not None:
        f.set_variation_by_axes([weight if a['name'] == b'Weight' else
                                 a['default'] for a in f.get_variation_axes()])
    return f


def fit_text(text, spec, size, max_w):
    """Largest size <= size at which the line fits max_w. Japanese has no
    spaces to break on, so captions are written to fit one line each."""
    while size > 10:
        f = font(spec, size)
        if f.getlength(text) <= max_w:
            return f
        size -= 2
    return font(spec, size)


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
    # A headline shrunk to fit keeps the line under it at a readable gap.
    y_sub = y_head + round(max(head_f.size * 0.95, w * 0.075 * 0.66))
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
    global RAW, HEAD, BODY
    if args.raw:
        RAW = pathlib.Path(args.raw).resolve()
    HEAD, BODY = LANG_FONTS.get(args.lang, SF)

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
            raw = hide_island(Image.open(raw_path).convert('RGB'))
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
        return [hide_island(Image.open(p).convert('RGB')) for p in paths]

    if raws := load(HEADER_SHOTS):
        header(raws).save(creative / 'header-3840x1646.png', optimize=True)
    if raws := load(SEARCH_SHOTS):
        search(raws, SEARCH_LINE[args.lang]).save(
            creative / 'search-3840x2560.png', optimize=True)
    print(f'{creative.relative_to(ROOT)}/ header + search')

if __name__ == '__main__':
    main()
