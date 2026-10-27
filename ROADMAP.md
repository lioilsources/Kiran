# ROADMAP — z Kiriana živá hra s výdělkem

Stav k 14. 9. 2026, verze 3.3.0. Cíl otázky zněl "jak z toho udělat stejně
výdělečnou hru jako Candy Crush". Tenhle dokument odpovídá poctivě: co Candy
Crush skutečně je, co z toho na shmup přenést jde, co ne, a v jakém pořadí.

---

## 0. Realita, ze které se vychází

**Candy Crush Saga** je ~1 mld. USD ročně, 200+ mil. MAU, stovky lidí v
live-ops, 12 let ladění, casual publikum, které nikdy nehrálo shmup a nikdy
nebude. Jeho výdělek nestojí na hře, ale na **stroji kolem hry**: měření →
retence → kadence obsahu → cenový žebřík → nákup uživatelů → opakuj.

**Kirian** je vertikální shmup — žánr s malým, věrným, náročným publikem.
Strop je řádově jinde a žádná roadmapa to nezmění. Co se změnit dá, je
poměr *výdělek na hráče* a *retence*, a to jsou přesně ty dvě věci, které
Candy Crush umí a Kirian dnes neměří vůbec.

Realistické patra, ať je jasné, o čem se bavíme:

| Patro | Co to znamená | Co k tomu musí být |
|---|---|---|
| Hobby | jednotky tisíc Kč/měs. | to, co je dnes + kampaň, která se nikdy nespustila |
| Indie živobytí | desítky–stovky tisíc Kč/měs. | fáze 0–3 níže, Android + Steam, jeden člověk full-time |
| Malé studio | miliony Kč/měs. | fáze 0–5, UA rozpočet, 2–4 lidi, 2+ roky |
| Candy Crush | — | jiný žánr, jiná firma |

Roadmapa míří na patro 2 s otevřenými dveřmi do patra 3.

---

## 1. Co Kirian má a co mu chybí

### Má (ověřeno v kódu)

- **Jádro hry je hotové a dobré**: roguelike smyčka (smrt vrací do sektoru 1,
  ale drží loadout, kredity, skóre), 18 ručně psaných sektorů + procedurální
  nekonečno, 8 zbraní, elementální smrti nepřátel, Voronoi destrukce, shadery.
- **25 skinů** (`lib/services/skin_registry.dart`): 3 zdarma, 22 za jednotnou
  cenu $0.99. Každý s vlastní grafikou pro 7 zón, HUD, SFX a hudbou.
- **Game Center**: 2 leaderboardy (kumulativní skóre, nejhlubší sektor) a
  ~25 achievementů (`achievement_service.dart`). Android ID achievementů jsou
  placeholder `REPLACE_WITH_PLAY_ACHIEVEMENT_ID` — na Play nefungují.
- **Co-op** 2 hráčů lokálně (Bonjour + Multipeer), bez serveru.
- **Asset pipeline**, která umí vyrobit kompletní skin za den. To je největší
  konkurenční výhoda projektu a celý live-ops model níže na ní stojí.
- **Připravené texty kampaně** (`tyrian_mobile/marketing/community-posts.md`),
  zastaralé o 11 skinů a jednu major verzi.

### Nemá (ověřeno v kódu — nula výskytů)

| Chybí | Proč to bolí |
|---|---|
| **Analytika, crash reporting, remote config** | Nevíš D1/D7/D30 retenci, kde hráči odpadají, kolik lidí vůbec otevře obchod. Bez toho je každý bod níže střelba naslepo. |
| **Onboarding / FTUE** | První minuta rozhoduje o D1. Dnes hráč dostane loď a nepřátele. Žádné "proč", žádný cíl, žádné vysvětlení generátoru/slotů. |
| **Push notifikace** | Žádný důvod se vrátit, když hra není otevřená. |
| **Denní obsah, streak, cíle** | Hra nemá odpověď na otázku "proč zapnout dnes, a ne příští týden". |
| **Cenový žebřík** | Jedna cena, jeden typ produktu. Hráč, který by dal 300 Kč, nemá kde. Hráč, který by dal 20 Kč, taky ne. |
| **Sezóny / eventy** | Skiny jsou obsah, ale vydávají se jako "hotovo", ne jako "teď a jen teď". |
| **Sdílení** | Elementální smrti jsou nejvíc "ukaž kamarádovi" moment ve hře a nejde je nikam poslat. |
| **Lokalizace** | Jen angličtina. Shmup je nejsilnější v Japonsku; Candy Crush je v 20+ jazycích. |
| **Příběh / journey** | Nic. Ani cíl na obzoru, ani "kdo jsi a proč střílíš". |
| **Identita značky** | 25 skinů = 25 tváří. Na ikoně, v obchodě, v reklamě a na tričku není *jedna* loď, kterou si lidi zapamatují. |
| **Android release, Steam** | Android je pořád v closed testingu. Půlka trhu je vypnutá. |
| **Spuštěná kampaň** | Texty existují od 3. 9., nikam se neposlaly. |

