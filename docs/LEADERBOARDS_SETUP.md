# Leaderboard setup — Game Center + Google Play Games

The app submits each run's score (the vessel's credit) to a native leaderboard
and opens the platform's native leaderboard UI. There is **no** on-device score
table anymore. Leaderboards work on **iOS, macOS (Game Center)** and **Android
(Play Games)**; on **Windows/Linux** there is no leaderboard (the button is
hidden). All the code + native config is already in place — this checklist is
the **portal setup** that only you can do (needs the developer accounts).

Until the portal IDs below are filled in, sign-in fails gracefully:
`LeaderboardService.available` stays `false`, no score is submitted and the
"LEADERBOARD" button stays hidden. Nothing crashes.

Bundle id: `com.ol1n.kiran`.

## Where the IDs go (in this repo)

| ID | File | Constant / key |
|---|---|---|
| iOS/macOS leaderboard id | `tyrian_mobile/lib/services/leaderboard_service.dart` | `_iosLeaderboardId` (now `kiran_topscore`) |
| Android leaderboard id | `tyrian_mobile/lib/services/leaderboard_service.dart` | `_androidLeaderboardId` (placeholder) |
| Play Games APP_ID | `tyrian_mobile/android/app/src/main/res/values/strings.xml` | `game_services_app_id` (placeholder `000000000000`) |

## 1. Apple — App Store Connect + Xcode

1. **App Store Connect** → your app (`com.ol1n.kiran`) → **Features → Game
   Center → Leaderboards** → **+** → *Single Recurring / Classic*.
   - Reference name: `Top Score`
   - **Leaderboard ID**: `kiran_topscore` (must match `_iosLeaderboardId`)
   - Score format: **Integer**, sort **High to Low**.
   - Add at least one localization (e.g. English).
2. **Xcode** → open `tyrian_mobile/ios/Runner.xcworkspace` → Runner target →
   **Signing & Capabilities** → **+ Capability → Game Center**. (The
   entitlement file `ios/Runner/Runner.entitlements` and the
   `CODE_SIGN_ENTITLEMENTS` build setting are already wired; the capability
   toggle makes Xcode add it to the provisioning profile.)
3. macOS uses the same Game Center leaderboard; entitlements are already in
   `macos/Runner/{Release,DebugProfile}.entitlements`. Confirm the macOS app id
   in App Store Connect shares the Game Center config.

## 2. Google — Play Console (Play Games Services)

1. **Play Console** → **Play Games Services → Setup and management →
   Configuration** → create/link a Games Services project for `com.ol1n.kiran`.
   - Copy the numeric **Application ID** → put it in `strings.xml`
     (`game_services_app_id`).
2. **Credentials**: add an **Android** credential; register the **OAuth client**
   with the signing-certificate **SHA-1** of the **release keystore** (the one
   the release workflow signs with) — and also the **debug** keystore's SHA-1 so
   you can test debug builds. (`keytool -list -v -keystore <ks> -alias <alias>`.)
3. **Leaderboards** → **Create leaderboard** → *Top Score*, Integer, High to Low
   → copy its **ID** (looks like `CgkI…`) → put it in `_androidLeaderboardId`.
4. Publish the Play Games Services configuration (testing track is enough to
   test with allow-listed testers).

## 3. Fill the IDs & verify

1. Edit `_iosLeaderboardId` / `_androidLeaderboardId` in
   `lib/services/leaderboard_service.dart` and `game_services_app_id` in
   `strings.xml` with the real values.
2. Build to a **real device** signed into Game Center / Play Games (leaderboards
   don't work in most simulators/emulators).
3. Play → die → the score should appear in the platform's leaderboard; in the
   ComCenter and on the game-over screen the **LEADERBOARD** button opens the
   native overlay.
4. On Windows/Linux the button is absent by design (no native leaderboard).

## Notes

- Score submitted = `vessel.credit`; in co-op only the local player's score is
  submitted (each device submits its own).
- Old on-device high scores are **not** migrated (Game Center/Play Games have no
  import path).
- The `games_services` package (v4) uses the Play Games SDK v2 auto sign-in — no
  explicit sign-in button; `LeaderboardService.init()` triggers it at launch.
