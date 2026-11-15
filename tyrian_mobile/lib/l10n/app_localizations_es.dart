// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'CANCELAR';

  @override
  String get connect => 'CONECTAR';

  @override
  String get gameOverEndless =>
      'Reconstruyendo en el Sector 1 — conservas el equipo y los créditos';

  @override
  String get waitingForHost => 'Esperando al anfitrión...';

  @override
  String get waitingForHostHint =>
      'La partida empezará cuando el anfitrión esté listo';

  @override
  String get vesselLost => 'NAVE PERDIDA';

  @override
  String scoreValue(String score) {
    return 'Puntos: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Créditos: $credits';
  }

  @override
  String get creditsPrefix => 'Créditos: ';

  @override
  String get leaderboard => 'CLASIFICACIÓN';

  @override
  String get achievements => 'LOGROS';

  @override
  String get redeploy => 'REDESPLEGAR';

  @override
  String get resume => 'REANUDAR';

  @override
  String get pause => 'PAUSA';

  @override
  String get paused => 'EN PAUSA';

  @override
  String get skins => 'ASPECTOS';

  @override
  String get skin => 'ASPECTO';

  @override
  String get soundOn => 'SONIDO: SÍ';

  @override
  String get soundOff => 'SONIDO: NO';

  @override
  String get musicOn => 'MÚSICA: SÍ';

  @override
  String get musicOff => 'MÚSICA: NO';

  @override
  String get statsOn => 'ESTADÍSTICAS: SÍ';

  @override
  String get statsOff => 'ESTADÍSTICAS: NO';

  @override
  String get quitToDesktop => 'SALIR AL ESCRITORIO';

  @override
  String get selectSkin => 'ELIGE ASPECTO';

  @override
  String get quit => 'SALIR';

  @override
  String get restorePurchases => 'RESTAURAR COMPRAS';

  @override
  String get locked => 'BLOQUEADO';

  @override
  String get hudHp => 'PV';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'ENE';

  @override
  String get hudGen => 'GEN';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sector $level — Espacio desconocido';
  }

  @override
  String get player2Joined => '¡El jugador 2 se ha unido!';

  @override
  String get player2Disconnected => 'El jugador 2 se ha desconectado';

  @override
  String get hostDisconnected => 'El anfitrión se ha desconectado';

  @override
  String maxLevelSold(String amount) {
    return '¡Nivel máx.! Vendido por \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Nivel de armas $tier desbloqueado';
  }

  @override
  String get cheatsEnabled => 'Trucos activados';

  @override
  String get cheatsDisabled => 'Trucos desactivados';

  @override
  String get cheatsMaxed =>
      'TRUCO: créditos al máximo, todas las armas desbloqueadas';

  @override
  String get cheats => 'TRUCOS';

  @override
  String get maxCredits => 'MÁX. CRÉDITOS';

  @override
  String get sectionStats => 'ESTADÍSTICAS';

  @override
  String get sectionLoadout => 'ARMAMENTO';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MÁX';

  @override
  String get upgradeShort => 'MEJ';

  @override
  String get sell => 'VENDER';

  @override
  String get buy => 'COMPRAR';

  @override
  String get commandCenter => 'CENTRO DE MANDO';

  @override
  String get pilot => 'Piloto';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUNTOS';

  @override
  String get nextWeapon => 'SIGUIENTE ARMA';

  @override
  String pointsValue(String points) {
    return '$points pts';
  }

  @override
  String get slotFront => 'Frontal';

  @override
  String get slotLeft => 'Izq.';

  @override
  String get slotRight => 'Der.';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'ENE';

  @override
  String get startMission => 'INICIAR MISIÓN';

  @override
  String get continueMission => 'CONTINUAR MISIÓN';

  @override
  String get padControlsHint =>
      '[↑↓] Fila   [←→] Elegir   [B] Comprar/Mejorar/Cambiar   [X/Y] Vender   [OPTIONS] Continuar';

  @override
  String get host => 'ANFITRIÓN';

  @override
  String get connectToHost => 'Conectar con el anfitrión';

  @override
  String hostingAt(String ip) {
    return 'ANFITRIÓN  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
  }

  @override
  String get join => 'UNIRSE';

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
  String get overload => 'SOBRECARGA';

  @override
  String weaponOff(String weapon) {
    return '$weapon APAGADO — generador demasiado débil';
  }

  @override
  String unlocksAt(String points) {
    return 'Se desbloquea con $points pts';
  }

  @override
  String get swapHint => 'Con dos dedos disparas tu segundo juego de armas';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: disparos más fuertes';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: casco reparado';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount de escudo, se recarga más rápido';
  }

  @override
  String get pickupGenerator =>
      'Generador mejorado: más energía para tus armas';

  @override
  String pickupCredits(String amount) {
    return '+$amount créditos para gastar en el ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'NIVEL $level';
  }

  @override
  String get tutPickupWeapon =>
      'Los power-ups de arma suben su nivel: más daño, disparo más rápido';

  @override
  String get tutPickupHealth =>
      'Las reparaciones arreglan el casco; si estás bien, suben el HP máx.';

  @override
  String get tutPickupShield =>
      'El escudo recibe los golpes antes que el casco y se recarga solo';

  @override
  String get tutPickupGenerator =>
      'El generador alimenta tus armas: más energía, más armas disparando';

  @override
  String get tutPickupCredits =>
      'Con créditos compras armas y mejoras en el ComCenter entre rondas';

  @override
  String get tutBoss =>
      '¡BOSS! Su vida es la barra de arriba. Muévete y dispara';

  @override
  String get tutLowHp =>
      '¡Casco bajo! Una reparación o el ComCenter lo arreglan';

  @override
  String get tutGenStarved =>
      'Tus armas piden más energía que el generador: mejóralo';

  @override
  String get tutCanAfford =>
      'Te alcanza para una mejora: pasa por el ComCenter tras la ronda';

  @override
  String get tutFly => 'Arrastra para volar. Tus armas disparan mientras tocas';

  @override
  String get introCollect => 'Atrapa los iconos que sueltan los enemigos';

  @override
  String get introShop => 'Entre rondas, gasta tus créditos en el ComCenter';

  @override
  String get objBoss => 'Objetivo: sobrevive a las oleadas y vence al jefe';

  @override
  String get objSurvive => 'Objetivo: sobrevive a las oleadas';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits créditos · $kills derribos';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Mejor arma: $weapon';
  }

  @override
  String get deathBoss =>
      'Los disparos del jefe duelen: un escudo mejor te da tiempo';

  @override
  String get deathShield =>
      'Mejora el escudo en el ComCenter: recibe golpes antes que el casco';

  @override
  String get deathGuns =>
      'Armas más fuertes barren oleadas antes de que te dañen';
}
