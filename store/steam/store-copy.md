# Steam store copy — Kirian (5258090)

Paste source for the Steamworks store page. Adapted from
`tyrian_mobile/marketing/appstore-listing.md`, but not a copy of it: the mobile
listing sells a free game with 21 paid skins, and Steam sells the opposite —
one price, everything in it. It also predates Campaign Mode.

As on the App Store, no field here names a real game or franchise. The skins
were renamed away from trademarked titles deliberately; that decision holds on
Steam for the same reason it held on the App Store.

**Counts verified against `lib/services/skin_registry.dart` on 2026-09-26:**
24 skins total, 21 of them paid on mobile, all 24 included here.

---

## ⚠ Before pasting — three things need your decision

1. **The original author's credit is a placeholder.** `[AUTHOR NAME]` appears in
   the Description and in *Developers*. Kirian is a port of your friend's VB6
   game and that credit has to be right and has to be his call — tell me the
   name and wording he wants and I will set it everywhere. Do not publish with
   the placeholder still in.

2. **Co-op is claimed but unverified on Windows and Linux.** Local co-op is
   tested between iPhone, iPad and Mac. Nobody has run it PC-to-PC. If it does
   not work there, cut the `LOCAL CO-OP` block and the `Remote Play` /
   multiplayer tags — a headline feature that fails is a refund and a bad
   review, not a small inaccuracy.

3. **No leaderboards or achievements are claimed.** The mobile listing sells
   Game Center boards; the Steam equivalents are not implemented (they sit
   unchecked under *Doporučené položky*). Nothing below promises them.

---

## Short description (limit 300)

```
A vertical arcade shooter with a roguelike spine. Dying costs you the hull, never the progress: keep every weapon, credit and point, drop back to Sector 1 and push deeper. Twenty-four skins restyle the entire game — ships, enemies, backgrounds, interface, sound. All of them included.
```

**281 chars.** This is the text under the capsule in search and on the page
header, so it front-loads the hook and closes on the thing that separates this
release from the mobile one — everything is in the price.

## About This Game (BBCode)

```
[h2]Death is a setback, not an ending[/h2]
Fly a lone gunship up an endless corridor of hostiles, one sixty-second sector at a time. Losing your vessel does not end the run. You keep every weapon, every credit, every point you earned, and drop back to Sector 1 to push deeper than last time. Progress is permanent. Only your hull resets.

[h2]Two ways to fly[/h2]
[b]Endless run.[/b] Eighteen hand-authored sectors across six zones, each a tight sixty-second script with its own formations and rhythm. Past them a generator takes over and never stops, difficulty climbing without a ceiling, a boss waiting at every fifth level.

[b]Campaign.[/b] Twenty nodes, four bosses, its own progression from zero and its own save. Each node sets a task you have to clear and optional ones you do not — fly it clean, hold a loadout, finish under time. The bosses are built rather than picked: each one grows another part onto the same core, so the last is the first four times over.

[h2]Elemental destruction[/h2]
Enemies die by the weapon that killed them. Bubble guns burst them into water. Cannons shatter them into ice that falls heavy and cold. Star guns leave them burning with rising flame and drifting embers. Lasers discharge in a flicker of lightning. Blasters implode them into a magenta plasma nova. Every kill reads at a glance.

[h2]Build your gunship[/h2]
Between sectors the Com Center is yours: front guns, side guns, generators, hull and shields, all upgradable across twenty-five levels. Power is finite — a heavier gun drains a generator that cannot keep up, so every loadout is a trade, not a shopping list.

[h2]Twenty-four games in one[/h2]
Every skin restyles the whole thing: ships, enemies, backgrounds, interface, sound and music. Monochrome invaders, vector wireframe, neon grid, chrome fleet, sepia dogfight, wasteland pixel. On mobile most of these are paid extras. Here they are all in the box — one price, no in-app purchases, no ads, no subscriptions, nothing to unlock with money.

[h2]Local co-op[/h2]
Two players over the local network with automatic discovery. No accounts, no servers, no internet. One machine hosts, the other joins, and you fly the same sector together.

[h2]Built to feel right[/h2]
GPU shaders drive bloom, scanlines, vignette and chromatic aberration. Enemies shatter into physics-driven fragments cut from their own sprites. Play with a controller or the keyboard, windowed or fullscreen, on Windows, Linux or Steam Deck.

[hr][/hr]
Kirian is a remake of a game written by [AUTHOR NAME], rebuilt from the original source with his blessing.
```

## Tags (Popisné značky v obchodě)

Steam takes up to 20 but weights the first ones hardest, so this is ordered,
not alphabetical. Everything here is a thing the game demonstrably is — tags
that oversell get reported by players and hurt the store algorithm more than
the extra reach helps.

```
Shoot 'Em Up
Bullet Hell
Roguelite
Arcade
Action
Top-Down Shooter
Space
2D
Pixel Graphics
Score Attack
Replay Value
Difficult
Retro
Singleplayer
Local Co-Op
Colorful
Atmospheric
Controller
Stylized
Indie
```

Drop `Local Co-Op` if point 2 above goes unverified.

## Controller support (Popis podpory ovladačů)

```
Full controller support. Menus, the Com Center and the campaign map are all navigable with a gamepad, and the game can be played start to finish without touching a keyboard. Keyboard and mouse work throughout as well.
```

**Check before pasting:** the pause → skins grid is reached through the pause
menu rather than the Com Center grid, because pad focus in that grid was
deferred. If a pad genuinely cannot reach something, soften this to "Partial".

## Support info (Informace o podpoře)

| Field | Value |
|---|---|
| Support URL | https://lioilsources.github.io/Kiran/support.html |
| Support e-mail | (your public address — not the one on the CI account) |
| Privacy policy URL | https://lioilsources.github.io/Kiran/privacy.html |

Both pages already exist in `docs/`. Confirm the GitHub Pages URLs resolve
before pasting — Steam checks that the privacy policy loads.

## Fields that are not free text

| Field | Value |
|---|---|
| Type | Game |
| Genres | Action, Indie |
| Developers | lioilsources / [AUTHOR NAME] — see point 1 |
| Publisher | lioilsources |
| Supported OS | Windows, Linux / SteamOS |
| Price | one-time, not set yet — blocks two build checklist items |
| Release date | not set yet |

## What is still missing from the checklist after this file

Everything below needs something I cannot produce:

- **5+ screenshots, 1920×1080** — captures from the running game
- **Trailer** — the longest lead time of anything left
- **Content questionnaire** — legal declarations about the content
- **Price**, and its approval
- **Release date**

Graphics are done and sit in `store/steam/out/`: main, header, small, vertical
and library capsules, the library hero, and the transparent library logo.
Icons are in `store/steam/icons/`.
