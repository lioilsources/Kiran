# Google Play Console — Kirian

Everything to paste or click, in the order Play Console asks for it. Written
against the current build (v2.7.4, `app-release.aab`, package `com.ol1n.kiran`).

Character limits are Play's, not Apple's, and they differ — do not paste the
App Store copy in.

---

## 1. Store listing

### App name (limit 30)

```
Kirian: Space Shooter
```
**21 chars.** The device shows `Kirian` (AndroidManifest `android:label`), and
unlike Apple, Google does not police name-vs-listing similarity nearly as hard.
Keep them close anyway.

### Short description (limit 80)

```
Roguelike arcade shmup. Die, keep everything, push deeper. Local co-op for two.
```
**78 chars.** This one matters more than on iOS: it is the text under the title
in search results and the first thing anyone reads.

### Full description (limit 4000)

```
Fly a lone gunship through an endless corridor of hostiles, one sixty-second sector at a time.

Kirian is a vertical arcade shooter built on a roguelike loop. Losing your vessel does not end the run — you keep every weapon, every credit, every point you have earned, and drop back to Sector 1 to push deeper than last time. Progress is permanent. Only your hull resets.

ELEMENTAL DESTRUCTION
Enemies die by the weapon that killed them. Bubble guns burst them into water. Cannons shatter them into ice that falls heavy and cold. Star guns leave them burning with rising flame and drifting embers. Lasers discharge in a flicker of lightning. Blasters implode them into a magenta plasma nova. Each kill reads at a glance.

BUILD YOUR GUNSHIP
Between sectors, the Com Center is yours: front guns, side guns, generators, hull and shields, all upgradable across twenty-five levels. Power is finite — a heavier gun drains a generator that cannot keep up, so every loadout is a trade. Score never resets, and crossing its thresholds permanently unlocks the higher weapon tiers.

SEVEN ZONES, THEN FOREVER
Eighteen hand-authored sectors span six zones, each a tight sixty-second script with its own formations and rhythm. The sky escalates with them — cold and calm at the frontier, running teal, then amber, then crimson as you push in. Past the authored run the generator takes over and never stops, difficulty climbing without a ceiling, bosses waiting at every fifth level.

TWO PLAYERS, ONE ROOM
Co-op runs over local Wi-Fi with automatic discovery — no accounts, no servers, no internet. One device hosts, the other joins, and you fly the same sector together.

FOURTEEN LOOKS
Every skin restyles the whole game: ships, enemies, backgrounds, interface, sound. Three ship free with the app. The other eleven are one-time purchases, each permanent, with no ads, no subscriptions and no consumables anywhere in the game.

BUILT TO FEEL RIGHT
GPU shaders drive bloom, scanlines, vignette and chromatic aberration. Enemies shatter into physics-driven fragments cut from their own sprites. Play by touch, keyboard, or a connected controller.

Play Games leaderboards rank you by total score and by the deepest level you have ever reached, alongside achievements for kills, sectors and untouched runs.
```
**~2 250 chars.**

### ⚠ There is no keywords field

Play has nothing equivalent to Apple's 100-character keyword box. Search ranking
reads the **title, short description and full description**, so the terms have to
live in the prose — which is why the copy above says "roguelike", "arcade",
"shmup", "co-op", "controller" and "shooter" in plain sentences rather than
keeping them for a separate field. Do not paste Apple's comma list anywhere;
Google treats keyword stuffing as a policy violation.

---

## 2. Graphics you must supply

| Asset | Spec | Have it? |
|---|---|---|
| App icon | 512×512 PNG, 32-bit | from `android/app/src/main/res/mipmap-*` |
| **Feature graphic** | **1024×500 PNG/JPG, no alpha** | **MISSING — required, blocks release** |
| Phone screenshots | 2–8, min 320px, 16:9 or 9:16 | reuse `ol1n.now/apps/kirian/screenshots/raw/mobile/ios/` |
| 7" tablet | 2–8 | optional unless you claim tablet support |
| 10" tablet | 2–8 | optional unless you claim tablet support |

The feature graphic is the banner at the top of the store page and Play will not
let you publish without one. Nothing in the repo is that shape.

---

## 3. In-app products

Monetization → Products → In-app products. Create all eleven with these exact
IDs — they match the code (`skin_registry.dart`) and the iOS products, so no
code change is needed.

