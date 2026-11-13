#!/usr/bin/env python3
"""App Store "Header and Search Results" creative: a boss fight key art.

    python3 marketing/tools/store_boss_creative.py [--out DIR] [--seed N]
                                                   [--only search|header]

Builds two text-free RGB PNGs from the game's sprites (Nex Machina skin):

    search-3840x2560.png   3:2 search-results tile
    header-3840x1646.png   21:9 product page header

Both keep the boss and the player ship inside Apple's art safe area (see
SAFE below) and fail with an AssertionError if a layout change pushes either
one out.

The boss is assembled as boss.dart does it: the `rododendron` core with its
four parts at `BossPart._offsetFraction`, which this script reads from
boss.dart, rotated 180 degrees like every hostile in HostileBatchRenderer.
The player ship is `vessel_5`, player shots the skin's `laser` sprite, enemy
shots its `bubble` sprite (spawnEnemyProjectile). The backdrop is the four
parallax layers of zone 6, the zone every boss level from 10 on uses, under
BgZones.tintFor for that level. Explosions are ExplosionRenderer's filled
circles (yellow core to red rim, white centre). Only glow, light rays, sparks
and grading are added here.

Pillow only; no numpy.
"""
import argparse
import math
import pathlib
import random
import re
import sys

from PIL import Image, ImageChops, ImageDraw, ImageEnhance, ImageFilter

APP = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(APP / 'marketing/screenshots'))
from compose import CYAN, cover  # noqa: E402  shared accent and crop

SKIN = APP / 'assets/skins/nex_machina'
SPR = SKIN / 'sprites'
BG = SKIN / 'backgrounds'
BOSS_DART = APP / 'lib/entities/boss.dart'
OUT = APP / 'marketing/appstore-creative-boss'

# Apple "Creative assets specifications": the art safe area of each slot,
# as (x0, y0, x1, y1) in the full-size canvas.
SAFE = {
    'search': (836, 765, 836 + 2168, 765 + 1030),
    'header': ((3840 - 1646) // 2, (1646 - 661) // 2,
               (3840 + 1646) // 2, (1646 + 661) // 2),
}

# The level whose sky the backdrop shows: a late boss level, past the point
# where BgZones.tintFor saturates.
LEVEL = 30
ZONES = 7  # BgZones.count

# boss.dart PartKind -> sprite, in kBossPartProgression order (parts join the
# fleet after the core, in this order, so they draw over it).
PART_SPRITES = [('turret', 'boss_turret'), ('shieldPod', 'boss_shield'),
                ('thruster', 'boss_thruster'), ('cannon', 'boss_cannon')]

# ExplosionRenderer._colors
EXPLO = [(255, 255, 0), (255, 136, 0), (255, 68, 0), (255, 0, 0), (204, 0, 0)]
MAGENTA = (255, 60, 200)
EMBER = (255, 70, 30)


# ---------------------------------------------------------------- helpers

def load(path):
    return Image.open(path).convert('RGBA')


def scaled(im, s, resample=Image.LANCZOS):
    return im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), resample)


def facing(im, deg):
    """Rotate a nose-up sprite so its nose points `deg` clockwise from up."""
    return im.rotate(-deg, Image.BICUBIC, expand=True) if deg else im


def paste(canvas, sprite, cx, cy):
    """Draw RGBA `sprite` centred at (cx, cy) over the RGB canvas."""
    canvas.paste(sprite, (round(cx - sprite.width / 2), round(cy - sprite.height / 2)), sprite)


class Light:
    """A black-based RGB light patch placed at (x, y) of the canvas."""

    def __init__(self, patch, x, y):
        self.patch, self.x, self.y = patch, x, y


def add(canvas, light):
    """Additive blend of a Light (or a full-size RGB image) into `canvas`, in place."""
    if isinstance(light, Image.Image):
        canvas.paste(ImageChops.add(canvas, light))
        return canvas
    w, h = canvas.size
    x0, y0 = max(0, light.x), max(0, light.y)
    x1, y1 = min(w, light.x + light.patch.width), min(h, light.y + light.patch.height)
    if x0 >= x1 or y0 >= y1:
        return canvas
    part = light.patch.crop((x0 - light.x, y0 - light.y, x1 - light.x, y1 - light.y))
    box = (x0, y0, x1, y1)
    canvas.paste(ImageChops.add(canvas.crop(box), part), box)
    return canvas


