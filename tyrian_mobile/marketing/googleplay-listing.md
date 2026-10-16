# Google Play Console — Kirian

App: **Kirian** · package **`com.ab.kiran`** · A+B organization developer
account · new app, straight to **Production** (organization accounts have no
"12 testers / 14 days" closed-test gate).

Written for the **v2 line** — the same game as the live App Store 2.9.1:
14 skins / 11 paid, endless sectors, no Campaign, no difficulty selection.
Built from branch `release/2.9.x` (tag `v2.9.1` + `applicationId com.ab.kiran`).
The v3 features (Campaign, difficulty, 24 skins) come to Play with a later
update, never the other way: Play only accepts a higher versionCode.

Three things to know before starting:

- **No keywords field.** Play indexes the name, short and full description,
  so "roguelike", "arcade", "shmup", "shooter", "co-op", "controller" live in
  the prose. Do not paste Apple's comma list anywhere — keyword stuffing is a
  policy violation.
- **A feature graphic is mandatory**: `play-assets/feature_graphic_1024x500.png`.
- **Play Games needs the app signing key's SHA-1**, which exists only after the
  first AAB is uploaded. So the release is two builds: 2.9.1 (85) to Internal
  testing first, then 2.9.2 with the Play Games IDs to Production.

Every text below is length-checked by
`python3 marketing/tools/check_play_lengths.py` (the `[N]` is its count).

## Language: English default, Japanese translation

**Default language: English (United States) – en-US.** The whole game UI is
English. **Japanese – ja-JP** is added as a translation from
`googleplay-listing-ja.md` (texts) and `screenshots-ja/play-*` (graphics).

## Store listing

| Field | Limit | Value |
|---|---|---|
| App name | 30 | `Kirian: Space Shooter` [21] — the launcher label is `Kirian` |
| Short description | 80 | below |
| Full description | 4000 | below |
| App or game | — | **Game** |
| Free or paid | — | **Free** (with in-app products). Free can never become paid; IAPs are fine. |
| Category | — | **Arcade** |
| Tags | — | from Play's fixed list, max 5: Shoot 'em up, Arcade, Roguelike, Sci-fi, Offline (pick the closest offered) |
| Contact email | — | `oldrich.vorechovsky.jr@gmail.com` |
| Website | — | `https://lioilsources.github.io/Kiran/` |
| Privacy policy | — | `https://lioilsources.github.io/Kiran/privacy.html` |

All three URLs return HTTP 200 (checked 2026-10-16). The privacy policy is
updated on this branch to name **Kirian / `com.ab.kiran` / A+B** and to cover
Play Games, Play Billing and local co-op — **it goes live only after this
branch is merged to `main`** (GitHub Pages). Merge before sending for review.

<!-- check: name 30 -->
```
Kirian: Space Shooter
```

### Short description (80)

<!-- check: short_en 80 -->
```
Roguelike arcade shmup. Die, keep everything, push deeper. Local co-op for two.
```

It is the line under the title in search results — the first thing anyone reads.

### Full description (4000)

<!-- check: full_en 4000 -->
```
Fly a lone gunship through an endless corridor of hostiles, one sixty-second sector at a time.

Kirian is a vertical arcade shooter built on a roguelike loop. Losing your vessel does not end the run — you keep every weapon, every credit, every point you have earned, and drop back to Sector 1 to push deeper than last time. Progress is permanent. Only your hull resets.

ELEMENTAL DESTRUCTION
Enemies die by the weapon that killed them. Bubble guns burst them into water. Cannons shatter them into ice that falls heavy and cold. Star guns leave them burning with rising flame and drifting embers. Lasers discharge in a flicker of lightning. Blasters implode them into a magenta plasma nova. Each kill reads at a glance.

BUILD YOUR GUNSHIP
Between sectors, the Com Center is yours: front guns, side guns, generators, hull and shields, all upgradable across twenty-five levels. Power is finite — a heavier gun drains a generator that cannot keep up, so every loadout is a trade. Score never resets, and crossing its thresholds permanently unlocks the higher weapon tiers.

SIX ZONES, THEN FOREVER
Eighteen hand-authored sectors span six zones, each a tight sixty-second script with its own formations and rhythm. The sky escalates with them — cold and calm at the frontier, running teal, then amber, then crimson as you push in. Past the authored run the generator takes over and never stops, difficulty climbing without a ceiling, bosses waiting at every fifth level.

TWO PLAYERS, ONE ROOM
Co-op runs over local Wi-Fi with automatic discovery — no accounts, no servers, no internet. One device hosts, the other joins, and you fly the same sector together.

FOURTEEN LOOKS
Every skin restyles the whole game: ships, enemies, backgrounds, interface, sound. Three ship free with the app. The other eleven are one-time purchases, each permanent, with no ads, no subscriptions and no consumables anywhere in the game.

BUILT TO FEEL RIGHT
GPU shaders drive bloom, scanlines, vignette and chromatic aberration. Enemies shatter into physics-driven fragments cut from their own sprites. Play by touch, keyboard, or a connected controller.

Play Games leaderboards rank you by total score and by the deepest level you have ever reached, alongside achievements for kills, sectors and untouched runs.
```

