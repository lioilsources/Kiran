# Anonymous gameplay statistics

Kirian sends a small set of anonymous gameplay events so the owner can see
where new players drop off, how long sessions last, how the ComCenter is
understood and which levels are too hard. This file is the **event
dictionary**: the code constant `TelemetryDictionary`
(`tyrian_mobile/lib/services/telemetry_dictionary.dart`) and this document
list exactly the same events and properties, and `test/telemetry_test.dart`
fails when they drift apart. The plan behind it is
`tyrian_mobile/Prompts/33-PLAN-analytika.md`.

This is the **2.x line** (`release/2.9.x`). It sends the same events with the
same properties as `main` (3.x), so both read the same in the dashboards;
where 2.x lacks a feature (campaign, arena, difficulty, sigils, tester
builds) the property carries its one fixed value.

Adding an event or a property is a change to the privacy policy
(`docs/privacy.html`) and to the store privacy answers. Ask the owner first.

## Rules

- **No persistent identifier.** No install, device or advertising id. Each
  session gets a random 128-bit id that lives in memory. Unsent events
  waiting in the offline queue carry the id of the session they came from
  and are deleted once sent. The next session never reuses it.
- **Cohorts are computed on the device.** The device keeps the day
  measurement started and a session counter; only bands leave it.
- **Only enums, bands and numbers.** No free text, no pilot name, no device
  model. Skin ids, weapon names and language codes are catalogue constants.
  `TelemetryService.track` drops any event that does not validate against
  the dictionary.
- **No key, no network.** Without `TELEMETRY_KEY` and an `https`
  `TELEMETRY_HOST` the service builds no sink and does nothing: local
  builds, forks and tests are silent.
- **The game never waits.** `track` is synchronous; sending runs on a 30 s
  timer and right after `session_pause`, with 5 s connect and 8 s request
  timeouts. Every failure is swallowed.
- **Bounded offline queue.** At most 500 events, oldest dropped first,
  kept in `shared_preferences` across launches. An event's timestamp is when
  it happened, not when it was sent.
- **Off means off, at once.** The toggle wipes the queue in memory and on
  disk. Nothing further is sent, queued events included.
- **Measuring never steers the game.** No gameplay code reads anything the
  service holds.
- **Vendor behind an interface.** `TelemetrySink` has one method; the
  PostHog implementation is `PostHogSink`.

## Configuration

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | The vendor's project key (PostHog `phc_…`). Empty → nothing is sent. |
| `TELEMETRY_HOST` | Ingestion host, e.g. the PostHog EU ingestion host. Must be `https`. Empty → nothing is sent. |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them. For checking a build by hand. |

The release workflows (`release-ios`, `release-android`, `release-macos`,
`release-windows`, `release-linux`, `steam-deploy`) pass both from the GitHub
secrets of the same names. An absent secret expands to an empty string and
the build is silent. The key, the project URL and dashboard links never go
into this public repository.

## Transport

PostHog Cloud EU, HTTP batch capture (`POST /batch/`). Each event carries
`distinct_id` = the session id and `$process_person_profile: false`, so
PostHog creates no person profiles and nothing links two sessions. The
client is a thin `dart:io HttpClient`; no SDK (the official plugins lack
Windows and Linux, and a new dependency could outgrow the Dart pinned in CI).

## Sessions and cohorts

- A session starts at a cold start, or on returning to the app after more
  than 30 minutes in the background (`app_open` with `start: resume`).
- `session_pause` is sent at once when the app goes to the background
  (`hidden`/`paused`) or closes, because the system may end the process.
- If the app goes to the background mid-sector, a `sector_end` with
  `result: background` is parked on disk. Coming back drops it; if the
  process never comes back, the next launch sends it with its original time.
- `days_band` is `pre` for a pilot who had a save, a chosen skin or
  achievement progress before measuring began: their real install day is
  unknown, and they are not counted as new (`first_session: false`).

## Retention

Raw events are kept **12 months**, set in the PostHog project settings.

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kTelemetryAppVersion`, checked against `pubspec.yaml`) |
| `line` | enum | `2` here (`3` on `main`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's resolved language, one of the shipped locales (`en`, `pt`, `zh_Hant`, …) |
| `skin` | enum | current skin id from `kSkins`, or `none` |
| `input` | enum | last input used: `touch`, `mouse`, `pad`, `keyboard`, `none` |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began on this device: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` |
| `first_session` | bool | the very first session on a new install |
| `mode` | enum | `endless` (the only mode on 2.x) |
| `difficulty` | enum | `normal` (2.x has no difficulty choice) |
| `tester` | bool | tester build; always `false` on 2.x |

## Events

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |

### `menu_ready`

The main menu is usable (game loaded, save restored). Once per launch.

| Property | Type | Values |
|---|---|---|
| `ms` | int | milliseconds since the process started |

### `skin_tap`

A skin card was chosen in the skin grid.

| Property | Type | Values |
|---|---|---|
| `target` | enum | the tapped skin id |
| `owned` | bool | already owned |
| `result` | enum | `play` (owned: loads and plays), `purchase` (not owned: store sheet) |
| `load_ms` | int | milliseconds to load the skin's art, sound and music; `0` for `purchase` |
| `where` | enum | `menu` (main menu), `pause` (pause-time selector) |

### `purchase`

The end of a skin purchase the player started.

| Property | Type | Values |
|---|---|---|
| `target` | enum | skin id |
| `result` | enum | `ok`, `cancel`, `error` |

### `comcenter_open`

The ComCenter appeared.