### Co je odpověď na "chybí art? journey? příběh? PR?"

- **Art nechybí.** 25 skinů je víc, než hra unese. Chybí *jedna* výchozí
  identita (viz 4.4) a chybí *kadence* — skiny vydávané jako události, ne
  jako změny v changelogu.
- **Journey chybí, příběh skoro ne.** Candy Crush nemá příběh, má *mapu*:
  vždy vidíš, kde jsi, kolik zbývá a co je za rohem. Kirian má 18 sektorů v
  6 zónách a hráč to nikde nevidí. Příběh stačí lehký — Tyrian to řešil
  datakostkami mezi levely, Kirian má ComCenter, kde se to dá odvyprávět
  stejně (viz 4.5).
- **PR chybí celé.** A je to ta nejlevnější položka v tomhle dokumentu.

---

## 2. Rozhodnutí, které musí padnout první

Marketingové texty slibují: **žádné reklamy, žádná energie, žádné
konzumovatelné položky, žádné předplatné.** Candy Crush stojí přesně na
těch čtyřech věcech (životy = energie, boostery = konzumky, reklamy za
životy, gold pass = předplatné).

Nejde mít obojí. Doporučení — **držet slib pro jádro hry, monetizovat okolo
něj**:

| | Držet | Přidat | Nikdy |
|---|---|---|---|
| Sektory, zbraně, módy | zdarma, bez omezení | — | paywall, energie, časovače |
| Kosmetika | $0.99 skiny | balíčky, sezónní/limitované skiny, prémiový tier | pay-to-win |
| Předplatné | — | **Season Pass** (jednorázový, ~$4.99/sezóna) jako "všechny skiny sezóny + sezónní leaderboard" | auto-renew subscription |
| Reklamy | — | **jen rewarded, jen na vyžádání hráče** (2× kredity za sektor, jeden pokus navíc); vypnutelné jakýmkoli nákupem | interstitial, banner, vynucené |
| Konzumky | — | — | boostery, extra životy za peníze |

Tohle je jediný model, který nedělá z "no ads, no energy" lež zpětně a
zároveň otevře žebřík. Rewarded reklamy jsou volitelné a lze je vynechat
úplně, pokud je positioning důležitější než ~15–25 % příjmu.

---

## 3. Fáze — pořadí není náhodné

Každá fáze má metriku, která ji ukončí. Nezačínej další, dokud ta předchozí
nemá číslo.

### Fáze 0 — Měřit (2–3 týdny) — *bez tohohle nic dalšího nemá smysl*

- [ ] Analytika + crash reporting (Firebase Analytics + Crashlytics je
      nejrychlejší cesta; Aptabase/PostHog, pokud vadí Google)
- [ ] Události trychtýře: `app_open`, `first_sector_start`, `first_death`,
      `first_shop_open`, `first_purchase`, `sector_complete{n}`,
      `skin_switch`, `coop_host/join`, `session_end{seconds, sector}`
- [ ] Remote config: ceny, texty, zapnutí/vypnutí featur bez release
- [ ] In-app review prompt po 3. dokončeném sektoru (0 hodnocení na App
      Store je dnes horší než špatná hodnocení)
- [ ] Android: dokončit closed testing → production. Doplnit Play achievement
      ID.

**Ukončeno, když:** máš D1/D7/D30, průměrnou délku session a konverzi
install → obchod → nákup. Cokoli dál se měří proti tomuhle.

### Fáze 1 — Spustit to, co je (1 týden, paralelně s fází 0)

- [ ] Přepsat `community-posts.md` na 3.3.0 / 25 skinů / co-op nearby
- [ ] Vyřešit provenance (viz sekci "Provenance" v tom dokumentu) — jedna
      věta, domluvená, napsaná předem
- [ ] r/shmups → r/iosgaming → Show HN → r/gamedev, podle rozvrhu v dokumentu
- [ ] Trailer 30 s: elementální smrti, přepínání skinů, co-op. Bez trailer
      videa je každý post z poloviční síly. Pipeline umí vyrobit assety —
      neumí to nahrát; tohle je ruční práce s OBS.

**Ukončeno, když:** je první tisícovka instalací a první data ve fázi 0
nejsou jen od tebe.

### Fáze 2 — Udržet (4–6 týdnů)

Candy Crush D1 ≈ 40 %, D7 ≈ 20 %, D30 ≈ 10 %. Shmup na polovině je dobrý.

