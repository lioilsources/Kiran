// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get connect => 'VERBINDEN';

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
  String get quitToDesktop => 'ZUM DESKTOP';

  @override
  String get selectSkin => 'SKIN WÄHLEN';

  @override
  String get quit => 'BEENDEN';

  @override
  String get restorePurchases => 'KÄUFE WIEDERHERSTELLEN';

  @override
  String get locked => 'GESPERRT';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SCH';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

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
  String get startMission => 'MISSION BEGINNEN';

  @override
  String get continueMission => 'MISSION FORTSETZEN';

  @override
  String get padControlsHint =>
      '[↑↓] Zeile   [←→] Auswahl   [B] Kaufen/Verbessern/Wechseln   [X/Y] Verkaufen   [OPTIONS] Weiter';

  @override
  String get host => 'HOSTEN';

  @override
  String get connectToHost => 'Mit Host verbinden';

  @override
  String hostingAt(String ip) {
    return 'HOST  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
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
}
