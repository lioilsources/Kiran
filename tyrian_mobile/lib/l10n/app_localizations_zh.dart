// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get cancel => '取消';

  @override
  String get connect => '連線';

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
  String get quitToDesktop => '返回桌面';

  @override
  String get selectSkin => '選擇外觀';

  @override
  String get quit => '離開';

  @override
  String get restorePurchases => '恢復購買項目';

  @override
  String get locked => '未解鎖';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => '護盾';

  @override
  String get hudPower => '能量';

  @override
  String get hudGen => 'GEN';

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
  String get sectionOutfitting => '整備';

  @override
  String get sectionShop => '商店';

  @override
  String get tabFront => '前方';

  @override
  String get tabSide => '側翼';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get noWeaponInstalled => '未裝備武器';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return '傷害:$damage 速度:$speed';
  }

  @override
  String statPower(int power) {
    return '能量:$power';
  }

  @override
  String get beam => '光束';

  @override
  String get guided => '導引';

  @override
  String get owned => '已擁有';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => '升級';

  @override
  String get upgradeShort => '升級';

  @override
  String get sell => '賣出';

  @override
  String get buy => '購買';

  @override
  String get noCredits => '點數不足';

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
  String get generator => '發電機';

  @override
  String genOutput(String value) {
    return '能量:+$value/幀';
  }

  @override
  String genCapacity(int value) {
    return '容量:$value';
  }

  @override
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[B] 購買/升級   [X/Y] 賣出   [LB/RB] 分頁   [OPTIONS] 繼續任務';

  @override
  String get host => '建立主機';

  @override
  String get connectToHost => '連線到主機';

  @override
  String hostingAt(String ip) {
    return '主機  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP:$ip';
  }

  @override
  String get join => '加入';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get cancel => '取消';

  @override
  String get connect => '連線';

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
  String get quitToDesktop => '返回桌面';

  @override
  String get selectSkin => '選擇外觀';

  @override
  String get quit => '離開';

  @override
  String get restorePurchases => '恢復購買項目';

  @override
  String get locked => '未解鎖';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => '護盾';

  @override
  String get hudPower => '能量';

  @override
  String get hudGen => 'GEN';

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
  String get sectionOutfitting => '整備';

  @override
  String get sectionShop => '商店';

  @override
  String get tabFront => '前方';

  @override
  String get tabSide => '側翼';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get noWeaponInstalled => '未裝備武器';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return '傷害:$damage 速度:$speed';
  }

  @override
  String statPower(int power) {
    return '能量:$power';
  }

  @override
  String get beam => '光束';

  @override
  String get guided => '導引';

  @override
  String get owned => '已擁有';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => '升級';

  @override
  String get upgradeShort => '升級';

  @override
  String get sell => '賣出';

  @override
  String get buy => '購買';

  @override
  String get noCredits => '點數不足';

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
  String get generator => '發電機';

  @override
  String genOutput(String value) {
    return '能量:+$value/幀';
  }

  @override
  String genCapacity(int value) {
    return '容量:$value';
  }

  @override
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[B] 購買/升級   [X/Y] 賣出   [LB/RB] 分頁   [OPTIONS] 繼續任務';

  @override
  String get host => '建立主機';

  @override
  String get connectToHost => '連線到主機';

  @override
  String hostingAt(String ip) {
    return '主機  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP:$ip';
  }

  @override
  String get join => '加入';
}
