// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get connect => 'সংযোগ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName-এর সাথে সংযোগ করা যায়নি';
  }

  @override
  String get nearbyJoinFailedBody =>
      'হোস্ট দেখা যাচ্ছিল, কিন্তু সংযোগ তৈরি হয়নি।\n\nকাছাকাছি খেলার জন্য পিয়ার-টু-পিয়ার Wi-Fi লাগে, যা পার্সোনাল হটস্পট চালু থাকলে iOS বন্ধ করে দেয় — দুটি ডিভাইসেই হটস্পট বন্ধ করে আবার চেষ্টা করুন, অথবা দুটি ডিভাইস একই Wi-Fi-তে যুক্ত করুন।';

  @override
  String get gameOverCampaign =>
      'মিশন ব্যর্থ — লোডআউট ও ক্রেডিট রয়ে গেছে। কমান্ড সেন্টার থেকে আবার চেষ্টা করুন।';

  @override
  String get gameOverEndless =>
      'সেক্টর 1-এ পুনর্গঠন — লোডআউট ও ক্রেডিট রয়ে গেছে';

  @override
  String get waitingForHost => 'হোস্টের অপেক্ষায়...';

  @override
  String get waitingForHostHint => 'হোস্ট প্রস্তুত হলে খেলা শুরু হবে';

  @override
  String get vesselLost => 'যান ধ্বংস';

  @override
  String scoreValue(String score) {
    return 'স্কোর: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'ক্রেডিট: $credits';
  }

  @override
  String get creditsPrefix => 'ক্রেডিট: ';

  @override
  String get leaderboard => 'লিডারবোর্ড';

  @override
  String get achievements => 'অর্জন';

  @override
  String get redeploy => 'আবার লড়াইয়ে';

  @override
  String get resume => 'আবার শুরু';

  @override
  String get pause => 'বিরতি';

  @override
  String get paused => 'থামানো';

  @override
  String get skins => 'স্কিন';

  @override
  String get skin => 'স্কিন';

  @override
  String get soundOn => 'শব্দ: চালু';

  @override
  String get soundOff => 'শব্দ: বন্ধ';

  @override
  String get musicOn => 'সংগীত: চালু';

  @override
  String get musicOff => 'সংগীত: বন্ধ';

  @override
  String get statsOn => 'পরিসংখ্যান: চালু';

  @override
  String get statsOff => 'পরিসংখ্যান: বন্ধ';

  @override
  String get mainMenu => 'প্রধান মেনু';

  @override
  String get quitToDesktop => 'ডেস্কটপে ফিরুন';

  @override
  String get selectSkin => 'স্কিন বাছুন';

  @override
  String get difficulty => 'কাঠিন্য';

  @override
  String get difficultyEasy => 'সহজ';

  @override
  String get difficultyNormal => 'স্বাভাবিক';

  @override
  String get difficultyHard => 'কঠিন';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'অভিযান';

  @override
  String get quit => 'বেরিয়ে যান';

  @override
  String get restorePurchases => 'কেনাকাটা পুনরুদ্ধার';

  @override
  String get locked => 'লক করা';

  @override
  String get mainMenuTooltip => 'প্রধান মেনু';

  @override
  String nodeLevel(int level) {
    return 'লেভেল $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'লেভেল $level · বস $ordinal';
  }

  @override
  String get nodeLockedHint => 'লক করা। আগে আগের নোডটি শেষ করুন।';

  @override
  String get flyAgain => 'আবার উড়ুন';

  @override
  String get launch => 'উৎক্ষেপণ';

  @override
  String zoneLabel(int zone) {
    return 'জোন $zone';
  }

  @override
  String get objectiveStar => 'তারা';

  @override
  String get continueButton => 'এগিয়ে যান';

  @override
  String get replayNode => 'নোড আবার খেলুন';

  @override
  String get retry => 'আবার চেষ্টা';

  @override
  String get nodeCleared => 'নোড সম্পন্ন';

  @override
  String get nodeFailed => 'নোড ব্যর্থ';

  @override
  String get weaponTierUnlocked => 'নতুন অস্ত্র স্তর আনলক';

  @override
  String get onSaleInComCenter => 'কমান্ড সেন্টারে বিক্রি হচ্ছে।';

  @override
  String get requiredTasksHint =>
      'আবশ্যিক কাজগুলোই নোডের ফল ঠিক করে। আবার উড়ুন — যা অর্জন করেছেন তা আপনারই থাকবে।';

  @override
  String get objClear => 'সেক্টর পরিষ্কার করুন';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি শত্রু ভূপাতিত করুন',
      one: '$countটি শত্রু ভূপাতিত করুন',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'খোলে কোনো ক্ষতি হবে না';

  @override
  String objHull(int percent) {
    return '$percent%-এর বেশি খোল নিয়ে শেষ করুন';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon দিয়ে $countটি ধ্বংস করুন',
      one: '$weapon দিয়ে $countটি ধ্বংস করুন',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'পাশের কামান দিয়ে $countটি ধ্বংস করুন',
      one: 'পাশের কামান দিয়ে $countটি ধ্বংস করুন',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'সামনে $weapon লাগিয়ে উৎক্ষেপণ করুন';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'পাশের মাউন্টে $weapon লাগিয়ে উৎক্ষেপণ করুন';
  }

  @override
  String get objBuySideGun => 'কমান্ড সেন্টার থেকে পাশের কামান কিনুন';

  @override
  String objUpgradeGenerator(int level) {
    return 'জেনারেটর লেভেল $level-এ আপগ্রেড করুন';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'সামনের কামান লেভেল $level-এ আপগ্রেড করুন';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'একটি পাশের কামান লেভেল $level-এ আপগ্রেড করুন';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বোনাস ধরুন',
      one: '$countটি বোনাস ধরুন',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পুরো ফর্মেশন মুছে দিন',
      one: '$countটি পুরো ফর্মেশন মুছে দিন',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'কোনো গ্রহাণুতে ধাক্কা দেবেন না';

  @override
  String objUnderTime(int seconds) {
    return '$seconds সেকেন্ডের মধ্যে শেষ করুন';
  }

  @override
  String get objStripBoss => 'কোরের আগে বসের প্রতিটি অংশ ধ্বংস করুন';

  @override
  String get joinCoopTitle => 'কো-অপে যোগ দিন';

  @override
  String get cannotSearchNetwork => 'এই নেটওয়ার্কে খোঁজা যাচ্ছে না';

  @override
  String get joinHintNearby =>
      'একই Wi-Fi সব ডিভাইসে কাজ করে। iPhone, iPad ও Mac এটি ছাড়াও কাছাকাছি একে অপরকে খুঁজে পায় — দুটিতেই পার্সোনাল হটস্পট বন্ধ থাকলে।';

  @override
  String get joinHintWifi =>
      'দুজন খেলোয়াড়কেই একই Wi-Fi-তে থাকতে হবে — পার্সোনাল হটস্পটও চলবে।';

  @override
  String noHostsYet(String hint) {
    return 'এখনো কোনো হোস্ট নেই। $hint';
  }

  @override
  String get lookingForHosts => 'এই Wi-Fi-তে ও কাছাকাছি হোস্ট খোঁজা হচ্ছে…';

  @override
  String get hostNearby => 'কাছাকাছি · Bluetooth / পিয়ার-টু-পিয়ার Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · একই Wi-Fi';
  }

  @override
  String get enterIpManually => 'নিজে IP লিখুন';

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
    return '$name — ঢালে সুরক্ষিত';
  }

  @override
  String get bossPartTurret => 'টারেট';

  @override
  String get bossPartShieldPod => 'ঢাল পড';

  @override
  String get bossPartThruster => 'থ্রাস্টার';

  @override
  String get bossPartCannon => 'কামান';

  @override
  String sectorUnknownSpace(int level) {
    return 'সেক্টর $level — অজানা মহাকাশ';
  }

  @override
  String get player2Joined => 'খেলোয়াড় 2 যোগ দিয়েছে!';

  @override
  String get player2Disconnected => 'খেলোয়াড় 2-এর সংযোগ বিচ্ছিন্ন';

  @override
  String get hostDisconnected => 'হোস্টের সংযোগ বিচ্ছিন্ন';

  @override
  String maxLevelSold(String amount) {
    return 'সর্বোচ্চ লেভেল! \$$amount-এ বিক্রি';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'অস্ত্র স্তর $tier আনলক';
  }

  @override
  String get cheatsEnabled => 'চিট চালু';

  @override
  String get cheatsDisabled => 'চিট বন্ধ';

  @override
  String get cheatsMaxed => 'চিট: ক্রেডিট সর্বোচ্চ, সব অস্ত্র আনলক';

  @override
  String get cheats => 'চিট';

  @override
  String get maxCredits => 'সর্বোচ্চ ক্রেডিট';

  @override
  String get sectionStats => 'পরিসংখ্যান';

  @override
  String get sectionLoadout => 'লোডআউট';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'আপগ্রেড';

  @override
  String get sell => 'বিক্রি';

  @override
  String get buy => 'কিনুন';

  @override
  String get commandCenter => 'কমান্ড সেন্টার';

  @override
  String get pilot => 'পাইলট';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'স্কোর';

  @override
  String get nextWeapon => 'পরের অস্ত্র';

  @override
  String pointsValue(String points) {
    return '$points পয়েন্ট';
  }

  @override
  String get slotFront => 'সামনে';

  @override
  String get slotLeft => 'বাঁ';

  @override
  String get slotRight => 'ডান';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'মিশন উৎক্ষেপণ';

  @override
  String get startMission => 'মিশন শুরু';

  @override
  String get continueMission => 'মিশন চালিয়ে যান';

  @override
  String get padControlsHint =>
      '[↑↓] সারি   [←→] বাছাই   [B] কিনুন/আপগ্রেড/বদল   [X/Y] বিক্রি   [OPTIONS] মিশন চালিয়ে যান';

  @override
  String get host => 'হোস্ট';

  @override
  String hostingAs(String name) {
    return '$name নামে হোস্টিং';
  }

  @override
  String get join => 'যোগ দিন';

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
  String get overload => 'ওভারলোড';

  @override
  String weaponOff(String weapon) {
    return '$weapon বন্ধ — জেনারেটর খুব দুর্বল';
  }

  @override
  String unlocksAt(String points) {
    return '$points পয়েন্টে আনলক';
  }

  @override
  String joinConnecting(String target) {
    return '$target-এর সাথে সংযোগ হচ্ছে…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'হোস্ট সাড়া দেয়নি: $reason।\n\nদুজন খেলোয়াড়কেই একই Wi-Fi-তে থাকতে হবে (পার্সোনাল হটস্পটও চলবে) এবং হোস্টকে হোস্ট চাপতে হবে। ঠিকানা যাচাই করে আবার চেষ্টা করুন।';
  }

  @override
  String get lanJoinNoAnswer => 'কোনো সাড়া নেই';

  @override
  String objBossUnder(int seconds) {
    return 'বস আসার $seconds সেকেন্ডের মধ্যে তার কোর ধ্বংস করুন';
  }

  @override
  String get sectionHangar => 'হ্যাঙ্গার';

  @override
  String get sectionVault => 'ভল্ট';

  @override
  String get rackSide => 'পাশ';

  @override
  String get rackHull => 'খোল';

  @override
  String get rarityCommon => 'সাধারণ';

  @override
  String get rarityRare => 'বিরল';

  @override
  String get rarityMythic => 'পৌরাণিক';

  @override
  String get curse => 'অভিশাপ';

  @override
  String get modFit => 'লাগান';

  @override
  String get modUnfit => 'খুলুন';

  @override
  String get modForge => 'কামারশালা';

  @override
  String get forgeHint => 'একই বিরলতার 3টি বেছে পরের বিরলতার 1টি গড়ুন';

  @override
  String get vaultEmpty =>
      'এখনো কোনো মড নেই। সব তারা নিয়ে একটি নোড শেষ করুন, দ্রুত একটি বসকে হারান, বা অন্তহীন মোডে একটি বস ভূপাতিত করুন।';

  @override
  String modNeeds(String families) {
    return '$families-এর সাথে কাজ করে';
  }

  @override
  String get modRackFull => 'র‍্যাক ভর্তি';

  @override
  String get modAlreadyFitted => 'আগেই লাগানো';

  @override
  String get modWrongRack => 'এই র‍্যাকে মানায় না';

  @override
  String modsSpilled(int n) {
    return '$nটি মড ভল্টে ফেরত';
  }

  @override
  String get hullLocked => 'লক করা';

  @override
  String hullUnlockBoss(int n) {
    return 'অভিযানের বস $n-কে হারান';
  }

  @override
  String get hullUnlockFinish => 'অভিযান শেষ করুন বা সেক্টর 30-এ পৌঁছান';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'সাধারণ যান';

  @override
  String get perkAfterimage => 'স্থির থাকুন: শট ×1.5';

  @override
  String get perkBulwark => 'ঢাল পেরোনো ক্ষতি অর্ধেক';

  @override
  String get perkOverclock => 'ক্ষমতার 130 % পর্যন্ত গুলি, ধীরে';

  @override
  String get perkBattery => 'একটি বিনামূল্যের গান ড্রোন সঙ্গে ওড়ে';

  @override
  String get rewardTitle => 'পুরস্কার';

  @override
  String newHull(String name) {
    return 'নতুন খোল: $name';
  }

  @override
  String get socketEmpty => 'খালি';

  @override
  String fxStreams(int n) {
    return '$nটি সমান্তরাল ধারা';
  }

  @override
  String fxFan(int n) {
    return '$n শটের পাখা';
  }

  @override
  String fxSalvo(int n) {
    return '$n শটের ঝাঁক';
  }

  @override
  String fxFireRate(String x) {
    return 'গুলির হার ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'ক্ষতি ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'শটের গতি ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'শটের আকার ×$x';
  }

  @override
  String fxPower(String x) {
    return 'শক্তি খরচ ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'লক্ষ্যসন্ধানী +$n';
  }

  @override
  String fxPierce(int n) {
    return '$nটি লক্ষ্য ভেদ করে';
  }

  @override
  String get fxPierceAll => 'সবকিছু ভেদ করে';

  @override
  String fxCrit(int pct, String x) {
    return '×$x ক্ষতির $pct % সম্ভাবনা';
  }

  @override
  String fxBossCrit(String x) {
    return 'বসের ওপর ×$x ক্রিট';
  }

  @override
  String fxFork(int n) {
    return 'ভূপাতিত হলে $n শট ছড়িয়ে পড়ে';
  }

  @override
  String get fxChain => 'ছড়ানো শট আবার ছড়ায়';

  @override
  String get fxSplit => 'লাগলে দুই ভাগ হয়';

  @override
  String get fxFrost => 'আঘাত শত্রুদের ধীর করে';

  @override
  String get fxCrossfire => 'পাশের কামান ভেতরের দিকে হেলে';

  @override
  String get fxRearguard => 'পাশের কামান পেছনেও গুলি করে';

  @override
  String get fxOrbit => 'শট এঁকেবেঁকে যায়';

  @override
  String fxBounce(int n) {
    return 'দেয়াল থেকে $n× ছিটকে যায়';
  }

  @override
  String get fxBounceTop => '…আর ওপর থেকেও';

  @override
  String get fxOverdrive => 'শক্তির ধারে গুলি করে';

  @override
  String get fxReactor => 'ক্ষমতার বেশি কামানও গুলি করে, ধীরে';

  @override
  String fxGenPower(String x) {
    return 'জেনারেটর রিচার্জ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'জেনারেটর ক্ষমতা ×$x';
  }

  @override
  String get fxSurge => 'পূর্ণ জেনারেটর: শট ×2';

  @override
  String fxSiphon(int pct) {
    return 'ভূপাতিত হলে $pct % শক্তি ফেরে';
  }

  @override
  String fxHp(String x) {
    return 'খোল ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ঢাল ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ঢাল পুনরুদ্ধার ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'ভূপাতিত হলে $n HP সারে';
  }

  @override
  String get fxMagnet => 'বোনাস টেনে আনে';

  @override
  String get fxMagnetAll => 'সব বোনাস টেনে আনে';

  @override
  String fxReflect(int pct) {
    return 'ঢাল থেকে $pct % শট ফিরে যায়';
  }

  @override
  String get fxReflectGuided => 'ফেরত শট নিজে লক্ষ্য খোঁজে';

  @override
  String fxGhost(String sec) {
    return 'খোলে আঘাতের পর $sec সেকেন্ড অস্পৃশ্য';
  }

  @override
  String get fxNova => 'ঢাল ভাঙলে পুরো স্ক্রিনে বিস্ফোরণ';

  @override
  String fxAgility(String x) {
    return 'চটপটে ভাব ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'হিটবক্স ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'ক্রেডিট ×$x';
  }

  @override
  String fxScore(String x) {
    return 'স্কোর ×$x';
  }

  @override
  String get fxSatellite => 'একটি গান ড্রোন সঙ্গে ওড়ে';

  @override
  String get fxTimewarp => 'খোলে আঘাত সময়কে ধীর করে';

  @override
  String get fxGambler => 'প্রতিটি শট এলোমেলো অস্ত্র';

  @override
  String get vaultAll => 'সব';

  @override
  String get sigilMissUnknown => 'অজানা আকার';

  @override
  String get sigilMissTooSlow => 'খুব ধীর';

  @override
  String get sigilMissSkippedDot => 'একটি বিন্দু বাদ গেছে';

  @override
  String get sigilMissLeftRimEarly => 'খুব আগে ছেড়েছ';

  @override
  String get sigilMissWrongDirection => 'উল্টো আঁকা';

  @override
  String get sigilMissWrongLayer => 'ভুল শোল্ডার বাটন';

  @override
  String get sigilDry => 'যথেষ্ট চার্জ নেই';

  @override
  String get sigilBusy => 'আগেরটি এখনও চলছে';

  @override
  String get arena => 'অ্যারেনা';

  @override
  String get arenaBossParts => 'বসের অংশ';

  @override
  String get arenaBareCore => 'খোলা কোর';

  @override
  String get arenaCompanions => 'সঙ্গী';

  @override
  String get arenaCharge => 'চার্জ';

  @override
  String get arenaChargeNormal => 'সাধারণ';

  @override
  String get arenaSpeed => 'বিশ্বের গতি';

  @override
  String get arenaDrill => 'অনুশীলন';

  @override
  String get arenaFreePlay => 'ফ্রি প্লে';

  @override
  String get arenaFight => 'লড়াই';

  @override
  String get arenaNewBoss => 'নতুন বস';

  @override
  String get arenaLeave => 'অ্যারেনা ছাড়ো';

  @override
  String get arenaHint =>
      'বস মারা যাওয়ামাত্র ফিরে আসে। এখানে কিছুই সেভ হয় না।';

  @override
  String get arenaColCast => 'প্রয়োগ';

  @override
  String get arenaColMiss => 'ভুল';

  @override
  String get arenaColAvg => 'গড়';

  @override
  String get arenaColBest => 'সেরা';

  @override
  String get arenaColTime => 'দ্রুততম';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'বস $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'প্যাড: সিজিল';

  @override
  String get padSchemeClassic => 'প্যাড: ক্লাসিক';

  @override
  String get padSouthpawOn => 'বাঁহাতি: চালু';

  @override
  String get padSouthpawOff => 'বাঁহাতি: বন্ধ';

  @override
  String get sigilDescHop => 'ফ্লিকের দিকে দ্রুত লাফ';

  @override
  String get sigilDescSidestep => 'মাঠ জুড়ে লম্বা পাশ-পদক্ষেপ';

  @override
  String get sigilDescStrike => 'তিনটি ভারী গুলি নিয়ে সামনে ঝাঁপ, তারপর ফেরা';

  @override
  String get sigilDescRetreat => 'পিছু হটো, কভারিং ফায়ার সামনে যায়';

  @override
  String get sigilDescDash =>
      'আগুনের মধ্য দিয়ে কোণাকুণি ড্যাশ, মাঝপথে অস্পৃশ্য';

  @override
  String get sigilDescRoll => 'পাশে ব্যারেল রোল, অস্পৃশ্য';

  @override
  String get sigilDescShadow => 'নিকটতম শত্রুর নিচে লক করে গুলি চালিয়ে যাও';

  @override
  String get sigilDescEcho =>
      'একটি ছায়া তোমার শেষ দুই সেকেন্ড অর্ধেক ক্ষতিতে পুনরায় চালায়';

  @override
  String get sigilDescLoop => 'উপর দিয়ে লুপ: গুলি তোমার নিচ দিয়ে যায়';

  @override
  String get sigilDescSlalom => 'পাখার মতো ফায়ার নিয়ে মাঠ জুড়ে S-বাঁক';

  @override
  String get sigilDescCorkscrew =>
      'চারদিকে গুলি চালিয়ে সামনে কর্কস্ক্রু, অস্পৃশ্য';

  @override
  String get sigilDescSnapshot => 'ফ্লিকের দিকে একটি ভারী গুলি';

  @override
  String get sigilDescBroadside => 'দুই পাশ থেকে গোলাবর্ষণ';

  @override
  String get sigilDescVolley => 'সামনে পাঁচটি চার্জড রশ্মি';

  @override
  String get sigilDescCaltrop => 'একটি মাইন ফেলো যা গুলি গিলে বিস্ফোরিত হয়';

  @override
  String get sigilDescFrenzy => 'কয়েক সেকেন্ড অস্ত্র দ্রুত চলে';

  @override
  String get sigilDescStasis => 'শত্রু ও তাদের গুলি অর্ধেক গতিতে';

  @override
  String get sigilDescHalo => 'ঢাল চারগুণ দ্রুত চার্জ হয় আর কিছুই ভেদ করে না';

  @override
  String get sigilDescRadial => 'ষোলোটি গুলির বলয়';

  @override
  String get sigilDescStorm => 'সব অস্ত্র পূর্ণ শক্তিতে, বিনামূল্যে';

  @override
  String get sigilDescPing => 'সঙ্গীরা ফ্লিকের দিকে ফায়ার কেন্দ্রীভূত করে';

  @override
  String get sigilDescWingman => 'যে দিকে এঁকেছ সেই পাশে উইংম্যান ডাকো';

  @override
  String get sigilDescHunter => 'একজন শিকারি ডাকো যে আগে উড়ে লক্ষ্য বাছে';

  @override
  String get sigilDescWarden => 'একজন রক্ষী ডাকো যে তোমার গুলি নিজে নেয়';

  @override
  String get sigilDescFormation => 'সঙ্গীরা চওড়া ও কীলক বিন্যাসে বদলায়';

  @override
  String get sigilDescWhirl => 'সঙ্গীরা তোমার চারপাশে ঘুরে গুলি গিলে';

  @override
  String get sigilDescSacrifice =>
      'সঙ্গীরা ঝাঁপিয়ে বিস্ফোরিত হয়, চার্জ ফেরত দেয়';

  @override
  String get grimoire => 'গ্রিমোয়ার';

  @override
  String get grimoireHint =>
      'ডান স্টিক দিয়ে আঁকো। ARMS-এর জন্য LB, WING-এর জন্য RB, দুটোই MEGA BLAST-এর জন্য।';

  @override
  String sigilCost(int cost) {
    return 'মূল্য $cost';
  }

  @override
  String get sigilUntouchable => 'অস্পৃশ্য';

  @override
  String get lessonWatch => 'দেখো';

  @override
  String get lessonTrace => 'ট্রেস করো';

  @override
  String get lessonSlow => 'ধীরে';

  @override
  String get lessonLive => 'পূর্ণ গতি';

  @override
  String get lessonStreak => 'টানা পাঁচ';

  @override
  String get lessonLearned => 'শেখা হয়েছে';

  @override
  String lessonTempo(int pct) {
    return 'টেম্পো $pct %';
  }

  @override
  String get hintHop => 'ডান স্টিক ফ্লিক করো';

  @override
  String get hintLoop => 'একটি বৃত্ত আঁকো: তুমি গুলির উপর দিয়ে ওড়ো';

  @override
  String get hintStream => 'LT চাপো: দুই বা তিনটি ধারা';

  @override
  String get arenaKata => 'কাতা';

  @override
  String get arenaKataOff => 'কিছু না';

  @override
  String kataNext(String sigil, String secs) {
    return 'পরবর্তী $sigil $secs s পরে';
  }

  @override
  String get arenaGauntlet => 'চ্যালেঞ্জ';

  @override
  String get arenaOn => 'চালু';

  @override
  String get arenaOff => 'বন্ধ';

  @override
  String gauntletRating(int rating, int best) {
    return 'রেটিং $rating · সেরা $best';
  }

  @override
  String get duelWarning => 'সতর্কতা';

  @override
  String get duelHintPad1 => 'ডান স্টিক লক্ষ্য করে গুলি চালায়';

  @override
  String get duelHintPad2Rt => 'RT, LB বা RB ধরে রাখো: ডান স্টিক সিজিল আঁকে';

  @override
  String get duelHintPad2Lt => 'LT, LB বা RB ধরে রাখো: ডান স্টিক সিজিল আঁকে';

  @override
  String get duelHintClassic =>
      'বাম স্টিক ওড়ায় · B, RB বা RT নাকের দিকে গুলি চালায়';

  @override
  String get duelHintKeys1 => 'তীর লক্ষ্য ও গুলি · WASD ওড়ায়';

  @override
  String get duelHintKeys2 =>
      'স্পেস নাকের দিকে গুলি চালায় · নামপ্যাড সিজিল আঁকে';

  @override
  String get arenaDuelBinding => 'দ্বন্দ্ব ভঙ্গি';

  @override
  String get duelBindingRt => 'RT + স্টিক';

  @override
  String get duelBindingLt => 'LT + স্টিক';

  @override
  String get arenaDuelFrame => 'প্যাডের সামনে';

  @override
  String get duelFrameNose => 'নাক';

  @override
  String get duelFrameUp => 'উপরে';

  @override
  String get arenaDuelAimFires => 'লক্ষ্য = গুলি';

  @override
  String get duelCutInFirst => 'বস ক্লোজ-আপ: প্রথমবার';

  @override
  String get duelCutInAlways => 'বস ক্লোজ-আপ: সবসময়';

  @override
  String get duelCutInNever => 'বস ক্লোজ-আপ: কখনও না';

  @override
  String get arenaDuelDrill => 'দ্বন্দ্ব অনুশীলন';

  @override
  String get duelDrillOff => 'কিছু না';

  @override
  String get duelDrillAim => 'লক্ষ্য করে গুলি';

  @override
  String get duelDrillAimHow => 'ডান স্টিক বসের দিকে তাক করে আঘাত করো';

  @override
  String get duelDrillHold => 'নাক ধরে রাখো';

  @override
  String get duelDrillHoldHow => 'ভঙ্গি বাটন ধরে ওড়ো: নাক স্থির থাকে';

  @override
  String get duelDrillDraw => 'সামনে আঁকো';

  @override
  String get duelDrillDrawHow => 'ভঙ্গিতে বসের দিকে একটি সিজিল আঁকো';

  @override
  String get duelDrillTurn => 'ঘুরে যাও';

  @override
  String get duelDrillTurnHow => 'বস তোমার নিচে: নাক ঘুরিয়ে আঘাত করো';

  @override
  String get duelDrillDone => 'সম্পন্ন';
}
