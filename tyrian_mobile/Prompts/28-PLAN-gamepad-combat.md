# 28 — PLÁN: Gamepad combat — SIGILY (pravá páčka kreslí bojový systém)

**Jen linie 3.x (`main`).** Do `release/2.9.x` se z tohohle plánu neportuje nic.

Cíl jednou větou: levá páčka letí, pravá páčka **kreslí sigily** na neviditelné mřížce 3×3
(zámek z Androidu převedený na analog), triggery jsou dva analogové pedály palby, shouldery
přepínají, **čím** se sigil provede — a celé to platí jeden generátor.

**Jen desktop (rozhodnuto 2026-11-10): sigily na mobilu nebudou.** Na telefonech a tabletech
zůstává dnešní dotykové ovládání beze změny; nastavení schématu se tam vůbec neukáže.

Dokument je psaný pro implementační session (Opus). Navazuje na `25-ROADMAP-tyrian-dos-gaps.md`
(twiddly, sidekicky) a `27-PLAN-mods-hulls-forge.md` (mody, trupy). Zdroj combo systému je repo
**OrbitronTactics** (`lib/core/maneuvers/`, `Prompts/08-PLAN-maneuvers.md`) — tam je to swipe
prstem po 3×3 bodech; tady se totéž kreslí páčkou. Návazný plán výuky a videí: `29-PLAN-sigil-training-and-video.md`.

---

## 0. Fakta z kódu, na kterých plán stojí (ověřeno 2026-11-10 na `main`, 3.9.2)

| Věc | Kde | Důsledek pro plán |
|---|---|---|
| Pad se čte přes MethodChannel `com.tyrian/gamepad`, jen desktop | `lib/input/gamepad_input.dart` | `GamepadState` už má `lx/ly/rx/ry`, `a/b/x/y`, `lb/rb`, `lt/rt` 0–1, dpad, start, back. **Pravá páčka, LT, LB, A/X/Y, dpad a back jsou ve hře nevyužité.** |
| Střelba = `buttonB \|\| rightShoulder \|\| rightTrigger > 0.05`, `fireRate` = analog RT | tamtéž | RT kadence už existuje. B a RB se uvolní (viz §3, schéma `classic` je zachová). |
| Nativní pluginy: macOS GameController (`back` natvrdo `false`), Windows XInput, Linux `/dev/input/js` | `macos/Runner/GamepadPlugin.swift`, `windows/runner/gamepad_plugin.cpp`, `linux/runner/gamepad_plugin.cc` | L3/R3 ani vibrace se neposílají. Plán je **nepotřebuje**; `back` na macOS se opraví v kroku 1. |
| Vstup se zpracovává v `_processDesktopInput(dt)`, pad má přednost před klávesnicí, pohyb jde přes `_applyMovement` (násobí `v.agility`, řeší landscape rotaci) | `lib/game/tyrian_game.dart` ~1177 | Jediné místo, kam se sigily napojí. Rozpoznávač musí počítat s **časem (dt)**, ne s počtem vzorků. |
| Klávesnice: WASD/šipky, Space = palba, Esc = pauza | `lib/input/keyboard_input.dart` | Numpad a okolní klávesy jsou volné → fallback v §12. |
| Generátor: `genMax 100`, dobíjí `genPower(4) × dt × originalFps(40)` ≈ **160 j/s**, tedy z nuly za ~0,6 s | `lib/entities/vessel.dart` | Generátor je **omezovač průtoku, ne zásobník**. Sigily proto nemůžou stát „kus generátoru“ — potřebují vlastní zásobník (§6). |
| `_fullGenTime` už měří, jak dlouho je generátor plný (mod SURGE) | `vessel.dart` ~969 | Přebytek generátoru je měřitelný → z něj se plní NÁBOJ. |
| Zbraň platí `pwrNeed` z `genValue`, kadence = `cooldown / fireRateMult` | `lib/systems/device.dart:157` | OVERSTREAM se napojí sem a do `ShotPlan`, nikam jinam. |
| `ShotPlan.of(device, fx)` skládá `streams` (max 4), `fan`, `salvo`, `pwrNeed`, `cooldown`; strop `maxLiveShots 360` | `lib/systems/mods/shot_plan.dart` | Střely ze sigilů i companionů jdou přes `ShotPlan` → mody platí automaticky. |
| Zásah hráče má tři vstupy: střely (`_updateEnemyProjectiles` → `tryReflect` → `takeDamage`), náraz (`hostile.dart:358`), asteroid (`structure.dart:141` → `hitByAsteroid`) | — | Nezranitelnost se řeší v `Vessel` (vzor `_ghostTimer`), u střel **před** `tryReflect`. |
| Zpomalení času existuje: `game.startTimewarp(scale, seconds)` → `enemyTimeScale` | `tyrian_game.dart` | Sigil TIMEWARP i tréninkové slow-mo (plán 29) stojí na hotovém primitivu. |
| Dron existuje jako čtvrté zařízení `satellite` (`_syncSatellite`, `satellitePos`), kopíruje přední zbraň × `modSatelliteDmg` | `vessel.dart` ~494 | Companioni jsou zobecnění téhož; art dronů pro skiny je z hull pilotu. |
| Skóre se přičítá na jednom místě `Vessel.addScore` | `vessel.dart` ~1188 | FLOW násobič patří sem, ne ke čtyřem místům `Challenge`. |
| Žebříček je jen Game Center (iOS **a macOS** sdílí `kiran_topscore`) a Play Games; Windows a Linux, tedy Steam, žádný nemají; Steamworks SDK ve hře není | `lib/services/leaderboard_service.dart` | Hráč se sigily na Macu by soutěžil v jedné tabulce s dotykem na iPhonu → §6.2 a otázka č. 7. |
| Co-op: klient `Vessel.update` hned vrací, stav nese `VesselSnap`, `protocolVersion = 4` | `lib/net/protocol.dart` | Nový stav = verze 5 (§13). Do té doby jsou sigily v co-opu vypnuté. |
| `Challenge` násobí HP/damage/kadenci/skóre na čtyřech místech, `normal` = 1,0 = parita | `lib/game/challenge.dart` | **Žádné páté místo.** Kdo sigily nepoužívá, hraje přesně dnešní hru. |
| Menu si pad čtou sama (`_pollGamepad`), existuje `ui/loadout_cursor.dart` | `main.dart`, `ui/com_center.dart`, `ui/campaign_*.dart` | Grimoár (§10) použije stejný vzor. |

