// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get connect => 'CONECTAR';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'No se pudo conectar con $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'El anfitrión era visible, pero el enlace no se estableció.\n\nEl juego cercano necesita Wi-Fi punto a punto, que iOS desactiva mientras el punto de acceso personal está activo. Apaga el punto de acceso en ambos dispositivos y vuelve a intentarlo, o conecta los dos a la misma red Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Misión fallida — conservas el equipo y los créditos. Reinténtalo desde el Centro de Mando.';

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
  String get mainMenu => 'MENÚ PRINCIPAL';

  @override
  String get quitToDesktop => 'SALIR AL ESCRITORIO';

  @override
  String get selectSkin => 'ELIGE ASPECTO';

  @override
  String get difficulty => 'DIFICULTAD';

  @override
  String get difficultyEasy => 'FÁCIL';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'DIFÍCIL';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAÑA';

  @override
  String get quit => 'SALIR';

  @override
  String get restorePurchases => 'RESTAURAR COMPRAS';

  @override
  String get locked => 'BLOQUEADO';

  @override
  String get mainMenuTooltip => 'Menú principal';

  @override
  String nodeLevel(int level) {
    return 'NIVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVEL $level · JEFE $ordinal';
  }

  @override
  String get nodeLockedHint => 'Bloqueado. Supera antes la misión anterior.';

  @override
  String get flyAgain => 'VOLAR DE NUEVO';

  @override
  String get launch => 'DESPEGAR';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'ESTRELLA';

  @override
  String get continueButton => 'CONTINUAR';

  @override
  String get replayNode => 'REPETIR MISIÓN';

  @override
  String get retry => 'REINTENTAR';

  @override
  String get nodeCleared => 'MISIÓN SUPERADA';

  @override
  String get nodeFailed => 'MISIÓN FALLIDA';

  @override
  String get weaponTierUnlocked => 'NUEVO NIVEL DE ARMAS';

  @override
  String get onSaleInComCenter => 'A la venta en el Centro de Mando.';

  @override
  String get requiredTasksHint =>
      'Las tareas obligatorias deciden la misión. Vuela otra vez: lo que ganaste se queda contigo.';

  @override
  String get objClear => 'Limpia el sector';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Derriba $count enemigos',
      one: 'Derriba 1 enemigo',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'No recibas daño en el casco';

  @override
  String objHull(int percent) {
    return 'Termina con más del $percent % de casco';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count con $weapon',
      one: 'Elimina 1 con $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count con las armas laterales',
      one: 'Elimina 1 con las armas laterales',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Despega con $weapon al frente';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Despega con $weapon en un lateral';
  }

  @override
  String get objBuySideGun => 'Compra un arma lateral en el Centro de Mando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Mejora el generador al nivel $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Mejora el arma frontal al nivel $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Mejora un arma lateral al nivel $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recoge $count objetos',
      one: 'Recoge 1 objeto',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count formaciones completas',
      one: 'Elimina 1 formación completa',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'No choques con asteroides';

  @override
  String objUnderTime(int seconds) {
    return 'Termina en menos de $seconds s';
  }

  @override
  String get objStripBoss =>
      'Destruye todas las piezas del jefe antes que el núcleo';

  @override
  String get joinCoopTitle => 'Unirse al cooperativo';

  @override
  String get cannotSearchNetwork => 'No se puede buscar en esta red';

  @override
  String get joinHintNearby =>
      'La misma Wi-Fi funciona en cualquier dispositivo. iPhone, iPad y Mac también se encuentran cerca sin ella, con el punto de acceso personal apagado en ambos.';

  @override
  String get joinHintWifi =>
      'Ambos jugadores deben estar en la misma Wi-Fi; un punto de acceso personal también sirve.';

  @override
  String noHostsYet(String hint) {
    return 'Aún no hay anfitriones. $hint';
  }

  @override
  String get lookingForHosts => 'Buscando anfitriones en esta Wi-Fi y cerca…';

  @override
  String get hostNearby => 'Cerca · Bluetooth / Wi-Fi punto a punto';

  @override
  String hostSameWifi(String address) {
    return '$address · misma Wi-Fi';
  }

  @override
  String get enterIpManually => 'Introducir IP manualmente';

  @override
  String get hudHp => 'PV';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'ENE';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — CON ESCUDO';
  }

  @override
  String get bossPartTurret => 'Torreta';

  @override
  String get bossPartShieldPod => 'Módulo de escudo';

  @override
  String get bossPartThruster => 'Propulsor';

  @override
  String get bossPartCannon => 'Cañón';

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
  String get launchMission => 'LANZAR MISIÓN';

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
  String hostingAs(String name) {
    return 'ANFITRIÓN: $name';
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
  String joinConnecting(String target) {
    return 'Conectando con $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'El anfitrión no respondió: $reason.\n\nAmbos jugadores deben estar en la misma Wi-Fi (también sirve un punto de acceso personal) y el anfitrión debe haber pulsado HOST. Comprueba la dirección e inténtalo de nuevo.';
  }

  @override
  String get lanJoinNoAnswer => 'sin respuesta';
}