| Product ID | Name | Price |
|---|---|---|
| `com.ol1n.kiran.skin_space_invaders` | Monochrome Invader Skin | 0.99 |
| `com.ol1n.kiran.skin_asteroids` | Vector Wireframe Skin | 0.99 |
| `com.ol1n.kiran.skin_river_raid` | 8-Bit Canyon Skin | 0.99 |
| `com.ol1n.kiran.skin_rtype` | Biomech Cruiser Skin | 0.99 |
| `com.ol1n.kiran.skin_blazing_lazers` | 16-Bit Laser Skin | 0.99 |
| `com.ol1n.kiran.skin_tyrian_dos` | Retro PC Pixel Skin | 0.99 |
| `com.ol1n.kiran.skin_ikaruga` | Dual-Polarity Skin | 0.99 |
| `com.ol1n.kiran.skin_gradius_v` | Chrome Fleet Skin | 0.99 |
| `com.ol1n.kiran.skin_luftrausers` | Sepia Dogfight Skin | 0.99 |
| `com.ol1n.kiran.skin_nuclear_throne` | Wasteland Pixel Skin | 0.99 |
| `com.ol1n.kiran.skin_nex_machina` | Neon Voxel Skin | 0.99 |

Type: **one-time product** (non-consumable equivalent). Unlike Apple, these do
**not** get submitted for review — activate them and they are live. That whole
class of problem does not exist here.

Note: a product ID can never be reused on Play either. Type them carefully.

---

## 4. Play Games Services

Play Games → Set up → create a project and link it to `com.ol1n.kiran`.

### 4a. The App ID goes into the code

Play Games gives the project a numeric **App ID** (12-ish digits). It currently
sits in `android/app/src/main/res/values/strings.xml` as a placeholder:

```xml
<string name="game_services_app_id">000000000000</string>
```

Send it to me — leaderboards and achievements cannot work until it is real.

### 4b. Leaderboards (2)

Create both, then send me the generated IDs (they look like `CgkI…`). The code
holds `REPLACE_WITH_PLAY_LEADERBOARD_ID` / `REPLACE_WITH_PLAY_DEPTH_LEADERBOARD_ID`
in `leaderboard_service.dart`.

| Name | Sort | Format | Notes |
|---|---|---|---|
| Top Score | Larger is better | Integer | cumulative score, never resets |
| Deepest Sector | Larger is better | Integer | deepest level ever reached |

Both are ordinary (non-recurring) boards, matching the Game Center setup.

### 4c. Achievements (34)

The iOS names are reused so the two platforms read the same. **Incremental**
achievements need their step count entered in Play; the others are one-shot.

| ID (for your reference) | Name | Points | Steps |
|---|---|---|---|
| `kiran_ach_sector_5` | Deep Space | 10 | — |
| `kiran_ach_sector_10` | Into the Fire | 25 | — |
| `kiran_ach_sector_20` | Veteran | 50 | — |
| `kiran_ach_sector_40` | Legend of Kirian | 100 | — |
| `kiran_ach_first_kill` | First Blood | 5 | — |
| `kiran_ach_kills_1000` | Exterminator | 25 | 1000 |
| `kiran_ach_kills_10000` | Armada Slayer | 100 | 10000 |
| `kiran_ach_falcon1_100` | Falcon I Hunter | 10 | 100 |
| `kiran_ach_falcon2_100` | Falcon II Hunter | 10 | 100 |
| `kiran_ach_falcon3_100` | Falcon III Hunter | 10 | 100 |
| `kiran_ach_falcon4_100` | Falcon IV Hunter | 10 | 100 |
| `kiran_ach_falcon5_100` | Falcon V Hunter | 10 | 100 |
| `kiran_ach_falcon6_100` | Falcon VI Hunter | 10 | 100 |
| `kiran_ach_elite_100` | Elite Hunter | 25 | 100 |
| `kiran_ach_boss_1` | Boss Down | 25 | — |
| `kiran_ach_boss_10` | Serial Boss Killer | 50 | 10 |
| `kiran_ach_asteroid_1` | Rock Meets Hull | 5 | — |
| `kiran_ach_asteroid_50` | Asteroid Magnet | 25 | 50 |
| `kiran_ach_max_bubble_gun` | Bubble Gun Master | 25 | — |
| `kiran_ach_max_vulcan_cannon` | Vulcan Cannon Master | 25 | — |
| `kiran_ach_max_blaster` | Blaster Master | 25 | — |
| `kiran_ach_max_laser` | Laser Master | 25 | — |
| `kiran_ach_max_small_bubble` | Small Bubble Master | 25 | — |
| `kiran_ach_max_small_vulcan` | Small Vulcan Master | 25 | — |
| `kiran_ach_max_star_gun` | Star Gun Master | 25 | — |
| `kiran_ach_max_small_laser` | Small Laser Master | 25 | — |
| `kiran_ach_starts_10` | Regular | 10 | 10 |
| `kiran_ach_starts_100` | Addicted | 50 | 100 |
| `kiran_ach_time_1h` | Warming Up | 10 | 60 |
| `kiran_ach_time_10h` | No Sleep | 50 | 600 |
| `kiran_ach_deaths_25` | Never Give Up | 10 | 25 |
| `kiran_ach_coop` | Better Together | 25 | — |
| `kiran_ach_skins_5` | Fashion Victim | 10 | — |
| `kiran_ach_untouchable` | Untouchable | 50 | — |

