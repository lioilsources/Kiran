# 30 — PLÁN: DUEL — souboj s bossem na celé obrazovce (čumák nahoru, pravá páčka míří)

**Jen linie 3.x, jen desktop.** Do `release/2.9.x` se neportuje nic. Na mobilu zůstávají
souboje s bossy tak, jak jsou.

Cíl jednou větou: když přiletí boss, hra **přestane být střílečkou zprava doleva a stane se
arénou** — obraz se otočí, boss stojí hlavou nahoru a chodí po celé obrazovce, loď míří
čumákem tam, kam ukáže pravá páčka, a sigily se kreslí toutéž páčkou, když hráč drží spoušť.

Zadání uživatele (2026-11-11) po bodech:

- souboj s bossy, a tedy i Aréna, budou jiné než zbytek hry; obraz se „jakoby otočí na landscape“;
- boss přiletí shora, hlava nahoře, chapadla dole, operuje po celé obrazovce;
- čumák lodi míří nahoru, loď manévruje kolem bosse a čumák se natáčí pravou páčkou;
- komba (sigily) se proto musí přestěhovat — návrh „pravá páčka se stisknutým RT“, **ověřit** (§6.1);
- domyslet přechod z letu do souboje, možná s animací nebo videem detailu bosse (§8).

Dokument je psaný pro implementační session (Opus). Staví na plánech
`28-PLAN-gamepad-combat.md` (sigily) a `29-PLAN-sigil-training-and-video.md` (aréna, videa),
tedy na větvi `feat/sigils`, která zatím není v `main`. Nová větev `feat/boss-duel` vychází z ní.

**První krok je pilot v aréně (§14, krok 0) a po něm rozhodnutí uživatele o ovládání.**
Ergonomii bez padu v ruce ověřit nejde. Plán proto odděluje, co je ověřené na papíře proti
kódu, a co musí rozhodnout ruka.

---

## 0. Fakta z kódu, na kterých plán stojí (ověřeno 2026-11-11 na `feat/sigils`)

| Věc | Kde | Důsledek pro plán |
|---|---|---|
| Pole je `gameWidth` (konstanta 600) × `gameHeight` (proměnná, ≈1067 při 16:9). Desktop = kamera otočená o `landscapeCameraAngle = pi/2`; `screenToGame(sx,sy) = (-sy, sx)`, `gameToScreen(gx,gy) = (gy, -gx)` | `lib/game/platform_config.dart`, `lib/game/game_config.dart:22`, `lib/game/tyrian_game.dart:677` | Na obrazovce je **vpravo = herní +y, nahoře = herní +x**. Let míří k −y, tedy doleva. „Nahoru“ v duelu je herní +x. |
| Text a bonusy se už dnes staví na výšku přes `canvas.rotate(landscapeCameraAngle)` | `lib/ui/float_text.dart:71`, `lib/entities/collectable.dart:166` | Tentýž úhel postaví na výšku bosse a je to i výchozí kurz lodi v duelu. Jedna konstanta, žádné druhé číslo. |
| `config.gameWidth`/`gameHeight` se v `lib/` používá na zhruba 150 místech (ořezy, culling, cesty, HUD) | celé `lib/` | Obdélník pole se **nepřerámovává**. Viz §3. |
| Pad ve schématu `sigil`: LS pohyb, **RS kreslí**, **RT palba s analogovou kadencí**, LT OVERSTREAM, LB vrstva ARMS, RB vrstva WING, LB+RB MEGA BLAST (RS při nabíjení míří), A FOCUS, B BREAK, Y výměna | `lib/input/pad_scheme.dart` (`PadFrame.read`) | Pravá páčka i RT jsou obsazené. To je jádro §6. |
| Vstup sigilů jde jedním místem: `screenToGame(both.drawX, both.drawY)` → `caster.input(both, sx, sy, dt)`; palba `vessel.fire = f.fire \|\| keyboardInput.fire` | `tyrian_game.dart` ~1622 (`_processSigilPad`) | Role pravé páčky se přepíná tady a nikde jinde. Páčka se casteru předává **v rámu lodi**; dnes je ten rám pevný, v duelu se otáčí. |
| Druhý pad (lokální co-op) má jen pohyb a palbu | `tyrian_game.dart` ~1607 | P2 dostane v duelu jen míření, žádné sigily. |
| Klávesnice: WASD **i šipky** hýbou, Space pálí; sigily na numpadu „jak jsou vidět na obrazovce“; myš se při pohybu bez tlačítka nečte | `lib/input/keyboard_input.dart`, `lib/input/keyboard_sigils.dart` | Míření z klávesnice a myši je nové (§6.6). |
| Střela má `speed` (svisle, záporná = nahoru) a `vx`; hitbox je AABB podle spritu; hráčovy střely se ořezávají na obou osách; orbitální vlnění přičítá jen k `position.x` | `lib/entities/projectile.dart` | Rychlost je už 2D. Chybí hitbox pro vodorovný let a vlnění kolmo na směr. |
| Zbraně: `Device.fire` → `_emit`: sloty mají pevné posuny (`vesselY - 5`, boky `+18`), `vx = speed·sin(a) + lean`, `speed = -speed·cos(a)`; REARGUARD pálí dozadu | `lib/systems/device.dart:157`, `:240` | Posuny i směry se přepíšou do rámu lodi (§4). Při kurzu 0 musí vyjít bit po bitu totéž. |
| Loď: `nozzle`, `adjustPosition` (ořez do pole), `_findClosestEnemy` (kužel předpokládá nepřítele „nad“ lodí), samonaváděcí střely dotahují jen x, paprsek zasahuje `closestEnemy` | `lib/entities/vessel.dart:140`, `:588`, `:765`, `:965` | Všechno „nad lodí“ se mění na „před čumákem“. |
| Renderer: nepřátelé se kreslí otočení o π („sprite je čumákem nahoru, otoč ho na hráče“); hráčovy střely se natáčejí po směru letu, nepřátelské ne | `lib/rendering/batch_renderer.dart:154`, `:263` | Boss v duelu potřebuje vlastní úhel kreslení; nepřátelské střely se v duelu natáčejí taky. |
| Boss: `Boss extends Hostile`, fáze na 66 % a 33 % HP, pendluje přes `cyclePath`, `_fireAimed` má ořez „nikdy nestřílej dozadu“ (`vy < 6.0`), `_fireSpread`; tvor se pozná podle spritu `rododendron_blink` | `lib/entities/boss.dart:163`, `:270`, `:441` | Pohyb po celé obrazovce a střelba všemi směry jsou nové. Ořez se v duelu ruší. |
| Části bosse (`BossPart`: věž, štítový modul, tryska, kanón) sedí na pevném zlomku velikosti jádra v herních osách | `boss.dart` ~355–410 | Zlomky se zadají v rámu obrázku a otáčejí se s bossem (§7.4). |
| Obrázek tvora má **hlavu nahoře a chapadla dole** (1024×1024, ≈189 herních jednotek); hotový je pro 2 skiny, ostatních 22 má bosse-loď | `assets/skins/default/sprites/rododendron.png` | Dnes je tvor na mobilu hlavou dolů a na desktopu na boku. Duel ho konečně postaví. Bossové-lodě potřebují jiné pravidlo (§7.1). |
| Boss vlna: `Sector.addBossWave` počítá HP, poškození, `recharge`, náraz i odměnu z úrovně a pořadí; nastupuje 3 s po poslední vlně; endless každá 5. úroveň od 10; kampaň má uzly s cílem `bossUnder(s)` | `lib/systems/sector.dart:135`, `:245`, `lib/systems/campaign.dart` | Čísla se nemění. Mění se, **kdy** a **kde** boss vznikne. |
| Časovač `bossUnder` startuje v `Fleet._spawnHostile` (`campaignTracker.onBossSpawn`); hudba bosse se řídí `game.bossActive` | `lib/systems/fleet.dart:297`, `tyrian_game.dart:543`, `lib/systems/music_director.dart:34` | Flotila se spawne až po úvodu → časovač neběží během střihu. Hudba potřebuje vědět o úvodu dřív. |
| Nepřátelské střely se ořezávají jen na ose y; zásah lodi je AABB s `cf = 0.7` | `tyrian_game.dart` (`_updateEnemyProjectiles`, `_projectileHitsVessel`) | V duelu ořez na všech čtyřech stranách a hitbox nezávislý na natočení. |
| Bonus padá po +y (na desktopu doprava, k hráči) | `collectable.dart:84` | V duelu musí padat dolů po obrazovce nebo letět k lodi. |
| Pozadí: vrstvy široké 600 dlaždicované po y, rychlosti `[0.5, 1.0, 2.0, 3.5]` | `lib/rendering/parallax_bg.dart` | Pozadí dostane úhel rámu a musí pokrýt i šířku ≈1067 (§8.2). |
| Sigily: pózy `SigilPose(dx, dy, scale, roll)` a řízení `SigilControl` jsou v rámu lodi; companioni míří „nahoru“; `SigilHud` kreslí pad přes `gameToScreen` | `lib/systems/sigils/`, `lib/rendering/sigil_hud.dart` | Rám lodi (§4) je obslouží všechny naráz. |
| Aréna je vždy proti bossovi; duch (`arena_ghost.dart`) vyrábí `PadFrame`; nahrávání otáčí snímky o 270° do svislého videa | `lib/systems/training/`, `lib/game/capture_director.dart`, `bin/tutorial_assemble.py` ~99 | Aréna = duel. Duch a skládání videa se mění (§9, §10). |
| Co-op: `protocolVersion = 4`, `VesselSnap` nemá kurz, `ProjSnap` nemá `vx`; klient sigily nekreslí | `lib/net/protocol.dart:114`, `tyrian_game.dart:721` | Síťový co-op zůstane ve verzi 1 u klasického bosse (§11). |
| `Challenge` násobí HP, poškození, kadenci a skóre na čtyřech místech | `lib/game/challenge.dart` | Žádné páté místo. Duel mění směry a pohyb, ne čísla. |

