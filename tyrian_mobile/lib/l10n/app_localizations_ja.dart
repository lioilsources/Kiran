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

  @override
  String objBossUnder(int seconds) {
    return 'ボスのコアを出現から$seconds秒以内に破壊する';
  }

  @override
  String get sectionHangar => '格納庫';

  @override
  String get sectionVault => '保管庫';

  @override
  String get rackSide => 'サイド';

  @override
  String get rackHull => '船体';

  @override
  String get rarityCommon => 'コモン';

  @override
  String get rarityRare => 'レア';

  @override
  String get rarityMythic => 'ミシック';

  @override
  String get curse => '呪い';

  @override
  String get modFit => '装着';

  @override
  String get modUnfit => '外す';

  @override
  String get modForge => '鍛造';

  @override
  String get forgeHint => '同じレア度を3つ選んで上位を1つ鍛造';

  @override
  String get vaultEmpty =>
      'まだMODがありません。ノードを星すべてでクリアするか、ボスを素早く倒すか、エンドレスのボスを撃墜しよう。';

  @override
  String modNeeds(String families) {
    return '$familiesで有効';
  }

  @override
  String get modRackFull => 'ラックが満杯';

  @override
  String get modAlreadyFitted => '装着済み';

  @override
  String get modWrongRack => 'このラックには付かない';

  @override
  String modsSpilled(int n) {
    return '$n個のMODを保管庫に戻した';
  }

  @override
  String get hullLocked => 'ロック中';

  @override
  String hullUnlockBoss(int n) {
    return 'キャンペーンのボス$nを倒す';
  }

  @override
  String get hullUnlockFinish => 'キャンペーンをクリアするかセクター30に到達';

  @override
  String get statAgility => '機動';

  @override
  String get statHitbox => '被弾';

  @override
  String get perkNone => '標準機';

  @override
  String get perkAfterimage => '静止中: ショット×1.5';

  @override
  String get perkBulwark => 'シールドを越えたダメージ半減';

  @override
  String get perkOverclock => '容量130%までの武器も撃てる(遅め)';

  @override
  String get perkBattery => '無料のドローンが随伴';

  @override
  String get rewardTitle => '報酬';

  @override
  String newHull(String name) {
    return '新しい船体: $name';
  }

  @override
  String get socketEmpty => '空き';

  @override
  String fxStreams(int n) {
    return '$n本の平行ショット';
  }

  @override
  String fxFan(int n) {
    return '$n発の扇状ショット';
  }

  @override
  String fxSalvo(int n) {
    return '$n連射';
  }

  @override
  String fxFireRate(String x) {
    return '連射速度×$x';
  }

  @override
  String fxDamage(String x) {
    return 'ダメージ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return '弾速×$x';
  }

  @override
  String fxShotSize(String x) {
    return '弾サイズ×$x';
  }

  @override
  String fxPower(String x) {
    return '消費電力×$x';
  }

  @override
  String fxHoming(int n) {
    return '誘導+$n';
  }

  @override
  String fxPierce(int n) {
    return '$n体を貫通';
  }

  @override
  String get fxPierceAll => 'すべて貫通';

  @override
  String fxCrit(int pct, String x) {
    return '$pct%の確率でダメージ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'ボスへのクリティカル×$x';
  }

  @override
  String fxFork(int n) {
    return '撃破時に$n発を拡散';
  }

  @override
  String get fxChain => '拡散弾がさらに拡散';

  @override
  String get fxSplit => '命中で2つに分裂';

  @override
  String get fxFrost => '命中で敵を減速';

  @override
  String get fxCrossfire => 'サイド武器が中央を狙う';

  @override
  String get fxRearguard => 'サイド武器が後方にも撃つ';

  @override
  String get fxOrbit => '弾がうねる';

  @override
  String fxBounce(int n) {
    return '壁で$n回跳ね返る';
  }

  @override
  String get fxBounceTop => '…上端でも';

  @override
  String get fxOverdrive => '電力の前借りでも撃つ';

  @override
  String get fxReactor => '容量オーバーの武器もゆっくり撃てる';

  @override
  String fxGenPower(String x) {
    return 'ジェネレーター充電×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ジェネレーター容量×$x';
  }

  @override
  String get fxSurge => '満充電: ショット×2';

  @override
  String fxSiphon(int pct) {
    return '撃破で電力$pct%回復';
  }

  @override
  String fxHp(String x) {
    return '船体×$x';
  }

  @override
  String fxShield(String x) {
    return 'シールド×$x';
  }

  @override
  String fxRegen(String x) {
    return 'シールド回復×$x';
  }

  @override
  String fxLeech(int n) {
    return '撃破でHP$n回復';
  }

  @override
  String get fxMagnet => 'アイテムを引き寄せる';

  @override
  String get fxMagnetAll => 'すべてのアイテムを引き寄せる';

  @override
  String fxReflect(int pct) {
    return 'シールドに当たった弾の$pct%を跳ね返す';
  }

  @override
  String get fxReflectGuided => '反射弾が誘導する';

  @override
  String fxGhost(String sec) {
    return '船体被弾後$sec秒無敵';
  }

  @override
  String get fxNova => 'シールド破壊で画面全体に爆発';

  @override
  String fxAgility(String x) {
    return '機動力×$x';
  }

  @override
  String fxHitbox(String x) {
    return '当たり判定×$x';
  }

  @override
  String fxCredits(String x) {
    return 'クレジット×$x';
  }

  @override
  String fxScore(String x) {
    return 'スコア×$x';
  }

  @override
  String get fxSatellite => '戦闘ドローンが随伴';

  @override
  String get fxTimewarp => '船体被弾で時間が遅くなる';

  @override
  String get fxGambler => '毎発ランダムな武器';

  @override
  String get vaultAll => 'すべて';

  @override
  String get sigilMissUnknown => '不明な形';

  @override
  String get sigilMissTooSlow => '遅すぎる';

  @override
  String get sigilMissSkippedDot => '点を飛ばした';

  @override
  String get sigilMissLeftRimEarly => '離すのが早すぎた';

  @override
  String get sigilMissWrongDirection => '逆向きに描いた';

  @override
  String get sigilMissWrongLayer => 'ショルダーボタンが違う';

  @override
  String get sigilDry => 'チャージ不足';

  @override
  String get sigilBusy => '前の技が実行中';

  @override
  String get arena => 'アリーナ';

  @override
  String get arenaBossParts => 'ボスのパーツ';

  @override
  String get arenaBareCore => 'コアのみ';

  @override
  String get arenaCompanions => '僚機';

  @override
  String get arenaCharge => 'チャージ';

  @override
  String get arenaChargeNormal => '通常';

  @override
  String get arenaSpeed => '世界の速さ';

  @override
  String get arenaDrill => '練習';

  @override
  String get arenaFreePlay => 'フリー';

  @override
  String get arenaFight => '戦う';

  @override
  String get arenaNewBoss => 'ボスを出し直す';

  @override
  String get arenaLeave => 'アリーナを出る';

  @override
  String get arenaHint => 'ボスは倒すとすぐ復活します。ここでは何も保存されません。';

  @override
  String get arenaColCast => '成功';

  @override
  String get arenaColMiss => '失敗';

  @override
  String get arenaColAvg => '平均';

  @override
  String get arenaColBest => '最高';

  @override
  String get arenaColTime => '最速';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'ボス $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'パッド: シジル';

  @override
  String get padSchemeClassic => 'パッド: クラシック';

  @override
  String get padSouthpawOn => '左利き: オン';

  @override
  String get padSouthpawOff => '左利き: オフ';

  @override
  String get sigilDescHop => '弾いた方向へ素早く跳ぶ';

  @override
  String get sigilDescSidestep => 'フィールドを横切る長い横移動';

  @override
  String get sigilDescStrike => '重いショット3発で前へ突進し、戻る';

  @override
  String get sigilDescRetreat => '援護射撃を前に撃ちつつ後退';

  @override
  String get sigilDescDash => '弾幕を斜めに突っ切るダッシュ、途中は無敵';

  @override
  String get sigilDescRoll => '横へバレルロール、無敵';

  @override
  String get sigilDescShadow => '最寄りの敵の真下に張り付き撃ち続ける';

  @override
  String get sigilDescEcho => '影が直前2秒の動きを半分の威力で再現';

  @override
  String get sigilDescLoop => '上へ宙返り: 弾は下を通り抜ける';

  @override
  String get sigilDescSlalom => '扇状に撃ちながらフィールドをS字に横切る';

  @override
  String get sigilDescCorkscrew => '全方位に撃ちつつきりもみで前進、無敵';

  @override
  String get sigilDescSnapshot => '弾いた方向へ重い一発';

  @override
  String get sigilDescBroadside => '両側面から一斉射撃';

  @override
  String get sigilDescVolley => 'チャージした光線を前方に5本';

  @override
  String get sigilDescCaltrop => '弾を吸い込んで爆発する機雷を置く';

  @override
  String get sigilDescFrenzy => '数秒間、武器の連射が速くなる';

  @override
  String get sigilDescStasis => '敵とその弾が半分の速さになる';

  @override
  String get sigilDescHalo => 'シールド回復が4倍速になり、何も通さない';

  @override
  String get sigilDescRadial => '16発のリング状ショット';

  @override
  String get sigilDescStorm => '全武器がノーコストで全開射撃';

  @override
  String get sigilDescPing => '僚機が弾いた方向へ集中砲火';

  @override
  String get sigilDescWingman => '描いた側の側面にウイングマンを呼ぶ';

  @override
  String get sigilDescHunter => '先行して標的を選ぶハンターを呼ぶ';

  @override
  String get sigilDescWarden => '自分を狙う弾を受け止めるガーディアンを呼ぶ';

  @override
  String get sigilDescFormation => '僚機が横広と楔形の隊形を切り替える';

  @override
  String get sigilDescWhirl => '僚機が周囲を回り弾を吸収する';

  @override
  String get sigilDescSacrifice => '僚機が突撃して自爆し、チャージを返す';

  @override
  String get grimoire => 'グリモア';

  @override
  String get grimoireHint => '右スティックで描く。LB長押しでARMS、RBでWING、両方でMEGA BLAST。';

  @override
  String sigilCost(int cost) {
    return 'コスト $cost';
  }

  @override
  String get sigilUntouchable => '無敵';

  @override
  String get lessonWatch => '見て覚える';

  @override
  String get lessonTrace => 'なぞる';

  @override
  String get lessonSlow => 'ゆっくり';

  @override
  String get lessonLive => '本番';

  @override
  String get lessonStreak => '5回連続';

  @override
  String get lessonLearned => '習得';

  @override
  String lessonTempo(int pct) {
    return 'テンポ $pct %';
  }

  @override
  String get hintHop => '右スティックをはじく';

  @override
  String get hintLoop => '円を描くと弾の上を飛び越える';

  @override
  String get hintStream => 'LTを握る: 弾が2本か3本に';

  @override
  String get arenaKata => '型';

  @override
  String get arenaKataOff => 'なし';

  @override
  String kataNext(String sigil, String secs) {
    return '次は $sigil　あと $secs 秒';
  }

  @override
  String get arenaGauntlet => '連戦';

  @override
  String get arenaOn => 'オン';

  @override
  String get arenaOff => 'オフ';

  @override
  String gauntletRating(int rating, int best) {
    return '評価 $rating · 最高 $best';
  }

  @override
  String get duelWarning => '警告';

  @override
  String get duelHintPad1 => '右スティックで照準と射撃';

  @override
  String get duelHintPad2Rt => 'RT・LB・RBを押しながら右スティックでシジルを描く';

  @override
  String get duelHintPad2Lt => 'LT・LB・RBを押しながら右スティックでシジルを描く';

  @override
  String get duelHintClassic => '左スティックで移動 · B・RB・RTで機首の向きに射撃';

  @override
  String get duelHintKeys1 => '矢印キーで照準と射撃 · WASDで移動';

  @override
  String get duelHintKeys2 => 'スペースで機首の向きに射撃 · テンキーでシジルを描く';

  @override
  String get arenaDuelBinding => '決闘の構え';

  @override
  String get duelBindingRt => 'RT + スティック';

  @override
  String get duelBindingLt => 'LT + スティック';

  @override
  String get arenaDuelFrame => 'パッドの前方';

  @override
  String get duelFrameNose => '機首';

  @override
  String get duelFrameUp => '上';

  @override
  String get arenaDuelAimFires => '照準で射撃';

  @override
  String get duelCutInFirst => 'ボスのクローズアップ：初回のみ';

  @override
  String get duelCutInAlways => 'ボスのクローズアップ：毎回';

  @override
  String get duelCutInNever => 'ボスのクローズアップ：なし';

  @override
  String get arenaDuelDrill => '決闘ドリル';

  @override
  String get duelDrillOff => 'なし';

  @override
  String get duelDrillAim => '狙って撃つ';

  @override
  String get duelDrillAimHow => '右スティックをボスに向けて当てよう';

  @override
  String get duelDrillHold => '機首を保つ';

  @override
  String get duelDrillHoldHow => '構えボタンを押したまま飛ぶと機首は動かない';

  @override
  String get duelDrillDraw => '前方に描く';

  @override
  String get duelDrillDrawHow => '構えたままボスの方向へシジルを描こう';

  @override
  String get duelDrillTurn => '振り返る';

  @override
  String get duelDrillTurnHow => 'ボスは下にいる：機首を回して当てよう';

  @override
  String get duelDrillDone => '完了';

  @override
  String get swapHint => '2本目の指でタップして武器を切り替えよう';
}