def tint(mask, color, gain=1.0):
    """Black-based RGB image of `color` with intensity from L `mask`."""
    if gain != 1.0:
        mask = mask.point(lambda v: min(255, int(v * gain)))
    return Image.composite(Image.new('RGB', mask.size, color), Image.new('RGB', mask.size, 0), mask)


def glow(sprite, cx, cy, color, radius, gain):
    """Coloured blurred halo of a sprite's alpha, centred at (cx, cy)."""
    pad = math.ceil(3 * radius) + 2
    m = Image.new('L', (sprite.width + 2 * pad, sprite.height + 2 * pad), 0)
    m.paste(sprite.getchannel('A'), (pad, pad))
    m = m.filter(ImageFilter.GaussianBlur(radius))
    return Light(tint(m, color, gain), round(cx - sprite.width / 2) - pad,
                 round(cy - sprite.height / 2) - pad)


def radial(cx, cy, r, color, gain=1.0, falloff=2.0):
    """Soft radial light blob."""
    blur = max(2, r / 12)
    half = math.ceil(r + 3 * blur)
    m = Image.new('L', (2 * half, 2 * half), 0)
    d = ImageDraw.Draw(m)
    steps = 40
    for i in range(steps, 0, -1):
        t = i / steps
        rr = r * t
        d.ellipse((half - rr, half - rr, half + rr, half + rr), fill=int(255 * (1 - t) ** falloff))
    m = m.filter(ImageFilter.GaussianBlur(blur))
    return Light(tint(m, color, gain), round(cx) - half, round(cy) - half)


def rays(size, cx, cy, n, length, color, rng, gain=1.0, blur=10):
    """God rays fanning out of (cx, cy), fading with distance. Full-size."""
    m = Image.new('L', size, 0)
    d = ImageDraw.Draw(m)
    for _ in range(n):
        a = rng.uniform(0, 2 * math.pi)
        wdt = math.radians(rng.uniform(0.25, 1.4))
        L = length * rng.uniform(0.6, 1.0)
        p1 = (cx + L * math.cos(a - wdt), cy + L * math.sin(a - wdt))
        p2 = (cx + L * math.cos(a + wdt), cy + L * math.sin(a + wdt))
        d.polygon([(cx, cy), p1, p2], fill=rng.randint(60, 200))
    m = m.filter(ImageFilter.GaussianBlur(blur))
    fade = Image.new('L', size, 0)
    fd = ImageDraw.Draw(fade)
    for i in range(48, 0, -1):
        t = i / 48
        r = length * t
        fd.ellipse((cx - r, cy - r, cx + r, cy + r), fill=int(255 * (1 - t) ** 1.3))
    m = ImageChops.multiply(m, fade.filter(ImageFilter.GaussianBlur(length / 40)))
    return tint(m, color, gain)


def tint_for(level):
    """BgZones.tintFor: multiplicative sky tint from level 8 on."""
    if level <= ZONES:
        return None
    t = min(1.0, max(0.0, (level - ZONES) / 12.0))
    return (255, round(255 * (1.0 - 0.45 * t)), round(255 * (1.0 - 0.65 * t)))


def boss_parts():
    """[(sprite, fx, fy)] from boss.dart's BossPart._offsetFraction."""
    src = BOSS_DART.read_text(encoding='utf-8')
    body = src[src.index('get _offsetFraction'):]
    body = body[:body.index('\n  }\n')]
    found = {k: (float(x), float(y)) for k, x, y in
             re.findall(r'PartKind\.(\w+):\s*return Vector2\(([-\d.]+),\s*([-\d.]+)\)', body)}
    assert set(found) == {k for k, _ in PART_SPRITES}, f'boss.dart part kinds changed: {sorted(found)}'
    return [(name, *found[kind]) for kind, name in PART_SPRITES]


def bbox_of(sprite, cx, cy):
    x, y = round(cx - sprite.width / 2), round(cy - sprite.height / 2)
    bb = sprite.getbbox() or (0, 0, 0, 0)
    return (x + bb[0], y + bb[1], x + bb[2], y + bb[3])