---

## Stav implementace

Nic z toho není v kódu. Čeká se na pilot (§14, krok 0).

---

## 1. Let a duel vedle sebe

| | Let (dnes, beze změny) | Duel (nové) |
|---|---|---|
| Kdy | celá hra mimo bosse | každý `Boss` na desktopu; Aréna vždy |
| Směr světa | zprava doleva, pozadí ubíhá doprava | aréna stojí, pozadí zvolna teče dolů |
| Čumák | pevně doleva | výchozí nahoru, otáčí se pravou páčkou |
| Boss | přiletí zleva, pendluje u levého okraje | přiletí shora, hlavou nahoru, chodí po celé obrazovce |
| Levá páčka | pohyb po obrazovce | pohyb po obrazovce (stejné) |
| Pravá páčka | kreslí sigily | **míří**; sigily kreslí, jen když se drží modifikátor |
| RT | palba, analogová kadence | palba ve drženém směru + postoj pro sigily trupu |
| Kde je „vpřed“ pro sigil | vlevo | tam, kam míří čumák |
| Čísla (HP, dmg, ceny, kadence) | VB6 parita | stejná |

Všechno ostatní — NÁBOJ, FLOW, OVERSTREAM, MEGA BLAST, FOCUS, BREAK, mody, trupy,
companioni, `Challenge` — platí v duelu beze změny pravidel.

---

## 2. Slovník

| Pojem | Význam |
|---|---|
| **Let** | Dnešní režim: čumák pevně doleva, svět ubíhá. |
| **Duel** | Souboj s bossem: aréna na celé obrazovce, čumák volný. |
| **Kurz** (`heading`) | Úhel čumáku. 0 = herní −y (let). Kladný po směru hodin. V duelu výchozí `uprightAngle` (nahoru). |
| **Rám lodi** | Osy „vpřed“ a „vpravo“ podle kurzu. Všechno, co loď dělá, se počítá v něm. |
| **Míření** | Pravá páčka určuje kurz. |
| **Postoj** | Stav, kdy pravá páčka nekreslí kurz, ale sigil. Vzniká držením modifikátoru. |
| **Západka** | Pravá páčka mění roli jen ve středu. Brání škubnutí čumákem po dokresleném tahu. |
| **Rám postoje** | Kurz zamrzlý ve chvíli vstupu do postoje. V něm se tah rozpozná i provede. |
| **Varování, Střih, Obrat, Nástup** | Čtyři doby přechodu z letu do duelu (§8). |

---

## 3. Geometrie: otočí se obraz, ne souřadnice

### 3.1 Rozhodnutí

**Kamera, viewport ani obdélník pole se nemění.** Mění se jen to, co hra považuje za „vpřed“.

