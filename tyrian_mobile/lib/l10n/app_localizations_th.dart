// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get connect => 'เชื่อมต่อ';

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
  String get quitToDesktop => 'ออกสู่เดสก์ท็อป';

  @override
  String get selectSkin => 'เลือกสกิน';

  @override
  String get quit => 'ออก';

  @override
  String get restorePurchases => 'กู้คืนการซื้อ';

  @override
  String get locked => 'ล็อกอยู่';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'โล่';

  @override
  String get hudPower => 'พลัง';

  @override
  String get hudGen => 'GEN';

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
  String get startMission => 'เริ่มภารกิจ';

  @override
  String get continueMission => 'ทำภารกิจต่อ';

  @override
  String get padControlsHint =>
      '[B] ซื้อ/อัปเกรด   [X/Y] ขาย   [LB/RB] แท็บ   [OPTIONS] ทำภารกิจต่อ';

  @override
  String get host => 'เป็นโฮสต์';

  @override
  String get connectToHost => 'เชื่อมต่อกับโฮสต์';

  @override
  String hostingAt(String ip) {
    return 'กำลังโฮสต์  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'เข้าร่วม';
}