The last paragraph is true only once the Play Games IDs are in the build
(2.9.2). It is not in the listing until Production goes out with 2.9.2, so it
can stay.

### Release notes (first production release, 500)

<!-- check: notes_en 500 -->
```
First release on Google Play. Fourteen skins, three free. Play Games leaderboards and achievements.
```

ja-JP notes are in `googleplay-listing-ja.md`.

## Graphics

| Asset | Requirement | File |
|---|---|---|
| App icon | 512×512 PNG, no alpha | `play-assets/icon_512.png` (RGB) |
| Feature graphic | 1024×500, no alpha | `play-assets/feature_graphic_1024x500.png` |
| Phone screenshots | 2–8, max 2:1 | `screenshots-en/play-phone/01…06_*.png` (1080×1920) |
| 7" tablet | 2–8 | `screenshots-en/play-tablet7/` (1200×1920) |
| 10" tablet | 2–8 | `screenshots-en/play-tablet10/` (1600×2560) |

Screenshots are real v2.9.1 captures (iPhone 17 Pro Max / iPad Pro 13"
simulator — Flutter draws the same UI on Android) with English captions:
01 roguelike · 02 skins · 03 Com Center · 04 elemental kills · 05 endless
sectors · 06 no ads. Regenerate with
`python3 marketing/screenshots/compose.py -lang en -raw build/store_screenshots_v2`
(see `screenshots/README.md`). The Japanese translation gets its own set from
`screenshots-ja/play-*`.

The old `play-assets/phone|tablet7|tablet10/` (v2.7 shots) are superseded.

## In-app products

**Monetize with Play → Products → In-app products** (one-time products).
Locked until (a) the A+B account has a **payments profile** and (b) an AAB with
the `com.android.vending.BILLING` permission is uploaded to any track — the
Internal testing upload in step 6 unlocks it.

The IDs must match `skin_registry.dart` exactly — a mismatch fails silently
(the skin shows no price). They keep the `com.ol1n.kiran.` prefix even though
the package is `com.ab.kiran`: product IDs are free-form strings, and sharing
them with iOS keeps one code path. **A product ID can never be reused**, even
after deletion — type carefully.

Products are per app: nothing carries over from any older Kiran app. Unlike
Apple, they are not reviewed — **Activate** each one and it is live.

| Product ID | Name (≤55) | Description (≤200) |
|---|---|---|
| `com.ol1n.kiran.skin_space_invaders` | Monochrome Invader Skin | 1978 arcade monochrome. Restyles ships, enemies, backgrounds, UI and sound. Yours for good. |
| `com.ol1n.kiran.skin_asteroids` | Vector Wireframe Skin | 1979 vector wireframe. … |
| `com.ol1n.kiran.skin_river_raid` | 8-Bit Canyon Skin | 1982 8-bit canyon. … |
| `com.ol1n.kiran.skin_rtype` | Biomech Cruiser Skin | 1987 biomechanical. … |
| `com.ol1n.kiran.skin_blazing_lazers` | 16-Bit Laser Skin | 1989 16-bit console. … |
| `com.ol1n.kiran.skin_tyrian_dos` | Retro PC Pixel Skin | 1995 DOS pixel art. … |
| `com.ol1n.kiran.skin_ikaruga` | Dual-Polarity Skin | 2001 black-and-white polarity. … |
| `com.ol1n.kiran.skin_gradius_v` | Chrome Fleet Skin | 2004 chrome and steel. … |
| `com.ol1n.kiran.skin_luftrausers` | Sepia Dogfight Skin | 2014 sepia dogfight. … |
| `com.ol1n.kiran.skin_nuclear_throne` | Wasteland Pixel Skin | 2015 wasteland pixel art. … |
| `com.ol1n.kiran.skin_nex_machina` | Neon Voxel Skin | 2017 neon voxel. … |

