# Trailer — Kirian (5258090)

Target: **75 seconds**, 1920×1080, 60 fps, H.264.

Steam autoplays the trailer muted on the store page, so it has to read with the
sound off and it has to hook before anyone decides to scroll. That rules out the
thing most indie trailers open with — a logo on black. The logo goes at the end,
where it lands on someone who has already decided they like this.

## What is capture and what is not

Valve expects a trailer to represent the product, and players are fast at
spotting footage that is not the game. So:

- **Everything from 0:00 to 1:06 is real capture.** No exceptions.
- **Generated footage appears only in the closing sting (1:06–1:15)**, behind
  the logo, as the same refinery-and-fire look the capsules already use. It is
  set dressing around a title card, not a claim about gameplay.

If the generated sting ends up looking like gameplay, it is wrong and should be
cut back to a still of the capsule art.

## Shot list

Timecodes are targets, not law — cut to the music.

| # | Time | Shot | Notes |
|---|---|---|---|
| 1 | 0:00–0:04 | **Cold open.** Mid-fight, dense wave, player weaving. End on a cannon kill: enemy shatters into ice. | No logo, no fade-in. First frame is already the game. |
| 2 | 0:04–0:12 | Three fast cuts of escalating combat, different zones. | Card: `DIE. KEEP EVERYTHING.` |
| 3 | 0:12–0:22 | The hook, shown not told: hull explodes → Sector 1 → pan across the *same* loadout, guns still upgraded. | Card: `PROGRESS IS PERMANENT — ONLY YOUR HULL RESETS.` This is the single most important beat. |
| 4 | 0:22–0:34 | **Elemental montage.** Five kills, one per weapon: water burst, ice shatter, rising flame, lightning flicker, magenta plasma nova. ~2.5 s each, hard cuts. | The most visually distinctive thing the game does. Frame each kill centre-screen. |
| 5 | 0:34–0:44 | Com Center: cursor moves along the upgrade track, a gun goes up a tier, the generator bar drops. | Card: `POWER IS FINITE. EVERY LOADOUT IS A TRADE.` |
| 6 | 0:44–0:56 | Campaign: route map with nodes lighting up → a node objective card → a composite boss, cutting between the first boss and the fourth so the added parts read. | Card: `20 NODES. 4 BOSSES, EACH BUILT ON THE LAST.` |
| 7 | 0:56–1:06 | **The skin riff.** Hold one gameplay moment and cut the art style under it every 6–8 frames, through as many of the 24 skins as fit. Same ship position, same wave. | Card: `24 GAMES IN ONE — ALL INCLUDED.` The showstopper; do not rush it. |
| 8 | 1:06–1:10 | Co-op: two ships, one screen. | Card: `LOCAL TWO-PLAYER CO-OP.` |
| 9 | 1:10–1:15 | **Sting.** Generated refinery-and-fire plate, ship rising through smoke, logo resolves. Platform row, then `COMING SOON`. | The only generated footage in the film. |

## How to capture

The clips have to come from a real run; nothing here can be reconstructed.

- **Resolution 1920×1080, 60 fps.** Desktop build, landscape, fullscreen (F11).
  A phone capture is portrait and unusable.
- **Record long, cut later.** For every shot above, record 20–30 s and hand over
  the whole thing — a 4-second beat cut from a 5-second clip always looks tight
  and slightly wrong.
- **Shot 7 needs discipline:** record the *same* sector opening once per skin,
  from the same start, so the cuts land on matching frames. If the waves drift,
  the riff reads as noise instead of as one moment restyled.
- **Shot 3 needs a real death**, not a restart — the point is that the loadout
  survived it.
- Capture with the HUD on. It is part of what the game looks like.
- macOS/Windows: any screen recorder at 60 fps. Linux: `obs` or
  `ffmpeg -f x11grab`.

Drop the files anywhere and tell me the path; I will cut, grade, add the cards
and master it.

## Music

Use the game's own music — one of the skin themes, in the repo. It is honest,
it costs nothing, and it is already the sound the player will hear. Suggest the
`default` skin's `theme_3` or `theme_5` for pace; I will pick against the cut
once the footage exists.

Do **not** use a licensed track. Steam trailers get claimed and muted.

## Cards

White Helvetica Neue Condensed Black on a 60 % black scrim, cyan subtitle where
a second line is needed — the same type treatment as the capsules, so the
trailer and the store page read as one thing. All cards hold 1.5–2 s: long
enough to read muted, short enough not to stall.

## What blocks this

Everything except the sting. I cannot capture gameplay — the game does not run
here (`flutter run -d macos` fails at signing, no dev certificate on this
machine), so shots 1–8 are yours. Once the clips exist the assembly is a
short job.
