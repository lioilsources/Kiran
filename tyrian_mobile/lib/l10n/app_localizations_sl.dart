// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get ok => 'V REDU';

  @override
  String get cancel => 'PREKLIČI';

  @override
  String get connect => 'POVEŽI';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Povezava z $hostName ni uspela';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Gostitelj je bil viden, vendar se povezava ni vzpostavila.\n\nIgra v bližini potrebuje Wi-Fi peer-to-peer, ki ga iOS izklopi, ko je vklopljena Osebna dostopna točka — izklopite jo na obeh napravah in poskusite znova ali povežite obe napravi v isto omrežje Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Misija ni uspela — oprema in krediti ostanejo. Poskusite znova iz Poveljniškega centra.';

  @override
  String get gameOverEndless =>
      'Obnova v Sektorju 1 — oprema in krediti ostanejo';

  @override
  String get waitingForHost => 'Čakanje na gostitelja...';

  @override
  String get waitingForHostHint => 'Igra se začne, ko bo gostitelj pripravljen';

  @override
  String get vesselLost => 'LADJA IZGUBLJENA';

  @override
  String scoreValue(String score) {
    return 'Točke: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Krediti: $credits';
  }

  @override
  String get creditsPrefix => 'Krediti: ';

  @override
  String get leaderboard => 'LESTVICA';

  @override
  String get achievements => 'DOSEŽKI';

  @override
  String get redeploy => 'NAZAJ V BOJ';

  @override
  String get resume => 'NADALJUJ';

  @override
  String get pause => 'PREMOR';

  @override
  String get paused => 'ZAUSTAVLJENO';

  @override
  String get skins => 'VIDEZI';

  @override
  String get skin => 'VIDEZ';

  @override
  String get soundOn => 'ZVOK: VKL.';

  @override
  String get soundOff => 'ZVOK: IZKL.';

  @override
  String get musicOn => 'GLASBA: VKL.';

  @override
  String get musicOff => 'GLASBA: IZKL.';

  @override
  String get statsOn => 'STATISTIKA: VKL.';

  @override
  String get statsOff => 'STATISTIKA: IZKL.';

  @override
  String get mainMenu => 'GLAVNI MENI';

  @override
  String get quitToDesktop => 'IZHOD NA NAMIZJE';

  @override
  String get selectSkin => 'IZBERI VIDEZ';

  @override
  String get difficulty => 'TEŽAVNOST';

  @override
  String get difficultyEasy => 'LAHKO';

  @override
  String get difficultyNormal => 'NORMALNO';

  @override
  String get difficultyHard => 'TEŽKO';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANJA';

  @override
  String get quit => 'IZHOD';

  @override
  String get restorePurchases => 'OBNOVI NAKUPE';

  @override
  String get locked => 'ZAKLENJENO';

  @override
  String get mainMenuTooltip => 'Glavni meni';

  @override
  String nodeLevel(int level) {
    return 'STOPNJA $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'STOPNJA $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Zaklenjeno. Najprej opravite prejšnje vozlišče.';

  @override
  String get flyAgain => 'LETI ZNOVA';

  @override
  String get launch => 'VZLET';

  @override
  String zoneLabel(int zone) {
    return 'CONA $zone';
  }

  @override
  String get objectiveStar => 'ZVEZDICA';

  @override
  String get continueButton => 'NAPREJ';

  @override
  String get replayNode => 'PONOVI VOZLIŠČE';

  @override
  String get retry => 'POSKUSI ZNOVA';

  @override
  String get nodeCleared => 'VOZLIŠČE OPRAVLJENO';

  @override
  String get nodeFailed => 'VOZLIŠČE NI OPRAVLJENO';

  @override
  String get weaponTierUnlocked => 'ODKLENJENA STOPNJA OROŽJA';

  @override
  String get onSaleInComCenter => 'Naprodaj v Poveljniškem centru.';

  @override
  String get requiredTasksHint =>
      'O vozlišču odločajo obvezne naloge. Letite znova — kar ste pridobili, vam ostane.';

  @override
  String get objClear => 'Očistite sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sestrelite $count sovražnikov',
      few: 'Sestrelite $count sovražnike',
      two: 'Sestrelite $count sovražnika',
      one: 'Sestrelite $count sovražnika',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ne utrpite poškodb trupa';

  @override
  String objHull(int percent) {
    return 'Končajte s trupom nad $percent %';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uničite $count sovražnikov z orožjem $weapon',
      few: 'Uničite $count sovražnike z orožjem $weapon',
      two: 'Uničite $count sovražnika z orožjem $weapon',
      one: 'Uničite $count sovražnika z orožjem $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uničite $count sovražnikov s stranskimi topovi',
      few: 'Uničite $count sovražnike s stranskimi topovi',
      two: 'Uničite $count sovražnika s stranskimi topovi',
      one: 'Uničite $count sovražnika s stranskimi topovi',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Vzletite z orožjem $weapon spredaj';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Vzletite z orožjem $weapon ob strani';
  }

  @override
  String get objBuySideGun => 'Kupite stranski top v Poveljniškem centru';

  @override
  String objUpgradeGenerator(int level) {
    return 'Nadgradite generator na stopnjo $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Nadgradite sprednji top na stopnjo $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Nadgradite stranski top na stopnjo $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ujemite $count bonusov',
      few: 'Ujemite $count bonuse',
      two: 'Ujemite $count bonusa',
      one: 'Ujemite $count bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uničite $count celih formacij',
      few: 'Uničite $count cele formacije',
      two: 'Uničite $count celi formaciji',
      one: 'Uničite $count celo formacijo',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ne zaletite se v noben asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Končajte v $seconds s';
  }

  @override
  String get objStripBoss => 'Uničite vse dele bossa pred jedrom';

  @override
  String get joinCoopTitle => 'Pridruži se co-opu';

  @override
  String get cannotSearchNetwork => 'Tega omrežja ni mogoče preiskati';

  @override
  String get joinHintNearby =>
      'Isto omrežje Wi-Fi deluje na vsaki napravi. iPhone, iPad in Mac se najdejo tudi v bližini brez njega — z izklopljeno Osebno dostopno točko na obeh.';

  @override
  String get joinHintWifi =>
      'Oba igralca morata biti v istem omrežju Wi-Fi — deluje tudi Osebna dostopna točka.';

  @override
  String noHostsYet(String hint) {
    return 'Gostiteljev še ni. $hint';
  }

  @override
  String get lookingForHosts =>
      'Iskanje gostiteljev v tem omrežju Wi-Fi in v bližini…';

  @override
  String get hostNearby => 'V bližini · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · isto omrežje Wi-Fi';
  }

  @override
  String get enterIpManually => 'Vnesi IP ročno';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ŠČ';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — ZAŠČITEN S ŠČITOM';
  }

  @override
  String get bossPartTurret => 'Kupola';

  @override
  String get bossPartShieldPod => 'Modul ščita';

  @override
  String get bossPartThruster => 'Potisnik';

  @override
  String get bossPartCannon => 'Top';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Neznano vesolje';
  }

  @override
  String get player2Joined => 'Igralec 2 se je pridružil!';

  @override
  String get player2Disconnected => 'Igralec 2 je prekinil povezavo';

  @override
  String get hostDisconnected => 'Gostitelj je prekinil povezavo';

  @override
  String maxLevelSold(String amount) {
    return 'Najvišja stopnja! Prodano za \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Odklenjena stopnja orožja $tier';
  }

  @override
  String get cheatsEnabled => 'Goljufije vklopljene';

  @override
  String get cheatsDisabled => 'Goljufije izklopljene';

  @override
  String get cheatsMaxed =>
      'GOLJUFIJA: krediti na maksimumu, vsa orožja odklenjena';

  @override
  String get cheats => 'GOLJUFIJE';

  @override
  String get maxCredits => 'MAKS. KREDITI';

  @override
  String get sectionStats => 'STATISTIKA';

  @override
  String get sectionLoadout => 'OPREMA';

  @override
  String levelShort(int level) {
    return 'St.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'NADG';

  @override
  String get sell => 'PRODAJ';

  @override
  String get buy => 'KUPI';

  @override
  String get commandCenter => 'POVELJNIŠKI CENTER';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'TOČKE';

  @override
  String get nextWeapon => 'NASLEDNJE OROŽJE';

  @override
  String pointsValue(String points) {
    return '$points t.';
  }

  @override
  String get slotFront => 'Spredaj';

  @override
  String get slotLeft => 'Levo';

  @override
  String get slotRight => 'Desno';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'ZAČNI MISIJO';

  @override
  String get startMission => 'ZAŽENI MISIJO';

  @override
  String get continueMission => 'NADALJUJ MISIJO';

  @override
  String get padControlsHint =>
      '[↑↓] Vrstica   [←→] Izbira   [B] Kupi/Nadgradi/Zamenjaj   [X/Y] Prodaj   [OPTIONS] Nadaljuj misijo';

  @override
  String get host => 'GOSTI';

  @override
  String hostingAs(String name) {
    return 'GOSTITE kot $name';
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
  String get overload => 'PREOBREMENITEV';

  @override
  String weaponOff(String weapon) {
    return '$weapon IZKL. — prešibak generator';
  }

  @override
  String unlocksAt(String points) {
    return 'Odklene se pri $points t.';
  }

  @override
  String joinConnecting(String target) {
    return 'Povezovanje z $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Gostitelj se ni odzval: $reason.\n\nOba igralca morata biti v istem omrežju Wi-Fi (deluje tudi Osebna dostopna točka), gostitelj pa mora pritisniti GOSTI. Preverite naslov in poskusite znova.';
  }

  @override
  String get lanJoinNoAnswer => 'ni odgovora';

  @override
  String objBossUnder(int seconds) {
    return 'Uničite jedro bossa v $seconds s po njegovem prihodu';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'TREZOR';

  @override
  String get rackSide => 'Stran';

  @override
  String get rackHull => 'Trup';

  @override
  String get rarityCommon => 'NAVADNO';

  @override
  String get rarityRare => 'REDKO';

  @override
  String get rarityMythic => 'MITSKO';

  @override
  String get curse => 'PREKLETSTVO';

  @override
  String get modFit => 'VGRADI';

  @override
  String get modUnfit => 'ODSTRANI';

  @override
  String get modForge => 'KOVAČNICA';

  @override
  String get forgeHint => 'Izberite 3 iste redkosti, da skujete 1 naslednje';

  @override
  String get vaultEmpty =>
      'Modov še ni. Opravite vozlišče z vsemi zvezdicami, hitro premagajte bossa ali sestrelite bossa v neskončnem načinu.';

  @override
  String modNeeds(String families) {
    return 'Deluje z: $families';
  }

  @override
  String get modRackFull => 'Nosilec je poln';

  @override
  String get modAlreadyFitted => 'Že vgrajeno';

  @override
  String get modWrongRack => 'Ne ustreza temu nosilcu';

  @override
  String modsSpilled(int n) {
    return 'Modov nazaj v trezorju: $n';
  }

  @override
  String get hullLocked => 'Zaklenjeno';

  @override
  String hullUnlockBoss(int n) {
    return 'Premagajte bossa kampanje $n';
  }

  @override
  String get hullUnlockFinish => 'Končajte kampanjo ali dosezite sektor 30';

  @override
  String get statAgility => 'OKR';

  @override
  String get statHitbox => 'ZAD';

  @override
  String get perkNone => 'Serijska ladja';

  @override
  String get perkAfterimage => 'Mirujte: streli ×1,5';

  @override
  String get perkBulwark => 'Škoda mimo ščita je prepolovljena';

  @override
  String get perkOverclock => 'Strelja do 130 % zmogljivosti, počasneje';

  @override
  String get perkBattery => 'Z vami leti brezplačen bojni dron';

  @override
  String get rewardTitle => 'NAGRADA';

  @override
  String newHull(String name) {
    return 'Nov trup: $name';
  }

  @override
  String get socketEmpty => 'prazno';

  @override
  String fxStreams(int n) {
    return 'Vzporednih curkov: $n';
  }

  @override
  String fxFan(int n) {
    return 'Pahljača $n strelov';
  }

  @override
  String fxSalvo(int n) {
    return 'Salva $n strelov';
  }

  @override
  String fxFireRate(String x) {
    return 'Hitrost streljanja ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Škoda ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Hitrost strelov ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Velikost strelov ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Poraba energije ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Vodenje +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Prebije tarč: $n';
  }

  @override
  String get fxPierceAll => 'Prebije vse';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % možnosti za škodo ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Kritični ×$x na bossih';
  }

  @override
  String fxFork(int n) {
    return 'Sestrelitve razpršijo strele: $n';
  }

  @override
  String get fxChain => 'Razpršeni streli se znova razpršijo';

  @override
  String get fxSplit => 'Ob zadetku se razdeli na dva';

  @override
  String get fxFrost => 'Zadetki upočasnijo sovražnike';

  @override
  String get fxCrossfire => 'Stranski topovi merijo navznoter';

  @override
  String get fxRearguard => 'Stranski topovi streljajo tudi nazaj';

  @override
  String get fxOrbit => 'Streli vijugajo';

  @override
  String fxBounce(int n) {
    return 'Odbije se od sten $n×';
  }

  @override
  String get fxBounceTop => '…in od vrha';

  @override
  String get fxOverdrive => 'Strelja na dolg energije';

  @override
  String get fxReactor => 'Preobremenjena orožja še vedno streljajo, počasi';

  @override
  String fxGenPower(String x) {
    return 'Polnjenje generatorja ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Zmogljivost generatorja ×$x';
  }

  @override
  String get fxSurge => 'Poln generator: streli ×2';

  @override
  String fxSiphon(int pct) {
    return 'Sestrelitve obnovijo $pct % energije';
  }

  @override
  String fxHp(String x) {
    return 'Trup ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Ščit ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Obnova ščita ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Sestrelitve zdravijo $n HP';
  }

  @override
  String get fxMagnet => 'Privlači bonuse';

  @override
  String get fxMagnetAll => 'Privlači vse bonuse';

  @override
  String fxReflect(int pct) {
    return '$pct % strelov se od ščita odbije nazaj';
  }

  @override
  String get fxReflectGuided => 'Odbiti streli se sami vodijo';

  @override
  String fxGhost(String sec) {
    return 'Nedotakljiv $sec s po zadetku v trup';
  }

  @override
  String get fxNova => 'Ščit poči: eksplozija čez ves zaslon';

  @override
  String fxAgility(String x) {
    return 'Okretnost ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Območje zadetka ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Krediti ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Točke ×$x';
  }

  @override
  String get fxSatellite => 'Z vami leti bojni dron';

  @override
  String get fxTimewarp => 'Zadetek v trup upočasni čas';

  @override
  String get fxGambler => 'Vsak strel je naključno orožje';

  @override
  String get vaultAll => 'VSE';

  @override
  String get sigilMissUnknown => 'neznana oblika';

  @override
  String get sigilMissTooSlow => 'prepočasi';

  @override
  String get sigilMissSkippedDot => 'izpuščena točka';

  @override
  String get sigilMissLeftRimEarly => 'prezgodaj spuščeno';

  @override
  String get sigilMissWrongDirection => 'narisano nazaj';

  @override
  String get sigilMissWrongLayer => 'napačen ramenski gumb';

  @override
  String get sigilDry => 'premalo naboja';

  @override
  String get sigilBusy => 'prejšnji še teče';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'DELI BOSSA';

  @override
  String get arenaBareCore => 'golo jedro';

  @override
  String get arenaCompanions => 'SPREMLJEVALCI';

  @override
  String get arenaCharge => 'NABOJ';

  @override
  String get arenaChargeNormal => 'NORMALNO';

  @override
  String get arenaSpeed => 'HITROST SVETA';

  @override
  String get arenaDrill => 'VAJA';

  @override
  String get arenaFreePlay => 'PROSTA IGRA';

  @override
  String get arenaFight => 'BOJ';

  @override
  String get arenaNewBoss => 'NOV BOSS';

  @override
  String get arenaLeave => 'ZAPUSTI ARENO';

  @override
  String get arenaHint =>
      'Boss se vrne takoj, ko umre. Nič tukaj se ne shrani.';

  @override
  String get arenaColCast => 'UPORABE';

  @override
  String get arenaColMiss => 'ZGREŠENI';

  @override
  String get arenaColAvg => 'POVPR.';

  @override
  String get arenaColBest => 'NAJBOLJŠE';

  @override
  String get arenaColTime => 'NAJHITREJE';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossi $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'KRMILNIK: SIGILI';

  @override
  String get padSchemeClassic => 'KRMILNIK: KLASIČNO';

  @override
  String get padSouthpawOn => 'LEVIČAR: VKLOP';

  @override
  String get padSouthpawOff => 'LEVIČAR: IZKLOP';

  @override
  String get sigilDescHop => 'Hiter skok v smeri zamaha';

  @override
  String get sigilDescSidestep => 'Dolg korak vstran čez polje';

  @override
  String get sigilDescStrike =>
      'Izpad naprej s tremi težkimi streli, nato nazaj';

  @override
  String get sigilDescRetreat => 'Umik, medtem ko kritni ogenj leti naprej';

  @override
  String get sigilDescDash =>
      'Diagonalni preboj skozi ogenj, na sredini nedotakljiv';

  @override
  String get sigilDescRoll => 'Sodček vstran, nedotakljiv';

  @override
  String get sigilDescShadow =>
      'Prilepi se pod najbližjega sovražnika in streljaj';

  @override
  String get sigilDescEcho =>
      'Senca ponovi tvoji zadnji dve sekundi s pol škode';

  @override
  String get sigilDescLoop => 'Looping čez vrh: streli gredo pod teboj';

  @override
  String get sigilDescSlalom => 'Krivulja S čez polje s pahljačastim ognjem';

  @override
  String get sigilDescCorkscrew =>
      'Vijak naprej s streljanjem naokoli, nedotakljiv';

  @override
  String get sigilDescSnapshot => 'En težek strel v smeri zamaha';

  @override
  String get sigilDescBroadside => 'Salva z obeh bokov';

  @override
  String get sigilDescVolley => 'Pet nabitih žarkov naprej';

  @override
  String get sigilDescCaltrop =>
      'Odvrzi mino, ki pogoltne strele in eksplodira';

  @override
  String get sigilDescFrenzy => 'Orožja nekaj sekund streljajo hitreje';

  @override
  String get sigilDescStasis =>
      'Sovražniki in njihovi streli upočasnijo na pol';

  @override
  String get sigilDescHalo =>
      'Ščit se polni štirikrat hitreje in nič ne pride skozi';

  @override
  String get sigilDescRadial => 'Obroč šestnajstih strelov';

  @override
  String get sigilDescStorm => 'Vsa orožja na polno, zastonj';

  @override
  String get sigilDescPing => 'Spremljevalci zberejo ogenj v smeri zamaha';

  @override
  String get sigilDescWingman =>
      'Pokliči krilnega pilota na bok, kamor si risal';

  @override
  String get sigilDescHunter => 'Pokliči lovca, ki leti naprej in izbira tarče';

  @override
  String get sigilDescWarden => 'Pokliči varuha, ki prestreže strele zate';

  @override
  String get sigilDescFormation =>
      'Spremljevalci preklapljajo med široko in klinom';

  @override
  String get sigilDescWhirl =>
      'Spremljevalci krožijo okoli tebe in požirajo strele';

  @override
  String get sigilDescSacrifice =>
      'Spremljevalci se zaletijo in eksplodirajo, vrnejo naboj';

  @override
  String get grimoire => 'GRIMOAR';

  @override
  String get grimoireHint =>
      'Riši z desno palico. LB za OROŽJA, RB za KRILO, oba za MEGA UDAR.';

  @override
  String sigilCost(int cost) {
    return 'cena $cost';
  }

  @override
  String get sigilUntouchable => 'nedotakljiv';

  @override
  String get lessonWatch => 'GLEJ';

  @override
  String get lessonTrace => 'OBRIŠI';

  @override
  String get lessonSlow => 'POČASI';

  @override
  String get lessonLive => 'POLNA HITROST';

  @override
  String get lessonStreak => 'PET ZAPORED';

  @override
  String get lessonLearned => 'NAUČENO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Zamahni z desno palico';

  @override
  String get hintLoop => 'Nariši krog: preletiš strele';

  @override
  String get hintStream => 'Stisni LT: dva ali trije curki';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'BREZ';

  @override
  String kataNext(String sigil, String secs) {
    return 'naslednji $sigil čez $secs s';
  }

  @override
  String get arenaGauntlet => 'PREIZKUŠNJA';

  @override
  String get arenaOn => 'VKLOP';

  @override
  String get arenaOff => 'IZKLOP';

  @override
  String gauntletRating(int rating, int best) {
    return 'Ocena $rating · najboljše $best';
  }

  @override
  String get duelWarning => 'OPOZORILO';

  @override
  String get duelHintPad1 => 'Desna palica meri in strelja';

  @override
  String get duelHintPad2Rt => 'Drži RT, LB ali RB: desna palica riše sigile';

  @override
  String get duelHintPad2Lt => 'Drži LT, LB ali RB: desna palica riše sigile';

  @override
  String get duelHintClassic =>
      'Leva palica leti · B, RB ali RT streljajo, kamor kaže nos';

  @override
  String get duelHintKeys1 => 'Puščice merijo in streljajo · WASD leti';

  @override
  String get duelHintKeys2 =>
      'Preslednica strelja, kamor kaže nos · številčnica riše sigile';

  @override
  String get arenaDuelBinding => 'DVOBOJNA DRŽA';

  @override
  String get duelBindingRt => 'RT + PALICA';

  @override
  String get duelBindingLt => 'LT + PALICA';

  @override
  String get arenaDuelFrame => 'NAPREJ NA KRMILNIKU';

  @override
  String get duelFrameNose => 'NOS';

  @override
  String get duelFrameUp => 'GOR';

  @override
  String get arenaDuelAimFires => 'MERJENJE STRELJA';

  @override
  String get duelCutInFirst => 'BLIŽNJI POSNETEK BOSSA: PRVIČ';

  @override
  String get duelCutInAlways => 'BLIŽNJI POSNETEK BOSSA: VEDNO';

  @override
  String get duelCutInNever => 'BLIŽNJI POSNETEK BOSSA: NIKOLI';

  @override
  String get arenaDuelDrill => 'DVOBOJNA VAJA';

  @override
  String get duelDrillOff => 'BREZ';

  @override
  String get duelDrillAim => 'MERI IN STRELJAJ';

  @override
  String get duelDrillAimHow => 'Usmeri desno palico v bossa in ga zadeni';

  @override
  String get duelDrillHold => 'DRŽI NOS';

  @override
  String get duelDrillHoldHow => 'Drži gumb drže in leti: nos ostane na mestu';

  @override
  String get duelDrillDraw => 'RIŠI NAPREJ';

  @override
  String get duelDrillDrawHow => 'V drži nariši sigil proti bossu';

  @override
  String get duelDrillTurn => 'OBRNI SE';

  @override
  String get duelDrillTurnHow => 'Boss je pod teboj: obrni nos in ga zadeni';

  @override
  String get duelDrillDone => 'KONČANO';
}