"…" = the same tail as the first row: ` Restyles ships, enemies, backgrounds,
UI and sound. Yours for good.` Longest description is 98 characters.

Price: **€0.99 / $0.99** tier each (same as the App Store), let Play convert
the rest. Japanese names/descriptions are in `iap/iap-ja.md` (Play limits:
name 55, description 200 — the Apple-sized ja texts fit).

<!-- check: iap_desc_longest 200 -->
```
2001 black-and-white polarity. Restyles ships, enemies, backgrounds, UI and sound. Yours for good.
```

## Play Games Services

**Grow users → Play Games Services → Setup and management → Configuration.**
Do this after the first AAB is in Internal testing (step 6 below), because the
credential needs the app signing key.

1. **Create** a new Play Games Services project → *No, my game doesn't use
   Google APIs yet* → name `Kirian`.
2. **Properties**: display name `Kirian`, category Arcade, description = the
   short description, icon `play-assets/icon_512.png`, feature graphic as above.
3. **Credentials → Add credential → Android**: package `com.ab.kiran`,
   OAuth client with the **SHA-1 of the app signing key** — Play Console →
   Test and release → **App integrity → App signing → App signing key
   certificate → SHA-1**. Add a second credential with the **upload key**
   SHA-1 `73:C8:1A:1A:89:43:D5:09:BB:0B:86:18:A0:35:80:C6:31:9E:EA:02` only if
   you want to test APKs installed from GitHub Releases (they are signed with
   the upload key, not by Play).
   Google Cloud will ask to configure the **OAuth consent screen** first:
   External, app name Kirian, support email as above, no scopes.
4. **Testers**: add your own Google account so it works before publishing.
5. **Leaderboards** (2) and **Achievements** (34), below.
6. **Review and publish** the Play Games configuration — independent of the
   app release; it can go out first.
7. Send me: the numeric **Application ID** (Configuration page, 12 digits),
   both leaderboard IDs and the 34 achievement IDs (`CgkI…`). The
   **Achievements → Get resources** button gives them all as one XML — paste
   that.

### Leaderboards

| Name | Format | Order | Icon |
|---|---|---|---|
| Top Score | Numeric, no decimals | Larger is better | `play-games/leaderboard_top_score.png` |
| Deepest Sector | Numeric, no decimals | Larger is better | `play-games/leaderboard_deepest_sector.png` |

Tamper protection on, no limits. Same meaning as the Game Center boards
(`kiran_topscore`, cumulative score; deepest level ever reached).

### Achievements

Icons are 512×512 RGB in `play-assets/play-games/<id>.png` (from the same
art as Game Center). For every row: **Incremental** only where Steps is
given (enter that step count); initial state **Revealed**; points as listed —
they total 920, under Play's 1000 cap. The ID column is the file name and the Game
Center ID; Play generates its own `CgkI…` IDs.