---

## 1. Co svět zná — a co z toho skládáme

Nic z toho není nové samo o sobě. Nové je to pohromadě, na jedné páčce, ve střílečce.

| Co svět zná | Odkud | Co si bereme |
|---|---|---|
| Zámek 3×3, tah přes body | Android, OrbitronTactics | Mřížka a číslování bodů 0–8, zrcadlení, „mezibod se sebere sám“ |
| Motion inputy a numpad notace | bojovky (čtvrtkruh, půlkruh, 360) | Střed páčky = bod 4, okraj = osm bodů. Čtvrtkruh je `[1,2,5]`. |
| Triky pravou páčkou | Skate „Flick-it“ | Gesto = trik, žádné tlačítko k tomu |
| Twiddly placené štítem | Tyrian | Pravidlo „silný efekt stojí celý štít“ → MEGA BLAST |
| Kód na směrovkách pod tlakem | Helldivers stratagemy | Přivolání companionů gestem, zatímco letíš |
| Sud a looping | Star Fox | ROLL a LOOP s oknem nezranitelnosti |
| Options a formace | Gradius, Thunder Force | Vrstva WING |
| Graze | Psyvariar, Touhou | Střela těsně vedle = příjem NÁBOJE |
| Focus (pomalý přesný let) | Touhou | Tlačítko A |
| Nabíjená rána | R-Type | MEGA BLAST se drží a pouští |
| Styl za pestrost, stale moves | Tony Hawk, DMC, Smash | FLOW: opakovaný sigil nic nepřidá |
| Dva pedály | závodní hry | RT = jak rychle, LT = jak široce |

**Čtyři věci, které (pokud vím) pohromadě nikdo nemá** — před marketingovým „světový unikát“
udělat rešerši, tohle je tvrzení z hlavy, ne ověřený fakt:

1. Zámek 3×3 kreslený analogovou páčkou jako motion inputy ve vertikální střílečce.
2. Gramatika **tvar × vrstva**: tvar říká *co*, držený shoulder říká *čím*. Deset tvarů × tři
   vrstvy místo třiceti samostatných komb.
3. **Shoulder krade prst svému triggeru**: LB bere ukazovák z LT, RB z RT. Cena přepnutí vrstvy
   je fyzická, ne číslo v tabulce. Oba shouldery = nestřílíš vůbec = nabíjíš MEGA BLAST.
4. Dva analogové pedály (kadence × šířka proudu) proti jednomu generátoru, a jeho **přebytek**
   plní zásobník na sigily. Kdo uvolní palbu, šetří si na trik.

Právní rámec z plánu 25 platí: mechaniky ano, **cizí jména, texty a GPL kód nikdy**. Jména
sigilů jsou vlastní obecná slova.

---

## 2. Slovník

| Pojem | Význam |
|---|---|
| **Sigil** | Jedno gesto pravé páčky = jeden trik. Jméno je vlastní jméno, nepřekládá se. |
| **Tvar** | Posloupnost bodů mřížky, např. `[3,4,5]`. Jeden tvar má v každé vrstvě jiný sigil. |
| **Vrstva** | HULL (nic nedržíš), ARMS (držíš LB), WING (držíš RB). |
| **NÁBOJ** (`charge`) | Zásobník 0–100 na sigily. Plní ho přebytek generátoru, graze a zabití. |
| **OVERSTREAM** | Dvojitý / trojitý proud střel na LT, platí generátor. |
| **Graze** | Nepřátelská střela proletí těsně kolem trupu bez zásahu. |
| **Fáze** | Okno nezranitelnosti uvnitř sigilu; střela, která by zasáhla, se počítá jako *phase graze*. |
| **FLOW** | Řetěz různých sigilů za sebou; násobí skóre a příjem NÁBOJE. |
| **MEGA BLAST** | Nabíjená rána za štít a generátor (LB+RB). |
| **Companion** | Dočasný dron přivolaný sigilem z vrstvy WING. |
| **Grimoár** | Přehled sigilů ve hře (tlačítko Back) a stránka v ComCenteru. |

Identifikátory v kódu anglicky: `Sigil`, `SigilLayer { hull, arms, wing }`, `charge`, `flow`,
`graze`, `overstream`, `megaBlast`, `Companion`.

---

## 3. Mapování ovladače

Zásada: **palce patří páčkám**. Všechno, co se drží dlouho, je na ukazovácích. XYAB jsou jen
krátké a vzácné akce, protože palec při nich opouští pravou páčku. Směrový kříž není na výběr
ničeho — levý palec ve střílečce nesmí pustit pohyb.

