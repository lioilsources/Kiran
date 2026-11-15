# Plán 32: od zapnutí ke hře — rychlý start, řazení skinů, přepnutí zbraní druhým prstem, +DPS (zadání pro Opus)

Stav 2026-11-14. `main` je 3.9.3, linka 2.x (`release/2.9.x`) je 2.10.6.

Cíl: zkrátit cestu od zapnutí hry k prvnímu výstřelu a zjednodušit rozhodování v obchodě. Čtyři malé změny, každá do **obou linek**: nejdřív `main` (3.x), pak backport do `release/2.9.x` jako PR s příponou `-2.10`. Mobilní obchody prodávají linku 2.x, takže backport není volitelný.

Pořadí: Q1 + Q2 (start) → Q3 (přepnutí zbraní) → Q4 (DPS).

## 1. Kde to stojí (ověřeno v kódu 2026-11-14)

Názvy funkcí platí pro obě linky, pokud není řečeno jinak. Čísla řádků se mezi linkami liší, hledat podle jména.

### Start hry

- Klepnutí na kartu skinu už dnes vybírá i spouští: `_selectAndPlay` v `lib/ui/skin_selector.dart` načte skin a zavolá `onPlay`, to je `_startAsAutoHost` v `lib/main.dart`.
- `_startAsAutoHost` vždy otevře ComCenter (`_showComCenter = true`). Do sektoru se jde až tlačítkem START (`_onComCenterStart`: uloží postup, dočte pozadí zóny, `startGame()`).
- Nový pilot (`Vessel.newGame`) má 0 kreditů, Bubble Gun vpředu a základní generátor. V ComCenteru si při prvním spuštění nemá co koupit.
- `_runInProgress` říká, jestli se při startu načetl uložený postup (`loadProgress`). První uložení dělá až `_onComCenterStart`.
- Smrt v sólu vrací do ComCenteru sektoru 1 se zachovanými zbraněmi a kredity (`_respawnAtFirstSector`).
- Na 3.x má hlavní menu navíc KAMPAŇ, ARÉNU a volbu obtížnosti. Těch se plán netýká.

### Skiny

- `kSkins` v `lib/services/skin_registry.dart` je seřazený podle roku (rok je v názvu, např. `Arcade Formation (1981)`). Řazení nic nehlídá.
- Oba výběry iterují `kSkins` přímo: `SkinSelector` (hlavní menu a pauza) přes index, `SkinShopSection` (ComCenter) přes id. Fokus padu (`_focusIndex`, `_padFocus`) je index do `kSkins`; za skiny následují další položky (`_challengeIndex`, `_campaignIndex`, `_arenaIndex`, `_quitIndex`).
- `SkinStoreService.isUnlocked(id)`: zdarma jsou skiny bez `productId` (`galaga`, `geometry_wars`, `default`), koupené jsou v `_unlocked`. Kde obchod není (`supported == false`, tedy desktop a Steam) a v testerském buildu je odemčeno všechno.
- Po dokončeném nákupu hlavní menu skin rovnou vybere a spustí (`_onStoreChanged`).

### Zbraně a dotyk

- `Vessel.devices` jsou osazené zbraně, `Vessel.hangar` koupené a neosazené (drží slot i level). `fitWeapon(type, slot)` osadí zbraň a tu současnou přesune do hangáru; přepnutí je zdarma. Hangár je per slot: levý a pravý bok vlastní zbraně nezávisle.
- 3.x má přepnutí na padu (Y) a klávesnici (R) v `SigilCaster` (`_swapFront`, `_swapSides`, `_fit`): bere **první** položku hangáru pro slot, po přepnutí nastaví `cd = cooldown + config.swapDelay` (0,5 s) a ukáže název zbraně. Caster běží jen na desktopu. Linka 2.x přepnutí za letu nemá vůbec.
- Dotyk je v `TyrianGame` (`onDragStart`, `onDragUpdate`, `onDragEnd`, `onTapDown`) a **nerozlišuje prsty**: drží jediné `_prevDragPos`. Druhý prst dnes škodí: jeho `onTapDown` přepne `vessel.fire` (vypne střelbu) a jeho tah přepíše `_prevDragPos`, takže loď skočí. Události Flame nesou `pointerId`.
- Co-op: na 2.x je vypnutý (`kCoopEnabled`). Na 3.x klient posílá hostiteli jen polohu a střelbu.

### DPS

