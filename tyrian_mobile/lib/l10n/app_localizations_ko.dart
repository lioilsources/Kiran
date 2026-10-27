// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get connect => '연결';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName에 연결할 수 없습니다';
  }

  @override
  String get nearbyJoinFailedBody =>
      '호스트는 보였지만 연결이 이루어지지 않았습니다.\n\n근거리 플레이에는 P2P Wi-Fi가 필요한데, iOS는 개인용 핫스팟이 켜져 있으면 이를 끕니다. 두 기기 모두 핫스팟을 끄고 다시 시도하거나, 두 기기를 같은 Wi-Fi에 연결하세요.';

  @override
  String get gameOverCampaign => '임무 실패 — 장비와 크레딧은 유지됩니다. 사령부에서 다시 도전하세요.';

  @override
  String get gameOverEndless => '섹터 1에서 재정비 중 — 장비와 크레딧은 유지됩니다';

  @override
  String get waitingForHost => '호스트를 기다리는 중...';

  @override
  String get waitingForHostHint => '호스트가 준비되면 게임이 시작됩니다';

  @override
  String get vesselLost => '기체 손실';

  @override
  String scoreValue(String score) {
    return '점수: $score';
  }

  @override
  String creditsValue(String credits) {
    return '크레딧: $credits';
  }

  @override
  String get creditsPrefix => '크레딧: ';

  @override
  String get leaderboard => '순위표';

  @override
  String get achievements => '업적';

  @override
  String get redeploy => '재출격';

  @override
  String get resume => '계속';

  @override
  String get pause => '일시정지';

  @override
  String get paused => '일시정지됨';

  @override
  String get skins => '스킨';

  @override
  String get skin => '스킨';

  @override
  String get soundOn => '효과음: 켬';

  @override
  String get soundOff => '효과음: 끔';

  @override
  String get musicOn => '음악: 켬';

  @override
  String get musicOff => '음악: 끔';

  @override
  String get mainMenu => '메인 메뉴';

  @override
  String get quitToDesktop => '데스크톱으로 나가기';

  @override
  String get selectSkin => '스킨 선택';

  @override
  String get difficulty => '난이도';

  @override
  String get difficultyEasy => '쉬움';

  @override
  String get difficultyNormal => '보통';

  @override
  String get difficultyHard => '어려움';

  @override
  String get difficultyLord => '로드';

  @override
  String get campaign => '캠페인';

  @override
  String get quit => '종료';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get locked => '잠김';

  @override
  String get mainMenuTooltip => '메인 메뉴';

  @override
  String nodeLevel(int level) {
    return '레벨 $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return '레벨 $level · 보스 $ordinal';
  }

  @override
  String get nodeLockedHint => '잠김. 이전 임무를 먼저 완료하세요.';

  @override
  String get flyAgain => '다시 출격';

  @override
  String get launch => '출격';

  @override
  String zoneLabel(int zone) {
    return '구역 $zone';
  }

  @override
  String get objectiveStar => '별';

  @override
  String get continueButton => '계속';

  @override
  String get replayNode => '임무 다시 하기';

  @override
  String get retry => '재도전';

  @override
  String get nodeCleared => '임무 완료';

  @override
  String get nodeFailed => '임무 실패';

  @override
  String get weaponTierUnlocked => '새 무기 등급 해금';

  @override
  String get onSaleInComCenter => '사령부에서 판매 중.';

  @override
  String get requiredTasksHint =>
      '필수 목표가 임무의 성패를 결정합니다. 다시 출격하세요 — 얻은 것은 그대로 남습니다.';

  @override
  String get objClear => '섹터 소탕';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '적 $count기 격추',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => '선체 피해 없이 완료';

  @override
  String objHull(int percent) {
    return '선체 $percent% 이상으로 완료';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon(으)로 $count기 처치',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '측면 무기로 $count기 처치',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon을(를) 전방에 장착하고 출격';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon을(를) 측면에 장착하고 출격';
  }

  @override
  String get objBuySideGun => '사령부에서 측면 무기 구매';

  @override
  String objUpgradeGenerator(int level) {
    return '발전기를 레벨 $level까지 강화';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return '전방 무기를 레벨 $level까지 강화';
  }

  @override
  String objUpgradeSideGun(int level) {
    return '측면 무기를 레벨 $level까지 강화';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '아이템 $count개 획득',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '편대 $count개 전멸',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => '소행성에 충돌하지 않기';

  @override
  String objUnderTime(int seconds) {
    return '$seconds초 안에 완료';
  }

  @override
  String get objStripBoss => '코어보다 먼저 보스의 모든 부품 파괴';

  @override
  String get joinCoopTitle => '협동 플레이 참가';

  @override
  String get cannotSearchNetwork => '이 네트워크에서는 검색할 수 없습니다';

  @override
  String get joinHintNearby =>
      '같은 Wi-Fi라면 모든 기기에서 됩니다. iPhone, iPad, Mac은 Wi-Fi 없이도 가까이 있으면 서로 찾을 수 있습니다 — 두 기기 모두 개인용 핫스팟을 끈 상태에서.';

  @override
  String get joinHintWifi => '두 플레이어가 같은 Wi-Fi에 있어야 합니다 — 개인용 핫스팟도 됩니다.';

  @override
  String noHostsYet(String hint) {
    return '아직 호스트가 없습니다. $hint';
  }

  @override
  String get lookingForHosts => '이 Wi-Fi와 주변에서 호스트를 찾는 중…';

  @override
  String get hostNearby => '근처 · Bluetooth / P2P Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · 같은 Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP 직접 입력';

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
    return '$name — 보호막';
  }

  @override
  String get bossPartTurret => '포탑';

  @override
  String get bossPartShieldPod => '보호막 포드';

  @override
  String get bossPartThruster => '추진기';

  @override
  String get bossPartCannon => '캐논';

  @override
  String sectorUnknownSpace(int level) {
    return '섹터 $level — 미지의 우주';
  }

  @override
  String get player2Joined => '플레이어 2가 참가했습니다!';

  @override
  String get player2Disconnected => '플레이어 2의 연결이 끊겼습니다';

  @override
  String get hostDisconnected => '호스트의 연결이 끊겼습니다';

  @override
  String maxLevelSold(String amount) {
    return '최대 레벨! \$$amount에 판매';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return '무기 레벨 $tier 해금';
  }

  @override
  String get cheatsEnabled => '치트 켜짐';

  @override
  String get cheatsDisabled => '치트 꺼짐';

  @override
  String get cheatsMaxed => '치트: 크레딧 최대, 모든 무기 해금';

  @override
  String get cheats => '치트';

  @override
  String get maxCredits => '크레딧 최대';

  @override
  String get sectionStats => '능력치';

  @override
  String get sectionLoadout => '장착 무기';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => '강화';

  @override
  String get sell => '판매';

  @override
  String get buy => '구매';

  @override
  String get commandCenter => '사령부';

  @override
  String get pilot => '파일럿';

  @override
  String get dps => 'DPS';

  @override
  String get score => '점수';

  @override
  String get nextWeapon => '다음 무기까지';

  @override
  String pointsValue(String points) {
    return '$points점';
  }

  @override
  String get slotFront => '전방';

  @override
  String get slotLeft => '왼쪽';

  @override
  String get slotRight => '오른쪽';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => '임무 개시';

  @override
  String get startMission => '임무 시작';

  @override
  String get continueMission => '임무 계속';

  @override
  String get padControlsHint =>
      '[↑↓] 줄   [←→] 선택   [B] 구매/강화/교체   [X/Y] 판매   [OPTIONS] 계속';

  @override
  String get host => '호스트';

  @override
  String hostingAs(String name) {
    return '호스팅 중: $name';
  }

  @override
  String get join => '참가';

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
  String get overload => '과부하';

  @override
  String weaponOff(String weapon) {
    return '$weapon 꺼짐 — 발전기 출력 부족';
  }

  @override
  String unlocksAt(String points) {
    return '$points점에서 해금';
  }

  @override
  String joinConnecting(String target) {
    return '$target에 연결 중…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return '호스트가 응답하지 않습니다: $reason.\n\n두 플레이어가 같은 Wi-Fi(개인용 핫스팟도 가능)에 있어야 하고 호스트가 HOST를 눌러야 합니다. 주소를 확인하고 다시 시도하세요.';
  }

  @override
  String get lanJoinNoAnswer => '응답 없음';
}