| Vstup | Funkce | Druh | Poznámka |
|---|---|---|---|
| **LS** | Pohyb | analog | Beze změny (`_applyMovement`). |
| **D-pad** | Pohyb digitálně, 8 směrů | digitál | Pro arkádové hráče; sčítá se s LS a ořízne na 1. |
| **RS** | Kreslení sigilů | gesto | §4. Střed = klid. |
| **RT** | Palba, analogová kadence | pedál | Beze změny. Slabší stisk = pomalejší palba = generátor má přebytek = roste NÁBOJ. |
| **LT** | OVERSTREAM: do 25 % jeden proud, 25–85 % dvojitý, nad 85 % trojitý | pedál | Hystereze ±5 %. §7. |
| **LB** (drž) | Vrstva ARMS pro právě kreslený sigil | modifikátor | Ukazovák odchází z LT → během kreslení není overstream. |
| **RB** (drž) | Vrstva WING pro právě kreslený sigil | modifikátor | Ukazovák odchází z RT → během kreslení se nestřílí. |
| **LB + RB** (drž, pusť) | MEGA BLAST: držením nabíjí, puštěním pálí | akord | §8. RS při nabíjení míří. |
| **A** (drž) | FOCUS: pohyb ×0,45, viditelný hitbox, větší graze prstenec | stav | Palec je mimo RS → při focusu se nekreslí. Šetřicí režim. |
| **B** | BREAK: okamžitě ukončí běžící sigil nebo časovaný efekt | tap | Stojí 10 NÁBOJE. Umožní navázat další sigil. |
| **Y** | Další přední zbraň z hangáru; podržení 0,3 s = další boční pár | tap/hold | Prodleva výměny 0,5 s, cooldown nové zbraně startuje plný. |
| **X** | Přepnutí grimoáru I ↔ II (která varianta sigilu je na tvaru) | tap | Až budou varianty (krok 7), do té doby nic. |
| **Start** | Pauza | — | Beze změny. |
| **Back** | Grimoár: tahák s tvary; v single playeru pauzuje | — | macOS plugin dnes `back` neposílá → opravit. |
| **L3 / R3** | Nic | — | Kliknutí páčky při gestu je nehoda. Zůstává volné pro Steam Input. |

**Dvě schémata** v nastavení, `PadScheme { sigil, classic }`:

- `classic` = dnešní chování beze změny (B/RB/RT střílí, nic dalšího). Regresní pojistka.
- `sigil` = tabulka výše. Výchozí pro nové desktopové instalace 3.x; stávajícím hráčům se
  nabídne jednou dialogem (otevřená otázka č. 5).

Brána je jedna: `sigilsEnabled => platform.isDesktop && padScheme == PadScheme.sigil`
(a mimo co-op, §13). Všechno ze sigilů — NÁBOJ, OVERSTREAM, MEGA BLAST, HUD, grimoár — se
ptá jen jí. Na mobilu je vždy `false`, takže mobilní build se chová přesně jako dnes.

Všechna přiřazení žijí v **jednom** souboru `lib/input/pad_scheme.dart` (akce → vstup). Prohodit
LB/RB nebo dát MEGA BLAST na triggery je pak úprava jedné tabulky, ne hledání po kódu.
Levácké zrcadlení (`southpaw`: prohodí páčky i strany) je druhá tabulka ve stejném souboru.

---

## 4. Rozpoznávač: zámek 3×3 na páčce

### 4.1 Mřížka

```
 0 1 2      ↖ ↑ ↗
 3 4 5  =   ← ● →      bod 4 = páčka ve středu
 6 7 8      ↙ ↓ ↘      ostatní = osm výsečí po 45° na okraji
```

Číslování je shodné s OrbitronTactics, aby šly sdílet glyfy i hlava hráče.

### 4.2 Zóny (všechny hodnoty do `game_config.dart`)

| Konstanta | Hodnota | Význam |
|---|---|---|
| `sigilCenterEnter` / `sigilCenterLeave` | 0,30 / 0,42 | Střed s hysterezí (drift páčky nesmí začít gesto) |
| `sigilRimEnter` / `sigilRimLeave` | 0,70 / 0,62 | Okraj; mezi středem a okrajem je přechodové pásmo, které nic nesbírá |
| `sigilSectorHysteresis` | 6° | Přechod mezi sousedními výsečemi |
| `sigilNeutralDwell` | 0,09 s | Jak dlouho musí páčka stát ve středu, aby gesto skončilo |
| `sigilMaxTime` | 1,2 s (dvojkruh 2,0 s) | Delší gesto se zahodí |
| `sigilFizzleLock` | 0,15 s | Pauza po nerozpoznaném tvaru |

### 4.3 Pravidla

1. Gesto **začíná** opuštěním středu a **končí** návratem do středu na `sigilNeutralDwell`.
   Návrat do středu je „zvednutí prstu“.
2. Průlet středem kratší než `sigilNeutralDwell` gesto neukončí — sebere **bod 4** jako mezibod.
   Tak vzniká tah `[3,4,5]` (zleva středem doprava).
3. Po okraji se body sbírají, jak páčka prochází výsečemi. Přeskočí-li rychlý pohyb jednu
   výseč, **doplní se sama** (stejné pravidlo jako mezibod u zámku).
4. Úvodní a závěrečný bod 4 se odřízne. Tvar je to mezi nimi.
5. Směr záleží. Zrcadlový tvar (vlevo ↔ vpravo) = zrcadlový sigil, pokud je `mirrorable`.
6. Kruh smí začít v kterékoli výseči — před porovnáním se pootočí na kanonický začátek.
7. Vrstvu určuje stav LB/RB **v okamžiku opuštění středu**; změna během gesta se ignoruje.
8. Shoda je přesná proti tvarům aktuální vrstvy. Z nich se staví **trie**: je-li nasbíraný
   tvar list (žádný delší tvar jím nezačíná), sigil se spustí hned, bez čekání na návrat.
   Jinak se čeká na pravidlo 1.
