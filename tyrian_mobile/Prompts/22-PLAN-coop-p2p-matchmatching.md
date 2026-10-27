# 22 — PLAN: P2P co-op via MatchMatching

Plan for validating the MatchMatching playground on physical devices and then
replacing Kiran's LAN-socket co-op with its lobby protocol — including the
router-less transports (iOS Multipeer, Android Nearby) and the in-game UX.

Written 2026-08-15 after a full audit of `lib/net/` and of the
`lioilsources/MatchMatching` repo. The audit facts below carry file:line
references so this plan can be executed without re-exploring.

---

## Context: what exists on each side

### Kiran co-op today (audited)

Pure LAN BSD sockets, no P2P capability of any kind (no networking package in
`pubspec.yaml` at all):

- TCP game channel on port 5743, host binds `anyIPv4`, 1 client max
  (`lib/net/coop_host.dart:9,32-46`). Client sends `(dx, dy, fire)`; host
  streams a **full world snapshot every frame** at ~60 Hz
  (`tyrian_game.dart:512-515`, `protocol.dart:342-368`), no delta, no
  interpolation.
- UDP discovery beacon (port 5742, broadcast + multicast 239.42.42.42) is
  **write-only dead code**: `CoopDiscovery.startListening()`
  (`discovery.dart:48`) is never called anywhere. The only join path is the
  player typing the host's IP shown in the ComCenter header
  (`main.dart:239-276`, `com_center.dart:887-892`).
- **Every press of PLAY auto-hosts** — there is no true solo mode
  (`main.dart:400-403` → `_startAsAutoHost`); every session binds 5743 and
  broadcasts beacons nobody hears.
- iOS: `NSLocalNetworkUsageDescription` + `NSBonjourServices` declared
  (`ios/Runner/Info.plist:31-38`) but **no mDNS code backs them**, and the
  `com.apple.developer.networking.multicast` entitlement is absent — so on
  iOS 14+ both beacon sends fail silently (they are wrapped in
  `catch (_) {}`, `discovery.dart:34-35`).
- Android: manifest has INTERNET / ACCESS_WIFI_STATE /
  CHANGE_WIFI_MULTICAST_STATE, but no `MulticastLock` is ever acquired
  (`MainActivity.kt` is a bare stub) — beacon reception would be unreliable.
- Known debts: manual-IP dialog hardcodes port 5743 so the random-port
  fallback is unjoinable (`main.dart:268`); no reconnect after backgrounding
  (`main.dart:194-204` pauses but never re-opens sockets); framer "reset" via
  `addData(Uint8List(0))` doesn't reset — a client dying mid-frame poisons
  the buffer for the next one (`coop_host.dart:90`); shop/ready sync protocol
  is fully encoded but never invoked (`coop_client.dart:84-89`,
  `protocol.dart:643`); macOS **Release** entitlements lack
  `com.apple.security.network.server`, so shipped macOS builds cannot host
  (fix already sits on the unmerged `chore/mac-app-store` branch).
- Verdict: two phones on a friendly home router can play today via manual IP.
  Anything else — discovery, hostile networks, backgrounding, no router —
  does not work.

### MatchMatching (github.com/lioilsources/MatchMatching)

A P2P lobby playground built exactly for the missing piece:

- Transport-agnostic lobby state machine
  (`lib/src/orchestrator/lobby_orchestrator.dart`, 784 lines): browse-first
  host election ("first node that finds nothing becomes host"), split-brain
  tie-break, retries, reconnect, handshake, roster, RTT.
- Four backends: **Multipeer** (iOS, AWDL/BT, no router; 290-line Swift),
  **Nearby** (Android, P2P_STAR = BT/Wi-Fi Direct, no router; 303-line
  Kotlin), **LAN** (UDP broadcast **and** mDNS in parallel — mDNS is the
  primary iOS path, which sidesteps the multicast entitlement), **Loopback**
  (in-process, spawns bot nodes).
- Wire protocol documented in `docs/PROTOCOL.md` (247 lines), explicitly
  designed for reimplementation by other apps; manual device checklist in
  `docs/TEST-MATRIX.md`.
- Validated: 124 unit tests (state machine under fake time, protocol,
  fuzzing, sockets) + `tool/multi_node_test.dart` spawning real OS processes
  (convergence, chat relay, host-kill re-election, 20× simultaneous start).
- **Not validated: the native Multipeer/Nearby pipes on physical devices,
  OS permission prompts, radio behaviour.** That is precisely what the
  playground's on-screen logging exists for.

