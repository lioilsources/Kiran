// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'AVBRYT';

  @override
  String get connect => 'KOBLE TIL';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Kunne ikke koble til $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Verten var synlig, men forbindelsen kom ikke opp.\n\nSpill i nærheten krever node-til-node-Wi-Fi, som iOS slår av mens Delt Internett er på — slå av delingen på begge enhetene og prøv igjen, eller koble begge enhetene til samme Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Oppdraget mislyktes — utstyr og kreditter beholdes. Prøv igjen fra Kommandosentralen.';

  @override
  String get gameOverEndless =>
      'Bygger opp igjen i Sektor 1 — utstyr og kreditter beholdes';

  @override
  String get waitingForHost => 'Venter på vert...';

  @override
  String get waitingForHostHint => 'Spillet starter når verten er klar';

  @override
  String get vesselLost => 'SKIPET TAPT';

  @override
  String scoreValue(String score) {
    return 'Poeng: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kreditter: $credits';
  }

  @override
  String get creditsPrefix => 'Kreditter: ';

  @override
  String get leaderboard => 'TOPPLISTE';

  @override
  String get achievements => 'PRESTASJONER';

  @override
  String get redeploy => 'TILBAKE I KAMP';

  @override
  String get resume => 'FORTSETT';

  @override
  String get pause => 'PAUSE';

  @override
  String get paused => 'PAUSET';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'LYD: PÅ';

  @override
  String get soundOff => 'LYD: AV';

  @override
  String get musicOn => 'MUSIKK: PÅ';

  @override
  String get musicOff => 'MUSIKK: AV';

  @override
  String get mainMenu => 'HOVEDMENY';

  @override
  String get quitToDesktop => 'AVSLUTT TIL SKRIVEBORDET';

  @override
  String get selectSkin => 'VELG SKIN';

  @override
  String get difficulty => 'VANSKELIGHETSGRAD';

  @override
  String get difficultyEasy => 'LETT';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'VANSKELIG';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANJE';

  @override
  String get quit => 'AVSLUTT';

  @override
  String get restorePurchases => 'GJENOPPRETT KJØP';

  @override
  String get locked => 'LÅST';

  @override
  String get mainMenuTooltip => 'Hovedmeny';

  @override
  String nodeLevel(int level) {
    return 'NIVÅ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVÅ $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Låst. Klar forrige node først.';

  @override
  String get flyAgain => 'FLY IGJEN';

  @override
  String get launch => 'AVGANG';

  @override
  String zoneLabel(int zone) {
    return 'SONE $zone';
  }

  @override
  String get objectiveStar => 'STJERNE';

  @override
  String get continueButton => 'FORTSETT';

  @override
  String get replayNode => 'SPILL NODEN IGJEN';

  @override
  String get retry => 'PRØV IGJEN';

  @override
  String get nodeCleared => 'NODE KLART';

  @override
  String get nodeFailed => 'NODE MISLYKTES';

  @override
  String get weaponTierUnlocked => 'VÅPENNIVÅ LÅST OPP';

  @override
  String get onSaleInComCenter => 'Til salgs i Kommandosentralen.';

  @override
  String get requiredTasksHint =>
      'De påkrevde oppgavene avgjør noden. Fly den igjen — det du har tjent, beholder du.';

  @override
  String get objClear => 'Rydd sektoren';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skyt ned $count fiender',
      one: 'Skyt ned 1 fiende',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ikke ta skade på skroget';

  @override
  String objHull(int percent) {
    return 'Avslutt med over $percent% skrog';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Drep $count med $weapon',
      one: 'Drep 1 med $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Drep $count med sidekanonene',
      one: 'Drep 1 med sidekanonene',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Fly ut med $weapon foran';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Fly ut med $weapon på et sidefeste';
  }

  @override
  String get objBuySideGun => 'Kjøp en sidekanon i Kommandosentralen';

  @override
  String objUpgradeGenerator(int level) {
    return 'Oppgrader generatoren til nivå $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Oppgrader frontkanonen til nivå $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Oppgrader en sidekanon til nivå $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plukk opp $count bonuser',
      one: 'Plukk opp 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Utslett $count hele formasjoner',
      one: 'Utslett 1 hel formasjon',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ikke kollider med noen asteroider';

  @override
  String objUnderTime(int seconds) {
    return 'Fullfør innen $seconds s';
  }

  @override
  String get objStripBoss => 'Ødelegg alle bossens deler før kjernen';

  @override
  String get joinCoopTitle => 'Bli med i co-op';

  @override
  String get cannotSearchNetwork => 'Kan ikke søke i dette nettverket';

  @override
  String get joinHintNearby =>
      'Samme Wi-Fi fungerer på alle enheter. iPhone, iPad og Mac finner også hverandre i nærheten uten — med Delt Internett av på begge.';

  @override
  String get joinHintWifi =>
      'Begge spillerne må være på samme Wi-Fi — Delt Internett fungerer også.';

  @override
  String noHostsYet(String hint) {
    return 'Ingen verter ennå. $hint';
  }

  @override
  String get lookingForHosts =>
      'Leter etter verter på dette Wi-Fi-nettet og i nærheten…';

  @override
  String get hostNearby => 'I nærheten · Bluetooth / node-til-node-Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · samme Wi-Fi';
  }

  @override
  String get enterIpManually => 'Skriv inn IP manuelt';

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
    return '$name — SKJERMET';
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
    return 'Sektor $level — Ukjent rom';
  }

  @override
  String get player2Joined => 'Spiller 2 er med!';

  @override
  String get player2Disconnected => 'Spiller 2 koblet fra';

  @override
  String get hostDisconnected => 'Verten koblet fra';

  @override
  String maxLevelSold(String amount) {
    return 'Maks nivå! Solgt for \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Våpennivå $tier låst opp';
  }

  @override
  String get cheatsEnabled => 'Juksekoder på';

  @override
  String get cheatsDisabled => 'Juksekoder av';

  @override
  String get cheatsMaxed => 'JUKS: kreditter maksimert, alle våpen låst opp';

  @override
  String get cheats => 'JUKS';

  @override
  String get maxCredits => 'MAKS KREDITTER';

  @override
  String get sectionStats => 'STATISTIKK';

  @override
  String get sectionLoadout => 'UTSTYR';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'OPPG';

  @override
  String get sell => 'SELG';

  @override
  String get buy => 'KJØP';

  @override
  String get commandCenter => 'KOMMANDOSENTRAL';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'POENG';

  @override
  String get nextWeapon => 'NESTE VÅPEN';

  @override
  String pointsValue(String points) {
    return '$points p';
  }

  @override
  String get slotFront => 'Front';

  @override
  String get slotLeft => 'Venstre';

  @override
  String get slotRight => 'Høyre';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'SEND UT OPPDRAG';

  @override
  String get startMission => 'START OPPDRAG';

  @override
  String get continueMission => 'FORTSETT OPPDRAG';

  @override
  String get padControlsHint =>
      '[↑↓] Rad   [←→] Velg   [B] Kjøp/Oppgrader/Bytt   [X/Y] Selg   [OPTIONS] Fortsett oppdrag';

  @override
  String get host => 'VERT';

  @override
  String hostingAs(String name) {
    return 'VERT som $name';
  }

  @override
  String get join => 'BLI MED';

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
    return '$weapon AV — for svak generator';
  }

  @override
  String unlocksAt(String points) {
    return 'Låses opp ved $points p';
  }

  @override
  String joinConnecting(String target) {
    return 'Kobler til $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Verten svarte ikke: $reason.\n\nBegge spillerne må være på samme Wi-Fi (Delt Internett fungerer også), og verten må ha trykket VERT. Sjekk adressen og prøv igjen.';
  }

  @override
  String get lanJoinNoAnswer => 'intet svar';

  @override
  String objBossUnder(int seconds) {
    return 'Ødelegg bossens kjerne innen $seconds s etter at den dukker opp';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'HVELV';

  @override
  String get rackSide => 'Side';

  @override
  String get rackHull => 'Skrog';

  @override
  String get rarityCommon => 'VANLIG';

  @override
  String get rarityRare => 'SJELDEN';

  @override
  String get rarityMythic => 'MYTISK';

  @override
  String get curse => 'FORBANNELSE';

  @override
  String get modFit => 'MONTER';

  @override
  String get modUnfit => 'DEMONTER';

  @override
  String get modForge => 'SMIE';

  @override
  String get forgeHint => 'Velg 3 av samme sjeldenhet for å smi 1 av neste';

  @override
  String get vaultEmpty =>
      'Ingen modder ennå. Klar en node med alle stjerner, slå en boss raskt eller skyt ned en boss i endeløs modus.';

  @override
  String modNeeds(String families) {
    return 'Virker med $families';
  }

  @override
  String get modRackFull => 'Stativet er fullt';

  @override
  String get modAlreadyFitted => 'Allerede montert';

  @override
  String get modWrongRack => 'Passer ikke i dette stativet';

  @override
  String modsSpilled(int n) {
    return '$n modder tilbake i hvelvet';
  }

  @override
  String get hullLocked => 'Låst';

  @override
  String hullUnlockBoss(int n) {
    return 'Slå kampanjeboss $n';
  }

  @override
  String get hullUnlockFinish => 'Fullfør kampanjen eller nå sektor 30';

  @override
  String get statAgility => 'SMI';

  @override
  String get statHitbox => 'TREFF';

  @override
  String get perkNone => 'Standardskip';

  @override
  String get perkAfterimage => 'Stå stille: skudd ×1,5';

  @override
  String get perkBulwark => 'Skade forbi skjoldet halveres';

  @override
  String get perkOverclock => 'Skyter opptil 130 % av kapasiteten, saktere';

  @override
  String get perkBattery => 'En gratis kampdrone flyr med';

  @override
  String get rewardTitle => 'BELØNNING';

  @override
  String newHull(String name) {
    return 'Nytt skrog: $name';
  }

  @override
  String get socketEmpty => 'tom';

  @override
  String fxStreams(int n) {
    return '$n parallelle stråler';
  }

  @override
  String fxFan(int n) {
    return 'Vifte av $n skudd';
  }

  @override
  String fxSalvo(int n) {
    return 'Salve på $n skudd';
  }

  @override
  String fxFireRate(String x) {
    return 'Skuddtakt ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Skade ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Prosjektilfart ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Prosjektilstørrelse ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energibruk ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Målsøkende +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Går gjennom $n mål';
  }

  @override
  String get fxPierceAll => 'Går gjennom alt';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % sjanse for ×$x skade';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kritiske mot bosser';
  }

  @override
  String fxFork(int n) {
    return 'Drap sprer $n skudd';
  }

  @override
  String get fxChain => 'Spredte skudd sprer seg igjen';

  @override
  String get fxSplit => 'Deler seg i to ved treff';

  @override
  String get fxFrost => 'Treff bremser fiender';

  @override
  String get fxCrossfire => 'Sidekanonene sikter innover';

  @override
  String get fxRearguard => 'Sidekanonene skyter også bakover';

  @override
  String get fxOrbit => 'Skuddene slynger seg';

  @override
  String fxBounce(int n) {
    return 'Spretter av veggene $n×';
  }

  @override
  String get fxBounceTop => '…og av toppen';

  @override
  String get fxOverdrive => 'Skyter på energigjeld';

  @override
  String get fxReactor => 'Våpen over kapasitet skyter likevel, sakte';

  @override
  String fxGenPower(String x) {
    return 'Generatorlading ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generatorkapasitet ×$x';
  }

  @override
  String get fxSurge => 'Full generator: skudd ×2';

  @override
  String fxSiphon(int pct) {
    return 'Drap fyller på $pct % energi';
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
    return 'Skjoldgjenoppbygging ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Drap helbreder $n HP';
  }

  @override
  String get fxMagnet => 'Trekker til seg bonuser';

  @override
  String get fxMagnetAll => 'Trekker til seg alle bonuser';

  @override
  String fxReflect(int pct) {
    return '$pct % av skuddene spretter tilbake fra skjoldet';
  }

  @override
  String get fxReflectGuided => 'Reflekterte skudd søker mål';

  @override
  String fxGhost(String sec) {
    return 'Urørlig i $sec s etter et skrogtreff';
  }

  @override
  String get fxNova => 'Skjoldet brister: hele skjermen får en eksplosjon';

  @override
  String fxAgility(String x) {
    return 'Smidighet ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Treffsone ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kreditter ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Poeng ×$x';
  }

  @override
  String get fxSatellite => 'En kampdrone flyr med';

  @override
  String get fxTimewarp => 'Et skrogtreff bremser tiden';

  @override
  String get fxGambler => 'Hvert skudd er et tilfeldig våpen';

  @override
  String get vaultAll => 'ALLE';

  @override
  String get sigilMissUnknown => 'ukjent form';

  @override
  String get sigilMissTooSlow => 'for sakte';

  @override
  String get sigilMissSkippedDot => 'hoppet over et punkt';

  @override
  String get sigilMissLeftRimEarly => 'sluppet for tidlig';

  @override
  String get sigilMissWrongDirection => 'tegnet baklengs';

  @override
  String get sigilMissWrongLayer => 'feil skulderknapp';

  @override
  String get sigilDry => 'ikke nok ladning';

  @override
  String get sigilBusy => 'forrige kjører fortsatt';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BOSSDELER';

  @override
  String get arenaBareCore => 'naken kjerne';

  @override
  String get arenaCompanions => 'LEDSAGERE';

  @override
  String get arenaCharge => 'LADNING';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VERDENSFART';

  @override
  String get arenaDrill => 'ØVELSE';

  @override
  String get arenaFreePlay => 'FRI SPILL';

  @override
  String get arenaFight => 'KJEMP';

  @override
  String get arenaNewBoss => 'NY BOSS';

  @override
  String get arenaLeave => 'FORLAT ARENA';

  @override
  String get arenaHint =>
      'Bossen kommer tilbake i det den dør. Ingenting lagres her.';

  @override
  String get arenaColCast => 'KAST';

  @override
  String get arenaColMiss => 'BOM';

  @override
  String get arenaColAvg => 'SNITT';

  @override
  String get arenaColBest => 'BESTE';

  @override
  String get arenaColTime => 'RASKEST';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bosser $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILER';

  @override
  String get padSchemeClassic => 'PAD: KLASSISK';

  @override
  String get padSouthpawOn => 'VENSTREHENDT: PÅ';

  @override
  String get padSouthpawOff => 'VENSTREHENDT: AV';

  @override
  String get sigilDescHop => 'Et raskt hopp dit du sveiper';

  @override
  String get sigilDescSidestep => 'Et langt sidesteg over feltet';

  @override
  String get sigilDescStrike =>
      'Utfall fremover med tre tunge skudd, så tilbake';

  @override
  String get sigilDescRetreat =>
      'Trekk deg tilbake mens dekningsild går fremover';

  @override
  String get sigilDescDash => 'Et diagonalt rush gjennom ild, urørlig midtveis';

  @override
  String get sigilDescRoll => 'En tønnerull til siden, urørlig';

  @override
  String get sigilDescShadow =>
      'Lås deg under nærmeste fiende og fortsett å skyte';

  @override
  String get sigilDescEcho =>
      'En skygge gjentar dine siste to sekunder med halv skade';

  @override
  String get sigilDescLoop => 'Loop over toppen: skudd passerer under deg';

  @override
  String get sigilDescSlalom => 'En S-kurve over feltet med vifteild';

  @override
  String get sigilDescCorkscrew =>
      'Korketrekker fremover med ild rundt, urørlig';

  @override
  String get sigilDescSnapshot => 'Ett tungt skudd dit du sveiper';

  @override
  String get sigilDescBroadside => 'En salve fra begge flanker';

  @override
  String get sigilDescVolley => 'Fem ladde stråler fremover';

  @override
  String get sigilDescCaltrop =>
      'Slipp en mine som sluker skudd og eksploderer';

  @override
  String get sigilDescFrenzy => 'Våpnene skyter raskere i noen sekunder';

  @override
  String get sigilDescStasis => 'Fiender og skuddene deres går i halv fart';

  @override
  String get sigilDescHalo =>
      'Skjoldet lades fire ganger raskere og ingenting slipper gjennom';

  @override
  String get sigilDescRadial => 'En ring av seksten skudd';

  @override
  String get sigilDescStorm => 'Alle våpen skyter for fullt, gratis';

  @override
  String get sigilDescPing => 'Ledsagerne samler ilden dit du sveiper';

  @override
  String get sigilDescWingman => 'Kall en vingmann til flanken du tegnet mot';

  @override
  String get sigilDescHunter => 'Kall en jeger som flyr foran og velger mål';

  @override
  String get sigilDescWarden => 'Kall en vokter som tar skuddene ment for deg';

  @override
  String get sigilDescFormation => 'Ledsagerne bytter mellom bred og kile';

  @override
  String get sigilDescWhirl => 'Ledsagerne sirkler rundt deg og sluker skudd';

  @override
  String get sigilDescSacrifice =>
      'Ledsagerne stuper og eksploderer, gir ladning tilbake';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Tegn med høyre stikke. Hold LB for ARMS, RB for WING, begge for MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'pris $cost';
  }

  @override
  String get sigilUntouchable => 'urørlig';

  @override
  String get lessonWatch => 'SE';

  @override
  String get lessonTrace => 'TEGN ETTER';

  @override
  String get lessonSlow => 'SAKTE';

  @override
  String get lessonLive => 'FULL FART';

  @override
  String get lessonStreak => 'FEM PÅ RAD';

  @override
  String get lessonLearned => 'LÆRT';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Sveip høyre stikke';

  @override
  String get hintLoop => 'Tegn en sirkel: du flyr over skuddene';

  @override
  String get hintStream => 'Klem LT: to eller tre stråler';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'INGEN';

  @override
  String kataNext(String sigil, String secs) {
    return 'neste $sigil om $secs s';
  }

  @override
  String get arenaGauntlet => 'GAUNTLET';

  @override
  String get arenaOn => 'PÅ';

  @override
  String get arenaOff => 'AV';

  @override
  String gauntletRating(int rating, int best) {
    return 'Vurdering $rating · beste $best';
  }

  @override
  String get duelWarning => 'ADVARSEL';

  @override
  String get duelHintPad1 => 'Høyre stikke sikter og skyter';

  @override
  String get duelHintPad2Rt =>
      'Hold RT, LB eller RB: høyre stikke tegner sigiler';

  @override
  String get duelHintPad2Lt =>
      'Hold LT, LB eller RB: høyre stikke tegner sigiler';

  @override
  String get duelHintClassic =>
      'Venstre stikke flyr · B, RB eller RT skyter dit nesen peker';

  @override
  String get duelHintKeys1 => 'Piltaster sikter og skyter · WASD flyr';

  @override
  String get duelHintKeys2 =>
      'Mellomrom skyter dit nesen peker · talltastaturet tegner sigiler';

  @override
  String get arenaDuelBinding => 'DUELLSTILLING';

  @override
  String get duelBindingRt => 'RT + STIKKE';

  @override
  String get duelBindingLt => 'LT + STIKKE';

  @override
  String get arenaDuelFrame => 'PAD FREMOVER';

  @override
  String get duelFrameNose => 'NESEN';

  @override
  String get duelFrameUp => 'OPP';

  @override
  String get arenaDuelAimFires => 'SIKTING SKYTER';

  @override
  String get duelCutInFirst => 'BOSS NÆRBILDE: FØRSTE GANG';

  @override
  String get duelCutInAlways => 'BOSS NÆRBILDE: ALLTID';

  @override
  String get duelCutInNever => 'BOSS NÆRBILDE: ALDRI';

  @override
  String get arenaDuelDrill => 'DUELLØVELSE';

  @override
  String get duelDrillOff => 'INGEN';

  @override
  String get duelDrillAim => 'SIKT OG SKYT';

  @override
  String get duelDrillAimHow => 'Pek høyre stikke mot bossen og treff den';

  @override
  String get duelDrillHold => 'HOLD NESEN';

  @override
  String get duelDrillHoldHow =>
      'Hold en stillingsknapp og fly: nesen står stille';

  @override
  String get duelDrillDraw => 'TEGN FREMOVER';

  @override
  String get duelDrillDrawHow => 'I stillingen, tegn en sigil mot bossen';

  @override
  String get duelDrillTurn => 'SNU';

  @override
  String get duelDrillTurnHow => 'Bossen er under deg: snu nesen og treff den';

  @override
  String get duelDrillDone => 'FERDIG';
}