9. Nerozpoznaný tvar = *fizzle*: nic nestojí, krátký zvuk, `sigilFizzleLock`.
10. Tvar rozpoznán, ale chybí NÁBOJ = *dry*: bliknutí měřáku, žádná pauza.
11. **Buffer:** sigil dokreslený v posledních 30 % běžícího sigilu se zařadí a spustí hned po
    něm. Dřív nakreslený se zahodí (jinak by se hra hrála sama).

### 4.4 Tvary použitelné na páčce

Na dotyku jde skočit odkudkoli kamkoli; páčka se vždy vrací přes střed nebo po okraji. Tvary
„koněm“ z OrbitronTactics (`feint [0,7,2]`, `roll [1,5,7,3]`) se proto **nepřebírají**.

| Třída | Příklad | Jak se dělá | Obtížnost |
|---|---|---|---|
| Švih | `[5]` | Ťuknutí páčkou do směru a zpět | 1 |
| Tah středem | `[3,4,5]` | Natáhnout vlevo, švihnout přes střed vpravo | 2 |
| Čtvrtkruh | `[1,2,5]` | Nahoru a po okraji doprava | 3 |
| Půlkruh | `[3,0,1,2,5]` | Zleva horem doprava (nebo spodem) | 3 |
| Kruh | `[1,2,5,8,7,6,3,0]` | Celé kolo, kterýmkoli směrem | 4 |
| Zet | `[0,1,2,4,6,7,8]` | Horní hrana, šikmo středem, spodní hrana | 5 |
| Dvojkruh | 2× kruh | Dvě kola bez zastavení | 5 |

### 4.5 Kód

Čisté jádro bez Flame a bez Flutteru (pravidlo z games.md), `lib/systems/sigils/`:

- `stick_reader.dart` — `(x, y, dt)` → události `enter(dot)`, `neutral`.
- `sigil_recognizer.dart` — trie, kanonizace kruhu, zrcadlení, fizzle/dry, buffer.
- Vstupem je jen proud vzorků; stejné jádro později nakrmí i numpad (§12).
- Testy z **nahraných stop** páčky (`test/support/stick_traces/*.json`: seznam `t,x,y`),
  včetně rozklepané, pomalé a přestřelené varianty každého tvaru.

---

## 5. Katalog sigilů

Stejný tvar znamená ve všech vrstvách **totéž gesto mysli**: tah dopředu je útok (trup vyrazí,
zbraně vypálí, wing vyletí), tah dozadu obrana, kruh „všude kolem“. Hráč se učí deset tvarů,
ne dvacet šest komb. Zrcadlitelné sigily mají i levou/pravou verzi (v tabulce jedna).

Ceny jsou v NÁBOJI (0–100), časy v ms, *fáze* = okno nezranitelnosti jako podíl délky.
Čísla HULL vrstvy vycházejí z vyladěných hodnot OrbitronTactics.

### 5.1 HULL — nic nedržíš, pohybuje se trup

| Sigil | Tvar | ms | Cena | Fáze | Co udělá |
|---|---|---|---|---|---|
| HOP | švih, 8 směrů | 250 | 12 | — | Poposkočení o 1,5 šířky lodi daným směrem |
| SIDESTEP | `[3,4,5]` | 500 | 25 | — | Dlouhý úkrok přes 40 % šířky pole |
| STRIKE | `[7,4,1]` | 900 | 35 | — | Výpad vpřed se třemi ranami, návrat |
| RETREAT | `[1,4,7]` | 700 | 20 | — | Ústup dozadu s krycí palbou |
| DASH | `[6,4,2]` | 1000 | 40 | 0,20–0,50 | Šikmý průlet skrz střely |
| ROLL | `[1,2,5]` | 700 | 30 | 0,15–0,65 | Sud do strany |
| SHADOW | `[3,0,1,2,5]` | 2000 | 45 | — | Zavěsí se pod nejbližší cíl, kopíruje jeho pohyb do stran a pálí; LS řídí jen výšku |
| ECHO | `[3,6,7,8,5]` | 4000 | 45 | — | Stínový dvojník přehraje tvé poslední 2 s pohybu i palby (50 % dmg); řízení zůstává |
| LOOP | kruh | 1800 | 50 | 0,25–0,55 | Looping přes vršek; střely proletí pod lodí |
| SLALOM | zet | 1600 | 45 | — | Esíčko polem s vějířovou palbou |
| CORKSCREW | dvojkruh | 1500 | 50 | 0,30–0,70 | Vývrtka vpřed s palbou dokola |

„Shadow movements“ ze zadání pokrývají dva sigily: SHADOW (stínuješ nepřítele) a ECHO (stín
kopíruje tebe; technika je hotová v perku `afterimage` trupu Dart). Otevřená otázka č. 2.

### 5.2 ARMS — držíš LB, mluví zbraně a časované efekty

| Sigil | Tvar | Trvání | Cena | Co udělá |
|---|---|---|---|---|
| SNAPSHOT | švih, 8 směrů | — | 10 | Jedna rána přední zbraně daným směrem |
| BROADSIDE | `[3,4,5]` | — | 25 | Salva do obou boků |
| VOLLEY | `[7,4,1]` | — | 40 | Nabitý vějíř pěti paprsků vpřed |
| REARGUARD | `[1,4,7]` | 4 s | 20 | Mina za lodí |
| OVERDRIVE | `[1,2,5]` | 3 s | 35 | Cooldown zbraní ×0,6; řízení zůstává |
| TIMEWARP | `[3,0,1,2,5]` | 2,5 s | 50 | Nepřátelé a jejich střely na 50 % rychlosti (`startTimewarp`) |
| AEGIS | `[3,6,7,8,5]` | 3 s | 40 | Štít se dobíjí ×4 a nepropustí zásah do trupu |
| RADIAL | kruh | — | 55 | Prstenec 16 střel přední zbraně |
| STORM | dvojkruh | 4 s | 70 | Všechny zbraně pálí naplno bez placení generátoru |

