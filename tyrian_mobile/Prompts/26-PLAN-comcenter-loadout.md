# Plan: ComCenter → Loadout-first (bez sekce SHOP)

Přepis `lib/ui/com_center.dart` (dnes 2246 řádků na mainu, 1948 na 2.9.x).
Sekce OUTFITTING/SHOP s kartami zbraní a taby FRONT/SIDE/GEN mizí; nákup,
upgrade, prodej i přepínání zbraní se dělá přímo ve 4 řádcích LOADOUTu.
Zároveň se mění datový model: hráč může **vlastnit víc zbraní na slot** a
přepínat mezi nimi, aniž by o upgrady přišel.

Pořadí dodávky: **nejdřív linie 2.9.x** (větev `feat/l10n-2.9.x`, Android
`com.ab.kiran`, 15 jazyků), **pak upport na `main`** (3.x, Steam/iOS, bez l10n,
s kampaní, Challenge a pad API skinů). Stejný region model ovládání v obou
liniích, aby port byl diff, ne druhý přepis.

---

## 0. Co je v kódu dnes (fakta, na kterých plán stojí)

| Věc | Kde | Důsledek |
|---|---|---|
| Jeden `Device` na slot | `Vessel.devices` (List), `equipWeapon(type, slot)` nahrazuje, `removeWeapon(slot)` maže | Pro „víc koupených zbraní" je třeba nový stav — viz §2 |
| Tier odemykání | `Vessel.nextWeaponLevel` (0–3), `wepLevScores`, ComCenter ukazuje `frontWeapons.sublist(0, tier+1)` a totéž pro side | Zamčené elementy musí mít v řádku vlastní vizuální stav |
| Element = rodina zbraně | `WeaponFamily {bubble, vulcan, blaster, laser, starg}` z `DevType.imgName`; sprite každé rodiny je v atlasu každého skinu (`bubble.png`, `vulcan.png`, …) | Ikona elementu = sprite projektilu, **žádná nová grafika** |
| Front i side sdílí tier | front `[bubbleGun, vulcanCannon, blaster, laser]`, side `[smallBubble, smallVulcan, starGun, smallLaser]` | Řádek LEFT/RIGHT má čipy BUBBLE, VULCAN, STAR, LASER; FRONT: BUBBLE, VULCAN, BLASTER, LASER |
| Generátor | `DevType.generators = [generatorBasic]`, neprodejný, upgrade zvedá `genPower`+`genMax` | Řádek GEN = jen UPG |
| PWR | `Vessel.generatorLoad` (% zatížení), `genInfo` přidává `"<name> off"` když `d.pwrNeed > genMax` | Dva stavy: **>100 % = přetížení (červeně)**, **zbraň OFF = vůbec nestřílí** (to dnes UI neukazuje!) |
| Cena prodeje | `_sellSlot`: refund = `device.price` (aktuální, po upgradech plná) | Prodej je bezztrátový; s hangárem to platí i pro nevybavené zbraně — vědomé rozhodnutí |
| Max level | `Device.upgrade()` na maxu dává VB6 bonus (kredity+skóre), ale UI má `onTap: null` a píše `MAX` | Zachovat chování UI (MAX, neaktivní) |
| Save | `toSaveMap()['weapons']`, `SaveService.saveVersion = 2` | Hangár = nový klíč, verze 3, staré savy načtou prázdný hangár |
| Co-op | `encodeVesselState` posílá jen `weapons` (vybavené); `sendShopAction`/`onShopAction` v `lib/net` nemá volající mimo `lib/net` | Hangár se nesynchronizuje (host autoritativní). Ověřit, že shop-action je mrtvý kód, a pokud ano, smazat v obou liniích |
| Gamepad | polling 16 ms jen `platform.isDesktop`; `_PadRegion {loadout, outfitting, skins, bottomBar}`; B potvrdit, A L/R slot, X/Y prodat, LB/RB taby, START/BACK pokračovat; klávesnice zrcadlí (Tab = taby, Q = L/R) | Nový model v §5 |
| Skiny | main: `SkinShopSection` s pad API (`setPadFocus/movePadFocus/activatePadFocus` přes GlobalKey); 2.9.x: `SkinShopSection` bez pad API | Sekce SKINS zůstává beze změny; na 2.9.x bez pad focus (jako dnes) |
| Shop grafika | `ui_card_bg` (192², 24 skinů) — používá **jen** shop v `com_center.dart` (3 místa); `ui_tab_active` je mrtvý už dnes (prompty v pipeline, nikde nepoužit) | Obojí odstranit — §7. `ui_button` (START) a `comcenter_bg` zůstávají |
| Testy | `roguelike_progression_test` (tier gating), `sector_complete_guard_test` (devices), `skin_switch_test`, `bundle_contents_test` (soubory skinů) | Přidat `loadout_inventory_test`, upravit bundle test po smazání `ui_card_bg` |
| Rozdíl linií | 2.9.x: `_l.*` z 15 ARB, žádná kampaň/Challenge; main: `game.challenge.label` v hlavičce, `LAUNCH MISSION` v kampani, Lord unlock long-pressem na skinu | Port = §8 |

