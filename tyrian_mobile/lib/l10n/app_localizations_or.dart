// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get ok => 'ଠିକ ଅଛି';

  @override
  String get cancel => 'ବାତିଲ';

  @override
  String get connect => 'ସଂଯୋଗ କରନ୍ତୁ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName ସହ ସଂଯୋଗ ହୋଇପାରିଲା ନାହିଁ';
  }

  @override
  String get nearbyJoinFailedBody =>
      'ହୋଷ୍ଟ ଦେଖାଯାଉଥିଲା, କିନ୍ତୁ ସଂଯୋଗ ହେଲା ନାହିଁ।\n\nନିକଟରେ ଖେଳିବା ପାଇଁ ପିଅର-ଟୁ-ପିଅର Wi-Fi ଦରକାର, ଯାହାକୁ ପର୍ସନାଲ ହଟସ୍ପଟ ଚାଲୁ ଥିବାବେଳେ iOS ବନ୍ଦ କରିଦିଏ — ଦୁଇଟି ଡିଭାଇସରେ ହଟସ୍ପଟ ବନ୍ଦ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ, କିମ୍ବା ଦୁଇଟି ଡିଭାଇସକୁ ସମାନ Wi-Fi ସହ ଯୋଡନ୍ତୁ।';

  @override
  String get gameOverCampaign =>
      'ମିଶନ ବିଫଳ — ଲୋଡଆଉଟ ଓ କ୍ରେଡିଟ ରହିଲା। କମାଣ୍ଡ ସେଣ୍ଟରରୁ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get gameOverEndless =>
      'ସେକ୍ଟର 1ରେ ପୁନର୍ନିର୍ମାଣ — ଲୋଡଆଉଟ ଓ କ୍ରେଡିଟ ରହିଲା';

  @override
  String get waitingForHost => 'ହୋଷ୍ଟଙ୍କ ପାଇଁ ଅପେକ୍ଷା...';

  @override
  String get waitingForHostHint => 'ହୋଷ୍ଟ ପ୍ରସ୍ତୁତ ହେଲେ ଖେଳ ଆରମ୍ଭ ହେବ';

  @override
  String get vesselLost => 'ଯାନ ନଷ୍ଟ';

  @override
  String scoreValue(String score) {
    return 'ସ୍କୋର: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'କ୍ରେଡିଟ: $credits';
  }

  @override
  String get creditsPrefix => 'କ୍ରେଡିଟ: ';

  @override
  String get leaderboard => 'ଲିଡରବୋର୍ଡ';

  @override
  String get achievements => 'ସଫଳତା';

  @override
  String get redeploy => 'ପୁଣି ଯୁଦ୍ଧକୁ';

  @override
  String get resume => 'ଜାରି ରଖନ୍ତୁ';

  @override
  String get pause => 'ବିରତି';

  @override
  String get paused => 'ବିରତିରେ';

  @override
  String get skins => 'ସ୍କିନ';

  @override
  String get skin => 'ସ୍କିନ';

  @override
  String get soundOn => 'ଶବ୍ଦ: ଚାଲୁ';

  @override
  String get soundOff => 'ଶବ୍ଦ: ବନ୍ଦ';

  @override
  String get musicOn => 'ସଙ୍ଗୀତ: ଚାଲୁ';

  @override
  String get musicOff => 'ସଙ୍ଗୀତ: ବନ୍ଦ';

  @override
  String get mainMenu => 'ମୁଖ୍ୟ ମେନୁ';

  @override
  String get quitToDesktop => 'ଡେସ୍କଟପକୁ ଫେରନ୍ତୁ';

  @override
  String get selectSkin => 'ସ୍କିନ ବାଛନ୍ତୁ';

  @override
  String get difficulty => 'କାଠିନ୍ୟ';

  @override
  String get difficultyEasy => 'ସହଜ';

  @override
  String get difficultyNormal => 'ସାଧାରଣ';

  @override
  String get difficultyHard => 'କଠିନ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'ଅଭିଯାନ';

  @override
  String get quit => 'ବାହାରନ୍ତୁ';

  @override
  String get restorePurchases => 'କ୍ରୟ ପୁନରୁଦ୍ଧାର';

  @override
  String get locked => 'ଲକ';

  @override
  String get mainMenuTooltip => 'ମୁଖ୍ୟ ମେନୁ';

  @override
  String nodeLevel(int level) {
    return 'ଲେଭେଲ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ଲେଭେଲ $level · ବସ $ordinal';
  }

  @override
  String get nodeLockedHint => 'ଲକ ଅଛି। ପ୍ରଥମେ ପୂର୍ବ ନୋଡ ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ।';

  @override
  String get flyAgain => 'ପୁଣି ଉଡନ୍ତୁ';

  @override
  String get launch => 'ଉଡାଣ';

  @override
  String zoneLabel(int zone) {
    return 'ଜୋନ $zone';
  }

  @override
  String get objectiveStar => 'ତାରା';

  @override
  String get continueButton => 'ଆଗକୁ';

  @override
  String get replayNode => 'ନୋଡ ପୁଣି ଖେଳନ୍ତୁ';

  @override
  String get retry => 'ପୁଣି ଚେଷ୍ଟା';

  @override
  String get nodeCleared => 'ନୋଡ ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get nodeFailed => 'ନୋଡ ବିଫଳ';

  @override
  String get weaponTierUnlocked => 'ଅସ୍ତ୍ରର ନୂଆ ସ୍ତର ଅନଲକ';

  @override
  String get onSaleInComCenter => 'କମାଣ୍ଡ ସେଣ୍ଟରରେ ବିକ୍ରି ହେଉଛି।';

  @override
  String get requiredTasksHint =>
      'ଆବଶ୍ୟକ କାମ ହିଁ ନୋଡର ଫଳ ସ୍ଥିର କରେ। ପୁଣି ଉଡନ୍ତୁ — ଯାହା ରୋଜଗାର କଲେ ତାହା ଆପଣଙ୍କ ପାଖରେ ରହିବ।';

  @override
  String get objClear => 'ସେକ୍ଟର ସଫା କରନ୍ତୁ';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଶତ୍ରୁ ଖସାନ୍ତୁ',
      one: '$countଟି ଶତ୍ରୁ ଖସାନ୍ତୁ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ଖୋଳରେ କୌଣସି କ୍ଷତି ନ ହେଉ';

  @override
  String objHull(int percent) {
    return '$percent% ରୁ ଅଧିକ ଖୋଳ ସହ ସମାପ୍ତ କରନ୍ତୁ';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon ଦ୍ୱାରା $countଟି ନଷ୍ଟ କରନ୍ତୁ',
      one: '$weapon ଦ୍ୱାରା $countଟି ନଷ୍ଟ କରନ୍ତୁ',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ପାର୍ଶ୍ୱ ତୋପ ଦ୍ୱାରା $countଟି ନଷ୍ଟ କରନ୍ତୁ',
      one: 'ପାର୍ଶ୍ୱ ତୋପ ଦ୍ୱାରା $countଟି ନଷ୍ଟ କରନ୍ତୁ',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'ଆଗରେ $weapon ଲଗାଇ ଉଡାଣ ଭରନ୍ତୁ';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'ପାର୍ଶ୍ୱ ମାଉଣ୍ଟରେ $weapon ଲଗାଇ ଉଡାଣ ଭରନ୍ତୁ';
  }

  @override
  String get objBuySideGun => 'କମାଣ୍ଡ ସେଣ୍ଟରରୁ ପାର୍ଶ୍ୱ ତୋପ କିଣନ୍ତୁ';

  @override
  String objUpgradeGenerator(int level) {
    return 'ଜେନେରେଟରକୁ ଲେଭେଲ $level ପର୍ଯ୍ୟନ୍ତ ଅପଗ୍ରେଡ କରନ୍ତୁ';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'ଆଗ ତୋପକୁ ଲେଭେଲ $level ପର୍ଯ୍ୟନ୍ତ ଅପଗ୍ରେଡ କରନ୍ତୁ';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'ଗୋଟିଏ ପାର୍ଶ୍ୱ ତୋପକୁ ଲେଭେଲ $level ପର୍ଯ୍ୟନ୍ତ ଅପଗ୍ରେଡ କରନ୍ତୁ';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ବୋନସ ଧରନ୍ତୁ',
      one: '$countଟି ବୋନସ ଧରନ୍ତୁ',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ପୂରା ଫର୍ମେସନ ସଫା କରନ୍ତୁ',
      one: '$countଟି ପୂରା ଫର୍ମେସନ ସଫା କରନ୍ତୁ',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'କୌଣସି ଗ୍ରହାଣୁ ସହ ଧକ୍କା ଦିଅନ୍ତୁ ନାହିଁ';

  @override
  String objUnderTime(int seconds) {
    return '$seconds ସେକେଣ୍ଡରେ ସମାପ୍ତ କରନ୍ତୁ';
  }

  @override
  String get objStripBoss => 'କୋର ପୂର୍ବରୁ ବସର ପ୍ରତ୍ୟେକ ଅଂଶ ନଷ୍ଟ କରନ୍ତୁ';

  @override
  String get joinCoopTitle => 'କୋ-ଅପରେ ଯୋଗ ଦିଅନ୍ତୁ';

  @override
  String get cannotSearchNetwork => 'ଏହି ନେଟୱର୍କରେ ଖୋଜିହେବ ନାହିଁ';

  @override
  String get joinHintNearby =>
      'ସମାନ Wi-Fi ପ୍ରତ୍ୟେକ ଡିଭାଇସରେ କାମ କରେ। iPhone, iPad ଓ Mac ଏହା ବିନା ମଧ୍ୟ ନିକଟରେ ପରସ୍ପରକୁ ଖୋଜିନିଅନ୍ତି — ଦୁଇଟିରେ ପର୍ସନାଲ ହଟସ୍ପଟ ବନ୍ଦ ଥିଲେ।';

  @override
  String get joinHintWifi =>
      'ଉଭୟ ଖେଳାଳି ସମାନ Wi-Fiରେ ଥିବା ଆବଶ୍ୟକ — ପର୍ସନାଲ ହଟସ୍ପଟ ମଧ୍ୟ ଚାଲିବ।';

  @override
  String noHostsYet(String hint) {
    return 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ହୋଷ୍ଟ ନାହିଁ। $hint';
  }

  @override
  String get lookingForHosts => 'ଏହି Wi-Fiରେ ଓ ନିକଟରେ ହୋଷ୍ଟ ଖୋଜାଯାଉଛି…';

  @override
  String get hostNearby => 'ନିକଟରେ · Bluetooth / ପିଅର-ଟୁ-ପିଅର Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · ସମାନ Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP ନିଜେ ଲେଖନ୍ତୁ';

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
    return '$name — ଢାଲ ଦ୍ୱାରା ସୁରକ୍ଷିତ';
  }

  @override
  String get bossPartTurret => 'ଟରେଟ';

  @override
  String get bossPartShieldPod => 'ଢାଲ ପଡ';

  @override
  String get bossPartThruster => 'ଥ୍ରଷ୍ଟର';

  @override
  String get bossPartCannon => 'ତୋପ';

  @override
  String sectorUnknownSpace(int level) {
    return 'ସେକ୍ଟର $level — ଅଜଣା ମହାକାଶ';
  }

  @override
  String get player2Joined => 'ଖେଳାଳି 2 ଯୋଗ ଦେଲେ!';

  @override
  String get player2Disconnected => 'ଖେଳାଳି 2ଙ୍କ ସଂଯୋଗ ବିଚ୍ଛିନ୍ନ';

  @override
  String get hostDisconnected => 'ହୋଷ୍ଟଙ୍କ ସଂଯୋଗ ବିଚ୍ଛିନ୍ନ';

  @override
  String maxLevelSold(String amount) {
    return 'ସର୍ବାଧିକ ଲେଭେଲ! \$$amountରେ ବିକ୍ରି';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ଅସ୍ତ୍ର ସ୍ତର $tier ଅନଲକ';
  }

  @override
  String get cheatsEnabled => 'ଚିଟ ଚାଲୁ';

  @override
  String get cheatsDisabled => 'ଚିଟ ବନ୍ଦ';

  @override
  String get cheatsMaxed => 'ଚିଟ: କ୍ରେଡିଟ ସର୍ବାଧିକ, ସମସ୍ତ ଅସ୍ତ୍ର ଅନଲକ';

  @override
  String get cheats => 'ଚିଟ';

  @override
  String get maxCredits => 'ସର୍ବାଧିକ କ୍ରେଡିଟ';

  @override
  String get sectionStats => 'ପରିସଂଖ୍ୟାନ';

  @override
  String get sectionLoadout => 'ଲୋଡଆଉଟ';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ଅପଗ୍ରେଡ';

  @override
  String get sell => 'ବିକ୍ରି';

  @override
  String get buy => 'କିଣନ୍ତୁ';

  @override
  String get commandCenter => 'କମାଣ୍ଡ ସେଣ୍ଟର';

  @override
  String get pilot => 'ପାଇଲଟ';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ସ୍କୋର';

  @override
  String get nextWeapon => 'ପରବର୍ତ୍ତୀ ଅସ୍ତ୍ର';

  @override
  String pointsValue(String points) {
    return '$points ପଏଣ୍ଟ';
  }

  @override
  String get slotFront => 'ଆଗ';

  @override
  String get slotLeft => 'ବାମ';

  @override
  String get slotRight => 'ଡାହାଣ';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'ମିଶନ ଲଞ୍ଚ କରନ୍ତୁ';

  @override
  String get startMission => 'ମିଶନ ଆରମ୍ଭ';

  @override
  String get continueMission => 'ମିଶନ ଜାରି ରଖନ୍ତୁ';

  @override
  String get padControlsHint =>
      '[↑↓] ଧାଡି   [←→] ବାଛନ୍ତୁ   [B] କିଣନ୍ତୁ/ଅପଗ୍ରେଡ/ବଦଳାନ୍ତୁ   [X/Y] ବିକ୍ରି   [OPTIONS] ମିଶନ ଜାରି ରଖନ୍ତୁ';

  @override
  String get host => 'ହୋଷ୍ଟ କରନ୍ତୁ';

  @override
  String hostingAs(String name) {
    return '$name ଭାବେ ହୋଷ୍ଟିଂ';
  }

  @override
  String get join => 'ଯୋଗ ଦିଅନ୍ତୁ';

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
  String get overload => 'ଓଭରଲୋଡ';

  @override
  String weaponOff(String weapon) {
    return '$weapon ବନ୍ଦ — ଜେନେରେଟର ବହୁତ ଦୁର୍ବଳ';
  }

  @override
  String unlocksAt(String points) {
    return '$points ପଏଣ୍ଟରେ ଅନଲକ';
  }

  @override
  String joinConnecting(String target) {
    return '$target ସହ ସଂଯୋଗ ହେଉଛି…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'ହୋଷ୍ଟ ଉତ୍ତର ଦେଲେ ନାହିଁ: $reason।\n\nଉଭୟ ଖେଳାଳି ସମାନ Wi-Fiରେ ଥିବା ଆବଶ୍ୟକ (ପର୍ସନାଲ ହଟସ୍ପଟ ମଧ୍ୟ ଚାଲିବ) ଏବଂ ହୋଷ୍ଟ ହୋଷ୍ଟ କରନ୍ତୁ ଦବାଇଥିବା ଆବଶ୍ୟକ। ଠିକଣା ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';
  }

  @override
  String get lanJoinNoAnswer => 'କୌଣସି ଉତ୍ତର ନାହିଁ';

  @override
  String objBossUnder(int seconds) {
    return 'ବସ ଆସିବାର $seconds ସେକେଣ୍ଡ ମଧ୍ୟରେ ତାହାର କୋର ନଷ୍ଟ କରନ୍ତୁ';
  }

  @override
  String get sectionHangar => 'ହ୍ୟାଙ୍ଗର';

  @override
  String get sectionVault => 'ସିନ୍ଦୁକ';

  @override
  String get rackSide => 'ପାର୍ଶ୍ୱ';

  @override
  String get rackHull => 'ଖୋଳ';

  @override
  String get rarityCommon => 'ସାଧାରଣ';

  @override
  String get rarityRare => 'ବିରଳ';

  @override
  String get rarityMythic => 'ପୌରାଣିକ';

  @override
  String get curse => 'ଅଭିଶାପ';

  @override
  String get modFit => 'ଲଗାନ୍ତୁ';

  @override
  String get modUnfit => 'କାଢନ୍ତୁ';

  @override
  String get modForge => 'ଭାଟି';

  @override
  String get forgeHint => 'ସମାନ ବିରଳତାର 3ଟି ବାଛି ପରବର୍ତ୍ତୀ ବିରଳତାର 1ଟି ଗଢନ୍ତୁ';

  @override
  String get vaultEmpty =>
      'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ମଡ ନାହିଁ। ସମସ୍ତ ତାରା ସହ ଗୋଟିଏ ନୋଡ ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ, ଶୀଘ୍ର ଗୋଟିଏ ବସକୁ ହରାନ୍ତୁ କିମ୍ବା ଅସୀମ ମୋଡରେ ଗୋଟିଏ ବସକୁ ଖସାନ୍ତୁ।';

  @override
  String modNeeds(String families) {
    return '$families ସହ କାମ କରେ';
  }

  @override
  String get modRackFull => 'ର୍ୟାକ ଭର୍ତ୍ତି';

  @override
  String get modAlreadyFitted => 'ପୂର୍ବରୁ ଲାଗିଛି';

  @override
  String get modWrongRack => 'ଏହି ର୍ୟାକରେ ଖାପ ଖାଏ ନାହିଁ';

  @override
  String modsSpilled(int n) {
    return '$nଟି ମଡ ସିନ୍ଦୁକକୁ ଫେରିଲା';
  }

  @override
  String get hullLocked => 'ଲକ';

  @override
  String hullUnlockBoss(int n) {
    return 'ଅଭିଯାନର ବସ $nକୁ ହରାନ୍ତୁ';
  }

  @override
  String get hullUnlockFinish =>
      'ଅଭିଯାନ ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ କିମ୍ବା ସେକ୍ଟର 30ରେ ପହଞ୍ଚନ୍ତୁ';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'ମାନକ ଯାନ';

  @override
  String get perkAfterimage => 'ସ୍ଥିର ରୁହନ୍ତୁ: ଶଟ ×1.5';

  @override
  String get perkBulwark => 'ଢାଲ ପାର ହେଉଥିବା କ୍ଷତି ଅଧା';

  @override
  String get perkOverclock => 'କ୍ଷମତାର 130 % ପର୍ଯ୍ୟନ୍ତ ଫାୟାର, ଧୀରେ';

  @override
  String get perkBattery => 'ଗୋଟିଏ ମାଗଣା ଗନ ଡ୍ରୋନ ସାଥିରେ ଉଡେ';

  @override
  String get rewardTitle => 'ପୁରସ୍କାର';

  @override
  String newHull(String name) {
    return 'ନୂଆ ଖୋଳ: $name';
  }

  @override
  String get socketEmpty => 'ଖାଲି';

  @override
  String fxStreams(int n) {
    return '$nଟି ସମାନ୍ତରାଳ ଧାରା';
  }

  @override
  String fxFan(int n) {
    return '$n ଶଟର ପଙ୍ଖା';
  }

  @override
  String fxSalvo(int n) {
    return '$n ଶଟର ଝଡ';
  }

  @override
  String fxFireRate(String x) {
    return 'ଫାୟାର ହାର ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'କ୍ଷତି ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'ଶଟ ଗତି ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'ଶଟ ଆକାର ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ଶକ୍ତି ବ୍ୟୟ ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'ଲକ୍ଷ୍ୟସନ୍ଧାନୀ +$n';
  }

  @override
  String fxPierce(int n) {
    return '$nଟି ଲକ୍ଷ୍ୟ ଭେଦ କରେ';
  }

  @override
  String get fxPierceAll => 'ସବୁକିଛି ଭେଦ କରେ';

  @override
  String fxCrit(int pct, String x) {
    return '×$x କ୍ଷତିର $pct % ସମ୍ଭାବନା';
  }

  @override
  String fxBossCrit(String x) {
    return 'ବସ ଉପରେ ×$x କ୍ରିଟ';
  }

  @override
  String fxFork(int n) {
    return 'ଖସାଇଲେ $n ଶଟ ବିଛେଇ ହୁଏ';
  }

  @override
  String get fxChain => 'ବିଛା ଶଟ ପୁଣି ବିଛେଇ ହୁଏ';

  @override
  String get fxSplit => 'ବାଜିଲେ ଦୁଇ ଭାଗ ହୁଏ';

  @override
  String get fxFrost => 'ଆଘାତ ଶତ୍ରୁଙ୍କୁ ଧୀର କରେ';

  @override
  String get fxCrossfire => 'ପାର୍ଶ୍ୱ ତୋପ ଭିତର ଆଡକୁ ଢଳେ';

  @override
  String get fxRearguard => 'ପାର୍ଶ୍ୱ ତୋପ ପଛକୁ ମଧ୍ୟ ଫାୟାର କରେ';

  @override
  String get fxOrbit => 'ଶଟ ବଙ୍କା ହୋଇ ଯାଏ';

  @override
  String fxBounce(int n) {
    return 'କାନ୍ଥରୁ $n× ଡେଇଁ ଫେରେ';
  }

  @override
  String get fxBounceTop => '…ଏବଂ ଉପରୁ ମଧ୍ୟ';

  @override
  String get fxOverdrive => 'ଶକ୍ତି ଋଣରେ ଫାୟାର';

  @override
  String get fxReactor => 'କ୍ଷମତାଠୁ ଅଧିକ ତୋପ ମଧ୍ୟ ଫାୟାର କରେ, ଧୀରେ';

  @override
  String fxGenPower(String x) {
    return 'ଜେନେରେଟର ରିଚାର୍ଜ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ଜେନେରେଟର କ୍ଷମତା ×$x';
  }

  @override
  String get fxSurge => 'ପୂର୍ଣ୍ଣ ଜେନେରେଟର: ଶଟ ×2';

  @override
  String fxSiphon(int pct) {
    return 'ଖସାଇଲେ $pct % ଶକ୍ତି ଫେରେ';
  }

  @override
  String fxHp(String x) {
    return 'ଖୋଳ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ଢାଲ ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ଢାଲ ପୁନରୁଦ୍ଧାର ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'ଖସାଇଲେ $n HP ସୁସ୍ଥ';
  }

  @override
  String get fxMagnet => 'ବୋନସ ଟାଣେ';

  @override
  String get fxMagnetAll => 'ପ୍ରତ୍ୟେକ ବୋନସ ଟାଣେ';

  @override
  String fxReflect(int pct) {
    return 'ଢାଲରୁ $pct % ଶଟ ଫେରିଯାଏ';
  }

  @override
  String get fxReflectGuided => 'ଫେରିଥିବା ଶଟ ନିଜେ ଲକ୍ଷ୍ୟ ଖୋଜେ';

  @override
  String fxGhost(String sec) {
    return 'ଖୋଳରେ ଆଘାତ ପରେ $sec ସେକେଣ୍ଡ ଅସ୍ପୃଶ୍ୟ';
  }

  @override
  String get fxNova => 'ଢାଲ ଭାଙ୍ଗିଲେ ପୂରା ସ୍କ୍ରିନରେ ବିସ୍ଫୋରଣ';

  @override
  String fxAgility(String x) {
    return 'ଚଞ୍ଚଳତା ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'ହିଟବକ୍ସ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'କ୍ରେଡିଟ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'ସ୍କୋର ×$x';
  }

  @override
  String get fxSatellite => 'ଗୋଟିଏ ଗନ ଡ୍ରୋନ ସାଥିରେ ଉଡେ';

  @override
  String get fxTimewarp => 'ଖୋଳରେ ଆଘାତ ସମୟକୁ ଧୀର କରେ';

  @override
  String get fxGambler => 'ପ୍ରତ୍ୟେକ ଶଟ ଏକ ଅନିୟମିତ ଅସ୍ତ୍ର';

  @override
  String get vaultAll => 'ସମସ୍ତ';

  @override
  String get sigilMissUnknown => 'ଅଜଣା ଆକାର';

  @override
  String get sigilMissTooSlow => 'ବହୁତ ଧୀର';

  @override
  String get sigilMissSkippedDot => 'ଗୋଟିଏ ବିନ୍ଦୁ ଛାଡିଗଲା';

  @override
  String get sigilMissLeftRimEarly => 'ବହୁତ ଶୀଘ୍ର ଛାଡିଲେ';

  @override
  String get sigilMissWrongDirection => 'ଓଲଟା ଆଙ୍କିଲେ';

  @override
  String get sigilMissWrongLayer => 'ଭୁଲ ସୋଲ୍ଡର ବଟନ';

  @override
  String get sigilDry => 'ଯଥେଷ୍ଟ ଚାର୍ଜ ନାହିଁ';

  @override
  String get sigilBusy => 'ପୂର୍ବଟି ଏବେ ବି ଚାଲିଛି';

  @override
  String get arena => 'ଆରିନା';

  @override
  String get arenaBossParts => 'ବସର ଅଂଶ';

  @override
  String get arenaBareCore => 'ଖୋଲା କୋର';

  @override
  String get arenaCompanions => 'ସାଥୀ';

  @override
  String get arenaCharge => 'ଚାର୍ଜ';

  @override
  String get arenaChargeNormal => 'ସାଧାରଣ';

  @override
  String get arenaSpeed => 'ଦୁନିଆର ବେଗ';

  @override
  String get arenaDrill => 'ଅଭ୍ୟାସ';

  @override
  String get arenaFreePlay => 'ମୁକ୍ତ ଖେଳ';

  @override
  String get arenaFight => 'ଲଢନ୍ତୁ';

  @override
  String get arenaNewBoss => 'ନୂଆ ବସ';

  @override
  String get arenaLeave => 'ଆରିନା ଛାଡନ୍ତୁ';

  @override
  String get arenaHint => 'ବସ ମରିବା କ୍ଷଣି ଫେରିଆସେ। ଏଠାରେ କିଛି ସେଭ ହୁଏ ନାହିଁ।';

  @override
  String get arenaColCast => 'ବ୍ୟବହାର';

  @override
  String get arenaColMiss => 'ଭୁଲ';

  @override
  String get arenaColAvg => 'ହାରାହାରି';

  @override
  String get arenaColBest => 'ସର୍ବୋତ୍ତମ';

  @override
  String get arenaColTime => 'ଦ୍ରୁତତମ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'ବସ $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ପ୍ୟାଡ: ସିଜିଲ';

  @override
  String get padSchemeClassic => 'ପ୍ୟାଡ: କ୍ଲାସିକ';

  @override
  String get padSouthpawOn => 'ବାମହାତି: ଅନ';

  @override
  String get padSouthpawOff => 'ବାମହାତି: ଅଫ';

  @override
  String get sigilDescHop => 'ଫ୍ଲିକ ଦିଗରେ ଶୀଘ୍ର ଡେଇଁ';

  @override
  String get sigilDescSidestep => 'ପଡିଆ ପାର ହୋଇ ଲମ୍ବା ପାର୍ଶ୍ୱ ପାଦ';

  @override
  String get sigilDescStrike => 'ତିନୋଟି ଭାରି ଗୁଳି ସହ ଆଗକୁ ଝାମ୍ପ, ପରେ ଫେରନ୍ତୁ';

  @override
  String get sigilDescRetreat => 'ସୁରକ୍ଷା ଗୁଳି ଆଗକୁ ଯିବାବେଳେ ପଛକୁ ହଟନ୍ତୁ';

  @override
  String get sigilDescDash => 'ନିଆଁ ଦେଇ ତେର୍ଛା ଦୌଡ, ମଝିରେ ଅସ୍ପୃଶ୍ୟ';

  @override
  String get sigilDescRoll => 'ପାର୍ଶ୍ୱକୁ ବ୍ୟାରେଲ ରୋଲ, ଅସ୍ପୃଶ୍ୟ';

  @override
  String get sigilDescShadow => 'ନିକଟତମ ଶତ୍ରୁ ତଳେ ଲାଗି ଗୁଳି ଚଳାନ୍ତୁ';

  @override
  String get sigilDescEcho => 'ଛାଇ ଆପଣଙ୍କ ଶେଷ ଦୁଇ ସେକେଣ୍ଡ ଅଧା କ୍ଷତିରେ ଦୋହରାଏ';

  @override
  String get sigilDescLoop => 'ଉପରେ ଲୁପ: ଗୁଳି ଆପଣଙ୍କ ତଳେ ଯାଏ';

  @override
  String get sigilDescSlalom => 'ପଙ୍ଖା ଗୁଳି ସହ ପଡିଆ ପାର S-ମୋଡ';

  @override
  String get sigilDescCorkscrew => 'ଚାରିପଟେ ଗୁଳି କରି ଆଗକୁ ଘୂର୍ଣ୍ଣି, ଅସ୍ପୃଶ୍ୟ';

  @override
  String get sigilDescSnapshot => 'ଫ୍ଲିକ ଦିଗରେ ଗୋଟିଏ ଭାରି ଗୁଳି';

  @override
  String get sigilDescBroadside => 'ଦୁଇ ପାର୍ଶ୍ୱରୁ ସାଲଭୋ';

  @override
  String get sigilDescVolley => 'ଆଗକୁ ପାଞ୍ଚଟି ଚାର୍ଜ କିରଣ';

  @override
  String get sigilDescCaltrop => 'ଗୁଳି ଗିଳି ଫାଟୁଥିବା ମାଇନ ପକାନ୍ତୁ';

  @override
  String get sigilDescFrenzy => 'କିଛି ସେକେଣ୍ଡ ବନ୍ଧୁକ ଶୀଘ୍ର ଚାଲେ';

  @override
  String get sigilDescStasis => 'ଶତ୍ରୁ ଓ ସେମାନଙ୍କ ଗୁଳି ଅଧା ବେଗରେ';

  @override
  String get sigilDescHalo => 'ଢାଲ ଚାରିଗୁଣ ଶୀଘ୍ର ଭରେ ଓ କିଛି ପଶେ ନାହିଁ';

  @override
  String get sigilDescRadial => 'ଷୋହଳ ଗୁଳିର ବଳୟ';

  @override
  String get sigilDescStorm => 'ପ୍ରତି ବନ୍ଧୁକ ପୂର୍ଣ୍ଣ ଶକ୍ତିରେ, ମାଗଣା';

  @override
  String get sigilDescPing => 'ସାଥୀମାନେ ଫ୍ଲିକ ସ୍ଥାନରେ ଗୁଳି କେନ୍ଦ୍ରିତ କରନ୍ତି';

  @override
  String get sigilDescWingman => 'ଆଙ୍କିଥିବା ପାର୍ଶ୍ୱକୁ ୱିଙ୍ଗମ୍ୟାନ ଡାକନ୍ତୁ';

  @override
  String get sigilDescHunter => 'ଆଗରେ ଉଡି ଲକ୍ଷ୍ୟ ବାଛୁଥିବା ଶିକାରୀ ଡାକନ୍ତୁ';

  @override
  String get sigilDescWarden => 'ଆପଣଙ୍କ ଗୁଳି ସହୁଥିବା ରକ୍ଷକ ଡାକନ୍ତୁ';

  @override
  String get sigilDescFormation => 'ସାଥୀମାନେ ଚଉଡା ଓ ଖୁଣ୍ଟି ଗଠନ ବଦଳାନ୍ତି';

  @override
  String get sigilDescWhirl => 'ସାଥୀମାନେ ଆପଣଙ୍କ ଚାରିପଟେ ଘୂରି ଗୁଳି ଗିଳନ୍ତି';

  @override
  String get sigilDescSacrifice => 'ସାଥୀମାନେ ଡାଇଭ କରି ଫାଟନ୍ତି, ଚାର୍ଜ ଫେରାନ୍ତି';

  @override
  String get grimoire => 'ଗ୍ରିମୋଆର';

  @override
  String get grimoireHint =>
      'ଡାହାଣ ଷ୍ଟିକରେ ଆଙ୍କନ୍ତୁ। ARMS ପାଇଁ LB, WING ପାଇଁ RB, MEGA BLAST ପାଇଁ ଦୁଇଟି ଧରନ୍ତୁ।';

  @override
  String sigilCost(int cost) {
    return 'ମୂଲ୍ୟ $cost';
  }

  @override
  String get sigilUntouchable => 'ଅସ୍ପୃଶ୍ୟ';

  @override
  String get lessonWatch => 'ଦେଖନ୍ତୁ';

  @override
  String get lessonTrace => 'ଅନୁସରଣ କରି ଆଙ୍କନ୍ତୁ';

  @override
  String get lessonSlow => 'ଧୀର';

  @override
  String get lessonLive => 'ପୂର୍ଣ୍ଣ ବେଗ';

  @override
  String get lessonStreak => 'ଲଗାତାର ପାଞ୍ଚ';

  @override
  String get lessonLearned => 'ଶିଖିଲେ';

  @override
  String lessonTempo(int pct) {
    return 'ଟେମ୍ପୋ $pct %';
  }

  @override
  String get hintHop => 'ଡାହାଣ ଷ୍ଟିକ ଫ୍ଲିକ କରନ୍ତୁ';

  @override
  String get hintLoop => 'ବୃତ୍ତ ଆଙ୍କନ୍ତୁ: ଆପଣ ଗୁଳି ଉପରେ ଉଡନ୍ତି';

  @override
  String get hintStream => 'LT ଚାପନ୍ତୁ: ଦୁଇ ବା ତିନି ଧାର';

  @override
  String get arenaKata => 'କାଟା';

  @override
  String get arenaKataOff => 'କିଛି ନାହିଁ';

  @override
  String kataNext(String sigil, String secs) {
    return 'ପରବର୍ତ୍ତୀ $sigil $secs s ରେ';
  }

  @override
  String get arenaGauntlet => 'ଗଣ୍ଟଲେଟ';

  @override
  String get arenaOn => 'ଅନ';

  @override
  String get arenaOff => 'ଅଫ';

  @override
  String gauntletRating(int rating, int best) {
    return 'ରେଟିଂ $rating · ସର୍ବୋତ୍ତମ $best';
  }
}