Časované efekty („time span effects“) mají na HUD vlastní odpočet (§11). Nejvýš jeden od
každého; nový stejný jen obnoví čas. BREAK (B) je umí předčasně ukončit.

### 5.3 WING — držíš RB, velíš companionům

| Sigil | Tvar | Cena | Co udělá |
|---|---|---|---|
| PING | švih, 8 směrů | 5 | Companioni soustředí palbu daným směrem na 2 s |
| WINGMAN | `[3,4,5]` | 40 | Přivolá doprovod na ten bok (zrcadlově na druhý) |
| LANCER | `[7,4,1]` | 40 | Přivolá stíhače, který letí před tebou a loví |
| WARDEN | `[1,4,7]` | 40 | Přivolá strážce za loď; tělem chytá střely |
| FORMATION | `[1,2,5]` | 10 | Přepne rozestup: do šířky ↔ do klínu |
| ORBIT | kruh | 35 | Companioni 3 s krouží kolem lodi a žerou střely |
| SACRIFICE | `[3,6,7,8,5]` | 0 | Companioni vyletí a vybuchnou; vrátí 15 NÁBOJE za kus |

Pravidla companionů: nejvýš **2 ze sigilů** současně (dron z modu SATELLITE nebo trupu
Colossus se nepočítá a zůstává). Životnost 20 s nebo 3 zásahy. Střílí plánem boční zbraně
přes `ShotPlan` × `companionDmg` (start 0,5). Třetí přivolání nahradí nejstaršího.

### 5.4 Model

Port (ne import) modelu z OrbitronTactics do `lib/systems/sigils/`:

```dart
class SigilSpec {
  final String id;            // 'loop'
  final SigilLayer layer;
  final List<int> shape;      // dots 0-8
  final bool mirrorable;
  final int durationMs, cost;
  final Keyframes? path;      // hull motion, null = ship stays under player control
  final List<FireCue> fire;   // (t, shots, spread, damageMul) through ShotPlan
  final (double, double)? phase;   // untouchable window, fractions of duration
  final SigilControl control; // none | full | verticalOnly
  final SigilEffect? effect;  // timed effect, spawn, command
  final int tier;             // 1-5, drives unlock order and the curriculum in plan 29
}
```

`SigilRun { spec, mirrored, startedAt, origin, firedCues }`, `poseAt(progress)` vrací posun
proti `origin`; `Vessel` ho aplikuje přes `adjustPosition`, takže loď nikdy neopustí pole.
Katalog je **jedna tabulka** `sigil_catalog.dart`; HUD, grimoár, testy i plán 29 čtou z ní.

---

## 6. Ekonomika: tři měřáky, jeden zdroj

| Měřák | Platí | Plní se |
|---|---|---|
| **Generátor** (dnešní) | palbu, OVERSTREAM | sám, ~160 j/s |
| **NÁBOJ** (nový, 0–100, start 50) | sigily, BREAK | přebytkem generátoru, grazem, zabitím |
| **Štít** (dnešní) | MEGA BLAST | sám, když generátor není na nule |

### 6.1 Příjem NÁBOJE

- **Přebytek generátoru:** co by generátor dobil nad `genMax`, jde do NÁBOJE:
  `charge += surplus × chargePerGen`. S `chargePerGen = 0,075` dá plný přebytek 160 j/s
  **+12/s** (hodnota z OrbitronTactics). Kdo drží RT a LT na podlaze, má přebytek nula.
- **Graze:** střela mine trup do `grazeRadius` (= poloměr hitboxu × 2,2; při FOCUSu × 2,9):
  **+2**, jednou za střelu (příznak na `Projectile`).
- **Phase graze:** střela by zasáhla, ale loď je ve fázi: **+6**, jednou za střelu.
- **Zabití během sigilu** (od startu do 0,5 s po konci): **+5**.

Důsledek pro pocit ze hry: analogová kadence na RT konečně k něčemu je. Ubrat palbu = nabíjet.

### 6.2 FLOW

- Každý úspěšný sigil **jiný než dva předchozí**, spuštěný do 2,5 s od konce minulého: FLOW +1
  (strop 9). Stejný sigil znovu: nic (stale). Zrcadlová verze se počítá jako tentýž sigil.
- Zásah do trupu FLOW vynuluje. Zásah do štítu ne. Po 2,5 s bez sigilu klesá o 1 za sekundu.
- FLOW dává: skóre ×(1 + 0,1 × FLOW) v `Vessel.addScore`, příjem NÁBOJE +5 % za stupeň.
- Na HUD jako písmeno D–S. FLOW je hlavní metrika dovednosti pro plán 29.

FLOW násobič **není** páté místo `Challenge` — je to vlastnost hráče jako `mods.scoreMul` a
sedí vedle něj.

Žebříček: na macOS se skóre hry se sigily posílá do **vlastních tabulek** (`kiran_topscore_pad`,
`kiran_deepest_pad`), ne do sdílených s iPhonem — jinak by pad a sigily přeskákaly dotyk.
Tabulky založí uživatel v App Store Connect; než budou, submit tiše selže jako dnes u
nezaložené tabulky. Windows a Linux žebříček nemají (otázka č. 7).

---

## 7. OVERSTREAM — dvojitý a trojitý proud na LT

| Stupeň | LT | Proudy | Cena střely |
|---|---|---|---|
| 1 | < 25 % | podle modů | ×1,0 |
| 2 | 25–85 % | +1 | ×2,1 |
| 3 | > 85 % | +2 | ×3,3 |

