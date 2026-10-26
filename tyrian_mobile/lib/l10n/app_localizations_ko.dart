// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get cancel => '취소';

  @override
  String get connect => '연결';

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
  String get quitToDesktop => '데스크톱으로 나가기';

  @override
  String get selectSkin => '스킨 선택';

  @override
  String get quit => '종료';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get locked => '잠김';

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
  String get sectionOutfitting => '장비';

  @override
  String get sectionShop => '상점';

  @override
  String get tabFront => '전방';

  @override
  String get tabSide => '측면';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => '왼쪽';

  @override
  String get sideRight => '오른쪽';

  @override
  String get noWeaponInstalled => '무기 미장착';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return '공격:$damage 속도:$speed';
  }

  @override
  String statPower(int power) {
    return 'EN:$power';
  }

  @override
  String get beam => '빔';

  @override
  String get guided => '유도';

  @override
  String get owned => '보유';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => '강화';

  @override
  String get upgradeShort => '강화';

  @override
  String get sell => '판매';

  @override
  String get buy => '구매';

  @override
  String get noCredits => '크레딧 부족';

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
  String get generator => '발전기';

  @override
  String genOutput(String value) {
    return 'EN: +$value/fr';
  }

  @override
  String genCapacity(int value) {
    return '용량: $value';
  }

  @override
  String get startMission => '임무 시작';

  @override
  String get continueMission => '임무 계속';

  @override
  String get padControlsHint =>
      '[B] 구매/강화   [X/Y] 판매   [LB/RB] 탭   [OPTIONS] 임무 계속';

  @override
  String get host => '호스트';

  @override
  String get connectToHost => '호스트에 연결';

  @override
  String hostingAt(String ip) {
    return '호스팅 중  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => '참가';
}
