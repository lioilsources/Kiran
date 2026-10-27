# Roadmapa: co doplnit z původního DOS Tyrianu

Kirian je port TyrianVB (VB6, Tomáš Burian), a TyrianVB je sám o sobě *výsek*
DOS Tyrianu (Epic MegaGames, 1995; Tyrian 2000, 1999). Tenhle dokument
porovnává Kirian se skutečným Tyrianem a říká, co z něj stojí za to doplnit,
v jakém pořadí a co se naopak přebírat nemá.

Stav Kirianu je k 2026-10-01 (v3.6.1 + Campaign Mode kroky 1–3).

---

## 0. Co se smí převzít — právní rámec

Tohle rozhoduje, *jak* se věci z Tyrianu přebírají, a u placeného vydání na
Steamu to není detail.

| Co | Stav | Důsledek pro Kirian |
|---|---|---|
| **Herní mechaniky** (sloty, energie, sidekicky, twiddly, struktura levelů) | mechaniky nejsou chráněné | **přebírat volně** |
| **Grafika** (Daniel Cook) | CC-BY 3.0 od 2007 | použitelná s atribucí, ale Kirian má vlastní pipeline — nepotřebujeme ji |
| **Hudba** (Alexander Brandon) | uvolněná zdarma, bez jasné licence | nepoužívat, máme vlastní |
| **Kód OpenTyrian** | GPL-2.0-or-later | **nekopírovat ani řádek** — GPL by nakazila uzavřený Steam build |
| **Herní data** (levely, texty datacubů, příběh) | freeware 2004 = distribuce, ne otevřená licence | nepřebírat levely 1:1 ani text |
| **Jména** (Tyrian, Zica, Gencore, MicroCorp, Zinglon…) | copyright na text + značka | **vlastní názvy**, přesně jak už dělá App Store listing |

Pravidlo pro celý dokument: **přebíráme nápady a čísla jako referenci,
pojmenováváme a kreslíme sami.** Tabulky níže jsou proto reference pro
balancování, ne seznam věcí k přepsání do kódu.

---

## 1. Kirian dnes (inventář z kódu)

