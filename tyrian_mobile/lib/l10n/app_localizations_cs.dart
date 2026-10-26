// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get cancel => 'ZRUŠIT';

  @override
  String get connect => 'PŘIPOJIT';

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
  String get quitToDesktop => 'UKONČIT NA PLOCHU';

  @override
  String get selectSkin => 'VYBER VZHLED';

  @override
  String get quit => 'KONEC';

  @override
  String get restorePurchases => 'OBNOVIT NÁKUPY';

  @override
  String get locked => 'ZAMČENO';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ŠT';

  @override
  String get hudPower => 'ENG';

  @override
  String get hudGen => 'GEN';

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
  String get sectionOutfitting => 'VYBAVENÍ';

  @override
  String get sectionShop => 'OBCHOD';

  @override
  String get tabFront => 'PŘEDNÍ';

  @override
  String get tabSide => 'BOČNÍ';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => 'LEVÁ';

  @override
  String get sideRight => 'PRAVÁ';

  @override
  String get noWeaponInstalled => 'ŽÁDNÁ ZBRAŇ';

  @override
  String levelShort(int level) {
    return 'Úr.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'POŠ:$damage RYCH:$speed';
  }

  @override
  String statPower(int power) {
    return 'ENG:$power';
  }

  @override
  String get beam => 'PAPRSEK';

  @override
  String get guided => 'NAVÁDĚNÁ';

  @override
  String get owned => 'VLASTNÍŠ';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => 'VYLEPŠIT';

  @override
  String get upgradeShort => 'VYL';

  @override
  String get sell => 'PRODAT';

  @override
  String get buy => 'KOUPIT';

  @override
  String get noCredits => 'MÁLO KREDITŮ';

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
  String get generator => 'GENERÁTOR';

  @override
  String genOutput(String value) {
    return 'ENG: +$value/sn';
  }

  @override
  String genCapacity(int value) {
    return 'Kap.: $value';
  }

  @override
  String get startMission => 'ZAHÁJIT MISI';

  @override
  String get continueMission => 'POKRAČOVAT V MISI';

  @override
  String get padControlsHint =>
      '[B] Koupit/vylepšit   [X/Y] Prodat   [LB/RB] Karty   [OPTIONS] Pokračovat v misi';

  @override
  String get host => 'HOSTOVAT';

  @override
  String get connectToHost => 'Připojit k hostiteli';

  @override
  String hostingAt(String ip) {
    return 'HOSTUJEŠ  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'PŘIPOJIT';
}
