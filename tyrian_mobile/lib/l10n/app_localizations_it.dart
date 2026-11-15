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
  String get statsOn => 'STATISTICHE: SÌ';

  @override
  String get statsOff => 'STATISTICHE: NO';

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
  String get startMission => 'INIZIA MISSIONE';

  @override
  String get continueMission => 'CONTINUA MISSIONE';

  @override
  String get padControlsHint =>
      '[↑↓] Riga   [←→] Scegli   [B] Compra/Potenzia/Cambia   [X/Y] Vendi   [OPTIONS] Continua';

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

  @override
  String get swapHint => 'Con due dita spari con il secondo set di armi';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: colpi più potenti';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: scafo riparato';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount di scudo, si ricarica più in fretta';
  }

  @override
  String get pickupGenerator =>
      'Generatore potenziato: più energia per le armi';

  @override
  String pickupCredits(String amount) {
    return '+$amount crediti da spendere nel ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'LIVELLO $level';
  }

  @override
  String get tutPickupWeapon =>
      'I potenziamenti alzano il livello dell\'arma: più danni, fuoco più rapido';

  @override
  String get tutPickupHealth =>
      'Le riparazioni sistemano lo scafo; a scafo integro alzano gli HP massimi';

  @override
  String get tutPickupShield =>
      'Lo scudo assorbe i colpi prima dello scafo e si ricarica da solo';

  @override
  String get tutPickupGenerator =>
      'Il generatore alimenta le armi: più energia, più armi che sparano';

  @override
  String get tutPickupCredits =>
      'Con i crediti compri armi e potenziamenti nel ComCenter tra i round';

  @override
  String get tutBoss =>
      'BOSS! La sua salute è la barra in alto. Muoviti e continua a sparare';

  @override
  String get tutLowHp =>
      'Scafo a pezzi! Lo ripari con una riparazione o nel ComCenter';

  @override
  String get tutGenStarved =>
      'Le armi chiedono più energia del generatore: potenzialo';

  @override
  String get tutCanAfford =>
      'Puoi permetterti un potenziamento: passa al ComCenter dopo il round';

  @override
  String get tutFly =>
      'Trascina per volare. Le armi sparano finché tieni giù il dito';

  @override
  String get introCollect => 'Raccogli le icone lasciate dai nemici';

  @override
  String get introShop =>
      'Tra un round e l\'altro, spendi i crediti nel ComCenter';

  @override
  String get objBoss => 'Obiettivo: sopravvivi alle ondate e sconfiggi il boss';

  @override
  String get objSurvive => 'Obiettivo: sopravvivi alle ondate';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits crediti · $kills abbattuti';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Arma migliore: $weapon';
  }

  @override
  String get deathBoss =>
      'I colpi del boss fanno male: uno scudo più forte ti fa guadagnare tempo';

  @override
  String get deathShield =>
      'Potenzia lo scudo nel ComCenter: assorbe i colpi prima dello scafo';

  @override
  String get deathGuns =>
      'Armi più forti spazzano via le ondate prima che ti feriscano';
}
