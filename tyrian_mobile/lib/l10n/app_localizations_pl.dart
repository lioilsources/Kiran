// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANULUJ';

  @override
  String get connect => 'POŁĄCZ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Nie udało się połączyć z $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Host był widoczny, ale połączenie nie zostało nawiązane.\n\nGra w pobliżu wymaga Wi-Fi peer-to-peer, które iOS wyłącza, gdy działa Hotspot osobisty — wyłącz hotspot na obu urządzeniach i spróbuj ponownie albo połącz oba urządzenia z tą samą siecią Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Misja nieudana — wyposażenie i kredyty zachowane. Spróbuj ponownie z Centrum Dowodzenia.';

  @override
  String get gameOverEndless =>
      'Odbudowa w Sektorze 1 — wyposażenie i kredyty zachowane';

  @override
  String get waitingForHost => 'Czekanie na hosta...';

  @override
  String get waitingForHostHint => 'Gra zacznie się, gdy host będzie gotowy';

  @override
  String get vesselLost => 'STATEK STRACONY';

  @override
  String scoreValue(String score) {
    return 'Wynik: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredyty: $credits';
  }

  @override
  String get creditsPrefix => 'Kredyty: ';

  @override
  String get leaderboard => 'RANKING';

  @override
  String get achievements => 'OSIĄGNIĘCIA';

  @override
  String get redeploy => 'DO BOJU';

  @override
  String get resume => 'WZNÓW';

  @override
  String get pause => 'PAUZA';

  @override
  String get paused => 'WSTRZYMANO';

  @override
  String get skins => 'SKÓRKI';

  @override
  String get skin => 'SKÓRKA';

  @override
  String get soundOn => 'DŹWIĘK: WŁ.';

  @override
  String get soundOff => 'DŹWIĘK: WYŁ.';

  @override
  String get musicOn => 'MUZYKA: WŁ.';

  @override
  String get musicOff => 'MUZYKA: WYŁ.';

  @override
  String get statsOn => 'STATYSTYKI: WŁ.';

  @override
  String get statsOff => 'STATYSTYKI: WYŁ.';

  @override
  String get mainMenu => 'MENU GŁÓWNE';

  @override
  String get quitToDesktop => 'WYJDŹ DO PULPITU';

  @override
  String get selectSkin => 'WYBIERZ SKÓRKĘ';

  @override
  String get difficulty => 'POZIOM TRUDNOŚCI';

  @override
  String get difficultyEasy => 'ŁATWY';

  @override
  String get difficultyNormal => 'NORMALNY';

  @override
  String get difficultyHard => 'TRUDNY';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANIA';

  @override
  String get quit => 'WYJDŹ';

  @override
  String get restorePurchases => 'PRZYWRÓĆ ZAKUPY';

  @override
  String get locked => 'ZABLOKOWANE';

  @override
  String get mainMenuTooltip => 'Menu główne';

  @override
  String nodeLevel(int level) {
    return 'POZIOM $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'POZIOM $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Zablokowane. Najpierw ukończ poprzedni węzeł.';

  @override
  String get flyAgain => 'LEĆ PONOWNIE';

  @override
  String get launch => 'START';

  @override
  String zoneLabel(int zone) {
    return 'STREFA $zone';
  }

  @override
  String get objectiveStar => 'GWIAZDKA';

  @override
  String get continueButton => 'DALEJ';

  @override
  String get replayNode => 'POWTÓRZ WĘZEŁ';

  @override
  String get retry => 'PONÓW';

  @override
  String get nodeCleared => 'WĘZEŁ ZALICZONY';

  @override
  String get nodeFailed => 'WĘZEŁ NIEZALICZONY';

  @override
  String get weaponTierUnlocked => 'ODBLOKOWANO POZIOM BRONI';

  @override
  String get onSaleInComCenter => 'W sprzedaży w Centrum Dowodzenia.';

  @override
  String get requiredTasksHint =>
      'O węźle decydują zadania obowiązkowe. Leć jeszcze raz — to, co zdobyłeś, zostaje z tobą.';

  @override
  String get objClear => 'Oczyść sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zestrzel $count wroga',
      many: 'Zestrzel $count wrogów',
      few: 'Zestrzel $count wrogów',
      one: 'Zestrzel 1 wroga',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Nie odnieś uszkodzeń kadłuba';

  @override
  String objHull(int percent) {
    return 'Zakończ z kadłubem powyżej $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zniszcz $count wroga bronią $weapon',
      many: 'Zniszcz $count wrogów bronią $weapon',
      few: 'Zniszcz $count wrogów bronią $weapon',
      one: 'Zniszcz 1 wroga bronią $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zniszcz $count wroga działkami bocznymi',
      many: 'Zniszcz $count wrogów działkami bocznymi',
      few: 'Zniszcz $count wrogów działkami bocznymi',
      one: 'Zniszcz 1 wroga działkami bocznymi',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Wystartuj z bronią $weapon z przodu';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Wystartuj z bronią $weapon na boku';
  }

  @override
  String get objBuySideGun => 'Kup działko boczne w Centrum Dowodzenia';

  @override
  String objUpgradeGenerator(int level) {
    return 'Ulepsz generator do poziomu $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Ulepsz przednie działo do poziomu $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Ulepsz działko boczne do poziomu $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Złap $count bonusu',
      many: 'Złap $count bonusów',
      few: 'Złap $count bonusy',
      one: 'Złap 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zniszcz $count całej formacji',
      many: 'Zniszcz $count całych formacji',
      few: 'Zniszcz $count całe formacje',
      one: 'Zniszcz 1 całą formację',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Nie taranuj żadnej asteroidy';

  @override
  String objUnderTime(int seconds) {
    return 'Ukończ w $seconds s';
  }

  @override
  String get objStripBoss => 'Zniszcz wszystkie części bossa przed rdzeniem';

  @override
  String get joinCoopTitle => 'Dołącz do co-opa';

  @override
  String get cannotSearchNetwork => 'Nie można przeszukać tej sieci';

  @override
  String get joinHintNearby =>
      'Ta sama sieć Wi-Fi działa na każdym urządzeniu. iPhone, iPad i Mac znajdą się też w pobliżu bez niej — z wyłączonym Hotspotem osobistym na obu.';

  @override
  String get joinHintWifi =>
      'Obaj gracze muszą być w tej samej sieci Wi-Fi — Hotspot osobisty też działa.';

  @override
  String noHostsYet(String hint) {
    return 'Na razie brak hostów. $hint';
  }

  @override
  String get lookingForHosts =>
      'Szukanie hostów w tej sieci Wi-Fi i w pobliżu…';

  @override
  String get hostNearby => 'W pobliżu · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · ta sama sieć Wi-Fi';
  }

  @override
  String get enterIpManually => 'Wpisz IP ręcznie';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'TAR';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — OSŁONIĘTY';
  }

  @override
  String get bossPartTurret => 'Wieżyczka';

  @override
  String get bossPartShieldPod => 'Moduł osłony';

  @override
  String get bossPartThruster => 'Silnik';

  @override
  String get bossPartCannon => 'Działo';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Nieznany kosmos';
  }

  @override
  String get player2Joined => 'Gracz 2 dołączył!';

  @override
  String get player2Disconnected => 'Gracz 2 rozłączony';

  @override
  String get hostDisconnected => 'Host rozłączony';

  @override
  String maxLevelSold(String amount) {
    return 'Maks. poziom! Sprzedano za \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Odblokowano poziom broni $tier';
  }

  @override
  String get cheatsEnabled => 'Kody włączone';

  @override
  String get cheatsDisabled => 'Kody wyłączone';

  @override
  String get cheatsMaxed =>
      'KOD: kredyty na maksa, wszystkie bronie odblokowane';

  @override
  String get cheats => 'KODY';

  @override
  String get maxCredits => 'MAKS. KREDYTY';

  @override
  String get sectionStats => 'STATYSTYKI';

  @override
  String get sectionLoadout => 'WYPOSAŻENIE';

  @override
  String levelShort(int level) {
    return 'Poz.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ULEP';

  @override
  String get sell => 'SPRZEDAJ';

  @override
  String get buy => 'KUP';

  @override
  String get commandCenter => 'CENTRUM DOWODZENIA';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'WYNIK';

  @override
  String get nextWeapon => 'NASTĘPNA BROŃ';

  @override
  String pointsValue(String points) {
    return '$points pkt';
  }

  @override
  String get slotFront => 'Przód';

  @override
  String get slotLeft => 'Lewo';

  @override
  String get slotRight => 'Prawo';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'ROZPOCZNIJ MISJĘ';

  @override
  String get startMission => 'ZACZNIJ MISJĘ';

  @override
  String get continueMission => 'KONTYNUUJ MISJĘ';

  @override
  String get padControlsHint =>
      '[↑↓] Rząd   [←→] Wybór   [B] Kup/Ulepsz/Zmień   [X/Y] Sprzedaj   [OPTIONS] Kontynuuj misję';

  @override
  String get host => 'HOSTUJ';

  @override
  String hostingAs(String name) {
    return 'HOSTUJESZ jako $name';
  }

  @override
  String get join => 'DOŁĄCZ';

  @override
  String get familyBubble => 'BUBBLE';

  @override
  String get familyVulcan => 'VULCAN';

  @override
  String get familyBlaster => 'BLASTER';

  @override
  String get familyStar => 'STAR';

  @override
  String get familyLaser => 'LASER';

  @override
  String get overload => 'PRZECIĄŻENIE';

  @override
  String weaponOff(String weapon) {
    return '$weapon WYŁ. — za słaby generator';
  }

  @override
  String unlocksAt(String points) {
    return 'Odblokowanie przy $points pkt';
  }

  @override
  String joinConnecting(String target) {
    return 'Łączenie z $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Host nie odpowiedział: $reason.\n\nObaj gracze muszą być w tej samej sieci Wi-Fi (Hotspot osobisty też działa), a host musi nacisnąć HOSTUJ. Sprawdź adres i spróbuj ponownie.';
  }

  @override
  String get lanJoinNoAnswer => 'brak odpowiedzi';

  @override
  String objBossUnder(int seconds) {
    return 'Zniszcz rdzeń bossa w ciągu $seconds s od jego pojawienia się';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'SKARBIEC';

  @override
  String get rackSide => 'Bok';

  @override
  String get rackHull => 'Kadłub';

  @override
  String get rarityCommon => 'ZWYKŁY';

  @override
  String get rarityRare => 'RZADKI';

  @override
  String get rarityMythic => 'MITYCZNY';

  @override
  String get curse => 'KLĄTWA';

  @override
  String get modFit => 'ZAMONTUJ';

  @override
  String get modUnfit => 'ZDEMONTUJ';

  @override
  String get modForge => 'KUŹNIA';

  @override
  String get forgeHint => 'Wybierz 3 o jednej rzadkości, by wykuć 1 wyższej';

  @override
  String get vaultEmpty =>
      'Brak modów. Ukończ węzeł na wszystkie gwiazdki, szybko pokonaj bossa albo zestrzel bossa w trybie bez końca.';

  @override
  String modNeeds(String families) {
    return 'Działa z: $families';
  }

  @override
  String get modRackFull => 'Stelaż pełny';

  @override
  String get modAlreadyFitted => 'Już zamontowany';

  @override
  String get modWrongRack => 'Nie pasuje do tego stelaża';

  @override
  String modsSpilled(int n) {
    return 'Modów z powrotem w skarbcu: $n';
  }

  @override
  String get hullLocked => 'Zablokowany';

  @override
  String hullUnlockBoss(int n) {
    return 'Pokonaj bossa kampanii $n';
  }

  @override
  String get hullUnlockFinish => 'Ukończ kampanię lub dotrzyj do sektora 30';

  @override
  String get statAgility => 'ZWR';

  @override
  String get statHitbox => 'TRF';

  @override
  String get perkNone => 'Statek seryjny';

  @override
  String get perkAfterimage => 'Stój w miejscu: strzały ×1,5';

  @override
  String get perkBulwark => 'Obrażenia za osłoną są o połowę mniejsze';

  @override
  String get perkOverclock => 'Strzela z broni do 130 % mocy, wolniej';

  @override
  String get perkBattery => 'Leci z tobą darmowy dron bojowy';

  @override
  String get rewardTitle => 'NAGRODA';

  @override
  String newHull(String name) {
    return 'Nowy kadłub: $name';
  }

  @override
  String get socketEmpty => 'puste';

  @override
  String fxStreams(int n) {
    return 'Równoległe strumienie: $n';
  }

  @override
  String fxFan(int n) {
    return 'Wachlarz strzałów: $n';
  }

  @override
  String fxSalvo(int n) {
    return 'Salwa z $n strzałów';
  }

  @override
  String fxFireRate(String x) {
    return 'Szybkostrzelność ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Obrażenia ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Prędkość pocisków ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Rozmiar pocisków ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Zużycie energii ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Naprowadzanie +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Przebija cele: $n';
  }

  @override
  String get fxPierceAll => 'Przebija wszystko';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % szans na obrażenia ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Krytyki ×$x na bossach';
  }

  @override
  String fxFork(int n) {
    return 'Zestrzelenia rozsiewają strzały: $n';
  }

  @override
  String get fxChain => 'Rozsiane strzały rozsiewają się dalej';

  @override
  String get fxSplit => 'Po trafieniu dzieli się na dwa';

  @override
  String get fxFrost => 'Trafienia spowalniają wrogów';

  @override
  String get fxCrossfire => 'Działka boczne celują do środka';

  @override
  String get fxRearguard => 'Działka boczne strzelają też do tyłu';

  @override
  String get fxOrbit => 'Pociski wiją się';

  @override
  String fxBounce(int n) {
    return 'Odbija się od ścian $n×';
  }

  @override
  String get fxBounceTop => '…i od góry';

  @override
  String get fxOverdrive => 'Strzela na kredyt energii';

  @override
  String get fxReactor => 'Przeciążone bronie nadal strzelają, powoli';

  @override
  String fxGenPower(String x) {
    return 'Ładowanie generatora ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Pojemność generatora ×$x';
  }

  @override
  String get fxSurge => 'Pełny generator: strzały ×2';

  @override
  String fxSiphon(int pct) {
    return 'Zestrzelenia odnawiają $pct % energii';
  }

  @override
  String fxHp(String x) {
    return 'Kadłub ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Osłona ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regeneracja osłony ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Zestrzelenia leczą $n HP';
  }

  @override
  String get fxMagnet => 'Przyciąga bonusy';

  @override
  String get fxMagnetAll => 'Przyciąga każdy bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % strzałów odbija się od osłony';
  }

  @override
  String get fxReflectGuided => 'Odbite strzały same się naprowadzają';

  @override
  String fxGhost(String sec) {
    return 'Nietykalny przez $sec s po trafieniu w kadłub';
  }

  @override
  String get fxNova => 'Pęknięcie osłony: wybuch na cały ekran';

  @override
  String fxAgility(String x) {
    return 'Zwrotność ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Strefa trafienia ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kredyty ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Wynik ×$x';
  }

  @override
  String get fxSatellite => 'Leci z tobą dron bojowy';

  @override
  String get fxTimewarp => 'Trafienie w kadłub spowalnia czas';

  @override
  String get fxGambler => 'Każdy strzał to losowa broń';

  @override
  String get vaultAll => 'WSZYSTKO';

  @override
  String get sigilMissUnknown => 'nieznany kształt';

  @override
  String get sigilMissTooSlow => 'za wolno';

  @override
  String get sigilMissSkippedDot => 'pominięty punkt';

  @override
  String get sigilMissLeftRimEarly => 'puszczone za wcześnie';

  @override
  String get sigilMissWrongDirection => 'narysowane wstecz';

  @override
  String get sigilMissWrongLayer => 'zły przycisk ramienia';

  @override
  String get sigilDry => 'za mało ładunku';

  @override
  String get sigilBusy => 'poprzedni wciąż działa';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'CZĘŚCI BOSSA';

  @override
  String get arenaBareCore => 'goły rdzeń';

  @override
  String get arenaCompanions => 'TOWARZYSZE';

  @override
  String get arenaCharge => 'ŁADUNEK';

  @override
  String get arenaChargeNormal => 'NORMALNY';

  @override
  String get arenaSpeed => 'PRĘDKOŚĆ ŚWIATA';

  @override
  String get arenaDrill => 'TRENING';

  @override
  String get arenaFreePlay => 'WOLNA GRA';

  @override
  String get arenaFight => 'WALKA';

  @override
  String get arenaNewBoss => 'NOWY BOSS';

  @override
  String get arenaLeave => 'OPUŚĆ ARENĘ';

  @override
  String get arenaHint =>
      'Boss wraca w chwili śmierci. Nic tu nie jest zapisywane.';

  @override
  String get arenaColCast => 'UŻYCIA';

  @override
  String get arenaColMiss => 'PUDŁA';

  @override
  String get arenaColAvg => 'ŚR.';

  @override
  String get arenaColBest => 'NAJLEPSZY';

  @override
  String get arenaColTime => 'NAJSZYBCIEJ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossy $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILE';

  @override
  String get padSchemeClassic => 'PAD: KLASYCZNY';

  @override
  String get padSouthpawOn => 'LEWORĘCZNY: WŁ.';

  @override
  String get padSouthpawOff => 'LEWORĘCZNY: WYŁ.';

  @override
  String get sigilDescHop => 'Szybki skok w kierunku machnięcia';

  @override
  String get sigilDescSidestep => 'Długi unik w bok przez całe pole';

  @override
  String get sigilDescStrike =>
      'Wypad naprzód z trzema ciężkimi strzałami i powrót';

  @override
  String get sigilDescRetreat => 'Odwrót, a ogień osłonowy leci naprzód';

  @override
  String get sigilDescDash => 'Skośny zryw przez ogień, w połowie nietykalny';

  @override
  String get sigilDescRoll => 'Beczka w bok, nietykalny';

  @override
  String get sigilDescShadow =>
      'Przyklej się pod najbliższym wrogiem i strzelaj';

  @override
  String get sigilDescEcho =>
      'Cień powtarza twoje ostatnie dwie sekundy z połową obrażeń';

  @override
  String get sigilDescLoop => 'Pętla górą: pociski przelatują pod tobą';

  @override
  String get sigilDescSlalom => 'Slalom przez pole z ogniem wachlarzowym';

  @override
  String get sigilDescCorkscrew =>
      'Korkociąg naprzód z ogniem dookoła, nietykalny';

  @override
  String get sigilDescSnapshot => 'Jeden ciężki strzał w kierunku machnięcia';

  @override
  String get sigilDescBroadside => 'Salwa z obu burt';

  @override
  String get sigilDescVolley => 'Pięć naładowanych promieni naprzód';

  @override
  String get sigilDescCaltrop => 'Mina, która połyka pociski i wybucha';

  @override
  String get sigilDescFrenzy => 'Działa strzelają szybciej przez kilka sekund';

  @override
  String get sigilDescStasis => 'Wrogowie i ich pociski zwalniają o połowę';

  @override
  String get sigilDescHalo =>
      'Osłona ładuje się cztery razy szybciej i nic nie przejdzie';

  @override
  String get sigilDescRadial => 'Pierścień szesnastu strzałów';

  @override
  String get sigilDescStorm => 'Każde działo strzela na pełną moc, za darmo';

  @override
  String get sigilDescPing => 'Towarzysze skupiają ogień tam, gdzie machniesz';

  @override
  String get sigilDescWingman => 'Wezwij skrzydłowego na narysowaną flankę';

  @override
  String get sigilDescHunter =>
      'Wezwij łowcę, który leci przodem i wybiera cele';

  @override
  String get sigilDescWarden =>
      'Wezwij strażnika, który przyjmuje strzały za ciebie';

  @override
  String get sigilDescFormation =>
      'Towarzysze zmieniają szyk: szeroki lub klin';

  @override
  String get sigilDescWhirl => 'Towarzysze krążą wokół i łapią pociski';

  @override
  String get sigilDescSacrifice =>
      'Towarzysze nurkują i wybuchają, zwracając ładunek';

  @override
  String get grimoire => 'GRIMUAR';

  @override
  String get grimoireHint =>
      'Rysuj prawą gałką. LB: ARMS, RB: WING, oba: MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'koszt $cost';
  }

  @override
  String get sigilUntouchable => 'nietykalny';

  @override
  String get lessonWatch => 'PATRZ';

  @override
  String get lessonTrace => 'OBRYSUJ';

  @override
  String get lessonSlow => 'POWOLI';

  @override
  String get lessonLive => 'PEŁNA PRĘDKOŚĆ';

  @override
  String get lessonStreak => 'PIĘĆ Z RZĘDU';

  @override
  String get lessonLearned => 'OPANOWANE';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Machnij prawą gałką';

  @override
  String get hintLoop => 'Narysuj koło: przelatujesz nad pociskami';

  @override
  String get hintStream => 'Wciśnij LT: dwa lub trzy strumienie';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'BRAK';

  @override
  String kataNext(String sigil, String secs) {
    return 'następny $sigil za $secs s';
  }

  @override
  String get arenaGauntlet => 'RĘKAWICA';

  @override
  String get arenaOn => 'WŁ.';

  @override
  String get arenaOff => 'WYŁ.';

  @override
  String gauntletRating(int rating, int best) {
    return 'Ocena $rating · najlepsza $best';
  }

  @override
  String get duelWarning => 'UWAGA';

  @override
  String get duelHintPad1 => 'Prawa gałka celuje i strzela';

  @override
  String get duelHintPad2Rt =>
      'Trzymaj RT, LB lub RB: prawa gałka rysuje sigile';

  @override
  String get duelHintPad2Lt =>
      'Trzymaj LT, LB lub RB: prawa gałka rysuje sigile';

  @override
  String get duelHintClassic =>
      'Lewa gałka lot · B, RB lub RT strzelają w kierunku dzioba';

  @override
  String get duelHintKeys1 => 'Strzałki celują i strzelają · WASD lot';

  @override
  String get duelHintKeys2 =>
      'Spacja strzela w kierunku dzioba · klawiatura numeryczna rysuje sigile';

  @override
  String get arenaDuelBinding => 'POSTAWA POJEDYNKU';

  @override
  String get duelBindingRt => 'RT + GAŁKA';

  @override
  String get duelBindingLt => 'LT + GAŁKA';

  @override
  String get arenaDuelFrame => 'PAD NAPRZÓD';

  @override
  String get duelFrameNose => 'DZIÓB';

  @override
  String get duelFrameUp => 'GÓRA';

  @override
  String get arenaDuelAimFires => 'CELOWANIE STRZELA';

  @override
  String get duelCutInFirst => 'ZBLIŻENIE BOSSA: PIERWSZY RAZ';

  @override
  String get duelCutInAlways => 'ZBLIŻENIE BOSSA: ZAWSZE';

  @override
  String get duelCutInNever => 'ZBLIŻENIE BOSSA: NIGDY';

  @override
  String get arenaDuelDrill => 'TRENING POJEDYNKU';

  @override
  String get duelDrillOff => 'BRAK';

  @override
  String get duelDrillAim => 'CELUJ I STRZELAJ';

  @override
  String get duelDrillAimHow => 'Skieruj prawą gałkę na bossa i traf go';

  @override
  String get duelDrillHold => 'TRZYMAJ DZIÓB';

  @override
  String get duelDrillHoldHow =>
      'Trzymaj przycisk postawy i leć: dziób zostaje w miejscu';

  @override
  String get duelDrillDraw => 'RYSUJ NAPRZÓD';

  @override
  String get duelDrillDrawHow => 'W postawie narysuj sigil w stronę bossa';

  @override
  String get duelDrillTurn => 'ZAWRÓĆ';

  @override
  String get duelDrillTurnHow => 'Boss jest pod tobą: obróć dziób i traf go';

  @override
  String get duelDrillDone => 'GOTOWE';
}