Proč ne otočit kameru zpátky: pole je 600×1067 na výšku, okno je na šířku — nevešlo by se.
Proč ne prohodit šířku a výšku pole: každý ořez, cull, cesta a HUD počítá s dnešním rámem
(≈150 míst) a `gameWidth` je konstanta.

Jde to bez toho. V prázdném prostoru je „kamera se otočila o 90°“ k nerozeznání od „otočila
se loď a pozadí“. Před obratem se pole vyprázdní (§8), takže se otáčejí jen dvě věci:
**kurz lodi** a **rám, ve kterém se kreslí pozadí**. Všechno ostatní zůstane, kde je.

### 3.2 Směry v duelu

| Na obrazovce | V herních souřadnicích | Poznámka |
|---|---|---|
| nahoru | +x | odtud přilétá boss; výchozí směr čumáku |
| dolů | −x | sem padají bonusy; tady loď začíná |
| vpravo | +y | |
| vlevo | −y | směr letu mimo duel |

### 3.3 Jeden pomocník

Nový soubor `lib/game/duel_space.dart`. Nikde jinde se směry duelu nepíšou číslem.

```dart
/// Screen-normalised duel coordinates: u 0..1 left to right, v 0..1 top to bottom.
Vector2 duelToGame(double u, double v) =>
    Vector2((1 - v) * config.gameWidth, u * config.gameHeight);

/// The angle that stands nose-up art upright on screen; also the duel's default heading.
double get uprightAngle => platform.isLandscape ? platform.landscapeCameraAngle : 0;
```

Jednotkové směry `duelUp`, `duelDown`, `duelRight` se odvodí ze `screenToGame`, ne z literálů.
Test hlídá, že `gameToScreen(duelUp)` je opravdu „nahoru“ a že `ShipFrame(uprightAngle)` dává
stejný převod jako `screenToGame` (v duelu s čumákem nahoru je rám lodi totožný s obrazovkou).

### 3.4 Pole a velikosti

Aréna je celé pole: ≈1067×600 jednotek při 16:9, 960×600 na Steam Decku. Boss má ≈189
jednotek, tedy třetinu výšky. Loď se ořezává do stejného obdélníku jako dnes (`adjustPosition`).
**Žádné oddálení kamery ve verzi 1** — vyžadovalo by právě ten přerámovaný obdélník (parkoviště, §16).

---

## 4. Loď: kurz a rám lodi

### 4.1 Model

`Vessel` dostane `double heading = 0`. Nový soubor `lib/entities/ship_frame.dart`:

```dart
/// Ship-local axes in game space. Heading 0 = nose to -y, today's flight.
class ShipFrame {
  const ShipFrame(this.heading);
  final double heading;
  double get fx => sin(heading); // forward
  double get fy => -cos(heading);
  double get rx => cos(heading); // right
  double get ry => sin(heading);

  /// Ship space (x right, y back: today's game axes at heading 0) to a world delta.
  Vector2 toWorld(double x, double y) => Vector2(rx * x - fx * y, ry * x - fy * y);
  Vector2 toShip(double wx, double wy) =>
      Vector2(wx * rx + wy * ry, -(wx * fx + wy * fy));
}
```

Při kurzu 0 je `toWorld` identita. **To je pojistka celého plánu:** mimo duel je kurz vždy 0,
takže let, mobil i VB6 parita vyjdou přesně jako dnes.

Kurz se mění plynule: cílový úhel z míření, rychlost otáčení `duelTurnRate` (výchozí 720°/s;
0 = okamžitě). Sprite lodi se kreslí otočený o kurz; náklon a zploštění při úhybu (bank) se
počítají z boční rychlosti **v rámu lodi**.

### 4.2 Mapa zásahů

| Místo | Dnes | Po změně |
|---|---|---|
| `Device._emit` — poloha výstřelu | pevné posuny v herních osách | posun slotu přes `frame.toWorld` |
| `Device._emit` — směr | `vx = s·sin(a) + lean`, `speed = -s·cos(a)` | směr = kurz + `a`; `lean` po ose „vpravo“ |
| REARGUARD | pálí po +y | kurz + π |
| `nozzle`, plamen motoru | pod lodí | za lodí (−vpřed) |
| `_findClosestEnemy` (kužel navádění) | cíl musí být „nad“ | cíl musí být před čumákem: `toShip(d).y < 0` |
| Samonavádění střel | dotahuje x | zatáčí vektor rychlosti k cíli (stejná úhlová rychlost) |
| Paprsky (`_processBeamCollision`) | k `closestEnemy` | stejně; kužel už je v rámu lodi |
| Satelit, pody, companioni | posuny v herních osách, míří nahoru | posuny přes rám; míří po kurzu nebo na cíl |
| Sigily — pózy, výpady, dráhy | rám lodi = herní osy | `frame.toWorld` s rámem postoje |
| `SigilControl.verticalOnly` (SHADOW) | LS jen po y | LS jen po ose „vpřed“ |
| MEGA BLAST | RS míří paprsek | paprsek letí po kurzu (RS míří stejně jako vždy) |
| Bank, stín, zvětšení při LOOPu | kolem svislé osy | kolem osy lodi |

Vzor práce: nejdřív zavést `ShipFrame` a protáhnout ho **beze změny chování** (kurz 0 všude),
pustit celou sadu testů, a teprve pak kurz rozhýbat.

### 4.3 Hitbox lodi

Sprite lodi není čtverec; otočený AABB by v duelu měnil tvar podle kurzu. V duelu je proto
hitbox **čtverec o straně `min(w, h) · cf` kolem středu** (stejné `cf = 0.7`). V letu zůstává
dnešní obdélník. FOCUS ho ukazuje tak jako dnes.

---

## 5. Střely

| Věc | Dnes | V duelu |
|---|---|---|
| Hitbox | AABB podle spritu, „na výšku“ | při vzniku se šířka a výška prohodí, letí-li střela spíš vodorovně (v herních osách). Při kurzu 0 beze změny. |
| Orbitální vlnění | přičítá k x | kolmo na směr letu |
| `_bounce` (PINBALL) | boční stěny, strop | všechny čtyři stěny |
| Ořez hráčových střel | obě osy | beze změny |
| Ořez nepřátelských střel | jen y | všechny čtyři strany |
| Kreslení nepřátelských střel | nenatočené | natočené po směru, má-li sprite podélný tvar |
| Strop `maxLiveShots` | 360 | beze změny |

