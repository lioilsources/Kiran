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
  String get statsOn => 'STATISTIKY: ZAP';

  @override
  String get statsOff => 'STATISTIKY: VYP';

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
  String get startMission => 'ZAHÁJIT MISI';

  @override
  String get continueMission => 'POKRAČOVAT V MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Řádek   [←→] Výběr   [B] Koupit/Vylepšit/Přepnout   [X/Y] Prodat   [OPTIONS] Pokračovat';

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
  String get swapHint => 'Dvěma prsty střílíš druhou sadou zbraní';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: silnější střelba';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: trup opraven';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount štítu, rychleji se dobíjí';
  }

  @override
  String get pickupGenerator => 'Silnější generátor: víc energie pro zbraně';

  @override
  String pickupCredits(String amount) {
    return '+$amount kreditů na nákupy v ComCenteru';
  }

  @override
  String nodeLevel(int level) {
    return 'ÚROVEŇ $level';
  }

  @override
  String get tutPickupWeapon =>
      'Zbraňové power-upy zvedají úroveň zbraně: víc poškození, rychlejší palba';

  @override
  String get tutPickupHealth =>
      'Opravy spraví trup; když jsi v kondici, zvednou i maximum HP';

  @override
  String get tutPickupShield =>
      'Štít chytá zásahy dřív než trup a sám se dobíjí';

  @override
  String get tutPickupGenerator =>
      'Generátor napájí zbraně: víc energie udrží v palbě víc zbraní';

  @override
  String get tutPickupCredits =>
      'Za kredity koupíš zbraně a vylepšení v ComCenteru mezi koly';

  @override
  String get tutBoss => 'BOSS! Jeho zdraví je lišta nahoře. Hýbej se a střílej';

  @override
  String get tutLowHp => 'Trup je na dně! Spraví ho oprava nebo ComCenter';

  @override
  String get tutGenStarved =>
      'Zbraně chtějí víc energie, než dá generátor: vylepši ho';

  @override
  String get tutCanAfford =>
      'Máš na vylepšení: po tomhle kole zajdi do ComCenteru';

  @override
  String get tutFly => 'Táhni prstem a leť. Zbraně střílí, dokud držíš prst';

  @override
  String get introCollect => 'Chytej ikony, které padají z nepřátel';

  @override
  String get introShop => 'Mezi koly utrať kredity v ComCenteru';

  @override
  String get objBoss => 'Cíl: přežij vlny a poraz bosse';

  @override
  String get objSurvive => 'Cíl: přežij vlny';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits kreditů · $kills sestřelů';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Nejlepší zbraň: $weapon';
  }

  @override
  String get deathBoss => 'Střely bosse bolí: silnější štít ti koupí čas';

  @override
  String get deathShield =>
      'Vylepši štít v ComCenteru: chytá zásahy dřív než trup';

  @override
  String get deathGuns => 'Silnější zbraně smetou vlny dřív, než ti ublíží';
}
