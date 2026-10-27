// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get connect => '接続';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName に接続できませんでした';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ホストは見つかりましたが、接続を確立できませんでした。\n\n近くの端末とのプレイにはピアツーピアWi-Fiが必要ですが、インターネット共有がオンの間はiOSがこれをオフにします。両方の端末でインターネット共有をオフにして再試行するか、両方を同じWi-Fiに接続してください。';

  @override
  String get gameOverCampaign => 'ミッション失敗 — 装備とクレジットは保持されます。司令センターから再挑戦しましょう。';

  @override
  String get gameOverEndless => 'セクター1で再建中 — 装備とクレジットは保持されます';

  @override
  String get waitingForHost => 'ホストを待っています...';

  @override
  String get waitingForHostHint => 'ホストの準備ができるとゲームが始まります';

  @override
  String get vesselLost => '機体喪失';

  @override
  String scoreValue(String score) {
    return 'スコア: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'クレジット: $credits';
  }

  @override
  String get creditsPrefix => 'クレジット: ';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get achievements => '実績';

  @override
  String get redeploy => '再出撃';

  @override
  String get resume => '再開';

  @override
  String get pause => '一時停止';

  @override
  String get paused => '一時停止中';

  @override
  String get skins => 'スキン';

  @override
  String get skin => 'スキン';

  @override
  String get soundOn => '効果音: オン';

  @override
  String get soundOff => '効果音: オフ';

  @override
  String get musicOn => '音楽: オン';

  @override
  String get musicOff => '音楽: オフ';

  @override
  String get mainMenu => 'メインメニュー';

  @override
  String get quitToDesktop => 'デスクトップに戻る';

  @override
  String get selectSkin => 'スキン選択';

  @override
  String get difficulty => '難易度';

  @override
  String get difficultyEasy => 'イージー';

  @override
  String get difficultyNormal => 'ノーマル';

  @override
  String get difficultyHard => 'ハード';

  @override
  String get difficultyLord => 'ロード';

  @override
  String get campaign => 'キャンペーン';

  @override
  String get quit => '終了';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get locked => 'ロック中';

  @override
  String get mainMenuTooltip => 'メインメニュー';

  @override
  String nodeLevel(int level) {
    return 'レベル $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'レベル $level · ボス $ordinal';
  }

  @override
  String get nodeLockedHint => 'ロック中。先に前のミッションをクリアしてください。';

  @override
  String get flyAgain => 'もう一度出撃';

  @override
  String get launch => '出撃';

  @override
  String zoneLabel(int zone) {
    return 'ゾーン $zone';
  }

  @override
  String get objectiveStar => 'スター';

  @override
  String get continueButton => '次へ';

  @override
  String get replayNode => 'リプレイ';

  @override
  String get retry => 'リトライ';

  @override
  String get nodeCleared => 'ミッションクリア';

  @override
  String get nodeFailed => 'ミッション失敗';

  @override
  String get weaponTierUnlocked => '新たな武器ランク解放';

  @override
  String get onSaleInComCenter => '司令センターで販売中。';

  @override
  String get requiredTasksHint =>
      'ミッションの成否は必須目標で決まります。もう一度飛びましょう — 獲得したものは失われません。';

  @override
  String get objClear => 'セクターを制圧する';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '敵を$count機撃墜する',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => '機体にダメージを受けない';

  @override
  String objHull(int percent) {
    return '機体耐久$percent%以上でクリア';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weaponで$count機撃破する',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'サイド武器で$count機撃破する',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weaponを前方に装備して出撃';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weaponをサイドに装備して出撃';
  }

  @override
  String get objBuySideGun => '司令センターでサイド武器を購入する';

  @override
  String objUpgradeGenerator(int level) {
    return 'ジェネレーターをレベル$levelに強化する';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return '前方武器をレベル$levelに強化する';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'サイド武器をレベル$levelに強化する';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'アイテムを$count個回収する',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '編隊を$countつ全滅させる',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => '小惑星に体当たりしない';

  @override
  String objUnderTime(int seconds) {
    return '$seconds秒以内にクリア';
  }

  @override
  String get objStripBoss => 'コアより先にボスのパーツをすべて破壊する';

  @override
  String get joinCoopTitle => '協力プレイに参加';

  @override
  String get cannotSearchNetwork => 'このネットワークでは検索できません';

  @override
  String get joinHintNearby =>
      '同じWi-Fiならどの端末でも遊べます。iPhone、iPad、MacはWi-Fiがなくても近くの端末を見つけられます(両方でインターネット共有をオフにしてください)。';

  @override
  String get joinHintWifi => '両プレイヤーが同じWi-Fiに接続している必要があります。インターネット共有でも構いません。';

  @override
  String noHostsYet(String hint) {
    return 'ホストが見つかりません。$hint';
  }

  @override
  String get lookingForHosts => 'このWi-Fiと近くのホストを探しています…';

  @override
  String get hostNearby => '近く · Bluetooth / ピアツーピアWi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · 同じWi-Fi';
  }

  @override
  String get enterIpManually => 'IPを手動で入力';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SH';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — シールド中';
  }

  @override
  String get bossPartTurret => '砲台';

  @override
  String get bossPartShieldPod => 'シールドポッド';

  @override
  String get bossPartThruster => 'スラスター';

  @override
  String get bossPartCannon => 'キャノン';

  @override
  String sectorUnknownSpace(int level) {
    return 'セクター$level — 未知の宙域';
  }

  @override
  String get player2Joined => 'プレイヤー2が参加しました!';

  @override
  String get player2Disconnected => 'プレイヤー2が切断されました';

  @override
  String get hostDisconnected => 'ホストが切断されました';

  @override
  String maxLevelSold(String amount) {
    return '最大レベル!\$$amountで売却';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return '武器レベル$tier解放';
  }

  @override
  String get cheatsEnabled => 'チート有効';

  @override
  String get cheatsDisabled => 'チート無効';

  @override
  String get cheatsMaxed => 'チート: クレジット最大、全武器解放';

  @override
  String get cheats => 'チート';

  @override
  String get maxCredits => 'クレジット最大';

  @override
  String get sectionStats => 'ステータス';

  @override
  String get sectionLoadout => '装備中';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => '強化';

  @override
  String get sell => '売却';

  @override
  String get buy => '購入';

  @override
  String get commandCenter => '司令センター';

  @override
  String get pilot => 'パイロット';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'スコア';

  @override
  String get nextWeapon => '次の武器まで';

  @override
  String pointsValue(String points) {
    return '$points pt';
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
  String get power => 'EN';

  @override
  String get launchMission => 'ミッション開始';

  @override
  String get startMission => 'ミッション開始';

  @override
  String get continueMission => 'ミッション続行';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 選択   [B] 購入/強化/切替   [X/Y] 売却   [OPTIONS] 続行';

  @override
  String get host => 'ホスト';

  @override
  String hostingAs(String name) {
    return 'ホスト中: $name';
  }

  @override
  String get join => '参加';

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
  String get overload => '過負荷';

  @override
  String weaponOff(String weapon) {
    return '$weapon 停止 — ジェネレーター出力不足';
  }

  @override
  String unlocksAt(String points) {
    return '$points ptで解放';
  }

  @override
  String joinConnecting(String target) {
    return '$target に接続中…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ホストから応答がありません：$reason。\n\n両方のプレイヤーが同じWi-Fi（インターネット共有も可）に接続し、ホストがHOSTを押している必要があります。アドレスを確認して、もう一度お試しください。';
  }

  @override
  String get lanJoinNoAnswer => '応答なし';
}