| Oblast | Co je |
|---|---|
| Loď | jedna („Puddle Jumper"), HP 125, štít 100, bez výběru lodě |
| Sloty | front gun, generator, left gun, right gun; sloty 4/6/7 (satellite, shield capacitor) **rezervované a prázdné** od VB6 |
| Zbraně | 4 front (Bubble, Vulcan, Blaster, Laser) + 4 side; 25 upgrade levelů, ×1,1 dmg / ×1,2 power |
| Generátor | 1 typ, upgrade ×1,255 |
| Štít / HP | rostou jen přes pickupy, nejsou zboží |
| Odemykání | tiery zbraní za kumulativní skóre (400k / 4M / 14M); v kampani za bosse |
| Nepřátelé | 12 typů, všechno varianty „falcon" + bouncer; **jediná nepřátelská zbraň** (bubble škálovaná podle dmg) |
| Pickupy | 7 typů (upgrade F/L/R, HP, štít, generátor, kredity) |
| Levely | 18 ručně psaných ~60s částí v 6 zónách → procedurální; boss každý 5. level od 10 |
| Kampaň | 20 uzlů, 4 skládaní bossové (turret → shield pod → thruster → cannon), povinné úkoly + hvězdy, vlastní save |
| Módy | endless roguelike run, kampaň, lokální co-op (LAN) |
| Obtížnost | **žádná volba**; jen koeficient po levelu 20 a handicap pro podvybavené |
| Příběh | žádný |
| Skiny | 24, mění celý vzhled + zvuk, ne mechaniku |
| Cheaty | skrytý panel v Com Centeru (MAX CREDITS, skok o sektor) |

---

## 2. Co má Tyrian a Kirian ne — po oblastech

Každá oblast: co Tyrian dělá, jak velká je díra, co konkrétně doplnit.

### A. Výbava a ekonomika — **největší díra**

Tyrian má čtyři zbraňové systémy a tři podpůrné, všechno jako zboží
v obchodě s cenou:

| Systém | Tyrian | Kirian |
|---|---|---|
| Front gun | **18 typů**, každý jiné chování | 4 |
| **Rear gun** | **12 typů**, každý se **dvěma režimy střelby** přepínanými klávesou (např. dozadu ↔ do stran) | **neexistuje** |
| **Sidekicky** (2 sloty L/R) | **30 typů**: buď auto-fire s hlavní zbraní, nebo manuální s **omezenou municí** (5–100 ran) | **neexistují** (sloty 6/7 rezervované) |
| Generátor | **6 tierů** (Standard MR-9 → Gravitron Pulse-Wave), výkon určuje, kolik zbraní utáhneš | 1, upgraduje se |
| **Štít** | **9 tierů** jako zboží, regeneruje; Solar Shield se dobíjí sám | jen pickupy |
| **Armor** (= HP) | neregeneruje; opravuje se **v obchodě za peníze** nebo z „armor ships", které sestoupí, když jsi kriticky dole | roste pickupy |
| Power level | zbraň má **úrovně 1–11**, každá mění *vzor střelby*, ne jen čísla | 25 úrovní, jen čísla |

**Chování zbraní, které Kirian vůbec nemá** (podle katalogu):
rozptyl do vějíře (Multi-Cannon), navádění (Guided Bombs), odraz od okrajů
(Wild Ball, RetroBall), průraz (SDF Main Gun, Zica Laser), plamenomet
s krátkým dosahem (Zica Flamethrower), pomalá střela s obřím výbuchem
(Banana Bomb), zmrazení nepřátel (Dragon Frost / Ice Blast), miny (Post-It
Mine, Minefield), rázová vlna do stran (Sonic Wave), nabíjení bez střelby
(Charge Cannon, Zica SuperCharger).

**Co doplnit:**

1. **Rear slot** s přepínačem dvou režimů. Kirian má v `Vessel` slot 4
   rezervovaný — přesně tohle místo.
2. **Sidekick slot(y)** se dvěma typy: auto (střílí s front gunem) a
   **muniční** (tlačítko, počítadlo, doplnění v obchodě). Sloty 6/7.
3. **Štít a generátor jako tiery v obchodě**, ne jen upgrade jednoho kusu.
4. **Oprava trupu za kredity** v Com Centeru — dává smysl ekonomice, protože
   dnes HP jen roste.
5. **Rozšíření katalogu zbraní o chování**, ne o čísla: vějíř, odraz, průraz,
   plamenomet, mrazení, miny, nabíjení. Každé nové chování = nový
   `Projectile` typ, ne nový řádek v tabulce.
6. **Zvážit přechod z 25 číselných úrovní na ~11 úrovní měnících vzor.**
   Tohle je největší designové rozhodnutí v celém dokumentu — mění pocit z
   upgradu z „o 10 % víc" na „teď to střílí jinak". Viz otevřené otázky.

### B. Lodě

Tyrian: **11 lodí k výběru** (Storm 5 000 → SuperCarrot 65 000), liší se
armorem a hlavně **twiddly** — speciálními schopnostmi na fighting-game
vstup (Dolů, Drž fire, Nahoru → Ice Blast), placenými štítem nebo armorem.
Každá loď 1–3 twiddly: Atom Bomb, Invulnerability, Repair System, Repulsor,
Protron Field, Mine Spray, Ice Blast, HotDog Blast, Spin Wave…

Kirian: jedna loď. **Ale má 24 skinů** — a skiny už mají každý vlastní
loď, nepřátele a zvuk.

**Co doplnit:** **speciální schopnost per skin**, aktivovaná gestem (mobil:
double-tap / podržení; desktop: tlačítko), placená štítem. Tím se ze skinů
stanou *lodě* bez nového výběrového menu — a přesně to dělají Tyrianovy
**Super Arcade módy**: každý kód dá jinou loď se dvěma speciály (Stormwind:
SandStorm + Flare; Ninja Star: Blade Field + Invulnerability; FoodShip:
Banana Bomb + Orange Shield). Kirian má tuhle strukturu už postavenou, jen
jí chybí ta mechanická polovina.

Výběr lodí podle armoru je druhotný; na mobilu by se tloukl se skiny.

### C. Nepřátelé a levely

| | Tyrian | Kirian |
|---|---|---|
| Typy nepřátel | stovky, per epizoda | 12 + skinová varianta |
| Nepřátelské zbraně | mnoho vzorů (cílené, vějíř, navádění, lasery, miny) | 1 (bubble) |
| Pozemní cíle | ano (věže, základny, přistávací plochy) | ne |
| Smrtící stěny | ano (Soh Jin, Windy — červené stěny, skalní oblouky) | ne |
| Headlights | Hard+ levely se zúženým výhledem | ne |
| Časově omezené úseky | ano (Ixmucane — jádro se otevírá na čas) | ne |
| Armor ships | sestoupí při kritickém HP, dropnou opravu | ne |
| Tajné levely | 6 v Ep1, 2 v Ep2, 1 v Ep3, 6 v Ep4; přes **level orb** z konkrétního nepřítele, nebo přes datacube | ne |
| Větvení | kampaň se větví (Ep3: Easy/Normal končí u Fleet, Hard+ pokračuje Tyrian X → Savara Y → New Deli) | lineární |
| Bonus levely | několik per epizoda | ne |

**Co doplnit** (v tomhle pořadí):

1. **Nepřátelské vzory střelby** — cílená střela, vějíř, pomalá naváděná,
   laser s varováním. Dnes se každý nepřítel chová stejně, liší se jen HP.
   Nejlevnější změna s největším dopadem na pocit ze hry.
2. **Tajné uzly v kampani** — mapa uzlů už existuje; přidat větve odemykané
   *level orbem* (drop z konkrétního nepřítele v části). Tyrianova mechanika
   „zničit ten správný kámen" se přenese 1:1 na úkoly uzlu.
3. **Smrtící stěny / pozemní cíle** jako nový typ `Structure` — Kirian má
   asteroidy, tohle je stejná třída s jiným chováním.
4. **Headlights** jako modifikátor obtížnosti (viz F).
5. **Armor ships** — záchranný mechanismus, dává smysl s opravou trupu za
   peníze (A4).

### D. Bossové

Tyrian: boss je **unikátní per level** (Assassin Ship, Great Stomach,
Gryphon, Rock Ship, Lava Core, Dreadnought, Vykromod, Pineapple Ship…).
Mechaniky, které se opakují: **subsystémové poškození** (armor praskne
u ~25 %, díly odpadnou, palebná síla *vzroste*), **slabá místa** označená
zelenými šipkami (Javiho Dreadnought), **časově omezený boss** (Ixmucane),
**opakující se boss** napříč epizodou (Z-29 Central Defense Ship,
claw-ship 3×), **transformace** ve finále.

Kirian: fázový boss (3 fáze podle HP) + skládaní kampaňoví bossové
s odstřelitelnými díly. **Struktura dílů už odpovídá** Tyrianu.

**Co doplnit:**
1. **Odpadnutí dílu zvedne agresi jádra** — dnes je to jen ztráta části;
   v Tyrianu je to riziko, ne úleva.
2. **Slabé místo** (zasažitelné jen v určité fázi / z určitého úhlu).
3. **Časový limit** na jeden boss (úkol uzlu `underTime` už existuje — jen
   ho spojit s fází bosse).
4. **Jeden opakující se boss** v kampani, který se vrací silnější — levné na
   obsah, drahé na dojem.

### E. Herní módy

| Mód | Tyrian | Kirian |
|---|---|---|
| Full Story | obchod + datacuby + větvení | kampaň (bez příběhu) |
| **Arcade** | **bez obchodu**, výbava jen z barevných podů od nepřátel, 1–2 hráči | endless je *s* obchodem |
| Super Arcade | 9 kódem odemčených lodí se speciály | — (viz B) |
| Super Tyrian | jen Atomic RailGun + twiddly, Lord of Game | — |
| Timed Battle | (T2000) | — |
| Destruct | artillery minihra, 2 hráči naráz, různá vozidla | — |
| Zinglon's Ale / Squadrons / Revenge | bonusové hry po epizodě | — |
| 2P | Dragonhead + Dragonwing se **spojí** do Steel Dragon; P2 sbírá sidekicky, 2+ stejné = jiný | co-op existuje, bez spojení |

**Co doplnit:**
1. **Arcade mód** = endless run bez Com Centeru, výbava jen z podů. Kirian už
   má pickupy pro F/L/R upgrade — chybí jen vypnout obchod a zahustit dropy.
   Levné, a je to *jiná hra* pro lidi, co nechtějí nakupovat.
2. **Timed battle** / score attack na čas — triviální nad endless.
3. **Spojení lodí v co-opu** — drahé, ale unikátní; až po ověření co-opu
   na PC.
4. Destruct a Zinglon: **nepřebírat**, jiná hra.

### F. Obtížnost — **chybí úplně**

Tyrian: Easy / Normal / Hard + skryté **Impossible** (Shift+G), **Suicide**
(Shift+]), **Lord of the Game** (L+O+R+D). Vyšší obtížnost = víc HP
nepřátel, víc střel za sekundu, Hard+ má **vlastní levely** a headlights.

