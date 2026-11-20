# Plán 36: klávesnice a myš na desktopu a Steamu (zadání pro Opus)

Stav 2026-11-19, ověřeno na `main` (`446ae830`, verze 3.9.4, Flame 1.35.1). **Jen linie 3.x.** Do `release/2.9.x` se z plánu neportuje nic a mobilní ovládání se nemění.

Cíl: hráč na Steamu odehraje celou hru jen s klávesnicí a myší, bez ovladače. Myš řídí loď bez držení tlačítka, všechny akce mají klávesu nebo tlačítko myši, nápovědy mluví o zařízení, které hráč drží, a klávesy jdou přemapovat.

## 1. Kde to stojí (ověřeno v kódu)

### Co dnes funguje

| Oblast | Dnešní stav | Kde |
|---|---|---|
| Klávesnice v letu | WASD nebo šipky letí rychlostí 300 j/s × `agility`, Space drží palbu, Esc pauza | `lib/input/keyboard_input.dart`, `tyrian_game.dart` `_processDesktopInput` |
| Klávesnice, schéma sigil | numpad nebo blok `U I O / J K L / M , .` píše body sigilu, Shift ARMS, Ctrl WING, Alt FOCUS, F BREAK, R výměna (ťuk přední, držení 0,3 s boční), Tab grimoár, Q a E stupeň OVERSTREAM | `lib/input/keyboard_sigils.dart` |
| Duel | WASD letí, šipky míří a střílí, myš míří, tažení myší střílí | `_processDuelInput`, `onMouseMove` |
| Myš v letu | chová se jako prst: tažení se stisknutým tlačítkem hýbe lodí 1:1 a střílí, klik přepíná palbu | `lib/input/touch_controls.dart` |
| Menu | klávesy fungují v ComCenteru, výběru skinů, mapě kampaně, výsledku, aréně, grimoáru, pauze a po smrti | `lib/ui/*.dart`, `main.dart` |
| Pauza při ztrátě okna | `didChangeAppLifecycleState` hru pozastaví | `main.dart:456` |

Ovladač má přednost: klávesnice letí, jen když je páčka i palba ovladače v klidu.

### Co chybí

- **G1. Myš letí jen se stisknutým tlačítkem.** Loď nenásleduje kurzor. Pro hráče na PC je to nezvyklé a ruka se unaví.
- **G2. Pravé tlačítko, prostřední tlačítko a kolečko nedělají nic.** Druhá sada zbraní z plánu 34 (dva prsty) myší nejde.
- **G3. Sigil nejde nakreslit myší.** Jde jen napsat na klávesnici.
- **G4. Schéma classic má na klávesnici jen pohyb a palbu.** Druhá sada zbraní tam nemá klávesu.
- **G5. Klávesy se čtou jako `LogicalKeyboardKey`, tedy podle znaku.** Na rozložení AZERTY leží WASD jinde a blok `U I O / J K L / M , .` se rozpadne.
- **G6. Klient co-opu na desktopu neletí klávesnicí ani ovladačem.** `update()` u klienta skončí před voláním `_processDesktopInput` (`tyrian_game.dart`, kolem řádku 1094). Funguje jen tažení myší.
- **G7. Nápovědy mluví o ovladači.** `hintHop`, `hintStream`, `grimoireHint` i `padControlsHint` zmiňují páčky a tlačítka. Zařízení rozlišuje jen duel, a to podle `gamepadInput.isConnected`, ne podle toho, čím hráč právě hraje.
- **G8. Klávesy nejdou přemapovat.** Pauza nabízí jen schéma ovladače, leváka a střih před duelem.
- **G9. Hangár a dialog připojení nemají ovládání klávesami.** `hangar_panel.dart` a `join_dialog.dart` neobsahují žádný `LogicalKeyboardKey`.

### Co je potřeba ověřit v kroku 0

Tohle plyne z rozboru kódu, ale nikdo to nezkusil na běžící hře:

