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
  String get statsOn => 'THỐNG KÊ: BẬT';

  @override
  String get statsOff => 'THỐNG KÊ: TẮT';

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
  String levelShort(int level) {
    return 'Cấp $level';
  }

  @override
  String get max => 'TỐI ĐA';

  @override
  String get upgradeShort => 'NC';

  @override
  String get sell => 'BÁN';

  @override
  String get buy => 'MUA';

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
  String get startMission => 'BẮT ĐẦU NHIỆM VỤ';

  @override
  String get continueMission => 'TIẾP TỤC NHIỆM VỤ';

  @override
  String get padControlsHint =>
      '[↑↓] Hàng   [←→] Chọn   [B] Mua/Nâng cấp/Đổi   [X/Y] Bán   [OPTIONS] Tiếp tục';

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
  String get overload => 'QUÁ TẢI';

  @override
  String weaponOff(String weapon) {
    return '$weapon TẮT — máy phát quá yếu';
  }

  @override
  String unlocksAt(String points) {
    return 'Mở khóa ở $points điểm';
  }

  @override
  String get swapHint => 'Giữ hai ngón tay để bắn bằng bộ vũ khí thứ hai';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: bắn mạnh hơn';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: thân tàu đã sửa';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount khiên, sạc nhanh hơn';
  }

  @override
  String get pickupGenerator => 'Máy phát mạnh hơn: thêm năng lượng cho vũ khí';

  @override
  String pickupCredits(String amount) {
    return '+$amount tín dụng để tiêu ở ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'CẤP $level';
  }

  @override
  String get tutPickupWeapon =>
      'Vật phẩm vũ khí tăng cấp súng: sát thương cao hơn, bắn nhanh hơn';

  @override
  String get tutPickupHealth =>
      'Vật phẩm sửa chữa vá thân tàu; khi đầy máu sẽ tăng HP tối đa';

  @override
  String get tutPickupShield => 'Khiên đỡ đòn trước thân tàu và tự hồi lại';

  @override
  String get tutPickupGenerator =>
      'Máy phát cấp năng lượng cho súng: càng nhiều năng lượng, càng nhiều súng bắn';

  @override
  String get tutPickupCredits =>
      'Dùng tín dụng mua súng và nâng cấp ở ComCenter giữa các vòng';

  @override
  String get tutBoss =>
      'BOSS! Máu của nó là thanh trên cùng. Di chuyển và bắn liên tục';

  @override
  String get tutLowHp => 'Thân tàu yếu! Sửa bằng vật phẩm hoặc ở ComCenter';

  @override
  String get tutGenStarved =>
      'Súng cần nhiều năng lượng hơn máy phát cấp: nâng cấp nó';

  @override
  String get tutCanAfford => 'Bạn đủ tiền nâng cấp: ghé ComCenter sau vòng này';

  @override
  String get tutFly => 'Kéo để bay. Súng bắn khi ngón tay còn chạm màn hình';

  @override
  String get introCollect => 'Nhặt các biểu tượng kẻ địch rơi ra';

  @override
  String get introShop => 'Giữa các vòng, tiêu tín dụng ở ComCenter';

  @override
  String get objBoss => 'Mục tiêu: sống sót qua các đợt và hạ boss';

  @override
  String get objSurvive => 'Mục tiêu: sống sót qua các đợt';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits tín dụng · $kills hạ gục';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Vũ khí tốt nhất: $weapon';
  }

  @override
  String get deathBoss =>
      'Đạn boss rất mạnh: khiên tốt hơn cho bạn thêm thời gian';

  @override
  String get deathShield =>
      'Nâng cấp khiên ở ComCenter: nó đỡ đòn trước thân tàu';

  @override
  String get deathGuns =>
      'Súng mạnh hơn quét sạch các đợt trước khi chúng làm hại bạn';
}
