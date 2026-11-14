// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദാക്കൂ';

  @override
  String get connect => 'ബന്ധിപ്പിക്കൂ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName ലേക്ക് ബന്ധിപ്പിക്കാനായില്ല';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ഹോസ്റ്റ് കാണാമായിരുന്നു, പക്ഷേ ലിങ്ക് ഉണ്ടായില്ല.\n\nസമീപത്തെ കളിക്ക് പിയർ-ടു-പിയർ വൈ-ഫൈ വേണം; പേഴ്സണൽ ഹോട്ട്സ്പോട്ട് ഓണായിരിക്കുമ്പോൾ iOS അത് ഓഫാക്കും. രണ്ട് ഉപകരണങ്ങളിലും ഹോട്ട്സ്പോട്ട് ഓഫാക്കി വീണ്ടും ശ്രമിക്കൂ, അല്ലെങ്കിൽ രണ്ടും ഒരേ വൈ-ഫൈയിൽ ആക്കൂ.';

  @override
  String get gameOverCampaign =>
      'ദൗത്യം പരാജയപ്പെട്ടു — ലോഡ്ഔട്ടും ക്രെഡിറ്റും നിലനിർത്തി. കോം സെന്ററിൽ നിന്ന് വീണ്ടും ശ്രമിക്കൂ.';

  @override
  String get gameOverEndless =>
      'സെക്ടർ 1 ൽ പുനർനിർമ്മാണം — ലോഡ്ഔട്ടും ക്രെഡിറ്റും നിലനിർത്തി';

  @override
  String get waitingForHost => 'ഹോസ്റ്റിനായി കാത്തിരിക്കുന്നു...';

  @override
  String get waitingForHostHint => 'ഹോസ്റ്റ് തയ്യാറാകുമ്പോൾ കളി തുടങ്ങും';

  @override
  String get vesselLost => 'യാനം നഷ്ടമായി';

  @override
  String scoreValue(String score) {
    return 'സ്കോർ: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'ക്രെഡിറ്റ്: $credits';
  }

  @override
  String get creditsPrefix => 'ക്രെഡിറ്റ്:';

  @override
  String get leaderboard => 'ലീഡർബോർഡ്';

  @override
  String get achievements => 'നേട്ടങ്ങൾ';

  @override
  String get redeploy => 'വീണ്ടും വിന്യസിക്കൂ';

  @override
  String get resume => 'തുടരൂ';

  @override
  String get pause => 'നിർത്തൂ';

  @override
  String get paused => 'നിർത്തിവച്ചു';

  @override
  String get skins => 'സ്കിന്നുകൾ';

  @override
  String get skin => 'സ്കിൻ';

  @override
  String get soundOn => 'ശബ്ദം: ഓൺ';

  @override
  String get soundOff => 'ശബ്ദം: ഓഫ്';

  @override
  String get musicOn => 'സംഗീതം: ഓൺ';

  @override
  String get musicOff => 'സംഗീതം: ഓഫ്';

  @override
  String get statsOn => 'സ്ഥിതിവിവരം: ഓൺ';

  @override
  String get statsOff => 'സ്ഥിതിവിവരം: ഓഫ്';

  @override
  String get mainMenu => 'പ്രധാന മെനു';

  @override
  String get quitToDesktop => 'ഡെസ്ക്ടോപ്പിലേക്ക് പുറത്തുകടക്കൂ';

  @override
  String get selectSkin => 'സ്കിൻ തിരഞ്ഞെടുക്കൂ';

  @override
  String get difficulty => 'ബുദ്ധിമുട്ട്';

  @override
  String get difficultyEasy => 'എളുപ്പം';

  @override
  String get difficultyNormal => 'സാധാരണം';

  @override
  String get difficultyHard => 'കഠിനം';

  @override
  String get difficultyLord => 'ലോർഡ്';

  @override
  String get campaign => 'കാമ്പെയ്ൻ';

  @override
  String get quit => 'പുറത്തുകടക്കൂ';

  @override
  String get restorePurchases => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കൂ';

  @override
  String get locked => 'ലോക്ക് ചെയ്തു';

  @override
  String get mainMenuTooltip => 'പ്രധാന മെനു';

  @override
  String nodeLevel(int level) {
    return 'ലെവൽ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ലെവൽ $level · ബോസ് $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'ലോക്ക് ചെയ്തു. അതിന് മുമ്പത്തെ നോഡ് പൂർത്തിയാക്കൂ.';

  @override
  String get flyAgain => 'വീണ്ടും പറക്കൂ';

  @override
  String get launch => 'വിക്ഷേപിക്കൂ';

  @override
  String zoneLabel(int zone) {
    return 'സോൺ $zone';
  }

  @override
  String get objectiveStar => 'നക്ഷത്രം';

  @override
  String get continueButton => 'തുടരൂ';

  @override
  String get replayNode => 'നോഡ് വീണ്ടും കളിക്കൂ';

  @override
  String get retry => 'വീണ്ടും ശ്രമിക്കൂ';

  @override
  String get nodeCleared => 'നോഡ് പൂർത്തിയായി';

  @override
  String get nodeFailed => 'നോഡ് പരാജയപ്പെട്ടു';

  @override
  String get weaponTierUnlocked => 'ആയുധ തലം അൺലോക്ക് ചെയ്തു';

  @override
  String get onSaleInComCenter => 'കോം സെന്ററിൽ വിൽപ്പനയ്ക്കുണ്ട്.';

  @override
  String get requiredTasksHint =>
      'ആവശ്യമായ ടാസ്കുകൾ നോഡിന്റെ ഫലം തീരുമാനിക്കും. വീണ്ടും പറക്കൂ — നേടിയത് നിങ്ങളോടൊപ്പം തന്നെ നിൽക്കും.';

  @override
  String get objClear => 'സെക്ടർ ക്ലിയർ ചെയ്യൂ';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ശത്രുക്കളെ വെടിവച്ചിടൂ',
      one: '$count ശത്രുവിനെ വെടിവച്ചിടൂ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ഹളിന് കേടുപാട് വരുത്തരുത്';

  @override
  String objHull(int percent) {
    return '$percent% ഹളിന് മുകളിൽ പൂർത്തിയാക്കൂ';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon കൊണ്ട് $count ശത്രുക്കളെ കൊല്ലൂ',
      one: '$weapon കൊണ്ട് $count ശത്രുവിനെ കൊല്ലൂ',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'വശത്തെ തോക്കുകൾ കൊണ്ട് $count ശത്രുക്കളെ കൊല്ലൂ',
      one: 'വശത്തെ തോക്കുകൾ കൊണ്ട് $count ശത്രുവിനെ കൊല്ലൂ',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon മുൻവശത്ത് ഘടിപ്പിച്ച് വിക്ഷേപിക്കൂ';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon വശത്തെ മൗണ്ടിൽ ഘടിപ്പിച്ച് വിക്ഷേപിക്കൂ';
  }

  @override
  String get objBuySideGun => 'കോം സെന്ററിൽ ഒരു വശത്തെ തോക്ക് വാങ്ങൂ';

  @override
  String objUpgradeGenerator(int level) {
    return 'ജനറേറ്റർ ലെവൽ $level ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യൂ';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'മുൻ തോക്ക് ലെവൽ $level ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യൂ';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ഒരു വശത്തെ തോക്ക് ലെവൽ $level ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യൂ';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പിക്കപ്പുകൾ പിടിക്കൂ',
      one: '$count പിക്കപ്പ് പിടിക്കൂ',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മുഴുവൻ വ്യൂഹങ്ങളെയും തുടച്ചുനീക്കൂ',
      one: '$count മുഴുവൻ വ്യൂഹത്തെയും തുടച്ചുനീക്കൂ',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'ഒരു ഛിന്നഗ്രഹത്തിലും ഇടിക്കരുത്';

  @override
  String objUnderTime(int seconds) {
    return '${seconds}s നുള്ളിൽ പൂർത്തിയാക്കൂ';
  }

  @override
  String get objStripBoss =>
      'കോറിന് മുമ്പ് ബോസിന്റെ എല്ലാ ഭാഗങ്ങളും നശിപ്പിക്കൂ';

  @override
  String get joinCoopTitle => 'കോ-ഓപ്പിൽ ചേരൂ';

  @override
  String get cannotSearchNetwork => 'ഈ നെറ്റ്‌വർക്കിൽ തിരയാനാവില്ല';

  @override
  String get joinHintNearby =>
      'ഒരേ വൈ-ഫൈ എല്ലാ ഉപകരണങ്ങളിലും പ്രവർത്തിക്കും. iPhone, iPad, Mac എന്നിവ വൈ-ഫൈ ഇല്ലാതെയും സമീപത്ത് പരസ്പരം കണ്ടെത്തും — രണ്ടിലും പേഴ്സണൽ ഹോട്ട്സ്പോട്ട് ഓഫായിരിക്കണം.';

  @override
  String get joinHintWifi =>
      'രണ്ട് കളിക്കാരും ഒരേ വൈ-ഫൈയിൽ ആയിരിക്കണം — പേഴ്സണൽ ഹോട്ട്സ്പോട്ടും മതി.';

  @override
  String noHostsYet(String hint) {
    return 'ഇതുവരെ ഹോസ്റ്റുകളില്ല. $hint';
  }

  @override
  String get lookingForHosts => 'ഈ വൈ-ഫൈയിലും സമീപത്തും ഹോസ്റ്റുകളെ തിരയുന്നു…';

  @override
  String get hostNearby => 'സമീപത്ത് · ബ്ലൂടൂത്ത് / പിയർ-ടു-പിയർ വൈ-ഫൈ';

  @override
  String hostSameWifi(String address) {
    return '$address · അതേ വൈ-ഫൈ';
  }

  @override
  String get enterIpManually => 'IP സ്വമേധയാ നൽകൂ';

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
    return '$name — പരിചയുള്ളത്';
  }

  @override
  String get bossPartTurret => 'തോക്ക് ഗോപുരം';

  @override
  String get bossPartShieldPod => 'പരിച പോഡ്';

  @override
  String get bossPartThruster => 'ത്രസ്റ്റർ';

  @override
  String get bossPartCannon => 'പീരങ്കി';

  @override
  String sectorUnknownSpace(int level) {
    return 'സെക്ടർ $level — അജ്ഞാത ബഹിരാകാശം';
  }

  @override
  String get player2Joined => 'കളിക്കാരൻ 2 ചേർന്നു!';

  @override
  String get player2Disconnected => 'കളിക്കാരൻ 2 വിച്ഛേദിച്ചു';

  @override
  String get hostDisconnected => 'ഹോസ്റ്റ് വിച്ഛേദിച്ചു';

  @override
  String maxLevelSold(String amount) {
    return 'പരമാവധി ലെവൽ! \$$amount ന് വിറ്റു';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ആയുധ ലെവൽ $tier അൺലോക്ക് ചെയ്തു';
  }

  @override
  String get cheatsEnabled => 'ചീറ്റുകൾ ഓണാക്കി';

  @override
  String get cheatsDisabled => 'ചീറ്റുകൾ ഓഫാക്കി';

  @override
  String get cheatsMaxed =>
      'ചീറ്റ്: ക്രെഡിറ്റ് പരമാവധി, എല്ലാ ആയുധങ്ങളും അൺലോക്ക്';

  @override
  String get cheats => 'ചീറ്റുകൾ';

  @override
  String get maxCredits => 'പരമാവധി ക്രെഡിറ്റ്';

  @override
  String get sectionStats => 'കണക്കുകൾ';

  @override
  String get sectionLoadout => 'ലോഡ്ഔട്ട്';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'അപ്ഗ്രേഡ്';

  @override
  String get sell => 'വിൽക്കൂ';

  @override
  String get buy => 'വാങ്ങൂ';

  @override
  String get commandCenter => 'കമാൻഡ് സെന്റർ';

  @override
  String get pilot => 'പൈലറ്റ്';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'സ്കോർ';

  @override
  String get nextWeapon => 'അടുത്ത ആയുധം';

  @override
  String pointsValue(String points) {
    return '$points പോയിന്റ്';
  }

  @override
  String get slotFront => 'മുൻവശം';

  @override
  String get slotLeft => 'ഇടത്';

  @override
  String get slotRight => 'വലത്';

  @override
  String get slotGen => 'ജനറേറ്റർ';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'ദൗത്യം വിക്ഷേപിക്കൂ';

  @override
  String get startMission => 'ദൗത്യം തുടങ്ങൂ';

  @override
  String get continueMission => 'ദൗത്യം തുടരൂ';

  @override
  String get padControlsHint =>
      '[↑↓] വരി   [←→] തിരഞ്ഞെടുക്കൂ   [B] വാങ്ങൂ/അപ്ഗ്രേഡ്/മാറ്റൂ   [X/Y] വിൽക്കൂ   [OPTIONS] ദൗത്യം തുടരൂ';

  @override
  String get host => 'ഹോസ്റ്റ്';

  @override
  String hostingAs(String name) {
    return '$name ആയി ഹോസ്റ്റ് ചെയ്യുന്നു';
  }

  @override
  String get join => 'ചേരൂ';

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
  String get overload => 'ഓവർലോഡ്';

  @override
  String weaponOff(String weapon) {
    return '$weapon ഓഫ് — ജനറേറ്റർ ദുർബലം';
  }

  @override
  String unlocksAt(String points) {
    return '$points പോയിന്റിൽ അൺലോക്ക് ആകും';
  }

  @override
  String joinConnecting(String target) {
    return '$target ലേക്ക് ബന്ധിപ്പിക്കുന്നു…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ഹോസ്റ്റ് മറുപടി നൽകിയില്ല: $reason.\n\nരണ്ട് കളിക്കാരും ഒരേ വൈ-ഫൈയിൽ ആയിരിക്കണം (പേഴ്സണൽ ഹോട്ട്സ്പോട്ടും മതി), ഹോസ്റ്റ് HOST അമർത്തിയിരിക്കണം. വിലാസം പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കൂ.';
  }

  @override
  String get lanJoinNoAnswer => 'മറുപടിയില്ല';

  @override
  String objBossUnder(int seconds) {
    return 'ബോസ് എത്തി ${seconds}s നുള്ളിൽ അതിന്റെ കോർ നശിപ്പിക്കൂ';
  }

  @override
  String get sectionHangar => 'ഹാംഗർ';

  @override
  String get sectionVault => 'വോൾട്ട്';

  @override
  String get rackSide => 'വശം';

  @override
  String get rackHull => 'ഹൾ';

  @override
  String get rarityCommon => 'സാധാരണം';

  @override
  String get rarityRare => 'അപൂർവം';

  @override
  String get rarityMythic => 'ഇതിഹാസം';

  @override
  String get curse => 'ശാപം';

  @override
  String get modFit => 'യോജിക്കും';

  @override
  String get modUnfit => 'യോജിക്കില്ല';

  @override
  String get modForge => 'നിർമ്മിക്കൂ';

  @override
  String get forgeHint =>
      'ഒരേ അപൂർവതയിലുള്ള 3 എണ്ണം തിരഞ്ഞെടുത്ത് അടുത്ത തലത്തിലെ 1 നിർമ്മിക്കൂ';

  @override
  String get vaultEmpty =>
      'ഇതുവരെ മോഡുകളില്ല. മുഴുവൻ നക്ഷത്രങ്ങളോടെ നോഡ് പൂർത്തിയാക്കൂ, ബോസിനെ വേഗം തോൽപ്പിക്കൂ, അല്ലെങ്കിൽ അനന്തമായ ബോസിനെ വീഴ്ത്തൂ.';

  @override
  String modNeeds(String families) {
    return '$families ഉപയോഗിച്ച് പ്രവർത്തിക്കും';
  }

  @override
  String get modRackFull => 'റാക്ക് നിറഞ്ഞു';

  @override
  String get modAlreadyFitted => 'ഇതിനകം ഘടിപ്പിച്ചു';

  @override
  String get modWrongRack => 'ഈ റാക്കിന് യോജിക്കില്ല';

  @override
  String modsSpilled(int n) {
    return '$n മോഡുകൾ വോൾട്ടിലേക്ക് മടങ്ങി';
  }

  @override
  String get hullLocked => 'ലോക്ക് ചെയ്തു';

  @override
  String hullUnlockBoss(int n) {
    return 'കാമ്പെയ്ൻ ബോസ് $n നെ തോൽപ്പിക്കൂ';
  }

  @override
  String get hullUnlockFinish =>
      'കാമ്പെയ്ൻ പൂർത്തിയാക്കൂ അല്ലെങ്കിൽ സെക്ടർ 30 എത്തൂ';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'സ്റ്റോക്ക് യാനം';

  @override
  String get perkAfterimage => 'അനങ്ങാതെ നിൽക്കൂ: ഷോട്ടുകൾ ×1.5';

  @override
  String get perkBulwark => 'പരിചയ്ക്ക് അപ്പുറം വരുന്ന കേടുപാട് പകുതിയാകും';

  @override
  String get perkOverclock =>
      'ശേഷിയുടെ 130 % വരെ തോക്കുകൾ വെടിവയ്ക്കും, മെല്ലെ';

  @override
  String get perkBattery => 'ഒരു സൗജന്യ ഗൺ ഡ്രോൺ കൂടെ വരും';

  @override
  String get rewardTitle => 'സമ്മാനം';

  @override
  String newHull(String name) {
    return 'പുതിയ ഹൾ: $name';
  }

  @override
  String get socketEmpty => 'ശൂന്യം';

  @override
  String fxStreams(int n) {
    return '$n സമാന്തര പ്രവാഹങ്ങൾ';
  }

  @override
  String fxFan(int n) {
    return '$n ഷോട്ടുകളുടെ വിശറി';
  }

  @override
  String fxSalvo(int n) {
    return '$n-ഷോട്ട് സാൽവോ';
  }

  @override
  String fxFireRate(String x) {
    return 'വെടിവയ്പ്പ് നിരക്ക് ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'കേടുപാട് ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'ഷോട്ട് വേഗത ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'ഷോട്ട് വലിപ്പം ×$x';
  }

  @override
  String fxPower(String x) {
    return 'പവർ ഉപയോഗം ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'ഹോമിംഗ് +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n ലക്ഷ്യങ്ങളിലൂടെ കടന്നുപോകും';
  }

  @override
  String get fxPierceAll => 'എല്ലാറ്റിലൂടെയും കടന്നുപോകും';

  @override
  String fxCrit(int pct, String x) {
    return '×$x കേടുപാടിന് $pct % സാധ്യത';
  }

  @override
  String fxBossCrit(String x) {
    return 'ബോസുകളിൽ ×$x ക്രിറ്റുകൾ';
  }

  @override
  String fxFork(int n) {
    return 'കൊലകൾ $n ഷോട്ടുകൾ ചിതറിക്കും';
  }

  @override
  String get fxChain => 'ചിതറിയ ഷോട്ടുകൾ വീണ്ടും ചിതറും';

  @override
  String get fxSplit => 'തട്ടിയാൽ രണ്ടായി പിളരും';

  @override
  String get fxFrost => 'ഹിറ്റുകൾ ശത്രുക്കളെ മന്ദഗതിയിലാക്കും';

  @override
  String get fxCrossfire => 'വശത്തെ തോക്കുകൾ ഉള്ളിലേക്ക് ചായും';

  @override
  String get fxRearguard => 'വശത്തെ തോക്കുകൾ പിന്നിലേക്കും വെടിവയ്ക്കും';

  @override
  String get fxOrbit => 'ഷോട്ടുകൾ പിണഞ്ഞ് പോകും';

  @override
  String fxBounce(int n) {
    return 'ഭിത്തികളിൽ $n× തട്ടിത്തെറിക്കും';
  }

  @override
  String get fxBounceTop => '…മുകൾഭാഗത്തും തട്ടിത്തെറിക്കും';

  @override
  String get fxOverdrive => 'പവർ കടത്തിൽ വെടിവയ്ക്കും';

  @override
  String get fxReactor => 'ശേഷി കവിഞ്ഞ തോക്കുകളും മെല്ലെ വെടിവയ്ക്കും';

  @override
  String fxGenPower(String x) {
    return 'ജനറേറ്റർ റീചാർജ് ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ജനറേറ്റർ ശേഷി ×$x';
  }

  @override
  String get fxSurge => 'ജനറേറ്റർ നിറഞ്ഞാൽ: ഷോട്ടുകൾ ×2';

  @override
  String fxSiphon(int pct) {
    return 'കൊലകൾ $pct % പവർ നിറയ്ക്കും';
  }

  @override
  String fxHp(String x) {
    return 'ഹൾ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'പരിച ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'പരിച പുനരുജ്ജീവനം ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'കൊലകൾ $n HP സുഖപ്പെടുത്തും';
  }

  @override
  String get fxMagnet => 'പിക്കപ്പുകൾ വലിച്ചടുപ്പിക്കും';

  @override
  String get fxMagnetAll => 'എല്ലാ പിക്കപ്പുകളും വലിച്ചടുപ്പിക്കും';

  @override
  String fxReflect(int pct) {
    return 'പരിചയിൽ തട്ടിയ ഷോട്ടുകളുടെ $pct % തിരികെ പറക്കും';
  }

  @override
  String get fxReflectGuided => 'പ്രതിഫലിച്ച ഷോട്ടുകൾ ലക്ഷ്യം തേടും';

  @override
  String fxGhost(String sec) {
    return 'ഹള്ളിൽ അടി കിട്ടിയാൽ $sec s സ്പർശിക്കാനാവില്ല';
  }

  @override
  String get fxNova => 'പരിച പൊട്ടിയാൽ: സ്ക്രീൻ മുഴുവൻ സ്ഫോടനം';

  @override
  String fxAgility(String x) {
    return 'ചടുലത ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ഹിറ്റ്ബോക്സ് ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'ക്രെഡിറ്റ് ×$x';
  }

  @override
  String fxScore(String x) {
    return 'സ്കോർ ×$x';
  }

  @override
  String get fxSatellite => 'ഒരു ഗൺ ഡ്രോൺ കൂടെ വരും';

  @override
  String get fxTimewarp => 'ഹള്ളിൽ അടി കിട്ടിയാൽ സമയം മന്ദഗതിയിലാകും';

  @override
  String get fxGambler => 'ഓരോ ഷോട്ടും ക്രമരഹിത തോക്കാണ്';

  @override
  String get vaultAll => 'എല്ലാം';

  @override
  String get sigilMissUnknown => 'അജ്ഞാത ആകൃതി';

  @override
  String get sigilMissTooSlow => 'വളരെ പതുക്കെ';

  @override
  String get sigilMissSkippedDot => 'ഒരു ബിന്ദു വിട്ടുപോയി';

  @override
  String get sigilMissLeftRimEarly => 'വളരെ നേരത്തെ വിട്ടു';

  @override
  String get sigilMissWrongDirection => 'തിരിച്ചു വരച്ചു';

  @override
  String get sigilMissWrongLayer => 'തെറ്റായ ഷോൾഡർ ബട്ടൺ';

  @override
  String get sigilDry => 'ആവശ്യത്തിന് ചാർജ് ഇല്ല';

  @override
  String get sigilBusy => 'മുമ്പത്തേത് ഇപ്പോഴും നടക്കുന്നു';

  @override
  String get arena => 'അരീന';

  @override
  String get arenaBossParts => 'ബോസ് ഭാഗങ്ങൾ';

  @override
  String get arenaBareCore => 'നഗ്ന കോർ';

  @override
  String get arenaCompanions => 'കൂട്ടാളികൾ';

  @override
  String get arenaCharge => 'ചാർജ്';

  @override
  String get arenaChargeNormal => 'സാധാരണ';

  @override
  String get arenaSpeed => 'ലോക വേഗം';

  @override
  String get arenaDrill => 'പരിശീലനം';

  @override
  String get arenaFreePlay => 'സ്വതന്ത്ര കളി';

  @override
  String get arenaFight => 'പോരാടൂ';

  @override
  String get arenaNewBoss => 'പുതിയ ബോസ്';

  @override
  String get arenaLeave => 'അരീന വിടൂ';

  @override
  String get arenaHint =>
      'ബോസ് മരിക്കുന്ന നിമിഷം തിരികെ വരും. ഇവിടെ ഒന്നും സേവ് ചെയ്യില്ല.';

  @override
  String get arenaColCast => 'ഉപയോഗം';

  @override
  String get arenaColMiss => 'പിഴവ്';

  @override
  String get arenaColAvg => 'ശരാശരി';

  @override
  String get arenaColBest => 'മികച്ചത്';

  @override
  String get arenaColTime => 'വേഗമേറിയത്';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'ബോസുകൾ $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'പാഡ്: സിജിൽ';

  @override
  String get padSchemeClassic => 'പാഡ്: ക്ലാസിക്';

  @override
  String get padSouthpawOn => 'ഇടംകൈ: ഓൺ';

  @override
  String get padSouthpawOff => 'ഇടംകൈ: ഓഫ്';

  @override
  String get sigilDescHop => 'ഫ്ലിക്ക് ദിശയിൽ വേഗത്തിലൊരു ചാട്ടം';

  @override
  String get sigilDescSidestep => 'മൈതാനം കുറുകെ നീണ്ട വശച്ചുവട്';

  @override
  String get sigilDescStrike =>
      'മൂന്ന് ഭാരിച്ച വെടികളോടെ മുന്നോട്ട് കുതിച്ച്, തിരികെ';

  @override
  String get sigilDescRetreat => 'സംരക്ഷണ വെടി മുന്നോട്ട് പോകുമ്പോൾ പിന്മാറൂ';

  @override
  String get sigilDescDash => 'തീയിലൂടെ കോണോട്ടം, നടുവിൽ സ്പർശിക്കാനാവില്ല';

  @override
  String get sigilDescRoll => 'വശത്തേക്ക് ബാരൽ റോൾ, സ്പർശിക്കാനാവില്ല';

  @override
  String get sigilDescShadow => 'അടുത്ത ശത്രുവിന്റെ താഴെ പറ്റി വെടിവയ്ക്കൂ';

  @override
  String get sigilDescEcho =>
      'നിഴൽ നിങ്ങളുടെ അവസാന രണ്ട് സെക്കൻഡ് പകുതി നാശത്തോടെ ആവർത്തിക്കുന്നു';

  @override
  String get sigilDescLoop =>
      'മുകളിലൂടെ ലൂപ്പ്: വെടികൾ നിങ്ങളുടെ താഴെ കടന്നുപോകും';

  @override
  String get sigilDescSlalom => 'വിശറി വെടിയോടെ മൈതാനം കുറുകെ S-വളവ്';

  @override
  String get sigilDescCorkscrew =>
      'ചുറ്റും വെടിവച്ച് മുന്നോട്ട് ചുഴി, സ്പർശിക്കാനാവില്ല';

  @override
  String get sigilDescSnapshot => 'ഫ്ലിക്ക് ദിശയിൽ ഒരു ഭാരിച്ച വെടി';

  @override
  String get sigilDescBroadside => 'ഇരുവശത്തുനിന്നും സാൽവോ';

  @override
  String get sigilDescVolley => 'മുന്നോട്ട് അഞ്ച് ചാർജ് കിരണങ്ങൾ';

  @override
  String get sigilDescCaltrop => 'വെടികൾ വിഴുങ്ങി പൊട്ടുന്ന മൈൻ ഇടൂ';

  @override
  String get sigilDescFrenzy =>
      'കുറച്ച് സെക്കൻഡ് തോക്കുകൾ വേഗത്തിൽ വെടിവയ്ക്കും';

  @override
  String get sigilDescStasis => 'ശത്രുക്കളും വെടികളും പകുതി വേഗത്തിൽ';

  @override
  String get sigilDescHalo =>
      'പരിച നാലിരട്ടി വേഗത്തിൽ നിറയും, ഒന്നും കടക്കില്ല';

  @override
  String get sigilDescRadial => 'പതിനാറ് വെടികളുടെ വലയം';

  @override
  String get sigilDescStorm => 'എല്ലാ തോക്കും പൂർണ്ണ ശക്തിയിൽ, സൗജന്യം';

  @override
  String get sigilDescPing =>
      'ഫ്ലിക്ക് ചെയ്യുന്നിടത്ത് കൂട്ടാളികൾ വെടി കേന്ദ്രീകരിക്കും';

  @override
  String get sigilDescWingman => 'വരച്ച വശത്തേക്ക് വിംഗ്മാനെ വിളിക്കൂ';

  @override
  String get sigilDescHunter =>
      'മുന്നിൽ പറന്ന് ലക്ഷ്യം തിരഞ്ഞെടുക്കുന്ന വേട്ടക്കാരനെ വിളിക്കൂ';

  @override
  String get sigilDescWarden =>
      'നിങ്ങൾക്കുള്ള വെടികൾ ഏൽക്കുന്ന കാവൽക്കാരനെ വിളിക്കൂ';

  @override
  String get sigilDescFormation => 'കൂട്ടാളികൾ വീതിയും ആപ്പും തമ്മിൽ മാറും';

  @override
  String get sigilDescWhirl => 'കൂട്ടാളികൾ ചുറ്റും വട്ടമിട്ട് വെടികൾ വിഴുങ്ങും';

  @override
  String get sigilDescSacrifice =>
      'കൂട്ടാളികൾ കുതിച്ച് പൊട്ടും, ചാർജ് തിരികെ നൽകും';

  @override
  String get grimoire => 'ഗ്രിമോയർ';

  @override
  String get grimoireHint =>
      'വലത് സ്റ്റിക്ക് കൊണ്ട് വരയ്ക്കൂ. ARMS-ന് LB, WING-ന് RB, MEGA BLAST-ന് രണ്ടും പിടിക്കൂ.';

  @override
  String sigilCost(int cost) {
    return 'വില $cost';
  }

  @override
  String get sigilUntouchable => 'സ്പർശിക്കാനാവില്ല';

  @override
  String get lessonWatch => 'കാണൂ';

  @override
  String get lessonTrace => 'പിന്തുടർന്ന് വരയ്ക്കൂ';

  @override
  String get lessonSlow => 'പതുക്കെ';

  @override
  String get lessonLive => 'പൂർണ്ണ വേഗം';

  @override
  String get lessonStreak => 'തുടർച്ചയായി അഞ്ച്';

  @override
  String get lessonLearned => 'പഠിച്ചു';

  @override
  String lessonTempo(int pct) {
    return 'ടെമ്പോ $pct %';
  }

  @override
  String get hintHop => 'വലത് സ്റ്റിക്ക് ഫ്ലിക്ക് ചെയ്യൂ';

  @override
  String get hintLoop => 'വൃത്തം വരയ്ക്കൂ: നിങ്ങൾ വെടികൾക്ക് മുകളിലൂടെ പറക്കും';

  @override
  String get hintStream => 'LT അമർത്തൂ: രണ്ടോ മൂന്നോ ധാരകൾ';

  @override
  String get arenaKata => 'കാട്ട';

  @override
  String get arenaKataOff => 'ഒന്നുമില്ല';

  @override
  String kataNext(String sigil, String secs) {
    return 'അടുത്ത $sigil $secs s-ൽ';
  }

  @override
  String get arenaGauntlet => 'ഗോണ്ട്ലെറ്റ്';

  @override
  String get arenaOn => 'ഓൺ';

  @override
  String get arenaOff => 'ഓഫ്';

  @override
  String gauntletRating(int rating, int best) {
    return 'റേറ്റിംഗ് $rating · മികച്ചത് $best';
  }

  @override
  String get duelWarning => 'മുന്നറിയിപ്പ്';

  @override
  String get duelHintPad1 => 'വലത് സ്റ്റിക്ക് ഉന്നം വച്ച് വെടിവയ്ക്കും';

  @override
  String get duelHintPad2Rt =>
      'RT, LB അല്ലെങ്കിൽ RB പിടിക്കൂ: വലത് സ്റ്റിക്ക് സിജിൽ വരയ്ക്കും';

  @override
  String get duelHintPad2Lt =>
      'LT, LB അല്ലെങ്കിൽ RB പിടിക്കൂ: വലത് സ്റ്റിക്ക് സിജിൽ വരയ്ക്കും';

  @override
  String get duelHintClassic =>
      'ഇടത് സ്റ്റിക്ക് പറത്തും · B, RB അല്ലെങ്കിൽ RT മൂക്കിന്റെ ദിശയിൽ വെടി';

  @override
  String get duelHintKeys1 => 'അമ്പുകൾ ഉന്നവും വെടിയും · WASD പറത്തും';

  @override
  String get duelHintKeys2 =>
      'സ്പേസ് മൂക്കിന്റെ ദിശയിൽ വെടി · നംപാഡ് സിജിൽ വരയ്ക്കും';

  @override
  String get arenaDuelBinding => 'ദ്വന്ദ്വ നില';

  @override
  String get duelBindingRt => 'RT + സ്റ്റിക്ക്';

  @override
  String get duelBindingLt => 'LT + സ്റ്റിക്ക്';

  @override
  String get arenaDuelFrame => 'പാഡ് മുന്നോട്ട്';

  @override
  String get duelFrameNose => 'മൂക്ക്';

  @override
  String get duelFrameUp => 'മുകളിൽ';

  @override
  String get arenaDuelAimFires => 'ഉന്നം വച്ചാൽ വെടി';

  @override
  String get duelCutInFirst => 'ബോസ് ക്ലോസ്-അപ്പ്: ആദ്യ തവണ';

  @override
  String get duelCutInAlways => 'ബോസ് ക്ലോസ്-അപ്പ്: എപ്പോഴും';

  @override
  String get duelCutInNever => 'ബോസ് ക്ലോസ്-അപ്പ്: ഒരിക്കലുമില്ല';

  @override
  String get arenaDuelDrill => 'ദ്വന്ദ്വ പരിശീലനം';

  @override
  String get duelDrillOff => 'ഒന്നുമില്ല';

  @override
  String get duelDrillAim => 'ഉന്നം വച്ച് വെടിവയ്ക്കൂ';

  @override
  String get duelDrillAimHow => 'വലത് സ്റ്റിക്ക് ബോസിന് നേരെ ചൂണ്ടി അടിക്കൂ';

  @override
  String get duelDrillHold => 'മൂക്ക് നിർത്തൂ';

  @override
  String get duelDrillHoldHow => 'നില ബട്ടൺ പിടിച്ച് പറക്കൂ: മൂക്ക് അനങ്ങില്ല';

  @override
  String get duelDrillDraw => 'മുന്നോട്ട് വരയ്ക്കൂ';

  @override
  String get duelDrillDrawHow => 'നിലയിൽ ബോസിന് നേരെ സിജിൽ വരയ്ക്കൂ';

  @override
  String get duelDrillTurn => 'തിരിയൂ';

  @override
  String get duelDrillTurnHow =>
      'ബോസ് നിങ്ങളുടെ താഴെയാണ്: മൂക്ക് തിരിച്ച് അടിക്കൂ';

  @override
  String get duelDrillDone => 'പൂർത്തിയായി';
}
