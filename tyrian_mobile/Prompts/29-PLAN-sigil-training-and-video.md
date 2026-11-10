# 29 — PLÁN: Výcvik a videa — jak naučit svět kreslit sigily

**Jen linie 3.x (`main`).** Stojí na plánu `28-PLAN-gamepad-combat.md`; bez jeho kroků 1–2
není co učit.

Cíl jednou větou: každý sigil a každý trik má **jednu lekci jako data**, ze které hra udělá
výcvik v aréně a nástroje krátké video namluvené ve všech 15 jazycích — takže video nikdy
neukazuje nic, co ve hře neplatí.

**Jen desktop:** sigily na mobilu nebudou (rozhodnuto 2026-11-10), takže aréna, lekce i výuka
ve hře existují jen na desktopu. Videa se ale dívají na telefonech — viz §8.3.

Dokument je psaný pro implementační session (Opus).

---

## 0. Fakta, na kterých plán stojí (ověřeno 2026-11-10 na `main`, 3.9.2)

| Věc | Kde | Důsledek pro plán |
|---|---|---|
| 15 jazyků: cs, de, en, es, fr, id, it, ja, ko, pt, ru, th, tr, vi, zh | `lib/l10n/` | Rozsah namluvení. Thajština, vietnamština, čínština, japonština a korejština potřebují v titulcích vlastní font. |
| Ve hře není žádný tutoriál; režimy jsou `GameMode { endless, campaign }` | `lib/game/tyrian_game.dart:63` | Aréna je třetí režim `training`. |
| Zpomalení existuje jen pro nepřátele (`enemyTimeScale`, `startTimewarp`) | `tyrian_game.dart` | Výcvik a zpomalené záběry potřebují zpomalit **celý svět** včetně hráče → nový `worldTimeScale`. |
| Skládání videa už v repu je: číslované klipy + titulkové karty → 1920×1080 60 fps H.264 | `store/steam/build_trailer.py`, `store/steam/trailer-script.md` | Stejný přístup (ffmpeg řízený skriptem), nový formát 9:16. |
| Řízený průchod aplikací se seedovaným savem a přepnutým jazykem už existuje | `tool/store_screenshots.sh`, `test_driver/store_app*.dart` | Vzor pro nahrávací režim. Mobilní buildy se na tomhle stroji nedělají → nahrává se desktopový build. |
| Hra je portrait-first; landscape je na desktopu jen rotace kamery | CLAUDE.md | Svislé video je přirozený formát hry, ne ořez. |
| Na sdíleném GPU stroji je služba `tts` a doplněk `asr` | katalog brokeru | **Model a pokrytí jazyků nejsou ověřené.** Než se slíbí 15 jazyků, pilot (§7.3). |
| Generování SFX a hudby jde přes hostovanou službu; hudební kredity jsou vyčerpané | `pipeline/` | Podkres videí z hotové hudby skinů; licenci pro sociální sítě ověřit (otázka č. 8). |
| Katalog sigilů je jedna tabulka s `tier` 1–5; testy mají nahrané stopy páčky; FLOW D–S | plán 28 §5.4, §4.5, §6.2 | Osnova, referenční vstupy i hodnocení se berou odtud, nic se nevymýšlí podruhé. |
| Žebříček je jen Game Center (iOS/macOS) a Play Games; Windows a Linux (Steam) žádný, Steamworks SDK ve hře není | `lib/services/leaderboard_service.dart` | Denní výzva (§5.5) má žebříček zatím jen na Macu; na Steamu závisí na otázce č. 7 plánu 28. |
| Nástroje do `bin/`, běhová data do gitignorovaného `run/` | globální pravidla | Videa a snímky nejdou do gitu. |

---

## 1. Princip: jedna lekce, dva výstupy

```
                       ┌──► ARÉNA: ukázka → obkreslení → pomalu → naostro → 5× po sobě
 lekce (JSON) ─────────┤
  scéna, referenční    └──► VIDEO: stejná scéna přehraná referenčním vstupem,
  vstup, kroky, text         zmrazení a zpomalení podle kroků, hlas v 15 jazycích
```

