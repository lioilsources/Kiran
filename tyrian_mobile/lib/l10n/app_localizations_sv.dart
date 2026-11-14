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
  String get statsOn => 'STATISTIK: PÅ';

  @override
  String get statsOff => 'STATISTIK: AV';

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

  @override
  String get sigilMissUnknown => 'okänd form';

  @override
  String get sigilMissTooSlow => 'för långsamt';

  @override
  String get sigilMissSkippedDot => 'hoppade över en punkt';

  @override
  String get sigilMissLeftRimEarly => 'släppte för tidigt';

  @override
  String get sigilMissWrongDirection => 'ritad baklänges';

  @override
  String get sigilMissWrongLayer => 'fel axelknapp';

  @override
  String get sigilDry => 'för lite laddning';

  @override
  String get sigilBusy => 'förra pågår fortfarande';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BOSSDELAR';

  @override
  String get arenaBareCore => 'bar kärna';

  @override
  String get arenaCompanions => 'FÖLJESLAGARE';

  @override
  String get arenaCharge => 'LADDNING';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VÄRLDSHASTIGHET';

  @override
  String get arenaDrill => 'ÖVNING';

  @override
  String get arenaFreePlay => 'FRITT SPEL';

  @override
  String get arenaFight => 'SLÅSS';

  @override
  String get arenaNewBoss => 'NY BOSS';

  @override
  String get arenaLeave => 'LÄMNA ARENAN';

  @override
  String get arenaHint =>
      'Bossen kommer tillbaka så fort den dör. Inget här sparas.';

  @override
  String get arenaColCast => 'KAST';

  @override
  String get arenaColMiss => 'MISS';

  @override
  String get arenaColAvg => 'SNITT';

  @override
  String get arenaColBest => 'BÄST';

  @override
  String get arenaColTime => 'SNABBAST';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossar $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILL';

  @override
  String get padSchemeClassic => 'PAD: KLASSISK';

  @override
  String get padSouthpawOn => 'VÄNSTERHÄNT: PÅ';

  @override
  String get padSouthpawOff => 'VÄNSTERHÄNT: AV';

  @override
  String get sigilDescHop => 'Ett snabbt hopp åt det håll du snärtar';

  @override
  String get sigilDescSidestep => 'Ett långt sidsteg över fältet';

  @override
  String get sigilDescStrike =>
      'Utfall framåt med tre tunga skott, sedan tillbaka';

  @override
  String get sigilDescRetreat => 'Dra dig tillbaka medan täckeld går framåt';

  @override
  String get sigilDescDash =>
      'En diagonal rusning genom elden, oåtkomlig mitt i';

  @override
  String get sigilDescRoll => 'En tunnroll åt sidan, oåtkomlig';

  @override
  String get sigilDescShadow =>
      'Lås dig under närmaste fiende och fortsätt skjuta';

  @override
  String get sigilDescEcho =>
      'En skugga upprepar dina två senaste sekunder med halv skada';

  @override
  String get sigilDescLoop => 'Looping över toppen: skotten passerar under dig';

  @override
  String get sigilDescSlalom => 'En S-kurva över fältet med solfjäderseld';

  @override
  String get sigilDescCorkscrew =>
      'Korkskruv framåt med eld runt om, oåtkomlig';

  @override
  String get sigilDescSnapshot => 'Ett tungt skott åt det håll du snärtar';

  @override
  String get sigilDescBroadside => 'En salva från båda flankerna';

  @override
  String get sigilDescVolley => 'Fem laddade strålar framåt';

  @override
  String get sigilDescCaltrop =>
      'Släpp en mina som sväljer skott och exploderar';

  @override
  String get sigilDescFrenzy => 'Vapnen skjuter snabbare i några sekunder';

  @override
  String get sigilDescStasis =>
      'Fiender och deras skott saktar ner till halv fart';

  @override
  String get sigilDescHalo =>
      'Skölden laddas fyra gånger snabbare och inget tränger igenom';

  @override
  String get sigilDescRadial => 'En ring av sexton skott';

  @override
  String get sigilDescStorm => 'Alla vapen för fullt, gratis';

  @override
  String get sigilDescPing => 'Följeslagarna fokuserar elden dit du snärtar';

  @override
  String get sigilDescWingman =>
      'Kalla en flygkamrat till flanken du ritade mot';

  @override
  String get sigilDescHunter =>
      'Kalla en jägare som flyger före och väljer mål';

  @override
  String get sigilDescWarden => 'Kalla en väktare som tar skotten åt dig';

  @override
  String get sigilDescFormation => 'Följeslagarna växlar mellan bred och kil';

  @override
  String get sigilDescWhirl => 'Följeslagarna cirklar runt dig och äter skott';

  @override
  String get sigilDescSacrifice =>
      'Följeslagarna dyker och exploderar, ger tillbaka laddning';

  @override
  String get grimoire => 'GRIMOAR';

  @override
  String get grimoireHint =>
      'Rita med höger spak. Håll LB för VAPEN, RB för VINGE, båda för MEGASMÄLL.';

  @override
  String sigilCost(int cost) {
    return 'kostar $cost';
  }

  @override
  String get sigilUntouchable => 'oåtkomlig';

  @override
  String get lessonWatch => 'TITTA';

  @override
  String get lessonTrace => 'RITA AV';

  @override
  String get lessonSlow => 'LÅNGSAMT';

  @override
  String get lessonLive => 'FULL FART';

  @override
  String get lessonStreak => 'FEM I RAD';

  @override
  String get lessonLearned => 'INLÄRD';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Snärta höger spak';

  @override
  String get hintLoop => 'Rita en cirkel: du flyger över skotten';

  @override
  String get hintStream => 'Kläm LT: två eller tre strålar';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'INGEN';

  @override
  String kataNext(String sigil, String secs) {
    return 'nästa $sigil om $secs s';
  }

  @override
  String get arenaGauntlet => 'GATLOPP';

  @override
  String get arenaOn => 'PÅ';

  @override
  String get arenaOff => 'AV';

  @override
  String gauntletRating(int rating, int best) {
    return 'Betyg $rating · bäst $best';
  }

  @override
  String get duelWarning => 'VARNING';

  @override
  String get duelHintPad1 => 'Höger spak siktar och skjuter';

  @override
  String get duelHintPad2Rt => 'Håll RT, LB eller RB: höger spak ritar sigill';

  @override
  String get duelHintPad2Lt => 'Håll LT, LB eller RB: höger spak ritar sigill';

  @override
  String get duelHintClassic =>
      'Vänster spak flyger · B, RB eller RT skjuter dit nosen pekar';

  @override
  String get duelHintKeys1 => 'Pilarna siktar och skjuter · WASD flyger';

  @override
  String get duelHintKeys2 =>
      'Mellanslag skjuter dit nosen pekar · numpaden ritar sigill';

  @override
  String get arenaDuelBinding => 'DUELLSTÄLLNING';

  @override
  String get duelBindingRt => 'RT + SPAK';

  @override
  String get duelBindingLt => 'LT + SPAK';

  @override
  String get arenaDuelFrame => 'PAD FRAMÅT';

  @override
  String get duelFrameNose => 'NOSEN';

  @override
  String get duelFrameUp => 'UPP';

  @override
  String get arenaDuelAimFires => 'SIKTE SKJUTER';

  @override
  String get duelCutInFirst => 'BOSSNÄRBILD: FÖRSTA GÅNGEN';

  @override
  String get duelCutInAlways => 'BOSSNÄRBILD: ALLTID';

  @override
  String get duelCutInNever => 'BOSSNÄRBILD: ALDRIG';

  @override
  String get arenaDuelDrill => 'DUELLÖVNING';

  @override
  String get duelDrillOff => 'INGEN';

  @override
  String get duelDrillAim => 'SIKTA OCH SKJUT';

  @override
  String get duelDrillAimHow => 'Rikta höger spak mot bossen och träffa den';

  @override
  String get duelDrillHold => 'HÅLL NOSEN';

  @override
  String get duelDrillHoldHow =>
      'Håll en ställningsknapp och flyg: nosen ligger still';

  @override
  String get duelDrillDraw => 'RITA FRAMÅT';

  @override
  String get duelDrillDrawHow => 'I ställningen, rita ett sigill mot bossen';

  @override
  String get duelDrillTurn => 'VÄND OM';

  @override
  String get duelDrillTurnHow =>
      'Bossen är under dig: vänd nosen och träffa den';

  @override
  String get duelDrillDone => 'KLART';

  @override
  String get swapHint => 'Tryck med ett andra finger för att byta vapen';
}
