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
  String get launchMission => 'GÖREVE BAŞLA';

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
  String hostingAs(String name) {
    return 'SUNUCU: $name';
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
  String joinConnecting(String target) {
    return '$target adresine bağlanılıyor…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Ana makine yanıt vermedi: $reason.\n\nİki oyuncu da aynı Wi-Fi ağında olmalı (Kişisel Erişim Noktası da olur) ve ana makine HOST\'a basmış olmalı. Adresi kontrol edip tekrar deneyin.';
  }

  @override
  String get lanJoinNoAnswer => 'yanıt yok';

  @override
  String objBossUnder(int seconds) {
    return 'Boss çekirdeğini geldikten sonraki $seconds sn içinde yok et';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'KASA';

  @override
  String get rackSide => 'Yan';

  @override
  String get rackHull => 'Gövde';

  @override
  String get rarityCommon => 'SIRADAN';

  @override
  String get rarityRare => 'NADİR';

  @override
  String get rarityMythic => 'EFSANEVİ';

  @override
  String get curse => 'LANET';

  @override
  String get modFit => 'TAK';

  @override
  String get modUnfit => 'ÇIKAR';

  @override
  String get modForge => 'DEMİRHANE';

  @override
  String get forgeHint =>
      'Bir sonrakinden 1 dövmek için aynı nadirlikten 3 seç';

  @override
  String get vaultEmpty =>
      'Henüz mod yok. Bir düğümü tüm yıldızlarla bitir, bir bossu hızlı yen ya da sonsuz modda bir boss düşür.';

  @override
  String modNeeds(String families) {
    return '$families ile çalışır';
  }

  @override
  String get modRackFull => 'Raf dolu';

  @override
  String get modAlreadyFitted => 'Zaten takılı';

  @override
  String get modWrongRack => 'Bu rafa uymuyor';

  @override
  String modsSpilled(int n) {
    return '$n mod kasaya döndü';
  }

  @override
  String get hullLocked => 'Kilitli';

  @override
  String hullUnlockBoss(int n) {
    return 'Kampanya bossu $n\'i yen';
  }

  @override
  String get hullUnlockFinish => 'Kampanyayı bitir ya da 30. sektöre ulaş';

  @override
  String get statAgility => 'ÇEV';

  @override
  String get statHitbox => 'İSB';

  @override
  String get perkNone => 'Standart gemi';

  @override
  String get perkAfterimage => 'Dur: atışlar ×1,5';

  @override
  String get perkBulwark => 'Kalkanı aşan hasar yarıya iner';

  @override
  String get perkOverclock =>
      '%130 kapasiteye kadar silahları ateşler, daha yavaş';

  @override
  String get perkBattery => 'Yanında bedava bir drone uçar';

  @override
  String get rewardTitle => 'ÖDÜL';

  @override
  String newHull(String name) {
    return 'Yeni gövde: $name';
  }

  @override
  String get socketEmpty => 'boş';

  @override
  String fxStreams(int n) {
    return '$n paralel akış';
  }

  @override
  String fxFan(int n) {
    return '$n atışlık yelpaze';
  }

  @override
  String fxSalvo(int n) {
    return '$n atışlık salvo';
  }

  @override
  String fxFireRate(String x) {
    return 'Atış hızı ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Hasar ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Mermi hızı ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Mermi boyutu ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Enerji tüketimi ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Güdüm +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n hedefi deler';
  }

  @override
  String get fxPierceAll => 'Her şeyi deler';

  @override
  String fxCrit(int pct, String x) {
    return '%$pct ihtimalle ×$x hasar';
  }

  @override
  String fxBossCrit(String x) {
    return 'Bosslara ×$x kritik';
  }

  @override
  String fxFork(int n) {
    return 'Öldürmeler $n mermi saçar';
  }

  @override
  String get fxChain => 'Saçılan mermiler yeniden saçılır';

  @override
  String get fxSplit => 'İsabette ikiye bölünür';

  @override
  String get fxFrost => 'İsabetler düşmanı yavaşlatır';

  @override
  String get fxCrossfire => 'Yan silahlar ortaya nişan alır';

  @override
  String get fxRearguard => 'Yan silahlar geriye de ateş eder';

  @override
  String get fxOrbit => 'Mermiler kıvrılır';

  @override
  String fxBounce(int n) {
    return 'Duvarlardan $n× seker';
  }

  @override
  String get fxBounceTop => '…ve üst kenardan';

  @override
  String get fxOverdrive => 'Enerji borcuyla da ateş eder';

  @override
  String get fxReactor => 'Kapasite üstü silahlar yavaşça ateş eder';

  @override
  String fxGenPower(String x) {
    return 'Jeneratör şarjı ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Jeneratör kapasitesi ×$x';
  }

  @override
  String get fxSurge => 'Dolu jeneratör: atışlar ×2';

  @override
  String fxSiphon(int pct) {
    return 'Öldürmeler %$pct enerji doldurur';
  }

  @override
  String fxHp(String x) {
    return 'Gövde ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Kalkan ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Kalkan yenilenmesi ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Öldürmeler $n CP iyileştirir';
  }

  @override
  String get fxMagnet => 'Bonusları çeker';

  @override
  String get fxMagnetAll => 'Tüm bonusları çeker';

  @override
  String fxReflect(int pct) {
    return 'Kalkana gelen atışların %$pct\'i geri seker';
  }

  @override
  String get fxReflectGuided => 'Yansıyan atışlar güdümlüdür';

  @override
  String fxGhost(String sec) {
    return 'Gövde darbesinden sonra $sec sn dokunulmaz';
  }

  @override
  String get fxNova => 'Kalkan kırılınca tüm ekranda patlama';

  @override
  String fxAgility(String x) {
    return 'Çeviklik ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'İsabet alanı ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kredi ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Puan ×$x';
  }

  @override
  String get fxSatellite => 'Yanında savaş dronu uçar';

  @override
  String get fxTimewarp => 'Gövde darbesi zamanı yavaşlatır';

  @override
  String get fxGambler => 'Her atış rastgele bir silah';

  @override
  String get vaultAll => 'TÜMÜ';

  @override
  String get sigilMissUnknown => 'bilinmeyen şekil';

  @override
  String get sigilMissTooSlow => 'çok yavaş';

  @override
  String get sigilMissSkippedDot => 'bir nokta atlandı';

  @override
  String get sigilMissLeftRimEarly => 'çok erken bırakıldı';

  @override
  String get sigilMissWrongDirection => 'ters çizildi';

  @override
  String get sigilMissWrongLayer => 'yanlış omuz tuşu';

  @override
  String get sigilDry => 'yetersiz şarj';

  @override
  String get sigilBusy => 'önceki hâlâ sürüyor';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BOSS PARÇALARI';

  @override
  String get arenaBareCore => 'çıplak çekirdek';

  @override
  String get arenaCompanions => 'YOLDAŞLAR';

  @override
  String get arenaCharge => 'ŞARJ';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'DÜNYA HIZI';

  @override
  String get arenaDrill => 'ALIŞTIRMA';

  @override
  String get arenaFreePlay => 'SERBEST';

  @override
  String get arenaFight => 'SAVAŞ';

  @override
  String get arenaNewBoss => 'YENİ BOSS';

  @override
  String get arenaLeave => 'ARENADAN ÇIK';

  @override
  String get arenaHint =>
      'Boss düştüğü an geri gelir. Burada hiçbir şey kaydedilmez.';

  @override
  String get arenaColCast => 'BAŞARILI';

  @override
  String get arenaColMiss => 'ISKA';

  @override
  String get arenaColAvg => 'ORT.';

  @override
  String get arenaColBest => 'EN İYİ';

  @override
  String get arenaColTime => 'EN HIZLI';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Boss $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'KUMANDA: SİGİLLER';

  @override
  String get padSchemeClassic => 'KUMANDA: KLASİK';

  @override
  String get padSouthpawOn => 'SOLAK: AÇIK';

  @override
  String get padSouthpawOff => 'SOLAK: KAPALI';

  @override
  String get sigilDescHop => 'Analogu ittiğin yöne hızlı bir sıçrama';

  @override
  String get sigilDescSidestep => 'Alan boyunca uzun bir yan adım';

  @override
  String get sigilDescStrike => 'Üç ağır atışla ileri atıl, sonra geri dön';

  @override
  String get sigilDescRetreat => 'Örtme ateşi ileri giderken geri çekil';

  @override
  String get sigilDescDash =>
      'Ateşin içinden çapraz atılış, yarı yolda dokunulmaz';

  @override
  String get sigilDescRoll => 'Yana fıçı dönüşü, dokunulmaz';

  @override
  String get sigilDescShadow =>
      'En yakın düşmanın altına kilitlen ve ateşe devam et';

  @override
  String get sigilDescEcho =>
      'Bir gölge son iki saniyeni yarı hasarla tekrarlar';

  @override
  String get sigilDescLoop => 'Üstten takla: atışlar altından geçer';

  @override
  String get sigilDescSlalom => 'Yelpaze ateşle alan boyunca S kıvrımı';

  @override
  String get sigilDescCorkscrew =>
      'Her yöne ateş ederek ileri burgu, dokunulmaz';

  @override
  String get sigilDescSnapshot => 'Analogu ittiğin yöne tek ağır atış';

  @override
  String get sigilDescBroadside => 'İki kanattan birden salvo';

  @override
  String get sigilDescVolley => 'İleriye beş yüklü ışın';

  @override
  String get sigilDescCaltrop => 'Atışları yutup patlayan bir mayın bırak';

  @override
  String get sigilDescFrenzy => 'Silahlar birkaç saniye daha hızlı ateş eder';

  @override
  String get sigilDescStasis => 'Düşmanlar ve atışları yarı hıza düşer';

  @override
  String get sigilDescHalo =>
      'Kalkan dört kat hızlı dolar ve hiçbir şey geçemez';

  @override
  String get sigilDescRadial => 'On altı atışlık bir halka';

  @override
  String get sigilDescStorm => 'Tüm silahlar bedavaya tam güç ateş eder';

  @override
  String get sigilDescPing =>
      'Yoldaşlar ateşi analogu ittiğin yöne yoğunlaştırır';

  @override
  String get sigilDescWingman => 'Çizdiğin kanada bir kol uçağı çağır';

  @override
  String get sigilDescHunter => 'Önden uçup hedef seçen bir avcı çağır';

  @override
  String get sigilDescWarden =>
      'Sana gelen atışları üstlenen bir muhafız çağır';

  @override
  String get sigilDescFormation =>
      'Yoldaşlar geniş ve kama düzeni arasında geçiş yapar';

  @override
  String get sigilDescWhirl => 'Yoldaşlar etrafında döner ve atışları yutar';

  @override
  String get sigilDescSacrifice => 'Yoldaşlar dalıp patlar, şarjı geri öder';

  @override
  String get grimoire => 'BÜYÜ KİTABI';

  @override
  String get grimoireHint =>
      'Sağ analogla çiz. ARMS için LB, WING için RB, MEGA BLAST için ikisini birden basılı tut.';

  @override
  String sigilCost(int cost) {
    return 'maliyet $cost';
  }

  @override
  String get sigilUntouchable => 'dokunulmaz';
}