- Lekce říká: jaká scéna (co kde letí), **referenční vstup** (stopa páček a tlačítek v čase),
  kroky s časovými značkami, podmínky splnění a klíče textů.
- Hra lekci přehraje dvakrát jinak: v aréně hraje hráč a referenční vstup je „duch“; při
  nahrávání hraje duch sám a hra ukládá snímky.
- Změní-li se cena nebo tvar v katalogu, lekce se přehraje znovu a videa se přegenerují.
  Ruční střih neexistuje.

Podmínka, na které to celé stojí: **aréna je deterministická** — pevný krok 1/60 s, seedovaný
`Random`, žádná závislost na hodinách. Stejný vstup dvakrát = stejný výsledek na snímek.

---

## 2. Slovník

| Pojem | Význam |
|---|---|
| **Aréna** | Režim `GameMode.training`: bezpečný prostor bez smrti, se zpomalením a duchem. |
| **Lekce** | Jeden sigil nebo jeden trik, krok za krokem. |
| **Duch** | Referenční vstup přehrávaný vedle hráče: stín páčky na sigil padu a průsvitná loď. |
| **Krok** (`beat`) | Úsek lekce: akce + volitelné zmrazení nebo zpomalení + jedna věta. |
| **Dril** | Opakování jednoho sigilu s měřením přesnosti, času a tempa. |
| **Zkouška** | Scéna, kterou nejde projít bez sigilů daného stupně. Odemyká další stupeň. |
| **Kata** | Předepsaný řetěz sigilů v čase, hodnocený D–S. |
| **Gauntlet** | Nekonečné stupňované vlny v aréně s číselným hodnocením. |
| **Tempo** | Rychlost světa v drilu; nad 100 % nemá strop. |
| **Mistrovství** | Statistika a hodnost každého sigilu zvlášť. |

---

## 3. Aréna

- Vstup z hlavního menu a ze stránky grimoáru v ComCenteru. Jen když `sigilsEnabled`
  (desktop + schéma `sigil`); na mobilu se položka vůbec neukáže.
- **Bezpečná:** zásahy se počítají a ukazují, ale neubírají. NÁBOJ jde přepnout na nekonečný.
- **`worldTimeScale`** (nové, jedno místo na začátku `TyrianGame.update`): 100 / 50 / 25 %
  a v drilu i nad 100 %. Násobí `dt` pro všechno, i pro hráče a rozpoznávač — pomalý svět
  znamená i pomalejší kreslení, jinak by zpomalení nic neučilo. Mimo arénu je vždy 1,0.
- **Scéna je skript:** `ArenaScript` = seznam `(t, spawn)` se seedem. Střely jdou přes
  `spawnEnemyProjectile` jako všude jinde; aréna běží na `Challenge.normal`.
- **Vstupní panel** (Flame komponenta, jen v aréně a při nahrávání): zvětšený sigil pad,
  obrys ovladače s polohou obou páček, tlakem triggerů a stavem shoulderů. „Ukaž ruce.“
- **Duch:** stopa referenčního vstupu se kreslí do stejného panelu jinou barvou a o 0,4 s
  napřed; průsvitná loď letí referenční dráhu.
- **Okamžité přehrání chyby:** po nepovedeném pokusu se poslední 2 s přehrají na 25 % se
  stopou hráče přes stopu ducha a jednou větou, co se stalo. K tomu rozpoznávač z plánu 28
  vrací `SigilDiagnosis { nearest, firstMismatchAt, reason }` s důvody `skippedDot`,
  `leftRimEarly`, `wrongDirection`, `tooSlow`, `noCharge`, `wrongLayer`.
- Ovládání arény: Back = grimoár, Start = menu arény (rychlost, nekonečný NÁBOJ, restart
  kroku, další lekce). Všechno padem.

---

## 4. Lekce krok za krokem

### 4.1 Průběh jedné lekce

