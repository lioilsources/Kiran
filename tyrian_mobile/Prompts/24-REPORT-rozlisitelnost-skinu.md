# Kiran v3 — rozlišitelnost skinů podle barvy

**Pro:** Fable · **Od:** Claude (Claude Code) · **Datum:** 2026-09-02
**Stav větve:** `main`, verze v přípravě 3.0.0, generování batche 1 běží

---

## 1. Otázka, na kterou se ptáme

Kiran má dnes 14 skinů. Verze 3.0 přidává dalších 10, celkem 24. Skin je placený obsah
(11 ze 14 dnešních má `productId`), takže musí platit jednoduchá věc: **hráč musí na první
pohled poznat, že přepnul skin.** Když si koupí „Chrome Fleet" a vypadá to jako „Retro PC
Pixel", který už má, je to vrácení peněz a jednohvězdička.

Změřil jsem, jak na tom skiny barevně jsou. Vyšlo, že problém existuje, ale je jinde a jiného
druhu, než jsme čekali. Otázka pro tebe zní **kterou pákou ho řešit**, protože každá má jinou
cenu a jiný dopad na uměleckou věrnost předlohám.

Zadavatel formuloval dvě možnosti:

- **(A)** přepsat definice skinů tak, aby palety byly rozházené po barevném kruhu, a přegenerovat
- **(B)** nechat generaci být a barvy rozhodit až v postprocesu záměnou barev

Měření ukázalo **třetí páku, která v repu už existuje a nikdo ji nevyužil naplno.** Viz §6.

---

## 2. Co přesně se měřilo

Nezajímalo mě, co tvrdí definice skinu, ale co je opravdu v assetech.

**Sprity.** Rozbalený `atlas.webp` každého skinu, pouze pixely s alfou nad 200 (průhledná
výplň atlasu nese libovolné RGB a stáhla by paletu k tomu, co po sobě nechal packer).
K-means na 6 shluků, každý vzorek vážený svým podílem plochy. Vzorky jsou tedy plošně
poctivé: barva, která zabírá 30 % atlasu, má v paletě váhu 30 %.

**Pozadí.** `backgrounds/layer_0_z0.webp`, tedy základní deska nulté zóny. 4 shluky.
Layer 0 je jediná neprůhledná vrstva, ostatní tři se přes ni skládají alfou.

**Vzdálenost.** CIELAB. Vzdálenost dvou palet je oboustranný vážený průměr toho, jak daleko
musí každý vzorek jedné palety doputovat k nejbližšímu protějšku v druhé. Symetrická, takže
pořadí argumentů nehraje roli. Pro orientaci: **ΔE 2,3 je práh, pod kterým rozdíl nikdo
nevidí**; nad 25 jsou barvy zjevně jiné.

**Celkové skóre** = 0,45 × sprity + 0,55 × pozadí. Pozadí má vyšší váhu, protože zabírá
většinu svítící plochy; sprity nižší, protože po nich jde oko.

### 2.1 Co v tom čísle není — a je to důležité

Tohle **není** měřítko toho, jestli hráč skiny rozezná. Je to měřítko jedné složky, barvy.
Nezahrnuje:

- **siluetu a strukturu spritů** — `ikaruga` má hladké bílé lodě, `gradius_v` členité kovové;
  barevně blízko, tvarově daleko
- **bloom, scanlines, CRT zakřivení a vinětaci** — modeloval jsem jen tint a saturaci,
  protože jsou to prosté per-pixel operace; bloom a scanlines mění vjem výrazně a nejdou
  spočítat bez skutečného renderu
- **UI téma, font a hudbu** — každý skin má vlastní `UiTheme` a `GoogleFont`
- **strukturu pozadí** — dvě pozadí můžou mít stejnou paletu a přitom jedno být hvězdné pole
  a druhé kaňon

Číslo tedy **vytipovává podezřelé dvojice, nedokazuje záměnu.** Ke každé vytipované dvojici
patří pohled na obrazovku. Beru to jako síto, ne jako verdikt.

