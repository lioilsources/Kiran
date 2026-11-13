# Plán 31: jak dál — sloučit rozdělané, zavřít piloty, dojít ke Steam launchi (zadání pro Opus)

Stav 2026-11-12. `main` je 3.9.2, linka 2.x (`release/2.9.x`) je 2.10.6.

Za posledních deset dní vzniklo víc, než se stihlo vyzkoušet a sloučit: šest otevřených PR, tři z nich na sobě, a dvě sady vygenerované grafiky bez výběru. **Tenhle plán nepřidává žádnou novou mechaniku.** Řadí to, co už existuje, a říká, kde se čeká na vlastníka.

Pořadí: úklid → malé PR → lokalizace proti stacku → pilot ovládání a sloučení stacku → grafika po výběru → Steam launch.

## 1. Kde to stojí (ověřeno 2026-11-12)

### Otevřené PR

| PR | Větev | Co | Stav |
|---|---|---|---|
| #49 | `store/steam-screenshots` | 9 screenshotů 1920×1080 pro Steam | čisté, CI zelené |
| #54 | `feat/pods-plan-view` | pipeline: pody kreslené shora | čisté, CI zelené; touhle verzí je vygenerovaných všech 24 skinů |
| #55 | `i18n/all-langs` | 45 jazyků (16 → 45 ARB), store listingy; 551 souborů, sahá i do `lib/ui/*` | čisté proti dnešnímu `main` |
| #59 | `feat/fly-right-to-left` | desktop letí zprava doleva | CI zelené, 272 testů |
| #60 | `feat/sigils` (na #59) | sigily na padu, aréna, tutoriálová videa (plány 28, 29); +16,5 tis. řádků | CI zelené, 455 testů |
| #61 | `feat/boss-duel` (na #60) | souboj s bossem (plán 30); +6,5 tis. řádků | CI zelené, 516 testů; čeká na pilot s padem |

### Rozdělané mimo PR

Worktree níže jsou na druhém stroji; K0 běžel na MacBooku, kde je jen čistý `main`. Jejich stav a lokální větev `feat/mod-icons` (na GitHubu není) se tu ověřit nedají.