| Fáze | Co hráč dělá | Splněno, když |
|---|---|---|
| 1. **Dívej se** | Duch předvede trik naostro, pak na 25 % se vstupním panelem | hráč potvrdí (nebo přeskočí) |
| 2. **Obkresli** | Svět stojí. Kreslí tvar na zvětšeném padu, body se rozsvěcují | 3× správně |
| 3. **Pomalu** | Svět na 50 %, přiletí hrozba, na kterou trik odpovídá | 3× správně |
| 4. **Naostro** | 100 % | 3× správně |
| 5. **Pětkrát po sobě** | 100 %, střídavě i zrcadlově | 5× bez chyby v řadě |

Chyba v kterékoli fázi spustí okamžité přehrání a fáze se opakuje. Nic se nepočítá na čas;
lekce se nedá „prohrát“. Po páté fázi se sigil označí jako naučený a nabídne se další.

### 4.2 Formát

`assets/lessons/<id>.json` — čte ho hra i nástroje:

```json
{
  "id": "loop",
  "kind": "sigil",
  "sigil": "loop",
  "skin": "default",
  "seed": 28017,
  "scene": [{ "t": 1.2, "spawn": "wall", "gapAt": null, "speed": 220 }],
  "reference": "traces/loop_clean.json",
  "beats": [
    { "key": "loop.hook",   "from": 0.0, "to": 2.4 },
    { "key": "loop.shape",  "from": 0.0, "to": 2.4, "scale": 0.25, "panel": "stick" },
    { "key": "loop.phase",  "freezeAt": 1.55, "callout": ["phase", "cost"] },
    { "key": "loop.use",    "from": 3.0, "to": 6.5 },
    { "key": "loop.outro",  "next": "strike" }
  ],
  "pass": { "sigil": "loop", "noHullHit": true }
}
```

- `reference` je stopa ve stejném formátu jako testovací stopy z plánu 28 (`t, lx, ly, rx, ry,
  lt, rt, tlačítka`). Nahrává se v aréně: debug volba „nahrát referenci“ uloží poslední pokus.
- `beats` jsou zároveň osnova videa (§6.2) i texty fáze 1.
- Krátké texty pro hru jsou v ARB (`lessonLoopShape`…). Delší věty pro hlas žijí mimo
  aplikaci v `tutorial/narration/<jazyk>.json` — hra je nenese v balíku.
- Test `test/lessons_test.dart`: každá lekce se načte, její reference **opravdu splní** `pass`
  (přehraje se v deterministické aréně), každý `key` má text v ARB i ve všech narration souborech.
  Rozbitá lekce tak neprojde gate.

### 4.3 Osnova

Pořadí je `tier` z katalogu. Systémové lekce jdou před sigily, triky po nich.

| Řada | Lekce | Počet |
|---|---|---|
| **S0 Systém** | Dvě páčky · Mřížka 3×3 · Tři vrstvy · NÁBOJ a přebytek · Graze a fáze · OVERSTREAM · MEGA BLAST · FLOW | 8 |
| **S1 HULL** | HOP, SIDESTEP, STRIKE, RETREAT, DASH, ROLL, LOOP, SHADOW, ECHO, SLALOM, CORKSCREW | 11 |
| **S2 ARMS** | SNAPSHOT, BROADSIDE, VOLLEY, REARGUARD, OVERDRIVE, TIMEWARP, AEGIS, RADIAL, STORM | 9 |
| **S3 WING** | PING, WINGMAN, LANCER, WARDEN, FORMATION, ORBIT, SACRIFICE | 7 |
| **S4 Triky** | viz níže | 12 |

S4 — triky, které nejsou v katalogu, ale plynou z pravidel:

