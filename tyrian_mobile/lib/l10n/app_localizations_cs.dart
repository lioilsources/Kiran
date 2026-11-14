// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ZRUŠIT';

  @override
  String get connect => 'PŘIPOJIT';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Nelze se připojit k $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Hostitel byl vidět, ale spojení se nenavázalo.\n\nHra na blízko potřebuje Wi-Fi peer-to-peer, kterou iOS vypíná, když je zapnutý osobní hotspot. Vypněte hotspot na obou zařízeních a zkuste to znovu, nebo obě zařízení připojte ke stejné Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Mise selhala — výbava i kredity zůstávají. Zkus to znovu z Velitelského centra.';

  @override
  String get gameOverEndless =>
      'Obnova v sektoru 1 — výbava i kredity zůstávají';

  @override
  String get waitingForHost => 'Čekám na hostitele...';

  @override
  String get waitingForHostHint => 'Hra začne, až bude hostitel připraven';

  @override
  String get vesselLost => 'LOĎ ZNIČENA';

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
  String get leaderboard => 'ŽEBŘÍČEK';

  @override
  String get achievements => 'ÚSPĚCHY';

  @override
  String get redeploy => 'ZNOVU DO AKCE';

  @override
  String get resume => 'POKRAČOVAT';

  @override
  String get pause => 'PAUZA';

  @override
  String get paused => 'POZASTAVENO';

  @override
  String get skins => 'VZHLEDY';

  @override
  String get skin => 'VZHLED';

  @override
  String get soundOn => 'ZVUK: ZAP';

  @override
  String get soundOff => 'ZVUK: VYP';

  @override
  String get musicOn => 'HUDBA: ZAP';

  @override
  String get musicOff => 'HUDBA: VYP';

  @override
  String get mainMenu => 'HLAVNÍ MENU';

  @override
  String get quitToDesktop => 'UKONČIT NA PLOCHU';

  @override
  String get selectSkin => 'VYBER VZHLED';

  @override
  String get difficulty => 'OBTÍŽNOST';

  @override
  String get difficultyEasy => 'LEHKÁ';

  @override
  String get difficultyNormal => 'NORMÁLNÍ';

  @override
  String get difficultyHard => 'TĚŽKÁ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPAŇ';

  @override
  String get quit => 'KONEC';

  @override
  String get restorePurchases => 'OBNOVIT NÁKUPY';

  @override
  String get locked => 'ZAMČENO';

  @override
  String get mainMenuTooltip => 'Hlavní menu';

  @override
  String nodeLevel(int level) {
    return 'ÚROVEŇ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ÚROVEŇ $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Zamčeno. Nejdřív dokonči předchozí misi.';

  @override
  String get flyAgain => 'LETĚT ZNOVU';

  @override
  String get launch => 'START';

  @override
  String zoneLabel(int zone) {
    return 'ZÓNA $zone';
  }

  @override
  String get objectiveStar => 'HVĚZDA';

  @override
  String get continueButton => 'POKRAČOVAT';

  @override
  String get replayNode => 'ZOPAKOVAT MISI';

  @override
  String get retry => 'ZKUSIT ZNOVU';

  @override
  String get nodeCleared => 'MISE SPLNĚNA';

  @override
  String get nodeFailed => 'MISE SELHALA';

  @override
  String get weaponTierUnlocked => 'NOVÁ ÚROVEŇ ZBRANÍ';

  @override
  String get onSaleInComCenter => 'K mání ve Velitelském centru.';

  @override
  String get requiredTasksHint =>
      'O misi rozhodují povinné úkoly. Leť znovu — co jsi získal, ti zůstane.';

  @override
  String get objClear => 'Vyčisti sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sestřel $count nepřátel',
      few: 'Sestřel $count nepřátele',
      one: 'Sestřel 1 nepřítele',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Neutrp žádné poškození trupu';

  @override
  String objHull(int percent) {
    return 'Dokonči s trupem nad $percent %';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znič $count nepřátel zbraní $weapon',
      few: 'Znič $count nepřátele zbraní $weapon',
      one: 'Znič 1 nepřítele zbraní $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znič $count nepřátel bočními zbraněmi',
      few: 'Znič $count nepřátele bočními zbraněmi',
      one: 'Znič 1 nepřítele bočními zbraněmi',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Odstartuj se zbraní $weapon vpředu';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Odstartuj se zbraní $weapon na boku';
  }

  @override
  String get objBuySideGun => 'Kup boční zbraň ve Velitelském centru';

  @override
  String objUpgradeGenerator(int level) {
    return 'Vylepši generátor na úroveň $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Vylepši přední zbraň na úroveň $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Vylepši boční zbraň na úroveň $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seber $count bonusů',
      few: 'Seber $count bonusy',
      one: 'Seber 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znič $count celých formací',
      few: 'Znič $count celé formace',
      one: 'Znič 1 celou formaci',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Nenaraž do žádného asteroidu';

  @override
  String objUnderTime(int seconds) {
    return 'Dokonči do $seconds s';
  }

  @override
  String get objStripBoss => 'Znič všechny části bosse dřív než jádro';

  @override
  String get joinCoopTitle => 'Připojit ke co-opu';

  @override
  String get cannotSearchNetwork => 'V této síti nelze hledat';

  @override
  String get joinHintNearby =>
      'Stejná Wi-Fi funguje na každém zařízení. iPhone, iPad a Mac se navíc najdou i bez ní, pokud mají oba vypnutý osobní hotspot.';

  @override
  String get joinHintWifi =>
      'Oba hráči musí být na stejné Wi-Fi — funguje i osobní hotspot.';

  @override
  String noHostsYet(String hint) {
    return 'Zatím žádní hostitelé. $hint';
  }

  @override
  String get lookingForHosts => 'Hledám hostitele na této Wi-Fi a v okolí…';

  @override
  String get hostNearby => 'Poblíž · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · stejná Wi-Fi';
  }

  @override
  String get enterIpManually => 'Zadat IP ručně';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ŠT';

  @override
  String get hudPower => 'ENG';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — ŠTÍT';
  }

  @override
  String get bossPartTurret => 'Věž';

  @override
  String get bossPartShieldPod => 'Štítový modul';

  @override
  String get bossPartThruster => 'Motor';

  @override
  String get bossPartCannon => 'Kanón';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Neznámý vesmír';
  }

  @override
  String get player2Joined => 'Hráč 2 se připojil!';

  @override
  String get player2Disconnected => 'Hráč 2 se odpojil';

  @override
  String get hostDisconnected => 'Hostitel se odpojil';

  @override
  String maxLevelSold(String amount) {
    return 'Max. úroveň! Prodáno za \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Odemčena úroveň zbraní $tier';
  }

  @override
  String get cheatsEnabled => 'Cheaty zapnuty';

  @override
  String get cheatsDisabled => 'Cheaty vypnuty';

  @override
  String get cheatsMaxed =>
      'CHEAT: kredity na maximum, všechny zbraně odemčeny';

  @override
  String get cheats => 'CHEATY';

  @override
  String get maxCredits => 'MAX KREDITŮ';

  @override
  String get sectionStats => 'STATISTIKY';

  @override
  String get sectionLoadout => 'VÝZBROJ';

  @override
  String levelShort(int level) {
    return 'Úr.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'VYL';

  @override
  String get sell => 'PRODAT';

  @override
  String get buy => 'KOUPIT';

  @override
  String get commandCenter => 'VELITELSKÉ CENTRUM';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SKÓRE';

  @override
  String get nextWeapon => 'DALŠÍ ZBRAŇ';

  @override
  String pointsValue(String points) {
    return '$points b.';
  }

  @override
  String get slotFront => 'Vpředu';

  @override
  String get slotLeft => 'Vlevo';

  @override
  String get slotRight => 'Vpravo';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'ENG';

  @override
  String get launchMission => 'SPUSTIT MISI';

  @override
  String get startMission => 'ZAHÁJIT MISI';

  @override
  String get continueMission => 'POKRAČOVAT V MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Řádek   [←→] Výběr   [B] Koupit/Vylepšit/Přepnout   [X/Y] Prodat   [OPTIONS] Pokračovat';

  @override
  String get host => 'HOSTOVAT';

  @override
  String hostingAs(String name) {
    return 'HOSTUJEŠ jako $name';
  }

  @override
  String get join => 'PŘIPOJIT';

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
  String get overload => 'PŘETÍŽENÍ';

  @override
  String weaponOff(String weapon) {
    return '$weapon VYPNUT — slabý generátor';
  }

  @override
  String unlocksAt(String points) {
    return 'Odemkne se při $points b.';
  }

  @override
  String joinConnecting(String target) {
    return 'Připojuji se k $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Hostitel neodpověděl: $reason.\n\nOba hráči musí být na stejné Wi-Fi (funguje i osobní hotspot) a hostitel musí mít stisknuté HOST. Zkontrolujte adresu a zkuste to znovu.';
  }

  @override
  String get lanJoinNoAnswer => 'bez odpovědi';

  @override
  String objBossUnder(int seconds) {
    return 'Znič jádro bosse do $seconds s od jeho příletu';
  }

  @override
  String get sectionHangar => 'HANGÁR';

  @override
  String get sectionVault => 'TREZOR';

  @override
  String get rackSide => 'Boky';

  @override
  String get rackHull => 'Trup';

  @override
  String get rarityCommon => 'BĚŽNÝ';

  @override
  String get rarityRare => 'VZÁCNÝ';

  @override
  String get rarityMythic => 'MÝTICKÝ';

  @override
  String get curse => 'PROKLETÍ';

  @override
  String get modFit => 'OSADIT';

  @override
  String get modUnfit => 'SUNDAT';

  @override
  String get modForge => 'KOVÁRNA';

  @override
  String get forgeHint => 'Vyber 3 stejné rarity a ukuj 1 vyšší';

  @override
  String get vaultEmpty =>
      'Zatím žádné mody. Dokonči node na plné hvězdy, zabij bosse rychle nebo sestřel bosse v endless.';

  @override
  String modNeeds(String families) {
    return 'Funguje s $families';
  }

  @override
  String get modRackFull => 'Rack je plný';

  @override
  String get modAlreadyFitted => 'Už osazeno';

  @override
  String get modWrongRack => 'Do tohoto racku nepatří';

  @override
  String modsSpilled(int n) {
    return '$n modů zpět v trezoru';
  }

  @override
  String get hullLocked => 'Zamčeno';

  @override
  String hullUnlockBoss(int n) {
    return 'Poraz bosse kampaně $n';
  }

  @override
  String get hullUnlockFinish => 'Dokonči kampaň nebo dosáhni sektoru 30';

  @override
  String get statAgility => 'OBR';

  @override
  String get statHitbox => 'ZÁS';

  @override
  String get perkNone => 'Základní loď';

  @override
  String get perkAfterimage => 'Stůj na místě: střely ×1,5';

  @override
  String get perkBulwark => 'Poškození za štítem poloviční';

  @override
  String get perkOverclock => 'Střílí i zbraně do 130 % kapacity, pomaleji';

  @override
  String get perkBattery => 'S lodí letí dron zdarma';

  @override
  String get rewardTitle => 'ODMĚNA';

  @override
  String newHull(String name) {
    return 'Nový trup: $name';
  }

  @override
  String get socketEmpty => 'prázdné';

  @override
  String fxStreams(int n) {
    return '$n souběžné proudy';
  }

  @override
  String fxFan(int n) {
    return 'Vějíř $n střel';
  }

  @override
  String fxSalvo(int n) {
    return 'Dávka $n střel';
  }

  @override
  String fxFireRate(String x) {
    return 'Kadence ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Poškození ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Rychlost střel ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Velikost střel ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Spotřeba ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Navádění +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Proletí $n cíli';
  }

  @override
  String get fxPierceAll => 'Proletí vším';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % šance na ×$x poškození';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kritické zásahy na bosse';
  }

  @override
  String fxFork(int n) {
    return 'Zabití rozpráší $n střely';
  }

  @override
  String get fxChain => 'Rozprášené střely se rozprašují dál';

  @override
  String get fxSplit => 'Při zásahu se rozdělí na dvě';

  @override
  String get fxFrost => 'Zásah zpomalí nepřítele';

  @override
  String get fxCrossfire => 'Boční zbraně míří ke středu';

  @override
  String get fxRearguard => 'Boční zbraně střílí i dozadu';

  @override
  String get fxOrbit => 'Střely se vlní';

  @override
  String fxBounce(int n) {
    return 'Odráží se od stěn $n×';
  }

  @override
  String get fxBounceTop => '…i od horního okraje';

  @override
  String get fxOverdrive => 'Střílí i na energetický dluh';

  @override
  String get fxReactor => 'Zbraně nad kapacitu střílí, pomalu';

  @override
  String fxGenPower(String x) {
    return 'Dobíjení generátoru ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Kapacita generátoru ×$x';
  }

  @override
  String get fxSurge => 'Plný generátor: střely ×2';

  @override
  String fxSiphon(int pct) {
    return 'Zabití doplní $pct % energie';
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
    return 'Obnova štítu ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Zabití léčí $n HP';
  }

  @override
  String get fxMagnet => 'Přitahuje bonusy';

  @override
  String get fxMagnetAll => 'Přitáhne všechny bonusy';

  @override
  String fxReflect(int pct) {
    return '$pct % střel se od štítu odrazí zpět';
  }

  @override
  String get fxReflectGuided => 'Odražené střely se navádí';

  @override
  String fxGhost(String sec) {
    return 'Nezranitelnost $sec s po zásahu trupu';
  }

  @override
  String get fxNova => 'Prasklý štít: výbuch přes celou obrazovku';

  @override
  String fxAgility(String x) {
    return 'Obratnost ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zásahová plocha ×$x';
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
  String get fxSatellite => 'S lodí letí bojový dron';

  @override
  String get fxTimewarp => 'Zásah trupu zpomalí čas';

  @override
  String get fxGambler => 'Každá střela je náhodná zbraň';

  @override
  String get vaultAll => 'VŠE';

  @override
  String get sigilMissUnknown => 'neznámý tvar';

  @override
  String get sigilMissTooSlow => 'moc pomalu';

  @override
  String get sigilMissSkippedDot => 'vynechaný bod';

  @override
  String get sigilMissLeftRimEarly => 'pustil jsi moc brzy';

  @override
  String get sigilMissWrongDirection => 'nakresleno pozpátku';

  @override
  String get sigilMissWrongLayer => 'špatné ramenní tlačítko';

  @override
  String get sigilDry => 'málo náboje';

  @override
  String get sigilBusy => 'předchozí ještě běží';

  @override
  String get arena => 'ARÉNA';

  @override
  String get arenaBossParts => 'ČÁSTI BOSSE';

  @override
  String get arenaBareCore => 'holé jádro';

  @override
  String get arenaCompanions => 'COMPANIONI';

  @override
  String get arenaCharge => 'NÁBOJ';

  @override
  String get arenaChargeNormal => 'NORMÁLNÍ';

  @override
  String get arenaSpeed => 'RYCHLOST SVĚTA';

  @override
  String get arenaDrill => 'DRIL';

  @override
  String get arenaFreePlay => 'VOLNÁ HRA';

  @override
  String get arenaFight => 'DO BOJE';

  @override
  String get arenaNewBoss => 'NOVÝ BOSS';

  @override
  String get arenaLeave => 'OPUSTIT ARÉNU';

  @override
  String get arenaHint => 'Boss se vrátí hned, jak padne. Nic se tu neukládá.';

  @override
  String get arenaColCast => 'SESLÁNO';

  @override
  String get arenaColMiss => 'MIMO';

  @override
  String get arenaColAvg => 'PRŮMĚR';

  @override
  String get arenaColBest => 'NEJLEPŠÍ';

  @override
  String get arenaColTime => 'NEJRYCHLEJI';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossů $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILY';

  @override
  String get padSchemeClassic => 'PAD: KLASICKY';

  @override
  String get padSouthpawOn => 'LEVÁK: ZAP';

  @override
  String get padSouthpawOff => 'LEVÁK: VYP';

  @override
  String get sigilDescHop => 'Rychlý odskok tam, kam švihneš';

  @override
  String get sigilDescSidestep => 'Dlouhý úkrok napříč polem';

  @override
  String get sigilDescStrike => 'Výpad vpřed se třemi těžkými střelami a zpět';

  @override
  String get sigilDescRetreat => 'Ústup, zatímco krycí palba letí vpřed';

  @override
  String get sigilDescDash => 'Šikmý průlet palbou, v půli nezranitelný';

  @override
  String get sigilDescRoll => 'Výkrut do strany, nezranitelný';

  @override
  String get sigilDescShadow => 'Přilep se pod nejbližšího nepřítele a pal dál';

  @override
  String get sigilDescEcho =>
      'Stín zopakuje tvé poslední dvě sekundy s polovičním poškozením';

  @override
  String get sigilDescLoop => 'Přemet přes vrch: střely proletí pod tebou';

  @override
  String get sigilDescSlalom => 'Esíčko přes pole s vějířovou palbou';

  @override
  String get sigilDescCorkscrew =>
      'Vývrtka vpřed s palbou do všech stran, nezranitelný';

  @override
  String get sigilDescSnapshot => 'Jedna těžká střela tam, kam švihneš';

  @override
  String get sigilDescBroadside => 'Dávka z obou boků';

  @override
  String get sigilDescVolley => 'Pět nabitých paprsků vpřed';

  @override
  String get sigilDescCaltrop => 'Polož minu, která pohltí střely a vybuchne';

  @override
  String get sigilDescFrenzy => 'Zbraně pár sekund střílí rychleji';

  @override
  String get sigilDescStasis => 'Nepřátelé i jejich střely zpomalí na polovinu';

  @override
  String get sigilDescHalo =>
      'Štít se dobíjí čtyřikrát rychleji a nic neprojde';

  @override
  String get sigilDescRadial => 'Kruh šestnácti střel';

  @override
  String get sigilDescStorm => 'Všechny zbraně pálí naplno, zdarma';

  @override
  String get sigilDescPing => 'Companioni soustředí palbu tam, kam švihneš';

  @override
  String get sigilDescWingman =>
      'Přivolej křídelníka na bok, ke kterému jsi kreslil';

  @override
  String get sigilDescHunter =>
      'Přivolej lovce, který letí napřed a vybírá cíle';

  @override
  String get sigilDescWarden =>
      'Přivolej strážce, který chytá střely mířené na tebe';

  @override
  String get sigilDescFormation =>
      'Companioni přepínají mezi rozestupem a klínem';

  @override
  String get sigilDescWhirl => 'Companioni krouží kolem tebe a polykají střely';

  @override
  String get sigilDescSacrifice =>
      'Companioni se vrhnou a vybuchnou, vrátí ti náboj';

  @override
  String get grimoire => 'GRIMOÁR';

  @override
  String get grimoireHint =>
      'Kresli pravou páčkou. Drž LB pro ARMS, RB pro WING, obě pro MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'cena $cost';
  }

  @override
  String get sigilUntouchable => 'nezranitelný';

  @override
  String get lessonWatch => 'DÍVEJ SE';

  @override
  String get lessonTrace => 'OBKRESLI';

  @override
  String get lessonSlow => 'POMALU';

  @override
  String get lessonLive => 'NAOSTRO';

  @override
  String get lessonStreak => 'PĚTKRÁT PO SOBĚ';

  @override
  String get lessonLearned => 'NAUČENO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Švihni pravou páčkou';

  @override
  String get hintLoop => 'Nakresli kruh: přeletíš nad střelami';

  @override
  String get hintStream => 'Stiskni LT: dva nebo tři proudy';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'ŽÁDNÁ';

  @override
  String kataNext(String sigil, String secs) {
    return 'další $sigil za $secs s';
  }

  @override
  String get arenaGauntlet => 'GAUNTLET';

  @override
  String get arenaOn => 'ZAP';

  @override
  String get arenaOff => 'VYP';

  @override
  String gauntletRating(int rating, int best) {
    return 'Hodnocení $rating · nejlepší $best';
  }

  @override
  String get duelWarning => 'VAROVÁNÍ';

  @override
  String get duelHintPad1 => 'Pravá páčka míří a střílí';

  @override
  String get duelHintPad2Rt => 'Drž RT, LB nebo RB: pravá páčka kreslí sigily';

  @override
  String get duelHintPad2Lt => 'Drž LT, LB nebo RB: pravá páčka kreslí sigily';

  @override
  String get duelHintClassic =>
      'Levá páčka letí · B, RB nebo RT střílí, kam míří čumák';

  @override
  String get duelHintKeys1 => 'Šipky míří a střílí · WASD letí';

  @override
  String get duelHintKeys2 =>
      'Mezerník střílí, kam míří čumák · numerická klávesnice kreslí sigily';

  @override
  String get arenaDuelBinding => 'POSTOJ V DUELU';

  @override
  String get duelBindingRt => 'RT + PÁČKA';

  @override
  String get duelBindingLt => 'LT + PÁČKA';

  @override
  String get arenaDuelFrame => 'VPŘED NA PADU';

  @override
  String get duelFrameNose => 'ČUMÁK';

  @override
  String get duelFrameUp => 'NAHOŘE';

  @override
  String get arenaDuelAimFires => 'MÍŘENÍ STŘÍLÍ';

  @override
  String get duelCutInFirst => 'DETAIL BOSSE: POPRVÉ';

  @override
  String get duelCutInAlways => 'DETAIL BOSSE: VŽDY';

  @override
  String get duelCutInNever => 'DETAIL BOSSE: NIKDY';

  @override
  String get arenaDuelDrill => 'DRIL DUELU';

  @override
  String get duelDrillOff => 'ŽÁDNÝ';

  @override
  String get duelDrillAim => 'MIŘ A PAL';

  @override
  String get duelDrillAimHow => 'Namiř pravou páčku na bosse a zasahuj';

  @override
  String get duelDrillHold => 'DRŽ ČUMÁK';

  @override
  String get duelDrillHoldHow => 'Drž tlačítko postoje a leť: čumák zůstane';

  @override
  String get duelDrillDraw => 'KRESLI VPŘED';

  @override
  String get duelDrillDrawHow => 'V postoji nakresli sigil směrem k bossovi';

  @override
  String get duelDrillTurn => 'OTOČ SE';

  @override
  String get duelDrillTurnHow => 'Boss je pod tebou: otoč čumák a zasahuj';

  @override
  String get duelDrillDone => 'HOTOVO';

  @override
  String get swapHint => 'Druhým prstem přepneš zbraně';
}