### The one hard limitation to design around

Multipeer and Nearby do not interoperate. Router-less play is
iPhone↔iPhone (Multipeer) or Android↔Android (Nearby). **iPhone↔Android
without shared Wi-Fi is not covered by either API** — the fallback is one
player enabling a personal hotspot and both using the LAN transport. The UX
must say this instead of letting mixed pairs fail silently.

---

## Phase 1 — validate MatchMatching on physical devices

Goal: a written verdict per transport before any Kiran work starts.

1. Build the playground on: 2× iPhone, 2× Android (one API 33+, one older if
   available), 1× macOS. `flutter run -d <device>`.
2. Walk `docs/TEST-MATRIX.md` per transport. Minimum pass bar:
   - **Multipeer** (both iPhones, Wi-Fi *and* airplane-mode-with-BT):
     discovery < 5 s, join, chat RTT sane, host-kill → re-election, member
     drop/rejoin. Watch the two documented sharp edges: browsing must not
     stop until `.connected`, and `discoveryInfo` refresh requires
     advertiser restart (PROTOCOL.md §6.2).
   - **Nearby** (both Androids, no router): permission cascade on API 33+
     (`BLUETOOTH_SCAN/ADVERTISE/CONNECT` + `NEARBY_WIFI_DEVICES`) actually
     grantable from the in-app flow; discovery, join, re-election as above.
   - **LAN** (all five devices, shared Wi-Fi): which discovery source
     delivers on iOS — expectation is **mDNS works, raw broadcast does not**
     (no multicast entitlement); the log panel shows the winning path per
     peer. Verify Android receives beacons with screen off only if the
     MulticastLock is held.
   - **Backgrounding**: home-button the host and a client mid-lobby on both
     platforms; record what the orchestrator's reconnect actually recovers.