Střely vystřelené před obratem (§8) se nepřepočítávají — pole je v tu chvíli prázdné.

---

## 6. Ovládání v duelu

### 6.1 Ověření nápadu „sigily na pravé páčce se stisknutým RT“

Prošel jsem návrh proti dnešnímu mapování (`pad_scheme.dart`). Výsledek: **ano, RT je
správná volba — ale ne jako jediný modifikátor a ne s tím, že přestane střílet.**

| Kontrola | Co vyšlo | Důsledek |
|---|---|---|
| RT je dnes palba s analogovou kadencí | Kdyby RT v duelu jen přepínal páčku, hráč ztratí kadenci i zvyk „RT = palba“ | **RT střílí dál**, ve směru, který čumák drží. |
| RT přepíná páčku na kreslení a zároveň střílí | Pak nejde naráz mířit a střílet | **Mířením se střílí samo** (konvence twin-stick stříleček). RT je potřeba jen na „drž směr“. |
| RT a RB mačká tentýž ukazovák | Vrstva WING (RB) by s povinným RT nešla zahrát | **Postoj otevře kterýkoli modifikátor**: RT = trup, LB = zbraně, RB = wing. |
| Zvyk z letu: držím RT a kreslím | V duelu je totéž gesto tentýž výsledek | Hlavní důvod **pro** RT: nic se nepřeučuje. |
| LB + RB = MEGA BLAST, RS při nabíjení míří | Beze změny; v duelu to sedí samo | — |
| LT = OVERSTREAM | Beze změny | Žádná funkce se nestěhuje. |
| A = FOCUS, palec opouští pravou páčku | Čumák drží poslední směr, RT pálí | V pořádku. |
| Páčka je vychýlená, když se RT stiskne nebo pustí | Bez ošetření čumák po tahu škubne, nebo vznikne falešný tah | **Západka přes střed** (§6.3). |
| Lehký dotek RT kolem prahu | Role páčky by blikala | Postoj má hysterezi (zap. 0,15 / vyp. 0,08); práh palby zůstává 0,05. |
| Ekonomika NÁBOJE (slabší RT = přebytek generátoru) | Platí jen při drženém RT; palba mířením jede naplno | Vzniká rytmus „mířím a sázím“ ↔ „držím a nabíjím“. Ověřit pilotem, jestli NÁBOJ v duelu neroste moc pomalu. |

Co na papíře ověřit nejde a musí rozhodnout pilot s padem v ruce:

1. jestli je příjemné, že **mířením se střílí** (nejde mířit potichu);
2. jestli nevadí, že **při drženém RT čumák nejde otočit**;
3. jestli západka nepůsobí jako zpoždění.

Proto má pilot přepínač na druhé mapování (§6.5).

### 6.2 Doporučené mapování `rtStance`

| Vstup | V duelu | Proti letu |
|---|---|---|
| **LS**, D-pad | Pohyb po obrazovce | stejné |
| **RS** samotná | **Míří**: čumák se otočí za páčkou a loď pálí. Páčka ve středu = čumák drží, loď nepálí | nové |
| **RT** (drž) | Pálí po drženém kurzu, analogová kadence. Pravá páčka přitom **kreslí sigil trupu** (HULL) | RT + kreslení jako v letu |
| **LB** (drž) | Pravá páčka kreslí sigil zbraní (ARMS) | stejné |
| **RB** (drž) | Pravá páčka kreslí sigil wingu (WING) | stejné |
| **LB + RB** | MEGA BLAST; pravá páčka míří paprsek, tedy čumák | stejné |
| **LT** | OVERSTREAM | stejné |
| **A / B / Y / X / Start / Back** | FOCUS / BREAK / výměna / grimoár II / pauza / grimoár | stejné |

Pravidlo pro hráče jednou větou: **„Páčkou míříš. Když něco držíš, páčkou kreslíš.“**

Palba: `vessel.fire = RT stisknutý || míření aktivní || klávesnice`. Kadence: analog z RT,
je-li stisknutý, jinak 1,0.

### 6.3 Role pravé páčky — stavový stroj

Nový soubor `lib/input/duel_stick.dart`, čistá třída bez Flame (dá se testovat sama).
Vstup: páčka po deadzone, `hull` (RT s hysterezí), `arms`, `wing`, `megaCharging`.

| Stav | Co dělá páčka | Přechod |
|---|---|---|
| `aim` | Vychýlení nad `duelAimDeadzone` nastaví cílový kurz; nad `duelAimFireZone` se pálí | stisk modifikátoru → `draw`, je-li páčka ve středu; jinak `latch` |
| `latch` | Nic. Kurz drží. | páčka projde středem → `draw`; modifikátor puštěn dřív, než páčka prošla středem → zpět do `aim` **hned** (krátký stisk RT při míření nic nerozbije) |
| `draw` | Páčka jde do `caster.input` v rámu postoje | všechny modifikátory puštěny → rozdělaný tah se uzavře jako při návratu do středu; pak `aim`, je-li páčka ve středu, jinak čeká na střed |
| (akord) | LB+RB déle než 0,25 s: páčka míří paprsek | puštění → výstřel, pak `aim` přes střed |

Tah tedy vždy začíná ve středu, stejně jako v letu, kde páčka nic jiného nedělá. Casteru se
mimo stav `draw` posílá páčka ve středu — rozpoznávač se nemění.

Během běžícího sigilu s `control: none` (LOOP, DASH…) hráč mířit nemůže. Čumák tehdy
**pomalu sleduje cíl** (`duelRunTrackRate`, výchozí 180°/s; jádro bosse, nebo část, na kterou
hráč mířil při startu). Při pouhém držení RT bez sigilu čumák **nesleduje nic** — jinak by
stačilo držet RT a mířit by nebylo potřeba.

### 6.4 Rám sigilů: „kreslíš ve směru čumáku“

V letu je „vpřed“ na páčce vlevo, protože tam míří čumák. Duel to pravidlo jen zobecní:
**„vpřed“ na páčce je tam, kam míří čumák ve chvíli vstupu do postoje.** Ten směr hráč zná —
palec tam právě mířil.

Technicky jedna řádka: místo `screenToGame(drawX, drawY)` se páčka převede
`stanceFrame.toShip(screenToGame(drawX, drawY))`. Při kurzu 0 je to dnešní chování.
Tah se rozpozná i provede v témže zamrzlém rámu, takže platí vlastnost, kterou hráč z letu
zná a která se nesmí rozbít:

