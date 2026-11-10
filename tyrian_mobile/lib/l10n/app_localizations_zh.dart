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

  @override
  String objBossUnder(int seconds) {
    return '在首领核心出现后 $seconds 秒内摧毁它';
  }

  @override
  String get sectionHangar => '机库';

  @override
  String get sectionVault => '仓库';

  @override
  String get rackSide => '侧翼';

  @override
  String get rackHull => '船体';

  @override
  String get rarityCommon => '普通';

  @override
  String get rarityRare => '稀有';

  @override
  String get rarityMythic => '神话';

  @override
  String get curse => '诅咒';

  @override
  String get modFit => '装配';

  @override
  String get modUnfit => '卸下';

  @override
  String get modForge => '锻造';

  @override
  String get forgeHint => '选 3 个同稀有度的模组锻造 1 个更高级的';

  @override
  String get vaultEmpty => '还没有模组。满星通关节点、快速击败首领，或在无尽模式击落首领。';

  @override
  String modNeeds(String families) {
    return '适用于 $families';
  }

  @override
  String get modRackFull => '槽位已满';

  @override
  String get modAlreadyFitted => '已装配';

  @override
  String get modWrongRack => '不适合此槽位';

  @override
  String modsSpilled(int n) {
    return '$n 个模组已回到仓库';
  }

  @override
  String get hullLocked => '未解锁';

  @override
  String hullUnlockBoss(int n) {
    return '击败战役首领 $n';
  }

  @override
  String get hullUnlockFinish => '完成战役或到达第 30 区';

  @override
  String get statAgility => '机动';

  @override
  String get statHitbox => '判定';

  @override
  String get perkNone => '标准机体';

  @override
  String get perkAfterimage => '静止：射击 ×1.5';

  @override
  String get perkBulwark => '穿过护盾的伤害减半';

  @override
  String get perkOverclock => '可发射至 130% 容量的武器，速度较慢';

  @override
  String get perkBattery => '一架免费无人机随行';

  @override
  String get rewardTitle => '奖励';

  @override
  String newHull(String name) {
    return '新船体：$name';
  }

  @override
  String get socketEmpty => '空';

  @override
  String fxStreams(int n) {
    return '$n 道平行弹流';
  }

  @override
  String fxFan(int n) {
    return '$n 发扇形弹';
  }

  @override
  String fxSalvo(int n) {
    return '$n 连发';
  }

  @override
  String fxFireRate(String x) {
    return '射速 ×$x';
  }

  @override
  String fxDamage(String x) {
    return '伤害 ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return '弹速 ×$x';
  }

  @override
  String fxShotSize(String x) {
    return '弹体大小 ×$x';
  }

  @override
  String fxPower(String x) {
    return '耗能 ×$x';
  }

  @override
  String fxHoming(int n) {
    return '追踪 +$n';
  }

  @override
  String fxPierce(int n) {
    return '穿透 $n 个目标';
  }

  @override
  String get fxPierceAll => '穿透一切';

  @override
  String fxCrit(int pct, String x) {
    return '$pct% 概率造成 ×$x 伤害';
  }

  @override
  String fxBossCrit(String x) {
    return '对首领暴击 ×$x';
  }

  @override
  String fxFork(int n) {
    return '击杀时散射 $n 发';
  }

  @override
  String get fxChain => '散射弹再次散射';

  @override
  String get fxSplit => '命中时一分为二';

  @override
  String get fxFrost => '命中使敌人减速';

  @override
  String get fxCrossfire => '侧翼武器瞄向中央';

  @override
  String get fxRearguard => '侧翼武器也向后射击';

  @override
  String get fxOrbit => '子弹蛇行';

  @override
  String fxBounce(int n) {
    return '在墙壁反弹 $n 次';
  }

  @override
  String get fxBounceTop => '…以及顶部';

  @override
  String get fxOverdrive => '能量透支也能射击';

  @override
  String get fxReactor => '超出容量的武器也能缓慢射击';

  @override
  String fxGenPower(String x) {
    return '发电机充能 ×$x';
  }

  @override
  String fxGenMax(String x) {
    return '发电机容量 ×$x';
  }

  @override
  String get fxSurge => '发电机满载：射击 ×2';

  @override
  String fxSiphon(int pct) {
    return '击杀回复 $pct% 能量';
  }

  @override
  String fxHp(String x) {
    return '船体 ×$x';
  }

  @override
  String fxShield(String x) {
    return '护盾 ×$x';
  }

  @override
  String fxRegen(String x) {
    return '护盾回复 ×$x';
  }

  @override
  String fxLeech(int n) {
    return '击杀回复 $n 生命';
  }

  @override
  String get fxMagnet => '吸引道具';

  @override
  String get fxMagnetAll => '吸引所有道具';

  @override
  String fxReflect(int pct) {
    return '护盾反弹 $pct% 的子弹';
  }

  @override
  String get fxReflectGuided => '反弹弹追踪目标';

  @override
  String fxGhost(String sec) {
    return '船体受击后无敌 $sec 秒';
  }

  @override
  String get fxNova => '护盾破碎：全屏爆炸';

  @override
  String fxAgility(String x) {
    return '机动 ×$x';
  }

  @override
  String fxHitbox(String x) {
    return '判定范围 ×$x';
  }

  @override
  String fxCredits(String x) {
    return '积分 ×$x';
  }

  @override
  String fxScore(String x) {
    return '分数 ×$x';
  }

  @override
  String get fxSatellite => '一架战斗无人机随行';

  @override
  String get fxTimewarp => '船体受击时时间变慢';

  @override
  String get fxGambler => '每发都是随机武器';

  @override
  String get vaultAll => '全部';

  @override
  String get sigilMissUnknown => '未知图形';

  @override
  String get sigilMissTooSlow => '太慢了';

  @override
  String get sigilMissSkippedDot => '漏了一个点';

  @override
  String get sigilMissLeftRimEarly => '松开太早';

  @override
  String get sigilMissWrongDirection => '画反了';

  @override
  String get sigilMissWrongLayer => '肩键按错';

  @override
  String get sigilDry => '能量不足';

  @override
  String get sigilBusy => '上一个仍在进行';
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

  @override
  String objBossUnder(int seconds) {
    return '在首領核心出現後 $seconds 秒內摧毀它';
  }

  @override
  String get sectionHangar => '機庫';

  @override
  String get sectionVault => '倉庫';

  @override
  String get rackSide => '側翼';

  @override
  String get rackHull => '船體';

  @override
  String get rarityCommon => '普通';

  @override
  String get rarityRare => '稀有';

  @override
  String get rarityMythic => '神話';

  @override
  String get curse => '詛咒';

  @override
  String get modFit => '裝配';

  @override
  String get modUnfit => '卸下';

  @override
  String get modForge => '鍛造';

  @override
  String get forgeHint => '選 3 個同稀有度的模組鍛造 1 個更高級的';

  @override
  String get vaultEmpty => '還沒有模組。滿星通關節點、快速擊敗首領，或在無盡模式擊落首領。';

  @override
  String modNeeds(String families) {
    return '適用於 $families';
  }

  @override
  String get modRackFull => '槽位已滿';

  @override
  String get modAlreadyFitted => '已裝配';

  @override
  String get modWrongRack => '不適合此槽位';

  @override
  String modsSpilled(int n) {
    return '$n 個模組已回到倉庫';
  }

  @override
  String get hullLocked => '未解鎖';

  @override
  String hullUnlockBoss(int n) {
    return '擊敗戰役首領 $n';
  }

  @override
  String get hullUnlockFinish => '完成戰役或到達第 30 區';

  @override
  String get statAgility => '機動';

  @override
  String get statHitbox => '判定';

  @override
  String get perkNone => '標準機體';

  @override
  String get perkAfterimage => '靜止：射擊 ×1.5';

  @override
  String get perkBulwark => '穿過護盾的傷害減半';

  @override
  String get perkOverclock => '可發射至 130% 容量的武器，速度較慢';

  @override
  String get perkBattery => '一架免費無人機隨行';

  @override
  String get rewardTitle => '獎勵';

  @override
  String newHull(String name) {
    return '新船體：$name';
  }

  @override
  String get socketEmpty => '空';

  @override
  String fxStreams(int n) {
    return '$n 道平行彈流';
  }

  @override
  String fxFan(int n) {
    return '$n 發扇形彈';
  }

  @override
  String fxSalvo(int n) {
    return '$n 連發';
  }

  @override
  String fxFireRate(String x) {
    return '射速 ×$x';
  }

  @override
  String fxDamage(String x) {
    return '傷害 ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return '彈速 ×$x';
  }

  @override
  String fxShotSize(String x) {
    return '彈體大小 ×$x';
  }

  @override
  String fxPower(String x) {
    return '耗能 ×$x';
  }

  @override
  String fxHoming(int n) {
    return '追蹤 +$n';
  }

  @override
  String fxPierce(int n) {
    return '穿透 $n 個目標';
  }

  @override
  String get fxPierceAll => '穿透一切';

  @override
  String fxCrit(int pct, String x) {
    return '$pct% 機率造成 ×$x 傷害';
  }

  @override
  String fxBossCrit(String x) {
    return '對首領暴擊 ×$x';
  }

  @override
  String fxFork(int n) {
    return '擊殺時散射 $n 發';
  }

  @override
  String get fxChain => '散射彈再次散射';

  @override
  String get fxSplit => '命中時一分為二';

  @override
  String get fxFrost => '命中使敵人減速';

  @override
  String get fxCrossfire => '側翼武器瞄向中央';

  @override
  String get fxRearguard => '側翼武器也向後射擊';

  @override
  String get fxOrbit => '子彈蛇行';

  @override
  String fxBounce(int n) {
    return '在牆壁反彈 $n 次';
  }

  @override
  String get fxBounceTop => '…以及頂部';

  @override
  String get fxOverdrive => '能量透支也能射擊';

  @override
  String get fxReactor => '超出容量的武器也能緩慢射擊';

  @override
  String fxGenPower(String x) {
    return '發電機充能 ×$x';
  }

  @override
  String fxGenMax(String x) {
    return '發電機容量 ×$x';
  }

  @override
  String get fxSurge => '發電機滿載：射擊 ×2';

  @override
  String fxSiphon(int pct) {
    return '擊殺回復 $pct% 能量';
  }

  @override
  String fxHp(String x) {
    return '船體 ×$x';
  }

  @override
  String fxShield(String x) {
    return '護盾 ×$x';
  }

  @override
  String fxRegen(String x) {
    return '護盾回復 ×$x';
  }

  @override
  String fxLeech(int n) {
    return '擊殺回復 $n 生命';
  }

  @override
  String get fxMagnet => '吸引道具';

  @override
  String get fxMagnetAll => '吸引所有道具';

  @override
  String fxReflect(int pct) {
    return '護盾反彈 $pct% 的子彈';
  }

  @override
  String get fxReflectGuided => '反彈彈追蹤目標';

  @override
  String fxGhost(String sec) {
    return '船體受擊後無敵 $sec 秒';
  }

  @override
  String get fxNova => '護盾破碎：全螢幕爆炸';

  @override
  String fxAgility(String x) {
    return '機動 ×$x';
  }

  @override
  String fxHitbox(String x) {
    return '判定範圍 ×$x';
  }

  @override
  String fxCredits(String x) {
    return '點數 ×$x';
  }

  @override
  String fxScore(String x) {
    return '分數 ×$x';
  }

  @override
  String get fxSatellite => '一架戰鬥無人機隨行';

  @override
  String get fxTimewarp => '船體受擊時時間變慢';

  @override
  String get fxGambler => '每發都是隨機武器';

  @override
  String get vaultAll => '全部';

  @override
  String get sigilMissUnknown => '未知圖形';

  @override
  String get sigilMissTooSlow => '太慢了';

  @override
  String get sigilMissSkippedDot => '漏了一個點';

  @override
  String get sigilMissLeftRimEarly => '放開太早';

  @override
  String get sigilMissWrongDirection => '畫反了';

  @override
  String get sigilMissWrongLayer => '肩鍵按錯';

  @override
  String get sigilDry => '能量不足';

  @override
  String get sigilBusy => '上一個仍在進行';
}
