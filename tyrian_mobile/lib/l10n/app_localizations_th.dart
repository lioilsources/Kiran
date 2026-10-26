// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'เชื่อมต่อกับ $hostName ไม่ได้';
  }

  @override
  String get nearbyJoinFailedBody =>
      'มองเห็นโฮสต์แล้ว แต่ไม่สามารถสร้างการเชื่อมต่อได้\n\nการเล่นแบบใกล้กันต้องใช้ Wi-Fi แบบเพียร์ทูเพียร์ ซึ่ง iOS จะปิดไว้ขณะเปิดฮอตสปอตส่วนบุคคล ให้ปิดฮอตสปอตบนทั้งสองเครื่องแล้วลองอีกครั้ง หรือเชื่อมต่อทั้งสองเครื่องกับ Wi-Fi เดียวกัน';

  @override
  String get gameOverCampaign =>
      'ภารกิจล้มเหลว — อุปกรณ์และเครดิตยังอยู่ ลองใหม่จากศูนย์บัญชาการ';

  @override
  String get gameOverEndless =>
      'กำลังสร้างใหม่ที่เซกเตอร์ 1 — อุปกรณ์และเครดิตยังอยู่';

  @override
  String get waitingForHost => 'กำลังรอโฮสต์...';

  @override
  String get waitingForHostHint => 'เกมจะเริ่มเมื่อโฮสต์พร้อม';

  @override
  String get vesselLost => 'ยานถูกทำลาย';

  @override
  String scoreValue(String score) {
    return 'คะแนน: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'เครดิต: $credits';
  }

  @override
  String get creditsPrefix => 'เครดิต: ';

  @override
  String get leaderboard => 'กระดานผู้นำ';

  @override
  String get achievements => 'ความสำเร็จ';

  @override
  String get redeploy => 'ออกรบอีกครั้ง';

  @override
  String get resume => 'เล่นต่อ';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get paused => 'หยุดชั่วคราว';

  @override
  String get skins => 'สกิน';

  @override
  String get skin => 'สกิน';

  @override
  String get soundOn => 'เสียง: เปิด';

  @override
  String get soundOff => 'เสียง: ปิด';

  @override
  String get musicOn => 'เพลง: เปิด';

  @override
  String get musicOff => 'เพลง: ปิด';

  @override
  String get mainMenu => 'เมนูหลัก';

  @override
  String get quitToDesktop => 'ออกสู่เดสก์ท็อป';

  @override
  String get selectSkin => 'เลือกสกิน';

  @override
  String get difficulty => 'ความยาก';

  @override
  String get difficultyEasy => 'ง่าย';

  @override
  String get difficultyNormal => 'ปกติ';

  @override
  String get difficultyHard => 'ยาก';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'แคมเปญ';

  @override
  String get quit => 'ออก';

  @override
  String get restorePurchases => 'กู้คืนการซื้อ';

  @override
  String get locked => 'ล็อกอยู่';

  @override
  String get mainMenuTooltip => 'เมนูหลัก';

  @override
  String nodeLevel(int level) {
    return 'เลเวล $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'เลเวล $level · บอส $ordinal';
  }

  @override
  String get nodeLockedHint => 'ล็อกอยู่ ผ่านภารกิจก่อนหน้าให้ได้ก่อน';

  @override
  String get flyAgain => 'บินอีกครั้ง';

  @override
  String get launch => 'ออกบิน';

  @override
  String zoneLabel(int zone) {
    return 'โซน $zone';
  }

  @override
  String get objectiveStar => 'ดาว';

  @override
  String get continueButton => 'ไปต่อ';

  @override
  String get replayNode => 'เล่นภารกิจซ้ำ';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get nodeCleared => 'ภารกิจสำเร็จ';

  @override
  String get nodeFailed => 'ภารกิจล้มเหลว';

  @override
  String get weaponTierUnlocked => 'ปลดล็อกอาวุธระดับใหม่';

  @override
  String get onSaleInComCenter => 'วางขายแล้วที่ศูนย์บัญชาการ';

  @override
  String get requiredTasksHint =>
      'ภารกิจบังคับเป็นตัวตัดสินผล บินอีกครั้งได้เลย — สิ่งที่ได้มาจะยังอยู่กับคุณ';

  @override
  String get objClear => 'เคลียร์เซกเตอร์';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ยิงศัตรูตก $count ลำ',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'ไม่ให้ตัวยานเสียหาย';

  @override
  String objHull(int percent) {
    return 'จบด้วยตัวยานเกิน $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'กำจัด $count ลำด้วย $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'กำจัด $count ลำด้วยปืนข้าง',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'ออกบินโดยติด $weapon ไว้ด้านหน้า';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'ออกบินโดยติด $weapon ไว้ด้านข้าง';
  }

  @override
  String get objBuySideGun => 'ซื้อปืนข้างที่ศูนย์บัญชาการ';

  @override
  String objUpgradeGenerator(int level) {
    return 'อัปเกรดเครื่องกำเนิดไฟฟ้าเป็นเลเวล $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'อัปเกรดปืนหน้าเป็นเลเวล $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'อัปเกรดปืนข้างเป็นเลเวล $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เก็บไอเทม $count ชิ้น',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ทำลายฝูงบินทั้งฝูง $count ฝูง',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'ห้ามชนอุกกาบาต';

  @override
  String objUnderTime(int seconds) {
    return 'จบภายใน $seconds วินาที';
  }

  @override
  String get objStripBoss => 'ทำลายทุกชิ้นส่วนของบอสก่อนแกนกลาง';

  @override
  String get joinCoopTitle => 'เข้าร่วมโคออป';

  @override
  String get cannotSearchNetwork => 'ค้นหาในเครือข่ายนี้ไม่ได้';

  @override
  String get joinHintNearby =>
      'ใช้ Wi-Fi เดียวกันได้กับทุกอุปกรณ์ iPhone, iPad และ Mac ยังหากันเจอในระยะใกล้ได้โดยไม่ต้องใช้ Wi-Fi — เมื่อปิดฮอตสปอตส่วนบุคคลทั้งสองเครื่อง';

  @override
  String get joinHintWifi =>
      'ผู้เล่นทั้งสองต้องอยู่ใน Wi-Fi เดียวกัน — ใช้ฮอตสปอตส่วนบุคคลก็ได้';

  @override
  String noHostsYet(String hint) {
    return 'ยังไม่พบโฮสต์ $hint';
  }

  @override
  String get lookingForHosts =>
      'กำลังค้นหาโฮสต์ใน Wi-Fi นี้และบริเวณใกล้เคียง…';

  @override
  String get hostNearby => 'ใกล้เคียง · บลูทูธ / Wi-Fi เพียร์ทูเพียร์';

  @override
  String hostSameWifi(String address) {
    return '$address · Wi-Fi เดียวกัน';
  }

  @override
  String get enterIpManually => 'ป้อน IP เอง';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'โล่';

  @override
  String get hudPower => 'พลัง';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — มีโล่';
  }

  @override
  String get bossPartTurret => 'ป้อมปืน';

  @override
  String get bossPartShieldPod => 'โมดูลโล่';

  @override
  String get bossPartThruster => 'เครื่องขับดัน';

  @override
  String get bossPartCannon => 'ปืนใหญ่';

  @override
  String sectorUnknownSpace(int level) {
    return 'เซกเตอร์ $level — ห้วงอวกาศลึกลับ';
  }

  @override
  String get player2Joined => 'ผู้เล่น 2 เข้าร่วมแล้ว!';

  @override
  String get player2Disconnected => 'ผู้เล่น 2 ขาดการเชื่อมต่อ';

  @override
  String get hostDisconnected => 'โฮสต์ขาดการเชื่อมต่อ';

  @override
  String maxLevelSold(String amount) {
    return 'เลเวลสูงสุด! ขายได้ \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'ปลดล็อกอาวุธระดับ $tier';
  }

  @override
  String get cheatsEnabled => 'เปิดสูตรโกงแล้ว';

  @override
  String get cheatsDisabled => 'ปิดสูตรโกงแล้ว';

  @override
  String get cheatsMaxed => 'สูตรโกง: เครดิตเต็ม ปลดล็อกอาวุธทั้งหมด';

  @override
  String get cheats => 'สูตรโกง';

  @override
  String get maxCredits => 'เครดิตเต็ม';

  @override
  String get sectionStats => 'ค่าสถานะ';

  @override
  String get sectionLoadout => 'อาวุธที่ติดตั้ง';

  @override
  String get sectionOutfitting => 'ติดตั้งอุปกรณ์';

  @override
  String get sectionShop => 'ร้านค้า';

  @override
  String get tabFront => 'หน้า';

  @override
  String get tabSide => 'ข้าง';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => 'ซ้าย';

  @override
  String get sideRight => 'ขวา';

  @override
  String get noWeaponInstalled => 'ยังไม่ได้ติดอาวุธ';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'ดาเมจ:$damage ความเร็ว:$speed';
  }

  @override
  String statPower(int power) {
    return 'พลัง:$power';
  }

  @override
  String get beam => 'ลำแสง';

  @override
  String get guided => 'นำวิถี';

  @override
  String get owned => 'มีแล้ว';

  @override
  String get max => 'สูงสุด';

  @override
  String get upgrade => 'อัปเกรด';

  @override
  String get upgradeShort => 'อัป';

  @override
  String get sell => 'ขาย';

  @override
  String get buy => 'ซื้อ';

  @override
  String get noCredits => 'เครดิตไม่พอ';

  @override
  String get commandCenter => 'ศูนย์บัญชาการ';

  @override
  String get pilot => 'นักบิน';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'คะแนน';

  @override
  String get nextWeapon => 'อาวุธถัดไป';

  @override
  String pointsValue(String points) {
    return '$points แต้ม';
  }

  @override
  String get slotFront => 'หน้า';

  @override
  String get slotLeft => 'ซ้าย';

  @override
  String get slotRight => 'ขวา';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'พลัง';

  @override
  String get generator => 'เครื่องกำเนิดไฟฟ้า';

  @override
  String genOutput(String value) {
    return 'พลัง: +$value/เฟรม';
  }

  @override
  String genCapacity(int value) {
    return 'ความจุ: $value';
  }

  @override
  String get launchMission => 'เริ่มภารกิจ';

  @override
  String get startMission => 'เริ่มภารกิจ';

  @override
  String get continueMission => 'ทำภารกิจต่อ';

  @override
  String get padControlsHint =>
      '[↑↓] เลือก   [←→] คอลัมน์   [LB/RB] แท็บ   [A] ช่องซ้าย/ขวา    —    [B] ซื้อ/อัปเกรด   [X/Y] ขาย   [OPTIONS] ไปต่อ';

  @override
  String get host => 'เป็นโฮสต์';

  @override
  String hostingAs(String name) {
    return 'โฮสต์ในชื่อ $name';
  }

  @override
  String get join => 'เข้าร่วม';
}