- [ ] **FTUE**: první sektor jako vedený — jedna zbraň, "drž prst, uhýbej",
      první kill s elementální smrtí do 20 s, první nákup v ComCenter do
      3 min s předem daným kreditem. Skip pro veterány.
- [ ] **Cíl vždy na obrazovce**: "další zbraňový tier za 12 400 bodů",
      "sektor 7/18", "boss za 2 sektory". Data existují
      (`SaveService`, `achievement_service`), jen se nezobrazují mimo STATS.
- [ ] **Denní mise** (3/den, remote config): "zabij 50 nepřátel ohněm",
      "dokonči sektor bez zásahu", "hraj v skinu X". Odměna: kredity +
      denní streak.
- [ ] **Streak**: 7 dní = kosmetická odměna (barva thrusteru, odznak
      pilota). Nic, co ovlivní hru.
- [ ] **Push**: "denní mise resetnuty", "tvoje skóre na leaderboardu
      překonal X", "sezóna končí za 3 dny". Max 1/den, opt-in.
- [ ] **Týdenní výzva**: jeden seedovaný sektor z `sector_parts.dart`,
      stejný pro všechny, vlastní leaderboard, reset v pondělí. Levné —
      obsah už existuje, mění se jen seed a pravidla (např. "jen laser").

**Ukončeno, když:** D7 ≥ 12 % a průměrně ≥ 3 sessions/týden u vracejících.

### Fáze 3 — Žebřík (2–3 týdny, po fázi 2 — bez retence není co monetizovat)

Dnes: jeden produkt, jedna cena. Cíl: 5 cenových bodů, každý s důvodem.

| Produkt | Cena | Co to je |
|---|---|---|
| Skin | $0.99 | beze změny |
| **Era pack** | $2.99 | 4–5 skinů jedné dekády (8-bit, 16-bit, arcade, moderní). Sleva ~35 % motivuje k balíčku. |
| **Season Pass** | $4.99 | všechny skiny sezóny (3–4) + sezónní leaderboard + odznak. Jednorázově, nepředplácí se. |
| **Supporter pack** | $9.99 | všechno dosud + jméno v creditsech + "supporter" odznak u pilota. Pro lidi, kteří chtějí dát víc; existují a dnes nemají kam. |
| **Everything** | $19.99 | všechny skiny navždy vč. budoucích. Kotva — dělá $9.99 rozumným. |

- [ ] **Zkušební přepnutí skinu**: 1 sektor v zamčeném skinu zdarma, pak
      zámek. Nejsilnější konverzní nástroj pro kosmetiku vůbec; skiny se
      dnes prodávají z náhledového obrázku.
- [ ] **Starter pack** ($1.99, jen prvních 48 h po instalaci, remote config):
      2 skiny + kredity na první zbraň. Klasika, funguje.
- [ ] **Rewarded video** (rozhodnutí ze sekce 2): 2× kredity za sektor,
      jednou za sektor, jen tlačítko, nikdy pop-up. Vypnuto navždy po prvním
      nákupu čehokoli.

**Ukončeno, když:** ARPDAU je změřeno a konverze install → plátce ≥ 2 %.

### Fáze 4 — Live-ops kadence (průběžně od fáze 3)

Tady se pipeline z `pipeline/` stává obchodním modelem. Skin za den výroby
znamená, že obsah je nejlevnější věc, kterou hra má — a přesto se dnes
vydává bez data, bez konce, bez důvodu koupit *teď*.

- **Sezóna = kvartál.** Téma (např. "Rok 1992", "Voxel léto", "Horor"),
  3–4 skiny, z toho **1 limitovaný** — po sezóně ho nelze koupit, jen
  vlastnit. Sezónní leaderboard s odznakem pro top 1 %/10 %.
- **Event = víkend.** Boss rush (jen bossové, 5 min), Elemental week (jeden
  element dělá 2× dmg), Mirror (sektory zrcadlově), Co-op double credits.
  Každý event je remote-config přepínač nad existujícími systémy — ne nový
  kód pokaždé.
- **Kalendář na rok dopředu**, zveřejněný hráčům v ComCenter. Candy Crush
  hráč vždy ví, co bude příští týden. Kirian hráč neví, jestli bude příští
  verze.
- **Community skin**: jednou za sezónu hlasování o tématu dalšího skinu.
  Nejlevnější marketing, jaký existuje.

### Fáze 5 — Journey a příběh (4–6 týdnů, kdykoli po fázi 2)

- [ ] **Mapa sektorů**: 18 sektorů × 6 zón jako svislá trasa s medailemi
      (bronz/stříbro/zlato = skóre, bez zásahu, čas). Vidíš, kde jsi, co
      máš a co chybí. Procedurální sektory za mapou jako "hluboký vesmír".
      *Tohle je* Candy Crush "journey" — ne příběh, ale viditelný postup.
