import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
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
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
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

  /// Pause-menu toggle for the anonymous gameplay statistics (docs/telemetry.md). Same ON/OFF wording as SOUND and MUSIC.
  ///
  /// In en, this message translates to:
  /// **'USAGE STATS: ON'**
  String get statsOn;

  /// No description provided for @statsOff.
  ///
  /// In en, this message translates to:
  /// **'USAGE STATS: OFF'**
  String get statsOff;

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

  /// No description provided for @objBossUnder.
  ///
  /// In en, this message translates to:
  /// **'Destroy the boss core within {seconds}s of its arrival'**
  String objBossUnder(int seconds);

  /// No description provided for @sectionHangar.
  ///
  /// In en, this message translates to:
  /// **'HANGAR'**
  String get sectionHangar;

  /// No description provided for @sectionVault.
  ///
  /// In en, this message translates to:
  /// **'VAULT'**
  String get sectionVault;

  /// No description provided for @rackSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get rackSide;

  /// No description provided for @rackHull.
  ///
  /// In en, this message translates to:
  /// **'Hull'**
  String get rackHull;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'COMMON'**
  String get rarityCommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'RARE'**
  String get rarityRare;

  /// No description provided for @rarityMythic.
  ///
  /// In en, this message translates to:
  /// **'MYTHIC'**
  String get rarityMythic;

  /// No description provided for @curse.
  ///
  /// In en, this message translates to:
  /// **'CURSE'**
  String get curse;

  /// No description provided for @modFit.
  ///
  /// In en, this message translates to:
  /// **'FIT'**
  String get modFit;

  /// No description provided for @modUnfit.
  ///
  /// In en, this message translates to:
  /// **'UNFIT'**
  String get modUnfit;

  /// No description provided for @modForge.
  ///
  /// In en, this message translates to:
  /// **'FORGE'**
  String get modForge;

  /// No description provided for @forgeHint.
  ///
  /// In en, this message translates to:
  /// **'Pick 3 of one rarity to forge 1 of the next'**
  String get forgeHint;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'No mods yet. Clear a node on full stars, beat a boss fast, or down an endless boss.'**
  String get vaultEmpty;

  /// No description provided for @modNeeds.
  ///
  /// In en, this message translates to:
  /// **'Works with {families}'**
  String modNeeds(String families);

  /// No description provided for @modRackFull.
  ///
  /// In en, this message translates to:
  /// **'Rack full'**
  String get modRackFull;

  /// No description provided for @modAlreadyFitted.
  ///
  /// In en, this message translates to:
  /// **'Already fitted'**
  String get modAlreadyFitted;

  /// No description provided for @modWrongRack.
  ///
  /// In en, this message translates to:
  /// **'Does not fit this rack'**
  String get modWrongRack;

  /// No description provided for @modsSpilled.
  ///
  /// In en, this message translates to:
  /// **'{n} mods back in the vault'**
  String modsSpilled(int n);

  /// No description provided for @hullLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get hullLocked;

  /// No description provided for @hullUnlockBoss.
  ///
  /// In en, this message translates to:
  /// **'Beat campaign boss {n}'**
  String hullUnlockBoss(int n);

  /// No description provided for @hullUnlockFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish the campaign or reach sector 30'**
  String get hullUnlockFinish;

  /// No description provided for @statAgility.
  ///
  /// In en, this message translates to:
  /// **'AGI'**
  String get statAgility;

  /// No description provided for @statHitbox.
  ///
  /// In en, this message translates to:
  /// **'HIT'**
  String get statHitbox;

  /// No description provided for @perkNone.
  ///
  /// In en, this message translates to:
  /// **'Stock ship'**
  String get perkNone;

  /// No description provided for @perkAfterimage.
  ///
  /// In en, this message translates to:
  /// **'Hold still: shots hit ×1.5'**
  String get perkAfterimage;

  /// No description provided for @perkBulwark.
  ///
  /// In en, this message translates to:
  /// **'Damage past the shield is halved'**
  String get perkBulwark;

  /// No description provided for @perkOverclock.
  ///
  /// In en, this message translates to:
  /// **'Fires guns up to 130 % of capacity, slower'**
  String get perkOverclock;

  /// No description provided for @perkBattery.
  ///
  /// In en, this message translates to:
  /// **'A free gun drone rides along'**
  String get perkBattery;

  /// No description provided for @rewardTitle.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get rewardTitle;

  /// No description provided for @newHull.
  ///
  /// In en, this message translates to:
  /// **'New hull: {name}'**
  String newHull(String name);

  /// No description provided for @socketEmpty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get socketEmpty;

  /// No description provided for @fxStreams.
  ///
  /// In en, this message translates to:
  /// **'{n} parallel streams'**
  String fxStreams(int n);

  /// No description provided for @fxFan.
  ///
  /// In en, this message translates to:
  /// **'Fan of {n} shots'**
  String fxFan(int n);

  /// No description provided for @fxSalvo.
  ///
  /// In en, this message translates to:
  /// **'{n}-shot salvo'**
  String fxSalvo(int n);

  /// No description provided for @fxFireRate.
  ///
  /// In en, this message translates to:
  /// **'Fire rate ×{x}'**
  String fxFireRate(String x);

  /// No description provided for @fxDamage.
  ///
  /// In en, this message translates to:
  /// **'Damage ×{x}'**
  String fxDamage(String x);

  /// No description provided for @fxShotSpeed.
  ///
  /// In en, this message translates to:
  /// **'Shot speed ×{x}'**
  String fxShotSpeed(String x);

  /// No description provided for @fxShotSize.
  ///
  /// In en, this message translates to:
  /// **'Shot size ×{x}'**
  String fxShotSize(String x);

  /// No description provided for @fxPower.
  ///
  /// In en, this message translates to:
  /// **'Power use ×{x}'**
  String fxPower(String x);

  /// No description provided for @fxHoming.
  ///
  /// In en, this message translates to:
  /// **'Homing +{n}'**
  String fxHoming(int n);

  /// No description provided for @fxPierce.
  ///
  /// In en, this message translates to:
  /// **'Passes through {n} targets'**
  String fxPierce(int n);

  /// No description provided for @fxPierceAll.
  ///
  /// In en, this message translates to:
  /// **'Passes through everything'**
  String get fxPierceAll;

  /// No description provided for @fxCrit.
  ///
  /// In en, this message translates to:
  /// **'{pct} % chance of ×{x} damage'**
  String fxCrit(int pct, String x);

  /// No description provided for @fxBossCrit.
  ///
  /// In en, this message translates to:
  /// **'×{x} crits on bosses'**
  String fxBossCrit(String x);

  /// No description provided for @fxFork.
  ///
  /// In en, this message translates to:
  /// **'Kills spray {n} shots'**
  String fxFork(int n);

  /// No description provided for @fxChain.
  ///
  /// In en, this message translates to:
  /// **'Spray shots spray again'**
  String get fxChain;

  /// No description provided for @fxSplit.
  ///
  /// In en, this message translates to:
  /// **'Splits in two on a hit'**
  String get fxSplit;

  /// No description provided for @fxFrost.
  ///
  /// In en, this message translates to:
  /// **'Hits slow enemies down'**
  String get fxFrost;

  /// No description provided for @fxCrossfire.
  ///
  /// In en, this message translates to:
  /// **'Side guns lean inward'**
  String get fxCrossfire;

  /// No description provided for @fxRearguard.
  ///
  /// In en, this message translates to:
  /// **'Side guns also fire backward'**
  String get fxRearguard;

  /// No description provided for @fxOrbit.
  ///
  /// In en, this message translates to:
  /// **'Shots weave'**
  String get fxOrbit;

  /// No description provided for @fxBounce.
  ///
  /// In en, this message translates to:
  /// **'Bounces off the walls {n}×'**
  String fxBounce(int n);

  /// No description provided for @fxBounceTop.
  ///
  /// In en, this message translates to:
  /// **'…and off the top'**
  String get fxBounceTop;

  /// No description provided for @fxOverdrive.
  ///
  /// In en, this message translates to:
  /// **'Fires on a power debt'**
  String get fxOverdrive;

  /// No description provided for @fxReactor.
  ///
  /// In en, this message translates to:
  /// **'Over-capacity guns still fire, slowly'**
  String get fxReactor;

  /// No description provided for @fxGenPower.
  ///
  /// In en, this message translates to:
  /// **'Generator recharge ×{x}'**
  String fxGenPower(String x);

  /// No description provided for @fxGenMax.
  ///
  /// In en, this message translates to:
  /// **'Generator capacity ×{x}'**
  String fxGenMax(String x);

  /// No description provided for @fxSurge.
  ///
  /// In en, this message translates to:
  /// **'Full generator: shots ×2'**
  String get fxSurge;

  /// No description provided for @fxSiphon.
  ///
  /// In en, this message translates to:
  /// **'Kills refill {pct} % power'**
  String fxSiphon(int pct);

  /// No description provided for @fxHp.
  ///
  /// In en, this message translates to:
  /// **'Hull ×{x}'**
  String fxHp(String x);

  /// No description provided for @fxShield.
  ///
  /// In en, this message translates to:
  /// **'Shield ×{x}'**
  String fxShield(String x);

  /// No description provided for @fxRegen.
  ///
  /// In en, this message translates to:
  /// **'Shield regen ×{x}'**
  String fxRegen(String x);

  /// No description provided for @fxLeech.
  ///
  /// In en, this message translates to:
  /// **'Kills heal {n} HP'**
  String fxLeech(int n);

  /// No description provided for @fxMagnet.
  ///
  /// In en, this message translates to:
  /// **'Pulls pickups in'**
  String get fxMagnet;

  /// No description provided for @fxMagnetAll.
  ///
  /// In en, this message translates to:
  /// **'Pulls in every pickup'**
  String get fxMagnetAll;

  /// No description provided for @fxReflect.
  ///
  /// In en, this message translates to:
  /// **'{pct} % of shots off the shield fly back'**
  String fxReflect(int pct);

  /// No description provided for @fxReflectGuided.
  ///
  /// In en, this message translates to:
  /// **'Reflected shots home in'**
  String get fxReflectGuided;

  /// No description provided for @fxGhost.
  ///
  /// In en, this message translates to:
  /// **'Untouchable {sec} s after a hull hit'**
  String fxGhost(String sec);

  /// No description provided for @fxNova.
  ///
  /// In en, this message translates to:
  /// **'Shield breaks: the whole screen takes a blast'**
  String get fxNova;

  /// No description provided for @fxAgility.
  ///
  /// In en, this message translates to:
  /// **'Agility ×{x}'**
  String fxAgility(String x);

  /// No description provided for @fxHitbox.
  ///
  /// In en, this message translates to:
  /// **'Hitbox ×{x}'**
  String fxHitbox(String x);

  /// No description provided for @fxCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits ×{x}'**
  String fxCredits(String x);

  /// No description provided for @fxScore.
  ///
  /// In en, this message translates to:
  /// **'Score ×{x}'**
  String fxScore(String x);

  /// No description provided for @fxSatellite.
  ///
  /// In en, this message translates to:
  /// **'A gun drone rides along'**
  String get fxSatellite;

  /// No description provided for @fxTimewarp.
  ///
  /// In en, this message translates to:
  /// **'A hull hit slows time'**
  String get fxTimewarp;

  /// No description provided for @fxGambler.
  ///
  /// In en, this message translates to:
  /// **'Every shot is a random gun'**
  String get fxGambler;

  /// No description provided for @vaultAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get vaultAll;

  /// No description provided for @sigilMissUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown shape'**
  String get sigilMissUnknown;

  /// No description provided for @sigilMissTooSlow.
  ///
  /// In en, this message translates to:
  /// **'too slow'**
  String get sigilMissTooSlow;

  /// No description provided for @sigilMissSkippedDot.
  ///
  /// In en, this message translates to:
  /// **'skipped a dot'**
  String get sigilMissSkippedDot;

  /// No description provided for @sigilMissLeftRimEarly.
  ///
  /// In en, this message translates to:
  /// **'let go too early'**
  String get sigilMissLeftRimEarly;

  /// No description provided for @sigilMissWrongDirection.
  ///
  /// In en, this message translates to:
  /// **'drawn backwards'**
  String get sigilMissWrongDirection;

  /// No description provided for @sigilMissWrongLayer.
  ///
  /// In en, this message translates to:
  /// **'wrong shoulder button'**
  String get sigilMissWrongLayer;

  /// No description provided for @sigilDry.
  ///
  /// In en, this message translates to:
  /// **'not enough charge'**
  String get sigilDry;

  /// No description provided for @sigilBusy.
  ///
  /// In en, this message translates to:
  /// **'previous one still running'**
  String get sigilBusy;

  /// No description provided for @arena.
  ///
  /// In en, this message translates to:
  /// **'ARENA'**
  String get arena;

  /// No description provided for @arenaBossParts.
  ///
  /// In en, this message translates to:
  /// **'BOSS PARTS'**
  String get arenaBossParts;

  /// No description provided for @arenaBareCore.
  ///
  /// In en, this message translates to:
  /// **'bare core'**
  String get arenaBareCore;

  /// No description provided for @arenaCompanions.
  ///
  /// In en, this message translates to:
  /// **'COMPANIONS'**
  String get arenaCompanions;

  /// No description provided for @arenaCharge.
  ///
  /// In en, this message translates to:
  /// **'CHARGE'**
  String get arenaCharge;

  /// No description provided for @arenaChargeNormal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get arenaChargeNormal;

  /// No description provided for @arenaSpeed.
  ///
  /// In en, this message translates to:
  /// **'WORLD SPEED'**
  String get arenaSpeed;

  /// No description provided for @arenaDrill.
  ///
  /// In en, this message translates to:
  /// **'DRILL'**
  String get arenaDrill;

  /// No description provided for @arenaFreePlay.
  ///
  /// In en, this message translates to:
  /// **'FREE PLAY'**
  String get arenaFreePlay;

  /// No description provided for @arenaFight.
  ///
  /// In en, this message translates to:
  /// **'FIGHT'**
  String get arenaFight;

  /// No description provided for @arenaNewBoss.
  ///
  /// In en, this message translates to:
  /// **'NEW BOSS'**
  String get arenaNewBoss;

  /// No description provided for @arenaLeave.
  ///
  /// In en, this message translates to:
  /// **'LEAVE ARENA'**
  String get arenaLeave;

  /// No description provided for @arenaHint.
  ///
  /// In en, this message translates to:
  /// **'The boss comes back the moment it dies. Nothing here is saved.'**
  String get arenaHint;

  /// No description provided for @arenaColCast.
  ///
  /// In en, this message translates to:
  /// **'CAST'**
  String get arenaColCast;

  /// No description provided for @arenaColMiss.
  ///
  /// In en, this message translates to:
  /// **'MISS'**
  String get arenaColMiss;

  /// No description provided for @arenaColAvg.
  ///
  /// In en, this message translates to:
  /// **'AVG'**
  String get arenaColAvg;

  /// No description provided for @arenaColBest.
  ///
  /// In en, this message translates to:
  /// **'BEST'**
  String get arenaColBest;

  /// No description provided for @arenaColTime.
  ///
  /// In en, this message translates to:
  /// **'FASTEST'**
  String get arenaColTime;

  /// No description provided for @arenaSummary.
  ///
  /// In en, this message translates to:
  /// **'Bosses {bosses} · K.O. {knockouts}'**
  String arenaSummary(int bosses, int knockouts);

  /// No description provided for @padSchemeSigil.
  ///
  /// In en, this message translates to:
  /// **'PAD: SIGILS'**
  String get padSchemeSigil;

  /// No description provided for @padSchemeClassic.
  ///
  /// In en, this message translates to:
  /// **'PAD: CLASSIC'**
  String get padSchemeClassic;

  /// No description provided for @padSouthpawOn.
  ///
  /// In en, this message translates to:
  /// **'LEFT-HANDED: ON'**
  String get padSouthpawOn;

  /// No description provided for @padSouthpawOff.
  ///
  /// In en, this message translates to:
  /// **'LEFT-HANDED: OFF'**
  String get padSouthpawOff;

  /// No description provided for @sigilDescHop.
  ///
  /// In en, this message translates to:
  /// **'A quick hop the way you flick'**
  String get sigilDescHop;

  /// No description provided for @sigilDescSidestep.
  ///
  /// In en, this message translates to:
  /// **'A long sidestep across the field'**
  String get sigilDescSidestep;

  /// No description provided for @sigilDescStrike.
  ///
  /// In en, this message translates to:
  /// **'Lunge forward with three heavy shots, then back'**
  String get sigilDescStrike;

  /// No description provided for @sigilDescRetreat.
  ///
  /// In en, this message translates to:
  /// **'Fall back while covering fire goes forward'**
  String get sigilDescRetreat;

  /// No description provided for @sigilDescDash.
  ///
  /// In en, this message translates to:
  /// **'A diagonal dash through fire, untouchable midway'**
  String get sigilDescDash;

  /// No description provided for @sigilDescRoll.
  ///
  /// In en, this message translates to:
  /// **'A barrel roll to the side, untouchable'**
  String get sigilDescRoll;

  /// No description provided for @sigilDescShadow.
  ///
  /// In en, this message translates to:
  /// **'Lock under the nearest enemy and keep firing'**
  String get sigilDescShadow;

  /// No description provided for @sigilDescEcho.
  ///
  /// In en, this message translates to:
  /// **'A shadow replays your last two seconds at half damage'**
  String get sigilDescEcho;

  /// No description provided for @sigilDescLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop over the top: shots pass beneath you'**
  String get sigilDescLoop;

  /// No description provided for @sigilDescSlalom.
  ///
  /// In en, this message translates to:
  /// **'An S-curve across the field with fanned fire'**
  String get sigilDescSlalom;

  /// No description provided for @sigilDescCorkscrew.
  ///
  /// In en, this message translates to:
  /// **'Corkscrew forward firing all around, untouchable'**
  String get sigilDescCorkscrew;

  /// No description provided for @sigilDescSnapshot.
  ///
  /// In en, this message translates to:
  /// **'One heavy shot the way you flick'**
  String get sigilDescSnapshot;

  /// No description provided for @sigilDescBroadside.
  ///
  /// In en, this message translates to:
  /// **'A salvo out of both flanks'**
  String get sigilDescBroadside;

  /// No description provided for @sigilDescVolley.
  ///
  /// In en, this message translates to:
  /// **'Five charged rays forward'**
  String get sigilDescVolley;

  /// No description provided for @sigilDescCaltrop.
  ///
  /// In en, this message translates to:
  /// **'Drop a mine that swallows shots and blows up'**
  String get sigilDescCaltrop;

  /// No description provided for @sigilDescFrenzy.
  ///
  /// In en, this message translates to:
  /// **'Guns fire faster for a few seconds'**
  String get sigilDescFrenzy;

  /// No description provided for @sigilDescStasis.
  ///
  /// In en, this message translates to:
  /// **'Enemies and their shots slow to half speed'**
  String get sigilDescStasis;

  /// No description provided for @sigilDescHalo.
  ///
  /// In en, this message translates to:
  /// **'Shield recharges four times faster and nothing gets through'**
  String get sigilDescHalo;

  /// No description provided for @sigilDescRadial.
  ///
  /// In en, this message translates to:
  /// **'A ring of sixteen shots'**
  String get sigilDescRadial;

  /// No description provided for @sigilDescStorm.
  ///
  /// In en, this message translates to:
  /// **'Every gun fires flat out, for free'**
  String get sigilDescStorm;

  /// No description provided for @sigilDescPing.
  ///
  /// In en, this message translates to:
  /// **'Companions focus fire where you flick'**
  String get sigilDescPing;

  /// No description provided for @sigilDescWingman.
  ///
  /// In en, this message translates to:
  /// **'Call a wingman to the flank you drew toward'**
  String get sigilDescWingman;

  /// No description provided for @sigilDescHunter.
  ///
  /// In en, this message translates to:
  /// **'Call a hunter that flies ahead and picks targets'**
  String get sigilDescHunter;

  /// No description provided for @sigilDescWarden.
  ///
  /// In en, this message translates to:
  /// **'Call a warden that takes the shots meant for you'**
  String get sigilDescWarden;

  /// No description provided for @sigilDescFormation.
  ///
  /// In en, this message translates to:
  /// **'Companions switch between wide and wedge'**
  String get sigilDescFormation;

  /// No description provided for @sigilDescWhirl.
  ///
  /// In en, this message translates to:
  /// **'Companions circle you and eat shots'**
  String get sigilDescWhirl;

  /// No description provided for @sigilDescSacrifice.
  ///
  /// In en, this message translates to:
  /// **'Companions dive and explode, paying charge back'**
  String get sigilDescSacrifice;

  /// No description provided for @grimoire.
  ///
  /// In en, this message translates to:
  /// **'GRIMOIRE'**
  String get grimoire;

  /// No description provided for @grimoireHint.
  ///
  /// In en, this message translates to:
  /// **'Draw with the right stick. Hold LB for ARMS, RB for WING, both for MEGA BLAST.'**
  String get grimoireHint;

  /// No description provided for @sigilCost.
  ///
  /// In en, this message translates to:
  /// **'cost {cost}'**
  String sigilCost(int cost);

  /// No description provided for @sigilUntouchable.
  ///
  /// In en, this message translates to:
  /// **'untouchable'**
  String get sigilUntouchable;

  /// No description provided for @lessonWatch.
  ///
  /// In en, this message translates to:
  /// **'WATCH'**
  String get lessonWatch;

  /// No description provided for @lessonTrace.
  ///
  /// In en, this message translates to:
  /// **'TRACE IT'**
  String get lessonTrace;

  /// No description provided for @lessonSlow.
  ///
  /// In en, this message translates to:
  /// **'SLOW'**
  String get lessonSlow;

  /// No description provided for @lessonLive.
  ///
  /// In en, this message translates to:
  /// **'FULL SPEED'**
  String get lessonLive;

  /// No description provided for @lessonStreak.
  ///
  /// In en, this message translates to:
  /// **'FIVE IN A ROW'**
  String get lessonStreak;

  /// No description provided for @lessonLearned.
  ///
  /// In en, this message translates to:
  /// **'LEARNED'**
  String get lessonLearned;

  /// No description provided for @lessonTempo.
  ///
  /// In en, this message translates to:
  /// **'TEMPO {pct} %'**
  String lessonTempo(int pct);

  /// No description provided for @hintHop.
  ///
  /// In en, this message translates to:
  /// **'Flick the right stick'**
  String get hintHop;

  /// No description provided for @hintLoop.
  ///
  /// In en, this message translates to:
  /// **'Draw a circle: you fly over the shots'**
  String get hintLoop;

  /// No description provided for @hintStream.
  ///
  /// In en, this message translates to:
  /// **'Squeeze LT: two or three streams'**
  String get hintStream;

  /// No description provided for @arenaKata.
  ///
  /// In en, this message translates to:
  /// **'KATA'**
  String get arenaKata;

  /// No description provided for @arenaKataOff.
  ///
  /// In en, this message translates to:
  /// **'NONE'**
  String get arenaKataOff;

  /// No description provided for @kataNext.
  ///
  /// In en, this message translates to:
  /// **'next {sigil} in {secs} s'**
  String kataNext(String sigil, String secs);

  /// No description provided for @arenaGauntlet.
  ///
  /// In en, this message translates to:
  /// **'GAUNTLET'**
  String get arenaGauntlet;

  /// No description provided for @arenaOn.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get arenaOn;

  /// No description provided for @arenaOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get arenaOff;

  /// No description provided for @gauntletRating.
  ///
  /// In en, this message translates to:
  /// **'Rating {rating} · best {best}'**
  String gauntletRating(int rating, int best);

  /// No description provided for @duelWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get duelWarning;

  /// No description provided for @duelHintPad1.
  ///
  /// In en, this message translates to:
  /// **'Right stick aims and fires'**
  String get duelHintPad1;

  /// No description provided for @duelHintPad2Rt.
  ///
  /// In en, this message translates to:
  /// **'Hold RT, LB or RB: the right stick draws sigils'**
  String get duelHintPad2Rt;

  /// No description provided for @duelHintPad2Lt.
  ///
  /// In en, this message translates to:
  /// **'Hold LT, LB or RB: the right stick draws sigils'**
  String get duelHintPad2Lt;

  /// No description provided for @duelHintClassic.
  ///
  /// In en, this message translates to:
  /// **'Left stick flies · B, RB or RT fire where the nose points'**
  String get duelHintClassic;

  /// No description provided for @duelHintKeys1.
  ///
  /// In en, this message translates to:
  /// **'Arrows aim and fire · WASD flies'**
  String get duelHintKeys1;

  /// No description provided for @duelHintKeys2.
  ///
  /// In en, this message translates to:
  /// **'Space fires where the nose points · the numpad draws sigils'**
  String get duelHintKeys2;

  /// No description provided for @arenaDuelBinding.
  ///
  /// In en, this message translates to:
  /// **'DUEL STANCE'**
  String get arenaDuelBinding;

  /// No description provided for @duelBindingRt.
  ///
  /// In en, this message translates to:
  /// **'RT + STICK'**
  String get duelBindingRt;

  /// No description provided for @duelBindingLt.
  ///
  /// In en, this message translates to:
  /// **'LT + STICK'**
  String get duelBindingLt;

  /// No description provided for @arenaDuelFrame.
  ///
  /// In en, this message translates to:
  /// **'PAD FORWARD'**
  String get arenaDuelFrame;

  /// No description provided for @duelFrameNose.
  ///
  /// In en, this message translates to:
  /// **'THE NOSE'**
  String get duelFrameNose;

  /// No description provided for @duelFrameUp.
  ///
  /// In en, this message translates to:
  /// **'UP'**
  String get duelFrameUp;

  /// No description provided for @arenaDuelAimFires.
  ///
  /// In en, this message translates to:
  /// **'AIMING FIRES'**
  String get arenaDuelAimFires;

  /// No description provided for @duelCutInFirst.
  ///
  /// In en, this message translates to:
  /// **'BOSS CLOSE-UP: FIRST TIME'**
  String get duelCutInFirst;

  /// No description provided for @duelCutInAlways.
  ///
  /// In en, this message translates to:
  /// **'BOSS CLOSE-UP: ALWAYS'**
  String get duelCutInAlways;

  /// No description provided for @duelCutInNever.
  ///
  /// In en, this message translates to:
  /// **'BOSS CLOSE-UP: NEVER'**
  String get duelCutInNever;

  /// No description provided for @arenaDuelDrill.
  ///
  /// In en, this message translates to:
  /// **'DUEL DRILL'**
  String get arenaDuelDrill;

  /// No description provided for @duelDrillOff.
  ///
  /// In en, this message translates to:
  /// **'NONE'**
  String get duelDrillOff;

  /// No description provided for @duelDrillAim.
  ///
  /// In en, this message translates to:
  /// **'AIM AND FIRE'**
  String get duelDrillAim;

  /// No description provided for @duelDrillAimHow.
  ///
  /// In en, this message translates to:
  /// **'Point the right stick at the boss and hit it'**
  String get duelDrillAimHow;

  /// No description provided for @duelDrillHold.
  ///
  /// In en, this message translates to:
  /// **'HOLD THE NOSE'**
  String get duelDrillHold;

  /// No description provided for @duelDrillHoldHow.
  ///
  /// In en, this message translates to:
  /// **'Hold a stance button and fly: the nose stays put'**
  String get duelDrillHoldHow;

  /// No description provided for @duelDrillDraw.
  ///
  /// In en, this message translates to:
  /// **'DRAW FORWARD'**
  String get duelDrillDraw;

  /// No description provided for @duelDrillDrawHow.
  ///
  /// In en, this message translates to:
  /// **'In the stance, draw a sigil toward the boss'**
  String get duelDrillDrawHow;

  /// No description provided for @duelDrillTurn.
  ///
  /// In en, this message translates to:
  /// **'TURN ROUND'**
  String get duelDrillTurn;

  /// No description provided for @duelDrillTurnHow.
  ///
  /// In en, this message translates to:
  /// **'The boss is below you: turn the nose and hit it'**
  String get duelDrillTurnHow;

  /// No description provided for @duelDrillDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get duelDrillDone;

  /// ComCenter, touch only: a second finger in flight swaps to the alternate weapons (plan 32 Q3)
  ///
  /// In en, this message translates to:
  /// **'Tap a second finger to swap weapons'**
  String get swapHint;
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
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
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

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
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