- **Kurzor v letu.** `GameWidget(game: _game)` (`main.dart:913`) nenastavuje `mouseCursor`, takže šipka nejspíš zůstává vidět přes loď.
- **Klik bez pohybu v duelu.** Palbu zapíná `onDragStart`. Flame staví tažení na `ImmediateMultiDragGestureRecognizer`, který čeká na pohyb. Stisk tlačítka bez pohnutí myší tedy nejspíš nevystřelí.
- **Kolize se systémem:**
  - Alt (FOCUS) + Enter přepne celou obrazovku (`main.dart:419`).
  - Ctrl (WING) + šipky na macOS přepínají plochy.
  - Pětkrát Shift (ARMS) na Windows vyvolá Jedním prstem.
  - Tab (grimoár) může sebrat přechod fokusu ve Flutteru.
- **Pauza při Alt+Tab na Windows a Linuxu.** Na macOS stav `inactive` přichází, jinde to ověřit.

### Co ukázala fáze 0 (2026-11-19, testy `test/keyboard_mouse_test.dart`)

- **Flame nehlásí u tažení typ zařízení.** `FlameDragAdapter` ve Flame 1.35.1 skládá `DragStartDetails` bez `kind`, takže `DragStartEvent.deviceKind` je vždy `unknown`. Plán v §3.3 počítal s tím, že tažení myší pozná podle `deviceKind`. Neplatí to: první verze testu ukázala, že tažení myší dál hýbe lodí jako prst.
- **Oprava:** tažení, které začne se stisknutým tlačítkem myši, patří myši (`TouchControls.touchMouseHeld`). Syrové události dorazí do `MouseInput` dřív, než aréna gest tažení spustí, takže je tlačítko v tu chvíli už zapsané. U klepnutí `deviceKind` funguje.
- **Stisk bez pohybu:** přes syrové události (`MouseFeed`) se zapíše hned, test to potvrzuje.
- **Naživo neověřeno:** skrytý kurzor, kolize kláves se systémem a pauza při Alt+Tab na Windows a Linuxu. Ověří se na prvním buildu na Steam beta (kontrolní seznam v §5).

## 2. Rozhodnutí, která platí (neptat se znovu)

- Jen 3.x a jen desktop (`platform.isDesktop`). Telefony a tablety zůstávají beze změny.
- Sigily jsou jen na desktopu (plán 28). Schémata `classic` a `sigil` zůstávají obě.
- Dotyk na desktopu dál funguje jako dotyk: dotyková obrazovka Steam Decku nebo notebooku se řídí plánem 34.
- Staty z VB6 se nemění. `Challenge` nedostane žádné nové místo škálování.
- Hra čte XInput, GameController a `/dev/input/js`. Steam Input API se neimplementuje (plán 28 §12).
- Platí zákaz vydání: žádný tag, žádná Steam větev `default`. Testovací buildy jdou jen na Steam větev `beta`.

## 3. Návrh

### 3.1 Výchozí ovládání

| Akce | Klávesnice | Myš |
|---|---|---|
| Pohyb | WASD nebo šipky | loď letí za kurzorem |
| Palba | Space (držet) | levé tlačítko (držet) |
| Druhá sada zbraní, schéma classic | levý Shift (držet) | pravé tlačítko (držet) |
| Sigil, schéma sigil | numpad nebo `U I O / J K L / M , .` | pravé tlačítko a tah (§3.4) |
| ARMS, WING | Shift, Ctrl | bez výchozího tlačítka |
| FOCUS | Alt | prostřední tlačítko |
| BREAK | F | |
| Výměna zbraně | R | |
| OVERSTREAM | Q ubere, E přidá | kolečko |
| Grimoár | Tab | |
| Pauza | Esc | |
| Celá obrazovka | F11, Alt+Enter | |

V duelu zůstává dnešní rozdělení: WASD letí, šipky nebo myš míří, palba je Space nebo levé tlačítko.

### 3.2 Vrstva akcí

Nový soubor `lib/input/bindings.dart`:

- `enum InputAction` se všemi akcemi z tabulky.
- `Bindings`: každá akce má nejvýš dvě vazby. Vazba je `PhysicalKeyboardKey`, tlačítko myši nebo směr kolečka.
- Výchozí hodnoty podle §3.1. Uložení do `SharedPreferences` stejně jako `PadSettings`.
- `KeyboardInput` začne sledovat i fyzické klávesy. `KeyboardSigils` a `_processDesktopInput` se ptají na akce, ne na konkrétní klávesy.

