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

  @override
  String objBossUnder(int seconds) {
    return 'Zerstöre den Bosskern binnen $seconds s nach seiner Ankunft';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'TRESOR';

  @override
  String get rackSide => 'Seite';

  @override
  String get rackHull => 'Rumpf';

  @override
  String get rarityCommon => 'GEWÖHNLICH';

  @override
  String get rarityRare => 'SELTEN';

  @override
  String get rarityMythic => 'MYTHISCH';

  @override
  String get curse => 'FLUCH';

  @override
  String get modFit => 'EINBAUEN';

  @override
  String get modUnfit => 'AUSBAUEN';

  @override
  String get modForge => 'SCHMIEDE';

  @override
  String get forgeHint =>
      'Wähle 3 einer Seltenheit, um 1 der nächsten zu schmieden';

  @override
  String get vaultEmpty =>
      'Noch keine Mods. Schließe einen Knoten mit allen Sternen ab, besiege einen Boss schnell oder einen Endlos-Boss.';

  @override
  String modNeeds(String families) {
    return 'Wirkt mit $families';
  }

  @override
  String get modRackFull => 'Rack voll';

  @override
  String get modAlreadyFitted => 'Schon eingebaut';

  @override
  String get modWrongRack => 'Passt nicht in dieses Rack';

  @override
  String modsSpilled(int n) {
    return '$n Mods zurück im Tresor';
  }

  @override
  String get hullLocked => 'Gesperrt';

  @override
  String hullUnlockBoss(int n) {
    return 'Besiege Kampagnenboss $n';
  }

  @override
  String get hullUnlockFinish => 'Beende die Kampagne oder erreiche Sektor 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'TRF';

  @override
  String get perkNone => 'Standardschiff';

  @override
  String get perkAfterimage => 'Stillhalten: Schüsse ×1,5';

  @override
  String get perkBulwark => 'Schaden hinter dem Schild halbiert';

  @override
  String get perkOverclock => 'Feuert Waffen bis 130 % Kapazität, langsamer';

  @override
  String get perkBattery => 'Eine Gratis-Drohne fliegt mit';

  @override
  String get rewardTitle => 'BELOHNUNG';

  @override
  String newHull(String name) {
    return 'Neuer Rumpf: $name';
  }

  @override
  String get socketEmpty => 'leer';

  @override
  String fxStreams(int n) {
    return '$n parallele Ströme';
  }

  @override
  String fxFan(int n) {
    return 'Fächer aus $n Schüssen';
  }

  @override
  String fxSalvo(int n) {
    return 'Salve aus $n Schüssen';
  }

  @override
  String fxFireRate(String x) {
    return 'Feuerrate ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Schaden ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Schussgeschwindigkeit ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Schussgröße ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energiebedarf ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Zielsuche +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Durchschlägt $n Ziele';
  }

  @override
  String get fxPierceAll => 'Durchschlägt alles';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % Chance auf ×$x Schaden';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x Krits gegen Bosse';
  }

  @override
  String fxFork(int n) {
    return 'Abschüsse streuen $n Schüsse';
  }

  @override
  String get fxChain => 'Streuschüsse streuen weiter';

  @override
  String get fxSplit => 'Teilt sich bei Treffer in zwei';

  @override
  String get fxFrost => 'Treffer bremsen Gegner';

  @override
  String get fxCrossfire => 'Seitenwaffen zielen zur Mitte';

  @override
  String get fxRearguard => 'Seitenwaffen feuern auch nach hinten';

  @override
  String get fxOrbit => 'Schüsse schlängeln sich';

  @override
  String fxBounce(int n) {
    return 'Prallt $n× von den Wänden ab';
  }

  @override
  String get fxBounceTop => '…und von oben';

  @override
  String get fxOverdrive => 'Feuert auch auf Energieschuld';

  @override
  String get fxReactor => 'Überlastete Waffen feuern trotzdem, langsam';

  @override
  String fxGenPower(String x) {
    return 'Generator-Ladung ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generator-Kapazität ×$x';
  }

  @override
  String get fxSurge => 'Voller Generator: Schüsse ×2';

  @override
  String fxSiphon(int pct) {
    return 'Abschüsse füllen $pct % Energie auf';
  }

  @override
  String fxHp(String x) {
    return 'Rumpf ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Schild ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Schildregeneration ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Abschüsse heilen $n HP';
  }

  @override
  String get fxMagnet => 'Zieht Extras an';

  @override
  String get fxMagnetAll => 'Zieht alle Extras an';

  @override
  String fxReflect(int pct) {
    return '$pct % der Schüsse prallen vom Schild zurück';
  }

  @override
  String get fxReflectGuided => 'Reflektierte Schüsse suchen ihr Ziel';

  @override
  String fxGhost(String sec) {
    return '$sec s unverwundbar nach Rumpftreffer';
  }

  @override
  String get fxNova => 'Schild bricht: Explosion über den ganzen Schirm';

  @override
  String fxAgility(String x) {
    return 'Wendigkeit ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Trefferzone ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Credits ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Punkte ×$x';
  }

  @override
  String get fxSatellite => 'Eine Kampfdrohne fliegt mit';

  @override
  String get fxTimewarp => 'Rumpftreffer verlangsamt die Zeit';

  @override
  String get fxGambler => 'Jeder Schuss ist eine Zufallswaffe';

  @override
  String get vaultAll => 'ALLE';

  @override
  String get sigilMissUnknown => 'unbekannte Form';

  @override
  String get sigilMissTooSlow => 'zu langsam';

  @override
  String get sigilMissSkippedDot => 'Punkt ausgelassen';

  @override
  String get sigilMissLeftRimEarly => 'zu früh losgelassen';

  @override
  String get sigilMissWrongDirection => 'rückwärts gezeichnet';

  @override
  String get sigilMissWrongLayer => 'falsche Schultertaste';

  @override
  String get sigilDry => 'zu wenig Ladung';

  @override
  String get sigilBusy => 'vorheriges läuft noch';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BOSS-TEILE';

  @override
  String get arenaBareCore => 'nackter Kern';

  @override
  String get arenaCompanions => 'BEGLEITER';

  @override
  String get arenaCharge => 'LADUNG';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'WELTTEMPO';

  @override
  String get arenaDrill => 'DRILL';

  @override
  String get arenaFreePlay => 'FREIES SPIEL';

  @override
  String get arenaFight => 'KÄMPFEN';

  @override
  String get arenaNewBoss => 'NEUER BOSS';

  @override
  String get arenaLeave => 'ARENA VERLASSEN';

  @override
  String get arenaHint =>
      'Der Boss kehrt zurück, sobald er fällt. Hier wird nichts gespeichert.';

  @override
  String get arenaColCast => 'GEWIRKT';

  @override
  String get arenaColMiss => 'DANEBEN';

  @override
  String get arenaColAvg => 'SCHNITT';

  @override
  String get arenaColBest => 'BESTE';

  @override
  String get arenaColTime => 'SCHNELLSTE';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bosse $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILLE';

  @override
  String get padSchemeClassic => 'PAD: KLASSISCH';

  @override
  String get padSouthpawOn => 'LINKSHÄNDER: AN';

  @override
  String get padSouthpawOff => 'LINKSHÄNDER: AUS';

  @override
  String get sigilDescHop => 'Ein schneller Satz in Stickrichtung';

  @override
  String get sigilDescSidestep => 'Ein langer Seitschritt quer übers Feld';

  @override
  String get sigilDescStrike =>
      'Vorstoß mit drei schweren Schüssen, dann zurück';

  @override
  String get sigilDescRetreat =>
      'Rückzug, während Deckungsfeuer nach vorn geht';

  @override
  String get sigilDescDash =>
      'Diagonaler Sprint durchs Feuer, mittendrin unverwundbar';

  @override
  String get sigilDescRoll => 'Eine Fassrolle zur Seite, unverwundbar';

  @override
  String get sigilDescShadow =>
      'Klemm dich unter den nächsten Gegner und feuere weiter';

  @override
  String get sigilDescEcho =>
      'Ein Schatten wiederholt deine letzten zwei Sekunden mit halbem Schaden';

  @override
  String get sigilDescLoop =>
      'Looping über Kopf: Schüsse fliegen unter dir durch';

  @override
  String get sigilDescSlalom => 'S-Kurve quer übers Feld mit Fächerfeuer';

  @override
  String get sigilDescCorkscrew =>
      'Korkenzieher nach vorn, Feuer rundum, unverwundbar';

  @override
  String get sigilDescSnapshot => 'Ein schwerer Schuss in Stickrichtung';

  @override
  String get sigilDescBroadside => 'Eine Salve aus beiden Flanken';

  @override
  String get sigilDescVolley => 'Fünf geladene Strahlen nach vorn';

  @override
  String get sigilDescCaltrop =>
      'Leg eine Mine, die Schüsse schluckt und explodiert';

  @override
  String get sigilDescFrenzy => 'Waffen feuern ein paar Sekunden schneller';

  @override
  String get sigilDescStasis =>
      'Gegner und ihre Schüsse werden halb so schnell';

  @override
  String get sigilDescHalo =>
      'Schild lädt viermal schneller und nichts kommt durch';

  @override
  String get sigilDescRadial => 'Ein Ring aus sechzehn Schüssen';

  @override
  String get sigilDescStorm => 'Alle Waffen feuern auf Anschlag, gratis';

  @override
  String get sigilDescPing => 'Begleiter bündeln das Feuer in Stickrichtung';

  @override
  String get sigilDescWingman =>
      'Ruf einen Flügelmann an die gezeichnete Flanke';

  @override
  String get sigilDescHunter =>
      'Ruf einen Jäger, der vorausfliegt und Ziele wählt';

  @override
  String get sigilDescWarden =>
      'Ruf einen Wächter, der die Schüsse für dich abfängt';

  @override
  String get sigilDescFormation => 'Begleiter wechseln zwischen breit und Keil';

  @override
  String get sigilDescWhirl =>
      'Begleiter kreisen um dich und schlucken Schüsse';

  @override
  String get sigilDescSacrifice =>
      'Begleiter stürzen sich hinein und explodieren, Ladung kommt zurück';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Zeichne mit dem rechten Stick. Halte LB für ARMS, RB für WING, beide für MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'Kosten $cost';
  }

  @override
  String get sigilUntouchable => 'unverwundbar';

  @override
  String get lessonWatch => 'ZUSCHAUEN';

  @override
  String get lessonTrace => 'NACHZEICHNEN';

  @override
  String get lessonSlow => 'LANGSAM';

  @override
  String get lessonLive => 'VOLLES TEMPO';

  @override
  String get lessonStreak => 'FÜNFMAL HINTEREINANDER';

  @override
  String get lessonLearned => 'GELERNT';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Rechten Stick antippen';

  @override
  String get hintLoop => 'Zeichne einen Kreis: du fliegst über die Schüsse';

  @override
  String get hintStream => 'LT drücken: zwei oder drei Strahlen';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'KEINE';

  @override
  String kataNext(String sigil, String secs) {
    return 'nächstes $sigil in $secs s';
  }

  @override
  String get arenaGauntlet => 'SPIESSRUTENLAUF';

  @override
  String get arenaOn => 'AN';

  @override
  String get arenaOff => 'AUS';

  @override
  String gauntletRating(int rating, int best) {
    return 'Wertung $rating · Bestwert $best';
  }
}
