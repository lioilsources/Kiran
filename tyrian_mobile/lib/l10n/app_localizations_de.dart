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
  String get statsOn => 'STATISTIK: AN';

  @override
  String get statsOff => 'STATISTIK: AUS';

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

  @override
  String get swapHint => 'Mit zwei Fingern feuerst du dein zweites Waffenset';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: stärkere Schüsse';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: Rumpf repariert';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount Schild, lädt schneller';
  }

  @override
  String get pickupGenerator =>
      'Stärkerer Generator: mehr Energie für die Waffen';

  @override
  String pickupCredits(String amount) {
    return '+$amount Credits für das ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String get tutPickupWeapon =>
      'Waffen-Pickups erhöhen die Stufe: mehr Schaden, schnelleres Feuer';

  @override
  String get tutPickupHealth =>
      'Reparaturen flicken die Hülle; bei voller Hülle steigt max. HP';

  @override
  String get tutPickupShield =>
      'Der Schild fängt Treffer vor der Hülle ab und lädt sich selbst auf';

  @override
  String get tutPickupGenerator =>
      'Der Generator speist deine Waffen: mehr Energie, mehr Feuer';

  @override
  String get tutPickupCredits =>
      'Mit Credits kaufst du Waffen und Upgrades im ComCenter';

  @override
  String get tutBoss =>
      'BOSS! Seine Energie ist der Balken oben. Bleib in Bewegung, feuer!';

  @override
  String get tutLowHp => 'Hülle schwach! Reparaturen oder das ComCenter helfen';

  @override
  String get tutGenStarved =>
      'Deine Waffen brauchen mehr Energie als der Generator: upgrade ihn';

  @override
  String get tutCanAfford =>
      'Du kannst dir ein Upgrade leisten: ab ins ComCenter nach der Runde';

  @override
  String get tutFly =>
      'Ziehen zum Fliegen. Deine Waffen feuern, solange du berührst';

  @override
  String get introCollect =>
      'Schnapp dir die Symbole, die Gegner fallen lassen';

  @override
  String get introShop =>
      'Zwischen den Runden gibst du Credits im ComCenter aus';

  @override
  String get objBoss => 'Ziel: Überlebe die Wellen und besiege den Boss';

  @override
  String get objSurvive => 'Ziel: Überlebe die Wellen';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits Credits · $kills Abschüsse';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Beste Waffe: $weapon';
  }

  @override
  String get deathBoss =>
      'Boss-Schüsse treffen hart: ein stärkerer Schild verschafft Zeit';

  @override
  String get deathShield =>
      'Verbessere den Schild im ComCenter: er schützt die Hülle';

  @override
  String get deathGuns =>
      'Stärkere Waffen räumen Wellen ab, bevor sie dir schaden';
}
