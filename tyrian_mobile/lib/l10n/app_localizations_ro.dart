// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANULEAZĂ';

  @override
  String get connect => 'CONECTEAZĂ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Nu s-a putut conecta la $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Gazda era vizibilă, dar legătura nu s-a stabilit.\n\nJocul în apropiere are nevoie de Wi-Fi peer-to-peer, pe care iOS îl oprește cât timp Hotspotul personal este pornit — opriți hotspotul pe ambele dispozitive și încercați din nou sau conectați ambele dispozitive la aceeași rețea Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Misiune eșuată — echipamentul și creditele rămân. Reîncercați din Centrul de comandă.';

  @override
  String get gameOverEndless =>
      'Reconstrucție în Sectorul 1 — echipamentul și creditele rămân';

  @override
  String get waitingForHost => 'Se așteaptă gazda...';

  @override
  String get waitingForHostHint => 'Jocul începe când gazda este pregătită';

  @override
  String get vesselLost => 'NAVĂ PIERDUTĂ';

  @override
  String scoreValue(String score) {
    return 'Scor: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Credite: $credits';
  }

  @override
  String get creditsPrefix => 'Credite: ';

  @override
  String get leaderboard => 'CLASAMENT';

  @override
  String get achievements => 'REALIZĂRI';

  @override
  String get redeploy => 'ÎNAPOI ÎN LUPTĂ';

  @override
  String get resume => 'CONTINUĂ';

  @override
  String get pause => 'PAUZĂ';

  @override
  String get paused => 'ÎN PAUZĂ';

  @override
  String get skins => 'SKINURI';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SUNET: PORNIT';

  @override
  String get soundOff => 'SUNET: OPRIT';

  @override
  String get musicOn => 'MUZICĂ: PORNITĂ';

  @override
  String get musicOff => 'MUZICĂ: OPRITĂ';

  @override
  String get mainMenu => 'MENIU PRINCIPAL';

  @override
  String get quitToDesktop => 'IEȘIRE PE DESKTOP';

  @override
  String get selectSkin => 'ALEGE SKINUL';

  @override
  String get difficulty => 'DIFICULTATE';

  @override
  String get difficultyEasy => 'UȘOR';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'GREU';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPANIE';

  @override
  String get quit => 'IEȘIRE';

  @override
  String get restorePurchases => 'RESTABILEȘTE ACHIZIȚIILE';

  @override
  String get locked => 'BLOCAT';

  @override
  String get mainMenuTooltip => 'Meniu principal';

  @override
  String nodeLevel(int level) {
    return 'NIVELUL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVELUL $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Blocat. Terminați mai întâi nodul anterior.';

  @override
  String get flyAgain => 'ZBOARĂ DIN NOU';

  @override
  String get launch => 'LANSARE';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'STEA';

  @override
  String get continueButton => 'CONTINUĂ';

  @override
  String get replayNode => 'REJOACĂ NODUL';

  @override
  String get retry => 'REÎNCEARCĂ';

  @override
  String get nodeCleared => 'NOD TERMINAT';

  @override
  String get nodeFailed => 'NOD EȘUAT';

  @override
  String get weaponTierUnlocked => 'NIVEL DE ARME DEBLOCAT';

  @override
  String get onSaleInComCenter => 'De vânzare în Centrul de comandă.';

  @override
  String get requiredTasksHint =>
      'Sarcinile obligatorii decid nodul. Zburați-l din nou — ce ați câștigat rămâne al vostru.';

  @override
  String get objClear => 'Curățați sectorul';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Doborâți $count de inamici',
      few: 'Doborâți $count inamici',
      one: 'Doborâți 1 inamic',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Nu suferiți nicio avarie la carenă';

  @override
  String objHull(int percent) {
    return 'Terminați cu carena peste $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Distrugeți $count de inamici cu $weapon',
      few: 'Distrugeți $count inamici cu $weapon',
      one: 'Distrugeți 1 inamic cu $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Distrugeți $count de inamici cu tunurile laterale',
      few: 'Distrugeți $count inamici cu tunurile laterale',
      one: 'Distrugeți 1 inamic cu tunurile laterale',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Decolați cu $weapon în față';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Decolați cu $weapon pe o montură laterală';
  }

  @override
  String get objBuySideGun => 'Cumpărați un tun lateral în Centrul de comandă';

  @override
  String objUpgradeGenerator(int level) {
    return 'Îmbunătățiți generatorul la nivelul $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Îmbunătățiți tunul frontal la nivelul $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Îmbunătățiți un tun lateral la nivelul $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prindeți $count de bonusuri',
      few: 'Prindeți $count bonusuri',
      one: 'Prindeți 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Distrugeți $count de formații întregi',
      few: 'Distrugeți $count formații întregi',
      one: 'Distrugeți 1 formație întreagă',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Nu loviți niciun asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Terminați în $seconds s';
  }

  @override
  String get objStripBoss =>
      'Distrugeți fiecare parte a bossului înaintea nucleului';

  @override
  String get joinCoopTitle => 'Intră în co-op';

  @override
  String get cannotSearchNetwork => 'Nu se poate căuta în această rețea';

  @override
  String get joinHintNearby =>
      'Aceeași rețea Wi-Fi merge pe orice dispozitiv. iPhone, iPad și Mac se găsesc și în apropiere fără ea — cu Hotspotul personal oprit pe ambele.';

  @override
  String get joinHintWifi =>
      'Ambii jucători trebuie să fie în aceeași rețea Wi-Fi — merge și un Hotspot personal.';

  @override
  String noHostsYet(String hint) {
    return 'Încă nicio gazdă. $hint';
  }

  @override
  String get lookingForHosts =>
      'Se caută gazde în această rețea Wi-Fi și în apropiere…';

  @override
  String get hostNearby => 'În apropiere · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · aceeași rețea Wi-Fi';
  }

  @override
  String get enterIpManually => 'Introdu IP-ul manual';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — PROTEJAT DE SCUT';
  }

  @override
  String get bossPartTurret => 'Turelă';

  @override
  String get bossPartShieldPod => 'Modul de scut';

  @override
  String get bossPartThruster => 'Propulsor';

  @override
  String get bossPartCannon => 'Tun';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sectorul $level — Spațiu necunoscut';
  }

  @override
  String get player2Joined => 'Jucătorul 2 s-a alăturat!';

  @override
  String get player2Disconnected => 'Jucătorul 2 s-a deconectat';

  @override
  String get hostDisconnected => 'Gazda s-a deconectat';

  @override
  String maxLevelSold(String amount) {
    return 'Nivel maxim! Vândut pentru \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Nivelul de arme $tier deblocat';
  }

  @override
  String get cheatsEnabled => 'Coduri activate';

  @override
  String get cheatsDisabled => 'Coduri dezactivate';

  @override
  String get cheatsMaxed => 'COD: credite la maximum, toate armele deblocate';

  @override
  String get cheats => 'CODURI';

  @override
  String get maxCredits => 'CREDITE MAXIME';

  @override
  String get sectionStats => 'STATISTICI';

  @override
  String get sectionLoadout => 'ECHIPAMENT';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ÎMB';

  @override
  String get sell => 'VINDE';

  @override
  String get buy => 'CUMPĂRĂ';

  @override
  String get commandCenter => 'CENTRUL DE COMANDĂ';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SCOR';

  @override
  String get nextWeapon => 'URMĂTOAREA ARMĂ';

  @override
  String pointsValue(String points) {
    return '$points pct';
  }

  @override
  String get slotFront => 'Față';

  @override
  String get slotLeft => 'Stânga';

  @override
  String get slotRight => 'Dreapta';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LANSEAZĂ MISIUNEA';

  @override
  String get startMission => 'ÎNCEPE MISIUNEA';

  @override
  String get continueMission => 'CONTINUĂ MISIUNEA';

  @override
  String get padControlsHint =>
      '[↑↓] Rând   [←→] Selecție   [B] Cumpără/Îmbunătățește/Schimbă   [X/Y] Vinde   [OPTIONS] Continuă misiunea';

  @override
  String get host => 'GĂZDUIEȘTE';

  @override
  String hostingAs(String name) {
    return 'GĂZDUIEȘTI ca $name';
  }

  @override
  String get join => 'ALĂTURĂ-TE';

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
  String get overload => 'SUPRASARCINĂ';

  @override
  String weaponOff(String weapon) {
    return '$weapon OPRIT — generator prea slab';
  }

  @override
  String unlocksAt(String points) {
    return 'Se deblochează la $points pct';
  }

  @override
  String joinConnecting(String target) {
    return 'Conectare la $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Gazda nu a răspuns: $reason.\n\nAmbii jucători trebuie să fie în aceeași rețea Wi-Fi (merge și un Hotspot personal), iar gazda trebuie să fi apăsat GĂZDUIEȘTE. Verificați adresa și încercați din nou.';
  }

  @override
  String get lanJoinNoAnswer => 'niciun răspuns';

  @override
  String objBossUnder(int seconds) {
    return 'Distrugeți nucleul bossului în $seconds s de la sosirea lui';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'SEIF';

  @override
  String get rackSide => 'Lateral';

  @override
  String get rackHull => 'Carenă';

  @override
  String get rarityCommon => 'COMUN';

  @override
  String get rarityRare => 'RAR';

  @override
  String get rarityMythic => 'MITIC';

  @override
  String get curse => 'BLESTEM';

  @override
  String get modFit => 'MONTEAZĂ';

  @override
  String get modUnfit => 'DEMONTEAZĂ';

  @override
  String get modForge => 'FORJĂ';

  @override
  String get forgeHint =>
      'Alegeți 3 de aceeași raritate pentru a forja 1 de raritatea următoare';

  @override
  String get vaultEmpty =>
      'Încă niciun mod. Terminați un nod cu toate stelele, învingeți repede un boss sau doborâți un boss în modul nesfârșit.';

  @override
  String modNeeds(String families) {
    return 'Merge cu $families';
  }

  @override
  String get modRackFull => 'Suport plin';

  @override
  String get modAlreadyFitted => 'Deja montat';

  @override
  String get modWrongRack => 'Nu se potrivește acestui suport';

  @override
  String modsSpilled(int n) {
    return 'Moduri înapoi în seif: $n';
  }

  @override
  String get hullLocked => 'Blocat';

  @override
  String hullUnlockBoss(int n) {
    return 'Învingeți bossul de campanie $n';
  }

  @override
  String get hullUnlockFinish =>
      'Terminați campania sau ajungeți în sectorul 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'ȚNT';

  @override
  String get perkNone => 'Navă de serie';

  @override
  String get perkAfterimage => 'Stați pe loc: focuri ×1,5';

  @override
  String get perkBulwark => 'Daunele trecute de scut se înjumătățesc';

  @override
  String get perkOverclock => 'Trage până la 130 % din capacitate, mai lent';

  @override
  String get perkBattery => 'O dronă de luptă gratuită vă însoțește';

  @override
  String get rewardTitle => 'RECOMPENSĂ';

  @override
  String newHull(String name) {
    return 'Carenă nouă: $name';
  }

  @override
  String get socketEmpty => 'gol';

  @override
  String fxStreams(int n) {
    return '$n fluxuri paralele';
  }

  @override
  String fxFan(int n) {
    return 'Evantai de $n focuri';
  }

  @override
  String fxSalvo(int n) {
    return 'Salvă de $n focuri';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadență ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Daune ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Viteza proiectilelor ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Mărimea proiectilelor ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consum de energie ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Ghidare +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Străpunge $n ținte';
  }

  @override
  String get fxPierceAll => 'Străpunge orice';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % șansă de daune ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Critice ×$x pe bossi';
  }

  @override
  String fxFork(int n) {
    return 'Doborârile împrăștie $n focuri';
  }

  @override
  String get fxChain => 'Focurile împrăștiate se împrăștie din nou';

  @override
  String get fxSplit => 'Se desparte în două la impact';

  @override
  String get fxFrost => 'Loviturile încetinesc inamicii';

  @override
  String get fxCrossfire => 'Tunurile laterale țintesc spre interior';

  @override
  String get fxRearguard => 'Tunurile laterale trag și înapoi';

  @override
  String get fxOrbit => 'Focurile șerpuiesc';

  @override
  String fxBounce(int n) {
    return 'Ricoșează din pereți de $n×';
  }

  @override
  String get fxBounceTop => '…și din partea de sus';

  @override
  String get fxOverdrive => 'Trage pe datorie de energie';

  @override
  String get fxReactor => 'Armele peste capacitate trag totuși, încet';

  @override
  String fxGenPower(String x) {
    return 'Reîncărcare generator ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacitate generator ×$x';
  }

  @override
  String get fxSurge => 'Generator plin: focuri ×2';

  @override
  String fxSiphon(int pct) {
    return 'Doborârile reîncarcă $pct % energie';
  }

  @override
  String fxHp(String x) {
    return 'Carenă ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Scut ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regenerare scut ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Doborârile vindecă $n HP';
  }

  @override
  String get fxMagnet => 'Atrage bonusurile';

  @override
  String get fxMagnetAll => 'Atrage orice bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % din focuri ricoșează din scut înapoi';
  }

  @override
  String get fxReflectGuided => 'Focurile reflectate se autoghidează';

  @override
  String fxGhost(String sec) {
    return 'Invulnerabil $sec s după o lovitură în carenă';
  }

  @override
  String get fxNova => 'Scutul cedează: tot ecranul încasează o explozie';

  @override
  String fxAgility(String x) {
    return 'Agilitate ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zonă de impact ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Credite ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Scor ×$x';
  }

  @override
  String get fxSatellite => 'O dronă de luptă vă însoțește';

  @override
  String get fxTimewarp => 'O lovitură în carenă încetinește timpul';

  @override
  String get fxGambler => 'Fiecare foc e o armă aleatorie';

  @override
  String get vaultAll => 'TOATE';
}
