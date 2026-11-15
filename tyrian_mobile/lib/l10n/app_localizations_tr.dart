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
  String levelShort(int level) {
    return 'Sv.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'YÜKS';

  @override
  String get sell => 'SAT';

  @override
  String get buy => 'SATIN AL';

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
  String get startMission => 'GÖREVİ BAŞLAT';

  @override
  String get continueMission => 'GÖREVE DEVAM';

  @override
  String get padControlsHint =>
      '[↑↓] Satır   [←→] Seç   [B] Al/Yükselt/Değiştir   [X/Y] Sat   [OPTIONS] Devam';

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
  String get overload => 'AŞIRI YÜK';

  @override
  String weaponOff(String weapon) {
    return '$weapon KAPALI — jeneratör çok zayıf';
  }

  @override
  String unlocksAt(String points) {
    return '$points puanda açılır';
  }

  @override
  String get swapHint => 'İki parmakla ikinci silah setinle ateş edersin';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: daha güçlü atışlar';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: gövde onarıldı';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount kalkan, daha hızlı dolar';
  }

  @override
  String get pickupGenerator => 'Jeneratör güçlendi: silahlara daha çok enerji';

  @override
  String pickupCredits(String amount) {
    return '+$amount kredi, ComCenter\'da harca';
  }

  @override
  String nodeLevel(int level) {
    return 'SEVİYE $level';
  }

  @override
  String get tutPickupWeapon =>
      'Silah bonusları seviyeyi artırır: daha çok hasar, daha hızlı ateş';

  @override
  String get tutPickupHealth =>
      'Onarımlar gövdeyi tamir eder; canın tamsa maks. HP artar';

  @override
  String get tutPickupShield =>
      'Kalkan darbeleri gövdeden önce alır ve kendiliğinden dolar';

  @override
  String get tutPickupGenerator =>
      'Jeneratör silahları besler: daha çok güç, daha çok silah ateşler';

  @override
  String get tutPickupCredits =>
      'Krediyle turlar arasında ComCenter\'dan silah ve geliştirme al';

  @override
  String get tutBoss =>
      'BOSS! Canı üstteki çubuk. Hareket et, ateş etmeye devam et';

  @override
  String get tutLowHp => 'Gövde zayıf! Onarım ya da ComCenter düzeltir';

  @override
  String get tutGenStarved =>
      'Silahlar jeneratörün verdiğinden fazla güç istiyor: geliştir';

  @override
  String get tutCanAfford =>
      'Geliştirmeye paran yetiyor: bu turdan sonra ComCenter\'a uğra';

  @override
  String get tutFly =>
      'Uçmak için sürükle. Parmağın ekrandayken silahlar ateşler';

  @override
  String get introCollect => 'Düşmanların düşürdüğü simgeleri yakala';

  @override
  String get introShop => 'Turlar arasında kredilerini ComCenter\'da harca';

  @override
  String get objBoss => 'Hedef: dalgalardan sağ çık ve boss\'u yen';

  @override
  String get objSurvive => 'Hedef: dalgalardan sağ çık';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits kredi · $kills düşürülen';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'En iyi silah: $weapon';
  }

  @override
  String get deathBoss =>
      'Boss sert vurur: daha güçlü kalkan sana zaman kazandırır';

  @override
  String get deathShield =>
      'ComCenter\'da kalkanı geliştir: darbeleri gövdeden önce alır';

  @override
  String get deathGuns =>
      'Güçlü silahlar dalgaları sana zarar vermeden temizler';
}