---

## 1. Layout

Mobil (portrait, jeden scroll). Desktop: dva sloupce jako dnes — vlevo
hlavička+STATS+LOADOUT, vpravo SKINS; spodní lišta přes celou šířku.

```
┌──────────────────────────────────────────────┐
│ COMMAND CENTER  [HARD]          Pilot: Ace_  │  ← řádek 1: nadpis (long-press = cheats),
│                                  P2: Bob     │     challenge label (jen main), jméno pilota vpravo
│ Credits: 12,500 (+800 cr)      Score: 98,400 │  ← řádek 2: Credits vlevo (CreditsWave + delta), Score vpravo
│ IP: 192.168.1.7                              │  ← jen host co-op, malé
├──────────────────────────────────────────────┤
│ ▌STATS                                       │
│  [ship]  HP   ████████░░  125/125            │
│          SH   ██████░░░░   60/100            │
│          GEN  ████████░░   80/100            │
│          PWR  ██████████▌ 112%  OVERLOAD     │  ← >100 % červeně + text; ≤70 zelená, 70–100 žlutá
│          DPS  14.2                           │
│          NEXT WEAPON  VULCAN  in 12,340 pts  │  ← ikona+název rodiny dalšího tieru, progress bar
│                       ▂▂▂▂▂▂▂▂░░░░            │     od předchozího prahu; skryto po posledním tieru
├──────────────────────────────────────────────┤
│ ▌LOADOUT                                     │
│  FRONT  [BUBBLE][VULCAN][BLASTER][🔒LASER]  [UPG 2,200][SELL]        │
│          Lv.II   Lv.I     16,000   120k pts                              │
│          ═══════(vybavená)                                               │
│  LEFT   [BUBBLE][VULCAN][STAR   ][🔒LASER]  [BUY 8,000]                │
│  RIGHT  [BUBBLE][VULCAN][STAR   ][🔒LASER]  [UPG 900][SELL]             │
│  GEN    [FALCON Lv.III  cap 180]              [UPG 2,600]              │
├──────────────────────────────────────────────┤
│ ▌SKINS   (SkinShopSection beze změny)        │
├──────────────────────────────────────────────┤
│ [B] Action  [X/Y] Sell  [OPTIONS] Continue   │  ← jen desktop
│ [HOST] [JOIN]              [START MISSION]   │
└──────────────────────────────────────────────┘
```

Čip elementu (jedna buňka řádku):
- ikona = sprite projektilu rodiny z atlasu aktuálního skinu (`AssetLibrary.getSprite(imgName)`), 24 px;
- popisek = **název rodiny** (ne název zbraně — „Small Bubble" se do 80 px nevejde, „BUBBLE" ano);
- druhý řádek: `Lv.II` (vlastněná) / cena (odemčená nevlastněná) / `NNN pts` (zamčená);
- stavy: **vybavená** (plný akcent + spodní linka), **vlastněná nevybavená** (obrys akcentu, Lv.), **k zakoupení** (šedý obrys, cena; červená cena když nejsou kredity), **zamčená** (35 % opacity, zámek, netapovatelná);
- 4 čipy + tlačítka se musí vejít na 375 px (iPhone mini): čipy `Expanded`, tlačítka pevné 44pt výšky; na desktopu `_fs()` jako dnes.

Popisek čipu = **název rodiny** (rozhodnuto 2026-10-27: žádné „voda/oheň",
nechat bubble/vulcan/…). Stejný popisek pro velkou i malou variantu, takže
FRONT i LEFT/RIGHT čtou stejně:

| Rodina (`imgName`) | Popisek čipu | Barva čipu |
|---|---|---|
| bubble | BUBBLE | modrá |
| vulcan | VULCAN | oranžová |
| blaster | BLASTER | fialová |
| starg | STAR | žlutá |
| laser | LASER | cyan |

Popisky jsou vlastní jména zbraní, **nepřekládají se** (jeden ARB klíč na
rodinu kvůli konzistenci, ale hodnota ve všech jazycích stejná).

