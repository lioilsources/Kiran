# Plan: Mody (common / rare / mythic), trupy a vizuální hangár

**Jen linie 3.x (`main`).** Linie 2.9.x nic z tohoto nedostane — nemá kampaň,
nemá composite boss a je na App Store/Play jako „hotová" hra.

Cíl jednou větou: hráč si za výkon v kampani (plné hvězdy, boss v časovém
okně) odnáší **mody** tří rarit, které v ComCenter nasazuje na zbraně, na
celou přední/boční baterii, na generátor a na trup. Mody se skládají, takže
loď nakonec střílí 3×3 vějíře přes celou obrazovku. ComCenter zároveň dostane
**velkou loď uprostřed**, na které je vidět trup (jeden z pěti na skin),
nasazené zbraně (pody) a mody. Hra není simulátor — je to sandbox, který má
právo být absurdní; brzdou je jen výkon telefonu a čitelnost obrazovky.

Dokument je psaný pro implementační session (Opus). Části §1–§6 jsou
závazné (datový model a herní mechanika), §7–§9 (grafika, prompty) jsou
návrh pro pipeline, §11 jsou otevřené otázky pro uživatele — **nerozhodovat
za něj, zeptat se před začátkem**.

---

## 0. Fakta z kódu, na kterých plán stojí (ověřeno 2026-11-05 na `main`, 3.8.7)

| Věc | Kde | Důsledek pro plán |
|---|---|---|
| Zbraň = `Device` v `Vessel.devices`, jedna na slot; `WeaponSlot {frontGun, generator, leftGun, notAvailable, rightGun, satellite, shieldCapacitor}` | `lib/systems/dev_type.dart`, `lib/entities/vessel.dart:46` | `satellite` a `shieldCapacitor` jsou v enumu z VB6 a **nikdo je nepoužívá** — mythic mody je mohou oživit |
| Výstřel: `Device.fire()` spočítá `px,py`, `xShift`, `scale`, vezme `Projectile` z poolu, `world.add` | `lib/systems/device.dart:140-210` | Jediné místo, kde vzniká střela hráče → sem patří „ShotPlan" (§3) |
| `Projectile` má `speed` (svisle), `vx` (vodorovně; dnes jen boss), `damage`, `projScale`, `drawScale` (render-only, front ×2 / side ×1.5) | `lib/entities/projectile.dart` | Vějíř = nenulové `vx`; **už to umí**, jen to hráč nikdy nedostal |
| Zásah: `Vessel._checkProjectileCollisions` → `h.takeDamage(d.damage, …)`, `return true` = střela spotřebovaná | `lib/entities/vessel.dart:~460` | Pierce, crit, chain, split = hooky přesně tady |
| Beam (laser): `beamActive = seqs`, kolize v `_processBeamCollision` | `device.dart`, `vessel.dart:388` | Laser má jiný pipeline — vějíř pro laser = víc paprsků, ne víc střel |
| Energie: `pwrNeed` se odečítá z `genValue`, dobíjí `genPower` za frame; zbraň s `pwrNeed > genMax` **vůbec nestřílí** (ComCenter ukazuje OFF) | `device.dart:150`, `vessel.dart:351` | Mody se **platí energií**, ne kredity — to je balanc, který už existuje |
| Upgrade: dmg ×1.1, pwrNeed ×1.2, cooldown ÷1.02, max 25 | `game_config.dart:104-109` | Mody nesmí sahat na tyhle konstanty (VB6 parita) |
| `fireRateMult` (0–1) z analogové spouště padu dělí cooldown | `vessel.dart:35`, `tyrian_game.dart:1150` | RATE mod jde stejnou cestou (`cooldown / mult`), ale musí fungovat i bez padu |
| Hangár: `Vessel.hangar` (koupené nevybavené zbraně), `fitWeapon`, `sellFitted`, save klíč `hangar` | `vessel.dart:52,639`, Prompts/26 | Racky modů jsou **další** seznam vedle hangáru; stejný vzor serializace |
| Save endless: `game_state` (saveVersion 2, **nezvyšovat** — loader by hnal v2 savy migrací); kampaň: `campaign_state` (campaignSaveVersion 1) s `vessel` mapou | `lib/services/save_service.dart` | Nové klíče jsou volitelné; account-level věci (vault, trupy) dostanou **vlastní klíč** `mods_state` |
| Kampaň: 20 nodů, `ObjectiveSpec` (required/star), `CampaignTracker.evaluate` → `NodeResult.starsEarned`, boss nody mají `strip`, `untouched`; `under(seconds)` měří **celý node** od startu | `lib/systems/campaign.dart`, `campaign_tracker.dart` | „Boss v časovém okně" je **nový** `ObjectiveKind.bossUnderTime` (od spawnu bosse do smrti jádra) |
| Výsledek nodu: `_onSectorComplete` → `lastNodeResult`, `lastNodeUnlock` (String — odemčený tier zbraní) → `CampaignResultCard(unlocked:)` | `tyrian_game.dart:686`, `lib/ui/campaign_result.dart` | Drop modu se ukáže na stejné kartě, pod „unlocked" |
| Boss: `Boss extends Hostile`, `BossPart` ×4 druhů, `Sector.addBossWave(ttk:, dps: Campaign.poweredDps(vessel))` — **TTK bosse se škáluje podle DPS lodi** | `lib/entities/boss.dart`, `sector.dart:245`, `campaign.dart:~430` | Mody zvednou DPS → boss dostane víc HP → časové okno zůstane férové. Dobrá vlastnost, zachovat |
| Challenge: 4 násobiče (hp, damage, cadence, score), `normal` = 1.0 = parita, testy stavějí na normal | `lib/game/challenge.dart` | Stejný princip pro mody: **prázdné racky = parita**, parity testy se nemění |
| Loď: `vessel_0..5` snímky z atlasu (glow ping-pong), `AssetLibrary.vesselFrames`, referenční velikost `vessel {114, 84}` ×4 supersample | `asset_library.dart:168`, `pipeline/.../reference_sizes.go:26` | Trupy = `vessel_<hull>_<i>`; fallback na `vessel_<i>` když skin trup nemá |
| Pohyb: drag 1:1 (`onDragUpdate` delta / zoom), pad/klávesnice `_kbSpeed` v `_processDesktopInput → _applyMovement`; `vesselDefaultSpeed` se nikde nečte | `tyrian_game.dart:1017`, `_processDesktopInput`, `game_config.dart:102` | „Rychlost" trupu na dotyku nic neznamená → stat **agility** = násobek rychlosti pro pad/klávesy + **velikost hitboxu** (platí všude) |
| ComCenter: `_buildShipPreview` kreslí první snímek do boxu 72×56 (`_ShipPreviewPainter`), řádky LOADOUT s čipy rodin, `LoadoutCursor` pro pad | `lib/ui/com_center.dart:1460,1809`, `loadout_cursor.dart` | Náhled lodi se stane hlavním prvkem obrazovky (§6) |
| Pipeline: `AssetSpec{Name, AssetType, PromptKind, ExtraVars}`, šablony `ship/bullet/enemy/boss/...` v `prompts.go`, `ship_frames` → `vessel_*` přes glow syntézu, `namemap.go` | `pipeline/internal/generator/assets.go:199`, `prompts.go:33` | Trupy = nové specs s `PromptKind: "ship"` + `HullDirective`; pody = nový `PromptKind: "pod"` |
| Co-op: `ProjSnap` nese `img`, `side`; `VesselSnap` nenese trup ani mody; `protocolVersion = 3` | `lib/net/protocol.dart:283` | Víc střel = víc snapů (OK); trup a pody do `VesselSnap` → `protocolVersion = 4` |
| l10n: 15 jazyků, ARB, vlastní jména zbraní se nepřekládají (rozhodnuto v Prompts/26 §9) | `lib/l10n/` | Názvy modů a trupů = vlastní jména, **nepřekládat**; popisy efektů přeložit |
| Výkon: `BatchRenderer` kreslí střely jedním `drawAtlas`; kolize střel je O(fleets × hostiles) na střelu, s broad-phase AABB flotily | `lib/rendering/batch_renderer.dart`, `vessel.dart` | 9× střel = 9× kolizních testů; cap + měření (§3.6) |

