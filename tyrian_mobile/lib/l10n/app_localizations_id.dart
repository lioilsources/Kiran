// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get cancel => 'BATAL';

  @override
  String get connect => 'HUBUNGKAN';

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
  String get quitToDesktop => 'KELUAR KE DESKTOP';

  @override
  String get selectSkin => 'PILIH SKIN';

  @override
  String get quit => 'KELUAR';

  @override
  String get restorePurchases => 'PULIHKAN PEMBELIAN';

  @override
  String get locked => 'TERKUNCI';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'PRS';

  @override
  String get hudPower => 'DAYA';

  @override
  String get hudGen => 'GEN';

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
  String get startMission => 'MULAI MISI';

  @override
  String get continueMission => 'LANJUTKAN MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Baris   [←→] Pilih   [B] Beli/Tingkatkan/Ganti   [X/Y] Jual   [OPTIONS] Lanjut';

  @override
  String get host => 'JADI HOST';

  @override
  String get connectToHost => 'Hubungkan ke host';

  @override
  String hostingAt(String ip) {
    return 'HOST  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
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
