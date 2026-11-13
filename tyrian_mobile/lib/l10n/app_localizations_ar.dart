// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get ok => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get connect => 'اتصال';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'تعذّر الاتصال بـ $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'كان المضيف ظاهرًا لكن الاتصال لم يكتمل.\n\nيحتاج اللعب القريب إلى Wi-Fi من نظير إلى نظير، ويوقفه iOS ما دامت نقطة الاتصال الشخصية مفعّلة — أوقف نقطة الاتصال على الجهازين وحاول مجددًا، أو صِل الجهازين بشبكة Wi-Fi نفسها.';

  @override
  String get gameOverCampaign =>
      'فشلت المهمة — احتفظت بالعتاد والرصيد. أعد المحاولة من مركز القيادة.';

  @override
  String get gameOverEndless =>
      'إعادة البناء في القطاع 1 — احتفظت بالعتاد والرصيد';

  @override
  String get waitingForHost => 'بانتظار المضيف...';

  @override
  String get waitingForHostHint => 'ستبدأ اللعبة عندما يكون المضيف جاهزًا';

  @override
  String get vesselLost => 'فُقدت المركبة';

  @override
  String scoreValue(String score) {
    return 'النقاط: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'الرصيد: $credits';
  }

  @override
  String get creditsPrefix => 'الرصيد: ';

  @override
  String get leaderboard => 'لوحة المتصدرين';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get redeploy => 'عودة إلى القتال';

  @override
  String get resume => 'استئناف';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get skins => 'المظاهر';

  @override
  String get skin => 'المظهر';

  @override
  String get soundOn => 'الصوت: تشغيل';

  @override
  String get soundOff => 'الصوت: إيقاف';

  @override
  String get musicOn => 'الموسيقى: تشغيل';

  @override
  String get musicOff => 'الموسيقى: إيقاف';

  @override
  String get mainMenu => 'القائمة الرئيسية';

  @override
  String get quitToDesktop => 'الخروج إلى سطح المكتب';

  @override
  String get selectSkin => 'اختر المظهر';

  @override
  String get difficulty => 'الصعوبة';

  @override
  String get difficultyEasy => 'سهل';

  @override
  String get difficultyNormal => 'عادي';

  @override
  String get difficultyHard => 'صعب';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'الحملة';

  @override
  String get quit => 'خروج';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get locked => 'مقفل';

  @override
  String get mainMenuTooltip => 'القائمة الرئيسية';

  @override
  String nodeLevel(int level) {
    return 'المستوى $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'المستوى $level · الزعيم $ordinal';
  }

  @override
  String get nodeLockedHint => 'مقفل. أنهِ العقدة السابقة أولًا.';

  @override
  String get flyAgain => 'حلّق مجددًا';

  @override
  String get launch => 'انطلاق';

  @override
  String zoneLabel(int zone) {
    return 'المنطقة $zone';
  }

  @override
  String get objectiveStar => 'نجمة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get replayNode => 'إعادة العقدة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get nodeCleared => 'اكتملت العقدة';

  @override
  String get nodeFailed => 'فشلت العقدة';

  @override
  String get weaponTierUnlocked => 'فُتح مستوى أسلحة جديد';

  @override
  String get onSaleInComCenter => 'متوفر للبيع في مركز القيادة.';

  @override
  String get requiredTasksHint =>
      'المهام المطلوبة هي التي تحسم العقدة. حلّق فيها مجددًا — ما كسبته يبقى معك.';

  @override
  String get objClear => 'طهّر القطاع';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أسقط $count عدو',
      many: 'أسقط $count عدوًا',
      few: 'أسقط $count أعداء',
      two: 'أسقط عدوّين',
      one: 'أسقط عدوًا واحدًا',
      zero: 'أسقط $count عدو',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'لا تتلقَّ أي ضرر في الهيكل';

  @override
  String objHull(int percent) {
    return 'أنهِ والهيكل فوق $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'دمّر $count بسلاح $weapon',
      many: 'دمّر $count بسلاح $weapon',
      few: 'دمّر $count بسلاح $weapon',
      two: 'دمّر اثنين بسلاح $weapon',
      one: 'دمّر واحدًا بسلاح $weapon',
      zero: 'دمّر $count بسلاح $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'دمّر $count بالمدافع الجانبية',
      many: 'دمّر $count بالمدافع الجانبية',
      few: 'دمّر $count بالمدافع الجانبية',
      two: 'دمّر اثنين بالمدافع الجانبية',
      one: 'دمّر واحدًا بالمدافع الجانبية',
      zero: 'دمّر $count بالمدافع الجانبية',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'انطلق وسلاح $weapon في المقدمة';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'انطلق وسلاح $weapon على حامل جانبي';
  }

  @override
  String get objBuySideGun => 'اشترِ مدفعًا جانبيًا من مركز القيادة';

  @override
  String objUpgradeGenerator(int level) {
    return 'طوّر المولّد إلى المستوى $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'طوّر المدفع الأمامي إلى المستوى $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'طوّر مدفعًا جانبيًا إلى المستوى $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'التقط $count مكافأة',
      many: 'التقط $count مكافأة',
      few: 'التقط $count مكافآت',
      two: 'التقط مكافأتين',
      one: 'التقط مكافأة واحدة',
      zero: 'التقط $count مكافأة',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أبِد $count تشكيل كامل',
      many: 'أبِد $count تشكيلًا كاملًا',
      few: 'أبِد $count تشكيلات كاملة',
      two: 'أبِد تشكيلين كاملين',
      one: 'أبِد تشكيلًا كاملًا واحدًا',
      zero: 'أبِد $count تشكيل كامل',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'لا تصطدم بأي كويكب';

  @override
  String objUnderTime(int seconds) {
    return 'أنهِ خلال $seconds ث';
  }

  @override
  String get objStripBoss => 'دمّر كل أجزاء الزعيم قبل النواة';

  @override
  String get joinCoopTitle => 'الانضمام إلى اللعب التعاوني';

  @override
  String get cannotSearchNetwork => 'لا يمكن البحث في هذه الشبكة';

  @override
  String get joinHintNearby =>
      'شبكة Wi-Fi نفسها تعمل على كل الأجهزة. يجد iPhone وiPad وMac بعضها بالقرب من دونها أيضًا — مع إيقاف نقطة الاتصال الشخصية على الجهازين.';

  @override
  String get joinHintWifi =>
      'يجب أن يكون اللاعبان على شبكة Wi-Fi نفسها — نقطة الاتصال الشخصية تصلح أيضًا.';

  @override
  String noHostsYet(String hint) {
    return 'لا يوجد مضيفون بعد. $hint';
  }

  @override
  String get lookingForHosts => 'جارٍ البحث عن مضيفين على هذه الشبكة وبالقرب…';

  @override
  String get hostNearby => 'بالقرب · Bluetooth / Wi-Fi من نظير إلى نظير';

  @override
  String hostSameWifi(String address) {
    return '$address · شبكة Wi-Fi نفسها';
  }

  @override
  String get enterIpManually => 'أدخل IP يدويًا';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'درع';

  @override
  String get hudPower => 'طاقة';

  @override
  String get hudGen => 'مولّد';

  @override
  String bossShielded(String name) {
    return '$name — محمي بدرع';
  }

  @override
  String get bossPartTurret => 'برج';

  @override
  String get bossPartShieldPod => 'وحدة الدرع';

  @override
  String get bossPartThruster => 'دافع';

  @override
  String get bossPartCannon => 'مدفع';

  @override
  String sectorUnknownSpace(int level) {
    return 'القطاع $level — فضاء مجهول';
  }

  @override
  String get player2Joined => 'انضم اللاعب 2!';

  @override
  String get player2Disconnected => 'انقطع اتصال اللاعب 2';

  @override
  String get hostDisconnected => 'انقطع اتصال المضيف';

  @override
  String maxLevelSold(String amount) {
    return 'أقصى مستوى! بيع مقابل \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'فُتح مستوى الأسلحة $tier';
  }

  @override
  String get cheatsEnabled => 'الغش مفعّل';

  @override
  String get cheatsDisabled => 'الغش معطّل';

  @override
  String get cheatsMaxed => 'غش: الرصيد في الحد الأقصى، كل الأسلحة مفتوحة';

  @override
  String get cheats => 'الغش';

  @override
  String get maxCredits => 'أقصى رصيد';

  @override
  String get sectionStats => 'الإحصاءات';

  @override
  String get sectionLoadout => 'العتاد';

  @override
  String levelShort(int level) {
    return 'م$level';
  }

  @override
  String get max => 'أقصى';

  @override
  String get upgradeShort => 'تطوير';

  @override
  String get sell => 'بيع';

  @override
  String get buy => 'شراء';

  @override
  String get commandCenter => 'مركز القيادة';

  @override
  String get pilot => 'الطيار';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'النقاط';

  @override
  String get nextWeapon => 'السلاح التالي';

  @override
  String pointsValue(String points) {
    return '$points نقطة';
  }

  @override
  String get slotFront => 'أمامي';

  @override
  String get slotLeft => 'يسار';

  @override
  String get slotRight => 'يمين';

  @override
  String get slotGen => 'مولّد';

  @override
  String get power => 'طاقة';

  @override
  String get launchMission => 'إطلاق المهمة';

  @override
  String get startMission => 'بدء المهمة';

  @override
  String get continueMission => 'متابعة المهمة';

  @override
  String get padControlsHint =>
      '[↑↓] صف   [←→] اختيار   [B] شراء/تطوير/تبديل   [X/Y] بيع   [OPTIONS] متابعة المهمة';

  @override
  String get host => 'استضافة';

  @override
  String hostingAs(String name) {
    return 'تستضيف باسم $name';
  }

  @override
  String get join => 'انضمام';

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
  String get overload => 'حمل زائد';

  @override
  String weaponOff(String weapon) {
    return '$weapon متوقف — المولّد ضعيف جدًا';
  }

  @override
  String unlocksAt(String points) {
    return 'يُفتح عند $points نقطة';
  }

  @override
  String joinConnecting(String target) {
    return 'جارٍ الاتصال بـ $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'لم يرد المضيف: $reason.\n\nيجب أن يكون اللاعبان على شبكة Wi-Fi نفسها (نقطة الاتصال الشخصية تصلح أيضًا)، وأن يكون المضيف قد ضغط استضافة. تحقق من العنوان وحاول مجددًا.';
  }

  @override
  String get lanJoinNoAnswer => 'لا رد';

  @override
  String objBossUnder(int seconds) {
    return 'دمّر نواة الزعيم خلال $seconds ث من وصوله';
  }

  @override
  String get sectionHangar => 'الحظيرة';

  @override
  String get sectionVault => 'الخزنة';

  @override
  String get rackSide => 'جانبي';

  @override
  String get rackHull => 'الهيكل';

  @override
  String get rarityCommon => 'شائع';

  @override
  String get rarityRare => 'نادر';

  @override
  String get rarityMythic => 'أسطوري';

  @override
  String get curse => 'لعنة';

  @override
  String get modFit => 'تركيب';

  @override
  String get modUnfit => 'فكّ';

  @override
  String get modForge => 'المصهر';

  @override
  String get forgeHint => 'اختر 3 من الندرة نفسها لتصهر 1 من الندرة التالية';

  @override
  String get vaultEmpty =>
      'لا تعديلات بعد. أنهِ عقدة بكل النجوم، أو اهزم زعيمًا بسرعة، أو أسقط زعيمًا في الوضع اللانهائي.';

  @override
  String modNeeds(String families) {
    return 'يعمل مع $families';
  }

  @override
  String get modRackFull => 'الحامل ممتلئ';

  @override
  String get modAlreadyFitted => 'مركّب بالفعل';

  @override
  String get modWrongRack => 'لا يناسب هذا الحامل';

  @override
  String modsSpilled(int n) {
    return 'عادت $n تعديلات إلى الخزنة';
  }

  @override
  String get hullLocked => 'مقفل';

  @override
  String hullUnlockBoss(int n) {
    return 'اهزم زعيم الحملة $n';
  }

  @override
  String get hullUnlockFinish => 'أنهِ الحملة أو اصل إلى القطاع 30';

  @override
  String get statAgility => 'رشاقة';

  @override
  String get statHitbox => 'إصابة';

  @override
  String get perkNone => 'مركبة قياسية';

  @override
  String get perkAfterimage => 'اثبت مكانك: الطلقات ×1.5';

  @override
  String get perkBulwark => 'الضرر الذي يتجاوز الدرع يُخفَّض إلى النصف';

  @override
  String get perkOverclock => 'يطلق حتى 130 % من السعة، بإيقاع أبطأ';

  @override
  String get perkBattery => 'طائرة مسيّرة مسلحة مجانية ترافقك';

  @override
  String get rewardTitle => 'مكافأة';

  @override
  String newHull(String name) {
    return 'هيكل جديد: $name';
  }

  @override
  String get socketEmpty => 'فارغ';

  @override
  String fxStreams(int n) {
    return '$n تيارات متوازية';
  }

  @override
  String fxFan(int n) {
    return 'مروحة من $n طلقات';
  }

  @override
  String fxSalvo(int n) {
    return 'رشقة من $n طلقات';
  }

  @override
  String fxFireRate(String x) {
    return 'معدل الإطلاق ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'الضرر ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'سرعة الطلقات ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'حجم الطلقات ×$x';
  }

  @override
  String fxPower(String x) {
    return 'استهلاك الطاقة ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'توجيه ذاتي +$n';
  }

  @override
  String fxPierce(int n) {
    return 'يخترق $n أهداف';
  }

  @override
  String get fxPierceAll => 'يخترق كل شيء';

  @override
  String fxCrit(int pct, String x) {
    return 'فرصة $pct % لضرر ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'ضربات حرجة ×$x على الزعماء';
  }

  @override
  String fxFork(int n) {
    return 'الإسقاط ينثر $n طلقات';
  }

  @override
  String get fxChain => 'الطلقات المنثورة تنتثر مجددًا';

  @override
  String get fxSplit => 'ينقسم إلى اثنين عند الإصابة';

  @override
  String get fxFrost => 'الإصابات تبطئ الأعداء';

  @override
  String get fxCrossfire => 'المدافع الجانبية تميل إلى الداخل';

  @override
  String get fxRearguard => 'المدافع الجانبية تطلق إلى الخلف أيضًا';

  @override
  String get fxOrbit => 'الطلقات تتمايل';

  @override
  String fxBounce(int n) {
    return 'يرتد عن الجدران $n×';
  }

  @override
  String get fxBounceTop => '…وعن الأعلى أيضًا';

  @override
  String get fxOverdrive => 'يطلق بدَين من الطاقة';

  @override
  String get fxReactor => 'الأسلحة فوق السعة تطلق رغم ذلك، ببطء';

  @override
  String fxGenPower(String x) {
    return 'شحن المولّد ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'سعة المولّد ×$x';
  }

  @override
  String get fxSurge => 'مولّد ممتلئ: الطلقات ×2';

  @override
  String fxSiphon(int pct) {
    return 'الإسقاط يعيد $pct % من الطاقة';
  }

  @override
  String fxHp(String x) {
    return 'الهيكل ×$x';
  }

  @override
  String fxShield(String x) {
    return 'الدرع ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'تجدد الدرع ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'الإسقاط يشفي $n HP';
  }

  @override
  String get fxMagnet => 'يجذب المكافآت';

  @override
  String get fxMagnetAll => 'يجذب كل المكافآت';

  @override
  String fxReflect(int pct) {
    return '$pct % من الطلقات ترتد عن الدرع';
  }

  @override
  String get fxReflectGuided => 'الطلقات المرتدة موجّهة';

  @override
  String fxGhost(String sec) {
    return 'منيع لمدة $sec ث بعد إصابة الهيكل';
  }

  @override
  String get fxNova => 'انكسار الدرع: انفجار يعم الشاشة كلها';

  @override
  String fxAgility(String x) {
    return 'الرشاقة ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'منطقة الإصابة ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'الرصيد ×$x';
  }

  @override
  String fxScore(String x) {
    return 'النقاط ×$x';
  }

  @override
  String get fxSatellite => 'طائرة مسيّرة مسلحة ترافقك';

  @override
  String get fxTimewarp => 'إصابة الهيكل تبطئ الزمن';

  @override
  String get fxGambler => 'كل طلقة سلاح عشوائي';

  @override
  String get vaultAll => 'الكل';

  @override
  String get sigilMissUnknown => 'شكل غير معروف';

  @override
  String get sigilMissTooSlow => 'بطيء جدًا';

  @override
  String get sigilMissSkippedDot => 'تخطّيت نقطة';

  @override
  String get sigilMissLeftRimEarly => 'أفلتَّ مبكرًا';

  @override
  String get sigilMissWrongDirection => 'مرسوم بالعكس';

  @override
  String get sigilMissWrongLayer => 'زر كتف خاطئ';

  @override
  String get sigilDry => 'الشحنة غير كافية';

  @override
  String get sigilBusy => 'السابق ما زال يعمل';

  @override
  String get arena => 'الحلبة';

  @override
  String get arenaBossParts => 'أجزاء الزعيم';

  @override
  String get arenaBareCore => 'النواة مكشوفة';

  @override
  String get arenaCompanions => 'المرافقون';

  @override
  String get arenaCharge => 'الشحنة';

  @override
  String get arenaChargeNormal => 'عادية';

  @override
  String get arenaSpeed => 'سرعة العالم';

  @override
  String get arenaDrill => 'تمرين';

  @override
  String get arenaFreePlay => 'لعب حر';

  @override
  String get arenaFight => 'قتال';

  @override
  String get arenaNewBoss => 'زعيم جديد';

  @override
  String get arenaLeave => 'مغادرة الحلبة';

  @override
  String get arenaHint => 'يعود الزعيم لحظة موته. لا يُحفظ شيء هنا.';

  @override
  String get arenaColCast => 'رسم';

  @override
  String get arenaColMiss => 'خطأ';

  @override
  String get arenaColAvg => 'متوسط';

  @override
  String get arenaColBest => 'الأفضل';

  @override
  String get arenaColTime => 'الأسرع';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'الزعماء $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'اليد: الرموز';

  @override
  String get padSchemeClassic => 'اليد: كلاسيكي';

  @override
  String get padSouthpawOn => 'أعسر: تشغيل';

  @override
  String get padSouthpawOff => 'أعسر: إيقاف';

  @override
  String get sigilDescHop => 'قفزة سريعة باتجاه التحريك';

  @override
  String get sigilDescSidestep => 'خطوة جانبية طويلة عبر الساحة';

  @override
  String get sigilDescStrike => 'اندفاع بثلاث طلقات ثقيلة ثم عودة';

  @override
  String get sigilDescRetreat => 'تراجع مع نيران تغطية إلى الأمام';

  @override
  String get sigilDescDash => 'اندفاع قطري عبر النيران، منيع في منتصفه';

  @override
  String get sigilDescRoll => 'دحرجة جانبية، منيع';

  @override
  String get sigilDescShadow => 'اثبت تحت أقرب عدو وواصل الإطلاق';

  @override
  String get sigilDescEcho => 'ظل يعيد آخر ثانيتين بنصف الضرر';

  @override
  String get sigilDescLoop => 'حلقة من الأعلى: تمر الطلقات من تحتك';

  @override
  String get sigilDescSlalom => 'منعطف S عبر الساحة بنيران مروحية';

  @override
  String get sigilDescCorkscrew =>
      'دوران لولبي للأمام بنيران في كل اتجاه، منيع';

  @override
  String get sigilDescSnapshot => 'طلقة ثقيلة واحدة باتجاه التحريك';

  @override
  String get sigilDescBroadside => 'رشقة من الجانبين';

  @override
  String get sigilDescVolley => 'خمسة أشعة مشحونة للأمام';

  @override
  String get sigilDescCaltrop => 'ألقِ لغمًا يبتلع الطلقات وينفجر';

  @override
  String get sigilDescFrenzy => 'تطلق الأسلحة أسرع لبضع ثوانٍ';

  @override
  String get sigilDescStasis => 'يبطؤ الأعداء وطلقاتهم إلى النصف';

  @override
  String get sigilDescHalo => 'يُشحن الدرع أسرع بأربع مرات ولا يخترقه شيء';

  @override
  String get sigilDescRadial => 'حلقة من ست عشرة طلقة';

  @override
  String get sigilDescStorm => 'كل الأسلحة بأقصى طاقة، مجانًا';

  @override
  String get sigilDescPing => 'يركّز المرافقون النيران حيث تحرّك';

  @override
  String get sigilDescWingman => 'استدعِ مرافق جناح إلى الجهة التي رسمت نحوها';

  @override
  String get sigilDescHunter => 'استدعِ صيادًا يطير أمامك ويختار الأهداف';

  @override
  String get sigilDescWarden => 'استدعِ حارسًا يتلقى الطلقات عنك';

  @override
  String get sigilDescFormation => 'يتبدّل المرافقون بين تشكيل عريض وإسفين';

  @override
  String get sigilDescWhirl => 'يدور المرافقون حولك ويبتلعون الطلقات';

  @override
  String get sigilDescSacrifice => 'ينقضّ المرافقون وينفجرون ويعيدون الشحنة';

  @override
  String get grimoire => 'كتاب الرموز';

  @override
  String get grimoireHint =>
      'ارسم بالعصا اليمنى. اضغط LB للأسلحة، RB للجناح، كليهما لـ MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'التكلفة $cost';
  }

  @override
  String get sigilUntouchable => 'منيع';

  @override
  String get lessonWatch => 'شاهد';

  @override
  String get lessonTrace => 'تتبّعه';

  @override
  String get lessonSlow => 'ببطء';

  @override
  String get lessonLive => 'سرعة كاملة';

  @override
  String get lessonStreak => 'خمسة متتالية';

  @override
  String get lessonLearned => 'تم التعلّم';

  @override
  String lessonTempo(int pct) {
    return 'الإيقاع $pct %';
  }

  @override
  String get hintHop => 'حرّك العصا اليمنى بسرعة';

  @override
  String get hintLoop => 'ارسم دائرة: تطير فوق الطلقات';

  @override
  String get hintStream => 'اضغط LT: تياران أو ثلاثة';

  @override
  String get arenaKata => 'كاتا';

  @override
  String get arenaKataOff => 'لا شيء';

  @override
  String kataNext(String sigil, String secs) {
    return 'التالي $sigil بعد $secs ث';
  }

  @override
  String get arenaGauntlet => 'التحدي';

  @override
  String get arenaOn => 'تشغيل';

  @override
  String get arenaOff => 'إيقاف';

  @override
  String gauntletRating(int rating, int best) {
    return 'التقييم $rating · الأفضل $best';
  }

  @override
  String get duelWarning => 'تحذير';

  @override
  String get duelHintPad1 => 'العصا اليمنى تصوّب وتطلق';

  @override
  String get duelHintPad2Rt => 'اضغط RT أو LB أو RB: العصا اليمنى ترسم الرموز';

  @override
  String get duelHintPad2Lt => 'اضغط LT أو LB أو RB: العصا اليمنى ترسم الرموز';

  @override
  String get duelHintClassic =>
      'العصا اليسرى للطيران · B أو RB أو RT تطلق باتجاه المقدمة';

  @override
  String get duelHintKeys1 => 'الأسهم تصوّب وتطلق · WASD للطيران';

  @override
  String get duelHintKeys2 =>
      'المسافة تطلق باتجاه المقدمة · لوحة الأرقام ترسم الرموز';

  @override
  String get arenaDuelBinding => 'وضعية المبارزة';

  @override
  String get duelBindingRt => 'RT + العصا';

  @override
  String get duelBindingLt => 'LT + العصا';

  @override
  String get arenaDuelFrame => 'أمام اليد';

  @override
  String get duelFrameNose => 'المقدمة';

  @override
  String get duelFrameUp => 'أعلى';

  @override
  String get arenaDuelAimFires => 'التصويب يطلق';

  @override
  String get duelCutInFirst => 'لقطة الزعيم: أول مرة';

  @override
  String get duelCutInAlways => 'لقطة الزعيم: دائمًا';

  @override
  String get duelCutInNever => 'لقطة الزعيم: أبدًا';

  @override
  String get arenaDuelDrill => 'تمرين المبارزة';

  @override
  String get duelDrillOff => 'لا شيء';

  @override
  String get duelDrillAim => 'صوّب وأطلق';

  @override
  String get duelDrillAimHow => 'وجّه العصا اليمنى نحو الزعيم وأصبه';

  @override
  String get duelDrillHold => 'ثبّت المقدمة';

  @override
  String get duelDrillHoldHow => 'اضغط زر الوضعية وطِر: تبقى المقدمة ثابتة';

  @override
  String get duelDrillDraw => 'ارسم للأمام';

  @override
  String get duelDrillDrawHow => 'في الوضعية، ارسم رمزًا نحو الزعيم';

  @override
  String get duelDrillTurn => 'استدر';

  @override
  String get duelDrillTurnHow => 'الزعيم تحتك: أدر المقدمة وأصبه';

  @override
  String get duelDrillDone => 'تم';
}
