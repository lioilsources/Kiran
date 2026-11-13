// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get ok => 'ಸರಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get connect => 'ಸಂಪರ್ಕಿಸಿ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName ಗೆ ಸಂಪರ್ಕಿಸಲಾಗಲಿಲ್ಲ';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ಹೋಸ್ಟ್ ಕಾಣಿಸಿತ್ತು, ಆದರೆ ಸಂಪರ್ಕ ಏರ್ಪಡಲಿಲ್ಲ.\n\nಹತ್ತಿರದ ಆಟಕ್ಕೆ ಪೀರ್-ಟು-ಪೀರ್ ವೈ-ಫೈ ಬೇಕು; ಪರ್ಸನಲ್ ಹಾಟ್‌ಸ್ಪಾಟ್ ಆನ್ ಇದ್ದಾಗ iOS ಅದನ್ನು ಆಫ್ ಮಾಡುತ್ತದೆ. ಎರಡೂ ಸಾಧನಗಳಲ್ಲಿ ಹಾಟ್‌ಸ್ಪಾಟ್ ಆಫ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ, ಅಥವಾ ಎರಡೂ ಸಾಧನಗಳನ್ನು ಒಂದೇ ವೈ-ಫೈಗೆ ಸೇರಿಸಿ.';

  @override
  String get gameOverCampaign =>
      'ಕಾರ್ಯಾಚರಣೆ ವಿಫಲ — ಶಸ್ತ್ರಸಜ್ಜಿತತೆ ಮತ್ತು ಕ್ರೆಡಿಟ್‌ಗಳು ಉಳಿದಿವೆ. ಕಾಮ್ ಸೆಂಟರ್‌ನಿಂದ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get gameOverEndless =>
      'ಸೆಕ್ಟರ್ 1 ರಲ್ಲಿ ಪುನರ್ನಿರ್ಮಾಣ — ಶಸ್ತ್ರಸಜ್ಜಿತತೆ ಮತ್ತು ಕ್ರೆಡಿಟ್‌ಗಳು ಉಳಿದಿವೆ';

  @override
  String get waitingForHost => 'ಹೋಸ್ಟ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ...';

  @override
  String get waitingForHostHint => 'ಹೋಸ್ಟ್ ಸಿದ್ಧವಾದಾಗ ಆಟ ಪ್ರಾರಂಭವಾಗುತ್ತದೆ';

  @override
  String get vesselLost => 'ಯಾನ ನಾಶ';

  @override
  String scoreValue(String score) {
    return 'ಸ್ಕೋರ್: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'ಕ್ರೆಡಿಟ್: $credits';
  }

  @override
  String get creditsPrefix => 'ಕ್ರೆಡಿಟ್:';

  @override
  String get leaderboard => 'ಲೀಡರ್‌ಬೋರ್ಡ್';

  @override
  String get achievements => 'ಸಾಧನೆಗಳು';

  @override
  String get redeploy => 'ಮರುನಿಯೋಜನೆ';

  @override
  String get resume => 'ಮುಂದುವರಿಸಿ';

  @override
  String get pause => 'ವಿರಾಮ';

  @override
  String get paused => 'ವಿರಾಮದಲ್ಲಿದೆ';

  @override
  String get skins => 'ಸ್ಕಿನ್‌ಗಳು';

  @override
  String get skin => 'ಸ್ಕಿನ್';

  @override
  String get soundOn => 'ಧ್ವನಿ: ಆನ್';

  @override
  String get soundOff => 'ಧ್ವನಿ: ಆಫ್';

  @override
  String get musicOn => 'ಸಂಗೀತ: ಆನ್';

  @override
  String get musicOff => 'ಸಂಗೀತ: ಆಫ್';

  @override
  String get mainMenu => 'ಮುಖ್ಯ ಮೆನು';

  @override
  String get quitToDesktop => 'ಡೆಸ್ಕ್‌ಟಾಪ್‌ಗೆ ನಿರ್ಗಮಿಸಿ';

  @override
  String get selectSkin => 'ಸ್ಕಿನ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get difficulty => 'ಕಠಿಣತೆ';

  @override
  String get difficultyEasy => 'ಸುಲಭ';

  @override
  String get difficultyNormal => 'ಸಾಮಾನ್ಯ';

  @override
  String get difficultyHard => 'ಕಠಿಣ';

  @override
  String get difficultyLord => 'ಲಾರ್ಡ್';

  @override
  String get campaign => 'ಅಭಿಯಾನ';

  @override
  String get quit => 'ನಿರ್ಗಮಿಸಿ';

  @override
  String get restorePurchases => 'ಖರೀದಿಗಳನ್ನು ಮರುಸ್ಥಾಪಿಸಿ';

  @override
  String get locked => 'ಲಾಕ್ ಆಗಿದೆ';

  @override
  String get mainMenuTooltip => 'ಮುಖ್ಯ ಮೆನು';

  @override
  String nodeLevel(int level) {
    return 'ಹಂತ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ಹಂತ $level · ಬಾಸ್ $ordinal';
  }

  @override
  String get nodeLockedHint => 'ಲಾಕ್ ಆಗಿದೆ. ಅದಕ್ಕೂ ಮೊದಲಿನ ನೋಡ್ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get flyAgain => 'ಮತ್ತೆ ಹಾರಿ';

  @override
  String get launch => 'ಉಡಾವಣೆ';

  @override
  String zoneLabel(int zone) {
    return 'ವಲಯ $zone';
  }

  @override
  String get objectiveStar => 'ನಕ್ಷತ್ರ';

  @override
  String get continueButton => 'ಮುಂದುವರಿಸಿ';

  @override
  String get replayNode => 'ನೋಡ್ ಮರುಆಡಿ';

  @override
  String get retry => 'ಮರುಪ್ರಯತ್ನ';

  @override
  String get nodeCleared => 'ನೋಡ್ ಪೂರ್ಣ';

  @override
  String get nodeFailed => 'ನೋಡ್ ವಿಫಲ';

  @override
  String get weaponTierUnlocked => 'ಶಸ್ತ್ರ ಮಟ್ಟ ಅನ್‌ಲಾಕ್ ಆಯಿತು';

  @override
  String get onSaleInComCenter => 'ಕಾಮ್ ಸೆಂಟರ್‌ನಲ್ಲಿ ಮಾರಾಟಕ್ಕಿದೆ.';

  @override
  String get requiredTasksHint =>
      'ಅಗತ್ಯ ಕಾರ್ಯಗಳು ನೋಡ್‌ನ ಫಲಿತಾಂಶ ನಿರ್ಧರಿಸುತ್ತವೆ. ಮತ್ತೆ ಹಾರಿ — ನೀವು ಗಳಿಸಿದ್ದು ನಿಮ್ಮೊಂದಿಗೇ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get objClear => 'ಸೆಕ್ಟರ್ ಅನ್ನು ತೆರವುಗೊಳಿಸಿ';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಶತ್ರುಗಳನ್ನು ಹೊಡೆದುರುಳಿಸಿ',
      one: '$count ಶತ್ರುವನ್ನು ಹೊಡೆದುರುಳಿಸಿ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ಹಲ್‌ಗೆ ಹಾನಿಯಾಗದಂತೆ ನೋಡಿಕೊಳ್ಳಿ';

  @override
  String objHull(int percent) {
    return '$percent% ಹಲ್‌ಗಿಂತ ಹೆಚ್ಚು ಉಳಿಸಿಕೊಂಡು ಮುಗಿಸಿ';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon ಯಿಂದ $count ಶತ್ರುಗಳನ್ನು ಕೊಲ್ಲಿ',
      one: '$weapon ಯಿಂದ $count ಶತ್ರುವನ್ನು ಕೊಲ್ಲಿ',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಬದಿಯ ಗನ್‌ಗಳಿಂದ $count ಶತ್ರುಗಳನ್ನು ಕೊಲ್ಲಿ',
      one: 'ಬದಿಯ ಗನ್‌ಗಳಿಂದ $count ಶತ್ರುವನ್ನು ಕೊಲ್ಲಿ',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon ಅನ್ನು ಮುಂಭಾಗದಲ್ಲಿ ಇಟ್ಟು ಉಡಾಯಿಸಿ';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon ಅನ್ನು ಬದಿಯ ಮೌಂಟ್‌ನಲ್ಲಿ ಇಟ್ಟು ಉಡಾಯಿಸಿ';
  }

  @override
  String get objBuySideGun => 'ಕಾಮ್ ಸೆಂಟರ್‌ನಲ್ಲಿ ಬದಿಯ ಗನ್ ಖರೀದಿಸಿ';

  @override
  String objUpgradeGenerator(int level) {
    return 'ನಿಮ್ಮ ಜನರೇಟರ್ ಅನ್ನು ಹಂತ $level ಕ್ಕೆ ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'ನಿಮ್ಮ ಮುಂಭಾಗದ ಗನ್ ಅನ್ನು ಹಂತ $level ಕ್ಕೆ ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ಒಂದು ಬದಿಯ ಗನ್ ಅನ್ನು ಹಂತ $level ಕ್ಕೆ ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಪಿಕಪ್‌ಗಳನ್ನು ಹಿಡಿಯಿರಿ',
      one: '$count ಪಿಕಪ್ ಹಿಡಿಯಿರಿ',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಇಡೀ ತುಕಡಿಗಳನ್ನು ನಾಶಮಾಡಿ',
      one: '$count ಇಡೀ ತುಕಡಿಯನ್ನು ನಾಶಮಾಡಿ',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'ಯಾವುದೇ ಕ್ಷುದ್ರಗ್ರಹಕ್ಕೆ ಡಿಕ್ಕಿ ಹೊಡೆಯಬೇಡಿ';

  @override
  String objUnderTime(int seconds) {
    return '${seconds}s ಒಳಗೆ ಮುಗಿಸಿ';
  }

  @override
  String get objStripBoss => 'ಕೋರ್ ಮೊದಲು ಬಾಸ್‌ನ ಎಲ್ಲ ಭಾಗಗಳನ್ನು ನಾಶಮಾಡಿ';

  @override
  String get joinCoopTitle => 'ಕೋ-ಆಪ್‌ಗೆ ಸೇರಿ';

  @override
  String get cannotSearchNetwork => 'ಈ ನೆಟ್‌ವರ್ಕ್‌ನಲ್ಲಿ ಹುಡುಕಲಾಗುವುದಿಲ್ಲ';

  @override
  String get joinHintNearby =>
      'ಒಂದೇ ವೈ-ಫೈ ಎಲ್ಲ ಸಾಧನಗಳಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ. iPhone, iPad ಮತ್ತು Mac ವೈ-ಫೈ ಇಲ್ಲದೆಯೂ ಹತ್ತಿರದಲ್ಲಿ ಪರಸ್ಪರ ಕಂಡುಕೊಳ್ಳುತ್ತವೆ — ಎರಡರಲ್ಲೂ ಪರ್ಸನಲ್ ಹಾಟ್‌ಸ್ಪಾಟ್ ಆಫ್ ಇರಬೇಕು.';

  @override
  String get joinHintWifi =>
      'ಇಬ್ಬರೂ ಆಟಗಾರರು ಒಂದೇ ವೈ-ಫೈನಲ್ಲಿರಬೇಕು — ಪರ್ಸನಲ್ ಹಾಟ್‌ಸ್ಪಾಟ್ ಕೂಡ ನಡೆಯುತ್ತದೆ.';

  @override
  String noHostsYet(String hint) {
    return 'ಇನ್ನೂ ಹೋಸ್ಟ್‌ಗಳಿಲ್ಲ. $hint';
  }

  @override
  String get lookingForHosts =>
      'ಈ ವೈ-ಫೈ ಮತ್ತು ಹತ್ತಿರದಲ್ಲಿ ಹೋಸ್ಟ್‌ಗಳನ್ನು ಹುಡುಕುತ್ತಿದೆ…';

  @override
  String get hostNearby => 'ಹತ್ತಿರ · ಬ್ಲೂಟೂತ್ / ಪೀರ್-ಟು-ಪೀರ್ ವೈ-ಫೈ';

  @override
  String hostSameWifi(String address) {
    return '$address · ಅದೇ ವೈ-ಫೈ';
  }

  @override
  String get enterIpManually => 'IP ಅನ್ನು ಕೈಯಾರೆ ನಮೂದಿಸಿ';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SH';

  @override
  String get hudPower => 'PWR';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — ಗುರಾಣಿ ಹೊಂದಿದೆ';
  }

  @override
  String get bossPartTurret => 'ಗನ್ ಗೋಪುರ';

  @override
  String get bossPartShieldPod => 'ಗುರಾಣಿ ಪಾಡ್';

  @override
  String get bossPartThruster => 'ಥ್ರಸ್ಟರ್';

  @override
  String get bossPartCannon => 'ಫಿರಂಗಿ';

  @override
  String sectorUnknownSpace(int level) {
    return 'ಸೆಕ್ಟರ್ $level — ಅಜ್ಞಾತ ಬಾಹ್ಯಾಕಾಶ';
  }

  @override
  String get player2Joined => 'ಆಟಗಾರ 2 ಸೇರಿದರು!';

  @override
  String get player2Disconnected => 'ಆಟಗಾರ 2 ಸಂಪರ್ಕ ಕಡಿದರು';

  @override
  String get hostDisconnected => 'ಹೋಸ್ಟ್ ಸಂಪರ್ಕ ಕಡಿದರು';

  @override
  String maxLevelSold(String amount) {
    return 'ಗರಿಷ್ಠ ಹಂತ! \$$amount ಗೆ ಮಾರಲಾಯಿತು';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ಶಸ್ತ್ರ ಹಂತ $tier ಅನ್‌ಲಾಕ್ ಆಯಿತು';
  }

  @override
  String get cheatsEnabled => 'ಚೀಟ್‌ಗಳು ಸಕ್ರಿಯ';

  @override
  String get cheatsDisabled => 'ಚೀಟ್‌ಗಳು ನಿಷ್ಕ್ರಿಯ';

  @override
  String get cheatsMaxed => 'ಚೀಟ್: ಕ್ರೆಡಿಟ್ ಗರಿಷ್ಠ, ಎಲ್ಲ ಶಸ್ತ್ರಗಳು ಅನ್‌ಲಾಕ್';

  @override
  String get cheats => 'ಚೀಟ್‌ಗಳು';

  @override
  String get maxCredits => 'ಗರಿಷ್ಠ ಕ್ರೆಡಿಟ್';

  @override
  String get sectionStats => 'ಅಂಕಿಅಂಶ';

  @override
  String get sectionLoadout => 'ಸಜ್ಜಿಕೆ';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ಅಪ್‌ಗ್ರೇಡ್';

  @override
  String get sell => 'ಮಾರಿ';

  @override
  String get buy => 'ಖರೀದಿಸಿ';

  @override
  String get commandCenter => 'ಕಮಾಂಡ್ ಸೆಂಟರ್';

  @override
  String get pilot => 'ಪೈಲಟ್';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ಸ್ಕೋರ್';

  @override
  String get nextWeapon => 'ಮುಂದಿನ ಶಸ್ತ್ರ';

  @override
  String pointsValue(String points) {
    return '$points ಅಂಕ';
  }

  @override
  String get slotFront => 'ಮುಂದೆ';

  @override
  String get slotLeft => 'ಎಡ';

  @override
  String get slotRight => 'ಬಲ';

  @override
  String get slotGen => 'ಜನರೇಟರ್';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'ಕಾರ್ಯಾಚರಣೆ ಉಡಾಯಿಸಿ';

  @override
  String get startMission => 'ಕಾರ್ಯಾಚರಣೆ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get continueMission => 'ಕಾರ್ಯಾಚರಣೆ ಮುಂದುವರಿಸಿ';

  @override
  String get padControlsHint =>
      '[↑↓] ಸಾಲು   [←→] ಆಯ್ಕೆ   [B] ಖರೀದಿ/ಅಪ್‌ಗ್ರೇಡ್/ಬದಲಿ   [X/Y] ಮಾರಾಟ   [OPTIONS] ಕಾರ್ಯಾಚರಣೆ ಮುಂದುವರಿಸಿ';

  @override
  String get host => 'ಹೋಸ್ಟ್';

  @override
  String hostingAs(String name) {
    return '$name ಆಗಿ ಹೋಸ್ಟ್ ಮಾಡುತ್ತಿದೆ';
  }

  @override
  String get join => 'ಸೇರಿ';

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
  String get overload => 'ಓವರ್‌ಲೋಡ್';

  @override
  String weaponOff(String weapon) {
    return '$weapon ಆಫ್ — ಜನರೇಟರ್ ದುರ್ಬಲ';
  }

  @override
  String unlocksAt(String points) {
    return '$points ಅಂಕಗಳಲ್ಲಿ ಅನ್‌ಲಾಕ್ ಆಗುತ್ತದೆ';
  }

  @override
  String joinConnecting(String target) {
    return '$target ಗೆ ಸಂಪರ್ಕಿಸುತ್ತಿದೆ…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ಹೋಸ್ಟ್ ಉತ್ತರಿಸಲಿಲ್ಲ: $reason.\n\nಇಬ್ಬರೂ ಆಟಗಾರರು ಒಂದೇ ವೈ-ಫೈನಲ್ಲಿರಬೇಕು (ಪರ್ಸನಲ್ ಹಾಟ್‌ಸ್ಪಾಟ್ ಕೂಡ ನಡೆಯುತ್ತದೆ) ಮತ್ತು ಹೋಸ್ಟ್ HOST ಒತ್ತಿರಬೇಕು. ವಿಳಾಸ ಪರಿಶೀಲಿಸಿ, ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
  }

  @override
  String get lanJoinNoAnswer => 'ಉತ್ತರವಿಲ್ಲ';

  @override
  String objBossUnder(int seconds) {
    return 'ಬಾಸ್ ಬಂದ ${seconds}s ಒಳಗೆ ಅದರ ಕೋರ್ ಅನ್ನು ನಾಶಮಾಡಿ';
  }

  @override
  String get sectionHangar => 'ಹ್ಯಾಂಗರ್';

  @override
  String get sectionVault => 'ವಾಲ್ಟ್';

  @override
  String get rackSide => 'ಬದಿ';

  @override
  String get rackHull => 'ಹಲ್';

  @override
  String get rarityCommon => 'ಸಾಮಾನ್ಯ';

  @override
  String get rarityRare => 'ಅಪರೂಪ';

  @override
  String get rarityMythic => 'ಪೌರಾಣಿಕ';

  @override
  String get curse => 'ಶಾಪ';

  @override
  String get modFit => 'ಸರಿಹೊಂದುತ್ತದೆ';

  @override
  String get modUnfit => 'ಹೊಂದುವುದಿಲ್ಲ';

  @override
  String get modForge => 'ತಯಾರಿಸಿ';

  @override
  String get forgeHint => 'ಒಂದೇ ಅಪರೂಪತೆಯ 3 ಆರಿಸಿ, ಮುಂದಿನ ಮಟ್ಟದ 1 ತಯಾರಿಸಲು';

  @override
  String get vaultEmpty =>
      'ಇನ್ನೂ ಮಾಡ್‌ಗಳಿಲ್ಲ. ಪೂರ್ಣ ನಕ್ಷತ್ರಗಳೊಂದಿಗೆ ನೋಡ್ ಪೂರ್ಣಗೊಳಿಸಿ, ಬಾಸ್ ಅನ್ನು ವೇಗವಾಗಿ ಸೋಲಿಸಿ, ಅಥವಾ ಅಂತ್ಯವಿಲ್ಲದ ಬಾಸ್ ಅನ್ನು ಬೀಳಿಸಿ.';

  @override
  String modNeeds(String families) {
    return '$families ಜೊತೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';
  }

  @override
  String get modRackFull => 'ರ‍್ಯಾಕ್ ತುಂಬಿದೆ';

  @override
  String get modAlreadyFitted => 'ಈಗಾಗಲೇ ಅಳವಡಿಸಲಾಗಿದೆ';

  @override
  String get modWrongRack => 'ಈ ರ‍್ಯಾಕ್‌ಗೆ ಹೊಂದುವುದಿಲ್ಲ';

  @override
  String modsSpilled(int n) {
    return '$n ಮಾಡ್‌ಗಳು ವಾಲ್ಟ್‌ಗೆ ಮರಳಿದವು';
  }

  @override
  String get hullLocked => 'ಲಾಕ್ ಆಗಿದೆ';

  @override
  String hullUnlockBoss(int n) {
    return 'ಅಭಿಯಾನದ ಬಾಸ್ $n ಅನ್ನು ಸೋಲಿಸಿ';
  }

  @override
  String get hullUnlockFinish => 'ಅಭಿಯಾನ ಮುಗಿಸಿ ಅಥವಾ ಸೆಕ್ಟರ್ 30 ತಲುಪಿ';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'ಸ್ಟಾಕ್ ಯಾನ';

  @override
  String get perkAfterimage => 'ಸ್ಥಿರವಾಗಿರಿ: ಹೊಡೆತಗಳು ×1.5';

  @override
  String get perkBulwark => 'ಗುರಾಣಿ ದಾಟಿದ ಹಾನಿ ಅರ್ಧವಾಗುತ್ತದೆ';

  @override
  String get perkOverclock =>
      'ಸಾಮರ್ಥ್ಯದ 130 % ವರೆಗೆ ಗನ್‌ಗಳನ್ನು ಹಾರಿಸುತ್ತದೆ, ನಿಧಾನವಾಗಿ';

  @override
  String get perkBattery => 'ಒಂದು ಉಚಿತ ಗನ್ ಡ್ರೋನ್ ಜೊತೆಗೆ ಬರುತ್ತದೆ';

  @override
  String get rewardTitle => 'ಬಹುಮಾನ';

  @override
  String newHull(String name) {
    return 'ಹೊಸ ಹಲ್: $name';
  }

  @override
  String get socketEmpty => 'ಖಾಲಿ';

  @override
  String fxStreams(int n) {
    return '$n ಸಮಾನಾಂತರ ಸ್ಟ್ರೀಮ್‌ಗಳು';
  }

  @override
  String fxFan(int n) {
    return '$n ಹೊಡೆತಗಳ ಬೀಸಣಿಗೆ';
  }

  @override
  String fxSalvo(int n) {
    return '$n-ಹೊಡೆತದ ಸಾಲ್ವೋ';
  }

  @override
  String fxFireRate(String x) {
    return 'ಹಾರಿಸುವ ವೇಗ ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'ಹಾನಿ ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'ಹೊಡೆತದ ವೇಗ ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'ಹೊಡೆತದ ಗಾತ್ರ ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ವಿದ್ಯುತ್ ಬಳಕೆ ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'ಹೋಮಿಂಗ್ +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n ಗುರಿಗಳ ಮೂಲಕ ಹಾದುಹೋಗುತ್ತದೆ';
  }

  @override
  String get fxPierceAll => 'ಎಲ್ಲದರ ಮೂಲಕ ಹಾದುಹೋಗುತ್ತದೆ';

  @override
  String fxCrit(int pct, String x) {
    return '×$x ಹಾನಿಯ $pct % ಸಂಭವನೀಯತೆ';
  }

  @override
  String fxBossCrit(String x) {
    return 'ಬಾಸ್‌ಗಳ ಮೇಲೆ ×$x ಕ್ರಿಟ್‌ಗಳು';
  }

  @override
  String fxFork(int n) {
    return 'ಕೊಲೆಗಳು $n ಹೊಡೆತಗಳನ್ನು ಚೆಲ್ಲುತ್ತವೆ';
  }

  @override
  String get fxChain => 'ಚೆಲ್ಲಿದ ಹೊಡೆತಗಳು ಮತ್ತೆ ಚೆಲ್ಲುತ್ತವೆ';

  @override
  String get fxSplit => 'ಹೊಡೆದಾಗ ಎರಡಾಗಿ ಒಡೆಯುತ್ತದೆ';

  @override
  String get fxFrost => 'ಹೊಡೆತಗಳು ಶತ್ರುಗಳನ್ನು ನಿಧಾನಗೊಳಿಸುತ್ತವೆ';

  @override
  String get fxCrossfire => 'ಬದಿಯ ಗನ್‌ಗಳು ಒಳಮುಖವಾಗಿ ವಾಲುತ್ತವೆ';

  @override
  String get fxRearguard => 'ಬದಿಯ ಗನ್‌ಗಳು ಹಿಂದಕ್ಕೂ ಹಾರಿಸುತ್ತವೆ';

  @override
  String get fxOrbit => 'ಹೊಡೆತಗಳು ಹೆಣೆದುಕೊಂಡು ಸಾಗುತ್ತವೆ';

  @override
  String fxBounce(int n) {
    return 'ಗೋಡೆಗಳಿಂದ $n× ಪುಟಿಯುತ್ತದೆ';
  }

  @override
  String get fxBounceTop => '…ಮತ್ತು ಮೇಲ್ಭಾಗದಿಂದಲೂ';

  @override
  String get fxOverdrive => 'ವಿದ್ಯುತ್ ಸಾಲದ ಮೇಲೆ ಹಾರಿಸುತ್ತದೆ';

  @override
  String get fxReactor => 'ಸಾಮರ್ಥ್ಯ ಮೀರಿದ ಗನ್‌ಗಳೂ ನಿಧಾನವಾಗಿ ಹಾರಿಸುತ್ತವೆ';

  @override
  String fxGenPower(String x) {
    return 'ಜನರೇಟರ್ ರೀಚಾರ್ಜ್ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ಜನರೇಟರ್ ಸಾಮರ್ಥ್ಯ ×$x';
  }

  @override
  String get fxSurge => 'ಜನರೇಟರ್ ಪೂರ್ಣವಾದಾಗ: ಹೊಡೆತಗಳು ×2';

  @override
  String fxSiphon(int pct) {
    return 'ಕೊಲೆಗಳು $pct % ವಿದ್ಯುತ್ ತುಂಬುತ್ತವೆ';
  }

  @override
  String fxHp(String x) {
    return 'ಹಲ್ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ಗುರಾಣಿ ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ಗುರಾಣಿ ಚೇತರಿಕೆ ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'ಕೊಲೆಗಳು $n HP ಗುಣಪಡಿಸುತ್ತವೆ';
  }

  @override
  String get fxMagnet => 'ಪಿಕಪ್‌ಗಳನ್ನು ಎಳೆಯುತ್ತದೆ';

  @override
  String get fxMagnetAll => 'ಎಲ್ಲ ಪಿಕಪ್‌ಗಳನ್ನು ಎಳೆಯುತ್ತದೆ';

  @override
  String fxReflect(int pct) {
    return 'ಗುರಾಣಿಗೆ ತಾಕಿದ $pct % ಹೊಡೆತಗಳು ಹಿಂದಕ್ಕೆ ಹಾರುತ್ತವೆ';
  }

  @override
  String get fxReflectGuided => 'ಪ್ರತಿಫಲಿತ ಹೊಡೆತಗಳು ಗುರಿಯತ್ತ ಸಾಗುತ್ತವೆ';

  @override
  String fxGhost(String sec) {
    return 'ಹಲ್‌ಗೆ ಹೊಡೆತದ ನಂತರ $sec s ಅಜೇಯ';
  }

  @override
  String get fxNova => 'ಗುರಾಣಿ ಒಡೆದಾಗ: ಇಡೀ ಪರದೆಗೆ ಸ್ಫೋಟ';

  @override
  String fxAgility(String x) {
    return 'ಚುರುಕುತನ ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ಹಿಟ್‌ಬಾಕ್ಸ್ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'ಕ್ರೆಡಿಟ್ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'ಸ್ಕೋರ್ ×$x';
  }

  @override
  String get fxSatellite => 'ಒಂದು ಗನ್ ಡ್ರೋನ್ ಜೊತೆಗೆ ಬರುತ್ತದೆ';

  @override
  String get fxTimewarp => 'ಹಲ್‌ಗೆ ಹೊಡೆತ ಸಮಯವನ್ನು ನಿಧಾನಗೊಳಿಸುತ್ತದೆ';

  @override
  String get fxGambler => 'ಪ್ರತಿ ಹೊಡೆತವೂ ಯಾದೃಚ್ಛಿಕ ಗನ್';

  @override
  String get vaultAll => 'ಎಲ್ಲ';

  @override
  String get sigilMissUnknown => 'ಅಜ್ಞಾತ ಆಕಾರ';

  @override
  String get sigilMissTooSlow => 'ತುಂಬಾ ನಿಧಾನ';

  @override
  String get sigilMissSkippedDot => 'ಒಂದು ಬಿಂದು ತಪ್ಪಿತು';

  @override
  String get sigilMissLeftRimEarly => 'ಬೇಗನೆ ಬಿಟ್ಟಿರಿ';

  @override
  String get sigilMissWrongDirection => 'ಹಿಮ್ಮುಖವಾಗಿ ಬರೆದಿರಿ';

  @override
  String get sigilMissWrongLayer => 'ತಪ್ಪು ಶೋಲ್ಡರ್ ಬಟನ್';

  @override
  String get sigilDry => 'ಸಾಕಷ್ಟು ಚಾರ್ಜ್ ಇಲ್ಲ';

  @override
  String get sigilBusy => 'ಹಿಂದಿನದು ಇನ್ನೂ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get arena => 'ಅರೀನಾ';

  @override
  String get arenaBossParts => 'ಬಾಸ್ ಭಾಗಗಳು';

  @override
  String get arenaBareCore => 'ಬರಿ ಕೋರ್';

  @override
  String get arenaCompanions => 'ಸಂಗಾತಿಗಳು';

  @override
  String get arenaCharge => 'ಚಾರ್ಜ್';

  @override
  String get arenaChargeNormal => 'ಸಾಮಾನ್ಯ';

  @override
  String get arenaSpeed => 'ಜಗತ್ತಿನ ವೇಗ';

  @override
  String get arenaDrill => 'ಅಭ್ಯಾಸ';

  @override
  String get arenaFreePlay => 'ಮುಕ್ತ ಆಟ';

  @override
  String get arenaFight => 'ಹೋರಾಡಿ';

  @override
  String get arenaNewBoss => 'ಹೊಸ ಬಾಸ್';

  @override
  String get arenaLeave => 'ಅರೀನಾ ಬಿಡಿ';

  @override
  String get arenaHint =>
      'ಬಾಸ್ ಸತ್ತ ಕ್ಷಣವೇ ಮರಳುತ್ತದೆ. ಇಲ್ಲಿ ಏನೂ ಉಳಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get arenaColCast => 'ಬಳಕೆ';

  @override
  String get arenaColMiss => 'ತಪ್ಪು';

  @override
  String get arenaColAvg => 'ಸರಾಸರಿ';

  @override
  String get arenaColBest => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get arenaColTime => 'ಅತಿ ವೇಗ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'ಬಾಸ್‌ಗಳು $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ಪ್ಯಾಡ್: ಸಿಜಿಲ್';

  @override
  String get padSchemeClassic => 'ಪ್ಯಾಡ್: ಕ್ಲಾಸಿಕ್';

  @override
  String get padSouthpawOn => 'ಎಡಗೈ: ಆನ್';

  @override
  String get padSouthpawOff => 'ಎಡಗೈ: ಆಫ್';

  @override
  String get sigilDescHop => 'ಫ್ಲಿಕ್ ದಿಕ್ಕಿನಲ್ಲಿ ವೇಗದ ಜಿಗಿತ';

  @override
  String get sigilDescSidestep => 'ಮೈದಾನದಾದ್ಯಂತ ಉದ್ದ ಪಕ್ಕ ಹೆಜ್ಜೆ';

  @override
  String get sigilDescStrike =>
      'ಮೂರು ಭಾರಿ ಗುಂಡುಗಳೊಂದಿಗೆ ಮುಂದೆ ನುಗ್ಗಿ, ಮತ್ತೆ ಹಿಂದೆ';

  @override
  String get sigilDescRetreat => 'ರಕ್ಷಣಾ ಗುಂಡು ಮುಂದೆ ಹೋಗುವಾಗ ಹಿಂದೆ ಸರಿಯಿರಿ';

  @override
  String get sigilDescDash => 'ಬೆಂಕಿಯ ಮೂಲಕ ಕರ್ಣ ಓಟ, ಮಧ್ಯದಲ್ಲಿ ಅಸ್ಪೃಶ್ಯ';

  @override
  String get sigilDescRoll => 'ಪಕ್ಕಕ್ಕೆ ಬ್ಯಾರೆಲ್ ರೋಲ್, ಅಸ್ಪೃಶ್ಯ';

  @override
  String get sigilDescShadow =>
      'ಹತ್ತಿರದ ಶತ್ರುವಿನ ಕೆಳಗೆ ಅಂಟಿ ಗುಂಡು ಹಾರಿಸುತ್ತಿರಿ';

  @override
  String get sigilDescEcho =>
      'ನೆರಳು ನಿಮ್ಮ ಕೊನೆಯ ಎರಡು ಸೆಕೆಂಡುಗಳನ್ನು ಅರ್ಧ ಹಾನಿಯಲ್ಲಿ ಮರುಮಾಡುತ್ತದೆ';

  @override
  String get sigilDescLoop =>
      'ಮೇಲಿನಿಂದ ಲೂಪ್: ಗುಂಡುಗಳು ನಿಮ್ಮ ಕೆಳಗೆ ಹಾದುಹೋಗುತ್ತವೆ';

  @override
  String get sigilDescSlalom => 'ಬೀಸಣಿಗೆ ಗುಂಡಿನೊಂದಿಗೆ ಮೈದಾನದಾದ್ಯಂತ S-ತಿರುವು';

  @override
  String get sigilDescCorkscrew =>
      'ಸುತ್ತಲೂ ಗುಂಡು ಹಾರಿಸುತ್ತಾ ಮುಂದೆ ಸುರುಳಿ, ಅಸ್ಪೃಶ್ಯ';

  @override
  String get sigilDescSnapshot => 'ಫ್ಲಿಕ್ ದಿಕ್ಕಿನಲ್ಲಿ ಒಂದು ಭಾರಿ ಗುಂಡು';

  @override
  String get sigilDescBroadside => 'ಎರಡೂ ಪಾರ್ಶ್ವಗಳಿಂದ ಸಾಲ್ವೊ';

  @override
  String get sigilDescVolley => 'ಮುಂದೆ ಐದು ಚಾರ್ಜ್ ಕಿರಣಗಳು';

  @override
  String get sigilDescCaltrop => 'ಗುಂಡುಗಳನ್ನು ನುಂಗಿ ಸ್ಫೋಟಿಸುವ ಮೈನ್ ಬಿಡಿ';

  @override
  String get sigilDescFrenzy => 'ಕೆಲವು ಸೆಕೆಂಡು ಬಂದೂಕುಗಳು ವೇಗವಾಗಿ ಹಾರಿಸುತ್ತವೆ';

  @override
  String get sigilDescStasis => 'ಶತ್ರುಗಳು ಮತ್ತು ಅವರ ಗುಂಡುಗಳು ಅರ್ಧ ವೇಗಕ್ಕೆ';

  @override
  String get sigilDescHalo =>
      'ಗುರಾಣಿ ನಾಲ್ಕು ಪಟ್ಟು ವೇಗವಾಗಿ ತುಂಬುತ್ತದೆ, ಏನೂ ಒಳಬರುವುದಿಲ್ಲ';

  @override
  String get sigilDescRadial => 'ಹದಿನಾರು ಗುಂಡುಗಳ ಉಂಗುರ';

  @override
  String get sigilDescStorm => 'ಪ್ರತಿ ಬಂದೂಕು ಪೂರ್ಣ ಶಕ್ತಿಯಲ್ಲಿ, ಉಚಿತ';

  @override
  String get sigilDescPing =>
      'ಸಂಗಾತಿಗಳು ಫ್ಲಿಕ್ ಮಾಡಿದಲ್ಲಿ ಗುಂಡು ಕೇಂದ್ರೀಕರಿಸುತ್ತಾರೆ';

  @override
  String get sigilDescWingman => 'ಬರೆದ ಪಾರ್ಶ್ವಕ್ಕೆ ವಿಂಗ್‌ಮ್ಯಾನ್ ಕರೆಯಿರಿ';

  @override
  String get sigilDescHunter => 'ಮುಂದೆ ಹಾರಿ ಗುರಿ ಆರಿಸುವ ಬೇಟೆಗಾರನನ್ನು ಕರೆಯಿರಿ';

  @override
  String get sigilDescWarden => 'ನಿಮ್ಮ ಗುಂಡುಗಳನ್ನು ತಡೆಯುವ ರಕ್ಷಕನನ್ನು ಕರೆಯಿರಿ';

  @override
  String get sigilDescFormation => 'ಸಂಗಾತಿಗಳು ಅಗಲ ಮತ್ತು ಬೆಣೆ ರಚನೆ ಬದಲಿಸುತ್ತಾರೆ';

  @override
  String get sigilDescWhirl => 'ಸಂಗಾತಿಗಳು ನಿಮ್ಮ ಸುತ್ತ ಸುತ್ತಿ ಗುಂಡು ನುಂಗುತ್ತಾರೆ';

  @override
  String get sigilDescSacrifice =>
      'ಸಂಗಾತಿಗಳು ಧುಮುಕಿ ಸ್ಫೋಟಿಸುತ್ತಾರೆ, ಚಾರ್ಜ್ ಮರಳಿಸುತ್ತಾರೆ';

  @override
  String get grimoire => 'ಗ್ರಿಮೊಯರ್';

  @override
  String get grimoireHint =>
      'ಬಲ ಸ್ಟಿಕ್‌ನಿಂದ ಬರೆಯಿರಿ. ARMS ಗೆ LB, WING ಗೆ RB, MEGA BLAST ಗೆ ಎರಡೂ ಒತ್ತಿ.';

  @override
  String sigilCost(int cost) {
    return 'ಬೆಲೆ $cost';
  }

  @override
  String get sigilUntouchable => 'ಅಸ್ಪೃಶ್ಯ';

  @override
  String get lessonWatch => 'ನೋಡಿ';

  @override
  String get lessonTrace => 'ಅನುಸರಿಸಿ ಬರೆಯಿರಿ';

  @override
  String get lessonSlow => 'ನಿಧಾನ';

  @override
  String get lessonLive => 'ಪೂರ್ಣ ವೇಗ';

  @override
  String get lessonStreak => 'ಸತತ ಐದು';

  @override
  String get lessonLearned => 'ಕಲಿತಿರಿ';

  @override
  String lessonTempo(int pct) {
    return 'ಟೆಂಪೋ $pct %';
  }

  @override
  String get hintHop => 'ಬಲ ಸ್ಟಿಕ್ ಫ್ಲಿಕ್ ಮಾಡಿ';

  @override
  String get hintLoop => 'ವೃತ್ತ ಬರೆಯಿರಿ: ನೀವು ಗುಂಡುಗಳ ಮೇಲೆ ಹಾರುತ್ತೀರಿ';

  @override
  String get hintStream => 'LT ಒತ್ತಿ: ಎರಡು ಅಥವಾ ಮೂರು ಧಾರೆ';

  @override
  String get arenaKata => 'ಕಾಟಾ';

  @override
  String get arenaKataOff => 'ಯಾವುದೂ ಇಲ್ಲ';

  @override
  String kataNext(String sigil, String secs) {
    return 'ಮುಂದಿನ $sigil $secs s ನಲ್ಲಿ';
  }

  @override
  String get arenaGauntlet => 'ಗಾಂಟ್ಲೆಟ್';

  @override
  String get arenaOn => 'ಆನ್';

  @override
  String get arenaOff => 'ಆಫ್';

  @override
  String gauntletRating(int rating, int best) {
    return 'ರೇಟಿಂಗ್ $rating · ಉತ್ತಮ $best';
  }
}