1. **Šetři a utrať:** uber RT, nech narůst NÁBOJ, utrať ho sigilem.
2. **Navázání:** druhý sigil nakreslený v posledních 30 % prvního (buffer).
3. **BREAK cancel:** utni STRIKE a hned ROLL.
4. **Zeď skrz:** LOOP přes stěnu střel, phase graze vrátí půlku ceny.
5. **Focus farma:** A a průlet mezi střelami, NÁBOJ z grazu.
6. **Stín a pedál:** SHADOW + OVERSTREAM 3 na jeden cíl.
7. **Dvojník v bouři:** ECHO, pak STORM — pálí oba.
8. **Želva:** WARDEN + AEGIS pod bossem.
9. **Oběť a návrat:** SACRIFICE vrátí NÁBOJ na nový WINGMAN.
10. **Blast jako štít:** MEGA BLAST zruší salvu, která by tě trefila.
11. **Křížová palba:** PING a tvůj VOLLEY do stejného bodu — companioni a loď v jedné ráně.
12. **Kata „První S“:** nejkratší řetěz na FLOW S.

Celkem 47 lekcí. Každý krok plánu 28 dodá lekce svých sigilů — je to součást jeho „hotovo“.

---

## 5. Nekonečný postup dovednosti

Odemykání jednou skončí. Tyhle čtyři osy ne.

### 5.1 Dril a tempo

- Vybereš sigil nebo sadu. Aréna zadává výzvy (tvar se ukáže, přiletí hrozba), náhodně i zrcadlově.
- Měří se: úspěšnost, **čas kreslení** (od opuštění středu po rozpoznání, v ms) a série.
- Po 5 úspěších v řadě se **tempo** zvedne o 5 %, po chybě o 5 % klesne (ne pod 50 %).
  Nad 100 % je svět rychlejší než hra — a nemá strop. Rekordní tempo každého sigilu je číslo,
  které jde zlepšovat pořád.

### 5.2 Mistrovství sigilu

- U každého sigilu se ukládá: pokusy, úspěchy, nejlepší čas kreslení, rekordní tempo, kolikrát
  byl použit v ostré hře a kolik phase grazů přinesl.
- Hodnosti podle úspěšných použití v ostré hře: 10 / 100 / 1 000 / 10 000 / dál ×10 bez konce.
  Grimoár ukazuje hodnost u glyfu. Je to jen čest a kosmetika (obrys glyfu), žádná síla navíc.

### 5.3 Zkoušky

- Jedna na stupeň (`tier` 1–5) a vrstvu. Scéna, kterou nejde projít jinak: stěna bez mezery
  (LOOP nebo DASH), cíl za štítem dosažitelný jen STRIKEm, salva, kterou přežije jen AEGIS…
- Splnění odemyká sigily dalšího stupně (plán 28 §10). Počet pokusů neomezený, hodnocení D–S
  podle zásahů a spotřeby NÁBOJE; odemyká už D.

### 5.4 Kata

- Ručně psané řetězy s časováním, např. `LOOP → STRIKE → VOLLEY → HOP`. Duch je předvede;
  hráč je musí zahrát v oknech (± 0,25 s na krok při 100 %).
- Hodnocení D–S: přesnost oken, FLOW na konci, zásahy. S vyžaduje bez chyby.
- Start s 20 katami ve čtyřech pásech obtížnosti; další se přidávají jako data bez zásahu do kódu.
  Formát je lekce s `kind: "kata"` a polem `sequence`.

### 5.5 Gauntlet a denní výzva

- Nekonečné vlny generované ze seedu; každá vlna je poskládaná z dílků zkoušek, takže **žádá
  triky**, ne jen přežití. Každých 5 vln roste hustota a klesá příjem NÁBOJE z přebytku.
- Tady se **umírá** (jediné místo v aréně). Výsledek: dosažená vlna a **hodnocení** — celé
  číslo, které roste s vlnou, FLOW a pestrostí použitých sigilů. Nemá strop.
- **Denní výzva:** seed dne je stejný pro všechny. Série dní se počítá vždy, lokálně.
  Žebříček dne: na Macu přes `leaderboard_service` (nová tabulka v Game Center, založí
  uživatel), na Steamu až se Steamworks leaderboards (otázka č. 7 plánu 28). Bez žebříčku
  se ukáže jen vlastní nejlepší výsledek.

### 5.6 Kde se to ukládá

`SaveService`: `sigilStats[id]`, `trials[tier][layer]`, `kata[id].grade`, `gauntletBest`,
`dailyStreak`, `lessonsDone`. Chybějící klíč = nula; migrace není potřeba.

