# Community posts — Kirian launch

English, ready to paste. Written for the **free** model: the game is free,
the default look plus two skins are unlocked, the other eleven are $0.99 each
(verified in `lib/services/skin_registry.dart` — three entries have no
productId).

## Before you post — three blockers

1. **The App Store still says $0.99.** Verified live via the iTunes lookup
   API. Every post below says "free". Change the price in App Store Connect
   and wait for it to propagate before posting anything, or the first
   commenter calls it a lie.
2. **Decide what to say about the original author** — see the provenance
   section below. The default text credits him without personal detail. Do
   not upgrade to a more revealing variant without asking him about that
   specific disclosure.
3. **Steam differs on purpose.** Steam is planned as a paid title with all
   14 skins included; mobile is free with per-skin purchases. That is a normal
   cross-platform split, but expect someone to ask — the honest answer is
   "no in-app purchases on Steam, you get everything".

## Provenance — the part that needs a real decision

The original VB6 game is a friend's work, written recently, with his
permission and a 50/50 revenue split. He also wrote it while incarcerated,
which is the actual reason the stack is a decade out of date.

That last fact is a strong story hook and it is also **his** private
information. Agreeing to the port is not agreeing to have his incarceration
posted to a permanently-indexed forum where the comments will absolutely ask
which prison and what for. It can follow him into parole hearings, job
applications and everything after.

So: **ask him specifically about this**, separately from the port agreement,
and let him say no without friction. Three levels, pick after that
conversation:

- **A — omit (default, used in the posts below).** "A friend wrote the
  original in VB6." No explanation of the stack. Costs you a good hook,
  costs him nothing.
- **B — vague.** "He wrote it somewhere with no internet and a decade-old
  toolchain, which is why it's VB6." True, gives the stack a reason,
  identifies nothing. Best value if he is uneasy about specifics.
- **C — explicit.** Only with his clear yes. If used, say it once, plainly,
  and do not make it the headline — a title that leads with prison gets the
  game read as a novelty act instead of a game.

Practical, separate from publishing: **check how he can actually receive
money** before revenue starts flowing. Incarceration commonly complicates
bank accounts, and some facilities restrict earning outside income. Sort the
mechanics of the 50/50 split now, in writing, rather than after the first
payout lands.

## Posting order

r/shmups (small, sharp feedback) → r/iosgaming → Show HN (weekday morning US
time) → r/gamedev postmortem a few days later. One community per day; answer
every comment in the first two hours — that window decides whether a post
grows or dies.

## r/iosgaming

**Title:** [DEV] I made a roguelike shmup where enemies die differently depending on which weapon killed them — free, no ads, nothing gated behind a paywall

Kirian is a vertical arcade shooter built on one idea I haven't seen on mobile:
death is not the end. You keep every weapon, every credit, every point — and
drop back to Sector 1 to push deeper. Only your hull resets. Score is
cumulative and permanently unlocks higher weapon tiers.

The thing I'm most proud of: elemental destruction. Enemies die by the weapon
that killed them — bubble guns burst them into water, cannons shatter them
into falling ice chunks, star guns set them burning, lasers discharge as
lightning, blasters implode them into a plasma nova. Each kill reads at a
glance.

Other things that matter here:
- 18 hand-authored ~60s sectors, then endless procedural difficulty
- 14 complete visual skins — each restyles ships, enemies, backgrounds, UI and
  sound (one per era of the genre, from monochrome arcade to neon voxel)
- 2-player co-op over local Wi-Fi — no accounts, no servers
- Controller support, Game Center leaderboards
- Free, no ads, no subscriptions, no energy timers, no consumables. Three
  looks are included; the other eleven skins are $0.99 each, one-time, purely
  cosmetic. Every sector, weapon and mode is in the free game.

App Store: https://apps.apple.com/us/app/kirian/id6774868017

Happy to answer anything about the game or the tech — it's Flutter/Flame with
custom GLSL shaders, which apparently nobody believes until they see it.

## r/shmups

**Title:** Made a vertical shmup with weapon-typed kill effects and a roguelike economy — would love genre-head feedback

Long-time lurker, first game. Kirian is a portrait vertical shooter that
borrows its economy from the classics: credits from kills, a between-sector
shop, front/side weapon slots, upgrade tiers to XXV, and a generator that
limits sustained fire — a heavier gun drains power faster than a weak
generator regenerates it, so loadout is a real decision.

The twist: dying rewinds you to Sector 1 but keeps your loadout, credits and
cumulative score. Runs get deeper because *you* get stronger, not because the
game gets easier.

