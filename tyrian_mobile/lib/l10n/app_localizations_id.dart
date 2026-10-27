// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'BATAL';

  @override
  String get connect => 'HUBUNGKAN';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Tidak dapat terhubung ke $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Host terlihat, tetapi tautan tidak tersambung.\n\nMain di sekitar butuh Wi-Fi peer-to-peer, yang dimatikan iOS selama Hotspot Pribadi aktif. Matikan hotspot di kedua perangkat lalu coba lagi, atau sambungkan keduanya ke Wi-Fi yang sama.';

  @override
  String get gameOverCampaign =>
      'Misi gagal — perlengkapan dan kredit tetap ada. Coba lagi dari Pusat Komando.';

  @override
  String get gameOverEndless =>
      'Membangun ulang di Sektor 1 — perlengkapan dan kredit tetap ada';

  @override
  String get waitingForHost => 'Menunggu host...';

  @override
  String get waitingForHostHint => 'Game dimulai saat host siap';

  @override
  String get vesselLost => 'KAPAL HANCUR';

  @override
  String scoreValue(String score) {
    return 'Skor: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredit: $credits';
  }

  @override
  String get creditsPrefix => 'Kredit: ';

  @override
  String get leaderboard => 'PAPAN PERINGKAT';

  @override
  String get achievements => 'PENCAPAIAN';

  @override
  String get redeploy => 'TERJUN LAGI';

  @override
  String get resume => 'LANJUTKAN';

  @override
  String get pause => 'JEDA';

  @override
  String get paused => 'DIJEDA';

  @override
  String get skins => 'SKIN';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SUARA: NYALA';

  @override
  String get soundOff => 'SUARA: MATI';

  @override
  String get musicOn => 'MUSIK: NYALA';

  @override
  String get musicOff => 'MUSIK: MATI';

  @override
  String get mainMenu => 'MENU UTAMA';

  @override
  String get quitToDesktop => 'KELUAR KE DESKTOP';

  @override
  String get selectSkin => 'PILIH SKIN';

  @override
  String get difficulty => 'KESULITAN';

  @override
  String get difficultyEasy => 'MUDAH';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'SULIT';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANYE';

  @override
  String get quit => 'KELUAR';

  @override
  String get restorePurchases => 'PULIHKAN PEMBELIAN';

  @override
  String get locked => 'TERKUNCI';

  @override
  String get mainMenuTooltip => 'Menu utama';

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LEVEL $level · BOS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Terkunci. Selesaikan dulu misi sebelumnya.';

  @override
  String get flyAgain => 'TERBANG LAGI';

  @override
  String get launch => 'LUNCURKAN';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'BINTANG';

  @override
  String get continueButton => 'LANJUT';

  @override
  String get replayNode => 'ULANGI MISI';

  @override
  String get retry => 'COBA LAGI';

  @override
  String get nodeCleared => 'MISI SELESAI';

  @override
  String get nodeFailed => 'MISI GAGAL';

  @override
  String get weaponTierUnlocked => 'TINGKAT SENJATA BARU';

  @override
  String get onSaleInComCenter => 'Sudah dijual di Pusat Komando.';

  @override
  String get requiredTasksHint =>
      'Tugas wajib menentukan hasil misi. Terbangkan lagi — apa yang kamu dapat tetap milikmu.';

  @override
  String get objClear => 'Bersihkan sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tembak jatuh $count musuh',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Jangan terkena kerusakan lambung';

  @override
  String objHull(int percent) {
    return 'Selesai dengan lambung di atas $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hancurkan $count musuh dengan $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hancurkan $count musuh dengan senjata samping',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Luncurkan dengan $weapon di depan';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Luncurkan dengan $weapon di sisi';
  }

  @override
  String get objBuySideGun => 'Beli senjata samping di Pusat Komando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Tingkatkan generator ke level $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Tingkatkan senjata depan ke level $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Tingkatkan senjata samping ke level $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ambil $count bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Habisi $count formasi utuh',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Jangan tabrak asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Selesai dalam $seconds dtk';
  }

  @override
  String get objStripBoss => 'Hancurkan semua bagian bos sebelum intinya';

  @override
  String get joinCoopTitle => 'Gabung co-op';

  @override
  String get cannotSearchNetwork => 'Tidak bisa mencari di jaringan ini';

  @override
  String get joinHintNearby =>
      'Wi-Fi yang sama berfungsi di semua perangkat. iPhone, iPad, dan Mac juga saling menemukan dari dekat tanpa Wi-Fi — dengan Hotspot Pribadi mati di keduanya.';

  @override
  String get joinHintWifi =>
      'Kedua pemain harus di Wi-Fi yang sama — Hotspot Pribadi juga bisa.';

  @override
  String noHostsYet(String hint) {
    return 'Belum ada host. $hint';
  }

  @override
  String get lookingForHosts => 'Mencari host di Wi-Fi ini dan sekitar…';

  @override
  String get hostNearby => 'Di sekitar · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · Wi-Fi sama';
  }

  @override
  String get enterIpManually => 'Masukkan IP manual';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'PRS';

  @override
  String get hudPower => 'DAYA';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — BERPERISAI';
  }

  @override
  String get bossPartTurret => 'Turet';

  @override
  String get bossPartShieldPod => 'Modul Perisai';

  @override
  String get bossPartThruster => 'Pendorong';

  @override
  String get bossPartCannon => 'Meriam';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Ruang Tak Dikenal';
  }

  @override
  String get player2Joined => 'Pemain 2 bergabung!';

  @override
  String get player2Disconnected => 'Pemain 2 terputus';

  @override
  String get hostDisconnected => 'Host terputus';

  @override
  String maxLevelSold(String amount) {
    return 'Level maks.! Terjual seharga \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Level senjata $tier terbuka';
  }

  @override
  String get cheatsEnabled => 'Cheat aktif';

  @override
  String get cheatsDisabled => 'Cheat nonaktif';

  @override
  String get cheatsMaxed => 'CHEAT: kredit maksimal, semua senjata terbuka';

  @override
  String get cheats => 'CHEAT';

  @override
  String get maxCredits => 'KREDIT MAKS';

  @override
  String get sectionStats => 'STATISTIK';

  @override
  String get sectionLoadout => 'PERSENJATAAN';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'JUAL';

  @override
  String get buy => 'BELI';

  @override
  String get commandCenter => 'PUSAT KOMANDO';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SKOR';

  @override
  String get nextWeapon => 'SENJATA BERIKUTNYA';

  @override
  String pointsValue(String points) {
    return '$points poin';
  }

  @override
  String get slotFront => 'Depan';

  @override
  String get slotLeft => 'Kiri';

  @override
  String get slotRight => 'Kanan';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'DAYA';

  @override
  String get launchMission => 'LUNCURKAN MISI';

  @override
  String get startMission => 'MULAI MISI';

  @override
  String get continueMission => 'LANJUTKAN MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Baris   [←→] Pilih   [B] Beli/Tingkatkan/Ganti   [X/Y] Jual   [OPTIONS] Lanjut';

  @override
  String get host => 'JADI HOST';

  @override
  String hostingAs(String name) {
    return 'HOST: $name';
  }

  @override
  String get join => 'GABUNG';

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
  String get overload => 'KELEBIHAN BEBAN';

  @override
  String weaponOff(String weapon) {
    return '$weapon MATI — generator terlalu lemah';
  }

  @override
  String unlocksAt(String points) {
    return 'Terbuka di $points poin';
  }
}
