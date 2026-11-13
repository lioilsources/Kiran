// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'AVBRYT';

  @override
  String get connect => 'ANSLUT';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Kunde inte ansluta till $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Värden syntes, men anslutningen kom inte upp.\n\nSpel i närheten kräver peer-to-peer-wifi, som iOS stänger av medan Internetdelning är på — stäng av delningen på båda enheterna och försök igen, eller anslut båda enheterna till samma wifi.';

  @override
  String get gameOverCampaign =>
      'Uppdraget misslyckades — utrustning och krediter finns kvar. Försök igen från Ledningscentralen.';

  @override
  String get gameOverEndless =>
      'Bygger om i Sektor 1 — utrustning och krediter finns kvar';

  @override
  String get waitingForHost => 'Väntar på värden...';

  @override
  String get waitingForHostHint => 'Spelet startar när värden är redo';

  @override
  String get vesselLost => 'SKEPPET FÖRLORAT';

  @override
  String scoreValue(String score) {
    return 'Poäng: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Krediter: $credits';
  }

  @override
  String get creditsPrefix => 'Krediter: ';

  @override
  String get leaderboard => 'TOPPLISTA';

  @override
  String get achievements => 'PRESTATIONER';

  @override
  String get redeploy => 'TILLBAKA I STRID';

  @override
  String get resume => 'FORTSÄTT';

  @override
  String get pause => 'PAUS';

  @override
  String get paused => 'PAUSAT';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'LJUD: PÅ';

  @override
  String get soundOff => 'LJUD: AV';

  @override
  String get musicOn => 'MUSIK: PÅ';

  @override
  String get musicOff => 'MUSIK: AV';

  @override
  String get mainMenu => 'HUVUDMENY';

  @override
  String get quitToDesktop => 'AVSLUTA TILL SKRIVBORDET';

  @override
  String get selectSkin => 'VÄLJ SKIN';

  @override
  String get difficulty => 'SVÅRIGHETSGRAD';

  @override
  String get difficultyEasy => 'LÄTT';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'SVÅR';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANJ';

  @override
  String get quit => 'AVSLUTA';

  @override
  String get restorePurchases => 'ÅTERSTÄLL KÖP';

  @override
  String get locked => 'LÅST';

  @override
  String get mainMenuTooltip => 'Huvudmeny';

  @override
  String nodeLevel(int level) {
    return 'NIVÅ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVÅ $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Låst. Klara föregående nod först.';

  @override
  String get flyAgain => 'FLYG IGEN';

  @override
  String get launch => 'STARTA';

  @override
  String zoneLabel(int zone) {
    return 'ZON $zone';
  }

  @override
  String get objectiveStar => 'STJÄRNA';

  @override
  String get continueButton => 'FORTSÄTT';

  @override
  String get replayNode => 'SPELA OM NODEN';

  @override
  String get retry => 'FÖRSÖK IGEN';

  @override
  String get nodeCleared => 'NODEN KLARAD';

  @override
  String get nodeFailed => 'NODEN MISSLYCKADES';

  @override
  String get weaponTierUnlocked => 'VAPENNIVÅ UPPLÅST';

  @override
  String get onSaleInComCenter => 'Till salu i Ledningscentralen.';

  @override
  String get requiredTasksHint =>
      'De obligatoriska uppgifterna avgör noden. Flyg den igen — det du tjänat behåller du.';

  @override
  String get objClear => 'Rensa sektorn';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skjut ner $count fiender',
      one: 'Skjut ner 1 fiende',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ta ingen skrovskada';

  @override
  String objHull(int percent) {
    return 'Avsluta med över $percent% skrov';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Döda $count med $weapon',
      one: 'Döda 1 med $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Döda $count med dina sidokanoner',
      one: 'Döda 1 med dina sidokanoner',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Starta med $weapon längst fram';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Starta med $weapon på ett sidofäste';
  }

  @override
  String get objBuySideGun => 'Köp en sidokanon i Ledningscentralen';

  @override
  String objUpgradeGenerator(int level) {
    return 'Uppgradera generatorn till nivå $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Uppgradera frontkanonen till nivå $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Uppgradera en sidokanon till nivå $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fånga $count bonusar',
      one: 'Fånga 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Utplåna $count hela formationer',
      one: 'Utplåna 1 hel formation',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Kör inte in i någon asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Klara det inom $seconds s';
  }

  @override
  String get objStripBoss => 'Förstör alla bossens delar före kärnan';

  @override
  String get joinCoopTitle => 'Gå med i co-op';

  @override
  String get cannotSearchNetwork => 'Kan inte söka i det här nätverket';

  @override
  String get joinHintNearby =>
      'Samma wifi fungerar på alla enheter. iPhone, iPad och Mac hittar också varandra i närheten utan — med Internetdelning avstängd på båda.';

  @override
  String get joinHintWifi =>
      'Båda spelarna måste vara på samma wifi — Internetdelning fungerar också.';

  @override
  String noHostsYet(String hint) {
    return 'Inga värdar än. $hint';
  }

  @override
  String get lookingForHosts =>
      'Letar efter värdar på detta wifi och i närheten…';

  @override
  String get hostNearby => 'I närheten · Bluetooth / peer-to-peer-wifi';

  @override
  String hostSameWifi(String address) {
    return '$address · samma wifi';
  }

  @override
  String get enterIpManually => 'Ange IP manuellt';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SK';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — SKÖLDAD';
  }

  @override
  String get bossPartTurret => 'Torn';

  @override
  String get bossPartShieldPod => 'Sköldmodul';

  @override
  String get bossPartThruster => 'Motor';

  @override
  String get bossPartCannon => 'Kanon';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Okänd rymd';
  }

  @override
  String get player2Joined => 'Spelare 2 är med!';

  @override
  String get player2Disconnected => 'Spelare 2 kopplade från';

  @override
  String get hostDisconnected => 'Värden kopplade från';

  @override
  String maxLevelSold(String amount) {
    return 'Max. nivå! Såld för \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Vapennivå $tier upplåst';
  }

  @override
  String get cheatsEnabled => 'Fusk på';

  @override
  String get cheatsDisabled => 'Fusk av';

  @override
  String get cheatsMaxed => 'FUSK: krediter maxade, alla vapen upplåsta';

  @override
  String get cheats => 'FUSK';

  @override
  String get maxCredits => 'MAX KREDITER';

  @override
  String get sectionStats => 'STATISTIK';

  @override
  String get sectionLoadout => 'UTRUSTNING';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'SÄLJ';

  @override
  String get buy => 'KÖP';

  @override
  String get commandCenter => 'LEDNINGSCENTRAL';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'POÄNG';

  @override
  String get nextWeapon => 'NÄSTA VAPEN';

  @override
  String pointsValue(String points) {
    return '$points p';
  }

  @override
  String get slotFront => 'Fram';

  @override
  String get slotLeft => 'Vänster';

  @override
  String get slotRight => 'Höger';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'SKICKA UT UPPDRAG';

  @override
  String get startMission => 'STARTA UPPDRAG';

  @override
  String get continueMission => 'FORTSÄTT UPPDRAG';

  @override
  String get padControlsHint =>
      '[↑↓] Rad   [←→] Välj   [B] Köp/Uppgradera/Byt   [X/Y] Sälj   [OPTIONS] Fortsätt uppdrag';

  @override
  String get host => 'VÄRD';

  @override
  String hostingAs(String name) {
    return 'VÄRD som $name';
  }

  @override
  String get join => 'GÅ MED';

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
  String get overload => 'ÖVERBELASTNING';

  @override
  String weaponOff(String weapon) {
    return '$weapon AV — för svag generator';
  }

  @override
  String unlocksAt(String points) {
    return 'Låses upp vid $points p';
  }

  @override
  String joinConnecting(String target) {
    return 'Ansluter till $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Värden svarade inte: $reason.\n\nBåda spelarna måste vara på samma wifi (Internetdelning fungerar också) och värden måste ha tryckt på VÄRD. Kontrollera adressen och försök igen.';
  }

  @override
  String get lanJoinNoAnswer => 'inget svar';

  @override
  String objBossUnder(int seconds) {
    return 'Förstör bossens kärna inom $seconds s efter att den dykt upp';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'VALV';

  @override
  String get rackSide => 'Sida';

  @override
  String get rackHull => 'Skrov';

  @override
  String get rarityCommon => 'VANLIG';

  @override
  String get rarityRare => 'SÄLLSYNT';

  @override
  String get rarityMythic => 'MYTISK';

  @override
  String get curse => 'FÖRBANNELSE';

  @override
  String get modFit => 'MONTERA';

  @override
  String get modUnfit => 'DEMONTERA';

  @override
  String get modForge => 'SMEDJA';

  @override
  String get forgeHint =>
      'Välj 3 av samma sällsynthet för att smida 1 av nästa';

  @override
  String get vaultEmpty =>
      'Inga moddar än. Klara en nod med alla stjärnor, besegra en boss snabbt eller skjut ner en boss i oändligt läge.';

  @override
  String modNeeds(String families) {
    return 'Fungerar med $families';
  }

  @override
  String get modRackFull => 'Stället är fullt';

  @override
  String get modAlreadyFitted => 'Redan monterad';

  @override
  String get modWrongRack => 'Passar inte i detta ställ';

  @override
  String modsSpilled(int n) {
    return '$n moddar tillbaka i valvet';
  }

  @override
  String get hullLocked => 'Låst';

  @override
  String hullUnlockBoss(int n) {
    return 'Besegra kampanjboss $n';
  }

  @override
  String get hullUnlockFinish => 'Klara kampanjen eller nå sektor 30';

  @override
  String get statAgility => 'SMI';

  @override
  String get statHitbox => 'TRÄFF';

  @override
  String get perkNone => 'Standardskepp';

  @override
  String get perkAfterimage => 'Stå still: skott ×1,5';

  @override
  String get perkBulwark => 'Skada förbi skölden halveras';

  @override
  String get perkOverclock =>
      'Skjuter upp till 130 % av kapaciteten, långsammare';

  @override
  String get perkBattery => 'En gratis stridsdrönare flyger med';

  @override
  String get rewardTitle => 'BELÖNING';

  @override
  String newHull(String name) {
    return 'Nytt skrov: $name';
  }

  @override
  String get socketEmpty => 'tom';

  @override
  String fxStreams(int n) {
    return '$n parallella strålar';
  }

  @override
  String fxFan(int n) {
    return 'Solfjäder av $n skott';
  }

  @override
  String fxSalvo(int n) {
    return 'Salva på $n skott';
  }

  @override
  String fxFireRate(String x) {
    return 'Eldhastighet ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Skada ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Skotthastighet ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Skottstorlek ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energiförbrukning ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Målsökande +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Går igenom $n mål';
  }

  @override
  String get fxPierceAll => 'Går igenom allt';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % chans till ×$x skada';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kritiska mot bossar';
  }

  @override
  String fxFork(int n) {
    return 'Dödande skott sprider $n skott';
  }

  @override
  String get fxChain => 'Spridda skott sprids igen';

  @override
  String get fxSplit => 'Delas i två vid träff';

  @override
  String get fxFrost => 'Träffar saktar ner fiender';

  @override
  String get fxCrossfire => 'Sidokanonerna siktar inåt';

  @override
  String get fxRearguard => 'Sidokanonerna skjuter även bakåt';

  @override
  String get fxOrbit => 'Skotten slingrar sig';

  @override
  String fxBounce(int n) {
    return 'Studsar mot väggarna $n×';
  }

  @override
  String get fxBounceTop => '…och mot toppen';

  @override
  String get fxOverdrive => 'Skjuter på energiskuld';

  @override
  String get fxReactor => 'Vapen över kapaciteten skjuter ändå, långsamt';

  @override
  String fxGenPower(String x) {
    return 'Generatorladdning ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generatorkapacitet ×$x';
  }

  @override
  String get fxSurge => 'Full generator: skott ×2';

  @override
  String fxSiphon(int pct) {
    return 'Dödande skott fyller på $pct % energi';
  }

  @override
  String fxHp(String x) {
    return 'Skrov ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Sköld ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Sköldåterladdning ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Dödande skott helar $n HP';
  }

  @override
  String get fxMagnet => 'Drar till sig bonusar';

  @override
  String get fxMagnetAll => 'Drar till sig alla bonusar';

  @override
  String fxReflect(int pct) {
    return '$pct % av skotten studsar tillbaka från skölden';
  }

  @override
  String get fxReflectGuided => 'Reflekterade skott söker mål';

  @override
  String fxGhost(String sec) {
    return 'Oantastlig i $sec s efter en skrovträff';
  }

  @override
  String get fxNova => 'Skölden brister: hela skärmen får en smäll';

  @override
  String fxAgility(String x) {
    return 'Smidighet ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Träffyta ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Krediter ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Poäng ×$x';
  }

  @override
  String get fxSatellite => 'En stridsdrönare flyger med';

  @override
  String get fxTimewarp => 'En skrovträff saktar ner tiden';

  @override
  String get fxGambler => 'Varje skott är ett slumpvapen';

  @override
  String get vaultAll => 'ALLA';
}
