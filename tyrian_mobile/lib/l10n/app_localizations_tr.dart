// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get cancel => 'İPTAL';

  @override
  String get connect => 'BAĞLAN';

  @override
  String get gameOverEndless =>
      'Sektör 1\'de yeniden kuruluyor — donanım ve krediler korundu';

  @override
  String get waitingForHost => 'Sunucu bekleniyor...';

  @override
  String get waitingForHostHint => 'Sunucu hazır olunca oyun başlayacak';

  @override
  String get vesselLost => 'GEMİ KAYBEDİLDİ';

  @override
  String scoreValue(String score) {
    return 'Puan: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredi: $credits';
  }

  @override
  String get creditsPrefix => 'Kredi: ';

  @override
  String get leaderboard => 'SKOR TABLOSU';

  @override
  String get achievements => 'BAŞARIMLAR';

  @override
  String get redeploy => 'YENİDEN SAVAŞA';

  @override
  String get resume => 'DEVAM ET';

  @override
  String get pause => 'DURAKLAT';

  @override
  String get paused => 'DURAKLATILDI';

  @override
  String get skins => 'GÖRÜNÜMLER';

  @override
  String get skin => 'GÖRÜNÜM';

  @override
  String get soundOn => 'SES: AÇIK';

  @override
  String get soundOff => 'SES: KAPALI';

  @override
  String get musicOn => 'MÜZİK: AÇIK';

  @override
  String get musicOff => 'MÜZİK: KAPALI';

  @override
  String get quitToDesktop => 'MASAÜSTÜNE ÇIK';

  @override
  String get selectSkin => 'GÖRÜNÜM SEÇ';

  @override
  String get quit => 'ÇIK';

  @override
  String get restorePurchases => 'SATIN ALIMLARI GERİ YÜKLE';

  @override
  String get locked => 'KİLİTLİ';

  @override
  String get hudHp => 'CAN';

  @override
  String get hudShield => 'KLK';

  @override
  String get hudPower => 'GÜÇ';

  @override
  String get hudGen => 'JEN';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektör $level — Bilinmeyen Uzay';
  }

  @override
  String get player2Joined => 'Oyuncu 2 katıldı!';

  @override
  String get player2Disconnected => 'Oyuncu 2\'nin bağlantısı koptu';

  @override
  String get hostDisconnected => 'Sunucunun bağlantısı koptu';

  @override
  String maxLevelSold(String amount) {
    return 'Maks. seviye! \$$amount karşılığında satıldı';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Silah seviyesi $tier açıldı';
  }

  @override
  String get cheatsEnabled => 'Hileler açık';

  @override
  String get cheatsDisabled => 'Hileler kapalı';

  @override
  String get cheatsMaxed => 'HİLE: krediler son sınırda, tüm silahlar açık';

  @override
  String get cheats => 'HİLELER';

  @override
  String get maxCredits => 'MAKS. KREDİ';

  @override
  String get sectionStats => 'İSTATİSTİK';

  @override
  String get sectionLoadout => 'TEÇHİZAT';

  @override
  String get sectionOutfitting => 'DONANIM';

  @override
  String get sectionShop => 'MAĞAZA';

  @override
  String get tabFront => 'ÖN';

  @override
  String get tabSide => 'YAN';

  @override
  String get tabGen => 'JEN';

  @override
  String get sideLeft => 'SOL';

  @override
  String get sideRight => 'SAĞ';

  @override
  String get noWeaponInstalled => 'SİLAH TAKILI DEĞİL';

  @override
  String levelShort(int level) {
    return 'Sv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'HSR:$damage HIZ:$speed';
  }

  @override
  String statPower(int power) {
    return 'GÜÇ:$power';
  }

  @override
  String get beam => 'IŞIN';

  @override
  String get guided => 'GÜDÜMLÜ';

  @override
  String get owned => 'SAHİPSİN';

  @override
  String get max => 'MAKS';

  @override
  String get upgrade => 'YÜKSELT';

  @override
  String get upgradeShort => 'YÜKS';

  @override
  String get sell => 'SAT';

  @override
  String get buy => 'SATIN AL';

  @override
  String get noCredits => 'KREDİ YETERSİZ';

  @override
  String get commandCenter => 'KOMUTA MERKEZİ';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUAN';

  @override
  String get nextWeapon => 'SONRAKİ SİLAH';

  @override
  String pointsValue(String points) {
    return '$points puan';
  }

  @override
  String get slotFront => 'Ön';

  @override
  String get slotLeft => 'Sol';

  @override
  String get slotRight => 'Sağ';

  @override
  String get slotGen => 'Jen';

  @override
  String get power => 'GÜÇ';

  @override
  String get generator => 'JENERATÖR';

  @override
  String genOutput(String value) {
    return 'GÜÇ: +$value/kare';
  }

  @override
  String genCapacity(int value) {
    return 'Kap.: $value';
  }

  @override
  String get startMission => 'GÖREVİ BAŞLAT';

  @override
  String get continueMission => 'GÖREVE DEVAM';

  @override
  String get padControlsHint =>
      '[B] Al/Yükselt   [X/Y] Sat   [LB/RB] Sekmeler   [OPTIONS] Göreve devam';

  @override
  String get host => 'SUNUCU OL';

  @override
  String get connectToHost => 'Sunucuya bağlan';

  @override
  String hostingAt(String ip) {
    return 'SUNUCU  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'KATIL';
}
