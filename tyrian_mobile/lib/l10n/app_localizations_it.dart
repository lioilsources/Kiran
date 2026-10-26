// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get cancel => 'ANNULLA';

  @override
  String get connect => 'CONNETTI';

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
  String get quitToDesktop => 'ESCI AL DESKTOP';

  @override
  String get selectSkin => 'SCEGLI SKIN';

  @override
  String get quit => 'ESCI';

  @override
  String get restorePurchases => 'RIPRISTINA ACQUISTI';

  @override
  String get locked => 'BLOCCATO';

  @override
  String get hudHp => 'PS';

  @override
  String get hudShield => 'SC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

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
  String get sectionOutfitting => 'EQUIPAGGIAMENTO';

  @override
  String get sectionShop => 'NEGOZIO';

  @override
  String get tabFront => 'FRONTE';

  @override
  String get tabSide => 'LATO';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => 'SINISTRA';

  @override
  String get sideRight => 'DESTRA';

  @override
  String get noWeaponInstalled => 'NESSUN\'ARMA INSTALLATA';

  @override
  String levelShort(int level) {
    return 'Liv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'DAN:$damage VEL:$speed';
  }

  @override
  String statPower(int power) {
    return 'EN:$power';
  }

  @override
  String get beam => 'RAGGIO';

  @override
  String get guided => 'GUIDATA';

  @override
  String get owned => 'POSSEDUTA';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => 'POTENZIA';

  @override
  String get upgradeShort => 'POT';

  @override
  String get sell => 'VENDI';

  @override
  String get buy => 'COMPRA';

  @override
  String get noCredits => 'CREDITI INSUFF.';

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
  String get generator => 'GENERATORE';

  @override
  String genOutput(String value) {
    return 'EN: +$value/fr';
  }

  @override
  String genCapacity(int value) {
    return 'Cap.: $value';
  }

  @override
  String get startMission => 'INIZIA MISSIONE';

  @override
  String get continueMission => 'CONTINUA MISSIONE';

  @override
  String get padControlsHint =>
      '[B] Compra/potenzia   [X/Y] Vendi   [LB/RB] Schede   [OPTIONS] Continua missione';

  @override
  String get host => 'OSPITA';

  @override
  String get connectToHost => 'Connetti all\'host';

  @override
  String hostingAt(String ip) {
    return 'HOST  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'UNISCITI';
}
