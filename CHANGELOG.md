# Changelog

## [06/09/2026]
- Co-op: JOIN now lists the hosts on your Wi-Fi by pilot name — tap one to connect, no IP to type. Discovery is Bonjour, so it works on iOS 13+ (the iPad on 17 and the iPhone on 26 that could not find each other), macOS, Android and Windows without any special entitlement. The old UDP beacon needed Apple's multicast entitlement, which the app never had, so on iOS it silently never left the phone — which is why the join screen ended up asking for an address nobody could see
- Co-op: a host is listed only while its seat is free — the advertisement goes away when a player connects and comes back if they drop
- Co-op: typing an IP is still there under "Enter IP manually" for networks that block mDNS between clients; the host still shows its IP in the shop for that case

## [21/08/2026]
- Every skin now has its own artwork for all seven zones: the sky shifts from cold and calm at the frontier through teal and amber to crimson as you push deeper. Previously only two skins of fourteen did this — the rest reused one background everywhere, and the default skin had no background art at all
- The default skin's ship is animated for the first time (its thruster pulses like every other skin's) and now matches the rest of its own artwork instead of being the last piece of legacy pixel art
- Fix: power-up icons showed as opaque squares in five skins (Blazing Lazers had all four affected), and an asteroid in Ikaruga carried a dark plate behind it
- Despite 154 new background layers, the app is about 26 MB smaller — the flat backgrounds they replace were heavier than the entire new set

## [21/08/2026]
- Fix: power-up drops in the default skin had no artwork — they fell back to a plain coloured square with a letter. The five HUD icons the collectables use were the one asset the skin had never had generated; they now exist, and the same icons return to the HUD and shop
- Fix: the default skin's boss rendered as an opaque red rectangle — the shipped sprite was a bare texture rather than a ship, and predated sprite supersampling
- Fix: the Star Gun projectile in the default skin was a grey box with a white cross — a placeholder that was never replaced; it is now a proper energy star
- Fix: enemies drawn side-on instead of facing the player — six in Chrome Fleet (2004) and one in Dual-Polarity (2001), re-picked from art that was already generated
- Fix: boss explosions flashed an opaque orange rectangle over the whole sprite for the first frames

## [21/08/2026]
- Enemy tally in the HUD is now a flat seven-segment LED readout with ghosted unlit segments — the rounded, drop-shadowed numeral was the one element breaking the HUD's segmented instrument look; the spawn pop animation is unchanged
- The game canvas now survives a rendering error instead of going permanently black while the HUD keeps running (seen once on Android after a death redeploy) — the error is logged with a stack trace to the system log so a recurrence can be diagnosed

## [21/08/2026]
- Fix: finishing a sector advanced the game by ~120 sectors instead of 1 — level 2 was actually level 121, which made the game unplayable. Sector completion ran on every frame for the two seconds before the shop opened; it now fires once
- Fix: the same loop paid the sector bonus ~120 times over (credits are wildly inflated in existing saves) and restarted the victory fanfare every 70ms, which is what made the audio sound broken
- Fix: music re-sent an unchanged volume to all five soundtrack layers every frame — 300 platform calls a second for the whole run, audible as general audio stutter
- Fix: generator pickups were erased by the next shop purchase, leaving a large power capacity that refilled at the un-upgraded rate — the generator could never keep up. Pickups now upgrade the device itself
- Fix: the generator card in the shop always showed the level-1 output (+4.35/fr) no matter how far it had been upgraded

## [20/08/2026]
- Roguelike run: dying no longer ends the game — the pilot keeps weapons, credits, cumulative score and upgraded stats, and is rewound to Sector 1 through the shop (only hull, shield and position reset)
- Score is now cumulative across lives and permanently unlocks weapon tiers: the unlock level is persisted rather than re-derived from score, so it can never be silently revoked, and pressing PLAY no longer wipes a run that was resumed at startup
- Two Game Center leaderboards — cumulative score and deepest level reached — submitted on death and on every sector completion. Score now posts the actual score; it used to post the spendable credit balance, so buying a weapon moved you *down* the board (new board `kiran_deepest` must be created in App Store Connect)
- ComCenter STATS shows the score and the points remaining to the next weapon tier, which were invisible despite driving both progression and ranking
- App is now named Kirian on iOS, macOS and Android — the device name did not match the store listing
- Skins renamed to original descriptors in-game to match the store entries (e.g. "R-Type (1987)" → "Biomech Cruiser (1987)"); product IDs and asset paths unchanged
- Fix: macOS release builds could join a co-op game but never host one — the sandboxed Release entitlements were missing `com.apple.security.network.server`