---

## 3. Co data ukazují

### 3.1 Odstín je obsazený, ne rozprostřený

Ze 17 změřených skinů jich **osm sedí v pásmu 185–240°**, tedy azur až modrá:
`asteroids` 190°, `default` 194°, `blazing_lazers` 197°, `geometry_wars` 201°,
`star_fox` 206°, `tyrian_dos` 210°, `nex_machina` 224°, `gradius_v` 232°.

Zbytek kruhu je řídký: teplé pásmo drží `galaga` 1°, `rtype` 7°, `river_raid` 27°,
`nuclear_throne` 29°, `luftrausers` 32°, `tempest` 48°. Zelená má dva obyvatele,
`space_invaders` 124° a `solar_striker` 126°. **Mezi 50° a 120° a mezi 240° a 360°
není nikdo.** Purpurová, fialová, tyrkysová do zelena — prázdno.

### 3.2 Druhá tlačenice je ve středu kruhu, ne na obvodu

Šest skinů má průměrnou sytost pod 0,26: `ikaruga` 0,07, `tyrian_dos` 0,18,
`star_fox` 0,20, `gradius_v` 0,20, `asteroids` 0,23, `river_raid` 0,25.
Ty padají do středu barevného kruhu a **splývají spolu bez ohledu na odstín** —
u šedi je odstín šum, ne informace. Tohle je vážnější než §3.1, protože na středu
kruhu žádné „rozházení po obvodu" nepomůže: šedou nelze posunout jinam, aniž
přestane být šedá.

### 3.3 Kolize jsou v pozadí, ne ve spritech

Tohle je nejdůležitější řádek celého reportu. Když se do výpočtu zahrne shader
(saturace Rec.601, pak násobení tintem — pořadí podle `shaders/vignette_color.frag`),
pořadí se přeskládá:

| # | dvojice | sprity syrové | sprity po shaderu | pozadí | celkem | pásmo |
|---:|---|---:|---:|---:|---:|---|
| 1 | `gradius_v` + `ikaruga` | 11,8 | 11,6 | 3,9 | **7,4** | **splývá** |
| 2 | `default` + `geometry_wars` | 19,1 | 18,9 | 3,4 | **10,4** | blízko |
| 3 | `star_fox` + `tyrian_dos` | 6,5 | 10,8 | — | **10,8** | blízko |
| 4 | `gradius_v` + `star_fox` | 10,6 | 11,1 | — | **11,1** | blízko |
| 5 | `asteroids` + `default` | 15,8 | 19,6 | 7,9 | **13,2** | blízko |
| 6 | `default` + `star_fox` | 13,6 | 13,6 | — | **13,6** | blízko |
| 7 | `gradius_v` + `tyrian_dos` | 9,9 | 16,1 | 11,9 | **13,8** | blízko |
| 8 | `default` + `gradius_v` | 24,1 | 21,3 | 8,7 | **14,4** | odliší se |
| 9 | `default` + `tyrian_dos` | 14,9 | 16,9 | 13,4 | **15,0** | odliší se |
| 10 | `asteroids` + `geometry_wars` | 23,6 | 26,5 | 5,9 | **15,2** | odliší se |
| 11 | `geometry_wars` + `nex_machina` | 23,3 | 24,7 | 7,3 | **15,2** | odliší se |
| 12 | `default` + `rtype` | 25,6 | 25,6 | 7,4 | **15,6** | odliší se |
| 13 | `gradius_v` + `rtype` | 23,2 | 23,2 | 10,6 | **16,3** | odliší se |
| 14 | `default` + `ikaruga` | 30,9 | 29,2 | 6,3 | **16,6** | odliší se |
| 15 | `ikaruga` + `tyrian_dos` | 21,2 | 25,5 | 9,7 | **16,8** | odliší se |
| 16 | `geometry_wars` + `gradius_v` | 30,0 | 27,3 | 8,7 | **17,1** | odliší se |
| 17 | `river_raid` + `star_fox` | 17,1 | 17,1 | — | **17,1** | odliší se |
| 18 | `rtype` + `tyrian_dos` | 18,2 | 15,5 | 18,6 | **17,2** | odliší se |
| 19 | `blazing_lazers` + `gradius_v` | 26,6 | 28,0 | 10,7 | **18,5** | odliší se |
| 20 | `ikaruga` + `star_fox` | 20,1 | 18,8 | — | **18,8** | odliší se |
Čtyři pozorování z té tabulky:

1. **`gradius_v` + `ikaruga` je nejhorší dvojice a nese to pozadí.** Sprity 11,6 (v pohodě),
   pozadí **3,9** (prakticky totéž plátno). A obě mají v `ShaderConfig`
   **naprosto identický tint `0,90 / 0,95 / 1,00`** — kopie, která rozdíl aktivně maže.
2. **`default` + `geometry_wars`, pozadí 3,4.** Obojí je skin **zdarma**. Ze tří skinů,
   které hráč dostane bez placení (`galaga`, `geometry_wars`, `default`), vypadají dva
   skoro stejně. To je výkladní skříň appky.
3. **Shader už dnes dělá kus práce.** `star_fox` + `tyrian_dos` je syrově 6,5, po shaderu
   **10,8** — teplý tint Tyrianu (`1,00 / 0,95 / 0,85`) je odtáhne. Podobně
   `gradius_v` + `tyrian_dos` z 9,9 na 16,1 a `asteroids` + `default` z 15,8 na 19,6.
4. **`star_fox` má tint `1,0 / 1,0 / 1,0` a saturaci 1,0, tedy žádný.** Jediný ze všech
   kolizních skinů, který tu páku nemá vůbec zataženou — a je nový, ještě nevydaný.

### 3.4 Proč to tak dopadlo: kolize kopíruje historii

`kSkins` v `lib/services/skin_registry.dart` je **řazený chronologicky** a rok je součástí
jména skinu: Monochrome Invader (1978) → Kiran (2026). Skiny nejsou náhodná sbírka, jsou
procházka dějinami žánru.

A dějiny žánru mají šedou éru. `tyrian_dos` (1995), `ikaruga` (2001), `gradius_v` (2004)
a `star_fox` (1993, přibývá ve v3) jsou šedomodré **protože jejich předlohy šedomodré byly** —
byla to doba, kdy hry objevily kov, render a „realistickou" paletu. Kolize není chyba
generátoru. Je to věrný přepis toho, že se ty čtyři hry na sebe barevně podobaly.

**Tady je jádro rozhodnutí:** každé rozhození palet po kruhu je oslabení předlohy.
Šedý Star Fox posunutý do fialova už není Star Fox. Otázka není „jak barvy rozházet",
ale **kolik věrnosti jsme ochotni obětovat za rozlišitelnost a kde přesně.**

---

## 4. Páka A — přepsat definice a přegenerovat

Změnit `PaletteDescription`, `StyleKeywords` a `BackgroundMood` v
`pipeline/internal/skin/definitions.go` a pustit generátor znovu.

**Pro**
- Jediné řešení, které opravdu mění umělecké dílo, ne jeho filtr. Vzniknou skutečně jiné
  assety, ne přebarvené stejné.
- U ještě nevygenerovaných skinů je **zadarmo** — není co zahazovat.
- Řeší i strukturu pozadí, ne jen jeho barvu, protože `BackgroundMood` řídí obsah scény.

**Proti**
- U 14 vydaných skinů to znamená **změnit zaplacený obsah pod rukama lidí, kteří si ho koupili.**
  To je produktové rozhodnutí, ne technické.
- Cena strojového času: zhruba 31 spritových specs + 16 pozadí na skin. Při dvou variantách
  a ~20 s/obrázek je to kolem 30–40 minut ComfyUI na jeden skin, plus ruční výběr variant.
