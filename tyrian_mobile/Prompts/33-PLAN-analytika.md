# Plán 33: analytika hraní — konverze, délka hraní, ComCenter, nehratelné levely (zadání pro Opus)

Stav 2026-11-14. `main` je 3.9.3, linka 2.x (`release/2.9.x`) je 2.10.6.

Hra dnes nic neměří. Tento plán zavádí anonymní statistiky hraní do obou linek a mění prohlášení o soukromí, která dnes tvrdí, že se nic neposílá. Tohle není právní posudek; místa, kde rozhoduje právo a ne technika, jsou v §8 označená jako rozhodnutí vlastníka.

Pořadí: T0 rozhodnutí a účet → T1 klient → T2 události → T3 prohlášení → T4 backport do 2.x → T5 čtení dat.

## 1. Na co má měření odpovědět

| Otázka vlastníka | Čím se odpoví |
|---|---|
| Kolik nových hráčů se dostane od zapnutí ke hře | trychtýř první relace: `app_open` → `menu_ready` → `skin_tap` → `run_start` → `sector_end` |
| Za jak dlouho to vypnou | poslední `session_pause` relace: sekundy od startu a obrazovka, na které hráč skončil |
| Jak dlouho hrají | součet aktivních sekund relace, počet sektorů na relaci |
| Nováčci proti vracejícím se | pořadí relace a dny od instalace, obojí v pásmech |
| Jak rozumí ComCenteru | souhrn každé návštěvy: čas, nákupy, klepnutí na nedostupné, odchod s nevyužitými kredity |
| Které levely jsou nehratelné | podíl smrtí a odchodů na level a obtížnost, čím a ve které části hráč umřel |

## 2. Kde to stojí (ověřeno 2026-11-14)

### V kódu

- Žádná analytika ani vlastní HTTP volání v `lib/`. Jediný provoz ven: Game Center a Play Games (`games_services`), nákupy (`in_app_purchase`), stažení fontů (`google_fonts`), co-op po lokální síti.
- Háčky ve správných místech už existují: `AchievementService` (`onRunStarted`, `onMissionStarted`, `onSectorCompleted`, `onGameOver`, `onKill`, `onWeaponLevel`). Události měření patří vedle jejich volání, ne do nových míst.
- Životní cyklus aplikace hlídá `didChangeAppLifecycleState` v `lib/main.dart`. Na desktopu je zavření okna přes `window_manager`.
- macOS má oprávnění `com.apple.security.network.client`, Android má `INTERNET`. Nic se přidávat nemusí.
- Hra jde hrát celá offline (tvrdí to i `docs/support.html`). Měření tedy musí umět frontu.
- Aplikace nemá vlastní `PrivacyInfo.xcprivacy` (iOS, macOS).
- Jméno pilota zadává hráč. Do událostí nesmí nikdy.

### Prohlášení, která dnes tvrdí opak

- `docs/privacy.html` (GitHub Pages; stejnou adresu používá App Store, Google Play i Steam): „Usage analytics or telemetry“ je v seznamu toho, co hra nesbírá; „does not integrate any third-party analytics“; „The app itself collects no data at all“.
- `store/steam/content-questionnaire.md`, text o AI zobrazený hráčům: „no data is sent anywhere“. Stejný text je vložený ve Steamworks.
- Google Play, Data safety (`tyrian_mobile/marketing/googleplay-listing.md`): už dnes „sbírá“ kvůli Play Games (skóre, diagnostika, pády). Interakce s aplikací pro analytiku tam nejsou.
- App Store, App Privacy: stav není v repu. Ověřit v App Store Connect.
- Texty obchodů „no accounts, no servers, no internet“ popisují co-op a platí dál. „No ads“ platí dál.

### Co obchody měří samy, bez kódu

- App Store Connect → Analytics: relace, retence a pády od uživatelů, kteří sdílení povolili.
- Google Play Console: instalace, odinstalace, Android vitals.
- Steamworks: prodeje a doba hraní.

Žádný z nich neřekne nic o ComCenteru ani o jednotlivých levelech. Proto vlastní události.

## 3. Musí se změnit prohlášení? Ano

Apple i Google berou jako sběr každý přenos dat ze zařízení, který si vývojář nebo jeho dodavatel uchová. Anonymita na tom nic nemění, mění jen kolonku „nepropojeno s uživatelem“. Změnit se musí:

1. **`docs/privacy.html`**: vyškrtnout analytiku ze seznamu nesbíraného, přidat oddíl o anonymních statistikách (co, proč, bez identifikátorů, kdo je zpracovává a kde, jak dlouho, jak je vypnout), doplnit dodavatele do třetích stran, opravit větu u dětí, nové datum.
2. **App Store Connect → App Privacy**: Usage Data → Product Interaction a Diagnostics → Performance Data (kvůli časům načítání), účel Analytics, nepropojeno s uživatelem, nepoužito ke sledování.
3. **Google Play → Data safety**: App activity → App interactions, účel Analytics, sbíráno, nesdíleno (dodavatel zpracovává jménem vývojáře), volitelné, pokud jde vypnout.
4. **Steam**: přepsat větu v dotazníku o AI tak, aby netvrdila, že se nic neposílá, v repu i ve Steamworks.
5. **`PrivacyInfo.xcprivacy`** pro iOS a macOS s `NSPrivacyCollectedDataTypes` odpovídajícími bodu 2.
6. **Ve hře**: přepínač statistik vedle zvuku a hudby.

