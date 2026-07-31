# Game Center Achievements — checklist pro App Store Connect

Obrázky: `marketing/achievements_ai/kiran_ach_*.png` (1024×1024, název souboru = Achievement ID).
Kód: `lib/services/achievement_service.dart` (`_defs`) — ID musí sedět přesně.

## Kde

**App Store Connect → Moje aplikace → Kiran → Services → Game Center → Achievements → „+"**

## Postup pro každý achievement (pořadí polí v ASC)

1. **Reference Name** — zkopíruj *Title* z tabulky (interní název, hráč nevidí).
2. **Achievement ID** — zkopíruj *ID* z tabulky. ⚠️ Jediné místo, kde překlep = achievement se nikdy neodešle.
3. **Points** — z tabulky (součet sady je 920 z max 1 000).
4. **Hidden** — `Yes` jen kde je uvedeno, jinak `No`.
5. **Achievable More Than Once** — vždy `No`.
6. **Localization → English (U.S.)**:
   - **Title** — z tabulky
   - **Pre-earned Description** — z tabulky (před získáním)
   - **Earned Description** — z tabulky (po získání)
   - **Image** — nahraj `kiran_ach_<ID>.png` (soubor se jmenuje přesně podle ID)

Pozn.: žádné nastavení „incremental" v ASC neexistuje — progres reportuje appka přes
`percentComplete` a Game Center sám kreslí progress bar.

---

## Progrese sektorů

| | |
|---|---|
| ID | `kiran_ach_sector_5` — obrázek `kiran_ach_sector_5.png` |
| Title | Deep Space |
| Points | 10 |
| Pre-earned | Reach sector 5 |
| Earned | You reached sector 5. |

| | |
|---|---|
| ID | `kiran_ach_sector_10` — obrázek `kiran_ach_sector_10.png` |
| Title | Into the Fire |
| Points | 25 |
| Pre-earned | Reach sector 10 |
| Earned | You reached sector 10. |

| | |
|---|---|
| ID | `kiran_ach_sector_20` — obrázek `kiran_ach_sector_20.png` |
| Title | Veteran |
| Points | 50 |
| Pre-earned | Reach sector 20 |
| Earned | You reached sector 20. |

| | |
|---|---|
| ID | `kiran_ach_sector_40` — obrázek `kiran_ach_sector_40.png` |
| Title | Legend of Kiran |
| Points | 100 |
| Pre-earned | Reach sector 40 |
| Earned | You reached sector 40. |

## Zabití

| | |
|---|---|
| ID | `kiran_ach_first_kill` — obrázek `kiran_ach_first_kill.png` |
| Title | First Blood |
| Points | 5 |
| Pre-earned | Destroy your first enemy |
| Earned | You destroyed your first enemy. |

| | |
|---|---|
| ID | `kiran_ach_kills_1000` — obrázek `kiran_ach_kills_1000.png` |
| Title | Exterminator |
| Points | 25 |
| Pre-earned | Destroy 1,000 enemies |
| Earned | You destroyed 1,000 enemies. |

| | |
|---|---|
| ID | `kiran_ach_kills_10000` — obrázek `kiran_ach_kills_10000.png` |
| Title | Armada Slayer |
| Points | 100 |
| Pre-earned | Destroy 10,000 enemies |
| Earned | You destroyed 10,000 enemies. |

## Falcon hunteři (100 killů daného typu, po 10 bodech)

| ID | Title | Pre-earned | Earned |
|---|---|---|---|
| `kiran_ach_falcon1_100` | Falcon I Hunter | Destroy 100 Falcon I fighters | You destroyed 100 Falcon I fighters. |
| `kiran_ach_falcon2_100` | Falcon II Hunter | Destroy 100 Falcon II fighters | You destroyed 100 Falcon II fighters. |
| `kiran_ach_falcon3_100` | Falcon III Hunter | Destroy 100 Falcon III fighters | You destroyed 100 Falcon III fighters. |
| `kiran_ach_falcon4_100` | Falcon IV Hunter | Destroy 100 Falcon IV fighters | You destroyed 100 Falcon IV fighters. |
| `kiran_ach_falcon5_100` | Falcon V Hunter | Destroy 100 Falcon V fighters | You destroyed 100 Falcon V fighters. |
| `kiran_ach_falcon6_100` | Falcon VI Hunter | Destroy 100 Falcon VI fighters | You destroyed 100 Falcon VI fighters. |

Obrázek vždy `<ID>.png`, Points 10, Hidden No.

## Elita a bossové

| | |
|---|---|
| ID | `kiran_ach_elite_100` — obrázek `kiran_ach_elite_100.png` |
| Title | Elite Hunter |
| Points | 25 |
| Pre-earned | Destroy 100 elite Falcons |
| Earned | You destroyed 100 elite Falcons. |

| | |
|---|---|
| ID | `kiran_ach_boss_1` — obrázek `kiran_ach_boss_1.png` |
| Title | Boss Down |
| Points | 25 |
| Pre-earned | Defeat your first boss |
| Earned | You defeated your first boss. |

| | |
|---|---|
| ID | `kiran_ach_boss_10` — obrázek `kiran_ach_boss_10.png` |
| Title | Serial Boss Killer |
| Points | 50 |
| Pre-earned | Defeat 10 bosses |
| Earned | You defeated 10 bosses. |

