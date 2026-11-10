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

  @override
  String joinConnecting(String target) {
    return 'Đang kết nối tới $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Máy chủ không phản hồi: $reason.\n\nCả hai người chơi phải cùng một mạng Wi-Fi (Điểm truy cập cá nhân cũng được) và máy chủ phải đã nhấn HOST. Hãy kiểm tra địa chỉ rồi thử lại.';
  }

  @override
  String get lanJoinNoAnswer => 'không có phản hồi';

  @override
  String objBossUnder(int seconds) {
    return 'Phá lõi trùm trong $seconds giây kể từ khi nó xuất hiện';
  }

  @override
  String get sectionHangar => 'XƯỞNG';

  @override
  String get sectionVault => 'KHO';

  @override
  String get rackSide => 'Bên';

  @override
  String get rackHull => 'Thân';

  @override
  String get rarityCommon => 'THƯỜNG';

  @override
  String get rarityRare => 'HIẾM';

  @override
  String get rarityMythic => 'THẦN THOẠI';

  @override
  String get curse => 'LỜI NGUYỀN';

  @override
  String get modFit => 'LẮP';

  @override
  String get modUnfit => 'THÁO';

  @override
  String get modForge => 'LÒ RÈN';

  @override
  String get forgeHint => 'Chọn 3 cùng độ hiếm để rèn 1 cấp cao hơn';

  @override
  String get vaultEmpty =>
      'Chưa có mod. Hoàn thành một nút đủ sao, hạ trùm thật nhanh hoặc bắn hạ trùm ở chế độ vô tận.';

  @override
  String modNeeds(String families) {
    return 'Dùng với $families';
  }

  @override
  String get modRackFull => 'Giá đã đầy';

  @override
  String get modAlreadyFitted => 'Đã lắp rồi';

  @override
  String get modWrongRack => 'Không hợp với giá này';

  @override
  String modsSpilled(int n) {
    return '$n mod về lại kho';
  }

  @override
  String get hullLocked => 'Đã khóa';

  @override
  String hullUnlockBoss(int n) {
    return 'Hạ trùm chiến dịch $n';
  }

  @override
  String get hullUnlockFinish => 'Hoàn thành chiến dịch hoặc tới khu vực 30';

  @override
  String get statAgility => 'LIN';

  @override
  String get statHitbox => 'VÙN';

  @override
  String get perkNone => 'Tàu tiêu chuẩn';

  @override
  String get perkAfterimage => 'Đứng yên: đạn ×1,5';

  @override
  String get perkBulwark => 'Sát thương xuyên khiên giảm một nửa';

  @override
  String get perkOverclock => 'Bắn vũ khí tới 130 % công suất, chậm hơn';

  @override
  String get perkBattery => 'Một drone miễn phí bay theo';

  @override
  String get rewardTitle => 'PHẦN THƯỞNG';

  @override
  String newHull(String name) {
    return 'Thân tàu mới: $name';
  }

  @override
  String get socketEmpty => 'trống';

  @override
  String fxStreams(int n) {
    return '$n luồng song song';
  }

  @override
  String fxFan(int n) {
    return 'Quạt $n viên';
  }

  @override
  String fxSalvo(int n) {
    return 'Loạt $n viên';
  }

  @override
  String fxFireRate(String x) {
    return 'Tốc độ bắn ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Sát thương ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Tốc độ đạn ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Kích thước đạn ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Tiêu hao năng lượng ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Dẫn đường +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Xuyên $n mục tiêu';
  }

  @override
  String get fxPierceAll => 'Xuyên mọi thứ';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % cơ hội sát thương ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Chí mạng ×$x với trùm';
  }

  @override
  String fxFork(int n) {
    return 'Hạ địch tỏa ra $n viên';
  }

  @override
  String get fxChain => 'Đạn tỏa lại tỏa tiếp';

  @override
  String get fxSplit => 'Tách đôi khi trúng';

  @override
  String get fxFrost => 'Trúng đạn làm địch chậm lại';

  @override
  String get fxCrossfire => 'Súng bên nhắm vào giữa';

  @override
  String get fxRearguard => 'Súng bên bắn cả phía sau';

  @override
  String get fxOrbit => 'Đạn uốn lượn';

  @override
  String fxBounce(int n) {
    return 'Nảy khỏi tường $n×';
  }

  @override
  String get fxBounceTop => '…và cả mép trên';

  @override
  String get fxOverdrive => 'Bắn cả khi nợ năng lượng';

  @override
  String get fxReactor => 'Vũ khí quá công suất vẫn bắn, chậm';

  @override
  String fxGenPower(String x) {
    return 'Nạp máy phát ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Dung lượng máy phát ×$x';
  }

  @override
  String get fxSurge => 'Máy phát đầy: đạn ×2';

  @override
  String fxSiphon(int pct) {
    return 'Hạ địch nạp $pct % năng lượng';
  }

  @override
  String fxHp(String x) {
    return 'Thân tàu ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Khiên ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Hồi khiên ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Hạ địch hồi $n HP';
  }

  @override
  String get fxMagnet => 'Hút vật phẩm';

  @override
  String get fxMagnetAll => 'Hút mọi vật phẩm';

  @override
  String fxReflect(int pct) {
    return '$pct % đạn bật lại từ khiên';
  }

  @override
  String get fxReflectGuided => 'Đạn phản xạ tự dẫn';

  @override
  String fxGhost(String sec) {
    return 'Bất tử $sec giây sau khi thân trúng đòn';
  }

  @override
  String get fxNova => 'Khiên vỡ: nổ khắp màn hình';

  @override
  String fxAgility(String x) {
    return 'Nhanh nhẹn ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Vùng trúng ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Tín dụng ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Điểm ×$x';
  }

  @override
  String get fxSatellite => 'Một drone chiến đấu bay theo';

  @override
  String get fxTimewarp => 'Thân trúng đòn làm chậm thời gian';

  @override
  String get fxGambler => 'Mỗi viên là một vũ khí ngẫu nhiên';

  @override
  String get vaultAll => 'TẤT CẢ';

  @override
  String get sigilMissUnknown => 'hình không xác định';

  @override
  String get sigilMissTooSlow => 'quá chậm';

  @override
  String get sigilMissSkippedDot => 'bỏ sót một điểm';

  @override
  String get sigilMissLeftRimEarly => 'thả ra quá sớm';

  @override
  String get sigilMissWrongDirection => 'vẽ ngược chiều';

  @override
  String get sigilMissWrongLayer => 'sai nút vai';

  @override
  String get sigilDry => 'không đủ năng lượng';

  @override
  String get sigilBusy => 'chiêu trước vẫn đang chạy';

  @override
  String get arena => 'ĐẤU TRƯỜNG';

  @override
  String get arenaBossParts => 'BỘ PHẬN TRÙM';

  @override
  String get arenaBareCore => 'chỉ có lõi';

  @override
  String get arenaCompanions => 'BẠN ĐỒNG HÀNH';

  @override
  String get arenaCharge => 'NĂNG LƯỢNG';

  @override
  String get arenaChargeNormal => 'BÌNH THƯỜNG';

  @override
  String get arenaSpeed => 'TỐC ĐỘ THẾ GIỚI';

  @override
  String get arenaDrill => 'LUYỆN TẬP';

  @override
  String get arenaFreePlay => 'TỰ DO';

  @override
  String get arenaFight => 'CHIẾN ĐẤU';

  @override
  String get arenaNewBoss => 'TRÙM MỚI';

  @override
  String get arenaLeave => 'RỜI ĐẤU TRƯỜNG';

  @override
  String get arenaHint =>
      'Trùm quay lại ngay khi gục ngã. Ở đây không lưu gì cả.';

  @override
  String get arenaColCast => 'THÀNH';

  @override
  String get arenaColMiss => 'TRƯỢT';

  @override
  String get arenaColAvg => 'TB';

  @override
  String get arenaColBest => 'TỐT NHẤT';

  @override
  String get arenaColTime => 'NHANH NHẤT';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Trùm $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'TAY CẦM: ẤN CHÚ';

  @override
  String get padSchemeClassic => 'TAY CẦM: CỔ ĐIỂN';

  @override
  String get padSouthpawOn => 'TAY TRÁI: BẬT';

  @override
  String get padSouthpawOff => 'TAY TRÁI: TẮT';

  @override
  String get sigilDescHop => 'Nhảy nhanh theo hướng gạt cần';

  @override
  String get sigilDescSidestep => 'Bước ngang dài băng qua chiến trường';

  @override
  String get sigilDescStrike => 'Lao lên với ba phát đạn nặng rồi lùi lại';

  @override
  String get sigilDescRetreat =>
      'Lùi lại trong khi hỏa lực yểm trợ bắn lên trước';

  @override
  String get sigilDescDash => 'Lướt chéo xuyên làn đạn, bất tử giữa chừng';

  @override
  String get sigilDescRoll => 'Cuộn thân sang bên, bất tử';

  @override
  String get sigilDescShadow => 'Bám dưới địch gần nhất và tiếp tục bắn';

  @override
  String get sigilDescEcho =>
      'Một bóng mờ lặp lại hai giây cuối của bạn với nửa sát thương';

  @override
  String get sigilDescLoop => 'Nhào lộn qua phía trên: đạn bay bên dưới bạn';

  @override
  String get sigilDescSlalom =>
      'Đường cong chữ S băng qua chiến trường với đạn hình quạt';

  @override
  String get sigilDescCorkscrew => 'Xoắn ốc lên trước, bắn tứ phía, bất tử';

  @override
  String get sigilDescSnapshot => 'Một phát đạn nặng theo hướng gạt cần';

  @override
  String get sigilDescBroadside => 'Một loạt đạn từ hai bên sườn';

  @override
  String get sigilDescVolley => 'Năm tia tích năng lượng bắn lên trước';

  @override
  String get sigilDescCaltrop => 'Thả mìn nuốt đạn rồi phát nổ';

  @override
  String get sigilDescFrenzy => 'Súng bắn nhanh hơn trong vài giây';

  @override
  String get sigilDescStasis => 'Địch và đạn của chúng chậm còn một nửa';

  @override
  String get sigilDescHalo => 'Khiên hồi nhanh gấp bốn và không gì xuyên qua';

  @override
  String get sigilDescRadial => 'Một vòng mười sáu viên đạn';

  @override
  String get sigilDescStorm => 'Mọi súng bắn hết cỡ, miễn phí';

  @override
  String get sigilDescPing => 'Bạn đồng hành dồn hỏa lực theo hướng gạt cần';

  @override
  String get sigilDescWingman => 'Gọi máy bay hộ tống tới bên sườn bạn đã vẽ';

  @override
  String get sigilDescHunter => 'Gọi thợ săn bay lên trước và chọn mục tiêu';

  @override
  String get sigilDescWarden => 'Gọi hộ vệ đỡ đạn thay bạn';

  @override
  String get sigilDescFormation =>
      'Bạn đồng hành đổi giữa đội hình rộng và hình nêm';

  @override
  String get sigilDescWhirl => 'Bạn đồng hành bay vòng quanh bạn và nuốt đạn';

  @override
  String get sigilDescSacrifice =>
      'Bạn đồng hành lao xuống và phát nổ, hoàn lại năng lượng';

  @override
  String get grimoire => 'SÁCH PHÉP';

  @override
  String get grimoireHint =>
      'Vẽ bằng cần phải. Giữ LB cho ARMS, RB cho WING, cả hai cho MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'giá $cost';
  }

  @override
  String get sigilUntouchable => 'bất tử';

  @override
  String get lessonWatch => 'XEM';

  @override
  String get lessonTrace => 'VẼ THEO';

  @override
  String get lessonSlow => 'CHẬM';

  @override
  String get lessonLive => 'TỐC ĐỘ THẬT';

  @override
  String get lessonStreak => 'NĂM LẦN LIÊN TIẾP';

  @override
  String get lessonLearned => 'ĐÃ THUỘC';

  @override
  String lessonTempo(int pct) {
    return 'NHỊP $pct %';
  }
}
