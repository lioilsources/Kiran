// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'CANCEL';

  @override
  String get connect => 'CONNECT';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Could not connect to $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'The host was visible but the link did not come up.\n\nNearby play needs peer-to-peer Wi-Fi, which iOS turns off while a Personal Hotspot is on — switch the hotspot off on both devices and try again, or put both devices on the same Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Mission failed — loadout and credits retained. Retry from the Com Center.';

  @override
  String get gameOverEndless =>
      'Rebuilding at Sector 1 — loadout and credits retained';

  @override
  String get waitingForHost => 'Waiting for host...';

  @override
  String get waitingForHostHint => 'Game will start when host is ready';

  @override
  String get vesselLost => 'VESSEL LOST';

  @override
  String scoreValue(String score) {
    return 'Score: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Credits: $credits';
  }

  @override
  String get creditsPrefix => 'Credits: ';

  @override
  String get leaderboard => 'LEADERBOARD';

  @override
  String get achievements => 'ACHIEVEMENTS';

  @override
  String get redeploy => 'REDEPLOY';

  @override
  String get resume => 'RESUME';

  @override
  String get pause => 'PAUSE';

  @override
  String get paused => 'PAUSED';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SOUND: ON';

  @override
  String get soundOff => 'SOUND: OFF';

  @override
  String get musicOn => 'MUSIC: ON';

  @override
  String get musicOff => 'MUSIC: OFF';

  @override
  String get mainMenu => 'MAIN MENU';

  @override
  String get quitToDesktop => 'QUIT TO DESKTOP';

  @override
  String get selectSkin => 'SELECT SKIN';

  @override
  String get difficulty => 'DIFFICULTY';

  @override
  String get difficultyEasy => 'EASY';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'HARD';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAIGN';

  @override
  String get quit => 'QUIT';

  @override
  String get restorePurchases => 'RESTORE PURCHASES';

  @override
  String get locked => 'LOCKED';

  @override
  String get mainMenuTooltip => 'Main menu';

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LEVEL $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Locked. Clear the node before it.';

  @override
  String get flyAgain => 'FLY AGAIN';

  @override
  String get launch => 'LAUNCH';

  @override
  String zoneLabel(int zone) {
    return 'ZONE $zone';
  }

  @override
  String get objectiveStar => 'STAR';

  @override
  String get continueButton => 'CONTINUE';

  @override
  String get replayNode => 'REPLAY NODE';

  @override
  String get retry => 'RETRY';

  @override
  String get nodeCleared => 'NODE CLEARED';

  @override
  String get nodeFailed => 'NODE FAILED';

  @override
  String get weaponTierUnlocked => 'WEAPON TIER UNLOCKED';

  @override
  String get onSaleInComCenter => 'On sale in the Com Center.';

  @override
  String get requiredTasksHint =>
      'The required tasks decide the node. Fly it again — what you earned stays with you.';

  @override
  String get objClear => 'Clear the sector';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shoot down $count hostiles',
      one: 'Shoot down 1 hostile',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Take no hull damage';

  @override
  String objHull(int percent) {
    return 'Finish above $percent% hull';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kill $count with the $weapon',
      one: 'Kill 1 with the $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kill $count with your side guns',
      one: 'Kill 1 with your side guns',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Launch with the $weapon up front';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Launch with the $weapon on a side mount';
  }

  @override
  String get objBuySideGun => 'Buy a side gun in the Com Center';

  @override
  String objUpgradeGenerator(int level) {
    return 'Upgrade your generator to level $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Upgrade your front gun to level $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Upgrade a side gun to level $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Catch $count pickups',
      one: 'Catch 1 pickup',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wipe $count whole formations',
      one: 'Wipe 1 whole formation',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ram no asteroids';

  @override
  String objUnderTime(int seconds) {
    return 'Finish within ${seconds}s';
  }

  @override
  String get objStripBoss => 'Destroy every boss part before the core';

  @override
  String get joinCoopTitle => 'Join co-op';

  @override
  String get cannotSearchNetwork => 'Cannot search this network';

  @override
  String get joinHintNearby =>
      'Same Wi-Fi works on every device. iPhone, iPad and Mac also find each other nearby without one — with Personal Hotspot off on both.';

  @override
  String get joinHintWifi =>
      'Both players must be on the same Wi-Fi — a Personal Hotspot works too.';

  @override
  String noHostsYet(String hint) {
    return 'No hosts yet. $hint';
  }

  @override
  String get lookingForHosts => 'Looking for hosts on this Wi-Fi and nearby…';

  @override
  String get hostNearby => 'Nearby · Bluetooth / peer-to-peer Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · same Wi-Fi';
  }

  @override
  String get enterIpManually => 'Enter IP manually';

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
    return '$name — SHIELDED';
  }

  @override
  String get bossPartTurret => 'Turret';

  @override
  String get bossPartShieldPod => 'Shield Pod';

  @override
  String get bossPartThruster => 'Thruster';

  @override
  String get bossPartCannon => 'Cannon';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sector $level — Unknown Space';
  }

  @override
  String get player2Joined => 'Player 2 joined!';

  @override
  String get player2Disconnected => 'Player 2 disconnected';

  @override
  String get hostDisconnected => 'Host disconnected';

  @override
  String maxLevelSold(String amount) {
    return 'Max. level! Sold for \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Weapon level $tier unlocked';
  }

  @override
  String get cheatsEnabled => 'Cheats enabled';

  @override
  String get cheatsDisabled => 'Cheats disabled';

  @override
  String get cheatsMaxed => 'CHEAT: credits maxed, all weapons unlocked';

  @override
  String get cheats => 'CHEATS';

  @override
  String get maxCredits => 'MAX CREDITS';

  @override
  String get sectionStats => 'STATS';

  @override
  String get sectionLoadout => 'LOADOUT';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'SELL';

  @override
  String get buy => 'BUY';

  @override
  String get commandCenter => 'COMMAND CENTER';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SCORE';

  @override
  String get nextWeapon => 'NEXT WEAPON';

  @override
  String pointsValue(String points) {
    return '$points pts';
  }

  @override
  String get slotFront => 'Front';

  @override
  String get slotLeft => 'Left';

  @override
  String get slotRight => 'Right';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'LAUNCH MISSION';

  @override
  String get startMission => 'START MISSION';

  @override
  String get continueMission => 'CONTINUE MISSION';

  @override
  String get padControlsHint =>
      '[↑↓] Row   [←→] Select   [B] Buy/Upgrade/Switch   [X/Y] Sell   [OPTIONS] Continue mission';

  @override
  String get host => 'HOST';

  @override
  String hostingAs(String name) {
    return 'HOSTING as $name';
  }

  @override
  String get join => 'JOIN';

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
  String get overload => 'OVERLOAD';

  @override
  String weaponOff(String weapon) {
    return '$weapon OFF — generator too weak';
  }

  @override
  String unlocksAt(String points) {
    return 'Unlocks at $points pts';
  }
}