## Asteroidy

| | |
|---|---|
| ID | `kiran_ach_asteroid_1` — obrázek `kiran_ach_asteroid_1.png` |
| Title | Rock Meets Hull |
| Points | 5 — **Hidden: Yes** |
| Pre-earned | Ram your first asteroid |
| Earned | You rammed your first asteroid. |

| | |
|---|---|
| ID | `kiran_ach_asteroid_50` — obrázek `kiran_ach_asteroid_50.png` |
| Title | Asteroid Magnet |
| Points | 25 |
| Pre-earned | Ram 50 asteroids |
| Earned | You rammed 50 asteroids. |

## Zbraně na level XXV (po 25 bodech)

| ID | Title | Pre-earned | Earned |
|---|---|---|---|
| `kiran_ach_max_bubble_gun` | Bubble Gun Master | Upgrade the Bubble Gun to level XXV | You upgraded the Bubble Gun to level XXV. |
| `kiran_ach_max_vulcan_cannon` | Vulcan Cannon Master | Upgrade the Vulcan Cannon to level XXV | You upgraded the Vulcan Cannon to level XXV. |
| `kiran_ach_max_blaster` | Blaster Master | Upgrade the Blaster to level XXV | You upgraded the Blaster to level XXV. |
| `kiran_ach_max_laser` | Laser Master | Upgrade the Laser to level XXV | You upgraded the Laser to level XXV. |
| `kiran_ach_max_small_bubble` | Small Bubble Master | Upgrade the Small Bubble to level XXV | You upgraded the Small Bubble to level XXV. |
| `kiran_ach_max_small_vulcan` | Small Vulcan Master | Upgrade the Small Vulcan to level XXV | You upgraded the Small Vulcan to level XXV. |
| `kiran_ach_max_star_gun` | Star Gun Master | Upgrade the Star Gun to level XXV | You upgraded the Star Gun to level XXV. |
| `kiran_ach_max_small_laser` | Small Laser Master | Upgrade the Small Laser to level XXV | You upgraded the Small Laser to level XXV. |

Obrázek vždy `<ID>.png`, Points 25, Hidden No.

## Vytrvalost

| | |
|---|---|
| ID | `kiran_ach_starts_10` — obrázek `kiran_ach_starts_10.png` |
| Title | Regular |
| Points | 10 |
| Pre-earned | Start 10 runs |
| Earned | You started 10 runs. |

| | |
|---|---|
| ID | `kiran_ach_starts_100` — obrázek `kiran_ach_starts_100.png` |
| Title | Addicted |
| Points | 50 |
| Pre-earned | Start 100 runs |
| Earned | You started 100 runs. |

| | |
|---|---|
| ID | `kiran_ach_time_1h` — obrázek `kiran_ach_time_1h.png` |
| Title | Warming Up |
| Points | 10 |
| Pre-earned | Play for 1 hour |
| Earned | You played for 1 hour. |

| | |
|---|---|
| ID | `kiran_ach_time_10h` — obrázek `kiran_ach_time_10h.png` |
| Title | No Sleep |
| Points | 50 |
| Pre-earned | Play for 10 hours |
| Earned | You played for 10 hours. |

| | |
|---|---|
| ID | `kiran_ach_deaths_25` — obrázek `kiran_ach_deaths_25.png` |
| Title | Never Give Up |
| Points | 10 — **Hidden: Yes** |
| Pre-earned | Get destroyed 25 times |
| Earned | You got destroyed 25 times. Never give up! |

## Bonusy

| | |
|---|---|
| ID | `kiran_ach_coop` — obrázek `kiran_ach_coop.png` |
| Title | Better Together |
| Points | 25 |
| Pre-earned | Play a co-op game |
| Earned | You played a co-op game. |

| | |
|---|---|
| ID | `kiran_ach_skins_5` — obrázek `kiran_ach_skins_5.png` |
| Title | Fashion Victim |
| Points | 10 |
| Pre-earned | Play with 5 different skins |
| Earned | You played with 5 different skins. |

| | |
|---|---|
| ID | `kiran_ach_untouchable` — obrázek `kiran_ach_untouchable.png` |
| Title | Untouchable |
| Points | 50 |
| Pre-earned | Complete a sector without hull damage |
| Earned | You completed a sector without hull damage. |

---

## Po vytvoření

1. **Sandbox test hned**: development/TestFlight build + přihlášený účet → tlačítko
   ACHIEVEMENTS na game-over obrazovce otevře nativní overlay.
2. **Produkce**: achievementy jdou live s příštím odesláním verze appky — na stránce
   verze zkontroluj sekci Game Center, že jsou přiřazené.
3. **Opakované testování**: appka si lokálně pamatuje odeslaný progres
   (`shared_preferences`). Po resetu achievementů v GC nebo změně účtu smaž appku,
   jinak už odeslaný progres znovu nepošle.
4. **Android později**: v Play Console založit tytéž achievementy (řádky
   s počítadly jako *incremental* s cílovým počtem kroků) a vygenerovaná „CgkI…" ID
   doplnit do `achievement_service.dart` místo `REPLACE_WITH_PLAY_ACHIEVEMENT_ID`.
