// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'PERUUTA';

  @override
  String get connect => 'YHDISTÄ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Yhteys kohteeseen $hostName epäonnistui';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Isäntä näkyi, mutta yhteys ei muodostunut.\n\nLähipeli vaatii vertaisverkko-Wi-Fin, jonka iOS sammuttaa, kun Oma yhteyspiste on päällä — sammuta yhteyspiste molemmista laitteista ja yritä uudelleen, tai yhdistä molemmat laitteet samaan Wi-Fi-verkkoon.';

  @override
  String get gameOverCampaign =>
      'Tehtävä epäonnistui — varustus ja krediitit säilyvät. Yritä uudelleen Komentokeskuksesta.';

  @override
  String get gameOverEndless =>
      'Jälleenrakennus sektorilla 1 — varustus ja krediitit säilyvät';

  @override
  String get waitingForHost => 'Odotetaan isäntää...';

  @override
  String get waitingForHostHint => 'Peli alkaa, kun isäntä on valmis';

  @override
  String get vesselLost => 'ALUS MENETETTY';

  @override
  String scoreValue(String score) {
    return 'Pisteet: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Krediitit: $credits';
  }

  @override
  String get creditsPrefix => 'Krediitit: ';

  @override
  String get leaderboard => 'TULOSTAULU';

  @override
  String get achievements => 'SAAVUTUKSET';

  @override
  String get redeploy => 'TAKAISIN TAISTELUUN';

  @override
  String get resume => 'JATKA';

  @override
  String get pause => 'TAUKO';

  @override
  String get paused => 'TAUOLLA';

  @override
  String get skins => 'ULKOASUT';

  @override
  String get skin => 'ULKOASU';

  @override
  String get soundOn => 'ÄÄNI: PÄÄLLÄ';

  @override
  String get soundOff => 'ÄÄNI: POIS';

  @override
  String get musicOn => 'MUSIIKKI: PÄÄLLÄ';

  @override
  String get musicOff => 'MUSIIKKI: POIS';

  @override
  String get statsOn => 'TILASTOT: PÄÄLLÄ';

  @override
  String get statsOff => 'TILASTOT: POIS';

  @override
  String get mainMenu => 'PÄÄVALIKKO';

  @override
  String get quitToDesktop => 'LOPETA TYÖPÖYDÄLLE';

  @override
  String get selectSkin => 'VALITSE ULKOASU';

  @override
  String get difficulty => 'VAIKEUSTASO';

  @override
  String get difficultyEasy => 'HELPPO';

  @override
  String get difficultyNormal => 'NORMAALI';

  @override
  String get difficultyHard => 'VAIKEA';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANJA';

  @override
  String get quit => 'LOPETA';

  @override
  String get restorePurchases => 'PALAUTA OSTOT';

  @override
  String get locked => 'LUKITTU';

  @override
  String get mainMenuTooltip => 'Päävalikko';

  @override
  String nodeLevel(int level) {
    return 'TASO $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'TASO $level · POMO $ordinal';
  }

  @override
  String get nodeLockedHint => 'Lukittu. Läpäise ensin edellinen solmu.';

  @override
  String get flyAgain => 'LENNÄ UUDELLEEN';

  @override
  String get launch => 'LÄHTÖ';

  @override
  String zoneLabel(int zone) {
    return 'VYÖHYKE $zone';
  }

  @override
  String get objectiveStar => 'TÄHTI';

  @override
  String get continueButton => 'JATKA';

  @override
  String get replayNode => 'PELAA SOLMU UUDELLEEN';

  @override
  String get retry => 'YRITÄ UUDELLEEN';

  @override
  String get nodeCleared => 'SOLMU LÄPÄISTY';

  @override
  String get nodeFailed => 'SOLMU EPÄONNISTUI';

  @override
  String get weaponTierUnlocked => 'ASETASO AVATTU';

  @override
  String get onSaleInComCenter => 'Myynnissä Komentokeskuksessa.';

  @override
  String get requiredTasksHint =>
      'Pakolliset tehtävät ratkaisevat solmun. Lennä se uudelleen — ansaitsemasi jää sinulle.';

  @override
  String get objClear => 'Tyhjennä sektori';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ammu alas $count vihollista',
      one: 'Ammu alas 1 vihollinen',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Älä ota runkovaurioita';

  @override
  String objHull(int percent) {
    return 'Lopeta yli $percent% rungolla';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tuhoa $count aseella $weapon',
      one: 'Tuhoa 1 aseella $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tuhoa $count sivutykeillä',
      one: 'Tuhoa 1 sivutykeillä',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Lähde liikkeelle $weapon edessä';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Lähde liikkeelle $weapon sivukiinnikkeessä';
  }

  @override
  String get objBuySideGun => 'Osta sivutykki Komentokeskuksesta';

  @override
  String objUpgradeGenerator(int level) {
    return 'Päivitä generaattori tasolle $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Päivitä etutykki tasolle $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Päivitä sivutykki tasolle $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nappaa $count bonusta',
      one: 'Nappaa 1 bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tuhoa $count kokonaista muodostelmaa',
      one: 'Tuhoa 1 kokonainen muodostelma',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Älä törmää asteroideihin';

  @override
  String objUnderTime(int seconds) {
    return 'Läpäise $seconds sekunnissa';
  }

  @override
  String get objStripBoss => 'Tuhoa pomon kaikki osat ennen ydintä';

  @override
  String get joinCoopTitle => 'Liity yhteispeliin';

  @override
  String get cannotSearchNetwork => 'Tätä verkkoa ei voi hakea';

  @override
  String get joinHintNearby =>
      'Sama Wi-Fi toimii kaikilla laitteilla. iPhone, iPad ja Mac löytävät toisensa lähellä myös ilman sitä — kun Oma yhteyspiste on pois molemmista.';

  @override
  String get joinHintWifi =>
      'Molempien pelaajien on oltava samassa Wi-Fi-verkossa — Oma yhteyspiste käy myös.';

  @override
  String noHostsYet(String hint) {
    return 'Ei vielä isäntiä. $hint';
  }

  @override
  String get lookingForHosts => 'Etsitään isäntiä tästä Wi-Fistä ja läheltä…';

  @override
  String get hostNearby => 'Lähellä · Bluetooth / vertaisverkko-Wi-Fi';

  @override
  String hostSameWifi(String address) {
    return '$address · sama Wi-Fi';
  }

  @override
  String get enterIpManually => 'Syötä IP käsin';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'SK';

  @override
  String get hudPower => 'EN';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — SUOJATTU';
  }

  @override
  String get bossPartTurret => 'Tykkitorni';

  @override
  String get bossPartShieldPod => 'Suojamoduuli';

  @override
  String get bossPartThruster => 'Moottori';

  @override
  String get bossPartCannon => 'Tykki';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektori $level — Tuntematon avaruus';
  }

  @override
  String get player2Joined => 'Pelaaja 2 liittyi!';

  @override
  String get player2Disconnected => 'Pelaaja 2 katkaisi yhteyden';

  @override
  String get hostDisconnected => 'Isäntä katkaisi yhteyden';

  @override
  String maxLevelSold(String amount) {
    return 'Maksimitaso! Myyty hintaan \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Asetaso $tier avattu';
  }

  @override
  String get cheatsEnabled => 'Huijaukset päällä';

  @override
  String get cheatsDisabled => 'Huijaukset pois';

  @override
  String get cheatsMaxed =>
      'HUIJAUS: krediitit maksimissa, kaikki aseet avattu';

  @override
  String get cheats => 'HUIJAUKSET';

  @override
  String get maxCredits => 'MAKS. KREDIITIT';

  @override
  String get sectionStats => 'TILASTOT';

  @override
  String get sectionLoadout => 'VARUSTUS';

  @override
  String levelShort(int level) {
    return 'Tl.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'PÄIV';

  @override
  String get sell => 'MYY';

  @override
  String get buy => 'OSTA';

  @override
  String get commandCenter => 'KOMENTOKESKUS';

  @override
  String get pilot => 'Lentäjä';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'PISTEET';

  @override
  String get nextWeapon => 'SEURAAVA ASE';

  @override
  String pointsValue(String points) {
    return '$points p';
  }

  @override
  String get slotFront => 'Etu';

  @override
  String get slotLeft => 'Vasen';

  @override
  String get slotRight => 'Oikea';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'EN';

  @override
  String get launchMission => 'LÄHETÄ TEHTÄVÄÄN';

  @override
  String get startMission => 'ALOITA TEHTÄVÄ';

  @override
  String get continueMission => 'JATKA TEHTÄVÄÄ';

  @override
  String get padControlsHint =>
      '[↑↓] Rivi   [←→] Valinta   [B] Osta/Päivitä/Vaihda   [X/Y] Myy   [OPTIONS] Jatka tehtävää';

  @override
  String get host => 'ISÄNNÖI';

  @override
  String hostingAs(String name) {
    return 'ISÄNTÄNÄ $name';
  }

  @override
  String get join => 'LIITY';

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
  String get overload => 'YLIKUORMA';

  @override
  String weaponOff(String weapon) {
    return '$weapon POIS — liian heikko generaattori';
  }

  @override
  String unlocksAt(String points) {
    return 'Avautuu $points pisteessä';
  }

  @override
  String joinConnecting(String target) {
    return 'Yhdistetään: $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Isäntä ei vastannut: $reason.\n\nMolempien pelaajien on oltava samassa Wi-Fi-verkossa (Oma yhteyspiste käy myös), ja isännän on täytynyt painaa ISÄNNÖI. Tarkista osoite ja yritä uudelleen.';
  }

  @override
  String get lanJoinNoAnswer => 'ei vastausta';

  @override
  String objBossUnder(int seconds) {
    return 'Tuhoa pomon ydin $seconds sekunnissa sen saapumisesta';
  }

  @override
  String get sectionHangar => 'HALLI';

  @override
  String get sectionVault => 'HOLVI';

  @override
  String get rackSide => 'Sivu';

  @override
  String get rackHull => 'Runko';

  @override
  String get rarityCommon => 'TAVALLINEN';

  @override
  String get rarityRare => 'HARVINAINEN';

  @override
  String get rarityMythic => 'MYYTTINEN';

  @override
  String get curse => 'KIROUS';

  @override
  String get modFit => 'ASENNA';

  @override
  String get modUnfit => 'IRROTA';

  @override
  String get modForge => 'PAJA';

  @override
  String get forgeHint =>
      'Valitse 3 samaa harvinaisuutta takoaksesi 1 seuraavaa';

  @override
  String get vaultEmpty =>
      'Ei vielä modeja. Läpäise solmu kaikilla tähdillä, voita pomo nopeasti tai ammu pomo alas loputtomassa tilassa.';

  @override
  String modNeeds(String families) {
    return 'Toimii näiden kanssa: $families';
  }

  @override
  String get modRackFull => 'Teline täynnä';

  @override
  String get modAlreadyFitted => 'Jo asennettu';

  @override
  String get modWrongRack => 'Ei sovi tähän telineeseen';

  @override
  String modsSpilled(int n) {
    return '$n modia takaisin holvissa';
  }

  @override
  String get hullLocked => 'Lukittu';

  @override
  String hullUnlockBoss(int n) {
    return 'Voita kampanjan pomo $n';
  }

  @override
  String get hullUnlockFinish => 'Läpäise kampanja tai saavuta sektori 30';

  @override
  String get statAgility => 'KET';

  @override
  String get statHitbox => 'OSU';

  @override
  String get perkNone => 'Vakioalus';

  @override
  String get perkAfterimage => 'Pysy paikallaan: laukaukset ×1,5';

  @override
  String get perkBulwark => 'Suojan läpi tuleva vahinko puolittuu';

  @override
  String get perkOverclock => 'Ampuu jopa 130 % kapasiteetista, hitaammin';

  @override
  String get perkBattery => 'Ilmainen taistelulennokki lentää mukana';

  @override
  String get rewardTitle => 'PALKINTO';

  @override
  String newHull(String name) {
    return 'Uusi runko: $name';
  }

  @override
  String get socketEmpty => 'tyhjä';

  @override
  String fxStreams(int n) {
    return '$n rinnakkaista suihkua';
  }

  @override
  String fxFan(int n) {
    return '$n laukauksen viuhka';
  }

  @override
  String fxSalvo(int n) {
    return '$n laukauksen sarja';
  }

  @override
  String fxFireRate(String x) {
    return 'Tulinopeus ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Vahinko ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Ammusnopeus ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Ammuskoko ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Energiankulutus ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Hakeutuva +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Läpäisee $n kohdetta';
  }

  @override
  String get fxPierceAll => 'Läpäisee kaiken';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % mahdollisuus ×$x vahinkoon';
  }

  @override
  String fxBossCrit(String x) {
    return '×$x kriittiset pomoihin';
  }

  @override
  String fxFork(int n) {
    return 'Kaadot sinkoavat $n laukausta';
  }

  @override
  String get fxChain => 'Sinkoutuneet laukaukset sinkoavat uudelleen';

  @override
  String get fxSplit => 'Jakautuu kahtia osuessaan';

  @override
  String get fxFrost => 'Osumat hidastavat vihollisia';

  @override
  String get fxCrossfire => 'Sivutykit tähtäävät sisäänpäin';

  @override
  String get fxRearguard => 'Sivutykit ampuvat myös taaksepäin';

  @override
  String get fxOrbit => 'Laukaukset kiemurtelevat';

  @override
  String fxBounce(int n) {
    return 'Kimpoaa seinistä $n×';
  }

  @override
  String get fxBounceTop => '…ja yläreunasta';

  @override
  String get fxOverdrive => 'Ampuu energiavelaksi';

  @override
  String get fxReactor => 'Ylikapasiteetin aseet ampuvat silti, hitaasti';

  @override
  String fxGenPower(String x) {
    return 'Generaattorin lataus ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Generaattorin kapasiteetti ×$x';
  }

  @override
  String get fxSurge => 'Täysi generaattori: laukaukset ×2';

  @override
  String fxSiphon(int pct) {
    return 'Kaadot palauttavat $pct % energiaa';
  }

  @override
  String fxHp(String x) {
    return 'Runko ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Suoja ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Suojan palautuminen ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Kaadot parantavat $n HP';
  }

  @override
  String get fxMagnet => 'Vetää bonuksia puoleensa';

  @override
  String get fxMagnetAll => 'Vetää kaikki bonukset puoleensa';

  @override
  String fxReflect(int pct) {
    return '$pct % laukauksista kimpoaa suojasta takaisin';
  }

  @override
  String get fxReflectGuided => 'Heijastetut laukaukset hakeutuvat';

  @override
  String fxGhost(String sec) {
    return 'Koskematon $sec s runko-osuman jälkeen';
  }

  @override
  String get fxNova => 'Suoja murtuu: koko ruutu saa räjähdyksen';

  @override
  String fxAgility(String x) {
    return 'Ketteryys ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Osuma-alue ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Krediitit ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Pisteet ×$x';
  }

  @override
  String get fxSatellite => 'Taistelulennokki lentää mukana';

  @override
  String get fxTimewarp => 'Runko-osuma hidastaa aikaa';

  @override
  String get fxGambler => 'Jokainen laukaus on satunnainen ase';

  @override
  String get vaultAll => 'KAIKKI';

  @override
  String get sigilMissUnknown => 'tuntematon muoto';

  @override
  String get sigilMissTooSlow => 'liian hidas';

  @override
  String get sigilMissSkippedDot => 'piste jäi väliin';

  @override
  String get sigilMissLeftRimEarly => 'päästit liian aikaisin';

  @override
  String get sigilMissWrongDirection => 'piirretty takaperin';

  @override
  String get sigilMissWrongLayer => 'väärä olkanäppäin';

  @override
  String get sigilDry => 'ei tarpeeksi latausta';

  @override
  String get sigilBusy => 'edellinen on yhä käynnissä';

  @override
  String get arena => 'AREENA';

  @override
  String get arenaBossParts => 'BOSSIN OSAT';

  @override
  String get arenaBareCore => 'paljas ydin';

  @override
  String get arenaCompanions => 'KUMPPANIT';

  @override
  String get arenaCharge => 'LATAUS';

  @override
  String get arenaChargeNormal => 'NORMAALI';

  @override
  String get arenaSpeed => 'MAAILMAN NOPEUS';

  @override
  String get arenaDrill => 'HARJOITUS';

  @override
  String get arenaFreePlay => 'VAPAA PELI';

  @override
  String get arenaFight => 'TAISTELE';

  @override
  String get arenaNewBoss => 'UUSI BOSSI';

  @override
  String get arenaLeave => 'POISTU AREENALTA';

  @override
  String get arenaHint => 'Bossi palaa heti kuoltuaan. Mitään ei tallenneta.';

  @override
  String get arenaColCast => 'LOITSUT';

  @override
  String get arenaColMiss => 'OHI';

  @override
  String get arenaColAvg => 'KA';

  @override
  String get arenaColBest => 'PARAS';

  @override
  String get arenaColTime => 'NOPEIN';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bossit $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGILLIT';

  @override
  String get padSchemeClassic => 'PAD: KLASSINEN';

  @override
  String get padSouthpawOn => 'VASENKÄTINEN: PÄÄLLÄ';

  @override
  String get padSouthpawOff => 'VASENKÄTINEN: POIS';

  @override
  String get sigilDescHop => 'Nopea hyppy pyyhkäisyn suuntaan';

  @override
  String get sigilDescSidestep => 'Pitkä sivuaskel kentän poikki';

  @override
  String get sigilDescStrike =>
      'Syöksy eteen kolmella raskaalla laukauksella ja takaisin';

  @override
  String get sigilDescRetreat => 'Vetäydy, kun suojatuli menee eteen';

  @override
  String get sigilDescDash => 'Vino syöksy tulen läpi, koskematon puolivälissä';

  @override
  String get sigilDescRoll => 'Tynnyripyörähdys sivulle, koskematon';

  @override
  String get sigilDescShadow =>
      'Lukitu lähimmän vihollisen alle ja ammu jatkuvasti';

  @override
  String get sigilDescEcho =>
      'Varjo toistaa kaksi viime sekuntiasi puolella vahingolla';

  @override
  String get sigilDescLoop => 'Silmukka yläkautta: laukaukset menevät alitse';

  @override
  String get sigilDescSlalom => 'S-kaarre kentän poikki viuhkatulella';

  @override
  String get sigilDescCorkscrew =>
      'Korkkiruuvi eteen ampuen joka suuntaan, koskematon';

  @override
  String get sigilDescSnapshot => 'Yksi raskas laukaus pyyhkäisyn suuntaan';

  @override
  String get sigilDescBroadside => 'Yhteislaukaus molemmilta kyljiltä';

  @override
  String get sigilDescVolley => 'Viisi ladattua sädettä eteen';

  @override
  String get sigilDescCaltrop =>
      'Pudota miina, joka nielee laukauksia ja räjähtää';

  @override
  String get sigilDescFrenzy => 'Aseet ampuvat nopeammin muutaman sekunnin';

  @override
  String get sigilDescStasis =>
      'Viholliset ja niiden laukaukset hidastuvat puoleen';

  @override
  String get sigilDescHalo =>
      'Kilpi latautuu neljä kertaa nopeammin, eikä mikään läpäise';

  @override
  String get sigilDescRadial => 'Kuudentoista laukauksen rengas';

  @override
  String get sigilDescStorm => 'Kaikki aseet täysillä, ilmaiseksi';

  @override
  String get sigilDescPing => 'Kumppanit keskittävät tulen pyyhkäisyn suuntaan';

  @override
  String get sigilDescWingman => 'Kutsu siipimies kyljelle, jota kohti piirsit';

  @override
  String get sigilDescHunter =>
      'Kutsu metsästäjä, joka lentää edellä ja valitsee kohteet';

  @override
  String get sigilDescWarden =>
      'Kutsu vartija, joka ottaa sinulle tarkoitetut laukaukset';

  @override
  String get sigilDescFormation =>
      'Kumppanit vaihtavat leveän ja kiilan välillä';

  @override
  String get sigilDescWhirl =>
      'Kumppanit kiertävät sinua ja nielevät laukauksia';

  @override
  String get sigilDescSacrifice =>
      'Kumppanit syöksyvät ja räjähtävät, palauttaen latausta';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Piirrä oikealla tikulla. Pidä LB = ASEET, RB = SIIPI, molemmat = MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'hinta $cost';
  }

  @override
  String get sigilUntouchable => 'koskematon';

  @override
  String get lessonWatch => 'KATSO';

  @override
  String get lessonTrace => 'JÄLJITÄ';

  @override
  String get lessonSlow => 'HITAASTI';

  @override
  String get lessonLive => 'TÄYSI VAUHTI';

  @override
  String get lessonStreak => 'VIISI PERÄKKÄIN';

  @override
  String get lessonLearned => 'OPITTU';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Pyyhkäise oikeaa tikkua';

  @override
  String get hintLoop => 'Piirrä ympyrä: lennät laukausten yli';

  @override
  String get hintStream => 'Purista LT: kaksi tai kolme suihkua';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'EI MITÄÄN';

  @override
  String kataNext(String sigil, String secs) {
    return 'seuraava $sigil $secs s päästä';
  }

  @override
  String get arenaGauntlet => 'KUJANJUOKSU';

  @override
  String get arenaOn => 'PÄÄLLÄ';

  @override
  String get arenaOff => 'POIS';

  @override
  String gauntletRating(int rating, int best) {
    return 'Arvio $rating · paras $best';
  }

  @override
  String get duelWarning => 'VAROITUS';

  @override
  String get duelHintPad1 => 'Oikea tikku tähtää ja ampuu';

  @override
  String get duelHintPad2Rt =>
      'Pidä RT, LB tai RB: oikea tikku piirtää sigillejä';

  @override
  String get duelHintPad2Lt =>
      'Pidä LT, LB tai RB: oikea tikku piirtää sigillejä';

  @override
  String get duelHintClassic =>
      'Vasen tikku lentää · B, RB tai RT ampuu keulan suuntaan';

  @override
  String get duelHintKeys1 => 'Nuolet tähtäävät ja ampuvat · WASD lentää';

  @override
  String get duelHintKeys2 =>
      'Välilyönti ampuu keulan suuntaan · numeronäppäimet piirtävät';

  @override
  String get arenaDuelBinding => 'KAKSINTAISTELUASENTO';

  @override
  String get duelBindingRt => 'RT + TIKKU';

  @override
  String get duelBindingLt => 'LT + TIKKU';

  @override
  String get arenaDuelFrame => 'PADIN ETEENPÄIN';

  @override
  String get duelFrameNose => 'KEULA';

  @override
  String get duelFrameUp => 'YLÖS';

  @override
  String get arenaDuelAimFires => 'TÄHTÄYS AMPUU';

  @override
  String get duelCutInFirst => 'BOSSIN LÄHIKUVA: 1. KERTA';

  @override
  String get duelCutInAlways => 'BOSSIN LÄHIKUVA: AINA';

  @override
  String get duelCutInNever => 'BOSSIN LÄHIKUVA: EI KOSKAAN';

  @override
  String get arenaDuelDrill => 'TAISTELUHARJOITUS';

  @override
  String get duelDrillOff => 'EI MITÄÄN';

  @override
  String get duelDrillAim => 'TÄHTÄÄ JA AMMU';

  @override
  String get duelDrillAimHow => 'Osoita oikealla tikulla bossia ja osu';

  @override
  String get duelDrillHold => 'PIDÄ KEULA';

  @override
  String get duelDrillHoldHow =>
      'Pidä asentonäppäintä ja lennä: keula pysyy paikallaan';

  @override
  String get duelDrillDraw => 'PIIRRÄ ETEEN';

  @override
  String get duelDrillDrawHow => 'Asennossa piirrä sigilli bossia kohti';

  @override
  String get duelDrillTurn => 'KÄÄNNY';

  @override
  String get duelDrillTurnHow => 'Bossi on alapuolella: käännä keula ja osu';

  @override
  String get duelDrillDone => 'VALMIS';
}
