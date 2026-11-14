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
  String get statsOn => 'ESTADÍSTICAS: SÍ';

  @override
  String get statsOff => 'ESTADÍSTICAS: NO';

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

  @override
  String objBossUnder(int seconds) {
    return 'Destruye el núcleo del jefe en $seconds s desde su llegada';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'BÓVEDA';

  @override
  String get rackSide => 'Lateral';

  @override
  String get rackHull => 'Casco';

  @override
  String get rarityCommon => 'COMÚN';

  @override
  String get rarityRare => 'RARO';

  @override
  String get rarityMythic => 'MÍTICO';

  @override
  String get curse => 'MALDICIÓN';

  @override
  String get modFit => 'MONTAR';

  @override
  String get modUnfit => 'QUITAR';

  @override
  String get modForge => 'FORJA';

  @override
  String get forgeHint => 'Elige 3 de una rareza para forjar 1 de la siguiente';

  @override
  String get vaultEmpty =>
      'Aún no hay mods. Completa un nodo con todas las estrellas, vence rápido a un jefe o derriba un jefe en modo infinito.';

  @override
  String modNeeds(String families) {
    return 'Funciona con $families';
  }

  @override
  String get modRackFull => 'Rack lleno';

  @override
  String get modAlreadyFitted => 'Ya montado';

  @override
  String get modWrongRack => 'No va en este rack';

  @override
  String modsSpilled(int n) {
    return '$n mods de vuelta en la bóveda';
  }

  @override
  String get hullLocked => 'Bloqueado';

  @override
  String hullUnlockBoss(int n) {
    return 'Vence al jefe de campaña $n';
  }

  @override
  String get hullUnlockFinish => 'Termina la campaña o llega al sector 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'IMP';

  @override
  String get perkNone => 'Nave estándar';

  @override
  String get perkAfterimage => 'Quieto: disparos ×1,5';

  @override
  String get perkBulwark => 'El daño tras el escudo se reduce a la mitad';

  @override
  String get perkOverclock =>
      'Dispara armas hasta el 130 % de capacidad, más lento';

  @override
  String get perkBattery => 'Un dron gratis te acompaña';

  @override
  String get rewardTitle => 'RECOMPENSA';

  @override
  String newHull(String name) {
    return 'Casco nuevo: $name';
  }

  @override
  String get socketEmpty => 'vacío';

  @override
  String fxStreams(int n) {
    return '$n chorros paralelos';
  }

  @override
  String fxFan(int n) {
    return 'Abanico de $n disparos';
  }

  @override
  String fxSalvo(int n) {
    return 'Ráfaga de $n disparos';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadencia ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Daño ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Velocidad de disparo ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Tamaño de disparo ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consumo ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Guiado +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Atraviesa $n objetivos';
  }

  @override
  String get fxPierceAll => 'Lo atraviesa todo';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % de probabilidad de daño ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Críticos ×$x contra jefes';
  }

  @override
  String fxFork(int n) {
    return 'Las bajas esparcen $n disparos';
  }

  @override
  String get fxChain => 'Los disparos esparcidos se esparcen otra vez';

  @override
  String get fxSplit => 'Se divide en dos al impactar';

  @override
  String get fxFrost => 'Los impactos frenan al enemigo';

  @override
  String get fxCrossfire => 'Las armas laterales apuntan al centro';

  @override
  String get fxRearguard => 'Las armas laterales también disparan atrás';

  @override
  String get fxOrbit => 'Los disparos ondulan';

  @override
  String fxBounce(int n) {
    return 'Rebota en las paredes $n×';
  }

  @override
  String get fxBounceTop => '…y en el borde superior';

  @override
  String get fxOverdrive => 'Dispara aunque falte energía';

  @override
  String get fxReactor => 'Las armas sobre la capacidad disparan, despacio';

  @override
  String fxGenPower(String x) {
    return 'Recarga del generador ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacidad del generador ×$x';
  }

  @override
  String get fxSurge => 'Generador lleno: disparos ×2';

  @override
  String fxSiphon(int pct) {
    return 'Las bajas recargan $pct % de energía';
  }

  @override
  String fxHp(String x) {
    return 'Casco ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Escudo ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regeneración de escudo ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Las bajas curan $n PV';
  }

  @override
  String get fxMagnet => 'Atrae los objetos';

  @override
  String get fxMagnetAll => 'Atrae todos los objetos';

  @override
  String fxReflect(int pct) {
    return '$pct % de los disparos rebotan en el escudo';
  }

  @override
  String get fxReflectGuided => 'Los disparos reflejados se guían';

  @override
  String fxGhost(String sec) {
    return 'Invulnerable $sec s tras un golpe al casco';
  }

  @override
  String get fxNova => 'Escudo roto: explosión en toda la pantalla';

  @override
  String fxAgility(String x) {
    return 'Agilidad ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zona de impacto ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Créditos ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Puntos ×$x';
  }

  @override
  String get fxSatellite => 'Un dron de combate te acompaña';

  @override
  String get fxTimewarp => 'Un golpe al casco ralentiza el tiempo';

  @override
  String get fxGambler => 'Cada disparo es un arma al azar';

  @override
  String get vaultAll => 'TODO';

  @override
  String get sigilMissUnknown => 'forma desconocida';

  @override
  String get sigilMissTooSlow => 'demasiado lento';

  @override
  String get sigilMissSkippedDot => 'punto saltado';

  @override
  String get sigilMissLeftRimEarly => 'soltaste demasiado pronto';

  @override
  String get sigilMissWrongDirection => 'dibujado al revés';

  @override
  String get sigilMissWrongLayer => 'botón de hombro equivocado';

  @override
  String get sigilDry => 'falta carga';

  @override
  String get sigilBusy => 'el anterior sigue activo';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'PIEZAS DEL JEFE';

  @override
  String get arenaBareCore => 'núcleo desnudo';

  @override
  String get arenaCompanions => 'ACOMPAÑANTES';

  @override
  String get arenaCharge => 'CARGA';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VELOCIDAD';

  @override
  String get arenaDrill => 'PRÁCTICA';

  @override
  String get arenaFreePlay => 'JUEGO LIBRE';

  @override
  String get arenaFight => 'A LUCHAR';

  @override
  String get arenaNewBoss => 'NUEVO JEFE';

  @override
  String get arenaLeave => 'SALIR DE LA ARENA';

  @override
  String get arenaHint =>
      'El jefe vuelve en cuanto cae. Aquí no se guarda nada.';

  @override
  String get arenaColCast => 'LANZADOS';

  @override
  String get arenaColMiss => 'FALLOS';

  @override
  String get arenaColAvg => 'MEDIA';

  @override
  String get arenaColBest => 'MEJOR';

  @override
  String get arenaColTime => 'MÁS RÁPIDO';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Jefes $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'MANDO: SIGILOS';

  @override
  String get padSchemeClassic => 'MANDO: CLÁSICO';

  @override
  String get padSouthpawOn => 'ZURDO: SÍ';

  @override
  String get padSouthpawOff => 'ZURDO: NO';

  @override
  String get sigilDescHop => 'Un salto rápido hacia donde apuntes';

  @override
  String get sigilDescSidestep => 'Un largo paso lateral por el campo';

  @override
  String get sigilDescStrike =>
      'Embestida al frente con tres disparos pesados, y atrás';

  @override
  String get sigilDescRetreat =>
      'Retrocede mientras el fuego de cobertura va al frente';

  @override
  String get sigilDescDash =>
      'Carrera diagonal entre el fuego, invulnerable a medio camino';

  @override
  String get sigilDescRoll => 'Un tonel hacia un lado, invulnerable';

  @override
  String get sigilDescShadow =>
      'Pégate bajo el enemigo más cercano y sigue disparando';

  @override
  String get sigilDescEcho =>
      'Una sombra repite tus dos últimos segundos con la mitad de daño';

  @override
  String get sigilDescLoop =>
      'Un rizo por arriba: los disparos pasan por debajo';

  @override
  String get sigilDescSlalom =>
      'Una curva en S por el campo con fuego en abanico';

  @override
  String get sigilDescCorkscrew =>
      'Sacacorchos al frente disparando a todos lados, invulnerable';

  @override
  String get sigilDescSnapshot => 'Un disparo pesado hacia donde apuntes';

  @override
  String get sigilDescBroadside => 'Una ráfaga por ambos flancos';

  @override
  String get sigilDescVolley => 'Cinco rayos cargados al frente';

  @override
  String get sigilDescCaltrop => 'Suelta una mina que traga disparos y explota';

  @override
  String get sigilDescFrenzy => 'Las armas disparan más rápido unos segundos';

  @override
  String get sigilDescStasis =>
      'Los enemigos y sus disparos van a media velocidad';

  @override
  String get sigilDescHalo =>
      'El escudo se recarga cuatro veces más rápido y nada lo atraviesa';

  @override
  String get sigilDescRadial => 'Un anillo de dieciséis disparos';

  @override
  String get sigilDescStorm => 'Todas las armas disparan a tope, gratis';

  @override
  String get sigilDescPing =>
      'Los acompañantes concentran el fuego donde apuntes';

  @override
  String get sigilDescWingman => 'Llama a un escolta al flanco que trazaste';

  @override
  String get sigilDescHunter =>
      'Llama a un cazador que vuela delante y elige blancos';

  @override
  String get sigilDescWarden =>
      'Llama a un guardián que recibe los disparos dirigidos a ti';

  @override
  String get sigilDescFormation =>
      'Los acompañantes alternan formación abierta y en cuña';

  @override
  String get sigilDescWhirl => 'Los acompañantes te rodean y absorben disparos';

  @override
  String get sigilDescSacrifice =>
      'Los acompañantes se lanzan y explotan, devolviendo carga';

  @override
  String get grimoire => 'GRIMORIO';

  @override
  String get grimoireHint =>
      'Dibuja con el stick derecho. Mantén LB para ARMS, RB para WING, ambos para MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'coste $cost';
  }

  @override
  String get sigilUntouchable => 'invulnerable';

  @override
  String get lessonWatch => 'MIRA';

  @override
  String get lessonTrace => 'CALCA';

  @override
  String get lessonSlow => 'DESPACIO';

  @override
  String get lessonLive => 'A TODA VELOCIDAD';

  @override
  String get lessonStreak => 'CINCO SEGUIDAS';

  @override
  String get lessonLearned => 'APRENDIDO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Mueve rápido el stick derecho';

  @override
  String get hintLoop => 'Dibuja un círculo: pasas sobre los disparos';

  @override
  String get hintStream => 'Aprieta LT: dos o tres ráfagas';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NINGUNA';

  @override
  String kataNext(String sigil, String secs) {
    return 'siguiente $sigil en $secs s';
  }

  @override
  String get arenaGauntlet => 'DESAFÍO';

  @override
  String get arenaOn => 'SÍ';

  @override
  String get arenaOff => 'NO';

  @override
  String gauntletRating(int rating, int best) {
    return 'Puntuación $rating · mejor $best';
  }

  @override
  String get duelWarning => 'PELIGRO';

  @override
  String get duelHintPad1 => 'El stick derecho apunta y dispara';

  @override
  String get duelHintPad2Rt =>
      'Mantén RT, LB o RB: el stick derecho dibuja sigilos';

  @override
  String get duelHintPad2Lt =>
      'Mantén LT, LB o RB: el stick derecho dibuja sigilos';

  @override
  String get duelHintClassic =>
      'El stick izquierdo vuela · B, RB o RT disparan hacia donde apunta el morro';

  @override
  String get duelHintKeys1 => 'Las flechas apuntan y disparan · WASD vuela';

  @override
  String get duelHintKeys2 =>
      'Espacio dispara hacia donde apunta el morro · el teclado numérico dibuja sigilos';

  @override
  String get arenaDuelBinding => 'POSTURA DE DUELO';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'ADELANTE EN EL MANDO';

  @override
  String get duelFrameNose => 'EL MORRO';

  @override
  String get duelFrameUp => 'ARRIBA';

  @override
  String get arenaDuelAimFires => 'APUNTAR DISPARA';

  @override
  String get duelCutInFirst => 'PRIMER PLANO DEL JEFE: LA PRIMERA VEZ';

  @override
  String get duelCutInAlways => 'PRIMER PLANO DEL JEFE: SIEMPRE';

  @override
  String get duelCutInNever => 'PRIMER PLANO DEL JEFE: NUNCA';

  @override
  String get arenaDuelDrill => 'EJERCICIO DE DUELO';

  @override
  String get duelDrillOff => 'NINGUNO';

  @override
  String get duelDrillAim => 'APUNTA Y DISPARA';

  @override
  String get duelDrillAimHow => 'Apunta el stick derecho al jefe y dale';

  @override
  String get duelDrillHold => 'MANTÉN EL MORRO';

  @override
  String get duelDrillHoldHow =>
      'Mantén un botón de postura y vuela: el morro no se mueve';

  @override
  String get duelDrillDraw => 'DIBUJA HACIA DELANTE';

  @override
  String get duelDrillDrawHow =>
      'En la postura, dibuja un sigilo hacia el jefe';

  @override
  String get duelDrillTurn => 'DATE LA VUELTA';

  @override
  String get duelDrillTurnHow =>
      'El jefe está debajo de ti: gira el morro y dale';

  @override
  String get duelDrillDone => 'HECHO';

  @override
  String get swapHint => 'Toca con un segundo dedo para cambiar de armas';
}