Kirian: nic. Jen interní koeficient po levelu 20.

**Co doplnit:** tři viditelné obtížnosti (HP × / cadence × / drop ×) a jednu
skrytou odemykatelnou. Na Steamu je to očekávaná položka a recenzenti si
všimnou, když chybí. Kampaň: Hard+ přidá uzly (viz C2 větvení).

### G. Příběh a datacuby

Tyrian: **datacuby** sbírané v levelu, čtené mezi levely — briefingy, lore,
humor, **a spouštěče tajných levelů**. Hlavní nosič příběhu.

Kirian: nic. Kampaň má uzly s úkoly, ale bez důvodu, proč tam letíš.

**Co doplnit:** krátké **briefingy per uzel** (2–4 věty, vlastní text,
vlastní svět) + občasný sběratelský „cube" v části, který odemkne tajný uzel.
Levné na kód, drahé na psaní — ale kampaň bez textu je jen seznam úkolů.

### H. Konfigurace a QoL

Tyrian má: rychlost hry (Backspace+1), detail modes, jukebox, command-line
parametry, in-game cheaty (invincibility, auto-complete level, debug HUD
s FPS/počtem nepřátel), **Caps Lock + #** = doplnit sidekicky a opravit
armor.

Kirian má cheat panel. **Doplnit:** debug HUD (FPS, počet entit, část/vlna),
rychlost hry pro testování, a hlavně **jukebox** — hra má 24 × 5 themes,
hráči to budou chtít poslouchat.