Formuláře v obchodech vyplňuje vlastník, nebo Claude v Chrome na jeho výslovné slovo. Opus připraví přesné odpovědi do `tyrian_mobile/marketing/*-listing.md` a `store/steam/`.

## 4. Zásady (platí pro celý plán)

- **Žádný trvalý identifikátor.** Žádné ID instalace, zařízení ani reklamní ID. Relace má náhodné ID, které žije jen v paměti.
- **Kohorty se počítají v zařízení.** Lokálně se drží den instalace a počet relací; ven jdou jen pásma: relace 1, 2, 3–5, 6–10, 11+ a dny od instalace 0, 1, 2–6, 7–29, 30+.
- **Jen výčty, pásma a čísla.** Žádný volný text, žádné jméno pilota, žádný přesný model zařízení. Názvy skinů, zbraní a nepřátel jsou konstanty z katalogu a smí ven.
- **Slovník událostí je jeden** (`docs/telemetry.md` a konstanta v kódu). Test hlídá, že kód neposílá nic, co ve slovníku není.
- **Bez klíče se nic neposílá.** Klíč a adresa jdou přes `--dart-define` z tajemství CI. Lokální buildy, forky a testy jsou tiché.
- **Hra na měření nikdy nečeká.** Odesílání je mimo herní smyčku, s krátkým timeoutem, chyby se tiše zahodí.
- **Offline fronta s limitem** (řádově 500 událostí), nejstarší se zahazují, čas události je čas vzniku.
- **Vypnutí platí hned**: po vypnutí se neodešle nic, ani fronta.
- Dodavatel je za rozhraním (`TelemetrySink`). Výměna služby je jeden soubor.

## 5. Služba

Klient je vlastní, tenký, nad `dart:io HttpClient`. Hotové SDK nepoužívat: oficiální pluginy PostHog a Firebase Analytics nemají Windows ani Linux a nová závislost by mohla chtít novější Dart, než drží CI.

| | PostHog Cloud EU (doporučeno) | Aptabase EU |
|---|---|---|
| Příjem | HTTP capture API, anonymní události přes `$process_person_profile: false` | vlastní SDK nebo HTTP |
| Analýza | trychtýře, rozpady, SQL | počty a rozpady, export CSV; trychtýře po lidech ani SQL neumí |
| Vracející se hráči | nemá je odkud znát (bez trvalého ID), řeší pásma z §4 | stejně, denní hash |
| Cena | podle paměti 1 mil. událostí měsíčně zdarma; **ověřit** | 20 tis. událostí měsíčně zdarma, pak od 10 USD |
| IP adresa | **ověřit** nastavení „discard client IP“ a rozsah GeoIP | podle dodavatele se neukládá, z IP se odvodí země |

Odhad objemu: asi 25 událostí na relaci s pěti sektory. Volný limit Aptabase by stačil na zhruba 800 relací měsíčně.

V T0 ověřit u zvolené služby přímo v jejím nastavení: EU region, zahazování IP, co přidává GeoIP (chceme nanejvýš zemi), dobu uchování, zpracovatelskou smlouvu (DPA).

## 6. Události

Společné vlastnosti každé události: verze aplikace, linka (2 nebo 3), platforma, jazyk, skin, vstup (dotyk, pad, klávesnice), pásmo pořadí relace, pásmo dnů od instalace, první relace ano/ne, režim (endless, kampaň, aréna), obtížnost, testerský build ano/ne.

| Událost | Kdy | Vlastnosti |
|---|---|---|
| `app_open` | studený start | — |
| `menu_ready` | hlavní menu je použitelné | ms od startu |
| `skin_tap` | klepnutí na kartu skinu | vlastněný ano/ne, výsledek: hra nebo nákup, ms načtení skinu |
| `purchase` | konec nákupního toku | skin, výsledek: ok, zrušeno, chyba |
| `comcenter_open` | ComCenter se zobrazil | důvod: první, po sektoru, po smrti, obnovení; pásmo kreditů; index sektoru; počet dostupných nákupů a upgradů |
| `comcenter_close` | odchod z ComCenteru | sekundy; nákupy, upgrady, prodeje, přepnutí; klepnutí na nedostupné; změna skinu; odchod: start, menu, pozadí; zůstal dostupný nákup ano/ne |
| `sector_start` | začátek sektoru | index, level, pásmo DPS, přední zbraň a její level |
| `sector_end` | konec sektoru | index, level, výsledek: dokončeno, smrt, odchod do menu, pozadí; sekundy; část 1–3; čím umřel; počet přepnutí zbraní |
| `session_pause` | aplikace jde do pozadí nebo se zavírá | aktivní sekundy relace; obrazovka: menu, ComCenter, hra, pauza; index sektoru; sektory a smrti v relaci |

