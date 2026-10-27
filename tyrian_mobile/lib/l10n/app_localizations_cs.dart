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
}