| Property | Type | Values |
|---|---|---|
| `reason` | enum | `first` (from the main menu), `sector` (after a cleared sector), `death` (after a death), `resume` (back from the background) |
| `credits_band` | band | `0`, `1-999`, `1k-10k`, `10k-100k`, `100k-1m`, `1m+` |
| `index` | int | sector index |
| `buys_avail` | int | unlocked, unowned weapons the pilot can afford |
| `upgrades_avail` | int | fitted weapons and generator the pilot can afford to upgrade |

### `comcenter_close`

The ComCenter left the screen. Going to the background closes the visit
(`exit: background`); coming back opens a new one (`reason: resume`).

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds on screen |
| `buys` | int | weapons bought |
| `upgrades` | int | upgrades bought |
| `sells` | int | weapons sold |
| `switches` | int | owned weapons swapped in from the hangar |
| `unavailable` | int | taps on a locked tier or on something too expensive |
| `skin_changed` | bool | a skin was switched or bought from the ComCenter |
| `exit` | enum | `start` (mission launched), `menu`, `background` |
| `left_affordable` | bool | something was still affordable on leaving |

### `sector_start`

A sector begins.

| Property | Type | Values |
|---|---|---|
| `index` | int | sector index |
| `level` | int | difficulty level |
| `dps_band` | band | loadout DPS: `0-99`, `100-299`, `300-999`, `1k-3k`, `3k-10k`, `10k+` |
| `front` | enum | front weapon (`bubble_gun`, `vulcan_cannon`, `blaster`, `laser`, … or `none`) |
| `front_level` | int | its level |

### `sector_end`

The sector being flown ends.

| Property | Type | Values |
|---|---|---|
| `index` | int | as in `sector_start` |
| `level` | int | as in `sector_start` |
| `result` | enum | `completed`, `death`, `menu` (back to the main menu when a co-op partner drops), `background` (left the app and never came back), `quit` (quit to desktop) |
| `secs` | int | seconds flown in the sector |
| `part` | int | part of the level, `1`–`3`, for the hand-authored sectors; `0` for generated ones |
| `cause` | enum | what dealt the fatal hit, for `death`: `shot`, `ram` (collision with an enemy), `asteroid`; `none` otherwise |
| `boss` | bool | a boss was on the field |
| `switches` | int | weapons swapped in flight; always `0` on 2.x (no sigils) |

### `session_pause`

The app goes to the background or closes.

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session so far |
| `screen` | enum | `menu`, `comcenter`, `game`, `pause`, `game_over` |
| `index` | int | sector index at the time |
| `sectors` | int | sectors started this session |
| `deaths` | int | deaths this session |

## Reading the data (T5)

The first-session funnel in the plan names a `run_start` step; there is no
such event. The first `sector_start` of a session is the run start.

Saved views to create in PostHog once the project exists (filter
`tester = false` everywhere; split by `line` and `platform` where useful):

1. **First-session funnel.** Funnel, `first_session = true`, steps
   `app_open` → `menu_ready` → `skin_tap` → `sector_start` → `sector_end`,
   conversion window 1 hour, aggregated by `distinct_id` (= session).
2. **Time to quit.** Trend of the last `session_pause` per session: histogram
   of `active_secs`, broken down by `screen`. Second tab: same with
   `first_session = true` only.
3. **Session length.** Per session: max `active_secs` and max `sectors` from
   `session_pause`; weekly median and p75. Breakdown by `session_band`.
4. **New against returning.** Weekly unique sessions broken down by
   `session_band` and by `days_band`.
5. **ComCenter understanding.** From `comcenter_close`: median `secs`,
   share with `buys + upgrades = 0`, share with `left_affordable = true`,
   mean `unavailable`; broken down by the `reason` of the matching
   `comcenter_open` and by `session_band`.
6. **Unplayable levels.** From `sector_end` with `mode = endless`: by
   `level` × `part` × `difficulty`, the share of `result` in (`death`,
   `menu`, `background`, `quit`); for deaths, breakdown by `cause` and
   `boss`, and median `secs`. A second table for `mode = campaign` by
   `index` (3.x only).

Load times: `menu_ready.ms` and `skin_tap.load_ms` (where `result = play`),
p50/p90 by `platform`.

## Owner setup (T0)

1. Create the PostHog Cloud **EU** project. Settings to check in the
   project itself, not from memory:
   - **Discard client IP data** on.
   - GeoIP: keep the **country** only (drop city, subdivision, postal code
     and coordinates, e.g. with a property-drop transformation). Check
     whether discarding the IP still allows the country lookup; if it does
     not, decide between country and IP discarding before launch.
   - Data retention **12 months**.
   - Person profiles: the client already sends
     `$process_person_profile: false`; confirm no persons appear.
   - Accept the DPA.
   - Free tier volume (about 25 events per five-sector session).
2. Add the GitHub secrets `TELEMETRY_KEY` (project API key) and
   `TELEMETRY_HOST` (the EU ingestion host, `https://…`).
3. Publish the new `docs/privacy.html` and fill in App Store App Privacy,
   Google Play Data safety and the Steam AI disclosure
   (answers in `tyrian_mobile/marketing/*-listing.md` and
   `store/steam/content-questionnaire.md`) **before** any build with
   telemetry goes to a store. Order: policy → forms → release.

## Checking a build by hand (T2)

Run a development build with the real key once and play one full session:

```bash
cd tyrian_mobile
flutter run -d macos \
  --dart-define=TELEMETRY_KEY=<key> --dart-define=TELEMETRY_HOST=<host>
```

Then compare PostHog's live events with this dictionary: only the events
above, each with exactly its properties plus the common ones. With
`--dart-define=TELEMETRY_DEBUG=true` instead, the same events print to the
console and nothing is sent.