Nová relace začíná studeným startem nebo návratem po více než 30 minutách v pozadí. `session_pause` se odesílá hned, protože systém může aplikaci ukončit. Na 3.x nesou kampaň a aréna stejné události, liší se vlastností režimu.

## 7. Fáze

### T0: rozhodnutí a účet (vlastník)

Odpovědi na §8, založení účtu a projektu u zvolené služby, klíč do tajemství GitHubu (`TELEMETRY_KEY`, `TELEMETRY_HOST`). Účet zakládá vlastník. Opus mezitím dělá T1 proti falešnému příjemci.

### T1: klient (`main`)

- `lib/services/telemetry_service.dart`: singleton jako ostatní služby, rozhraní `TelemetrySink`, fronta, dávky, pásma, relace, přepínač v `SharedPreferences`.
- Slovník událostí jako konstanta a `docs/telemetry.md`.
- Testy: pásma; fronta a její limit; bez klíče se nevolá síť; vypnuto znamená nic; slovník pokrývá vše, co kód posílá; žádná vlastnost není volný text.
- Tajemství do všech release workflow (`release-ios`, `release-android`, desktopové, `steam-deploy`) přes `--dart-define`.

### T2: události (`main`)

- Instrumentace podle §6 vedle volání `AchievementService` a v `main.dart` (životní cyklus, ComCenter, výběr skinu).
- Přepínač ve hře vedle zvuku a hudby, texty do všech 45 ARB.
- Ověření na skutečném příjemci z vývojového buildu: jedna celá relace, kontrola, že přišlo přesně to, co je ve slovníku.

### T3: prohlášení

- `docs/privacy.html`, `PrivacyInfo.xcprivacy`, text dotazníku Steam, připravené odpovědi pro App Privacy a Data safety.
- **Brána:** verze s měřením nesmí do obchodu dřív, než je venku nová politika a vyplněné formuláře. Pořadí: politika → formuláře → vydání.

### T4: backport do `release/2.9.x`

- PR s příponou `-2.10`: klient, slovník, události, přepínač, 16 ARB, workflow. Přenést chování a testy, ne diff; 2.x nemá kampaň, arénu ani mody.

### T5: čtení dat

- Uložené pohledy u služby pro šest otázek z §1 a krátký návod v `docs/telemetry.md`, jak je číst.
- První hlášení vlastníkovi po týdnu dat: trychtýř první relace, rozdělení doby do vypnutí, levely s nejvyšším podílem smrtí a odchodů, čísla o ComCenteru.

## 8. Otázky na vlastníka (položit najednou; do odpovědi platí výchozí volba)

1. **Služba**: PostHog Cloud EU, nebo Aptabase EU? Výchozí: PostHog.
2. **Zapnuto od prvního spuštění s možností vypnout, nebo až po souhlasu?** Bez zapnutí od začátku nejde změřit konverze prvního spuštění. V EU je k tomu právní otázka (ePrivacy, GDPR), kterou plán neřeší. Výchozí: zapnuto, přepínač ve hře, popsáno v politice.
3. **Země hráče** (odvozená dodavatelem z IP): chceme ji? Výchozí: ano, jen země.
4. **Časy načítání** (start, skin): měřit? Přidává to do App Privacy kolonku Diagnostics. Výchozí: ano.
5. **Doba uchování dat**: výchozí 12 měsíců.
6. **Pořadí vydání vůči plánu 32**: nejdřív měření a změny z plánu 32 až v další verzi, aby bylo s čím srovnávat? Výchozí: ano, aspoň týden dat před změnami.

## 9. Pravidla práce

Platí pravidla z plánu 31 §5 a §6. Navíc:

- Klíč služby, adresy projektu a odkazy na dashboardy nepatří do veřejného repa.
- Žádná událost mimo slovník. Rozšíření slovníku je změna politiky: nejdřív se zeptat.
- Měření nesmí změnit hru: žádná herní logika se podle něj neřídí.
- Ověřit, že aplikace není v dětské kategorii App Storu ani v programu Families na Google Play. Pokud je, zastavit a zeptat se.

## 10. Kdy stát a ptát se

- Založení účtu, placený tarif, přijetí podmínek služby.
- Vyplnění formulářů v obchodech a ve Steamworks, zveřejnění nové politiky, merge, tag, vydání.
- Cokoli, co by z dat udělalo osobní údaj: trvalé ID, přesný model zařízení, volný text.

## 11. Zadání do chatu

> Implementuj podle `tyrian_mobile/Prompts/33-PLAN-analytika.md`. Otázky z §8 polož najednou a mezitím dělej T1 podle výchozích voleb proti falešnému příjemci. Zásady v §4 platí bez výjimek. Hlas po každé fázi; před T3 se zastav a ukaž mi nové znění politiky a odpovědi do formulářů.