- Generátor **neposlouchá paletu spolehlivě.** Důkaz z dneška: `solar_striker` má v definici
  napsáno „pouze tyto čtyři odstíny, žádné jiné barvy" a model přesto vyrobil sprity, kde
  je paleta rozvolněná natolik, že chroma key sežral světlé objekty. Přepsat definici tedy
  neznamená dostat požadovanou paletu — znamená to zvýšit pravděpodobnost.
- Nezachrání §3.2. Šedý skin, který má být šedý, zůstane po přegenerování šedý.

**Kdy dává smysl:** pro 7 skinů, které ještě nemají assety, a pro `star_fox`, jehož pozadí
se v tuto chvíli ještě negeneruje.

---

## 5. Páka B — záměna barev v postprocesu

Přidat do `pipeline/internal/postprocess` operaci, která posune odstín nebo přemapuje paletu
už vyrenderovaných obrázků.

**Pro**
- Nulový strojový čas na generování, běží lokálně nad hotovými JPEGy.
- Deterministické a přesně řiditelné, na rozdíl od promptu.

**Proti — a tohle je podle mě zabiják**
- **Rotace odstínu nefunguje na tom, co je rozbité.** Kolizní skiny kolidují právě proto, že
  jsou odbarvené (§3.2). Rotace odstínu na šedi se sytostí 0,20 vyrobí zase tu samou šeď.
  Aby to zabralo, musela by se sytost **přidávat**, což je mnohem invazivnější operace a
  z realistického kovu udělá plast.
- Postprocess běží **před** balením atlasu, takže každá změna znamená přebalit atlas a vydat
  nový build. Není to nic, co by šlo doladit za běhu.
- Zavádí druhý zdroj pravdy o barvě skinu. Definice říká jedno, postprocess druhé, a při
  příštím přegenerování se ta dvě rozejdou.
- V `internal/postprocess` **dnes žádná barevná operace není** — celý modul se zabývá alfou,
  ořezem a měřítkem. Byla by to nová třída kódu k údržbě.

**Kdy dává smysl:** prakticky nikdy, pokud existuje páka C, protože C dělá totéž levněji,
reverzibilněji a na správné vrstvě.

---

## 6. Páka C — per-skin tint v shaderu, který v repu už je

`lib/rendering/shader_config.dart` má pro každý skin `tintR`, `tintG`, `tintB` a `saturation`.
`shaders/vignette_color.frag` je aplikuje na **celou scénu** — sprity i pozadí najednou:

```glsl
float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
color.rgb = mix(vec3(lum), color.rgb, uSaturation);   // saturace první
color.rgb *= vec3(uTintR, uTintG, uTintB);            // pak tint
```

Tahle páka **už se pro tenhle účel používá** — `tyrian_dos` má teplý tint, `ikaruga` studený,
`asteroids` zelený, `luftrausers` výrazně sépiový `1,00 / 0,90 / 0,70`. Jen se používá
nesystematicky: **osm skinů ji nemá zataženou vůbec** (`default`, `galaga`, `nex_machina`,
`river_raid`, `rtype`, `space_invaders`, `star_fox`, `twinbee`) a **tři mají shodnou hodnotu
`0,90 / 0,95 / 1,00`** — `ikaruga`, `gradius_v` a plánovaný `thunder_force`, který si tu
kolizi teprve zdědí.

**Pro**
- **Čtyři čísla v jedné konstantní mapě v Dartu.** Žádná generace, žádný postprocess,
  žádné přebalení atlasu.
- Posune sprity i pozadí **konzistentně**, takže neroztrhne vnitřní ladění skinu.
- **Na šedi funguje.** Neutrální šeď × `(1,00; 0,90; 0,75)` je teplá šeď. Přesně tohle
  odděluje `star_fox` od `tyrian_dos` a přesně tohle už dnes ten rozdíl z 6,5 dělá 10,8.
- Okamžitě reverzibilní a testovatelné. Dá se na to napsat test v Dartu, který spočítá
  vzdálenosti mezi presety a shodí build, když dva skiny splynou.
