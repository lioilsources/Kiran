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
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'สูงสุด';

  @override
  String get upgradeShort => 'อัป';

  @override
  String get sell => 'ขาย';

  @override
  String get buy => 'ซื้อ';

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
  String get startMission => 'เริ่มภารกิจ';

  @override
  String get continueMission => 'ทำภารกิจต่อ';

  @override
  String get padControlsHint =>
      '[↑↓] แถว   [←→] เลือก   [B] ซื้อ/อัปเกรด/สลับ   [X/Y] ขาย   [OPTIONS] ไปต่อ';

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
  String get overload => 'โอเวอร์โหลด';

  @override
  String weaponOff(String weapon) {
    return '$weapon ปิด — เครื่องกำเนิดไฟฟ้าอ่อนเกินไป';
  }

  @override
  String unlocksAt(String points) {
    return 'ปลดล็อกที่ $points คะแนน';
  }

  @override
  String get swapHint => 'แตะค้างสองนิ้วเพื่อยิงด้วยอาวุธชุดที่สอง';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: ยิงแรงขึ้น';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: ซ่อมตัวยานแล้ว';
  }

  @override
  String pickupShield(int amount) {
    return 'โล่ +$amount ชาร์จเร็วขึ้น';
  }

  @override
  String get pickupGenerator => 'เครื่องปั่นไฟแรงขึ้น: อาวุธได้พลังงานมากขึ้น';

  @override
  String pickupCredits(String amount) {
    return '+$amount เครดิตไว้ใช้ใน ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'เลเวล $level';
  }

  @override
  String get tutPickupWeapon => 'ไอเทมอาวุธเพิ่มเลเวลปืน: แรงขึ้น ยิงเร็วขึ้น';

  @override
  String get tutPickupHealth =>
      'ไอเทมซ่อมฟื้นตัวยาน ถ้าเลือดเต็มจะเพิ่ม HP สูงสุด';

  @override
  String get tutPickupShield => 'โล่รับกระสุนก่อนตัวยานและฟื้นฟูเอง';

  @override
  String get tutPickupGenerator =>
      'เครื่องปั่นไฟจ่ายพลังให้ปืน: พลังมากขึ้น ยิงได้หลายกระบอกขึ้น';

  @override
  String get tutPickupCredits =>
      'ใช้เครดิตซื้อปืนและอัปเกรดที่ ComCenter ระหว่างรอบ';

  @override
  String get tutBoss => 'บอส! แถบด้านบนคือพลังชีวิตของมัน ขยับและยิงต่อไป';

  @override
  String get tutLowHp => 'ตัวยานใกล้พัง! ซ่อมด้วยไอเทมหรือที่ ComCenter';

  @override
  String get tutGenStarved =>
      'ปืนต้องการพลังมากกว่าที่เครื่องปั่นไฟให้: อัปเกรดเลย';

  @override
  String get tutCanAfford => 'เงินพออัปเกรดแล้ว: ไป ComCenter หลังจบรอบนี้';

  @override
  String get tutFly => 'ลากนิ้วเพื่อบิน ปืนยิงตลอดที่นิ้วแตะจอ';

  @override
  String get introCollect => 'เก็บไอคอนที่ศัตรูทิ้งไว้';

  @override
  String get introShop => 'ระหว่างรอบ ใช้เครดิตที่ ComCenter';

  @override
  String get objBoss => 'เป้าหมาย: รอดจากคลื่นศัตรูและชนะบอส';

  @override
  String get objSurvive => 'เป้าหมาย: รอดจากคลื่นศัตรู';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits เครดิต · ยิงตก $kills';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'อาวุธยอดเยี่ยม: $weapon';
  }

  @override
  String get deathBoss => 'กระสุนบอสแรงมาก: โล่ที่แข็งขึ้นช่วยซื้อเวลา';

  @override
  String get deathShield => 'อัปเกรดโล่ที่ ComCenter: รับกระสุนก่อนตัวยาน';

  @override
  String get deathGuns => 'ปืนที่แรงขึ้นกวาดคลื่นศัตรูก่อนมันจะทำร้ายคุณ';
}
