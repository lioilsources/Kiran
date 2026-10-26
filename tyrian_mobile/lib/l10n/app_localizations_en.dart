// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'CANCEL';

  @override
  String get connect => 'CONNECT';

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
  String get quitToDesktop => 'QUIT TO DESKTOP';

  @override
  String get selectSkin => 'SELECT SKIN';

  @override
  String get quit => 'QUIT';

  @override
  String get restorePurchases => 'RESTORE PURCHASES';

  @override
  String get locked => 'LOCKED';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SH';

  @override
  String get hudPower => 'PWR';

  @override
  String get hudGen => 'GEN';

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
  String get sectionOutfitting => 'OUTFITTING';

  @override
  String get sectionShop => 'SHOP';

  @override
  String get tabFront => 'FRONT';

  @override
  String get tabSide => 'SIDE';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => 'LEFT';

  @override
  String get sideRight => 'RIGHT';

  @override
  String get noWeaponInstalled => 'NO WEAPON INSTALLED';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'DMG:$damage SPD:$speed';
  }

  @override
  String statPower(int power) {
    return 'PWR:$power';
  }

  @override
  String get beam => 'BEAM';

  @override
  String get guided => 'GUIDED';

  @override
  String get owned => 'OWNED';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => 'UPGRADE';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'SELL';

  @override
  String get buy => 'BUY';

  @override
  String get noCredits => 'NO CREDITS';

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
  String get generator => 'GENERATOR';

  @override
  String genOutput(String value) {
    return 'PWR: +$value/fr';
  }

  @override
  String genCapacity(int value) {
    return 'Cap: $value';
  }

  @override
  String get startMission => 'START MISSION';

  @override
  String get continueMission => 'CONTINUE MISSION';

  @override
  String get padControlsHint =>
      '[B] Buy/Upgrade   [X/Y] Sell   [LB/RB] Tabs   [OPTIONS] Continue mission';

  @override
  String get host => 'HOST';

  @override
  String get connectToHost => 'Connect to host';

  @override
  String hostingAt(String ip) {
    return 'HOSTING  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'JOIN';
}