- Nedotýká se assetů, tedy ani zaplaceného obsahu — mění se jen filtr, kterým se dívá.

**Proti**
- Tint je násobení, tedy **jen ztmavuje.** Nedokáže barvu přidat tam, kde není, ani posunout
  dva odstíny proti sobě. Je to posun celé scény, ne přemapování palety.
- Silný tint sníží celkový jas. U už tak tmavých skinů (`nuclear_throne` jas 0,33,
  `rtype` 0,34) není moc kam ubírat.
- Neřeší **strukturu** pozadí. Když mají `gradius_v` a `ikaruga` obě mlhovinu se stejným
  rozložením, tint z jedné neudělá kaňon.
- **Nepomůže hráči v obchodě, a to je ověřeno.** `SkinSelector` kreslí kartu z
  `AssetLibrary.loadPreviews()` jako prostý `ui.Image` (`lib/ui/skin_selector.dart:351,414`).
  Shader na ni nesahá. Tint tedy opraví, jak skin vypadá ve hře, ale **ne to, podle čeho se
  kupuje.** Dá se to dorovnat: obalit náhled `ColorFiltered` se stejnou maticí, jakou má
  preset. Je to pár řádků, ale je to nutná součást páky C, ne volitelný doplněk — jinak se
  opraví přesně to místo, kde na tom nezáleží nejvíc.

---

## 7. Co bych dělal já

Nejde o volbu jedné páky. Podle mě jde o tři různé skupiny skinů, kde má každá jinou správnou
odpověď, a hlavní chyba by byla použít na všechny stejnou.

### 7.1 Sedm nevygenerovaných skinů → páka A, hned a zadarmo

`zaxxon`, `twinbee`, `fantasy_zone`, `abadox`, `axelay`, `thunder_force`, `lords_of_thunder`
nemají jediný asset. Přepsat jim definici nic nestojí. Deklarované palety navíc míří
většinou do prázdných míst kruhu (růžová `fantasy_zone`, masová červená `abadox`), takže
to vypadá dobře — ale **`axelay` a `thunder_force` mají obě „steel/cold blue" s oranžovým akcentem a míří
přímo do už přeplněné modré.** `thunder_force` navíc už má nastavený tint shodný
s `ikarugou` a `gradiem`, takže by do té kolize zapadl dvakrát. Ty dvě bych přepsal dřív,
než se pustí batch 2.

Zároveň bych zavedl **explicitní rozpočet kruhu**: každý skin dostane přidělený výsek odstínu
a pásmo sytosti, a přidání dalšího skinu do obsazeného výseku je vědomé rozhodnutí, ne náhoda.

### 7.2 `star_fox` → páka A, ale okno se zavírá dnes

`star_fox` má hotové sprity, **pozadí se v tuhle chvíli ještě negenerovalo** (batch je na
`tempestu`). Do začátku jeho pozadí zbývá zhruba 20–25 minut. Jeho `BackgroundMood` se dá
přepsat teď zadarmo; za půl hodiny už to bude stát přegenerování. ComfyUI navíc ve 2:00
vypínají do 6:00.

Sprity `star_foxu` bych **nepřegeneroval** — vypadají dobře a šedomodrá je věrná předloze.
Místo toho mu dát tint (viz 7.3), což je přesně to, co u něj dnes chybí.

### 7.3 Čtrnáct vydaných skinů → páka C, assetů se nedotýkat

Konkrétně a v tomhle pořadí:

1. **Rozejít `gradius_v` a `ikaruga`.** Mají shodný tint `0,90 / 0,95 / 1,00`. Ikaruga je
   o polaritě černá–bílá, snese tint úplně neutrální; Gradius je kov, snese chladnější
   a tmavší. Jedna z těch dvou hodnot je kopie, která tam neměla nikdy být.
