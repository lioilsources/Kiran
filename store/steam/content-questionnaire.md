# Content questionnaire — Kirian (5258090)

Prepared answers for Steamworks → *Dotazník ohledně obsahu*. Field labels are
from Valve's standard survey; if the live form words something differently,
the substance below still applies — nothing here is a judgement call except
where marked.

This is a declaration to Valve about what is in the game. Answers that do not
match the product are grounds for taking the page down, so everything below is
checked against the repo rather than assumed.

---

## AI-generated content — **disclose (user's decision, 2026-09-29)**

Steam splits this in two. Kirian is **Pre-Generated only**:

| Category | Answer | Why |
|---|---|---|
| **Pre-Generated** (made with AI during development, shipped in the game) | **Yes** | Art and audio come from the project's own generation pipeline. |
| **Live-Generated** (AI produces content while the player plays) | **No** | Nothing calls a model at runtime. The game ships fixed assets and plays offline. |

### Disclosure text for the store page

This is shown to players in its own section, so it is written for them, not for
a compliance form:

```
The art and audio in Kirian were produced with generative AI tools as part of the development pipeline, then hand-selected, post-processed and assembled by the developer. This covers the ship, enemy and environment sprites, the background layers, the interface elements, the 24 visual skins, and the music and sound effects.

The game itself runs entirely offline and contains no AI at runtime — nothing is generated while you play, and no data is sent anywhere.

Gameplay, level design, balance and code are the developer's own work, ported from the original game by Tomáš Burian.
```

**Why say it this plainly:** the pipeline is most of `pipeline/` and it produced
essentially all visual and audio assets across 24 skins and 384 audio files.
A vaguer answer would be the kind of mismatch Valve pulls pages for, and the
detail actually helps — it draws the line at where the human work is, which a
one-word "yes" does not.

---

## Violence and gore

| Question | Answer |
|---|---|
| Violence | **Yes — cartoon / fantasy only** |
| Realistic violence | No |
| Blood or gore | No |
| Dismemberment | No |

Enemies are spacecraft and abstract shapes. They explode into sprite fragments
and elemental effects — ice, flame, plasma. No human or animal figures are
harmed anywhere in the game; there are no human characters at all.

## Sexual content and nudity

All **No**. There is no sexual content, no nudity, no suggestive imagery.

## Substances

All **No**. No drugs, alcohol or tobacco appear or are referenced.

## Gambling

**No**. No gambling, no loot boxes, no randomised paid rewards. Skins on Steam
are all included in the purchase price, so there is nothing to buy in-game at
all — worth stating, because "shmup with cosmetics" invites the question.

## Profanity / mature language

**No**. Interface and objective text is plain; nothing in the game swears.

## Adults-only content

**No**.

## User-generated content

**No**. Players cannot create, upload or share content. No Workshop, no level
editor, no custom assets.

## Online interaction

| Question | Answer |
|---|---|
| Players interact with each other online | **No** |
| In-game chat / voice | **No** |
| Matchmaking with strangers | **No** |

Co-op is **local network only** — automatic discovery on the LAN, one machine
hosts and another joins. There are no accounts, no servers and no route to a
stranger. Answering this honestly is worth doing carefully: a wrong "yes" adds
Valve's standard "includes online interaction, not rated by rating boards"
notice to the store page for a feature the game does not have.

---

## Age rating expectation

Mobile ratings already landed at **9+ (App Store)** for infrequent mild cartoon
violence. Steam does not assign a rating itself outside specific regions, but
the answers above are consistent with that.

## Still needs you

The questionnaire itself is a declaration made by the developer, so the final
submit is yours — I can fill the fields, you confirm and send. Two things I
cannot decide:

1. Whether the disclosure wording above says what you want it to say. It is
   public and permanent-ish; read it as a player would.
2. Anything in the live form that asks about business terms rather than
   content — price, regional restrictions, release timing.
