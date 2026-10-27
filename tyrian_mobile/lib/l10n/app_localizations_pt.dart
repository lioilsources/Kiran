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
}