---

## 5b. Výuka přímo ve hře (mimo arénu)

Lehká, přeskočitelná, jen ve schématu `sigil` a jen třikrát za život savu:

1. **První plný NÁBOJ:** svět na 30 % (`worldTimeScale`), nad lodí glyf HOP a šipka. Po
   provedení nebo po 3 s se čas vrátí.
2. **První stěna střel v kampani:** totéž s LOOPem.
3. **První plný generátor při držené palbě:** nápověda LT → OVERSTREAM.

V co-opu se čas nezpomaluje, nápověda je jen glyf. Po třetí nápovědě hra jednou nabídne arénu.
V grimoáru má každý sigil tlačítko „Trénovat“ (otevře lekci) a „Video“ (otevře odkaz v prohlížeči).

---

## 6. Videa: jak je natočit

### 6.1 Formát

- **1080×1920, 60 fps, H.264 + AAC**, cíl 20–45 s, tvrdý strop 59 s v nejdelším jazyce
  (skládací skript jinak selže).
- Rozvržení plátna shora: **hra 1080×1440** (aréna si nastaví `gameHeight` na poměr 3:4),
  pod ní **vstupní panel a titulek 1080×300**, spodních 180 px prázdných. Spodní pětinu
  a pravý okraj překrývají ovládací prvky TikToku a Shorts; sigil pad, který je ve hře vpravo
  dole, by tam nebyl vidět.
- Jedna lekce = jedno video. Navíc souhrn každé řady („Všech 11 sigilů trupu“) složený
  ze stejných kroků — hodí se i na stránku obchodu.

### 6.2 Šablona jednoho videa

| # | Krok | Délka | Obraz | Hlas |
|---|---|---|---|---|
| 1 | **Háček** | 2–3 s | Trik naostro, bez panelu, bez slov | — |
| 2 | **Jméno** | 0,8 s | Karta: glyf 3×3 + jméno + vrstva | jméno |
| 3 | **Tvar** | pružná | Tentýž záběr na 25 %, panel ukazuje páčku, glyf se kreslí bod po bodu | „Zleva středem doprava.“ |
| 4 | **Zastavení** | pružná | Zmrazený snímek v klíčovém okamžiku, popisky (cena, okno fáze, co proletí) | jedna až dvě věty proč |
| 5 | **K čemu** | 3–5 s | Jiná situace naostro: kdy to použít | jedna věta |
| 6 | **Dál** | 1,5 s | „Na PC / Steam Decku“ + glyf příštího dílu | — |

**Pružné kroky řeší jazyky.** Němčina je delší než čínština. Akční záběry mají pevnou délku;
zastavení a zpomalení se natáhnou přesně na délku hlasu v daném jazyce. Proto je zmrazený
snímek základ formátu, ne ozdoba.

### 6.3 Nahrávání

Aplikace dostane **nahrávací režim**: `--dart-define=LESSON_CAPTURE=<id>` → spustí se rovnou
aréna, duch hraje referenční vstup, hra jede pevným krokem a ukládá výstup do `run/tutorial/<id>/`:

- snímky (nebo rovnou video bez zvuku),
- `beats.json` — které snímky patří kterému kroku, které jsou zmrazené,
- `events.json` — časy a id všech zvuků, které by `SoundService` přehrál.

Zpomalené záběry se **nahrávají zpomaleně** (`worldTimeScale 0,25` při pevném kroku), takže
mají plných 60 skutečných snímků za sekundu. Žádná interpolace, žádné rozmazání.

Dvě cesty, pilot rozhodne:

| Cesta | Jak | Riziko |
|---|---|---|
| **A — mimo reálný čas** (preferovaná) | Každý krok simulace se vykreslí do obrázku a pošle do ffmpeg. Rychlost stroje nehraje roli, žádný vypadlý snímek. | Ověřit, že shader passy (bloom, CRT, aberace) projdou vykreslením do obrázku stejně jako na obrazovce. |
| **B — záznam okna** | Desktopový build ve svislém okně, nahrává se obrazovka. | Vypadlé snímky; záznam obrazovky musí povolit uživatel. |