---

## 3. Roadmapa — pořadí

Seřazeno podle poměru hodnota / náročnost a podle závislostí. S/M/L = dny /
týden / víc.

### Tier 1 — zapadá do dnešní architektury, viditelné hned

| # | Položka | Oblast | Náročnost | Závislost |
|---|---|---|---|---|
| 1 | **Obtížnost** Easy/Normal/Hard + skrytá | F | S | — |
| 2 | **Nepřátelské vzory střelby** (4–5 vzorů) | C1 | M | — |
| 3 | **Rear slot** + přepínač režimů | A1 | M | sloty jsou |
| 4 | **Štít + generátor jako tiery** v Com Centeru | A3 | S | — |
| 5 | **Oprava trupu za kredity** | A4 | S | — |
| 6 | **Arcade mód** (endless bez obchodu) | E1 | S | pickupy jsou |
| 7 | **Jukebox** + debug HUD | H | S | — |

### Tier 2 — nový obsah na existujících systémech

| # | Položka | Oblast | Náročnost | Závislost |
|---|---|---|---|---|
| 8 | **Sidekick sloty** (auto + muniční) | A2 | M | T1.3 |
| 9 | **Nová chování zbraní** (vějíř, odraz, průraz, plamenomet, mrazení, miny) | A5 | L | T1.3, T2.8 |
| 10 | **Speciál per skin** (twiddle gestem, placený štítem) | B | M | — |
| 11 | **Bossové: odpadnutí dílu = agrese ↑, slabé místo, časový limit** | D | M | kampaň 2–3 |
| 12 | **Tajné uzly** přes level orb + větvení mapy | C2 | M | kampaň mapa |
| 13 | **Briefingy per uzel** + sběratelské cuby | G | M (psaní L) | T2.12 |
| 14 | **Smrtící stěny / pozemní cíle** | C3 | M | — |

