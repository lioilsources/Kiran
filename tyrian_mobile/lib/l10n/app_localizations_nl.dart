// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANNULEREN';

  @override
  String get connect => 'VERBINDEN';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Kan geen verbinding maken met $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'De host was zichtbaar, maar de verbinding kwam niet tot stand.\n\nSpelen in de buurt vereist peer-to-peer-wifi, dat iOS uitschakelt zolang Persoonlijke hotspot aan staat — zet de hotspot op beide apparaten uit en probeer het opnieuw, of zet beide apparaten op hetzelfde wifinetwerk.';

  @override
  String get gameOverCampaign =>
      'Missie mislukt — uitrusting en credits blijven behouden. Probeer opnieuw vanuit het Commandocentrum.';

  @override
  String get gameOverEndless =>
      'Herbouwen in Sector 1 — uitrusting en credits blijven behouden';

  @override
  String get waitingForHost => 'Wachten op host...';

  @override
  String get waitingForHostHint => 'Het spel begint zodra de host klaar is';

  @override
  String get vesselLost => 'SCHIP VERLOREN';

  @override
  String scoreValue(String score) {
    return 'Score: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Credits: $credits';
  }

  @override
  String get creditsPrefix => 'Credits: ';

  @override
  String get leaderboard => 'RANGLIJST';

  @override
  String get achievements => 'PRESTATIES';

  @override
  String get redeploy => 'OPNIEUW INZETTEN';

  @override
  String get resume => 'HERVATTEN';

  @override
  String get pause => 'PAUZE';

  @override
  String get paused => 'GEPAUZEERD';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'GELUID: AAN';

  @override
  String get soundOff => 'GELUID: UIT';

  @override
  String get musicOn => 'MUZIEK: AAN';

  @override
  String get musicOff => 'MUZIEK: UIT';

  @override
  String get mainMenu => 'HOOFDMENU';

  @override
  String get quitToDesktop => 'NAAR BUREAUBLAD';

  @override
  String get selectSkin => 'KIES SKIN';

  @override
  String get difficulty => 'MOEILIJKHEID';

  @override
  String get difficultyEasy => 'MAKKELIJK';

  @override
  String get difficultyNormal => 'NORMAAL';

  @override
  String get difficultyHard => 'MOEILIJK';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAGNE';

  @override
  String get quit => 'STOPPEN';

  @override
  String get restorePurchases => 'AANKOPEN HERSTELLEN';

  @override
  String get locked => 'VERGRENDELD';

  @override
  String get mainMenuTooltip => 'Hoofdmenu';

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LEVEL $level · BAAS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Vergrendeld. Voltooi eerst het vorige knooppunt.';

  @override
  String get flyAgain => 'OPNIEUW VLIEGEN';

  @override
  String get launch => 'LANCEREN';

  @override
  String zoneLabel(int zone) {
    return 'ZONE $zone';
  }

  @override
  String get objectiveStar => 'STER';

  @override
  String get continueButton => 'DOORGAAN';

  @override
  String get replayNode => 'KNOOPPUNT OPNIEUW';

  @override
  String get retry => 'OPNIEUW';

  @override
  String get nodeCleared => 'KNOOPPUNT VOLTOOID';

  @override
  String get nodeFailed => 'KNOOPPUNT MISLUKT';

  @override
  String get weaponTierUnlocked => 'WAPENNIVEAU ONTGRENDELD';

  @override
  String get onSaleInComCenter => 'Te koop in het Commandocentrum.';

  @override
  String get requiredTasksHint =>
      'De verplichte taken bepalen het knooppunt. Vlieg het opnieuw — wat je hebt verdiend, houd je.';

  @override
  String get objClear => 'Zuiver de sector';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Schiet $count vijanden neer',
      one: 'Schiet 1 vijand neer',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Loop geen rompschade op';

  @override
  String objHull(int percent) {
    return 'Eindig met meer dan $percent% romp';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vernietig $count vijanden met de $weapon',
      one: 'Vernietig 1 vijand met de $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vernietig $count vijanden met je zijkanonnen',
      one: 'Vernietig 1 vijand met je zijkanonnen',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Vertrek met de $weapon voorop';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Vertrek met de $weapon op een zijmontage';
  }

  @override
  String get objBuySideGun => 'Koop een zijkanon in het Commandocentrum';

  @override
  String objUpgradeGenerator(int level) {
    return 'Upgrade je generator naar level $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Upgrade je frontkanon naar level $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Upgrade een zijkanon naar level $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vang $count bonussen',
      one: 'Vang 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vernietig $count complete formaties',
      one: 'Vernietig 1 complete formatie',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ram geen enkele asteroïde';

  @override
  String objUnderTime(int seconds) {
    return 'Voltooi binnen $seconds s';
  }

  @override
  String get objStripBoss => 'Vernietig elk deel van de baas vóór de kern';

  @override
  String get joinCoopTitle => 'Co-op deelnemen';

  @override
  String get cannotSearchNetwork => 'Kan dit netwerk niet doorzoeken';

  @override
  String get joinHintNearby =>
      'Hetzelfde wifinetwerk werkt op elk apparaat. iPhone, iPad en Mac vinden elkaar ook zonder wifi in de buurt — met Persoonlijke hotspot uit op beide.';

  @override
  String get joinHintWifi =>
      'Beide spelers moeten op hetzelfde wifinetwerk zitten — een Persoonlijke hotspot werkt ook.';

  @override
  String noHostsYet(String hint) {
    return 'Nog geen hosts. $hint';
  }

  @override
  String get lookingForHosts =>
      'Zoeken naar hosts op deze wifi en in de buurt…';

  @override
  String get hostNearby => 'In de buurt · Bluetooth / peer-to-peer-wifi';

  @override
  String hostSameWifi(String address) {
    return '$address · zelfde wifi';
  }

  @override
  String get enterIpManually => 'IP handmatig invoeren';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SCH';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — AFGESCHERMD';
  }

  @override
  String get bossPartTurret => 'Geschutskoepel';

  @override
  String get bossPartShieldPod => 'Schildmodule';

  @override
  String get bossPartThruster => 'Stuwraket';

  @override
  String get bossPartCannon => 'Kanon';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sector $level — Onbekende ruimte';
  }

  @override
  String get player2Joined => 'Speler 2 doet mee!';

  @override
  String get player2Disconnected => 'Speler 2 heeft de verbinding verbroken';

  @override
  String get hostDisconnected => 'Host heeft de verbinding verbroken';

  @override
  String maxLevelSold(String amount) {
    return 'Max. level! Verkocht voor \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Wapenniveau $tier ontgrendeld';
  }

  @override
  String get cheatsEnabled => 'Cheats ingeschakeld';

  @override
  String get cheatsDisabled => 'Cheats uitgeschakeld';

  @override
  String get cheatsMaxed => 'CHEAT: credits maximaal, alle wapens ontgrendeld';

  @override
  String get cheats => 'CHEATS';

  @override
  String get maxCredits => 'MAX. CREDITS';

  @override
  String get sectionStats => 'STATISTIEKEN';

  @override
  String get sectionLoadout => 'UITRUSTING';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'VERKOOP';

  @override
  String get buy => 'KOOP';

  @override
  String get commandCenter => 'COMMANDOCENTRUM';

  @override
  String get pilot => 'Piloot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SCORE';

  @override
  String get nextWeapon => 'VOLGEND WAPEN';

  @override
  String pointsValue(String points) {
    return '$points ptn';
  }

  @override
  String get slotFront => 'Voor';

  @override
  String get slotLeft => 'Links';

  @override
  String get slotRight => 'Rechts';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'MISSIE LANCEREN';

  @override
  String get startMission => 'MISSIE STARTEN';

  @override
  String get continueMission => 'MISSIE VERVOLGEN';

  @override
  String get padControlsHint =>
      '[↑↓] Rij   [←→] Kiezen   [B] Kopen/Upgraden/Wisselen   [X/Y] Verkopen   [OPTIONS] Missie vervolgen';

  @override
  String get host => 'HOSTEN';

  @override
  String hostingAs(String name) {
    return 'HOST als $name';
  }

  @override
  String get join => 'DEELNEMEN';

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
  String get overload => 'OVERBELAST';

  @override
  String weaponOff(String weapon) {
    return '$weapon UIT — generator te zwak';
  }

  @override
  String unlocksAt(String points) {
    return 'Ontgrendelt bij $points ptn';
  }

  @override
  String joinConnecting(String target) {
    return 'Verbinden met $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'De host gaf geen antwoord: $reason.\n\nBeide spelers moeten op hetzelfde wifinetwerk zitten (een Persoonlijke hotspot werkt ook) en de host moet op HOSTEN hebben gedrukt. Controleer het adres en probeer het opnieuw.';
  }

  @override
  String get lanJoinNoAnswer => 'geen antwoord';

  @override
  String objBossUnder(int seconds) {
    return 'Vernietig de kern van de baas binnen $seconds s na zijn komst';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'KLUIS';

  @override
  String get rackSide => 'Zij';

  @override
  String get rackHull => 'Romp';

  @override
  String get rarityCommon => 'GEWOON';

  @override
  String get rarityRare => 'ZELDZAAM';

  @override
  String get rarityMythic => 'MYTHISCH';

  @override
  String get curse => 'VLOEK';

  @override
  String get modFit => 'INBOUWEN';

  @override
  String get modUnfit => 'UITBOUWEN';

  @override
  String get modForge => 'SMIDSE';

  @override
  String get forgeHint =>
      'Kies er 3 van één zeldzaamheid om 1 van de volgende te smeden';

  @override
  String get vaultEmpty =>
      'Nog geen mods. Voltooi een knooppunt met alle sterren, versla snel een baas of schiet een baas neer in eindeloze modus.';

  @override
  String modNeeds(String families) {
    return 'Werkt met $families';
  }

  @override
  String get modRackFull => 'Rek vol';

  @override
  String get modAlreadyFitted => 'Al ingebouwd';

  @override
  String get modWrongRack => 'Past niet in dit rek';

  @override
  String modsSpilled(int n) {
    return '$n mods terug in de kluis';
  }

  @override
  String get hullLocked => 'Vergrendeld';

  @override
  String hullUnlockBoss(int n) {
    return 'Versla campagnebaas $n';
  }

  @override
  String get hullUnlockFinish => 'Voltooi de campagne of bereik sector 30';

  @override
  String get statAgility => 'WEN';

  @override
  String get statHitbox => 'RAAK';

  @override
  String get perkNone => 'Standaardschip';

  @override
  String get perkAfterimage => 'Stilstaan: schoten ×1,5';

  @override
  String get perkBulwark => 'Schade voorbij het schild wordt gehalveerd';

  @override
  String get perkOverclock => 'Vuurt tot 130 % van de capaciteit, trager';

  @override
  String get perkBattery => 'Een gratis gevechtsdrone vliegt mee';

  @override
  String get rewardTitle => 'BELONING';

  @override
  String newHull(String name) {
    return 'Nieuwe romp: $name';
  }

  @override
  String get socketEmpty => 'leeg';

  @override
  String fxStreams(int n) {
    return '$n parallelle stralen';
  }

  @override
  String fxFan(int n) {
    return 'Waaier van $n schoten';
  }

  @override
  String fxSalvo(int n) {
    return 'Salvo van $n schoten';
  }

  @override
  String fxFireRate(String x) {
    return 'Vuursnelheid ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Schade ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Kogelsnelheid ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Kogelgrootte ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energieverbruik ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Doelzoekend +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Gaat door $n doelen heen';
  }

  @override
  String get fxPierceAll => 'Gaat overal doorheen';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % kans op ×$x schade';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x crits op bazen';
  }

  @override
  String fxFork(int n) {
    return 'Kills sproeien $n schoten';
  }

  @override
  String get fxChain => 'Gesproeide schoten sproeien opnieuw';

  @override
  String get fxSplit => 'Splitst in tweeën bij een treffer';

  @override
  String get fxFrost => 'Treffers vertragen vijanden';

  @override
  String get fxCrossfire => 'Zijkanonnen richten naar binnen';

  @override
  String get fxRearguard => 'Zijkanonnen vuren ook naar achteren';

  @override
  String get fxOrbit => 'Schoten slingeren';

  @override
  String fxBounce(int n) {
    return 'Kaatst $n× van de wanden';
  }

  @override
  String get fxBounceTop => '…en van de bovenkant';

  @override
  String get fxOverdrive => 'Vuurt op energieschuld';

  @override
  String get fxReactor => 'Overbelaste wapens vuren toch, langzaam';

  @override
  String fxGenPower(String x) {
    return 'Generatorlading ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generatorcapaciteit ×$x';
  }

  @override
  String get fxSurge => 'Volle generator: schoten ×2';

  @override
  String fxSiphon(int pct) {
    return 'Kills vullen $pct % energie aan';
  }

  @override
  String fxHp(String x) {
    return 'Romp ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Schild ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Schildherstel ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Kills herstellen $n HP';
  }

  @override
  String get fxMagnet => 'Trekt bonussen aan';

  @override
  String get fxMagnetAll => 'Trekt elke bonus aan';

  @override
  String fxReflect(int pct) {
    return '$pct % van de schoten kaatst terug van het schild';
  }

  @override
  String get fxReflectGuided => 'Teruggekaatste schoten zoeken hun doel';

  @override
  String fxGhost(String sec) {
    return 'Onaantastbaar $sec s na een rompschot';
  }

  @override
  String get fxNova => 'Schild breekt: het hele scherm krijgt een klap';

  @override
  String fxAgility(String x) {
    return 'Wendbaarheid ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Raakzone ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Credits ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Score ×$x';
  }

  @override
  String get fxSatellite => 'Een gevechtsdrone vliegt mee';

  @override
  String get fxTimewarp => 'Een rompschot vertraagt de tijd';

  @override
  String get fxGambler => 'Elk schot is een willekeurig wapen';

  @override
  String get vaultAll => 'ALLE';
}
