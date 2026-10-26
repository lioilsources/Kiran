// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get connect => 'CONECTAR';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Não foi possível conectar a $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'O anfitrião estava visível, mas a conexão não foi estabelecida.\n\nO jogo por proximidade precisa de Wi-Fi ponto a ponto, que o iOS desliga enquanto o Acesso Pessoal está ativo. Desligue o Acesso Pessoal nos dois aparelhos e tente de novo, ou conecte ambos à mesma rede Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Missão fracassada — equipamento e créditos mantidos. Tente de novo pelo Centro de Comando.';

  @override
  String get gameOverEndless =>
      'Reconstruindo no Setor 1 — equipamento e créditos mantidos';

  @override
  String get waitingForHost => 'Aguardando o anfitrião...';

  @override
  String get waitingForHostHint =>
      'O jogo começa quando o anfitrião estiver pronto';

  @override
  String get vesselLost => 'NAVE PERDIDA';

  @override
  String scoreValue(String score) {
    return 'Pontos: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Créditos: $credits';
  }

  @override
  String get creditsPrefix => 'Créditos: ';

  @override
  String get leaderboard => 'PLACAR';

  @override
  String get achievements => 'CONQUISTAS';

  @override
  String get redeploy => 'VOLTAR À AÇÃO';

  @override
  String get resume => 'CONTINUAR';

  @override
  String get pause => 'PAUSAR';

  @override
  String get paused => 'PAUSADO';

  @override
  String get skins => 'VISUAIS';

  @override
  String get skin => 'VISUAL';

  @override
  String get soundOn => 'SOM: LIGADO';

  @override
  String get soundOff => 'SOM: DESLIGADO';

  @override
  String get musicOn => 'MÚSICA: LIGADA';

  @override
  String get musicOff => 'MÚSICA: DESLIGADA';

  @override
  String get mainMenu => 'MENU PRINCIPAL';

  @override
  String get quitToDesktop => 'SAIR PARA A ÁREA DE TRABALHO';

  @override
  String get selectSkin => 'ESCOLHA O VISUAL';

  @override
  String get difficulty => 'DIFICULDADE';

  @override
  String get difficultyEasy => 'FÁCIL';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'DIFÍCIL';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPANHA';

  @override
  String get quit => 'SAIR';

  @override
  String get restorePurchases => 'RESTAURAR COMPRAS';

  @override
  String get locked => 'BLOQUEADO';

  @override
  String get mainMenuTooltip => 'Menu principal';

  @override
  String nodeLevel(int level) {
    return 'NÍVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NÍVEL $level · CHEFE $ordinal';
  }

  @override
  String get nodeLockedHint => 'Bloqueado. Conclua antes a missão anterior.';

  @override
  String get flyAgain => 'VOAR DE NOVO';

  @override
  String get launch => 'DECOLAR';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'ESTRELA';

  @override
  String get continueButton => 'CONTINUAR';

  @override
  String get replayNode => 'REPETIR MISSÃO';

  @override
  String get retry => 'TENTAR DE NOVO';

  @override
  String get nodeCleared => 'MISSÃO CUMPRIDA';

  @override
  String get nodeFailed => 'MISSÃO FRACASSADA';

  @override
  String get weaponTierUnlocked => 'NOVO NÍVEL DE ARMAS';

  @override
  String get onSaleInComCenter => 'À venda no Centro de Comando.';

  @override
  String get requiredTasksHint =>
      'As tarefas obrigatórias decidem a missão. Voe de novo: o que você ganhou fica com você.';

  @override
  String get objClear => 'Limpe o setor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abata $count inimigos',
      one: 'Abata 1 inimigo',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Não sofra dano no casco';

  @override
  String objHull(int percent) {
    return 'Termine com mais de $percent% de casco';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimine $count com $weapon',
      one: 'Elimine 1 com $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimine $count com as armas laterais',
      one: 'Elimine 1 com as armas laterais',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Decole com $weapon na frente';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Decole com $weapon na lateral';
  }

  @override
  String get objBuySideGun => 'Compre uma arma lateral no Centro de Comando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Melhore o gerador até o nível $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Melhore a arma frontal até o nível $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Melhore uma arma lateral até o nível $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pegue $count itens',
      one: 'Pegue 1 item',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Destrua $count formações inteiras',
      one: 'Destrua 1 formação inteira',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Não bata em asteroides';

  @override
  String objUnderTime(int seconds) {
    return 'Termine em até $seconds s';
  }

  @override
  String get objStripBoss => 'Destrua todas as partes do chefe antes do núcleo';

  @override
  String get joinCoopTitle => 'Entrar no co-op';

  @override
  String get cannotSearchNetwork => 'Não é possível buscar nesta rede';

  @override
  String get joinHintNearby =>
      'A mesma rede Wi-Fi funciona em qualquer aparelho. iPhone, iPad e Mac também se encontram por proximidade sem ela, com o Acesso Pessoal desligado nos dois.';

  @override
  String get joinHintWifi =>
      'Os dois jogadores precisam estar na mesma rede Wi-Fi; o Acesso Pessoal também funciona.';

  @override
  String noHostsYet(String hint) {
    return 'Nenhum anfitrião ainda. $hint';
  }

  @override
  String get lookingForHosts =>
      'Procurando anfitriões nesta Wi-Fi e por perto…';

  @override
  String get hostNearby => 'Por perto · Bluetooth / Wi-Fi ponto a ponto';

  @override
  String hostSameWifi(String address) {
    return '$address · mesma Wi-Fi';
  }

  @override
  String get enterIpManually => 'Digitar IP manualmente';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'ENE';

  @override
  String get hudGen => 'GER';

  @override
  String bossShielded(String name) {
    return '$name — BLINDADO';
  }

  @override
  String get bossPartTurret => 'Torreta';

  @override
  String get bossPartShieldPod => 'Módulo de escudo';

  @override
  String get bossPartThruster => 'Propulsor';

  @override
  String get bossPartCannon => 'Canhão';

  @override
  String sectorUnknownSpace(int level) {
    return 'Setor $level — Espaço desconhecido';
  }

  @override
  String get player2Joined => 'O jogador 2 entrou!';

  @override
  String get player2Disconnected => 'O jogador 2 se desconectou';

  @override
  String get hostDisconnected => 'O anfitrião se desconectou';

  @override
  String maxLevelSold(String amount) {
    return 'Nível máx.! Vendido por \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Nível de armas $tier desbloqueado';
  }

  @override
  String get cheatsEnabled => 'Trapaças ativadas';

  @override
  String get cheatsDisabled => 'Trapaças desativadas';

  @override
  String get cheatsMaxed =>
      'TRAPAÇA: créditos no máximo, todas as armas desbloqueadas';

  @override
  String get cheats => 'TRAPAÇAS';

  @override
  String get maxCredits => 'CRÉDITOS MÁX.';

  @override
  String get sectionStats => 'ATRIBUTOS';

  @override
  String get sectionLoadout => 'ARMAMENTO';

  @override
  String get sectionOutfitting => 'EQUIPAMENTO';

  @override
  String get sectionShop => 'LOJA';

  @override
  String get tabFront => 'FRENTE';

  @override
  String get tabSide => 'LATERAL';

  @override
  String get tabGen => 'GER';

  @override
  String get sideLeft => 'ESQ.';

  @override
  String get sideRight => 'DIR.';

  @override
  String get noWeaponInstalled => 'NENHUMA ARMA INSTALADA';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'DANO:$damage VEL:$speed';
  }

  @override
  String statPower(int power) {
    return 'ENE:$power';
  }

  @override
  String get beam => 'RAIO';

  @override
  String get guided => 'TELEGUIADA';

  @override
  String get owned => 'ADQUIRIDA';

  @override
  String get max => 'MÁX';

  @override
  String get upgrade => 'MELHORAR';

  @override
  String get upgradeShort => 'MELH';

  @override
  String get sell => 'VENDER';

  @override
  String get buy => 'COMPRAR';

  @override
  String get noCredits => 'SEM CRÉDITOS';

  @override
  String get commandCenter => 'CENTRO DE COMANDO';

  @override
  String get pilot => 'Piloto';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PONTOS';

  @override
  String get nextWeapon => 'PRÓXIMA ARMA';

  @override
  String pointsValue(String points) {
    return '$points pts';
  }

  @override
  String get slotFront => 'Frente';

  @override
  String get slotLeft => 'Esq.';

  @override
  String get slotRight => 'Dir.';

  @override
  String get slotGen => 'Ger';

  @override
  String get power => 'ENE';

  @override
  String get generator => 'GERADOR';

  @override
  String genOutput(String value) {
    return 'ENE: +$value/qd';
  }

  @override
  String genCapacity(int value) {
    return 'Cap.: $value';
  }

  @override
  String get launchMission => 'LANÇAR MISSÃO';

  @override
  String get startMission => 'INICIAR MISSÃO';

  @override
  String get continueMission => 'CONTINUAR MISSÃO';

  @override
  String get padControlsHint =>
      '[↑↓] Escolher   [←→] Colunas   [LB/RB] Abas   [A] Slot E/D    —    [B] Comprar/melhorar   [X/Y] Vender   [OPTIONS] Continuar';

  @override
  String get host => 'HOSPEDAR';

  @override
  String hostingAs(String name) {
    return 'ANFITRIÃO: $name';
  }

  @override
  String get join => 'ENTRAR';
}
