// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName से कनेक्ट नहीं हो सका';
  }

  @override
  String get nearbyJoinFailedBody =>
      'होस्ट दिख रहा था, लेकिन कनेक्शन नहीं बना।\n\nपास में खेलने के लिए पीयर-टू-पीयर Wi-Fi चाहिए, जिसे iOS पर्सनल हॉटस्पॉट चालू रहने पर बंद कर देता है — दोनों डिवाइस पर हॉटस्पॉट बंद करें और फिर कोशिश करें, या दोनों डिवाइस को एक ही Wi-Fi से जोड़ें।';

  @override
  String get gameOverCampaign =>
      'मिशन विफल — लोडआउट और क्रेडिट बचे रहे। कमांड सेंटर से फिर कोशिश करें।';

  @override
  String get gameOverEndless =>
      'सेक्टर 1 में फिर से निर्माण — लोडआउट और क्रेडिट बचे रहे';

  @override
  String get waitingForHost => 'होस्ट का इंतज़ार...';

  @override
  String get waitingForHostHint => 'होस्ट तैयार होते ही खेल शुरू होगा';

  @override
  String get vesselLost => 'यान नष्ट';

  @override
  String scoreValue(String score) {
    return 'स्कोर: $score';
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
  String get achievements => 'उपलब्धियाँ';

  @override
  String get redeploy => 'फिर से मैदान में';

  @override
  String get resume => 'जारी रखें';

  @override
  String get pause => 'रोकें';

  @override
  String get paused => 'रुका हुआ';

  @override
  String get skins => 'स्किन';

  @override
  String get skin => 'स्किन';

  @override
  String get soundOn => 'आवाज़: चालू';

  @override
  String get soundOff => 'आवाज़: बंद';

  @override
  String get musicOn => 'संगीत: चालू';

  @override
  String get musicOff => 'संगीत: बंद';

  @override
  String get mainMenu => 'मुख्य मेन्यू';

  @override
  String get quitToDesktop => 'डेस्कटॉप पर लौटें';

  @override
  String get selectSkin => 'स्किन चुनें';

  @override
  String get difficulty => 'कठिनाई';

  @override
  String get difficultyEasy => 'आसान';

  @override
  String get difficultyNormal => 'सामान्य';

  @override
  String get difficultyHard => 'कठिन';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'अभियान';

  @override
  String get quit => 'बाहर निकलें';

  @override
  String get restorePurchases => 'खरीदारी बहाल करें';

  @override
  String get locked => 'लॉक';

  @override
  String get mainMenuTooltip => 'मुख्य मेन्यू';

  @override
  String nodeLevel(int level) {
    return 'लेवल $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'लेवल $level · बॉस $ordinal';
  }

  @override
  String get nodeLockedHint => 'लॉक है। पहले पिछला नोड पूरा करें।';

  @override
  String get flyAgain => 'फिर उड़ें';

  @override
  String get launch => 'लॉन्च';

  @override
  String zoneLabel(int zone) {
    return 'ज़ोन $zone';
  }

  @override
  String get objectiveStar => 'सितारा';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get replayNode => 'नोड फिर खेलें';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get nodeCleared => 'नोड पूरा';

  @override
  String get nodeFailed => 'नोड विफल';

  @override
  String get weaponTierUnlocked => 'हथियार का नया स्तर अनलॉक';

  @override
  String get onSaleInComCenter => 'कमांड सेंटर में बिक्री पर।';

  @override
  String get requiredTasksHint =>
      'ज़रूरी काम ही नोड का फ़ैसला करते हैं। फिर उड़ें — जो कमाया, वह आपके पास रहेगा।';

  @override
  String get objClear => 'सेक्टर साफ़ करें';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दुश्मनों को मार गिराएँ',
      one: '$count दुश्मन को मार गिराएँ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ढाँचे को कोई नुकसान न हो';

  @override
  String objHull(int percent) {
    return '$percent% से ज़्यादा ढाँचे के साथ पूरा करें';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon से $count को नष्ट करें',
      one: '$weapon से $count को नष्ट करें',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'साइड गन से $count को नष्ट करें',
      one: 'साइड गन से $count को नष्ट करें',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon को आगे लगाकर लॉन्च करें';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon को साइड माउंट पर लगाकर लॉन्च करें';
  }

  @override
  String get objBuySideGun => 'कमांड सेंटर से साइड गन खरीदें';

  @override
  String objUpgradeGenerator(int level) {
    return 'जनरेटर को लेवल $level तक अपग्रेड करें';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'आगे वाली गन को लेवल $level तक अपग्रेड करें';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'किसी साइड गन को लेवल $level तक अपग्रेड करें';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बोनस पकड़ें',
      one: '$count बोनस पकड़ें',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पूरी फ़ॉर्मेशन का सफ़ाया करें',
      one: '$count पूरी फ़ॉर्मेशन का सफ़ाया करें',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'किसी क्षुद्रग्रह से न टकराएँ';

  @override
  String objUnderTime(int seconds) {
    return '$seconds सेकंड में पूरा करें';
  }

  @override
  String get objStripBoss => 'कोर से पहले बॉस का हर हिस्सा नष्ट करें';

  @override
  String get joinCoopTitle => 'को-ऑप में शामिल हों';

  @override
  String get cannotSearchNetwork => 'इस नेटवर्क पर खोज नहीं हो सकती';

  @override
  String get joinHintNearby =>
      'एक ही Wi-Fi हर डिवाइस पर काम करता है। iPhone, iPad और Mac इसके बिना भी पास में एक-दूसरे को ढूँढ लेते हैं — दोनों पर पर्सनल हॉटस्पॉट बंद होना चाहिए।';

  @override
  String get joinHintWifi =>
      'दोनों खिलाड़ी एक ही Wi-Fi पर हों — पर्सनल हॉटस्पॉट भी चलेगा।';

  @override
  String noHostsYet(String hint) {
    return 'अभी कोई होस्ट नहीं। $hint';
  }

  @override
  String get lookingForHosts => 'इस Wi-Fi पर और पास में होस्ट खोजे जा रहे हैं…';

  @override
  String get hostNearby => 'पास में · Bluetooth / पीयर-टू-पीयर Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · वही Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP खुद डालें';

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
    return '$name — कवच से सुरक्षित';
  }

  @override
  String get bossPartTurret => 'टरेट';

  @override
  String get bossPartShieldPod => 'कवच पॉड';

  @override
  String get bossPartThruster => 'थ्रस्टर';

  @override
  String get bossPartCannon => 'तोप';

  @override
  String sectorUnknownSpace(int level) {
    return 'सेक्टर $level — अज्ञात अंतरिक्ष';
  }

  @override
  String get player2Joined => 'खिलाड़ी 2 जुड़ गया!';

  @override
  String get player2Disconnected => 'खिलाड़ी 2 का कनेक्शन टूटा';

  @override
  String get hostDisconnected => 'होस्ट का कनेक्शन टूटा';

  @override
  String maxLevelSold(String amount) {
    return 'अधिकतम लेवल! \$$amount में बिका';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'हथियार स्तर $tier अनलॉक';
  }

  @override
  String get cheatsEnabled => 'चीट्स चालू';

  @override
  String get cheatsDisabled => 'चीट्स बंद';

  @override
  String get cheatsMaxed => 'चीट: क्रेडिट अधिकतम, सभी हथियार अनलॉक';

  @override
  String get cheats => 'चीट्स';

  @override
  String get maxCredits => 'अधिकतम क्रेडिट';

  @override
  String get sectionStats => 'आँकड़े';

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
  String get sell => 'बेचें';

  @override
  String get buy => 'खरीदें';

  @override
  String get commandCenter => 'कमांड सेंटर';

  @override
  String get pilot => 'पायलट';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'स्कोर';

  @override
  String get nextWeapon => 'अगला हथियार';

  @override
  String pointsValue(String points) {
    return '$points अंक';
  }

  @override
  String get slotFront => 'आगे';

  @override
  String get slotLeft => 'बाएँ';

  @override
  String get slotRight => 'दाएँ';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'मिशन लॉन्च करें';

  @override
  String get startMission => 'मिशन शुरू करें';

  @override
  String get continueMission => 'मिशन जारी रखें';

  @override
  String get padControlsHint =>
      '[↑↓] पंक्ति   [←→] चुनें   [B] खरीदें/अपग्रेड/बदलें   [X/Y] बेचें   [OPTIONS] मिशन जारी रखें';

  @override
  String get host => 'होस्ट करें';

  @override
  String hostingAs(String name) {
    return '$name के रूप में होस्टिंग';
  }

  @override
  String get join => 'शामिल हों';

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
  String get overload => 'ओवरलोड';

  @override
  String weaponOff(String weapon) {
    return '$weapon बंद — जनरेटर बहुत कमज़ोर';
  }

  @override
  String unlocksAt(String points) {
    return '$points अंक पर अनलॉक';
  }

  @override
  String joinConnecting(String target) {
    return '$target से कनेक्ट हो रहा है…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'होस्ट ने जवाब नहीं दिया: $reason।\n\nदोनों खिलाड़ी एक ही Wi-Fi पर हों (पर्सनल हॉटस्पॉट भी चलेगा) और होस्ट ने होस्ट करें दबाया हो। पता जाँचें और फिर कोशिश करें।';
  }

  @override
  String get lanJoinNoAnswer => 'कोई जवाब नहीं';

  @override
  String objBossUnder(int seconds) {
    return 'बॉस के आने के $seconds सेकंड के भीतर उसका कोर नष्ट करें';
  }

  @override
  String get sectionHangar => 'हैंगर';

  @override
  String get sectionVault => 'तिजोरी';

  @override
  String get rackSide => 'साइड';

  @override
  String get rackHull => 'ढाँचा';

  @override
  String get rarityCommon => 'सामान्य';

  @override
  String get rarityRare => 'दुर्लभ';

  @override
  String get rarityMythic => 'पौराणिक';

  @override
  String get curse => 'श्राप';

  @override
  String get modFit => 'लगाएँ';

  @override
  String get modUnfit => 'हटाएँ';

  @override
  String get modForge => 'भट्ठी';

  @override
  String get forgeHint =>
      'एक ही दुर्लभता के 3 चुनें और अगली दुर्लभता का 1 गढ़ें';

  @override
  String get vaultEmpty =>
      'अभी कोई मॉड नहीं। सभी सितारों के साथ नोड पूरा करें, बॉस को जल्दी हराएँ या अंतहीन मोड में बॉस को गिराएँ।';

  @override
  String modNeeds(String families) {
    return '$families के साथ काम करता है';
  }

  @override
  String get modRackFull => 'रैक भरा है';

  @override
  String get modAlreadyFitted => 'पहले से लगा है';

  @override
  String get modWrongRack => 'इस रैक में फ़िट नहीं होता';

  @override
  String modsSpilled(int n) {
    return '$n मॉड तिजोरी में वापस';
  }

  @override
  String get hullLocked => 'लॉक';

  @override
  String hullUnlockBoss(int n) {
    return 'अभियान बॉस $n को हराएँ';
  }

  @override
  String get hullUnlockFinish => 'अभियान पूरा करें या सेक्टर 30 तक पहुँचें';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'मानक यान';

  @override
  String get perkAfterimage => 'स्थिर रहें: शॉट ×1.5';

  @override
  String get perkBulwark => 'कवच के पार का नुकसान आधा';

  @override
  String get perkOverclock => 'क्षमता के 130 % तक फ़ायर, धीमे';

  @override
  String get perkBattery => 'एक मुफ़्त गन ड्रोन साथ उड़ता है';

  @override
  String get rewardTitle => 'इनाम';

  @override
  String newHull(String name) {
    return 'नया ढाँचा: $name';
  }

  @override
  String get socketEmpty => 'खाली';

  @override
  String fxStreams(int n) {
    return '$n समानांतर धाराएँ';
  }

  @override
  String fxFan(int n) {
    return '$n शॉट का पंखा';
  }

  @override
  String fxSalvo(int n) {
    return '$n शॉट की बौछार';
  }

  @override
  String fxFireRate(String x) {
    return 'फ़ायर दर ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'नुकसान ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'शॉट की गति ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'शॉट का आकार ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ऊर्जा खपत ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'होमिंग +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n लक्ष्यों के आर-पार';
  }

  @override
  String get fxPierceAll => 'हर चीज़ के आर-पार';

  @override
  String fxCrit(int pct, String x) {
    return '×$x नुकसान की $pct % संभावना';
  }

  @override
  String fxBossCrit(String x) {
    return 'बॉस पर ×$x क्रिट';
  }

  @override
  String fxFork(int n) {
    return 'मार गिराने पर $n शॉट बिखरते हैं';
  }

  @override
  String get fxChain => 'बिखरे शॉट फिर बिखरते हैं';

  @override
  String get fxSplit => 'लगने पर दो में बँटता है';

  @override
  String get fxFrost => 'वार दुश्मनों को धीमा करते हैं';

  @override
  String get fxCrossfire => 'साइड गन अंदर की ओर झुकती हैं';

  @override
  String get fxRearguard => 'साइड गन पीछे भी फ़ायर करती हैं';

  @override
  String get fxOrbit => 'शॉट लहराते हैं';

  @override
  String fxBounce(int n) {
    return 'दीवारों से $n× उछलता है';
  }

  @override
  String get fxBounceTop => '…और ऊपर से भी';

  @override
  String get fxOverdrive => 'ऊर्जा के कर्ज़ पर फ़ायर';

  @override
  String get fxReactor => 'क्षमता से ऊपर की गन भी फ़ायर करती हैं, धीरे';

  @override
  String fxGenPower(String x) {
    return 'जनरेटर रीचार्ज ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'जनरेटर क्षमता ×$x';
  }

  @override
  String get fxSurge => 'भरा जनरेटर: शॉट ×2';

  @override
  String fxSiphon(int pct) {
    return 'मार गिराने से $pct % ऊर्जा वापस';
  }

  @override
  String fxHp(String x) {
    return 'ढाँचा ×$x';
  }

  @override
  String fxShield(String x) {
    return 'कवच ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'कवच पुनर्जनन ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'मार गिराने से $n HP ठीक';
  }

  @override
  String get fxMagnet => 'बोनस खींचता है';

  @override
  String get fxMagnetAll => 'हर बोनस खींचता है';

  @override
  String fxReflect(int pct) {
    return 'कवच से $pct % शॉट वापस लौटते हैं';
  }

  @override
  String get fxReflectGuided => 'लौटे शॉट खुद निशाना ढूँढते हैं';

  @override
  String fxGhost(String sec) {
    return 'ढाँचे पर वार के बाद $sec सेकंड तक अछूता';
  }

  @override
  String get fxNova => 'कवच टूटे तो पूरी स्क्रीन पर धमाका';

  @override
  String fxAgility(String x) {
    return 'फुर्ती ×$x';
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
    return 'स्कोर ×$x';
  }

  @override
  String get fxSatellite => 'एक गन ड्रोन साथ उड़ता है';

  @override
  String get fxTimewarp => 'ढाँचे पर वार समय को धीमा करता है';

  @override
  String get fxGambler => 'हर शॉट एक बेतरतीब हथियार';

  @override
  String get vaultAll => 'सभी';
}
