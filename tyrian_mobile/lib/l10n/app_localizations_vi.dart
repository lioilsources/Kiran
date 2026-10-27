// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'HỦY';

  @override
  String get connect => 'KẾT NỐI';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Không thể kết nối tới $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Đã thấy máy chủ nhưng không thiết lập được liên kết.\n\nChơi gần nhau cần Wi-Fi ngang hàng, mà iOS sẽ tắt khi Điểm truy cập cá nhân đang bật. Hãy tắt điểm truy cập trên cả hai thiết bị rồi thử lại, hoặc kết nối cả hai vào cùng một mạng Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Nhiệm vụ thất bại — giữ nguyên trang bị và tín dụng. Thử lại từ Trung tâm Chỉ huy.';

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
  String get mainMenu => 'MENU CHÍNH';

  @override
  String get quitToDesktop => 'THOÁT RA DESKTOP';

  @override
  String get selectSkin => 'CHỌN GIAO DIỆN';

  @override
  String get difficulty => 'ĐỘ KHÓ';

  @override
  String get difficultyEasy => 'DỄ';

  @override
  String get difficultyNormal => 'THƯỜNG';

  @override
  String get difficultyHard => 'KHÓ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CHIẾN DỊCH';

  @override
  String get quit => 'THOÁT';

  @override
  String get restorePurchases => 'KHÔI PHỤC GIAO DỊCH';

  @override
  String get locked => 'ĐÃ KHÓA';

  @override
  String get mainMenuTooltip => 'Menu chính';

  @override
  String nodeLevel(int level) {
    return 'CẤP $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'CẤP $level · TRÙM $ordinal';
  }

  @override
  String get nodeLockedHint => 'Đã khóa. Hãy hoàn thành nhiệm vụ trước đó.';

  @override
  String get flyAgain => 'BAY LẠI';

  @override
  String get launch => 'CẤT CÁNH';

  @override
  String zoneLabel(int zone) {
    return 'VÙNG $zone';
  }

  @override
  String get objectiveStar => 'SAO';

  @override
  String get continueButton => 'TIẾP TỤC';

  @override
  String get replayNode => 'CHƠI LẠI';

  @override
  String get retry => 'THỬ LẠI';

  @override
  String get nodeCleared => 'HOÀN THÀNH';

  @override
  String get nodeFailed => 'THẤT BẠI';

  @override
  String get weaponTierUnlocked => 'MỞ KHÓA BẬC VŨ KHÍ';

  @override
  String get onSaleInComCenter => 'Đã có bán tại Trung tâm Chỉ huy.';

  @override
  String get requiredTasksHint =>
      'Các nhiệm vụ bắt buộc quyết định kết quả. Hãy bay lại — những gì bạn kiếm được vẫn còn nguyên.';

  @override
  String get objClear => 'Dọn sạch khu vực';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bắn hạ $count kẻ địch',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Không để thân tàu bị hư hại';

  @override
  String objHull(int percent) {
    return 'Kết thúc với thân tàu trên $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hạ $count kẻ địch bằng $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hạ $count kẻ địch bằng súng bên',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Cất cánh với $weapon ở phía trước';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Cất cánh với $weapon ở bên hông';
  }

  @override
  String get objBuySideGun => 'Mua một khẩu súng bên tại Trung tâm Chỉ huy';

  @override
  String objUpgradeGenerator(int level) {
    return 'Nâng cấp máy phát lên cấp $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Nâng cấp súng trước lên cấp $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Nâng cấp một súng bên lên cấp $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nhặt $count vật phẩm',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tiêu diệt trọn $count đội hình',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Không đâm vào thiên thạch';

  @override
  String objUnderTime(int seconds) {
    return 'Hoàn thành trong $seconds giây';
  }

  @override
  String get objStripBoss => 'Phá hủy mọi bộ phận của trùm trước lõi';

  @override
  String get joinCoopTitle => 'Tham gia co-op';

  @override
  String get cannotSearchNetwork => 'Không thể tìm kiếm trong mạng này';

  @override
  String get joinHintNearby =>
      'Cùng Wi-Fi hoạt động trên mọi thiết bị. iPhone, iPad và Mac còn tìm thấy nhau ở gần mà không cần Wi-Fi — khi cả hai đã tắt Điểm truy cập cá nhân.';

  @override
  String get joinHintWifi =>
      'Hai người chơi phải dùng cùng Wi-Fi — Điểm truy cập cá nhân cũng được.';

  @override
  String noHostsYet(String hint) {
    return 'Chưa có máy chủ. $hint';
  }

  @override
  String get lookingForHosts => 'Đang tìm máy chủ trên Wi-Fi này và ở gần…';

  @override
  String get hostNearby => 'Ở gần · Bluetooth / Wi-Fi ngang hàng';

  @override
  String hostSameWifi(String address) {
    return '$address · cùng Wi-Fi';
  }

  @override
  String get enterIpManually => 'Nhập IP thủ công';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'KHIÊN';

  @override
  String get hudPower => 'NL';

  @override
  String get hudGen => 'MP';

  @override
  String bossShielded(String name) {
    return '$name — CÓ KHIÊN';
  }

  @override
  String get bossPartTurret => 'Tháp pháo';

  @override
  String get bossPartShieldPod => 'Mô-đun khiên';

  @override
  String get bossPartThruster => 'Động cơ đẩy';

  @override
  String get bossPartCannon => 'Đại bác';

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
  String get launchMission => 'BẮT ĐẦU NHIỆM VỤ';

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
  String hostingAs(String name) {
    return 'ĐANG TẠO PHÒNG: $name';
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
}
