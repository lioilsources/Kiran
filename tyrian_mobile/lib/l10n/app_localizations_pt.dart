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
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MÁX';

  @override
  String get upgradeShort => 'MELH';

  @override
  String get sell => 'VENDER';

  @override
  String get buy => 'COMPRAR';

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
  String get launchMission => 'LANÇAR MISSÃO';

  @override
  String get startMission => 'INICIAR MISSÃO';

  @override
  String get continueMission => 'CONTINUAR MISSÃO';

  @override
  String get padControlsHint =>
      '[↑↓] Linha   [←→] Escolher   [B] Comprar/Melhorar/Trocar   [X/Y] Vender   [OPTIONS] Continuar';

  @override
  String get host => 'HOSPEDAR';

  @override
  String hostingAs(String name) {
    return 'ANFITRIÃO: $name';
  }

  @override
  String get join => 'ENTRAR';

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
    return '$weapon DESLIGADO — gerador fraco demais';
  }

  @override
  String unlocksAt(String points) {
    return 'Desbloqueia com $points pts';
  }

  @override
  String joinConnecting(String target) {
    return 'Conectando a $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'O anfitrião não respondeu: $reason.\n\nOs dois jogadores precisam estar na mesma Wi-Fi (um Acesso Pessoal também serve) e o anfitrião precisa ter tocado em HOST. Verifique o endereço e tente de novo.';
  }

  @override
  String get lanJoinNoAnswer => 'sem resposta';

  @override
  String objBossUnder(int seconds) {
    return 'Destrói o núcleo do chefe em $seconds s após sua chegada';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'COFRE';

  @override
  String get rackSide => 'Lateral';

  @override
  String get rackHull => 'Casco';

  @override
  String get rarityCommon => 'COMUM';

  @override
  String get rarityRare => 'RARO';

  @override
  String get rarityMythic => 'MÍTICO';

  @override
  String get curse => 'MALDIÇÃO';

  @override
  String get modFit => 'EQUIPAR';

  @override
  String get modUnfit => 'REMOVER';

  @override
  String get modForge => 'FORJA';

  @override
  String get forgeHint => 'Escolha 3 de uma raridade para forjar 1 da seguinte';

  @override
  String get vaultEmpty =>
      'Nenhum mod ainda. Conclua um nó com todas as estrelas, vença um chefe rápido ou derrube um chefe no modo infinito.';

  @override
  String modNeeds(String families) {
    return 'Funciona com $families';
  }

  @override
  String get modRackFull => 'Rack cheio';

  @override
  String get modAlreadyFitted => 'Já equipado';

  @override
  String get modWrongRack => 'Não cabe neste rack';

  @override
  String modsSpilled(int n) {
    return '$n mods de volta ao cofre';
  }

  @override
  String get hullLocked => 'Bloqueado';

  @override
  String hullUnlockBoss(int n) {
    return 'Vença o chefe da campanha $n';
  }

  @override
  String get hullUnlockFinish => 'Termine a campanha ou chegue ao setor 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'ALV';

  @override
  String get perkNone => 'Nave padrão';

  @override
  String get perkAfterimage => 'Parado: tiros ×1,5';

  @override
  String get perkBulwark => 'Dano além do escudo cai pela metade';

  @override
  String get perkOverclock =>
      'Dispara armas até 130 % da capacidade, mais devagar';

  @override
  String get perkBattery => 'Um drone grátis acompanha você';

  @override
  String get rewardTitle => 'RECOMPENSA';

  @override
  String newHull(String name) {
    return 'Novo casco: $name';
  }

  @override
  String get socketEmpty => 'vazio';

  @override
  String fxStreams(int n) {
    return '$n fluxos paralelos';
  }

  @override
  String fxFan(int n) {
    return 'Leque de $n tiros';
  }

  @override
  String fxSalvo(int n) {
    return 'Rajada de $n tiros';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadência ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Dano ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Velocidade do tiro ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Tamanho do tiro ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consumo ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Teleguiado +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Atravessa $n alvos';
  }

  @override
  String get fxPierceAll => 'Atravessa tudo';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % de chance de dano ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Críticos ×$x em chefes';
  }

  @override
  String fxFork(int n) {
    return 'Abates espalham $n tiros';
  }

  @override
  String get fxChain => 'Tiros espalhados espalham de novo';

  @override
  String get fxSplit => 'Divide-se em dois ao acertar';

  @override
  String get fxFrost => 'Acertos desaceleram o inimigo';

  @override
  String get fxCrossfire => 'Armas laterais miram o centro';

  @override
  String get fxRearguard => 'Armas laterais também atiram para trás';

  @override
  String get fxOrbit => 'Os tiros ondulam';

  @override
  String fxBounce(int n) {
    return 'Ricocheteia nas paredes $n×';
  }

  @override
  String get fxBounceTop => '…e no topo';

  @override
  String get fxOverdrive => 'Dispara mesmo com dívida de energia';

  @override
  String get fxReactor => 'Armas acima da capacidade disparam, devagar';

  @override
  String fxGenPower(String x) {
    return 'Recarga do gerador ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacidade do gerador ×$x';
  }

  @override
  String get fxSurge => 'Gerador cheio: tiros ×2';

  @override
  String fxSiphon(int pct) {
    return 'Abates recarregam $pct % de energia';
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
    return 'Regeneração do escudo ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Abates curam $n PV';
  }

  @override
  String get fxMagnet => 'Atrai os itens';

  @override
  String get fxMagnetAll => 'Atrai todos os itens';

  @override
  String fxReflect(int pct) {
    return '$pct % dos tiros voltam do escudo';
  }

  @override
  String get fxReflectGuided => 'Tiros refletidos são teleguiados';

  @override
  String fxGhost(String sec) {
    return 'Invulnerável $sec s após um golpe no casco';
  }

  @override
  String get fxNova => 'Escudo quebrado: explosão na tela inteira';

  @override
  String fxAgility(String x) {
    return 'Agilidade ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Área de acerto ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Créditos ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Pontos ×$x';
  }

  @override
  String get fxSatellite => 'Um drone de combate acompanha você';

  @override
  String get fxTimewarp => 'Golpe no casco desacelera o tempo';

  @override
  String get fxGambler => 'Cada tiro é uma arma aleatória';

  @override
  String get vaultAll => 'TODOS';

  @override
  String get sigilMissUnknown => 'forma desconhecida';

  @override
  String get sigilMissTooSlow => 'lento demais';

  @override
  String get sigilMissSkippedDot => 'ponto pulado';

  @override
  String get sigilMissLeftRimEarly => 'soltou cedo demais';

  @override
  String get sigilMissWrongDirection => 'desenhado ao contrário';

  @override
  String get sigilMissWrongLayer => 'botão de ombro errado';

  @override
  String get sigilDry => 'carga insuficiente';

  @override
  String get sigilBusy => 'o anterior ainda está ativo';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'PARTES DO CHEFE';

  @override
  String get arenaBareCore => 'só o núcleo';

  @override
  String get arenaCompanions => 'COMPANHEIROS';

  @override
  String get arenaCharge => 'CARGA';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VELOCIDADE';

  @override
  String get arenaDrill => 'TREINO';

  @override
  String get arenaFreePlay => 'LIVRE';

  @override
  String get arenaFight => 'LUTAR';

  @override
  String get arenaNewBoss => 'NOVO CHEFE';

  @override
  String get arenaLeave => 'SAIR DA ARENA';

  @override
  String get arenaHint => 'O chefe volta assim que cai. Nada aqui é salvo.';

  @override
  String get arenaColCast => 'LANÇADOS';

  @override
  String get arenaColMiss => 'FALHAS';

  @override
  String get arenaColAvg => 'MÉDIA';

  @override
  String get arenaColBest => 'MELHOR';

  @override
  String get arenaColTime => 'MAIS RÁPIDO';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Chefes $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'CONTROLE: SIGILOS';

  @override
  String get padSchemeClassic => 'CONTROLE: CLÁSSICO';

  @override
  String get padSouthpawOn => 'CANHOTO: SIM';

  @override
  String get padSouthpawOff => 'CANHOTO: NÃO';

  @override
  String get sigilDescHop => 'Um salto rápido na direção do analógico';

  @override
  String get sigilDescSidestep => 'Um longo passo lateral pelo campo';

  @override
  String get sigilDescStrike =>
      'Investida à frente com três tiros pesados, e volta';

  @override
  String get sigilDescRetreat =>
      'Recue enquanto o fogo de cobertura vai à frente';

  @override
  String get sigilDescDash =>
      'Arrancada diagonal pelo fogo, invulnerável no meio';

  @override
  String get sigilDescRoll => 'Um tonneau para o lado, invulnerável';

  @override
  String get sigilDescShadow =>
      'Grude sob o inimigo mais próximo e continue atirando';

  @override
  String get sigilDescEcho =>
      'Uma sombra repete seus últimos dois segundos com metade do dano';

  @override
  String get sigilDescLoop =>
      'Um looping por cima: os tiros passam por baixo de você';

  @override
  String get sigilDescSlalom => 'Uma curva em S pelo campo com tiros em leque';

  @override
  String get sigilDescCorkscrew =>
      'Saca-rolhas à frente atirando para todo lado, invulnerável';

  @override
  String get sigilDescSnapshot => 'Um tiro pesado na direção do analógico';

  @override
  String get sigilDescBroadside => 'Uma rajada pelos dois flancos';

  @override
  String get sigilDescVolley => 'Cinco raios carregados à frente';

  @override
  String get sigilDescCaltrop => 'Solte uma mina que engole tiros e explode';

  @override
  String get sigilDescFrenzy =>
      'As armas atiram mais rápido por alguns segundos';

  @override
  String get sigilDescStasis =>
      'Inimigos e seus tiros caem para metade da velocidade';

  @override
  String get sigilDescHalo =>
      'O escudo recarrega quatro vezes mais rápido e nada passa';

  @override
  String get sigilDescRadial => 'Um anel de dezesseis tiros';

  @override
  String get sigilDescStorm => 'Todas as armas atiram no máximo, de graça';

  @override
  String get sigilDescPing =>
      'Os companheiros concentram fogo na direção do analógico';

  @override
  String get sigilDescWingman => 'Chame um ala para o flanco que você desenhou';

  @override
  String get sigilDescHunter =>
      'Chame um caçador que voa à frente e escolhe alvos';

  @override
  String get sigilDescWarden =>
      'Chame um guardião que leva os tiros mirados em você';

  @override
  String get sigilDescFormation =>
      'Os companheiros alternam formação aberta e em cunha';

  @override
  String get sigilDescWhirl => 'Os companheiros circulam você e absorvem tiros';

  @override
  String get sigilDescSacrifice =>
      'Os companheiros mergulham e explodem, devolvendo carga';

  @override
  String get grimoire => 'GRIMÓRIO';

  @override
  String get grimoireHint =>
      'Desenhe com o analógico direito. Segure LB para ARMS, RB para WING, ambos para MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'custo $cost';
  }

  @override
  String get sigilUntouchable => 'invulnerável';

  @override
  String get lessonWatch => 'OBSERVE';

  @override
  String get lessonTrace => 'DECALQUE';

  @override
  String get lessonSlow => 'DEVAGAR';

  @override
  String get lessonLive => 'VELOCIDADE TOTAL';

  @override
  String get lessonStreak => 'CINCO SEGUIDAS';

  @override
  String get lessonLearned => 'APRENDIDO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Dê um toque no analógico direito';

  @override
  String get hintLoop => 'Desenhe um círculo: você passa por cima dos tiros';

  @override
  String get hintStream => 'Aperte LT: duas ou três rajadas';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NENHUMA';

  @override
  String kataNext(String sigil, String secs) {
    return 'próximo $sigil em $secs s';
  }

  @override
  String get arenaGauntlet => 'DESAFIO';

  @override
  String get arenaOn => 'SIM';

  @override
  String get arenaOff => 'NÃO';

  @override
  String gauntletRating(int rating, int best) {
    return 'Nota $rating · melhor $best';
  }

  @override
  String get duelWarning => 'ALERTA';

  @override
  String get duelHintPad1 => 'O analógico direito mira e dispara';

  @override
  String get duelHintPad2Rt =>
      'Segure RT, LB ou RB: o analógico direito desenha sigilos';

  @override
  String get duelHintPad2Lt =>
      'Segure LT, LB ou RB: o analógico direito desenha sigilos';

  @override
  String get duelHintClassic =>
      'O analógico esquerdo voa · B, RB ou RT disparam para onde o nariz aponta';

  @override
  String get duelHintKeys1 => 'As setas miram e disparam · WASD voa';

  @override
  String get duelHintKeys2 =>
      'Espaço dispara para onde o nariz aponta · o teclado numérico desenha sigilos';

  @override
  String get arenaDuelBinding => 'POSTURA DE DUELO';

  @override
  String get duelBindingRt => 'RT + ANALÓGICO';

  @override
  String get duelBindingLt => 'LT + ANALÓGICO';

  @override
  String get arenaDuelFrame => 'FRENTE NO CONTROLE';

  @override
  String get duelFrameNose => 'O NARIZ';

  @override
  String get duelFrameUp => 'CIMA';

  @override
  String get arenaDuelAimFires => 'MIRAR DISPARA';

  @override
  String get duelCutInFirst => 'CLOSE DO CHEFE: PRIMEIRA VEZ';

  @override
  String get duelCutInAlways => 'CLOSE DO CHEFE: SEMPRE';

  @override
  String get duelCutInNever => 'CLOSE DO CHEFE: NUNCA';

  @override
  String get arenaDuelDrill => 'TREINO DE DUELO';

  @override
  String get duelDrillOff => 'NENHUM';

  @override
  String get duelDrillAim => 'MIRE E DISPARE';

  @override
  String get duelDrillAimHow =>
      'Aponte o analógico direito para o chefe e acerte';

  @override
  String get duelDrillHold => 'SEGURE O NARIZ';

  @override
  String get duelDrillHoldHow =>
      'Segure um botão de postura e voe: o nariz fica parado';

  @override
  String get duelDrillDraw => 'DESENHE PARA A FRENTE';

  @override
  String get duelDrillDrawHow =>
      'Na postura, desenhe um sigilo na direção do chefe';

  @override
  String get duelDrillTurn => 'VIRE-SE';

  @override
  String get duelDrillTurnHow =>
      'O chefe está abaixo de você: vire o nariz e acerte';

  @override
  String get duelDrillDone => 'FEITO';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get connect => 'LIGAR';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Não foi possível ligar a $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'O anfitrião estava visível, mas a ligação não foi estabelecida.\n\nO jogo por proximidade precisa de Wi-Fi ponto a ponto, que o iOS desliga enquanto a Zona Wi-Fi pessoal está ativa — desative-a nos dois dispositivos e tente novamente, ou ligue ambos à mesma rede Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Missão falhada — equipamento e créditos mantidos. Tente novamente a partir do Centro de Comando.';

  @override
  String get gameOverEndless =>
      'A reconstruir no Setor 1 — equipamento e créditos mantidos';

  @override
  String get waitingForHost => 'À espera do anfitrião...';

  @override
  String get waitingForHostHint =>
      'O jogo começa quando o anfitrião estiver pronto';

  @override
  String get vesselLost => 'NAVE PERDIDA';

  @override
  String scoreValue(String score) {
    return 'Pontuação: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Créditos: $credits';
  }

  @override
  String get creditsPrefix => 'Créditos: ';

  @override
  String get leaderboard => 'CLASSIFICAÇÃO';

  @override
  String get achievements => 'CONQUISTAS';

  @override
  String get redeploy => 'VOLTAR AO COMBATE';

  @override
  String get resume => 'RETOMAR';

  @override
  String get pause => 'PAUSA';

  @override
  String get paused => 'EM PAUSA';

  @override
  String get skins => 'ASPETOS';

  @override
  String get skin => 'ASPETO';

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
  String get quitToDesktop => 'SAIR PARA O AMBIENTE DE TRABALHO';

  @override
  String get selectSkin => 'ESCOLHER ASPETO';

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
  String get nodeLockedHint => 'Bloqueado. Conclua primeiro o nó anterior.';

  @override
  String get flyAgain => 'VOAR DE NOVO';

  @override
  String get launch => 'DESCOLAR';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'ESTRELA';

  @override
  String get continueButton => 'CONTINUAR';

  @override
  String get replayNode => 'REPETIR NÓ';

  @override
  String get retry => 'TENTAR DE NOVO';

  @override
  String get nodeCleared => 'NÓ CONCLUÍDO';

  @override
  String get nodeFailed => 'NÓ FALHADO';

  @override
  String get weaponTierUnlocked => 'NÍVEL DE ARMAS DESBLOQUEADO';

  @override
  String get onSaleInComCenter => 'À venda no Centro de Comando.';

  @override
  String get requiredTasksHint =>
      'As tarefas obrigatórias decidem o nó. Volte a voá-lo — o que ganhou fica consigo.';

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
  String get objUntouched => 'Não sofra danos no casco';

  @override
  String objHull(int percent) {
    return 'Termine com mais de $percent% de casco';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimine $count com a $weapon',
      one: 'Elimine 1 com a $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimine $count com os canhões laterais',
      one: 'Elimine 1 com os canhões laterais',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Descole com a $weapon à frente';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Descole com a $weapon num suporte lateral';
  }

  @override
  String get objBuySideGun => 'Compre um canhão lateral no Centro de Comando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Melhore o gerador até ao nível $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Melhore o canhão frontal até ao nível $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Melhore um canhão lateral até ao nível $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apanhe $count bónus',
      one: 'Apanhe 1 bónus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimine $count formações inteiras',
      one: 'Elimine 1 formação inteira',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Não embata em nenhum asteroide';

  @override
  String objUnderTime(int seconds) {
    return 'Termine em $seconds s';
  }

  @override
  String get objStripBoss => 'Destrua todas as partes do chefe antes do núcleo';

  @override
  String get joinCoopTitle => 'Entrar em cooperativo';

  @override
  String get cannotSearchNetwork => 'Não é possível pesquisar nesta rede';

  @override
  String get joinHintNearby =>
      'A mesma rede Wi-Fi funciona em qualquer dispositivo. iPhone, iPad e Mac também se encontram por proximidade sem ela — com a Zona Wi-Fi pessoal desativada em ambos.';

  @override
  String get joinHintWifi =>
      'Os dois jogadores têm de estar na mesma rede Wi-Fi — uma Zona Wi-Fi pessoal também serve.';

  @override
  String noHostsYet(String hint) {
    return 'Ainda sem anfitriões. $hint';
  }

  @override
  String get lookingForHosts =>
      'À procura de anfitriões nesta rede Wi-Fi e por perto…';

  @override
  String get hostNearby => 'Por perto · Bluetooth / Wi-Fi ponto a ponto';

  @override
  String hostSameWifi(String address) {
    return '$address · mesma rede Wi-Fi';
  }

  @override
  String get enterIpManually => 'Introduzir IP manualmente';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GER';

  @override
  String bossShielded(String name) {
    return '$name — COM ESCUDO';
  }

  @override
  String get bossPartTurret => 'Torre';

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
  String get player2Disconnected => 'O jogador 2 desligou-se';

  @override
  String get hostDisconnected => 'O anfitrião desligou-se';

  @override
  String maxLevelSold(String amount) {
    return 'Nível máx.! Vendido por \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Nível de armas $tier desbloqueado';
  }

  @override
  String get cheatsEnabled => 'Batotas ativadas';

  @override
  String get cheatsDisabled => 'Batotas desativadas';

  @override
  String get cheatsMaxed =>
      'BATOTA: créditos no máximo, todas as armas desbloqueadas';

  @override
  String get cheats => 'BATOTAS';

  @override
  String get maxCredits => 'CRÉDITOS MÁX.';

  @override
  String get sectionStats => 'ESTATÍSTICAS';

  @override
  String get sectionLoadout => 'EQUIPAMENTO';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MÁX';

  @override
  String get upgradeShort => 'MELH';

  @override
  String get sell => 'VENDER';

  @override
  String get buy => 'COMPRAR';

  @override
  String get commandCenter => 'CENTRO DE COMANDO';

  @override
  String get pilot => 'Piloto';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PONTUAÇÃO';

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
  String get power => 'EN';

  @override
  String get launchMission => 'LANÇAR MISSÃO';

  @override
  String get startMission => 'INICIAR MISSÃO';

  @override
  String get continueMission => 'CONTINUAR MISSÃO';

  @override
  String get padControlsHint =>
      '[↑↓] Linha   [←→] Escolher   [B] Comprar/Melhorar/Trocar   [X/Y] Vender   [OPTIONS] Continuar missão';

  @override
  String get host => 'ALOJAR';

  @override
  String hostingAs(String name) {
    return 'A ALOJAR como $name';
  }

  @override
  String get join => 'ENTRAR';

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
    return '$weapon DESLIGADA — gerador demasiado fraco';
  }

  @override
  String unlocksAt(String points) {
    return 'Desbloqueia aos $points pts';
  }

  @override
  String joinConnecting(String target) {
    return 'A ligar a $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'O anfitrião não respondeu: $reason.\n\nOs dois jogadores têm de estar na mesma rede Wi-Fi (uma Zona Wi-Fi pessoal também serve) e o anfitrião tem de ter premido ALOJAR. Verifique o endereço e tente novamente.';
  }

  @override
  String get lanJoinNoAnswer => 'sem resposta';

  @override
  String objBossUnder(int seconds) {
    return 'Destrua o núcleo do chefe em $seconds s após a sua chegada';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'COFRE';

  @override
  String get rackSide => 'Lateral';

  @override
  String get rackHull => 'Casco';

  @override
  String get rarityCommon => 'COMUM';

  @override
  String get rarityRare => 'RARO';

  @override
  String get rarityMythic => 'MÍTICO';

  @override
  String get curse => 'MALDIÇÃO';

  @override
  String get modFit => 'MONTAR';

  @override
  String get modUnfit => 'DESMONTAR';

  @override
  String get modForge => 'FORJA';

  @override
  String get forgeHint =>
      'Escolha 3 da mesma raridade para forjar 1 da seguinte';

  @override
  String get vaultEmpty =>
      'Ainda sem mods. Conclua um nó com todas as estrelas, derrote um chefe depressa ou abata um chefe no modo infinito.';

  @override
  String modNeeds(String families) {
    return 'Funciona com $families';
  }

  @override
  String get modRackFull => 'Suporte cheio';

  @override
  String get modAlreadyFitted => 'Já montado';

  @override
  String get modWrongRack => 'Não encaixa neste suporte';

  @override
  String modsSpilled(int n) {
    return '$n mods de volta ao cofre';
  }

  @override
  String get hullLocked => 'Bloqueado';

  @override
  String hullUnlockBoss(int n) {
    return 'Derrote o chefe de campanha $n';
  }

  @override
  String get hullUnlockFinish => 'Conclua a campanha ou chegue ao setor 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'ALVO';

  @override
  String get perkNone => 'Nave de série';

  @override
  String get perkAfterimage => 'Fique parado: disparos ×1,5';

  @override
  String get perkBulwark => 'O dano que passa o escudo é reduzido a metade';

  @override
  String get perkOverclock => 'Dispara até 130 % da capacidade, mais devagar';

  @override
  String get perkBattery => 'Um drone de combate gratuito acompanha-o';

  @override
  String get rewardTitle => 'RECOMPENSA';

  @override
  String newHull(String name) {
    return 'Novo casco: $name';
  }

  @override
  String get socketEmpty => 'vazio';

  @override
  String fxStreams(int n) {
    return '$n feixes paralelos';
  }

  @override
  String fxFan(int n) {
    return 'Leque de $n disparos';
  }

  @override
  String fxSalvo(int n) {
    return 'Salva de $n disparos';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadência ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Dano ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Velocidade dos disparos ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Tamanho dos disparos ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consumo de energia ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Teleguiado +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Atravessa $n alvos';
  }

  @override
  String get fxPierceAll => 'Atravessa tudo';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % de hipótese de dano ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Críticos ×$x em chefes';
  }

  @override
  String fxFork(int n) {
    return 'Abates espalham $n disparos';
  }

  @override
  String get fxChain => 'Disparos espalhados voltam a espalhar-se';

  @override
  String get fxSplit => 'Divide-se em dois ao acertar';

  @override
  String get fxFrost => 'Os impactos abrandam os inimigos';

  @override
  String get fxCrossfire => 'Os canhões laterais apontam para dentro';

  @override
  String get fxRearguard => 'Os canhões laterais também disparam para trás';

  @override
  String get fxOrbit => 'Os disparos serpenteiam';

  @override
  String fxBounce(int n) {
    return 'Ressalta nas paredes $n×';
  }

  @override
  String get fxBounceTop => '…e no topo';

  @override
  String get fxOverdrive => 'Dispara a crédito de energia';

  @override
  String get fxReactor =>
      'Armas acima da capacidade disparam na mesma, devagar';

  @override
  String fxGenPower(String x) {
    return 'Recarga do gerador ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacidade do gerador ×$x';
  }

  @override
  String get fxSurge => 'Gerador cheio: disparos ×2';

  @override
  String fxSiphon(int pct) {
    return 'Abates repõem $pct % de energia';
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
    return 'Regeneração do escudo ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Abates curam $n HP';
  }

  @override
  String get fxMagnet => 'Atrai os bónus';

  @override
  String get fxMagnetAll => 'Atrai todos os bónus';

  @override
  String fxReflect(int pct) {
    return '$pct % dos disparos ressaltam no escudo';
  }

  @override
  String get fxReflectGuided => 'Disparos refletidos são teleguiados';

  @override
  String fxGhost(String sec) {
    return 'Intocável $sec s após um impacto no casco';
  }

  @override
  String get fxNova => 'O escudo parte-se: explosão em todo o ecrã';

  @override
  String fxAgility(String x) {
    return 'Agilidade ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Área de impacto ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Créditos ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Pontuação ×$x';
  }

  @override
  String get fxSatellite => 'Um drone de combate acompanha-o';

  @override
  String get fxTimewarp => 'Um impacto no casco abranda o tempo';

  @override
  String get fxGambler => 'Cada disparo é uma arma aleatória';

  @override
  String get vaultAll => 'TODOS';

  @override
  String get sigilMissUnknown => 'forma desconhecida';

  @override
  String get sigilMissTooSlow => 'demasiado lento';

  @override
  String get sigilMissSkippedDot => 'saltou um ponto';

  @override
  String get sigilMissLeftRimEarly => 'largou cedo demais';

  @override
  String get sigilMissWrongDirection => 'desenhado ao contrário';

  @override
  String get sigilMissWrongLayer => 'botão de ombro errado';

  @override
  String get sigilDry => 'carga insuficiente';

  @override
  String get sigilBusy => 'o anterior ainda está ativo';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'PARTES DO CHEFE';

  @override
  String get arenaBareCore => 'núcleo exposto';

  @override
  String get arenaCompanions => 'COMPANHEIROS';

  @override
  String get arenaCharge => 'CARGA';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'VELOCIDADE DO MUNDO';

  @override
  String get arenaDrill => 'TREINO';

  @override
  String get arenaFreePlay => 'JOGO LIVRE';

  @override
  String get arenaFight => 'COMBATER';

  @override
  String get arenaNewBoss => 'NOVO CHEFE';

  @override
  String get arenaLeave => 'SAIR DA ARENA';

  @override
  String get arenaHint =>
      'O chefe volta assim que morre. Nada aqui é guardado.';

  @override
  String get arenaColCast => 'USOS';

  @override
  String get arenaColMiss => 'FALHAS';

  @override
  String get arenaColAvg => 'MÉDIA';

  @override
  String get arenaColBest => 'MELHOR';

  @override
  String get arenaColTime => 'MAIS RÁPIDO';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Chefes $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'COMANDO: SIGILOS';

  @override
  String get padSchemeClassic => 'COMANDO: CLÁSSICO';

  @override
  String get padSouthpawOn => 'CANHOTO: SIM';

  @override
  String get padSouthpawOff => 'CANHOTO: NÃO';

  @override
  String get sigilDescHop => 'Um salto rápido na direção do gesto';

  @override
  String get sigilDescSidestep => 'Um longo passo lateral pelo campo';

  @override
  String get sigilDescStrike => 'Investida com três tiros pesados e regresso';

  @override
  String get sigilDescRetreat => 'Recua enquanto o fogo de cobertura avança';

  @override
  String get sigilDescDash => 'Arranque diagonal pelo fogo, intocável a meio';

  @override
  String get sigilDescRoll => 'Um tonneau para o lado, intocável';

  @override
  String get sigilDescShadow => 'Fixa-se sob o inimigo mais próximo e dispara';

  @override
  String get sigilDescEcho =>
      'Uma sombra repete os teus últimos dois segundos com metade do dano';

  @override
  String get sigilDescLoop => 'Looping por cima: os tiros passam por baixo';

  @override
  String get sigilDescSlalom => 'Uma curva em S pelo campo com fogo em leque';

  @override
  String get sigilDescCorkscrew =>
      'Saca-rolhas em frente a disparar em redor, intocável';

  @override
  String get sigilDescSnapshot => 'Um tiro pesado na direção do gesto';

  @override
  String get sigilDescBroadside => 'Uma salva pelos dois flancos';

  @override
  String get sigilDescVolley => 'Cinco raios carregados em frente';

  @override
  String get sigilDescCaltrop => 'Larga uma mina que engole tiros e explode';

  @override
  String get sigilDescFrenzy =>
      'As armas disparam mais depressa por uns segundos';

  @override
  String get sigilDescStasis =>
      'Inimigos e os seus tiros a metade da velocidade';

  @override
  String get sigilDescHalo =>
      'O escudo recarrega quatro vezes mais rápido e nada passa';

  @override
  String get sigilDescRadial => 'Um anel de dezasseis tiros';

  @override
  String get sigilDescStorm => 'Todas as armas a fundo, de graça';

  @override
  String get sigilDescPing =>
      'Os companheiros concentram fogo na direção do gesto';

  @override
  String get sigilDescWingman => 'Chama um ala para o flanco desenhado';

  @override
  String get sigilDescHunter =>
      'Chama um caçador que voa à frente e escolhe alvos';

  @override
  String get sigilDescWarden => 'Chama um guardião que leva os tiros por ti';

  @override
  String get sigilDescFormation =>
      'Os companheiros alternam entre aberta e cunha';

  @override
  String get sigilDescWhirl =>
      'Os companheiros giram à tua volta e absorvem tiros';

  @override
  String get sigilDescSacrifice =>
      'Os companheiros mergulham e explodem, devolvendo carga';

  @override
  String get grimoire => 'GRIMÓRIO';

  @override
  String get grimoireHint =>
      'Desenha com o stick direito. LB para ARMAS, RB para ALAS, ambos para MEGA RAJADA.';

  @override
  String sigilCost(int cost) {
    return 'custo $cost';
  }

  @override
  String get sigilUntouchable => 'intocável';

  @override
  String get lessonWatch => 'OBSERVA';

  @override
  String get lessonTrace => 'DESENHA';

  @override
  String get lessonSlow => 'LENTO';

  @override
  String get lessonLive => 'VELOCIDADE TOTAL';

  @override
  String get lessonStreak => 'CINCO SEGUIDOS';

  @override
  String get lessonLearned => 'APRENDIDO';

  @override
  String lessonTempo(int pct) {
    return 'RITMO $pct %';
  }

  @override
  String get hintHop => 'Move rápido o stick direito';

  @override
  String get hintLoop => 'Desenha um círculo: voas por cima dos tiros';

  @override
  String get hintStream => 'Prime LT: dois ou três feixes';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NENHUM';

  @override
  String kataNext(String sigil, String secs) {
    return 'próximo $sigil em $secs s';
  }

  @override
  String get arenaGauntlet => 'DESAFIO';

  @override
  String get arenaOn => 'SIM';

  @override
  String get arenaOff => 'NÃO';

  @override
  String gauntletRating(int rating, int best) {
    return 'Nota $rating · melhor $best';
  }
}