Co se v hlavičce zachová: long-press nadpisu = cheat bar, animace `+/− cr`
u kreditů, `P2:` v co-opu, `IP:` u hosta, `game.challenge.label` (main).

---

## 2. Datový model: hangár

Cíl: vybavené zbraně se chovají jako dnes (`Vessel.devices` beze změny pro
gameplay, síť, DPS, PWR). Nový seznam drží **koupené, ale nevybavené** kusy
včetně jejich levelu.

`lib/entities/vessel.dart`:
```dart
/// Owned but not fitted. Each keeps its slot and level. Never fires, never
/// counts toward generatorLoad/totalDps, never serialized to co-op peers.
final List<Device> hangar = [];

/// Fit [type] into [slot]. Whatever is fitted there now goes to the hangar
/// (level preserved). If the hangar already holds [type] for [slot], that
/// instance comes back instead of a fresh level-0 one.
void fitWeapon(DevType type, WeaponSlot slot);

/// Sell the device fitted in [slot] (refund = device.price, as today).
int sellFitted(WeaponSlot slot);

/// Sell a hangar entry (same refund rule).
int sellFromHangar(Device d);

Device? hangarEntry(String name, WeaponSlot slot);
```
- `equipWeapon` zůstává pro `resetVessel()` (start hry); `fitWeapon` je
  nákup/přepnutí z ComCenter. Při přepnutí NEplatí se znovu nic.
- `generatorLoad` se po přepnutí přirozeně změní → PWR v STATS hned reaguje
  (to je důvod, proč je PWR hned nad loadoutem).
