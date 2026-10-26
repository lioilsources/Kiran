// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get cancel => 'HỦY';

  @override
  String get connect => 'KẾT NỐI';

  @override
  String get gameOverEndless =>
      'Tái thiết tại Khu vực 1 — giữ nguyên trang bị và tín dụng';

  @override
  String get waitingForHost => 'Đang chờ máy chủ...';

  @override
  String get waitingForHostHint => 'Trận đấu sẽ bắt đầu khi máy chủ sẵn sàng';

  @override
  String get vesselLost => 'MẤT PHI THUYỀN';

  @override
  String scoreValue(String score) {
    return 'Điểm: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Tín dụng: $credits';
  }

  @override
  String get creditsPrefix => 'Tín dụng: ';

  @override
  String get leaderboard => 'BẢNG XẾP HẠNG';

  @override
  String get achievements => 'THÀNH TÍCH';

  @override
  String get redeploy => 'XUẤT KÍCH LẠI';

  @override
  String get resume => 'TIẾP TỤC';

  @override
  String get pause => 'TẠM DỪNG';

  @override
  String get paused => 'ĐANG TẠM DỪNG';

  @override
  String get skins => 'GIAO DIỆN';

  @override
  String get skin => 'GIAO DIỆN';

  @override
  String get soundOn => 'ÂM THANH: BẬT';

  @override
  String get soundOff => 'ÂM THANH: TẮT';

  @override
  String get musicOn => 'NHẠC: BẬT';

  @override
  String get musicOff => 'NHẠC: TẮT';

  @override
  String get quitToDesktop => 'THOÁT RA DESKTOP';

  @override
  String get selectSkin => 'CHỌN GIAO DIỆN';

  @override
  String get quit => 'THOÁT';

  @override
  String get restorePurchases => 'KHÔI PHỤC GIAO DỊCH';

  @override
  String get locked => 'ĐÃ KHÓA';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'KHIÊN';

  @override
  String get hudPower => 'NL';

  @override
  String get hudGen => 'MP';

  @override
  String sectorUnknownSpace(int level) {
    return 'Khu vực $level — Vùng không gian lạ';
  }

  @override
  String get player2Joined => 'Người chơi 2 đã tham gia!';

  @override
  String get player2Disconnected => 'Người chơi 2 đã ngắt kết nối';

  @override
  String get hostDisconnected => 'Máy chủ đã ngắt kết nối';

  @override
  String maxLevelSold(String amount) {
    return 'Cấp tối đa! Đã bán với giá \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Đã mở khóa vũ khí cấp $tier';
  }

  @override
  String get cheatsEnabled => 'Đã bật cheat';

  @override
  String get cheatsDisabled => 'Đã tắt cheat';

  @override
  String get cheatsMaxed => 'CHEAT: tín dụng tối đa, mở khóa mọi vũ khí';

  @override
  String get cheats => 'CHEAT';

  @override
  String get maxCredits => 'TÍN DỤNG TỐI ĐA';

  @override
  String get sectionStats => 'CHỈ SỐ';

  @override
  String get sectionLoadout => 'VŨ KHÍ';

  @override
  String get sectionOutfitting => 'TRANG BỊ';

  @override
  String get sectionShop => 'CỬA HÀNG';

  @override
  String get tabFront => 'TRƯỚC';

  @override
  String get tabSide => 'BÊN';

  @override
  String get tabGen => 'MP';

  @override
  String get sideLeft => 'TRÁI';

  @override
  String get sideRight => 'PHẢI';

  @override
  String get noWeaponInstalled => 'CHƯA LẮP VŨ KHÍ';

  @override
  String levelShort(int level) {
    return 'Cấp $level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'ST:$damage TĐ:$speed';
  }

  @override
  String statPower(int power) {
    return 'NL:$power';
  }

  @override
  String get beam => 'TIA';

  @override
  String get guided => 'DẪN ĐƯỜNG';

  @override
  String get owned => 'ĐÃ CÓ';

  @override
  String get max => 'TỐI ĐA';

  @override
  String get upgrade => 'NÂNG CẤP';

  @override
  String get upgradeShort => 'NC';

  @override
  String get sell => 'BÁN';

  @override
  String get buy => 'MUA';

  @override
  String get noCredits => 'THIẾU TÍN DỤNG';

  @override
  String get commandCenter => 'TRUNG TÂM CHỈ HUY';

  @override
  String get pilot => 'Phi công';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ĐIỂM';

  @override
  String get nextWeapon => 'VŨ KHÍ TIẾP THEO';

  @override
  String pointsValue(String points) {
    return '$points điểm';
  }

  @override
  String get slotFront => 'Trước';

  @override
  String get slotLeft => 'Trái';

  @override
  String get slotRight => 'Phải';

  @override
  String get slotGen => 'MP';

  @override
  String get power => 'NL';

  @override
  String get generator => 'MÁY PHÁT';

  @override
  String genOutput(String value) {
    return 'NL: +$value/khung';
  }

  @override
  String genCapacity(int value) {
    return 'Dung lượng: $value';
  }

  @override
  String get startMission => 'BẮT ĐẦU NHIỆM VỤ';

  @override
  String get continueMission => 'TIẾP TỤC NHIỆM VỤ';

  @override
  String get padControlsHint =>
      '[B] Mua/nâng cấp   [X/Y] Bán   [LB/RB] Thẻ   [OPTIONS] Tiếp tục nhiệm vụ';

  @override
  String get host => 'TẠO PHÒNG';

  @override
  String get connectToHost => 'Kết nối với chủ phòng';

  @override
  String hostingAt(String ip) {
    return 'ĐANG TẠO PHÒNG  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'THAM GIA';
}