- V `ShotPlan.of` přibude parametr `gear`: `streams = min(fx.streams + gear − 1, maxStreams + 2)`,
  `pwrNeed ×= overstreamCost[gear]`. Rozestup proudů hlídá dál `minStreamGap`, počet střel
  `maxLiveShots`.
- **Limit je generátor, ne časovač.** Bubble gun bere ~53 j/s → trojitý proud (~176 j/s) jede
  skoro trvale. Vulcan bere ~213 j/s už sám → dvojitý vydrží jen dávku a zadrhává. Lepší
  generátor, mody COIL/CELL a trup Dynamo posouvají hranici. Tím má OVERSTREAM smysl jako
  důvod k výbavě, ne jako tlačítko „víc“.
- Mírně nadlineární cena je záměr: široký proud je pohodlí a pokrytí, ne zadarmo DPS.
- Platí jen pro přední zbraň. Boční zbraně a companioni jedou dál po svém.
- Stupeň 2 a 3 nedávají přebytek → neroste NÁBOJ. Hráč volí mezi šířkou teď a sigilem potom.

---

## 8. MEGA BLAST — oba shouldery

1. Drž **LB + RB**. Po 0,25 s začne nabíjení (do té doby jde o překlep, nic se neděje).
2. Nabíjení trvá až 1,2 s a **vysává štít**, po něm generátor. Oba ukazováky jsou mimo
   triggery, takže loď nestřílí — to je ta cena.
3. RS při nabíjení míří (výchozí směr vpřed). LS dál letí.
4. Puštěním kteréhokoli shoulderu rána vyletí:
   `dmg = megaBase + štítVysátý × megaShieldDmg + genVysátý × megaGenDmg`.
   Paprsek šířky podle nabití; **ruší nepřátelské střely** ve své dráze.
5. Po ráně: generátor 1,5 s nedobíjí, štít zůstane, kde skončil (při plném nabití nula).
6. Minimum pro výstřel je 25 % štítu; pod tím se nabíjení nespustí (*dry*).
7. Bossové berou `megaBossShare` (vzor `modNovaBossShare`).

Je to Tyrianovo pravidlo „silný efekt stojí celý štít“ spojené s nabíjením z R-Type. Liší se
od modu NOVA: ta je pasivní, kruhová a spouští ji prolomený štít. Obojí smí existovat zároveň.

„Trigger mega blast“ ze zadání čtu jako *spuštění*. Kdyby mělo jít doslova o triggery
(LT + RT na podlahu), je to jedna změna v `pad_scheme.dart` — otevřená otázka č. 1.

---

## 9. Nezranitelnost, focus, výměna zbraní

**Fáze.** `Vessel.untouchable` (getter nad běžícím `SigilRun`) se kontroluje na třech místech:

- `takeDamage` — hned vedle `_ghostTimer`;
- `hitByAsteroid` — stejně;
- `_updateEnemyProjectiles` — **před** `tryReflect`: střela se nespotřebuje, letí dál a započte
  se phase graze. Jinak by odraz „sežral“ střely, které mají proletět pod lodí.

Žádné okno není delší než 0,6 s (pravidlo z OrbitronTactics je 0,5 s; LOOP a CORKSCREW mají
výjimku). Mezi dvěma fázemi je povinná mezera `phaseGap = 0,4 s`, i přes buffer a BREAK —
jinak jde nezranitelnost řetězit donekonečna.

**Během sigilu** s `control: none` se LS ignoruje; štít, RT i LT fungují dál. Loď při LOOPu
roste na 1,35× a vrhá stín — nezranitelnost musí být vidět, ne jen platit.

**FOCUS (A).** Rychlost ×0,45 v `_applyMovement`, vykreslí se hitbox a graze prstenec.
Žádná cena. Nejde kombinovat s kreslením (palec), takže je to čistě „sbírám NÁBOJ grazem“.

**Výměna zbraně (Y).** Prohodí přední `Device` s další přední zbraní v `vessel.hangar`
(podržení: boční pár). Mody jsou na rackách podle `RackKind`, takže přejdou samy. Výměna trvá
0,5 s a nová zbraň začíná s plným cooldownem. Prázdný hangár = tlačítko nic nedělá.

---

## 10. Výbava, odemykání, grimoár

- **Tvar je slot.** Na jednom tvaru v jedné vrstvě je vždy právě jeden sigil. Později přibudou
  **varianty** (např. na kruhu v HULL místo LOOP sigil VORTEX); grimoár I a II jsou dvě sady
  voleb a přepíná je X. Ve verzi 1 varianty nejsou a X nic nedělá.
- **Odemykání podle `tier`:** tier 1 (švihy) a tier 2 (tahy středem) od začátku, vyšší za
  postup kampaní a za zkoušky v tréninkové aréně (plán 29). **Nikdy** za skin ani za peníze —
  roadmapa 25 už pojmenovala riziko pay-to-win (její otázka č. 2).
- **Úrovně sigilu** L2/L3 jako v OrbitronTactics (levnější, delší fáze, rána navíc) kupované
  za kredity v ComCenteru. Až v kroku 7; do té doby má každý sigil jednu úroveň.
- **Grimoár ve hře (Back):** překryv se třemi sloupci podle vrstev, u každého sigilu glyf 3×3,
  jméno, cena. Zamčené jsou vidět šedě i s podmínkou. V single playeru pauzuje.
- **Grimoár v ComCenteru:** nová stránka vedle HANGAR/VAULT, ovládaná `loadout_cursor`.
  Odtud vede vstup do tréninkové arény (plán 29).

---

## 11. HUD a zpětná vazba

Uvnitř plátna jen Flame komponenty (žádné widgety). Vše má být čitelné koutkem oka.