| ID | Name | Description | Pts | Steps |
|---|---|---|---|---|
| `kiran_ach_sector_5` | Deep Space | Reach sector 5. | 10 | — |
| `kiran_ach_sector_10` | Into the Fire | Reach sector 10. | 25 | — |
| `kiran_ach_sector_20` | Veteran | Reach sector 20. | 50 | — |
| `kiran_ach_sector_40` | Legend of Kirian | Reach sector 40. | 100 | — |
| `kiran_ach_first_kill` | First Blood | Destroy your first enemy. | 5 | — |
| `kiran_ach_kills_1000` | Exterminator | Destroy 1,000 enemies. | 25 | 1000 |
| `kiran_ach_kills_10000` | Armada Slayer | Destroy 10,000 enemies. | 100 | 10000 |
| `kiran_ach_falcon1_100` | Falcon I Hunter | Destroy 100 Falcon I fighters. | 10 | 100 |
| `kiran_ach_falcon2_100` | Falcon II Hunter | Destroy 100 Falcon II fighters. | 10 | 100 |
| `kiran_ach_falcon3_100` | Falcon III Hunter | Destroy 100 Falcon III fighters. | 10 | 100 |
| `kiran_ach_falcon4_100` | Falcon IV Hunter | Destroy 100 Falcon IV fighters. | 10 | 100 |
| `kiran_ach_falcon5_100` | Falcon V Hunter | Destroy 100 Falcon V fighters. | 10 | 100 |
| `kiran_ach_falcon6_100` | Falcon VI Hunter | Destroy 100 Falcon VI fighters. | 10 | 100 |
| `kiran_ach_elite_100` | Elite Hunter | Destroy 100 elite fighters. | 25 | 100 |
| `kiran_ach_boss_1` | Boss Down | Defeat a boss. | 25 | — |
| `kiran_ach_boss_10` | Serial Boss Killer | Defeat 10 bosses. | 50 | 10 |
| `kiran_ach_asteroid_1` | Rock Meets Hull | Ram an asteroid. | 5 | — |
| `kiran_ach_asteroid_50` | Asteroid Magnet | Ram 50 asteroids. | 25 | 50 |
| `kiran_ach_max_bubble_gun` | Bubble Gun Master | Upgrade the Bubble Gun to level XXV. | 25 | — |
| `kiran_ach_max_vulcan_cannon` | Vulcan Cannon Master | Upgrade the Vulcan Cannon to level XXV. | 25 | — |
| `kiran_ach_max_blaster` | Blaster Master | Upgrade the Blaster to level XXV. | 25 | — |
| `kiran_ach_max_laser` | Laser Master | Upgrade the Laser to level XXV. | 25 | — |
| `kiran_ach_max_small_bubble` | Small Bubble Master | Upgrade the Small Bubble to level XXV. | 25 | — |
| `kiran_ach_max_small_vulcan` | Small Vulcan Master | Upgrade the Small Vulcan to level XXV. | 25 | — |
| `kiran_ach_max_star_gun` | Star Gun Master | Upgrade the Star Gun to level XXV. | 25 | — |
| `kiran_ach_max_small_laser` | Small Laser Master | Upgrade the Small Laser to level XXV. | 25 | — |
| `kiran_ach_starts_10` | Regular | Start 10 runs. | 10 | 10 |
| `kiran_ach_starts_100` | Addicted | Start 100 runs. | 50 | 100 |
| `kiran_ach_time_1h` | Warming Up | Play for one hour. | 10 | 60 |
| `kiran_ach_time_10h` | No Sleep | Play for ten hours. | 50 | 600 |
| `kiran_ach_deaths_25` | Never Give Up | Lose your vessel 25 times. | 10 | 25 |
| `kiran_ach_coop` | Better Together | Play a co-op game. | 25 | — |
| `kiran_ach_skins_5` | Fashion Victim | Play with 5 different skins. | 10 | — |
| `kiran_ach_untouchable` | Untouchable | Clear a sector without taking damage. | 50 | — |

Steps and thresholds are the ones in `achievement_service.dart` (`target`,
`incremental: true`); time steps are minutes. Order in Play = the order above.

## App content (Policy → App content)

### Privacy policy
`https://lioilsources.github.io/Kiran/privacy.html` — see the Store listing
note: merge first so the updated version is live.

### App access
**All functionality is available without special access.** No login; Play
Games sign-in is automatic and optional.

### Ads
**No.** No ad SDK (`pubspec.yaml`).

### Content rating (IARC questionnaire)

Email `oldrich.vorechovsky.jr@gmail.com`, category **Game**.

| Question area | Answer | Why |
|---|---|---|
| Violence | **Yes — fantasy violence**, non-realistic, no blood, no humans harmed | spaceships explode into fragments |
| Blood / gore | No | |
| Fear / horror | No | |
| Sexuality / nudity | No | |
| Language | No | |
| Controlled substances | No | |
| Gambling / simulated gambling / loot boxes | No | skins are fixed-content one-time purchases |
| Users interact or exchange content (chat, voice, UGC) | **No** — co-op shares only gameplay over local Wi-Fi, no communication | `lib/net/` |
| Shares user location | No | |
| Digital purchases | **Yes** | in-app skins |
| Unrestricted internet | No | |

Expect **PEGI 7 / ESRB Everyone 10+ / USK 6** or close — matches the 4+/9+
neighbourhood on iOS. Accept the generated rating.

### Target audience and content
Select **13–15, 16–17 and 18+**. Not under 13: any under-13 band pulls in the
Families policy (and Play Games + IAP need extra review there). "Appeals to
children": **No**.

### Data safety

The app itself collects nothing. The **Play Games Services SDK** does, on the
app's behalf, and Google's guidance
(developer.android.com/games/pgs/data-collection) says to declare it:

- Does your app collect or share any of the required user data types? **Yes.**
- Is all user data encrypted in transit? **Yes** (HTTPS, per Google).
- Do you provide a way for users to request deletion? **No** account in the
  app; the player deletes Play Games data in their Play Games profile. Answer
  No (deletion is required only for apps with account creation).
- Data types, all **Collected**, not shared, processed ephemerally: No,
  required (cannot be turned off in the app):