---

## 1. Slovník

- **Mod** — předmět ve vaultu. Má `id` (stabilní string do savu), raritu, scope (kam se dá nasadit), efekt(y). Instance = `ModInstance{modId, uid}`; žádné náhodné staty na instanci (žádné „+7 % dmg" rolování — vlastnosti jsou dané modem, náhoda je **který** mod padne).
- **Rarita** — `common` (šedobílá), `rare` (modrá), `mythic` (zlatá/magenta, animovaný rámeček). Rarita určuje sílu i vzácnost v dropu.
- **Rack** — sada socketů na lodi. Čtyři racky: `FRONT` (přední zbraň), `SIDE` (obě boční zbraně dohromady), `GEN` (generátor), `HULL` (trup). Počet socketů dává **trup** (§5).
- **Scope** modu — do kterých racků smí: `{front, side}` (zbraňové), `{front}`/`{side}` jen jeden, `{gen}`, `{hull}`. Některé zbraňové mody mají navíc `families` (jen pro laser, jen pro bubble…).
- **Vault** — account-level inventář modů (sdílený endless i kampaní). Nasazené mody jsou **na lodi** (per mode: endless loď a kampaňová loď mají každá své racky).
- **Trup (hull)** — jeden z 5 na skin. Account-level odemčení, výběr per loď (mode). Určuje HP/shield/gen základ, agilitu, počty socketů, speciální schopnost a grafiku `vessel_<hull>_*`.
- **Pod** — vizuální sprite nasazené zbraně (přední/boční, per rodina), kreslí se na trup v ComCenter i ve hře.
- **Forge** — slučování 3 modů stejné rarity → 1 náhodný vyšší rarity. Jediný „sink" pro duplikáty.

---

## 2. Katalog modů

Zásady:
1. **Prázdné racky = dnešní hra.** Všechny parity testy (`roguelike_progression_test`, `sector_parts_test`, …) stavějí bez modů a nemění se.
2. Mod **nikdy nesahá do `DevType`/`Device.upgrade()` konstant**. Působí v nové vrstvě `ShotPlan`/`HitContext` (§3) nebo přes násobiče čtené v `Vessel.update`.
3. Každý zbraňový mod, který zvedá výstup, zvedá i `pwrNeed` výstřelu. Energie je rozpočet, který hráč vidí (PWR bar v STATS, OVERLOAD, OFF). Generátorové mody rozpočet zvedají. Tím se pořadí „co si vzít" stává volbou, ne hromaděním.
4. Mody se **skládají násobením** (count = součin, násobiče = součin), s pevnými stropy (§3.6). Stejný mod dvakrát v jednom racku je povolen jen tam, kde je to uvedeno (`stackable`).
5. Pojmenování: krátké **vlastní jméno** (nepřekládá se, ≤ 9 znaků, ať se vejde na čip 80 px), + lokalizovaný popis efektu jednou větou.

### 2.1 Zbraňové mody — tvar palby (scope front, side)

| Mod | Rarita | Efekt | Energie | Poznámka |
|---|---|---|---|---|
| **DOUBLE** | common | 2 rovnoběžné proudy, rozestup ±10 px, každý 100 % dmg | pwr ×1.6 | stackable ×2 v racku → 4 proudy |
| **TRIPLE** | rare | vějíř 3 střel: `vx = −3, 0, +3` px/frame (přední) / `±2` (boční), 100 % dmg | pwr ×2.0 | |
| **HYDRA** | mythic | vějíř 5 střel `vx ∈ {−6,−3,0,3,6}`, 100 % dmg | pwr ×2.6 | nahrazuje TRIPLE, pokud jsou oba (bere se větší vějíř) |
| **SALVO** | rare | každý výstřel = dávka 2 střel za sebou s odstupem 4 framy (`FirePattern.burstGap` vzor) | pwr ×1.5 | stackable ×2 → dávka 3 → s TRIPLE **3×3** |
| **WIDE** | common | jen laser (`beam > 0`): paprsek +1 vedle (celkem 2), každý plné dmg | pwr ×1.7 | laserový ekvivalent DOUBLE; s TRIPLE = 3 paprsky `vx` ±3 (paprsek skloněný — `BeamSnap` má `dx,dy`, umí to) |
| **CROSSFIRE** | rare | jen side: boční zbraně střílejí **do kříže** (levá +vx, pravá −vx = 2 px/frame), pokrývají střed | pwr ×1.2 | mění, co boční zbraně dělají — konečně kryjí střed obrazovky |
| **REARGUARD** | mythic | jen side: ke každému bočnímu výstřelu +1 střela **dozadu** (speed +, 60 % dmg), hitbox na nepřátele, které prolétli | pwr ×1.4 | absurdní, ale užitečné: fleety s horizontálními cestami |
| **ORBIT** | mythic | jen bubble: střely letí po sinusovce (`vx = A·sin(t)`), šířka 40 px | pwr ×1.3 | vizuální show; s HYDRA pokryje celou šířku |

### 2.2 Zbraňové mody — kadence, síla, chování střely

| Mod | Rarita | Efekt | Energie |
|---|---|---|---|
| **RATE** | common | cooldown ÷1.25 | pwr ×1.15 (za výstřel; za sekundu ≈ ×1.44) |
| **RATE+** | rare | cooldown ÷1.6 | pwr ×1.2 |
| **OVERDRIVE** | mythic | cooldown ÷2.2; nad 90 % PWR zátěže střílí **i když** je `genValue < pwrNeed` (jede na dluh, generátor pak 1 s nedobíjí) | pwr ×1.25 |
| **HEAVY** | common | dmg ×1.25, speed ×0.85, drawScale +0.2 | pwr ×1.3 |
| **HEAVY+** | rare | dmg ×1.5, speed ×0.8, projScale ×1.25 (větší **hitbox**) | pwr ×1.6 |
| **CRIT** | common | 12 % šance ×3 dmg; FloatText „CRIT" žlutě (FloatText už existuje) | ×1.0 |
| **CRIT+** | rare | 25 % ×3 | ×1.0 |
| **DEADEYE** | mythic | 40 % ×3; crit na boss part = ×5 | ×1.0 |
| **PIERCE** | rare | střela po zásahu pokračuje; max 2 cíle (`hitsLeft`) | ×1.2 |
| **LANCE** | mythic | pierce bez limitu, dmg −10 % za každý průlet (min 30 %) | ×1.3 |
| **HOMING** | common | `guide +3` na zbraň (VB6 vodění existuje) | ×1.1 |
| **SEEKER** | rare | `guide +8`; střely bez cíle letí rovně | ×1.2 |
| **SWIFT** | common | speed ×1.3 (střely letí rychleji = dřív zasáhnou, méně míjejí) | ×1.0 |
| **FORK** | rare | při **zabití** vystřelí z místa smrti 2 střely téže rodiny do ±45° nahoru, 50 % dmg | ×1.0 |
| **CHAIN** | mythic | jako FORK, ale 3 střely a každá může forkovat dál (max hloubka 3) | ×1.0 |
| **SPLIT** | rare | jen bubble: při zásahu (ne zabití) se střela rozpadne na 2 malé (projScale ×0.5, 40 % dmg, `vx ±4`) | ×1.1 |
| **BOUNCE** | rare | střela, která by opustila obrazovku **bokem**, se odrazí (`vx = −vx`), 1× | ×1.0 |
| **PINBALL** | mythic | odraz bokem i **shora** (střela letí zpátky dolů a zase nahoru), max 3 odrazy, pak zmizí | ×1.0 |
| **FROST** | rare | zásah zpomalí nepřítele: `PathSystem.advance()` se na 1 s volá jen každý 2. frame; BossPart/Boss: 0.5 s | ×1.1 |
| **BIGSHOT** | common | projScale ×1.2 (hitbox) + drawScale +0.2 | ×1.1 |

### 2.3 Generátorové mody (scope gen)

| Mod | Rarita | Efekt |
|---|---|---|
| **COIL** | common | genPower ×1.25 (rychlejší dobíjení) |
| **COIL+** | rare | genPower ×1.6 |
| **REACTOR** | mythic | genPower ×2.2, **a** zbraně s `pwrNeed > genMax` střílejí přesto jednou za 3 s (OFF se mění na „SLOW") |
| **CELL** | common | genMax ×1.3 (větší zásobník = déle držíš plnou palbu) |
| **CELL+** | rare | genMax ×1.7 |
| **SURGE** | rare | když je `genValue == genMax` déle než 1 s, další výstřel všech zbraní dmg ×2 (FloatText „SURGE") |
| **SIPHON** | rare | každé zabití vrátí `genValue += 8 % genMax` |
| **FLUX** | mythic | pwrNeed všech zbraní ×0.6 — jediný mod, který snižuje cenu, a proto mythic |

### 2.4 Trupové mody (scope hull)

| Mod | Rarita | Efekt |
|---|---|---|
| **PLATE** | common | hpMax +25 % (HP se dorovná poměrně) |
| **AEGIS** | common | shieldMax +30 % |
| **REGEN** | rare | shieldRegen ×2 |
| **LEECH** | rare | zabití +1 HP (max hpMax); boss part +5 |
| **MAGNET** | common | pickupy v okruhu 160 px se přitahují k lodi (Collectable.update: lerp k vesselu) |
| **MAGNET+** | rare | celá obrazovka |
| **REFLECT** | rare | 20 % střel nepřátel, které zasáhnou **shield**, se odrazí nahoru jako střela hráče (bubble sprite, dmg = původní ×2) |
| **MIRROR** | mythic | REFLECT 60 % + odražená střela má `guide 10` |
| **GHOST** | rare | po zásahu trupu 1,5 s nezranitelnost místo 4 framů (`dmgTaken` je dnes flash + krátký invuln) |
| **NOVA** | mythic | když shield spadne na 0, výbuch přes obrazovku: dmg = `genMax` všem nepřátelům, boss ×0.3; cooldown 20 s |
| **AFTERBURN** | common | agilita +20 % (pad/klávesy rychlost; hitbox ×0.9) |
| **SCAVENGER** | common | kredity z kill ×1.25 |
| **BOUNTY** | rare | skóre ×1.25 (ovlivní odemykání tierů v endless — vědomé) |
| **SATELLITE** | mythic | oživí `WeaponSlot.satellite`: malý dron 30 px vedle lodi (ping-pong po x), střílí **kopii přední zbraně** s 50 % dmg a 0 pwr. Sprite: `boss_turret` skinu zmenšený, než vznikne vlastní |
| **TIMEWARP** | mythic | po zásahu trupu 0,6 s `dt × 0.35` pro nepřátele a jejich střely (hráč normálně) — vyžaduje time-scale v `TyrianGame.update` pro flotily/structures/enemy projectiles; cooldown 8 s |
| **GAMBLER** | mythic | každý výstřel má náhodnou rodinu sprite+staty (bubble/vulcan/blaster/laser/starg); pwr průměr. Čistý chaos, hra je sandbox |

### 2.5 Rarita vs. síla — orientační DPS násobky

Jedna zbraň, 25. level, bez modů = 1.0. Sockety FRONT na základním trupu: 2.

| Sestava | DPS výstupu | Zátěž PWR |
|---|---|---|
| DOUBLE | 2.0 | 1.6 |
| DOUBLE + RATE | 2.5 | 2.3 |
| TRIPLE + SALVO | 6.0 | 3.0 |
| TRIPLE + SALVO×2 (3 sockety) | 9.0 (3×3) | 3.75 |
| HYDRA + SALVO×2 + OVERDRIVE (4 sockety, mythic trup) | 33 | 5.3 → bez REACTOR/FLUX nestřílí |

Energie je ta brzda: 3×3 vějíř na základním generátoru = OVERLOAD. Hráč musí sbírat i gen mody a upgradovat generátor (kredity). To je smyčka: kredity → generátor, mody → tvar palby.

---

## 3. Mechanika ve hře

### 3.1 Datový model (`lib/systems/mods/`)

```dart
enum ModRarity { common, rare, mythic }
enum RackKind { front, side, gen, hull }

class ModSpec {
  final String id;            // 'double', 'triple', … stabilní do savu
  final String name;          // 'DOUBLE' — vlastní jméno, nepřekládá se
  final ModRarity rarity;
  final Set<RackKind> scopes;
  final Set<WeaponFamily>? families; // null = všechny
  final bool stackable;       // smí být 2× v jednom racku
  final ModEffects effects;   // viz níže; čistá data
  const ModSpec(...);
}

/// Co mod dělá — jen čísla a přepínače, žádná logika. ShotPlan/HitContext je čtou.
class ModEffects {
  final int streams;          // DOUBLE 2, HYDRA 5 (násobí se)
  final double fanVx;         // TRIPLE 3, HYDRA 6 — max, ne součin
  final int salvo;            // SALVO 2 (násobí se)
  final double cooldownDiv, dmgMul, speedMul, projScaleMul, drawScaleAdd, pwrMul;
  final int guideAdd, pierce;  // pierce -1 = ∞
  final double critChance, critMul;
  final int forkCount, forkDepth;
  final bool split, crossfire, rearguard, orbit, bounceSide, bounceTop, frost;
  final double genPowerMul, genMaxMul, hpMul, shieldMul, regenMul, agilityMul, creditMul, scoreMul;
  final double reflectChance, magnetRadius;
  final bool surge, siphon, overdrive, reactor, flux, leech, ghost, nova, satellite, timewarp, gambler;
  const ModEffects({...všechno s neutrálními defaulty: 1, 1.0, 0, false});
}

const List<ModSpec> kMods = [...];   // katalog §2; ModSpec.byId()

class ModInstance { final String uid; final String modId; }   // uid = 12 hex, vault
class ModRack {
  final RackKind kind;
  int sockets;                           // z trupu
  final List<ModInstance> fitted = [];   // ≤ sockets
  ModEffects get combined;               // složení podle pravidel §3.3
}
```

`Vessel` dostane `final Map<RackKind, ModRack> racks` a `HullSpec hull` (§5).
`Vessel.toSaveMap()` přidá klíče `racks` (per rack list `modId` + `uid`) a
`hull` (id). `loadFromSave` bez klíčů = prázdné racky, trup `falcon` →
stará hra. Account-level `ModsState { vault: List<ModInstance>, unlockedHulls:
Set<String>, claimed: Set<String> }` v `SaveService` pod klíčem `mods_state`
(verze 1). `claimed` = klíče už vydaných jednorázových odměn (§4).

### 3.2 ShotPlan — jediný vstup do `Device.fire`

`Device.fire()` dnes dělá všechno sám. Refaktor:

```dart
/// Co jeden stisk spouště u této zbraně vyprodukuje. Bez modů: 1 proud, 1 střela.
class ShotPlan {
  final int streams;      // rovnoběžné proudy
  final double fanVx;     // 0 = rovně; jinak krajní vx, mezilehlé lineárně
  final int salvo;        // dávky za sebou
  final double dmg, speed, projScale, pwrNeed, cooldown;
  final int guide, pierce;
  final double critChance, critMul;
  final bool crossfire, rearguard, orbit, bounceSide, bounceTop, frost;
  final int forkCount, forkDepth; final bool split;
  static ShotPlan from(Device d, ModEffects rack, ModEffects hullGen) ...
}
```

- `Device.fire(..., plan)`: ověří energii **na celý plán** (`plan.pwrNeed`), nastaví `cd = plan.cooldown / fireRateMult`, pak `for salvoIndex, for stream, for fan` vytvoří střely. Dávky za sebou = fronta `_pendingSalvo` s odpočtem framů, vyprazdňovaná v `updateCooldown`.
- Rozmístění proudů: `px + (i − (streams−1)/2) · 10`; vějíř: `vx = fanVx · (j − (fan−1)/2) / ((fan−1)/2)`; **vějíř se počítá z `fanVx > 0 ? 3 (TRIPLE) : 1`, HYDRA 5** — tj. `fan` je 1/3/5, ne součin, `streams` je součin. 3×3 = `streams 1 × fan 3 × salvo 3`, nebo `streams 3 × fan 1 × salvo 3` (DOUBLE×… ne, DOUBLE dává 2) — v praxi TRIPLE + SALVO×2.
- `Projectile` dostane `hitsLeft` (pierce), `bounces`, `forkDepth`, `salvoDelay`, `orbitPhase`, `frost`. Vše resetuje `activate()`. Pool zůstává per Device.
- Laser: `beam > 0` → `plan.streams` = počet paprsků; `Device` drží `List<BeamRay>` místo jedné `sx..dy`. `BeamSnap` v protokolu je už seznam → bez změny formátu.
- `fireRateMult` zůstává jak je (pad analog).

### 3.3 Skládání v racku

- `streams`: součin. `fan`: max. `salvo`: součin. Násobiče (`dmgMul`, `cooldownDiv`, `pwrMul`, …): součin. `guideAdd`, `forkCount`: součet. `pierce`: max (−1 vítězí). Booly: OR.
- `crit`: šance součet, násobek max.
- SIDE rack platí pro **obě** boční zbraně stejně (jedna sada socketů, dvojnásobný efekt na obrazovce — to je záměr: boční slot má menší zbraně).
- Rack `GEN` působí na `Vessel.genPower/genMax` **při výpočtu**, ne zápisem do uložených hodnot: `effectiveGenPower = genPower · rack.genPowerMul`. Totéž HP/shield trupových modů: `effectiveHpMax`. Save drží základ, mody jsou vrstva → sundání modu nic nerozbije. ComCenter STATS ukazují efektivní hodnoty s „(+30 %)" šedě.

### 3.4 HitContext — hooky v `Vessel._checkProjectileCollisions`

```dart
// místo h.takeDamage(d.damage …):
final hit = HitContext(p, d, rack);          // dmg po crit, surge, gambler
h.takeDamage(hit.damage, game, attacker: this, source: d);
if (hit.crit) game.floatText('CRIT', h.hostCenter, yellow);
if (plan.frost) h.applyFrost(seconds);
if (h.isDead) { fleet.onHostileKilled(…); if (plan.forkCount > 0 && p.forkDepth < plan.forkDepth) _spawnFork(p, h, plan); }
else if (plan.split && p.canSplit) _spawnSplit(p);
if (p.hitsLeft != 0) { p.hitsLeft--; p.hitHostiles.add(h); continue; }  // pierce: nekonzumovat, nezasáhnout 2× téhož
return true;
```

- `Hostile.applyFrost(s)`: `frostTimer`; `Fleet` při advance cesty přeskočí každý 2. frame, dokud `frostTimer > 0`. Boss/BossPart: poloviční doba.
- Fork/Split střely: `Projectile(parentDevice: d)` ze stejného poolu, `forkDepth + 1`, `vx` podle úhlu. Fork na `Structure` ne (jen kill nepřítele).
- Odraz nepřátelské střely (REFLECT): v `TyrianGame` enemy-projectile smyčce (`v.takeDamage(p.damage…)` ~1211): pokud `v.shield > 0 && rng < reflectChance` → místo damage `v.frontDevice.spawnReflected(p)`.
- Leech, Siphon, Surge, Scavenger, Bounty: v `Fleet.onHostileKilled` (už tam přidává skóre a kredity attackerovi) + `Vessel.onKillFeedback()`.
- NOVA/TIMEWARP/GHOST: v `Vessel.takeDamage`.
- MAGNET: `Collectable.update` — pokud `game.vessel.magnetRadius > 0` a vzdálenost < r, `position += (vessel − position) · min(1, 6·dt)`.
- SATELLITE: nová entita `Satellite extends PositionComponent` v `lib/entities/`, vlastní `Device` (kopie front typu, `slot: WeaponSlot.satellite`, `pwrNeed 0`, dmg ×0.5), v `Vessel.devices`? **Ne** — držet mimo `devices` (`Vessel.satellite`), ať ho nespočítá `generatorLoad`, `totalDps`, ComCenter ani co-op `encodeVesselState`. Střely posílat do `allVessels` smyčky snapů zvlášť.
- GAMBLER: v `ShotPlan.from` per výstřel: `rng.pick(DevType.frontWeapons)` → `imgName`, dmg/speed z něj, pwr průměr. `Projectile.imgName` se už mění přes `activate` + `_loadSprite`.

### 3.5 Co-op

- Host autoritativní. Klient dostává střely jako dnes (`ProjSnap` s `img`, `side`) — víc střel = delší paket, limit `playerProjs` 400 (ověřit MTU/rozdělení v `MessageFramer`).
- `VesselSnap` + `hull: uint8` (index do `kHulls`) + `pods: uint8` bitmask (5 rodin × front/side = 10 bitů → uint16) → klient kreslí správný trup a pody. `protocolVersion = 4`. `test/proj_snap_test.dart` rozšířit.
- P2 (vessel2) mody: **v této iteraci žádné** — P2 nemá vlastní ComCenter racky; host může P2 racky nastavit stejně jako své („mirror") — rozhodnout v §11.

### 3.6 Výkon a stropy

- Hard cap: `streams ≤ 4`, `fan ≤ 5`, `salvo ≤ 3` → max 60 střel na stisk všech zbraní; **globální cap 360 aktivních střel hráče** (ShotPlan odmítne vystřelit, když `game.playerProjectileCount > 360`, zbraň „přeskočí" tick — stejně jako když chybí energie). Číslo změřit na iPhone 12 mini a Pixel 6a s bloom zapnutým; BatchRenderer kreslí jedním `drawAtlas`, úzké místo je kolize + bloom pass.
- Kolize: dnes O(střel × flotil × nepřátel) s AABB flotily jako broad-phase. Při 300 střelách a 20 nepřátelích = 6k testů/frame — OK. Pokud profil ukáže problém: `Fleet.minY/maxY` už existuje → setřídit flotily podle `minY` a ukončit smyčku dřív. Neřešit předem.
- Bloom: střel víc → jasnější obraz. `ShaderConfig` má práh; u HYDRA sestav zvážit automatické `bloomStrength × 0.8`, když je střel > 150. Volitelné.
- Fork/Chain: `forkDepth ≤ 3`, FORK jen z kill → omezený počet.
- SFX: `SfxEvent.fireBullet` hrát **jednou na plán**, ne per střela (dnes jednou per `fire()` — zůstane).

### 3.7 Challenge × mody

Násobiče Challenge zůstávají. Dropy (§4) mají váhu rarit podle challenge: hard rare +10 pb, lord mythic ×2. Nic jiného.

---

## 4. Získávání modů

### 4.1 Zdroje

| Spouštěč | Odměna | Jednorázovost |
|---|---|---|
| **Kampaň: node poprvé na plný počet hvězd** | 1 drop z tabulky nodu (§4.2) | `claimed: 'stars:<node>'` |
| **Kampaň: boss v časovém okně** — nový star objective `bossUnderTime(s)` na nodech 4, 9, 14, 19 (okno 25 / 30 / 35 / 40 s od spawnu jádra do jeho smrti; TTK je 19–31 s pro aktuální DPS, takže okno vyžaduje mody nebo přesnou palbu) | 1 drop **rare+** (rare 75 / mythic 25); boss 4: mythic jistý | `claimed: 'boss:<ordinal>'` |
| **Kampaň: boss „perfektně"** = `strip` + `untouched` + `bossUnderTime` na jednom nodu | +1 **mythic** navíc | `claimed: 'perfect:<node>'` |
| **Kampaň dohrána** (`isFinished` poprvé) | trup (§5) + 1 mythic | `claimed: 'finish'` |
| **Endless: každý boss zabit** | 1 drop: common 70 / rare 27 / mythic 3 | opakovatelné (jediný farmable zdroj, záměr: endless je grind, kampaň je výzva) |
| **Endless: hloubka 10 / 20 / 30 sektorů poprvé** | rare / rare / mythic | `claimed: 'depth:<n>'` |
| **Forge** | 3× stejná rarita → 1 náhodný vyšší rarity (mythic ×3 → 1 mythic jiný než vložené) | — |

Žádné IAP za mody, žádný prodej za kredity. Monetizace zůstává u skinů
(rozhodnuto dřív: free-with-skins). Mody jsou account-level a **nejsou vázané
na skin** — skin je kabát, mod je výkon.

### 4.2 Drop tabulka

```dart
class DropTable { final int common, rare, mythic; /* váhy */ }
// kampaň podle nodu:
nodes 0–4   : 80 / 20 / 0
nodes 5–14  : 55 / 38 / 7
nodes 15–19 : 35 / 50 / 15
```

Výběr modu v rámci rarity: rovnoměrně z katalogu dané rarity, **s vyloučením**
modů, které hráč už má ≥ 2× (pity proti duplikátům); pokud nic nezbývá,
rovnoměrně. RNG seedovaný (`Random(seed)`), seed uložený v `ModsState` a
posouvaný po každém dropu → deterministické testy, žádný save-scum
(drop se spočítá v `_onSectorComplete` a hned uloží spolu s `claimed`).

### 4.3 Tracker

- `CampaignTracker`: `bossSpawnedAt`, `bossKilledAt` (herní čas `game.elapsed`); hooky `onBossSpawn()` z `Fleet` když spawnuje `Boss`, `onBossKill()` z `onKill` když `h is Boss`. `ObjectiveKind.bossUnderTime` → `met = killed − spawned ≤ amount`.
- `ObjectiveSpec.bossUnder(seconds)`: `id: 'bossfast'`, text `'Destroy the boss core within ${s}s of its arrival'`, ARB klíč `objBossUnder`.
- Na boss nodech přibude 4. star → `starTotal` 4 (CampaignResultCard kreslí hvězdy dynamicky z `starTotal`? ověřit, `campaign_ui_test`).

### 4.4 Předání odměny

`_onSectorComplete` (kampaň): po `markCompleted` → `ModRewards.evaluate(campaign, node, result)` vrátí `List<ModInstance>` + `List<String> hullsUnlocked`; zapíše do `ModsState` + `claimed`, uloží; `lastNodeDrops`. `CampaignResultCard` pod „unlocked" vykreslí **odhalení karty**: karta rarity (rub → líc, 400 ms, barva rarity, mythic s animovaným okrajem), jméno modu, popis, tlačítko „TO HANGAR" (otevře ComCenter rovnou na racku) / „CONTINUE". Endless boss drop: `showMessage` + stejná karta jako overlay nad hrou po smrti bosse (krátce, 2 s, netlačí na pauzu).

---

## 5. Trupy

Pět trupů na skin. Staty jsou **společné všem skinům** (hra je jedna), skin dává jen grafiku. Dnešní loď = trup `falcon`.

| id | Jméno | HP | Shield | Gen (power/max) | Agilita | Hitbox | Sockety F/S/G/H | Speciál |
|---|---|---|---|---|---|---|---|---|
| `falcon` | FALCON | 125 | 100 | 1.0 / 1.0 | 1.0 | 1.0 | 2/1/1/1 | — (parita) |
| `dart` | DART | 90 | 80 | 0.9 / 0.9 | 1.35 | 0.8 | 2/0/1/1 | **Afterimage**: po 0,4 s bez pohybu další výstřel dmg ×1.5 (odměna za „stop and shoot") |
| `bastion` | BASTION | 200 | 160 | 1.0 / 1.2 | 0.8 | 1.15 | 1/2/1/2 | **Bulwark**: poškození, které po vyčerpání shieldu projde do trupu, je ×0.5 (`takeDamage`: shield dnes absorbuje vše, zbytek jde celý do HP); první asteroid bere jen 50 % shieldu místo celého (`hitByAsteroid` stupeň 1); REFLECT 10 % zdarma |
| `dynamo` | DYNAMO | 110 | 90 | 1.5 / 1.4 | 1.0 | 1.0 | 2/1/**2**/1 | **Overclock**: OFF práh je 1.3 × genMax (zbraň střílí i mírně nad kapacitu, pomaleji) |
| `colossus` | COLOSSUS | 170 | 130 | 1.2 / 1.3 | 0.7 | 1.25 | **3/2/1/2** | **Battery**: vestavěný `satellite` slot (dron zdarma); jediný trup, kde jde 3×3 bez mythic modů |

Odemykání (account-level, `unlockedHulls`): `falcon` vždy; `dart` boss 1,
`bastion` boss 2, `dynamo` boss 3 (kampaň, poprvé), `colossus` dohrání kampaně
**nebo** endless hloubka 30. Trup se mění v ComCenter kdykoli; zbraně zůstávají
(sloty jsou stejné), racky se přepočítají — mody nad počet socketů jdou
**zpátky do vaultu** (toast). Trup je uložený per loď (`vessel.hull`), takže
endless a kampaň mohou létat s jiným.

Hitbox: `Vessel.size` zůstává (sprite), kolizní AABB dostane `hitboxScale`
(`Vessel.hitRect` — ověřit, kde se dnes testuje zásah lodi: `tyrian_game.dart`
~1211 a asteroidy). Agilita: násobek `_kbSpeed` v `TyrianGame._applyMovement`
(klávesnice i pad, obě lodě) a **nic** pro drag (1:1 je svaté).

```dart
class HullSpec {
  final String id, name; final int hp, shield;
  final double genPowerMul, genMaxMul, agility, hitbox;
  final Map<RackKind, int> sockets;
  final HullPerk perk;                      // enum {none, afterimage, bulwark, overclock, battery}
  final List<PodAnchor> anchors;            // kde sedí pody, normalizované 0..1 × 0..1 vůči sprite
}
```

VB6 parita: `falcon` má přesně dnešní hodnoty (`hpMax 125`, `shieldMax 100`,
`genMax 100`, `genPower 4`) a `resetVessel()` je bere z `kHulls.falcon` → jeden
zdroj pravdy, parity testy beze změny.

---

## 6. ComCenter: hangár s lodí

Dnešní layout (Prompts/26): hlavička → STATS → LOADOUT (4 řádky čipů) → SKINS. Nově:

```
┌──────────────────────────────────────────────┐
│ COMMAND CENTER  [HARD]          Pilot: Ace_  │
│ Credits: 12,500                Score: 98,400 │
├──────────────────────────────────────────────┤
│ ▌HANGAR                        ◄ DART  ►     │  ← výběr trupu (odemčené; zamčené šedě + „Boss 2")
│                                              │
│            [F]   ╱‾‾╲   [F]                  │  ← F = socket FRONT racku (čip modu nebo prázdný „+")
│      [S]  ╱  ▓▓ pod ▓▓  ╲  [S]               │     pod přední zbraně na nose, boční pody na křídlech
│          │ ▓▓▓▓▓▓▓▓▓▓▓▓ │                    │     loď 60 % šířky, glow ping-pong jako ve hře, bank 0
│      [S]  ╲ ▓▓▓▓▓▓▓▓ ╱   [G]                 │  ← G = GEN socket u motoru
│            ╲_▓▓▓▓_╱      [H][H]              │  ← H = HULL sockety pod trupem
│   HP 200  SH 160  GEN 1.0×  AGI 0.8  HIT 1.15│  ← staty trupu + mody (efektivní, zelené „+")
│   PWR ████████▌ 112% OVERLOAD   DPS 48.6     │
├──────────────────────────────────────────────┤
│ ▌LOADOUT   (řádky FRONT/LEFT/RIGHT/GEN z 26) │  ← beze změny: nákup/upgrade zbraní
├──────────────────────────────────────────────┤
│ ▌VAULT   [ALL][FRONT][SIDE][GEN][HULL] 23    │  ← mřížka čipů modů, filtr podle racku, rarita barvou
│  [DOUBLE][TRIPLE][RATE ][CRIT ][COIL ][PLATE]│     tap = detail + „FIT → F/S/G/H" / „FORGE"
│  [RATE  ][RATE  ][HEAVY][...  ]              │     3 stejné rarity vybrané → tlačítko FORGE
├──────────────────────────────────────────────┤
│ ▌SKINS                                       │
├──────────────────────────────────────────────┤
│ [HOST] [JOIN]              [START MISSION]   │
└──────────────────────────────────────────────┘
```

Interakce:
- **Tap na socket** (prázdný): otevře VAULT filtrovaný na ten rack, první tap na čip ho nasadí. Socket s modem: detail (jméno, rarita, popis, „UNFIT", „SWAP").
- **Tap na čip ve VAULTu**: detail + tlačítka `FIT FRONT / FIT SIDE / …` jen pro povolené scopy a volné sockety; čip, který nejde nasadit nikam (rodina nesouhlasí, plno), má šedý rámeček s důvodem.
- **Drag & drop** čip → socket na mobilu i desktopu (Flutter `Draggable`/`DragTarget`); tap flow je primární, drag je bonus.
- **Forge**: long-press na čip = „vybrat"; 3 vybrané stejné rarity → tlačítko FORGE (potvrzení, animace tří karet do jedné).
- Trup `◄ ►`: přepne trup, loď se překreslí (nové snímky, jiné kotvy podů), racky se přepočítají, přebytek → vault + toast.
- STATS sekce z Prompts/26 se **slučuje** do HANGAR spodního řádku (HP/SH/GEN/PWR/DPS/NEXT) — jedna obrazovka míň.
- Pad/klávesnice: `LoadoutCursor` dostane region `hangar` (sockety v pořadí F, F, S, S, G, H, H + šipky trupu) a `vault` (mřížka). ↑↓ mezi regiony jako dnes, ←→ v regionu, B = akce, X = unfit, Y = forge-select. Rozepsat do `loadout_cursor_test`.
- Zůstává: hlavička (long-press cheats — přidat cheat „+1 mythic", „+10 common" pro ladění), SKINS, spodní lišta, 375 pt layout test (`com_center_layout_test`).

Loď v hangáru kreslí nový `HangarShipPainter` (CustomPainter, `lib/ui/hangar_ship.dart`):
1. trup: `AssetLibrary.vesselFramesFor(hull)` snímek `(t · 8).floor()` ping-pong → stejný glow jako ve hře;
2. pody: pro každou vybavenou zbraň sprite `pod_front_<family>` / `pod_side_<family>` na kotvě z `HullSpec.anchors` (`front` nos, `left`/`right` křídla; měřítko podle šířky trupu), boční pod vpravo zrcadlit;
3. sockety: pozice z kotev (`frontSockets`, `sideSockets`, `gen`, `hull`), kreslí widgety přes `Stack`/`Positioned` nad painterem (kvůli tapům);
4. mythic efekt: tenký animovaný okraj kolem lodi, pokud je nasazen ≥ 1 mythic.

Ve hře kreslí pody `Vessel.render` **uvnitř** stejné canvas transformace jako trup (bank/depth), pod trupem (z-order: pody, pak trup? — pody **nad** trupem, jsou to přídavky). Dron SATELLITE/Battery má vlastní entitu.

---

## 7. Grafika: co generovat

Na skin (24 skinů):

| Asset | Počet | Pipeline name | Game name | Ref. velikost (VB6 px) | Poznámka |
|---|---|---|---|---|---|
| Trupy | 4 nové (`dart`, `bastion`, `dynamo`, `colossus`; `falcon` = dnešní `ship_frames`) | `hull_<id>` (`AssetType: "ship"`, `ExtraVars.HullDirective`) | `vessel_<id>_0..5` (glow syntéza jako ship) | podle trupu: dart 96×84, bastion 124×84, dynamo 114×84, colossus 140×96 | `namemap.go`: `hull_x` → `vessel_x`; `processor.go:280` čte ReferenceSize("vessel") → per trup |
| Pody přední | 5 rodin | `pod_front_<family>` (`PromptKind: "pod"`) | `pod_front_<family>` | 40×48 | bez pozadí (bg removal jako sprites), nos nahoru |
| Pody boční | 5 rodin | `pod_side_<family>` | `pod_side_<family>` | 28×40 | kreslí se na levém křídle, vpravo zrcadleně |
| Dron | 1 | `drone` (`PromptKind: "pod"`, směr nahoru) | `drone` | 30×30 | do té doby `boss_turret` zmenšený |
| Ikony rarit | 0 | — | — | — | vektorově (`CustomPainter`): rámeček + barva; žádná generace |

Celkem 4 + 10 + 1 = **15 assetů × 24 skinů = 360 obrázků** × 4 varianty = 1440 → přes broker po dávkách (`sparkctl exec kirian comfyui …`, viz `output/boss_b/run.sh` jako vzor; ~10–15 s/obr. na flux-dev 1k → 4–6 h celkem, v několika oknech). Pilot: `default` + `abadox` (pixel vs. ilustrace), všechny trupy a pody, 4 varianty → kontaktní list uživateli (variantsheet + sprite picker artefakt: přidat sekci „Trupy a pody") → teprve pak všech 24.

Atlas: 15 spritů navíc na skin; `default` atlas je dnes 4096² při 151 spritech (4.9 MB) — pody jsou malé, trupy 4× ~450×340 px → vejde se; `pack_atlas.dart` hlásí přetečení, ověřit u `galaga`/`geometry_wars` (4096×4096 už dnes).

Fallbacky (důležité pro postupné dodání, §10): chybí `vessel_<hull>_*` → `vessel_*` + **barevný tint** trupu (dart cyan, bastion oranžová, dynamo žlutá, colossus magenta) přes `ColorFilter`, ať je trup rozeznat i bez grafiky; chybí `pod_*` → malý vektorový glyf rodiny (barvy z Prompts/26 §1: bubble modrá, vulcan oranžová, …). Hra i ComCenter musí fungovat **bez jediného nového obrázku**.

---

## 8. Prompty (pipeline `prompts.go` / `assets.go`)

### 8.1 Trupy — rozšíření šablony `ship`

Stávající `ship` šablona zůstává pro `falcon`. Nový `{{.HullDirective}}` se
vloží za první odstavec (po „nose points straight to the TOP edge"):

```
dart:     "Hull archetype: INTERCEPTOR — slim, long, needle-like fuselage, swept-back narrow wings,
           two oversized engines at the rear, almost no armor plating, built for speed. Overall
           proportions taller than wide (about 5:4)."
bastion:  "Hull archetype: BULWARK — squat, wide, heavily armored hull with layered plating, short
           stubby wings, a thick frontal shield prow, four small engines. Overall proportions wider
           than tall (about 3:2). Looks like it can take a hit."
dynamo:   "Hull archetype: REACTOR SHIP — mid-size hull dominated by a large glowing power core in
           the centre, visible energy conduits running from the core to the wingtips and nose,
           radiator fins along the sides, one big engine. Roughly square."
colossus: "Hull archetype: DREADNOUGHT — massive, broad, multi-tiered hull, two heavy outer pylons
           with hardpoints, central superstructure, six engines across the rear, flat empty mounting
           pads on the nose and both wings where weapon pods will be attached. Widest of all, about
           3:2, filling the frame."
```

Pony varianta (`ponyQuality + ", player spaceship, vehicle, {{.HullDirective}}, …"`) stejně.
Všechny trupy téhož skinu musí být **jedna rodina**: stejný `StyleKeywords`, paleta, dekály — to zajišťuje skin, ne prompt; v pilotu ověřit, že čtveřice vypadá jako jedna flotila (re-roll outlierů, viz [[kiran-iteration-style]]).

### 8.2 Pody — nová šablona `pod`

flux:
```
{{.ArtDirective}}
A single detachable WEAPON POD for a spacecraft, viewed from DIRECTLY OVERHEAD — strict top-down
orthographic view, zero perspective. It is an attachment, NOT a ship: no cockpit, no wings, no
engines. The muzzle points straight to the TOP edge of the image. {{.PodDirective}}
Compact, chunky, readable at small size: one dominant shape, strong silhouette, 2–3 bold details,
a mounting base/bracket at the bottom. Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}},
with the weapon's own energy color as the single accent.
Centered, filling about 70 % of the frame height. No background elements, no text, no UI.
The background must be a single flat solid color, no gradient, clearly distinct from the sprite.
```

`PodDirective` per rodina (sdílí barvu a tvar s `bulletSpecs`, aby pod a střela patřily k sobě):

| Rodina | front | side |
|---|---|---|
| bubble | "Bubble emitter: a glass dome over a glowing blue orb chamber, short wide nozzle, soft blue energy color" | "Small wing-mounted bubble emitter: single glass bead on a stub bracket, blue glow" |
| vulcan | "Rotary vulcan cannon: a cluster of six barrels in a drum, ammo belt housing, hot orange muzzle tips" | "Twin-barrel light autocannon on a wing pylon, orange tracer glow at the muzzles" |
| blaster | "Heavy blaster: one thick coil-wound cannon with a wide bright purple charge ring near the muzzle" | "Compact blaster coil on a side mount, purple charge ring" |
| laser | "Laser projector: a long crystal lens assembly with focusing rings, cyan emitter core at the tip" | "Thin side laser lens on a bracket, cyan emitter tip" |
| starg | "Star launcher: a spinning magazine of yellow star-shaped shells visible through a slot, splayed rails" | "Mini star launcher pod with one visible yellow star shell" |
| drone | "Tiny autonomous gun drone: round body, one small barrel, a glowing eye-sensor, no wings" | — |

Postprocess: `pod_*` jako `sprites` (bg removal, resize na referenci, do atlasu); `drone` totéž. `reference_sizes.go` + `namemap.go` (identita) + `processor_test.go`.

### 8.3 Co negenerovat
- Ikony modů: vektorové — mod je abstraktní stat, 60 ikon × 24 skinů by bylo 1440 obrázků bez herní hodnoty. Čip = jméno + rarita barvou + malý glyf druhu (vektor: vějíř, blesk, štít, ozubené kolo).
- Pozadí ComCenter: zůstává (Prompts/26 §10).

---

## 9. Save, migrace, testy

Save:
- `game_state` a `campaign_state.vessel`: nové volitelné klíče `hull: 'falcon'`, `racks: {front:[{id,uid}], side:[…], gen:[…], hull:[…]}`. Verze **nezvyšovat** (viz §0). Chybí → default.
- `mods_state` (nový klíč, verze 1): `{vault:[{id,uid}], unlockedHulls:[…], claimed:[…], rngSeed:int}`.
- `tyrian_game.dart:~1360` kopie lodi (`dst.devices.clear()…`) → zkopírovat i `hull`, `racks`.
- Smrt v endless = `restartRun() → vessel.resetVessel()` („keeping everything the pilot earned"): racky **zůstávají**, stejně jako hangár. `resetForNewGame() → vessel.newGame()` maže `devices` i `hangar` (`vessel.dart:185-192`) → maže i racky (mody se vrátí do vaultu, vault se nemaže — je account-level). Trup při `newGame` zpět na `falcon`.

Testy (všechny headless, bez widgetů, kromě layoutu):
- `test/mods/shot_plan_test.dart`: bez modů = 1 střela, parametry = Device; DOUBLE 2; TRIPLE vx −3/0/3; TRIPLE+SALVO×2 = 9 střel s odstupy; HYDRA přebije TRIPLE; stropy; laser streams → paprsky; pwr součin.
- `test/mods/rack_test.dart`: skládání (součin/max/součet), scope + families odmítnutí, stackable, sockety při změně trupu → přebytek.
- `test/mods/hit_context_test.dart`: crit šance se seedem, pierce `hitsLeft`, fork hloubka, split jen bubble.
- `test/mods/drop_table_test.dart`: váhy per node, pity proti dupům, determinismus seedu, challenge posun.
- `test/mods/rewards_test.dart`: plné hvězdy poprvé → 1 drop, podruhé nic; `bossUnderTime` z trackeru (spawn/kill časy); perfect boss → mythic; `claimed` idempotence.
- `test/hull_spec_test.dart`: `falcon` == dnešní konstanty (parita!); sockety; `resetVessel` z HullSpec.
- `test/mods/save_roundtrip_test.dart`: racky + vault + hull; load bez klíčů.
- `test/proj_snap_test.dart`: `VesselSnap.hull/pods`, verze 4.
- `test/campaign_tracker_test.dart`: `bossUnderTime` případy; `campaign_nodes_test`: boss nody mají 4 stars.
- `test/com_center_layout_test.dart`: HANGAR + VAULT na 375 pt v en/cs/de/ru/ja bez přetečení; flow „tap socket → vault → fit".
- `loadout_cursor_test.dart`: regiony hangar/vault.
- Stávající parity testy **beze změny a zelené**.

---

## 10. Pořadí dodávky (vše `main`, každý krok = PR + tag, Steam beta + TestFlight + Firebase)

1. **3.9.0 — jádro bez grafiky.** `lib/systems/mods/` (katalog, racky, ShotPlan, HitContext, drop table, rewards), `HullSpec` s 5 trupy (fallback tint), hooky ve `Vessel`/`Device`/`Projectile`/`Fleet`/`Collectable`, `bossUnderTime`, `ModsState` save, co-op v4, cheat „+mody". ComCenter: **minimální** HANGAR (loď jako dnes + 7 socketů jako čipy + ◄► trup) a VAULT mřížka s tap-flow; CampaignResultCard odhalení karty. Testy §9. Tím je celá mechanika hratelná a laditelná na zařízení.
2. **3.9.1 — ladění.** Čísla z §2 po hraní na telefonu (uživatel), stropy z měření, bloom ztlumení, SFX pro crit/surge/nova (ElevenLabs přes pipeline `-sfx`, nebo reuse).
3. **3.10.0 — grafika pilot.** Pipeline: `hull_*`, `pod_*`, `drone` specs + šablony §8, reference sizes, namemap; `default` + `abadox` vygenerované, vybrané uživatelem (sprite picker artefakt: sekce „Trupy a pody"), atlasy; `HangarShipPainter` s pody a kotvami; pody ve hře. Ostatní skiny jedou na fallback.
4. **3.10.x — zbylých 22 skinů** po dávkách přes broker, kurátorský výběr, bez změn kódu.
5. **3.11.0 — drag & drop, forge animace, Steam achievementy** („First mythic", „3×3", „Colossus online"), pokud bude chuť.

Každý krok nechává parity testy zelené a hru s prázdnými racky identickou s 3.8.7.

---

## 11. Otevřené otázky pro uživatele (zeptat se před krokem 1)

1. **Vault sdílený** mezi endless a kampaní (návrh: ano, account-level), nebo každý mode vlastní?
2. **Endless boss drop opakovatelně** (návrh: ano, jediný grind zdroj) — nebo jen jednorázové milníky, aby mody zůstaly „trofej z kampaně"?
3. **P2 v co-opu**: žádné mody (návrh pro první verzi) / mirror hostových / vlastní (vyžaduje P2 ComCenter racky a sync)?
4. **Mody vázané na skin?** Návrh: ne. Alternativa: skin-exkluzivní mythic (např. `ikaruga` → POLARITY: střídání dvou rodin) — hezké, ale 24 unikátních mechanik je další projekt.
5. **Trupy odemykat bossy** (návrh), nebo prodávat za kredity v ComCenter (kredity dnes nemají velký sink po 25. levelu zbraní)?
6. **Agilita na dotyku**: jen hitbox (návrh), nebo i jemné „zpoždění" sledování prstu u těžkých trupů (riziko: pocit rozbitého ovládání)?
7. **Jména**: DOUBLE/TRIPLE/HYDRA… anglicky všude (jako rodiny zbraní) — potvrdit.
8. Má smysl i **negativní mod** (curse) s velkým bonusem, např. GLASS: dmg ×2, hpMax ×0.5? Sandbox to snese; návrh: ano, 3 kusy jako rare.

---

## 12. Ad absurdum (parkoviště nápadů, až bude §10 krok 1–3 venku)

- **ECHO** (mythic hull): každá střela se po 0,5 s zopakuje z místa, kde právě je, jako duch s 30 % dmg.
- **BLACKHOLE** (mythic front): každá 20. střela je singularita — zastaví se uprostřed obrazovky, 2 s přitahuje nepřátele a jejich střely, pak zmizí.
- **SWARM** (mythic side): boční zbraně místo střel vypouštějí 1 dron za 3 s (max 6), drony se chovají jako SATELLITE s 20 % dmg.
- **PRISM** (laser): paprsek se na prvním zásahu láme do 3 paprsků ±30°.
- **GRAVITY WELL** (hull): nepřátelské střely se u lodi ohýbají (`vx` k ose lodi záporně) — „force field" bez nezranitelnosti.
- **TEMPO** (gen): kadence sleduje `MusicDirector` tier — na nejvyšší hudební intenzitě cooldown ÷1.5. Hudba už má tiery.
- **SKIN SHIFT** (mythic): každý sektor náhodný odemčený skin — reklama na skiny zdarma.
- **Lord-only**: na `Challenge.lord` padá navíc jeden „cursed" mod každý boss, který hráč **musí** nasadit (nelze unfit do konce kampaně).

---

## 13. Rozhodnuto (uživatel, 2026-11-05)

1. **Vault sdílený** endless + kampaň (account-level, klíč `mods_state`); racky jsou per loď.
2. **Endless boss drop opakovaně** (common 70 / rare 27 / mythic 3) + jednorázové milníky hloubky 10/20/30.
3. **Trupy za bosse kampaně** (1 → DART, 2 → BASTION, 3 → DYNAMO; COLOSSUS za dohrání kampaně nebo endless hloubku 30). Za kredity ne.
4. **Curse mody ano**, 3 kusy jako rare: GLASS (hull: dmg ×2, HP ×0.5), FURNACE (zbraň: dmg ×1.8, PWR ×2.4), ANCHOR (hull: HP/štít ×1.6, agilita ×0.6, hitbox ×1.2).
5. Podle doporučení plánu (uživatel nevybíral): P2 v co-opu **bez modů** (P2 dostává staty P1 s vydělenými mod násobiči), mody **nevázané na skin**, agilita na dotyku **jen hitbox**, jména modů **anglicky všude**.

## 14. Stav implementace — krok 1 (3.9.0, větev `feat/mods-hulls`)

Hotovo:
- `lib/systems/mods/`: `mod_spec.dart` (katalog 55 modů: 15 common, 25 rare vč. 3 curse, 15 mythic, `ModEffects.combine`), `mod_rack.dart`, `hull_spec.dart` (5 trupů jako násobiče na VB6 loď), `shot_plan.dart`, `mods_state.dart` (vault, trupy, claimed, seed, drop tabulky, forge), `mod_rewards.dart`.
- Hra: `Device.fire` přes `ShotPlan` (proudy, vějíř, salvo, crossfire, rearguard, gambler, overdrive/reactor/overclock, strop 360 živých střel), `Projectile` (pierce, bounce/pinball, orbit, fork/split stav), `Vessel` (racky, trup, škálování statů, crit/pierce/fork/split/frost, paprsky laseru na víc cílů, leech, siphon, surge, afterimage, bulwark, ghost, nova, timewarp, reflect/mirror, satelitní dron), `Fleet` (score/credit násobiče, kill feedback), `Collectable` (magnet), `TyrianGame` (enemy time scale, hitbox, agilita, reflect, odměny).
- Kampaň: `ObjectiveSpec.bossUnder` (`bossfast`) na nodech 4/9/14/19 (25/30/35/40 s od spawnu jádra); `CampaignTracker.bossSpawnedAt/bossKilledAt`; `Campaign.poweredDps` počítá DPS s mody → boss má HP podle modované lodi.
- UI: ComCenter sekce HANGAR (výběr trupu ◄►, náhled lodi s tintem bez grafiky, 4 racky se sockety) + VAULT (filtr, mřížka, karta modu s FIT → rack, long-press = výběr do forge, FORGE); cheat řádek `+C +R +M +H`; CampaignResultCard blok REWARD.
- l10n: 78 nových klíčů ve všech 16 jazycích; popisy modů se skládají z efektů (`lib/ui/mod_text.dart`), žádný text na mod.
- Co-op: `protocolVersion = 4`, `VesselSnap.hull`.
- Testy: `test/mods_test.dart` (41), hull v `proj_snap_test`, hangar/vault na 375 pt v `com_center_layout_test`. Všechny staré testy beze změny zelené (parita).

Odchylky od plánu:
- `newGame()` **nechává zvolený trup** (je to volba, ne postup); mody vrací do vaultu kromě startu nové kampaně (`returnMods: false`), kde zůstávají v endless savu.
- Staty trupů jsou **násobiče** na VB6 loď (DART HP ×0.72 = 90 atd.), aby upgrady z pickupů a shopu dál platily procentem.
- WIDE = +1 paprsek a dmg ×1.2 (laser jen), OVERDRIVE = dluh až 25 % genMax (bez pauzy dobíjení), GAMBLER bez laseru, REARGUARD/odražené střely se navádějí.
- Endless boss drop se ohlásí jen zprávou ve hře (`+ NAME`), ne kartou.
- Dron SATELLITE kreslí `drone` sprite, jinak zmenšený `boss_turret` skinu.

Zbývá v kroku 1:
- **Ovládání HANGAR/VAULT padem a klávesnicí** (desktop/Steam Deck) — dnes jen tap/myš. `LoadoutCursor` region `hangar`/`vault` podle §6.
- Ověření na zařízení: výkon 3×3/HYDRA sestav (iPhone 12 mini, Pixel 6a), čitelnost, balanc čísel (krok 2 = 3.9.1).