| Prvek | Kde | Chování |
|---|---|---|
| **Sigil pad** | roh u pravého palce (portrait vpravo dole) | 9 teček, kurzor = poloha páčky, sebrané body svítí a spojuje je čára. Barva = vrstva (HULL tyrkys, ARMS jantar, WING zelená). |
| Jméno sigilu | nad padem | Vyskočí při rozpoznání; *fizzle* a *dry* mají vlastní krátký stav |
| NÁBOJ | prstenec kolem padu | Zářezy po cenách nejbližších sigilů |
| OVERSTREAM | u měřáku generátoru | 1–3 čárky; bliká, když generátor nestíhá |
| Časované efekty | oblouky kolem lodi | Jeden oblouk na efekt, ubývá s časem |
| FLOW | u skóre | Písmeno D–S, pulz při zvýšení |
| MEGA BLAST | kolem lodi | Kruh se plní, jak ubývá štít |
| Fáze | loď | Zvětšení, stín, lehký obrys; phase graze cinkne |
| Graze | u trupu | Jiskra a tichý tik; při FOCUSu viditelný prstenec |

Zvuk jen přes `just_audio` a `SoundService`. Nové zvuky (rozpoznání, fizzle, dry, graze, nabíjení,
výstřel MEGA BLASTu) se přidají do skinu `default`; ostatní skiny na něj spadnou fallbackem.

Vibrace jsou příjemné, ale nepovinné: nativní pluginy je dnes neumí. Samostatný krok 9.

---

## 12. Klávesnice, Steam Deck, Steam Input

**Klávesnice** (stejné jádro, jiný zdroj bodů):

| Akce | Klávesa |
|---|---|
| Sigil | Numpad 1–9 jako mřížka (7 8 9 nahoře); bez numpadu blok `U I O / J K L / M , .` |
| ARMS / WING | levý Shift / levý Ctrl (oba = MEGA BLAST) |
| OVERSTREAM | `Q` ubere stupeň, `E` přidá (digitálně, bez pedálu) |
| FOCUS / BREAK | levý Alt / `F` |
| Zbraň / grimoár | `R` / `Tab` (tahák: `G`) |

Na klávesnici se body mačkají **postupně**; gesto končí 0,25 s po poslední klávese. Před
zapojením ověřit kolize s tím, co už `KeyboardHandler` a menu používají.

**Steam Deck / Steam Input.** Hra čte XInput, GameController a `/dev/input/js`; Steam Input
jiné ovladače překládá na Xbox pad, takže není co implementovat. Navíc:

- Oficiální konfigurace ovladače ve Steamworks: zadní páčky Decku L4 = LB+RB (MEGA BLAST),
  R4 = A (FOCUS) — focus pak jde držet bez puštění pravé páčky. Nahrání je akce uživatele.
- Glyfy tlačítek **podle polohy** (kosočtverec čtyř teček, jedna plná), ne písmena A/B/X/Y.
  Hra neví, jaký pad drží hráč v ruce, a kosočtverec sedí na Xbox, PlayStation i Switch.
- Text `padControlsHint` v ARB se přepíše pro schéma `sigil`; `classic` si nechá dnešní.

---

## 13. Co-op

- Do kroku 8 platí pojistka: `coopRole != none` → sigily, OVERSTREAM a MEGA BLAST vypnuté
  u obou hráčů, schéma se chová jako `classic`. Nic se nerozbije po cestě.
- Krok 8: `VesselSnap` dostane `sigil` (index v katalogu, 0 = nic), `sigilT` (0–255),
  příznaky `mirrored`/`untouchable`/`focus`, `gear`, `charge`, `flow` a až 3 companiony
  (`type, x, y`). `protocolVersion = 5`; starší verze se odmítne stejně jako dnes.
- Druhý pad (`gamepadInput.secondary`) dostane stejné schéma. Každý hráč má vlastní NÁBOJ a FLOW.
- TIMEWARP v co-opu zpomalí nepřátele oběma — je to stav hry, ne lodi.

---

## 14. Save, l10n, konfigurace

- `SaveService`: `padScheme`, `southpaw`, odemčené sigily, úrovně, grimoár I/II. Chybějící
  klíč = výchozí hodnota; žádná migrace starých savů není potřeba.
- ARB: popisy sigilů, nápovědy, nastavení ve všech 15 jazycích. **Jména sigilů se nepřekládají**
  (LOOP je LOOP i v japonštině) — jeden klíč méně na sigil a videa z plánu 29 sdílí titulky.
- Všechny laditelné hodnoty (zóny, ceny, časy, násobiče) v `game_config.dart` nebo
  v `sigil_catalog.dart`. Nikde jinde žádné číslo.

---

## 15. Testy

| Soubor | Co hlídá |
|---|---|
| `test/sigil_recognizer_test.dart` | Každý tvar ze stop páčky (čistá, rozklepaná, pomalá, přestřelená); zrcadlení; kruh z libovolného začátku; doplnění přeskočené výseče; fizzle; trie spouští list okamžitě |
| `test/sigil_catalog_test.dart` | V jedné vrstvě žádné dva stejné tvary; žádný tvar „koněm“; fáze ≤ 0,6 s; každý sigil má ARB popis |
| `test/sigil_run_test.dart` | `poseAt` je deterministická; loď neopustí pole; fire cue vystřelí právě jednou; `phaseGap` drží i přes buffer a BREAK |
| `test/charge_test.dart` | Přebytek → +12/s; graze jednou za střelu; phase graze; ceny; dry |
| `test/overstream_test.dart` | `ShotPlan` pro stupně 1–3 s mody i bez; strop proudů; cena |
| `test/mega_blast_test.dart` | Škálování vysátým štítem; minimum 25 %; zámek generátoru; podíl na bossech |
| `test/untouchable_test.dart` | Všechny tři vstupy zásahu; střela ve fázi přežije a letí dál |
| `test/pad_scheme_test.dart` | `classic` = bit po bitu dnešní chování; `southpaw` zrcadlí; mimo desktop je `sigilsEnabled` vždy `false` |
| stávající paritní testy | Beze změny zelené: bez vstupu sigilů je hra shodná s dneškem |