Zvuk se nenahrává, **skládá se**: z `events.json` a OGG souborů skinu ho smíchá skládací
skript. Je tak čistý, stejný v každém jazyce a jde pod hlas ztlumit.

Nahrává se desktopový build (macOS) v `--profile`. Dávka přes 10 minut běží přes
`nohup` + `disown` s logem a PID v `run/`.

### 6.4 Nástroje

| Soubor | Dělá |
|---|---|
| `bin/tutorial_capture.sh <id>` | Spustí nahrávací režim pro jednu lekci |
| `bin/tutorial_narrate.py <id> [jazyky]` | Text → hlas po krocích, změří délky, zkontroluje (§7.4) |
| `bin/tutorial_assemble.py <id> [jazyky]` | Složí video: záběry, pružná zastavení, popisky, titulky, zvuky, hudba, hlasitost −14 LUFS |
| `bin/tutorial_manifest.py` | Tabulka pro zveřejnění: soubor, jazyk, název, popis, hashtagy, termín |
| `bin/tutorial_all.sh` | Všechny lekce × všechny jazyky, přeskakuje hotové (podle hashe lekce a textu) |

Texty a lekce v gitu (`assets/lessons/`, `tutorial/narration/`), **výstupy nikdy**: 47 lekcí
× 15 jazyků je 705 videí a několik GB. Žijí v `run/tutorial/out/` a na úložišti mimo repo.

---

## 7. Hlas ve všech 15 jazycích

### 7.1 Text

- Předloha se píše **česky a anglicky** v `tutorial/narration/cs.json` a `en.json`, klíč = `key`
  kroku. Jedna až dvě krátké věty na krok; žádná souvětí — TTS i titulky je zvládnou lépe.
- Ostatních 13 jazyků překladem z angličtiny se slovníkem: **jména sigilů se nepřekládají**,
  termíny (NÁBOJ, vrstva, fáze, graze) mají v každém jazyce jeden pevný překlad shodný s ARB.
- Soubor `tutorial/narration/glossary.json` drží slovník i výslovnost jmen (jak má TTS
  v daném jazyce přečíst „SIDESTEP“).

### 7.2 Hlas

- Jeden hlas na jazyk, stejný charakter ve všech (klidný instruktor, ne hlasatel).
- Syntéza po krocích, ne po celém videu — kvůli pružným krokům a levnému přegenerování jedné věty.
- GPU služba se používá **jen přes frontu brokeru** jako dávka; nikdy přímým spuštěním služby.

### 7.3 Pilot před rozsahem

Nejdřív **jedna lekce (LOOP) ve třech jazycích: cs, en, ja.** Výsledek poslat uživateli na
telefon a počkat na verdikt k hlasu, tempu a vzhledu. Teprve potom:

1. Ověřit, které z 15 jazyků místní TTS umí a v jaké kvalitě (thajština a vietnamština
   bývají nejslabší).
2. Pro jazyky, které neprojdou, je záloha hostované TTS (rozpočet = otázka č. 6), a pokud ani
   to, video **jen s titulky** a hudbou. Titulky má každé video vždy.

### 7.4 Kontrola kvality bez rodilého mluvčího

- Každou vygenerovanou větu přepíše zpět `asr`; liší-li se přepis od textu nad práh, věta se
  vygeneruje znovu (jiný seed), po třech pokusech se označí k ruční kontrole.
- Délka věty mimo rozumný rozsah (znaky × konstanta jazyka) = podezřelá syntéza.
- Titulky se sázejí fontem s pokrytím daného písma (CJK, thajština); test, že žádný znak
  nepadne na „tofu“.
- Je to strojový překlad a strojový hlas. V popisu videa to říct a nechat odkaz na hlášení chyb.

---

## 8. Distribuce: TikTok a YouTube Shorts

**Zveřejnění je vždy rozhodnutí uživatele.** Nástroje připraví soubory a tabulku; účty,
přihlášení a tlačítko „zveřejnit“ patří jemu, dokud výslovně neurčí jinak.

