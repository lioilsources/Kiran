// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get connect => 'కనెక్ట్ చేయి';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostNameకు కనెక్ట్ కాలేకపోయాం';
  }

  @override
  String get nearbyJoinFailedBody =>
      'హోస్ట్ కనిపించింది, కానీ లింక్ ఏర్పడలేదు.\n\nసమీప ఆటకు పీర్-టు-పీర్ వై-ఫై కావాలి; పర్సనల్ హాట్‌స్పాట్ ఆన్‌లో ఉంటే iOS దాన్ని ఆఫ్ చేస్తుంది. రెండు పరికరాల్లోనూ హాట్‌స్పాట్ ఆఫ్ చేసి మళ్లీ ప్రయత్నించండి, లేదా రెండింటినీ ఒకే వై-ఫైలో ఉంచండి.';

  @override
  String get gameOverCampaign =>
      'మిషన్ విఫలమైంది — లోడ్‌అవుట్, క్రెడిట్‌లు అలాగే ఉన్నాయి. కామ్ సెంటర్ నుండి మళ్లీ ప్రయత్నించండి.';

  @override
  String get gameOverEndless =>
      'సెక్టర్ 1లో పునర్నిర్మాణం — లోడ్‌అవుట్, క్రెడిట్‌లు అలాగే ఉన్నాయి';

  @override
  String get waitingForHost => 'హోస్ట్ కోసం వేచి ఉంది...';

  @override
  String get waitingForHostHint => 'హోస్ట్ సిద్ధమైనప్పుడు ఆట మొదలవుతుంది';

  @override
  String get vesselLost => 'నౌక నాశనమైంది';

  @override
  String scoreValue(String score) {
    return 'స్కోరు: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'క్రెడిట్: $credits';
  }

  @override
  String get creditsPrefix => 'క్రెడిట్:';

  @override
  String get leaderboard => 'లీడర్‌బోర్డ్';

  @override
  String get achievements => 'సాధనలు';

  @override
  String get redeploy => 'మళ్లీ మోహరించు';

  @override
  String get resume => 'కొనసాగించు';

  @override
  String get pause => 'పాజ్';

  @override
  String get paused => 'పాజ్ అయింది';

  @override
  String get skins => 'స్కిన్‌లు';

  @override
  String get skin => 'స్కిన్';

  @override
  String get soundOn => 'ధ్వని: ఆన్';

  @override
  String get soundOff => 'ధ్వని: ఆఫ్';

  @override
  String get musicOn => 'సంగీతం: ఆన్';

  @override
  String get musicOff => 'సంగీతం: ఆఫ్';

  @override
  String get statsOn => 'గణాంకాలు: ఆన్';

  @override
  String get statsOff => 'గణాంకాలు: ఆఫ్';

  @override
  String get mainMenu => 'ప్రధాన మెనూ';

  @override
  String get quitToDesktop => 'డెస్క్‌టాప్‌కు నిష్క్రమించు';

  @override
  String get selectSkin => 'స్కిన్ ఎంచుకో';

  @override
  String get difficulty => 'కష్టం';

  @override
  String get difficultyEasy => 'సులభం';

  @override
  String get difficultyNormal => 'సాధారణం';

  @override
  String get difficultyHard => 'కఠినం';

  @override
  String get difficultyLord => 'లార్డ్';

  @override
  String get campaign => 'ప్రచారం';

  @override
  String get quit => 'నిష్క్రమించు';

  @override
  String get restorePurchases => 'కొనుగోళ్లను పునరుద్ధరించు';

  @override
  String get locked => 'లాక్ చేయబడింది';

  @override
  String get mainMenuTooltip => 'ప్రధాన మెనూ';

  @override
  String nodeLevel(int level) {
    return 'స్థాయి $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'స్థాయి $level · బాస్ $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'లాక్ చేయబడింది. దానికి ముందున్న నోడ్‌ను పూర్తి చేయండి.';

  @override
  String get flyAgain => 'మళ్లీ ఎగురు';

  @override
  String get launch => 'ప్రయోగించు';

  @override
  String zoneLabel(int zone) {
    return 'జోన్ $zone';
  }

  @override
  String get objectiveStar => 'నక్షత్రం';

  @override
  String get continueButton => 'కొనసాగించు';

  @override
  String get replayNode => 'నోడ్‌ను మళ్లీ ఆడు';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించు';

  @override
  String get nodeCleared => 'నోడ్ పూర్తయింది';

  @override
  String get nodeFailed => 'నోడ్ విఫలమైంది';

  @override
  String get weaponTierUnlocked => 'ఆయుధ స్థాయి అన్‌లాక్ అయింది';

  @override
  String get onSaleInComCenter => 'కామ్ సెంటర్‌లో అమ్మకానికి ఉంది.';

  @override
  String get requiredTasksHint =>
      'అవసరమైన పనులే నోడ్ ఫలితాన్ని నిర్ణయిస్తాయి. మళ్లీ ఎగరండి — మీరు సంపాదించింది మీ వద్దే ఉంటుంది.';

  @override
  String get objClear => 'సెక్టర్‌ను క్లియర్ చేయి';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count శత్రువులను కూల్చు',
      one: '$count శత్రువును కూల్చు',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'హల్‌కు నష్టం కలగనివ్వకు';

  @override
  String objHull(int percent) {
    return '$percent% కంటే ఎక్కువ హల్‌తో ముగించు';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weaponతో $count శత్రువులను చంపు',
      one: '$weaponతో $count శత్రువును చంపు',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'పక్క గన్‌లతో $count శత్రువులను చంపు',
      one: 'పక్క గన్‌లతో $count శత్రువును చంపు',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weaponను ముందు భాగంలో ఉంచి ప్రయోగించు';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weaponను పక్క మౌంట్‌లో ఉంచి ప్రయోగించు';
  }

  @override
  String get objBuySideGun => 'కామ్ సెంటర్‌లో ఒక పక్క గన్ కొను';

  @override
  String objUpgradeGenerator(int level) {
    return 'జనరేటర్‌ను స్థాయి $levelకు అప్‌గ్రేడ్ చేయి';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'ముందు గన్‌ను స్థాయి $levelకు అప్‌గ్రేడ్ చేయి';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ఒక పక్క గన్‌ను స్థాయి $levelకు అప్‌గ్రేడ్ చేయి';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count పికప్‌లు పట్టుకో',
      one: '$count పికప్ పట్టుకో',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మొత్తం దళాలను తుడిచిపెట్టు',
      one: '$count మొత్తం దళాన్ని తుడిచిపెట్టు',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'ఏ గ్రహశకలాన్నీ ఢీకొనకు';

  @override
  String objUnderTime(int seconds) {
    return '${seconds}s లోపు ముగించు';
  }

  @override
  String get objStripBoss => 'కోర్‌కు ముందు బాస్ భాగాలన్నిటినీ నాశనం చేయి';

  @override
  String get joinCoopTitle => 'కో-ఆప్‌లో చేరండి';

  @override
  String get cannotSearchNetwork => 'ఈ నెట్‌వర్క్‌లో వెతకలేము';

  @override
  String get joinHintNearby =>
      'ఒకే వై-ఫై అన్ని పరికరాల్లో పనిచేస్తుంది. iPhone, iPad, Mac వై-ఫై లేకుండానే సమీపంలో ఒకదానినొకటి కనుగొంటాయి — రెండింటిలోనూ పర్సనల్ హాట్‌స్పాట్ ఆఫ్‌లో ఉండాలి.';

  @override
  String get joinHintWifi =>
      'ఇద్దరు ఆటగాళ్లూ ఒకే వై-ఫైలో ఉండాలి — పర్సనల్ హాట్‌స్పాట్ కూడా చాలు.';

  @override
  String noHostsYet(String hint) {
    return 'ఇంకా హోస్ట్‌లు లేవు. $hint';
  }

  @override
  String get lookingForHosts => 'ఈ వై-ఫైలో, సమీపంలో హోస్ట్‌ల కోసం వెతుకుతోంది…';

  @override
  String get hostNearby => 'సమీపం · బ్లూటూత్ / పీర్-టు-పీర్ వై-ఫై';

  @override
  String hostSameWifi(String address) {
    return '$address · అదే వై-ఫై';
  }

  @override
  String get enterIpManually => 'IPని మాన్యువల్‌గా నమోదు చేయండి';

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
    return '$name — కవచంతో';
  }

  @override
  String get bossPartTurret => 'గన్ గోపురం';

  @override
  String get bossPartShieldPod => 'కవచ పాడ్';

  @override
  String get bossPartThruster => 'థ్రస్టర్';

  @override
  String get bossPartCannon => 'ఫిరంగి';

  @override
  String sectorUnknownSpace(int level) {
    return 'సెక్టర్ $level — తెలియని అంతరిక్షం';
  }

  @override
  String get player2Joined => 'ఆటగాడు 2 చేరారు!';

  @override
  String get player2Disconnected => 'ఆటగాడు 2 డిస్‌కనెక్ట్ అయ్యారు';

  @override
  String get hostDisconnected => 'హోస్ట్ డిస్‌కనెక్ట్ అయ్యారు';

  @override
  String maxLevelSold(String amount) {
    return 'గరిష్ఠ స్థాయి! \$$amountకు అమ్మబడింది';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ఆయుధ స్థాయి $tier అన్‌లాక్ అయింది';
  }

  @override
  String get cheatsEnabled => 'చీట్‌లు ప్రారంభించబడ్డాయి';

  @override
  String get cheatsDisabled => 'చీట్‌లు నిలిపివేయబడ్డాయి';

  @override
  String get cheatsMaxed => 'చీట్: క్రెడిట్‌లు గరిష్ఠం, అన్ని ఆయుధాలు అన్‌లాక్';

  @override
  String get cheats => 'చీట్‌లు';

  @override
  String get maxCredits => 'గరిష్ఠ క్రెడిట్';

  @override
  String get sectionStats => 'గణాంకాలు';

  @override
  String get sectionLoadout => 'లోడ్‌అవుట్';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'అప్‌గ్రేడ్';

  @override
  String get sell => 'అమ్ము';

  @override
  String get buy => 'కొను';

  @override
  String get commandCenter => 'కమాండ్ సెంటర్';

  @override
  String get pilot => 'పైలట్';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'స్కోరు';

  @override
  String get nextWeapon => 'తదుపరి ఆయుధం';

  @override
  String pointsValue(String points) {
    return '$points పాయింట్లు';
  }

  @override
  String get slotFront => 'ముందు';

  @override
  String get slotLeft => 'ఎడమ';

  @override
  String get slotRight => 'కుడి';

  @override
  String get slotGen => 'జనరేటర్';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'మిషన్ ప్రయోగించు';

  @override
  String get startMission => 'మిషన్ ప్రారంభించు';

  @override
  String get continueMission => 'మిషన్ కొనసాగించు';

  @override
  String get padControlsHint =>
      '[↑↓] వరుస   [←→] ఎంచుకో   [B] కొను/అప్‌గ్రేడ్/మార్చు   [X/Y] అమ్ము   [OPTIONS] మిషన్ కొనసాగించు';

  @override
  String get host => 'హోస్ట్';

  @override
  String hostingAs(String name) {
    return '$nameగా హోస్ట్ చేస్తోంది';
  }

  @override
  String get join => 'చేరు';

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
  String get overload => 'ఓవర్‌లోడ్';

  @override
  String weaponOff(String weapon) {
    return '$weapon ఆఫ్ — జనరేటర్ బలహీనం';
  }

  @override
  String unlocksAt(String points) {
    return '$points పాయింట్ల వద్ద అన్‌లాక్ అవుతుంది';
  }

  @override
  String joinConnecting(String target) {
    return '$targetకు కనెక్ట్ అవుతోంది…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'హోస్ట్ స్పందించలేదు: $reason.\n\nఇద్దరు ఆటగాళ్లూ ఒకే వై-ఫైలో ఉండాలి (పర్సనల్ హాట్‌స్పాట్ కూడా చాలు), హోస్ట్ HOST నొక్కి ఉండాలి. చిరునామా తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';
  }

  @override
  String get lanJoinNoAnswer => 'స్పందన లేదు';

  @override
  String objBossUnder(int seconds) {
    return 'బాస్ వచ్చిన ${seconds}s లోపు దాని కోర్‌ను నాశనం చేయి';
  }

  @override
  String get sectionHangar => 'హ్యాంగర్';

  @override
  String get sectionVault => 'వాల్ట్';

  @override
  String get rackSide => 'పక్క';

  @override
  String get rackHull => 'హల్';

  @override
  String get rarityCommon => 'సాధారణం';

  @override
  String get rarityRare => 'అరుదు';

  @override
  String get rarityMythic => 'పౌరాణికం';

  @override
  String get curse => 'శాపం';

  @override
  String get modFit => 'సరిపోతుంది';

  @override
  String get modUnfit => 'సరిపోదు';

  @override
  String get modForge => 'తయారు చేయి';

  @override
  String get forgeHint =>
      'ఒకే అరుదైన స్థాయిలో 3 ఎంచుకుని తదుపరి స్థాయిలో 1 తయారు చేయండి';

  @override
  String get vaultEmpty =>
      'ఇంకా మోడ్‌లు లేవు. పూర్తి నక్షత్రాలతో నోడ్ పూర్తి చేయండి, బాస్‌ను త్వరగా ఓడించండి, లేదా అంతులేని బాస్‌ను కూల్చండి.';

  @override
  String modNeeds(String families) {
    return '$familiesతో పనిచేస్తుంది';
  }

  @override
  String get modRackFull => 'ర్యాక్ నిండింది';

  @override
  String get modAlreadyFitted => 'ఇప్పటికే అమర్చబడింది';

  @override
  String get modWrongRack => 'ఈ ర్యాక్‌కు సరిపోదు';

  @override
  String modsSpilled(int n) {
    return '$n మోడ్‌లు వాల్ట్‌కు తిరిగి వచ్చాయి';
  }

  @override
  String get hullLocked => 'లాక్ చేయబడింది';

  @override
  String hullUnlockBoss(int n) {
    return 'ప్రచార బాస్ $nను ఓడించండి';
  }

  @override
  String get hullUnlockFinish =>
      'ప్రచారాన్ని పూర్తి చేయండి లేదా సెక్టర్ 30కి చేరండి';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'సాధారణ నౌక';

  @override
  String get perkAfterimage => 'కదలకుండా ఉండండి: షాట్లు ×1.5';

  @override
  String get perkBulwark => 'కవచం దాటిన నష్టం సగమవుతుంది';

  @override
  String get perkOverclock =>
      'సామర్థ్యంలో 130 % వరకు గన్‌లు కాలుస్తాయి, నెమ్మదిగా';

  @override
  String get perkBattery => 'ఒక ఉచిత గన్ డ్రోన్ తోడుగా వస్తుంది';

  @override
  String get rewardTitle => 'బహుమతి';

  @override
  String newHull(String name) {
    return 'కొత్త హల్: $name';
  }

  @override
  String get socketEmpty => 'ఖాళీ';

  @override
  String fxStreams(int n) {
    return '$n సమాంతర ప్రవాహాలు';
  }

  @override
  String fxFan(int n) {
    return '$n షాట్ల విసనకర్ర';
  }

  @override
  String fxSalvo(int n) {
    return '$n-షాట్ సాల్వో';
  }

  @override
  String fxFireRate(String x) {
    return 'కాల్పుల రేటు ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'నష్టం ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'షాట్ వేగం ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'షాట్ పరిమాణం ×$x';
  }

  @override
  String fxPower(String x) {
    return 'శక్తి వినియోగం ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'హోమింగ్ +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n లక్ష్యాలను ఛేదిస్తుంది';
  }

  @override
  String get fxPierceAll => 'అన్నిటినీ ఛేదిస్తుంది';

  @override
  String fxCrit(int pct, String x) {
    return '×$x నష్టానికి $pct % అవకాశం';
  }

  @override
  String fxBossCrit(String x) {
    return 'బాస్‌లపై ×$x క్రిట్‌లు';
  }

  @override
  String fxFork(int n) {
    return 'కిల్స్ $n షాట్లను చిమ్ముతాయి';
  }

  @override
  String get fxChain => 'చిమ్మిన షాట్లు మళ్లీ చిమ్ముతాయి';

  @override
  String get fxSplit => 'తగిలితే రెండుగా చీలుతుంది';

  @override
  String get fxFrost => 'హిట్‌లు శత్రువులను నెమ్మదింపజేస్తాయి';

  @override
  String get fxCrossfire => 'పక్క గన్‌లు లోపలికి వంగుతాయి';

  @override
  String get fxRearguard => 'పక్క గన్‌లు వెనక్కీ కాలుస్తాయి';

  @override
  String get fxOrbit => 'షాట్లు అల్లుకుంటూ సాగుతాయి';

  @override
  String fxBounce(int n) {
    return 'గోడలపై $n× తిరిగి ఎగురుతుంది';
  }

  @override
  String get fxBounceTop => '…పై భాగంపైనా తిరిగి ఎగురుతుంది';

  @override
  String get fxOverdrive => 'శక్తి అప్పుపై కాలుస్తుంది';

  @override
  String get fxReactor => 'సామర్థ్యం మించిన గన్‌లు కూడా నెమ్మదిగా కాలుస్తాయి';

  @override
  String fxGenPower(String x) {
    return 'జనరేటర్ రీఛార్జ్ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'జనరేటర్ సామర్థ్యం ×$x';
  }

  @override
  String get fxSurge => 'జనరేటర్ నిండితే: షాట్లు ×2';

  @override
  String fxSiphon(int pct) {
    return 'కిల్స్ $pct % శక్తిని నింపుతాయి';
  }

  @override
  String fxHp(String x) {
    return 'హల్ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'కవచం ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'కవచ పునరుత్పత్తి ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'కిల్స్ $n HP నయం చేస్తాయి';
  }

  @override
  String get fxMagnet => 'పికప్‌లను లాగుతుంది';

  @override
  String get fxMagnetAll => 'అన్ని పికప్‌లను లాగుతుంది';

  @override
  String fxReflect(int pct) {
    return 'కవచానికి తగిలిన షాట్లలో $pct % తిరిగి ఎగురుతాయి';
  }

  @override
  String get fxReflectGuided => 'ప్రతిబింబించిన షాట్లు లక్ష్యాన్ని వెతుకుతాయి';

  @override
  String fxGhost(String sec) {
    return 'హల్‌కు దెబ్బ తగిలాక $sec s తాకలేనిది';
  }

  @override
  String get fxNova => 'కవచం పగిలితే: మొత్తం స్క్రీన్‌కు పేలుడు';

  @override
  String fxAgility(String x) {
    return 'చురుకుదనం ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'హిట్‌బాక్స్ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'క్రెడిట్ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'స్కోరు ×$x';
  }

  @override
  String get fxSatellite => 'ఒక గన్ డ్రోన్ తోడుగా వస్తుంది';

  @override
  String get fxTimewarp => 'హల్‌కు దెబ్బ తగిలితే కాలం నెమ్మదిస్తుంది';

  @override
  String get fxGambler => 'ప్రతి షాట్ యాదృచ్ఛిక గన్';

  @override
  String get vaultAll => 'అన్నీ';

  @override
  String get sigilMissUnknown => 'తెలియని ఆకారం';

  @override
  String get sigilMissTooSlow => 'చాలా నెమ్మదిగా';

  @override
  String get sigilMissSkippedDot => 'ఒక చుక్క వదిలేశారు';

  @override
  String get sigilMissLeftRimEarly => 'ముందుగానే వదిలేశారు';

  @override
  String get sigilMissWrongDirection => 'వెనక్కి గీశారు';

  @override
  String get sigilMissWrongLayer => 'తప్పు భుజం బటన్';

  @override
  String get sigilDry => 'తగినంత ఛార్జ్ లేదు';

  @override
  String get sigilBusy => 'మునుపటిది ఇంకా నడుస్తోంది';

  @override
  String get arena => 'అరేనా';

  @override
  String get arenaBossParts => 'బాస్ భాగాలు';

  @override
  String get arenaBareCore => 'బయటపడిన కోర్';

  @override
  String get arenaCompanions => 'సహచరులు';

  @override
  String get arenaCharge => 'ఛార్జ్';

  @override
  String get arenaChargeNormal => 'సాధారణం';

  @override
  String get arenaSpeed => 'ప్రపంచ వేగం';

  @override
  String get arenaDrill => 'సాధన';

  @override
  String get arenaFreePlay => 'ఉచిత ఆట';

  @override
  String get arenaFight => 'పోరాడు';

  @override
  String get arenaNewBoss => 'కొత్త బాస్';

  @override
  String get arenaLeave => 'అరేనా వదులు';

  @override
  String get arenaHint =>
      'బాస్ చనిపోయిన వెంటనే తిరిగి వస్తాడు. ఇక్కడ ఏదీ సేవ్ కాదు.';

  @override
  String get arenaColCast => 'వాడకం';

  @override
  String get arenaColMiss => 'మిస్';

  @override
  String get arenaColAvg => 'సగటు';

  @override
  String get arenaColBest => 'ఉత్తమం';

  @override
  String get arenaColTime => 'వేగవంతం';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'బాస్‌లు $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ప్యాడ్: సిగిల్స్';

  @override
  String get padSchemeClassic => 'ప్యాడ్: క్లాసిక్';

  @override
  String get padSouthpawOn => 'ఎడమచేతి: ఆన్';

  @override
  String get padSouthpawOff => 'ఎడమచేతి: ఆఫ్';

  @override
  String get sigilDescHop => 'మీరు విసిరిన దిశలో వేగవంతమైన గెంతు';

  @override
  String get sigilDescSidestep => 'మైదానం అంతటా పొడవైన పక్క అడుగు';

  @override
  String get sigilDescStrike =>
      'మూడు భారీ షాట్లతో ముందుకు దూకి, తిరిగి వెనక్కి';

  @override
  String get sigilDescRetreat =>
      'కవరింగ్ ఫైర్ ముందుకు వెళ్తుండగా వెనక్కి తగ్గు';

  @override
  String get sigilDescDash => 'మంటల గుండా వికర్ణ దూకుడు, మధ్యలో తాకలేనిది';

  @override
  String get sigilDescRoll => 'పక్కకు బ్యారెల్ రోల్, తాకలేనిది';

  @override
  String get sigilDescShadow => 'దగ్గరి శత్రువు కింద లాక్ అయి కాల్చుతూ ఉండు';

  @override
  String get sigilDescEcho =>
      'ఒక నీడ మీ చివరి రెండు సెకన్లను సగం నష్టంతో మళ్లీ చేస్తుంది';

  @override
  String get sigilDescLoop => 'పైనుంచి లూప్: షాట్లు మీ కింద నుంచి వెళ్తాయి';

  @override
  String get sigilDescSlalom => 'విసనకర్ర కాల్పులతో మైదానంలో S-వంపు';

  @override
  String get sigilDescCorkscrew =>
      'చుట్టూ కాల్చుతూ కార్క్‌స్క్రూ ముందుకు, తాకలేనిది';

  @override
  String get sigilDescSnapshot => 'మీరు విసిరిన దిశలో ఒక భారీ షాట్';

  @override
  String get sigilDescBroadside => 'రెండు పక్కల నుంచీ ఒక సాల్వో';

  @override
  String get sigilDescVolley => 'ముందుకు ఐదు ఛార్జ్ కిరణాలు';

  @override
  String get sigilDescCaltrop => 'షాట్లను మింగి పేలే మైన్‌ను వదులు';

  @override
  String get sigilDescFrenzy => 'కొన్ని సెకన్లు తుపాకులు వేగంగా కాల్చుతాయి';

  @override
  String get sigilDescStasis => 'శత్రువులు, వారి షాట్లు సగం వేగానికి తగ్గుతాయి';

  @override
  String get sigilDescHalo =>
      'కవచం నాలుగు రెట్లు వేగంగా నిండుతుంది, ఏదీ దూసుకురాదు';

  @override
  String get sigilDescRadial => 'పదహారు షాట్ల వలయం';

  @override
  String get sigilDescStorm => 'అన్ని తుపాకులూ పూర్తి వేగంతో, ఉచితంగా';

  @override
  String get sigilDescPing =>
      'మీరు విసిరిన చోట సహచరులు కాల్పులు కేంద్రీకరిస్తారు';

  @override
  String get sigilDescWingman => 'మీరు గీసిన పక్కకు వింగ్‌మ్యాన్‌ను పిలువు';

  @override
  String get sigilDescHunter =>
      'ముందు ఎగిరి లక్ష్యాలను ఎంచుకునే హంటర్‌ను పిలువు';

  @override
  String get sigilDescWarden => 'మీ కోసం షాట్లను తీసుకునే వార్డెన్‌ను పిలువు';

  @override
  String get sigilDescFormation => 'సహచరులు వెడల్పు, చీలిక మధ్య మారుతారు';

  @override
  String get sigilDescWhirl => 'సహచరులు మీ చుట్టూ తిరిగి షాట్లను మింగుతారు';

  @override
  String get sigilDescSacrifice => 'సహచరులు దూకి పేలి, ఛార్జ్ తిరిగి ఇస్తారు';

  @override
  String get grimoire => 'మంత్ర గ్రంథం';

  @override
  String get grimoireHint =>
      'కుడి స్టిక్‌తో గీయండి. ఆయుధాలకు LB, రెక్కకు RB, మెగా పేలుడుకు రెండూ.';

  @override
  String sigilCost(int cost) {
    return 'ఖర్చు $cost';
  }

  @override
  String get sigilUntouchable => 'తాకలేనిది';

  @override
  String get lessonWatch => 'చూడు';

  @override
  String get lessonTrace => 'గీయి';

  @override
  String get lessonSlow => 'నెమ్మది';

  @override
  String get lessonLive => 'పూర్తి వేగం';

  @override
  String get lessonStreak => 'వరుసగా ఐదు';

  @override
  String get lessonLearned => 'నేర్చుకున్నారు';

  @override
  String lessonTempo(int pct) {
    return 'టెంపో $pct %';
  }

  @override
  String get hintHop => 'కుడి స్టిక్‌ను విసరండి';

  @override
  String get hintLoop => 'వృత్తం గీయండి: షాట్ల పైనుంచి ఎగురుతారు';

  @override
  String get hintStream => 'LT నొక్కండి: రెండు లేదా మూడు ధారలు';

  @override
  String get arenaKata => 'కాటా';

  @override
  String get arenaKataOff => 'ఏదీ లేదు';

  @override
  String kataNext(String sigil, String secs) {
    return 'తదుపరి $sigil $secs సెకన్లలో';
  }

  @override
  String get arenaGauntlet => 'సవాలు';

  @override
  String get arenaOn => 'ఆన్';

  @override
  String get arenaOff => 'ఆఫ్';

  @override
  String gauntletRating(int rating, int best) {
    return 'రేటింగ్ $rating · ఉత్తమం $best';
  }

  @override
  String get duelWarning => 'హెచ్చరిక';

  @override
  String get duelHintPad1 => 'కుడి స్టిక్ గురిపెట్టి కాల్చుతుంది';

  @override
  String get duelHintPad2Rt =>
      'RT, LB లేదా RB పట్టుకోండి: కుడి స్టిక్ సిగిల్స్ గీస్తుంది';

  @override
  String get duelHintPad2Lt =>
      'LT, LB లేదా RB పట్టుకోండి: కుడి స్టిక్ సిగిల్స్ గీస్తుంది';

  @override
  String get duelHintClassic =>
      'ఎడమ స్టిక్ ఎగురుతుంది · B, RB లేదా RT ముక్కు చూపే వైపు కాల్చుతాయి';

  @override
  String get duelHintKeys1 => 'బాణాలు గురిపెట్టి కాల్చుతాయి · WASD ఎగురుతుంది';

  @override
  String get duelHintKeys2 =>
      'Space ముక్కు చూపే వైపు కాల్చుతుంది · నంప్యాడ్ సిగిల్స్ గీస్తుంది';

  @override
  String get arenaDuelBinding => 'ద్వంద్వ భంగిమ';

  @override
  String get duelBindingRt => 'RT + స్టిక్';

  @override
  String get duelBindingLt => 'LT + స్టిక్';

  @override
  String get arenaDuelFrame => 'ప్యాడ్ ముందుకు';

  @override
  String get duelFrameNose => 'ముక్కు';

  @override
  String get duelFrameUp => 'పైకి';

  @override
  String get arenaDuelAimFires => 'గురి కాల్చుతుంది';

  @override
  String get duelCutInFirst => 'బాస్ క్లోజ్-అప్: మొదటిసారి';

  @override
  String get duelCutInAlways => 'బాస్ క్లోజ్-అప్: ఎల్లప్పుడూ';

  @override
  String get duelCutInNever => 'బాస్ క్లోజ్-అప్: ఎప్పుడూ కాదు';

  @override
  String get arenaDuelDrill => 'ద్వంద్వ సాధన';

  @override
  String get duelDrillOff => 'ఏదీ లేదు';

  @override
  String get duelDrillAim => 'గురిపెట్టి కాల్చు';

  @override
  String get duelDrillAimHow => 'కుడి స్టిక్‌ను బాస్ వైపు చూపి కొట్టండి';

  @override
  String get duelDrillHold => 'ముక్కు పట్టు';

  @override
  String get duelDrillHoldHow => 'భంగిమ బటన్ పట్టుకుని ఎగరండి: ముక్కు కదలదు';

  @override
  String get duelDrillDraw => 'ముందుకు గీయి';

  @override
  String get duelDrillDrawHow => 'భంగిమలో, బాస్ వైపు ఒక సిగిల్ గీయండి';

  @override
  String get duelDrillTurn => 'వెనుదిరుగు';

  @override
  String get duelDrillTurnHow => 'బాస్ మీ కింద ఉన్నాడు: ముక్కు తిప్పి కొట్టండి';

  @override
  String get duelDrillDone => 'పూర్తయింది';

  @override
  String get swapHint => 'ఆయుధాలు మార్చడానికి రెండో వేలితో ట్యాప్ చేయండి';
}
