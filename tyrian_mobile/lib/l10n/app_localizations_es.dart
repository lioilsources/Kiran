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
  String get sectionOutfitting => 'EQUIPAMIENTO';

  @override
  String get sectionShop => 'TIENDA';

  @override
  String get tabFront => 'FRONTAL';

  @override
  String get tabSide => 'LATERAL';

  @override
  String get tabGen => 'GEN';

  @override
  String get sideLeft => 'IZQ.';

  @override
  String get sideRight => 'DER.';

  @override
  String get noWeaponInstalled => 'SIN ARMA INSTALADA';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'DAÑO:$damage VEL:$speed';
  }

  @override
  String statPower(int power) {
    return 'ENE:$power';
  }

  @override
  String get beam => 'RAYO';

  @override
  String get guided => 'GUIADO';

  @override
  String get owned => 'EN PROPIEDAD';

  @override
  String get max => 'MÁX';

  @override
  String get upgrade => 'MEJORAR';

  @override
  String get upgradeShort => 'MEJ';

  @override
  String get sell => 'VENDER';

  @override
  String get buy => 'COMPRAR';

  @override
  String get noCredits => 'SIN CRÉDITOS';

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
  String get generator => 'GENERADOR';

  @override
  String genOutput(String value) {
    return 'ENE: +$value/fr';
  }

  @override
  String genCapacity(int value) {
    return 'Cap.: $value';
  }

  @override
  String get startMission => 'INICIAR MISIÓN';

  @override
  String get continueMission => 'CONTINUAR MISIÓN';

  @override
  String get padControlsHint =>
      '[B] Comprar/mejorar   [X/Y] Vender   [LB/RB] Pestañas   [OPTIONS] Continuar misión';

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
}