2. **Rozejít `default` a `geometry_wars`,** protože jsou obě zdarma a jejich pozadí je na 3,4.
   Geometry Wars je neonová mřížka, snese silný azurový tint a vyšší saturaci; `default`
   je vlajkový skin Kiranu a měl by zůstat nejneutrálnější.
3. **Dát `star_foxu` tint,** aby nesplýval s `tyrian_dos` a `asteroids`. SNES Star Fox měl
   nádech do modrofialova, takže `0,95 / 0,95 / 1,05`… což tint neumí, protože nad 1,0
   přepaluje. Tedy spíš ztlumit červenou a zelenou: `0,88 / 0,92 / 1,00`.
4. **Obarvit i náhledy v obchodě** stejným tintem přes `ColorFiltered`, jinak páka C
   nepokrývá tu obrazovku, kde hráč o nákupu rozhoduje.
5. **Napsat test,** který spočítá vzdálenost mezi všemi dvojicemi presetů a shodí build pod
   zvolenou hranicí. Bez něj se to za tři skiny rozejde znovu. Vzor existuje —
   `test/skin_registry_consistency_test.dart` už dneska hlídá, že každý skin má preset
   a téma, a při psaní odhalil, že `river_raid` žádný preset neměl.

### 7.4 Co bych naopak nedělal

- **Nepřegeneroval bych vydané skiny.** Barevná kolize je nepříjemná, ale změnit vzhled
  zaplaceného obsahu je horší.
- **Nepřerovnal bych `kSkins`,** aby kolizní skiny nesousedily. Řazení je chronologické a
  ten příběh je součástí hodnoty. Kolize se navíc kupí právě proto, že jsou ze stejné éry,
  takže rozehnat je znamená rozbít chronologii úplně.
- **Nešel bych do páky B.** Dělá to samé co C, jen dráž, na horší vrstvě a nevratně.

---

## 8. Na co bych chtěl tvůj názor

1. **Je páka C dost?** Tint je násobení celé scény. Mám pocit, že na oddělení šedých skinů
   stačí, protože přesně to už u `tyrian_dos` prokazatelně funguje. Nebo je to lepení
   náplasti na to, že tři skiny mají prostě stejný nápad?
2. **Kolik věrnosti obětovat?** Šedá éra je historicky pravdivá. Je lepší mít čtyři poctivě
   šedé skiny, které se pletou, nebo čtyři rozlišitelné, z nichž dva už nepřipomínají svou
   předlohu?
3. **Jaká je správná hranice pro test?** Navrhuji ΔE 8 na celkovém skóre jako tvrdý fail
   a 14 jako varování. Je to postavené na tom, co jsem naměřil, ne na literatuře — sedí to?
4. **Má se rozlišovat globálně, nebo jen lokálně?** Uvažoval jsem, že skutečné riziko není
   „dva z 24 skinů jsou si podobné", ale „hráč přepne a nepozná to". To by znamenalo hlídat
   hlavně tři skiny zdarma a dvojice, které jsou v selektoru vedle sebe.
5. **Stojí za to rozšířit metriku o strukturu?** Barva je jen jedna složka (§2.1). Šlo by
   měřit i hustotu hran nebo rozložení jasu, což by odlišilo hladkou Ikarugu od členitého
   Gradia. Přijde ti to jako potřebné, nebo předělané?
6. **Rozpočet kruhu — kdo ho vlastní?** Když se zavede přidělování výseků odstínu, je to
   omezení pro každý budoucí skin. Nemám pocit, že u sbírky poct konkrétním hrám je to
   správný nástroj, ale nemám lepší.

---

## 9. Přílohy

### 9.1 Změřené skiny

