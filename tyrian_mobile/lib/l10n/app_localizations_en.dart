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
  String get statsOn => 'USAGE STATS: ON';

  @override
  String get statsOff => 'USAGE STATS: OFF';

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

  @override
  String joinConnecting(String target) {
    return 'Connecting to $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'The host did not answer: $reason.\n\nBoth players need to be on the same Wi-Fi (a Personal Hotspot works too) and the host must have pressed HOST. Check the address and try again.';
  }

  @override
  String get lanJoinNoAnswer => 'no reply';

  @override
  String objBossUnder(int seconds) {
    return 'Destroy the boss core within ${seconds}s of its arrival';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'VAULT';

  @override
  String get rackSide => 'Side';

  @override
  String get rackHull => 'Hull';

  @override
  String get rarityCommon => 'COMMON';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityMythic => 'MYTHIC';

  @override
  String get curse => 'CURSE';

  @override
  String get modFit => 'FIT';

  @override
  String get modUnfit => 'UNFIT';

  @override
  String get modForge => 'FORGE';

  @override
  String get forgeHint => 'Pick 3 of one rarity to forge 1 of the next';

  @override
  String get vaultEmpty =>
      'No mods yet. Clear a node on full stars, beat a boss fast, or down an endless boss.';

  @override
  String modNeeds(String families) {
    return 'Works with $families';
  }

  @override
  String get modRackFull => 'Rack full';

  @override
  String get modAlreadyFitted => 'Already fitted';

  @override
  String get modWrongRack => 'Does not fit this rack';

  @override
  String modsSpilled(int n) {
    return '$n mods back in the vault';
  }

  @override
  String get hullLocked => 'Locked';

  @override
  String hullUnlockBoss(int n) {
    return 'Beat campaign boss $n';
  }

  @override
  String get hullUnlockFinish => 'Finish the campaign or reach sector 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'Stock ship';

  @override
  String get perkAfterimage => 'Hold still: shots hit ×1.5';

  @override
  String get perkBulwark => 'Damage past the shield is halved';

  @override
  String get perkOverclock => 'Fires guns up to 130 % of capacity, slower';

  @override
  String get perkBattery => 'A free gun drone rides along';

  @override
  String get rewardTitle => 'REWARD';

  @override
  String newHull(String name) {
    return 'New hull: $name';
  }

  @override
  String get socketEmpty => 'empty';

  @override
  String fxStreams(int n) {
    return '$n parallel streams';
  }

  @override
  String fxFan(int n) {
    return 'Fan of $n shots';
  }

  @override
  String fxSalvo(int n) {
    return '$n-shot salvo';
  }

  @override
  String fxFireRate(String x) {
    return 'Fire rate ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Damage ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Shot speed ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Shot size ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Power use ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Homing +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Passes through $n targets';
  }

  @override
  String get fxPierceAll => 'Passes through everything';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % chance of ×$x damage';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x crits on bosses';
  }

  @override
  String fxFork(int n) {
    return 'Kills spray $n shots';
  }

  @override
  String get fxChain => 'Spray shots spray again';

  @override
  String get fxSplit => 'Splits in two on a hit';

  @override
  String get fxFrost => 'Hits slow enemies down';

  @override
  String get fxCrossfire => 'Side guns lean inward';

  @override
  String get fxRearguard => 'Side guns also fire backward';

  @override
  String get fxOrbit => 'Shots weave';

  @override
  String fxBounce(int n) {
    return 'Bounces off the walls $n×';
  }

  @override
  String get fxBounceTop => '…and off the top';

  @override
  String get fxOverdrive => 'Fires on a power debt';

  @override
  String get fxReactor => 'Over-capacity guns still fire, slowly';

  @override
  String fxGenPower(String x) {
    return 'Generator recharge ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generator capacity ×$x';
  }

  @override
  String get fxSurge => 'Full generator: shots ×2';

  @override
  String fxSiphon(int pct) {
    return 'Kills refill $pct % power';
  }

  @override
  String fxHp(String x) {
    return 'Hull ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Shield ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Shield regen ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Kills heal $n HP';
  }

  @override
  String get fxMagnet => 'Pulls pickups in';

  @override
  String get fxMagnetAll => 'Pulls in every pickup';

  @override
  String fxReflect(int pct) {
    return '$pct % of shots off the shield fly back';
  }

  @override
  String get fxReflectGuided => 'Reflected shots home in';

  @override
  String fxGhost(String sec) {
    return 'Untouchable $sec s after a hull hit';
  }

  @override
  String get fxNova => 'Shield breaks: the whole screen takes a blast';

  @override
  String fxAgility(String x) {
    return 'Agility ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Hitbox ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Credits ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Score ×$x';
  }

  @override
  String get fxSatellite => 'A gun drone rides along';

  @override
  String get fxTimewarp => 'A hull hit slows time';

  @override
  String get fxGambler => 'Every shot is a random gun';

  @override
  String get vaultAll => 'ALL';

  @override
  String get sigilMissUnknown => 'unknown shape';

  @override
  String get sigilMissTooSlow => 'too slow';

  @override
  String get sigilMissSkippedDot => 'skipped a dot';

  @override
  String get sigilMissLeftRimEarly => 'let go too early';

  @override
  String get sigilMissWrongDirection => 'drawn backwards';

  @override
  String get sigilMissWrongLayer => 'wrong shoulder button';

  @override
  String get sigilDry => 'not enough charge';

  @override
  String get sigilBusy => 'previous one still running';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BOSS PARTS';

  @override
  String get arenaBareCore => 'bare core';

  @override
  String get arenaCompanions => 'COMPANIONS';

  @override
  String get arenaCharge => 'CHARGE';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'WORLD SPEED';

  @override
  String get arenaDrill => 'DRILL';

  @override
  String get arenaFreePlay => 'FREE PLAY';

  @override
  String get arenaFight => 'FIGHT';

  @override
  String get arenaNewBoss => 'NEW BOSS';

  @override
  String get arenaLeave => 'LEAVE ARENA';

  @override
  String get arenaHint =>
      'The boss comes back the moment it dies. Nothing here is saved.';

  @override
  String get arenaColCast => 'CAST';

  @override
  String get arenaColMiss => 'MISS';

  @override
  String get arenaColAvg => 'AVG';

  @override
  String get arenaColBest => 'BEST';

  @override
  String get arenaColTime => 'FASTEST';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bosses $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILS';

  @override
  String get padSchemeClassic => 'PAD: CLASSIC';

  @override
  String get padSouthpawOn => 'LEFT-HANDED: ON';

  @override
  String get padSouthpawOff => 'LEFT-HANDED: OFF';

  @override
  String get sigilDescHop => 'A quick hop the way you flick';

  @override
  String get sigilDescSidestep => 'A long sidestep across the field';

  @override
  String get sigilDescStrike =>
      'Lunge forward with three heavy shots, then back';

  @override
  String get sigilDescRetreat => 'Fall back while covering fire goes forward';

  @override
  String get sigilDescDash =>
      'A diagonal dash through fire, untouchable midway';

  @override
  String get sigilDescRoll => 'A barrel roll to the side, untouchable';

  @override
  String get sigilDescShadow => 'Lock under the nearest enemy and keep firing';

  @override
  String get sigilDescEcho =>
      'A shadow replays your last two seconds at half damage';

  @override
  String get sigilDescLoop => 'Loop over the top: shots pass beneath you';

  @override
  String get sigilDescSlalom => 'An S-curve across the field with fanned fire';

  @override
  String get sigilDescCorkscrew =>
      'Corkscrew forward firing all around, untouchable';

  @override
  String get sigilDescSnapshot => 'One heavy shot the way you flick';

  @override
  String get sigilDescBroadside => 'A salvo out of both flanks';

  @override
  String get sigilDescVolley => 'Five charged rays forward';

  @override
  String get sigilDescCaltrop => 'Drop a mine that swallows shots and blows up';

  @override
  String get sigilDescFrenzy => 'Guns fire faster for a few seconds';

  @override
  String get sigilDescStasis => 'Enemies and their shots slow to half speed';

  @override
  String get sigilDescHalo =>
      'Shield recharges four times faster and nothing gets through';

  @override
  String get sigilDescRadial => 'A ring of sixteen shots';

  @override
  String get sigilDescStorm => 'Every gun fires flat out, for free';

  @override
  String get sigilDescPing => 'Companions focus fire where you flick';

  @override
  String get sigilDescWingman => 'Call a wingman to the flank you drew toward';

  @override
  String get sigilDescHunter =>
      'Call a hunter that flies ahead and picks targets';

  @override
  String get sigilDescWarden =>
      'Call a warden that takes the shots meant for you';

  @override
  String get sigilDescFormation => 'Companions switch between wide and wedge';

  @override
  String get sigilDescWhirl => 'Companions circle you and eat shots';

  @override
  String get sigilDescSacrifice =>
      'Companions dive and explode, paying charge back';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Draw with the right stick. Hold LB for ARMS, RB for WING, both for MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'cost $cost';
  }

  @override
  String get sigilUntouchable => 'untouchable';

  @override
  String get lessonWatch => 'WATCH';

  @override
  String get lessonTrace => 'TRACE IT';

  @override
  String get lessonSlow => 'SLOW';

  @override
  String get lessonLive => 'FULL SPEED';

  @override
  String get lessonStreak => 'FIVE IN A ROW';

  @override
  String get lessonLearned => 'LEARNED';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Flick the right stick';

  @override
  String get hintLoop => 'Draw a circle: you fly over the shots';

  @override
  String get hintStream => 'Squeeze LT: two or three streams';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NONE';

  @override
  String kataNext(String sigil, String secs) {
    return 'next $sigil in $secs s';
  }

  @override
  String get arenaGauntlet => 'GAUNTLET';

  @override
  String get arenaOn => 'ON';

  @override
  String get arenaOff => 'OFF';

  @override
  String gauntletRating(int rating, int best) {
    return 'Rating $rating · best $best';
  }

  @override
  String get duelWarning => 'WARNING';

  @override
  String get duelHintPad1 => 'Right stick aims and fires';

  @override
  String get duelHintPad2Rt =>
      'Hold RT, LB or RB: the right stick draws sigils';

  @override
  String get duelHintPad2Lt =>
      'Hold LT, LB or RB: the right stick draws sigils';

  @override
  String get duelHintClassic =>
      'Left stick flies · B, RB or RT fire where the nose points';

  @override
  String get duelHintKeys1 => 'Arrows aim and fire · WASD flies';

  @override
  String get duelHintKeys2 =>
      'Space fires where the nose points · the numpad draws sigils';

  @override
  String get arenaDuelBinding => 'DUEL STANCE';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'PAD FORWARD';

  @override
  String get duelFrameNose => 'THE NOSE';

  @override
  String get duelFrameUp => 'UP';

  @override
  String get arenaDuelAimFires => 'AIMING FIRES';

  @override
  String get duelCutInFirst => 'BOSS CLOSE-UP: FIRST TIME';

  @override
  String get duelCutInAlways => 'BOSS CLOSE-UP: ALWAYS';

  @override
  String get duelCutInNever => 'BOSS CLOSE-UP: NEVER';

  @override
  String get arenaDuelDrill => 'DUEL DRILL';

  @override
  String get duelDrillOff => 'NONE';

  @override
  String get duelDrillAim => 'AIM AND FIRE';

  @override
  String get duelDrillAimHow => 'Point the right stick at the boss and hit it';

  @override
  String get duelDrillHold => 'HOLD THE NOSE';

  @override
  String get duelDrillHoldHow =>
      'Hold a stance button and fly: the nose stays put';

  @override
  String get duelDrillDraw => 'DRAW FORWARD';

  @override
  String get duelDrillDrawHow => 'In the stance, draw a sigil toward the boss';

  @override
  String get duelDrillTurn => 'TURN ROUND';

  @override
  String get duelDrillTurnHow =>
      'The boss is below you: turn the nose and hit it';

  @override
  String get duelDrillDone => 'DONE';

  @override
  String get swapHint => 'Tap a second finger to swap weapons';
}
