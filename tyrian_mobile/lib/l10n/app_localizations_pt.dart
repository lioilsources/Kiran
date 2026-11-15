// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get cancel => 'CANCELAR';

  @override
  String get connect => 'CONECTAR';

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
  String get statsOn => 'ESTATÍSTICAS: LIGADAS';

  @override
  String get statsOff => 'ESTATÍSTICAS: DESLIGADAS';

  @override
  String get quitToDesktop => 'SAIR PARA A ÁREA DE TRABALHO';

  @override
  String get selectSkin => 'ESCOLHA O VISUAL';

  @override
  String get quit => 'SAIR';

  @override
  String get restorePurchases => 'RESTAURAR COMPRAS';

  @override
  String get locked => 'BLOQUEADO';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'ESC';

  @override
  String get hudPower => 'ENE';

  @override
  String get hudGen => 'GER';

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
  String get startMission => 'INICIAR MISSÃO';

  @override
  String get continueMission => 'CONTINUAR MISSÃO';

  @override
  String get padControlsHint =>
      '[↑↓] Linha   [←→] Escolher   [B] Comprar/Melhorar/Trocar   [X/Y] Vender   [OPTIONS] Continuar';

  @override
  String get host => 'HOSPEDAR';

  @override
  String get connectToHost => 'Conectar ao anfitrião';

  @override
  String hostingAt(String ip) {
    return 'ANFITRIÃO  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
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
  String get swapHint =>
      'Com dois dedos você atira com o segundo conjunto de armas';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv: tiros mais fortes';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP: casco reparado';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount de escudo, recarrega mais rápido';
  }

  @override
  String get pickupGenerator => 'Gerador melhorado: mais energia para as armas';

  @override
  String pickupCredits(String amount) {
    return '+$amount créditos para gastar no ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'NÍVEL $level';
  }

  @override
  String get tutPickupWeapon =>
      'Power-ups de arma sobem o nível: mais dano, tiro mais rápido';

  @override
  String get tutPickupHealth =>
      'Reparos consertam o casco; com o casco cheio, aumentam o HP máximo';

  @override
  String get tutPickupShield =>
      'O escudo aguenta os tiros antes do casco e recarrega sozinho';

  @override
  String get tutPickupGenerator =>
      'O gerador alimenta as armas: mais energia mantém mais armas atirando';

  @override
  String get tutPickupCredits =>
      'Créditos compram armas e melhorias no ComCenter entre as rodadas';

  @override
  String get tutBoss =>
      'CHEFE! A vida dele é a barra no topo. Continue se mexendo e atirando';

  @override
  String get tutLowHp => 'Casco no limite! Um reparo ou o ComCenter resolve';

  @override
  String get tutGenStarved =>
      'Suas armas pedem mais energia do que o gerador dá: melhore-o';

  @override
  String get tutCanAfford =>
      'Você pode comprar uma melhoria: passe no ComCenter após a rodada';

  @override
  String get tutFly =>
      'Arraste para voar. As armas atiram enquanto seu dedo estiver na tela';

  @override
  String get introCollect => 'Pegue os ícones que os inimigos soltam';

  @override
  String get introShop => 'Entre as rodadas, gaste seus créditos no ComCenter';

  @override
  String get objBoss => 'Objetivo: sobreviva às ondas e derrote o chefe';

  @override
  String get objSurvive => 'Objetivo: sobreviva às ondas';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits créditos · $kills abates';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Melhor arma: $weapon';
  }

  @override
  String get deathBoss =>
      'Os tiros do chefe são fortes: um escudo melhor te dá tempo';

  @override
  String get deathShield =>
      'Melhore o escudo no ComCenter: ele aguenta os tiros antes do casco';

  @override
  String get deathGuns =>
      'Armas mais fortes limpam as ondas antes que te machuquem';
}