Play requires an icon per achievement (512×512). If you would rather not draw
34 of them, ship the leaderboards first and add achievements in a later pass —
the code degrades quietly when an ID is missing.

Total points: 1000, which is Play's maximum for the initial set. It already fits.

---

## 5. Policy sections (Play is stricter than Apple here)

**Privacy policy URL** — required, and it must be reachable:
```
https://lioilsources.github.io/Kiran/privacy.html
```
Note this is **not** on `olin.now` — that host returns 404 for `/privacy.html`.
Use the github.io address or move the page.

**Data safety** — the questionnaire is mandatory and self-declared. For Kirian:
- Data collected: none by the app itself.
- Data shared: none.
- But you must still declare what Play Games Services and Google Play Billing
  handle on your behalf — sign-in identifier and in-app purchase history.
- No data is collected for advertising or analytics; there is no ad SDK.
- Answer "Yes" to encryption in transit (Play Games and Billing use HTTPS).

**Content rating** — an IARC questionnaire. Kirian is fantasy space combat with
no blood, gore, language or gambling. That lands around PEGI 7 / ESRB Everyone,
matching the 4+ you already have on iOS.

**Target audience** — 13+ is the honest bracket. Do not tick "designed for
children"; it drags in Families policy and extra review.

**Ads** — declare **no ads**. True, and it is worth saying in the listing too.

**Government / financial features** — none apply.

---

## 6. Signing — read before the first upload

Turn on **Play App Signing**. Google then holds the distribution key and your
CI keystore (`ANDROID_KEYSTORE_BASE64` in GitHub secrets) becomes only the
*upload* key. Without it, losing that keystore means you can never ship an
update to the same listing again — there is no recovery path.

The first AAB you upload binds the app to whichever key signs it, so decide
before, not after.

---

## 7. What I do once you send the IDs

Send me the **Play Games App ID** and the **two leaderboard IDs** and I will:
1. put the App ID into `strings.xml`,
2. replace both `REPLACE_WITH_PLAY_LEADERBOARD_ID` constants in
   `leaderboard_service.dart`,
3. optionally wire the 34 achievement IDs (34 more `CgkI…` strings — send them
   whenever, they are independent),
4. cut a release so the AAB you upload actually has working Play Games.

Uploading the current `app-release.aab` before that works fine — the game plays
correctly, only leaderboards and achievements stay silent.

---

## 8. Where the upload-ready images are

`tyrian_mobile/marketing/play-assets/` — all validated against Play's limits
(min 320px, max 3840px, aspect ratio never steeper than 1:2).

| Console field | File |
|---|---|
| App icon | `icon_512.png` |
| Feature graphic | `feature_graphic_1024x500.png` |
| Phone screenshots | `phone/` (4) |
| 7-inch tablet | `tablet7/` (4) |
| 10-inch tablet | `tablet10/` (4) |

Two things worth knowing about how these were made:

- The iOS screenshots are 1125×2436, i.e. 1:2.17 — **steeper than Play allows**,
  so they could not be uploaded as-is. Three are re-cut to Play's canonical
  1080×1920 by `ol1n.now`'s own `make screenshots` (center-crop), and
  `kirian_comcenter` is instead padded to 1218×2436, because the crop cut its
  CONTINUE MISSION button off the bottom.
- `ol1n.now/scripts/resize-screenshots.sh` already knows Play's phone size
  (`PLAY_PHONE=1080x1920`) but keys store output off the *platform folder*, and
  Kirian only had `screenshots/raw/mobile/ios/`. Adding `.../android/` makes it
  emit Play sizes on every run. It has no Play tablet target — those two folders
  were produced by hand.
- The feature graphic did not exist in any form; it is composed from game art
  (zone-5 background, `vessel_2`, Avenir Next Condensed wordmark).
