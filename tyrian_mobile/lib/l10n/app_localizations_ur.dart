// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ';

  @override
  String get connect => 'جوڑیں';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName سے رابطہ نہیں ہو سکا';
  }

  @override
  String get nearbyJoinFailedBody =>
      'میزبان نظر آ رہا تھا مگر رابطہ قائم نہیں ہوا۔\n\nقریبی کھیل کے لیے پیئر ٹو پیئر Wi-Fi درکار ہے، جسے iOS ذاتی ہاٹ اسپاٹ آن ہونے پر بند کر دیتا ہے — دونوں آلات پر ہاٹ اسپاٹ بند کریں اور دوبارہ کوشش کریں، یا دونوں آلات کو ایک ہی Wi-Fi سے جوڑیں۔';

  @override
  String get gameOverCampaign =>
      'مشن ناکام — سازوسامان اور کریڈٹ محفوظ ہیں۔ کمانڈ سینٹر سے دوبارہ کوشش کریں۔';

  @override
  String get gameOverEndless =>
      'سیکٹر 1 میں دوبارہ تعمیر — سازوسامان اور کریڈٹ محفوظ ہیں';

  @override
  String get waitingForHost => 'میزبان کا انتظار...';

  @override
  String get waitingForHostHint => 'میزبان تیار ہوتے ہی کھیل شروع ہو گا';

  @override
  String get vesselLost => 'جہاز تباہ';

  @override
  String scoreValue(String score) {
    return 'اسکور: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'کریڈٹ: $credits';
  }

  @override
  String get creditsPrefix => 'کریڈٹ: ';

  @override
  String get leaderboard => 'لیڈر بورڈ';

  @override
  String get achievements => 'کامیابیاں';

  @override
  String get redeploy => 'دوبارہ میدان میں';

  @override
  String get resume => 'جاری رکھیں';

  @override
  String get pause => 'وقفہ';

  @override
  String get paused => 'رکا ہوا';

  @override
  String get skins => 'اسکنز';

  @override
  String get skin => 'اسکن';

  @override
  String get soundOn => 'آواز: آن';

  @override
  String get soundOff => 'آواز: آف';

  @override
  String get musicOn => 'موسیقی: آن';

  @override
  String get musicOff => 'موسیقی: آف';

  @override
  String get mainMenu => 'مرکزی مینو';

  @override
  String get quitToDesktop => 'ڈیسک ٹاپ پر واپس';

  @override
  String get selectSkin => 'اسکن منتخب کریں';

  @override
  String get difficulty => 'مشکل';

  @override
  String get difficultyEasy => 'آسان';

  @override
  String get difficultyNormal => 'عام';

  @override
  String get difficultyHard => 'مشکل';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'مہم';

  @override
  String get quit => 'باہر نکلیں';

  @override
  String get restorePurchases => 'خریداریاں بحال کریں';

  @override
  String get locked => 'مقفل';

  @override
  String get mainMenuTooltip => 'مرکزی مینو';

  @override
  String nodeLevel(int level) {
    return 'لیول $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'لیول $level · باس $ordinal';
  }

  @override
  String get nodeLockedHint => 'مقفل۔ پہلے پچھلا نوڈ مکمل کریں۔';

  @override
  String get flyAgain => 'دوبارہ اڑیں';

  @override
  String get launch => 'روانگی';

  @override
  String zoneLabel(int zone) {
    return 'زون $zone';
  }

  @override
  String get objectiveStar => 'ستارہ';

  @override
  String get continueButton => 'آگے بڑھیں';

  @override
  String get replayNode => 'نوڈ دوبارہ کھیلیں';

  @override
  String get retry => 'دوبارہ کوشش';

  @override
  String get nodeCleared => 'نوڈ مکمل';

  @override
  String get nodeFailed => 'نوڈ ناکام';

  @override
  String get weaponTierUnlocked => 'ہتھیاروں کا نیا درجہ کھل گیا';

  @override
  String get onSaleInComCenter => 'کمانڈ سینٹر میں دستیاب۔';

  @override
  String get requiredTasksHint =>
      'لازمی کام ہی نوڈ کا فیصلہ کرتے ہیں۔ دوبارہ اڑیں — جو کمایا وہ آپ کے پاس رہے گا۔';

  @override
  String get objClear => 'سیکٹر صاف کریں';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دشمن مار گرائیں',
      one: '1 دشمن مار گرائیں',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ڈھانچے کو کوئی نقصان نہ پہنچے';

  @override
  String objHull(int percent) {
    return '$percent% سے زیادہ ڈھانچے کے ساتھ ختم کریں';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon سے $count کو تباہ کریں',
      one: '$weapon سے 1 کو تباہ کریں',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سائیڈ گنز سے $count کو تباہ کریں',
      one: 'سائیڈ گنز سے 1 کو تباہ کریں',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon کو آگے لگا کر روانہ ہوں';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon کو سائیڈ ماؤنٹ پر لگا کر روانہ ہوں';
  }

  @override
  String get objBuySideGun => 'کمانڈ سینٹر سے سائیڈ گن خریدیں';

  @override
  String objUpgradeGenerator(int level) {
    return 'جنریٹر کو لیول $level تک اپ گریڈ کریں';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'اگلی گن کو لیول $level تک اپ گریڈ کریں';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'کسی سائیڈ گن کو لیول $level تک اپ گریڈ کریں';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بونس پکڑیں',
      one: '1 بونس پکڑیں',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مکمل فارمیشنز کا صفایا کریں',
      one: '1 مکمل فارمیشن کا صفایا کریں',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'کسی سیارچے سے نہ ٹکرائیں';

  @override
  String objUnderTime(int seconds) {
    return '$seconds سیکنڈ میں مکمل کریں';
  }

  @override
  String get objStripBoss => 'کور سے پہلے باس کا ہر حصہ تباہ کریں';

  @override
  String get joinCoopTitle => 'کو-آپ میں شامل ہوں';

  @override
  String get cannotSearchNetwork => 'اس نیٹ ورک پر تلاش ممکن نہیں';

  @override
  String get joinHintNearby =>
      'ایک ہی Wi-Fi ہر آلے پر کام کرتا ہے۔ iPhone، iPad اور Mac اس کے بغیر بھی قریب ایک دوسرے کو ڈھونڈ لیتے ہیں — دونوں پر ذاتی ہاٹ اسپاٹ بند ہو۔';

  @override
  String get joinHintWifi =>
      'دونوں کھلاڑیوں کا ایک ہی Wi-Fi پر ہونا ضروری ہے — ذاتی ہاٹ اسپاٹ بھی چلے گا۔';

  @override
  String noHostsYet(String hint) {
    return 'ابھی کوئی میزبان نہیں۔ $hint';
  }

  @override
  String get lookingForHosts => 'اس Wi-Fi اور قریب میں میزبان تلاش ہو رہے ہیں…';

  @override
  String get hostNearby => 'قریب · Bluetooth / پیئر ٹو پیئر Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · وہی Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP خود درج کریں';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ڈھال';

  @override
  String get hudPower => 'توانائی';

  @override
  String get hudGen => 'جنریٹر';

  @override
  String bossShielded(String name) {
    return '$name — ڈھال بند';
  }

  @override
  String get bossPartTurret => 'برج';

  @override
  String get bossPartShieldPod => 'ڈھال پوڈ';

  @override
  String get bossPartThruster => 'تھرسٹر';

  @override
  String get bossPartCannon => 'توپ';

  @override
  String sectorUnknownSpace(int level) {
    return 'سیکٹر $level — نامعلوم خلا';
  }

  @override
  String get player2Joined => 'کھلاڑی 2 شامل ہو گیا!';

  @override
  String get player2Disconnected => 'کھلاڑی 2 کا رابطہ ٹوٹ گیا';

  @override
  String get hostDisconnected => 'میزبان کا رابطہ ٹوٹ گیا';

  @override
  String maxLevelSold(String amount) {
    return 'زیادہ سے زیادہ لیول! \$$amount میں فروخت';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ہتھیار کا درجہ $tier کھل گیا';
  }

  @override
  String get cheatsEnabled => 'چیٹس آن';

  @override
  String get cheatsDisabled => 'چیٹس آف';

  @override
  String get cheatsMaxed => 'چیٹ: کریڈٹ زیادہ سے زیادہ، تمام ہتھیار کھل گئے';

  @override
  String get cheats => 'چیٹس';

  @override
  String get maxCredits => 'زیادہ سے زیادہ کریڈٹ';

  @override
  String get sectionStats => 'اعداد و شمار';

  @override
  String get sectionLoadout => 'سازوسامان';

  @override
  String levelShort(int level) {
    return 'ل$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'اپ گریڈ';

  @override
  String get sell => 'بیچیں';

  @override
  String get buy => 'خریدیں';

  @override
  String get commandCenter => 'کمانڈ سینٹر';

  @override
  String get pilot => 'پائلٹ';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'اسکور';

  @override
  String get nextWeapon => 'اگلا ہتھیار';

  @override
  String pointsValue(String points) {
    return '$points پوائنٹس';
  }

  @override
  String get slotFront => 'آگے';

  @override
  String get slotLeft => 'بائیں';

  @override
  String get slotRight => 'دائیں';

  @override
  String get slotGen => 'جنریٹر';

  @override
  String get power => 'توانائی';

  @override
  String get launchMission => 'مشن روانہ کریں';

  @override
  String get startMission => 'مشن شروع کریں';

  @override
  String get continueMission => 'مشن جاری رکھیں';

  @override
  String get padControlsHint =>
      '[↑↓] قطار   [←→] انتخاب   [B] خریدیں/اپ گریڈ/بدلیں   [X/Y] بیچیں   [OPTIONS] مشن جاری رکھیں';

  @override
  String get host => 'میزبانی';

  @override
  String hostingAs(String name) {
    return 'بطور $name میزبانی';
  }

  @override
  String get join => 'شامل ہوں';

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
  String get overload => 'اوورلوڈ';

  @override
  String weaponOff(String weapon) {
    return '$weapon بند — جنریٹر بہت کمزور ہے';
  }

  @override
  String unlocksAt(String points) {
    return '$points پوائنٹس پر کھلے گا';
  }

  @override
  String joinConnecting(String target) {
    return '$target سے جوڑا جا رہا ہے…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'میزبان نے جواب نہیں دیا: $reason۔\n\nدونوں کھلاڑیوں کا ایک ہی Wi-Fi پر ہونا ضروری ہے (ذاتی ہاٹ اسپاٹ بھی چلے گا) اور میزبان نے میزبانی دبایا ہو۔ پتہ چیک کریں اور دوبارہ کوشش کریں۔';
  }

  @override
  String get lanJoinNoAnswer => 'کوئی جواب نہیں';

  @override
  String objBossUnder(int seconds) {
    return 'باس کے آنے کے $seconds سیکنڈ کے اندر اس کا کور تباہ کریں';
  }

  @override
  String get sectionHangar => 'ہینگر';

  @override
  String get sectionVault => 'تجوری';

  @override
  String get rackSide => 'سائیڈ';

  @override
  String get rackHull => 'ڈھانچہ';

  @override
  String get rarityCommon => 'عام';

  @override
  String get rarityRare => 'نایاب';

  @override
  String get rarityMythic => 'افسانوی';

  @override
  String get curse => 'لعنت';

  @override
  String get modFit => 'لگائیں';

  @override
  String get modUnfit => 'اتاریں';

  @override
  String get modForge => 'بھٹی';

  @override
  String get forgeHint => 'ایک ہی نایابی کے 3 چن کر اگلی نایابی کا 1 ڈھالیں';

  @override
  String get vaultEmpty =>
      'ابھی کوئی موڈ نہیں۔ تمام ستاروں کے ساتھ نوڈ مکمل کریں، باس کو جلدی ہرائیں، یا لامتناہی موڈ میں باس گرائیں۔';

  @override
  String modNeeds(String families) {
    return '$families کے ساتھ کام کرتا ہے';
  }

  @override
  String get modRackFull => 'ریک بھرا ہوا ہے';

  @override
  String get modAlreadyFitted => 'پہلے سے لگا ہے';

  @override
  String get modWrongRack => 'اس ریک میں نہیں لگتا';

  @override
  String modsSpilled(int n) {
    return '$n موڈ واپس تجوری میں';
  }

  @override
  String get hullLocked => 'مقفل';

  @override
  String hullUnlockBoss(int n) {
    return 'مہم کا باس $n ہرائیں';
  }

  @override
  String get hullUnlockFinish => 'مہم مکمل کریں یا سیکٹر 30 تک پہنچیں';

  @override
  String get statAgility => 'پھرتی';

  @override
  String get statHitbox => 'ہدف';

  @override
  String get perkNone => 'معیاری جہاز';

  @override
  String get perkAfterimage => 'ساکن رہیں: گولیاں ×1.5';

  @override
  String get perkBulwark => 'ڈھال سے گزرنے والا نقصان آدھا';

  @override
  String get perkOverclock => 'صلاحیت کے 130 % تک فائر، آہستہ';

  @override
  String get perkBattery => 'ایک مفت گن ڈرون ساتھ اڑتا ہے';

  @override
  String get rewardTitle => 'انعام';

  @override
  String newHull(String name) {
    return 'نیا ڈھانچہ: $name';
  }

  @override
  String get socketEmpty => 'خالی';

  @override
  String fxStreams(int n) {
    return '$n متوازی دھارے';
  }

  @override
  String fxFan(int n) {
    return '$n گولیوں کا پنکھا';
  }

  @override
  String fxSalvo(int n) {
    return '$n گولیوں کی بوچھاڑ';
  }

  @override
  String fxFireRate(String x) {
    return 'فائر کی رفتار ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'نقصان ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'گولی کی رفتار ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'گولی کا سائز ×$x';
  }

  @override
  String fxPower(String x) {
    return 'توانائی کا استعمال ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'خود رہنما +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n اہداف کے آر پار';
  }

  @override
  String get fxPierceAll => 'ہر چیز کے آر پار';

  @override
  String fxCrit(int pct, String x) {
    return '×$x نقصان کا $pct % امکان';
  }

  @override
  String fxBossCrit(String x) {
    return 'باسز پر ×$x کرٹ';
  }

  @override
  String fxFork(int n) {
    return 'مار گرانے پر $n گولیاں بکھرتی ہیں';
  }

  @override
  String get fxChain => 'بکھری گولیاں پھر بکھرتی ہیں';

  @override
  String get fxSplit => 'لگنے پر دو حصوں میں بٹ جاتی ہے';

  @override
  String get fxFrost => 'ضربیں دشمنوں کو سست کرتی ہیں';

  @override
  String get fxCrossfire => 'سائیڈ گنز اندر کی طرف جھکتی ہیں';

  @override
  String get fxRearguard => 'سائیڈ گنز پیچھے بھی فائر کرتی ہیں';

  @override
  String get fxOrbit => 'گولیاں بل کھاتی ہیں';

  @override
  String fxBounce(int n) {
    return 'دیواروں سے $n× اچھلتی ہے';
  }

  @override
  String get fxBounceTop => '…اور اوپر سے بھی';

  @override
  String get fxOverdrive => 'توانائی کے قرض پر فائر';

  @override
  String get fxReactor => 'حد سے زیادہ گنز بھی فائر کرتی ہیں، آہستہ';

  @override
  String fxGenPower(String x) {
    return 'جنریٹر ری چارج ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'جنریٹر کی گنجائش ×$x';
  }

  @override
  String get fxSurge => 'بھرا جنریٹر: گولیاں ×2';

  @override
  String fxSiphon(int pct) {
    return 'مار گرانے سے $pct % توانائی بحال';
  }

  @override
  String fxHp(String x) {
    return 'ڈھانچہ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ڈھال ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ڈھال کی بحالی ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'مار گرانے سے $n HP شفا';
  }

  @override
  String get fxMagnet => 'بونس کھینچتا ہے';

  @override
  String get fxMagnetAll => 'ہر بونس کھینچتا ہے';

  @override
  String fxReflect(int pct) {
    return 'ڈھال سے $pct % گولیاں واپس پلٹتی ہیں';
  }

  @override
  String get fxReflectGuided => 'پلٹی ہوئی گولیاں خود نشانہ ڈھونڈتی ہیں';

  @override
  String fxGhost(String sec) {
    return 'ڈھانچے پر ضرب کے بعد $sec سیکنڈ ناقابلِ ضرب';
  }

  @override
  String get fxNova => 'ڈھال ٹوٹے تو پوری اسکرین پر دھماکا';

  @override
  String fxAgility(String x) {
    return 'پھرتی ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ضرب کا علاقہ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'کریڈٹ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'اسکور ×$x';
  }

  @override
  String get fxSatellite => 'ایک گن ڈرون ساتھ اڑتا ہے';

  @override
  String get fxTimewarp => 'ڈھانچے پر ضرب وقت کو سست کرتی ہے';

  @override
  String get fxGambler => 'ہر گولی ایک بے ترتیب ہتھیار';

  @override
  String get vaultAll => 'سب';

  @override
  String get sigilMissUnknown => 'نامعلوم شکل';

  @override
  String get sigilMissTooSlow => 'بہت سست';

  @override
  String get sigilMissSkippedDot => 'ایک نقطہ چھوٹ گیا';

  @override
  String get sigilMissLeftRimEarly => 'بہت جلد چھوڑ دیا';

  @override
  String get sigilMissWrongDirection => 'الٹا بنایا';

  @override
  String get sigilMissWrongLayer => 'غلط شولڈر بٹن';

  @override
  String get sigilDry => 'چارج ناکافی';

  @override
  String get sigilBusy => 'پچھلا ابھی جاری ہے';

  @override
  String get arena => 'میدان';

  @override
  String get arenaBossParts => 'باس کے حصے';

  @override
  String get arenaBareCore => 'کھلا کور';

  @override
  String get arenaCompanions => 'ساتھی';

  @override
  String get arenaCharge => 'چارج';

  @override
  String get arenaChargeNormal => 'عام';

  @override
  String get arenaSpeed => 'دنیا کی رفتار';

  @override
  String get arenaDrill => 'مشق';

  @override
  String get arenaFreePlay => 'آزاد کھیل';

  @override
  String get arenaFight => 'لڑو';

  @override
  String get arenaNewBoss => 'نیا باس';

  @override
  String get arenaLeave => 'میدان چھوڑیں';

  @override
  String get arenaHint =>
      'باس مرتے ہی واپس آ جاتا ہے۔ یہاں کچھ محفوظ نہیں ہوتا۔';

  @override
  String get arenaColCast => 'استعمال';

  @override
  String get arenaColMiss => 'چوک';

  @override
  String get arenaColAvg => 'اوسط';

  @override
  String get arenaColBest => 'بہترین';

  @override
  String get arenaColTime => 'تیز ترین';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'باس $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'پیڈ: سگل';

  @override
  String get padSchemeClassic => 'پیڈ: کلاسک';

  @override
  String get padSouthpawOn => 'بایاں ہاتھ: آن';

  @override
  String get padSouthpawOff => 'بایاں ہاتھ: آف';

  @override
  String get sigilDescHop => 'جھٹکے کی سمت ایک تیز چھلانگ';

  @override
  String get sigilDescSidestep => 'میدان کے پار لمبا سائیڈ اسٹیپ';

  @override
  String get sigilDescStrike => 'تین بھاری گولیوں کے ساتھ آگے جھپٹ کر واپس';

  @override
  String get sigilDescRetreat => 'پیچھے ہٹیں جبکہ کور فائر آگے جائے';

  @override
  String get sigilDescDash => 'آگ میں سے ترچھی دوڑ، بیچ میں ناقابلِ چھو';

  @override
  String get sigilDescRoll => 'سائیڈ کی طرف بیرل رول، ناقابلِ چھو';

  @override
  String get sigilDescShadow => 'قریب ترین دشمن کے نیچے جم کر فائر کرتے رہیں';

  @override
  String get sigilDescEcho =>
      'ایک سایہ آپ کے آخری دو سیکنڈ آدھے نقصان کے ساتھ دہراتا ہے';

  @override
  String get sigilDescLoop => 'اوپر سے لوپ: گولیاں نیچے سے گزرتی ہیں';

  @override
  String get sigilDescSlalom => 'پنکھا نما فائر کے ساتھ میدان میں S موڑ';

  @override
  String get sigilDescCorkscrew =>
      'چاروں طرف فائر کرتے ہوئے کارک اسکرو، ناقابلِ چھو';

  @override
  String get sigilDescSnapshot => 'جھٹکے کی سمت ایک بھاری گولی';

  @override
  String get sigilDescBroadside => 'دونوں پہلوؤں سے ایک بوچھاڑ';

  @override
  String get sigilDescVolley => 'آگے پانچ چارج شدہ شعاعیں';

  @override
  String get sigilDescCaltrop => 'بارودی سرنگ گرائیں جو گولیاں نگل کر پھٹے';

  @override
  String get sigilDescFrenzy => 'چند سیکنڈ بندوقیں تیز چلتی ہیں';

  @override
  String get sigilDescStasis => 'دشمن اور ان کی گولیاں آدھی رفتار پر';

  @override
  String get sigilDescHalo =>
      'ڈھال چار گنا تیز چارج ہوتی ہے اور کچھ نہیں گزرتا';

  @override
  String get sigilDescRadial => 'سولہ گولیوں کا حلقہ';

  @override
  String get sigilDescStorm => 'ہر بندوق پوری رفتار سے، مفت';

  @override
  String get sigilDescPing => 'ساتھی جھٹکے کی سمت فائر مرکوز کرتے ہیں';

  @override
  String get sigilDescWingman => 'بنائی گئی سمت کے پہلو پر ونگ مین بلائیں';

  @override
  String get sigilDescHunter => 'ایک شکاری بلائیں جو آگے اڑ کر ہدف چنے';

  @override
  String get sigilDescWarden => 'ایک محافظ بلائیں جو آپ کی گولیاں جھیلے';

  @override
  String get sigilDescFormation => 'ساتھی چوڑی اور نوکدار ترتیب میں بدلتے ہیں';

  @override
  String get sigilDescWhirl => 'ساتھی آپ کے گرد گھوم کر گولیاں کھاتے ہیں';

  @override
  String get sigilDescSacrifice =>
      'ساتھی غوطہ لگا کر پھٹتے ہیں، چارج واپس دیتے ہیں';

  @override
  String get grimoire => 'جادو کی کتاب';

  @override
  String get grimoireHint =>
      'دائیں اسٹک سے بنائیں۔ ہتھیار کے لیے LB، ونگ کے لیے RB، میگا دھماکے کے لیے دونوں۔';

  @override
  String sigilCost(int cost) {
    return 'قیمت $cost';
  }

  @override
  String get sigilUntouchable => 'ناقابلِ چھو';

  @override
  String get lessonWatch => 'دیکھیں';

  @override
  String get lessonTrace => 'بنائیں';

  @override
  String get lessonSlow => 'آہستہ';

  @override
  String get lessonLive => 'پوری رفتار';

  @override
  String get lessonStreak => 'لگاتار پانچ';

  @override
  String get lessonLearned => 'سیکھ لیا';

  @override
  String lessonTempo(int pct) {
    return 'رفتار $pct %';
  }

  @override
  String get hintHop => 'دائیں اسٹک کو جھٹکیں';

  @override
  String get hintLoop => 'دائرہ بنائیں: آپ گولیوں کے اوپر سے اڑیں گے';

  @override
  String get hintStream => 'LT دبائیں: دو یا تین دھارے';

  @override
  String get arenaKata => 'کاتا';

  @override
  String get arenaKataOff => 'کوئی نہیں';

  @override
  String kataNext(String sigil, String secs) {
    return 'اگلا $sigil $secs سیکنڈ میں';
  }

  @override
  String get arenaGauntlet => 'چیلنج';

  @override
  String get arenaOn => 'آن';

  @override
  String get arenaOff => 'آف';

  @override
  String gauntletRating(int rating, int best) {
    return 'درجہ $rating · بہترین $best';
  }

  @override
  String get duelWarning => 'انتباہ';

  @override
  String get duelHintPad1 => 'دائیں اسٹک نشانہ لے کر فائر کرتی ہے';

  @override
  String get duelHintPad2Rt =>
      'RT، LB یا RB دبائے رکھیں: دائیں اسٹک سگل بناتی ہے';

  @override
  String get duelHintPad2Lt =>
      'LT، LB یا RB دبائے رکھیں: دائیں اسٹک سگل بناتی ہے';

  @override
  String get duelHintClassic =>
      'بائیں اسٹک اڑاتی ہے · B، RB یا RT ناک کی سمت فائر کرتے ہیں';

  @override
  String get duelHintKeys1 => 'تیر نشانہ لے کر فائر کرتے ہیں · WASD اڑاتا ہے';

  @override
  String get duelHintKeys2 =>
      'Space ناک کی سمت فائر کرتا ہے · نمپیڈ سگل بناتا ہے';

  @override
  String get arenaDuelBinding => 'ڈوئل انداز';

  @override
  String get duelBindingRt => 'RT + اسٹک';

  @override
  String get duelBindingLt => 'LT + اسٹک';

  @override
  String get arenaDuelFrame => 'پیڈ کا آگے';

  @override
  String get duelFrameNose => 'ناک';

  @override
  String get duelFrameUp => 'اوپر';

  @override
  String get arenaDuelAimFires => 'نشانہ فائر کرتا ہے';

  @override
  String get duelCutInFirst => 'باس کلوز اپ: پہلی بار';

  @override
  String get duelCutInAlways => 'باس کلوز اپ: ہمیشہ';

  @override
  String get duelCutInNever => 'باس کلوز اپ: کبھی نہیں';

  @override
  String get arenaDuelDrill => 'ڈوئل مشق';

  @override
  String get duelDrillOff => 'کوئی نہیں';

  @override
  String get duelDrillAim => 'نشانہ لو اور فائر کرو';

  @override
  String get duelDrillAimHow => 'دائیں اسٹک باس کی طرف کر کے اسے ماریں';

  @override
  String get duelDrillHold => 'ناک تھامو';

  @override
  String get duelDrillHoldHow =>
      'انداز کا بٹن دبائے رکھ کر اڑیں: ناک اپنی جگہ رہتی ہے';

  @override
  String get duelDrillDraw => 'آگے بناؤ';

  @override
  String get duelDrillDrawHow => 'انداز میں باس کی طرف ایک سگل بنائیں';

  @override
  String get duelDrillTurn => 'مڑو';

  @override
  String get duelDrillTurnHow => 'باس آپ کے نیچے ہے: ناک موڑ کر اسے ماریں';

  @override
  String get duelDrillDone => 'مکمل';
}
