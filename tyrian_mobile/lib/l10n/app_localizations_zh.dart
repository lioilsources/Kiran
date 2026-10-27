// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get ok => '確定';

  @override
  String get cancel => '取消';

  @override
  String get connect => '連線';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '無法連線至 $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      '已看到主機,但連結沒有建立。\n\n近距離遊玩需要點對點 Wi-Fi,而開啟個人熱點時 iOS 會將其關閉。請在兩台裝置上關閉個人熱點後再試一次,或讓兩台裝置連上同一個 Wi-Fi。';

  @override
  String get gameOverCampaign => '任務失敗 — 保留裝備與點數。請從指揮中心重新挑戰。';

  @override
  String get gameOverEndless => '於第 1 區重建中 — 保留裝備與點數';

  @override
  String get waitingForHost => '等待主機中...';

  @override
  String get waitingForHostHint => '主機準備好後遊戲就會開始';

  @override
  String get vesselLost => '機體損毀';

  @override
  String scoreValue(String score) {
    return '分數:$score';
  }

  @override
  String creditsValue(String credits) {
    return '點數:$credits';
  }

  @override
  String get creditsPrefix => '點數:';

  @override
  String get leaderboard => '排行榜';

  @override
  String get achievements => '成就';

  @override
  String get redeploy => '重新出擊';

  @override
  String get resume => '繼續';

  @override
  String get pause => '暫停';

  @override
  String get paused => '已暫停';

  @override
  String get skins => '外觀';

  @override
  String get skin => '外觀';

  @override
  String get soundOn => '音效:開';

  @override
  String get soundOff => '音效:關';

  @override
  String get musicOn => '音樂:開';

  @override
  String get musicOff => '音樂:關';

  @override
  String get mainMenu => '主選單';

  @override
  String get quitToDesktop => '返回桌面';

  @override
  String get selectSkin => '選擇外觀';

  @override
  String get difficulty => '難度';

  @override
  String get difficultyEasy => '簡單';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困難';

  @override
  String get difficultyLord => '君主';

  @override
  String get campaign => '戰役';

  @override
  String get quit => '離開';

  @override
  String get restorePurchases => '恢復購買項目';

  @override
  String get locked => '未解鎖';

  @override
  String get mainMenuTooltip => '主選單';

  @override
  String nodeLevel(int level) {
    return '等級 $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return '等級 $level · 頭目 $ordinal';
  }

  @override
  String get nodeLockedHint => '未解鎖。請先完成前一個任務。';

  @override
  String get flyAgain => '再次出擊';

  @override
  String get launch => '出擊';

  @override
  String zoneLabel(int zone) {
    return '區域 $zone';
  }

  @override
  String get objectiveStar => '星星';

  @override
  String get continueButton => '繼續';

  @override
  String get replayNode => '重玩任務';

  @override
  String get retry => '重試';

  @override
  String get nodeCleared => '任務完成';

  @override
  String get nodeFailed => '任務失敗';

  @override
  String get weaponTierUnlocked => '新武器等級解鎖';

  @override
  String get onSaleInComCenter => '已在指揮中心開賣。';

  @override
  String get requiredTasksHint => '任務成敗取決於必要目標。再飛一次吧 — 你獲得的東西都會保留。';

  @override
  String get objClear => '肅清此區';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '擊落 $count 架敵機',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => '船體不受任何傷害';

  @override
  String objHull(int percent) {
    return '以船體 $percent% 以上完成';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用 $weapon 擊破 $count 架',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用側翼武器擊破 $count 架',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '在前方裝備 $weapon 出擊';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '在側翼裝備 $weapon 出擊';
  }

  @override
  String get objBuySideGun => '在指揮中心購買側翼武器';

  @override
  String objUpgradeGenerator(int level) {
    return '將發電機升級至 $level 級';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return '將前方武器升級至 $level 級';
  }

  @override
  String objUpgradeSideGun(int level) {
    return '將側翼武器升級至 $level 級';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '收集 $count 個道具',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '全滅 $count 個編隊',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => '不撞上任何小行星';

  @override
  String objUnderTime(int seconds) {
    return '在 $seconds 秒內完成';
  }

  @override
  String get objStripBoss => '在核心之前摧毀頭目的所有部件';

  @override
  String get joinCoopTitle => '加入合作模式';

  @override
  String get cannotSearchNetwork => '無法在此網路中搜尋';

  @override
  String get joinHintNearby =>
      '只要在同一個 Wi-Fi,任何裝置都能連線。iPhone、iPad 和 Mac 也能在沒有 Wi-Fi 時找到附近的彼此 — 前提是兩台都關閉個人熱點。';

  @override
  String get joinHintWifi => '兩位玩家必須在同一個 Wi-Fi — 使用個人熱點也可以。';

  @override
  String noHostsYet(String hint) {
    return '尚未找到主機。$hint';
  }

  @override
  String get lookingForHosts => '正在此 Wi-Fi 及附近搜尋主機…';

  @override
  String get hostNearby => '附近 · 藍牙/點對點 Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · 同一個 Wi-Fi';
  }

  @override
  String get enterIpManually => '手動輸入 IP';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => '護盾';

  @override
  String get hudPower => '能量';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — 護盾中';
  }

  @override
  String get bossPartTurret => '砲塔';

  @override
  String get bossPartShieldPod => '護盾艙';

  @override
  String get bossPartThruster => '推進器';

  @override
  String get bossPartCannon => '主砲';

  @override
  String sectorUnknownSpace(int level) {
    return '第 $level 區 — 未知宙域';
  }

  @override
  String get player2Joined => '玩家 2 已加入!';

  @override
  String get player2Disconnected => '玩家 2 已斷線';

  @override
  String get hostDisconnected => '主機已斷線';

  @override
  String maxLevelSold(String amount) {
    return '已達最高等級!以 \$$amount 售出';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return '武器等級 $tier 已解鎖';
  }

  @override
  String get cheatsEnabled => '作弊已開啟';

  @override
  String get cheatsDisabled => '作弊已關閉';

  @override
  String get cheatsMaxed => '作弊:點數全滿,所有武器解鎖';

  @override
  String get cheats => '作弊';

  @override
  String get maxCredits => '點數全滿';

  @override
  String get sectionStats => '數值';

  @override
  String get sectionLoadout => '目前武裝';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => '升級';

  @override
  String get sell => '賣出';

  @override
  String get buy => '購買';

  @override
  String get commandCenter => '指揮中心';

  @override
  String get pilot => '駕駛員';

  @override
  String get dps => 'DPS';

  @override
  String get score => '分數';

  @override
  String get nextWeapon => '下一件武器';

  @override
  String pointsValue(String points) {
    return '$points 分';
  }

  @override
  String get slotFront => '前方';

  @override
  String get slotLeft => '左';

  @override
  String get slotRight => '右';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => '能量';

  @override
  String get launchMission => '開始任務';

  @override
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 选择   [B] 购买/升级/切换   [X/Y] 出售   [OPTIONS] 继续';

  @override
  String get host => '建立主機';

  @override
  String hostingAs(String name) {
    return '主機:$name';
  }

  @override
  String get join => '加入';

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
  String get overload => '过载';

  @override
  String weaponOff(String weapon) {
    return '$weapon 关闭 — 发电机功率不足';
  }

  @override
  String unlocksAt(String points) {
    return '$points 分解锁';
  }

  @override
  String joinConnecting(String target) {
    return '正在连接 $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return '主机没有响应：$reason。\n\n两位玩家需要连接同一个 Wi-Fi（个人热点也可以），并且主机需要已按下 HOST。请检查地址后重试。';
  }

  @override
  String get lanJoinNoAnswer => '无响应';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get ok => '確定';

  @override
  String get cancel => '取消';

  @override
  String get connect => '連線';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '無法連線至 $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      '已看到主機,但連結沒有建立。\n\n近距離遊玩需要點對點 Wi-Fi,而開啟個人熱點時 iOS 會將其關閉。請在兩台裝置上關閉個人熱點後再試一次,或讓兩台裝置連上同一個 Wi-Fi。';

  @override
  String get gameOverCampaign => '任務失敗 — 保留裝備與點數。請從指揮中心重新挑戰。';

  @override
  String get gameOverEndless => '於第 1 區重建中 — 保留裝備與點數';

  @override
  String get waitingForHost => '等待主機中...';

  @override
  String get waitingForHostHint => '主機準備好後遊戲就會開始';

  @override
  String get vesselLost => '機體損毀';

  @override
  String scoreValue(String score) {
    return '分數:$score';
  }

  @override
  String creditsValue(String credits) {
    return '點數:$credits';
  }

  @override
  String get creditsPrefix => '點數:';

  @override
  String get leaderboard => '排行榜';

  @override
  String get achievements => '成就';

  @override
  String get redeploy => '重新出擊';

  @override
  String get resume => '繼續';

  @override
  String get pause => '暫停';

  @override
  String get paused => '已暫停';

  @override
  String get skins => '外觀';

  @override
  String get skin => '外觀';

  @override
  String get soundOn => '音效:開';

  @override
  String get soundOff => '音效:關';

  @override
  String get musicOn => '音樂:開';

  @override
  String get musicOff => '音樂:關';

  @override
  String get mainMenu => '主選單';

  @override
  String get quitToDesktop => '返回桌面';

  @override
  String get selectSkin => '選擇外觀';

  @override
  String get difficulty => '難度';

  @override
  String get difficultyEasy => '簡單';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困難';

  @override
  String get difficultyLord => '君主';

  @override
  String get campaign => '戰役';

  @override
  String get quit => '離開';

  @override
  String get restorePurchases => '恢復購買項目';

  @override
  String get locked => '未解鎖';

  @override
  String get mainMenuTooltip => '主選單';

  @override
  String nodeLevel(int level) {
    return '等級 $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return '等級 $level · 頭目 $ordinal';
  }

  @override
  String get nodeLockedHint => '未解鎖。請先完成前一個任務。';

  @override
  String get flyAgain => '再次出擊';

  @override
  String get launch => '出擊';

  @override
  String zoneLabel(int zone) {
    return '區域 $zone';
  }

  @override
  String get objectiveStar => '星星';

  @override
  String get continueButton => '繼續';

  @override
  String get replayNode => '重玩任務';

  @override
  String get retry => '重試';

  @override
  String get nodeCleared => '任務完成';

  @override
  String get nodeFailed => '任務失敗';

  @override
  String get weaponTierUnlocked => '新武器等級解鎖';

  @override
  String get onSaleInComCenter => '已在指揮中心開賣。';

  @override
  String get requiredTasksHint => '任務成敗取決於必要目標。再飛一次吧 — 你獲得的東西都會保留。';

  @override
  String get objClear => '肅清此區';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '擊落 $count 架敵機',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => '船體不受任何傷害';

  @override
  String objHull(int percent) {
    return '以船體 $percent% 以上完成';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用 $weapon 擊破 $count 架',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用側翼武器擊破 $count 架',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '在前方裝備 $weapon 出擊';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '在側翼裝備 $weapon 出擊';
  }

  @override
  String get objBuySideGun => '在指揮中心購買側翼武器';

  @override
  String objUpgradeGenerator(int level) {
    return '將發電機升級至 $level 級';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return '將前方武器升級至 $level 級';
  }

  @override
  String objUpgradeSideGun(int level) {
    return '將側翼武器升級至 $level 級';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '收集 $count 個道具',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '全滅 $count 個編隊',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => '不撞上任何小行星';

  @override
  String objUnderTime(int seconds) {
    return '在 $seconds 秒內完成';
  }

  @override
  String get objStripBoss => '在核心之前摧毀頭目的所有部件';

  @override
  String get joinCoopTitle => '加入合作模式';

  @override
  String get cannotSearchNetwork => '無法在此網路中搜尋';

  @override
  String get joinHintNearby =>
      '只要在同一個 Wi-Fi,任何裝置都能連線。iPhone、iPad 和 Mac 也能在沒有 Wi-Fi 時找到附近的彼此 — 前提是兩台都關閉個人熱點。';

  @override
  String get joinHintWifi => '兩位玩家必須在同一個 Wi-Fi — 使用個人熱點也可以。';

  @override
  String noHostsYet(String hint) {
    return '尚未找到主機。$hint';
  }

  @override
  String get lookingForHosts => '正在此 Wi-Fi 及附近搜尋主機…';

  @override
  String get hostNearby => '附近 · 藍牙/點對點 Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · 同一個 Wi-Fi';
  }

  @override
  String get enterIpManually => '手動輸入 IP';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => '護盾';

  @override
  String get hudPower => '能量';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — 護盾中';
  }

  @override
  String get bossPartTurret => '砲塔';

  @override
  String get bossPartShieldPod => '護盾艙';

  @override
  String get bossPartThruster => '推進器';

  @override
  String get bossPartCannon => '主砲';

  @override
  String sectorUnknownSpace(int level) {
    return '第 $level 區 — 未知宙域';
  }

  @override
  String get player2Joined => '玩家 2 已加入!';

  @override
  String get player2Disconnected => '玩家 2 已斷線';

  @override
  String get hostDisconnected => '主機已斷線';

  @override
  String maxLevelSold(String amount) {
    return '已達最高等級!以 \$$amount 售出';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return '武器等級 $tier 已解鎖';
  }

  @override
  String get cheatsEnabled => '作弊已開啟';

  @override
  String get cheatsDisabled => '作弊已關閉';

  @override
  String get cheatsMaxed => '作弊:點數全滿,所有武器解鎖';

  @override
  String get cheats => '作弊';

  @override
  String get maxCredits => '點數全滿';

  @override
  String get sectionStats => '數值';

  @override
  String get sectionLoadout => '目前武裝';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => '升級';

  @override
  String get sell => '賣出';

  @override
  String get buy => '購買';

  @override
  String get commandCenter => '指揮中心';

  @override
  String get pilot => '駕駛員';

  @override
  String get dps => 'DPS';

  @override
  String get score => '分數';

  @override
  String get nextWeapon => '下一件武器';

  @override
  String pointsValue(String points) {
    return '$points 分';
  }

  @override
  String get slotFront => '前方';

  @override
  String get slotLeft => '左';

  @override
  String get slotRight => '右';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => '能量';

  @override
  String get launchMission => '開始任務';

  @override
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 選擇   [B] 購買/升級/切換   [X/Y] 出售   [OPTIONS] 繼續';

  @override
  String get host => '建立主機';

  @override
  String hostingAs(String name) {
    return '主機:$name';
  }

  @override
  String get join => '加入';

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
  String get overload => '過載';

  @override
  String weaponOff(String weapon) {
    return '$weapon 關閉 — 發電機功率不足';
  }

  @override
  String unlocksAt(String points) {
    return '$points 分解鎖';
  }

  @override
  String joinConnecting(String target) {
    return '正在連線至 $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return '主機沒有回應：$reason。\n\n兩位玩家需要連上同一個 Wi-Fi（個人熱點也可以），而且主機需要已按下 HOST。請檢查位址後再試一次。';
  }

  @override
  String get lanJoinNoAnswer => '沒有回應';
}
