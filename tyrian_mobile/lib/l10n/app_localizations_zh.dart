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
  String get statsOn => '統計:開';

  @override
  String get statsOff => '統計:關';

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
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 选择   [B] 购买/升级/切换   [X/Y] 出售   [OPTIONS] 继续';

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
  String get swapHint => '两根手指按住时使用第二套武器射击';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv：火力更强';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP：船体已修复';
  }

  @override
  String pickupShield(int amount) {
    return '护盾 +$amount，充能更快';
  }

  @override
  String get pickupGenerator => '发电机升级：武器能量更多';

  @override
  String pickupCredits(String amount) {
    return '+$amount 积分，可在 ComCenter 使用';
  }

  @override
  String nodeLevel(int level) {
    return '等級 $level';
  }

  @override
  String get tutPickupWeapon => '武器道具提升枪械等级：伤害更高，射速更快';

  @override
  String get tutPickupHealth => '维修道具修复船体；满血时还会提升 HP 上限';

  @override
  String get tutPickupShield => '护盾先于船体承受伤害，并会自动恢复';

  @override
  String get tutPickupGenerator => '发电机为武器供能：能量越多，开火的武器越多';

  @override
  String get tutPickupCredits => '回合之间可在 ComCenter 用积分购买武器和升级';

  @override
  String get tutBoss => 'BOSS！顶部的血条就是它的生命。保持移动，持续开火';

  @override
  String get tutLowHp => '船体告急！用维修道具或去 ComCenter 修复';

  @override
  String get tutGenStarved => '武器所需能量超过发电机供给：升级发电机';

  @override
  String get tutCanAfford => '积分够升级了：本回合后去 ComCenter 看看';

  @override
  String get tutFly => '拖动来飞行。手指按住时武器持续开火';

  @override
  String get introCollect => '收集敌人掉落的图标';

  @override
  String get introShop => '回合之间，在 ComCenter 花掉积分';

  @override
  String get objBoss => '目标：挺过敌潮并击败 Boss';

  @override
  String get objSurvive => '目标：挺过敌潮';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits 积分 · 击落 $kills';
  }

  @override
  String roundBestWeapon(String weapon) {
    return '最佳武器：$weapon';
  }

  @override
  String get deathBoss => 'Boss 火力凶猛：更强的护盾能为你争取时间';

  @override
  String get deathShield => '在 ComCenter 升级护盾：它先于船体承受伤害';

  @override
  String get deathGuns => '更强的武器能在敌潮伤到你之前将其清除';
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
  String get statsOn => '統計:開';

  @override
  String get statsOff => '統計:關';

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
  String get startMission => '開始任務';

  @override
  String get continueMission => '繼續任務';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 選擇   [B] 購買/升級/切換   [X/Y] 出售   [OPTIONS] 繼續';

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
  String get swapHint => '兩根手指按住時使用第二套武器射擊';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv：火力更強';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP：船體已修復';
  }

  @override
  String pickupShield(int amount) {
    return '護盾 +$amount，充能更快';
  }

  @override
  String get pickupGenerator => '發電機升級：武器能量更多';

  @override
  String pickupCredits(String amount) {
    return '+$amount 點數，可在 ComCenter 使用';
  }

  @override
  String nodeLevel(int level) {
    return '等級 $level';
  }

  @override
  String get tutPickupWeapon => '武器道具提升槍械等級：傷害更高，射速更快';

  @override
  String get tutPickupHealth => '維修道具修復船體；滿血時還會提升 HP 上限';

  @override
  String get tutPickupShield => '護盾先於船體承受傷害，並會自動恢復';

  @override
  String get tutPickupGenerator => '發電機為武器供能：能量越多，開火的武器越多';

  @override
  String get tutPickupCredits => '回合之間可在 ComCenter 用點數購買武器和升級';

  @override
  String get tutBoss => 'BOSS！頂部的血條就是它的生命。保持移動，持續開火';

  @override
  String get tutLowHp => '船體告急！用維修道具或去 ComCenter 修復';

  @override
  String get tutGenStarved => '武器所需能量超過發電機供給：升級發電機';

  @override
  String get tutCanAfford => '點數夠升級了：本回合後去 ComCenter 看看';

  @override
  String get tutFly => '拖曳來飛行。手指按住時武器持續開火';

  @override
  String get introCollect => '收集敵人掉落的圖示';

  @override
  String get introShop => '回合之間，在 ComCenter 花掉點數';

  @override
  String get objBoss => '目標：撐過敵潮並擊敗 Boss';

  @override
  String get objSurvive => '目標：撐過敵潮';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits 點數 · 擊落 $kills';
  }

  @override
  String roundBestWeapon(String weapon) {
    return '最佳武器：$weapon';
  }

  @override
  String get deathBoss => 'Boss 火力兇猛：更強的護盾能為你爭取時間';

  @override
  String get deathShield => '在 ComCenter 升級護盾：它先於船體承受傷害';

  @override
  String get deathGuns => '更強的武器能在敵潮傷到你之前將其清除';
}