> **Loď se pohne tím směrem, kterým se pohnul palec.** Čumák rozhoduje jen o tom, čemu se
> říká „vpřed“.

Důsledky: tah k bossovi je útok (STRIKE), tah od bosse ústup (RETREAT), tah napříč je úkrok
kolem bosse (SIDESTEP) — přesně manévrování, které zadání chce. Švihy (HOP, SNAPSHOT, PING)
míří tam, kam palec švihl. Kruh je kruh.

`SigilHud` kreslí pad natočený podle rámu postoje a značí bod „vpřed“ malým čumákem.
Mimo postoj se pad otáčí s čumákem, aby bylo předem vidět, kde „vpřed“ bude.

Alternativa pro pilot: `DuelPadFrame.screenUp` — „vpřed“ je na páčce vždy nahoře, glyfy
vypadají jako v grimoáru, ale provedou se podle čumáku. Je to snazší na čtení, ale s čumákem
do strany se loď pohne jinam, než kam jel palec. Doporučuji `nose`; pilot má přepínač.

Volitelné přichytávání rámu po 45° (`duelPadSnap`, výchozí 0 = vypnuto) nechávám jako ladicí
hodnotu, kdyby plynulé natočení padu mátlo.

### 6.5 Druhé mapování pro pilot: `ltStance`

RS jen míří, **RT pálí** (kadence jako dnes, jde mířit i pálit zároveň), **LT je postoj** pro
sigily trupu, LB a RB vrstvy jako dnes. Cena: OVERSTREAM je v duelu dostupný jen v postoji
(hloubka LT dál vybírá proud) a LT s LB mačká tentýž ukazovák — zrcadlový problém k RT + RB,
vyřešený stejně (postoj otevře kterýkoli modifikátor).

Obě mapování jsou dvě tabulky v `pad_scheme.dart` (`DuelBinding { rtStance, ltStance }`),
jak chce plán 28: všechna přiřazení žijí v jednom souboru. Po pilotu jedna zmizí.

### 6.6 Ostatní vstupy

- **Schéma `classic`:** pravá páčka míří a pálí, B / RB / RT pálí po kurzu. Žádný postoj, žádné sigily.
- **Levák (`southpaw`):** zrcadlí páčky, spouště i shouldery; projde samo, protože se čte přes `PadFrame.read`.
- **P2 na druhém padu:** jako `classic`.
- **Klávesnice:** WASD pohyb, **šipky míří** (8 směrů, kurz po puštění drží), Space pálí po kurzu.
  V letu šipky dál hýbou; změnu ohlásí jednorázová nápověda při prvním duelu.
- **Myš:** pohyb myši míří (zaměřovač pod kurzorem), levé tlačítko pálí. Tah myší jako pohyb
  lodi je v duelu vypnutý. Ověřit na trackpadu Steam Decku.
- **Numpad:** sigily bez modifikátoru (numpad nic jiného nedělá), body „jak jsou vidět na
  obrazovce“ — tedy v rámu natočeného padu, stejné pravidlo jako páčka.

### 6.7 Role páčky musí být vidět

- Míření: tenká zaměřovací čára z čumáku (≈140 jednotek) se šipkou.
- Postoj: čára ztuhne (plná, jasnější), sigil pad se rozsvítí.
- Západka: středový bod padu pulzuje („vrať páčku“).
- První duel: karta se dvěma řádky nápovědy (ARB, 15 jazyků), pak už jen v pauze.

---

## 7. Boss v duelu

### 7.1 Postoj

`Hostile` dostane `drawAngle` (výchozí π = dnešek). `Boss` ho v duelu nastavuje:

| Boss | Pozná se | `drawAngle` v duelu |
|---|---|---|
| **Tvor** | skin má `rododendron_blink` | `uprightAngle` — hlava nahoře, chapadla dole, nikdy se neotáčí |
| **Loď** (22 skinů bez tvora) | jinak | čumákem k hráči, otáčí se nejvýš 90°/s |

Sprite bosse je čtverec, takže AABB na natočení nezávisí.

### 7.2 Pohyb: `DuelBrain`

Nový soubor `lib/systems/duel_brain.dart`. Boss v duelu neletí po `cyclePath`; polohu mu
dává mozek složený z **tahů** v souřadnicích `duelToGame(u, v)`. Seedovaný, bez Flame.

| Tah | Co udělá | Od kterého bosse |
|---|---|---|
| `hover(u, v)` | pohupuje se kolem bodu | 1 |
| `sweep(v)` | přejede zleva doprava nebo zpět (dnešní pendlování, jen nahoře) | 1 |
| `dive(u)` | 0,6 s varování (záškub chapadel, záblesk), pak výpad dolů a návrat | 1 |
| `perch(strana)` | usadí se u boku a pálí napříč | 2 |
| `orbit` | oblouk kolem středu obrazovky | 3 |
| `cross` | projde středem do dolní poloviny — hráč musí otočit čumák dolů | 4 |

Fáze podle HP (dnešní prahy 66 % a 33 %):

1. **Nad 66 %** — horní třetina: `hover`, `sweep`. Stačí čumák nahoru; hráč se rozkouká.
2. **66–33 %** — horní dvě třetiny: přibude `dive` a `perch`. Míří se šikmo a do stran.
3. **Pod 33 %** — celá obrazovka: `orbit`, `cross`. Boss se dostane i pod hráče.

První boss v endlessu i v kampani je tak jemný úvod, čtvrtý chodí všude. Rychlost vychází
z dnešní rychlosti pendlování; tryska ji násobí stejně jako dnes. Mozek nikdy nezačne tah
do místa blíž než `duelKeepOut` od lodi — kromě `dive`, který se ohlásí.

### 7.3 Útoky a rozpočet poškození

**Duel nepřidává žádný časovač palby.** Běží dnešní časovače (tři místa, kde `Challenge`
násobí kadenci), mění se jen **vzor**, který salva použije, podle právě běžícího tahu:

| Vzor | Dnes | V duelu |
|---|---|---|
| mířená salva (`_fireAimed`) | na hráče, s ořezem „jen dolů“ | na hráče **kterýmkoli směrem**; stejná velikost rychlosti, ořezy `vy < 6.0` a `vx` se v duelu nepoužijí |
| vějíř (`_fireSpread`) | dolů | osa vějíře míří na hráče |
| prstenec | — | tentýž **počet střel jako vějíř**, rozložený do 360° (při `perch` a `orbit`) |
| výpad (`dive`) | — | zraňuje dotykem: dnešní nárazové poškození (`collisionDmg`), dnešní cesta kolize |

