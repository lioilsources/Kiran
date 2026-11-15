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
  String get statsOn => 'STATS : OUI';

  @override
  String get statsOff => 'STATS : NON';

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
  String levelShort(int level) {
    return 'Nv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'AMÉL';

  @override
  String get sell => 'VENDRE';

  @override
  String get buy => 'ACHETER';

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
  String get startMission => 'COMMENCER LA MISSION';

  @override
  String get continueMission => 'CONTINUER LA MISSION';

  @override
  String get padControlsHint =>
      '[↑↓] Ligne   [←→] Choisir   [B] Acheter/Améliorer/Changer   [X/Y] Vendre   [OPTIONS] Continuer';

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
  String get overload => 'SURCHARGE';

  @override
  String weaponOff(String weapon) {
    return '$weapon HORS SERVICE — générateur trop faible';
  }

  @override
  String unlocksAt(String points) {
    return 'Débloqué à $points pts';
  }

  @override
  String get swapHint => 'À deux doigts, tu tires avec ton second jeu d\'armes';

  @override
  String pickupWeapon(String slot, String lv) {
    return '$slot $lv : tirs plus puissants';
  }

  @override
  String pickupRepair(int amount) {
    return '+$amount HP : coque réparée';
  }

  @override
  String pickupShield(int amount) {
    return '+$amount de bouclier, recharge plus rapide';
  }

  @override
  String get pickupGenerator =>
      'Générateur amélioré : plus d\'énergie pour tes armes';

  @override
  String pickupCredits(String amount) {
    return '+$amount crédits à dépenser au ComCenter';
  }

  @override
  String nodeLevel(int level) {
    return 'NIVEAU $level';
  }

  @override
  String get tutPickupWeapon =>
      'Les bonus d\'arme montent son niveau : plus de dégâts, tir plus rapide';

  @override
  String get tutPickupHealth =>
      'Les réparations soignent la coque ; en forme, elles montent les HP max';

  @override
  String get tutPickupShield =>
      'Le bouclier encaisse avant la coque et se recharge tout seul';

  @override
  String get tutPickupGenerator =>
      'Le générateur alimente tes armes : plus d\'énergie, plus de tirs';

  @override
  String get tutPickupCredits =>
      'Les crédits achètent armes et améliorations au ComCenter';

  @override
  String get tutBoss =>
      'BOSS ! Sa vie est la barre en haut. Bouge et tire sans arrêt';

  @override
  String get tutLowHp =>
      'Coque faible ! Une réparation ou le ComCenter la soigne';

  @override
  String get tutGenStarved =>
      'Tes armes veulent plus d\'énergie que le générateur : améliore-le';

  @override
  String get tutCanAfford =>
      'Tu peux t\'offrir une amélioration : file au ComCenter après';

  @override
  String get tutFly =>
      'Glisse pour voler. Tes armes tirent tant que ton doigt touche';

  @override
  String get introCollect => 'Attrape les icônes lâchées par les ennemis';

  @override
  String get introShop => 'Entre les manches, dépense tes crédits au ComCenter';

  @override
  String get objBoss => 'Objectif : survis aux vagues et bats le boss';

  @override
  String get objSurvive => 'Objectif : survis aux vagues';

  @override
  String roundSummary(String credits, int kills) {
    return '+$credits crédits · $kills abattus';
  }

  @override
  String roundBestWeapon(String weapon) {
    return 'Meilleure arme : $weapon';
  }

  @override
  String get deathBoss =>
      'Les tirs du boss font mal : un meilleur bouclier te fait gagner du temps';

  @override
  String get deathShield =>
      'Améliore le bouclier au ComCenter : il encaisse avant la coque';

  @override
  String get deathGuns =>
      'Des armes plus fortes nettoient les vagues avant qu\'elles te blessent';
}
