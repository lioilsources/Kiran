// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANNULLER';

  @override
  String get connect => 'FORBIND';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Kunne ikke oprette forbindelse til $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Værten var synlig, men forbindelsen kom ikke op.\n\nSpil i nærheden kræver peer-to-peer-wi-fi, som iOS slår fra, mens Internetdeling er slået til — slå deling fra på begge enheder og prøv igen, eller sæt begge enheder på samme wi-fi.';

  @override
  String get gameOverCampaign =>
      'Mission mislykket — udstyr og kreditter bevares. Prøv igen fra Kommandocentralen.';

  @override
  String get gameOverEndless =>
      'Genopbygger i Sektor 1 — udstyr og kreditter bevares';

  @override
  String get waitingForHost => 'Venter på vært...';

  @override
  String get waitingForHostHint => 'Spillet starter, når værten er klar';

  @override
  String get vesselLost => 'SKIB TABT';

  @override
  String scoreValue(String score) {
    return 'Point: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kreditter: $credits';
  }

  @override
  String get creditsPrefix => 'Kreditter: ';

  @override
  String get leaderboard => 'RANGLISTE';

  @override
  String get achievements => 'PRÆSTATIONER';

  @override
  String get redeploy => 'TILBAGE I KAMP';

  @override
  String get resume => 'FORTSÆT';

  @override
  String get pause => 'PAUSE';

  @override
  String get paused => 'PAUSET';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'LYD: TIL';

  @override
  String get soundOff => 'LYD: FRA';

  @override
  String get musicOn => 'MUSIK: TIL';

  @override
  String get musicOff => 'MUSIK: FRA';

  @override
  String get mainMenu => 'HOVEDMENU';

  @override
  String get quitToDesktop => 'AFSLUT TIL SKRIVEBORD';

  @override
  String get selectSkin => 'VÆLG SKIN';

  @override
  String get difficulty => 'SVÆRHEDSGRAD';

  @override
  String get difficultyEasy => 'LET';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'SVÆR';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPAGNE';

  @override
  String get quit => 'AFSLUT';

  @override
  String get restorePurchases => 'GENDAN KØB';

  @override
  String get locked => 'LÅST';

  @override
  String get mainMenuTooltip => 'Hovedmenu';

  @override
  String nodeLevel(int level) {
    return 'NIVEAU $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVEAU $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Låst. Klar den forrige knude først.';

  @override
  String get flyAgain => 'FLYV IGEN';

  @override
  String get launch => 'AFGANG';

  @override
  String zoneLabel(int zone) {
    return 'ZONE $zone';
  }

  @override
  String get objectiveStar => 'STJERNE';

  @override
  String get continueButton => 'FORTSÆT';

  @override
  String get replayNode => 'SPIL KNUDE IGEN';

  @override
  String get retry => 'PRØV IGEN';

  @override
  String get nodeCleared => 'KNUDE KLARET';

  @override
  String get nodeFailed => 'KNUDE MISLYKKET';

  @override
  String get weaponTierUnlocked => 'VÅBENNIVEAU LÅST OP';

  @override
  String get onSaleInComCenter => 'Til salg i Kommandocentralen.';

  @override
  String get requiredTasksHint =>
      'De påkrævede opgaver afgør knuden. Flyv den igen — det, du har tjent, beholder du.';

  @override
  String get objClear => 'Ryd sektoren';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skyd $count fjender ned',
      one: 'Skyd 1 fjende ned',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Tag ingen skade på skroget';

  @override
  String objHull(int percent) {
    return 'Slut med over $percent% skrog';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dræb $count med $weapon',
      one: 'Dræb 1 med $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dræb $count med dine sidekanoner',
      one: 'Dræb 1 med dine sidekanoner',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Flyv ud med $weapon forrest';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Flyv ud med $weapon på en sidemontering';
  }

  @override
  String get objBuySideGun => 'Køb en sidekanon i Kommandocentralen';

  @override
  String objUpgradeGenerator(int level) {
    return 'Opgrader din generator til niveau $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Opgrader din frontkanon til niveau $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Opgrader en sidekanon til niveau $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saml $count bonusser op',
      one: 'Saml 1 bonus op',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Udslet $count hele formationer',
      one: 'Udslet 1 hel formation',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ram ingen asteroider';

  @override
  String objUnderTime(int seconds) {
    return 'Gennemfør inden for $seconds s';
  }

  @override
  String get objStripBoss => 'Ødelæg alle bossens dele før kernen';

  @override
  String get joinCoopTitle => 'Deltag i co-op';

  @override
  String get cannotSearchNetwork => 'Kan ikke søge på dette netværk';

  @override
  String get joinHintNearby =>
      'Samme wi-fi virker på alle enheder. iPhone, iPad og Mac finder også hinanden i nærheden uden — med Internetdeling slået fra på begge.';

  @override
  String get joinHintWifi =>
      'Begge spillere skal være på samme wi-fi — Internetdeling virker også.';

  @override
  String noHostsYet(String hint) {
    return 'Ingen værter endnu. $hint';
  }

  @override
  String get lookingForHosts =>
      'Leder efter værter på dette wi-fi og i nærheden…';

  @override
  String get hostNearby => 'I nærheden · Bluetooth / peer-to-peer-wi-fi';

  @override
  String hostSameWifi(String address) {
    return '$address · samme wi-fi';
  }

  @override
  String get enterIpManually => 'Indtast IP manuelt';

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
    return '$name — SKJOLDBESKYTTET';
  }

  @override
  String get bossPartTurret => 'Tårn';

  @override
  String get bossPartShieldPod => 'Skjoldmodul';

  @override
  String get bossPartThruster => 'Motor';

  @override
  String get bossPartCannon => 'Kanon';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Ukendt rum';
  }

  @override
  String get player2Joined => 'Spiller 2 er med!';

  @override
  String get player2Disconnected => 'Spiller 2 har afbrudt';

  @override
  String get hostDisconnected => 'Værten har afbrudt';

  @override
  String maxLevelSold(String amount) {
    return 'Maks. niveau! Solgt for \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Våbenniveau $tier låst op';
  }

  @override
  String get cheatsEnabled => 'Snydekoder slået til';

  @override
  String get cheatsDisabled => 'Snydekoder slået fra';

  @override
  String get cheatsMaxed => 'SNYD: kreditter maksimeret, alle våben låst op';

  @override
  String get cheats => 'SNYD';

  @override
  String get maxCredits => 'MAKS. KREDITTER';

  @override
  String get sectionStats => 'STATISTIK';

  @override
  String get sectionLoadout => 'UDSTYR';

  @override
  String levelShort(int level) {
    return 'Niv.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'OPG';

  @override
  String get sell => 'SÆLG';

  @override
  String get buy => 'KØB';

  @override
  String get commandCenter => 'KOMMANDOCENTRAL';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'POINT';

  @override
  String get nextWeapon => 'NÆSTE VÅBEN';

  @override
  String pointsValue(String points) {
    return '$points p';
  }

  @override
  String get slotFront => 'Front';

  @override
  String get slotLeft => 'Venstre';

  @override
  String get slotRight => 'Højre';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'SEND MISSION AFSTED';

  @override
  String get startMission => 'START MISSION';

  @override
  String get continueMission => 'FORTSÆT MISSION';

  @override
  String get padControlsHint =>
      '[↑↓] Række   [←→] Vælg   [B] Køb/Opgrader/Skift   [X/Y] Sælg   [OPTIONS] Fortsæt mission';

  @override
  String get host => 'VÆRT';

  @override
  String hostingAs(String name) {
    return 'VÆRT som $name';
  }

  @override
  String get join => 'DELTAG';

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
  String get overload => 'OVERBELASTNING';

  @override
  String weaponOff(String weapon) {
    return '$weapon FRA — generatoren er for svag';
  }

  @override
  String unlocksAt(String points) {
    return 'Låses op ved $points p';
  }

  @override
  String joinConnecting(String target) {
    return 'Forbinder til $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Værten svarede ikke: $reason.\n\nBegge spillere skal være på samme wi-fi (Internetdeling virker også), og værten skal have trykket på VÆRT. Tjek adressen og prøv igen.';
  }

  @override
  String get lanJoinNoAnswer => 'intet svar';

  @override
  String objBossUnder(int seconds) {
    return 'Ødelæg bossens kerne inden for $seconds s efter dens ankomst';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'BOKS';

  @override
  String get rackSide => 'Side';

  @override
  String get rackHull => 'Skrog';

  @override
  String get rarityCommon => 'ALMINDELIG';

  @override
  String get rarityRare => 'SJÆLDEN';

  @override
  String get rarityMythic => 'MYTISK';

  @override
  String get curse => 'FORBANDELSE';

  @override
  String get modFit => 'MONTER';

  @override
  String get modUnfit => 'AFMONTER';

  @override
  String get modForge => 'SMEDJE';

  @override
  String get forgeHint =>
      'Vælg 3 af samme sjældenhed for at smede 1 af den næste';

  @override
  String get vaultEmpty =>
      'Ingen mods endnu. Klar en knude med alle stjerner, slå en boss hurtigt, eller skyd en boss ned i endeløs tilstand.';

  @override
  String modNeeds(String families) {
    return 'Virker med $families';
  }

  @override
  String get modRackFull => 'Stativet er fuldt';

  @override
  String get modAlreadyFitted => 'Allerede monteret';

  @override
  String get modWrongRack => 'Passer ikke til dette stativ';

  @override
  String modsSpilled(int n) {
    return '$n mods tilbage i boksen';
  }

  @override
  String get hullLocked => 'Låst';

  @override
  String hullUnlockBoss(int n) {
    return 'Slå kampagnebos $n';
  }

  @override
  String get hullUnlockFinish => 'Gennemfør kampagnen eller nå sektor 30';

  @override
  String get statAgility => 'MAN';

  @override
  String get statHitbox => 'TRÆF';

  @override
  String get perkNone => 'Standardskib';

  @override
  String get perkAfterimage => 'Hold stille: skud ×1,5';

  @override
  String get perkBulwark => 'Skade forbi skjoldet halveres';

  @override
  String get perkOverclock => 'Skyder op til 130 % af kapaciteten, langsommere';

  @override
  String get perkBattery => 'En gratis kampdrone flyver med';

  @override
  String get rewardTitle => 'BELØNNING';

  @override
  String newHull(String name) {
    return 'Nyt skrog: $name';
  }

  @override
  String get socketEmpty => 'tom';

  @override
  String fxStreams(int n) {
    return '$n parallelle stråler';
  }

  @override
  String fxFan(int n) {
    return 'Vifte af $n skud';
  }

  @override
  String fxSalvo(int n) {
    return 'Salve på $n skud';
  }

  @override
  String fxFireRate(String x) {
    return 'Skudhastighed ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Skade ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Projektilfart ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Projektilstørrelse ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energiforbrug ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Målsøgende +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Går gennem $n mål';
  }

  @override
  String get fxPierceAll => 'Går gennem alt';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % chance for ×$x skade';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kritiske på bosser';
  }

  @override
  String fxFork(int n) {
    return 'Drab spreder $n skud';
  }

  @override
  String get fxChain => 'Spredte skud spreder igen';

  @override
  String get fxSplit => 'Deler sig i to ved træf';

  @override
  String get fxFrost => 'Træffere sænker fjenders fart';

  @override
  String get fxCrossfire => 'Sidekanoner peger indad';

  @override
  String get fxRearguard => 'Sidekanoner skyder også bagud';

  @override
  String get fxOrbit => 'Skud slynger sig';

  @override
  String fxBounce(int n) {
    return 'Preller af væggene $n×';
  }

  @override
  String get fxBounceTop => '…og af toppen';

  @override
  String get fxOverdrive => 'Skyder på energigæld';

  @override
  String get fxReactor => 'Våben over kapacitet skyder stadig, langsomt';

  @override
  String fxGenPower(String x) {
    return 'Generatoropladning ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generatorkapacitet ×$x';
  }

  @override
  String get fxSurge => 'Fuld generator: skud ×2';

  @override
  String fxSiphon(int pct) {
    return 'Drab genfylder $pct % energi';
  }

  @override
  String fxHp(String x) {
    return 'Skrog ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Skjold ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Skjoldgendannelse ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Drab heler $n HP';
  }

  @override
  String get fxMagnet => 'Trækker bonusser til sig';

  @override
  String get fxMagnetAll => 'Trækker alle bonusser til sig';

  @override
  String fxReflect(int pct) {
    return '$pct % af skuddene preller tilbage fra skjoldet';
  }

  @override
  String get fxReflectGuided => 'Tilbagekastede skud søger mål';

  @override
  String fxGhost(String sec) {
    return 'Urørlig i $sec s efter et skrogtræf';
  }

  @override
  String get fxNova => 'Skjoldet brister: hele skærmen får en eksplosion';

  @override
  String fxAgility(String x) {
    return 'Manøvredygtighed ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Træfzone ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kreditter ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Point ×$x';
  }

  @override
  String get fxSatellite => 'En kampdrone flyver med';

  @override
  String get fxTimewarp => 'Et skrogtræf sænker tiden';

  @override
  String get fxGambler => 'Hvert skud er et tilfældigt våben';

  @override
  String get vaultAll => 'ALLE';
}
