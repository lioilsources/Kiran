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
  String get statsOn => 'STATISTICI: PORNITE';

  @override
  String get statsOff => 'STATISTICI: OPRITE';

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

  @override
  String get sigilMissUnknown => 'formă necunoscută';

  @override
  String get sigilMissTooSlow => 'prea încet';

  @override
  String get sigilMissSkippedDot => 'ai sărit un punct';

  @override
  String get sigilMissLeftRimEarly => 'eliberat prea devreme';

  @override
  String get sigilMissWrongDirection => 'desenat invers';

  @override
  String get sigilMissWrongLayer => 'buton de umăr greșit';

  @override
  String get sigilDry => 'încărcare insuficientă';

  @override
  String get sigilBusy => 'cel anterior încă rulează';

  @override
  String get arena => 'ARENĂ';

  @override
  String get arenaBossParts => 'PĂRȚI DE BOSS';

  @override
  String get arenaBareCore => 'nucleu expus';

  @override
  String get arenaCompanions => 'ÎNSOȚITORI';

  @override
  String get arenaCharge => 'ÎNCĂRCARE';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VITEZA LUMII';

  @override
  String get arenaDrill => 'EXERCIȚIU';

  @override
  String get arenaFreePlay => 'JOC LIBER';

  @override
  String get arenaFight => 'LUPTĂ';

  @override
  String get arenaNewBoss => 'BOSS NOU';

  @override
  String get arenaLeave => 'IEȘI DIN ARENĂ';

  @override
  String get arenaHint =>
      'Bossul revine imediat ce moare. Nimic de aici nu se salvează.';

  @override
  String get arenaColCast => 'FOLOSIRI';

  @override
  String get arenaColMiss => 'RATĂRI';

  @override
  String get arenaColAvg => 'MEDIE';

  @override
  String get arenaColBest => 'RECORD';

  @override
  String get arenaColTime => 'CEL MAI RAPID';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Boși $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILII';

  @override
  String get padSchemeClassic => 'PAD: CLASIC';

  @override
  String get padSouthpawOn => 'STÂNGACI: DA';

  @override
  String get padSouthpawOff => 'STÂNGACI: NU';

  @override
  String get sigilDescHop => 'Un salt rapid în direcția gestului';

  @override
  String get sigilDescSidestep => 'Un pas lateral lung peste câmp';

  @override
  String get sigilDescStrike =>
      'Atac înainte cu trei focuri grele, apoi înapoi';

  @override
  String get sigilDescRetreat => 'Retragere cu foc de acoperire înainte';

  @override
  String get sigilDescDash =>
      'Țâșnire diagonală prin foc, intangibil la mijloc';

  @override
  String get sigilDescRoll => 'Un tonou lateral, intangibil';

  @override
  String get sigilDescShadow =>
      'Fixare sub cel mai apropiat inamic, cu foc continuu';

  @override
  String get sigilDescEcho =>
      'O umbră îți repetă ultimele două secunde cu daune înjumătățite';

  @override
  String get sigilDescLoop => 'Looping pe deasupra: focurile trec pe dedesubt';

  @override
  String get sigilDescSlalom => 'O curbă în S peste câmp cu foc în evantai';

  @override
  String get sigilDescCorkscrew => 'Tirbușon înainte cu foc în jur, intangibil';

  @override
  String get sigilDescSnapshot => 'Un foc greu în direcția gestului';

  @override
  String get sigilDescBroadside => 'O salvă din ambele flancuri';

  @override
  String get sigilDescVolley => 'Cinci raze încărcate înainte';

  @override
  String get sigilDescCaltrop =>
      'Lasă o mină care înghite focuri și explodează';

  @override
  String get sigilDescFrenzy => 'Armele trag mai repede câteva secunde';

  @override
  String get sigilDescStasis =>
      'Inamicii și focurile lor încetinesc la jumătate';

  @override
  String get sigilDescHalo =>
      'Scutul se reîncarcă de patru ori mai repede și nimic nu trece';

  @override
  String get sigilDescRadial => 'Un inel de șaisprezece focuri';

  @override
  String get sigilDescStorm => 'Toate armele trag la maximum, gratuit';

  @override
  String get sigilDescPing =>
      'Însoțitorii concentrează focul în direcția gestului';

  @override
  String get sigilDescWingman => 'Cheamă un coechipier pe flancul desenat';

  @override
  String get sigilDescHunter =>
      'Cheamă un vânător care zboară înainte și alege ținte';

  @override
  String get sigilDescWarden =>
      'Cheamă un gardian care primește focurile în locul tău';

  @override
  String get sigilDescFormation => 'Însoțitorii comută între larg și pană';

  @override
  String get sigilDescWhirl =>
      'Însoțitorii se rotesc în jurul tău și absorb focuri';

  @override
  String get sigilDescSacrifice =>
      'Însoțitorii plonjează și explodează, returnând încărcare';

  @override
  String get grimoire => 'GRIMOAR';

  @override
  String get grimoireHint =>
      'Desenează cu stickul drept. LB pentru ARME, RB pentru ARIPĂ, ambele pentru MEGA EXPLOZIE.';

  @override
  String sigilCost(int cost) {
    return 'cost $cost';
  }

  @override
  String get sigilUntouchable => 'intangibil';

  @override
  String get lessonWatch => 'PRIVEȘTE';

  @override
  String get lessonTrace => 'DESENEAZĂ';

  @override
  String get lessonSlow => 'ÎNCET';

  @override
  String get lessonLive => 'VITEZĂ MAXIMĂ';

  @override
  String get lessonStreak => 'CINCI LA RÂND';

  @override
  String get lessonLearned => 'ÎNVĂȚAT';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Mișcă scurt stickul drept';

  @override
  String get hintLoop => 'Desenează un cerc: zbori peste focuri';

  @override
  String get hintStream => 'Apasă LT: două sau trei fascicule';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NICIUNA';

  @override
  String kataNext(String sigil, String secs) {
    return 'următorul $sigil în $secs s';
  }

  @override
  String get arenaGauntlet => 'PROBA DE FOC';

  @override
  String get arenaOn => 'DA';

  @override
  String get arenaOff => 'NU';

  @override
  String gauntletRating(int rating, int best) {
    return 'Scor $rating · record $best';
  }

  @override
  String get duelWarning => 'ATENȚIE';

  @override
  String get duelHintPad1 => 'Stickul drept țintește și trage';

  @override
  String get duelHintPad2Rt =>
      'Ține RT, LB sau RB: stickul drept desenează sigilii';

  @override
  String get duelHintPad2Lt =>
      'Ține LT, LB sau RB: stickul drept desenează sigilii';

  @override
  String get duelHintClassic =>
      'Stickul stâng zboară · B, RB sau RT trag unde arată botul';

  @override
  String get duelHintKeys1 => 'Săgețile țintesc și trag · WASD zboară';

  @override
  String get duelHintKeys2 =>
      'Space trage unde arată botul · tastatura numerică desenează sigilii';

  @override
  String get arenaDuelBinding => 'POZIȚIE DE DUEL';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'ÎNAINTE PE PAD';

  @override
  String get duelFrameNose => 'BOTUL';

  @override
  String get duelFrameUp => 'SUS';

  @override
  String get arenaDuelAimFires => 'ȚINTIREA TRAGE';

  @override
  String get duelCutInFirst => 'PRIM-PLAN BOSS: PRIMA DATĂ';

  @override
  String get duelCutInAlways => 'PRIM-PLAN BOSS: MEREU';

  @override
  String get duelCutInNever => 'PRIM-PLAN BOSS: NICIODATĂ';

  @override
  String get arenaDuelDrill => 'EXERCIȚIU DE DUEL';

  @override
  String get duelDrillOff => 'NICIUNUL';

  @override
  String get duelDrillAim => 'ȚINTEȘTE ȘI TRAGE';

  @override
  String get duelDrillAimHow =>
      'Îndreaptă stickul drept spre boss și lovește-l';

  @override
  String get duelDrillHold => 'ȚINE BOTUL';

  @override
  String get duelDrillHoldHow =>
      'Ține un buton de poziție și zboară: botul rămâne fix';

  @override
  String get duelDrillDraw => 'DESENEAZĂ ÎNAINTE';

  @override
  String get duelDrillDrawHow => 'În poziție, desenează un sigiliu spre boss';

  @override
  String get duelDrillTurn => 'ÎNTOARCE-TE';

  @override
  String get duelDrillTurnHow =>
      'Bossul e sub tine: întoarce botul și lovește-l';

  @override
  String get duelDrillDone => 'GATA';

  @override
  String get swapHint => 'Atinge cu un al doilea deget ca să schimbi armele';
}
