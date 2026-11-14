# Plán 34: dva prsty = druhá sada zbraní, oprava pohybu lodi (zadání pro Opus)

Stav 2026-11-14. Týká se větví `feat/touch-swap` (PR #70, do `main`) a `feat/touch-swap-2.10` (PR #71, do `release/2.9.x`). Obě jsou otevřené a obě jsou v testovacích buildech 3.9.4 (119) a 2.10.8 (118).

Cíl: loď se dá vždy řídit dotykem a sada zbraní se řídí počtem prstů na obrazovce. Jeden prst střílí první sadou, dva prsty druhou.

## 1. Co se stalo (ověřeno 2026-11-14)

Hlášení vlastníka z testovacího buildu: po dotyku druhým prstem přestal fungovat pohyb lodi. Přepínání zbraní fungovalo.

### Příčina

`TouchFingers` (`lib/input/touch_fingers.dart`) předpokládá, že tap a tažení téhož prstu hlásí stejné `pointerId`. Ve Flame 1.35.1 (obě linky) to neplatí. Jsou to dvě nezávislé číselné řady:

- **Tap** (`MultiTapDispatcher`): `pointerId` je číslo ukazatele z Flutteru. Roste o jedna s každým dotykem kdekoli v aplikaci, včetně menu.
- **Tažení** (`FlameDragAdapter` v balíčku flame, `lib/src/events/flame_drag_adapter.dart`): `pointerId` je vlastní statický čítač `_globalIdCounter`. Začíná nulou a roste o jedna s každým zahájeným tažením.

Pokus na skutečném `GameWidget` (tři klepnutí předem, pak jeden prst táhne):

```
tapDown 4
tapCancel 4
dragStart 0
```

Co s tím udělá dnešní kód:

1. `onTapDown(4)`: prst 4 je hlavní.
2. `onTapCancel(4)`: prst 4 se jen označí k uvolnění. Uvolní ho až `flush()` v příštím snímku.
3. `onDragStart(0)` přijde ve stejné události, tedy před `flush()`. Hlavní prst je pořád 4, takže 0 je „další prst“: zavolá se `_touchSwap()` a `_prevDragPos` se nenastaví.
4. `onDragUpdate(0)` končí na `_prevDragPos == null`. Loď se nehne.

Každé tažení se tedy bere jako druhý prst: přepne zbraně (má-li slot aspoň dvě) a lodí nehýbe.

### Co není jisté

Podle rozboru nejede loď ani jedním prstem, bez ohledu na druhý. Vlastník hlásí, že pohyb přestal až po druhém dotyku. První krok proto je reprodukce skutečnými gesty (§4, krok 0), ať je vidět, co build přesně dělá. Oprava na výsledku nezávisí: obě čtení mají stejnou příčinu.

### Proč to testy nechytily

`test/touch_fingers_test.dart` volá `down(1)`, `tapCancelled(1)`, `down(1)`: tap i tažení mají v testu stejné číslo. Žádný test nešel přes skutečná gesta.

## 2. Rozhodnutí vlastníka (ze zadání, neptat se znovu)

- Jezdím jedním prstem: první zbraň. Jezdím dvěma prsty: druhá zbraň.
- Platí pro obě linky.

Z plánu 32 zůstává: pravidlo výběru druhé sady (`Vessel.alternateFor`), jen sólo a hostitel, v duelu a u klienta co-opu se gesto nezavádí, nápověda je jen v ComCenteru, Y a R na 3.x se nemění.

Proti plánu 32 se mění dvě věci:

- Druhá sada je **stav po dobu držení**, ne přepínač při položení prstu.
- Věta „stav po přepnutí zůstává osazený i v ComCenteru a v uložení“ přestává platit. ComCenter i uložení vidí vždy první sadu.

**První sada** je to, co má hráč osazené z ComCenteru. **Druhá sada** je pro každý ze slotů přední, levý a pravý to, co vrátí `alternateFor` vůči první sadě.

## 3. Návrh

### 3.1 Sledování prstů

Přepsat `TouchFingers` na dvě množiny, které se **nikdy neporovnávají mezi sebou**:

- `taps`: čísla z tap událostí. `onTapDown` přidá, `onTapUp` a `onTapCancel` odeberou.
- `drags`: čísla z událostí tažení, v pořadí zahájení. `onDragStart` přidá, `onDragEnd` odebere. `onDragCancel` převádí Flame na `onDragEnd` sám.

Odvozené hodnoty:

- **Počet prstů** = `taps.length + drags.length`. Prst je buď ve fázi tapu (leží, nepřekročil práh), nebo ve fázi tažení.
- **Řídící prst** = nejstarší aktivní tažení (`drags.first`).

`flush()` a „čekající uvolnění“ zmizí. Přidat `clear()` a volat ho při startu sektoru jako pojistku proti prstu, jehož konec nikdy nepřišel.

Model je ověřený pokusem na skutečném `GameWidget`, počet čtený jednou za snímek:

| Situace | Počet prstů po snímcích |
|---|---|
| A položí a táhne | 1, bez propadu na 0 |
| B položí a 1,5 s leží, A táhne | 2 po celou dobu (`onLongTapDown` tap neruší) |
| B zvedne | 1 |
| C položí a táhne spolu s A | 2 |
| A zvedne, C táhne dál | 1, řídící je C |
| systém gesto zruší | 0 |
| tap zrušen bez tažení | 0 |

Počet se smí číst jen v `update()`. Uvnitř jedné události může na okamžik nesedět (tap už zrušen, tažení ještě nezačalo, nebo naopak).

### 3.2 Pohyb

- Lodí hýbe jen řídící prst. Dva prsty táhnoucí souběžně nesmí rychlost zdvojit.
- Když řídící prst zvedne a jiný táhne dál, řízení přebírá ten druhý, bez skoku. Poslední polohu proto držet pro každé tažení zvlášť (mapa podle čísla tažení) a aktualizovat ji u všech tažení, ne jen u řídícího.
- Výpočet posunu zůstává, jak je (`canvasEndPosition` minus poslední poloha, dělení zoomem kamery). Mění se jen to, že poslední poloha není jedna globální `_prevDragPos`.
- Ležící prst lodí nehýbe. Leží-li první prst a táhne druhý, řídí ten druhý.

### 3.3 Střelba

Pro jeden prst se nic nemění.

- `onTapDown`: `vessel.fire` přepne jen prst, který dopadl na prázdnou obrazovku (počet prstů před ním byl 0). Další prst střelbu nepřepíná.
- `onDragStart`: střelba se zapne.
- `onDragEnd`: střelba se vypne, až skončí poslední tažení.
- Klient co-opu: totéž s `_clientFire` a `sendInput`, jako dnes.

### 3.4 Sada zbraní

Vyhodnocuje se jednou za snímek v `update()`, jen při `GameState.playing`, jen sólo a hostitel, ne v duelu.

- Počet prstů ≥ 2 a běží první sada: hned přejít na druhou.
- Počet prstů je přesně 1 souvisle po dobu `touchAltRelease` a běží druhá sada: vrátit první. Nová konstanta `touchAltRelease = 0.15` v `game_config.dart` na obou linkách.
- Počet prstů 0: nic se nemění.
- Mimo `GameState.playing` se první sada vrací hned, bez prodlevy a bez zprávy.

Prodleva při návratu je nutná: dva prsty se nikdy nezvednou ve stejném snímku. Bez ní by každé zvednutí obou prstů na okamžik přepnulo sadu a stálo pauzu ve střelbě.

Zpráva (`showMessage`: název přední zbraně a DPS) se ukáže při přechodu oběma směry.

### 3.5 `Vessel`

Přepínač `swapToAlternate()` nahradit stavem:

- `bool get alternateActive`.
- `bool setAlternate(bool on)`, idempotentní, vrací, jestli se něco změnilo.
  - Zapnutí: pro každý ze tří slotů vzít `alternateFor(slot)`. Když něco vrátí, zapamatovat si typ dosud osazené zbraně a osadit druhou přes `swapIn`. Když se nezmění žádný slot, stav zůstane vypnutý.
  - Vypnutí: do každého zapamatovaného slotu vrátit přes `swapIn` zapamatovaný typ, pokud ho hráč stále vlastní. Jinak slot nechat být.
- `alternateFor` zůstává, používá ho nápověda v ComCenteru.
- 3.x: ruční přepnutí slotu (`SigilCaster._fit`, tedy Y a R) během druhé sady zapomene zapamatovaný typ toho slotu. Ruční volba platí a návrat ten slot nemění.
- Uložení a ComCenter: díky pravidlu „mimo `playing` se vrací první sada“ je v nich vždy první sada. Ověřit testem, ne spoléhat na pořadí volání.

Prodleva po přepnutí zůstává `cd = cooldown + swapDelay` (0,5 s) v obou směrech.

### 3.6 Nápověda

Text `swapHint` popisuje staré chování. Přepsat ve všech ARB dané linky (45 na `main`, 16 na 2.x):

- EN: „Hold two fingers to fire your second weapons“
- CS: „Dvěma prsty střílíš druhou sadou zbraní“

Podmínka zobrazení se nemění.

### 3.7 Zamítnutá varianta

Číst surové události ukazatele (vlastní rozpoznávač nebo `Listener`) místo tapů a tažení z Flame. Dalo by to jednu číselnou řadu, ale zmizel by práh tažení, takže by se muselo znovu psát rozlišení klepnutí od tažení, a `Listener` kolem `GameWidget` by počítal i dotyky tlačítek v překryvných vrstvách. Vrátit se k ní jen tehdy, když krok 0 ukáže, že tabulka z §3.1 na skutečné hře neplatí.

## 4. Testy

Krok 0, před jakoukoli opravou: test, který na dnešním kódu **selže**.

- Musí jít přes skutečný `GameWidget` a skutečná gesta (`tester.startGesture`, dvě souběžná). Nikdy nevolat `onTapDown` a `onDragStart` ručně s vymyšlenými čísly: přesně tak chyba prošla.
- Musí zkoušet kód, který běží ve hře. Když existující pomocníci umí `TyrianGame` v testu spustit (viz `test/telemetry_hooks_test.dart`, `test/death_effect_test.dart`), použít ji. Když ne, vytáhnout dotykové handlery do mixinu s malým rozhraním (posun lodi, střelba, sada zbraní), který použije `TyrianGame` i testovací hra.
- Před prvním gestem udělat pár klepnutí, ať se čísla tapů a tažení rozejdou.

Posloupnosti, každá ověřuje polohu lodi, `fire` a `alternateActive`:

1. Jeden prst položí a táhne: loď jede, střílí. Zvedne: střelba končí.
2. Klepnutí jedním prstem přepne střelbu. Klepnutí druhým prstem ji nepřepne.
3. A táhne, B položí a leží: do snímku druhá sada, loď dál jede za A, střelba nevypadne. B zvedne: po `touchAltRelease` první sada.
4. A i B táhnou: druhá sada, loď jede stejnou rychlostí jako řídící prst.
5. Řídící prst zvedne, druhý táhne dál: loď jede za ním bez skoku, po prodlevě první sada.
6. Oba zvednou do 50 ms: sada se mezitím nepřepne.
7. Systémové zrušení kteréhokoli prstu: počet se vrátí, nic nezůstane viset.
8. Hra opustí `playing` s druhou sadou: osazená je první, uložený stav drží první.
9. Klient co-opu a duel (3.x): druhý prst nic nemění.

Dále:

- Čistá třída: jednotkové testy s **různými** čísly pro tap a tažení, včetně případu, kdy se číslo tapu jednoho prstu rovná číslu aktivního tažení jiného.
- `loadout_inventory_test.dart`: testy `swapToAlternate` převést na `setAlternate`. Idempotence, návrat přesně na původní typy a levely, slot s jedinou zbraní se nemění, na 3.x ruční `_fit` během druhé sady.
- Staré testy v `touch_fingers_test.dart`, které stojí na shodných číslech, smazat a nahradit.
- Na 3.x musí dál projít `pad_scheme_test.dart` a `keyboard_sigils_test.dart`.

## 5. Větve a testovací build

- Oprava jde jako další commity do existujících větví `feat/touch-swap` (#70) a `feat/touch-swap-2.10` (#71). Žádné nové PR, žádný rebase, žádný force push. Názvy a popisy obou PR přepsat podle nového chování.
- Nejdřív `main`, pak 2.x. Přenést chování a testy, ne diff.
- Opravu potvrdí až telefon. Po zeleném CI proto obě větve sloučit (merge) do `test/3.9.4-testflight` a `test/2.10.7-testflight` a poslat testovací build: TestFlight obě linky, 3.x navíc na Steam do větve `beta`.
- Verze se nezvedá: 3.9.4 a 2.10.8, číslo buildu roste samo. `kTelemetryAppVersion` zůstává.
- Při slučování do `test/3.9.4-testflight` se čeká konflikt v `SigilCaster._fit` s větví telemetrie. Nechat obě změny: zapomenutí zapamatovaného typu i `noteWeaponSwitch()`.

## 6. Otázky na vlastníka

Žádná neblokuje. Dvě výchozí volby, které jde po zkoušce na telefonu změnit:

- Pauza 0,5 s ve střelbě platí při každém přechodu, tam i zpět. Při držení se přepíná častěji než dřív, takže může být cítit víc.
- Bez prstů na obrazovce zůstává sada, která běžela naposled.

## 7. Pravidla práce

Platí pravidla z plánu 31 §5 a §6 a z plánu 32 §6. Navíc:

- Staty z VB6 se nemění. `totalDps` a `lastMaxDps` se nedotýkat.
- `vessel.dart` má konce řádků CRLF. `saveVersion` se nezvedá.
- Gate před pushem v `tyrian_mobile/`: `flutter analyze --no-fatal-infos` a `flutter test`.
- Po odeslání buildu napsat vlastníkovi, co vyzkoušet na telefonu:
  1. Jeden prst: loď jede a střílí první sadou, zvednutí střelbu zastaví.
  2. Klepnutí jedním prstem přepne střelbu.
  3. Jedu jedním prstem, druhý položím a nechám ležet: druhá sada, loď jede dál.
  4. Jedu oběma prsty: druhá sada, loď jede stejně rychle jako prst.
  5. Zvednu druhý prst: po chvilce první sada.
  6. Zvednu první prst, druhý jede dál: loď jede za ním bez skoku.
  7. Zvednu oba naráz: nic neproblikne.
  8. Konec sektoru se dvěma prsty na obrazovce: v ComCenteru je osazená první sada.

## 8. Kdy stát a ptát se

- Merge PR, tag, zvednutí verze, vydání do obchodů a na Steam do `default`.
- Když krok 0 ukáže jiné pořadí událostí, než popisuje §1 a §3.1.
- Když test přes skutečnou hru nejde postavit ani přes mixin.
- Cokoli mimo dotykové ovládání a `setAlternate`.

## 9. Zadání do chatu

> Implementuj podle `tyrian_mobile/Prompts/34-PLAN-dva-prsty.md`. Začni krokem 0: test přes skutečná gesta, který na dnešním kódu selže, a napiš mi, co ukázal. Pak oprav `feat/touch-swap` a potom `feat/touch-swap-2.10`. Po zeleném CI slouč obě do testovacích větví a pošli testovací build na TestFlight, 3.x i na Steam beta. PR nemerguj.
