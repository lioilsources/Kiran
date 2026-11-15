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
  String get statsOn => 'USAGE STATS: ON';

  @override
  String get statsOff => 'USAGE STATS: OFF';

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
  String get startMission => 'START MISSION';

  @override
  String get continueMission => 'CONTINUE MISSION';

  @override
  String get padControlsHint =>
      '[↑↓] Row   [←→] Select   [B] Buy/Upgrade/Switch   [X/Y] Sell   [OPTIONS] Continue mission';

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

  @override
  String get swapHint => 'Hold two fingers to fire your second weapons';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: stronger shots';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: hull repaired';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount shield, recharges faster';
  }

  @override
  String get pickupGenerator => 'Generator up: more power for your guns';

  @override
  String pickupCredits(String amount) {
    return '+$amount credits to spend in the ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String get tutPickupWeapon =>
      'Weapon pickups raise a gun\'s level: more damage, faster fire';

  @override
  String get tutPickupHealth =>
      'Repair pickups mend the hull; when healthy they also raise max HP';

  @override
  String get tutPickupShield =>
      'The shield takes hits before the hull and refills by itself';

  @override
  String get tutPickupGenerator =>
      'The generator powers your guns: more power keeps more guns firing';

  @override
  String get tutPickupCredits =>
      'Credits buy guns and upgrades in the ComCenter between rounds';

  @override
  String get tutBoss =>
      'BOSS! Its health is the bar at the top. Keep moving, keep firing';

  @override
  String get tutLowHp => 'Hull low! Repair pickups or the ComCenter fix it';

  @override
  String get tutGenStarved =>
      'Your guns want more power than the generator gives: upgrade it';

  @override
  String get tutCanAfford =>
      'You can afford an upgrade: see the ComCenter after this round';

  @override
  String get tutFly => 'Drag to fly. Your guns fire while your finger is down';

  @override
  String get introCollect => 'Catch the icons that enemies drop';

  @override
  String get introShop => 'Between rounds, spend your credits in the ComCenter';

  @override
  String get objBoss => 'Goal: survive the waves and beat the boss';

  @override
  String get objSurvive => 'Goal: survive the waves';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits credits · $kills kills';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Best weapon: $weapon';
  }

  @override
  String get deathBoss =>
      'Boss shots hit hard: a stronger shield buys you time';

  @override
  String get deathShield =>
      'Upgrade the shield in the ComCenter: it takes hits before the hull';

  @override
  String get deathGuns => 'Stronger guns clear waves before they can hurt you';
}