Počet střel za salvu i poškození střely zůstávají. Všechno jde přes `spawnEnemyProjectile`.
Test hlídá, že střel za minutu × poškození je v duelu stejně jako u klasického bosse.

### 7.4 Části

Zlomky poloh (`_offsetFraction`) se zadají **v rámu obrázku** a do světa se otočí o `drawAngle`:
`pozice = střed + rotate(artOffset · velikost, drawAngle)`. Výchozí `artOffset` vznikne převodem
dnešních hodnot (`rotate(dnešní, -π)`), takže klasický boss vyjde bod na bod stejně. Pak se na
krakenovi doladí, aby kanón seděl mezi chapadly a tryska za hlavou. U bosse-lodi se části
otáčejí s trupem.

Části pálí od svého středu: věž mířeně kamkoli, kanón po ose „dolů“ obrázku. Štítový modul
a tryska fungují jako dnes.

### 7.5 Co se nemění

HP, poškození, `recharge`, náraz, odměna, prahy fází, pořadí částí (`kBossPartProgression`),
čtyři místa `Challenge`. Prahy `bossUnder` v kampani (25–40 s) jsou návrhové hodnoty plánu
kampaně, ne VB6 — po pilotu se přeměří, protože v duelu se míří hůř (otázka č. 7).

---

## 8. Přechod z letu do duelu (a zpět)

### 8.1 Čtyři doby

| # | Doba | Délka | Co se děje | Hráč |
|---|---|---|---|---|
| 1 | **Varování** | 1,5 s | Pruh VAROVÁNÍ, nastoupí hudba bosse. Zbylí nepřátelé odletí bez odměny, nepřátelské střely se rozpadnou (bez NÁBOJE, jinak by šly farmit), struktury se přestanou rodit a dojedou. | plné řízení, pálí |
| 2 | **Střih** | 2,2 s | Svět stojí. Detail bosse (§8.2). | nezranitelný; po 0,4 s jde přeskočit |
| 3 | **Obrat** | 1,2 s | Loď zatočí doprava o 90° (čumák zleva nahoru) a dojede na start duelu dole uprostřed. Pozadí se otočí s ní (§8.3). Bonusy přiletí k lodi. | řízení zamčené, nezranitelný |
| 4 | **Nástup** | 1,5 s | Boss sestoupí shora na své místo, lišta HP se naplní, části se rozloží. | plné řízení; boss je zasažitelný |

Poprvé 6,4 s. Boss, kterého hráč už viděl, přijde bez Střihu (4,2 s). V aréně jen Nástup.

### 8.2 Střih: detail bosse

Tři možnosti, doporučuji je brát v tomto pořadí:

| Varianta | Jak | Cena |
|---|---|---|
| **A — ve hře, z hotových spritů (verze 1)** | Černé pruhy nahoře a dole. Sprite bosse 3–4× zvětšený, oříznutý na hlavu (výřez ve zlomcích obrázku, výchozí horní polovina, skin ho smí přepsat). Tvor mrkne (`_blink`), chapadla škubnou (`_twitch_l/r`), pomalý nájezd 1,0 → 1,15, pulz chromatické aberace a viněty (passy už jsou). Boss-loď: totéž bez mrknutí, přejede ho skenovací čára. | žádné nové assety, funguje pro všech 24 skinů hned |
| **B — generovaná sekvence (později)** | 24–36 snímků detailu na skin: obraz → video na sdíleném GPU přes frontu, stejné klíčování jako u tvorů. Balí se jako samostatný atlas, který se načte až před soubojem. | pilot na jednom skinu, výběr uživatelem, pak 24 skinů; paměť a velikost buildu ověřit |
| **C — video soubor** | Přehrávač videa uvnitř hry | **nedoporučuji**: nová závislost na třech desktopových systémech; sekvence snímků udělá totéž dnešním rendererem |

Text ve Střihu je jen „VAROVÁNÍ“ a tečky s pořadím bosse. Žádná jména bossů (24 skinů × 15 jazyků).

### 8.3 Obrat: pozadí

`ParallaxBg` dostane `frameAngle`: 0 v letu, `uprightAngle` v duelu. Po dobu Obratu se
**rovná kurzu lodi**, takže hvězdy ubíhají celou dobu proti čumáku a oko čte zatáčku, ne střih.

- Vrstvy jsou široké 600 a dlaždicují se jen po délce. V otočeném rámu musí pokrýt šířku
  ≈1067 a během otáčení i rohy: kreslit dlaždice tak, aby pokryly kružnici opsanou obrazovce.
  Napříč se druhá dlaždice **zrcadlí**, aby nebyl vidět šev; ověřit na třech skinech, jinak
  vrstvu v duelu zvětšit.
- V duelu pozadí teče `duelBgDrift` × rychlost letu (aréna stojí, vesmír ne).
- Průběh easeInOut, lehký nájezd kamery není potřeba — stačí protažení hvězd ve směru otáčení.

### 8.4 Konec duelu

Boss padne → dnešní `onBossKilled`. Dvě sekundy dohry, bonusy letí k lodi. Pak **zpětný obrat**
(1,0 s, čumák zpátky doleva, pozadí zpět) a dnešní konec úrovně. V aréně se neobrací: další
boss sestoupí shora po 1,5 s.

### 8.5 Pravidla

- Nový `lib/systems/duel_director.dart`: `DuelPhase { none, warning, cutIn, turn, entrance, fight, outro, turnBack }`.
  `game.duelActive => phase != none`.
- **Jediná brána:** `duelEnabled => platform.isDesktop && coopRole == CoopRole.none`.
  Platí pro obě schémata padu i klávesnici — duel je vlastnost hry na desktopu, ne sigilů.
- `Sector.addBossWave` se nemění. Když vlna bosse dozraje a `duelEnabled`, flotilu převezme
  director a **spawne ji až na začátku Nástupu**. `Fleet._spawnHostile` tak zůstane jediným
  místem, kde se násobí HP a kde startuje `bossUnder` — časovač neběží během Střihu.
- Hudba: `MusicDirector` se ptá na `game.bossActive || game.duelActive`.
- Nezranitelnost ve Střihu a Obratu: getter `SigilCaster.untouchable` dostane druhý zdroj (director),
  platný i při vypnutých sigilech. `Vessel` se na něj už ptá; žádná nová větev v `takeDamage`.
