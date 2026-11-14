// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ANNULLA';

  @override
  String get connect => 'CONNETTI';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Impossibile connettersi a $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'L\'host era visibile, ma il collegamento non si è stabilito.\n\nIl gioco nelle vicinanze richiede il Wi-Fi peer-to-peer, che iOS disattiva quando l\'hotspot personale è attivo. Spegni l\'hotspot su entrambi i dispositivi e riprova, oppure collegali alla stessa rete Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Missione fallita — equipaggiamento e crediti conservati. Riprova dal Centro di comando.';

  @override
  String get gameOverEndless =>
      'Ricostruzione nel Settore 1 — equipaggiamento e crediti conservati';

  @override
  String get waitingForHost => 'In attesa dell\'host...';

  @override
  String get waitingForHostHint =>
      'La partita inizierà quando l\'host sarà pronto';

  @override
  String get vesselLost => 'NAVE PERDUTA';

  @override
  String scoreValue(String score) {
    return 'Punteggio: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Crediti: $credits';
  }

  @override
  String get creditsPrefix => 'Crediti: ';

  @override
  String get leaderboard => 'CLASSIFICA';

  @override
  String get achievements => 'OBIETTIVI';

  @override
  String get redeploy => 'RISCHIERA';

  @override
  String get resume => 'RIPRENDI';

  @override
  String get pause => 'PAUSA';

  @override
  String get paused => 'IN PAUSA';

  @override
  String get skins => 'SKIN';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SUONI: SÌ';

  @override
  String get soundOff => 'SUONI: NO';

  @override
  String get musicOn => 'MUSICA: SÌ';

  @override
  String get musicOff => 'MUSICA: NO';

  @override
  String get mainMenu => 'MENU PRINCIPALE';

  @override
  String get quitToDesktop => 'ESCI AL DESKTOP';

  @override
  String get selectSkin => 'SCEGLI SKIN';

  @override
  String get difficulty => 'DIFFICOLTÀ';

  @override
  String get difficultyEasy => 'FACILE';

  @override
  String get difficultyNormal => 'NORMALE';

  @override
  String get difficultyHard => 'DIFFICILE';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'CAMPAGNA';

  @override
  String get quit => 'ESCI';

  @override
  String get restorePurchases => 'RIPRISTINA ACQUISTI';

  @override
  String get locked => 'BLOCCATO';

  @override
  String get mainMenuTooltip => 'Menu principale';

  @override
  String nodeLevel(int level) {
    return 'LIVELLO $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LIVELLO $level · BOSS $ordinal';
  }

  @override
  String get nodeLockedHint =>
      'Bloccato. Completa prima la missione precedente.';

  @override
  String get flyAgain => 'VOLA DI NUOVO';

  @override
  String get launch => 'DECOLLA';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'STELLA';

  @override
  String get continueButton => 'CONTINUA';

  @override
  String get replayNode => 'RIGIOCA MISSIONE';

  @override
  String get retry => 'RIPROVA';

  @override
  String get nodeCleared => 'MISSIONE COMPIUTA';

  @override
  String get nodeFailed => 'MISSIONE FALLITA';

  @override
  String get weaponTierUnlocked => 'NUOVO LIVELLO ARMI';

  @override
  String get onSaleInComCenter => 'In vendita nel Centro di comando.';

  @override
  String get requiredTasksHint =>
      'Gli obiettivi obbligatori decidono la missione. Rigiocala: ciò che hai guadagnato resta tuo.';

  @override
  String get objClear => 'Ripulisci il settore';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abbatti $count nemici',
      one: 'Abbatti 1 nemico',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Non subire danni allo scafo';

  @override
  String objHull(int percent) {
    return 'Termina con lo scafo sopra il $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count nemici con $weapon',
      one: 'Elimina 1 nemico con $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elimina $count nemici con le armi laterali',
      one: 'Elimina 1 nemico con le armi laterali',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Decolla con $weapon davanti';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Decolla con $weapon su un lato';
  }

  @override
  String get objBuySideGun => 'Compra un\'arma laterale nel Centro di comando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Potenzia il generatore al livello $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Potenzia l\'arma frontale al livello $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Potenzia un\'arma laterale al livello $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Raccogli $count bonus',
      one: 'Raccogli 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Distruggi $count formazioni intere',
      one: 'Distruggi 1 formazione intera',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Non urtare asteroidi';

  @override
  String objUnderTime(int seconds) {
    return 'Termina entro $seconds s';
  }

  @override
  String get objStripBoss => 'Distruggi ogni parte del boss prima del nucleo';

  @override
  String get joinCoopTitle => 'Unisciti in co-op';

  @override
  String get cannotSearchNetwork => 'Impossibile cercare su questa rete';

  @override
  String get joinHintNearby =>
      'La stessa rete Wi-Fi funziona su ogni dispositivo. iPhone, iPad e Mac si trovano anche nelle vicinanze senza Wi-Fi, con l\'hotspot personale spento su entrambi.';

  @override
  String get joinHintWifi =>
      'Entrambi i giocatori devono essere sulla stessa rete Wi-Fi; va bene anche un hotspot personale.';

  @override
  String noHostsYet(String hint) {
    return 'Ancora nessun host. $hint';
  }

  @override
  String get lookingForHosts =>
      'Ricerca di host su questa rete Wi-Fi e nelle vicinanze…';

  @override
  String get hostNearby => 'Nelle vicinanze · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · stessa Wi-Fi';
  }

  @override
  String get enterIpManually => 'Inserisci IP manualmente';

  @override
  String get hudHp => 'PS';

  @override
  String get hudShield => 'SC';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — SCHERMATO';
  }

  @override
  String get bossPartTurret => 'Torretta';

  @override
  String get bossPartShieldPod => 'Modulo scudo';

  @override
  String get bossPartThruster => 'Propulsore';

  @override
  String get bossPartCannon => 'Cannone';

  @override
  String sectorUnknownSpace(int level) {
    return 'Settore $level — Spazio ignoto';
  }

  @override
  String get player2Joined => 'Il giocatore 2 si è unito!';

  @override
  String get player2Disconnected => 'Il giocatore 2 si è disconnesso';

  @override
  String get hostDisconnected => 'L\'host si è disconnesso';

  @override
  String maxLevelSold(String amount) {
    return 'Livello max! Venduto per \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Livello armi $tier sbloccato';
  }

  @override
  String get cheatsEnabled => 'Trucchi attivati';

  @override
  String get cheatsDisabled => 'Trucchi disattivati';

  @override
  String get cheatsMaxed =>
      'TRUCCO: crediti al massimo, tutte le armi sbloccate';

  @override
  String get cheats => 'TRUCCHI';

  @override
  String get maxCredits => 'CREDITI MAX';

  @override
  String get sectionStats => 'STATISTICHE';

  @override
  String get sectionLoadout => 'ARMAMENTO';

  @override
  String levelShort(int level) {
    return 'Liv.$level';
  }

  @override
  String get max => 'MAX';

  @override
  String get upgradeShort => 'POT';

  @override
  String get sell => 'VENDI';

  @override
  String get buy => 'COMPRA';

  @override
  String get commandCenter => 'CENTRO DI COMANDO';

  @override
  String get pilot => 'Pilota';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PUNTI';

  @override
  String get nextWeapon => 'PROSSIMA ARMA';

  @override
  String pointsValue(String points) {
    return '$points pt';
  }

  @override
  String get slotFront => 'Fronte';

  @override
  String get slotLeft => 'Sinistra';

  @override
  String get slotRight => 'Destra';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LANCIA MISSIONE';

  @override
  String get startMission => 'INIZIA MISSIONE';

  @override
  String get continueMission => 'CONTINUA MISSIONE';

  @override
  String get padControlsHint =>
      '[↑↓] Riga   [←→] Scegli   [B] Compra/Potenzia/Cambia   [X/Y] Vendi   [OPTIONS] Continua';

  @override
  String get host => 'OSPITA';

  @override
  String hostingAs(String name) {
    return 'HOST: $name';
  }

  @override
  String get join => 'UNISCITI';

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
  String get overload => 'SOVRACCARICO';

  @override
  String weaponOff(String weapon) {
    return '$weapon SPENTO — generatore troppo debole';
  }

  @override
  String unlocksAt(String points) {
    return 'Si sblocca a $points punti';
  }

  @override
  String joinConnecting(String target) {
    return 'Connessione a $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'L\'host non ha risposto: $reason.\n\nEntrambi i giocatori devono essere sulla stessa Wi-Fi (va bene anche un hotspot personale) e l\'host deve aver premuto HOST. Controlla l\'indirizzo e riprova.';
  }

  @override
  String get lanJoinNoAnswer => 'nessuna risposta';

  @override
  String objBossUnder(int seconds) {
    return 'Distruggi il nucleo del boss entro $seconds s dal suo arrivo';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'CAVEAU';

  @override
  String get rackSide => 'Lato';

  @override
  String get rackHull => 'Scafo';

  @override
  String get rarityCommon => 'COMUNE';

  @override
  String get rarityRare => 'RARO';

  @override
  String get rarityMythic => 'MITICO';

  @override
  String get curse => 'MALEDIZIONE';

  @override
  String get modFit => 'MONTA';

  @override
  String get modUnfit => 'SMONTA';

  @override
  String get modForge => 'FORGIA';

  @override
  String get forgeHint =>
      'Scegli 3 di una rarità per forgiarne 1 della successiva';

  @override
  String get vaultEmpty =>
      'Ancora nessun mod. Completa un nodo con tutte le stelle, batti un boss in fretta o abbatti un boss in modalità infinita.';

  @override
  String modNeeds(String families) {
    return 'Funziona con $families';
  }

  @override
  String get modRackFull => 'Rack pieno';

  @override
  String get modAlreadyFitted => 'Già montato';

  @override
  String get modWrongRack => 'Non va in questo rack';

  @override
  String modsSpilled(int n) {
    return '$n mod di nuovo nel caveau';
  }

  @override
  String get hullLocked => 'Bloccato';

  @override
  String hullUnlockBoss(int n) {
    return 'Batti il boss della campagna $n';
  }

  @override
  String get hullUnlockFinish =>
      'Finisci la campagna o raggiungi il settore 30';

  @override
  String get statAgility => 'AGI';

  @override
  String get statHitbox => 'COL';

  @override
  String get perkNone => 'Nave di serie';

  @override
  String get perkAfterimage => 'Fermo: colpi ×1,5';

  @override
  String get perkBulwark => 'Il danno oltre lo scudo è dimezzato';

  @override
  String get perkOverclock =>
      'Spara con armi fino al 130 % della capacità, più lento';

  @override
  String get perkBattery => 'Un drone gratis ti accompagna';

  @override
  String get rewardTitle => 'RICOMPENSA';

  @override
  String newHull(String name) {
    return 'Nuovo scafo: $name';
  }

  @override
  String get socketEmpty => 'vuoto';

  @override
  String fxStreams(int n) {
    return '$n flussi paralleli';
  }

  @override
  String fxFan(int n) {
    return 'Ventaglio di $n colpi';
  }

  @override
  String fxSalvo(int n) {
    return 'Raffica di $n colpi';
  }

  @override
  String fxFireRate(String x) {
    return 'Cadenza ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Danno ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Velocità colpi ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Dimensione colpi ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Consumo ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Guida +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Attraversa $n bersagli';
  }

  @override
  String get fxPierceAll => 'Attraversa tutto';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % di probabilità di danno ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Critici ×$x sui boss';
  }

  @override
  String fxFork(int n) {
    return 'Le uccisioni spargono $n colpi';
  }

  @override
  String get fxChain => 'I colpi sparsi si spargono ancora';

  @override
  String get fxSplit => 'Si divide in due all\'impatto';

  @override
  String get fxFrost => 'I colpi rallentano il nemico';

  @override
  String get fxCrossfire => 'Le armi laterali mirano al centro';

  @override
  String get fxRearguard => 'Le armi laterali sparano anche indietro';

  @override
  String get fxOrbit => 'I colpi ondeggiano';

  @override
  String fxBounce(int n) {
    return 'Rimbalza sulle pareti $n×';
  }

  @override
  String get fxBounceTop => '…e sul bordo superiore';

  @override
  String get fxOverdrive => 'Spara anche in debito di energia';

  @override
  String get fxReactor => 'Le armi oltre la capacità sparano lo stesso, lente';

  @override
  String fxGenPower(String x) {
    return 'Ricarica generatore ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Capacità generatore ×$x';
  }

  @override
  String get fxSurge => 'Generatore pieno: colpi ×2';

  @override
  String fxSiphon(int pct) {
    return 'Le uccisioni ricaricano il $pct % di energia';
  }

  @override
  String fxHp(String x) {
    return 'Scafo ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Scudo ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Rigenerazione scudo ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Le uccisioni curano $n PS';
  }

  @override
  String get fxMagnet => 'Attira i bonus';

  @override
  String get fxMagnetAll => 'Attira tutti i bonus';

  @override
  String fxReflect(int pct) {
    return 'Il $pct % dei colpi rimbalza dallo scudo';
  }

  @override
  String get fxReflectGuided => 'I colpi riflessi sono guidati';

  @override
  String fxGhost(String sec) {
    return 'Invulnerabile $sec s dopo un colpo allo scafo';
  }

  @override
  String get fxNova => 'Scudo infranto: esplosione su tutto lo schermo';

  @override
  String fxAgility(String x) {
    return 'Agilità ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Area di impatto ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Crediti ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Punti ×$x';
  }

  @override
  String get fxSatellite => 'Un drone da combattimento ti accompagna';

  @override
  String get fxTimewarp => 'Un colpo allo scafo rallenta il tempo';

  @override
  String get fxGambler => 'Ogni colpo è un\'arma a caso';

  @override
  String get vaultAll => 'TUTTI';

  @override
  String get sigilMissUnknown => 'forma sconosciuta';

  @override
  String get sigilMissTooSlow => 'troppo lento';

  @override
  String get sigilMissSkippedDot => 'punto saltato';

  @override
  String get sigilMissLeftRimEarly => 'rilasciato troppo presto';

  @override
  String get sigilMissWrongDirection => 'disegnato al contrario';

  @override
  String get sigilMissWrongLayer => 'tasto dorsale sbagliato';

  @override
  String get sigilDry => 'carica insufficiente';

  @override
  String get sigilBusy => 'il precedente è ancora attivo';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'PARTI DEL BOSS';

  @override
  String get arenaBareCore => 'solo nucleo';

  @override
  String get arenaCompanions => 'COMPAGNI';

  @override
  String get arenaCharge => 'CARICA';

  @override
  String get arenaChargeNormal => 'NORMALE';

  @override
  String get arenaSpeed => 'VELOCITÀ DEL MONDO';

  @override
  String get arenaDrill => 'ESERCIZIO';

  @override
  String get arenaFreePlay => 'GIOCO LIBERO';

  @override
  String get arenaFight => 'COMBATTI';

  @override
  String get arenaNewBoss => 'NUOVO BOSS';

  @override
  String get arenaLeave => 'ESCI DALL\'ARENA';

  @override
  String get arenaHint => 'Il boss torna appena cade. Qui non si salva nulla.';

  @override
  String get arenaColCast => 'LANCIATI';

  @override
  String get arenaColMiss => 'FALLITI';

  @override
  String get arenaColAvg => 'MEDIA';

  @override
  String get arenaColBest => 'MIGLIORE';

  @override
  String get arenaColTime => 'PIÙ RAPIDO';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Boss $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILLI';

  @override
  String get padSchemeClassic => 'PAD: CLASSICO';

  @override
  String get padSouthpawOn => 'MANCINO: SÌ';

  @override
  String get padSouthpawOff => 'MANCINO: NO';

  @override
  String get sigilDescHop => 'Un balzo rapido nella direzione dello stick';

  @override
  String get sigilDescSidestep => 'Un lungo passo laterale attraverso il campo';

  @override
  String get sigilDescStrike =>
      'Affondo in avanti con tre colpi pesanti, poi indietro';

  @override
  String get sigilDescRetreat =>
      'Ripiega mentre il fuoco di copertura va avanti';

  @override
  String get sigilDescDash =>
      'Scatto in diagonale nel fuoco, invulnerabile a metà';

  @override
  String get sigilDescRoll => 'Un tonneau laterale, invulnerabile';

  @override
  String get sigilDescShadow =>
      'Agganciati sotto il nemico più vicino e continua a sparare';

  @override
  String get sigilDescEcho =>
      'Un\'ombra ripete i tuoi ultimi due secondi a metà danno';

  @override
  String get sigilDescLoop => 'Un looping dall\'alto: i colpi ti passano sotto';

  @override
  String get sigilDescSlalom =>
      'Una curva a S attraverso il campo con fuoco a ventaglio';

  @override
  String get sigilDescCorkscrew =>
      'Avvitamento in avanti sparando ovunque, invulnerabile';

  @override
  String get sigilDescSnapshot =>
      'Un colpo pesante nella direzione dello stick';

  @override
  String get sigilDescBroadside => 'Una raffica da entrambi i fianchi';

  @override
  String get sigilDescVolley => 'Cinque raggi carichi in avanti';

  @override
  String get sigilDescCaltrop =>
      'Lascia una mina che inghiotte i colpi ed esplode';

  @override
  String get sigilDescFrenzy =>
      'Le armi sparano più veloci per qualche secondo';

  @override
  String get sigilDescStasis =>
      'I nemici e i loro colpi rallentano a metà velocità';

  @override
  String get sigilDescHalo =>
      'Lo scudo si ricarica quattro volte più in fretta e nulla passa';

  @override
  String get sigilDescRadial => 'Un anello di sedici colpi';

  @override
  String get sigilDescStorm => 'Ogni arma spara al massimo, gratis';

  @override
  String get sigilDescPing =>
      'I compagni concentrano il fuoco nella direzione dello stick';

  @override
  String get sigilDescWingman =>
      'Chiama un gregario sul fianco verso cui hai tracciato';

  @override
  String get sigilDescHunter =>
      'Chiama un cacciatore che vola avanti e sceglie i bersagli';

  @override
  String get sigilDescWarden =>
      'Chiama un guardiano che incassa i colpi diretti a te';

  @override
  String get sigilDescFormation =>
      'I compagni alternano formazione larga e a cuneo';

  @override
  String get sigilDescWhirl =>
      'I compagni ti girano intorno e assorbono i colpi';

  @override
  String get sigilDescSacrifice =>
      'I compagni si lanciano ed esplodono, restituendo carica';

  @override
  String get grimoire => 'GRIMORIO';

  @override
  String get grimoireHint =>
      'Disegna con lo stick destro. Tieni LB per ARMS, RB per WING, entrambi per MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'costo $cost';
  }

  @override
  String get sigilUntouchable => 'invulnerabile';

  @override
  String get lessonWatch => 'GUARDA';

  @override
  String get lessonTrace => 'RICALCA';

  @override
  String get lessonSlow => 'PIANO';

  @override
  String get lessonLive => 'VELOCITÀ PIENA';

  @override
  String get lessonStreak => 'CINQUE DI FILA';

  @override
  String get lessonLearned => 'IMPARATO';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Scatta lo stick destro';

  @override
  String get hintLoop => 'Disegna un cerchio: voli sopra i colpi';

  @override
  String get hintStream => 'Premi LT: due o tre raffiche';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'NESSUNA';

  @override
  String kataNext(String sigil, String secs) {
    return 'prossimo $sigil tra $secs s';
  }

  @override
  String get arenaGauntlet => 'SFIDA';

  @override
  String get arenaOn => 'SÌ';

  @override
  String get arenaOff => 'NO';

  @override
  String gauntletRating(int rating, int best) {
    return 'Punteggio $rating · record $best';
  }

  @override
  String get duelWarning => 'ATTENZIONE';

  @override
  String get duelHintPad1 => 'Lo stick destro mira e spara';

  @override
  String get duelHintPad2Rt =>
      'Tieni RT, LB o RB: lo stick destro traccia i sigilli';

  @override
  String get duelHintPad2Lt =>
      'Tieni LT, LB o RB: lo stick destro traccia i sigilli';

  @override
  String get duelHintClassic =>
      'Lo stick sinistro vola · B, RB o RT sparano dove punta il muso';

  @override
  String get duelHintKeys1 => 'Le frecce mirano e sparano · WASD vola';

  @override
  String get duelHintKeys2 =>
      'Spazio spara dove punta il muso · il tastierino numerico traccia i sigilli';

  @override
  String get arenaDuelBinding => 'POSTURA DA DUELLO';

  @override
  String get duelBindingRt => 'RT + STICK';

  @override
  String get duelBindingLt => 'LT + STICK';

  @override
  String get arenaDuelFrame => 'AVANTI SUL PAD';

  @override
  String get duelFrameNose => 'IL MUSO';

  @override
  String get duelFrameUp => 'SU';

  @override
  String get arenaDuelAimFires => 'MIRARE SPARA';

  @override
  String get duelCutInFirst => 'PRIMO PIANO DEL BOSS: LA PRIMA VOLTA';

  @override
  String get duelCutInAlways => 'PRIMO PIANO DEL BOSS: SEMPRE';

  @override
  String get duelCutInNever => 'PRIMO PIANO DEL BOSS: MAI';

  @override
  String get arenaDuelDrill => 'ESERCIZIO DI DUELLO';

  @override
  String get duelDrillOff => 'NESSUNO';

  @override
  String get duelDrillAim => 'MIRA E SPARA';

  @override
  String get duelDrillAimHow => 'Punta lo stick destro sul boss e colpiscilo';

  @override
  String get duelDrillHold => 'TIENI IL MUSO';

  @override
  String get duelDrillHoldHow =>
      'Tieni un tasto di postura e vola: il muso resta fermo';

  @override
  String get duelDrillDraw => 'TRACCIA IN AVANTI';

  @override
  String get duelDrillDrawHow => 'In postura, traccia un sigillo verso il boss';

  @override
  String get duelDrillTurn => 'GIRATI';

  @override
  String get duelDrillTurnHow =>
      'Il boss è sotto di te: gira il muso e colpiscilo';

  @override
  String get duelDrillDone => 'FATTO';

  @override
  String get swapHint => 'Tocca con un secondo dito per cambiare armi';
}