- `Device.dps` = `damage / cooldown` (paprsky `damage * seqs / cooldown`). **Rychlost střelby tedy existuje**: je to `cooldown` (sekundy mezi výstřely), rate = `1 / cooldown`. Upgrade násobí damage (`upgDamageMultiplier`) a dělí cooldown (`upgCooldownDivisor`). Na 3.x ji ještě škáluje hloubka triggeru (`fireRateMult`) a mody. V UI se rate nikde neukazuje.
- `Vessel.totalDps` sčítá všechny osazené zbraně, i ty, které generátor neutáhne. **Nesahat na něj**: plní `lastMaxDps` a tím škálování nepřátel (`sector.dart`, parita s VB6).
- 3.x má `Campaign.poweredDps(vessel)`: jen zbraně, které generátor utáhne, s mody (`canPower`, `effectiveDps`). 2.x nic takového nemá; „off“ je tam zbraň s `pwrNeed > genMax` (viz `genInfo`).
- ComCenter (`lib/ui/com_center.dart`): panel STATS ukazuje `vessel.totalDps`. Chip zbraně (`_buildChip`) má pod názvem jeden řádek: body k odemčení, `Lv.N` u vlastněné, cenu u nevlastněné. Tlačítka řádku (`_buildRowButtons`, `_upgradeButton`) ukazují jen cenu. Přetečení hlídá `test/com_center_layout_test.dart`.
- HUD (`lib/ui/osd_panel.dart`, `_buildVesselStats`): pruhy HP, štít, generátor a kredity. DPS v něm není.
- Analytika v aplikaci není. Konverze se tedy neměří a tento plán měření nezavádí; zavádí ho plán 33.

## 2. Rozhodnutí vlastníka (ze zadání, neptat se znovu)

- Při prvním spuštění stačí klepnout na skin: ComCenter se celý přeskočí a hra jde rovnou do sektoru.
- Skiny jsou v obou výběrech řazené podle roku vydání s jedinou výjimkou: skiny, které hráč má (zdarma nebo koupené), jsou nahoře.
- Položení druhého prstu přepne zbraně a samo vybere druhou nejsilnější zbraň, kterou má hráč pro přední a boční sloty koupenou.
- V ComCenteru je pod zbraní vždy vidět, kolik DPS nákup nebo upgrade přidá. DPS je vidět i v HUDu.
- Změny jdou do 2.x i 3.x.

Doplněno 2026-11-14 (odpovědi na otázky z první verze plánu):

- Y a R na 3.x se nemění. Pravidlo „dvě nejsilnější“ platí jen pro dotyk.
- ComCenter ukazuje u vybrané zbraně i rozklad damage × rate. V HUDu rate není.
- ComCenter se přeskakuje jen do jeho prvního zobrazení. Po smrti s nulou kreditů se nepřeskakuje.
- Nápověda k druhému prstu je jen v ComCenteru, ve hře ne.

## 3. Návrh

### Q1: první spuštění přeskočí ComCenter

Chování: nový hráč klepne na skin a letí. ComCenter poprvé uvidí po prvním sektoru nebo po první smrti, tedy až bude mít kredity.

- Příznak `comcenter_seen` v `SharedPreferences` (ne v save souboru, `saveVersion` se nezvedá). Nastaví se na `true` pokaždé, když se ComCenter zobrazí.
- Výchozí hodnota pro stávající hráče: když příznak chybí, bere se `_runInProgress` z načtení při startu. Kdo má uložený postup, ComCenter vidí jako dřív.
- V `_startAsAutoHost`: když příznak není nastavený, místo zobrazení ComCenteru zavolat cestu tlačítka START (`_onComCenterStart`). Nepsat druhou kopii startu.
- Hráč, který první sektor nedohraje a hru zavře, příště zase letí rovnou. To je záměr: v ComCenteru by pořád neměl co dělat.
- Netýká se: kampaně, arény, připojení do co-opu, výběru skinu z pauzy.
- Testy: widget test obou větví (`comcenter_seen` chybí a save není → hra běží bez ComCenteru; save je → ComCenter). Stávající `widget_test.dart` a `roguelike_progression_test.dart` musí projít beze změny smyslu.

### Q2: vlastněné skiny nahoře

- Jedna funkce pro oba výběry, např. `SkinStoreService.orderedSkins`: stabilní rozdělení `kSkins` na odemčené a zamčené. Rok se nikde neparsuje, pořadí uvnitř skupin dává `kSkins`.
- `SkinSelector` i `SkinShopSection` přejdou z `kSkins[i]` na tento seznam. Počet položek se nemění, takže indexy za skiny (`_challengeIndex` a další) zůstávají.
- Fokus drží **id skinu**, ne index: po nákupu se seznam přeřadí (`_onStoreChanged`) a fokus i posun musí zůstat na stejné kartě. Klíče karet v hlavním menu převést z indexu na id, jako to má ComCenter.
- Na desktopu a v testerském buildu je odemčeno vše, pořadí tam zůstane čistě podle roku.
- Testy: rozdělení (zdarma a koupené první, uvnitř skupin pořadí `kSkins`); bez obchodu se seznam rovná `kSkins`; nový test v `skin_registry_consistency_test.dart`, že roky v názvech `kSkins` neklesají. `skin_switch_test.dart` musí projít.

