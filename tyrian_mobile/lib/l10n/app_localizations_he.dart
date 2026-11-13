// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get ok => 'אישור';

  @override
  String get cancel => 'ביטול';

  @override
  String get connect => 'התחברות';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'לא ניתן להתחבר אל $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'המארח היה גלוי, אבל החיבור לא הוקם.\n\nמשחק בקרבת מקום דורש Wi-Fi עמית לעמית, ש-iOS מכבה כל עוד נקודה חמה אישית פעילה — כבו את הנקודה החמה בשני המכשירים ונסו שוב, או חברו את שני המכשירים לאותה רשת Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'המשימה נכשלה — הציוד והקרדיטים נשמרו. נסו שוב ממרכז הפיקוד.';

  @override
  String get gameOverEndless => 'בנייה מחדש בגזרה 1 — הציוד והקרדיטים נשמרו';

  @override
  String get waitingForHost => 'ממתינים למארח...';

  @override
  String get waitingForHostHint => 'המשחק יתחיל כשהמארח יהיה מוכן';

  @override
  String get vesselLost => 'הספינה אבדה';

  @override
  String scoreValue(String score) {
    return 'ניקוד: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'קרדיטים: $credits';
  }

  @override
  String get creditsPrefix => 'קרדיטים: ';

  @override
  String get leaderboard => 'טבלת מובילים';

  @override
  String get achievements => 'הישגים';

  @override
  String get redeploy => 'בחזרה לקרב';

  @override
  String get resume => 'המשך';

  @override
  String get pause => 'השהיה';

  @override
  String get paused => 'מושהה';

  @override
  String get skins => 'סקינים';

  @override
  String get skin => 'סקין';

  @override
  String get soundOn => 'צליל: מופעל';

  @override
  String get soundOff => 'צליל: כבוי';

  @override
  String get musicOn => 'מוזיקה: מופעלת';

  @override
  String get musicOff => 'מוזיקה: כבויה';

  @override
  String get mainMenu => 'תפריט ראשי';

  @override
  String get quitToDesktop => 'יציאה לשולחן העבודה';

  @override
  String get selectSkin => 'בחירת סקין';

  @override
  String get difficulty => 'רמת קושי';

  @override
  String get difficultyEasy => 'קל';

  @override
  String get difficultyNormal => 'רגיל';

  @override
  String get difficultyHard => 'קשה';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'מערכה';

  @override
  String get quit => 'יציאה';

  @override
  String get restorePurchases => 'שחזור רכישות';

  @override
  String get locked => 'נעול';

  @override
  String get mainMenuTooltip => 'תפריט ראשי';

  @override
  String nodeLevel(int level) {
    return 'שלב $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'שלב $level · בוס $ordinal';
  }

  @override
  String get nodeLockedHint => 'נעול. השלימו קודם את הצומת הקודם.';

  @override
  String get flyAgain => 'טיסה חוזרת';

  @override
  String get launch => 'המראה';

  @override
  String zoneLabel(int zone) {
    return 'אזור $zone';
  }

  @override
  String get objectiveStar => 'כוכב';

  @override
  String get continueButton => 'המשך';

  @override
  String get replayNode => 'שחקו שוב את הצומת';

  @override
  String get retry => 'ניסיון חוזר';

  @override
  String get nodeCleared => 'הצומת הושלם';

  @override
  String get nodeFailed => 'הצומת נכשל';

  @override
  String get weaponTierUnlocked => 'דרגת נשק חדשה נפתחה';

  @override
  String get onSaleInComCenter => 'למכירה במרכז הפיקוד.';

  @override
  String get requiredTasksHint =>
      'משימות החובה מכריעות את הצומת. טוסו שוב — מה שהרווחתם נשאר אצלכם.';

  @override
  String get objClear => 'טהרו את הגזרה';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'הפילו $count אויבים',
      two: 'הפילו $count אויבים',
      one: 'הפילו אויב אחד',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'אל תספגו נזק לגוף הספינה';

  @override
  String objHull(int percent) {
    return 'סיימו עם גוף ספינה מעל $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השמידו $count עם $weapon',
      two: 'השמידו $count עם $weapon',
      one: 'השמידו אחד עם $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'השמידו $count עם התותחים הצדדיים',
      two: 'השמידו $count עם התותחים הצדדיים',
      one: 'השמידו אחד עם התותחים הצדדיים',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'המריאו עם $weapon מקדימה';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'המריאו עם $weapon בתושבת צד';
  }

  @override
  String get objBuySideGun => 'קנו תותח צד במרכז הפיקוד';

  @override
  String objUpgradeGenerator(int level) {
    return 'שדרגו את הגנרטור לרמה $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'שדרגו את התותח הקדמי לרמה $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'שדרגו תותח צד לרמה $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'אספו $count בונוסים',
      two: 'אספו $count בונוסים',
      one: 'אספו בונוס אחד',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'חסלו $count מבנים שלמים',
      two: 'חסלו $count מבנים שלמים',
      one: 'חסלו מבנה שלם אחד',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'אל תתנגשו באף אסטרואיד';

  @override
  String objUnderTime(int seconds) {
    return 'סיימו בתוך $seconds שנ׳';
  }

  @override
  String get objStripBoss => 'השמידו כל חלק של הבוס לפני הליבה';

  @override
  String get joinCoopTitle => 'הצטרפות לשיתופי';

  @override
  String get cannotSearchNetwork => 'לא ניתן לחפש ברשת זו';

  @override
  String get joinHintNearby =>
      'אותה רשת Wi-Fi עובדת בכל מכשיר. iPhone,‏ iPad ו-Mac מוצאים זה את זה בקרבת מקום גם בלעדיה — כשהנקודה החמה האישית כבויה בשניהם.';

  @override
  String get joinHintWifi =>
      'שני השחקנים חייבים להיות באותה רשת Wi-Fi — גם נקודה חמה אישית מתאימה.';

  @override
  String noHostsYet(String hint) {
    return 'עדיין אין מארחים. $hint';
  }

  @override
  String get lookingForHosts => 'מחפשים מארחים ב-Wi-Fi הזה ובקרבת מקום…';

  @override
  String get hostNearby => 'בקרבת מקום · Bluetooth / Wi-Fi עמית לעמית';

  @override
  String hostSameWifi(String address) {
    return '$address · אותה רשת Wi-Fi';
  }

  @override
  String get enterIpManually => 'הזנת IP ידנית';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'מגן';

  @override
  String get hudPower => 'אנר';

  @override
  String get hudGen => 'גנר';

  @override
  String bossShielded(String name) {
    return '$name — מוגן';
  }

  @override
  String get bossPartTurret => 'צריח';

  @override
  String get bossPartShieldPod => 'תרמיל מגן';

  @override
  String get bossPartThruster => 'מדחף';

  @override
  String get bossPartCannon => 'תותח';

  @override
  String sectorUnknownSpace(int level) {
    return 'גזרה $level — חלל לא ידוע';
  }

  @override
  String get player2Joined => 'שחקן 2 הצטרף!';

  @override
  String get player2Disconnected => 'שחקן 2 התנתק';

  @override
  String get hostDisconnected => 'המארח התנתק';

  @override
  String maxLevelSold(String amount) {
    return 'רמה מרבית! נמכר ב-\$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'דרגת נשק $tier נפתחה';
  }

  @override
  String get cheatsEnabled => 'צ׳יטים מופעלים';

  @override
  String get cheatsDisabled => 'צ׳יטים כבויים';

  @override
  String get cheatsMaxed => 'צ׳יט: קרדיטים במקסימום, כל הנשקים פתוחים';

  @override
  String get cheats => 'צ׳יטים';

  @override
  String get maxCredits => 'קרדיטים מרביים';

  @override
  String get sectionStats => 'נתונים';

  @override
  String get sectionLoadout => 'ציוד';

  @override
  String levelShort(int level) {
    return 'רמה $level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'שדרג';

  @override
  String get sell => 'מכירה';

  @override
  String get buy => 'קנייה';

  @override
  String get commandCenter => 'מרכז הפיקוד';

  @override
  String get pilot => 'טייס';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ניקוד';

  @override
  String get nextWeapon => 'הנשק הבא';

  @override
  String pointsValue(String points) {
    return '$points נק׳';
  }

  @override
  String get slotFront => 'קדמי';

  @override
  String get slotLeft => 'שמאל';

  @override
  String get slotRight => 'ימין';

  @override
  String get slotGen => 'גנר';

  @override
  String get power => 'אנר';

  @override
  String get launchMission => 'שיגור משימה';

  @override
  String get startMission => 'התחלת משימה';

  @override
  String get continueMission => 'המשך משימה';

  @override
  String get padControlsHint =>
      '[↑↓] שורה   [←→] בחירה   [B] קנייה/שדרוג/החלפה   [X/Y] מכירה   [OPTIONS] המשך משימה';

  @override
  String get host => 'אירוח';

  @override
  String hostingAs(String name) {
    return 'מארחים בתור $name';
  }

  @override
  String get join => 'הצטרפות';

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
  String get overload => 'עומס יתר';

  @override
  String weaponOff(String weapon) {
    return '$weapon כבוי — הגנרטור חלש מדי';
  }

  @override
  String unlocksAt(String points) {
    return 'נפתח ב-$points נק׳';
  }

  @override
  String joinConnecting(String target) {
    return 'מתחברים אל $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'המארח לא ענה: $reason.\n\nשני השחקנים צריכים להיות באותה רשת Wi-Fi (גם נקודה חמה אישית מתאימה), והמארח צריך ללחוץ על אירוח. בדקו את הכתובת ונסו שוב.';
  }

  @override
  String get lanJoinNoAnswer => 'אין תשובה';

  @override
  String objBossUnder(int seconds) {
    return 'השמידו את ליבת הבוס בתוך $seconds שנ׳ מהגעתו';
  }

  @override
  String get sectionHangar => 'האנגר';

  @override
  String get sectionVault => 'כספת';

  @override
  String get rackSide => 'צד';

  @override
  String get rackHull => 'גוף';

  @override
  String get rarityCommon => 'נפוץ';

  @override
  String get rarityRare => 'נדיר';

  @override
  String get rarityMythic => 'מיתי';

  @override
  String get curse => 'קללה';

  @override
  String get modFit => 'התקנה';

  @override
  String get modUnfit => 'הסרה';

  @override
  String get modForge => 'נפחייה';

  @override
  String get forgeHint => 'בחרו 3 מאותה נדירות כדי לחשל 1 מהנדירות הבאה';

  @override
  String get vaultEmpty =>
      'אין עדיין מודים. השלימו צומת עם כל הכוכבים, הביסו בוס מהר או הפילו בוס במצב האינסופי.';

  @override
  String modNeeds(String families) {
    return 'עובד עם $families';
  }

  @override
  String get modRackFull => 'המתקן מלא';

  @override
  String get modAlreadyFitted => 'כבר מותקן';

  @override
  String get modWrongRack => 'לא מתאים למתקן הזה';

  @override
  String modsSpilled(int n) {
    return '$n מודים חזרו לכספת';
  }

  @override
  String get hullLocked => 'נעול';

  @override
  String hullUnlockBoss(int n) {
    return 'הביסו את בוס המערכה $n';
  }

  @override
  String get hullUnlockFinish => 'סיימו את המערכה או הגיעו לגזרה 30';

  @override
  String get statAgility => 'זריז';

  @override
  String get statHitbox => 'פגיע';

  @override
  String get perkNone => 'ספינה סטנדרטית';

  @override
  String get perkAfterimage => 'עמדו במקום: יריות ×1.5';

  @override
  String get perkBulwark => 'נזק שעובר את המגן נחצה';

  @override
  String get perkOverclock => 'יורה עד 130 % מהקיבולת, לאט יותר';

  @override
  String get perkBattery => 'רחפן תותח חינמי טס איתכם';

  @override
  String get rewardTitle => 'פרס';

  @override
  String newHull(String name) {
    return 'גוף חדש: $name';
  }

  @override
  String get socketEmpty => 'ריק';

  @override
  String fxStreams(int n) {
    return '$n זרמים מקבילים';
  }

  @override
  String fxFan(int n) {
    return 'מניפה של $n יריות';
  }

  @override
  String fxSalvo(int n) {
    return 'מטח של $n יריות';
  }

  @override
  String fxFireRate(String x) {
    return 'קצב אש ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'נזק ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'מהירות יריות ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'גודל יריות ×$x';
  }

  @override
  String fxPower(String x) {
    return 'צריכת אנרגיה ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'התבייתות +$n';
  }

  @override
  String fxPierce(int n) {
    return 'חודר דרך $n מטרות';
  }

  @override
  String get fxPierceAll => 'חודר דרך הכול';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % סיכוי לנזק ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'קריטיות ×$x על בוסים';
  }

  @override
  String fxFork(int n) {
    return 'הפלות מפזרות $n יריות';
  }

  @override
  String get fxChain => 'יריות מפוזרות מתפזרות שוב';

  @override
  String get fxSplit => 'מתפצל לשניים בפגיעה';

  @override
  String get fxFrost => 'פגיעות מאטות אויבים';

  @override
  String get fxCrossfire => 'התותחים הצדדיים נוטים פנימה';

  @override
  String get fxRearguard => 'התותחים הצדדיים יורים גם אחורה';

  @override
  String get fxOrbit => 'היריות מתפתלות';

  @override
  String fxBounce(int n) {
    return 'ניתר מהקירות $n×';
  }

  @override
  String get fxBounceTop => '…וגם מהחלק העליון';

  @override
  String get fxOverdrive => 'יורה על חשבון חוב אנרגיה';

  @override
  String get fxReactor => 'נשקים מעל הקיבולת עדיין יורים, לאט';

  @override
  String fxGenPower(String x) {
    return 'טעינת גנרטור ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'קיבולת גנרטור ×$x';
  }

  @override
  String get fxSurge => 'גנרטור מלא: יריות ×2';

  @override
  String fxSiphon(int pct) {
    return 'הפלות ממלאות $pct % אנרגיה';
  }

  @override
  String fxHp(String x) {
    return 'גוף ×$x';
  }

  @override
  String fxShield(String x) {
    return 'מגן ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'התחדשות מגן ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'הפלות מרפאות $n HP';
  }

  @override
  String get fxMagnet => 'מושך בונוסים';

  @override
  String get fxMagnetAll => 'מושך כל בונוס';

  @override
  String fxReflect(int pct) {
    return '$pct % מהיריות ניתזות מהמגן בחזרה';
  }

  @override
  String get fxReflectGuided => 'יריות מוחזרות מתבייתות';

  @override
  String fxGhost(String sec) {
    return 'בלתי פגיע $sec שנ׳ אחרי פגיעה בגוף';
  }

  @override
  String get fxNova => 'המגן נשבר: פיצוץ על כל המסך';

  @override
  String fxAgility(String x) {
    return 'זריזות ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'אזור פגיעה ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'קרדיטים ×$x';
  }

  @override
  String fxScore(String x) {
    return 'ניקוד ×$x';
  }

  @override
  String get fxSatellite => 'רחפן תותח טס איתכם';

  @override
  String get fxTimewarp => 'פגיעה בגוף מאטה את הזמן';

  @override
  String get fxGambler => 'כל ירייה היא נשק אקראי';

  @override
  String get vaultAll => 'הכול';
}
