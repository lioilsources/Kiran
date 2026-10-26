// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cancel => 'ANNULER';

  @override
  String get connect => 'CONNEXION';

  @override
  String get gameOverEndless =>
      'Reconstruction au secteur 1 — équipement et crédits conservés';

  @override
  String get waitingForHost => 'En attente de l\'hôte...';

  @override
  String get waitingForHostHint =>
      'La partie commencera quand l\'hôte sera prêt';

  @override
  String get vesselLost => 'VAISSEAU PERDU';

  @override
  String scoreValue(String score) {
    return 'Score : $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Crédits : $credits';
  }

  @override
  String get creditsPrefix => 'Crédits : ';

  @override
  String get leaderboard => 'CLASSEMENT';

  @override
  String get achievements => 'SUCCÈS';

  @override
  String get redeploy => 'REDÉPLOYER';

  @override
  String get resume => 'REPRENDRE';

  @override
  String get pause => 'PAUSE';

  @override
  String get paused => 'EN PAUSE';

  @override
  String get skins => 'APPARENCES';

  @override
  String get skin => 'APPARENCE';

  @override
  String get soundOn => 'SON : OUI';

  @override
  String get soundOff => 'SON : NON';

  @override
  String get musicOn => 'MUSIQUE : OUI';

  @override
  String get musicOff => 'MUSIQUE : NON';

  @override
  String get quitToDesktop => 'QUITTER LE JEU';

  @override
  String get selectSkin => 'CHOISIR UNE APPARENCE';

  @override
  String get quit => 'QUITTER';

  @override
  String get restorePurchases => 'RESTAURER LES ACHATS';

  @override
  String get locked => 'VERROUILLÉ';

  @override
  String get hudHp => 'PV';

  @override
  String get hudShield => 'BOU';

  @override
  String get hudPower => 'ÉNE';

  @override
  String get hudGen => 'GÉN';

  @override
  String sectorUnknownSpace(int level) {
    return 'Secteur $level — Espace inconnu';
  }

  @override
  String get player2Joined => 'Le joueur 2 a rejoint la partie !';

  @override
  String get player2Disconnected => 'Le joueur 2 s\'est déconnecté';

  @override
  String get hostDisconnected => 'L\'hôte s\'est déconnecté';

  @override
  String maxLevelSold(String amount) {
    return 'Niveau max ! Vendu pour \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Niveau d\'armes $tier débloqué';
  }

  @override
  String get cheatsEnabled => 'Triches activées';

  @override
  String get cheatsDisabled => 'Triches désactivées';

  @override
  String get cheatsMaxed =>
      'TRICHE : crédits au maximum, toutes les armes débloquées';

  @override
  String get cheats => 'TRICHES';

  @override
  String get maxCredits => 'CRÉDITS MAX';

  @override
  String get sectionStats => 'STATS';

  @override
  String get sectionLoadout => 'ARMEMENT';

  @override
  String get sectionOutfitting => 'ÉQUIPEMENT';

  @override
  String get sectionShop => 'BOUTIQUE';

  @override
  String get tabFront => 'AVANT';

  @override
  String get tabSide => 'FLANC';

  @override
  String get tabGen => 'GÉN';

  @override
  String get sideLeft => 'GAUCHE';

  @override
  String get sideRight => 'DROITE';

  @override
  String get noWeaponInstalled => 'AUCUNE ARME INSTALLÉE';

  @override
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String statDamageSpeed(int damage, int speed) {
    return 'DÉG:$damage VIT:$speed';
  }

  @override
  String statPower(int power) {
    return 'ÉNE:$power';
  }

  @override
  String get beam => 'RAYON';

  @override
  String get guided => 'GUIDÉ';

  @override
  String get owned => 'POSSÉDÉ';

  @override
  String get max => 'MAX';

  @override
  String get upgrade => 'AMÉLIORER';

  @override
  String get upgradeShort => 'AMÉL';

  @override
  String get sell => 'VENDRE';

  @override
  String get buy => 'ACHETER';

  @override
  String get noCredits => 'PAS ASSEZ';

  @override
  String get commandCenter => 'CENTRE DE COMMANDEMENT';

  @override
  String get pilot => 'Pilote';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SCORE';

  @override
  String get nextWeapon => 'ARME SUIVANTE';

  @override
  String pointsValue(String points) {
    return '$points pts';
  }

  @override
  String get slotFront => 'Avant';

  @override
  String get slotLeft => 'Gauche';

  @override
  String get slotRight => 'Droite';

  @override
  String get slotGen => 'Gén';

  @override
  String get power => 'ÉNE';

  @override
  String get generator => 'GÉNÉRATEUR';

  @override
  String genOutput(String value) {
    return 'ÉNE : +$value/im';
  }

  @override
  String genCapacity(int value) {
    return 'Cap. : $value';
  }

  @override
  String get startMission => 'COMMENCER LA MISSION';

  @override
  String get continueMission => 'CONTINUER LA MISSION';

  @override
  String get padControlsHint =>
      '[B] Acheter/améliorer   [X/Y] Vendre   [LB/RB] Onglets   [OPTIONS] Reprendre la mission';

  @override
  String get host => 'HÉBERGER';

  @override
  String get connectToHost => 'Se connecter à l\'hôte';

  @override
  String hostingAt(String ip) {
    return 'HÔTE  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP : $ip';
  }

  @override
  String get join => 'REJOINDRE';
}
