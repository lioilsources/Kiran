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
  String get launchMission => 'เริ่มภารกิจ';

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
  String hostingAs(String name) {
    return 'โฮสต์ในชื่อ $name';
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
  String joinConnecting(String target) {
    return 'กำลังเชื่อมต่อกับ $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'โฮสต์ไม่ตอบกลับ: $reason\n\nผู้เล่นทั้งสองต้องอยู่ใน Wi-Fi เดียวกัน (ฮอตสปอตส่วนบุคคลก็ใช้ได้) และโฮสต์ต้องกด HOST แล้ว ตรวจสอบที่อยู่แล้วลองอีกครั้ง';
  }

  @override
  String get lanJoinNoAnswer => 'ไม่มีการตอบกลับ';

  @override
  String objBossUnder(int seconds) {
    return 'ทำลายแกนบอสภายใน $seconds วินาทีหลังมันมาถึง';
  }

  @override
  String get sectionHangar => 'โรงเก็บ';

  @override
  String get sectionVault => 'คลัง';

  @override
  String get rackSide => 'ข้าง';

  @override
  String get rackHull => 'ตัวเรือ';

  @override
  String get rarityCommon => 'ธรรมดา';

  @override
  String get rarityRare => 'หายาก';

  @override
  String get rarityMythic => 'ตำนาน';

  @override
  String get curse => 'คำสาป';

  @override
  String get modFit => 'ติดตั้ง';

  @override
  String get modUnfit => 'ถอด';

  @override
  String get modForge => 'โรงตีเหล็ก';

  @override
  String get forgeHint => 'เลือก 3 ชิ้นระดับเดียวกันเพื่อตี 1 ชิ้นระดับถัดไป';

  @override
  String get vaultEmpty =>
      'ยังไม่มีมอด เคลียร์โหนดให้ได้ดาวครบ ปราบบอสให้เร็ว หรือยิงบอสในโหมดไม่รู้จบ';

  @override
  String modNeeds(String families) {
    return 'ใช้กับ $families';
  }

  @override
  String get modRackFull => 'แร็คเต็ม';

  @override
  String get modAlreadyFitted => 'ติดตั้งแล้ว';

  @override
  String get modWrongRack => 'ใส่แร็คนี้ไม่ได้';

  @override
  String modsSpilled(int n) {
    return '$n มอดกลับเข้าคลัง';
  }

  @override
  String get hullLocked => 'ล็อกอยู่';

  @override
  String hullUnlockBoss(int n) {
    return 'ปราบบอสแคมเปญ $n';
  }

  @override
  String get hullUnlockFinish => 'จบแคมเปญหรือถึงเซกเตอร์ 30';

  @override
  String get statAgility => 'คล่อง';

  @override
  String get statHitbox => 'เป้า';

  @override
  String get perkNone => 'เรือมาตรฐาน';

  @override
  String get perkAfterimage => 'อยู่นิ่ง: กระสุน ×1.5';

  @override
  String get perkBulwark => 'ความเสียหายที่ทะลุโล่ลดครึ่ง';

  @override
  String get perkOverclock => 'ยิงอาวุธได้ถึง 130 % ของความจุ แต่ช้าลง';

  @override
  String get perkBattery => 'มีโดรนฟรีบินตาม';

  @override
  String get rewardTitle => 'รางวัล';

  @override
  String newHull(String name) {
    return 'ตัวเรือใหม่: $name';
  }

  @override
  String get socketEmpty => 'ว่าง';

  @override
  String fxStreams(int n) {
    return '$n สายขนาน';
  }

  @override
  String fxFan(int n) {
    return 'พัด $n นัด';
  }

  @override
  String fxSalvo(int n) {
    return 'ชุด $n นัด';
  }

  @override
  String fxFireRate(String x) {
    return 'อัตรายิง ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'ความเสียหาย ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'ความเร็วกระสุน ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'ขนาดกระสุน ×$x';
  }

  @override
  String fxPower(String x) {
    return 'ใช้พลังงาน ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'นำวิถี +$n';
  }

  @override
  String fxPierce(int n) {
    return 'ทะลุ $n เป้า';
  }

  @override
  String get fxPierceAll => 'ทะลุทุกอย่าง';

  @override
  String fxCrit(int pct, String x) {
    return 'โอกาส $pct % ทำความเสียหาย ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'คริติคอล ×$x ใส่บอส';
  }

  @override
  String fxFork(int n) {
    return 'การฆ่ากระจาย $n นัด';
  }

  @override
  String get fxChain => 'นัดที่กระจายกระจายต่อ';

  @override
  String get fxSplit => 'แยกเป็นสองเมื่อโดน';

  @override
  String get fxFrost => 'โดนแล้วศัตรูช้าลง';

  @override
  String get fxCrossfire => 'ปืนข้างเล็งเข้ากลาง';

  @override
  String get fxRearguard => 'ปืนข้างยิงไปด้านหลังด้วย';

  @override
  String get fxOrbit => 'กระสุนส่ายไปมา';

  @override
  String fxBounce(int n) {
    return 'เด้งกำแพง $n ครั้ง';
  }

  @override
  String get fxBounceTop => '…และขอบบน';

  @override
  String get fxOverdrive => 'ยิงได้แม้พลังงานติดลบ';

  @override
  String get fxReactor => 'อาวุธเกินความจุยังยิงได้ช้าๆ';

  @override
  String fxGenPower(String x) {
    return 'ชาร์จเครื่องกำเนิด ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'ความจุเครื่องกำเนิด ×$x';
  }

  @override
  String get fxSurge => 'เครื่องกำเนิดเต็ม: กระสุน ×2';

  @override
  String fxSiphon(int pct) {
    return 'การฆ่าเติมพลังงาน $pct %';
  }

  @override
  String fxHp(String x) {
    return 'ตัวเรือ ×$x';
  }

  @override
  String fxShield(String x) {
    return 'โล่ ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'ฟื้นโล่ ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'การฆ่าฟื้น $n HP';
  }

  @override
  String get fxMagnet => 'ดูดไอเทม';

  @override
  String get fxMagnetAll => 'ดูดไอเทมทั้งหมด';

  @override
  String fxReflect(int pct) {
    return '$pct % ของกระสุนเด้งกลับจากโล่';
  }

  @override
  String get fxReflectGuided => 'กระสุนสะท้อนนำวิถี';

  @override
  String fxGhost(String sec) {
    return 'อมตะ $sec วินาทีหลังตัวเรือโดน';
  }

  @override
  String get fxNova => 'โล่แตก: ระเบิดทั้งจอ';

  @override
  String fxAgility(String x) {
    return 'ความคล่อง ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'พื้นที่โดน ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'เครดิต ×$x';
  }

  @override
  String fxScore(String x) {
    return 'คะแนน ×$x';
  }

  @override
  String get fxSatellite => 'มีโดรนรบบินตาม';

  @override
  String get fxTimewarp => 'ตัวเรือโดนแล้วเวลาช้าลง';

  @override
  String get fxGambler => 'ทุกนัดเป็นอาวุธสุ่ม';

  @override
  String get vaultAll => 'ทั้งหมด';
}