Tím se vyřeší G5: vazba drží polohu klávesy, ne znak. Popisek klávesy pro nápovědu se bere z poslední události té klávesy (`logicalKey.keyLabel`). Dokud ji hráč nestiskl, ukáže se americký popisek.

Menu se nepřemapovává. Šipky, WASD, Enter, Space a Esc v menu zůstávají pevné.

### 3.3 Myš

Nový soubor `lib/input/mouse_input.dart`. `GameWidget` se obalí Flutter widgetem `Listener` a ten plní stav: poloha, maska tlačítek, napočítané kroky kolečka. Hra stav čte jednou za snímek v `_processDesktopInput`, stejně jako klávesnici.

Důvod: syrové události nemají arénu gest. Stisk bez pohybu je hned stisk a pravé tlačítko i kolečko přijdou stejnou cestou.

`TouchControls` na desktopu přeskočí události s `deviceKind == PointerDeviceKind.mouse`. Dotyk se dál řídí plánem 34. `DragStartEvent` i `TapDownEvent` ve Flame 1.35.1 pole `deviceKind` mají.

**Let za kurzorem:**

- Cíl je poloha kurzoru převedená do světa přes `camera.globalToLocal`, stejně jako dnes míření v duelu. Loď k cíli letí nejvýš rychlostí `mouseFollowSpeed` (nová konstanta v `game_config.dart`, výchozí hodnota podle otázky 1).
- Strop rychlosti je nutný. Sigil, který pohne lodí, ji odnese od kurzoru. Bez stropu by se loď po jeho skončení vrátila skokem.
- Platí `caster.control` jako u páčky: `none` loď neřídí, `verticalOnly` jen podél osy, `full` volně. FOCUS násobí rychlost `focusSpeed`.
- Kurzor je v letu skrytý (`SystemMouseCursors.none`). Když je loď od cíle dál než pár bodů, ukáže se na místě kurzoru malý zaměřovač.
- V menu, v pauze a po smrti je kurzor vidět.
- Klávesnice a myš se o loď nepřetahují. Drží-li hráč klávesu pohybu, letí klávesnice. Myš převezme řízení, až se kurzor pohne aspoň o 8 bodů.
- Okno bez celé obrazovky: když kurzor vyjede z okna, loď zůstane u okraje.

**Tlačítka:**

- Levé drží palbu. V duelu funguje i bez pohybu myši.
- Pravé ve schématu classic drží druhou sadu zbraní přes `vessel.setAlternate`. Platí stejná brána jako u dvou prstů (`touchSwaps`): jen sólo a hostitel, ne v duelu.
- Kolečko a prostřední tlačítko fungují jen ve schématu sigil.

### 3.4 Sigil myší

Pravé tlačítko ve schématu sigil udělá z myši pravou páčku:

- Stisk zapamatuje kotvu. Výchylka páčky je `(kurzor − kotva) / mouseSigilRadius`, oříznutá na jednotkový kruh.
- Výchylka jde do `caster.input(...)` stejnou cestou jako pravá páčka ovladače. Rozpoznávač se nemění.
- Puštění tlačítka vrátí páčku do středu a tím gesto ukončí.
- Vrstvu vybírá Shift nebo Ctrl, držené při stisku pravého tlačítka.
- Po dobu kreslení loď nenásleduje kurzor. Letět jde dál přes WASD.
- V duelu pravé tlačítko otevírá postoj stejně jako RT nebo LT podle `DuelBinding`.

Rizika, která rozhodne až zkouška:

- Rozpoznávač je vyladěný na dráhu a rychlost palce. Poloměr `mouseSigilRadius` a prodlevy se musí doladit na všech tvarech z katalogu.
- Po puštění je kurzor jinde než loď. Loď za ním doletí, takže poloměr má zůstat malý.

Proto je to samostatná fáze. Když zkouška nedopadne, sigily zůstanou na klávesnici a pravé tlačítko ve schématu sigil nebude dělat nic.

### 3.5 Klávesnice

- Schéma classic dostane druhou sadu na levém Shiftu (držet), stejnou cestou jako pravé tlačítko myši.
- Alt+Enter nepřepíná celou obrazovku během hry (`state == playing`). F11 funguje vždy. Tím zmizí kolize s FOCUS.
- Ostatní kolize z kroku 0 se řeší druhou výchozí vazbou, ne změnou první.

