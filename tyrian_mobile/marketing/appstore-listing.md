# App Store listing — Kirian

Copy-paste source for App Store Connect. Every field is within Apple's limit
(counts noted). Nothing here names a third-party game or franchise — that is
deliberate: the skins were renamed away from trademarked titles to keep the
listing clear of Guideline 5.2.1.

---

## App Name  (limit 30)

```
Kirian: Space Shooter
```

**21 chars.** The device shows `Kirian`, so the leading token matches — this is
the standard brand-plus-descriptor pattern and stays inside 2.3.8, which asks
for names that are *similar*, not identical. It matters because "Kirian" is an
invented word that nobody types into search; the name field carries the most
ASO weight of any field, so it has to hold at least one real search term.

If you would rather take zero risk after a 2.3.8 rejection, use plain `Kirian`
and accept that discovery rests entirely on the subtitle and keywords.

## Subtitle  (limit 30)

```
Roguelike arcade shmup
```

**22 chars.** Indexed for search like the name, so it carries terms the name
does not repeat.

## Keywords  (limit 100)

```
shmup,bullet hell,roguelite,retro,arcade,spaceship,coop,vertical,scrolling,shoot em up,pixel
```

**92 chars.** No spaces after commas — a space costs a character and buys
nothing. Deliberately excludes words already in the name and subtitle
("shooter", "space", "roguelike", "arcade" appears once as a plural-free stem),
because Apple indexes those fields together and repeating a term wastes the
budget. Singular forms only; Apple matches plurals automatically.

## Promotional Text  (limit 170)

```
Death is not the end. Keep every weapon, credit and point you earned, drop back to Sector 1 and push deeper. Two-player co-op over local Wi-Fi. New: elemental kills.
```

**164 chars.** This field updates without a review, so use it for whatever is
newest.

## Description  (limit 4000)

```
Fly a lone gunship through an endless corridor of hostiles, one sixty-second sector at a time.

Kirian is a vertical arcade shooter built on a roguelike loop. Losing your vessel does not end the run — you keep every weapon, every credit, every point you have earned, and drop back to Sector 1 to push deeper than last time. Progress is permanent. Only your hull resets.

ELEMENTAL DESTRUCTION
Enemies die by the weapon that killed them. Bubble guns burst them into water. Cannons shatter them into ice that falls heavy and cold. Star guns leave them burning with rising flame and drifting embers. Lasers discharge in a flicker of lightning. Blasters implode them into a magenta plasma nova. Each kill reads at a glance.

BUILD YOUR GUNSHIP
Between sectors, the Com Center is yours: front guns, side guns, generators, hull and shields, all upgradable across twenty-five levels. Power is finite — a heavier gun drains a generator that cannot keep up, so every loadout is a trade. Score never resets, and crossing its thresholds permanently unlocks the higher weapon tiers.

HAND-BUILT WAVES, THEN FOREVER
Eighteen hand-authored sectors span six zones, each a tight sixty-second script with its own formations and rhythm. Past them the generator takes over and never stops, difficulty climbing without a ceiling, bosses waiting at every fifth level.

TWO PLAYERS, ONE ROOM
Co-op runs over local Wi-Fi with automatic discovery — no accounts, no servers, no internet. One device hosts, the other joins, and you fly the same sector together.

FOURTEEN LOOKS
Every skin restyles the whole game: ships, enemies, backgrounds, interface, sound. Three ship free with the app. The other eleven are one-time purchases, each permanent, with no ads, no subscriptions and no consumables anywhere in the game.

BUILT TO FEEL RIGHT
GPU shaders drive bloom, scanlines, vignette and chromatic aberration. Enemies shatter into physics-driven fragments cut from their own sprites. Play by touch, keyboard, or a connected controller.

Two Game Center leaderboards rank you by total score and by the deepest level you have ever reached, alongside achievements for kills, sectors and untouched runs.
```

**~2 050 chars.** Front-loads the roguelike hook, because the App Store cuts
the description off after roughly three lines on the product page and most
readers never tap "more". Explicitly says one-time purchase, no ads, no
subscription — that answers the objection that stops installs on a paid-skin
model, and it is also what a reviewer wants to see stated plainly.

## What's New  (version 2.7.0)

```
ROGUELIKE RUN
Losing your vessel no longer ends the game. Weapons, credits, upgrades and score all carry over — you rewind to Sector 1 and push again. Score is now cumulative and permanently unlocks the higher weapon tiers.

LEADERBOARDS
Two Game Center boards: total score and deepest level reached. Score now ranks your actual score rather than your unspent credits, so buying a weapon no longer costs you rank.

ALSO
The Com Center shows your score and the points left to your next weapon tier. Skins carry new names. Fixes hosting a co-op game from a macOS release build.
```

---

## Fields that are not free text

| Field | Value |
|---|---|
| Primary category | Games → Action |
| Secondary category | Games → Arcade |
| Age rating | 9+ (infrequent/mild cartoon or fantasy violence) |
| Price | Free |
| In-app purchases | 11 non-consumable skins |
| Game Center | Enabled — 2 leaderboards, achievements |

## Still to do in App Store Connect

1. **App Review screenshot on each of the 11 in-app purchases.** Without it they
   cannot be submitted, which is exactly the Guideline 2.1(b) rejection. A plain
   capture of the skin selector with the card visible is enough.
2. **Submit the in-app purchases together with the build**, not separately.
3. **Create the `kiran_deepest` leaderboard** — Classic, Integer, High to Low,
   Best Score. Until it exists the depth submissions fail silently.
4. **Screenshots.** Lead with gameplay mid-fight showing an elemental kill, then
   the Com Center loadout, then the skin grid, then co-op. The first two are the
   only ones most people see.