- [ ] **Příběh přes ComCenter**: 1–3 řádky zprávy před každou zónou, od
      velitele/dispečera. Kdo jsi (pilot s vygenerovaným jménem —
      `pilot_name_generator.dart` už existuje), proč hluboko, co je za
      poslední zónou. Šest zón = šest zpráv. Nic víc není třeba; Tyrian byl
      celý příběh v datakostkách a stačilo to.
- [ ] **Pilot jako identita**: jméno, odznaky (streak, sezóny, supporter),
      oblíbený skin, statistiky. Viditelné v co-op a na leaderboardu. Věc,
      do které hráč investuje čas, se hůř opouští.

### Fáze 6 — Značka, sociálno, merch (až je publikum, ne dřív)

- [ ] **Jedna tvář hry.** Vybrat *jeden* skin jako kanonický (kandidát:
      default "Kiran 2026" — je to jediný, který se nejmenuje po dekádě
      někoho jiného). Ikona, screenshoty, trailer, sociální sítě, merch —
      vždy ta loď. Ostatní skiny jsou "převleky", ne identita.
- [ ] **Sdílení**: tlačítko "sdílet" po smrti / po sektoru → 3s GIF
      elementální smrti nebo karta se skóre a skinem. Vodoznak s názvem hry.
      Rendering pipeline už frame-by-frame zvládá; jde o export.
- [ ] **Online leaderboard týdenní výzvy** viditelný bez Game Center —
      i na Androidu, i na Steamu, i na webu (jedna statická stránka v
      `docs/`).
- [ ] **Steam** (Win + Deck): jiné publikum, plná cena ($9.99, všechny
      skiny), žádné IAP. Shmup komunita žije na Steamu víc než na mobilu.
- [ ] **Merch**: až při ≥ 10 000 MAU. Print-on-demand (tričko, plakát
      kanonické lodi, pixelová verze), nula skladu. Merch je *výstup*
      značky, ne vstup — dřív je to náklad bez publika.
- [ ] **Lokalizace**: japonština první (shmup domov), pak DE/FR/ES/PT-BR,
      čeština. Texty ve hře jsou krátké; lokalizace je levná a App Store
      viditelnost v JP je skokové zlepšení.

---

## 4. Čeho se nedotýkat

- **Energie, životy, časovače.** Zabije to positioning i žánr. Shmup hráč
  hraje "ještě jednou" 40× za večer; každá zábrana v tom je ztracený hráč.
- **Pay-to-win.** Zbraně se kupují kredity z hraní. Vždy.
- **Vynucené reklamy.** Viz sekce 2.
- **Gacha / loot boxy.** Regulace v EU/JP, App Store požadavky na
  pravděpodobnosti, a hlavně: hráč, co dá $0.99 za konkrétní skin, je
  spokojenější než hráč, co dá $0.99 za náhodný.
- **Dalších 25 skinů, než je hotová fáze 0–2.** Obsah bez retence a měření
  je nejdražší způsob, jak nezjistit nic.

---

## 5. Pořadí prací na příští kvartál

| Týden | Co | Fáze |
|---|---|---|
| 1 | Analytika + crash reporting + remote config; Android do produkce | 0 |
| 1–2 | Přepsat kampaň, provenance věta, trailer, r/shmups | 1 |
| 2–3 | r/iosgaming, Show HN, r/gamedev; in-app review prompt | 1, 0 |
| 3–5 | FTUE + cíl na obrazovce + denní mise + streak | 2 |
| 5–6 | Push + týdenní výzva | 2 |
| 7–8 | Cenový žebřík (packy, season pass, everything) + zkušební skin | 3 |
| 9–10 | První sezóna: téma, 3 skiny + 1 limitovaný, kalendář | 4 |
| 11–12 | Mapa sektorů + ComCenter zprávy | 5 |

Vše výše je jeden člověk na plný úvazek. Na poloviční úvazek je to dva
kvartály; pořadí zůstává.

---

## 6. Čísla, na která se ptát každé pondělí

| Metrika | Dnes | Cíl Q4 2026 | Candy Crush (pro měřítko) |
|---|---|---|---|
| D1 retence | neměřeno | 30 % | ~40 % |
| D7 retence | neměřeno | 12 % | ~20 % |
| D30 retence | neměřeno | 5 % | ~10 % |
| Sessions / DAU | neměřeno | 3 | ~5 |
| Konverze na plátce | neměřeno | 2 % | ~3–5 % |
| ARPPU / měsíc | ~$0.99 | $4 | ~$20+ |
| App Store hodnocení | 0 | 50+, ≥ 4.5 | — |

Až tyhle řádky mají čísla, je tenhle dokument zastaralý — a to je dobře.