Kills are weapon-typed — water splash, ice shatter (the corpse itself breaks
into heavy falling chunks), fire with rising embers, lightning arcs, plasma
implosion. Voronoi-fragmented sprite destruction underneath.

18 hand-authored sectors (~60s each, three per level), then procedural
without a ceiling. Bosses every fifth level past that. Local Wi-Fi co-op.
Controller support. 14 full visual themes, one per era of the genre.

iOS now (free, no ads), Android in testing, Steam (Win + Deck) in the works.

App Store: https://apps.apple.com/us/app/kirian/id6774868017

Genuinely want the sharp feedback this sub is known for — especially on
bullet readability and the generator economy.

## Show HN

**Title:** Show HN: I ported a VB6 game to Flutter and generated all 14 art themes with a local Flux pipeline

Kirian is a vertical arcade shooter, now live on the App Store, with Android
and Steam in the pipeline. Two parts of the journey might interest HN:

The port. The original is not mine — a friend wrote a VB6/Win32 shooter, and
we agreed I would port it and split revenue evenly. First step was getting
his original running on 64-bit Office VBA
(LongPtr conversions, GDI+ declarations) just to have a reference
implementation I could observe. Then I ported the logic to Flutter + Flame,
keeping the original combat values — enemy HP, weapon damage, shop prices —
as ground truth, verified by tests. People are skeptical about Flutter for
games; this ships at 60-120 Hz with custom GLSL shaders (bloom, CRT
scanlines, chromatic aberration) through Flutter's FragmentProgram API.

The pipeline. All art — 14 complete visual themes, each restyling ships,
enemies, backgrounds, UI and sound — is generated by a Go pipeline driving a
local ComfyUI/Flux box. ~30 asset specs per theme, 4 candidate variations
each, then background removal, canvas normalization to per-sprite reference
sizes, Voronoi fragmentation for destruction physics, and a texture atlas
packer. The chosen variation per asset is recorded in a committed
selections.json, so any theme rebuilds byte-identically from the record.

Things that went wrong in interesting ways: the enemy-generation prompt asks
for nose-down ships while the renderer rotates everything 180° expecting
nose-up — it only works because the model usually ignores that instruction;
QA for "AI forgot the transparent background" needed a corner-sampling
heuristic because a 95%-opacity test passes solid rocks; and one sprite
shipped that came from no generated variation at all, which is what pushed me
to make the pipeline reproducible.

Free on the App Store (three skins included, the rest optional cosmetics):
https://apps.apple.com/us/app/kirian/id6774868017

Happy to go deep on any of it.

## r/gamedev

**Title:** Postmortem: generating 14 complete visual themes for a shmup with a local Flux/ComfyUI pipeline — what worked and what silently broke

My vertical shmup Kirian shipped with 14 full art themes — ships, 12 enemy
types, bosses, backgrounds, UI, projectiles per theme — all generated on a
local Flux box driven by a Go pipeline. Some lessons that might save you
time:

**Reproducibility is not optional.** We generated 4 variations per asset and
picked one by eye. Which one? Recorded nowhere. Months later an audit found
shipped sprites that didn't match variation 1 (the assumed default) and one
that came from *no* variation at all. Now every pick lands in a committed
selections.json and the whole theme rebuilds byte-identically. Do this from
day one.

**Your QA heuristics will be wrong in specific, instructive ways.** "Is the
background transparent?" sounds trivial. A >=95%-opaque test catches ships
(lots of negative space) but passes solid asteroids with a baked-in backdrop.
Corner sampling fails on sprites with soft feathered edges — you have to
sample slightly inset. Every defect class needed its own detector, and eyes
on a checkerboard backdrop caught things no heuristic did.

**The model ignores your orientation instructions — inconsistently.** Our
prompt asks for nose-down enemies; the renderer rotates 180° expecting
nose-up. It "works" because Flux usually ignores the instruction. When it
doesn't, you get side-view ships scattered randomly across themes. Align your
prompt with your renderer and verify orientation visually, rotated exactly as
the game displays it.

**Structure beats prompting.** Domain-neutral zone descriptions ("the outer
boundary of a huge body" instead of "planet orbit") let one prompt table
serve themes that aren't set in space at all — our river-valley and
wartime-sky themes came out right because the wording never said "space".

Happy to share spec formats, the bg-removal approach (flood-fill from
borders + soft edge margin), or the atlas/Voronoi tooling. Game context:
roguelike vertical shmup, Flutter/Flame, free on iOS, Steam in progress.