## [20/08/2026]
- Enemy deaths now match the weapon that killed them: bubble guns splash water, vulcan cannons shatter the enemy into heavy ice chunks, star guns set it burning with rising flames and embers, lasers discharge flickering lightning arcs, blasters implode into a magenta plasma nova — each with its own light flash; ramming, structures and boss phase transitions keep the generic explosion
- The corpse itself reacts — Voronoi shards carry a per-weapon tint and physics (ice falls heavy without shrinking, fire fragments rise charred)
- Co-op: clients finally see death effects at all — the host emits the explosion event it never sent, weapon family included; also fixes client shards frozen mid-air

## [18/08/2026]
- Fix: no flicker or card drift when switching skins in ComCenter — previews are decoded into their own cache outside Flame's (immune to loadSkin's cache clear, replaces the v2.5.1 drop-and-reload), and the switched card re-anchors into view after the re-themed layout settles
- Fix: skin cards in the ComCenter SKINS section rendered as gray garbage after switching a skin — previews are now dropped and re-loaded across the switch (loadSkin disposes Flame's image cache under them)
- Skin shop embedded in ComCenter: the selector's skin grid (shared `SkinCard` + new `SkinShopSection`) now also sits at the bottom of the shop page — switching or buying a skin re-themes ComCenter and the paused game immediately, return to gameplay stays behind Continue Mission
- IAP product IDs are bundle-prefixed (`com.ol1n.kiran.skin_<id>`) — App Store product IDs live in a single global namespace, bare `skin_*` IDs risk being taken; `SkinStore.storekit` updated to match

## [31/07/2026]
- Per-skin in-app purchases: only Default (Kiran 2026), Galaga and Geometry Wars ship free; the remaining 11 skins are non-consumable IAPs (`com.ol1n.kiran.skin_<id>`) bought directly in the skin selector — locked cards show a lock + localized price, tap/confirm starts the purchase, Restore Purchases button included
- Existing installs are grandfathered (all skins stay unlocked after update); desktop builds keep everything unlocked
- Added `ios/SkinStore.storekit` for local StoreKit testing without App Store Connect

## [01/04/2026]
- Corner statistics overlay on gameplay screen
- Doubled sprite scale to 0.74 to correctly match original VBA proportions
- Gun nozzle Y offset computed from sprite aspect ratio — fixes shot origin on tall-canvas skins (tyrian_dos, gradius_v, blazing_lazers)

## [29/03/2026]
- Fixed vessel animation jitter on blazing_lazers, gradius_v, and tyrian_dos skins
- Sprite scaling aligned to original VBA reference proportions

## [26–27/03/2026]
- Added dissolve and pixel-explosion GLSL fragment shaders
- Voronoi fragmentation — enemies shatter into physics-driven shards on destruction
- Radial shard physics with fade-out
- ComCenter UI fully rewritten to match VBA original; popup dialogs removed

## [25/03/2026]
- Replaced `flame_audio` with `just_audio` for cross-platform `.ogg` support (iOS, Android, macOS, Windows)

## [21/03/2026]
- Desktop landscape mode (camera rotated −90°)
- Gamepad input: PS4 / Xbox analog sticks + buttons, co-op local split support
- Fixed collision boxes sized too large
- Fixed projectile spawn offset in landscape orientation
- Fixed gamepad crash; improved audio resilience

## [19/03/2026]
- Shader configuration document added (13 skins × 4 shader effect presets)

## [16–18/03/2026]
- GPU shader pipeline via Flutter `FragmentProgram`: vignette, 3-pass bloom, CRT scanlines, chromatic aberration
- Fixed viewport scaling and enemy trajectory path oscillation
- Initial shader `.frag` files integrated

## [16/03/2026]
- Full skin system: Go asset pipeline, 12 skins with per-skin sprites, SFX, backgrounds, and shader presets
- In-game skin selector UI
- Skins: Nuclear Throne, Luftrausers, Nex Machina, Tyrian DOS, Gradius V, R-Type, Blazing Lazers, Galaga, Space Invaders, Geometry Wars, Ikaruga, Asteroids

## [04/03/2026]
- Gameplay Phase 4: full VB6 alignment — 19 fixes covering collision damage, explosion visuals, weapon max level, economy (kills → credits proportional to maxHP), random sector generation
- Moved original VBA app into its own folder

## [03/03/2026] — Flutter Port
- Ported TyrianVB to Flutter / Flame for Android and iOS
- Gameplay Phase 1: enemy wave spawning, basic fleet mechanics
- Gameplay Phase 2: enemy weapons, damage scaling, weapon unlock thresholds (400k / 4M / 14M credits)
- Gameplay Phase 3: beam weapon damage fix, float text messages, game-restart state reset
- Weapon, vessel, and score values aligned 1:1 with VB6 source

## [02/03/2026] — VB6 Win32→64-bit
- Converted Win32 API declarations to 64-bit for Office 365 compatibility
- Fixed `GdipLoadImg` type mismatch, `Chr(wParam)` LongPtr conversion, `CreateBlaster` wrong weapon assignment
- Removed `SplitDatabase` form dependency

## [02/03/2026] — Initial Commit
- Original TyrianVB VB6 source files
