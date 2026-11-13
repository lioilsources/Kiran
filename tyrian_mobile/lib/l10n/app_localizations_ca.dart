// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get ok => 'D\'ACORD';

  @override
  String get cancel => 'CANCEL·LA';

  @override
  String get connect => 'CONNECTA';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'No s\'ha pogut connectar a $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'L\'amfitrió era visible, però l\'enllaç no s\'ha establert.\n\nEl joc a prop necessita Wi-Fi d\'igual a igual, que l\'iOS desactiva mentre el Punt d\'accés personal és actiu — desactiva el punt d\'accés als dos dispositius i torna-ho a provar, o connecta tots dos dispositius a la mateixa Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Missió fallida — equipament i crèdits conservats. Torna-ho a provar des del Centre de comandament.';

  @override
  String get gameOverEndless =>
      'Reconstruint al Sector 1 — equipament i crèdits conservats';

  @override
  String get waitingForHost => 'Esperant l\'amfitrió...';

  @override
  String get waitingForHostHint =>
      'La partida començarà quan l\'amfitrió estigui a punt';

  @override
  String get vesselLost => 'NAU PERDUDA';

  @override
  String scoreValue(String score) {
    return 'Puntuació: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Crèdits: $credits';
  }

  @override
  String get creditsPrefix => 'Crèdits: ';

  @override
  String get leaderboard => 'CLASSIFICACIÓ';

  @override
  String get achievements => 'ASSOLIMENTS';

  @override
  String get redeploy => 'TORNA AL COMBAT';

  @override
  String get resume => 'CONTINUA';

  @override
  String get pause => 'PAUSA';

  @override
  String get paused => 'EN PAUSA';

  @override
  String get skins => 'ASPECTES';

  @override
  String get skin => 'ASPECTE';

  @override
  String get soundOn => 'SO: ACTIVAT';

  @override
  String get soundOff => 'SO: DESACTIVAT';

  @override
  String get musicOn => 'MÚSICA: ACTIVADA';

  @override
  String get musicOff => 'MÚSICA: DESACTIVADA';

  @override
  String get mainMenu => 'MENÚ PRINCIPAL';

  @override
  String get quitToDesktop => 'SURT A L\'ESCRIPTORI';

  @override
  String get selectSkin => 'TRIA L\'ASPECTE';

  @override
  String get difficulty => 'DIFICULTAT';

  @override
  String get difficultyEasy => 'FÀCIL';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'DIFÍCIL';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPANYA';

  @override
  String get quit => 'SURT';

  @override
  String get restorePurchases => 'RESTAURA LES COMPRES';

  @override
  String get locked => 'BLOQUEJAT';

  @override
  String get mainMenuTooltip => 'Menú principal';

  @override
  String nodeLevel(int level) {
    return 'NIVELL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVELL $level · CAP $ordinal';
  }

  @override
  String get nodeLockedHint => 'Bloquejat. Supera primer el node anterior.';

  @override
  String get flyAgain => 'VOLA DE NOU';

  @override
  String get launch => 'ENLAIRA\'T';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'ESTRELLA';

  @override
  String get continueButton => 'CONTINUA';

  @override
  String get replayNode => 'REPETEIX EL NODE';

  @override
  String get retry => 'TORNA-HO A PROVAR';

  @override
  String get nodeCleared => 'NODE SUPERAT';

  @override
  String get nodeFailed => 'NODE FALLIT';

  @override
  String get weaponTierUnlocked => 'NIVELL D\'ARMES DESBLOQUEJAT';

  @override
  String get onSaleInComCenter => 'A la venda al Centre de comandament.';

  @override
  String get requiredTasksHint =>
      'Les tasques obligatòries decideixen el node. Torna-hi a volar — el que has guanyat és teu.';

  @override
  String get objClear => 'Neteja el sector';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abat $count enemics',
      one: 'Abat 1 enemic',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'No rebis danys al buc';

  @override
  String objHull(int percent) {
    return 'Acaba amb més del $percent% de buc';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina\'n $count amb el $weapon',
      one: 'Elimina\'n 1 amb el $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina\'n $count amb els canons laterals',
      one: 'Elimina\'n 1 amb els canons laterals',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Enlaira\'t amb el $weapon al davant';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Enlaira\'t amb el $weapon en un suport lateral';
  }

  @override
  String get objBuySideGun => 'Compra un canó lateral al Centre de comandament';

  @override
  String objUpgradeGenerator(int level) {
    return 'Millora el generador fins al nivell $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Millora el canó frontal fins al nivell $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Millora un canó lateral fins al nivell $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Agafa $count bonificacions',
      one: 'Agafa 1 bonificació',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Destrueix $count formacions senceres',
      one: 'Destrueix 1 formació sencera',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'No xoquis amb cap asteroide';

  @override
  String objUnderTime(int seconds) {
    return 'Acaba en menys de $seconds s';
  }

  @override
  String get objStripBoss =>
      'Destrueix totes les parts del cap abans del nucli';

  @override
  String get joinCoopTitle => 'Uneix-te al cooperatiu';

  @override
  String get cannotSearchNetwork => 'No es pot cercar en aquesta xarxa';

  @override
  String get joinHintNearby =>
      'La mateixa Wi-Fi funciona en qualsevol dispositiu. L\'iPhone, l\'iPad i el Mac també es troben a prop sense Wi-Fi — amb el Punt d\'accés personal desactivat a tots dos.';

  @override
  String get joinHintWifi =>
      'Tots dos jugadors han d\'estar a la mateixa Wi-Fi — també funciona un Punt d\'accés personal.';

  @override
  String noHostsYet(String hint) {
    return 'Encara no hi ha amfitrions. $hint';
  }

  @override
  String get lookingForHosts => 'Cercant amfitrions en aquesta Wi-Fi i a prop…';

  @override
  String get hostNearby => 'A prop · Bluetooth / Wi-Fi d\'igual a igual';

  @override
  String hostSameWifi(String address) {
    return '$address · mateixa Wi-Fi';
  }

  @override
  String get enterIpManually => 'Introdueix la IP manualment';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — AMB ESCUT';
  }

  @override
  String get bossPartTurret => 'Torreta';

  @override
  String get bossPartShieldPod => 'Mòdul d\'escut';

  @override
  String get bossPartThruster => 'Propulsor';

  @override
  String get bossPartCannon => 'Canó';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sector $level — Espai desconegut';
  }

  @override
  String get player2Joined => 'El jugador 2 s\'ha unit!';

  @override
  String get player2Disconnected => 'El jugador 2 s\'ha desconnectat';

  @override
  String get hostDisconnected => 'L\'amfitrió s\'ha desconnectat';

  @override
  String maxLevelSold(String amount) {
    return 'Nivell màxim! Venut per \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Nivell d\'armes $tier desbloquejat';
  }

  @override
  String get cheatsEnabled => 'Trucs activats';

  @override
  String get cheatsDisabled => 'Trucs desactivats';

  @override
  String get cheatsMaxed =>
      'TRUC: crèdits al màxim, totes les armes desbloquejades';

  @override
  String get cheats => 'TRUCS';

  @override
  String get maxCredits => 'CRÈDITS MÀXIMS';

  @override
  String get sectionStats => 'ESTADÍSTIQUES';

  @override
  String get sectionLoadout => 'EQUIPAMENT';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MÀX';

  @override
  String get upgradeShort => 'MILL';

  @override
  String get sell => 'VEN';

  @override
  String get buy => 'COMPRA';

  @override
  String get commandCenter => 'CENTRE DE COMANDAMENT';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUNTUACIÓ';

  @override
  String get nextWeapon => 'ARMA SEGÜENT';

  @override
  String pointsValue(String points) {
    return '$points pts';
  }

  @override
  String get slotFront => 'Davant';

  @override
  String get slotLeft => 'Esquerra';

  @override
  String get slotRight => 'Dreta';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LLANÇA LA MISSIÓ';

  @override
  String get startMission => 'COMENÇA LA MISSIÓ';

  @override
  String get continueMission => 'CONTINUA LA MISSIÓ';

  @override
  String get padControlsHint =>
      '[↑↓] Fila   [←→] Tria   [B] Compra/Millora/Canvia   [X/Y] Ven   [OPTIONS] Continua la missió';

  @override
  String get host => 'AMFITRIÓ';

  @override
  String hostingAs(String name) {
    return 'AMFITRIÓ com a $name';
  }

  @override
  String get join => 'UNEIX-T\'HI';

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
  String get overload => 'SOBRECÀRREGA';

  @override
  String weaponOff(String weapon) {
    return '$weapon DESACTIVAT — generador massa feble';
  }

  @override
  String unlocksAt(String points) {
    return 'Es desbloqueja amb $points pts';
  }

  @override
  String joinConnecting(String target) {
    return 'Connectant a $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'L\'amfitrió no ha respost: $reason.\n\nTots dos jugadors han d\'estar a la mateixa Wi-Fi (també funciona un Punt d\'accés personal) i l\'amfitrió ha d\'haver premut AMFITRIÓ. Comprova l\'adreça i torna-ho a provar.';
  }

  @override
  String get lanJoinNoAnswer => 'sense resposta';

  @override
  String objBossUnder(int seconds) {
    return 'Destrueix el nucli del cap en $seconds s des que arriba';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'CAMBRA';

  @override
  String get rackSide => 'Lateral';

  @override
  String get rackHull => 'Buc';

  @override
  String get rarityCommon => 'COMÚ';

  @override
  String get rarityRare => 'RAR';

  @override
  String get rarityMythic => 'MÍTIC';

  @override
  String get curse => 'MALEDICCIÓ';

  @override
  String get modFit => 'MUNTA';

  @override
  String get modUnfit => 'DESMUNTA';

  @override
  String get modForge => 'FARGA';

  @override
  String get forgeHint =>
      'Tria\'n 3 d\'una raresa per forjar-ne 1 de la següent';

  @override
  String get vaultEmpty =>
      'Encara no tens mods. Supera un node amb totes les estrelles, venç un cap ràpidament o abat un cap en mode infinit.';

  @override
  String modNeeds(String families) {
    return 'Funciona amb $families';
  }

  @override
  String get modRackFull => 'Suport ple';

  @override
  String get modAlreadyFitted => 'Ja muntat';

  @override
  String get modWrongRack => 'No encaixa en aquest suport';

  @override
  String modsSpilled(int n) {
    return '$n mods tornen a la cambra';
  }

  @override
  String get hullLocked => 'Bloquejat';

  @override
  String hullUnlockBoss(int n) {
    return 'Venç el cap de campanya $n';
  }

  @override
  String get hullUnlockFinish => 'Acaba la campanya o arriba al sector 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'IMP';

  @override
  String get perkNone => 'Nau de sèrie';

  @override
  String get perkAfterimage => 'Quiet: trets ×1,5';

  @override
  String get perkBulwark =>
      'El dany que travessa l\'escut es redueix a la meitat';

  @override
  String get perkOverclock => 'Dispara fins al 130 % de capacitat, més lent';

  @override
  String get perkBattery => 'Un dron de combat gratuït t\'acompanya';

  @override
  String get rewardTitle => 'RECOMPENSA';

  @override
  String newHull(String name) {
    return 'Buc nou: $name';
  }

  @override
  String get socketEmpty => 'buit';

  @override
  String fxStreams(int n) {
    return '$n raigs paral·lels';
  }

  @override
  String fxFan(int n) {
    return 'Ventall de $n trets';
  }

  @override
  String fxSalvo(int n) {
    return 'Salva de $n trets';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadència ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Dany ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Velocitat dels trets ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Mida dels trets ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consum d\'energia ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Guiatge +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Travessa $n objectius';
  }

  @override
  String get fxPierceAll => 'Ho travessa tot';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % de probabilitat de dany ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Crítics ×$x contra caps';
  }

  @override
  String fxFork(int n) {
    return 'Les baixes escampen $n trets';
  }

  @override
  String get fxChain => 'Els trets escampats s\'escampen de nou';

  @override
  String get fxSplit => 'Es divideix en dos en impactar';

  @override
  String get fxFrost => 'Els impactes alenteixen els enemics';

  @override
  String get fxCrossfire => 'Els canons laterals apunten cap endins';

  @override
  String get fxRearguard => 'Els canons laterals també disparen enrere';

  @override
  String get fxOrbit => 'Els trets ondulen';

  @override
  String fxBounce(int n) {
    return 'Rebota a les parets $n×';
  }

  @override
  String get fxBounceTop => '…i al sostre';

  @override
  String get fxOverdrive => 'Dispara a crèdit d\'energia';

  @override
  String get fxReactor =>
      'Les armes per sobre de la capacitat disparen igualment, a poc a poc';

  @override
  String fxGenPower(String x) {
    return 'Recàrrega del generador ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacitat del generador ×$x';
  }

  @override
  String get fxSurge => 'Generador ple: trets ×2';

  @override
  String fxSiphon(int pct) {
    return 'Les baixes recarreguen un $pct % d\'energia';
  }

  @override
  String fxHp(String x) {
    return 'Buc ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Escut ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regeneració de l\'escut ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Les baixes curen $n HP';
  }

  @override
  String get fxMagnet => 'Atrau les bonificacions';

  @override
  String get fxMagnetAll => 'Atrau totes les bonificacions';

  @override
  String fxReflect(int pct) {
    return 'El $pct % dels trets reboten a l\'escut';
  }

  @override
  String get fxReflectGuided => 'Els trets reflectits es guien sols';

  @override
  String fxGhost(String sec) {
    return 'Intocable $sec s després d\'un impacte al buc';
  }

  @override
  String get fxNova => 'L\'escut es trenca: explosió a tota la pantalla';

  @override
  String fxAgility(String x) {
    return 'Agilitat ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zona d\'impacte ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Crèdits ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Puntuació ×$x';
  }

  @override
  String get fxSatellite => 'Un dron de combat t\'acompanya';

  @override
  String get fxTimewarp => 'Un impacte al buc alenteix el temps';

  @override
  String get fxGambler => 'Cada tret és una arma a l\'atzar';

  @override
  String get vaultAll => 'TOT';
}
