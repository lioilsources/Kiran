# Store screenshots

Two steps: capture the real app on a simulator, then caption and size the
captures per store and language.

```bash
cd tyrian_mobile

# 1. Raw captures (~6 min per device). Creates nothing in the repo; output in build/.
xcrun simctl create Kirian-Shots-iPhone com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro-Max
xcrun simctl create Kirian-Shots-iPad   com.apple.CoreSimulator.SimDeviceType.iPad-Pro-13-inch-M5-12GB
tool/store_screenshots.sh Kirian-Shots-iPhone build/store_screenshots/iphone
tool/store_screenshots.sh Kirian-Shots-iPad   build/store_screenshots/ipad

# 2. Captions + every store size → marketing/screenshots-<lang>/
python3 marketing/screenshots/compose.py -lang ja
```

## What the capture does

`test_driver/store_app.dart` starts the real app over a seeded save — every
skin owned, a level-10 Laser / Star Gun / Small Vulcan loadout, sector 10 —
with the FPS overlay off. `test_driver/store_app_test.dart` then walks it:
skin grid → Com Center → a mission with auto-fire on, once per skin listed
there → campaign map, capturing each scene with `simctl io screenshot`.
Status bar pinned to 9:41.

Commands run with frame sync off (`runUnsynchronized`): Flame redraws every
frame, so the driver's default "wait until idle" never returns.

**Xcode 27:** the project targets iOS 13.0 and Xcode 27 refuses anything under
15.0, so the simulator build fails as checked in. Raising the deployment target
is a release decision (it drops iOS 13–14 devices), so it is not committed;
for a capture, bump `IPHONEOS_DEPLOYMENT_TARGET` to 15.0 in
`ios/Runner.xcodeproj/project.pbxproj` and in a Podfile `post_install`, run,
and revert.

## Capturing an older release (v2.9.1)

The current `screenshots-ja/` set is from **v2.9.1**, the release the
Japanese listing targets. Capture ran in a detached worktree of tag `v2.9.1`
with this driver copied in, three local edits that were never committed
(`flutter_driver` dev dependency, FPS overlay line removed, iOS target 15.0),
and a walk adapted to v2: no CAMPAIGN, and no MAIN MENU in the pause menu, so
skins are switched mid-mission via PAUSE → SKINS. Then:

```bash
python3 marketing/screenshots/compose.py -lang ja -raw build/store_screenshots_v2
python3 marketing/screenshots/compose.py -lang en -raw build/store_screenshots_v2  # Google Play en-US
```

A single walk does not reach the fourth skin: the seeded ship dies after about
a minute of auto-fire, and with it the PAUSE button the walk taps. So the
iPhone ran twice, the second time with `SHOTS_ONLY_SKINS=1` (skips the
opening shots, walks only Retro PC Pixel and Dual-Polarity), both into the
same folder.

## Output (per language)

| Folder | Size | Store slot |
|---|---|---|
| `appstore-iphone-6.9` | 1320×2868 | iPhone 6.9" (required; smaller iPhones scale from it) |
| `appstore-iphone-6.3` | 1206×2622 | iPhone 6.3" — the "medium display" slot takes only 1206×2622 or 1179×2556 |
| `appstore-ipad-13` | 2064×2752 | iPad 13" |
| `play-phone` | 1080×1920 | Play phone |
| `play-tablet7` | 1200×1920 | Play 7" tablet |
| `play-tablet10` | 1600×2560 | Play 10" tablet |
| `appstore-creative/header-3840x1646.png` | 21:9 | product page header (new, iOS 27+) |
| `appstore-creative/search-3840x2560.png` | 3:2 | search results (new, iOS 27+) |

All RGB, no alpha (App Store Connect rejects alpha). `compose.py` clears each
folder before writing, so a renumbered scene never leaves a stale `NN_` file
behind.

### Header and search results (App Store, new in Oct 2026)

App Store Connect → version page → **Header and Search Results** tab, or the
Asset Library to ship them without a new version. Both optional, shown on iOS
27 / iPadOS 27 and later only, attached **per localization**.

- **Header** carries no text, so the same file can go on every localization.
  A row of gameplay screens in five skins: one idea, the same game in many
  looks. Apple publishes no crop rule, so the middle three screens are what
  must survive; the outer two are allowed to be cut.
- **Search results** is localized: three gameplay screens and one line in the
  listing language. Apple's guidance for that slot is the real app shown
  clearly, plus one short line.
- Not allowed in either: prices, URLs, ©, other platforms' logos, Apple
  badges. Must meet the 4+ standard.
- Check the Preview in App Store Connect on iPhone and iPad before submitting.

Specs: [Creative assets specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications/).

## Adding a language

Add an entry to `SCENES` and `SEARCH_LINE` in `compose.py`. Hiragino covers
Japanese; Korean needs a Hangul font (Apple SD Gothic Neo) swapped into
`HEAD`/`BODY`. Captions are single lines: write them to fit, `fit_text` only
shrinks.