### Tier 3 — velké designové změny, rozhodnout zvlášť

| # | Položka | Oblast | Náročnost | Poznámka |
|---|---|---|---|---|
| 15 | **Power levels 1–11 měnící vzor** místo 25 číselných | A6 | L | mění balanc všeho; VB6 parita stat by skončila |
| 16 | **Headlights + Hard-only uzly** | C4 + F | M | po T1.1 |
| 17 | **Armor ships** | C5 | S | po T1.5 |
| 18 | **Spojení lodí v co-opu** | E3 | L | až po PC co-op testu |
| 19 | **Opakující se boss** v kampani | D4 | M | obsah |

**Záměrně nepřebíráme:** Destruct, Zinglon bonusové hry, Super Tyrian,
holiday mode, jména, příběh, levely 1:1, GPL kód.

---

## 4. Otevřené otázky — rozhodnutí na tobě

1. **25 úrovní vs. 11 vzorů.** Tyrianův systém je pocitově silnější, ale
   `CLAUDE.md` drží VB6 paritu stat. Buď parita zůstane jen pro endless a
   kampaň dostane vlastní tabulku, nebo se parita opustí celá. Nerozhoduju.
2. **Skiny jako lodě.** Speciál per skin znamená, že skin přestane být čistě
   kosmetický — a na mobilu jsou skiny placené. Placený skin s lepší
   schopností = pay-to-win. Buď speciály stejně silné (jen jiné), nebo
   speciál oddělit od skinu.
3. **Arcade mód vs. endless.** Nahradit, nebo mít oba? Oba = dvě ekonomiky
   k balancování.
4. **Kolik psaní.** Briefingy per uzel × 20 uzlů × lokalizace. Kdo píše?

---

## Příloha A — Tyrian: výbava (reference pro balanc)

Ceny z Tyrian 2000. Jména jsou Tyrianova — **do Kirianu jdou vlastní.**

**Lodě:** Storm 5 000 · USP Talon 6 000 · USP Fang 8 000 · Gencore Phoenix
12 000 · Gencore Maelstrom 15 000 · Gencore II 17 000 · MicroCorp Stalker
20 000 · Stalker-B 25 000 · Prototype Stalker-C 50 000 · Stalker 21.126
30 000 · SuperCarrot 65 000. Tajné: U-Ship, Dragon, Ninja Star, Nort-Ship Z.

**Front guns (18):** Pulse-Cannon 500 · Vulcan Cannon 600 · Proton 600 ·
Needle Laser 600 · Dragon Frost 700 · Multi-Cannon 750 · Missile Launcher
850 · Mega Pulse 900 · Laser 900 · Widget Beam 950 · Fireball 1 000 · Heavy
Missile Launcher 1 000 · Lightning Cannon 1 000 · Mega Cannon 1 000 ·
RetroBall 1 000 · Sonic Impulse 1 000 · Hyper Pulse 1 050 · Zica Laser 1 100.
(+ Starburst, Banana Blast, Hot Dog, Atomic RailGun v některých verzích.)

**Rear guns (12)** s energií/výstřel: Vulcan Cannon 20/500 · Starburst
20/900 · Multi-Cannon 40/750 · Scatter Wave 40/900 · Proton 50/650 ·
Fireball 50/1 000 · Sonic Wave 50/950 · Guided Micro Bombs 60/1 100 · Wild
Ball 60/800 · Heavy Guided Bombs 80/1 000 · Rear Heavy Missile Launcher
90/1 000 · Rear Mega Pulse 90/900.