| skin | stav | odstín | sytost | jas | rozptyl | barev | dominantní vzorky | shader tint R/G/B |
|---|---|---:|---:|---:|---:|---:|---|---|
| `space_invaders` | placený | 124° | 0,94 | 0,55 | 0,00 | 1 166 | `#0A9E17` `#05750E` `#025607` `#0AD311` | — *(neutrální)* |
| `asteroids` | placený | 190° | 0,23 | 0,60 | 0,02 | 1 234 | `#AFC1C4` `#7D989D` `#4F676E` `#1E3035` | 0,85 / 1,00 / 0,85 |
| `galaga` | zdarma | 1° | 0,66 | 0,87 | 0,07 | 3 494 | `#F8413E` `#D3272E` `#A32A34` `#EDE4E3` | — *(neutrální)* |
| `river_raid` | placený | 27° | 0,25 | 0,57 | 0,70 | 2 501 | `#675955` `#B69777` `#E1DCD2` `#272323` | — *(neutrální)* |
| `rtype` | placený | 7° | 0,33 | 0,34 | 0,02 | 645 | `#412E2B` `#583F3B` `#704F4B` `#261D1C` | — *(neutrální)* |
| `blazing_lazers` | placený | 197° | 0,71 | 0,80 | 0,28 | 3 897 | `#17CFF3` `#CFC2AE` `#3C4B5F` `#1490BF` | 1,00 / 0,95 / 0,90 |
| `tyrian_dos` | placený | 210° | 0,18 | 0,45 | 0,45 | 1 724 | `#868C91` `#42464A` `#222934` `#AEB4B6` | 1,00 / 0,95 / 0,85 |
| `ikaruga` | placený | 266° | 0,07 | 0,84 | 0,06 | 883 | `#FEFEFE` `#DAD8DE` `#F0EFF1` `#B39CC9` | 0,90 / 0,95 / 1,00 |
| `geometry_wars` | zdarma | 201° | 0,84 | 0,57 | 0,12 | 3 270 | `#1A82AC` `#25398D` `#062B3F` `#105F71` | 0,80 / 1,00 / 1,00 |
| `gradius_v` | placený | 232° | 0,20 | 0,67 | 0,56 | 2 965 | `#EBEDEF` `#878A93` `#D1D3D8` `#252F4B` | 0,90 / 0,95 / 1,00 |
| `luftrausers` | placený | 32° | 0,61 | 0,55 | 0,00 | 599 | `#825B30` `#684519` `#F3DFC1` `#53330E` | 1,00 / 0,90 / 0,70 |
| `nuclear_throne` | placený | 29° | 0,79 | 0,33 | 0,01 | 864 | `#5A320C` `#43260B` `#7D4C1E` `#2C1A09` | 1,00 / 0,90 / 0,75 · sat 0,85 |
| `nex_machina` | placený | 224° | 0,92 | 0,59 | 0,36 | 3 449 | `#0A3A83` `#0D60AF` `#0B174F` `#1797DA` | — *(neutrální)* |
| `default` | zdarma | 194° | 0,70 | 0,47 | 0,18 | 1 562 | `#124859` `#44525A` `#10899C` `#181717` | — *(neutrální)* |
| `solar_striker` | **nový v3** | 126° | 0,39 | 0,60 | 0,03 | 1 472 | `#7AB17D` `#A8DAAE` `#59975C` `#43734A` | 0,90 / 1,00 / 0,85 · sat 0,90 |
| `tempest` | **nový v3** | 48° | 0,73 | 0,60 | 0,20 | 5 087 | `#E3EF36` `#090602` `#A3A226` `#DD2416` | 1,00 / 0,95 / 1,00 |
| `star_fox` | **nový v3** | 206° | 0,20 | 0,53 | 0,16 | 2 726 | `#919598` `#697179` `#444F5B` `#B8C0C2` | — *(neutrální)* |
*Odstín je cirkulární průměr vážený sytostí — odstín šedého pixelu je šum, ne informace.
Rozptyl 0 znamená jednu barvu, 1 znamená, že se odstíny navzájem vyruší.
Počet barev je při 5bitové hloubce na kanál.*

### 9.2 Skiny s deklarovanou, ale nezměřenou paletou

