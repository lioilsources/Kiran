# Google Ads App campaign assets, November 2026

App campaign (goal: installs) for **Kirian: Space Shooter Arcade** on Google
Play (`com.ab.kiran`, release 2.10.1), targeting Japan and South Korea with
English ad text. Upload is manual in the Google Ads UI. Videos have to go
through YouTube first (Google Ads takes video assets only as YouTube links).

## Images

| File | Size | Content |
|---|---|---|
| `images/landscape_1.png` | 1200×628 | action: the dense level-10 swarm (Arcade Formation skin) |
| `images/landscape_2.png` | 1200×628 | six skins side by side, era year under each, claim on top |
| `images/landscape_3.png` | 1200×628 | a wide wave (Neon Voxel skin) |
| `images/square_1.png` | 1200×1200 | action, as landscape_1 |
| `images/square_2.png` | 1200×1200 | the six skins in a 3×2 grid, claim on top |
| `images/square_3.png` | 1200×1200 | wave, as landscape_3 |
| `images/portrait_1.png` | 1200×1500 | action, the swarm over the player's ship |
| `images/portrait_2.png` | 1200×1500 | three skins (1979, 2001, 2017), claim on top |
| `images/portrait_3.png` | 1200×1500 | the level-10 boss over the player's ship |
| `images/logo.png` | 1200×1200 | the 2.10.1 app icon, which already sits on a plain dark-blue field |

The six skins are Vector Wireframe (1979), Arcade Formation (1981), Retro PC
Pixel (1995), Dual-Polarity (2001), Neon Grid (2003) and Neon Voxel (2017).
The only text is the claim **40 YEARS OF ARCADE** and the year labels. There
are no buttons, no frames and no store badges. Everything that matters stays
in the middle, because Google crops images.

## Video

| File | Size | Length |
|---|---|---|
| `video/kirian_9x16.mp4` | 1080×1920, main version | 27 s |
| `video/kirian_1x1.mp4` | 1080×1080, crop of the same footage | 27 s |
| `video/kirian_16x9.mp4` | 1920×1080, gameplay centred over its own blurred frame | 27 s |

H.264 high profile, 30 fps. Structure:

- **0–3 s:** the densest swarm, with no intro.
- **3–18 s:** one era per 3-second cut: 1979, 1995, 2001, 2003, 2017. The
  first cut is the 1981 skin. The year shows as a small label, and the claim
  is on screen from 3 to 9 s.
- **18–23 s:** the level-10 boss fight.
- **23–27 s:** end card with the icon, **KIRIAN** and **Free to Play**.

**Audio.** The main files are silent. The game's music in 2.10.1 (Kiran skin,
`theme_5.ogg`) was generated with ElevenLabs. The repo does not record which
plan it was generated on, and ElevenLabs allows commercial use only on paid
plans. So, as the brief says, the main videos carry no music.
`video/with-game-music/` has the same three cuts with that theme laid under
them. Use those only once you have confirmed the plan that generated the
track. The ACE-Step tracks (MIT, `docs/AUDIO.md`) are not in 2.10.1.

**No Google Play badge on the end card.** It must be Google's official
artwork, used per its badge guidelines
(https://play.google.com/intl/en_us/badges/), and nothing here downloads
outside files. An App campaign also adds its own install button around the
ad. If you want the badge anyway, download it from that page and overlay it
on the last 4 s.

## Source footage

All footage is real gameplay of v2.10.1 on an iPhone 17 Pro Max simulator
(1320×2868), using the store-screenshot driver
(`marketing/screenshots/README.md`) with the same uncommitted capture-build
edits:

- `flutter_driver` dev dependency;
- iOS target 15.0;
- ship invulnerable and firing (`STORE_SHOTS`);
- FPS overlay off.

A new scene, `SHOTS_SCENE=reel`, picks one skin (`SHOTS_SKIN`, its display
name), starts sector index 21 (level 10) and records 80 s with
`simctl io recordVideo` while the ship weaves. It takes a still every three
weaves. The waves stack up 44–56 s in, and both the cuts and the stills come
from that window. The boss shots are from the 2.10.1 app-preview capture
(`SHOTS_SCENE=boss`).

No Android emulator or adb was available, so nothing was recorded with
`adb shell screenrecord`. The game renders the same on both platforms, and
the store UI never appears.

Rebuild everything from the captures:

```bash
git show v2.10.1:tyrian_mobile/assets/icon/icon.png > /tmp/icon.png
git show v2.10.1:tyrian_mobile/assets/skins/default/music/theme_5.ogg > /tmp/theme_5.ogg
python3 marketing/ads/compose.py -reel <reel dir> -boss <boss dir> \
    -icon /tmp/icon.png -music /tmp/theme_5.ogg -out marketing/ads/2026-11
```

## Verified

Every image is under 5 MB and every video is 15–30 s:

```
$ identify -format "%f %wx%h %[colorspace] %b\n" images/*.png
landscape_1.png 1200x628 sRGB 317795B
landscape_2.png 1200x628 sRGB 764476B
landscape_3.png 1200x628 sRGB 319131B
logo.png 1200x1200 sRGB 1.12046MB
portrait_1.png 1200x1500 sRGB 654959B
portrait_2.png 1200x1500 sRGB 1.1632MB
portrait_3.png 1200x1500 sRGB 308495B
square_1.png 1200x1200 sRGB 566806B
square_2.png 1200x1200 sRGB 1.22778MB
square_3.png 1200x1200 sRGB 497622B

$ ffprobe: file, codec, width, height, fps, audio, duration s, bytes
video/kirian_16x9.mp4 h264,1920,1080,30/1 audio=none 27.033333,12538523
video/kirian_1x1.mp4 h264,1080,1080,30/1 audio=none 27.033333,15541900
video/kirian_9x16.mp4 h264,1080,1920,30/1 audio=none 27.033333,20330648
video/with-game-music/kirian_16x9.mp4 h264,1920,1080,30/1 audio=aac 27.000000,13110453
video/with-game-music/kirian_1x1.mp4 h264,1080,1080,30/1 audio=aac 27.000000,16113905
video/with-game-music/kirian_9x16.mp4 h264,1080,1920,30/1 audio=aac 27.000000,20902581
```