- Běžící sigil se na začátku Střihu ukončí bez ceny. NÁBOJ, FLOW a štít přechod nemění.
- Bonusy v duelu padají po `duelDown`; při Obratu a v dohře letí k lodi.
- Smrt hráče: dnešní průběh. Pokračuje-li hra, loď se vrátí na start duelu čumákem nahoru.
- Nastavení „Střih bosse: poprvé / vždy / nikdy“ (výchozí poprvé). Viděné bosse drží `SaveService` (skin + pořadí).

---

## 9. Aréna, lekce, kata, gauntlet

Aréna je vždy proti bossovi, takže **aréna je vždy duel**, bez přechodu: rám pozadí duelu,
loď dole uprostřed čumákem nahoru, boss přijde Nástupem.

- **Lekce se nemění.** Jsou to data v rámu lodi. Mění se duch (`arena_ghost.dart`): tah převede
  rámem postoje na polohu páčky a **drží modifikátor postoje**. Vstupní panel ukáže stisknutou
  spoušť — „ukaž ruce“ teď zahrnuje ukazovák.
- Popis tahu slovy („zleva středem doprava“) musí vznikat z dat a rámu padu. S čumákem nahoru
  sedí s grimoárem doslova. Ověřit, že texty nejsou psané ručně pro let.
- **Nová řada lekcí „Souboj“**, první v osnově: (1) miř a pal, (2) drž a čumák drží,
  (3) drž a táhni — sigil ve směru čumáku, (4) otoč se za bossem. Bez nich v aréně nejde nic.
- Boss v aréně používá `DuelBrain` podle stupně částí (0–4 částí = tahy bosse 1–4).
  Lekce mají nastavení „boss stojí“ (jen `hover`).
- Kata, gauntlet a drily běží v duelu, hodnocení se nemění.
- `test/arena_test.dart` dál hlídá, že každý sigil má lekci.
- **Sigily v letu zůstávají, jak jsou** (páčka kreslí i bez modifikátoru). Co se hráč naučí
  v aréně s drženým RT, platí v letu taky — RT tam drží stejně.

---

## 10. Videa (dopad na plán 29)

- Záběry z arény jsou teď na šířku a „nahoře je nahoře“. `bin/tutorial_assemble.py` je nesmí
  otáčet: `ROTATE_270` zůstane jen pro záběry z letu, řídí to pole `orientation` v `beats.json`.
- Formát 1080×1920 zůstává. Nové rozvržení shora: **hra 1080×1080** (nahrávací režim nastaví
  `gameHeight = gameWidth`, čtvercová aréna), **vstupní panel 1080×480** (větší pad a obrys
  ovladače se spouštěmi — postoj musí být vidět), titulek 180, spodních 180 prázdných.
  Druhá možnost je hra 4:3 (1080×810). Rozhodne pilot.
- Šablona videa (háček, jméno, tvar, zastavení, k čemu, dál) se nemění.
- **Pilot LOOP je natočený v letu.** Verdikt uživatele se proto týká hlasu, tempa a titulků;
  obraz se po kroku 2 natočí znovu.

---

## 11. Co-op a mobil

- **Mobil:** žádný duel, žádné míření. `duelEnabled` je tam vždy `false` a boss se chová
  přesně jako dnes. Otevřená otázka č. 5: postavit tvora hlavou nahoru i na mobilu.
- **Lokální co-op (druhý pad):** duel ano. P2 míří pravou páčkou jako ve schématu `classic`.
- **Síťový co-op:** ve verzi 1 klasický boss. Klient může být telefon na výšku nebo starší
  build; `VesselSnap` nemá kurz a `ProjSnap` nemá `vx`. Později nepovinný konec snapshotu
  `DuelSnap` (kurz obou lodí, úhel bosse, doba přechodu) jen mezi desktopy, vzor `SigilSnap`,
  bez změny `protocolVersion`.

---

## 12. HUD, zvuk, l10n, save, konfigurace

- **HUD:** lišta HP bosse nahoře uprostřed; `OffscreenEnemyMarkers` v duelu vypnuté;
  zaměřovací čára a pad (§6.7); pruh VAROVÁNÍ. Všechno Flame komponenty, žádné widgety v plátně.
- **Zvuk:** jen `just_audio`. Varování, obrat a nástup si zatím půjčí hotové SFX, stejně jako sigily.
- **l10n:** VAROVÁNÍ, dvě nápovědy, položky nastavení, názvy čtyř lekcí — ARB, 15 jazyků.
- **Save:** viděné bossy, ukázaná nápověda, volba Střihu.
- **Konfigurace:** nové konstanty v `game_config.dart`. Jsou to ladicí hodnoty duelu, ne čísla z VB6.

| Konstanta | Výchozí | Význam |
|---|---|---|
| `duelAimDeadzone` | 0,25 | od kdy páčka míří |
| `duelAimFireZone` | 0,25 | od kdy se mířením pálí (0,6 = vnitřní zóna jen míří) |
| `duelTurnRate` | 720°/s | rychlost otáčení čumáku (0 = hned) |
| `duelRunTrackRate` | 180°/s | sledování cíle při běžícím sigilu |
| `duelStanceOn` / `Off` | 0,15 / 0,08 | hystereze postoje na spoušti |
| `duelPadSnap` | 0 | přichytávání rámu postoje (0 nebo 8 směrů) |
| `duelWarning` / `CutIn` / `Turn` / `Entrance` | 1,5 / 2,2 / 1,2 / 1,5 s | doby přechodu |
| `duelBgDrift` | 0,35 | rychlost pozadí proti letu |
| `duelKeepOut` | 140 | nejmenší vzdálenost cíle tahu bosse od lodi |
| `duelShipStartV` / `duelBossHomeV` | 0,85 / 0,28 | výška startu lodi a domova bosse |

---

## 13. Testy

1. **Parita kurzu 0.** Po zavedení `ShipFrame` projde celá dnešní sada beze změny.
   `ship_frame_test`: převody jsou při kurzu 0 identita; polohy a rychlosti výstřelů všech slotů
   proti dnešním vzorcům.