| skin | shader tint R/G/B | deklarovaná paleta |
|---|---|---|
| `zaxxon` | 0,95 / 0,95 / 1,00 | fortress gray #8890A0, brick red #B03030, steel blue #4060A0, warning yellow #F0D040, deep shadow #101820 |
| `twinbee` | — *(neutrální)* | cherry red #FF3040, sky blue #40A0FF, sunshine yellow #FFE040, white #FFFFFF, mint #60E0A0 on pale sky #C8E8FF |
| `fantasy_zone` | 1,00 / 0,97 / 1,00 · sat 1,10 | bubblegum pink #FF9AD0, mint #A0F0D0, lemon #FFF0A0, lavender #C8B0FF, peach #FFC8A0 on cream #FFF4E8 |
| `abadox` | 1,00 / 0,85 / 0,85 | raw flesh red #A02020, dried blood #501010, bone white #E8D8C0, bile green #80A030, black #080404 |
| `axelay` | 0,92 / 0,95 / 1,00 | steel gray #9AA4B0, gunmetal #4A5560, cold blue #3060A0, warning orange #FF7020, white highlights on space black #06080C |
| `thunder_force` | 0,90 / 0,95 / 1,00 | cobalt blue #2050C0, ice blue #A0D0FF, chrome white #F0F4FF, hot orange #FF8000, magenta accents #E040A0 on deep navy #040A20 |
| `lords_of_thunder` | 1,00 / 0,92 / 0,85 | burnished gold #D8A030, blood red #B01020, lightning blue #60C0FF, flame orange #FF6010, black steel #1A1A22 |
### 9.3 Kde se to v repu odehrává

| co | soubor |
|---|---|
| definice skinů, palety, prompty | `pipeline/internal/skin/definitions.go` |
| shader presety per skin (**páka C**) | `tyrian_mobile/lib/rendering/shader_config.dart` |
| matematika tintu a saturace | `tyrian_mobile/shaders/vignette_color.frag` |
| pořadí a ceny skinů | `tyrian_mobile/lib/services/skin_registry.dart` |
| postprocess assetů (**páka B by šla sem**) | `pipeline/internal/postprocess/processor.go` |
| existující konzistenční test | `tyrian_mobile/test/skin_registry_consistency_test.dart` |

### 9.4 Reprodukce měření

Nástroje jsou zatím ve scratchi, ne v repu — záměrně, dokud se nerozhodne, jestli z toho
má být trvalý audit:

1. `magick <skin>/atlas.webp -resize 1024x512 <skin>.png` pro všech 14 vydaných; pro nové
   skiny montáž z výstupu postprocesu
2. `magick <skin>/backgrounds/layer_0_z0.webp -resize 256x <skin>.png`
3. Go nástroj: vzorkování neprůhledných pixelů → k-means (6 pro sprity, 4 pro pozadí,
   12 iterací, deterministické rozsetí seedů) → HSV souhrn
4. Druhý Go nástroj: převod do CIELAB, oboustranná vážená vzdálenost nejbližších vzorků
5. Přepočet se shaderem: saturace přes Rec.601 luma, pak násobení tintem, pořadí podle
   `vignette_color.frag`

### 9.5 Vedlejší nález z dnešního dne, který sem patří

Při zpracování batche 1 se ukázalo, že `solar_striker` má paletu tak úzkou, že ji chroma key
při výchozím prahu 60 zaměňoval za pozadí: světlým kulatým objektům chybělo 15–50 % těla a
`asteroid3` byl vymazaný na nulu. Opraveno per-skin prahem (`BgThreshold: 22`) a automatickým
backoffem, který hlásí, když key sprite sežral.

**Souvisí to s tímhle reportem:** je to důkaz, že **úzká paleta má technické důsledky až dolů
v pipeline**, ne jen estetické. Kdyby se šlo cestou A a nějakému skinu se paleta stáhla
k monochromu, tenhle problém přijde s ním.

---

*Podklady: 17 skinů změřeno z assetů, 7 z deklarace. Generování batche 1 v době psaní běží,
takže tři nové skiny nemají pozadí a jejich celkové skóre se ještě pohne.*
