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
  String get sectionOutfitting => '装備';

  @override
  String get sectionShop => 'ショップ';

  @override
  String get tabFront => '前方';

  @override
  String get tabSide => 'サイド';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get noWeaponInstalled => '武器未装備';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return '攻撃:$damage 速度:$speed';
  }

  @override
  String statPower(int power) {
    return 'EN:$power';
  }

  @override
  String get beam => 'ビーム';

  @override
  String get guided => '誘導';

  @override
  String get owned => '所持';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => '強化';

  @override
  String get upgradeShort => '強化';

  @override
  String get sell => '売却';

  @override
  String get buy => '購入';

  @override
  String get noCredits => 'クレジット不足';

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
  String get generator => 'ジェネレーター';

  @override
  String genOutput(String value) {
    return 'EN: +$value/fr';
  }

  @override
  String genCapacity(int value) {
    return '容量: $value';
  }

  @override
  String get startMission => 'ミッション開始';

  @override
  String get continueMission => 'ミッション続行';

  @override
  String get padControlsHint =>
      '[B] 購入/強化   [X/Y] 売却   [LB/RB] タブ   [OPTIONS] ミッション続行';

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
}
