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

  @override
  String get arena => '竞技场';

  @override
  String get arenaBossParts => '首领部件';

  @override
  String get arenaBareCore => '仅核心';

  @override
  String get arenaCompanions => '僚机';

  @override
  String get arenaCharge => '能量';

  @override
  String get arenaChargeNormal => '正常';

  @override
  String get arenaSpeed => '世界速度';

  @override
  String get arenaDrill => '练习';

  @override
  String get arenaFreePlay => '自由';

  @override
  String get arenaFight => '开战';

  @override
  String get arenaNewBoss => '新首领';

  @override
  String get arenaLeave => '离开竞技场';

  @override
  String get arenaHint => '首领一倒下就会重生。这里不会保存任何进度。';

  @override
  String get arenaColCast => '成功';

  @override
  String get arenaColMiss => '失败';

  @override
  String get arenaColAvg => '平均';

  @override
  String get arenaColBest => '最佳';

  @override
  String get arenaColTime => '最快';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return '首领 $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => '手柄：符印';

  @override
  String get padSchemeClassic => '手柄：经典';

  @override
  String get padSouthpawOn => '左手模式：开';

  @override
  String get padSouthpawOff => '左手模式：关';

  @override
  String get sigilDescHop => '朝摇杆拨动方向快速小跳';

  @override
  String get sigilDescSidestep => '横穿战场的长距离侧移';

  @override
  String get sigilDescStrike => '带三发重弹向前突进，再退回';

  @override
  String get sigilDescRetreat => '后撤，同时向前打出掩护火力';

  @override
  String get sigilDescDash => '斜向冲刺穿过弹幕，途中无敌';

  @override
  String get sigilDescRoll => '向侧面桶滚，无敌';

  @override
  String get sigilDescShadow => '锁定在最近敌人下方持续射击';

  @override
  String get sigilDescEcho => '影子以半伤重放你最近两秒的动作';

  @override
  String get sigilDescLoop => '从上方翻筋斗：子弹从你下方穿过';

  @override
  String get sigilDescSlalom => '以扇形火力 S 形横穿战场';

  @override
  String get sigilDescCorkscrew => '螺旋前进并向四周开火，无敌';

  @override
  String get sigilDescSnapshot => '朝摇杆拨动方向发射一发重弹';

  @override
  String get sigilDescBroadside => '从两侧齐射一轮';

  @override
  String get sigilDescVolley => '向前发射五道充能光束';

  @override
  String get sigilDescCaltrop => '布下一枚会吞噬子弹并爆炸的地雷';

  @override
  String get sigilDescFrenzy => '武器在几秒内射速加快';

  @override
  String get sigilDescStasis => '敌人和敌弹降为半速';

  @override
  String get sigilDescHalo => '护盾回复速度提升四倍，任何攻击都无法穿透';

  @override
  String get sigilDescRadial => '十六发子弹组成的圆环';

  @override
  String get sigilDescStorm => '所有武器免费全力开火';

  @override
  String get sigilDescPing => '僚机朝拨动方向集中火力';

  @override
  String get sigilDescWingman => '召唤一架护航机到你画向的一侧';

  @override
  String get sigilDescHunter => '召唤一架飞在前方并挑选目标的猎手';

  @override
  String get sigilDescWarden => '召唤一架替你挡下子弹的守卫';

  @override
  String get sigilDescFormation => '僚机在宽阵与楔形阵之间切换';

  @override
  String get sigilDescWhirl => '僚机环绕你并吞噬子弹';

  @override
  String get sigilDescSacrifice => '僚机俯冲自爆，返还能量';

  @override
  String get grimoire => '魔典';

  @override
  String get grimoireHint => '用右摇杆绘制。按住 LB 为 ARMS，RB 为 WING，同时按住为 MEGA BLAST。';

  @override
  String sigilCost(int cost) {
    return '消耗 $cost';
  }

  @override
  String get sigilUntouchable => '无敌';

  @override
  String get lessonWatch => '观看';

  @override
  String get lessonTrace => '描摹';

  @override
  String get lessonSlow => '慢速';

  @override
  String get lessonLive => '全速';

  @override
  String get lessonStreak => '连续五次';

  @override
  String get lessonLearned => '已掌握';

  @override
  String lessonTempo(int pct) {
    return '节奏 $pct %';
  }

  @override
  String get hintHop => '轻弹右摇杆';

  @override
  String get hintLoop => '画一个圆：从弹幕上方飞过';

  @override
  String get hintStream => '按住 LT：两道或三道弹流';

  @override
  String get arenaKata => '套路';

  @override
  String get arenaKataOff => '无';

  @override
  String kataNext(String sigil, String secs) {
    return '下一个 $sigil，$secs 秒后';
  }

  @override
  String get arenaGauntlet => '连战';

  @override
  String get arenaOn => '开';

  @override
  String get arenaOff => '关';

  @override
  String gauntletRating(int rating, int best) {
    return '评分 $rating · 最佳 $best';
  }

  @override
  String get duelWarning => '警告';

  @override
  String get duelHintPad1 => '右摇杆瞄准并射击';

  @override
  String get duelHintPad2Rt => '按住 RT、LB 或 RB：右摇杆绘制符印';

  @override
  String get duelHintPad2Lt => '按住 LT、LB 或 RB：右摇杆绘制符印';

  @override
  String get duelHintClassic => '左摇杆飞行 · B、RB 或 RT 朝机头方向射击';

  @override
  String get duelHintKeys1 => '方向键瞄准并射击 · WASD 飞行';

  @override
  String get duelHintKeys2 => '空格朝机头方向射击 · 数字小键盘绘制符印';

  @override
  String get arenaDuelBinding => '决斗架势';

  @override
  String get duelBindingRt => 'RT + 摇杆';

  @override
  String get duelBindingLt => 'LT + 摇杆';

  @override
  String get arenaDuelFrame => '手柄上的前方';

  @override
  String get duelFrameNose => '机头';

  @override
  String get duelFrameUp => '上方';

  @override
  String get arenaDuelAimFires => '瞄准即射击';

  @override
  String get duelCutInFirst => '首领特写：仅首次';

  @override
  String get duelCutInAlways => '首领特写：每次';

  @override
  String get duelCutInNever => '首领特写：从不';

  @override
  String get arenaDuelDrill => '决斗训练';

  @override
  String get duelDrillOff => '无';

  @override
  String get duelDrillAim => '瞄准射击';

  @override
  String get duelDrillAimHow => '把右摇杆对准首领并命中它';

  @override
  String get duelDrillHold => '锁定机头';

  @override
  String get duelDrillHoldHow => '按住架势键飞行：机头保持不动';

  @override
  String get duelDrillDraw => '向前绘制';

  @override
  String get duelDrillDrawHow => '在架势中朝首领方向绘制符印';

  @override
  String get duelDrillTurn => '掉头';

  @override
  String get duelDrillTurnHow => '首领在你下方：转动机头并命中它';

  @override
  String get duelDrillDone => '完成';

  @override
  String get swapHint => '用第二根手指点击以切换武器';
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

  @override
  String get arena => '競技場';

  @override
  String get arenaBossParts => '首領部件';

  @override
  String get arenaBareCore => '僅核心';

  @override
  String get arenaCompanions => '僚機';

  @override
  String get arenaCharge => '能量';

  @override
  String get arenaChargeNormal => '正常';

  @override
  String get arenaSpeed => '世界速度';

  @override
  String get arenaDrill => '練習';

  @override
  String get arenaFreePlay => '自由';

  @override
  String get arenaFight => '開戰';

  @override
  String get arenaNewBoss => '新首領';

  @override
  String get arenaLeave => '離開競技場';

  @override
  String get arenaHint => '首領一倒下就會重生。這裡不會儲存任何進度。';

  @override
  String get arenaColCast => '成功';

  @override
  String get arenaColMiss => '失敗';

  @override
  String get arenaColAvg => '平均';

  @override
  String get arenaColBest => '最佳';

  @override
  String get arenaColTime => '最快';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return '首領 $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => '手把：符印';

  @override
  String get padSchemeClassic => '手把：經典';

  @override
  String get padSouthpawOn => '左手模式：開';

  @override
  String get padSouthpawOff => '左手模式：關';

  @override
  String get sigilDescHop => '朝搖桿撥動方向快速小跳';

  @override
  String get sigilDescSidestep => '橫越戰場的長距離側移';

  @override
  String get sigilDescStrike => '帶三發重彈向前突進，再退回';

  @override
  String get sigilDescRetreat => '後撤，同時向前打出掩護火力';

  @override
  String get sigilDescDash => '斜向衝刺穿過彈幕，途中無敵';

  @override
  String get sigilDescRoll => '向側面桶滾，無敵';

  @override
  String get sigilDescShadow => '鎖定在最近敵人下方持續射擊';

  @override
  String get sigilDescEcho => '影子以半傷重放你最近兩秒的動作';

  @override
  String get sigilDescLoop => '從上方翻筋斗：子彈從你下方穿過';

  @override
  String get sigilDescSlalom => '以扇形火力 S 形橫越戰場';

  @override
  String get sigilDescCorkscrew => '螺旋前進並向四周開火，無敵';

  @override
  String get sigilDescSnapshot => '朝搖桿撥動方向發射一發重彈';

  @override
  String get sigilDescBroadside => '從兩側齊射一輪';

  @override
  String get sigilDescVolley => '向前發射五道充能光束';

  @override
  String get sigilDescCaltrop => '布下一枚會吞噬子彈並爆炸的地雷';

  @override
  String get sigilDescFrenzy => '武器在數秒內射速加快';

  @override
  String get sigilDescStasis => '敵人和敵彈降為半速';

  @override
  String get sigilDescHalo => '護盾回復速度提升四倍，任何攻擊都無法穿透';

  @override
  String get sigilDescRadial => '十六發子彈組成的圓環';

  @override
  String get sigilDescStorm => '所有武器免費全力開火';

  @override
  String get sigilDescPing => '僚機朝撥動方向集中火力';

  @override
  String get sigilDescWingman => '召喚一架護航機到你畫向的一側';

  @override
  String get sigilDescHunter => '召喚一架飛在前方並挑選目標的獵手';

  @override
  String get sigilDescWarden => '召喚一架替你擋下子彈的守衛';

  @override
  String get sigilDescFormation => '僚機在寬陣與楔形陣之間切換';

  @override
  String get sigilDescWhirl => '僚機環繞你並吞噬子彈';

  @override
  String get sigilDescSacrifice => '僚機俯衝自爆，返還能量';

  @override
  String get grimoire => '魔典';

  @override
  String get grimoireHint => '用右搖桿繪製。按住 LB 為 ARMS，RB 為 WING，同時按住為 MEGA BLAST。';

  @override
  String sigilCost(int cost) {
    return '消耗 $cost';
  }

  @override
  String get sigilUntouchable => '無敵';

  @override
  String get lessonWatch => '觀看';

  @override
  String get lessonTrace => '描摹';

  @override
  String get lessonSlow => '慢速';

  @override
  String get lessonLive => '全速';

  @override
  String get lessonStreak => '連續五次';

  @override
  String get lessonLearned => '已掌握';

  @override
  String lessonTempo(int pct) {
    return '節奏 $pct %';
  }

  @override
  String get hintHop => '輕彈右搖桿';

  @override
  String get hintLoop => '畫一個圓：從彈幕上方飛過';

  @override
  String get hintStream => '按住 LT：兩道或三道彈流';

  @override
  String get arenaKata => '套路';

  @override
  String get arenaKataOff => '無';

  @override
  String kataNext(String sigil, String secs) {
    return '下一個 $sigil，$secs 秒後';
  }

  @override
  String get arenaGauntlet => '連戰';

  @override
  String get arenaOn => '開';

  @override
  String get arenaOff => '關';

  @override
  String gauntletRating(int rating, int best) {
    return '評分 $rating · 最佳 $best';
  }

  @override
  String get duelWarning => '警告';

  @override
  String get duelHintPad1 => '右搖桿瞄準並射擊';

  @override
  String get duelHintPad2Rt => '按住 RT、LB 或 RB：右搖桿繪製符印';

  @override
  String get duelHintPad2Lt => '按住 LT、LB 或 RB：右搖桿繪製符印';

  @override
  String get duelHintClassic => '左搖桿飛行 · B、RB 或 RT 朝機頭方向射擊';

  @override
  String get duelHintKeys1 => '方向鍵瞄準並射擊 · WASD 飛行';

  @override
  String get duelHintKeys2 => '空白鍵朝機頭方向射擊 · 數字鍵盤繪製符印';

  @override
  String get arenaDuelBinding => '決鬥架勢';

  @override
  String get duelBindingRt => 'RT + 搖桿';

  @override
  String get duelBindingLt => 'LT + 搖桿';

  @override
  String get arenaDuelFrame => '手把上的前方';

  @override
  String get duelFrameNose => '機頭';

  @override
  String get duelFrameUp => '上方';

  @override
  String get arenaDuelAimFires => '瞄準即射擊';

  @override
  String get duelCutInFirst => '首領特寫：僅首次';

  @override
  String get duelCutInAlways => '首領特寫：每次';

  @override
  String get duelCutInNever => '首領特寫：從不';

  @override
  String get arenaDuelDrill => '決鬥訓練';

  @override
  String get duelDrillOff => '無';

  @override
  String get duelDrillAim => '瞄準射擊';

  @override
  String get duelDrillAimHow => '把右搖桿對準首領並命中它';

  @override
  String get duelDrillHold => '鎖定機頭';

  @override
  String get duelDrillHoldHow => '按住架勢鍵飛行：機頭保持不動';

  @override
  String get duelDrillDraw => '向前繪製';

  @override
  String get duelDrillDrawHow => '在架勢中朝首領方向繪製符印';

  @override
  String get duelDrillTurn => '迴轉';

  @override
  String get duelDrillTurnHow => '首領在你下方：轉動機頭並命中它';

  @override
  String get duelDrillDone => '完成';

  @override
  String get swapHint => '用第二根手指點擊以切換武器';
}
