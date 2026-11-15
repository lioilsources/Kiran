// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get cancel => 'キャンセル';

  @override
  String get connect => '接続';

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
  String get statsOn => '統計: オン';

  @override
  String get statsOff => '統計: オフ';

  @override
  String get quitToDesktop => 'デスクトップに戻る';

  @override
  String get selectSkin => 'スキン選択';

  @override
  String get quit => '終了';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get locked => 'ロック中';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SH';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

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
  String get startMission => 'ミッション開始';

  @override
  String get continueMission => 'ミッション続行';

  @override
  String get padControlsHint =>
      '[↑↓] 行   [←→] 選択   [B] 購入/強化/切替   [X/Y] 売却   [OPTIONS] 続行';

  @override
  String get host => 'ホスト';

  @override
  String get connectToHost => 'ホストに接続';

  @override
  String hostingAt(String ip) {
    return 'ホスト中  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
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
  String get swapHint => '2本指で触れている間は2つ目の武器セットで撃てる';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv：攻撃力アップ';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP：船体を修理';
  }

  @override
  String pickupShield(int amount) {
    return 'シールド +$amount、回復が速くなる';
  }

  @override
  String get pickupGenerator => 'ジェネレーター強化：武器のエネルギーが増える';

  @override
  String pickupCredits(String amount) {
    return '+$amount クレジット、ComCenterで使える';
  }

  @override
  String nodeLevel(int level) {
    return 'レベル $level';
  }

  @override
  String get tutPickupWeapon => '武器アイテムで武器レベルが上がります：威力と連射速度アップ';

  @override
  String get tutPickupHealth => '修理アイテムで船体を回復。満タン時は最大HPが上がります';

  @override
  String get tutPickupShield => 'シールドは船体より先に被弾を受け止め、自動で回復します';

  @override
  String get tutPickupGenerator => 'ジェネレーターは武器の電源です。出力が高いほど多くの武器を撃てます';

  @override
  String get tutPickupCredits => 'クレジットでラウンド間にComCenterで武器や強化を購入できます';

  @override
  String get tutBoss => 'ボス出現！上のバーが体力です。動き続け、撃ち続けましょう';

  @override
  String get tutLowHp => '船体が危険！修理アイテムかComCenterで回復しましょう';

  @override
  String get tutGenStarved => '武器の消費電力がジェネレーターを超えています：強化しましょう';

  @override
  String get tutCanAfford => '強化を購入できます：このラウンド後にComCenterへ';

  @override
  String get tutFly => 'ドラッグで移動。指を置いている間、武器が発射されます';

  @override
  String get introCollect => '敵が落とすアイコンを回収しましょう';

  @override
  String get introShop => 'ラウンドの合間にComCenterでクレジットを使いましょう';

  @override
  String get objBoss => '目標：敵の波を生き延び、ボスを倒す';

  @override
  String get objSurvive => '目標：敵の波を生き延びる';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits クレジット · 撃墜 $kills';
  }

  @override
  String roundBestWeapon(String weapon) {
    return '最優秀武器：$weapon';
  }

  @override
  String get deathBoss => 'ボスの攻撃は強力です。シールドを強化すれば時間を稼げます';

  @override
  String get deathShield => 'ComCenterでシールドを強化：船体より先に被弾を受け止めます';

  @override
  String get deathGuns => '強い武器なら、敵の波がダメージを与える前に一掃できます';
}