Gate před každým pushem: `flutter analyze`, `flutter test`.

---

## 16. Pořadí dodávky (každý krok = PR + tag)

Číslování navazuje na minor, který bude v době implementace volný (dnes je venku 3.9.2).
Každý krok je hratelný sám o sobě a nic nerozbíjí: schéma `classic` a co-op pojistka drží
po celou dobu.

| Krok | Obsah | Hotovo, když |
|---|---|---|
| 1 | `pad_scheme.dart`, `PadScheme` v nastavení, `stick_reader`, `sigil_recognizer`, sigil pad na HUD (jen ukazuje rozpoznaný tvar), oprava `back` na macOS, d-pad pohyb | Na padu jde nakreslit všech sedm tříd tvarů a HUD je pojmenuje; `classic` beze změny |
| 2 | NÁBOJ, graze, fáze na třech vstupech zásahu, HULL tier 1–4: HOP, SIDESTEP, STRIKE, RETREAT, DASH, ROLL, LOOP | LOOPem jde proletět salvou bez zásahu a phase graze vrací NÁBOJ |
| 3 | OVERSTREAM na LT, FOCUS na A, výměna zbraně na Y | Bubble gun drží trojitý proud, vulcan zadrhává; ubrání RT viditelně plní NÁBOJ |
| 4 | Vrstva ARMS + časované efekty + MEGA BLAST | Všech 9 ARMS sigilů; MEGA BLAST škáluje štítem a ruší střely |
| 5 | Vrstva WING + `Companion` | Dva companioni, formace, ORBIT, SACRIFICE; dron z modu běží vedle |
| 6 | SHADOW, ECHO, SLALOM, CORKSCREW, FLOW, BREAK, buffer | FLOW S jde udržet 10 s; `phaseGap` nejde obejít |
| 7 | Odemykání, úrovně L2/L3, grimoár (Back + ComCenter), varianty a X | Nový save začíná s tier 1–2; grimoár jde celý ovládat padem |
| 8 | Co-op: `VesselSnap` + `protocolVersion 5`, druhý pad | Dva hráči vidí navzájem své sigily a companiony; pojistka z §13 pryč |
| 9 | Klávesnice, vibrace (nativní pluginy), Steam Input konfigurace, průchod na Steam Decku | Celý katalog jde zahrát na numpadu; Deck ověřený na zařízení |

Kroky 1–3 dávají pocit ze hry a měly by jít ven rychle za sebou, aby šlo ladit zóny páčky na
skutečném ovladači dřív, než na nich vyroste 26 sigilů. **Krok 1 je pilot:** jestli se tvary
na páčce nekreslí dobře, mění se §4.4 a katalog, ne zbytek plánu.

Plán 29 (trénink, videa) se napojuje po kroku 2 — aréna potřebuje aspoň HULL vrstvu.

---

## 17. Otevřené otázky pro uživatele

Plán má u každé výchozí volbu, takže implementace na odpovědích nestojí.

1. **„Trigger mega blast“** — plán: akord LB+RB (ukazováky mimo triggery = nestřílíš = nabíjíš).
   Alternativa: LT+RT na podlahu. Co jsi myslel?
2. **„Shadow movements“** — plán má SHADOW (stínuješ nepřítele) i ECHO (stín kopíruje tebe).
   Který z nich má být ten hlavní, co se ukazuje v traileru?
3. ~~Mobil~~ — **uzavřeno 2026-11-10: sigily na mobilu nebudou.**
4. **Odemykání** — plán: kampaň + zkoušky v aréně, úrovně za kredity, nic za skiny. Souhlas?
5. **Výchozí schéma** pro stávající hráče s padem: nabídnout `sigil` dialogem, nebo přepnout rovnou?
6. **Výměna zbraně za letu (Y)** — sedí to k tomu, jak má Kirian působit, nebo zbraně jen v ComCenteru?
7. **Žebříček.** Plán: na Macu oddělené tabulky pro sigily (§6.2). Steam žebříček nemá vůbec —
   chceš kvůli tomu Steamworks leaderboards (nová integrace SDK), nebo Steam zatím bez žebříčku?
8. **Jména** SIGIL / NÁBOJ / FLOW / grimoár — bereš, nebo máš vlastní?
9. **Glyfy** podle polohy (kosočtverec) místo písmen — v pořádku i pro Steam stránku?

---

## 18. Ad absurdum (parkoviště, ne součást dodávky)

- **PARRY:** tap přesně v okamžiku zásahu vrátí střelu (stojí na hotovém `tryReflect`).
- **Tandemové sigily** v co-opu: oba hráči nakreslí stejný tvar do 0,5 s → společný efekt.
- **Sigil time:** na `Challenge.easy` se svět při kreslení zpomalí na 85 %.
- **Vlastní sigily:** hráč si v grimoáru nakreslí vlastní tvar pro existující efekt.
- **Bossové čtou sigily:** boss, který trestá opakování stejného triku (FLOW naruby).
- **Swap cancel:** výměna zbraně ruší cooldown jako pokročilá technika.
- **Gyro** na Steam Decku a DualSense jako třetí zdroj bodů mřížky.
- **Replay se stopou páčky:** nahrávka vstupu jako sdílitelný soubor (používá ji plán 29).
- **Hudba reaguje na FLOW:** `music_director` přidává vrstvy podle písmena.
