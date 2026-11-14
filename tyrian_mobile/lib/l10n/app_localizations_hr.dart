// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get ok => 'U REDU';

  @override
  String get cancel => 'ODUSTANI';

  @override
  String get connect => 'POVEŽI';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Povezivanje s $hostName nije uspjelo';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Domaćin je bio vidljiv, ali veza se nije uspostavila.\n\nIgra u blizini treba Wi-Fi peer-to-peer, koji iOS isključuje dok je uključena Osobna pristupna točka — isključite je na oba uređaja i pokušajte ponovno ili spojite oba uređaja na istu Wi-Fi mrežu.';

  @override
  String get gameOverCampaign =>
      'Misija neuspjela — oprema i krediti ostaju. Pokušajte ponovno iz Zapovjednog centra.';

  @override
  String get gameOverEndless => 'Obnova u Sektoru 1 — oprema i krediti ostaju';

  @override
  String get waitingForHost => 'Čekanje domaćina...';

  @override
  String get waitingForHostHint => 'Igra počinje kad domaćin bude spreman';

  @override
  String get vesselLost => 'BROD IZGUBLJEN';

  @override
  String scoreValue(String score) {
    return 'Bodovi: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Krediti: $credits';
  }

  @override
  String get creditsPrefix => 'Krediti: ';

  @override
  String get leaderboard => 'LJESTVICA';

  @override
  String get achievements => 'POSTIGNUĆA';

  @override
  String get redeploy => 'NATRAG U BOJ';

  @override
  String get resume => 'NASTAVI';

  @override
  String get pause => 'PAUZA';

  @override
  String get paused => 'PAUZIRANO';

  @override
  String get skins => 'IZGLEDI';

  @override
  String get skin => 'IZGLED';

  @override
  String get soundOn => 'ZVUK: UKLJ.';

  @override
  String get soundOff => 'ZVUK: ISKLJ.';

  @override
  String get musicOn => 'GLAZBA: UKLJ.';

  @override
  String get musicOff => 'GLAZBA: ISKLJ.';

  @override
  String get statsOn => 'STATISTIKA: UKLJ.';

  @override
  String get statsOff => 'STATISTIKA: ISKLJ.';

  @override
  String get mainMenu => 'GLAVNI IZBORNIK';

  @override
  String get quitToDesktop => 'IZLAZ NA RADNU POVRŠINU';

  @override
  String get selectSkin => 'ODABERI IZGLED';

  @override
  String get difficulty => 'TEŽINA';

  @override
  String get difficultyEasy => 'LAKO';

  @override
  String get difficultyNormal => 'NORMALNO';

  @override
  String get difficultyHard => 'TEŠKO';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANJA';

  @override
  String get quit => 'IZLAZ';

  @override
  String get restorePurchases => 'VRATI KUPNJE';

  @override
  String get locked => 'ZAKLJUČANO';

  @override
  String get mainMenuTooltip => 'Glavni izbornik';

  @override
  String nodeLevel(int level) {
    return 'RAZINA $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'RAZINA $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Zaključano. Najprije prođite prethodni čvor.';

  @override
  String get flyAgain => 'LETI PONOVNO';

  @override
  String get launch => 'LANSIRAJ';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'ZVJEZDICA';

  @override
  String get continueButton => 'NASTAVI';

  @override
  String get replayNode => 'PONOVI ČVOR';

  @override
  String get retry => 'POKUŠAJ PONOVNO';

  @override
  String get nodeCleared => 'ČVOR PRIJEĐEN';

  @override
  String get nodeFailed => 'ČVOR NEUSPJEO';

  @override
  String get weaponTierUnlocked => 'OTKLJUČANA RAZINA ORUŽJA';

  @override
  String get onSaleInComCenter => 'U prodaji u Zapovjednom centru.';

  @override
  String get requiredTasksHint =>
      'O čvoru odlučuju obvezni zadaci. Letite ponovno — ono što ste zaradili ostaje vam.';

  @override
  String get objClear => 'Očistite sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Srušite $count neprijatelja',
      few: 'Srušite $count neprijatelja',
      one: 'Srušite $count neprijatelja',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ne primite oštećenje trupa';

  @override
  String objHull(int percent) {
    return 'Završite s trupom iznad $percent %';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uništite $count neprijatelja oružjem $weapon',
      few: 'Uništite $count neprijatelja oružjem $weapon',
      one: 'Uništite $count neprijatelja oružjem $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uništite $count neprijatelja bočnim topovima',
      few: 'Uništite $count neprijatelja bočnim topovima',
      one: 'Uništite $count neprijatelja bočnim topovima',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Poletite s oružjem $weapon sprijeda';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Poletite s oružjem $weapon na boku';
  }

  @override
  String get objBuySideGun => 'Kupite bočni top u Zapovjednom centru';

  @override
  String objUpgradeGenerator(int level) {
    return 'Nadogradite generator na razinu $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Nadogradite prednji top na razinu $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Nadogradite bočni top na razinu $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uhvatite $count bonusa',
      few: 'Uhvatite $count bonusa',
      one: 'Uhvatite $count bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uništite $count cijelih formacija',
      few: 'Uništite $count cijele formacije',
      one: 'Uništite $count cijelu formaciju',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ne udarite ni u jedan asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Završite za $seconds s';
  }

  @override
  String get objStripBoss => 'Uništite sve dijelove bossa prije jezgre';

  @override
  String get joinCoopTitle => 'Pridruži se co-opu';

  @override
  String get cannotSearchNetwork => 'Nije moguće pretražiti ovu mrežu';

  @override
  String get joinHintNearby =>
      'Ista Wi-Fi mreža radi na svakom uređaju. iPhone, iPad i Mac pronalaze se i u blizini bez nje — s isključenom Osobnom pristupnom točkom na oba.';

  @override
  String get joinHintWifi =>
      'Oba igrača moraju biti na istoj Wi-Fi mreži — radi i Osobna pristupna točka.';

  @override
  String noHostsYet(String hint) {
    return 'Još nema domaćina. $hint';
  }

  @override
  String get lookingForHosts =>
      'Traženje domaćina na ovoj Wi-Fi mreži i u blizini…';

  @override
  String get hostNearby => 'U blizini · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · ista Wi-Fi mreža';
  }

  @override
  String get enterIpManually => 'Unesi IP ručno';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ŠT';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — ZAŠTIĆEN ŠTITOM';
  }

  @override
  String get bossPartTurret => 'Kupola';

  @override
  String get bossPartShieldPod => 'Modul štita';

  @override
  String get bossPartThruster => 'Potisnik';

  @override
  String get bossPartCannon => 'Top';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Nepoznati svemir';
  }

  @override
  String get player2Joined => 'Igrač 2 se pridružio!';

  @override
  String get player2Disconnected => 'Igrač 2 je prekinuo vezu';

  @override
  String get hostDisconnected => 'Domaćin je prekinuo vezu';

  @override
  String maxLevelSold(String amount) {
    return 'Maks. razina! Prodano za \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Otključana razina oružja $tier';
  }

  @override
  String get cheatsEnabled => 'Varke uključene';

  @override
  String get cheatsDisabled => 'Varke isključene';

  @override
  String get cheatsMaxed =>
      'VARKA: krediti na maksimumu, sva oružja otključana';

  @override
  String get cheats => 'VARKE';

  @override
  String get maxCredits => 'MAKS. KREDITI';

  @override
  String get sectionStats => 'STATISTIKA';

  @override
  String get sectionLoadout => 'OPREMA';

  @override
  String levelShort(int level) {
    return 'Raz.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'NADOG';

  @override
  String get sell => 'PRODAJ';

  @override
  String get buy => 'KUPI';

  @override
  String get commandCenter => 'ZAPOVJEDNI CENTAR';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'BODOVI';

  @override
  String get nextWeapon => 'SLJEDEĆE ORUŽJE';

  @override
  String pointsValue(String points) {
    return '$points bod.';
  }

  @override
  String get slotFront => 'Sprijeda';

  @override
  String get slotLeft => 'Lijevo';

  @override
  String get slotRight => 'Desno';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LANSIRAJ MISIJU';

  @override
  String get startMission => 'ZAPOČNI MISIJU';

  @override
  String get continueMission => 'NASTAVI MISIJU';

  @override
  String get padControlsHint =>
      '[↑↓] Red   [←→] Odabir   [B] Kupi/Nadogradi/Zamijeni   [X/Y] Prodaj   [OPTIONS] Nastavi misiju';

  @override
  String get host => 'DOMAĆIN';

  @override
  String hostingAs(String name) {
    return 'DOMAĆIN kao $name';
  }

  @override
  String get join => 'PRIDRUŽI SE';

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
  String get overload => 'PREOPTEREĆENJE';

  @override
  String weaponOff(String weapon) {
    return '$weapon ISKLJ. — preslab generator';
  }

  @override
  String unlocksAt(String points) {
    return 'Otključava se na $points bod.';
  }

  @override
  String joinConnecting(String target) {
    return 'Povezivanje s $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Domaćin nije odgovorio: $reason.\n\nOba igrača moraju biti na istoj Wi-Fi mreži (radi i Osobna pristupna točka), a domaćin mora pritisnuti DOMAĆIN. Provjerite adresu i pokušajte ponovno.';
  }

  @override
  String get lanJoinNoAnswer => 'nema odgovora';

  @override
  String objBossUnder(int seconds) {
    return 'Uništite jezgru bossa unutar $seconds s od njegova dolaska';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'TREZOR';

  @override
  String get rackSide => 'Bok';

  @override
  String get rackHull => 'Trup';

  @override
  String get rarityCommon => 'OBIČNO';

  @override
  String get rarityRare => 'RIJETKO';

  @override
  String get rarityMythic => 'MITSKO';

  @override
  String get curse => 'KLETVA';

  @override
  String get modFit => 'UGRADI';

  @override
  String get modUnfit => 'SKINI';

  @override
  String get modForge => 'KOVAČNICA';

  @override
  String get forgeHint => 'Odaberite 3 iste rijetkosti da iskujete 1 sljedeće';

  @override
  String get vaultEmpty =>
      'Još nema modova. Prođite čvor sa svim zvjezdicama, brzo pobijedite bossa ili srušite bossa u beskrajnom načinu.';

  @override
  String modNeeds(String families) {
    return 'Radi s: $families';
  }

  @override
  String get modRackFull => 'Nosač je pun';

  @override
  String get modAlreadyFitted => 'Već ugrađeno';

  @override
  String get modWrongRack => 'Ne pristaje ovom nosaču';

  @override
  String modsSpilled(int n) {
    return 'Modova vraćeno u trezor: $n';
  }

  @override
  String get hullLocked => 'Zaključano';

  @override
  String hullUnlockBoss(int n) {
    return 'Pobijedite bossa kampanje $n';
  }

  @override
  String get hullUnlockFinish => 'Završite kampanju ili dosegnite sektor 30';

  @override
  String get statAgility => 'OKR';

  @override
  String get statHitbox => 'POG';

  @override
  String get perkNone => 'Serijski brod';

  @override
  String get perkAfterimage => 'Mirujte: hici ×1,5';

  @override
  String get perkBulwark => 'Šteta iza štita je prepolovljena';

  @override
  String get perkOverclock => 'Puca do 130 % kapaciteta, sporije';

  @override
  String get perkBattery => 'Uz vas leti besplatni borbeni dron';

  @override
  String get rewardTitle => 'NAGRADA';

  @override
  String newHull(String name) {
    return 'Novi trup: $name';
  }

  @override
  String get socketEmpty => 'prazno';

  @override
  String fxStreams(int n) {
    return 'Paralelnih mlazova: $n';
  }

  @override
  String fxFan(int n) {
    return 'Lepeza od $n hitaca';
  }

  @override
  String fxSalvo(int n) {
    return 'Plotun od $n hitaca';
  }

  @override
  String fxFireRate(String x) {
    return 'Brzina paljbe ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Šteta ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Brzina hitaca ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Veličina hitaca ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Potrošnja energije ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Navođenje +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Probija mete: $n';
  }

  @override
  String get fxPierceAll => 'Probija sve';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % šanse za štetu ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Kritični ×$x na bossovima';
  }

  @override
  String fxFork(int n) {
    return 'Rušenja raspršuju hitce: $n';
  }

  @override
  String get fxChain => 'Raspršeni hici ponovno se raspršuju';

  @override
  String get fxSplit => 'Pri pogotku se dijeli na dva';

  @override
  String get fxFrost => 'Pogoci usporavaju neprijatelje';

  @override
  String get fxCrossfire => 'Bočni topovi ciljaju prema unutra';

  @override
  String get fxRearguard => 'Bočni topovi pucaju i unatrag';

  @override
  String get fxOrbit => 'Hici vijugaju';

  @override
  String fxBounce(int n) {
    return 'Odbija se od zidova $n×';
  }

  @override
  String get fxBounceTop => '…i od vrha';

  @override
  String get fxOverdrive => 'Puca na dug energije';

  @override
  String get fxReactor => 'Preopterećena oružja i dalje pucaju, sporo';

  @override
  String fxGenPower(String x) {
    return 'Punjenje generatora ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Kapacitet generatora ×$x';
  }

  @override
  String get fxSurge => 'Pun generator: hici ×2';

  @override
  String fxSiphon(int pct) {
    return 'Rušenja vraćaju $pct % energije';
  }

  @override
  String fxHp(String x) {
    return 'Trup ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Štit ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Obnova štita ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Rušenja liječe $n HP';
  }

  @override
  String get fxMagnet => 'Privlači bonuse';

  @override
  String get fxMagnetAll => 'Privlači svaki bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % hitaca odbija se od štita natrag';
  }

  @override
  String get fxReflectGuided => 'Odbijeni hici se navode';

  @override
  String fxGhost(String sec) {
    return 'Nedodirljiv $sec s nakon pogotka u trup';
  }

  @override
  String get fxNova => 'Štit pukne: eksplozija preko cijelog zaslona';

  @override
  String fxAgility(String x) {
    return 'Okretnost ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zona pogotka ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Krediti ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Bodovi ×$x';
  }

  @override
  String get fxSatellite => 'Uz vas leti borbeni dron';

  @override
  String get fxTimewarp => 'Pogodak u trup usporava vrijeme';

  @override
  String get fxGambler => 'Svaki hitac je nasumično oružje';

  @override
  String get vaultAll => 'SVE';

  @override
  String get sigilMissUnknown => 'nepoznat oblik';

  @override
  String get sigilMissTooSlow => 'presporo';

  @override
  String get sigilMissSkippedDot => 'preskočena točka';

  @override
  String get sigilMissLeftRimEarly => 'pušteno prerano';

  @override
  String get sigilMissWrongDirection => 'nacrtano unatrag';

  @override
  String get sigilMissWrongLayer => 'pogrešna rame-tipka';

  @override
  String get sigilDry => 'nedovoljno naboja';

  @override
  String get sigilBusy => 'prethodni još traje';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'DIJELOVI BOSSA';

  @override
  String get arenaBareCore => 'golo jezgro';

  @override
  String get arenaCompanions => 'PRATITELJI';

  @override
  String get arenaCharge => 'NABOJ';

  @override
  String get arenaChargeNormal => 'NORMALNO';

  @override
  String get arenaSpeed => 'BRZINA SVIJETA';

  @override
  String get arenaDrill => 'VJEŽBA';

  @override
  String get arenaFreePlay => 'SLOBODNA IGRA';

  @override
  String get arenaFight => 'BORBA';

  @override
  String get arenaNewBoss => 'NOVI BOSS';

  @override
  String get arenaLeave => 'NAPUSTI ARENU';

  @override
  String get arenaHint => 'Boss se vraća čim pogine. Ovdje se ništa ne sprema.';

  @override
  String get arenaColCast => 'BAČENO';

  @override
  String get arenaColMiss => 'PROMAŠAJ';

  @override
  String get arenaColAvg => 'PROS.';

  @override
  String get arenaColBest => 'NAJBOLJE';

  @override
  String get arenaColTime => 'NAJBRŽE';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossovi $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILI';

  @override
  String get padSchemeClassic => 'PAD: KLASIČNO';

  @override
  String get padSouthpawOn => 'LJEVORUKI: UKLJ.';

  @override
  String get padSouthpawOff => 'LJEVORUKI: ISKLJ.';

  @override
  String get sigilDescHop => 'Brzi skok u smjeru zamaha';

  @override
  String get sigilDescSidestep => 'Dugi bočni korak preko polja';

  @override
  String get sigilDescStrike => 'Iskorak s tri teška hica, pa natrag';

  @override
  String get sigilDescRetreat => 'Povlačenje dok zaštitna vatra ide naprijed';

  @override
  String get sigilDescDash =>
      'Dijagonalni proboj kroz vatru, nedodirljiv na pola puta';

  @override
  String get sigilDescRoll => 'Bačvasti okret u stranu, nedodirljiv';

  @override
  String get sigilDescShadow =>
      'Zaključaj se ispod najbližeg neprijatelja i pucaj';

  @override
  String get sigilDescEcho =>
      'Sjena ponavlja tvoje zadnje dvije sekunde uz pola štete';

  @override
  String get sigilDescLoop => 'Petlja preko vrha: hici prolaze ispod tebe';

  @override
  String get sigilDescSlalom => 'S-zavoj preko polja s lepezastom vatrom';

  @override
  String get sigilDescCorkscrew =>
      'Vadičep naprijed uz vatru na sve strane, nedodirljiv';

  @override
  String get sigilDescSnapshot => 'Jedan teški hitac u smjeru zamaha';

  @override
  String get sigilDescBroadside => 'Salva s oba boka';

  @override
  String get sigilDescVolley => 'Pet nabijenih zraka naprijed';

  @override
  String get sigilDescCaltrop => 'Ispusti minu koja guta hice i eksplodira';

  @override
  String get sigilDescFrenzy => 'Oružja nekoliko sekundi pucaju brže';

  @override
  String get sigilDescStasis =>
      'Neprijatelji i njihovi hici usporavaju na pola';

  @override
  String get sigilDescHalo =>
      'Štit se puni četiri puta brže i ništa ne prolazi';

  @override
  String get sigilDescRadial => 'Prsten od šesnaest hitaca';

  @override
  String get sigilDescStorm => 'Sva oružja pucaju punom snagom, besplatno';

  @override
  String get sigilDescPing => 'Pratitelji usmjeravaju vatru kamo zamahneš';

  @override
  String get sigilDescWingman =>
      'Pozovi krilnog pratitelja na bok prema kojem si crtao';

  @override
  String get sigilDescHunter => 'Pozovi lovca koji leti naprijed i bira mete';

  @override
  String get sigilDescWarden =>
      'Pozovi čuvara koji prima hice namijenjene tebi';

  @override
  String get sigilDescFormation =>
      'Pratitelji mijenjaju široku i klinastu formaciju';

  @override
  String get sigilDescWhirl => 'Pratitelji kruže oko tebe i gutaju hice';

  @override
  String get sigilDescSacrifice =>
      'Pratitelji se obrušavaju i eksplodiraju, vraćajući naboj';

  @override
  String get grimoire => 'GRIMOAR';

  @override
  String get grimoireHint =>
      'Crtaj desnom palicom. Drži LB za ORUŽJA, RB za KRILO, oba za MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'cijena $cost';
  }

  @override
  String get sigilUntouchable => 'nedodirljiv';

  @override
  String get lessonWatch => 'GLEDAJ';

  @override
  String get lessonTrace => 'PRATI';

  @override
  String get lessonSlow => 'SPORO';

  @override
  String get lessonLive => 'PUNA BRZINA';

  @override
  String get lessonStreak => 'PET ZA REDOM';

  @override
  String get lessonLearned => 'NAUČENO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Zamahni desnom palicom';

  @override
  String get hintLoop => 'Nacrtaj krug: letiš iznad hitaca';

  @override
  String get hintStream => 'Stisni LT: dva ili tri mlaza';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NIŠTA';

  @override
  String kataNext(String sigil, String secs) {
    return 'sljedeći $sigil za $secs s';
  }

  @override
  String get arenaGauntlet => 'IZAZOV';

  @override
  String get arenaOn => 'UKLJ.';

  @override
  String get arenaOff => 'ISKLJ.';

  @override
  String gauntletRating(int rating, int best) {
    return 'Ocjena $rating · najbolje $best';
  }

  @override
  String get duelWarning => 'UPOZORENJE';

  @override
  String get duelHintPad1 => 'Desna palica nišani i puca';

  @override
  String get duelHintPad2Rt => 'Drži RT, LB ili RB: desna palica crta sigile';

  @override
  String get duelHintPad2Lt => 'Drži LT, LB ili RB: desna palica crta sigile';

  @override
  String get duelHintClassic =>
      'Lijeva palica leti · B, RB ili RT pucaju kamo gleda nos';

  @override
  String get duelHintKeys1 => 'Strelice nišane i pucaju · WASD leti';

  @override
  String get duelHintKeys2 =>
      'Razmak puca kamo gleda nos · numerička tipkovnica crta sigile';

  @override
  String get arenaDuelBinding => 'STAV ZA DVOBOJ';

  @override
  String get duelBindingRt => 'RT + PALICA';

  @override
  String get duelBindingLt => 'LT + PALICA';

  @override
  String get arenaDuelFrame => 'PAD NAPRIJED';

  @override
  String get duelFrameNose => 'NOS';

  @override
  String get duelFrameUp => 'GORE';

  @override
  String get arenaDuelAimFires => 'NIŠANJENJE PUCA';

  @override
  String get duelCutInFirst => 'KRUPNI PLAN BOSSA: PRVI PUT';

  @override
  String get duelCutInAlways => 'KRUPNI PLAN BOSSA: UVIJEK';

  @override
  String get duelCutInNever => 'KRUPNI PLAN BOSSA: NIKAD';

  @override
  String get arenaDuelDrill => 'VJEŽBA DVOBOJA';

  @override
  String get duelDrillOff => 'NIŠTA';

  @override
  String get duelDrillAim => 'NIŠANI I PUCAJ';

  @override
  String get duelDrillAimHow => 'Usmjeri desnu palicu na bossa i pogodi ga';

  @override
  String get duelDrillHold => 'DRŽI NOS';

  @override
  String get duelDrillHoldHow =>
      'Drži tipku stava i leti: nos ostaje na mjestu';

  @override
  String get duelDrillDraw => 'CRTAJ NAPRIJED';

  @override
  String get duelDrillDrawHow => 'U stavu nacrtaj sigil prema bossu';

  @override
  String get duelDrillTurn => 'OKRENI SE';

  @override
  String get duelDrillTurnHow => 'Boss je ispod tebe: okreni nos i pogodi ga';

  @override
  String get duelDrillDone => 'GOTOVO';

  @override
  String get swapHint => 'Dodirni drugim prstom za promjenu oružja';
}