### 3.6 Klient co-opu

Klávesnice, myš i ovladač na klientovi posouvají `_clientTargetX` a `_clientTargetY` a volají `coopClient.sendInput`, stejně jako dnes `touchSteer`. Protokol se nemění: klient posílá polohu a palbu. Sigily a druhá sada na klientovi dál nejsou.

### 3.7 Nápovědy podle zařízení

- Nový stav „poslední použité zařízení“: ovladač, klávesnice s myší, dotyk. Mění ho skutečný vstup, ne to, co je připojené.
- Podle něj se vybírá text v `duel_hud.dart`, `sigil_hud.dart`, grimoáru, lekcích a v řádku nápovědy ComCenteru.
- Texty pro klávesnici a myš jsou nové klíče v ARB. Názvy kláves se dosazují z `Bindings`, takže přemapování se v nápovědě projeví samo.
- Každý nový klíč znamená 43 překladů. Počet nových textů držet do deseti.

### 3.8 Obrazovka Ovládání

Nová položka v pauze, jen na desktopu:

- Seznam akcí se dvěma vazbami. Výběr akce a stisk klávesy nebo tlačítka myši vazbu změní.
- Kolize: nová vazba se vezme té akci, která ji měla. Hráč to vidí hned v seznamu.
- Esc, F11 a klávesy menu přiřadit nejdou.
- „Obnovit výchozí“ vrátí §3.1.
- Obrazovka se ovládá myší, klávesnicí i ovladačem, jako ostatní menu.

### 3.9 Menu

- Hangár a dialog připojení dostanou ovládání klávesami (G9).
- Esc se ve všech panelech chová jako zpět. Projít panel po panelu a doplnit, kde chybí.
- Kolečko posouvá seznamy.
- Najetí myší přesune zvýraznění, aby myš a klávesy neukazovaly na dvě různé položky.

### 3.10 Zamítnuto

- **Relativní myš se zámkem kurzoru.** Flutter na desktopu zámek kurzoru nenabízí, chtělo by to nativní kód pro tři systémy. Bez zámku se kurzor zastaví o okraj obrazovky a loď s ním.
- **Přemapování ovladače.** Není součástí plánu.
- **Klávesnice jako druhý hráč vedle ovladače.** Viz otázka 5.

## 4. Fáze

Každá fáze je jeden PR do `main`. Po zeleném CI jde testovací build na Steam větev `beta`.

| Fáze | Obsah | Řeší |
|---|---|---|
| 0 | Testy přes skutečné události myši a kláves na skutečném `GameWidget`. Ověření bodů z §1. Krátká zpráva vlastníkovi, co se liší od plánu. | |
| 1 | `MouseInput`, `Bindings` s pevnými výchozími vazbami, fyzické klávesy. Let za kurzorem, palba a druhá sada myší, skrytý kurzor. Druhá sada na Shiftu. Klient co-opu. | G1, G2, G4, G5, G6 |
| 2 | Poslední použité zařízení, nápovědy a překlady. | G7 |
| 3 | Sigil myší, kolečko a prostřední tlačítko. Jen po souhlasu vlastníka (otázka 2). | G3 |
| 4 | Obrazovka Ovládání s přemapováním. | G8 |
| 5 | Menu: hangár, dialog připojení, Esc, kolečko, najetí myší. | G9 |

Fáze 2, 4 a 5 na sobě nezávisí a jdou v libovolném pořadí. Fáze 3 potřebuje fázi 1.

## 5. Testy

Poučení z plánu 34: test, který volá metody přímo, nechytí chybu v pořadí událostí. Vstup se proto testuje přes skutečné události.

- **Přes `GameWidget`** (`testWidgets`, ukazatel `kind: mouse`):
  - Pohyb bez tlačítka pohne lodí.
  - Stisk bez pohybu střílí, i v duelu.
  - Pravé tlačítko nasadí druhou sadu a puštění ji vrátí.
  - Ukazatel `kind: touch` na desktopu dál projde `TouchControls`.
