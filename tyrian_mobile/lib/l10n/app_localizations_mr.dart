// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get ok => 'ठीक आहे';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get connect => 'कनेक्ट करा';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName शी कनेक्ट करता आले नाही';
  }

  @override
  String get nearbyJoinFailedBody =>
      'होस्ट दिसत होता, पण कनेक्शन झाले नाही.\n\nजवळ खेळण्यासाठी पीअर-टू-पीअर Wi-Fi लागते, जे पर्सनल हॉटस्पॉट सुरू असताना iOS बंद करते — दोन्ही डिव्हाइसवर हॉटस्पॉट बंद करा आणि पुन्हा प्रयत्न करा, किंवा दोन्ही डिव्हाइस एकाच Wi-Fi ला जोडा.';

  @override
  String get gameOverCampaign =>
      'मोहीम अयशस्वी — लोडआउट आणि क्रेडिट राखले. कमांड सेंटरमधून पुन्हा प्रयत्न करा.';

  @override
  String get gameOverEndless =>
      'सेक्टर 1 मध्ये पुनर्बांधणी — लोडआउट आणि क्रेडिट राखले';

  @override
  String get waitingForHost => 'होस्टची वाट पाहत आहे...';

  @override
  String get waitingForHostHint => 'होस्ट तयार झाल्यावर खेळ सुरू होईल';

  @override
  String get vesselLost => 'यान नष्ट';

  @override
  String scoreValue(String score) {
    return 'स्कोअर: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'क्रेडिट: $credits';
  }

  @override
  String get creditsPrefix => 'क्रेडिट: ';

  @override
  String get leaderboard => 'लीडरबोर्ड';

  @override
  String get achievements => 'यश';

  @override
  String get redeploy => 'पुन्हा लढाईत';

  @override
  String get resume => 'पुढे सुरू ठेवा';

  @override
  String get pause => 'थांबवा';

  @override
  String get paused => 'थांबवले';

  @override
  String get skins => 'स्किन';

  @override
  String get skin => 'स्किन';

  @override
  String get soundOn => 'आवाज: सुरू';

  @override
  String get soundOff => 'आवाज: बंद';

  @override
  String get musicOn => 'संगीत: सुरू';

  @override
  String get musicOff => 'संगीत: बंद';

  @override
  String get mainMenu => 'मुख्य मेनू';

  @override
  String get quitToDesktop => 'डेस्कटॉपवर परत';

  @override
  String get selectSkin => 'स्किन निवडा';

  @override
  String get difficulty => 'कठीणता';

  @override
  String get difficultyEasy => 'सोपे';

  @override
  String get difficultyNormal => 'सामान्य';

  @override
  String get difficultyHard => 'कठीण';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'मोहीम';

  @override
  String get quit => 'बाहेर पडा';

  @override
  String get restorePurchases => 'खरेदी पुनर्संचयित करा';

  @override
  String get locked => 'लॉक';

  @override
  String get mainMenuTooltip => 'मुख्य मेनू';

  @override
  String nodeLevel(int level) {
    return 'लेव्हल $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'लेव्हल $level · बॉस $ordinal';
  }

  @override
  String get nodeLockedHint => 'लॉक आहे. आधी मागचा नोड पूर्ण करा.';

  @override
  String get flyAgain => 'पुन्हा उडा';

  @override
  String get launch => 'उड्डाण';

  @override
  String zoneLabel(int zone) {
    return 'झोन $zone';
  }

  @override
  String get objectiveStar => 'तारा';

  @override
  String get continueButton => 'पुढे';

  @override
  String get replayNode => 'नोड पुन्हा खेळा';

  @override
  String get retry => 'पुन्हा प्रयत्न';

  @override
  String get nodeCleared => 'नोड पूर्ण';

  @override
  String get nodeFailed => 'नोड अयशस्वी';

  @override
  String get weaponTierUnlocked => 'शस्त्रांचा नवा स्तर अनलॉक';

  @override
  String get onSaleInComCenter => 'कमांड सेंटरमध्ये विक्रीसाठी.';

  @override
  String get requiredTasksHint =>
      'आवश्यक कामेच नोडचा निकाल ठरवतात. पुन्हा उडा — जे कमावले ते तुमच्याकडेच राहील.';

  @override
  String get objClear => 'सेक्टर साफ करा';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शत्रू पाडा',
      one: '$count शत्रू पाडा',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'हलला कोणतेही नुकसान होऊ देऊ नका';

  @override
  String objHull(int percent) {
    return '$percent% पेक्षा जास्त हलसह पूर्ण करा';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon ने $count नष्ट करा',
      one: '$weapon ने $count नष्ट करा',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बाजूच्या तोफांनी $count नष्ट करा',
      one: 'बाजूच्या तोफांनी $count नष्ट करा',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon पुढे लावून उड्डाण करा';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon बाजूच्या माउंटवर लावून उड्डाण करा';
  }

  @override
  String get objBuySideGun => 'कमांड सेंटरमधून बाजूची तोफ विकत घ्या';

  @override
  String objUpgradeGenerator(int level) {
    return 'जनरेटर लेव्हल $level पर्यंत अपग्रेड करा';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'पुढची तोफ लेव्हल $level पर्यंत अपग्रेड करा';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'एक बाजूची तोफ लेव्हल $level पर्यंत अपग्रेड करा';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बोनस पकडा',
      one: '$count बोनस पकडा',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count संपूर्ण फॉर्मेशन नष्ट करा',
      one: '$count संपूर्ण फॉर्मेशन नष्ट करा',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'कोणत्याही लघुग्रहाला धडकू नका';

  @override
  String objUnderTime(int seconds) {
    return '$seconds सेकंदांत पूर्ण करा';
  }

  @override
  String get objStripBoss => 'कोअरच्या आधी बॉसचा प्रत्येक भाग नष्ट करा';

  @override
  String get joinCoopTitle => 'को-ऑपमध्ये सामील व्हा';

  @override
  String get cannotSearchNetwork => 'या नेटवर्कवर शोध घेता येत नाही';

  @override
  String get joinHintNearby =>
      'एकच Wi-Fi प्रत्येक डिव्हाइसवर चालते. iPhone, iPad आणि Mac त्याशिवायही जवळ एकमेकांना शोधतात — दोन्हीवर पर्सनल हॉटस्पॉट बंद असताना.';

  @override
  String get joinHintWifi =>
      'दोन्ही खेळाडू एकाच Wi-Fi वर असले पाहिजेत — पर्सनल हॉटस्पॉटही चालेल.';

  @override
  String noHostsYet(String hint) {
    return 'अजून कोणताही होस्ट नाही. $hint';
  }

  @override
  String get lookingForHosts => 'या Wi-Fi वर आणि जवळ होस्ट शोधत आहे…';

  @override
  String get hostNearby => 'जवळ · Bluetooth / पीअर-टू-पीअर Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · तेच Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP स्वतः टाका';

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
    return '$name — ढालीने सुरक्षित';
  }

  @override
  String get bossPartTurret => 'टरेट';

  @override
  String get bossPartShieldPod => 'ढाल पॉड';

  @override
  String get bossPartThruster => 'थ्रस्टर';

  @override
  String get bossPartCannon => 'तोफ';

  @override
  String sectorUnknownSpace(int level) {
    return 'सेक्टर $level — अज्ञात अवकाश';
  }

  @override
  String get player2Joined => 'खेळाडू 2 सामील झाला!';

  @override
  String get player2Disconnected => 'खेळाडू 2 चे कनेक्शन तुटले';

  @override
  String get hostDisconnected => 'होस्टचे कनेक्शन तुटले';

  @override
  String maxLevelSold(String amount) {
    return 'कमाल लेव्हल! \$$amount ला विकले';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'शस्त्र स्तर $tier अनलॉक';
  }

  @override
  String get cheatsEnabled => 'चीट्स सुरू';

  @override
  String get cheatsDisabled => 'चीट्स बंद';

  @override
  String get cheatsMaxed => 'चीट: क्रेडिट कमाल, सर्व शस्त्रे अनलॉक';

  @override
  String get cheats => 'चीट्स';

  @override
  String get maxCredits => 'कमाल क्रेडिट';

  @override
  String get sectionStats => 'आकडेवारी';

  @override
  String get sectionLoadout => 'लोडआउट';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'अपग्रेड';

  @override
  String get sell => 'विका';

  @override
  String get buy => 'खरेदी';

  @override
  String get commandCenter => 'कमांड सेंटर';

  @override
  String get pilot => 'वैमानिक';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'स्कोअर';

  @override
  String get nextWeapon => 'पुढचे शस्त्र';

  @override
  String pointsValue(String points) {
    return '$points गुण';
  }

  @override
  String get slotFront => 'पुढे';

  @override
  String get slotLeft => 'डावे';

  @override
  String get slotRight => 'उजवे';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'मोहीम सुरू करा';

  @override
  String get startMission => 'मोहीम प्रारंभ';

  @override
  String get continueMission => 'मोहीम सुरू ठेवा';

  @override
  String get padControlsHint =>
      '[↑↓] ओळ   [←→] निवडा   [B] खरेदी/अपग्रेड/बदला   [X/Y] विका   [OPTIONS] मोहीम सुरू ठेवा';

  @override
  String get host => 'होस्ट करा';

  @override
  String hostingAs(String name) {
    return '$name म्हणून होस्टिंग';
  }

  @override
  String get join => 'सामील व्हा';

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
  String get overload => 'ओव्हरलोड';

  @override
  String weaponOff(String weapon) {
    return '$weapon बंद — जनरेटर फार कमकुवत';
  }

  @override
  String unlocksAt(String points) {
    return '$points गुणांवर अनलॉक';
  }

  @override
  String joinConnecting(String target) {
    return '$target शी कनेक्ट होत आहे…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'होस्टने उत्तर दिले नाही: $reason.\n\nदोन्ही खेळाडू एकाच Wi-Fi वर असले पाहिजेत (पर्सनल हॉटस्पॉटही चालेल) आणि होस्टने होस्ट करा दाबलेले असले पाहिजे. पत्ता तपासा आणि पुन्हा प्रयत्न करा.';
  }

  @override
  String get lanJoinNoAnswer => 'उत्तर नाही';

  @override
  String objBossUnder(int seconds) {
    return 'बॉस आल्यापासून $seconds सेकंदांत त्याचा कोअर नष्ट करा';
  }

  @override
  String get sectionHangar => 'हँगर';

  @override
  String get sectionVault => 'तिजोरी';

  @override
  String get rackSide => 'बाजू';

  @override
  String get rackHull => 'हल';

  @override
  String get rarityCommon => 'सामान्य';

  @override
  String get rarityRare => 'दुर्मीळ';

  @override
  String get rarityMythic => 'पौराणिक';

  @override
  String get curse => 'शाप';

  @override
  String get modFit => 'बसवा';

  @override
  String get modUnfit => 'काढा';

  @override
  String get modForge => 'भट्टी';

  @override
  String get forgeHint =>
      'एकाच दुर्मीळतेचे 3 निवडून पुढच्या दुर्मीळतेचा 1 घडवा';

  @override
  String get vaultEmpty =>
      'अजून मॉड नाहीत. सर्व ताऱ्यांसह नोड पूर्ण करा, बॉसला पटकन हरवा किंवा अंतहीन मोडमध्ये बॉस पाडा.';

  @override
  String modNeeds(String families) {
    return '$families सोबत चालते';
  }

  @override
  String get modRackFull => 'रॅक भरला';

  @override
  String get modAlreadyFitted => 'आधीच बसवले';

  @override
  String get modWrongRack => 'या रॅकमध्ये बसत नाही';

  @override
  String modsSpilled(int n) {
    return '$n मॉड तिजोरीत परत';
  }

  @override
  String get hullLocked => 'लॉक';

  @override
  String hullUnlockBoss(int n) {
    return 'मोहिमेतील बॉस $n ला हरवा';
  }

  @override
  String get hullUnlockFinish => 'मोहीम पूर्ण करा किंवा सेक्टर 30 गाठा';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'मानक यान';

  @override
  String get perkAfterimage => 'स्थिर राहा: शॉट ×1.5';

  @override
  String get perkBulwark => 'ढालीपलीकडचे नुकसान अर्धे';

  @override
  String get perkOverclock => 'क्षमतेच्या 130 % पर्यंत मारा, हळू';

  @override
  String get perkBattery => 'एक मोफत गन ड्रोन सोबत उडतो';

  @override
  String get rewardTitle => 'बक्षीस';

  @override
  String newHull(String name) {
    return 'नवा हल: $name';
  }

  @override
  String get socketEmpty => 'रिकामे';

  @override
  String fxStreams(int n) {
    return '$n समांतर धारा';
  }

  @override
  String fxFan(int n) {
    return '$n शॉटचा पंखा';
  }

  @override
  String fxSalvo(int n) {
    return '$n शॉटचा मारा';
  }

  @override
  String fxFireRate(String x) {
    return 'माऱ्याचा वेग ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'नुकसान ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'शॉटचा वेग ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'शॉटचा आकार ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ऊर्जा वापर ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'लक्ष्यवेधी +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n लक्ष्यांच्या आरपार';
  }

  @override
  String get fxPierceAll => 'सगळ्याच्या आरपार';

  @override
  String fxCrit(int pct, String x) {
    return '×$x नुकसानाची $pct % शक्यता';
  }

  @override
  String fxBossCrit(String x) {
    return 'बॉसवर ×$x क्रिट';
  }

  @override
  String fxFork(int n) {
    return 'पाडल्यावर $n शॉट विखुरतात';
  }

  @override
  String get fxChain => 'विखुरलेले शॉट पुन्हा विखुरतात';

  @override
  String get fxSplit => 'लागल्यावर दोन भागांत फुटतो';

  @override
  String get fxFrost => 'प्रहार शत्रूंना मंद करतात';

  @override
  String get fxCrossfire => 'बाजूच्या तोफा आतल्या बाजूला झुकतात';

  @override
  String get fxRearguard => 'बाजूच्या तोफा मागेही मारा करतात';

  @override
  String get fxOrbit => 'शॉट वळणे घेतात';

  @override
  String fxBounce(int n) {
    return 'भिंतींवरून $n× उसळतो';
  }

  @override
  String get fxBounceTop => '…आणि वरूनही';

  @override
  String get fxOverdrive => 'ऊर्जेच्या कर्जावर मारा';

  @override
  String get fxReactor => 'क्षमतेपलीकडच्या तोफाही मारा करतात, हळू';

  @override
  String fxGenPower(String x) {
    return 'जनरेटर रिचार्ज ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'जनरेटर क्षमता ×$x';
  }

  @override
  String get fxSurge => 'पूर्ण जनरेटर: शॉट ×2';

  @override
  String fxSiphon(int pct) {
    return 'पाडल्यावर $pct % ऊर्जा परत';
  }

  @override
  String fxHp(String x) {
    return 'हल ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ढाल ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ढाल पुनर्भरण ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'पाडल्यावर $n HP भरून';
  }

  @override
  String get fxMagnet => 'बोनस ओढून घेतो';

  @override
  String get fxMagnetAll => 'प्रत्येक बोनस ओढून घेतो';

  @override
  String fxReflect(int pct) {
    return 'ढालीवरून $pct % शॉट परत जातात';
  }

  @override
  String get fxReflectGuided => 'परतलेले शॉट स्वतः लक्ष्य शोधतात';

  @override
  String fxGhost(String sec) {
    return 'हलवर प्रहारानंतर $sec सेकंद अभेद्य';
  }

  @override
  String get fxNova => 'ढाल फुटली की संपूर्ण स्क्रीनवर स्फोट';

  @override
  String fxAgility(String x) {
    return 'चपळता ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'हिटबॉक्स ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'क्रेडिट ×$x';
  }

  @override
  String fxScore(String x) {
    return 'स्कोअर ×$x';
  }

  @override
  String get fxSatellite => 'एक गन ड्रोन सोबत उडतो';

  @override
  String get fxTimewarp => 'हलवर प्रहार वेळ मंद करतो';

  @override
  String get fxGambler => 'प्रत्येक शॉट एक यादृच्छिक शस्त्र';

  @override
  String get vaultAll => 'सर्व';

  @override
  String get sigilMissUnknown => 'अज्ञात आकार';

  @override
  String get sigilMissTooSlow => 'खूप हळू';

  @override
  String get sigilMissSkippedDot => 'एक बिंदू चुकला';

  @override
  String get sigilMissLeftRimEarly => 'खूप लवकर सोडले';

  @override
  String get sigilMissWrongDirection => 'उलटे काढले';

  @override
  String get sigilMissWrongLayer => 'चुकीचे शोल्डर बटण';

  @override
  String get sigilDry => 'पुरेसा चार्ज नाही';

  @override
  String get sigilBusy => 'आधीचे अजून सुरू आहे';

  @override
  String get arena => 'अरेना';

  @override
  String get arenaBossParts => 'बॉसचे भाग';

  @override
  String get arenaBareCore => 'उघडा कोअर';

  @override
  String get arenaCompanions => 'साथीदार';

  @override
  String get arenaCharge => 'चार्ज';

  @override
  String get arenaChargeNormal => 'सामान्य';

  @override
  String get arenaSpeed => 'जगाचा वेग';

  @override
  String get arenaDrill => 'सराव';

  @override
  String get arenaFreePlay => 'मुक्त खेळ';

  @override
  String get arenaFight => 'लढा';

  @override
  String get arenaNewBoss => 'नवा बॉस';

  @override
  String get arenaLeave => 'अरेना सोडा';

  @override
  String get arenaHint => 'बॉस मरताच परत येतो. इथे काहीही सेव्ह होत नाही.';

  @override
  String get arenaColCast => 'वापर';

  @override
  String get arenaColMiss => 'चूक';

  @override
  String get arenaColAvg => 'सरासरी';

  @override
  String get arenaColBest => 'सर्वोत्तम';

  @override
  String get arenaColTime => 'सर्वात जलद';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'बॉस $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'पॅड: सिजिल';

  @override
  String get padSchemeClassic => 'पॅड: क्लासिक';

  @override
  String get padSouthpawOn => 'डावखुरा: चालू';

  @override
  String get padSouthpawOff => 'डावखुरा: बंद';

  @override
  String get sigilDescHop => 'फ्लिकच्या दिशेने झटपट उडी';

  @override
  String get sigilDescSidestep => 'मैदानभर लांब बाजूची पायरी';

  @override
  String get sigilDescStrike => 'तीन जड गोळ्यांसह पुढे झेप, मग परत';

  @override
  String get sigilDescRetreat => 'मागे सरका, संरक्षक मारा पुढे जातो';

  @override
  String get sigilDescDash => 'आगीतून तिरकी धाव, मध्ये अस्पर्श्य';

  @override
  String get sigilDescRoll => 'बाजूला बॅरल रोल, अस्पर्श्य';

  @override
  String get sigilDescShadow => 'जवळच्या शत्रूखाली चिकटा आणि मारा करत राहा';

  @override
  String get sigilDescEcho =>
      'सावली तुमचे शेवटचे दोन सेकंद अर्ध्या नुकसानीने पुन्हा करते';

  @override
  String get sigilDescLoop => 'वरून लूप: गोळ्या तुमच्या खालून जातात';

  @override
  String get sigilDescSlalom => 'पंख्यासारख्या माऱ्यासह मैदानभर S-वळण';

  @override
  String get sigilDescCorkscrew => 'चहूबाजूंनी मारा करत पुढे पिळवळ, अस्पर्श्य';

  @override
  String get sigilDescSnapshot => 'फ्लिकच्या दिशेने एक जड गोळी';

  @override
  String get sigilDescBroadside => 'दोन्ही बाजूंनी सल्वो';

  @override
  String get sigilDescVolley => 'पुढे पाच चार्ज केलेले किरण';

  @override
  String get sigilDescCaltrop => 'गोळ्या गिळून फुटणारी सुरुंग टाका';

  @override
  String get sigilDescFrenzy => 'काही सेकंद तोफा जलद मारा करतात';

  @override
  String get sigilDescStasis => 'शत्रू आणि त्यांच्या गोळ्या अर्ध्या वेगाने';

  @override
  String get sigilDescHalo => 'ढाल चौपट वेगाने भरते आणि काहीही आत येत नाही';

  @override
  String get sigilDescRadial => 'सोळा गोळ्यांचे वर्तुळ';

  @override
  String get sigilDescStorm => 'प्रत्येक तोफ पूर्ण जोराने, मोफत';

  @override
  String get sigilDescPing => 'साथीदार फ्लिकच्या दिशेने मारा केंद्रित करतात';

  @override
  String get sigilDescWingman => 'काढलेल्या बाजूला विंगमॅन बोलवा';

  @override
  String get sigilDescHunter => 'पुढे उडून लक्ष्य निवडणारा शिकारी बोलवा';

  @override
  String get sigilDescWarden => 'तुमच्यासाठीच्या गोळ्या झेलणारा रक्षक बोलवा';

  @override
  String get sigilDescFormation => 'साथीदार रुंद आणि पाचर रचनेत बदलतात';

  @override
  String get sigilDescWhirl => 'साथीदार तुमच्याभोवती फिरून गोळ्या गिळतात';

  @override
  String get sigilDescSacrifice => 'साथीदार सूर मारून फुटतात, चार्ज परत देतात';

  @override
  String get grimoire => 'ग्रिमोयर';

  @override
  String get grimoireHint =>
      'उजव्या स्टिकने काढा. ARMS साठी LB, WING साठी RB, MEGA BLAST साठी दोन्ही धरा.';

  @override
  String sigilCost(int cost) {
    return 'किंमत $cost';
  }

  @override
  String get sigilUntouchable => 'अस्पर्श्य';

  @override
  String get lessonWatch => 'पाहा';

  @override
  String get lessonTrace => 'गिरवा';

  @override
  String get lessonSlow => 'हळू';

  @override
  String get lessonLive => 'पूर्ण वेग';

  @override
  String get lessonStreak => 'सलग पाच';

  @override
  String get lessonLearned => 'शिकलात';

  @override
  String lessonTempo(int pct) {
    return 'टेम्पो $pct %';
  }

  @override
  String get hintHop => 'उजवी स्टिक फ्लिक करा';

  @override
  String get hintLoop => 'वर्तुळ काढा: तुम्ही गोळ्यांवरून उडता';

  @override
  String get hintStream => 'LT दाबा: दोन-तीन धारा';

  @override
  String get arenaKata => 'काटा';

  @override
  String get arenaKataOff => 'काही नाही';

  @override
  String kataNext(String sigil, String secs) {
    return 'पुढील $sigil $secs s मध्ये';
  }

  @override
  String get arenaGauntlet => 'गॉन्टलेट';

  @override
  String get arenaOn => 'चालू';

  @override
  String get arenaOff => 'बंद';

  @override
  String gauntletRating(int rating, int best) {
    return 'रेटिंग $rating · सर्वोत्तम $best';
  }

  @override
  String get duelWarning => 'सावधान';

  @override
  String get duelHintPad1 => 'उजवी स्टिक नेम धरते आणि मारते';

  @override
  String get duelHintPad2Rt => 'RT, LB किंवा RB धरा: उजवी स्टिक सिजिल काढते';

  @override
  String get duelHintPad2Lt => 'LT, LB किंवा RB धरा: उजवी स्टिक सिजिल काढते';

  @override
  String get duelHintClassic =>
      'डावी स्टिक उडवते · B, RB किंवा RT नाकाच्या दिशेने मारा';

  @override
  String get duelHintKeys1 => 'बाण नेम धरतात आणि मारतात · WASD उडवते';

  @override
  String get duelHintKeys2 => 'स्पेस नाकाच्या दिशेने मारते · नमपॅड सिजिल काढते';

  @override
  String get arenaDuelBinding => 'द्वंद्व पवित्रा';

  @override
  String get duelBindingRt => 'RT + स्टिक';

  @override
  String get duelBindingLt => 'LT + स्टिक';

  @override
  String get arenaDuelFrame => 'पॅड पुढे';

  @override
  String get duelFrameNose => 'नाक';

  @override
  String get duelFrameUp => 'वर';

  @override
  String get arenaDuelAimFires => 'नेम धरताच मारा';

  @override
  String get duelCutInFirst => 'बॉस क्लोज-अप: पहिल्यांदा';

  @override
  String get duelCutInAlways => 'बॉस क्लोज-अप: नेहमी';

  @override
  String get duelCutInNever => 'बॉस क्लोज-अप: कधीच नाही';

  @override
  String get arenaDuelDrill => 'द्वंद्व सराव';

  @override
  String get duelDrillOff => 'काही नाही';

  @override
  String get duelDrillAim => 'नेम धरा आणि मारा';

  @override
  String get duelDrillAimHow => 'उजवी स्टिक बॉसकडे करा आणि त्याला मारा';

  @override
  String get duelDrillHold => 'नाक स्थिर ठेवा';

  @override
  String get duelDrillHoldHow => 'पवित्रा बटण धरून उडा: नाक जागीच राहते';

  @override
  String get duelDrillDraw => 'पुढे काढा';

  @override
  String get duelDrillDrawHow => 'पवित्र्यात बॉसकडे सिजिल काढा';

  @override
  String get duelDrillTurn => 'मागे वळा';

  @override
  String get duelDrillTurnHow => 'बॉस तुमच्या खाली आहे: नाक वळवा आणि मारा';

  @override
  String get duelDrillDone => 'झाले';
}