### Q3: druhý prst přepne zbraně

Pravidlo výběru, pro každý ze slotů přední, levý a pravý zvlášť:

1. Seřadit vlastněné zbraně slotu (osazená + hangár) podle DPS na jejich současném levelu.
2. Je-li osazená ta nejsilnější, osadit druhou nejsilnější. Jinak osadit nejsilnější.
3. Slot s jedinou zbraní se nemění. Když se nezmění žádný slot, gesto nedělá nic.

Opakované klepnutí tak přepíná mezi dvěma nejsilnějšími sadami. Generátor se nepřepíná.

- Logika patří do `Vessel` (např. `swapToAlternate()`, vrací, jestli se něco změnilo), ať ji použije dotyk na obou linkách. Po přepnutí stejná prodleva jako na 3.x: `cd = cooldown + swapDelay`. Na 2.x přidat `swapDelay = 0.5` do `game_config.dart`. Na 3.x může `SigilCaster._fit` sdílet stejnou pomocnou funkci; chování Y a R se nemění.
- Zpětná vazba: zpráva s názvem přední zbraně a novým DPS (`showMessage`), HUD z Q4 se přepíše sám.
- Dotyk: zavést sledování prstů podle `pointerId`. První položený prst je **hlavní**: hýbe lodí a drží střelbu jako dnes. Každý další prst položený, dokud hlavní drží, je **gesto přepnutí** (jednou na položení). Další prst nesmí přepnout `vessel.fire`, přepsat `_prevDragPos` ani svým zvednutím ukončit střelbu. Když se hlavní prst zvedne, dalším hlavním je až nově položený prst.
- Stavový automat prstů vytáhnout do malé čisté třídy bez Flame, aby šel testovat: posloupnosti „dolů A, dolů B, nahoru B, nahoru A“, „dolů A, dolů B, nahoru A, tah B“ a klepnutí jedním prstem (dnešní přepnutí střelby zůstává).
- Pozor na pořadí událostí Flame: `onTapDown` přijde hned při položení, `onDragStart` až po pohybu. Hlavní prst se proto určuje už v `onTapDown`.
- Platí jen pro sólo a pro hostitele. Klient v co-opu (3.x) gesto ignoruje, protokol se nemění. V duelu na 3.x dotyk míří a střílí, tam se gesto nezavádí.
- Stav po přepnutí zůstává osazený i v ComCenteru a v uložení. Nic se na konci sektoru nevrací.
- Objevitelnost: jeden nový text (klíč např. `swapHint`, „Druhým prstem přepneš zbraně“) v ComCenteru, zobrazený jen na dotykových platformách a jen když má některý slot aspoň dvě zbraně. Patří do všech ARB (45 na `main`, 16 na 2.x).
- Testy: `loadout_inventory_test.dart` rozšířit o pravidlo výběru (dvě zbraně, tři zbraně, osazená slabší, levý a pravý nezávisle, levely zůstávají, hangár nekreslí proud). Na 3.x musí projít `pad_scheme_test.dart` a `keyboard_sigils_test.dart`.

### Q4: +DPS v ComCenteru a DPS v HUDu

Základ čísla: DPS zbraní, které generátor utáhne. Na 3.x `Campaign.poweredDps`, na 2.x nový getter `Vessel.poweredDps` (zbraň s `pwrNeed > genMax` počítá 0). Stejný základ použije panel STATS, HUD i rozdíly, jinak si čísla budou odporovat. `totalDps` zůstává, jak je.

- **Rozdíl pod chipem** (druhý řádek pod `Lv.N` nebo cenou), u každého odemčeného chipu v řadách přední, levý, pravý:
  - osazená zbraň: o kolik stoupne DPS upgradem; na max levelu nic;
  - zbraň v hangáru: rozdíl proti osazené, na svém levelu;
  - nevlastněná: rozdíl proti osazené po koupi (level 1); do prázdného slotu celé její DPS.