- **Jednotkové:**
  - `Bindings`: výchozí hodnoty, uložení a načtení, kolize, obnovení.
  - `KeyboardSigils` nad fyzickými klávesami. Stávající `keyboard_sigils_test.dart` musí projít po úpravě na akce.
  - Let za kurzorem: strop rychlosti, `caster.control`, FOCUS, předání mezi klávesnicí a myší.
  - Virtuální páčka z myši: každý tvar z katalogu se rozpozná stejně jako z páčky.
  - Klient co-opu: klávesnice i myš volají `sendInput`.
- **Brána před pushem** v `tyrian_mobile/`: `flutter analyze --no-fatal-infos` a `flutter test`.

Po každém buildu na Steam `beta` napsat vlastníkovi, co vyzkoušet. Po fázi 1:

1. Pohnu myší bez tlačítka: loď letí za kurzorem, šipka není vidět.
2. Držím levé tlačítko: loď střílí. Pustím: přestane.
3. Schéma classic, držím pravé tlačítko nebo Shift: druhá sada. Pustím: první.
4. Držím W a pohnu myší o kousek: loď dál poslouchá klávesnici.
5. Esc: pauza a kurzor je vidět. Pokračovat: kurzor zmizí.
6. Duel: stisknu levé tlačítko a nehýbu myší. Loď střílí.
7. Alt+Tab pryč a zpět: hra je v pauze.
8. Co-op, klient na PC: loď letí klávesnicí i myší.
9. Dotyková obrazovka (Steam Deck): jeden a dva prsty fungují jako dřív.

## 6. Otázky na vlastníka

1. **Rychlost lodi za myší.** Doporučení: rychlá, aby myš působila jako prst na telefonu (začít na 1200 j/s, čtyřnásobek klávesnice). Druhá možnost je stejný strop jako klávesnice a ovladač (300 j/s × `agility`). Pak jsou zařízení na PC vyrovnaná, ale myš bude líná.
2. **Sigily myší** (§3.4). Doporučení: ano, jako fáze 3 se zkouškou. Jinak zůstanou sigily na klávesnici a ovladači.
3. **Palba.** Doporučení: držet, jako dnes Space. Druhá možnost je přepínač jako klepnutí na telefonu, nebo volba Autopalba v Ovládání.
4. **Přemapování kláves** (fáze 4). Doporučení: ano, hráči na Steamu ho čekají. Jde odložit za vydání.
5. **Klávesnice a myš jako hráč 1 a jediný ovladač jako hráč 2** v místním co-opu. Dnes potřebuje druhý hráč druhý ovladač. Doporučení: mimo tento plán.

Fáze 0 a 1 na odpovědích nestojí, kromě čísla z otázky 1. To je jedna konstanta.

## 7. Pravidla práce

Platí pravidla z plánu 31 §5 a §6 a z plánu 32 §6. Navíc:

- Mobilní cesta se nemění. Každá změna v `TouchControls` musí nechat `touch_controls_test.dart` a `touch_fingers_test.dart` zelené bez úprav testů.
- Ovladač se nemění: `pad_scheme.dart` a čtení `PadFrame` zůstávají. Nová vrstva akcí se týká klávesnice a myši.
- Nové konstanty patří do `game_config.dart`.
- Texty jdou do všech ARB souborů. Bez nových textů v kódu.
- `saveVersion` se nezvedá. Vazby jsou v `SharedPreferences`, ne v uložené hře.

## 8. Kdy stát a ptát se

- Merge PR, tag, zvednutí verze, vydání na Steam do `default`.
- Když krok 0 ukáže jiné chování, než popisuje §1.
- Když zkouška sigilů myší (fáze 3) nedá spolehlivé rozpoznání všech tvarů.
- Když by změna zasáhla rozpoznávač sigilů, protokol co-opu nebo dotykové ovládání.
- Před fázemi 3 a 4, dokud vlastník neodpověděl na otázky 2 a 4.

## 9. Zadání do chatu

> Implementuj podle `tyrian_mobile/Prompts/36-PLAN-klavesnice-a-mys.md`. Začni fází 0: testy přes skutečné události myši a kláves a ověření bodů z §1. Napiš mi, co se liší od plánu. Pak fáze 1 na větvi `feat/keyboard-mouse`. Po zeleném CI otevři PR a pošli testovací build na Steam beta. PR nemerguj a před fázemi 3 a 4 se zeptej.
