// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get ok => 'TAMAM';

  @override
  String get cancel => 'İPTAL';

  @override
  String get connect => 'BAĞLAN';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName ile bağlantı kurulamadı';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Sunucu görünüyordu ama bağlantı kurulamadı.\n\nYakındaki oyun eşler arası Wi-Fi gerektirir; iOS, Kişisel Erişim Noktası açıkken bunu kapatır. İki cihazda da erişim noktasını kapatıp tekrar deneyin ya da iki cihazı aynı Wi-Fi ağına bağlayın.';

  @override
  String get gameOverCampaign =>
      'Görev başarısız — donanım ve krediler korundu. Komuta Merkezi\'nden tekrar dene.';

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
  String get mainMenu => 'ANA MENÜ';

  @override
  String get quitToDesktop => 'MASAÜSTÜNE ÇIK';

  @override
  String get selectSkin => 'GÖRÜNÜM SEÇ';

  @override
  String get difficulty => 'ZORLUK';

  @override
  String get difficultyEasy => 'KOLAY';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'ZOR';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'SEFER';

  @override
  String get quit => 'ÇIK';

  @override
  String get restorePurchases => 'SATIN ALIMLARI GERİ YÜKLE';

  @override
  String get locked => 'KİLİTLİ';

  @override
  String get mainMenuTooltip => 'Ana menü';

  @override
  String nodeLevel(int level) {
    return 'SEVİYE $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'SEVİYE $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Kilitli. Önce bir önceki görevi tamamla.';

  @override
  String get flyAgain => 'TEKRAR UÇ';

  @override
  String get launch => 'KALKIŞ';

  @override
  String zoneLabel(int zone) {
    return 'BÖLGE $zone';
  }

  @override
  String get objectiveStar => 'YILDIZ';

  @override
  String get continueButton => 'DEVAM';

  @override
  String get replayNode => 'GÖREVİ TEKRARLA';

  @override
  String get retry => 'TEKRAR DENE';

  @override
  String get nodeCleared => 'GÖREV TAMAM';

  @override
  String get nodeFailed => 'GÖREV BAŞARISIZ';

  @override
  String get weaponTierUnlocked => 'YENİ SİLAH SEVİYESİ';

  @override
  String get onSaleInComCenter => 'Komuta Merkezi\'nde satışta.';

  @override
  String get requiredTasksHint =>
      'Görevin sonucunu zorunlu hedefler belirler. Tekrar uç — kazandıkların sende kalır.';

  @override
  String get objClear => 'Sektörü temizle';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count düşman düşür',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Gövde hasarı alma';

  @override
  String objHull(int percent) {
    return 'Gövde %$percent üzerindeyken bitir';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon ile $count düşman yok et',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yan silahlarla $count düşman yok et',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon önde takılıyken kalk';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon yan yuvadayken kalk';
  }

  @override
  String get objBuySideGun => 'Komuta Merkezi\'nden bir yan silah al';

  @override
  String objUpgradeGenerator(int level) {
    return 'Jeneratörü $level. seviyeye yükselt';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Ön silahı $level. seviyeye yükselt';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Bir yan silahı $level. seviyeye yükselt';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonus topla',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count formasyonu tamamen yok et',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Hiçbir asteroide çarpma';

  @override
  String objUnderTime(int seconds) {
    return '$seconds sn içinde bitir';
  }

  @override
  String get objStripBoss => 'Çekirdekten önce boss\'un tüm parçalarını yok et';

  @override
  String get joinCoopTitle => 'Co-op\'a katıl';

  @override
  String get cannotSearchNetwork => 'Bu ağda arama yapılamıyor';

  @override
  String get joinHintNearby =>
      'Aynı Wi-Fi her cihazda çalışır. iPhone, iPad ve Mac ayrıca Wi-Fi olmadan da yakındaki cihazları bulur — ikisinde de Kişisel Erişim Noktası kapalıyken.';

  @override
  String get joinHintWifi =>
      'İki oyuncu da aynı Wi-Fi ağında olmalı — Kişisel Erişim Noktası da olur.';

  @override
  String noHostsYet(String hint) {
    return 'Henüz sunucu yok. $hint';
  }

  @override
  String get lookingForHosts => 'Bu Wi-Fi\'da ve yakında sunucu aranıyor…';

  @override
  String get hostNearby => 'Yakında · Bluetooth / eşler arası Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · aynı Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP\'yi elle gir';

  @override
  String get hudHp => 'CAN';

  @override
  String get hudShield => 'KLK';

  @override
  String get hudPower => 'GÜÇ';

  @override
  String get hudGen => 'JEN';

  @override
  String bossShielded(String name) {
    return '$name — KALKANLI';
  }

  @override
  String get bossPartTurret => 'Taret';

  @override
  String get bossPartShieldPod => 'Kalkan Modülü';

  @override
  String get bossPartThruster => 'İtici';

  @override
  String get bossPartCannon => 'Top';

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
  String get launchMission => 'GÖREVE BAŞLA';

  @override
  String get startMission => 'GÖREVİ BAŞLAT';

  @override
  String get continueMission => 'GÖREVE DEVAM';

  @override
  String get padControlsHint =>
      '[↑↓] Seç   [←→] Sütunlar   [LB/RB] Sekmeler   [A] Sol/Sağ yuva    —    [B] Al/Yükselt   [X/Y] Sat   [OPTIONS] Devam';

  @override
  String get host => 'SUNUCU OL';

  @override
  String hostingAs(String name) {
    return 'SUNUCU: $name';
  }

  @override
  String get join => 'KATIL';
}
