// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get connect => 'VERBINDEN';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Keine Verbindung zu $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Der Host war sichtbar, aber die Verbindung kam nicht zustande.\n\nSpielen in der Nähe braucht Peer-to-Peer-WLAN, das iOS abschaltet, solange ein persönlicher Hotspot aktiv ist. Schalte den Hotspot auf beiden Geräten aus und versuche es erneut, oder verbinde beide Geräte mit demselben WLAN.';

  @override
  String get gameOverCampaign =>
      'Mission gescheitert — Ausrüstung und Credits bleiben erhalten. Versuch es erneut aus dem Kommandozentrum.';

  @override
  String get gameOverEndless =>
      'Neustart in Sektor 1 — Ausrüstung und Credits bleiben erhalten';

  @override
  String get waitingForHost => 'Warte auf Host...';

  @override
  String get waitingForHostHint =>
      'Das Spiel startet, sobald der Host bereit ist';

  @override
  String get vesselLost => 'SCHIFF VERLOREN';

  @override
  String scoreValue(String score) {
    return 'Punkte: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Credits: $credits';
  }

  @override
  String get creditsPrefix => 'Credits: ';

  @override
  String get leaderboard => 'BESTENLISTE';

  @override
  String get achievements => 'ERFOLGE';

  @override
  String get redeploy => 'ERNEUT STARTEN';

  @override
  String get resume => 'WEITER';

  @override
  String get pause => 'PAUSE';

  @override
  String get paused => 'PAUSIERT';

  @override
  String get skins => 'SKINS';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SOUND: AN';

  @override
  String get soundOff => 'SOUND: AUS';

  @override
  String get musicOn => 'MUSIK: AN';

  @override
  String get musicOff => 'MUSIK: AUS';

  @override
  String get mainMenu => 'HAUPTMENÜ';

  @override
  String get quitToDesktop => 'ZUM DESKTOP';

  @override
  String get selectSkin => 'SKIN WÄHLEN';

  @override
  String get difficulty => 'SCHWIERIGKEIT';

  @override
  String get difficultyEasy => 'LEICHT';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'SCHWER';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPAGNE';

  @override
  String get quit => 'BEENDEN';

  @override
  String get restorePurchases => 'KÄUFE WIEDERHERSTELLEN';

  @override
  String get locked => 'GESPERRT';

  @override
  String get mainMenuTooltip => 'Hauptmenü';

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LEVEL $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Gesperrt. Schließe zuerst die vorherige Mission ab.';

  @override
  String get flyAgain => 'ERNEUT FLIEGEN';

  @override
  String get launch => 'STARTEN';

  @override
  String zoneLabel(int zone) {
    return 'ZONE $zone';
  }

  @override
  String get objectiveStar => 'STERN';

  @override
  String get continueButton => 'WEITER';

  @override
  String get replayNode => 'WIEDERHOLEN';

  @override
  String get retry => 'NOCHMAL';

  @override
  String get nodeCleared => 'MISSION ERFÜLLT';

  @override
  String get nodeFailed => 'MISSION GESCHEITERT';

  @override
  String get weaponTierUnlocked => 'NEUE WAFFENSTUFE';

  @override
  String get onSaleInComCenter => 'Jetzt im Kommandozentrum erhältlich.';

  @override
  String get requiredTasksHint =>
      'Die Pflichtaufgaben entscheiden über die Mission. Flieg sie nochmal — was du verdient hast, behältst du.';

  @override
  String get objClear => 'Säubere den Sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Schieße $count Gegner ab',
      one: 'Schieße 1 Gegner ab',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Nimm keinen Hüllenschaden';

  @override
  String objHull(int percent) {
    return 'Beende mit über $percent % Hülle';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Erledige $count Gegner mit $weapon',
      one: 'Erledige 1 Gegner mit $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Erledige $count Gegner mit den Seitenwaffen',
      one: 'Erledige 1 Gegner mit den Seitenwaffen',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Starte mit $weapon vorne';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Starte mit $weapon an einer Seite';
  }

  @override
  String get objBuySideGun => 'Kaufe eine Seitenwaffe im Kommandozentrum';

  @override
  String objUpgradeGenerator(int level) {
    return 'Rüste den Generator auf Stufe $level auf';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Rüste die Frontwaffe auf Stufe $level auf';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Rüste eine Seitenwaffe auf Stufe $level auf';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sammle $count Boni ein',
      one: 'Sammle 1 Bonus ein',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vernichte $count ganze Formationen',
      one: 'Vernichte 1 ganze Formation',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ramme keine Asteroiden';

  @override
  String objUnderTime(int seconds) {
    return 'Beende in unter $seconds s';
  }

  @override
  String get objStripBoss => 'Zerstöre alle Bossteile vor dem Kern';

  @override
  String get joinCoopTitle => 'Koop beitreten';

  @override
  String get cannotSearchNetwork =>
      'In diesem Netzwerk kann nicht gesucht werden';

  @override
  String get joinHintNearby =>
      'Dasselbe WLAN funktioniert auf jedem Gerät. iPhone, iPad und Mac finden sich auch ohne WLAN in der Nähe — wenn auf beiden der persönliche Hotspot aus ist.';

  @override
  String get joinHintWifi =>
      'Beide Spieler müssen im selben WLAN sein — ein persönlicher Hotspot geht auch.';

  @override
  String noHostsYet(String hint) {
    return 'Noch keine Hosts. $hint';
  }

  @override
  String get lookingForHosts => 'Suche Hosts in diesem WLAN und in der Nähe…';

  @override
  String get hostNearby => 'In der Nähe · Bluetooth / Peer-to-Peer-WLAN';

  @override
  String hostSameWifi(String address) {
    return '$address · selbes WLAN';
  }

  @override
  String get enterIpManually => 'IP manuell eingeben';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SCH';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — GESCHÜTZT';
  }

  @override
  String get bossPartTurret => 'Geschützturm';

  @override
  String get bossPartShieldPod => 'Schildmodul';

  @override
  String get bossPartThruster => 'Triebwerk';

  @override
  String get bossPartCannon => 'Kanone';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Unbekannter Raum';
  }

  @override
  String get player2Joined => 'Spieler 2 ist beigetreten!';

  @override
  String get player2Disconnected => 'Spieler 2 hat die Verbindung getrennt';

  @override
  String get hostDisconnected => 'Host hat die Verbindung getrennt';

  @override
  String maxLevelSold(String amount) {
    return 'Max. Stufe! Verkauft für \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Waffenstufe $tier freigeschaltet';
  }

  @override
  String get cheatsEnabled => 'Cheats aktiviert';

  @override
  String get cheatsDisabled => 'Cheats deaktiviert';

  @override
  String get cheatsMaxed =>
      'CHEAT: Credits maximiert, alle Waffen freigeschaltet';

  @override
  String get cheats => 'CHEATS';

  @override
  String get maxCredits => 'MAX CREDITS';

  @override
  String get sectionStats => 'WERTE';

  @override
  String get sectionLoadout => 'BEWAFFNUNG';

  @override
  String levelShort(int level) {
    return 'St.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'AUF';

  @override
  String get sell => 'VERKAUFEN';

  @override
  String get buy => 'KAUFEN';

  @override
  String get commandCenter => 'KOMMANDOZENTRUM';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUNKTE';

  @override
  String get nextWeapon => 'NÄCHSTE WAFFE';

  @override
  String pointsValue(String points) {
    return '$points Pkt.';
  }

  @override
  String get slotFront => 'Front';

  @override
  String get slotLeft => 'Links';

  @override
  String get slotRight => 'Rechts';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'MISSION STARTEN';

  @override
  String get startMission => 'MISSION BEGINNEN';

  @override
  String get continueMission => 'MISSION FORTSETZEN';

  @override
  String get padControlsHint =>
      '[↑↓] Zeile   [←→] Auswahl   [B] Kaufen/Verbessern/Wechseln   [X/Y] Verkaufen   [OPTIONS] Weiter';

  @override
  String get host => 'HOSTEN';

  @override
  String hostingAs(String name) {
    return 'HOST als $name';
  }

  @override
  String get join => 'BEITRETEN';

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
  String get overload => 'ÜBERLAST';

  @override
  String weaponOff(String weapon) {
    return '$weapon AUS — Generator zu schwach';
  }

  @override
  String unlocksAt(String points) {
    return 'Freigeschaltet ab $points Pkt.';
  }

  @override
  String joinConnecting(String target) {
    return 'Verbinde mit $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Der Host hat nicht geantwortet: $reason.\n\nBeide Spieler müssen im selben WLAN sein (ein persönlicher Hotspot geht auch) und der Host muss HOST gedrückt haben. Prüfe die Adresse und versuche es erneut.';
  }

  @override
  String get lanJoinNoAnswer => 'keine Antwort';
}
