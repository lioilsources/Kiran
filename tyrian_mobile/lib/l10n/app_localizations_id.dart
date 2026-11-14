// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'BATAL';

  @override
  String get connect => 'HUBUNGKAN';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Tidak dapat terhubung ke $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Host terlihat, tetapi tautan tidak tersambung.\n\nMain di sekitar butuh Wi-Fi peer-to-peer, yang dimatikan iOS selama Hotspot Pribadi aktif. Matikan hotspot di kedua perangkat lalu coba lagi, atau sambungkan keduanya ke Wi-Fi yang sama.';

  @override
  String get gameOverCampaign =>
      'Misi gagal — perlengkapan dan kredit tetap ada. Coba lagi dari Pusat Komando.';

  @override
  String get gameOverEndless =>
      'Membangun ulang di Sektor 1 — perlengkapan dan kredit tetap ada';

  @override
  String get waitingForHost => 'Menunggu host...';

  @override
  String get waitingForHostHint => 'Game dimulai saat host siap';

  @override
  String get vesselLost => 'KAPAL HANCUR';

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
  String get leaderboard => 'PAPAN PERINGKAT';

  @override
  String get achievements => 'PENCAPAIAN';

  @override
  String get redeploy => 'TERJUN LAGI';

  @override
  String get resume => 'LANJUTKAN';

  @override
  String get pause => 'JEDA';

  @override
  String get paused => 'DIJEDA';

  @override
  String get skins => 'SKIN';

  @override
  String get skin => 'SKIN';

  @override
  String get soundOn => 'SUARA: NYALA';

  @override
  String get soundOff => 'SUARA: MATI';

  @override
  String get musicOn => 'MUSIK: NYALA';

  @override
  String get musicOff => 'MUSIK: MATI';

  @override
  String get mainMenu => 'MENU UTAMA';

  @override
  String get quitToDesktop => 'KELUAR KE DESKTOP';

  @override
  String get selectSkin => 'PILIH SKIN';

  @override
  String get difficulty => 'KESULITAN';

  @override
  String get difficultyEasy => 'MUDAH';

  @override
  String get difficultyNormal => 'NORMAL';

  @override
  String get difficultyHard => 'SULIT';

  @override
  String get difficultyLord => 'LORD';

  @override
  String get campaign => 'KAMPANYE';

  @override
  String get quit => 'KELUAR';

  @override
  String get restorePurchases => 'PULIHKAN PEMBELIAN';

  @override
  String get locked => 'TERKUNCI';

  @override
  String get mainMenuTooltip => 'Menu utama';

  @override
  String nodeLevel(int level) {
    return 'LEVEL $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'LEVEL $level · BOS $ordinal';
  }

  @override
  String get nodeLockedHint => 'Terkunci. Selesaikan dulu misi sebelumnya.';

  @override
  String get flyAgain => 'TERBANG LAGI';

  @override
  String get launch => 'LUNCURKAN';

  @override
  String zoneLabel(int zone) {
    return 'ZONA $zone';
  }

  @override
  String get objectiveStar => 'BINTANG';

  @override
  String get continueButton => 'LANJUT';

  @override
  String get replayNode => 'ULANGI MISI';

  @override
  String get retry => 'COBA LAGI';

  @override
  String get nodeCleared => 'MISI SELESAI';

  @override
  String get nodeFailed => 'MISI GAGAL';

  @override
  String get weaponTierUnlocked => 'TINGKAT SENJATA BARU';

  @override
  String get onSaleInComCenter => 'Sudah dijual di Pusat Komando.';

  @override
  String get requiredTasksHint =>
      'Tugas wajib menentukan hasil misi. Terbangkan lagi — apa yang kamu dapat tetap milikmu.';

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
  String get objUntouched => 'Jangan terkena kerusakan lambung';

  @override
  String objHull(int percent) {
    return 'Selesai dengan lambung di atas $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hancurkan $count musuh dengan $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hancurkan $count musuh dengan senjata samping',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Luncurkan dengan $weapon di depan';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Luncurkan dengan $weapon di sisi';
  }

  @override
  String get objBuySideGun => 'Beli senjata samping di Pusat Komando';

  @override
  String objUpgradeGenerator(int level) {
    return 'Tingkatkan generator ke level $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Tingkatkan senjata depan ke level $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Tingkatkan senjata samping ke level $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ambil $count bonus',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Habisi $count formasi utuh',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Jangan tabrak asteroid';

  @override
  String objUnderTime(int seconds) {
    return 'Selesai dalam $seconds dtk';
  }

  @override
  String get objStripBoss => 'Hancurkan semua bagian bos sebelum intinya';

  @override
  String get joinCoopTitle => 'Gabung co-op';

  @override
  String get cannotSearchNetwork => 'Tidak bisa mencari di jaringan ini';

  @override
  String get joinHintNearby =>
      'Wi-Fi yang sama berfungsi di semua perangkat. iPhone, iPad, dan Mac juga saling menemukan dari dekat tanpa Wi-Fi — dengan Hotspot Pribadi mati di keduanya.';

  @override
  String get joinHintWifi =>
      'Kedua pemain harus di Wi-Fi yang sama — Hotspot Pribadi juga bisa.';

  @override
  String noHostsYet(String hint) {
    return 'Belum ada host. $hint';
  }

  @override
  String get lookingForHosts => 'Mencari host di Wi-Fi ini dan sekitar…';

  @override
  String get hostNearby => 'Di sekitar · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · Wi-Fi sama';
  }

  @override
  String get enterIpManually => 'Masukkan IP manual';

  @override
  String get hudHp => 'HP';

  @override
  String get hudShield => 'PRS';

  @override
  String get hudPower => 'DAYA';

  @override
  String get hudGen => 'GEN';

  @override
  String bossShielded(String name) {
    return '$name — BERPERISAI';
  }

  @override
  String get bossPartTurret => 'Turet';

  @override
  String get bossPartShieldPod => 'Modul Perisai';

  @override
  String get bossPartThruster => 'Pendorong';

  @override
  String get bossPartCannon => 'Meriam';

  @override
  String sectorUnknownSpace(int level) {
    return 'Sektor $level — Ruang Tak Dikenal';
  }

  @override
  String get player2Joined => 'Pemain 2 bergabung!';

  @override
  String get player2Disconnected => 'Pemain 2 terputus';

  @override
  String get hostDisconnected => 'Host terputus';

  @override
  String maxLevelSold(String amount) {
    return 'Level maks.! Terjual seharga \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Level senjata $tier terbuka';
  }

  @override
  String get cheatsEnabled => 'Cheat aktif';

  @override
  String get cheatsDisabled => 'Cheat nonaktif';

  @override
  String get cheatsMaxed => 'CHEAT: kredit maksimal, semua senjata terbuka';

  @override
  String get cheats => 'CHEAT';

  @override
  String get maxCredits => 'KREDIT MAKS';

  @override
  String get sectionStats => 'STATISTIK';

  @override
  String get sectionLoadout => 'PERSENJATAAN';

  @override
  String levelShort(int level) {
    return 'Lv.$level';
  }

  @override
  String get max => 'MAKS';

  @override
  String get upgradeShort => 'UPG';

  @override
  String get sell => 'JUAL';

  @override
  String get buy => 'BELI';

  @override
  String get commandCenter => 'PUSAT KOMANDO';

  @override
  String get pilot => 'Pilot';

  @override
  String get dps => 'DPS';

  @override
  String get score => 'SKOR';

  @override
  String get nextWeapon => 'SENJATA BERIKUTNYA';

  @override
  String pointsValue(String points) {
    return '$points poin';
  }

  @override
  String get slotFront => 'Depan';

  @override
  String get slotLeft => 'Kiri';

  @override
  String get slotRight => 'Kanan';

  @override
  String get slotGen => 'Gen';

  @override
  String get power => 'DAYA';

  @override
  String get launchMission => 'LUNCURKAN MISI';

  @override
  String get startMission => 'MULAI MISI';

  @override
  String get continueMission => 'LANJUTKAN MISI';

  @override
  String get padControlsHint =>
      '[↑↓] Baris   [←→] Pilih   [B] Beli/Tingkatkan/Ganti   [X/Y] Jual   [OPTIONS] Lanjut';

  @override
  String get host => 'JADI HOST';

  @override
  String hostingAs(String name) {
    return 'HOST: $name';
  }

  @override
  String get join => 'GABUNG';

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
  String get overload => 'KELEBIHAN BEBAN';

  @override
  String weaponOff(String weapon) {
    return '$weapon MATI — generator terlalu lemah';
  }

  @override
  String unlocksAt(String points) {
    return 'Terbuka di $points poin';
  }

  @override
  String joinConnecting(String target) {
    return 'Menghubungkan ke $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Host tidak menjawab: $reason.\n\nKedua pemain harus berada di Wi-Fi yang sama (Hotspot Pribadi juga bisa) dan host harus sudah menekan HOST. Periksa alamatnya lalu coba lagi.';
  }

  @override
  String get lanJoinNoAnswer => 'tidak ada balasan';

  @override
  String objBossUnder(int seconds) {
    return 'Hancurkan inti bos dalam $seconds dtk sejak kedatangannya';
  }

  @override
  String get sectionHangar => 'HANGAR';

  @override
  String get sectionVault => 'BRANKAS';

  @override
  String get rackSide => 'Samping';

  @override
  String get rackHull => 'Lambung';

  @override
  String get rarityCommon => 'BIASA';

  @override
  String get rarityRare => 'LANGKA';

  @override
  String get rarityMythic => 'MITIS';

  @override
  String get curse => 'KUTUKAN';

  @override
  String get modFit => 'PASANG';

  @override
  String get modUnfit => 'LEPAS';

  @override
  String get modForge => 'TEMPA';

  @override
  String get forgeHint =>
      'Pilih 3 dari satu kelangkaan untuk menempa 1 tingkat berikutnya';

  @override
  String get vaultEmpty =>
      'Belum ada mod. Selesaikan node dengan semua bintang, kalahkan bos dengan cepat, atau jatuhkan bos mode tanpa akhir.';

  @override
  String modNeeds(String families) {
    return 'Bekerja dengan $families';
  }

  @override
  String get modRackFull => 'Rak penuh';

  @override
  String get modAlreadyFitted => 'Sudah terpasang';

  @override
  String get modWrongRack => 'Tidak cocok untuk rak ini';

  @override
  String modsSpilled(int n) {
    return '$n mod kembali ke brankas';
  }

  @override
  String get hullLocked => 'Terkunci';

  @override
  String hullUnlockBoss(int n) {
    return 'Kalahkan bos kampanye $n';
  }

  @override
  String get hullUnlockFinish => 'Selesaikan kampanye atau capai sektor 30';

  @override
  String get statAgility => 'LIN';

  @override
  String get statHitbox => 'KEN';

  @override
  String get perkNone => 'Kapal standar';

  @override
  String get perkAfterimage => 'Diam: tembakan ×1,5';

  @override
  String get perkBulwark => 'Kerusakan tembus perisai jadi separuh';

  @override
  String get perkOverclock =>
      'Menembakkan senjata hingga 130 % kapasitas, lebih lambat';

  @override
  String get perkBattery => 'Drone gratis ikut terbang';

  @override
  String get rewardTitle => 'HADIAH';

  @override
  String newHull(String name) {
    return 'Lambung baru: $name';
  }

  @override
  String get socketEmpty => 'kosong';

  @override
  String fxStreams(int n) {
    return '$n aliran paralel';
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
    return 'Laju tembak ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Kerusakan ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Kecepatan tembakan ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Ukuran tembakan ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Konsumsi daya ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Pelacak +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Menembus $n sasaran';
  }

  @override
  String get fxPierceAll => 'Menembus semuanya';

  @override
  String fxCrit(int pct, String x) {
    return 'Peluang $pct % kerusakan ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Kritis ×$x pada bos';
  }

  @override
  String fxFork(int n) {
    return 'Kill menyebar $n tembakan';
  }

  @override
  String get fxChain => 'Tembakan sebar menyebar lagi';

  @override
  String get fxSplit => 'Terbelah dua saat kena';

  @override
  String get fxFrost => 'Kena tembakan memperlambat musuh';

  @override
  String get fxCrossfire => 'Senjata samping membidik ke tengah';

  @override
  String get fxRearguard => 'Senjata samping juga menembak ke belakang';

  @override
  String get fxOrbit => 'Tembakan meliuk';

  @override
  String fxBounce(int n) {
    return 'Memantul dari dinding $n×';
  }

  @override
  String get fxBounceTop => '…dan dari atas';

  @override
  String get fxOverdrive => 'Menembak meski utang daya';

  @override
  String get fxReactor => 'Senjata di atas kapasitas tetap menembak, pelan';

  @override
  String fxGenPower(String x) {
    return 'Isi ulang generator ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Kapasitas generator ×$x';
  }

  @override
  String get fxSurge => 'Generator penuh: tembakan ×2';

  @override
  String fxSiphon(int pct) {
    return 'Kill mengisi $pct % daya';
  }

  @override
  String fxHp(String x) {
    return 'Lambung ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Perisai ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Regenerasi perisai ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Kill memulihkan $n HP';
  }

  @override
  String get fxMagnet => 'Menarik item';

  @override
  String get fxMagnetAll => 'Menarik semua item';

  @override
  String fxReflect(int pct) {
    return '$pct % tembakan memantul dari perisai';
  }

  @override
  String get fxReflectGuided => 'Tembakan pantulan melacak';

  @override
  String fxGhost(String sec) {
    return 'Kebal $sec dtk setelah lambung terkena';
  }

  @override
  String get fxNova => 'Perisai pecah: ledakan di seluruh layar';

  @override
  String fxAgility(String x) {
    return 'Kelincahan ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Area kena ×$x';
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
  String get fxSatellite => 'Drone tempur ikut terbang';

  @override
  String get fxTimewarp => 'Lambung terkena memperlambat waktu';

  @override
  String get fxGambler => 'Setiap tembakan senjata acak';

  @override
  String get vaultAll => 'SEMUA';

  @override
  String get sigilMissUnknown => 'bentuk tidak dikenal';

  @override
  String get sigilMissTooSlow => 'terlalu lambat';

  @override
  String get sigilMissSkippedDot => 'titik terlewat';

  @override
  String get sigilMissLeftRimEarly => 'dilepas terlalu cepat';

  @override
  String get sigilMissWrongDirection => 'digambar terbalik';

  @override
  String get sigilMissWrongLayer => 'tombol bahu salah';

  @override
  String get sigilDry => 'muatan kurang';

  @override
  String get sigilBusy => 'yang sebelumnya masih berjalan';

  @override
  String get arena => 'ARENA';

  @override
  String get arenaBossParts => 'BAGIAN BOS';

  @override
  String get arenaBareCore => 'inti saja';

  @override
  String get arenaCompanions => 'PENDAMPING';

  @override
  String get arenaCharge => 'MUATAN';

  @override
  String get arenaChargeNormal => 'NORMAL';

  @override
  String get arenaSpeed => 'KECEPATAN DUNIA';

  @override
  String get arenaDrill => 'LATIHAN';

  @override
  String get arenaFreePlay => 'BEBAS';

  @override
  String get arenaFight => 'BERTARUNG';

  @override
  String get arenaNewBoss => 'BOS BARU';

  @override
  String get arenaLeave => 'KELUAR ARENA';

  @override
  String get arenaHint =>
      'Bos kembali begitu jatuh. Tidak ada yang disimpan di sini.';

  @override
  String get arenaColCast => 'BERHASIL';

  @override
  String get arenaColMiss => 'GAGAL';

  @override
  String get arenaColAvg => 'RATA²';

  @override
  String get arenaColBest => 'TERBAIK';

  @override
  String get arenaColTime => 'TERCEPAT';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Bos $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'PAD: SIGIL';

  @override
  String get padSchemeClassic => 'PAD: KLASIK';

  @override
  String get padSouthpawOn => 'KIDAL: AKTIF';

  @override
  String get padSouthpawOff => 'KIDAL: MATI';

  @override
  String get sigilDescHop => 'Lompatan cepat ke arah sentakan stik';

  @override
  String get sigilDescSidestep => 'Langkah samping jauh melintasi medan';

  @override
  String get sigilDescStrike =>
      'Terjang maju dengan tiga tembakan berat, lalu mundur';

  @override
  String get sigilDescRetreat =>
      'Mundur sambil tembakan perlindungan melaju ke depan';

  @override
  String get sigilDescDash =>
      'Melesat diagonal menembus tembakan, kebal di tengah jalan';

  @override
  String get sigilDescRoll => 'Gulingan tong ke samping, kebal';

  @override
  String get sigilDescShadow =>
      'Menempel di bawah musuh terdekat dan terus menembak';

  @override
  String get sigilDescEcho =>
      'Bayangan mengulang dua detik terakhirmu dengan separuh kerusakan';

  @override
  String get sigilDescLoop => 'Berputar lewat atas: tembakan lewat di bawahmu';

  @override
  String get sigilDescSlalom => 'Kurva S melintasi medan dengan tembakan kipas';

  @override
  String get sigilDescCorkscrew =>
      'Spiral maju sambil menembak ke segala arah, kebal';

  @override
  String get sigilDescSnapshot => 'Satu tembakan berat ke arah sentakan stik';

  @override
  String get sigilDescBroadside => 'Salvo dari kedua sisi';

  @override
  String get sigilDescVolley => 'Lima sinar bermuatan ke depan';

  @override
  String get sigilDescCaltrop =>
      'Jatuhkan ranjau yang menelan tembakan lalu meledak';

  @override
  String get sigilDescFrenzy =>
      'Senjata menembak lebih cepat selama beberapa detik';

  @override
  String get sigilDescStasis =>
      'Musuh dan tembakannya melambat ke separuh kecepatan';

  @override
  String get sigilDescHalo =>
      'Perisai terisi empat kali lebih cepat dan tak ada yang tembus';

  @override
  String get sigilDescRadial => 'Cincin enam belas tembakan';

  @override
  String get sigilDescStorm => 'Semua senjata menembak penuh, gratis';

  @override
  String get sigilDescPing =>
      'Pendamping memusatkan tembakan ke arah sentakan stik';

  @override
  String get sigilDescWingman => 'Panggil wingman ke sisi yang kamu gambar';

  @override
  String get sigilDescHunter =>
      'Panggil pemburu yang terbang di depan dan memilih sasaran';

  @override
  String get sigilDescWarden =>
      'Panggil penjaga yang menahan tembakan yang mengincarmu';

  @override
  String get sigilDescFormation =>
      'Pendamping beralih antara formasi lebar dan baji';

  @override
  String get sigilDescWhirl => 'Pendamping mengitarimu dan menelan tembakan';

  @override
  String get sigilDescSacrifice =>
      'Pendamping menukik dan meledak, mengembalikan muatan';

  @override
  String get grimoire => 'GRIMOIRE';

  @override
  String get grimoireHint =>
      'Gambar dengan stik kanan. Tahan LB untuk ARMS, RB untuk WING, keduanya untuk MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'biaya $cost';
  }

  @override
  String get sigilUntouchable => 'kebal';

  @override
  String get lessonWatch => 'LIHAT';

  @override
  String get lessonTrace => 'JIPLAK';

  @override
  String get lessonSlow => 'PELAN';

  @override
  String get lessonLive => 'KECEPATAN PENUH';

  @override
  String get lessonStreak => 'LIMA BERTURUT-TURUT';

  @override
  String get lessonLearned => 'DIKUASAI';

  @override
  String lessonTempo(int pct) {
    return 'TEMPO $pct %';
  }

  @override
  String get hintHop => 'Sentil stik kanan';

  @override
  String get hintLoop => 'Gambar lingkaran: kamu melayang di atas tembakan';

  @override
  String get hintStream => 'Tekan LT: dua atau tiga aliran';

  @override
  String get arenaKata => 'KATA';

  @override
  String get arenaKataOff => 'TIDAK ADA';

  @override
  String kataNext(String sigil, String secs) {
    return 'berikutnya $sigil dalam $secs dtk';
  }

  @override
  String get arenaGauntlet => 'TANTANGAN';

  @override
  String get arenaOn => 'AKTIF';

  @override
  String get arenaOff => 'MATI';

  @override
  String gauntletRating(int rating, int best) {
    return 'Nilai $rating · terbaik $best';
  }

  @override
  String get duelWarning => 'PERINGATAN';

  @override
  String get duelHintPad1 => 'Stik kanan membidik dan menembak';

  @override
  String get duelHintPad2Rt =>
      'Tahan RT, LB, atau RB: stik kanan menggambar sigil';

  @override
  String get duelHintPad2Lt =>
      'Tahan LT, LB, atau RB: stik kanan menggambar sigil';

  @override
  String get duelHintClassic =>
      'Stik kiri terbang · B, RB, atau RT menembak ke arah moncong';

  @override
  String get duelHintKeys1 => 'Panah membidik dan menembak · WASD terbang';

  @override
  String get duelHintKeys2 =>
      'Spasi menembak ke arah moncong · numpad menggambar sigil';

  @override
  String get arenaDuelBinding => 'KUDA-KUDA DUEL';

  @override
  String get duelBindingRt => 'RT + STIK';

  @override
  String get duelBindingLt => 'LT + STIK';

  @override
  String get arenaDuelFrame => 'DEPAN DI PAD';

  @override
  String get duelFrameNose => 'MONCONG';

  @override
  String get duelFrameUp => 'ATAS';

  @override
  String get arenaDuelAimFires => 'MEMBIDIK MENEMBAK';

  @override
  String get duelCutInFirst => 'CLOSE-UP BOS: PERTAMA KALI';

  @override
  String get duelCutInAlways => 'CLOSE-UP BOS: SELALU';

  @override
  String get duelCutInNever => 'CLOSE-UP BOS: TIDAK PERNAH';

  @override
  String get arenaDuelDrill => 'LATIHAN DUEL';

  @override
  String get duelDrillOff => 'TIDAK ADA';

  @override
  String get duelDrillAim => 'BIDIK DAN TEMBAK';

  @override
  String get duelDrillAimHow => 'Arahkan stik kanan ke bos dan kenai';

  @override
  String get duelDrillHold => 'TAHAN MONCONG';

  @override
  String get duelDrillHoldHow =>
      'Tahan tombol kuda-kuda dan terbang: moncong tetap diam';

  @override
  String get duelDrillDraw => 'GAMBAR KE DEPAN';

  @override
  String get duelDrillDrawHow => 'Dalam kuda-kuda, gambar sigil ke arah bos';

  @override
  String get duelDrillTurn => 'BERBALIK';

  @override
  String get duelDrillTurnHow => 'Bos ada di bawahmu: putar moncong dan kenai';

  @override
  String get duelDrillDone => 'SELESAI';

  @override
  String get swapHint => 'Ketuk dengan jari kedua untuk mengganti senjata';
}