def inside(box, area):
    return area[0] <= box[0] and area[1] <= box[1] and box[2] <= area[2] and box[3] <= area[3]


# ------------------------------------------------------------------ actors

def build_boss():
    """Boss as boss.dart lays it out, nose down.

    Returns (RGBA, centre of the core in it, core size)."""
    core = load(SPR / 'rododendron.png').rotate(180)
    cw, ch = core.size
    parts = [(load(SPR / f'{n}.png').rotate(180), fx, fy) for n, fx, fy in boss_parts()]
    pad = max(max(p.width, p.height) for p, _, _ in parts) + max(cw, ch) // 2
    c = Image.new('RGBA', (cw + 2 * pad, ch + 2 * pad), (0, 0, 0, 0))
    cx, cy = c.width // 2, c.height // 2
    c.alpha_composite(core, (cx - cw // 2, cy - ch // 2))
    for p, fx, fy in parts:
        c.alpha_composite(p, (round(cx + fx * cw - p.width / 2), round(cy + fy * ch - p.height / 2)))
    bb = c.getbbox()
    return c.crop(bb), (cx - bb[0], cy - bb[1]), (cw, ch)


class Scene:
    def __init__(self, w, h, seed):
        self.w, self.h = w, h
        self.size = (w, h)
        self.rng = random.Random(seed)
        self.boss, self.boss_c, self.core_px = build_boss()
        self.parts = boss_parts()
        self.ship = load(SPR / 'vessel_5.png')
        las = load(SPR / 'laser.png')
        self.laser = las.crop(las.getbbox())
        # The bolt's even-width middle section, for stretching into a beam.
        lw, lh = self.laser.size
        self.beam_src = self.laser.crop((0, int(lh * 0.12), lw, int(lh * 0.5)))
        bub = load(SPR / 'bubble.png')
        self.bubble = bub.crop(bub.getbbox())  # nose up, like every sprite
        self.escorts = [load(SPR / n) for n in ('falconxb.png', 'falconx3.png', 'falcon1.png')]

    # -------------------------------------------------------- background
    def background(self, fy):
        """Zone 6's four parallax layers stacked, under the level's tint.

        The layers are 512x1024 WebP, about 7x smaller than the canvas, so the
        softening happens at source size: there it removes the WebP block
        edges before the upscale can turn them into hard 60 px rectangles."""
        layers = [Image.open(BG / n).convert('RGBA')
                  for n in ('layer_0_z6.webp', 'layer_1_z6.webp', 'layer_2.webp', 'layer_3.webp')]
        src = layers[0]
        for layer in layers[1:]:
            src.alpha_composite(layer.resize(src.size, Image.LANCZOS))
        src = src.convert('RGB').filter(ImageFilter.GaussianBlur(1.6))
        t = tint_for(LEVEL)
        if t:
            src = ImageChops.multiply(src, Image.new('RGB', src.size, t))
        bg = cover(src, self.w, self.h, 0.5, fy)
        bg = bg.filter(ImageFilter.GaussianBlur(self.w / 1600))
        bg = ImageEnhance.Brightness(bg).enhance(0.85)
        return ImageEnhance.Color(bg).enhance(1.2)

    # ----------------------------------------------------------- effects
    def explosion(self, img, cx, cy, r, gain=1.0):
        """ExplosionRenderer: filled circles, yellow core to red rim, white centre."""
        for i, col in enumerate(reversed(EXPLO)):
            add(img, radial(cx, cy, r * (1.0 - i * 0.17), col, 0.55 * gain, 1.6))
        return add(img, radial(cx, cy, r * 0.35, (255, 255, 230), 1.2 * gain, 1.2))

    def sparks(self, img, cx, cy, n, spread, color, length, width):
        reach = spread + length[1] + 30
        side = 2 * math.ceil(reach)
        m = Image.new('L', (side, side), 0)
        d = ImageDraw.Draw(m)
        o = side / 2
        for _ in range(n):
            a = self.rng.uniform(0, 2 * math.pi)
            dist = spread * self.rng.random() ** 0.6
            x, y = o + dist * math.cos(a), o + dist * math.sin(a)
            L = self.rng.uniform(*length)
            d.line((x, y, x + L * math.cos(a), y + L * math.sin(a)),
                   fill=self.rng.randint(150, 255), width=width)
        x0, y0 = round(cx - o), round(cy - o)
        add(img, Light(tint(m.filter(ImageFilter.GaussianBlur(8)), color, 1.6), x0, y0))
        return add(img, Light(tint(m.filter(ImageFilter.GaussianBlur(1)), (255, 250, 220)), x0, y0))

    def embers(self, img, n, color, rmax=6):
        """Drifting embers over the whole frame (a legitimately full-size layer)."""
        m = Image.new('L', self.size, 0)
        d = ImageDraw.Draw(m)
        for _ in range(n):
            x, y = self.rng.uniform(0, self.w), self.rng.uniform(0, self.h)
            r = self.rng.uniform(1, rmax)
            d.ellipse((x - r, y - r, x + r, y + r), fill=self.rng.randint(60, 230))
        add(img, tint(m.filter(ImageFilter.GaussianBlur(6)), color, 1.5))
        return add(img, tint(m.filter(ImageFilter.GaussianBlur(1)), (255, 235, 200), 0.8))

    @staticmethod
    def bloom(img, threshold=170, radius=30, gain=0.6):
        hi = img.point(lambda v: max(0, v - threshold) * 255 // (255 - threshold))
        hi = hi.filter(ImageFilter.GaussianBlur(radius)).point(lambda v: int(v * gain))
        return ImageChops.add(img, hi)

    def vignette(self, img, strength):
        w, h = self.size
        sw, sh = w // 8, h // 8
        m = Image.new('L', (sw, sh), 0)
        ImageDraw.Draw(m).ellipse((-sw * 0.15, -sh * 0.2, sw * 1.15, sh * 1.2), fill=255)
        m = m.filter(ImageFilter.GaussianBlur(sw / 7)).resize(self.size, Image.BICUBIC)
        return Image.composite(img, ImageEnhance.Brightness(img).enhance(1 - strength), m)

    # ------------------------------------------------------------ actors
    def place_boss(self, img, cx, cy, s):
        """Boss with its core centred at (cx, cy). Returns its bbox."""
        boss = scaled(self.boss, s)
        bx = cx - (self.boss_c[0] * s - boss.width / 2)
        by = cy - (self.boss_c[1] * s - boss.height / 2)
        # Rim light: wide ember haze behind the hull, tight cyan halo on it.
        add(img, glow(boss, bx, by, EMBER, 90 * s, 0.9))
        add(img, glow(boss, bx, by, CYAN, 26 * s, 0.9))
        paste(img, boss, bx, by)
        return bbox_of(boss, bx, by)

    def part_pos(self, cx, cy, s, name):
        for n, fx, fy in self.parts:
            if n == name:
                return cx + fx * self.core_px[0] * s, cy + fy * self.core_px[1] * s
        raise KeyError(name)

    def place_ship(self, img, cx, cy, s, deg):
        """Player ship, nose `deg` clockwise from up. Returns its bbox."""
        ship = facing(scaled(self.ship, s), deg)
        add(img, glow(ship, cx, cy, CYAN, 30 * s, 1.1))
        # Engine glow behind the ship, opposite its nose.
        tail = 0.42 * self.ship.height * s
        r = math.radians(deg)
        add(img, radial(cx - tail * math.sin(r), cy + tail * math.cos(r), 120 * s, (255, 120, 40), 0.9))
        paste(img, ship, cx, cy)
        return bbox_of(ship, cx, cy)

    def beam(self, img, x0, y0, x1, y1, width):
        """Player laser stretched into a continuous beam from (x0,y0) to (x1,y1)."""
        L = math.hypot(x1 - x0, y1 - y0)
        las = self.beam_src.resize((round(width), round(L)), Image.BICUBIC)
        las = facing(las, math.degrees(math.atan2(x1 - x0, -(y1 - y0))))
        mx, my = (x0 + x1) / 2, (y0 + y1) / 2
        add(img, glow(las, mx, my, CYAN, width * 0.9, 1.4))
        add(img, glow(las, mx, my, MAGENTA, width * 2.2, 0.6))
        paste(img, las, mx, my)
        return img

    def bolt(self, img, cx, cy, s, deg):
        las = facing(scaled(self.laser, s), deg)
        add(img, glow(las, cx, cy, CYAN, 14 * s, 1.0))
        paste(img, las, cx, cy)
        return img

    def enemy_shot(self, img, cx, cy, s, down_deg):
        """Boss `bubble` shot heading `down_deg` from straight down, nose first."""
        b = facing(scaled(self.bubble, s), 180 - down_deg)
        half = max(b.width, b.height) / 2
        if -half < cx < self.w + half and -half < cy < self.h + half:
            add(img, glow(b, cx, cy, MAGENTA, 22 * s, 1.0))
            paste(img, b, cx, cy)
        return img

    def fan(self, img, ox, oy, aim, offsets, dist, s):
        """A volley of bubbles that left (ox, oy), centred on `aim` degrees
        from straight down, `dist` px out."""
        for a in offsets:
            r = math.radians(aim + a)
            img = self.enemy_shot(img, ox + dist * math.sin(r), oy + dist * math.cos(r), s, aim + a)
        return img

    def escort(self, img, idx, cx, cy, s, deg=0.0):
        e = facing(scaled(self.escorts[idx], s), 180 + deg)  # hostiles fly nose down
        add(img, glow(e, cx, cy, CYAN, 18 * s, 0.6))
        paste(img, e, cx, cy)
        return img

    def finish(self, img, vignette):
        img = self.bloom(img)
        img = self.vignette(img, vignette)
        return ImageEnhance.Contrast(img).enhance(1.08)


# --------------------------------------------------------------- the fight

def fight(sc, img, bx, by, bs, sx, sy, ss, ray_gain, ray_blur, embers):
    """The key-art moment, at any scale: the boss (core centred at bx, by, scale
    bs) rains a volley on the player ship (sx, sy, scale ss), whose beam is
    cutting into the boss turret. Every offset is in units of the boss core
    (u) or the ship, so the search tile and the header are the same scene.

    Returns the bboxes of the boss and the ship."""
    u = sc.core_px[0] * bs
    tx, ty = sc.part_pos(bx, by, bs, 'boss_turret')
    # Light behind the boss: hot core glow + god rays.
    add(img, radial(bx, by - 0.04 * u, 1.17 * u, EMBER, 0.7, 1.7))
    add(img, rays(sc.size, bx, by - 0.04 * u, 140, 2.0 * u, (255, 150, 70), sc.rng, ray_gain, ray_blur))
    img = sc.embers(img, embers, (255, 110, 30), max(3, round(0.005 * u)))
    boss_box = sc.place_boss(img, bx, by, bs)

    # Direction from the ship to the turret; the ship turns to face it.
    dx, dy = tx - sx, ty - sy
    D = math.hypot(dx, dy)
    ux, uy = dx / D, dy / D
    deg = math.degrees(math.atan2(dx, -dy))
    ship_h = sc.ship.height * ss
    ship_w = sc.ship.width * ss

    # Volley from the core's underside toward the ship (spawnEnemyProjectile).
    ox, oy = bx, by + 0.5 * u
    aim = math.degrees(math.atan2(sx - ox, sy - oy))
    reach = math.hypot(sx - ox, sy - oy)
    shot = 0.68 * bs
    img = sc.fan(img, ox, oy, aim, [-34, -17, 17, 34], 0.45 * reach, shot)
    img = sc.fan(img, ox, oy, aim, [-44, -26, -9, 9, 26, 44], 0.9 * reach, shot)

    # Player: beam from the nose into the turret, twin bolt streams beside it.
    hit_x, hit_y = tx - ux * 0.15 * u, ty - uy * 0.15 * u
    nose = 0.55 * ship_h
    beam_len = D - 0.15 * u - nose
    img = sc.beam(img, sx + ux * nose, sy + uy * nose, hit_x, hit_y, 0.076 * u)
    for k in (1.0, 1.6, 2.2):
        along = min(k * ship_h, 0.85 * beam_len)
        for side in (-0.25, 0.25):
            px, py = -uy * side * ship_w, ux * side * ship_w
            img = sc.bolt(img, sx + ux * (nose + along) + px, sy + uy * (nose + along) + py, 1.0 * ss, deg)

    # Impact on the turret.
    img = sc.explosion(img, hit_x, hit_y, 0.172 * u, 1.0)
    img = sc.sparks(img, hit_x, hit_y, 110, 0.227 * u, (255, 150, 40),
                    (0.02 * u, 0.1 * u), max(2, round(0.004 * u)))
    img = sc.explosion(img, tx - 0.131 * u, ty + 0.028 * u, 0.083 * u, 0.7)

    ship_box = sc.place_ship(img, sx, sy, ss, deg)
    return img, boss_box, ship_box


# ------------------------------------------------------------- layouts

def search(seed):
    W, H = 3840, 2560
    sc = Scene(W, H, seed)
    img = sc.background(fy=0.70)
    bs = 0.63
    bx, by = 2180, 1235
    tx, ty = sc.part_pos(bx, by, bs, 'boss_turret')
    img, boss_box, ship_box = fight(sc, img, bx, by, bs, tx - 360, 1640, 0.72,
                                    ray_gain=0.9, ray_blur=10, embers=260)
    # Escorts: one blown apart, two still coming. Two inside the safe area
    # frame the duel; the rest only fill the wide tile.
    img = sc.escort(img, 0, 1120, 960, 0.5, 25)
    img = sc.explosion(img, 1140, 1000, 120, 0.9)
    img = sc.escort(img, 1, 2800, 1450, 0.45, -12)
    img = sc.escort(img, 2, 380, 1350, 0.75, 10)
    img = sc.escort(img, 0, 430, 360, 0.85, 25)
    img = sc.explosion(img, 470, 430, 200, 0.9)
    img = sc.escort(img, 1, 3420, 1900, 0.75, -12)
    img = sc.embers(img, 120, (90, 200, 255), 5)
    return sc.finish(img, 0.5), boss_box, ship_box


def header(seed):
    W, H = 3840, 1646
    sc = Scene(W, H, seed)
    img = sc.background(fy=0.74)
    bs = 0.42
    bx, by = 1980, 808
    tx, ty = sc.part_pos(bx, by, bs, 'boss_turret')
    img, boss_box, ship_box = fight(sc, img, bx, by, bs, tx - 170, 1050, 0.47,
                                    ray_gain=0.7, ray_blur=6, embers=320)
    # Wide edges (visible on iPad/Mac only): escorts, some already hit, and
    # the bubbles they fire down at the player.
    for (ex, ey, k, s, a, boom) in [(560, 430, 0, 0.5, 15, True), (820, 1000, 1, 0.42, -10, False),
                                    (3300, 470, 1, 0.45, -20, True), (3420, 1020, 2, 0.5, 10, False),
                                    (2980, 1300, 2, 0.4, 0, False)]:
        img = sc.escort(img, k, ex, ey, s, a)
        if boom:
            img = sc.explosion(img, ex + 25, ey + 35, 120, 0.85)
        else:
            for d in (170, 330):
                img = sc.enemy_shot(img, ex - d * math.sin(math.radians(a)),
                                    ey + d * math.cos(math.radians(a)), 0.28, -a)
    img = sc.embers(img, 160, (90, 200, 255), 4)
    return sc.finish(img, 0.4), boss_box, ship_box


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=str(OUT))
    ap.add_argument('--seed', type=int, default=7)
    ap.add_argument('--only', choices=['search', 'header'])
    a = ap.parse_args()
    out = pathlib.Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    jobs = {'search': (search, 'search-3840x2560.png'), 'header': (header, 'header-3840x1646.png')}
    for key, (fn, name) in jobs.items():
        if a.only and a.only != key:
            continue
        im, boss_box, ship_box = fn(a.seed)
        assert im.mode == 'RGB'
        for what, box in (('boss', boss_box), ('ship', ship_box)):
            assert inside(box, SAFE[key]), f'{key}: {what} {box} leaves the safe area {SAFE[key]}'
        im.save(out / name, optimize=True)
        print(out / name, im.size, 'boss', boss_box, 'ship', ship_box)


if __name__ == '__main__':
    main()
