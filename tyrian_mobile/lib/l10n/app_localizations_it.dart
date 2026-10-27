// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANNULLA';

  @override
  String get connect => 'CONNETTI';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Impossibile connettersi a $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'L\'host era visibile, ma il collegamento non si è stabilito.\n\nIl gioco nelle vicinanze richiede il Wi-Fi peer-to-peer, che iOS disattiva quando l\'hotspot personale è attivo. Spegni l\'hotspot su entrambi i dispositivi e riprova, oppure collegali alla stessa rete Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Missione fallita — equipaggiamento e crediti conservati. Riprova dal Centro di comando.';

  @override
  String get gameOverEndless =>
      'Ricostruzione nel Settore 1 — equipaggiamento e crediti conservati';

  @override
  String get waitingForHost => 'In attesa dell\'host...';

  @override
  String get waitingForHostHint =>
      'La partita inizierà quando l\'host sarà pronto';

  @override
  String get vesselLost => 'NAVE PERDUTA';

  @override
  String scoreValue(String score) {
    return 'Punteggio: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Crediti: $credits';
  }

  @override
  String get creditsPrefix => 'Crediti: ';

  @override
  String get leaderboard => 'CLASSIFICA';

  @override
  String get achievements => 'OBIETTIVI';

  @override
  String get redeploy => 'RISCHIERA';

  @override
  String get resume => 'RIPRENDI';

  @override
  String get pause => 'PAUSA';

  @override
  String get paused => 'IN PAUSA';

  @override
  String get skins => 'SKIN';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SUONI: SÌ';

  @override
  String get soundOff => 'SUONI: NO';

  @override
  String get musicOn => 'MUSICA: SÌ';

  @override
  String get musicOff => 'MUSICA: NO';

  @override
  String get mainMenu => 'MENU PRINCIPALE';

  @override
  String get quitToDesktop => 'ESCI AL DESKTOP';

  @override
  String get selectSkin => 'SCEGLI SKIN';

  @override
  String get difficulty => 'DIFFICOLTÀ';

  @override
  String get difficultyEasy => 'FACILE';

  @override
  String get difficultyNormal => 'NORMALE';

  @override
  String get difficultyHard => 'DIFFICILE';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAGNA';

  @override
  String get quit => 'ESCI';

  @override
  String get restorePurchases => 'RIPRISTINA ACQUISTI';

  @override
  String get locked => 'BLOCCATO';

  @override
  String get mainMenuTooltip => 'Menu principale';

  @override
  String nodeLevel(int level) {
    return 'LIVELLO $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LIVELLO $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Bloccato. Completa prima la missione precedente.';

  @override
  String get flyAgain => 'VOLA DI NUOVO';

  @override
  String get launch => 'DECOLLA';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'STELLA';

  @override
  String get continueButton => 'CONTINUA';

  @override
  String get replayNode => 'RIGIOCA MISSIONE';

  @override
  String get retry => 'RIPROVA';

  @override
  String get nodeCleared => 'MISSIONE COMPIUTA';

  @override
  String get nodeFailed => 'MISSIONE FALLITA';

  @override
  String get weaponTierUnlocked => 'NUOVO LIVELLO ARMI';

  @override
  String get onSaleInComCenter => 'In vendita nel Centro di comando.';

  @override
  String get requiredTasksHint =>
      'Gli obiettivi obbligatori decidono la missione. Rigiocala: ciò che hai guadagnato resta tuo.';

  @override
  String get objClear => 'Ripulisci il settore';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abbatti $count nemici',
      one: 'Abbatti 1 nemico',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Non subire danni allo scafo';

  @override
  String objHull(int percent) {
    return 'Termina con lo scafo sopra il $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count nemici con $weapon',
      one: 'Elimina 1 nemico con $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count nemici con le armi laterali',
      one: 'Elimina 1 nemico con le armi laterali',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Decolla con $weapon davanti';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Decolla con $weapon su un lato';
  }

  @override
  String get objBuySideGun => 'Compra un\'arma laterale nel Centro di comando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Potenzia il generatore al livello $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Potenzia l\'arma frontale al livello $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Potenzia un\'arma laterale al livello $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Raccogli $count bonus',
      one: 'Raccogli 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Distruggi $count formazioni intere',
      one: 'Distruggi 1 formazione intera',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Non urtare asteroidi';

  @override
  String objUnderTime(int seconds) {
    return 'Termina entro $seconds s';
  }

  @override
  String get objStripBoss => 'Distruggi ogni parte del boss prima del nucleo';

  @override
  String get joinCoopTitle => 'Unisciti in co-op';

  @override
  String get cannotSearchNetwork => 'Impossibile cercare su questa rete';

  @override
  String get joinHintNearby =>
      'La stessa rete Wi-Fi funziona su ogni dispositivo. iPhone, iPad e Mac si trovano anche nelle vicinanze senza Wi-Fi, con l\'hotspot personale spento su entrambi.';

  @override
  String get joinHintWifi =>
      'Entrambi i giocatori devono essere sulla stessa rete Wi-Fi; va bene anche un hotspot personale.';

  @override
  String noHostsYet(String hint) {
    return 'Ancora nessun host. $hint';
  }

  @override
  String get lookingForHosts =>
      'Ricerca di host su questa rete Wi-Fi e nelle vicinanze…';

  @override
  String get hostNearby => 'Nelle vicinanze · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · stessa Wi-Fi';
  }

  @override
  String get enterIpManually => 'Inserisci IP manualmente';

  @override
  String get hudHp => 'PS';

  @override
  String get hudShield => 'SC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — SCHERMATO';
  }

  @override
  String get bossPartTurret => 'Torretta';

  @override
  String get bossPartShieldPod => 'Modulo scudo';

  @override
  String get bossPartThruster => 'Propulsore';

  @override
  String get bossPartCannon => 'Cannone';

  @override
  String sectorUnknownSpace(int level) {
    return 'Settore $level — Spazio ignoto';
  }

  @override
  String get player2Joined => 'Il giocatore 2 si è unito!';

  @override
  String get player2Disconnected => 'Il giocatore 2 si è disconnesso';

  @override
  String get hostDisconnected => 'L\'host si è disconnesso';

  @override
  String maxLevelSold(String amount) {
    return 'Livello max! Venduto per \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Livello armi $tier sbloccato';
  }

  @override
  String get cheatsEnabled => 'Trucchi attivati';

  @override
  String get cheatsDisabled => 'Trucchi disattivati';

  @override
  String get cheatsMaxed =>
      'TRUCCO: crediti al massimo, tutte le armi sbloccate';

  @override
  String get cheats => 'TRUCCHI';

  @override
  String get maxCredits => 'CREDITI MAX';

  @override
  String get sectionStats => 'STATISTICHE';

  @override
  String get sectionLoadout => 'ARMAMENTO';

  @override
  String levelShort(int level) {
    return 'Liv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'POT';

  @override
  String get sell => 'VENDI';

  @override
  String get buy => 'COMPRA';

  @override
  String get commandCenter => 'CENTRO DI COMANDO';

  @override
  String get pilot => 'Pilota';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUNTI';

  @override
  String get nextWeapon => 'PROSSIMA ARMA';

  @override
  String pointsValue(String points) {
    return '$points pt';
  }

  @override
  String get slotFront => 'Fronte';

  @override
  String get slotLeft => 'Sinistra';

  @override
  String get slotRight => 'Destra';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LANCIA MISSIONE';

  @override
  String get startMission => 'INIZIA MISSIONE';

  @override
  String get continueMission => 'CONTINUA MISSIONE';

  @override
  String get padControlsHint =>
      '[↑↓] Riga   [←→] Scegli   [B] Compra/Potenzia/Cambia   [X/Y] Vendi   [OPTIONS] Continua';

  @override
  String get host => 'OSPITA';

  @override
  String hostingAs(String name) {
    return 'HOST: $name';
  }

  @override
  String get join => 'UNISCITI';

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
  String get overload => 'SOVRACCARICO';

  @override
  String weaponOff(String weapon) {
    return '$weapon SPENTO — generatore troppo debole';
  }

  @override
  String unlocksAt(String points) {
    return 'Si sblocca a $points punti';
  }
}
