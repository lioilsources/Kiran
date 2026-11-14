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

  @override
  String joinConnecting(String target) {
    return 'Connexion à $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'L\'hôte n\'a pas répondu : $reason.\n\nLes deux joueurs doivent être sur le même Wi-Fi (un partage de connexion fonctionne aussi) et l\'hôte doit avoir appuyé sur HOST. Vérifiez l\'adresse et réessayez.';
  }

  @override
  String get lanJoinNoAnswer => 'aucune réponse';

  @override
  String objBossUnder(int seconds) {
    return 'Détruis le noyau du boss dans les $seconds s suivant son arrivée';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'COFFRE';

  @override
  String get rackSide => 'Côté';

  @override
  String get rackHull => 'Coque';

  @override
  String get rarityCommon => 'COMMUN';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityMythic => 'MYTHIQUE';

  @override
  String get curse => 'MALÉDICTION';

  @override
  String get modFit => 'MONTER';

  @override
  String get modUnfit => 'RETIRER';

  @override
  String get modForge => 'FORGE';

  @override
  String get forgeHint =>
      'Choisis 3 d\'une rareté pour en forger 1 de la suivante';

  @override
  String get vaultEmpty =>
      'Pas encore de mods. Termine un nœud avec toutes les étoiles, bats un boss vite ou abats un boss en mode infini.';

  @override
  String modNeeds(String families) {
    return 'Fonctionne avec $families';
  }

  @override
  String get modRackFull => 'Rack plein';

  @override
  String get modAlreadyFitted => 'Déjà monté';

  @override
  String get modWrongRack => 'Ne va pas dans ce rack';

  @override
  String modsSpilled(int n) {
    return '$n mods de retour au coffre';
  }

  @override
  String get hullLocked => 'Verrouillé';

  @override
  String hullUnlockBoss(int n) {
    return 'Bats le boss de campagne $n';
  }

  @override
  String get hullUnlockFinish => 'Termine la campagne ou atteins le secteur 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'IMP';

  @override
  String get perkNone => 'Vaisseau de série';

  @override
  String get perkAfterimage => 'Immobile : tirs ×1,5';

  @override
  String get perkBulwark => 'Dégâts après le bouclier divisés par deux';

  @override
  String get perkOverclock =>
      'Tire avec des armes jusqu\'à 130 % de capacité, plus lentement';

  @override
  String get perkBattery => 'Un drone gratuit t\'accompagne';

  @override
  String get rewardTitle => 'RÉCOMPENSE';

  @override
  String newHull(String name) {
    return 'Nouvelle coque : $name';
  }

  @override
  String get socketEmpty => 'vide';

  @override
  String fxStreams(int n) {
    return '$n flux parallèles';
  }

  @override
  String fxFan(int n) {
    return 'Éventail de $n tirs';
  }

  @override
  String fxSalvo(int n) {
    return 'Salve de $n tirs';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadence ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Dégâts ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Vitesse des tirs ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Taille des tirs ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consommation ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Guidage +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Traverse $n cibles';
  }

  @override
  String get fxPierceAll => 'Traverse tout';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % de chances de dégâts ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Critiques ×$x sur les boss';
  }

  @override
  String fxFork(int n) {
    return 'Les éliminations projettent $n tirs';
  }

  @override
  String get fxChain => 'Les tirs projetés se projettent encore';

  @override
  String get fxSplit => 'Se divise en deux à l\'impact';

  @override
  String get fxFrost => 'Les impacts ralentissent l\'ennemi';

  @override
  String get fxCrossfire => 'Les armes latérales visent le centre';

  @override
  String get fxRearguard => 'Les armes latérales tirent aussi vers l\'arrière';

  @override
  String get fxOrbit => 'Les tirs ondulent';

  @override
  String fxBounce(int n) {
    return 'Rebondit sur les murs $n×';
  }

  @override
  String get fxBounceTop => '…et sur le haut';

  @override
  String get fxOverdrive => 'Tire même à crédit d\'énergie';

  @override
  String get fxReactor =>
      'Les armes hors capacité tirent quand même, lentement';

  @override
  String fxGenPower(String x) {
    return 'Recharge du générateur ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacité du générateur ×$x';
  }

  @override
  String get fxSurge => 'Générateur plein : tirs ×2';

  @override
  String fxSiphon(int pct) {
    return 'Les éliminations rechargent $pct % d\'énergie';
  }

  @override
  String fxHp(String x) {
    return 'Coque ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Bouclier ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Régénération du bouclier ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Les éliminations soignent $n PV';
  }

  @override
  String get fxMagnet => 'Attire les bonus';

  @override
  String get fxMagnetAll => 'Attire tous les bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % des tirs rebondissent sur le bouclier';
  }

  @override
  String get fxReflectGuided => 'Les tirs renvoyés sont guidés';

  @override
  String fxGhost(String sec) {
    return 'Invulnérable $sec s après un coup à la coque';
  }

  @override
  String get fxNova => 'Bouclier brisé : explosion sur tout l\'écran';

  @override
  String fxAgility(String x) {
    return 'Agilité ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Zone d\'impact ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Crédits ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Score ×$x';
  }

  @override
  String get fxSatellite => 'Un drone de combat t\'accompagne';

  @override
  String get fxTimewarp => 'Un coup à la coque ralentit le temps';

  @override
  String get fxGambler => 'Chaque tir est une arme au hasard';

  @override
  String get vaultAll => 'TOUT';

  @override
  String get sigilMissUnknown => 'forme inconnue';

  @override
  String get sigilMissTooSlow => 'trop lent';

  @override
  String get sigilMissSkippedDot => 'point sauté';

  @override
  String get sigilMissLeftRimEarly => 'relâché trop tôt';

  @override
  String get sigilMissWrongDirection => 'tracé à l\'envers';

  @override
  String get sigilMissWrongLayer => 'mauvais bouton d\'épaule';

  @override
  String get sigilDry => 'pas assez de charge';

  @override
  String get sigilBusy => 'le précédent est en cours';

  @override
  String get arena => 'ARÈNE';

  @override
  String get arenaBossParts => 'PIÈCES DU BOSS';

  @override
  String get arenaBareCore => 'noyau nu';

  @override
  String get arenaCompanions => 'COMPAGNONS';

  @override
  String get arenaCharge => 'CHARGE';

  @override
  String get arenaChargeNormal => 'NORMALE';

  @override
  String get arenaSpeed => 'VITESSE DU MONDE';

  @override
  String get arenaDrill => 'EXERCICE';

  @override
  String get arenaFreePlay => 'JEU LIBRE';

  @override
  String get arenaFight => 'COMBATTRE';

  @override
  String get arenaNewBoss => 'NOUVEAU BOSS';

  @override
  String get arenaLeave => 'QUITTER L\'ARÈNE';

  @override
  String get arenaHint =>
      'Le boss revient dès qu\'il tombe. Rien n\'est sauvegardé ici.';

  @override
  String get arenaColCast => 'LANCÉS';

  @override
  String get arenaColMiss => 'RATÉS';

  @override
  String get arenaColAvg => 'MOY.';

  @override
  String get arenaColBest => 'MEILLEUR';

  @override
  String get arenaColTime => 'PLUS RAPIDE';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Boss $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'MANETTE : SIGILS';

  @override
  String get padSchemeClassic => 'MANETTE : CLASSIQUE';

  @override
  String get padSouthpawOn => 'GAUCHER : OUI';

  @override
  String get padSouthpawOff => 'GAUCHER : NON';

  @override
  String get sigilDescHop => 'Un bond rapide dans le sens du stick';

  @override
  String get sigilDescSidestep => 'Un long pas de côté à travers le terrain';

  @override
  String get sigilDescStrike =>
      'Fente en avant avec trois tirs lourds, puis retour';

  @override
  String get sigilDescRetreat =>
      'Recule pendant que le tir de couverture part devant';

  @override
  String get sigilDescDash =>
      'Ruée en diagonale à travers le feu, invulnérable à mi-course';

  @override
  String get sigilDescRoll => 'Un tonneau sur le côté, invulnérable';

  @override
  String get sigilDescShadow =>
      'Colle-toi sous l\'ennemi le plus proche et continue de tirer';

  @override
  String get sigilDescEcho =>
      'Une ombre rejoue tes deux dernières secondes à demi-dégâts';

  @override
  String get sigilDescLoop =>
      'Un looping par-dessus : les tirs passent sous toi';

  @override
  String get sigilDescSlalom =>
      'Une courbe en S à travers le terrain avec tir en éventail';

  @override
  String get sigilDescCorkscrew =>
      'Vrille en avant en tirant tout autour, invulnérable';

  @override
  String get sigilDescSnapshot => 'Un tir lourd dans le sens du stick';

  @override
  String get sigilDescBroadside => 'Une salve par les deux flancs';

  @override
  String get sigilDescVolley => 'Cinq rayons chargés vers l\'avant';

  @override
  String get sigilDescCaltrop => 'Pose une mine qui avale les tirs et explose';

  @override
  String get sigilDescFrenzy => 'Les armes tirent plus vite quelques secondes';

  @override
  String get sigilDescStasis =>
      'Les ennemis et leurs tirs ralentissent de moitié';

  @override
  String get sigilDescHalo =>
      'Le bouclier se recharge quatre fois plus vite et rien ne passe';

  @override
  String get sigilDescRadial => 'Un anneau de seize tirs';

  @override
  String get sigilDescStorm => 'Toutes les armes tirent à fond, gratuitement';

  @override
  String get sigilDescPing =>
      'Les compagnons concentrent le tir dans le sens du stick';

  @override
  String get sigilDescWingman =>
      'Appelle un ailier sur le flanc que tu as tracé';

  @override
  String get sigilDescHunter =>
      'Appelle un chasseur qui file devant et choisit ses cibles';

  @override
  String get sigilDescWarden =>
      'Appelle un gardien qui encaisse les tirs qui te visent';

  @override
  String get sigilDescFormation =>
      'Les compagnons alternent formation large et en coin';

  @override
  String get sigilDescWhirl =>
      'Les compagnons tournent autour de toi et absorbent les tirs';

  @override
  String get sigilDescSacrifice =>
      'Les compagnons plongent et explosent, et te rendent de la charge';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Dessine avec le stick droit. Maintiens LB pour ARMS, RB pour WING, les deux pour MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'coût $cost';
  }

  @override
  String get sigilUntouchable => 'invulnérable';

  @override
  String get lessonWatch => 'REGARDE';

  @override
  String get lessonTrace => 'DÉCALQUE';

  @override
  String get lessonSlow => 'LENTEMENT';

  @override
  String get lessonLive => 'PLEINE VITESSE';

  @override
  String get lessonStreak => 'CINQ D\'AFFILÉE';

  @override
  String get lessonLearned => 'APPRIS';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Donne un coup de stick droit';

  @override
  String get hintLoop => 'Trace un cercle : tu passes au-dessus des tirs';

  @override
  String get hintStream => 'Presse LT : deux ou trois flux';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'AUCUN';

  @override
  String kataNext(String sigil, String secs) {
    return 'suivant $sigil dans $secs s';
  }

  @override
  String get arenaGauntlet => 'ÉPREUVE';

  @override
  String get arenaOn => 'OUI';

  @override
  String get arenaOff => 'NON';

  @override
  String gauntletRating(int rating, int best) {
    return 'Note $rating · record $best';
  }

  @override
  String get duelWarning => 'ALERTE';

  @override
  String get duelHintPad1 => 'Le stick droit vise et tire';

  @override
  String get duelHintPad2Rt =>
      'Maintiens RT, LB ou RB : le stick droit trace des sigils';

  @override
  String get duelHintPad2Lt =>
      'Maintiens LT, LB ou RB : le stick droit trace des sigils';

  @override
  String get duelHintClassic =>
      'Le stick gauche pilote · B, RB ou RT tirent là où pointe le nez';

  @override
  String get duelHintKeys1 => 'Les flèches visent et tirent · ZQSD pilote';

  @override
  String get duelHintKeys2 =>
      'Espace tire là où pointe le nez · le pavé numérique trace des sigils';

  @override
  String get arenaDuelBinding => 'POSTURE DE DUEL';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'AVANT DU PAD';

  @override
  String get duelFrameNose => 'LE NEZ';

  @override
  String get duelFrameUp => 'EN HAUT';

  @override
  String get arenaDuelAimFires => 'VISER TIRE';

  @override
  String get duelCutInFirst => 'GROS PLAN DU BOSS : LA PREMIÈRE FOIS';

  @override
  String get duelCutInAlways => 'GROS PLAN DU BOSS : TOUJOURS';

  @override
  String get duelCutInNever => 'GROS PLAN DU BOSS : JAMAIS';

  @override
  String get arenaDuelDrill => 'EXERCICE DE DUEL';

  @override
  String get duelDrillOff => 'AUCUN';

  @override
  String get duelDrillAim => 'VISE ET TIRE';

  @override
  String get duelDrillAimHow =>
      'Pointe le stick droit vers le boss et touche-le';

  @override
  String get duelDrillHold => 'GARDE LE NEZ';

  @override
  String get duelDrillHoldHow =>
      'Maintiens un bouton de posture et vole : le nez reste en place';

  @override
  String get duelDrillDraw => 'TRACE VERS L\'AVANT';

  @override
  String get duelDrillDrawHow => 'En posture, trace un sigil vers le boss';

  @override
  String get duelDrillTurn => 'DEMI-TOUR';

  @override
  String get duelDrillTurnHow =>
      'Le boss est sous toi : tourne le nez et touche-le';

  @override
  String get duelDrillDone => 'RÉUSSI';

  @override
  String get swapHint => 'Touche avec un deuxième doigt pour changer d\'armes';
}
