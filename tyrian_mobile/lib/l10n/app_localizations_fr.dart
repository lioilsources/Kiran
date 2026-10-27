// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANNULER';

  @override
  String get connect => 'CONNEXION';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Connexion à $hostName impossible';
  }

  @override
  String get nearbyJoinFailedBody =>
      'L\'hôte était visible, mais la liaison ne s\'est pas établie.\n\nLe jeu à proximité nécessite le Wi-Fi pair à pair, qu\'iOS coupe tant qu\'un partage de connexion est actif. Désactivez le partage de connexion sur les deux appareils et réessayez, ou connectez-les au même Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Mission échouée — équipement et crédits conservés. Réessayez depuis le Centre de commandement.';

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
  String get mainMenu => 'MENU PRINCIPAL';

  @override
  String get quitToDesktop => 'QUITTER LE JEU';

  @override
  String get selectSkin => 'CHOISIR UNE APPARENCE';

  @override
  String get difficulty => 'DIFFICULTÉ';

  @override
  String get difficultyEasy => 'FACILE';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'DIFFICILE';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAGNE';

  @override
  String get quit => 'QUITTER';

  @override
  String get restorePurchases => 'RESTAURER LES ACHATS';

  @override
  String get locked => 'VERROUILLÉ';

  @override
  String get mainMenuTooltip => 'Menu principal';

  @override
  String nodeLevel(int level) {
    return 'NIVEAU $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'NIVEAU $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Verrouillé. Terminez d\'abord la mission précédente.';

  @override
  String get flyAgain => 'REJOUER';

  @override
  String get launch => 'DÉCOLLER';

  @override
  String zoneLabel(int zone) {
    return 'ZONE $zone';
  }

  @override
  String get objectiveStar => 'ÉTOILE';

  @override
  String get continueButton => 'CONTINUER';

  @override
  String get replayNode => 'REJOUER LA MISSION';

  @override
  String get retry => 'RÉESSAYER';

  @override
  String get nodeCleared => 'MISSION RÉUSSIE';

  @override
  String get nodeFailed => 'MISSION ÉCHOUÉE';

  @override
  String get weaponTierUnlocked => 'NOUVEAU PALIER D\'ARMES';

  @override
  String get onSaleInComCenter => 'En vente au Centre de commandement.';

  @override
  String get requiredTasksHint =>
      'Les tâches obligatoires décident de la mission. Rejouez-la : ce que vous avez gagné reste acquis.';

  @override
  String get objClear => 'Nettoyer le secteur';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abattre $count ennemis',
      one: 'Abattre 1 ennemi',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Ne subir aucun dégât à la coque';

  @override
  String objHull(int percent) {
    return 'Finir avec plus de $percent % de coque';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Éliminer $count ennemis avec $weapon',
      one: 'Éliminer 1 ennemi avec $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Éliminer $count ennemis avec les armes latérales',
      one: 'Éliminer 1 ennemi avec les armes latérales',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Décoller avec $weapon à l\'avant';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Décoller avec $weapon sur un flanc';
  }

  @override
  String get objBuySideGun =>
      'Acheter une arme latérale au Centre de commandement';

  @override
  String objUpgradeGenerator(int level) {
    return 'Améliorer le générateur au niveau $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Améliorer l\'arme avant au niveau $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Améliorer une arme latérale au niveau $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ramasser $count bonus',
      one: 'Ramasser 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Détruire $count formations entières',
      one: 'Détruire 1 formation entière',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Ne percuter aucun astéroïde';

  @override
  String objUnderTime(int seconds) {
    return 'Finir en moins de $seconds s';
  }

  @override
  String get objStripBoss => 'Détruire chaque pièce du boss avant le noyau';

  @override
  String get joinCoopTitle => 'Rejoindre en coop';

  @override
  String get cannotSearchNetwork => 'Impossible de chercher sur ce réseau';

  @override
  String get joinHintNearby =>
      'Le même Wi-Fi fonctionne sur tous les appareils. iPhone, iPad et Mac se trouvent aussi à proximité sans Wi-Fi, si le partage de connexion est coupé sur les deux.';

  @override
  String get joinHintWifi =>
      'Les deux joueurs doivent être sur le même Wi-Fi ; un partage de connexion fonctionne aussi.';

  @override
  String noHostsYet(String hint) {
    return 'Aucun hôte pour l\'instant. $hint';
  }

  @override
  String get lookingForHosts =>
      'Recherche d\'hôtes sur ce Wi-Fi et à proximité…';

  @override
  String get hostNearby => 'À proximité · Bluetooth / Wi-Fi pair à pair';

  @override
  String hostSameWifi(String address) {
    return '$address · même Wi-Fi';
  }

  @override
  String get enterIpManually => 'Saisir l\'IP manuellement';

  @override
  String get hudHp => 'PV';

  @override
  String get hudShield => 'BOU';

  @override
  String get hudPower => 'ÉNE';

  @override
  String get hudGen => 'GÉN';

  @override
  String bossShielded(String name) {
    return '$name — PROTÉGÉ';
  }

  @override
  String get bossPartTurret => 'Tourelle';

  @override
  String get bossPartShieldPod => 'Module bouclier';

  @override
  String get bossPartThruster => 'Propulseur';

  @override
  String get bossPartCannon => 'Canon';

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
  String get launchMission => 'LANCER LA MISSION';

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
  String hostingAs(String name) {
    return 'HÔTE : $name';
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
}
