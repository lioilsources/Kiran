// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'MÉGSE';

  @override
  String get connect => 'CSATLAKOZÁS';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Nem sikerült csatlakozni: $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'A gazda látható volt, de a kapcsolat nem jött létre.\n\nA közeli játékhoz peer-to-peer Wi-Fi kell, amelyet az iOS kikapcsol, amíg a Személyes hotspot be van kapcsolva — kapcsolja ki a hotspotot mindkét eszközön, és próbálja újra, vagy csatlakoztassa mindkét eszközt ugyanahhoz a Wi-Fi-hez.';

  @override
  String get gameOverCampaign =>
      'A küldetés elbukott — a felszerelés és a kreditek megmaradnak. Próbálja újra a Parancsnoki központból.';

  @override
  String get gameOverEndless =>
      'Újjáépítés az 1. szektorban — a felszerelés és a kreditek megmaradnak';

  @override
  String get waitingForHost => 'Várakozás a gazdára...';

  @override
  String get waitingForHostHint => 'A játék akkor indul, amikor a gazda kész';

  @override
  String get vesselLost => 'A HAJÓ ELVESZETT';

  @override
  String scoreValue(String score) {
    return 'Pontszám: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredit: $credits';
  }

  @override
  String get creditsPrefix => 'Kredit: ';

  @override
  String get leaderboard => 'RANGLISTA';

  @override
  String get achievements => 'EREDMÉNYEK';

  @override
  String get redeploy => 'VISSZA A HARCBA';

  @override
  String get resume => 'FOLYTATÁS';

  @override
  String get pause => 'SZÜNET';

  @override
  String get paused => 'SZÜNETEL';

  @override
  String get skins => 'SKINEK';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'HANG: BE';

  @override
  String get soundOff => 'HANG: KI';

  @override
  String get musicOn => 'ZENE: BE';

  @override
  String get musicOff => 'ZENE: KI';

  @override
  String get statsOn => 'STATISZTIKA: BE';

  @override
  String get statsOff => 'STATISZTIKA: KI';

  @override
  String get mainMenu => 'FŐMENÜ';

  @override
  String get quitToDesktop => 'KILÉPÉS AZ ASZTALRA';

  @override
  String get selectSkin => 'VÁLASSZ SKINT';

  @override
  String get difficulty => 'NEHÉZSÉG';

  @override
  String get difficultyEasy => 'KÖNNYŰ';

  @override
  String get difficultyNormal => 'NORMÁL';

  @override
  String get difficultyHard => 'NEHÉZ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'HADJÁRAT';

  @override
  String get quit => 'KILÉPÉS';

  @override
  String get restorePurchases => 'VÁSÁRLÁSOK VISSZAÁLLÍTÁSA';

  @override
  String get locked => 'ZÁROLVA';

  @override
  String get mainMenuTooltip => 'Főmenü';

  @override
  String nodeLevel(int level) {
    return '$level. SZINT';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return '$level. SZINT · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Zárolva. Előbb teljesítse az előző csomópontot.';

  @override
  String get flyAgain => 'REPÜLÉS ÚJRA';

  @override
  String get launch => 'INDÍTÁS';

  @override
  String zoneLabel(int zone) {
    return '$zone. ZÓNA';
  }

  @override
  String get objectiveStar => 'CSILLAG';

  @override
  String get continueButton => 'TOVÁBB';

  @override
  String get replayNode => 'CSOMÓPONT ÚJRA';

  @override
  String get retry => 'ÚJRA';

  @override
  String get nodeCleared => 'CSOMÓPONT TELJESÍTVE';

  @override
  String get nodeFailed => 'CSOMÓPONT ELBUKVA';

  @override
  String get weaponTierUnlocked => 'ÚJ FEGYVERSZINT FELOLDVA';

  @override
  String get onSaleInComCenter => 'Megvásárolható a Parancsnoki központban.';

  @override
  String get requiredTasksHint =>
      'A kötelező feladatok döntenek a csomópontról. Repüljön újra — amit megszerzett, megmarad.';

  @override
  String get objClear => 'Tisztítsa meg a szektort';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lőjön le $count ellenséget',
      one: 'Lőjön le 1 ellenséget',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ne sérüljön a hajótest';

  @override
  String objHull(int percent) {
    return 'Fejezze be $percent% feletti hajótesttel';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semmisítsen meg $count ellenséget ezzel: $weapon',
      one: 'Semmisítsen meg 1 ellenséget ezzel: $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semmisítsen meg $count ellenséget az oldalágyúkkal',
      one: 'Semmisítsen meg 1 ellenséget az oldalágyúkkal',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Induljon $weapon fegyverrel elöl';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Induljon $weapon fegyverrel oldalt';
  }

  @override
  String get objBuySideGun => 'Vegyen oldalágyút a Parancsnoki központban';

  @override
  String objUpgradeGenerator(int level) {
    return 'Fejlessze a generátort $level. szintre';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Fejlessze az elülső ágyút $level. szintre';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Fejlesszen egy oldalágyút $level. szintre';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gyűjtsön be $count bónuszt',
      one: 'Gyűjtsön be 1 bónuszt',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semmisítsen meg $count teljes alakzatot',
      one: 'Semmisítsen meg 1 teljes alakzatot',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ne ütközzön aszteroidának';

  @override
  String objUnderTime(int seconds) {
    return 'Fejezze be $seconds mp alatt';
  }

  @override
  String get objStripBoss => 'Semmisítse meg a boss minden részét a mag előtt';

  @override
  String get joinCoopTitle => 'Csatlakozás co-ophoz';

  @override
  String get cannotSearchNetwork => 'Ezen a hálózaton nem lehet keresni';

  @override
  String get joinHintNearby =>
      'Ugyanaz a Wi-Fi minden eszközön működik. Az iPhone, az iPad és a Mac a közelben nélküle is megtalálja egymást — mindkettőn kikapcsolt Személyes hotspottal.';

  @override
  String get joinHintWifi =>
      'Mindkét játékosnak ugyanazon a Wi-Fi-n kell lennie — a Személyes hotspot is megfelel.';

  @override
  String noHostsYet(String hint) {
    return 'Még nincs gazda. $hint';
  }

  @override
  String get lookingForHosts => 'Gazdák keresése ezen a Wi-Fi-n és a közelben…';

  @override
  String get hostNearby => 'Közel · Bluetooth / peer-to-peer Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · ugyanaz a Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP megadása kézzel';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'PAJ';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — PAJZS VÉDI';
  }

  @override
  String get bossPartTurret => 'Lövegtorony';

  @override
  String get bossPartShieldPod => 'Pajzsmodul';

  @override
  String get bossPartThruster => 'Hajtómű';

  @override
  String get bossPartCannon => 'Ágyú';

  @override
  String sectorUnknownSpace(int level) {
    return '$level. szektor — Ismeretlen űr';
  }

  @override
  String get player2Joined => 'A 2. játékos csatlakozott!';

  @override
  String get player2Disconnected => 'A 2. játékos kilépett';

  @override
  String get hostDisconnected => 'A gazda kilépett';

  @override
  String maxLevelSold(String amount) {
    return 'Max. szint! Eladva: \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return '$tier. fegyverszint feloldva';
  }

  @override
  String get cheatsEnabled => 'Csalások bekapcsolva';

  @override
  String get cheatsDisabled => 'Csalások kikapcsolva';

  @override
  String get cheatsMaxed =>
      'CSALÁS: kredit a maximumon, minden fegyver feloldva';

  @override
  String get cheats => 'CSALÁSOK';

  @override
  String get maxCredits => 'MAX. KREDIT';

  @override
  String get sectionStats => 'STATISZTIKA';

  @override
  String get sectionLoadout => 'FELSZERELÉS';

  @override
  String levelShort(int level) {
    return 'Sz.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'FEJL';

  @override
  String get sell => 'ELAD';

  @override
  String get buy => 'VESZ';

  @override
  String get commandCenter => 'PARANCSNOKI KÖZPONT';

  @override
  String get pilot => 'Pilóta';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PONTSZÁM';

  @override
  String get nextWeapon => 'KÖVETKEZŐ FEGYVER';

  @override
  String pointsValue(String points) {
    return '$points pont';
  }

  @override
  String get slotFront => 'Elöl';

  @override
  String get slotLeft => 'Bal';

  @override
  String get slotRight => 'Jobb';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'KÜLDETÉS INDÍTÁSA';

  @override
  String get startMission => 'KÜLDETÉS KEZDÉSE';

  @override
  String get continueMission => 'KÜLDETÉS FOLYTATÁSA';

  @override
  String get padControlsHint =>
      '[↑↓] Sor   [←→] Választás   [B] Vesz/Fejleszt/Vált   [X/Y] Elad   [OPTIONS] Küldetés folytatása';

  @override
  String get host => 'GAZDA';

  @override
  String hostingAs(String name) {
    return 'GAZDA: $name';
  }

  @override
  String get join => 'CSATLAKOZÁS';

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
  String get overload => 'TÚLTERHELÉS';

  @override
  String weaponOff(String weapon) {
    return '$weapon KI — túl gyenge a generátor';
  }

  @override
  String unlocksAt(String points) {
    return 'Feloldás $points pontnál';
  }

  @override
  String joinConnecting(String target) {
    return 'Csatlakozás: $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'A gazda nem válaszolt: $reason.\n\nMindkét játékosnak ugyanazon a Wi-Fi-n kell lennie (a Személyes hotspot is megfelel), és a gazdának meg kell nyomnia a GAZDA gombot. Ellenőrizze a címet, és próbálja újra.';
  }

  @override
  String get lanJoinNoAnswer => 'nincs válasz';

  @override
  String objBossUnder(int seconds) {
    return 'Semmisítse meg a boss magját $seconds mp-en belül a megjelenése után';
  }

  @override
  String get sectionHangar => 'HANGÁR';

  @override
  String get sectionVault => 'TREZOR';

  @override
  String get rackSide => 'Oldal';

  @override
  String get rackHull => 'Hajótest';

  @override
  String get rarityCommon => 'GYAKORI';

  @override
  String get rarityRare => 'RITKA';

  @override
  String get rarityMythic => 'MITIKUS';

  @override
  String get curse => 'ÁTOK';

  @override
  String get modFit => 'BESZERELÉS';

  @override
  String get modUnfit => 'KISZERELÉS';

  @override
  String get modForge => 'KOVÁCSMŰHELY';

  @override
  String get forgeHint =>
      'Válasszon 3 egyforma ritkaságút, hogy 1 következőt kovácsoljon';

  @override
  String get vaultEmpty =>
      'Még nincs mod. Teljesítsen egy csomópontot minden csillaggal, győzzön le gyorsan egy bosst, vagy lőjön le egy bosst a végtelen módban.';

  @override
  String modNeeds(String families) {
    return 'Működik ezekkel: $families';
  }

  @override
  String get modRackFull => 'A tartó megtelt';

  @override
  String get modAlreadyFitted => 'Már beszerelve';

  @override
  String get modWrongRack => 'Nem illik ebbe a tartóba';

  @override
  String modsSpilled(int n) {
    return '$n mod vissza a trezorba';
  }

  @override
  String get hullLocked => 'Zárolva';

  @override
  String hullUnlockBoss(int n) {
    return 'Győzze le a hadjárat $n. bossát';
  }

  @override
  String get hullUnlockFinish =>
      'Fejezze be a hadjáratot, vagy érje el a 30. szektort';

  @override
  String get statAgility => 'MOZ';

  @override
  String get statHitbox => 'TAL';

  @override
  String get perkNone => 'Gyári hajó';

  @override
  String get perkAfterimage => 'Álljon meg: lövések ×1,5';

  @override
  String get perkBulwark => 'A pajzson átjutó sebzés felére csökken';

  @override
  String get perkOverclock => 'A kapacitás 130 %-áig lő, lassabban';

  @override
  String get perkBattery => 'Egy ingyenes harci drón kíséri';

  @override
  String get rewardTitle => 'JUTALOM';

  @override
  String newHull(String name) {
    return 'Új hajótest: $name';
  }

  @override
  String get socketEmpty => 'üres';

  @override
  String fxStreams(int n) {
    return '$n párhuzamos sugár';
  }

  @override
  String fxFan(int n) {
    return '$n lövéses legyező';
  }

  @override
  String fxSalvo(int n) {
    return '$n lövéses sortűz';
  }

  @override
  String fxFireRate(String x) {
    return 'Tűzgyorsaság ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Sebzés ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Lövedéksebesség ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Lövedékméret ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energiafogyasztás ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Célkövetés +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n célponton hatol át';
  }

  @override
  String get fxPierceAll => 'Mindenen áthatol';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % esély ×$x sebzésre';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kritikus a bossokon';
  }

  @override
  String fxFork(int n) {
    return 'A találatok $n lövést szórnak szét';
  }

  @override
  String get fxChain => 'A szórt lövések újra szóródnak';

  @override
  String get fxSplit => 'Találatkor kettéválik';

  @override
  String get fxFrost => 'A találatok lelassítják az ellenséget';

  @override
  String get fxCrossfire => 'Az oldalágyúk befelé céloznak';

  @override
  String get fxRearguard => 'Az oldalágyúk hátrafelé is lőnek';

  @override
  String get fxOrbit => 'A lövések kígyóznak';

  @override
  String fxBounce(int n) {
    return '$n× visszapattan a falakról';
  }

  @override
  String get fxBounceTop => '…és a tetejéről is';

  @override
  String get fxOverdrive => 'Energiaadósságra is lő';

  @override
  String get fxReactor => 'A kapacitás feletti fegyverek is lőnek, lassan';

  @override
  String fxGenPower(String x) {
    return 'Generátortöltés ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generátorkapacitás ×$x';
  }

  @override
  String get fxSurge => 'Teli generátor: lövések ×2';

  @override
  String fxSiphon(int pct) {
    return 'A találatok $pct % energiát töltenek vissza';
  }

  @override
  String fxHp(String x) {
    return 'Hajótest ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Pajzs ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Pajzsregeneráció ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'A találatok $n HP-t gyógyítanak';
  }

  @override
  String get fxMagnet => 'Magához vonzza a bónuszokat';

  @override
  String get fxMagnetAll => 'Minden bónuszt magához vonz';

  @override
  String fxReflect(int pct) {
    return 'A pajzsról a lövések $pct %-a visszarepül';
  }

  @override
  String get fxReflectGuided => 'A visszavert lövések célt követnek';

  @override
  String fxGhost(String sec) {
    return 'Sérthetetlen $sec mp-ig a hajótest találata után';
  }

  @override
  String get fxNova => 'Megtört pajzs: robbanás az egész képernyőn';

  @override
  String fxAgility(String x) {
    return 'Mozgékonyság ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Találati zóna ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kredit ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Pontszám ×$x';
  }

  @override
  String get fxSatellite => 'Egy harci drón kíséri';

  @override
  String get fxTimewarp => 'A hajótest találata lelassítja az időt';

  @override
  String get fxGambler => 'Minden lövés véletlen fegyver';

  @override
  String get vaultAll => 'MIND';

  @override
  String get sigilMissUnknown => 'ismeretlen alakzat';

  @override
  String get sigilMissTooSlow => 'túl lassú';

  @override
  String get sigilMissSkippedDot => 'kihagyott egy pontot';

  @override
  String get sigilMissLeftRimEarly => 'túl korán elengedted';

  @override
  String get sigilMissWrongDirection => 'fordítva rajzolva';

  @override
  String get sigilMissWrongLayer => 'rossz vállgomb';

  @override
  String get sigilDry => 'nincs elég töltés';

  @override
  String get sigilBusy => 'az előző még fut';

  @override
  String get arena => 'ARÉNA';

  @override
  String get arenaBossParts => 'BOSS RÉSZEK';

  @override
  String get arenaBareCore => 'csupasz mag';

  @override
  String get arenaCompanions => 'KÍSÉRŐK';

  @override
  String get arenaCharge => 'TÖLTÉS';

  @override
  String get arenaChargeNormal => 'NORMÁL';

  @override
  String get arenaSpeed => 'VILÁG SEBESSÉGE';

  @override
  String get arenaDrill => 'GYAKORLÁS';

  @override
  String get arenaFreePlay => 'SZABAD JÁTÉK';

  @override
  String get arenaFight => 'HARC';

  @override
  String get arenaNewBoss => 'ÚJ BOSS';

  @override
  String get arenaLeave => 'ARÉNA ELHAGYÁSA';

  @override
  String get arenaHint =>
      'A boss halála pillanatában visszatér. Itt semmi sem mentődik.';

  @override
  String get arenaColCast => 'VARÁZS';

  @override
  String get arenaColMiss => 'HIBA';

  @override
  String get arenaColAvg => 'ÁTL';

  @override
  String get arenaColBest => 'LEGJOBB';

  @override
  String get arenaColTime => 'LEGGYORSABB';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossok $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: JELEK';

  @override
  String get padSchemeClassic => 'PAD: KLASSZIKUS';

  @override
  String get padSouthpawOn => 'BALKEZES: BE';

  @override
  String get padSouthpawOff => 'BALKEZES: KI';

  @override
  String get sigilDescHop => 'Gyors szökkenés a pöccintés irányába';

  @override
  String get sigilDescSidestep => 'Hosszú oldallépés a pályán át';

  @override
  String get sigilDescStrike => 'Előrerontás három erős lövéssel, majd vissza';

  @override
  String get sigilDescRetreat => 'Hátrálás, miközben a fedezőtűz előre megy';

  @override
  String get sigilDescDash => 'Átlós kitörés a tűzön át, közben sérthetetlen';

  @override
  String get sigilDescRoll => 'Orsózás oldalra, sérthetetlen';

  @override
  String get sigilDescShadow => 'Rátapad a legközelebbi ellenség alá és tüzel';

  @override
  String get sigilDescEcho =>
      'Egy árny félsebzéssel ismétli az utolsó két másodperced';

  @override
  String get sigilDescLoop => 'Bukfenc felül: a lövések alattad mennek el';

  @override
  String get sigilDescSlalom => 'S-kanyar a pályán át legyezőtűzzel';

  @override
  String get sigilDescCorkscrew => 'Dugóhúzó előre, körkörös tűz, sérthetetlen';

  @override
  String get sigilDescSnapshot => 'Egy erős lövés a pöccintés irányába';

  @override
  String get sigilDescBroadside => 'Sortűz mindkét oldalról';

  @override
  String get sigilDescVolley => 'Öt feltöltött sugár előre';

  @override
  String get sigilDescCaltrop => 'Akna, ami elnyeli a lövéseket és felrobban';

  @override
  String get sigilDescFrenzy =>
      'Pár másodpercig gyorsabban tüzelnek a fegyverek';

  @override
  String get sigilDescStasis =>
      'Az ellenség és lövései fél sebességre lassulnak';

  @override
  String get sigilDescHalo =>
      'A pajzs négyszer gyorsabban töltődik, és semmi sem jut át';

  @override
  String get sigilDescRadial => 'Tizenhat lövésből álló gyűrű';

  @override
  String get sigilDescStorm => 'Minden fegyver teljes erővel tüzel, ingyen';

  @override
  String get sigilDescPing => 'A kísérők oda tüzelnek, ahová pöccintesz';

  @override
  String get sigilDescWingman => 'Szárnysegéd hívása a rajzolt oldalra';

  @override
  String get sigilDescHunter =>
      'Vadász hívása, ami előre repül és célt választ';

  @override
  String get sigilDescWarden =>
      'Őrző hívása, ami felfogja a neked szánt lövéseket';

  @override
  String get sigilDescFormation =>
      'A kísérők széles és ék alakzat között váltanak';

  @override
  String get sigilDescWhirl =>
      'A kísérők körülötted keringenek és elnyelik a lövéseket';

  @override
  String get sigilDescSacrifice =>
      'A kísérők lecsapnak és felrobbannak, töltést visszaadva';

  @override
  String get grimoire => 'GRIMOÁR';

  @override
  String get grimoireHint =>
      'Rajzolj a jobb karral. LB: ARMS, RB: WING, mindkettő: MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'ár $cost';
  }

  @override
  String get sigilUntouchable => 'sérthetetlen';

  @override
  String get lessonWatch => 'NÉZD';

  @override
  String get lessonTrace => 'RAJZOLD UTÁNA';

  @override
  String get lessonSlow => 'LASSÚ';

  @override
  String get lessonLive => 'TELJES SEBESSÉG';

  @override
  String get lessonStreak => 'ÖTÖT EGYMÁS UTÁN';

  @override
  String get lessonLearned => 'MEGTANULVA';

  @override
  String lessonTempo(int pct) {
    return 'TEMPÓ $pct %';
  }

  @override
  String get hintHop => 'Pöccintsd a jobb kart';

  @override
  String get hintLoop => 'Rajzolj kört: átrepülsz a lövések felett';

  @override
  String get hintStream => 'Nyomd az LT-t: két-három sugár';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NINCS';

  @override
  String kataNext(String sigil, String secs) {
    return 'következő $sigil $secs mp múlva';
  }

  @override
  String get arenaGauntlet => 'KESZTYŰ';

  @override
  String get arenaOn => 'BE';

  @override
  String get arenaOff => 'KI';

  @override
  String gauntletRating(int rating, int best) {
    return 'Értékelés $rating · legjobb $best';
  }

  @override
  String get duelWarning => 'FIGYELEM';

  @override
  String get duelHintPad1 => 'A jobb kar céloz és tüzel';

  @override
  String get duelHintPad2Rt =>
      'Tartsd az RT-t, LB-t vagy RB-t: a jobb kar jeleket rajzol';

  @override
  String get duelHintPad2Lt =>
      'Tartsd az LT-t, LB-t vagy RB-t: a jobb kar jeleket rajzol';

  @override
  String get duelHintClassic =>
      'Bal kar repül · B, RB vagy RT az orr irányába tüzel';

  @override
  String get duelHintKeys1 => 'Nyilak: célzás és tűz · WASD: repülés';

  @override
  String get duelHintKeys2 =>
      'Szóköz az orr irányába tüzel · a numerikus billentyűzet jeleket rajzol';

  @override
  String get arenaDuelBinding => 'PÁRBAJ TARTÁS';

  @override
  String get duelBindingRt => 'RT + KAR';

  @override
  String get duelBindingLt => 'LT + KAR';

  @override
  String get arenaDuelFrame => 'PAD ELŐRE';

  @override
  String get duelFrameNose => 'AZ ORR';

  @override
  String get duelFrameUp => 'FEL';

  @override
  String get arenaDuelAimFires => 'CÉLZÁS TÜZEL';

  @override
  String get duelCutInFirst => 'BOSS KÖZELI: ELSŐ ALKALOM';

  @override
  String get duelCutInAlways => 'BOSS KÖZELI: MINDIG';

  @override
  String get duelCutInNever => 'BOSS KÖZELI: SOHA';

  @override
  String get arenaDuelDrill => 'PÁRBAJ GYAKORLÁS';

  @override
  String get duelDrillOff => 'NINCS';

  @override
  String get duelDrillAim => 'CÉLOZZ ÉS LŐJ';

  @override
  String get duelDrillAimHow => 'Fordítsd a jobb kart a bossra és találd el';

  @override
  String get duelDrillHold => 'TARTSD AZ ORRT';

  @override
  String get duelDrillHoldHow =>
      'Tarts egy tartásgombot és repülj: az orr helyben marad';

  @override
  String get duelDrillDraw => 'RAJZOLJ ELŐRE';

  @override
  String get duelDrillDrawHow => 'Tartásban rajzolj jelet a boss felé';

  @override
  String get duelDrillTurn => 'FORDULJ MEG';

  @override
  String get duelDrillTurnHow =>
      'A boss alattad van: fordítsd az orrt és találd el';

  @override
  String get duelDrillDone => 'KÉSZ';

  @override
  String get swapHint => 'Koppints egy második ujjal a fegyvercseréhez';
}