3. Export JSON traces of every failure → commit to MatchMatching as
   regression fixtures (the README's intended loop).
4. Deliverable: a short RESULTS.md in MatchMatching — per transport:
   works / works-with-caveats / broken, with trace links. **Decision gate:**
   only transports that pass carry into Kiran; if Nearby or Multipeer fails
   fundamentally, Kiran still gets the LAN+mDNS transport, which alone fixes
   discovery on shared Wi-Fi.

## Phase 2 — extract the library

Goal: MatchMatching's orchestrator + backends usable from Kiran without the
playground UI.

1. Split the repo into `packages/match_matching` (orchestrator, protocol,
   backends, native pipes) and the playground app depending on it. The UI
   already only touches the backend via `LobbyBackend`/`LobbySession`, so
   the seam exists.
2. Kiran consumes it as a git dependency in `pubspec.yaml`.
3. Native code travels as a federated-style plugin (the Swift/Kotlin files +
   MethodChannels), so Kiran's `Runner`/`MainActivity` stay untouched apart
   from registration.
4. Keep the playground app alive — it is the debugging tool for every future
   transport issue and the README's trace-to-fixture loop depends on it.

## Phase 3 — Kiran integration (architecture)

Goal: Kiran's existing game protocol rides on a `LobbySession` instead of raw
sockets. Kiran's `protocol.dart` frames become opaque payloads; the lobby
owns discovery, election, membership and reconnect.

1. **Layering.** Replace the socket layer of `CoopHost`/`CoopClient` with a
   `LobbySession` channel. Keep `protocol.dart`'s message encoding as-is —
   over Multipeer/Nearby the transport is message-based (no length prefix
   needed, per PROTOCOL.md §6.2/6.3), over LAN TCP the existing framing
   stays. This also retires the framer-reset bug (`coop_host.dart:90`) since
   per-message transports don't share a stream buffer.
2. **Roles.** Lobby host = game host (owns simulation, streams snapshots);
   the browse-first election **replaces auto-host-on-play** — solo play
   opens no sockets at all. Cap the lobby at 2 members for now (Kiran
   supports host + 1 client; `maxMembers` is already a beacon field).
3. **Reconnect.** The orchestrator's reconnect becomes the missing
   resume-after-backgrounding path; the game pauses (host) or shows a
   reconnecting overlay (client) while the lobby re-forms — see UX below.
4. **Bandwidth flag, not blocker:** the 60 Hz full-snapshot stream should
   drop to ~20-30 Hz with client-side interpolation before shipping over
   BT-backed transports; measure on devices first (Multipeer over AWDL may
   cope fine). Tune after integration, on the playground's RTT numbers.
5. **Cleanups on the way:** delete the dead beacon code
   (`discovery.dart`), the manual-IP path (kept only behind an advanced
   toggle, see UX), and either wire or delete the never-invoked shop-sync
   protocol (`protocol.dart:643` — recommend delete now, resync later if
   co-op shopping becomes a feature). Merge the macOS
   `network.server` entitlement fix from `chore/mac-app-store`.
6. **Permissions/entitlements** (copy the working patterns from
   MatchMatching's `Info.plist`/manifest): iOS keeps
   `NSLocalNetworkUsageDescription`, updates `NSBonjourServices` to the real
   mDNS service type, adds the two Bluetooth usage strings for Multipeer.
   Android adds the Nearby runtime-permission set per API level
   (PROTOCOL.md §6.3). **Skip the iOS multicast entitlement entirely** —
   mDNS covers LAN discovery; raw broadcast on iOS is not worth an Apple
   approval process.

## Phase 4 — UX in Kiran

Principles: solo is the default and touches no radios; co-op is one button;
the player never types an IP; every failure has a visible reason.

1. **Entry point.** ComCenter gains a `PLAY TOGETHER` button next to
   `START MISSION` (replacing today's `JOIN` + IP dialog,
   `com_center.dart:1594-1596`). Plain PLAY = solo, zero sockets.
2. **Lobby screen** (new, themed via `UiTheme.forSkin` like the ComCenter):
   - On entry: transport picker is implicit — LAN + the platform's P2P
     backend run in parallel, exactly as the orchestrator's model intends.
     Status line cycles `Searching for nearby games…` while browsing.
   - Found lobbies listed as cards: host name, `1/2`, transport badge
     (Wi-Fi / Nearby / Multipeer). Tap = join.
   - Nothing found after the election timeout → this node **becomes the
     host automatically** (protocol's browse-first model) and the screen
     flips to `Hosting — waiting for a player…` with the roster.
   - Roster shows both players with ping once joined; host's
     `START MISSION` goes enabled; client sees `Waiting for host to start`
     (this state already exists — `main.dart` `_clientWaiting`).
   - Back button tears the lobby down cleanly (host handoff per protocol if
     a client remains).
3. **Permission choreography.** Before the first browse on each platform,
   one inline explainer in the lobby screen (not a modal):
   "Finding nearby players uses the local network »" with a Continue button
   that triggers the OS prompt(s). Denial → the affected transport shows a
   chip `Local network off — open Settings`, other transports keep working.
   Never trigger OS permission prompts from plain solo PLAY.
4. **Failure surfacing.** The silent `catch (_) {}` pattern is banned in the
   new layer: every backend error maps to a user-readable status chip in the
   lobby (the playground's log taxonomy — NATIVE / state transitions —
   already names them). Mixed-platform no-router case gets explicit copy:
   "iPhone and Android can only pair over Wi-Fi. Turn on a personal hotspot
   on one phone and join it from the other."
5. **In-game disconnect.** Client loss: host gets a FloatText (exists,
   `tyrian_game.dart:1021`) and plays on solo. Host loss: client gets a
   full-screen `Connection lost — Reconnecting… (10s)` overlay driven by the
   orchestrator's reconnect; on failure, return to the lobby screen with the
   reason, not to a frozen game. Backgrounding mid-game = the same path.
6. **Advanced fallback.** Manual IP entry survives behind a long-press on
   `PLAY TOGETHER` (hotel AP-isolation + hotspot cases where discovery is
   filtered but unicast works). Port becomes part of the entered string
   (`ip:port`), fixing the random-port-fallback hole (`main.dart:268`).

## Phase 5 — rollout

- **M1**: Phase 1 report committed to MatchMatching (traces + RESULTS.md).
- **M2**: package extraction; playground still green (124 tests + multi-node).
- **M3**: Kiran lobby UI + LobbySession transport behind a debug flag;
  LAN transport on desktop first (fastest loop), then devices.
- **M4**: P2P transports on devices; snapshot-rate tuning with RTT data;
  permissions review against the store checklists (PROTOCOL.md §7).
- **M5**: remove the flag, delete dead code, release. Store notes: new
  Bluetooth usage strings will trigger App Review questions — answer is
  local co-op; no multicast entitlement needed (mDNS path).

Out of scope, recorded so they're deliberate: >2 players (protocol supports
it, Kiran's snapshot/roles don't), cross-platform router-less pairing
(hotspot copy is the answer), co-op shop synchronisation (dead code today —
delete, revisit as its own feature), iCloud/GameCenter matchmaking.