### 8.1 Vlny

| Vlna | Jazyky | Proč |
|---|---|---|
| 1 | en, cs, ja | Angličtina nese dosah, čeština je domácí kontrola kvality, Japonsko je domov žánru |
| 2 | de, es, pt, fr, ko, zh | Podle toho, odkud přijdou diváci ve vlně 1 |
| 3 | it, ru, tr, id, th, vi | Zbytek; vyrenderované jsou už od začátku |

Renderuje se všech 15 hned (je to strojový čas). Po vlnách se jen zveřejňuje.

### 8.2 Kanály

- **YouTube:** jeden kanál, na jazyk jeden playlist, název a popis v jazyce videa. Ověřit,
  jestli Shorts už umí více zvukových stop na jednom videu — pokud ano, je to lepší než 15
  kopií (jedno video sbírá všechna zhlédnutí).
- **TikTok:** více stop neumí. Jeden účet pro vlnu 1 v angličtině; další jazyky až podle čísel,
  každý jako vlastní účet, nebo vůbec.
- **Zdarma navíc:** Steam návody (Guides) v jazycích obchodu s vloženými videi, komunitní
  centrum hry, stránka hry na webu a tlačítko „Video“ v grimoáru.

### 8.3 Rytmus a balení

- Jeden díl denně v pořadí osnovy; seriál se čísluje („Sigil #07 — LOOP“). Divák má vždy
  další díl, hra má 47 dní obsahu na jazyk.
- Název: jméno sigilu + jedna věta užitku. Popis: tvar slovy, odkaz na hru, poznámka o strojovém
  hlasu. Hashtagy z pevné sady na jazyk + žánrové.
- První 2 sekundy rozhodují: háček je trik sám, žádné logo, žádný úvod.
- **Divák je na telefonu, sigily ne.** Každé video musí říct, že jde o PC a Steam Deck s
  ovladačem, a odkaz vede na Steam stránku, ne do App Store / Google Play. Jinak si lidé
  stáhnou mobilní verzi, nenajdou nic z videa a napíšou to do recenzí.
- Náhledový snímek = karta se jménem a glyfem.

### 8.4 Nahrávání

- Výchozí cesta je **ruční nahrání podle manifestu** (`tutorial_manifest.py` dá tabulku
  a složky po dnech).
- Automatizace až potom a jen s přihlášením uživatele: API YouTube má denní kvótu, která
  v základu stačí jen na jednotky nahrání denně; API TikToku pouští veřejné příspěvky až po
  schválení aplikace. Obojí před stavbou ověřit v aktuální dokumentaci — tohle jsou údaje
  z hlavy.

### 8.5 Měření

Po vlně 1 (prvních 10 dílů) zastavit a podívat se: udržení v 3. sekundě, dokoukání, prokliky
na hru. Podle toho upravit šablonu §6.2 a **přegenerovat** — to je důvod, proč je všechno
z dat. Teprve pak pustit zbytek.

---

## 9. Testy

| Soubor | Co hlídá |
|---|---|
| `test/arena_determinism_test.dart` | Stejná lekce + stejná reference dvakrát = shodný otisk stavu snímek po snímku |
| `test/lessons_test.dart` | Každá lekce se načte; reference splní `pass`; všechny klíče mají texty; délky kroků dávají smysl |
| `test/world_time_scale_test.dart` | Mimo arénu vždy 1,0; v aréně škáluje hráče, nepřátele, střely i rozpoznávač stejně |
| `test/sigil_diagnosis_test.dart` | Každý důvod chyby ze záměrně pokažené stopy |
| `test/drill_tempo_test.dart` | Tempo roste a klesá podle pravidel, rekord se ukládá |
| `test/gauntlet_seed_test.dart` | Stejný seed = stejné vlny; denní seed je funkce data |
| `tutorial/tests/` (Python) | Skládací skript: pružné kroky se natáhnou na délku hlasu; strop 59 s; manifest je úplný |
| stávající paritní testy | `worldTimeScale` a aréna se ostré hry nedotknou |

---

## 10. Pořadí dodávky (každý krok aplikace = PR + tag; nástroje = PR bez tagu)

| Krok | Obsah | Čeká na | Hotovo, když |
|---|---|---|---|
| 1 | `GameMode.training`, `worldTimeScale`, deterministický krok a seed, `ArenaScript`, vstupní panel | 28 krok 2 | Aréna jde otevřít z menu a test determinismu je zelený |
| 2 | Formát lekce, duch, pět fází, `SigilDiagnosis`, okamžité přehrání chyby; lekce S0 (první 4) a 7 sigilů HULL | — | Nový hráč se v aréně naučí LOOP bez jediného slova mimo hru |
| 3 | **Pilot videa:** nahrávací režim, `tutorial_capture/narrate/assemble`, LOOP v cs/en/ja | — | Tři videa u uživatele na telefonu. **Tady se stojí a čeká na verdikt.** |
| 4 | Dril, tempo, mistrovství | — | Rekordní tempo se ukládá a je vidět v grimoáru |
| 5 | Zkoušky a kata | 28 krok 6 (FLOW) | Zkouška stupně 2 odemkne stupeň 3; 20 kat s hodnocením |
| 6 | Gauntlet, denní výzva, žebříček | — | Dva běhy stejného dne mají stejné vlny |
| 7 | Výuka ve hře (§5b), tlačítka „Trénovat“ a „Video“ v grimoáru | 28 krok 7 | Tři nápovědy se ukážou právě jednou |
| 8 | Texty ve 13 dalších jazycích, kontrola přes ASR, dávkový render, manifest | verdikt z kroku 3 | Všechna videa hotových lekcí ve všech jazycích, které prošly kontrolou |
| 9 | Vlna 1 ven, měření, úprava šablony | uživatel | Rozhodnutí o vlně 2 |

Lekce a videa pro ARMS, WING a triky přibývají s kroky 4–6 plánu 28; nejsou to další kroky
tady, jen data a jeden běh `tutorial_all.sh`.

---

## 11. Otevřené otázky pro uživatele

1. **Hlas:** syntetický instruktor, nebo tvůj vlastní hlas naklonovaný do všech jazyků (pokud
   to TTS umí)? Druhé je osobnější a je to tvůj hlas a tvůj souhlas.
2. **Kanály:** jeden kanál s playlisty (plán), nebo kanál na jazyk? Které jazyky do vlny 1?
3. **Kdo nahrává:** ručně podle manifestu (plán), nebo později automat s tvým přihlášením?
4. **Jméno seriálu** a jestli má mít tvář (logo, znělku ze `store/steam/video/sting_*`).
5. **Skiny ve videích:** všechno v `default` (čitelné, jednotné), nebo každý díl v jiném
   skinu (reklama na 24 skinů zdarma)?
6. **Rozpočet na hostované TTS** pro jazyky, které místní model nezvládne — nebo tam jen titulky?
7. **Zkoušky jako brána** k dalším sigilům (plán), nebo jen odznaky a sigily odemyká kampaň?
8. **Hudba ve videích:** smí se hudba skinů použít na sociálních sítích? (licence generátoru)
9. ~~Mobil~~ — **uzavřeno 2026-11-10: sigily ani aréna na mobilu nebudou.**

---

## 12. Ad absurdum (parkoviště)

- **Sdílitelný duch:** hráč pošle svou stopu kamarádovi jako výzvu („zahraj mou katu“).
- **Video z vlastního pokusu:** aréna vyrenderuje hráčův nejlepší dril ve stejné šabloně,
  připravené ke sdílení — hráči dělají reklamu sami.
- **Hlas ve hře:** namluvené lekce jako stažitelný balík na jazyk.
- **Komentátor:** živý hlas hodnotí gauntlet („S! Tempo 140!“).
- **Kata týdne od komunity** s hlasováním.
- **Rytmický dril:** tempo drilu svázané s hudbou skinu (`music_director`).
- **Dlouhý formát:** „Celá magie za 10 minut“ na šířku, složený ze stejných kroků.
