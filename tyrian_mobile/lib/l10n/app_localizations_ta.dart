// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get connect => 'இணை';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName உடன் இணைக்க முடியவில்லை';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ஹோஸ்ட் தெரிந்தது, ஆனால் இணைப்பு உருவாகவில்லை.\n\nஅருகிலுள்ள விளையாட்டுக்கு பியர்-டு-பியர் வைஃபை தேவை; தனிப்பட்ட ஹாட்ஸ்பாட் இயக்கத்தில் இருக்கும்போது iOS அதை அணைத்துவிடும். இரு சாதனங்களிலும் ஹாட்ஸ்பாட்டை அணைத்து மீண்டும் முயலுங்கள், அல்லது இரண்டையும் ஒரே வைஃபையில் இணையுங்கள்.';

  @override
  String get gameOverCampaign =>
      'பணி தோல்வி — ஆயுதத் தொகுப்பும் கிரெடிட்டும் தக்கவைக்கப்பட்டன. காம் சென்டரில் இருந்து மீண்டும் முயலுங்கள்.';

  @override
  String get gameOverEndless =>
      'செக்டர் 1 இல் மீண்டும் கட்டமைக்கிறது — ஆயுதத் தொகுப்பும் கிரெடிட்டும் தக்கவைக்கப்பட்டன';

  @override
  String get waitingForHost => 'ஹோஸ்ட்டுக்காகக் காத்திருக்கிறது...';

  @override
  String get waitingForHostHint => 'ஹோஸ்ட் தயாரானதும் ஆட்டம் தொடங்கும்';

  @override
  String get vesselLost => 'விண்கலம் இழப்பு';

  @override
  String scoreValue(String score) {
    return 'மதிப்பெண்: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'கிரெடிட்: $credits';
  }

  @override
  String get creditsPrefix => 'கிரெடிட்:';

  @override
  String get leaderboard => 'முன்னணிப் பலகை';

  @override
  String get achievements => 'சாதனைகள்';

  @override
  String get redeploy => 'மீண்டும் நிறுத்து';

  @override
  String get resume => 'தொடர்';

  @override
  String get pause => 'இடைநிறுத்து';

  @override
  String get paused => 'இடைநிறுத்தப்பட்டது';

  @override
  String get skins => 'ஸ்கின்கள்';

  @override
  String get skin => 'ஸ்கின்';

  @override
  String get soundOn => 'ஒலி: இயக்கம்';

  @override
  String get soundOff => 'ஒலி: நிறுத்தம்';

  @override
  String get musicOn => 'இசை: இயக்கம்';

  @override
  String get musicOff => 'இசை: நிறுத்தம்';

  @override
  String get mainMenu => 'முதன்மை மெனு';

  @override
  String get quitToDesktop => 'டெஸ்க்டாப்புக்கு வெளியேறு';

  @override
  String get selectSkin => 'ஸ்கின்னைத் தேர்ந்தெடு';

  @override
  String get difficulty => 'கடினம்';

  @override
  String get difficultyEasy => 'எளிது';

  @override
  String get difficultyNormal => 'சாதாரணம்';

  @override
  String get difficultyHard => 'கடினம்';

  @override
  String get difficultyLord => 'லார்டு';

  @override
  String get campaign => 'பிரச்சாரம்';

  @override
  String get quit => 'வெளியேறு';

  @override
  String get restorePurchases => 'வாங்கியவற்றை மீட்டமை';

  @override
  String get locked => 'பூட்டப்பட்டது';

  @override
  String get mainMenuTooltip => 'முதன்மை மெனு';

  @override
  String nodeLevel(int level) {
    return 'நிலை $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'நிலை $level · தலைவன் $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'பூட்டப்பட்டது. அதற்கு முந்தைய நோடை முடியுங்கள்.';

  @override
  String get flyAgain => 'மீண்டும் பற';

  @override
  String get launch => 'ஏவு';

  @override
  String zoneLabel(int zone) {
    return 'மண்டலம் $zone';
  }

  @override
  String get objectiveStar => 'நட்சத்திரம்';

  @override
  String get continueButton => 'தொடர்';

  @override
  String get replayNode => 'நோடை மீண்டும் விளையாடு';

  @override
  String get retry => 'மீண்டும் முயல்';

  @override
  String get nodeCleared => 'நோட் முடிந்தது';

  @override
  String get nodeFailed => 'நோட் தோல்வி';

  @override
  String get weaponTierUnlocked => 'ஆயுத நிலை திறக்கப்பட்டது';

  @override
  String get onSaleInComCenter => 'காம் சென்டரில் விற்பனைக்கு உள்ளது.';

  @override
  String get requiredTasksHint =>
      'தேவையான பணிகளே நோடின் முடிவைத் தீர்மானிக்கும். மீண்டும் பறக்கவும் — நீங்கள் பெற்றது உங்களிடமே இருக்கும்.';

  @override
  String get objClear => 'செக்டரைத் துடைத்தெடு';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count எதிரிகளைச் சுட்டு வீழ்த்து',
      one: '$count எதிரியைச் சுட்டு வீழ்த்து',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'கலத்தில் சேதம் ஏற்படாமல் இரு';

  @override
  String objHull(int percent) {
    return '$percent% க்கு மேல் கலத்துடன் முடி';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon மூலம் $count எதிரிகளைக் கொல்',
      one: '$weapon மூலம் $count எதிரியைக் கொல்',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பக்கத் துப்பாக்கிகளால் $count எதிரிகளைக் கொல்',
      one: 'பக்கத் துப்பாக்கிகளால் $count எதிரியைக் கொல்',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon ஐ முன்புறத்தில் பொருத்தி ஏவு';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon ஐ பக்க ஏற்றியில் பொருத்தி ஏவு';
  }

  @override
  String get objBuySideGun => 'காம் சென்டரில் ஒரு பக்கத் துப்பாக்கியை வாங்கு';

  @override
  String objUpgradeGenerator(int level) {
    return 'ஜெனரேட்டரை நிலை $level க்கு மேம்படுத்து';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'முன் துப்பாக்கியை நிலை $level க்கு மேம்படுத்து';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ஒரு பக்கத் துப்பாக்கியை நிலை $level க்கு மேம்படுத்து';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பிக்கப்புகளைப் பிடி',
      one: '$count பிக்கப்பைப் பிடி',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count முழு அணிகளையும் அழி',
      one: '$count முழு அணியையும் அழி',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'எந்தச் சிறுகோளையும் மோதாதே';

  @override
  String objUnderTime(int seconds) {
    return '${seconds}s க்குள் முடி';
  }

  @override
  String get objStripBoss =>
      'கோருக்கு முன் தலைவனின் அனைத்துப் பாகங்களையும் அழி';

  @override
  String get joinCoopTitle => 'கூட்டாட்டத்தில் சேர்';

  @override
  String get cannotSearchNetwork => 'இந்த நெட்வொர்க்கில் தேட முடியாது';

  @override
  String get joinHintNearby =>
      'ஒரே வைஃபை எல்லா சாதனங்களிலும் வேலை செய்யும். iPhone, iPad, Mac ஆகியவை வைஃபை இல்லாமலும் அருகில் ஒன்றையொன்று கண்டறியும் — இரண்டிலும் தனிப்பட்ட ஹாட்ஸ்பாட் அணைந்திருக்க வேண்டும்.';

  @override
  String get joinHintWifi =>
      'இரு ஆட்டக்காரர்களும் ஒரே வைஃபையில் இருக்க வேண்டும் — தனிப்பட்ட ஹாட்ஸ்பாட்டும் போதும்.';

  @override
  String noHostsYet(String hint) {
    return 'இன்னும் ஹோஸ்ட்கள் இல்லை. $hint';
  }

  @override
  String get lookingForHosts =>
      'இந்த வைஃபையிலும் அருகிலும் ஹோஸ்ட்களைத் தேடுகிறது…';

  @override
  String get hostNearby => 'அருகில் · புளூடூத் / பியர்-டு-பியர் வைஃபை';

  @override
  String hostSameWifi(String address) {
    return '$address · அதே வைஃபை';
  }

  @override
  String get enterIpManually => 'IP ஐக் கைமுறையாக உள்ளிடு';

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
    return '$name — கேடயத்துடன்';
  }

  @override
  String get bossPartTurret => 'துப்பாக்கிக் கோபுரம்';

  @override
  String get bossPartShieldPod => 'கேடயப் பெட்டி';

  @override
  String get bossPartThruster => 'உந்துவிசை';

  @override
  String get bossPartCannon => 'பீரங்கி';

  @override
  String sectorUnknownSpace(int level) {
    return 'செக்டர் $level — அறியப்படாத விண்வெளி';
  }

  @override
  String get player2Joined => 'ஆட்டக்காரர் 2 சேர்ந்தார்!';

  @override
  String get player2Disconnected => 'ஆட்டக்காரர் 2 துண்டிக்கப்பட்டார்';

  @override
  String get hostDisconnected => 'ஹோஸ்ட் துண்டிக்கப்பட்டார்';

  @override
  String maxLevelSold(String amount) {
    return 'அதிகபட்ச நிலை! \$$amount க்கு விற்கப்பட்டது';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ஆயுத நிலை $tier திறக்கப்பட்டது';
  }

  @override
  String get cheatsEnabled => 'ஏமாற்றுகள் இயக்கப்பட்டன';

  @override
  String get cheatsDisabled => 'ஏமாற்றுகள் முடக்கப்பட்டன';

  @override
  String get cheatsMaxed =>
      'ஏமாற்று: கிரெடிட் அதிகபட்சம், அனைத்து ஆயுதங்களும் திறக்கப்பட்டன';

  @override
  String get cheats => 'ஏமாற்றுகள்';

  @override
  String get maxCredits => 'அதிகபட்ச கிரெடிட்';

  @override
  String get sectionStats => 'புள்ளிவிவரம்';

  @override
  String get sectionLoadout => 'ஆயுதத் தொகுப்பு';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'மேம்படுத்து';

  @override
  String get sell => 'விற்கவும்';

  @override
  String get buy => 'வாங்கவும்';

  @override
  String get commandCenter => 'கமாண்ட் சென்டர்';

  @override
  String get pilot => 'விமானி';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'மதிப்பெண்';

  @override
  String get nextWeapon => 'அடுத்த ஆயுதம்';

  @override
  String pointsValue(String points) {
    return '$points புள்ளிகள்';
  }

  @override
  String get slotFront => 'முன்';

  @override
  String get slotLeft => 'இடது';

  @override
  String get slotRight => 'வலது';

  @override
  String get slotGen => 'ஜெனரேட்டர்';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'பணியை ஏவு';

  @override
  String get startMission => 'பணியைத் தொடங்கு';

  @override
  String get continueMission => 'பணியைத் தொடர்';

  @override
  String get padControlsHint =>
      '[↑↓] வரிசை   [←→] தேர்வு   [B] வாங்கு/மேம்படுத்து/மாற்று   [X/Y] விற்கவும்   [OPTIONS] பணியைத் தொடர்';

  @override
  String get host => 'ஹோஸ்ட்';

  @override
  String hostingAs(String name) {
    return '$name ஆக ஹோஸ்ட் செய்கிறது';
  }

  @override
  String get join => 'சேர்';

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
  String get overload => 'அதிக சுமை';

  @override
  String weaponOff(String weapon) {
    return '$weapon நிறுத்தம் — ஜெனரேட்டர் பலவீனம்';
  }

  @override
  String unlocksAt(String points) {
    return '$points புள்ளிகளில் திறக்கும்';
  }

  @override
  String joinConnecting(String target) {
    return '$target உடன் இணைக்கிறது…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ஹோஸ்ட் பதிலளிக்கவில்லை: $reason.\n\nஇரு ஆட்டக்காரர்களும் ஒரே வைஃபையில் இருக்க வேண்டும் (தனிப்பட்ட ஹாட்ஸ்பாட்டும் போதும்), ஹோஸ்ட் HOST ஐ அழுத்தியிருக்க வேண்டும். முகவரியைச் சரிபார்த்து மீண்டும் முயலுங்கள்.';
  }

  @override
  String get lanJoinNoAnswer => 'பதில் இல்லை';

  @override
  String objBossUnder(int seconds) {
    return 'தலைவன் வந்த ${seconds}s க்குள் அதன் கோரை அழி';
  }

  @override
  String get sectionHangar => 'ஹேங்கர்';

  @override
  String get sectionVault => 'பெட்டகம்';

  @override
  String get rackSide => 'பக்கம்';

  @override
  String get rackHull => 'கலம்';

  @override
  String get rarityCommon => 'சாதாரணம்';

  @override
  String get rarityRare => 'அரிது';

  @override
  String get rarityMythic => 'புராணம்';

  @override
  String get curse => 'சாபம்';

  @override
  String get modFit => 'பொருந்தும்';

  @override
  String get modUnfit => 'பொருந்தாது';

  @override
  String get modForge => 'உருவாக்கு';

  @override
  String get forgeHint =>
      'ஒரே அரிதான தன்மையில் 3 ஐத் தேர்ந்து அடுத்த நிலையின் 1 ஐ உருவாக்குங்கள்';

  @override
  String get vaultEmpty =>
      'இன்னும் மோட்கள் இல்லை. முழு நட்சத்திரங்களுடன் நோடை முடியுங்கள், தலைவனை விரைவாக வெல்லுங்கள், அல்லது முடிவற்ற தலைவனை வீழ்த்துங்கள்.';

  @override
  String modNeeds(String families) {
    return '$families உடன் வேலை செய்யும்';
  }

  @override
  String get modRackFull => 'தட்டு நிரம்பியது';

  @override
  String get modAlreadyFitted => 'ஏற்கனவே பொருத்தப்பட்டது';

  @override
  String get modWrongRack => 'இந்தத் தட்டுக்குப் பொருந்தாது';

  @override
  String modsSpilled(int n) {
    return '$n மோட்கள் பெட்டகத்துக்குத் திரும்பின';
  }

  @override
  String get hullLocked => 'பூட்டப்பட்டது';

  @override
  String hullUnlockBoss(int n) {
    return 'பிரச்சாரத் தலைவன் $n ஐ வெல்லுங்கள்';
  }

  @override
  String get hullUnlockFinish =>
      'பிரச்சாரத்தை முடியுங்கள் அல்லது செக்டர் 30 ஐ அடையுங்கள்';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'சாதாரண விண்கலம்';

  @override
  String get perkAfterimage => 'அசையாமல் இரு: குண்டுகள் ×1.5';

  @override
  String get perkBulwark => 'கேடயத்தைத் தாண்டும் சேதம் பாதியாகும்';

  @override
  String get perkOverclock =>
      'கொள்ளளவின் 130 % வரை துப்பாக்கிகளைச் சுடும், மெதுவாக';

  @override
  String get perkBattery => 'ஒரு இலவச துப்பாக்கி ட்ரோன் உடன் வரும்';

  @override
  String get rewardTitle => 'பரிசு';

  @override
  String newHull(String name) {
    return 'புதிய கலம்: $name';
  }

  @override
  String get socketEmpty => 'காலி';

  @override
  String fxStreams(int n) {
    return '$n இணை ஓடைகள்';
  }

  @override
  String fxFan(int n) {
    return '$n குண்டுகளின் விசிறி';
  }

  @override
  String fxSalvo(int n) {
    return '$n-குண்டு சால்வோ';
  }

  @override
  String fxFireRate(String x) {
    return 'சுடும் வேகம் ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'சேதம் ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'குண்டு வேகம் ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'குண்டு அளவு ×$x';
  }

  @override
  String fxPower(String x) {
    return 'மின் பயன்பாடு ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'இலக்கு நாடல் +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n இலக்குகளை ஊடுருவிச் செல்லும்';
  }

  @override
  String get fxPierceAll => 'அனைத்தையும் ஊடுருவிச் செல்லும்';

  @override
  String fxCrit(int pct, String x) {
    return '×$x சேதத்துக்கு $pct % வாய்ப்பு';
  }

  @override
  String fxBossCrit(String x) {
    return 'தலைவர்கள் மீது ×$x கிரிட்கள்';
  }

  @override
  String fxFork(int n) {
    return 'கொலைகள் $n குண்டுகளைச் சிதறடிக்கும்';
  }

  @override
  String get fxChain => 'சிதறிய குண்டுகள் மீண்டும் சிதறும்';

  @override
  String get fxSplit => 'தாக்கினால் இரண்டாகப் பிளக்கும்';

  @override
  String get fxFrost => 'தாக்குதல்கள் எதிரிகளை மெதுவாக்கும்';

  @override
  String get fxCrossfire => 'பக்கத் துப்பாக்கிகள் உள்நோக்கிச் சாயும்';

  @override
  String get fxRearguard => 'பக்கத் துப்பாக்கிகள் பின்னாலும் சுடும்';

  @override
  String get fxOrbit => 'குண்டுகள் பின்னிச் செல்லும்';

  @override
  String fxBounce(int n) {
    return 'சுவர்களில் $n× எதிரொலிக்கும்';
  }

  @override
  String get fxBounceTop => '…மேற்புறத்திலும் எதிரொலிக்கும்';

  @override
  String get fxOverdrive => 'மின் கடனில் சுடும்';

  @override
  String get fxReactor => 'கொள்ளளவு மீறிய துப்பாக்கிகளும் மெதுவாகச் சுடும்';

  @override
  String fxGenPower(String x) {
    return 'ஜெனரேட்டர் மறுஊட்டம் ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ஜெனரேட்டர் கொள்ளளவு ×$x';
  }

  @override
  String get fxSurge => 'ஜெனரேட்டர் நிரம்பினால்: குண்டுகள் ×2';

  @override
  String fxSiphon(int pct) {
    return 'கொலைகள் $pct % மின்சாரத்தை நிரப்பும்';
  }

  @override
  String fxHp(String x) {
    return 'கலம் ×$x';
  }

  @override
  String fxShield(String x) {
    return 'கேடயம் ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'கேடய மீட்பு ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'கொலைகள் $n HP ஐ குணப்படுத்தும்';
  }

  @override
  String get fxMagnet => 'பிக்கப்புகளை இழுக்கும்';

  @override
  String get fxMagnetAll => 'எல்லா பிக்கப்புகளையும் இழுக்கும்';

  @override
  String fxReflect(int pct) {
    return 'கேடயத்தில் பட்ட குண்டுகளில் $pct % திரும்பப் பறக்கும்';
  }

  @override
  String get fxReflectGuided => 'திரும்பிய குண்டுகள் இலக்கை நாடும்';

  @override
  String fxGhost(String sec) {
    return 'கலத்தில் தாக்கப்பட்ட பின் $sec s தீண்டத்தகாதது';
  }

  @override
  String get fxNova => 'கேடயம் உடைந்தால்: முழுத் திரைக்கும் வெடிப்பு';

  @override
  String fxAgility(String x) {
    return 'சுறுசுறுப்பு ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ஹிட்பாக்ஸ் ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'கிரெடிட் ×$x';
  }

  @override
  String fxScore(String x) {
    return 'மதிப்பெண் ×$x';
  }

  @override
  String get fxSatellite => 'ஒரு துப்பாக்கி ட்ரோன் உடன் வரும்';

  @override
  String get fxTimewarp => 'கலத்தில் தாக்குதல் நேரத்தை மெதுவாக்கும்';

  @override
  String get fxGambler => 'ஒவ்வொரு குண்டும் சீரற்ற துப்பாக்கி';

  @override
  String get vaultAll => 'அனைத்தும்';
}