2. **Ekvivariance** (`duel_equivariance_test`). Co loď udělá při kurzu *h*, je totéž co při
   kurzu 0, otočené o *h*. Pro každou zbraň, každý mod se směrem, každý sigil z katalogu
   a companiony; kurzy 0°, 45°, 90°, 180°, 270°; uprostřed velkého pole. **Jeden test pokryje
   všechno, co má „vpřed“** — a selže, kdykoli někdo přidá sigil psaný natvrdo po ose y.
3. **Geometrie** (`duel_space_test`). `duelUp` je na obrazovce nahoře; `uprightAngle` postaví
   obrázek hlavou nahoru; rohy `duelToGame`.
4. **Páčka** (`duel_stick_test`), obě mapování: RT + tah = HULL; LB + tah = ARMS bez RT;
   RB + tah = WING bez RT; krátký stisk RT při míření nic nezmění; po tahu se míření chytne až
   po průchodu středem; hystereze; akord míří; `classic` nikdy nekreslí; levák.
5. **Rám sigilů.** Pro 8 kurzů: tah po směru čumáku je STRIKE a loď se pohne směrem tahu
   na obrazovce („loď jde za palcem“).
6. **Střely.** Prohození hitboxu podle směru; ořez nepřátelských střel na čtyřech stranách;
   samonavádění trefí cíl v kterémkoli směru; vlnění kolmo na směr; odraz od čtyř stěn.
7. **Boss.** Mířená salva smí letět nahoru; střel za minutu × poškození stejně jako u klasického
   bosse při `Challenge.normal`; části klasického bosse na dnešních pozicích; `DuelBrain` se
   seedem je deterministický, nevyjede z pole a ctí `duelKeepOut`; tahy podle pořadí bosse.
8. **Director.** Pořadí dob; při Obratu není v poli nepřítel ani nepřátelská střela;
   `onBossSpawn` až na začátku Nástupu; hudba od Varování; přeskočení Střihu; bonusy přežijí;
   zpětný obrat; aréna bez přechodu; smrt hráče.
9. **Brány.** `duelEnabled` je `false` na mobilu a v síťovém co-opu; dnešní testy bosse tam
   projdou beze změny.
10. **Videa** (`tutorial/tests/`). Skládání neotáčí záběry s `orientation: duel`; nové rozvržení
    má správné rozměry.
11. **l10n.** Nové klíče ve všech ARB (16 souborů, 15 jazyků).

Gate: `flutter analyze`, `flutter test`.

---

## 14. Pořadí dodávky

| Krok | Obsah | Výstup |
|---|---|---|
| **0 — pilot ovládání** | `ShipFrame` jen pro přední a boční zbraně, kurz lodi, `duel_stick.dart` s oběma mapováními a oběma rámy padu, přepínače v menu arény. Boss = dnešní boss postavený na výšku nahoře uprostřed, pálí mířeně. Žádný přechod, žádný mozek, pozadí jen teče dolů. | Větev, bez tagu. macOS build v `--profile` pro uživatele s padem a 20s záznam do telefonu. **Stop: uživatel vybere mapování, rám padu a jestli se mířením střílí.** |
| **1 — rám lodi celý** | Všechny zbraně, mody, navádění, paprsky, satelit, companioni, sigily, MEGA BLAST, střely (§4, §5). Testy 1, 2, 6. V letu se nic nezmění. | PR + tag |
| **2 — boss a aréna** | `drawAngle`, `DuelBrain`, vzory útoků, části, aréna celá v duelu, duch, lekce „Souboj“, kata a gauntlet (§7, §9). | PR + tag. Uživatel hraje arénu. |
| **3 — přechod** | `DuelDirector`, střih ve hře, obrat pozadí, bonusy, hudba, časovač kampaně; duel v endlessu a kampani (§8). | PR + tag |
| **4 — ostatní vstupy** | Klávesnice, myš, `classic`, P2, nápovědy, nastavení, l10n, přeměření `bossUnder`. | PR + tag |
| **5 — videa** | Nahrávání a skládání na šířku, nové natočení pilotu LOOP (§10). | PR bez tagu |
| **6 — volitelně** | Generované detaily bossů (pilot na 1 skinu → 24), `DuelSnap` pro co-op mezi desktopy. | podle rozhodnutí |

Stojí se jen po kroku 0. Kroky 1–4 jdou za sebou; o merge a tagu rozhoduje uživatel.

Pojistka po cestě: do kroku 3 je duel jen v aréně, endless a kampaň hrají klasického bosse.
`duelEnabled` je jediná brána, takže vypnout duel je jedna řádka.

---

## 15. Otevřené otázky pro uživatele

Výchozí je vždy doporučení. Kromě č. 1–3 (pilot) se na nich implementace nezastavuje.

1. **Mapování:** `rtStance` (doporučeno — tvůj návrh, doplněný o LB/RB a o to, že RT dál střílí),
   nebo `ltStance` (RT jen pálí, postoj na LT)?
2. **Střílí se mířením** (doporučeno), nebo jen spouští?
3. **Rám padu:** „vpřed“ podle čumáku (doporučeno), nebo vždy nahoře?
4. **Detail bosse:** verze 1 jako střih ve hře z hotových spritů. Chceš potom generovanou
   sekvenci pro každý skin? (Video soubor nedoporučuji.)
5. **Mobil:** postavit tvora hlavou nahoru i tam? Duel na mobilu nebude.
6. **Síťový co-op** zůstane u klasického bosse, dokud nebude `DuelSnap`. V pořádku?
7. **Kampaň:** smím po pilotu přeměřit prahy `bossUnder` (25–40 s)?
8. **Po bossovi:** zpětný obrat do letu (doporučeno), nebo úroveň skončí v duelu?
9. **Bossové-lodě** (22 skinů bez tvora): otáčet je čumákem k hráči (doporučeno), dokud nebudou tvorové?

---

## 16. Ad absurdum (parkoviště, ne součást dodávky)

- Oddálená aréna: přerámované pole (`fieldRect`), boss dvakrát větší.
- Chapadlo chytí loď; vykroutíš se kroužením levou páčkou nebo BREAKem.
- Boss ve třetí fázi otočí obraz znovu.
- Přisluhovači bosse; dva bossové naráz.
- Zámek cíle: čumák míří sám a pravá páčka zůstane jen sigilům — záložní varianta, kdyby pilot
  ukázal, že mířit a kreslit jednou páčkou nejde.
- Duel i pro velké nepřátele mimo bosse.
- Fotorežim ve Střihu.
- Generované video nástupu pro trailer.
