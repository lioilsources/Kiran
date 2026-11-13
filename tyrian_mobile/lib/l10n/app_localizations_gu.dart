// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get ok => 'ઠીક છે';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get connect => 'કનેક્ટ કરો';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return '$hostName સાથે કનેક્ટ થઈ શક્યું નહીં';
  }

  @override
  String get nearbyJoinFailedBody =>
      'હોસ્ટ દેખાતો હતો, પણ કનેક્શન બન્યું નહીં.\n\nનજીકમાં રમવા માટે પીઅર-ટુ-પીઅર Wi-Fi જોઈએ, જે પર્સનલ હોટસ્પોટ ચાલુ હોય ત્યારે iOS બંધ કરી દે છે — બંને ડિવાઇસ પર હોટસ્પોટ બંધ કરો અને ફરી પ્રયાસ કરો, અથવા બંને ડિવાઇસને એક જ Wi-Fi સાથે જોડો.';

  @override
  String get gameOverCampaign =>
      'મિશન નિષ્ફળ — લોડઆઉટ અને ક્રેડિટ સાચવ્યાં. કમાન્ડ સેન્ટરમાંથી ફરી પ્રયાસ કરો.';

  @override
  String get gameOverEndless =>
      'સેક્ટર 1માં ફરી નિર્માણ — લોડઆઉટ અને ક્રેડિટ સાચવ્યાં';

  @override
  String get waitingForHost => 'હોસ્ટની રાહ જોવાય છે...';

  @override
  String get waitingForHostHint => 'હોસ્ટ તૈયાર થતાં જ રમત શરૂ થશે';

  @override
  String get vesselLost => 'યાન નષ્ટ';

  @override
  String scoreValue(String score) {
    return 'સ્કોર: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'ક્રેડિટ: $credits';
  }

  @override
  String get creditsPrefix => 'ક્રેડિટ: ';

  @override
  String get leaderboard => 'લીડરબોર્ડ';

  @override
  String get achievements => 'સિદ્ધિઓ';

  @override
  String get redeploy => 'ફરી મેદાનમાં';

  @override
  String get resume => 'ચાલુ રાખો';

  @override
  String get pause => 'થોભો';

  @override
  String get paused => 'થોભાવેલું';

  @override
  String get skins => 'સ્કિન';

  @override
  String get skin => 'સ્કિન';

  @override
  String get soundOn => 'અવાજ: ચાલુ';

  @override
  String get soundOff => 'અવાજ: બંધ';

  @override
  String get musicOn => 'સંગીત: ચાલુ';

  @override
  String get musicOff => 'સંગીત: બંધ';

  @override
  String get mainMenu => 'મુખ્ય મેનૂ';

  @override
  String get quitToDesktop => 'ડેસ્કટોપ પર પાછા';

  @override
  String get selectSkin => 'સ્કિન પસંદ કરો';

  @override
  String get difficulty => 'મુશ્કેલી';

  @override
  String get difficultyEasy => 'સરળ';

  @override
  String get difficultyNormal => 'સામાન્ય';

  @override
  String get difficultyHard => 'મુશ્કેલ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'અભિયાન';

  @override
  String get quit => 'બહાર નીકળો';

  @override
  String get restorePurchases => 'ખરીદી પુનઃસ્થાપિત કરો';

  @override
  String get locked => 'લૉક';

  @override
  String get mainMenuTooltip => 'મુખ્ય મેનૂ';

  @override
  String nodeLevel(int level) {
    return 'લેવલ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'લેવલ $level · બોસ $ordinal';
  }

  @override
  String get nodeLockedHint => 'લૉક છે. પહેલાં પાછલો નોડ પૂરો કરો.';

  @override
  String get flyAgain => 'ફરી ઉડો';

  @override
  String get launch => 'ઉડાન';

  @override
  String zoneLabel(int zone) {
    return 'ઝોન $zone';
  }

  @override
  String get objectiveStar => 'તારો';

  @override
  String get continueButton => 'આગળ';

  @override
  String get replayNode => 'નોડ ફરી રમો';

  @override
  String get retry => 'ફરી પ્રયાસ';

  @override
  String get nodeCleared => 'નોડ પૂર્ણ';

  @override
  String get nodeFailed => 'નોડ નિષ્ફળ';

  @override
  String get weaponTierUnlocked => 'હથિયારનું નવું સ્તર અનલૉક';

  @override
  String get onSaleInComCenter => 'કમાન્ડ સેન્ટરમાં વેચાણ પર.';

  @override
  String get requiredTasksHint =>
      'જરૂરી કાર્યો જ નોડનો નિર્ણય કરે છે. ફરી ઉડો — જે કમાયું તે તમારું જ રહેશે.';

  @override
  String get objClear => 'સેક્ટર સાફ કરો';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દુશ્મનોને તોડી પાડો',
      one: '$count દુશ્મનને તોડી પાડો',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'હલને કોઈ નુકસાન ન થાય';

  @override
  String objHull(int percent) {
    return '$percent%થી વધુ હલ સાથે પૂરું કરો';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$weapon વડે $countનો નાશ કરો',
      one: '$weapon વડે $countનો નાશ કરો',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'બાજુની તોપો વડે $countનો નાશ કરો',
      one: 'બાજુની તોપો વડે $countનો નાશ કરો',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return '$weapon આગળ લગાવીને ઉડાન ભરો';
  }

  @override
  String objFlyWithSide(String weapon) {
    return '$weapon બાજુના માઉન્ટ પર લગાવીને ઉડાન ભરો';
  }

  @override
  String get objBuySideGun => 'કમાન્ડ સેન્ટરમાંથી બાજુની તોપ ખરીદો';

  @override
  String objUpgradeGenerator(int level) {
    return 'જનરેટરને લેવલ $level સુધી અપગ્રેડ કરો';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'આગળની તોપને લેવલ $level સુધી અપગ્રેડ કરો';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'એક બાજુની તોપને લેવલ $level સુધી અપગ્રેડ કરો';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count બોનસ પકડો',
      one: '$count બોનસ પકડો',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count આખી ફોર્મેશનનો સફાયો કરો',
      one: '$count આખી ફોર્મેશનનો સફાયો કરો',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'કોઈ લઘુગ્રહ સાથે ન અથડાઓ';

  @override
  String objUnderTime(int seconds) {
    return '$seconds સેકન્ડમાં પૂરું કરો';
  }

  @override
  String get objStripBoss => 'કોર પહેલાં બોસનો દરેક ભાગ નષ્ટ કરો';

  @override
  String get joinCoopTitle => 'કો-ઓપમાં જોડાઓ';

  @override
  String get cannotSearchNetwork => 'આ નેટવર્ક પર શોધી શકાતું નથી';

  @override
  String get joinHintNearby =>
      'એક જ Wi-Fi દરેક ડિવાઇસ પર ચાલે છે. iPhone, iPad અને Mac તેના વિના પણ નજીકમાં એકબીજાને શોધી લે છે — બંને પર પર્સનલ હોટસ્પોટ બંધ હોય ત્યારે.';

  @override
  String get joinHintWifi =>
      'બંને ખેલાડીઓ એક જ Wi-Fi પર હોવા જોઈએ — પર્સનલ હોટસ્પોટ પણ ચાલશે.';

  @override
  String noHostsYet(String hint) {
    return 'હજી કોઈ હોસ્ટ નથી. $hint';
  }

  @override
  String get lookingForHosts => 'આ Wi-Fi પર અને નજીકમાં હોસ્ટ શોધાય છે…';

  @override
  String get hostNearby => 'નજીક · Bluetooth / પીઅર-ટુ-પીઅર Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · એ જ Wi-Fi';
  }

  @override
  String get enterIpManually => 'IP જાતે દાખલ કરો';

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
    return '$name — ઢાલથી સુરક્ષિત';
  }

  @override
  String get bossPartTurret => 'ટરેટ';

  @override
  String get bossPartShieldPod => 'ઢાલ પોડ';

  @override
  String get bossPartThruster => 'થ્રસ્ટર';

  @override
  String get bossPartCannon => 'તોપ';

  @override
  String sectorUnknownSpace(int level) {
    return 'સેક્ટર $level — અજાણ્યું અવકાશ';
  }

  @override
  String get player2Joined => 'ખેલાડી 2 જોડાયો!';

  @override
  String get player2Disconnected => 'ખેલાડી 2નું કનેક્શન તૂટ્યું';

  @override
  String get hostDisconnected => 'હોસ્ટનું કનેક્શન તૂટ્યું';

  @override
  String maxLevelSold(String amount) {
    return 'મહત્તમ લેવલ! \$$amountમાં વેચાયું';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'હથિયાર સ્તર $tier અનલૉક';
  }

  @override
  String get cheatsEnabled => 'ચીટ્સ ચાલુ';

  @override
  String get cheatsDisabled => 'ચીટ્સ બંધ';

  @override
  String get cheatsMaxed => 'ચીટ: ક્રેડિટ મહત્તમ, બધાં હથિયાર અનલૉક';

  @override
  String get cheats => 'ચીટ્સ';

  @override
  String get maxCredits => 'મહત્તમ ક્રેડિટ';

  @override
  String get sectionStats => 'આંકડા';

  @override
  String get sectionLoadout => 'લોડઆઉટ';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'અપગ્રેડ';

  @override
  String get sell => 'વેચો';

  @override
  String get buy => 'ખરીદો';

  @override
  String get commandCenter => 'કમાન્ડ સેન્ટર';

  @override
  String get pilot => 'પાઇલટ';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'સ્કોર';

  @override
  String get nextWeapon => 'પછીનું હથિયાર';

  @override
  String pointsValue(String points) {
    return '$points પોઇન્ટ';
  }

  @override
  String get slotFront => 'આગળ';

  @override
  String get slotLeft => 'ડાબે';

  @override
  String get slotRight => 'જમણે';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'PWR';

  @override
  String get launchMission => 'મિશન લોન્ચ કરો';

  @override
  String get startMission => 'મિશન શરૂ કરો';

  @override
  String get continueMission => 'મિશન ચાલુ રાખો';

  @override
  String get padControlsHint =>
      '[↑↓] પંક્તિ   [←→] પસંદ   [B] ખરીદો/અપગ્રેડ/બદલો   [X/Y] વેચો   [OPTIONS] મિશન ચાલુ રાખો';

  @override
  String get host => 'હોસ્ટ કરો';

  @override
  String hostingAs(String name) {
    return '$name તરીકે હોસ્ટિંગ';
  }

  @override
  String get join => 'જોડાઓ';

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
  String get overload => 'ઓવરલોડ';

  @override
  String weaponOff(String weapon) {
    return '$weapon બંધ — જનરેટર બહુ નબળું';
  }

  @override
  String unlocksAt(String points) {
    return '$points પોઇન્ટ પર અનલૉક';
  }

  @override
  String joinConnecting(String target) {
    return '$target સાથે કનેક્ટ થાય છે…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'હોસ્ટે જવાબ આપ્યો નહીં: $reason.\n\nબંને ખેલાડીઓ એક જ Wi-Fi પર હોવા જોઈએ (પર્સનલ હોટસ્પોટ પણ ચાલશે) અને હોસ્ટે હોસ્ટ કરો દબાવ્યું હોવું જોઈએ. સરનામું તપાસીને ફરી પ્રયાસ કરો.';
  }

  @override
  String get lanJoinNoAnswer => 'કોઈ જવાબ નથી';

  @override
  String objBossUnder(int seconds) {
    return 'બોસ આવ્યા પછી $seconds સેકન્ડમાં તેનો કોર નષ્ટ કરો';
  }

  @override
  String get sectionHangar => 'હેંગર';

  @override
  String get sectionVault => 'તિજોરી';

  @override
  String get rackSide => 'બાજુ';

  @override
  String get rackHull => 'હલ';

  @override
  String get rarityCommon => 'સામાન્ય';

  @override
  String get rarityRare => 'દુર્લભ';

  @override
  String get rarityMythic => 'પૌરાણિક';

  @override
  String get curse => 'શ્રાપ';

  @override
  String get modFit => 'લગાવો';

  @override
  String get modUnfit => 'કાઢો';

  @override
  String get modForge => 'ભઠ્ઠી';

  @override
  String get forgeHint => 'એક જ દુર્લભતાના 3 પસંદ કરી પછીની દુર્લભતાનો 1 ઘડો';

  @override
  String get vaultEmpty =>
      'હજી કોઈ મોડ નથી. બધા તારા સાથે નોડ પૂરો કરો, બોસને ઝડપથી હરાવો અથવા અનંત મોડમાં બોસને તોડી પાડો.';

  @override
  String modNeeds(String families) {
    return '$families સાથે ચાલે છે';
  }

  @override
  String get modRackFull => 'રેક ભરેલી છે';

  @override
  String get modAlreadyFitted => 'પહેલેથી લગાવેલું';

  @override
  String get modWrongRack => 'આ રેકમાં બેસતું નથી';

  @override
  String modsSpilled(int n) {
    return '$n મોડ તિજોરીમાં પાછા';
  }

  @override
  String get hullLocked => 'લૉક';

  @override
  String hullUnlockBoss(int n) {
    return 'અભિયાનના બોસ $nને હરાવો';
  }

  @override
  String get hullUnlockFinish => 'અભિયાન પૂરું કરો અથવા સેક્ટર 30 સુધી પહોંચો';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'HIT';

  @override
  String get perkNone => 'માનક યાન';

  @override
  String get perkAfterimage => 'સ્થિર રહો: શોટ ×1.5';

  @override
  String get perkBulwark => 'ઢાલ પારનું નુકસાન અડધું';

  @override
  String get perkOverclock => 'ક્ષમતાના 130 % સુધી ફાયર, ધીમે';

  @override
  String get perkBattery => 'એક મફત ગન ડ્રોન સાથે ઉડે છે';

  @override
  String get rewardTitle => 'ઇનામ';

  @override
  String newHull(String name) {
    return 'નવો હલ: $name';
  }

  @override
  String get socketEmpty => 'ખાલી';

  @override
  String fxStreams(int n) {
    return '$n સમાંતર ધારાઓ';
  }

  @override
  String fxFan(int n) {
    return '$n શોટનો પંખો';
  }

  @override
  String fxSalvo(int n) {
    return '$n શોટનો મારો';
  }

  @override
  String fxFireRate(String x) {
    return 'ફાયર દર ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'નુકસાન ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'શોટની ઝડપ ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'શોટનું કદ ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ઊર્જા વપરાશ ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'લક્ષ્યશોધક +$n';
  }

  @override
  String fxPierce(int n) {
    return '$n લક્ષ્યોની આરપાર';
  }

  @override
  String get fxPierceAll => 'બધાની આરપાર';

  @override
  String fxCrit(int pct, String x) {
    return '×$x નુકસાનની $pct % શક્યતા';
  }

  @override
  String fxBossCrit(String x) {
    return 'બોસ પર ×$x ક્રિટ';
  }

  @override
  String fxFork(int n) {
    return 'તોડી પાડતાં $n શોટ વિખેરાય છે';
  }

  @override
  String get fxChain => 'વિખેરાયેલા શોટ ફરી વિખેરાય છે';

  @override
  String get fxSplit => 'વાગતાં બે ભાગમાં વહેંચાય છે';

  @override
  String get fxFrost => 'પ્રહાર દુશ્મનોને ધીમા પાડે છે';

  @override
  String get fxCrossfire => 'બાજુની તોપો અંદર તરફ ઝૂકે છે';

  @override
  String get fxRearguard => 'બાજુની તોપો પાછળ પણ ફાયર કરે છે';

  @override
  String get fxOrbit => 'શોટ વળાંક લે છે';

  @override
  String fxBounce(int n) {
    return 'દીવાલો પરથી $n× ઊછળે છે';
  }

  @override
  String get fxBounceTop => '…અને ઉપરથી પણ';

  @override
  String get fxOverdrive => 'ઊર્જાના દેવા પર ફાયર';

  @override
  String get fxReactor => 'ક્ષમતાથી વધુ તોપો પણ ફાયર કરે છે, ધીમે';

  @override
  String fxGenPower(String x) {
    return 'જનરેટર રિચાર્જ ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'જનરેટર ક્ષમતા ×$x';
  }

  @override
  String get fxSurge => 'ભરેલું જનરેટર: શોટ ×2';

  @override
  String fxSiphon(int pct) {
    return 'તોડી પાડતાં $pct % ઊર્જા પાછી';
  }

  @override
  String fxHp(String x) {
    return 'હલ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'ઢાલ ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ઢાલ પુનઃપ્રાપ્તિ ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'તોડી પાડતાં $n HP સાજા';
  }

  @override
  String get fxMagnet => 'બોનસ ખેંચે છે';

  @override
  String get fxMagnetAll => 'દરેક બોનસ ખેંચે છે';

  @override
  String fxReflect(int pct) {
    return 'ઢાલ પરથી $pct % શોટ પાછા ફરે છે';
  }

  @override
  String get fxReflectGuided => 'પાછા ફરેલા શોટ જાતે લક્ષ્ય શોધે છે';

  @override
  String fxGhost(String sec) {
    return 'હલ પર પ્રહાર પછી $sec સેકન્ડ અસ્પૃશ્ય';
  }

  @override
  String get fxNova => 'ઢાલ તૂટે તો આખી સ્ક્રીન પર વિસ્ફોટ';

  @override
  String fxAgility(String x) {
    return 'ચપળતા ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'હિટબોક્સ ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'ક્રેડિટ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'સ્કોર ×$x';
  }

  @override
  String get fxSatellite => 'એક ગન ડ્રોન સાથે ઉડે છે';

  @override
  String get fxTimewarp => 'હલ પર પ્રહાર સમયને ધીમો કરે છે';

  @override
  String get fxGambler => 'દરેક શોટ એક રેન્ડમ હથિયાર';

  @override
  String get vaultAll => 'બધા';

  @override
  String get sigilMissUnknown => 'અજાણ્યો આકાર';

  @override
  String get sigilMissTooSlow => 'ખૂબ ધીમું';

  @override
  String get sigilMissSkippedDot => 'એક બિંદુ છૂટ્યું';

  @override
  String get sigilMissLeftRimEarly => 'ખૂબ વહેલું છોડ્યું';

  @override
  String get sigilMissWrongDirection => 'ઊંધું દોર્યું';

  @override
  String get sigilMissWrongLayer => 'ખોટું શોલ્ડર બટન';

  @override
  String get sigilDry => 'પૂરતો ચાર્જ નથી';

  @override
  String get sigilBusy => 'પાછલું હજી ચાલે છે';

  @override
  String get arena => 'અખાડો';

  @override
  String get arenaBossParts => 'બોસના ભાગ';

  @override
  String get arenaBareCore => 'ખુલ્લો કોર';

  @override
  String get arenaCompanions => 'સાથીઓ';

  @override
  String get arenaCharge => 'ચાર્જ';

  @override
  String get arenaChargeNormal => 'સામાન્ય';

  @override
  String get arenaSpeed => 'દુનિયાની ઝડપ';

  @override
  String get arenaDrill => 'અભ્યાસ';

  @override
  String get arenaFreePlay => 'ફ્રી પ્લે';

  @override
  String get arenaFight => 'લડો';

  @override
  String get arenaNewBoss => 'નવો બોસ';

  @override
  String get arenaLeave => 'અખાડો છોડો';

  @override
  String get arenaHint => 'બોસ મરતાં જ પાછો આવે છે. અહીં કંઈ સેવ થતું નથી.';

  @override
  String get arenaColCast => 'પ્રયોગ';

  @override
  String get arenaColMiss => 'ચૂક';

  @override
  String get arenaColAvg => 'સરેરાશ';

  @override
  String get arenaColBest => 'શ્રેષ્ઠ';

  @override
  String get arenaColTime => 'સૌથી ઝડપી';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'બોસ $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'પેડ: સિજિલ';

  @override
  String get padSchemeClassic => 'પેડ: ક્લાસિક';

  @override
  String get padSouthpawOn => 'ડાબોડી: ચાલુ';

  @override
  String get padSouthpawOff => 'ડાબોડી: બંધ';

  @override
  String get sigilDescHop => 'ફ્લિકની દિશામાં ઝડપી કૂદકો';

  @override
  String get sigilDescSidestep => 'મેદાન પાર લાંબું બાજુ-પગલું';

  @override
  String get sigilDescStrike => 'ત્રણ ભારે શોટ સાથે આગળ ધસારો, પછી પાછા';

  @override
  String get sigilDescRetreat => 'પાછા હટો, કવરિંગ ફાયર આગળ જાય છે';

  @override
  String get sigilDescDash => 'આગ વચ્ચેથી ત્રાંસો ડેશ, અધવચ્ચે અસ્પૃશ્ય';

  @override
  String get sigilDescRoll => 'બાજુમાં બેરલ રોલ, અસ્પૃશ્ય';

  @override
  String get sigilDescShadow => 'નજીકના દુશ્મન નીચે લોક થઈ ફાયર ચાલુ રાખો';

  @override
  String get sigilDescEcho =>
      'એક પડછાયો તમારી છેલ્લી બે સેકન્ડ અડધા નુકસાને ફરી ભજવે છે';

  @override
  String get sigilDescLoop => 'ઉપરથી લૂપ: શોટ તમારી નીચેથી જાય છે';

  @override
  String get sigilDescSlalom => 'પંખા જેવા ફાયર સાથે મેદાનમાં S-વળાંક';

  @override
  String get sigilDescCorkscrew =>
      'ચારે બાજુ ફાયર કરતાં આગળ કૉર્કસ્ક્રૂ, અસ્પૃશ્ય';

  @override
  String get sigilDescSnapshot => 'ફ્લિકની દિશામાં એક ભારે શોટ';

  @override
  String get sigilDescBroadside => 'બંને બાજુથી વરસાદ';

  @override
  String get sigilDescVolley => 'આગળ પાંચ ચાર્જ્ડ કિરણો';

  @override
  String get sigilDescCaltrop => 'એક માઇન નાખો જે શોટ ગળીને ફાટે છે';

  @override
  String get sigilDescFrenzy => 'થોડી સેકન્ડ હથિયારો ઝડપથી ચાલે છે';

  @override
  String get sigilDescStasis => 'દુશ્મનો અને તેમના શોટ અડધી ઝડપે';

  @override
  String get sigilDescHalo => 'ઢાલ ચાર ગણી ઝડપે ચાર્જ થાય અને કંઈ પાર થતું નથી';

  @override
  String get sigilDescRadial => 'સોળ શોટની વીંટી';

  @override
  String get sigilDescStorm => 'દરેક હથિયાર પૂરી તાકાતે, મફત';

  @override
  String get sigilDescPing => 'સાથીઓ ફ્લિકની દિશામાં ફાયર કેન્દ્રિત કરે છે';

  @override
  String get sigilDescWingman => 'જે બાજુ દોર્યું ત્યાં વિંગમેન બોલાવો';

  @override
  String get sigilDescHunter => 'શિકારી બોલાવો જે આગળ ઊડીને નિશાન પસંદ કરે';

  @override
  String get sigilDescWarden => 'રક્ષક બોલાવો જે તમારા શોટ ઝીલે';

  @override
  String get sigilDescFormation => 'સાથીઓ પહોળી અને ફાચર રચના વચ્ચે બદલાય છે';

  @override
  String get sigilDescWhirl => 'સાથીઓ તમારી આસપાસ ફરીને શોટ ગળે છે';

  @override
  String get sigilDescSacrifice => 'સાથીઓ ઝંપલાવી ફાટે છે, ચાર્જ પાછો આપે છે';

  @override
  String get grimoire => 'ગ્રિમોયર';

  @override
  String get grimoireHint =>
      'જમણી સ્ટિકથી દોરો. ARMS માટે LB, WING માટે RB, બંને MEGA BLAST માટે.';

  @override
  String sigilCost(int cost) {
    return 'કિંમત $cost';
  }

  @override
  String get sigilUntouchable => 'અસ્પૃશ્ય';

  @override
  String get lessonWatch => 'જુઓ';

  @override
  String get lessonTrace => 'ટ્રેસ કરો';

  @override
  String get lessonSlow => 'ધીમું';

  @override
  String get lessonLive => 'પૂરી ઝડપ';

  @override
  String get lessonStreak => 'સતત પાંચ';

  @override
  String get lessonLearned => 'શીખ્યા';

  @override
  String lessonTempo(int pct) {
    return 'ટેમ્પો $pct %';
  }

  @override
  String get hintHop => 'જમણી સ્ટિક ફ્લિક કરો';

  @override
  String get hintLoop => 'વર્તુળ દોરો: તમે શોટ ઉપરથી ઊડો છો';

  @override
  String get hintStream => 'LT દબાવો: બે કે ત્રણ ધારા';

  @override
  String get arenaKata => 'કાતા';

  @override
  String get arenaKataOff => 'કંઈ નહીં';

  @override
  String kataNext(String sigil, String secs) {
    return 'આગળ $sigil $secs s માં';
  }

  @override
  String get arenaGauntlet => 'પડકાર';

  @override
  String get arenaOn => 'ચાલુ';

  @override
  String get arenaOff => 'બંધ';

  @override
  String gauntletRating(int rating, int best) {
    return 'રેટિંગ $rating · શ્રેષ્ઠ $best';
  }
}
