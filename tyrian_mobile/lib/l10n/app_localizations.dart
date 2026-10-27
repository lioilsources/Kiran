import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get connect;

  /// No description provided for @nearbyJoinFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to {hostName}'**
  String nearbyJoinFailedTitle(String hostName);

  /// No description provided for @nearbyJoinFailedBody.
  ///
  /// In en, this message translates to:
  /// **'The host was visible but the link did not come up.\n\nNearby play needs peer-to-peer Wi-Fi, which iOS turns off while a Personal Hotspot is on — switch the hotspot off on both devices and try again, or put both devices on the same Wi-Fi.'**
  String get nearbyJoinFailedBody;

  /// No description provided for @gameOverCampaign.
  ///
  /// In en, this message translates to:
  /// **'Mission failed — loadout and credits retained. Retry from the Com Center.'**
  String get gameOverCampaign;

  /// No description provided for @gameOverEndless.
  ///
  /// In en, this message translates to:
  /// **'Rebuilding at Sector 1 — loadout and credits retained'**
  String get gameOverEndless;

  /// No description provided for @waitingForHost.
  ///
  /// In en, this message translates to:
  /// **'Waiting for host...'**
  String get waitingForHost;

  /// No description provided for @waitingForHostHint.
  ///
  /// In en, this message translates to:
  /// **'Game will start when host is ready'**
  String get waitingForHostHint;

  /// No description provided for @vesselLost.
  ///
  /// In en, this message translates to:
  /// **'VESSEL LOST'**
  String get vesselLost;

  /// No description provided for @scoreValue.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreValue(String score);

  /// No description provided for @creditsValue.
  ///
  /// In en, this message translates to:
  /// **'Credits: {credits}'**
  String creditsValue(String credits);

  /// No description provided for @creditsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Credits: '**
  String get creditsPrefix;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboard;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENTS'**
  String get achievements;

  /// No description provided for @redeploy.
  ///
  /// In en, this message translates to:
  /// **'REDEPLOY'**
  String get redeploy;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get pause;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @skins.
  ///
  /// In en, this message translates to:
  /// **'SKINS'**
  String get skins;

  /// No description provided for @skin.
  ///
  /// In en, this message translates to:
  /// **'SKIN'**
  String get skin;

  /// No description provided for @soundOn.
  ///
  /// In en, this message translates to:
  /// **'SOUND: ON'**
  String get soundOn;

  /// No description provided for @soundOff.
  ///
  /// In en, this message translates to:
  /// **'SOUND: OFF'**
  String get soundOff;

  /// No description provided for @musicOn.
  ///
  /// In en, this message translates to:
  /// **'MUSIC: ON'**
  String get musicOn;

  /// No description provided for @musicOff.
  ///
  /// In en, this message translates to:
  /// **'MUSIC: OFF'**
  String get musicOff;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'MAIN MENU'**
  String get mainMenu;

  /// No description provided for @quitToDesktop.
  ///
  /// In en, this message translates to:
  /// **'QUIT TO DESKTOP'**
  String get quitToDesktop;

  /// No description provided for @selectSkin.
  ///
  /// In en, this message translates to:
  /// **'SELECT SKIN'**
  String get selectSkin;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULTY'**
  String get difficulty;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'EASY'**
  String get difficultyEasy;

  /// No description provided for @difficultyNormal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get difficultyNormal;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'HARD'**
  String get difficultyHard;

  /// No description provided for @difficultyLord.
  ///
  /// In en, this message translates to:
  /// **'LORD'**
  String get difficultyLord;

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'CAMPAIGN'**
  String get campaign;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'QUIT'**
  String get quit;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'RESTORE PURCHASES'**
  String get restorePurchases;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get locked;

  /// No description provided for @mainMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Main menu'**
  String get mainMenuTooltip;

  /// No description provided for @nodeLevel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String nodeLevel(int level);

  /// No description provided for @nodeLevelBoss.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level} · BOSS {ordinal}'**
  String nodeLevelBoss(int level, String ordinal);

  /// No description provided for @nodeLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Locked. Clear the node before it.'**
  String get nodeLockedHint;

  /// No description provided for @flyAgain.
  ///
  /// In en, this message translates to:
  /// **'FLY AGAIN'**
  String get flyAgain;

  /// No description provided for @launch.
  ///
  /// In en, this message translates to:
  /// **'LAUNCH'**
  String get launch;

  /// No description provided for @zoneLabel.
  ///
  /// In en, this message translates to:
  /// **'ZONE {zone}'**
  String zoneLabel(int zone);

  /// No description provided for @objectiveStar.
  ///
  /// In en, this message translates to:
  /// **'STAR'**
  String get objectiveStar;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueButton;

  /// No description provided for @replayNode.
  ///
  /// In en, this message translates to:
  /// **'REPLAY NODE'**
  String get replayNode;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retry;

  /// No description provided for @nodeCleared.
  ///
  /// In en, this message translates to:
  /// **'NODE CLEARED'**
  String get nodeCleared;

  /// No description provided for @nodeFailed.
  ///
  /// In en, this message translates to:
  /// **'NODE FAILED'**
  String get nodeFailed;

  /// No description provided for @weaponTierUnlocked.
  ///
  /// In en, this message translates to:
  /// **'WEAPON TIER UNLOCKED'**
  String get weaponTierUnlocked;

  /// No description provided for @onSaleInComCenter.
  ///
  /// In en, this message translates to:
  /// **'On sale in the Com Center.'**
  String get onSaleInComCenter;

  /// No description provided for @requiredTasksHint.
  ///
  /// In en, this message translates to:
  /// **'The required tasks decide the node. Fly it again — what you earned stays with you.'**
  String get requiredTasksHint;

  /// No description provided for @objClear.
  ///
  /// In en, this message translates to:
  /// **'Clear the sector'**
  String get objClear;

  /// No description provided for @objKills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Shoot down 1 hostile} other{Shoot down {count} hostiles}}'**
  String objKills(int count);

  /// No description provided for @objUntouched.
  ///
  /// In en, this message translates to:
  /// **'Take no hull damage'**
  String get objUntouched;

  /// No description provided for @objHull.
  ///
  /// In en, this message translates to:
  /// **'Finish above {percent}% hull'**
  String objHull(int percent);

  /// No description provided for @objWeaponKills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kill 1 with the {weapon}} other{Kill {count} with the {weapon}}}'**
  String objWeaponKills(int count, String weapon);

  /// No description provided for @objSideGunKills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kill 1 with your side guns} other{Kill {count} with your side guns}}'**
  String objSideGunKills(int count);

  /// No description provided for @objFlyWithFront.
  ///
  /// In en, this message translates to:
  /// **'Launch with the {weapon} up front'**
  String objFlyWithFront(String weapon);

  /// No description provided for @objFlyWithSide.
  ///
  /// In en, this message translates to:
  /// **'Launch with the {weapon} on a side mount'**
  String objFlyWithSide(String weapon);

  /// No description provided for @objBuySideGun.
  ///
  /// In en, this message translates to:
  /// **'Buy a side gun in the Com Center'**
  String get objBuySideGun;

  /// No description provided for @objUpgradeGenerator.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your generator to level {level}'**
  String objUpgradeGenerator(int level);

  /// No description provided for @objUpgradeFrontGun.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your front gun to level {level}'**
  String objUpgradeFrontGun(int level);

  /// No description provided for @objUpgradeSideGun.
  ///
  /// In en, this message translates to:
  /// **'Upgrade a side gun to level {level}'**
  String objUpgradeSideGun(int level);

  /// No description provided for @objPickups.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Catch 1 pickup} other{Catch {count} pickups}}'**
  String objPickups(int count);

  /// No description provided for @objFleets.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Wipe 1 whole formation} other{Wipe {count} whole formations}}'**
  String objFleets(int count);

  /// No description provided for @objNoRam.
  ///
  /// In en, this message translates to:
  /// **'Ram no asteroids'**
  String get objNoRam;

  /// No description provided for @objUnderTime.
  ///
  /// In en, this message translates to:
  /// **'Finish within {seconds}s'**
  String objUnderTime(int seconds);

  /// No description provided for @objStripBoss.
  ///
  /// In en, this message translates to:
  /// **'Destroy every boss part before the core'**
  String get objStripBoss;

  /// No description provided for @joinCoopTitle.
  ///
  /// In en, this message translates to:
  /// **'Join co-op'**
  String get joinCoopTitle;

  /// No description provided for @cannotSearchNetwork.
  ///
  /// In en, this message translates to:
  /// **'Cannot search this network'**
  String get cannotSearchNetwork;

  /// No description provided for @joinHintNearby.
  ///
  /// In en, this message translates to:
  /// **'Same Wi-Fi works on every device. iPhone, iPad and Mac also find each other nearby without one — with Personal Hotspot off on both.'**
  String get joinHintNearby;

  /// No description provided for @joinHintWifi.
  ///
  /// In en, this message translates to:
  /// **'Both players must be on the same Wi-Fi — a Personal Hotspot works too.'**
  String get joinHintWifi;

  /// No description provided for @noHostsYet.
  ///
  /// In en, this message translates to:
  /// **'No hosts yet. {hint}'**
  String noHostsYet(String hint);

  /// No description provided for @lookingForHosts.
  ///
  /// In en, this message translates to:
  /// **'Looking for hosts on this Wi-Fi and nearby…'**
  String get lookingForHosts;

  /// No description provided for @hostNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby · Bluetooth / peer-to-peer Wi-Fi'**
  String get hostNearby;

  /// No description provided for @hostSameWifi.
  ///
  /// In en, this message translates to:
  /// **'{address} · same Wi-Fi'**
  String hostSameWifi(String address);

  /// No description provided for @enterIpManually.
  ///
  /// In en, this message translates to:
  /// **'Enter IP manually'**
  String get enterIpManually;

  /// No description provided for @hudHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get hudHp;

  /// No description provided for @hudShield.
  ///
  /// In en, this message translates to:
  /// **'SH'**
  String get hudShield;

  /// No description provided for @hudPower.
  ///
  /// In en, this message translates to:
  /// **'PWR'**
  String get hudPower;

  /// No description provided for @hudGen.
  ///
  /// In en, this message translates to:
  /// **'GEN'**
  String get hudGen;

  /// No description provided for @bossShielded.
  ///
  /// In en, this message translates to:
  /// **'{name} — SHIELDED'**
  String bossShielded(String name);

  /// No description provided for @bossPartTurret.
  ///
  /// In en, this message translates to:
  /// **'Turret'**
  String get bossPartTurret;

  /// No description provided for @bossPartShieldPod.
  ///
  /// In en, this message translates to:
  /// **'Shield Pod'**
  String get bossPartShieldPod;

  /// No description provided for @bossPartThruster.
  ///
  /// In en, this message translates to:
  /// **'Thruster'**
  String get bossPartThruster;

  /// No description provided for @bossPartCannon.
  ///
  /// In en, this message translates to:
  /// **'Cannon'**
  String get bossPartCannon;

  /// No description provided for @sectorUnknownSpace.
  ///
  /// In en, this message translates to:
  /// **'Sector {level} — Unknown Space'**
  String sectorUnknownSpace(int level);

  /// No description provided for @player2Joined.
  ///
  /// In en, this message translates to:
  /// **'Player 2 joined!'**
  String get player2Joined;

  /// No description provided for @player2Disconnected.
  ///
  /// In en, this message translates to:
  /// **'Player 2 disconnected'**
  String get player2Disconnected;

  /// No description provided for @hostDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Host disconnected'**
  String get hostDisconnected;

  /// No description provided for @maxLevelSold.
  ///
  /// In en, this message translates to:
  /// **'Max. level! Sold for \${amount}'**
  String maxLevelSold(String amount);

  /// No description provided for @weaponLevelUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Weapon level {tier} unlocked'**
  String weaponLevelUnlocked(String tier);

  /// No description provided for @cheatsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Cheats enabled'**
  String get cheatsEnabled;

  /// No description provided for @cheatsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Cheats disabled'**
  String get cheatsDisabled;

  /// No description provided for @cheatsMaxed.
  ///
  /// In en, this message translates to:
  /// **'CHEAT: credits maxed, all weapons unlocked'**
  String get cheatsMaxed;

  /// No description provided for @cheats.
  ///
  /// In en, this message translates to:
  /// **'CHEATS'**
  String get cheats;

  /// No description provided for @maxCredits.
  ///
  /// In en, this message translates to:
  /// **'MAX CREDITS'**
  String get maxCredits;

  /// No description provided for @sectionStats.
  ///
  /// In en, this message translates to:
  /// **'STATS'**
  String get sectionStats;

  /// No description provided for @sectionLoadout.
  ///
  /// In en, this message translates to:
  /// **'LOADOUT'**
  String get sectionLoadout;

  /// No description provided for @levelShort.
  ///
  /// In en, this message translates to:
  /// **'Lv.{level}'**
  String levelShort(int level);

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get max;

  /// No description provided for @upgradeShort.
  ///
  /// In en, this message translates to:
  /// **'UPG'**
  String get upgradeShort;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'SELL'**
  String get sell;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get buy;

  /// No description provided for @commandCenter.
  ///
  /// In en, this message translates to:
  /// **'COMMAND CENTER'**
  String get commandCenter;

  /// No description provided for @pilot.
  ///
  /// In en, this message translates to:
  /// **'Pilot'**
  String get pilot;

  /// No description provided for @dps.
  ///
  /// In en, this message translates to:
  /// **'DPS'**
  String get dps;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'SCORE'**
  String get score;

  /// No description provided for @nextWeapon.
  ///
  /// In en, this message translates to:
  /// **'NEXT WEAPON'**
  String get nextWeapon;

  /// No description provided for @pointsValue.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String pointsValue(String points);

  /// No description provided for @slotFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get slotFront;

  /// No description provided for @slotLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get slotLeft;

  /// No description provided for @slotRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get slotRight;

  /// No description provided for @slotGen.
  ///
  /// In en, this message translates to:
  /// **'Gen'**
  String get slotGen;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'PWR'**
  String get power;

  /// No description provided for @launchMission.
  ///
  /// In en, this message translates to:
  /// **'LAUNCH MISSION'**
  String get launchMission;

  /// No description provided for @startMission.
  ///
  /// In en, this message translates to:
  /// **'START MISSION'**
  String get startMission;

  /// No description provided for @continueMission.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE MISSION'**
  String get continueMission;

  /// No description provided for @padControlsHint.
  ///
  /// In en, this message translates to:
  /// **'[↑↓] Row   [←→] Select   [B] Buy/Upgrade/Switch   [X/Y] Sell   [OPTIONS] Continue mission'**
  String get padControlsHint;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'HOST'**
  String get host;

  /// No description provided for @hostingAs.
  ///
  /// In en, this message translates to:
  /// **'HOSTING as {name}'**
  String hostingAs(String name);

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'JOIN'**
  String get join;

  /// Weapon family name on a loadout chip. Proper noun — keep identical in every language.
  ///
  /// In en, this message translates to:
  /// **'BUBBLE'**
  String get familyBubble;

  /// Weapon family name on a loadout chip. Proper noun — keep identical in every language.
  ///
  /// In en, this message translates to:
  /// **'VULCAN'**
  String get familyVulcan;

  /// Weapon family name on a loadout chip. Proper noun — keep identical in every language.
  ///
  /// In en, this message translates to:
  /// **'BLASTER'**
  String get familyBlaster;

  /// Weapon family name on a loadout chip. Proper noun — keep identical in every language.
  ///
  /// In en, this message translates to:
  /// **'STAR'**
  String get familyStar;

  /// Weapon family name on a loadout chip. Proper noun — keep identical in every language.
  ///
  /// In en, this message translates to:
  /// **'LASER'**
  String get familyLaser;

  /// No description provided for @overload.
  ///
  /// In en, this message translates to:
  /// **'OVERLOAD'**
  String get overload;

  /// No description provided for @weaponOff.
  ///
  /// In en, this message translates to:
  /// **'{weapon} OFF — generator too weak'**
  String weaponOff(String weapon);

  /// No description provided for @unlocksAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocks at {points} pts'**
  String unlocksAt(String points);

  /// No description provided for @joinConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {target}…'**
  String joinConnecting(String target);

  /// No description provided for @lanJoinFailedBody.
  ///
  /// In en, this message translates to:
  /// **'The host did not answer: {reason}.\n\nBoth players need to be on the same Wi-Fi (a Personal Hotspot works too) and the host must have pressed HOST. Check the address and try again.'**
  String lanJoinFailedBody(String reason);

  /// No description provided for @lanJoinNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'no reply'**
  String get lanJoinNoAnswer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
