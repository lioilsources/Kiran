// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get ok => 'ਠੀਕ ਹੈ';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get connect => 'ਕਨੈਕਟ ਕਰੋ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName ਨਾਲ ਕਨੈਕਟ ਨਹੀਂ ਹੋ ਸਕਿਆ';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ਹੋਸਟ ਦਿਖ ਰਿਹਾ ਸੀ, ਪਰ ਕਨੈਕਸ਼ਨ ਨਹੀਂ ਬਣਿਆ।\n\nਨੇੜੇ ਖੇਡਣ ਲਈ ਪੀਅਰ-ਟੂ-ਪੀਅਰ Wi-Fi ਚਾਹੀਦਾ ਹੈ, ਜਿਸ ਨੂੰ ਪਰਸਨਲ ਹੌਟਸਪੌਟ ਚਾਲੂ ਹੋਣ ਵੇਲੇ iOS ਬੰਦ ਕਰ ਦਿੰਦਾ ਹੈ — ਦੋਵਾਂ ਡਿਵਾਈਸਾਂ \'ਤੇ ਹੌਟਸਪੌਟ ਬੰਦ ਕਰੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ, ਜਾਂ ਦੋਵਾਂ ਡਿਵਾਈਸਾਂ ਨੂੰ ਇੱਕੋ Wi-Fi ਨਾਲ ਜੋੜੋ।';

  @override
  String get gameOverCampaign =>
      'ਮਿਸ਼ਨ ਅਸਫਲ — ਲੋਡਆਊਟ ਅਤੇ ਕ੍ਰੈਡਿਟ ਬਚੇ ਰਹੇ। ਕਮਾਂਡ ਸੈਂਟਰ ਤੋਂ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get gameOverEndless =>
      'ਸੈਕਟਰ 1 ਵਿੱਚ ਮੁੜ ਨਿਰਮਾਣ — ਲੋਡਆਊਟ ਅਤੇ ਕ੍ਰੈਡਿਟ ਬਚੇ ਰਹੇ';

  @override
  String get waitingForHost => 'ਹੋਸਟ ਦੀ ਉਡੀਕ...';

  @override
  String get waitingForHostHint => 'ਹੋਸਟ ਤਿਆਰ ਹੁੰਦੇ ਹੀ ਖੇਡ ਸ਼ੁਰੂ ਹੋਵੇਗੀ';

  @override
  String get vesselLost => 'ਜਹਾਜ਼ ਤਬਾਹ';

  @override
  String scoreValue(String score) {
    return 'ਸਕੋਰ: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'ਕ੍ਰੈਡਿਟ: $credits';
  }

  @override
  String get creditsPrefix => 'ਕ੍ਰੈਡਿਟ: ';

  @override
  String get leaderboard => 'ਲੀਡਰਬੋਰਡ';

  @override
  String get achievements => 'ਪ੍ਰਾਪਤੀਆਂ';

  @override
  String get redeploy => 'ਮੁੜ ਮੈਦਾਨ ਵਿੱਚ';

  @override
  String get resume => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get pause => 'ਰੋਕੋ';

  @override
  String get paused => 'ਰੁਕਿਆ ਹੋਇਆ';

  @override
  String get skins => 'ਸਕਿਨ';

  @override
  String get skin => 'ਸਕਿਨ';

  @override
  String get soundOn => 'ਆਵਾਜ਼: ਚਾਲੂ';

  @override
  String get soundOff => 'ਆਵਾਜ਼: ਬੰਦ';

  @override
  String get musicOn => 'ਸੰਗੀਤ: ਚਾਲੂ';

  @override
  String get musicOff => 'ਸੰਗੀਤ: ਬੰਦ';

  @override
  String get mainMenu => 'ਮੁੱਖ ਮੀਨੂ';

  @override
  String get quitToDesktop => 'ਡੈਸਕਟਾਪ \'ਤੇ ਵਾਪਸ';

  @override
  String get selectSkin => 'ਸਕਿਨ ਚੁਣੋ';

  @override
  String get difficulty => 'ਮੁਸ਼ਕਲ';

  @override
  String get difficultyEasy => 'ਆਸਾਨ';

  @override
  String get difficultyNormal => 'ਆਮ';

  @override
  String get difficultyHard => 'ਔਖਾ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'ਮੁਹਿੰਮ';

  @override
  String get quit => 'ਬਾਹਰ ਨਿਕਲੋ';

  @override
  String get restorePurchases => 'ਖਰੀਦਾਂ ਬਹਾਲ ਕਰੋ';

  @override
  String get locked => 'ਲੌਕ';

  @override
  String get mainMenuTooltip => 'ਮੁੱਖ ਮੀਨੂ';

  @override
  String nodeLevel(int level) {
    return 'ਲੈਵਲ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ਲੈਵਲ $level · ਬੌਸ $ordinal';
  }

  @override
  String get nodeLockedHint => 'ਲੌਕ ਹੈ। ਪਹਿਲਾਂ ਪਿਛਲਾ ਨੋਡ ਪੂਰਾ ਕਰੋ।';

  @override
  String get flyAgain => 'ਮੁੜ ਉੱਡੋ';

  @override
  String get launch => 'ਉਡਾਣ';

  @override
  String zoneLabel(int zone) {
    return 'ਜ਼ੋਨ $zone';
  }

  @override
  String get objectiveStar => 'ਤਾਰਾ';

  @override
  String get continueButton => 'ਅੱਗੇ';

  @override
  String get replayNode => 'ਨੋਡ ਮੁੜ ਖੇਡੋ';

  @override
  String get retry => 'ਮੁੜ ਕੋਸ਼ਿਸ਼';

  @override
  String get nodeCleared => 'ਨੋਡ ਪੂਰਾ';

  @override
  String get nodeFailed => 'ਨੋਡ ਅਸਫਲ';

  @override
  String get weaponTierUnlocked => 'ਹਥਿਆਰਾਂ ਦਾ ਨਵਾਂ ਪੱਧਰ ਅਨਲੌਕ';

  @override
  String get onSaleInComCenter => 'ਕਮਾਂਡ ਸੈਂਟਰ ਵਿੱਚ ਵਿਕਰੀ ਲਈ।';

  @override
  String get requiredTasksHint =>
      'ਲਾਜ਼ਮੀ ਕੰਮ ਹੀ ਨੋਡ ਦਾ ਫ਼ੈਸਲਾ ਕਰਦੇ ਹਨ। ਮੁੜ ਉੱਡੋ — ਜੋ ਕਮਾਇਆ ਉਹ ਤੁਹਾਡੇ ਕੋਲ ਰਹੇਗਾ।';

  @override
  String get objClear => 'ਸੈਕਟਰ ਸਾਫ਼ ਕਰੋ';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦੁਸ਼ਮਣਾਂ ਨੂੰ ਡੇਗੋ',
      one: '$count ਦੁਸ਼ਮਣ ਨੂੰ ਡੇਗੋ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ਢਾਂਚੇ ਨੂੰ ਕੋਈ ਨੁਕਸਾਨ ਨਾ ਹੋਵੇ';

  @override
  String objHull(int percent) {
    return '$percent% ਤੋਂ ਵੱਧ ਢਾਂਚੇ ਨਾਲ ਪੂਰਾ ਕਰੋ';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon ਨਾਲ $count ਨੂੰ ਤਬਾਹ ਕਰੋ',
      one: '$weapon ਨਾਲ $count ਨੂੰ ਤਬਾਹ ਕਰੋ',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਸਾਈਡ ਗੰਨਾਂ ਨਾਲ $count ਨੂੰ ਤਬਾਹ ਕਰੋ',
      one: 'ਸਾਈਡ ਗੰਨਾਂ ਨਾਲ $count ਨੂੰ ਤਬਾਹ ਕਰੋ',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon ਨੂੰ ਅੱਗੇ ਲਗਾ ਕੇ ਉਡਾਣ ਭਰੋ';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon ਨੂੰ ਸਾਈਡ ਮਾਊਂਟ \'ਤੇ ਲਗਾ ਕੇ ਉਡਾਣ ਭਰੋ';
  }

  @override
  String get objBuySideGun => 'ਕਮਾਂਡ ਸੈਂਟਰ ਤੋਂ ਸਾਈਡ ਗੰਨ ਖਰੀਦੋ';

  @override
  String objUpgradeGenerator(int level) {
    return 'ਜਨਰੇਟਰ ਨੂੰ ਲੈਵਲ $level ਤੱਕ ਅੱਪਗ੍ਰੇਡ ਕਰੋ';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'ਅਗਲੀ ਗੰਨ ਨੂੰ ਲੈਵਲ $level ਤੱਕ ਅੱਪਗ੍ਰੇਡ ਕਰੋ';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ਕਿਸੇ ਸਾਈਡ ਗੰਨ ਨੂੰ ਲੈਵਲ $level ਤੱਕ ਅੱਪਗ੍ਰੇਡ ਕਰੋ';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਬੋਨਸ ਫੜੋ',
      one: '$count ਬੋਨਸ ਫੜੋ',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਪੂਰੀਆਂ ਫ਼ਾਰਮੇਸ਼ਨਾਂ ਦਾ ਸਫ਼ਾਇਆ ਕਰੋ',
      one: '$count ਪੂਰੀ ਫ਼ਾਰਮੇਸ਼ਨ ਦਾ ਸਫ਼ਾਇਆ ਕਰੋ',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'ਕਿਸੇ ਛੋਟੇ ਗ੍ਰਹਿ ਨਾਲ ਨਾ ਟਕਰਾਓ';

  @override
  String objUnderTime(int seconds) {
    return '$seconds ਸਕਿੰਟਾਂ ਵਿੱਚ ਪੂਰਾ ਕਰੋ';
  }

  @override
  String get objStripBoss => 'ਕੋਰ ਤੋਂ ਪਹਿਲਾਂ ਬੌਸ ਦਾ ਹਰ ਹਿੱਸਾ ਤਬਾਹ ਕਰੋ';

  @override
  String get joinCoopTitle => 'ਕੋ-ਆਪ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get cannotSearchNetwork => 'ਇਸ ਨੈੱਟਵਰਕ \'ਤੇ ਖੋਜ ਨਹੀਂ ਹੋ ਸਕਦੀ';

  @override
  String get joinHintNearby =>
      'ਇੱਕੋ Wi-Fi ਹਰ ਡਿਵਾਈਸ \'ਤੇ ਚੱਲਦਾ ਹੈ। iPhone, iPad ਅਤੇ Mac ਇਸ ਤੋਂ ਬਿਨਾਂ ਵੀ ਨੇੜੇ ਇੱਕ-ਦੂਜੇ ਨੂੰ ਲੱਭ ਲੈਂਦੇ ਹਨ — ਦੋਵਾਂ \'ਤੇ ਪਰਸਨਲ ਹੌਟਸਪੌਟ ਬੰਦ ਹੋਵੇ।';

  @override
  String get joinHintWifi =>
      'ਦੋਵੇਂ ਖਿਡਾਰੀ ਇੱਕੋ Wi-Fi \'ਤੇ ਹੋਣ — ਪਰਸਨਲ ਹੌਟਸਪੌਟ ਵੀ ਚੱਲੇਗਾ।';

  @override
  String noHostsYet(String hint) {
    return 'ਹਾਲੇ ਕੋਈ ਹੋਸਟ ਨਹੀਂ। $hint';
  }

  @override
  String get lookingForHosts => 'ਇਸ Wi-Fi \'ਤੇ ਅਤੇ ਨੇੜੇ ਹੋਸਟ ਲੱਭੇ ਜਾ ਰਹੇ ਹਨ…';

  @override
  String get hostNearby => 'ਨੇੜੇ · Bluetooth / ਪੀਅਰ-ਟੂ-ਪੀਅਰ Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · ਉਹੀ Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP ਖੁਦ ਦਰਜ ਕਰੋ';

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
    return '$name — ਢਾਲ ਨਾਲ ਸੁਰੱਖਿਅਤ';
  }

  @override
  String get bossPartTurret => 'ਟਰੇਟ';

  @override
  String get bossPartShieldPod => 'ਢਾਲ ਪੌਡ';

  @override
  String get bossPartThruster => 'ਥ੍ਰਸਟਰ';

  @override
  String get bossPartCannon => 'ਤੋਪ';

  @override
  String sectorUnknownSpace(int level) {
    return 'ਸੈਕਟਰ $level — ਅਣਜਾਣ ਪੁਲਾੜ';
  }

  @override
  String get player2Joined => 'ਖਿਡਾਰੀ 2 ਸ਼ਾਮਲ ਹੋਇਆ!';

  @override
  String get player2Disconnected => 'ਖਿਡਾਰੀ 2 ਦਾ ਕਨੈਕਸ਼ਨ ਟੁੱਟਿਆ';

  @override
  String get hostDisconnected => 'ਹੋਸਟ ਦਾ ਕਨੈਕਸ਼ਨ ਟੁੱਟਿਆ';

  @override
  String maxLevelSold(String amount) {
    return 'ਵੱਧ ਤੋਂ ਵੱਧ ਲੈਵਲ! \$$amount ਵਿੱਚ ਵਿਕਿਆ';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ਹਥਿਆਰ ਪੱਧਰ $tier ਅਨਲੌਕ';
  }

  @override
  String get cheatsEnabled => 'ਚੀਟਸ ਚਾਲੂ';

  @override
  String get cheatsDisabled => 'ਚੀਟਸ ਬੰਦ';

  @override
  String get cheatsMaxed => 'ਚੀਟ: ਕ੍ਰੈਡਿਟ ਵੱਧ ਤੋਂ ਵੱਧ, ਸਾਰੇ ਹਥਿਆਰ ਅਨਲੌਕ';

  @override
  String get cheats => 'ਚੀਟਸ';

  @override
  String get maxCredits => 'ਵੱਧ ਤੋਂ ਵੱਧ ਕ੍ਰੈਡਿਟ';

  @override
  String get sectionStats => 'ਅੰਕੜੇ';

  @override
  String get sectionLoadout => 'ਲੋਡਆਊਟ';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ਅੱਪਗ੍ਰੇਡ';

  @override
  String get sell => 'ਵੇਚੋ';

  @override
  String get buy => 'ਖਰੀਦੋ';

  @override
  String get commandCenter => 'ਕਮਾਂਡ ਸੈਂਟਰ';

  @override
  String get pilot => 'ਪਾਇਲਟ';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ਸਕੋਰ';

  @override
  String get nextWeapon => 'ਅਗਲਾ ਹਥਿਆਰ';

  @override
  String pointsValue(String points) {
    return '$points ਅੰਕ';
  }

  @override
  String get slotFront => 'ਅੱਗੇ';

  @override
  String get slotLeft => 'ਖੱਬੇ';

  @override
  String get slotRight => 'ਸੱਜੇ';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'ਮਿਸ਼ਨ ਲਾਂਚ ਕਰੋ';

  @override
  String get startMission => 'ਮਿਸ਼ਨ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get continueMission => 'ਮਿਸ਼ਨ ਜਾਰੀ ਰੱਖੋ';

  @override
  String get padControlsHint =>
      '[↑↓] ਕਤਾਰ   [←→] ਚੁਣੋ   [B] ਖਰੀਦੋ/ਅੱਪਗ੍ਰੇਡ/ਬਦਲੋ   [X/Y] ਵੇਚੋ   [OPTIONS] ਮਿਸ਼ਨ ਜਾਰੀ ਰੱਖੋ';

  @override
  String get host => 'ਹੋਸਟ ਕਰੋ';

  @override
  String hostingAs(String name) {
    return '$name ਵਜੋਂ ਹੋਸਟਿੰਗ';
  }

  @override
  String get join => 'ਸ਼ਾਮਲ ਹੋਵੋ';

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
  String get overload => 'ਓਵਰਲੋਡ';

  @override
  String weaponOff(String weapon) {
    return '$weapon ਬੰਦ — ਜਨਰੇਟਰ ਬਹੁਤ ਕਮਜ਼ੋਰ';
  }

  @override
  String unlocksAt(String points) {
    return '$points ਅੰਕਾਂ \'ਤੇ ਅਨਲੌਕ';
  }

  @override
  String joinConnecting(String target) {
    return '$target ਨਾਲ ਕਨੈਕਟ ਹੋ ਰਿਹਾ ਹੈ…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ਹੋਸਟ ਨੇ ਜਵਾਬ ਨਹੀਂ ਦਿੱਤਾ: $reason।\n\nਦੋਵੇਂ ਖਿਡਾਰੀ ਇੱਕੋ Wi-Fi \'ਤੇ ਹੋਣ (ਪਰਸਨਲ ਹੌਟਸਪੌਟ ਵੀ ਚੱਲੇਗਾ) ਅਤੇ ਹੋਸਟ ਨੇ ਹੋਸਟ ਕਰੋ ਦਬਾਇਆ ਹੋਵੇ। ਪਤਾ ਜਾਂਚੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
  }

  @override
  String get lanJoinNoAnswer => 'ਕੋਈ ਜਵਾਬ ਨਹੀਂ';

  @override
  String objBossUnder(int seconds) {
    return 'ਬੌਸ ਦੇ ਆਉਣ ਦੇ $seconds ਸਕਿੰਟਾਂ ਵਿੱਚ ਉਸ ਦਾ ਕੋਰ ਤਬਾਹ ਕਰੋ';
  }

  @override
  String get sectionHangar => 'ਹੈਂਗਰ';

  @override
  String get sectionVault => 'ਤਿਜੋਰੀ';

  @override
  String get rackSide => 'ਸਾਈਡ';

  @override
  String get rackHull => 'ਢਾਂਚਾ';

  @override
  String get rarityCommon => 'ਆਮ';

  @override
  String get rarityRare => 'ਦੁਰਲੱਭ';

  @override
  String get rarityMythic => 'ਮਿਥਿਹਾਸਕ';

  @override
  String get curse => 'ਸਰਾਪ';

  @override
  String get modFit => 'ਲਗਾਓ';

  @override
  String get modUnfit => 'ਲਾਹੋ';

  @override
  String get modForge => 'ਭੱਠੀ';

  @override
  String get forgeHint => 'ਇੱਕੋ ਦੁਰਲੱਭਤਾ ਦੇ 3 ਚੁਣ ਕੇ ਅਗਲੀ ਦੁਰਲੱਭਤਾ ਦਾ 1 ਘੜੋ';

  @override
  String get vaultEmpty =>
      'ਹਾਲੇ ਕੋਈ ਮੌਡ ਨਹੀਂ। ਸਾਰੇ ਤਾਰਿਆਂ ਨਾਲ ਨੋਡ ਪੂਰਾ ਕਰੋ, ਬੌਸ ਨੂੰ ਜਲਦੀ ਹਰਾਓ ਜਾਂ ਬੇਅੰਤ ਮੋਡ ਵਿੱਚ ਬੌਸ ਨੂੰ ਡੇਗੋ।';

  @override
  String modNeeds(String families) {
    return '$families ਨਾਲ ਚੱਲਦਾ ਹੈ';
  }

  @override
  String get modRackFull => 'ਰੈਕ ਭਰਿਆ ਹੈ';

  @override
  String get modAlreadyFitted => 'ਪਹਿਲਾਂ ਹੀ ਲੱਗਾ ਹੈ';

  @override
  String get modWrongRack => 'ਇਸ ਰੈਕ ਵਿੱਚ ਨਹੀਂ ਲੱਗਦਾ';

  @override
  String modsSpilled(int n) {
    return '$n ਮੌਡ ਤਿਜੋਰੀ ਵਿੱਚ ਵਾਪਸ';
  }

  @override
  String get hullLocked => 'ਲੌਕ';

  @override
  String hullUnlockBoss(int n) {
    return 'ਮੁਹਿੰਮ ਦੇ ਬੌਸ $n ਨੂੰ ਹਰਾਓ';
  }

  @override
  String get hullUnlockFinish => 'ਮੁਹਿੰਮ ਪੂਰੀ ਕਰੋ ਜਾਂ ਸੈਕਟਰ 30 ਤੱਕ ਪਹੁੰਚੋ';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'ਮਿਆਰੀ ਜਹਾਜ਼';

  @override
  String get perkAfterimage => 'ਟਿਕੇ ਰਹੋ: ਸ਼ਾਟ ×1.5';

  @override
  String get perkBulwark => 'ਢਾਲ ਤੋਂ ਪਾਰ ਦਾ ਨੁਕਸਾਨ ਅੱਧਾ';

  @override
  String get perkOverclock => 'ਸਮਰੱਥਾ ਦੇ 130 % ਤੱਕ ਫ਼ਾਇਰ, ਹੌਲੀ';

  @override
  String get perkBattery => 'ਇੱਕ ਮੁਫ਼ਤ ਗੰਨ ਡਰੋਨ ਨਾਲ ਉੱਡਦਾ ਹੈ';

  @override
  String get rewardTitle => 'ਇਨਾਮ';

  @override
  String newHull(String name) {
    return 'ਨਵਾਂ ਢਾਂਚਾ: $name';
  }

  @override
  String get socketEmpty => 'ਖਾਲੀ';

  @override
  String fxStreams(int n) {
    return '$n ਸਮਾਂਤਰ ਧਾਰਾਵਾਂ';
  }

  @override
  String fxFan(int n) {
    return '$n ਸ਼ਾਟਾਂ ਦਾ ਪੱਖਾ';
  }

  @override
  String fxSalvo(int n) {
    return '$n ਸ਼ਾਟਾਂ ਦੀ ਬੁਛਾੜ';
  }

  @override
  String fxFireRate(String x) {
    return 'ਫ਼ਾਇਰ ਦਰ ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'ਨੁਕਸਾਨ ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'ਸ਼ਾਟ ਦੀ ਗਤੀ ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'ਸ਼ਾਟ ਦਾ ਆਕਾਰ ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ਊਰਜਾ ਖਪਤ ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'ਨਿਸ਼ਾਨਾ-ਖੋਜੀ +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n ਨਿਸ਼ਾਨਿਆਂ ਦੇ ਆਰ-ਪਾਰ';
  }

  @override
  String get fxPierceAll => 'ਹਰ ਚੀਜ਼ ਦੇ ਆਰ-ਪਾਰ';

  @override
  String fxCrit(int pct, String x) {
    return '×$x ਨੁਕਸਾਨ ਦੀ $pct % ਸੰਭਾਵਨਾ';
  }

  @override
  String fxBossCrit(String x) {
    return 'ਬੌਸ \'ਤੇ ×$x ਕ੍ਰਿਟ';
  }

  @override
  String fxFork(int n) {
    return 'ਡੇਗਣ \'ਤੇ $n ਸ਼ਾਟ ਖਿੱਲਰਦੇ ਹਨ';
  }

  @override
  String get fxChain => 'ਖਿੱਲਰੇ ਸ਼ਾਟ ਮੁੜ ਖਿੱਲਰਦੇ ਹਨ';

  @override
  String get fxSplit => 'ਵੱਜਣ \'ਤੇ ਦੋ ਹਿੱਸਿਆਂ ਵਿੱਚ ਵੰਡਦਾ ਹੈ';

  @override
  String get fxFrost => 'ਵਾਰ ਦੁਸ਼ਮਣਾਂ ਨੂੰ ਹੌਲੀ ਕਰਦੇ ਹਨ';

  @override
  String get fxCrossfire => 'ਸਾਈਡ ਗੰਨਾਂ ਅੰਦਰ ਵੱਲ ਝੁਕਦੀਆਂ ਹਨ';

  @override
  String get fxRearguard => 'ਸਾਈਡ ਗੰਨਾਂ ਪਿੱਛੇ ਵੀ ਫ਼ਾਇਰ ਕਰਦੀਆਂ ਹਨ';

  @override
  String get fxOrbit => 'ਸ਼ਾਟ ਵਲ ਖਾਂਦੇ ਹਨ';

  @override
  String fxBounce(int n) {
    return 'ਕੰਧਾਂ ਤੋਂ $n× ਉਛਲਦਾ ਹੈ';
  }

  @override
  String get fxBounceTop => '…ਅਤੇ ਉੱਪਰੋਂ ਵੀ';

  @override
  String get fxOverdrive => 'ਊਰਜਾ ਦੇ ਕਰਜ਼ੇ \'ਤੇ ਫ਼ਾਇਰ';

  @override
  String get fxReactor => 'ਸਮਰੱਥਾ ਤੋਂ ਵੱਧ ਗੰਨਾਂ ਵੀ ਫ਼ਾਇਰ ਕਰਦੀਆਂ ਹਨ, ਹੌਲੀ';

  @override
  String fxGenPower(String x) {
    return 'ਜਨਰੇਟਰ ਰੀਚਾਰਜ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ਜਨਰੇਟਰ ਸਮਰੱਥਾ ×$x';
  }

  @override
  String get fxSurge => 'ਭਰਿਆ ਜਨਰੇਟਰ: ਸ਼ਾਟ ×2';

  @override
  String fxSiphon(int pct) {
    return 'ਡੇਗਣ \'ਤੇ $pct % ਊਰਜਾ ਵਾਪਸ';
  }

  @override
  String fxHp(String x) {
    return 'ਢਾਂਚਾ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ਢਾਲ ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ਢਾਲ ਬਹਾਲੀ ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'ਡੇਗਣ \'ਤੇ $n HP ਠੀਕ';
  }

  @override
  String get fxMagnet => 'ਬੋਨਸ ਖਿੱਚਦਾ ਹੈ';

  @override
  String get fxMagnetAll => 'ਹਰ ਬੋਨਸ ਖਿੱਚਦਾ ਹੈ';

  @override
  String fxReflect(int pct) {
    return 'ਢਾਲ ਤੋਂ $pct % ਸ਼ਾਟ ਵਾਪਸ ਮੁੜਦੇ ਹਨ';
  }

  @override
  String get fxReflectGuided => 'ਮੁੜੇ ਸ਼ਾਟ ਖੁਦ ਨਿਸ਼ਾਨਾ ਲੱਭਦੇ ਹਨ';

  @override
  String fxGhost(String sec) {
    return 'ਢਾਂਚੇ \'ਤੇ ਵਾਰ ਤੋਂ ਬਾਅਦ $sec ਸਕਿੰਟ ਅਛੂਤਾ';
  }

  @override
  String get fxNova => 'ਢਾਲ ਟੁੱਟੇ ਤਾਂ ਪੂਰੀ ਸਕ੍ਰੀਨ \'ਤੇ ਧਮਾਕਾ';

  @override
  String fxAgility(String x) {
    return 'ਫੁਰਤੀ ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ਹਿੱਟਬਾਕਸ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'ਕ੍ਰੈਡਿਟ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'ਸਕੋਰ ×$x';
  }

  @override
  String get fxSatellite => 'ਇੱਕ ਗੰਨ ਡਰੋਨ ਨਾਲ ਉੱਡਦਾ ਹੈ';

  @override
  String get fxTimewarp => 'ਢਾਂਚੇ \'ਤੇ ਵਾਰ ਸਮੇਂ ਨੂੰ ਹੌਲੀ ਕਰਦਾ ਹੈ';

  @override
  String get fxGambler => 'ਹਰ ਸ਼ਾਟ ਇੱਕ ਬੇਤਰਤੀਬ ਹਥਿਆਰ';

  @override
  String get vaultAll => 'ਸਾਰੇ';

  @override
  String get sigilMissUnknown => 'ਅਣਜਾਣ ਆਕਾਰ';

  @override
  String get sigilMissTooSlow => 'ਬਹੁਤ ਹੌਲੀ';

  @override
  String get sigilMissSkippedDot => 'ਇੱਕ ਬਿੰਦੂ ਛੁੱਟ ਗਿਆ';

  @override
  String get sigilMissLeftRimEarly => 'ਬਹੁਤ ਜਲਦੀ ਛੱਡਿਆ';

  @override
  String get sigilMissWrongDirection => 'ਉਲਟਾ ਬਣਾਇਆ';

  @override
  String get sigilMissWrongLayer => 'ਗਲਤ ਸ਼ੋਲਡਰ ਬਟਨ';

  @override
  String get sigilDry => 'ਚਾਰਜ ਕਾਫ਼ੀ ਨਹੀਂ';

  @override
  String get sigilBusy => 'ਪਿਛਲਾ ਅਜੇ ਚੱਲ ਰਿਹਾ ਹੈ';

  @override
  String get arena => 'ਅਰੀਨਾ';

  @override
  String get arenaBossParts => 'ਬੌਸ ਦੇ ਹਿੱਸੇ';

  @override
  String get arenaBareCore => 'ਨੰਗਾ ਕੋਰ';

  @override
  String get arenaCompanions => 'ਸਾਥੀ';

  @override
  String get arenaCharge => 'ਚਾਰਜ';

  @override
  String get arenaChargeNormal => 'ਆਮ';

  @override
  String get arenaSpeed => 'ਦੁਨੀਆ ਦੀ ਰਫ਼ਤਾਰ';

  @override
  String get arenaDrill => 'ਅਭਿਆਸ';

  @override
  String get arenaFreePlay => 'ਖੁੱਲ੍ਹੀ ਖੇਡ';

  @override
  String get arenaFight => 'ਲੜੋ';

  @override
  String get arenaNewBoss => 'ਨਵਾਂ ਬੌਸ';

  @override
  String get arenaLeave => 'ਅਰੀਨਾ ਛੱਡੋ';

  @override
  String get arenaHint =>
      'ਬੌਸ ਮਰਦੇ ਹੀ ਵਾਪਸ ਆਉਂਦਾ ਹੈ। ਇੱਥੇ ਕੁਝ ਵੀ ਸੇਵ ਨਹੀਂ ਹੁੰਦਾ।';

  @override
  String get arenaColCast => 'ਵਰਤੋਂ';

  @override
  String get arenaColMiss => 'ਖੁੰਝ';

  @override
  String get arenaColAvg => 'ਔਸਤ';

  @override
  String get arenaColBest => 'ਸਭ ਤੋਂ ਵਧੀਆ';

  @override
  String get arenaColTime => 'ਸਭ ਤੋਂ ਤੇਜ਼';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'ਬੌਸ $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ਪੈਡ: ਸਿਜਿਲ';

  @override
  String get padSchemeClassic => 'ਪੈਡ: ਕਲਾਸਿਕ';

  @override
  String get padSouthpawOn => 'ਖੱਬੇ-ਹੱਥਾ: ਚਾਲੂ';

  @override
  String get padSouthpawOff => 'ਖੱਬੇ-ਹੱਥਾ: ਬੰਦ';

  @override
  String get sigilDescHop => 'ਫ਼ਲਿੱਕ ਦੀ ਦਿਸ਼ਾ ਵਿੱਚ ਤੇਜ਼ ਛਾਲ';

  @override
  String get sigilDescSidestep => 'ਮੈਦਾਨ ਦੇ ਪਾਰ ਲੰਮਾ ਪਾਸੇ ਦਾ ਕਦਮ';

  @override
  String get sigilDescStrike => 'ਤਿੰਨ ਭਾਰੀ ਗੋਲੀਆਂ ਨਾਲ ਅੱਗੇ ਝਪਟ, ਫਿਰ ਵਾਪਸ';

  @override
  String get sigilDescRetreat => 'ਪਿੱਛੇ ਹਟੋ, ਬਚਾਅ ਵਾਲੀ ਫ਼ਾਇਰ ਅੱਗੇ ਜਾਂਦੀ ਹੈ';

  @override
  String get sigilDescDash => 'ਅੱਗ ਵਿੱਚੋਂ ਤਿਰਛੀ ਦੌੜ, ਵਿਚਕਾਰ ਅਛੂਤ';

  @override
  String get sigilDescRoll => 'ਪਾਸੇ ਵੱਲ ਬੈਰਲ ਰੋਲ, ਅਛੂਤ';

  @override
  String get sigilDescShadow => 'ਨੇੜਲੇ ਦੁਸ਼ਮਣ ਹੇਠਾਂ ਟਿਕੋ ਅਤੇ ਫ਼ਾਇਰ ਕਰਦੇ ਰਹੋ';

  @override
  String get sigilDescEcho =>
      'ਪਰਛਾਵਾਂ ਤੁਹਾਡੇ ਆਖਰੀ ਦੋ ਸਕਿੰਟ ਅੱਧੇ ਨੁਕਸਾਨ ਨਾਲ ਦੁਹਰਾਉਂਦਾ ਹੈ';

  @override
  String get sigilDescLoop => 'ਉੱਪਰੋਂ ਲੂਪ: ਗੋਲੀਆਂ ਤੁਹਾਡੇ ਹੇਠੋਂ ਲੰਘਦੀਆਂ ਹਨ';

  @override
  String get sigilDescSlalom => 'ਪੱਖੇ ਵਾਂਗ ਫ਼ਾਇਰ ਨਾਲ ਮੈਦਾਨ ਪਾਰ S-ਮੋੜ';

  @override
  String get sigilDescCorkscrew => 'ਚਾਰੇ ਪਾਸੇ ਫ਼ਾਇਰ ਕਰਦਾ ਅੱਗੇ ਚੱਕਰ, ਅਛੂਤ';

  @override
  String get sigilDescSnapshot => 'ਫ਼ਲਿੱਕ ਦੀ ਦਿਸ਼ਾ ਵਿੱਚ ਇੱਕ ਭਾਰੀ ਗੋਲੀ';

  @override
  String get sigilDescBroadside => 'ਦੋਵਾਂ ਪਾਸਿਆਂ ਤੋਂ ਸਾਲਵੋ';

  @override
  String get sigilDescVolley => 'ਅੱਗੇ ਪੰਜ ਚਾਰਜ ਕਿਰਨਾਂ';

  @override
  String get sigilDescCaltrop => 'ਗੋਲੀਆਂ ਨਿਗਲ ਕੇ ਫਟਣ ਵਾਲੀ ਮਾਈਨ ਸੁੱਟੋ';

  @override
  String get sigilDescFrenzy => 'ਕੁਝ ਸਕਿੰਟ ਤੋਪਾਂ ਤੇਜ਼ ਚੱਲਦੀਆਂ ਹਨ';

  @override
  String get sigilDescStasis => 'ਦੁਸ਼ਮਣ ਅਤੇ ਉਨ੍ਹਾਂ ਦੀਆਂ ਗੋਲੀਆਂ ਅੱਧੀ ਰਫ਼ਤਾਰ ਤੇ';

  @override
  String get sigilDescHalo => 'ਢਾਲ ਚਾਰ ਗੁਣਾ ਤੇਜ਼ ਭਰਦੀ ਹੈ ਅਤੇ ਕੁਝ ਨਹੀਂ ਲੰਘਦਾ';

  @override
  String get sigilDescRadial => 'ਸੋਲਾਂ ਗੋਲੀਆਂ ਦਾ ਚੱਕਰ';

  @override
  String get sigilDescStorm => 'ਹਰ ਤੋਪ ਪੂਰੇ ਜ਼ੋਰ ਨਾਲ, ਮੁਫ਼ਤ';

  @override
  String get sigilDescPing => 'ਸਾਥੀ ਫ਼ਲਿੱਕ ਵਾਲੀ ਥਾਂ ਫ਼ਾਇਰ ਕੇਂਦਰਿਤ ਕਰਦੇ ਹਨ';

  @override
  String get sigilDescWingman => 'ਬਣਾਏ ਪਾਸੇ ਵਿੰਗਮੈਨ ਬੁਲਾਓ';

  @override
  String get sigilDescHunter => 'ਅੱਗੇ ਉੱਡ ਕੇ ਨਿਸ਼ਾਨੇ ਚੁਣਨ ਵਾਲਾ ਸ਼ਿਕਾਰੀ ਬੁਲਾਓ';

  @override
  String get sigilDescWarden => 'ਤੁਹਾਡੀਆਂ ਗੋਲੀਆਂ ਝੱਲਣ ਵਾਲਾ ਰਖਵਾਲਾ ਬੁਲਾਓ';

  @override
  String get sigilDescFormation => 'ਸਾਥੀ ਚੌੜੀ ਅਤੇ ਪਾੜੇ ਵਾਲੀ ਬਣਤਰ ਬਦਲਦੇ ਹਨ';

  @override
  String get sigilDescWhirl => 'ਸਾਥੀ ਤੁਹਾਡੇ ਦੁਆਲੇ ਘੁੰਮ ਕੇ ਗੋਲੀਆਂ ਨਿਗਲਦੇ ਹਨ';

  @override
  String get sigilDescSacrifice =>
      'ਸਾਥੀ ਗੋਤਾ ਲਾ ਕੇ ਫਟਦੇ ਹਨ, ਚਾਰਜ ਵਾਪਸ ਦਿੰਦੇ ਹਨ';

  @override
  String get grimoire => 'ਗ੍ਰਿਮੋਆਰ';

  @override
  String get grimoireHint =>
      'ਸੱਜੀ ਸਟਿੱਕ ਨਾਲ ਬਣਾਓ। ARMS ਲਈ LB, WING ਲਈ RB, MEGA BLAST ਲਈ ਦੋਵੇਂ ਦਬਾਓ।';

  @override
  String sigilCost(int cost) {
    return 'ਕੀਮਤ $cost';
  }

  @override
  String get sigilUntouchable => 'ਅਛੂਤ';

  @override
  String get lessonWatch => 'ਦੇਖੋ';

  @override
  String get lessonTrace => 'ਨਕਲ ਕਰੋ';

  @override
  String get lessonSlow => 'ਹੌਲੀ';

  @override
  String get lessonLive => 'ਪੂਰੀ ਰਫ਼ਤਾਰ';

  @override
  String get lessonStreak => 'ਲਗਾਤਾਰ ਪੰਜ';

  @override
  String get lessonLearned => 'ਸਿੱਖ ਲਿਆ';

  @override
  String lessonTempo(int pct) {
    return 'ਟੈਂਪੋ $pct %';
  }

  @override
  String get hintHop => 'ਸੱਜੀ ਸਟਿੱਕ ਫ਼ਲਿੱਕ ਕਰੋ';

  @override
  String get hintLoop => 'ਚੱਕਰ ਬਣਾਓ: ਤੁਸੀਂ ਗੋਲੀਆਂ ਉੱਤੋਂ ਉੱਡਦੇ ਹੋ';

  @override
  String get hintStream => 'LT ਦਬਾਓ: ਦੋ ਜਾਂ ਤਿੰਨ ਧਾਰਾਂ';

  @override
  String get arenaKata => 'ਕਾਟਾ';

  @override
  String get arenaKataOff => 'ਕੋਈ ਨਹੀਂ';

  @override
  String kataNext(String sigil, String secs) {
    return 'ਅਗਲਾ $sigil $secs s ਵਿੱਚ';
  }

  @override
  String get arenaGauntlet => 'ਗੌਂਟਲੈਟ';

  @override
  String get arenaOn => 'ਚਾਲੂ';

  @override
  String get arenaOff => 'ਬੰਦ';

  @override
  String gauntletRating(int rating, int best) {
    return 'ਰੇਟਿੰਗ $rating · ਵਧੀਆ $best';
  }

  @override
  String get duelWarning => 'ਚੇਤਾਵਨੀ';

  @override
  String get duelHintPad1 => 'ਸੱਜੀ ਸਟਿੱਕ ਨਿਸ਼ਾਨਾ ਲਾ ਕੇ ਫ਼ਾਇਰ ਕਰਦੀ ਹੈ';

  @override
  String get duelHintPad2Rt =>
      'RT, LB ਜਾਂ RB ਦਬਾਓ: ਸੱਜੀ ਸਟਿੱਕ ਸਿਜਿਲ ਬਣਾਉਂਦੀ ਹੈ';

  @override
  String get duelHintPad2Lt =>
      'LT, LB ਜਾਂ RB ਦਬਾਓ: ਸੱਜੀ ਸਟਿੱਕ ਸਿਜਿਲ ਬਣਾਉਂਦੀ ਹੈ';

  @override
  String get duelHintClassic =>
      'ਖੱਬੀ ਸਟਿੱਕ ਉਡਾਉਂਦੀ ਹੈ · B, RB ਜਾਂ RT ਨੱਕ ਦੀ ਦਿਸ਼ਾ ਫ਼ਾਇਰ';

  @override
  String get duelHintKeys1 => 'ਤੀਰ ਨਿਸ਼ਾਨਾ ਤੇ ਫ਼ਾਇਰ · WASD ਉਡਾਉਂਦਾ ਹੈ';

  @override
  String get duelHintKeys2 =>
      'ਸਪੇਸ ਨੱਕ ਦੀ ਦਿਸ਼ਾ ਫ਼ਾਇਰ · ਨਮਪੈਡ ਸਿਜਿਲ ਬਣਾਉਂਦਾ ਹੈ';

  @override
  String get arenaDuelBinding => 'ਦੁਵੱਲਾ ਮੁਦਰਾ';

  @override
  String get duelBindingRt => 'RT + ਸਟਿੱਕ';

  @override
  String get duelBindingLt => 'LT + ਸਟਿੱਕ';

  @override
  String get arenaDuelFrame => 'ਪੈਡ ਅੱਗੇ';

  @override
  String get duelFrameNose => 'ਨੱਕ';

  @override
  String get duelFrameUp => 'ਉੱਪਰ';

  @override
  String get arenaDuelAimFires => 'ਨਿਸ਼ਾਨਾ ਲਾਉਣਾ ਫ਼ਾਇਰ ਕਰਦਾ ਹੈ';

  @override
  String get duelCutInFirst => 'ਬੌਸ ਕਲੋਜ਼-ਅੱਪ: ਪਹਿਲੀ ਵਾਰ';

  @override
  String get duelCutInAlways => 'ਬੌਸ ਕਲੋਜ਼-ਅੱਪ: ਹਮੇਸ਼ਾ';

  @override
  String get duelCutInNever => 'ਬੌਸ ਕਲੋਜ਼-ਅੱਪ: ਕਦੇ ਨਹੀਂ';

  @override
  String get arenaDuelDrill => 'ਦੁਵੱਲਾ ਅਭਿਆਸ';

  @override
  String get duelDrillOff => 'ਕੋਈ ਨਹੀਂ';

  @override
  String get duelDrillAim => 'ਨਿਸ਼ਾਨਾ ਲਾਓ ਤੇ ਫ਼ਾਇਰ';

  @override
  String get duelDrillAimHow => 'ਸੱਜੀ ਸਟਿੱਕ ਬੌਸ ਵੱਲ ਕਰੋ ਅਤੇ ਮਾਰੋ';

  @override
  String get duelDrillHold => 'ਨੱਕ ਟਿਕਾਓ';

  @override
  String get duelDrillHoldHow => 'ਮੁਦਰਾ ਬਟਨ ਦਬਾ ਕੇ ਉੱਡੋ: ਨੱਕ ਥਾਂ ਤੇ ਰਹਿੰਦਾ ਹੈ';

  @override
  String get duelDrillDraw => 'ਅੱਗੇ ਬਣਾਓ';

  @override
  String get duelDrillDrawHow => 'ਮੁਦਰਾ ਵਿੱਚ ਬੌਸ ਵੱਲ ਸਿਜਿਲ ਬਣਾਓ';

  @override
  String get duelDrillTurn => 'ਪਿੱਛੇ ਮੁੜੋ';

  @override
  String get duelDrillTurnHow => 'ਬੌਸ ਤੁਹਾਡੇ ਹੇਠਾਂ ਹੈ: ਨੱਕ ਮੋੜੋ ਅਤੇ ਮਾਰੋ';

  @override
  String get duelDrillDone => 'ਹੋ ਗਿਆ';
}
