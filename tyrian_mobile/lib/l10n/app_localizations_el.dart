// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ΑΚΥΡΟ';

  @override
  String get connect => 'ΣΥΝΔΕΣΗ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Δεν ήταν δυνατή η σύνδεση με $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Ο οικοδεσπότης ήταν ορατός, αλλά η σύνδεση δεν ολοκληρώθηκε.\n\nΤο παιχνίδι κοντά απαιτεί Wi-Fi peer-to-peer, το οποίο το iOS απενεργοποιεί όσο είναι ενεργό το Προσωπικό hotspot — απενεργοποιήστε το hotspot και στις δύο συσκευές και δοκιμάστε ξανά ή συνδέστε και τις δύο στο ίδιο Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Η αποστολή απέτυχε — ο εξοπλισμός και τα κρέντιτ διατηρούνται. Δοκιμάστε ξανά από το Κέντρο Διοίκησης.';

  @override
  String get gameOverEndless =>
      'Ανασυγκρότηση στον Τομέα 1 — ο εξοπλισμός και τα κρέντιτ διατηρούνται';

  @override
  String get waitingForHost => 'Αναμονή για τον οικοδεσπότη...';

  @override
  String get waitingForHostHint =>
      'Το παιχνίδι θα ξεκινήσει όταν ο οικοδεσπότης είναι έτοιμος';

  @override
  String get vesselLost => 'ΤΟ ΣΚΑΦΟΣ ΧΑΘΗΚΕ';

  @override
  String scoreValue(String score) {
    return 'Σκορ: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Κρέντιτ: $credits';
  }

  @override
  String get creditsPrefix => 'Κρέντιτ: ';

  @override
  String get leaderboard => 'ΚΑΤΑΤΑΞΗ';

  @override
  String get achievements => 'ΕΠΙΤΕΥΓΜΑΤΑ';

  @override
  String get redeploy => 'ΞΑΝΑ ΣΤΗ ΜΑΧΗ';

  @override
  String get resume => 'ΣΥΝΕΧΕΙΑ';

  @override
  String get pause => 'ΠΑΥΣΗ';

  @override
  String get paused => 'ΣΕ ΠΑΥΣΗ';

  @override
  String get skins => 'ΕΜΦΑΝΙΣΕΙΣ';

  @override
  String get skin => 'ΕΜΦΑΝΙΣΗ';

  @override
  String get soundOn => 'ΗΧΟΣ: ΝΑΙ';

  @override
  String get soundOff => 'ΗΧΟΣ: ΟΧΙ';

  @override
  String get musicOn => 'ΜΟΥΣΙΚΗ: ΝΑΙ';

  @override
  String get musicOff => 'ΜΟΥΣΙΚΗ: ΟΧΙ';

  @override
  String get statsOn => 'ΣΤΑΤΙΣΤΙΚΑ: ΝΑΙ';

  @override
  String get statsOff => 'ΣΤΑΤΙΣΤΙΚΑ: ΟΧΙ';

  @override
  String get mainMenu => 'ΚΥΡΙΟ ΜΕΝΟΥ';

  @override
  String get quitToDesktop => 'ΕΞΟΔΟΣ ΣΤΗΝ ΕΠΙΦΑΝΕΙΑ ΕΡΓΑΣΙΑΣ';

  @override
  String get selectSkin => 'ΕΠΙΛΟΓΗ ΕΜΦΑΝΙΣΗΣ';

  @override
  String get difficulty => 'ΔΥΣΚΟΛΙΑ';

  @override
  String get difficultyEasy => 'ΕΥΚΟΛΟ';

  @override
  String get difficultyNormal => 'ΚΑΝΟΝΙΚΟ';

  @override
  String get difficultyHard => 'ΔΥΣΚΟΛΟ';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'ΕΚΣΤΡΑΤΕΙΑ';

  @override
  String get quit => 'ΕΞΟΔΟΣ';

  @override
  String get restorePurchases => 'ΕΠΑΝΑΦΟΡΑ ΑΓΟΡΩΝ';

  @override
  String get locked => 'ΚΛΕΙΔΩΜΕΝΟ';

  @override
  String get mainMenuTooltip => 'Κύριο μενού';

  @override
  String nodeLevel(int level) {
    return 'ΕΠΙΠΕΔΟ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'ΕΠΙΠΕΔΟ $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Κλειδωμένο. Ολοκληρώστε πρώτα τον προηγούμενο κόμβο.';

  @override
  String get flyAgain => 'ΠΕΤΑΞΕ ΞΑΝΑ';

  @override
  String get launch => 'ΑΠΟΓΕΙΩΣΗ';

  @override
  String zoneLabel(int zone) {
    return 'ΖΩΝΗ $zone';
  }

  @override
  String get objectiveStar => 'ΑΣΤΕΡΙ';

  @override
  String get continueButton => 'ΣΥΝΕΧΕΙΑ';

  @override
  String get replayNode => 'ΕΠΑΝΑΛΗΨΗ ΚΟΜΒΟΥ';

  @override
  String get retry => 'ΞΑΝΑ';

  @override
  String get nodeCleared => 'Ο ΚΟΜΒΟΣ ΟΛΟΚΛΗΡΩΘΗΚΕ';

  @override
  String get nodeFailed => 'Ο ΚΟΜΒΟΣ ΑΠΕΤΥΧΕ';

  @override
  String get weaponTierUnlocked => 'ΞΕΚΛΕΙΔΩΘΗΚΕ ΝΕΟ ΕΠΙΠΕΔΟ ΟΠΛΩΝ';

  @override
  String get onSaleInComCenter => 'Διαθέσιμο στο Κέντρο Διοίκησης.';

  @override
  String get requiredTasksHint =>
      'Οι υποχρεωτικές αποστολές κρίνουν τον κόμβο. Πετάξτε ξανά — ό,τι κερδίσατε μένει δικό σας.';

  @override
  String get objClear => 'Καθαρίστε τον τομέα';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Καταρρίψτε $count εχθρούς',
      one: 'Καταρρίψτε 1 εχθρό',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Μην πάθετε ζημιά στο κύτος';

  @override
  String objHull(int percent) {
    return 'Τελειώστε με κύτος πάνω από $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εξοντώστε $count με το $weapon',
      one: 'Εξοντώστε 1 με το $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εξοντώστε $count με τα πλαϊνά πυροβόλα',
      one: 'Εξοντώστε 1 με τα πλαϊνά πυροβόλα',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Απογειωθείτε με το $weapon μπροστά';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Απογειωθείτε με το $weapon σε πλαϊνή βάση';
  }

  @override
  String get objBuySideGun => 'Αγοράστε πλαϊνό πυροβόλο στο Κέντρο Διοίκησης';

  @override
  String objUpgradeGenerator(int level) {
    return 'Αναβαθμίστε τη γεννήτρια στο επίπεδο $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Αναβαθμίστε το εμπρός πυροβόλο στο επίπεδο $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Αναβαθμίστε ένα πλαϊνό πυροβόλο στο επίπεδο $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Μαζέψτε $count μπόνους',
      one: 'Μαζέψτε 1 μπόνους',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εξαλείψτε $count ολόκληρους σχηματισμούς',
      one: 'Εξαλείψτε 1 ολόκληρο σχηματισμό',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Μην εμβολίσετε κανέναν αστεροειδή';

  @override
  String objUnderTime(int seconds) {
    return 'Τελειώστε μέσα σε $seconds δ';
  }

  @override
  String get objStripBoss =>
      'Καταστρέψτε κάθε μέρος του boss πριν από τον πυρήνα';

  @override
  String get joinCoopTitle => 'Συμμετοχή σε co-op';

  @override
  String get cannotSearchNetwork =>
      'Δεν είναι δυνατή η αναζήτηση σε αυτό το δίκτυο';

  @override
  String get joinHintNearby =>
      'Το ίδιο Wi-Fi λειτουργεί σε κάθε συσκευή. iPhone, iPad και Mac βρίσκουν το ένα το άλλο κοντά και χωρίς αυτό — με το Προσωπικό hotspot κλειστό και στα δύο.';

  @override
  String get joinHintWifi =>
      'Και οι δύο παίκτες πρέπει να είναι στο ίδιο Wi-Fi — λειτουργεί και το Προσωπικό hotspot.';

  @override
  String noHostsYet(String hint) {
    return 'Δεν υπάρχουν ακόμη οικοδεσπότες. $hint';
  }

  @override
  String get lookingForHosts =>
      'Αναζήτηση οικοδεσποτών σε αυτό το Wi-Fi και κοντά…';

  @override
  String get hostNearby => 'Κοντά · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · ίδιο Wi-Fi';
  }

  @override
  String get enterIpManually => 'Εισαγωγή IP χειροκίνητα';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ΑΣΠ';

  @override
  String get hudPower => 'ΕΝ';

  @override
  String get hudGen => 'ΓΕΝ';

  @override
  String bossShielded(String name) {
    return '$name — ΜΕ ΑΣΠΙΔΑ';
  }

  @override
  String get bossPartTurret => 'Πυργίσκος';

  @override
  String get bossPartShieldPod => 'Μονάδα ασπίδας';

  @override
  String get bossPartThruster => 'Προωθητήρας';

  @override
  String get bossPartCannon => 'Κανόνι';

  @override
  String sectorUnknownSpace(int level) {
    return 'Τομέας $level — Άγνωστο διάστημα';
  }

  @override
  String get player2Joined => 'Ο παίκτης 2 μπήκε!';

  @override
  String get player2Disconnected => 'Ο παίκτης 2 αποσυνδέθηκε';

  @override
  String get hostDisconnected => 'Ο οικοδεσπότης αποσυνδέθηκε';

  @override
  String maxLevelSold(String amount) {
    return 'Μέγ. επίπεδο! Πουλήθηκε για \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Ξεκλειδώθηκε επίπεδο όπλων $tier';
  }

  @override
  String get cheatsEnabled => 'Κόλπα ενεργά';

  @override
  String get cheatsDisabled => 'Κόλπα ανενεργά';

  @override
  String get cheatsMaxed => 'ΚΟΛΠΟ: μέγιστα κρέντιτ, όλα τα όπλα ξεκλείδωτα';

  @override
  String get cheats => 'ΚΟΛΠΑ';

  @override
  String get maxCredits => 'ΜΕΓ. ΚΡΕΝΤΙΤ';

  @override
  String get sectionStats => 'ΣΤΑΤΙΣΤΙΚΑ';

  @override
  String get sectionLoadout => 'ΕΞΟΠΛΙΣΜΟΣ';

  @override
  String levelShort(int level) {
    return 'Επ.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'ΑΝΑΒ';

  @override
  String get sell => 'ΠΩΛΗΣΗ';

  @override
  String get buy => 'ΑΓΟΡΑ';

  @override
  String get commandCenter => 'ΚΕΝΤΡΟ ΔΙΟΙΚΗΣΗΣ';

  @override
  String get pilot => 'Πιλότος';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'ΣΚΟΡ';

  @override
  String get nextWeapon => 'ΕΠΟΜΕΝΟ ΟΠΛΟ';

  @override
  String pointsValue(String points) {
    return '$points πόντ.';
  }

  @override
  String get slotFront => 'Εμπρός';

  @override
  String get slotLeft => 'Αριστερά';

  @override
  String get slotRight => 'Δεξιά';

  @override
  String get slotGen => 'Γεν';

  @override
  String get power => 'ΕΝ';

  @override
  String get launchMission => 'ΕΚΚΙΝΗΣΗ ΑΠΟΣΤΟΛΗΣ';

  @override
  String get startMission => 'ΕΝΑΡΞΗ ΑΠΟΣΤΟΛΗΣ';

  @override
  String get continueMission => 'ΣΥΝΕΧΙΣΗ ΑΠΟΣΤΟΛΗΣ';

  @override
  String get padControlsHint =>
      '[↑↓] Σειρά   [←→] Επιλογή   [B] Αγορά/Αναβάθμιση/Αλλαγή   [X/Y] Πώληση   [OPTIONS] Συνέχιση αποστολής';

  @override
  String get host => 'ΦΙΛΟΞΕΝΙΑ';

  @override
  String hostingAs(String name) {
    return 'ΟΙΚΟΔΕΣΠΟΤΗΣ ως $name';
  }

  @override
  String get join => 'ΣΥΜΜΕΤΟΧΗ';

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
  String get overload => 'ΥΠΕΡΦΟΡΤΩΣΗ';

  @override
  String weaponOff(String weapon) {
    return '$weapon ΕΚΤΟΣ — αδύναμη γεννήτρια';
  }

  @override
  String unlocksAt(String points) {
    return 'Ξεκλειδώνει στους $points πόντους';
  }

  @override
  String joinConnecting(String target) {
    return 'Σύνδεση με $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Ο οικοδεσπότης δεν απάντησε: $reason.\n\nΚαι οι δύο παίκτες πρέπει να είναι στο ίδιο Wi-Fi (λειτουργεί και το Προσωπικό hotspot) και ο οικοδεσπότης πρέπει να έχει πατήσει ΦΙΛΟΞΕΝΙΑ. Ελέγξτε τη διεύθυνση και δοκιμάστε ξανά.';
  }

  @override
  String get lanJoinNoAnswer => 'καμία απάντηση';

  @override
  String objBossUnder(int seconds) {
    return 'Καταστρέψτε τον πυρήνα του boss μέσα σε $seconds δ από την άφιξή του';
  }

  @override
  String get sectionHangar => 'ΥΠΟΣΤΕΓΟ';

  @override
  String get sectionVault => 'ΘΗΣΑΥΡΟΦΥΛΑΚΙΟ';

  @override
  String get rackSide => 'Πλαϊνό';

  @override
  String get rackHull => 'Κύτος';

  @override
  String get rarityCommon => 'ΚΟΙΝΟ';

  @override
  String get rarityRare => 'ΣΠΑΝΙΟ';

  @override
  String get rarityMythic => 'ΜΥΘΙΚΟ';

  @override
  String get curse => 'ΚΑΤΑΡΑ';

  @override
  String get modFit => 'ΤΟΠΟΘΕΤΗΣΗ';

  @override
  String get modUnfit => 'ΑΦΑΙΡΕΣΗ';

  @override
  String get modForge => 'ΣΙΔΗΡΟΥΡΓΕΙΟ';

  @override
  String get forgeHint =>
      'Διαλέξτε 3 ίδιας σπανιότητας για να σφυρηλατήσετε 1 της επόμενης';

  @override
  String get vaultEmpty =>
      'Δεν υπάρχουν ακόμη mod. Ολοκληρώστε έναν κόμβο με όλα τα αστέρια, νικήστε γρήγορα ένα boss ή καταρρίψτε ένα boss στην ατελείωτη λειτουργία.';

  @override
  String modNeeds(String families) {
    return 'Λειτουργεί με $families';
  }

  @override
  String get modRackFull => 'Η βάση είναι γεμάτη';

  @override
  String get modAlreadyFitted => 'Ήδη τοποθετημένο';

  @override
  String get modWrongRack => 'Δεν ταιριάζει σε αυτή τη βάση';

  @override
  String modsSpilled(int n) {
    return '$n mod επέστρεψαν στο θησαυροφυλάκιο';
  }

  @override
  String get hullLocked => 'Κλειδωμένο';

  @override
  String hullUnlockBoss(int n) {
    return 'Νικήστε το boss εκστρατείας $n';
  }

  @override
  String get hullUnlockFinish =>
      'Ολοκληρώστε την εκστρατεία ή φτάστε στον τομέα 30';

  @override
  String get statAgility => 'ΕΥΚ';

  @override
  String get statHitbox => 'ΣΤΟΧ';

  @override
  String get perkNone => 'Βασικό σκάφος';

  @override
  String get perkAfterimage => 'Μείνετε ακίνητοι: βολές ×1,5';

  @override
  String get perkBulwark => 'Η ζημιά πέρα από την ασπίδα μειώνεται στο μισό';

  @override
  String get perkOverclock => 'Πυροβολεί έως 130 % της χωρητικότητας, πιο αργά';

  @override
  String get perkBattery => 'Ένα δωρεάν μαχητικό drone σας συνοδεύει';

  @override
  String get rewardTitle => 'ΑΝΤΑΜΟΙΒΗ';

  @override
  String newHull(String name) {
    return 'Νέο κύτος: $name';
  }

  @override
  String get socketEmpty => 'κενό';

  @override
  String fxStreams(int n) {
    return '$n παράλληλες δέσμες';
  }

  @override
  String fxFan(int n) {
    return 'Βεντάλια $n βολών';
  }

  @override
  String fxSalvo(int n) {
    return 'Ομοβροντία $n βολών';
  }

  @override
  String fxFireRate(String x) {
    return 'Ρυθμός βολής ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Ζημιά ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Ταχύτητα βολών ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Μέγεθος βολών ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Κατανάλωση ενέργειας ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Αυτοκαθοδήγηση +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Διαπερνά $n στόχους';
  }

  @override
  String get fxPierceAll => 'Διαπερνά τα πάντα';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % πιθανότητα για ζημιά ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Κρίσιμα ×$x σε boss';
  }

  @override
  String fxFork(int n) {
    return 'Οι καταρρίψεις σκορπίζουν $n βολές';
  }

  @override
  String get fxChain => 'Οι σκόρπιες βολές σκορπίζουν ξανά';

  @override
  String get fxSplit => 'Χωρίζεται στα δύο όταν πετύχει';

  @override
  String get fxFrost => 'Τα χτυπήματα επιβραδύνουν τους εχθρούς';

  @override
  String get fxCrossfire => 'Τα πλαϊνά πυροβόλα στοχεύουν προς τα μέσα';

  @override
  String get fxRearguard => 'Τα πλαϊνά πυροβόλα ρίχνουν και προς τα πίσω';

  @override
  String get fxOrbit => 'Οι βολές κάνουν ζιγκ-ζαγκ';

  @override
  String fxBounce(int n) {
    return 'Αναπηδά στους τοίχους $n×';
  }

  @override
  String get fxBounceTop => '…και στην κορυφή';

  @override
  String get fxOverdrive => 'Πυροβολεί με χρέος ενέργειας';

  @override
  String get fxReactor =>
      'Τα όπλα πάνω από τη χωρητικότητα ρίχνουν ακόμα, αργά';

  @override
  String fxGenPower(String x) {
    return 'Επαναφόρτιση γεννήτριας ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Χωρητικότητα γεννήτριας ×$x';
  }

  @override
  String get fxSurge => 'Γεμάτη γεννήτρια: βολές ×2';

  @override
  String fxSiphon(int pct) {
    return 'Οι καταρρίψεις αναπληρώνουν $pct % ενέργεια';
  }

  @override
  String fxHp(String x) {
    return 'Κύτος ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Ασπίδα ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Ανάκτηση ασπίδας ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Οι καταρρίψεις θεραπεύουν $n HP';
  }

  @override
  String get fxMagnet => 'Έλκει τα μπόνους';

  @override
  String get fxMagnetAll => 'Έλκει κάθε μπόνους';

  @override
  String fxReflect(int pct) {
    return '$pct % των βολών αναπηδούν από την ασπίδα';
  }

  @override
  String get fxReflectGuided => 'Οι ανακλώμενες βολές αυτοκαθοδηγούνται';

  @override
  String fxGhost(String sec) {
    return 'Άτρωτο για $sec δ μετά από χτύπημα στο κύτος';
  }

  @override
  String get fxNova => 'Σπάει η ασπίδα: έκρηξη σε όλη την οθόνη';

  @override
  String fxAgility(String x) {
    return 'Ευκινησία ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Ζώνη πρόσκρουσης ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Κρέντιτ ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Σκορ ×$x';
  }

  @override
  String get fxSatellite => 'Ένα μαχητικό drone σας συνοδεύει';

  @override
  String get fxTimewarp => 'Ένα χτύπημα στο κύτος επιβραδύνει τον χρόνο';

  @override
  String get fxGambler => 'Κάθε βολή είναι τυχαίο όπλο';

  @override
  String get vaultAll => 'ΟΛΑ';

  @override
  String get sigilMissUnknown => 'άγνωστο σχήμα';

  @override
  String get sigilMissTooSlow => 'πολύ αργά';

  @override
  String get sigilMissSkippedDot => 'παραλείφθηκε σημείο';

  @override
  String get sigilMissLeftRimEarly => 'άφησες πολύ νωρίς';

  @override
  String get sigilMissWrongDirection => 'σχεδιάστηκε ανάποδα';

  @override
  String get sigilMissWrongLayer => 'λάθος πλαϊνό κουμπί';

  @override
  String get sigilDry => 'ανεπαρκής φόρτιση';

  @override
  String get sigilBusy => 'το προηγούμενο τρέχει ακόμα';

  @override
  String get arena => 'ΑΡΕΝΑ';

  @override
  String get arenaBossParts => 'ΜΕΡΗ BOSS';

  @override
  String get arenaBareCore => 'γυμνός πυρήνας';

  @override
  String get arenaCompanions => 'ΣΥΝΤΡΟΦΟΙ';

  @override
  String get arenaCharge => 'ΦΟΡΤΙΣΗ';

  @override
  String get arenaChargeNormal => 'ΚΑΝΟΝΙΚΗ';

  @override
  String get arenaSpeed => 'ΤΑΧΥΤΗΤΑ ΚΟΣΜΟΥ';

  @override
  String get arenaDrill => 'ΑΣΚΗΣΗ';

  @override
  String get arenaFreePlay => 'ΕΛΕΥΘΕΡΟ ΠΑΙΧΝΙΔΙ';

  @override
  String get arenaFight => 'ΜΑΧΗ';

  @override
  String get arenaNewBoss => 'ΝΕΟ BOSS';

  @override
  String get arenaLeave => 'ΕΞΟΔΟΣ ΑΠΟ ΑΡΕΝΑ';

  @override
  String get arenaHint =>
      'Το boss επιστρέφει μόλις πεθάνει. Τίποτα δεν αποθηκεύεται εδώ.';

  @override
  String get arenaColCast => 'ΡΙΨΕΙΣ';

  @override
  String get arenaColMiss => 'ΑΣΤΟΧ.';

  @override
  String get arenaColAvg => 'Μ.Ο.';

  @override
  String get arenaColBest => 'ΚΑΛΥΤΕΡΟ';

  @override
  String get arenaColTime => 'ΤΑΧΥΤΕΡΟ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Boss $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: ΣΦΡΑΓΙΔΕΣ';

  @override
  String get padSchemeClassic => 'PAD: ΚΛΑΣΙΚΟ';

  @override
  String get padSouthpawOn => 'ΑΡΙΣΤΕΡΟΧΕΙΡΑΣ: ΝΑΙ';

  @override
  String get padSouthpawOff => 'ΑΡΙΣΤΕΡΟΧΕΙΡΑΣ: ΟΧΙ';

  @override
  String get sigilDescHop => 'Γρήγορο άλμα προς την κατεύθυνση της κίνησης';

  @override
  String get sigilDescSidestep => 'Μεγάλο πλευρικό βήμα στο πεδίο';

  @override
  String get sigilDescStrike => 'Εφόρμηση με τρεις βαριές βολές και επιστροφή';

  @override
  String get sigilDescRetreat => 'Υποχώρηση με πυρά κάλυψης προς τα εμπρός';

  @override
  String get sigilDescDash =>
      'Διαγώνια εφόρμηση μέσα από πυρά, άτρωτο στη μέση';

  @override
  String get sigilDescRoll => 'Περιστροφή στο πλάι, άτρωτο';

  @override
  String get sigilDescShadow =>
      'Κλείδωσε κάτω από τον πλησιέστερο εχθρό και πυροβόλα';

  @override
  String get sigilDescEcho =>
      'Μια σκιά επαναλαμβάνει τα 2 τελευταία δευτερόλεπτα με μισή ζημιά';

  @override
  String get sigilDescLoop => 'Λούπα από πάνω: οι βολές περνούν από κάτω σου';

  @override
  String get sigilDescSlalom => 'Καμπύλη S στο πεδίο με βεντάλια πυρών';

  @override
  String get sigilDescCorkscrew => 'Τιρμπουσόν μπροστά με πυρά παντού, άτρωτο';

  @override
  String get sigilDescSnapshot =>
      'Μία βαριά βολή προς την κατεύθυνση της κίνησης';

  @override
  String get sigilDescBroadside => 'Ομοβροντία και από τα δύο πλευρά';

  @override
  String get sigilDescVolley => 'Πέντε φορτισμένες ακτίνες μπροστά';

  @override
  String get sigilDescCaltrop =>
      'Ρίξε νάρκη που καταπίνει βολές και εκρήγνυται';

  @override
  String get sigilDescFrenzy =>
      'Τα όπλα πυροβολούν ταχύτερα για λίγα δευτερόλεπτα';

  @override
  String get sigilDescStasis => 'Εχθροί και βολές τους στη μισή ταχύτητα';

  @override
  String get sigilDescHalo =>
      'Η ασπίδα φορτίζει 4 φορές ταχύτερα και τίποτα δεν περνά';

  @override
  String get sigilDescRadial => 'Δαχτυλίδι δεκαέξι βολών';

  @override
  String get sigilDescStorm => 'Όλα τα όπλα στο φουλ, δωρεάν';

  @override
  String get sigilDescPing => 'Οι σύντροφοι εστιάζουν πυρά όπου δείχνεις';

  @override
  String get sigilDescWingman =>
      'Κάλεσε συνοδό στο πλευρό προς το οποίο σχεδίασες';

  @override
  String get sigilDescHunter =>
      'Κάλεσε κυνηγό που πετά μπροστά και διαλέγει στόχους';

  @override
  String get sigilDescWarden => 'Κάλεσε φύλακα που δέχεται τις βολές για σένα';

  @override
  String get sigilDescFormation =>
      'Οι σύντροφοι αλλάζουν μεταξύ φαρδιάς και σφήνας';

  @override
  String get sigilDescWhirl =>
      'Οι σύντροφοι κάνουν κύκλους γύρω σου και τρώνε βολές';

  @override
  String get sigilDescSacrifice =>
      'Οι σύντροφοι βουτούν και εκρήγνυνται, επιστρέφοντας φόρτιση';

  @override
  String get grimoire => 'ΓΚΡΙΜΟΥΑΡ';

  @override
  String get grimoireHint =>
      'Σχεδίασε με το δεξί stick. LB για ΟΠΛΑ, RB για ΠΤΕΡΥΓΑ, και τα δύο για MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'κόστος $cost';
  }

  @override
  String get sigilUntouchable => 'άτρωτο';

  @override
  String get lessonWatch => 'ΔΕΣ';

  @override
  String get lessonTrace => 'ΑΚΟΛΟΥΘΗΣΕ';

  @override
  String get lessonSlow => 'ΑΡΓΑ';

  @override
  String get lessonLive => 'ΠΛΗΡΗΣ ΤΑΧΥΤΗΤΑ';

  @override
  String get lessonStreak => 'ΠΕΝΤΕ ΣΤΗ ΣΕΙΡΑ';

  @override
  String get lessonLearned => 'ΕΜΑΘΕΣ';

  @override
  String lessonTempo(int pct) {
    return 'ΤΕΜΠΟ $pct %';
  }

  @override
  String get hintHop => 'Τίναξε το δεξί stick';

  @override
  String get hintLoop => 'Σχεδίασε κύκλο: πετάς πάνω από τις βολές';

  @override
  String get hintStream => 'Πάτα LT: δύο ή τρεις ριπές';

  @override
  String get arenaKata => 'ΚΑΤΑ';

  @override
  String get arenaKataOff => 'ΚΑΜΙΑ';

  @override
  String kataNext(String sigil, String secs) {
    return 'επόμενο $sigil σε $secs s';
  }

  @override
  String get arenaGauntlet => 'ΔΟΚΙΜΑΣΙΑ';

  @override
  String get arenaOn => 'ΝΑΙ';

  @override
  String get arenaOff => 'ΟΧΙ';

  @override
  String gauntletRating(int rating, int best) {
    return 'Βαθμός $rating · καλύτερο $best';
  }

  @override
  String get duelWarning => 'ΠΡΟΣΟΧΗ';

  @override
  String get duelHintPad1 => 'Το δεξί stick σημαδεύει και πυροβολεί';

  @override
  String get duelHintPad2Rt =>
      'Κράτα RT, LB ή RB: το δεξί stick σχεδιάζει σφραγίδες';

  @override
  String get duelHintPad2Lt =>
      'Κράτα LT, LB ή RB: το δεξί stick σχεδιάζει σφραγίδες';

  @override
  String get duelHintClassic =>
      'Αριστερό stick πετά · B, RB ή RT πυροβολούν όπου δείχνει η μύτη';

  @override
  String get duelHintKeys1 => 'Βέλη σημαδεύουν και πυροβολούν · WASD πετά';

  @override
  String get duelHintKeys2 =>
      'Space πυροβολεί όπου δείχνει η μύτη · numpad σχεδιάζει';

  @override
  String get arenaDuelBinding => 'ΣΤΑΣΗ ΜΟΝΟΜΑΧΙΑΣ';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'ΕΜΠΡΟΣ ΤΟΥ PAD';

  @override
  String get duelFrameNose => 'Η ΜΥΤΗ';

  @override
  String get duelFrameUp => 'ΠΑΝΩ';

  @override
  String get arenaDuelAimFires => 'ΣΚΟΠΕΥΣΗ = ΒΟΛΗ';

  @override
  String get duelCutInFirst => 'ΚΟΝΤΙΝΟ BOSS: ΠΡΩΤΗ ΦΟΡΑ';

  @override
  String get duelCutInAlways => 'ΚΟΝΤΙΝΟ BOSS: ΠΑΝΤΑ';

  @override
  String get duelCutInNever => 'ΚΟΝΤΙΝΟ BOSS: ΠΟΤΕ';

  @override
  String get arenaDuelDrill => 'ΑΣΚΗΣΗ ΜΟΝΟΜΑΧΙΑΣ';

  @override
  String get duelDrillOff => 'ΚΑΜΙΑ';

  @override
  String get duelDrillAim => 'ΣΗΜΑΔΕΨΕ ΚΑΙ ΡΙΞΕ';

  @override
  String get duelDrillAimHow => 'Στρέψε το δεξί stick στο boss και χτύπα το';

  @override
  String get duelDrillHold => 'ΚΡΑΤΑ ΤΗ ΜΥΤΗ';

  @override
  String get duelDrillHoldHow =>
      'Κράτα κουμπί στάσης και πέτα: η μύτη μένει σταθερή';

  @override
  String get duelDrillDraw => 'ΣΧΕΔΙΑΣΕ ΜΠΡΟΣΤΑ';

  @override
  String get duelDrillDrawHow => 'Στη στάση, σχεδίασε σφραγίδα προς το boss';

  @override
  String get duelDrillTurn => 'ΓΥΡΝΑ';

  @override
  String get duelDrillTurnHow =>
      'Το boss είναι από κάτω: γύρνα τη μύτη και χτύπα το';

  @override
  String get duelDrillDone => 'ΤΕΛΟΣ';
}
