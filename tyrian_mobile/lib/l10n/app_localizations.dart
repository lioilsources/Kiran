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

  /// No description provided for @connectToHost.
  ///
  /// In en, this message translates to:
  /// **'Connect to host'**
  String get connectToHost;

  /// No description provided for @hostingAt.
  ///
  /// In en, this message translates to:
  /// **'HOSTING  {ip}'**
  String hostingAt(String ip);

  /// No description provided for @ipValue.
  ///
  /// In en, this message translates to:
  /// **'IP: {ip}'**
  String ipValue(String ip);

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