**Sidekicky (30)** — cena, munice (— = auto-fire):
Mini-Missile 1 000/100 · Satellite Marlo 2 000/— · Side Ship 3 000/100 ·
Single Shot Option 3 000/— · MegaMissile 4 000/5 · MicroBomb 4 000/60 ·
Companion Ship Warfly 5 000/— · Mint-O-Ship 5 000/— · Bubble Gum-Gun
6 000/— · Dual Shot Option 6 000/— · Post-It Mine 7 000/20 · 8-Way
MicroBomb 7 500/30 · Atom Bombs 8 000/20 · Phoenix Device 8 000/8 ·
MicroSol FrontBlaster 8 000/— · Tropical Cherry Companion 8 000/— · Plasma
Storm 9 500/6 · Companion Ship Gerund 10 000/— · Vulcan Shot Option
10 000/— · Proton Cannon Indigo 12 000/— · Buster Rocket 12 500/30 ·
MicroSol FrontBlaster II 14 000/— · Charge Cannon 15 000/— · Beno Wallop
Beam 20 000/— · Zica Flamethrower 20 000/— · Wobbley 25 000/— · Beno
Proton System -B- 30 000/— · Proton Cannon Tangerine 30 000/— · Zica
SuperCharger 50 000/— · BattleShip-Class Firebomb 65 000/—.

**Generátory (6):** Standard MR-9 (10 pwr, 500) · Advanced MR-12 (14,
2 000) · Gencore Custom MR-12 (19, 5 000) · Standard MicroFusion (25,
10 000) · Advanced MicroFusion (30, 15 000) · Gravitron Pulse-Wave (50,
50 000).

**Štíty (9):** Structural Integrity Field 100 · Advanced Integrity Field
250 · Gencore Low Energy 500 · Gencore High Energy 1 000 · MicroCorp LXS
A/B/C 2 000 / 4 000 / 5 000 · Gencore Solar Shield 10 000 (samodobíjecí) ·
MicroCorp HXS A 12 000 (+ HXS B/C v T2000).

## Příloha B — Twiddly (vstup → efekt → cena)

| Loď | Vstup | Efekt | Cena |
|---|---|---|---|
| Talon | →←↓ drž fire ↑ | Atom Bomb | 2 armor |
| Talon / Fang | ↓↑↓ drž fire ↑ | Invulnerability | celý štít |
| Fang / Stalker-C | ←→ drž fire ↓ | Guided Bomb Cluster | 2 armor |
| Phoenix / SuperCarrot | ↓ drž fire ↑ | Ice Blast | 3 štítu |
| Phoenix / Maelstrom / Stalker-C | fire↓, pusť, ↓, fire↓ | Repair System | celý štít |
| Maelstrom | drž fire, 2× dokola | Spin Wave | půl štítu |
| Stalker A/B | drž fire ←→ | Repulsor | 1 štítu |
| Stalker A | ↑ drž fire ←↓ | Protron Field | půl štítu |
| Stalker B | drž fire →↓← pusť ↑ | Mine Spray | 4 armor |
| Stalker-C | ← drž fire ↓→↑ | Post-It Blast | 5 armor |
| SuperCarrot | ↑ drž fire ↓ | HotDog Blast | 1 armor |
| 2P: P1 | ←→← drž fire ↓ | Repair Player 2 | celý štít |

Vzor: **silný efekt stojí celý štít, střední půl, slabý 1–5 armor.**
To je ta rovnováha k převzetí.

## Příloha C — Epizody a levely

Tajné *kurzívou*. Bossové jen tam, kde jsou doložené.

**Ep 1 — Escape:** Tyrian (Assassin/claw ship) → Asteroid 1 → Asteroid 2 →
Savara (Z-29 Central Defense Ship) → Bonus → Deliani (Dual Gun Ship) →
Savara V (T-29 Blimp) → Assassin (Assassin Ship) → bonusová hra Zinglon's
Ale. Tajné: *Bubbles, Holes, Soh Jin, Asteroid ?, Windy, MineMaze*.

**Ep 2 — Treachery:** Torm (zelená Torm ship) → Gyges (Great Stomach) →
Bonus → Asteroid City → Bonus → Soh Jin → Botany A → Botany B → Gryphon
(Gryphon Ship — střílí vlastní hlavou). Tajné: *Gem War, Mistakes*.