- `resetVessel()` (smrt v endless, nová kampaň) hangár vyprázdní — stejně
  jako dnes zahazuje `devices`. Ověřit, co dělá `gameOverEndless`
  („loadout and credits retained") — pokud drží `devices`, drží i hangár.
- Save: `toSaveMap()['hangar'] = hangar.map(toJson)`, `loadFromSave` načte
  nebo prázdný; `SaveService.saveVersion = 3` (jen marker, migrace není třeba).
  Kampaňový save má vlastní klíč/verzi (`save_service.dart:70`) — zkontrolovat,
  zda ukládá vessel stejnou mapou; pokud ano, hangár jde s ní.
- Co-op: `encodeVesselState` beze změny (jen vybavené). Pokud se potvrdí, že
  `sendShopAction/onShopAction/encodeShopAction/decodeShopAction` nemají
  volající, smazat (protocol.dart, coop_client.dart, coop_host.dart) — ale
  **bez změny `protocolVersion`**, pokud se tím nemění žádný živý paket.
- Achievementy: jediné zbraňové jsou „max level XXV" per zbraň, hlášené z
  `upgrade()` přes `onWeaponLevel` — hangár je neovlivní.
- `tyrian_game.dart:1371` kopíruje vessel (`dst.devices.clear()` + přepis) —
  doplnit o `hangar`, ať se při té kopii neztratí.

Pravidla akcí na řádku (slot S, čip C, vybavený `fitted`, kurzor `sel`):

| Stav C | Tap na čip | Tlačítka vpravo |
|---|---|---|
| vybavená | nic (už je) | `UPG <cena>` / `MAX` + `SELL` |
| vlastněná v hangáru | `fitWeapon` → okamžitě vybaví, předchozí jde do hangáru | (po přepnutí jako „vybavená") |
| nevlastněná, odemčená | `sel = C` (jen výběr, nic se neplatí) | `BUY <cena>` (červená + neaktivní bez kreditů); SELL skrytý |
| zamčená | nic (toast `Unlocks at N pts` max 1× za 2 s) | — |

`sel` je per řádek, default = vybavená; po BUY se koupená zbraň rovnou vybaví
(`fitWeapon`) a `sel` se na ni přesune. Když hráč prodá vybavenou a v hangáru
něco pro ten slot je, **slot zůstane prázdný** (rozhodnuto: „tvoje chyba, když
si nepřepneš/nekoupíš"), hangár zůstane, hráč si vybere. Prázdný slot: žádný
čip není vybavený, tlačítka podle `sel`. Refund z hangáru i z vybavené =
`device.price` (rozhodnuto).

GEN řádek: jeden čip `FALCON Lv.N  cap <genMax>` + `UPG <cena>`/`MAX`.

---

## 3. STATS

`_buildStatValues()` přepsat na sloupec 6 položek, všechny stejnou šířkou
popisku (HP/SH/GEN/PWR/DPS/NEXT), bary `HealthBar` pro první čtyři:

- **PWR** bar: hodnota `generatorLoad` na škále 0–100, nad 100 bar plný +
  červený, číslo červené, přípona `OVERLOAD`. Barvy jako dnes v `_buildGenInfo`
  (≤70 success, ≤100 upgrade, >100 danger). `_buildGenInfo` zaniká.
- Pokud `vessel.devices.any((d) => d.pwrNeed > genMax)`: pod PWR řádek
  `<FAMILY> OFF — generator too weak` červeně a odpovídající čip v LOADOUTu
  dostane červený rámeček. To je stav, který dnes hráč nevidí a zbraň přitom
  vůbec nestřílí.
- **NEXT WEAPON**: `tier = vessel.nextWeaponLevel`; pokud `< frontWeapons.length`
  a `< wepLevScores.length`: ikona + název rodiny `frontWeapons[tier]` (stejná
  rodina jako side téhož tieru až na STAR/PLASMA — ukázat obě ikony, když se
  liší), text `in <wepLevScores[tier] − score> pts`, tenký progress bar
  `(score − prev) / (threshold − prev)`. Jinak řádek skrýt.
- SCORE z STATS mizí (je v hlavičce).

---

## 4. Co z `com_center.dart` zmizí

Stav: `_sectionIndex`, `_targetSideSlot`, `_selectedWeaponIndex`,
`_lastColumnRegion` (pokud už nebude potřeba), `_PadRegion.outfitting`.

Metody: `_buildSectionTabs`, `_buildTab`, `_buildActiveSection`,
`_buildWeaponGrid`, `_buildSideSection`, `_buildSideSubTab`,
`_buildSlotWeaponCard`, `_buildSlotCardAction`, `_buildWeaponCard`,
`_buildCardAction`, `_buildGeneratorSection`, `_buildGenInfo`,
`_switchSection`, `_toggleSideSlot`, `_scrollWeaponIntoView`, `_buyWeapon`,
`_buyWeaponToSlot`, `_upgradeWeapon`, `_sellWeapon` (jmenné varianty;
zůstávají jen slotové `_upgradeSlot`/`_sellSlot` + nové `_buyToSlot`,
`_fitFromHangar`).

Pomocník `spriteCardBox` v `skin_painter.dart:142` volá jen shop (3 místa
v `com_center.dart`) → smazat i jeho.

Cílová velikost souboru: pod ~1300 řádků. Zvážit vytažení řádku do
`lib/ui/loadout_row.dart` (StatelessWidget s callbacky) a kurzoru do
`lib/ui/loadout_cursor.dart` (čistá třída, testovatelná bez widgetů — §6).

---

## 5. Ovládání: gamepad + klávesnice (desktop / Steam Deck)

Jeden region model pro pad i klávesnici (dnes to tak je, nesmí se rozejít):

```
enum _PadRegion { loadout, skins, bottomBar }
```

Kurzor v LOADOUTu je **2D**: `row ∈ {FRONT, LEFT, RIGHT, GEN}`,
`cell ∈ [čip0..čipN, UPG/BUY, SELL]` — jen buňky, které v daném stavu
existují (zamčené čipy se přeskakují, SELL jen když je co prodat, GEN má
`[čip, UPG]`).

| Vstup | Akce |
|---|---|
| ↑ / ↓ (d-pad, levá páčka, W/S) | řádek −/+; nad FRONT nic; pod GEN → `skins` (desktop, `_hasSkinsRegion`) jinak `bottomBar`; `cell` se při změně řádku zachová, oříznutý na počet buněk |
| ← / → (A/D) | buňka −/+; **za poslední buňkou vpravo → `skins`** (vstup na první kartu řádku, kde kurzor byl); ze `skins` ← na levém okraji mřížky → zpět do `loadout` (poslední buňka aktuálního řádku) |
| B / Enter / Space | aktivuj buňku: čip → stejná pravidla jako tap (§2); UPG/BUY/SELL → akce |
| X / Y / Delete / Backspace | prodej vybavenou zbraň aktuálního řádku (zkratka, nezávisle na buňce); na GEN nic |
| A | volné (dřív L/R toggle). Nechat **nevyužité** — dokumentovat, ať se do nápovědy nepíše |
| LB / RB / Tab / Shift+Tab | řádek −/+ (nahrazuje přepínání tabů; Tab z GEN jde na SKINS, pak bottom, pak zpět na FRONT) |
| START / BACK / Esc | `widget.onStart()` (pokračovat) jako dnes |
| Q | smazat (byl L/R toggle) |

Pravidla, která dnes existují a zůstávají: `_enterRegion(skins)` předává
focus do `SkinShopSectionState` přes GlobalKey (main) — na 2.9.x `skins`
region neexistuje, ↓ z GEN jde rovnou do `bottomBar`; `_bottomActions`
(host/join/start) a `_bottomFocused` beze změny; pad kurzor se kreslí jen na
desktopu (`platform.isDesktop`), tap na mobilu kurzor nemění.

Vizuál kurzoru: 2px akcentový rámeček kolem **buňky** (ne celého řádku);
`_padHint('B')` sufixy na UPG/BUY, `_padHint('X')` na SELL jako dnes.
Spodní nápověda (desktop):
`[↑↓] Row   [←→] Select   [B] Buy/Upgrade/Switch   [X/Y] Sell   [OPTIONS] Continue`.

Při změně skinu (`_onSkinChanged`) se ikony čipů přenačtou (atlas se mění).

Pilotovo jméno je `TextField`; s padem není dosažitelné (ani dnes). Na
desktopu při focusu TextFieldu šipky píšou do pole — chování jako dnes,
Esc z pole vrací focus na `_focusNode`.

---

## 6. Testy

Nový `test/loadout_inventory_test.dart` (headless `Vessel`, jako
`sector_complete_guard_test`):
1. `fitWeapon` do prázdného slotu → `devices` má 1, hangár 0.
2. Upgrade na Lv.II, `fitWeapon` jiné rodiny → původní v hangáru s Lv.II;
   `fitWeapon` zpět → vrátí tu samou instanci (level drží), hangár prázdný.
3. `sellFitted` vrací `device.price` a hangár nechává.
4. Save roundtrip s hangárem; load mapy **bez** klíče `hangar` → prázdný.
5. `generatorLoad` po přepnutí odpovídá jen vybaveným.
6. Stejná rodina v LEFT i RIGHT (dva `Small Bubble`) se nemíchá — hangár
   indexuje `(name, slot)`.

Nový `test/loadout_cursor_test.dart`, pokud se kurzor vytáhne do čisté třídy:
přechody z tabulky v §5 (okraje řádků, přeskok zamčených, GEN bez SELL,
hand-off do skins/bottom).

Upravit: `bundle_contents_test.dart` (už nečekat `ui_card_bg`),
`roguelike_progression_test.dart` (komentář k sublist zůstává pravdivý).
Spustit `flutter analyze` + `flutter test`; běh na zařízení dělá uživatel
(IPA/AAB-first).

---

## 7. Odstranění shop artefaktů (grafika + pipeline)

Flutter:
- `lib/services/asset_library.dart:251-252` — vyřadit `ui_card_bg` z preloadu.
- `rm assets/skins/*/ui/ui_card_bg.png` (24 souborů). `pubspec.yaml` deklaruje
  složky, ne soubory — ověřit a nic neměnit.
- `ui_tab_active` ve Flutteru není; jen komentář v `com_center.dart:798`, který
  zmizí s taby.

Pipeline (`pipeline/`):
- `internal/generator/assets.go`: odebrat řádek `{"ui_card_bg", "ui_card_bg", "1:1"}`.
- `internal/generator/prompts.go`: odebrat šablony `ui_card_bg` a `ui_tab_active`
  (flux i pony varianty).
- `internal/postprocess/reference_sizes.go`: odebrat `ui_card_bg`.
- `internal/postprocess/processor.go:168`: case `ui_card_bg || ui_button` → jen `ui_button`.
- `internal/postprocess/processor_test.go`: pokud testuje `ui_card_bg`, upravit.
- `SKILL.md` řádky 38, 167, 269–272: vyřadit `ui_card_bg`, `ui_tab_active`.
- `selections/*`, `tuned/*/flux/ui_card_bg.yaml`, `tuned/*/flux/ui_tab_active.yaml`,
  `output*/<skin>/ui/ui_card_bg*`: smazat (git i na disku; `output*` je
  pravděpodobně mimo git — zkontrolovat `.gitignore`).
- `go test ./...` v `pipeline/` musí projít.
- `Prompts/23-PLAN-v3-ten-skins.md` tabulka UI: ponechat, je to historický plán;
  jen poznámka, že `ui_card_bg` od v2.9.4/v3.8 neexistuje.

Zůstává: `comcenter_bg` (pozadí), `ui_button` (START/HOST/JOIN),
`icon_*` (HUD + collectables), `preview`.

---

## 8. Dvě linie a verze

**Krok A — 2.9.x** (větev `feat/comcenter-loadout-2.9` z `feat/l10n-2.9.x`):
1. §2 model + testy §6.
2. §1/§3/§4 UI; všechny texty přes `_l.*`. Nové ARB klíče (do všech 15
   `lib/l10n/app_*.arb`, krátké labely přeložit stejně, jako to dělal
   l10n commit `2a2b3ca`): `familyBubble/Vulcan/Blaster/Star/Laser` (hodnota
   všude stejná), `overload`, `weaponOff(family)`, `nextWeaponIn(points)`,
   `unlocksAt(points)`, `padHintLoadout`. Smazat mrtvé:
   `sectionOutfitting`, `sectionShop`, `tabFront/tabSide/tabGen`, `sideLeft/sideRight`,
   `owned`, `padControlsHint` (nahradit), případně `statPower`.
3. §5 ovládání — na 2.9.x je pad kód přítomný (stejný `platform.isDesktop`
   gate), ale linie je Android-only; implementovat celý model, ručně
   neověřovat.
4. §7 artefakty (pipeline je společná — udělat **jen jednou**, v tomto kroku,
   commit zvlášť, aby se dal cherry-picknout na main).
5. `pubspec.yaml` → `2.9.4` — **2.9.3 se samostatně nevydává**, l10n i loadout
   jdou ven spolu jako 2.9.4 (rozhodnuto). Release podle běžného toku: merge do
   větve linie → tag `v2.9.4` → CI AAB.

**Krok B — main** (větev `feat/comcenter-loadout` z `main`), v tomto pořadí:
1. **Port l10n vrstvy na main** (rozhodnuto: lokalizace do všech jazyků).
   Main dnes nemá `flutter_localizations` ani `lib/l10n/`. Základ =
   cherry-pick `2a2b3ca` (15 ARB + `l10n.dart` + `l10n.yaml` + zapojení v
   `main.dart` + `test/l10n_test.dart` + generované `app_localizations_*.dart`,
   pokud jsou commitnuté). Pak doplnit klíče pro obrazovky, které má jen main:
   `campaign_map.dart`, `campaign_result.dart`, `join_dialog.dart`,
   `challenge.dart` (labely Easy/Normal/Hard/Lord), `credits_wave.dart`,
   `enemy_counter.dart`, a stringy v `osd_panel`/`skin_selector`/`main.dart`,
   které přibyly po `dcf683f`. Jediné zdroje pravdy pro „co ještě není
   přeložené": `grep -n "Text('" lib/ui lib/game` + `l10n_test`. Toto je
   největší kus portu, dělat jako **samostatný PR před loadoutem**, aby se
   loadout na main cherry-pickoval už do lokalizovaného kódu.
2. Cherry-pick model + testy (`vessel.dart`, `device.dart`, `save_service.dart`,
   testy) — konflikty budou malé (diff linií v těchto souborech je 7 řádků).
3. Cherry-pick pipeline/asset commit beze změny.
4. `com_center.dart` **neportovat cherry-pickem** (soubory se liší o 522
   řádků); vzít novou verzi z 2.9.x (už s `_l.*`) a ručně vrátit, co má jen
   main:
   - `game.challenge.label` v hlavičce, `LAUNCH MISSION` v kampani
     (`game.mode == GameMode.campaign`) — oboje přes nové ARB klíče;
   - `_PadRegion.skins` + GlobalKey na `SkinShopSectionState` (pad API je jen
     na mainu);
   - 4 commity, které v com_center přibyly mezi `dcf683f` a `main`
     (`git log dcf683f..main -- tyrian_mobile/lib/ui/com_center.dart`).
5. `pubspec.yaml` → `3.8.0`; PR do main, tag `v3.8.0`.
6. Steam Deck / pad: po vydání projít §5 na reálném padu — to je linie, kde
   na tom záleží.

---

## 9. Rozhodnuto (uživatel, 2026-10-27) — žádné otevřené otázky

1. **Hangár** (víc vlastněných zbraní na slot, level se drží) — ano, §2.
2. **Refund z hangáru** = plná aktuální cena `device.price`, stejně jako u vybavené.
3. **Popisky čipů** = názvy rodin BUBBLE / VULCAN / BLASTER / STAR / LASER,
   žádné živly.
4. **Po prodeji vybavené zbraně slot zůstane prázdný**, i když je něco v hangáru.
5. **2.9.3 se nevydává zvlášť** — 2.9.4 = l10n + loadout.
6. **Main dostane l10n do všech 15 jazyků** jako první krok portu (§8 B.1).

---

## 10. Přegenerování pozadí ComCenter (`comcenter_bg`) pro všech 24 skinů

Nový layout má jiné těžiště (hlavička + STATS nahoře, 4 řádky LOADOUTu
uprostřed, SKINS dole) a pozadí je dnes generované pro starou obrazovku.
Přegenerovat **všech 24 skinů**, **víc variant na skin, uživatel vybírá**,
generovat přes **flux-schnell** (rychlé, ne flux-dev).

### Stav pipeline (fakta)
- Spec: `internal/generator/assets.go` → `comcenter_bg`, `ui/`, aspekt 1:2,
  rozlišení 2k (latent 1024×2048 podle `client.go:586`); postprocess exact
  resize na 512×1024 (`reference_sizes.go:83`), opaque, bez odstranění pozadí.
- Prompt: šablona `comcenter_bg` v `prompts.go:93` (flux) — už obsahuje
  „central area naturally dark … no text, no HUD, no ship, no people".
  `tuned/<skin>/flux/comcenter_bg.yaml` existuje jen pro 2 skiny.
- Workflow `flux_sprite.json`: UNETLoader `flux1-dev-kontext_fp8_scaled`,
  KSampler **20 kroků**, FluxGuidance 3.5. `-comfyui-checkpoint` umí přepsat
  `unet_name`, ale **počet kroků a guidance přepsat neumí** — schnell chce
  4 kroky a guidance se ignoruje.
- Varianty: `-n <N>`, výstup `output/assets/skins/<skin>/ui/comcenter_bg_v<i>.jpg`;
  výběr se zapisuje do `selections/<skin>.json` (`"comcenter_bg": <i>`) a
  `cmd/postprocess` bere vybranou variantu.
- SPARK broker: od 2026-10-27 07:25 je profil `comfy` jen comfyui + tts
  (NIM `flux-schnell` bral ComfyUI 17 GiB, render jel z části na CPU,
  ~97 s/obrázek). Preset `schnell` načítá `flux1-schnell.safetensors`
  přímo v ComfyUI, takže stage potřebuje jen `comfyui`; kombinaci
  `comfyui,flux-schnell` dnes žádný profil nesplní a úloha by visela. Strop priority projektu `kirian` je 30; výš jen okno
  uživatele (priorita 100, doslovná slova) nebo `sparkctl approve` na jeho pokyn.

### Kroky
1. **Pipeline: schnell režim** (`pipeline/`, ~30 řádků):
   - `cmd/generate`: nové flagy `-comfyui-steps <n>` (KSampler node 8 `steps`)
     a `-comfyui-guidance <f>` (node 7), nebo jeden `-comfyui-preset schnell`
     = checkpoint schnell + steps 4 + guidance 1.0. Přesný název souboru
     schnell UNETu zjistit z ComfyUI `GET /object_info/UNETLoader`, až profil
     poběží (nehádat).
   - `client.go`: `WithSteps`, `WithGuidance` vedle `WithCheckpoint`
     (stejný `setNodeInput` vzor, `client.go:283`).
   - Test v `comfyuiimage` na přepsání node 8/7.
2. **Prompt dolaďit pro nový layout** (`prompts.go` šablona `comcenter_bg`,
   jedna změna pro všechny skiny): tmavý pás v **horní třetině** (hlavička +
   STATS) a **středu** (LOADOUT), světlejší/detailnější okraje a spodek;
   bez horizontu uprostřed, který by procházel za řádky loadoutu. Pilot
   nejdřív: 1 skin (`default`), 8 variant, poslat uživateli, teprve pak všech 24
   (viz [[kiran-iteration-style]]: pilot-first, re-roll outliers).
3. **Generování** (dávka na tomhle stroji přes broker, ne ručně):
   ```
   id=$(sparkctl exec kirian comfyui 90 30 "Kirian: comcenter_bg ×24 skinů, 8 variant, schnell" -- \
     go run ./cmd/generate -asset-type comcenter_bg -n 8 -force -comfyui-preset schnell -tuned-dir tuned)
   ```
   `exec` obstará heartbeat i done/fail. Odhad: 24 × 8 = 192 obrázků
   1024×2048 @ 4 kroky ≈ 10–15 s/ks na GB10 → 35–50 min + přepnutí profilu.
   Nikdy nestartovat ve posledních ~40 min okna.
4. **Výběr uživatelem**: kontaktní list per skin (8 variant vedle sebe
   s číslem, náhled s překrytým drátěným modelem nového layoutu, aby šlo
   posoudit čitelnost textu) → uživatel vrátí čísla → zapsat do
   `selections/<skin>.json` → `go run ./cmd/postprocess -skin <id>` pro každý
   skin → `dart run tool/pack_atlas.dart` není potřeba (`ui/` není v atlasu,
   `asset_library.dart:254` načítá PNG přímo). Outliery přegenerovat
   (`-force` jen na dotyčný skin).
5. Commit: 24× `assets/skins/<skin>/ui/comcenter_bg.png` + `selections/` +
   pipeline změny. Jde do **obou linií** (2.9.4 i 3.8.0) — grafika je sdílená,
   cherry-pick beze změny.

### Okno na SPARKu — domluveno a zařazeno (2026-10-27)
Director session navrhl start **06:35** (StoryTeller korektura 1026-48 si
lease prodlužuje do 06:30, uživatel jí dává přednost; knihovnu 1025-24
úloha jen přeruší, ta sama naváže; přepnutí profilu gptoss → comfy dělá broker).
Zařazeno z tohoto Macu (nohup + `caffeinate -i`, log
`pipeline/output/comcenter_v2/exec.log`, id v `pipeline/output/comcenter_v2/job.id`):
```
sparkctl exec kirian comfyui 90 30 "Kirian: ComCenter pozadí 24×8 (schnell)" --at 06:35 \
  --dir pipeline -- go run ./cmd/generate -asset-type comcenter_bg -n 8 -comfyui-preset schnell \
  -out output/comcenter_v2/skins
```
→ úloha **1027-49**, priorita 30 (strop kirian; výš jen `sparkctl window`
uživatelovými slovy). Výstup jde do **čistého** `output/comcenter_v2/skins/`,
aby se nemíchal se starými 4 variantami v `output/assets/skins/`; bez `-force`,
takže po odsunutí exec navazuje a hotové skiny přeskočí. Postprocess pak
volat s `-input output/comcenter_v2/skins`. Mac musí v 06:35 být vzhůru a na LAN
(ComfyUI API jen přes `spark-99bb:8188`).

Krok 1 (schnell preset) je **hotový, necommitnutý**: `-comfyui-preset schnell`
= UNET `flux1-schnell.safetensors` (potvrdil Director, leží v
`models/diffusion_models/`), 4 kroky, guidance 1.0; dual CLIP a VAE zůstávají
z workflow (sdílené s dev). Nové flagy `-comfyui-steps`, `-comfyui-guidance`,
`WithSteps`/`WithGuidance` v `client.go`, `NodeRoles.Guidance`, testy v
`sampler_override_test.go`. Krok 2 (prompt pro nový layout) je taky v
`prompts.go`. Pozn.: `TestGenerateInjectsWorkflow` v `client_test.go` padá už na
HEAD (kontroluje pony node ID proti flux workflow) — nesouvisí, opravit zvlášť.

---

## 11. Stav implementace (2026-10-27, noc)

| Linie | Větev | Stav |
|---|---|---|
| 2.9.x | `feat/comcenter-loadout-2.9` (z `feat/l10n-2.9.x`) | hangár, nový ComCenter, l10n klíče, smazaný `ui_card_bg`, verze **2.9.4**; 119 testů zelených |
| 3.x | `feat/comcenter-loadout-3x` (z `feat/l10n-main`) | totéž + skiny jako pad region, obtížnost v hlavičce, LAUNCH MISSION; pipeline bez `ui_card_bg`/`ui_tab_active`; verze **3.8.0**; 214 testů zelených |
| main l10n | `feat/l10n-main` | cherry-pick původní main lokalizace `57a2ccb` (ne ořezané `2a2b3ca`), všech 15 jazyků |

Odchylky od plánu výše:
- **`saveVersion` zůstává 2.** Loader porovnává uloženou verzi s konstantou a starší savy posílá přes migraci starých indexů sektorů; zvýšení na 3 by savy z verze 2 rozbilo. Hangár je volitelný klíč `hangar`.
- **GEN řádek má jen buňku UPG** (čip generátoru nic nedělá, kurzor ho přeskakuje).
- **SELL prodává jen vybavenou zbraň.** Zbraň z hangáru se prodá tak, že se na ni nejdřív přepne. `Vessel.sellFromHangar` existuje, UI ho nevolá.
- **Dvousloupcový desktop až od šířky 900 px**, užší okno dostane mobilní layout.
- **Pipeline na 2.9.x se nemění** (generuje se z main), smazání `ui_card_bg` z pipeline je jen na 3.x.
- Widget testy (`test/com_center_layout_test.dart`) hlídají přetečení na 375 pt v en/cs/de/ru/ja a tok přepnutí/nákupu; testovací font má znaky široké 1 em, zhruba jako Press Start 2P.

Zbývá: nová pozadí `comcenter_bg` (úloha 1027-49 v 06:35, pak výběr uživatelem) do obou linií, push větví, PR, tagy `v2.9.4` a `v3.8.0`.
