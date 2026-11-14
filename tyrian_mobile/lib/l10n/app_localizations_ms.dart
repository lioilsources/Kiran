// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'BATAL';

  @override
  String get connect => 'SAMBUNG';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Tidak dapat bersambung ke $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Hos kelihatan tetapi sambungan tidak terbentuk.\n\nPermainan berdekatan memerlukan Wi-Fi rakan ke rakan, yang dimatikan oleh iOS semasa Hotspot Peribadi aktif — matikan hotspot pada kedua-dua peranti dan cuba lagi, atau sambungkan kedua-dua peranti ke Wi-Fi yang sama.';

  @override
  String get gameOverCampaign =>
      'Misi gagal — kelengkapan dan kredit dikekalkan. Cuba lagi dari Pusat Kawalan.';

  @override
  String get gameOverEndless =>
      'Membina semula di Sektor 1 — kelengkapan dan kredit dikekalkan';

  @override
  String get waitingForHost => 'Menunggu hos...';

  @override
  String get waitingForHostHint => 'Permainan bermula apabila hos sedia';

  @override
  String get vesselLost => 'KAPAL HILANG';

  @override
  String scoreValue(String score) {
    return 'Skor: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Kredit: $credits';
  }

  @override
  String get creditsPrefix => 'Kredit: ';

  @override
  String get leaderboard => 'PAPAN MATA';

  @override
  String get achievements => 'PENCAPAIAN';

  @override
  String get redeploy => 'KEMBALI BERTEMPUR';

  @override
  String get resume => 'SAMBUNG SEMULA';

  @override
  String get pause => 'JEDA';

  @override
  String get paused => 'DIJEDA';

  @override
  String get skins => 'KULIT';

  @override
  String get skin => 'KULIT';

  @override
  String get soundOn => 'BUNYI: HIDUP';

  @override
  String get soundOff => 'BUNYI: MATI';

  @override
  String get musicOn => 'MUZIK: HIDUP';

  @override
  String get musicOff => 'MUZIK: MATI';

  @override
  String get statsOn => 'STATISTIK: HIDUP';

  @override
  String get statsOff => 'STATISTIK: MATI';

  @override
  String get mainMenu => 'MENU UTAMA';

  @override
  String get quitToDesktop => 'KELUAR KE DESKTOP';

  @override
  String get selectSkin => 'PILIH KULIT';

  @override
  String get difficulty => 'KESUKARAN';

  @override
  String get difficultyEasy => 'MUDAH';

  @override
  String get difficultyNormal => 'BIASA';

  @override
  String get difficultyHard => 'SUKAR';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KEMPEN';

  @override
  String get quit => 'KELUAR';

  @override
  String get restorePurchases => 'PULIHKAN PEMBELIAN';

  @override
  String get locked => 'DIKUNCI';

  @override
  String get mainMenuTooltip => 'Menu utama';

  @override
  String nodeLevel(int level) {
    return 'TAHAP $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'TAHAP $level · BOS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Dikunci. Selesaikan nod sebelumnya dahulu.';

  @override
  String get flyAgain => 'TERBANG LAGI';

  @override
  String get launch => 'LANCAR';

  @override
  String zoneLabel(int zone) {
    return 'ZON $zone';
  }

  @override
  String get objectiveStar => 'BINTANG';

  @override
  String get continueButton => 'TERUSKAN';

  @override
  String get replayNode => 'MAIN SEMULA NOD';

  @override
  String get retry => 'CUBA LAGI';

  @override
  String get nodeCleared => 'NOD SELESAI';

  @override
  String get nodeFailed => 'NOD GAGAL';

  @override
  String get weaponTierUnlocked => 'TAHAP SENJATA DIBUKA';

  @override
  String get onSaleInComCenter => 'Dijual di Pusat Kawalan.';

  @override
  String get requiredTasksHint =>
      'Tugasan wajib menentukan nod. Terbangkannya lagi — apa yang anda peroleh kekal milik anda.';

  @override
  String get objClear => 'Bersihkan sektor';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tembak jatuh $count musuh',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Jangan alami kerosakan badan kapal';

  @override
  String objHull(int percent) {
    return 'Tamat dengan badan kapal melebihi $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Musnahkan $count dengan $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Musnahkan $count dengan senapang sisi',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Berlepas dengan $weapon di hadapan';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Berlepas dengan $weapon pada lekapan sisi';
  }

  @override
  String get objBuySideGun => 'Beli senapang sisi di Pusat Kawalan';

  @override
  String objUpgradeGenerator(int level) {
    return 'Naik taraf penjana ke tahap $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Naik taraf senapang hadapan ke tahap $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Naik taraf senapang sisi ke tahap $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kutip $count bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hapuskan $count formasi sepenuhnya',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Jangan rempuh sebarang asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Selesaikan dalam $seconds s';
  }

  @override
  String get objStripBoss => 'Musnahkan setiap bahagian bos sebelum terasnya';

  @override
  String get joinCoopTitle => 'Sertai co-op';

  @override
  String get cannotSearchNetwork => 'Tidak dapat mencari dalam rangkaian ini';

  @override
  String get joinHintNearby =>
      'Wi-Fi yang sama berfungsi pada setiap peranti. iPhone, iPad dan Mac juga saling menemui secara berdekatan tanpanya — dengan Hotspot Peribadi dimatikan pada kedua-duanya.';

  @override
  String get joinHintWifi =>
      'Kedua-dua pemain mesti berada pada Wi-Fi yang sama — Hotspot Peribadi juga boleh.';

  @override
  String noHostsYet(String hint) {
    return 'Belum ada hos. $hint';
  }

  @override
  String get lookingForHosts => 'Mencari hos pada Wi-Fi ini dan berdekatan…';

  @override
  String get hostNearby => 'Berdekatan · Bluetooth / Wi-Fi rakan ke rakan';

  @override
  String hostSameWifi(String address) {
    return '$address · Wi-Fi sama';
  }

  @override
  String get enterIpManually => 'Masukkan IP secara manual';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'PRS';

  @override
  String get hudPower => 'KSA';

  @override
  String get hudGen => 'JANA';

  @override
  String bossShielded(String name) {
    return '$name — BERPERISAI';
  }

  @override
  String get bossPartTurret => 'Menara meriam';

  @override
  String get bossPartShieldPod => 'Modul perisai';

  @override
  String get bossPartThruster => 'Pendorong';

  @override
  String get bossPartCannon => 'Meriam';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Angkasa Tidak Diketahui';
  }

  @override
  String get player2Joined => 'Pemain 2 telah menyertai!';

  @override
  String get player2Disconnected => 'Pemain 2 terputus';

  @override
  String get hostDisconnected => 'Hos terputus';

  @override
  String maxLevelSold(String amount) {
    return 'Tahap maks! Dijual pada \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Tahap senjata $tier dibuka';
  }

  @override
  String get cheatsEnabled => 'Tipu helah dihidupkan';

  @override
  String get cheatsDisabled => 'Tipu helah dimatikan';

  @override
  String get cheatsMaxed => 'TIPU: kredit dimaksimumkan, semua senjata dibuka';

  @override
  String get cheats => 'TIPU HELAH';

  @override
  String get maxCredits => 'KREDIT MAKS';

  @override
  String get sectionStats => 'STATISTIK';

  @override
  String get sectionLoadout => 'KELENGKAPAN';

  @override
  String levelShort(int level) {
    return 'Tp.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'NAIK';

  @override
  String get sell => 'JUAL';

  @override
  String get buy => 'BELI';

  @override
  String get commandCenter => 'PUSAT KAWALAN';

  @override
  String get pilot => 'Juruterbang';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SKOR';

  @override
  String get nextWeapon => 'SENJATA SETERUSNYA';

  @override
  String pointsValue(String points) {
    return '$points mata';
  }

  @override
  String get slotFront => 'Depan';

  @override
  String get slotLeft => 'Kiri';

  @override
  String get slotRight => 'Kanan';

  @override
  String get slotGen => 'Jana';

  @override
  String get power => 'KSA';

  @override
  String get launchMission => 'LANCAR MISI';

  @override
  String get startMission => 'MULA MISI';

  @override
  String get continueMission => 'TERUSKAN MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Baris   [←→] Pilih   [B] Beli/Naik taraf/Tukar   [X/Y] Jual   [OPTIONS] Teruskan misi';

  @override
  String get host => 'HOS';

  @override
  String hostingAs(String name) {
    return 'MENJADI HOS sebagai $name';
  }

  @override
  String get join => 'SERTAI';

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
  String get overload => 'LEBIHAN BEBAN';

  @override
  String weaponOff(String weapon) {
    return '$weapon MATI — penjana terlalu lemah';
  }

  @override
  String unlocksAt(String points) {
    return 'Dibuka pada $points mata';
  }

  @override
  String joinConnecting(String target) {
    return 'Menyambung ke $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Hos tidak menjawab: $reason.\n\nKedua-dua pemain mesti berada pada Wi-Fi yang sama (Hotspot Peribadi juga boleh) dan hos mesti telah menekan HOS. Semak alamat dan cuba lagi.';
  }

  @override
  String get lanJoinNoAnswer => 'tiada jawapan';

  @override
  String objBossUnder(int seconds) {
    return 'Musnahkan teras bos dalam $seconds s selepas ia tiba';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'BILIK KEBAL';

  @override
  String get rackSide => 'Sisi';

  @override
  String get rackHull => 'Badan';

  @override
  String get rarityCommon => 'BIASA';

  @override
  String get rarityRare => 'JARANG';

  @override
  String get rarityMythic => 'MITOS';

  @override
  String get curse => 'SUMPAHAN';

  @override
  String get modFit => 'PASANG';

  @override
  String get modUnfit => 'TANGGAL';

  @override
  String get modForge => 'TEMPA';

  @override
  String get forgeHint =>
      'Pilih 3 daripada satu kelangkaan untuk menempa 1 kelangkaan seterusnya';

  @override
  String get vaultEmpty =>
      'Belum ada mod. Selesaikan nod dengan semua bintang, tewaskan bos dengan pantas atau tembak jatuh bos dalam mod tanpa henti.';

  @override
  String modNeeds(String families) {
    return 'Berfungsi dengan $families';
  }

  @override
  String get modRackFull => 'Rak penuh';

  @override
  String get modAlreadyFitted => 'Sudah dipasang';

  @override
  String get modWrongRack => 'Tidak sesuai dengan rak ini';

  @override
  String modsSpilled(int n) {
    return '$n mod kembali ke bilik kebal';
  }

  @override
  String get hullLocked => 'Dikunci';

  @override
  String hullUnlockBoss(int n) {
    return 'Tewaskan bos kempen $n';
  }

  @override
  String get hullUnlockFinish => 'Tamatkan kempen atau capai sektor 30';

  @override
  String get statAgility => 'TGS';

  @override
  String get statHitbox => 'KENA';

  @override
  String get perkNone => 'Kapal standard';

  @override
  String get perkAfterimage => 'Kekal pegun: tembakan ×1.5';

  @override
  String get perkBulwark => 'Kerosakan melepasi perisai dikurangkan separuh';

  @override
  String get perkOverclock => 'Menembak hingga 130 % kapasiti, lebih perlahan';

  @override
  String get perkBattery => 'Dron senapang percuma terbang bersama';

  @override
  String get rewardTitle => 'GANJARAN';

  @override
  String newHull(String name) {
    return 'Badan kapal baharu: $name';
  }

  @override
  String get socketEmpty => 'kosong';

  @override
  String fxStreams(int n) {
    return '$n aliran selari';
  }

  @override
  String fxFan(int n) {
    return 'Kipas $n tembakan';
  }

  @override
  String fxSalvo(int n) {
    return 'Salvo $n tembakan';
  }

  @override
  String fxFireRate(String x) {
    return 'Kadar tembakan ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Kerosakan ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Kelajuan tembakan ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Saiz tembakan ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Penggunaan kuasa ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Pengesan sasaran +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Menembusi $n sasaran';
  }

  @override
  String get fxPierceAll => 'Menembusi segalanya';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % peluang kerosakan ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Kritikal ×$x terhadap bos';
  }

  @override
  String fxFork(int n) {
    return 'Bunuhan menyembur $n tembakan';
  }

  @override
  String get fxChain => 'Tembakan semburan menyembur lagi';

  @override
  String get fxSplit => 'Terbelah dua apabila kena';

  @override
  String get fxFrost => 'Tembakan memperlahankan musuh';

  @override
  String get fxCrossfire => 'Senapang sisi condong ke dalam';

  @override
  String get fxRearguard => 'Senapang sisi juga menembak ke belakang';

  @override
  String get fxOrbit => 'Tembakan meliuk';

  @override
  String fxBounce(int n) {
    return 'Melantun dari dinding $n×';
  }

  @override
  String get fxBounceTop => '…dan dari atas';

  @override
  String get fxOverdrive => 'Menembak atas hutang kuasa';

  @override
  String get fxReactor => 'Senapang melebihi kapasiti masih menembak, perlahan';

  @override
  String fxGenPower(String x) {
    return 'Cas semula penjana ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Kapasiti penjana ×$x';
  }

  @override
  String get fxSurge => 'Penjana penuh: tembakan ×2';

  @override
  String fxSiphon(int pct) {
    return 'Bunuhan mengisi semula $pct % kuasa';
  }

  @override
  String fxHp(String x) {
    return 'Badan kapal ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Perisai ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Pemulihan perisai ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Bunuhan memulihkan $n HP';
  }

  @override
  String get fxMagnet => 'Menarik bonus';

  @override
  String get fxMagnetAll => 'Menarik setiap bonus';

  @override
  String fxReflect(int pct) {
    return '$pct % tembakan pada perisai terpantul semula';
  }

  @override
  String get fxReflectGuided => 'Tembakan terpantul mengesan sasaran';

  @override
  String fxGhost(String sec) {
    return 'Kebal $sec s selepas badan kapal terkena';
  }

  @override
  String get fxNova => 'Perisai pecah: seluruh skrin terkena letupan';

  @override
  String fxAgility(String x) {
    return 'Ketangkasan ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Kawasan kena ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Kredit ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Skor ×$x';
  }

  @override
  String get fxSatellite => 'Dron senapang terbang bersama';

  @override
  String get fxTimewarp => 'Badan kapal terkena memperlahankan masa';

  @override
  String get fxGambler => 'Setiap tembakan senjata rawak';

  @override
  String get vaultAll => 'SEMUA';

  @override
  String get sigilMissUnknown => 'bentuk tidak dikenali';

  @override
  String get sigilMissTooSlow => 'terlalu perlahan';

  @override
  String get sigilMissSkippedDot => 'terlepas satu titik';

  @override
  String get sigilMissLeftRimEarly => 'dilepas terlalu awal';

  @override
  String get sigilMissWrongDirection => 'dilukis terbalik';

  @override
  String get sigilMissWrongLayer => 'butang bahu salah';

  @override
  String get sigilDry => 'cas tidak cukup';

  @override
  String get sigilBusy => 'yang sebelum masih berjalan';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BAHAGIAN BOS';

  @override
  String get arenaBareCore => 'teras terdedah';

  @override
  String get arenaCompanions => 'PENEMAN';

  @override
  String get arenaCharge => 'CAS';

  @override
  String get arenaChargeNormal => 'BIASA';

  @override
  String get arenaSpeed => 'KELAJUAN DUNIA';

  @override
  String get arenaDrill => 'LATIHAN';

  @override
  String get arenaFreePlay => 'MAIN BEBAS';

  @override
  String get arenaFight => 'LAWAN';

  @override
  String get arenaNewBoss => 'BOS BARU';

  @override
  String get arenaLeave => 'TINGGALKAN ARENA';

  @override
  String get arenaHint =>
      'Bos kembali sebaik sahaja ia mati. Tiada apa disimpan di sini.';

  @override
  String get arenaColCast => 'GUNA';

  @override
  String get arenaColMiss => 'TERLEPAS';

  @override
  String get arenaColAvg => 'PURATA';

  @override
  String get arenaColBest => 'TERBAIK';

  @override
  String get arenaColTime => 'TERPANTAS';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bos $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGIL';

  @override
  String get padSchemeClassic => 'PAD: KLASIK';

  @override
  String get padSouthpawOn => 'KIDAL: HIDUP';

  @override
  String get padSouthpawOff => 'KIDAL: MATI';

  @override
  String get sigilDescHop => 'Lompatan pantas ke arah jentikan';

  @override
  String get sigilDescSidestep => 'Langkah sisi panjang merentas medan';

  @override
  String get sigilDescStrike =>
      'Menerpa ke depan dengan tiga tembakan berat, lalu undur';

  @override
  String get sigilDescRetreat =>
      'Berundur sambil tembakan perlindungan ke depan';

  @override
  String get sigilDescDash =>
      'Pecutan pepenjuru menembusi tembakan, kebal di tengah';

  @override
  String get sigilDescRoll => 'Gulingan tong ke sisi, kebal';

  @override
  String get sigilDescShadow =>
      'Kunci di bawah musuh terdekat dan terus menembak';

  @override
  String get sigilDescEcho =>
      'Bayang mengulang dua saat terakhir anda pada separuh kerosakan';

  @override
  String get sigilDescLoop => 'Gelung ke atas: tembakan lalu di bawah anda';

  @override
  String get sigilDescSlalom =>
      'Lengkung S merentas medan dengan tembakan kipas';

  @override
  String get sigilDescCorkscrew =>
      'Pusaran ke depan menembak sekeliling, kebal';

  @override
  String get sigilDescSnapshot => 'Satu tembakan berat ke arah jentikan';

  @override
  String get sigilDescBroadside => 'Salvo dari kedua-dua rusuk';

  @override
  String get sigilDescVolley => 'Lima sinar bercas ke depan';

  @override
  String get sigilDescCaltrop =>
      'Jatuhkan periuk api yang menelan tembakan dan meletup';

  @override
  String get sigilDescFrenzy => 'Senjata menembak lebih laju beberapa saat';

  @override
  String get sigilDescStasis => 'Musuh dan tembakannya perlahan separuh';

  @override
  String get sigilDescHalo =>
      'Perisai dicas empat kali lebih laju dan tiada yang tembus';

  @override
  String get sigilDescRadial => 'Gelang enam belas tembakan';

  @override
  String get sigilDescStorm => 'Semua senjata menembak penuh, percuma';

  @override
  String get sigilDescPing => 'Peneman menumpukan tembakan ke arah jentikan';

  @override
  String get sigilDescWingman => 'Panggil wingman ke rusuk yang dilukis';

  @override
  String get sigilDescHunter =>
      'Panggil pemburu yang terbang ke depan dan pilih sasaran';

  @override
  String get sigilDescWarden =>
      'Panggil penjaga yang menahan tembakan untuk anda';

  @override
  String get sigilDescFormation => 'Peneman bertukar antara lebar dan baji';

  @override
  String get sigilDescWhirl => 'Peneman mengelilingi anda dan menelan tembakan';

  @override
  String get sigilDescSacrifice =>
      'Peneman menjunam dan meletup, memulangkan cas';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Lukis dengan batang kanan. Tahan LB untuk ARMS, RB untuk WING, kedua-duanya untuk MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'kos $cost';
  }

  @override
  String get sigilUntouchable => 'kebal';

  @override
  String get lessonWatch => 'LIHAT';

  @override
  String get lessonTrace => 'SURIH';

  @override
  String get lessonSlow => 'PERLAHAN';

  @override
  String get lessonLive => 'KELAJUAN PENUH';

  @override
  String get lessonStreak => 'LIMA BERTURUT';

  @override
  String get lessonLearned => 'DIPELAJARI';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Jentik batang kanan';

  @override
  String get hintLoop => 'Lukis bulatan: anda terbang atas tembakan';

  @override
  String get hintStream => 'Picit LT: dua atau tiga aliran';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'TIADA';

  @override
  String kataNext(String sigil, String secs) {
    return '$sigil seterusnya dalam $secs s';
  }

  @override
  String get arenaGauntlet => 'CABARAN';

  @override
  String get arenaOn => 'HIDUP';

  @override
  String get arenaOff => 'MATI';

  @override
  String gauntletRating(int rating, int best) {
    return 'Penarafan $rating · terbaik $best';
  }

  @override
  String get duelWarning => 'AMARAN';

  @override
  String get duelHintPad1 => 'Batang kanan membidik dan menembak';

  @override
  String get duelHintPad2Rt =>
      'Tahan RT, LB atau RB: batang kanan melukis sigil';

  @override
  String get duelHintPad2Lt =>
      'Tahan LT, LB atau RB: batang kanan melukis sigil';

  @override
  String get duelHintClassic =>
      'Batang kiri terbang · B, RB atau RT tembak ke arah muncung';

  @override
  String get duelHintKeys1 => 'Anak panah bidik dan tembak · WASD terbang';

  @override
  String get duelHintKeys2 =>
      'Space tembak ke arah muncung · numpad melukis sigil';

  @override
  String get arenaDuelBinding => 'SIKAP DUEL';

  @override
  String get duelBindingRt => 'RT + BATANG';

  @override
  String get duelBindingLt => 'LT + BATANG';

  @override
  String get arenaDuelFrame => 'PAD KE DEPAN';

  @override
  String get duelFrameNose => 'MUNCUNG';

  @override
  String get duelFrameUp => 'ATAS';

  @override
  String get arenaDuelAimFires => 'BIDIK MENEMBAK';

  @override
  String get duelCutInFirst => 'DEKAT BOS: KALI PERTAMA';

  @override
  String get duelCutInAlways => 'DEKAT BOS: SENTIASA';

  @override
  String get duelCutInNever => 'DEKAT BOS: TIDAK PERNAH';

  @override
  String get arenaDuelDrill => 'LATIHAN DUEL';

  @override
  String get duelDrillOff => 'TIADA';

  @override
  String get duelDrillAim => 'BIDIK DAN TEMBAK';

  @override
  String get duelDrillAimHow => 'Halakan batang kanan ke bos dan kenakan';

  @override
  String get duelDrillHold => 'TAHAN MUNCUNG';

  @override
  String get duelDrillHoldHow =>
      'Tahan butang sikap dan terbang: muncung kekal';

  @override
  String get duelDrillDraw => 'LUKIS KE DEPAN';

  @override
  String get duelDrillDrawHow => 'Dalam sikap, lukis sigil ke arah bos';

  @override
  String get duelDrillTurn => 'PUSING';

  @override
  String get duelDrillTurnHow =>
      'Bos di bawah anda: pusing muncung dan kenakan';

  @override
  String get duelDrillDone => 'SELESAI';

  @override
  String get swapHint => 'Ketik dengan jari kedua untuk menukar senjata';
}
