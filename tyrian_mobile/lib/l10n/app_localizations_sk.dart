// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ZRUŠIŤ';

  @override
  String get connect => 'PRIPOJIŤ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Nepodarilo sa pripojiť k $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Hostiteľ bol viditeľný, ale spojenie sa nenadviazalo.\n\nHra v blízkosti potrebuje Wi-Fi peer-to-peer, ktoré iOS vypína, keď je zapnutý Osobný hotspot — vypnite hotspot na oboch zariadeniach a skúste to znova, alebo pripojte obe zariadenia k rovnakej Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Misia zlyhala — výbava a kredity zostávajú. Skúste znova z Veliteľského centra.';

  @override
  String get gameOverEndless =>
      'Obnova v Sektore 1 — výbava a kredity zostávajú';

  @override
  String get waitingForHost => 'Čaká sa na hostiteľa...';

  @override
  String get waitingForHostHint => 'Hra začne, keď bude hostiteľ pripravený';

  @override
  String get vesselLost => 'LOĎ STRATENÁ';

  @override
  String scoreValue(String score) {
    return 'Skóre: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredity: $credits';
  }

  @override
  String get creditsPrefix => 'Kredity: ';

  @override
  String get leaderboard => 'REBRÍČEK';

  @override
  String get achievements => 'ÚSPECHY';

  @override
  String get redeploy => 'DO BOJA';

  @override
  String get resume => 'POKRAČOVAŤ';

  @override
  String get pause => 'PAUZA';

  @override
  String get paused => 'POZASTAVENÉ';

  @override
  String get skins => 'VZHĽADY';

  @override
  String get skin => 'VZHĽAD';

  @override
  String get soundOn => 'ZVUK: ZAP';

  @override
  String get soundOff => 'ZVUK: VYP';

  @override
  String get musicOn => 'HUDBA: ZAP';

  @override
  String get musicOff => 'HUDBA: VYP';

  @override
  String get mainMenu => 'HLAVNÉ MENU';

  @override
  String get quitToDesktop => 'UKONČIŤ NA PLOCHU';

  @override
  String get selectSkin => 'VYBERTE VZHĽAD';

  @override
  String get difficulty => 'OBTIAŽNOSŤ';

  @override
  String get difficultyEasy => 'ĽAHKÁ';

  @override
  String get difficultyNormal => 'NORMÁLNA';

  @override
  String get difficultyHard => 'ŤAŽKÁ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPAŇ';

  @override
  String get quit => 'KONIEC';

  @override
  String get restorePurchases => 'OBNOVIŤ NÁKUPY';

  @override
  String get locked => 'ZAMKNUTÉ';

  @override
  String get mainMenuTooltip => 'Hlavné menu';

  @override
  String nodeLevel(int level) {
    return 'ÚROVEŇ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ÚROVEŇ $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Zamknuté. Najprv dokončite predchádzajúci uzol.';

  @override
  String get flyAgain => 'LETIEŤ ZNOVA';

  @override
  String get launch => 'ŠTART';

  @override
  String zoneLabel(int zone) {
    return 'ZÓNA $zone';
  }

  @override
  String get objectiveStar => 'HVIEZDA';

  @override
  String get continueButton => 'POKRAČOVAŤ';

  @override
  String get replayNode => 'ZOPAKOVAŤ UZOL';

  @override
  String get retry => 'ZNOVA';

  @override
  String get nodeCleared => 'UZOL SPLNENÝ';

  @override
  String get nodeFailed => 'UZOL NESPLNENÝ';

  @override
  String get weaponTierUnlocked => 'ODOMKNUTÁ ÚROVEŇ ZBRANÍ';

  @override
  String get onSaleInComCenter => 'Na predaj vo Veliteľskom centre.';

  @override
  String get requiredTasksHint =>
      'O uzle rozhodujú povinné úlohy. Leťte ho znova — čo ste získali, vám zostane.';

  @override
  String get objClear => 'Vyčistite sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zostreľte $count nepriateľov',
      many: 'Zostreľte $count nepriateľa',
      few: 'Zostreľte $count nepriateľov',
      one: 'Zostreľte 1 nepriateľa',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Neutrpte žiadne poškodenie trupu';

  @override
  String objHull(int percent) {
    return 'Dokončite s trupom nad $percent %';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zničte $count nepriateľov zbraňou $weapon',
      many: 'Zničte $count nepriateľa zbraňou $weapon',
      few: 'Zničte $count nepriateľov zbraňou $weapon',
      one: 'Zničte 1 nepriateľa zbraňou $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zničte $count nepriateľov bočnými zbraňami',
      many: 'Zničte $count nepriateľa bočnými zbraňami',
      few: 'Zničte $count nepriateľov bočnými zbraňami',
      one: 'Zničte 1 nepriateľa bočnými zbraňami',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Odštartujte so zbraňou $weapon vpredu';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Odštartujte so zbraňou $weapon na boku';
  }

  @override
  String get objBuySideGun => 'Kúpte bočnú zbraň vo Veliteľskom centre';

  @override
  String objUpgradeGenerator(int level) {
    return 'Vylepšite generátor na úroveň $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Vylepšite prednú zbraň na úroveň $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Vylepšite bočnú zbraň na úroveň $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chyťte $count bonusov',
      many: 'Chyťte $count bonusu',
      few: 'Chyťte $count bonusy',
      one: 'Chyťte 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zničte $count celých formácií',
      many: 'Zničte $count celej formácie',
      few: 'Zničte $count celé formácie',
      one: 'Zničte 1 celú formáciu',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Nenarazte do žiadneho asteroidu';

  @override
  String objUnderTime(int seconds) {
    return 'Dokončite do $seconds s';
  }

  @override
  String get objStripBoss => 'Zničte všetky časti bossa pred jadrom';

  @override
  String get joinCoopTitle => 'Pripojiť sa ku co-opu';

  @override
  String get cannotSearchNetwork => 'V tejto sieti nemožno hľadať';

  @override
  String get joinHintNearby =>
      'Rovnaká Wi-Fi funguje na každom zariadení. iPhone, iPad a Mac sa nájdu aj v blízkosti bez nej — s vypnutým Osobným hotspotom na oboch.';

  @override
  String get joinHintWifi =>
      'Obaja hráči musia byť na rovnakej Wi-Fi — funguje aj Osobný hotspot.';

  @override
  String noHostsYet(String hint) {
    return 'Zatiaľ žiadni hostitelia. $hint';
  }

  @override
  String get lookingForHosts =>
      'Hľadajú sa hostitelia na tejto Wi-Fi a v blízkosti…';

  @override
  String get hostNearby => 'V blízkosti · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · rovnaká Wi-Fi';
  }

  @override
  String get enterIpManually => 'Zadať IP ručne';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ŠT';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — CHRÁNENÝ ŠTÍTOM';
  }

  @override
  String get bossPartTurret => 'Veža';

  @override
  String get bossPartShieldPod => 'Štítový modul';

  @override
  String get bossPartThruster => 'Motor';

  @override
  String get bossPartCannon => 'Kanón';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Neznámy vesmír';
  }

  @override
  String get player2Joined => 'Hráč 2 sa pripojil!';

  @override
  String get player2Disconnected => 'Hráč 2 sa odpojil';

  @override
  String get hostDisconnected => 'Hostiteľ sa odpojil';

  @override
  String maxLevelSold(String amount) {
    return 'Max. úroveň! Predané za \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Odomknutá úroveň zbrane $tier';
  }

  @override
  String get cheatsEnabled => 'Cheaty zapnuté';

  @override
  String get cheatsDisabled => 'Cheaty vypnuté';

  @override
  String get cheatsMaxed => 'CHEAT: kredity na maxime, všetky zbrane odomknuté';

  @override
  String get cheats => 'CHEATY';

  @override
  String get maxCredits => 'MAX. KREDITY';

  @override
  String get sectionStats => 'ŠTATISTIKY';

  @override
  String get sectionLoadout => 'VÝBAVA';

  @override
  String levelShort(int level) {
    return 'Úr.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'VYL';

  @override
  String get sell => 'PREDAŤ';

  @override
  String get buy => 'KÚPIŤ';

  @override
  String get commandCenter => 'VELITEĽSKÉ CENTRUM';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SKÓRE';

  @override
  String get nextWeapon => 'ĎALŠIA ZBRAŇ';

  @override
  String pointsValue(String points) {
    return '$points b.';
  }

  @override
  String get slotFront => 'Predok';

  @override
  String get slotLeft => 'Vľavo';

  @override
  String get slotRight => 'Vpravo';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'SPUSTIŤ MISIU';

  @override
  String get startMission => 'ZAČAŤ MISIU';

  @override
  String get continueMission => 'POKRAČOVAŤ V MISII';

  @override
  String get padControlsHint =>
      '[↑↓] Riadok   [←→] Výber   [B] Kúpiť/Vylepšiť/Prepnúť   [X/Y] Predať   [OPTIONS] Pokračovať v misii';

  @override
  String get host => 'HOSTIŤ';

  @override
  String hostingAs(String name) {
    return 'HOSTÍTE ako $name';
  }

  @override
  String get join => 'PRIPOJIŤ';

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
  String get overload => 'PREŤAŽENIE';

  @override
  String weaponOff(String weapon) {
    return '$weapon VYP — slabý generátor';
  }

  @override
  String unlocksAt(String points) {
    return 'Odomkne sa pri $points b.';
  }

  @override
  String joinConnecting(String target) {
    return 'Pripája sa k $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Hostiteľ neodpovedal: $reason.\n\nObaja hráči musia byť na rovnakej Wi-Fi (funguje aj Osobný hotspot) a hostiteľ musí stlačiť HOSTIŤ. Skontrolujte adresu a skúste to znova.';
  }

  @override
  String get lanJoinNoAnswer => 'bez odpovede';

  @override
  String objBossUnder(int seconds) {
    return 'Zničte jadro bossa do $seconds s od jeho príchodu';
  }

  @override
  String get sectionHangar => 'HANGÁR';

  @override
  String get sectionVault => 'TREZOR';

  @override
  String get rackSide => 'Bok';

  @override
  String get rackHull => 'Trup';

  @override
  String get rarityCommon => 'BEŽNÝ';

  @override
  String get rarityRare => 'VZÁCNY';

  @override
  String get rarityMythic => 'MÝTICKÝ';

  @override
  String get curse => 'KLIATBA';

  @override
  String get modFit => 'OSADIŤ';

  @override
  String get modUnfit => 'VYBRAŤ';

  @override
  String get modForge => 'KOVÁČSTVO';

  @override
  String get forgeHint => 'Vyberte 3 jednej vzácnosti a ukujte 1 vyššej';

  @override
  String get vaultEmpty =>
      'Zatiaľ žiadne mody. Dokončite uzol na všetky hviezdy, porazte bossa rýchlo alebo zostreľte bossa v nekonečnom režime.';

  @override
  String modNeeds(String families) {
    return 'Funguje s: $families';
  }

  @override
  String get modRackFull => 'Stojan je plný';

  @override
  String get modAlreadyFitted => 'Už je osadený';

  @override
  String get modWrongRack => 'Nehodí sa do tohto stojana';

  @override
  String modsSpilled(int n) {
    return 'Modov späť v trezore: $n';
  }

  @override
  String get hullLocked => 'Zamknutý';

  @override
  String hullUnlockBoss(int n) {
    return 'Porazte bossa kampane $n';
  }

  @override
  String get hullUnlockFinish => 'Dokončite kampaň alebo dosiahnite sektor 30';

  @override
  String get statAgility => 'OBR';

  @override
  String get statHitbox => 'ZÁS';

  @override
  String get perkNone => 'Sériová loď';

  @override
  String get perkAfterimage => 'Stojte na mieste: strely ×1,5';

  @override
  String get perkBulwark => 'Poškodenie za štítom je polovičné';

  @override
  String get perkOverclock =>
      'Strieľa zo zbraní až do 130 % kapacity, pomalšie';

  @override
  String get perkBattery => 'Letí s vami bezplatný bojový dron';

  @override
  String get rewardTitle => 'ODMENA';

  @override
  String newHull(String name) {
    return 'Nový trup: $name';
  }

  @override
  String get socketEmpty => 'prázdne';

  @override
  String fxStreams(int n) {
    return 'Paralelné prúdy: $n';
  }

  @override
  String fxFan(int n) {
    return 'Vejár striel: $n';
  }

  @override
  String fxSalvo(int n) {
    return 'Salva $n striel';
  }

  @override
  String fxFireRate(String x) {
    return 'Kadencia ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Poškodenie ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Rýchlosť striel ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Veľkosť striel ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Spotreba energie ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Navádzanie +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Prestrelí ciele: $n';
  }

  @override
  String get fxPierceAll => 'Prestrelí všetko';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % šanca na poškodenie ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Kritické zásahy ×$x na bossov';
  }

  @override
  String fxFork(int n) {
    return 'Zostrely rozprášia strely: $n';
  }

  @override
  String get fxChain => 'Rozprášené strely sa rozprášia znova';

  @override
  String get fxSplit => 'Pri zásahu sa rozdelí na dve';

  @override
  String get fxFrost => 'Zásahy spomaľujú nepriateľov';

  @override
  String get fxCrossfire => 'Bočné zbrane mieria dovnútra';

  @override
  String get fxRearguard => 'Bočné zbrane strieľajú aj dozadu';

  @override
  String get fxOrbit => 'Strely sa vlnia';

  @override
  String fxBounce(int n) {
    return 'Odráža sa od stien $n×';
  }

  @override
  String get fxBounceTop => '…aj od vrchu';

  @override
  String get fxOverdrive => 'Strieľa na dlh energie';

  @override
  String get fxReactor => 'Preťažené zbrane stále strieľajú, pomaly';

  @override
  String fxGenPower(String x) {
    return 'Nabíjanie generátora ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Kapacita generátora ×$x';
  }

  @override
  String get fxSurge => 'Plný generátor: strely ×2';

  @override
  String fxSiphon(int pct) {
    return 'Zostrely doplnia $pct % energie';
  }

  @override
  String fxHp(String x) {
    return 'Trup ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Štít ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regenerácia štítu ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Zostrely liečia $n HP';
  }

  @override
  String get fxMagnet => 'Priťahuje bonusy';

  @override
  String get fxMagnetAll => 'Priťahuje každý bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % striel sa od štítu odrazí späť';
  }

  @override
  String get fxReflectGuided => 'Odrazené strely sa navádzajú';

  @override
  String fxGhost(String sec) {
    return 'Nedotknuteľný $sec s po zásahu trupu';
  }

  @override
  String get fxNova => 'Prasknutý štít: výbuch cez celú obrazovku';

  @override
  String fxAgility(String x) {
    return 'Obratnosť ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zásahová zóna ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kredity ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Skóre ×$x';
  }

  @override
  String get fxSatellite => 'Letí s vami bojový dron';

  @override
  String get fxTimewarp => 'Zásah trupu spomalí čas';

  @override
  String get fxGambler => 'Každá strela je náhodná zbraň';

  @override
  String get vaultAll => 'VŠETKO';

  @override
  String get sigilMissUnknown => 'neznámy tvar';

  @override
  String get sigilMissTooSlow => 'príliš pomaly';

  @override
  String get sigilMissSkippedDot => 'vynechaný bod';

  @override
  String get sigilMissLeftRimEarly => 'pustené príliš skoro';

  @override
  String get sigilMissWrongDirection => 'nakreslené opačne';

  @override
  String get sigilMissWrongLayer => 'nesprávne bočné tlačidlo';

  @override
  String get sigilDry => 'nedostatok náboja';

  @override
  String get sigilBusy => 'predchádzajúci ešte beží';

  @override
  String get arena => 'ARÉNA';

  @override
  String get arenaBossParts => 'ČASTI BOSSA';

  @override
  String get arenaBareCore => 'holé jadro';

  @override
  String get arenaCompanions => 'SPOLOČNÍCI';

  @override
  String get arenaCharge => 'NÁBOJ';

  @override
  String get arenaChargeNormal => 'NORMÁLNY';

  @override
  String get arenaSpeed => 'RÝCHLOSŤ SVETA';

  @override
  String get arenaDrill => 'CVIČENIE';

  @override
  String get arenaFreePlay => 'VOĽNÁ HRA';

  @override
  String get arenaFight => 'BOJ';

  @override
  String get arenaNewBoss => 'NOVÝ BOSS';

  @override
  String get arenaLeave => 'OPUSTIŤ ARÉNU';

  @override
  String get arenaHint => 'Boss sa vráti hneď, ako zomrie. Nič sa tu neukladá.';

  @override
  String get arenaColCast => 'POUŽITIA';

  @override
  String get arenaColMiss => 'CHYBY';

  @override
  String get arenaColAvg => 'PRIEMER';

  @override
  String get arenaColBest => 'NAJLEPŠIE';

  @override
  String get arenaColTime => 'NAJRÝCHLEJŠIE';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossovia $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'OVLÁDAČ: SIGILY';

  @override
  String get padSchemeClassic => 'OVLÁDAČ: KLASIKA';

  @override
  String get padSouthpawOn => 'ĽAVÁK: ZAP';

  @override
  String get padSouthpawOff => 'ĽAVÁK: VYP';

  @override
  String get sigilDescHop => 'Rýchly skok v smere švihu';

  @override
  String get sigilDescSidestep => 'Dlhý úkrok naprieč poľom';

  @override
  String get sigilDescStrike => 'Výpad vpred s tromi ťažkými strelami a späť';

  @override
  String get sigilDescRetreat => 'Ústup, zatiaľ čo krycia paľba letí vpred';

  @override
  String get sigilDescDash => 'Šikmý prienik paľbou, v polovici nezraniteľný';

  @override
  String get sigilDescRoll => 'Výkrut do strany, nezraniteľný';

  @override
  String get sigilDescShadow =>
      'Zaves sa pod najbližšieho nepriateľa a strieľaj';

  @override
  String get sigilDescEcho =>
      'Tieň zopakuje tvoje posledné dve sekundy za polovičné poškodenie';

  @override
  String get sigilDescLoop => 'Looping cez vrch: strely prejdú pod tebou';

  @override
  String get sigilDescSlalom =>
      'Esovitá krivka naprieč poľom s vejárovou paľbou';

  @override
  String get sigilDescCorkscrew =>
      'Vývrtka vpred so streľbou dookola, nezraniteľný';

  @override
  String get sigilDescSnapshot => 'Jedna ťažká strela v smere švihu';

  @override
  String get sigilDescBroadside => 'Salva z oboch bokov';

  @override
  String get sigilDescVolley => 'Päť nabitých lúčov vpred';

  @override
  String get sigilDescCaltrop => 'Odhoď mínu, ktorá pohltí strely a vybuchne';

  @override
  String get sigilDescFrenzy => 'Zbrane na pár sekúnd strieľajú rýchlejšie';

  @override
  String get sigilDescStasis => 'Nepriatelia a ich strely spomalia na polovicu';

  @override
  String get sigilDescHalo =>
      'Štít sa nabíja štyrikrát rýchlejšie a nič neprejde';

  @override
  String get sigilDescRadial => 'Kruh šestnástich striel';

  @override
  String get sigilDescStorm => 'Všetky zbrane naplno, zadarmo';

  @override
  String get sigilDescPing => 'Spoločníci sústredia paľbu v smere švihu';

  @override
  String get sigilDescWingman => 'Privolaj krídelníka na bok, kam si kreslil';

  @override
  String get sigilDescHunter =>
      'Privolaj lovca, ktorý letí vpred a vyberá ciele';

  @override
  String get sigilDescWarden => 'Privolaj strážcu, ktorý chytá strely za teba';

  @override
  String get sigilDescFormation =>
      'Spoločníci prepínajú medzi širokou a klinom';

  @override
  String get sigilDescWhirl => 'Spoločníci krúžia okolo teba a pohlcujú strely';

  @override
  String get sigilDescSacrifice =>
      'Spoločníci sa vrhnú a vybuchnú, vrátia náboj';

  @override
  String get grimoire => 'GRIMOÁR';

  @override
  String get grimoireHint =>
      'Kresli pravou páčkou. LB pre ZBRANE, RB pre KRÍDLO, obe pre MEGA VÝBUCH.';

  @override
  String sigilCost(int cost) {
    return 'cena $cost';
  }

  @override
  String get sigilUntouchable => 'nezraniteľný';

  @override
  String get lessonWatch => 'POZERAJ';

  @override
  String get lessonTrace => 'OBKRESLI';

  @override
  String get lessonSlow => 'POMALY';

  @override
  String get lessonLive => 'PLNÁ RÝCHLOSŤ';

  @override
  String get lessonStreak => 'PÄŤ ZA SEBOU';

  @override
  String get lessonLearned => 'NAUČENÉ';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Švihni pravou páčkou';

  @override
  String get hintLoop => 'Nakresli kruh: preletíš nad strelami';

  @override
  String get hintStream => 'Stlač LT: dva alebo tri prúdy';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'ŽIADNA';

  @override
  String kataNext(String sigil, String secs) {
    return 'ďalší $sigil o $secs s';
  }

  @override
  String get arenaGauntlet => 'SKÚŠKA';

  @override
  String get arenaOn => 'ZAP';

  @override
  String get arenaOff => 'VYP';

  @override
  String gauntletRating(int rating, int best) {
    return 'Hodnotenie $rating · najlepšie $best';
  }
}