- **Hlavní worktree** stojí na lokální větvi `feat/mod-icons`, dva commity za `origin/main`. Necommitnuté: šablona `mod_icon` v pipeline (`assets.go`, `prompts.go`, test, `variantsheet`), složka `store/reddit/` a starší kopie plánu 28 jako nesledovaný soubor (liší se od verze na `feat/sigils`). Změny ve `store/steam/` jsou shodné s `origin/main` a po posunu větve zmizí.
- **Worktree vedle repa:** `Kiran-flip` a `Kiran-sigils` (živé, stack #59–#61), `Kiran-29` (větev `fix/no-empty-bonus-2.10` je mergnutá PR #46, v2.10.6 je venku), `Kiran-rl` (`rl-headless`, stojí na 3.7.0).
- **Grafika vygenerovaná a nevybraná:**
  - trupy, pody a dron pro 24 skinů, 4 varianty (picker `hullpicks`); ve hře jede tint fallback;
  - tvorové místo bossů-lodí pro 22 skinů (picker `bosspicks`); ve hře je tvor jen u `default` a `abadox` (3.9.2).
  Odkazy na pickery a umístění výstupů jsou v paměti projektu, ne v repu.
- **Plán 27 (mody, trupy):** kroky 1 a 2 jsou venku (3.9.0, 3.9.1). Krok 3 (3.10.0, grafika pilot) čeká na výběr. Ovládání HANGAR a VAULT padem a klávesnicí pořád chybí (ověřeno K0 na `origin/main` i `feat/boss-duel`): `lib/ui/loadout_cursor.dart` o hangáru ani vaultu neví a `lib/ui/hangar_panel.dart` nemá žádný focus ani obsluhu kláves.
- **Roadmapa 25, Tier 1:** obtížnost (`Challenge`) a vzory střelby (`fire_pattern.dart`) jsou v kódu. Jukebox není. Rear slot, tiery štítu, oprava trupu a arcade mód nejsou; část z toho nahradily mody.
- **Plány 28–30:** stav je v tabulkách přímo v plánech (na `feat/boss-duel`). Nehotové: odemykání po stupních, varianty a tlačítko X, vibrace, Steam Input, sigily klienta v co-opu, zkoušky stupňů, denní výzva, přeměření `bossUnder`. Nic z toho se neověřilo na skutečném padu ani na Steam Decku.
- **Steam:** CI nahrává build a tag `v3.*` ho rovnou nastaví živě na větvi `default` (PR #57). Datum vydání není nastavené (`store/steam/store-copy.md`). Stav stránky ve Steamworks (schválené Coming Soon, dotazník, cena) v repu není.
- **Kampaň:** režim, mapa, 20 uzlů, skládaní bossové a patnáct druhů úkolů jsou v `lib/systems/campaign.dart`. Z původních šesti kroků (ověřeno K0, `origin/main`): klikatá mapa je hotová (`campaign_map.dart` kreslí hadovitou trasu obloukem); art dílů bossů je hotový (`boss_turret`, `boss_shield`, `boss_thruster`, `boss_cannon` i úlomky jsou ve všech 24 skinech a atlasech). **Chybí achievementy kampaně:** `achievement_service.dart` žádný nemá.

## 2. Rozhodnutí vlastníka, která platí (neptat se znovu)

- Sigily, aréna a duel jsou jen na desktopu. Na mobilu nebudou.
- Desktop letí zprava doleva. Mobil na výšku beze změny.
- Sigil je kruhový. Každé nové kombo musí být v tréninkové aréně (hlídá `arena_test`). Sigil pad vždy ukazuje, co a jak přesně hráč nakreslil.
- Steam je placená hra se všemi 24 skiny, bez IAP. Text obchodu neslibuje budoucí funkce.
- VB6 parita platí pro staty; `Challenge.normal` je 1,0 všude.
- Mody: sdílený vault, trupy za bosse kampaně, P2 v co-opu bez modů (plán 27 §13).
- Právní rámec roadmapy 25 §0: žádný GPL kód, žádná jména, příběh ani levely 1:1.
- Dvě linky: 3.x je `main`; 2.x jde přes PR do `release/2.9.x` a tag. U tagu 2.x se ruší běh Steam Deploy.
- Pilot napřed: jeden skin nebo jedna lekce, ukázka vlastníkovi na telefon, teprve potom rozsah.
- Merge a tag jen na slovo vlastníka. Zveřejňující kliky ve Steamworks dělá vlastník.

## 3. Na co se čeká od vlastníka

Položit najednou, hned po K0. U každé je výchozí volba; kde výchozí stačí, práce nestojí.

| # | Otázka | Výchozí | Co na ní stojí |
|---|---|---|---|
| V1 | Pilot duelu s padem (plán 30 §15 č. 1–3): postoj na RT, nebo LT? Střílí se mířením? Rám padu podle čumáku, nebo vždy nahoře? | RT, střílí, podle čumáku | K3 |
| V2 | Verdikt videa LOOP (cs/en/ja, natočeno znovu v duelu): hlas, tempo, formát. Jde se do rozsahu? | bez verdiktu se nerenderuje nic dalšího | videa (mimo tento plán) |
| V3 | Odemykání sigilů (plán 28 č. 4, plán 29 č. 7): kampaň a zkoušky, nebo vše odemčené? | vše odemčené, dokud se nerozhodne | K3 jen okrajově |
| V4 | Výběr grafiky v pickerech: trupy a pody, tvorové | pilot `default` + `abadox` stačí na start | K4 |
| V5 | Pořadí: lokalizace (#55) před stackem, nebo po něm? | #55 první | K2 |
| V6 | Steam: v jakém stavu je stránka, cena a datum? Mají být sigily a duel v launch buildu? | ano, launch je s duelem | K5 |
| V7 | Šablona `mod_icon` v hlavním worktree: pracuje na ní jiná session? | ne → Opus ji dokončí jako PR | K0, K4 |
| V8 | Smazat worktree `Kiran-29` (větev je mergnutá)? Co s `Kiran-rl`? | nic se nemaže bez slova | úklid |
| V9 | Kampaň: tiery zbraní jedou přes kumulativní skóre a kampaň ho nasbírá málo. Snížit prahy, nebo tier za bosse? | nenavrhovat mechaniku bez souhlasu | mimo tento plán |

## 4. Fáze

### K0: inventura a úklid (bez PR, nic se nemaže)

1. `git status` a poslední commit ve všech pěti worktree. Zapsat do zprávy.
2. Pracovat v novém worktree z `origin/main`. Hlavní worktree je špinavý a patří rozdělané práci.
3. Starší kopii plánu 28 v hlavním worktree porovnat s verzí na `feat/sigils`. Když v ní je něco navíc, ukázat vlastníkovi. Nemazat.
4. Ověřit v kódu řádky z §1, které říkají „zjistí K0“: zbylé kroky kampaně, ovládání hangáru padem. Opravit §1 tohoto plánu.
5. Položit otázky z §3 jednou zprávou.

**Výstup:** krátká zpráva a opravený §1. Dál se pokračuje tím, co na odpovědích nestojí.

### K1: malé PR

- #49 a #54 jsou hotové. Ověřit CI a že #54 odpovídá verzi, kterou se generovalo. Merge na slovo vlastníka.
- V7 = ne: `feat/mod-icons` posunout na `origin/main`, dopsat test, `go test ./...` v `pipeline/`, PR. Generování ikon až v K4.

### K2: lokalizace proti stacku

Problém: #55 má 45 jazyků a mění `lib/ui/*`. Stack přidává nové texty jen do 16 ARB a mění tytéž soubory. Kdo jde druhý, řeší konflikty a doplňuje překlady.

Postup při výchozím V5:

1. #55 do `main` na slovo vlastníka.
2. `main` zamergovat do stacku odspodu: `feat/fly-right-to-left`, pak `feat/sigils`, pak `feat/boss-duel`. **Žádný rebase:** větve jsou pushnuté a force push je zakázaný.
3. Nové klíče stacku doplnit do 29 chybějících ARB stejnou cestou, jakou vznikl #55 (popis PR #55).
4. Zkontrolovat směr textu zprava doleva (ar, he, ur) na nových obrazovkách: aréna, grimoár, HUD duelu, sigil pad.

**Brána:** všech 45 ARB má stejnou sadu klíčů jako `app_en.arb`; `flutter analyze` a `flutter test` zelené na všech třech větvích.

Při opačném V5 se totéž udělá zrcadlově: `main` se stackem se zamerguje do `i18n/all-langs` a klíče se doplní tam.

### K3: pilot ovládání a sloučení stacku

1. Připravit vlastníkovi pilot: macOS build přes `bin/macos_build.sh` (podpis ad hoc, bez Game Center) a krátký záznam na telefon. Lokální `flutter run -d macos` na podpisu padá, s tím se nepočítá.
2. Po V1: vítězné mapování a rám padu nastavit jako jediné. Prohrané přepínače z arény odstranit i s kódem a testy, pokud vlastník neřekne nechat.
3. Po souhlasu (plán 30 č. 7) přeměřit prahy `bossUnder` v kampani.
4. Merge v pořadí #59 → #60 → #61, každý na slovo vlastníka. Po každém merge přesměrovat další PR na `main`.
5. Tag až na slovo vlastníka. **Tag `v3.*` znamená vydání na všech platformách a živý build na Steamu.**

**Pojistky, které musí zůstat:** `duelEnabled` je jediná brána duelu. Schéma `classic` funguje beze změny. Síťový co-op hraje klasického bosse. Mobil se nesmí změnit: po každém merge pustit testy parity a projít diff `lib/` na podmínky `isDesktop`.

### K4: grafika po výběru

Vše pilot napřed, `default` a `abadox`, pak zbytek po dávkách. Jeden skin = jeden commit.

- **Trupy a pody (plán 27 krok 3, 3.10.0):** postprocess, atlasy, `HangarShipPainter` s pody a kotvami, pody ve hře. Ostatní skiny zůstávají na fallbacku, dokud nejsou vybrané.
- **Tvorové (22 skinů):** po výběru `cmd/animate` → `cmd/bossart` → atlas. Každý atlas naroste asi o 2 MB: po každé dávce nahlásit velikost balíku pro mobil. Otevřené: díly bosse (věž, štít, tryska, kanón) sedí na pevných offsetech a na tvorovi můžou vypadat špatně. Ukázat vlastníkovi na pilotu, neřešit naslepo.
- **Ikony modů:** až po K1, pilot na jednom skinu, 55 modů.
- **GPU:** jen přes broker (skill `spark-job`). Na druhém GPU stroji jen v okně od jeho dispečera, nikdy vlastním přepnutím profilu.

### K5: Steam launch

1. **Inventura ve Steamworks** (jen čtení): co je v kontrolním seznamu hotové, co chybí. Sepsat do `store/steam/` jako stav s datem.
2. **Obsah launch buildu** (při výchozím V6):
   - ovládání HANGAR a VAULT padem a klávesnicí (plán 27 §14, §6). Bez toho nejde hra na Steam Decku dohrát jen padem;
   - jukebox, poslední domluvená položka Tier 1;
   - konfigurace Steam Input a průchod celé hry jen padem (plán 28 krok 9);
   - po vydání přepnout v `steam-deploy.yml` tag na testovací větev a `default` povyšovat ručně (komentář v hlavičce workflow).
3. **Ověření na hardwaru dělá vlastník.** Opus připraví kontrolní seznam: zvuk na čistém Windows, start na SteamOS a Decku (libmpv), `manualLoop` a `leanPools` na Linuxu, celý průchod padem.
4. **Stránka:** screenshoty z #49, trailer (`store/steam/trailer-script.md`, `build_trailer.py`) přestříhat s duelem, dotazník (`content-questionnaire.md`), cena a datum od vlastníka. Dva týdny Coming Soon běží od schválení stránky, ne od odeslání.

### K6: parkoviště (ne v tomto plánu)

Zbytek kampaně a V9, Tier 2 roadmapy 25, `DuelSnap` a sigily klienta v co-opu, videa ve všech jazycích (plán 29 kroky 8–9), denní výzva a žebříček, port novinek na linku 2.x. Každé chce vlastní rozhodnutí vlastníka.

## 5. Pravidla práce

- Před fází přečíst tento plán, plán, kterého se fáze týká (27–30), `CLAUDE.md` a `AGENTS.md`. Paměť projektu má pasti Steamworks, releasů a pipeline; neobjevovat je znovu.
- Gate před pushem: v `tyrian_mobile/` `flutter analyze --no-fatal-infos` a `flutter test`; v `pipeline/` `go test ./...`.
- CI drží Flutter 3.41 (Dart 3.11) na desktopu. Lokální Flutter je novější: nepřidávat závislost, která chce Dart 3.12.
- Nový text patří do všech ARB. `vessel.dart` a `save_service.dart` mají konce řádků CRLF. `saveVersion` se nezvedá.
- Žádný force push, žádný rebase pushnuté větve, `git add` jen jmenovitě. Cizí worktree a jejich necommitnutou práci nechat být.
- Veřejné repo: žádné adresy strojů, domovské cesty, ID klíčů ani odkazy na soukromé artefakty.
- Běhy přes 10 minut přes `nohup` + `disown` s logem a PID v gitignorovaném `run/`.
- Po fázi krátké hlášení: co je hotové, čísla, co čeká na vlastníka. Po bráně se nezastavovat.

## 6. Kdy stát a ptát se

- Merge, tag, mazání větve nebo worktree, cokoli zveřejňujícího ve Steamworks a v obchodech.
- Výběr grafiky a verdikt pilotu: bez nich se rozsah nespouští.
- Cokoli, co by změnilo mobilní hru, VB6 staty nebo pravidla z §2.
- Placené služby (hostované TTS, kredity generátorů).

## 7. Zadání do chatu

> Implementuj podle `tyrian_mobile/Prompts/31-PLAN-jak-dal.md`. Začni K0. Rozhodnutí v §2 platí, neptej se na ně znovu. Otázky z §3 polož najednou a mezitím dělej, co na nich nestojí. Hlas po každé fázi.