- Formát `+48` zeleně, `−12` červeně, `0` šedě, velká čísla přes `fmtNum`. Text `DPS` se u chipu neopakuje (je v panelu), nový l10n klíč není potřeba.
- Rozdíl se počítá bez zásahu do lodi: čistá funkce nad kopií hodnot (např. `Device.fromType(type, slot)` pro katalog a výpočet dalšího levelu z `upgDamageMultiplier` a `upgCooldownDivisor`). Na 3.x přes `planFor(...).dpsFor(...)`, ať sedí i s mody; ověřit, že plán jde spočítat pro neosazenou zbraň.
- Zbraň, kterou by generátor neutáhl, ukáže rozdíl podle skutečnosti (tedy záporný nebo nulový) v barvě `danger`. Hráč tak nekoupí zbraň, která nebude střílet.
- **HUD**: malý údaj `DPS n` u pruhů v `_buildVesselStats`, stejný základ. Mění se při přepnutí zbraní i při ztrátě proudu.
- Layout: `com_center_layout_test.dart` musí projít na nejužší podporované šířce; druhý řádek chipu nesmí zvětšit výšku řady tak, aby obrazovka přetekla.
- Testy: pro každý případ (upgrade, přepnutí z hangáru, koupě, prázdný slot, zbraň bez proudu) provést akci na lodi a porovnat změnu čísla v panelu s předpovězeným rozdílem. Musí se rovnat.
- **Rozklad damage × rate**: pod každou řadou zbraní jeden malý řádek pro vybraný chip (čekající na koupi, jinak osazený) ve tvaru `12 × 4.0/s`. Damage je to, co vstupuje do `Device.dps` (u paprsků už vynásobené `seqs`), rate je `1 / cooldown` na jedno desetinné místo. Součin se musí rovnat DPS zbraně. Bez nového l10n klíče. Řádek nesmí rozbít `com_center_layout_test.dart`.

## 4. PR a verze

| Krok | PR do `main` | Backport do `release/2.9.x` |
|---|---|---|
| Q1 + Q2 | `feat/quick-start` | `feat/quick-start-2.10` |
| Q3 | `feat/touch-swap` | `feat/touch-swap-2.10` |
| Q4 | `feat/dps-delta` | `feat/dps-delta-2.10` |

- Backport není cherry-pick naslepo: ComCenter, `Vessel` i výběr skinů se mezi linkami liší (2.x nemá mody, trupy, caster ani kampaň). Přenést chování a testy, ne diff.
- Verze: další patch obou linek (3.9.x a 2.10.x) podle toho, co vyjde dřív, viz §5. Číslo 3.10.0 je rezervované plánem 27. Zvednutí verze, tag a vydání do obchodů jen na slovo vlastníka.
- Pracovat ve vlastním worktree. Hlavní worktree je pozadu za `origin/main` a má nesledované soubory; nechat je být.

## 5. Otázky na vlastníka

Žádná otevřená. Čtyři otázky z první verze plánu vlastník zodpověděl 2026-11-14, odpovědi jsou v §2.

Pořadí vůči plánu 33 (analytika): doporučení je vydat nejdřív měření a tyto změny až ve verzi po něm, aby bylo s čím srovnávat. O pořadí vydání rozhoduje vlastník; implementovat lze souběžně.

## 6. Pravidla práce

Platí pravidla z plánu 31 §5 a §6. Navíc:

- Staty z VB6 se nemění: žádná změna damage, cooldownu, cen ani `totalDps` a `lastMaxDps`.
- Nový text do všech ARB dané linky. `vessel.dart` a `save_service.dart` mají konce řádků CRLF. `saveVersion` se nezvedá.
- Gate před pushem v `tyrian_mobile/`: `flutter analyze --no-fatal-infos` a `flutter test`. CI drží Flutter 3.41.
- Dvouprsté gesto se na simulátoru ověří jen zčásti. Po Q3 napsat vlastníkovi, co vyzkoušet na telefonu: tah jedním prstem, klepnutí druhým, zvednutí v obou pořadích, střelba přitom nesmí vypadnout a loď nesmí skočit.

## 7. Kdy stát a ptát se

- Merge, tag, zvednutí verze, vydání do obchodů a na Steam.
- Cokoli, co by změnilo chování mimo čtyři body z §2 (například ovládání padem, obtížnost, ekonomiku).
- Když se ukáže, že některý bod nejde na 2.x udělat bez většího přenosu kódu z 3.x.

## 8. Zadání do chatu

> Implementuj podle `tyrian_mobile/Prompts/32-PLAN-rychly-start.md`. Začni Q1 + Q2 na `main`, pak jejich backport do `release/2.9.x`, potom Q3 a Q4 stejně. Rozhodnutí v §2 platí, neptej se na ně znovu. Hlas po každém PR.