| Data type | Purpose | Source |
|---|---|---|
| App activity → **Other actions** (scores, achievements) | App functionality | leaderboards, achievements |
| App info and performance → **Diagnostics** | Analytics | PGS SDK default |
| App info and performance → **Crash logs** | Analytics | PGS SDK default |

Not collected: location, personal info, financial info (purchases are Play
Billing's data, not ours), device IDs, contacts, files, messages.
**Advertising ID: No** — verified: the merged manifest of the 2.9.1 (85) AAB
has no `com.google.android.gms.permission.AD_ID` (permissions: INTERNET,
ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE, CHANGE_WIFI_MULTICAST_STATE,
com.android.vending.BILLING).

### Other declarations
Government app **No** · Financial features **None** · Health **No** · News
**No** · COVID-19 **No** · Data deletion: not applicable (no account creation).

## Signing and versionCode

- **Upload key** = the CI keystore in the `ANDROID_KEYSTORE_BASE64` secret,
  `CN=Kirian, OU=Mobile, O=lioilsources` — SHA-256
  `c0:8c:32:a6:3e:fd:1a:ba:0a:13:82:5e:54:8f:f7:df:70:f7:38:6b:9b:84:db:85:b4:9c:69:c0:1e:39:1b:c8`,
  SHA-1 `73:c8:1a:1a:89:43:d5:09:bb:0b:86:18:a0:35:80:c6:31:9e:ea:02`.
  It exists **only** in GitHub secrets — not on this Mac (`~/upload-keystore.jks`
  is PoetryStream's key, a different certificate). So every Play AAB comes
  from CI.
- **Play App Signing**: accept the **Google-generated app signing key**
  (default) at the first upload.
- versionCode = `github.run_number` of `release-android.yml`; versionName from
  the tag, or `pubspec.yaml` on an untagged run.
  - **2.9.1 (85)** — run #85, manual run on `release/2.9.x`, AAB in the run's
    artifacts (`kirian-aab-85`). For Internal testing only: no Play Games IDs.
  - **2.9.2 (86+)** — tag `v2.9.2` on `release/2.9.x` once the IDs are in;
    AAB attached to the GitHub Release. This is the Production build. The
    same tag also builds iOS 2.9.2 for the Japanese App Store listing.
- Do not upload any `v3.x` AAB from GitHub Releases: they are `com.ol1n.kiran`.

## Release — new app `com.ab.kiran`

1. **Create app** (A+B → All apps → Create app): name `Kirian: Space
   Shooter`, default language **English (United States)**, **Game**,
   **Free**, accept the declarations.
2. **Store settings**: category Arcade, tags, contact email, website.
3. **Main store listing**: en-US texts, icon, feature graphic, phone + tablet
   screenshots. **Manage translations → Add your own → Japanese (ja-JP)**,
   texts from `googleplay-listing-ja.md`, screenshots from `screenshots-ja/play-*`.
4. **App content**: everything above.
5. **Production → Countries/regions**: all countries.
6. **Internal testing → Create new release**: accept Play App Signing,
   upload `app-release.aab` from run #85's artifact (2.9.1 (85)), add yourself
   as tester, **Save and roll out**. This unlocks in-app products and shows
   the app signing key.
7. **In-app products**: create and activate the 11 above (needs the
   payments profile).
8. **Play Games Services**: setup above; send me the IDs.
9. I put the IDs into `strings.xml`, `leaderboard_service.dart` and
   `achievement_service.dart` on `release/2.9.x` and tag **v2.9.2**.
10. **Production → Create new release**: upload the 2.9.2 AAB from the GitHub
    Release, notes en-US + ja-JP, **Next → Save**. Optionally turn on
    **Managed publishing** to pick the go-live moment.
11. **Publishing overview → Send changes for review.** A new app's first
    review usually takes several days, sometimes over a week.

### CI follow-ups (not blockers)

- **Firebase App Distribution**: `FIREBASE_ANDROID_APP_ID` is registered for
  `com.ol1n.kiran` (`google-services.json` has no `com.ab.kiran`), so the step
  will fail for `com.ab.kiran` tag builds. It runs last; the GitHub Release
  already has the AAB by then. Register `com.ab.kiran` in Firebase or drop the
  step. On `release/2.9.x` it is skipped for manual runs.
- **Automatic Play upload** (as PoetryStream has, `r0adkll/upload-google-play`)
  needs a service account invited to the A+B account and works only after the
  first manual upload. Worth adding once 2.9.2 is out.
- `main` (v3) already has `com.ab.kiran`; its next tag builds an AAB for the
  same Play app, with a higher versionCode — that is the v3 update path.