**Ep 3 — Mission: Suicide:** Gauntlet → Ixmucane (Rock Ship; jádro
otevřené na čas) → Bonus → Asteroid City → Stargate → Camanis → Maces →
Fleet *(konec na Easy/Normal)* → Tyrian X → Savara Y → New Deli. Tajné:
*Sawblades*. Z-29 se vrací 3×.

**Ep 4 — An End to Fate:** Surface → Lava Run (obří oko) → Core (Lava Core)
→ Lava Exit → Harvest → Underdeli → Approach → Savara IV → Dread-Not (Javiho
Dreadnought, slabá místa) → EyeSpy (oko) → Brainiac (Muldarova mozková loď)
→ Nose Drip (Vykromod). Tajné: *Windy, Side Exit, Desert Run, Ice Exit, Ice
Secret, ?Tunnel?*. Po Nose Drip bonusová hra (Squadrons, nebo Revenge se
Stalkerem 21.126 po ?Tunnel? + Ice Exit).

**Ep 5 — Hazudra Fodder (T2000):** Asteroid 3 → Asteroid 1 → Soh Jin →
Savara → Camanis → Gyges → finále (Pineapple Ship — ovocný destroyer).

**Celkem ~48 levelů, z toho 15 tajných** (necelá třetina). To je poměr, který
stojí za převzetí do kampaně.

## Příloha D — Módy, obtížnosti, kódy

- **Obtížnosti:** Easy, Normal, Hard; skryté Impossible (Shift+G), Suicide
  (po Impossible Shift+]), Lord of the Game (L+O+R+D). Hard+: víc HP, víc
  střel/s, vlastní levely, headlights.
- **Super Arcade kódy:** TECHNO (Experimental PQZ: Minefield + MegaLaser
  Dual) · STORMWIND (Stormwind: SandStorm + Flare) · UNKNOWN (TX Silver
  Cloud: Proton Dispersal + Xega Ball) · ENEMY (Captured U-Fighter: Dual
  Vulcan + Lightning Zone) · STEALTH (Ninja Star: Blade Field +
  Invulnerability) · WEIRD (FoodShip Nine: Banana Bomb + Orange Shield) ·
  NORTSHIPZ (Nort-Ship Z: Astral Zone + SDF Main Gun) · LIZARD (Dragon) ·
  PRETZEL (Pretzel Pete Truck). Pravidlo: bez rear gunu, Enter přepíná dva
  speciály; pody jsou barevné a barva = zbraň.
- **Super Tyrian:** ENGAGE v menu; jen Atomic RailGun + twiddly, Lord of
  Game, cheaty vypnuté.
- **In-game kódy:** F2+F3+F6 nesmrtelnost · F2+F3+F4 „destruction" (armor 0,
  nesmrtelný) · F2+F6+F7 dokončit level · Backspace+1 rychlost ·
  Backspace+F10 debug HUD · Caps Lock+# doplnit sidekicky a opravit armor ·
  Backspace+Scroll Lock náhodná skladba · DESTRUCT v titulu = minihra.
- **Datacuby:** příklady „MISSION BRIEFING FLUX 0473", „INCOMING MESSAGE FROM
  HAZUDRA", „HOLO NEWS - XP9 v123-02-39"; spouštějí tajné levely.

## Zdroje

Tabulky výbavy, levely, twiddly, kódy: archiv fanouškovského Tyrian webu
(jkdf2.net/…/Websites/Tyrian/ — guide, maps, superarc, suprtwid, diff,
bonusgam, gamecode). Módy, obtížnosti, licence: Wikipedia „Tyrian (video
game)"; Hardcore Gaming 101. Bossové a mechaniky levelů: All The Tropes
„Tyrian", tyrian.fandom.com (přes vyhledávání, stránky samy jsou za
paywallem). Hodnoty generátorů/štítů ověřené proti GameFAQs výtahu.
StrategyWiki a NamuWiki blokují strojové čtení — neověřeno z nich.
