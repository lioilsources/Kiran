// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'СКАСУВАТИ';

  @override
  String get connect => 'ПІДКЛЮЧИТИ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Не вдалося підключитися до $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Хост був видимий, але з\'єднання не встановилося.\n\nГра поруч потребує Wi-Fi peer-to-peer, який iOS вимикає, поки увімкнено Режим модема — вимкніть його на обох пристроях і спробуйте знову або підключіть обидва пристрої до однієї Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Місію провалено — спорядження й кредити збережено. Спробуйте знову з Командного центру.';

  @override
  String get gameOverEndless =>
      'Відновлення в Секторі 1 — спорядження й кредити збережено';

  @override
  String get waitingForHost => 'Очікування хоста...';

  @override
  String get waitingForHostHint => 'Гра почнеться, коли хост буде готовий';

  @override
  String get vesselLost => 'КОРАБЕЛЬ ВТРАЧЕНО';

  @override
  String scoreValue(String score) {
    return 'Рахунок: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Кредити: $credits';
  }

  @override
  String get creditsPrefix => 'Кредити: ';

  @override
  String get leaderboard => 'РЕЙТИНГ';

  @override
  String get achievements => 'ДОСЯГНЕННЯ';

  @override
  String get redeploy => 'ДО БОЮ';

  @override
  String get resume => 'ПРОДОВЖИТИ';

  @override
  String get pause => 'ПАУЗА';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get skins => 'СКІНИ';

  @override
  String get skin => 'СКІН';

  @override
  String get soundOn => 'ЗВУК: УВІМК.';

  @override
  String get soundOff => 'ЗВУК: ВИМК.';

  @override
  String get musicOn => 'МУЗИКА: УВІМК.';

  @override
  String get musicOff => 'МУЗИКА: ВИМК.';

  @override
  String get statsOn => 'СТАТИСТИКА: УВІМК.';

  @override
  String get statsOff => 'СТАТИСТИКА: ВИМК.';

  @override
  String get mainMenu => 'ГОЛОВНЕ МЕНЮ';

  @override
  String get quitToDesktop => 'ВИЙТИ НА РОБОЧИЙ СТІЛ';

  @override
  String get selectSkin => 'ВИБЕРІТЬ СКІН';

  @override
  String get difficulty => 'СКЛАДНІСТЬ';

  @override
  String get difficultyEasy => 'ЛЕГКО';

  @override
  String get difficultyNormal => 'НОРМАЛЬНО';

  @override
  String get difficultyHard => 'ВАЖКО';

  @override
  String get difficultyLord => 'ЛОРД';

  @override
  String get campaign => 'КАМПАНІЯ';

  @override
  String get quit => 'ВИЙТИ';

  @override
  String get restorePurchases => 'ВІДНОВИТИ ПОКУПКИ';

  @override
  String get locked => 'ЗАБЛОКОВАНО';

  @override
  String get mainMenuTooltip => 'Головне меню';

  @override
  String nodeLevel(int level) {
    return 'РІВЕНЬ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'РІВЕНЬ $level · БОС $ordinal';
  }

  @override
  String get nodeLockedHint => 'Заблоковано. Спершу пройдіть попередній вузол.';

  @override
  String get flyAgain => 'ЛЕТІТИ ЗНОВУ';

  @override
  String get launch => 'СТАРТ';

  @override
  String zoneLabel(int zone) {
    return 'ЗОНА $zone';
  }

  @override
  String get objectiveStar => 'ЗІРКА';

  @override
  String get continueButton => 'ДАЛІ';

  @override
  String get replayNode => 'ПОВТОРИТИ ВУЗОЛ';

  @override
  String get retry => 'ЩЕ РАЗ';

  @override
  String get nodeCleared => 'ВУЗОЛ ПРОЙДЕНО';

  @override
  String get nodeFailed => 'ВУЗОЛ ПРОВАЛЕНО';

  @override
  String get weaponTierUnlocked => 'ВІДКРИТО РІВЕНЬ ЗБРОЇ';

  @override
  String get onSaleInComCenter => 'У продажу в Командному центрі.';

  @override
  String get requiredTasksHint =>
      'Долю вузла вирішують обов\'язкові завдання. Летіть знову — здобуте залишається з вами.';

  @override
  String get objClear => 'Очистіть сектор';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Збийте $count ворога',
      many: 'Збийте $count ворогів',
      few: 'Збийте $count ворогів',
      one: 'Збийте $count ворога',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Не отримайте пошкоджень корпусу';

  @override
  String objHull(int percent) {
    return 'Завершіть із корпусом понад $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знищте $count ворога зброєю $weapon',
      many: 'Знищте $count ворогів зброєю $weapon',
      few: 'Знищте $count ворогів зброєю $weapon',
      one: 'Знищте $count ворога зброєю $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знищте $count ворога бічними гарматами',
      many: 'Знищте $count ворогів бічними гарматами',
      few: 'Знищте $count ворогів бічними гарматами',
      one: 'Знищте $count ворога бічними гарматами',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Вилетіть зі зброєю $weapon спереду';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Вилетіть зі зброєю $weapon на боці';
  }

  @override
  String get objBuySideGun => 'Купіть бічну гармату в Командному центрі';

  @override
  String objUpgradeGenerator(int level) {
    return 'Покращте генератор до рівня $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Покращте передню гармату до рівня $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Покращте бічну гармату до рівня $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зберіть $count бонусу',
      many: 'Зберіть $count бонусів',
      few: 'Зберіть $count бонуси',
      one: 'Зберіть $count бонус',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знищте $count формації повністю',
      many: 'Знищте $count формацій повністю',
      few: 'Знищте $count формації повністю',
      one: 'Знищте $count формацію повністю',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Не тараньте астероїди';

  @override
  String objUnderTime(int seconds) {
    return 'Завершіть за $seconds с';
  }

  @override
  String get objStripBoss => 'Знищте всі частини боса до ядра';

  @override
  String get joinCoopTitle => 'Приєднатися до кооперативу';

  @override
  String get cannotSearchNetwork => 'У цій мережі неможливо шукати';

  @override
  String get joinHintNearby =>
      'Спільна Wi-Fi працює на всіх пристроях. iPhone, iPad і Mac також знаходять одне одного поруч без неї — з вимкненим Режимом модема на обох.';

  @override
  String get joinHintWifi =>
      'Обидва гравці мають бути в одній Wi-Fi — Режим модема теж підходить.';

  @override
  String noHostsYet(String hint) {
    return 'Хостів поки немає. $hint';
  }

  @override
  String get lookingForHosts => 'Пошук хостів у цій Wi-Fi і поруч…';

  @override
  String get hostNearby => 'Поруч · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · та сама Wi-Fi';
  }

  @override
  String get enterIpManually => 'Ввести IP вручну';

  @override
  String get hudHp => 'МЦ';

  @override
  String get hudShield => 'ЩИТ';

  @override
  String get hudPower => 'ЕН';

  @override
  String get hudGen => 'ГЕН';

  @override
  String bossShielded(String name) {
    return '$name — ПІД ЩИТОМ';
  }

  @override
  String get bossPartTurret => 'Турель';

  @override
  String get bossPartShieldPod => 'Щитовий модуль';

  @override
  String get bossPartThruster => 'Двигун';

  @override
  String get bossPartCannon => 'Гармата';

  @override
  String sectorUnknownSpace(int level) {
    return 'Сектор $level — Невідомий космос';
  }

  @override
  String get player2Joined => 'Гравець 2 приєднався!';

  @override
  String get player2Disconnected => 'Гравець 2 відключився';

  @override
  String get hostDisconnected => 'Хост відключився';

  @override
  String maxLevelSold(String amount) {
    return 'Макс. рівень! Продано за \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Відкрито рівень зброї $tier';
  }

  @override
  String get cheatsEnabled => 'Чити увімкнено';

  @override
  String get cheatsDisabled => 'Чити вимкнено';

  @override
  String get cheatsMaxed => 'ЧИТ: кредити на максимумі, уся зброя відкрита';

  @override
  String get cheats => 'ЧИТИ';

  @override
  String get maxCredits => 'МАКС. КРЕДИТИ';

  @override
  String get sectionStats => 'СТАТИСТИКА';

  @override
  String get sectionLoadout => 'СПОРЯДЖЕННЯ';

  @override
  String levelShort(int level) {
    return 'Р.$level';
  }

  @override
  String get max => 'МАКС';

  @override
  String get upgradeShort => 'ПОКР';

  @override
  String get sell => 'ПРОДАТИ';

  @override
  String get buy => 'КУПИТИ';

  @override
  String get commandCenter => 'КОМАНДНИЙ ЦЕНТР';

  @override
  String get pilot => 'Пілот';

  @override
  String get dps => 'ШВУ';

  @override
  String get score => 'РАХУНОК';

  @override
  String get nextWeapon => 'НАСТУПНА ЗБРОЯ';

  @override
  String pointsValue(String points) {
    return '$points оч.';
  }

  @override
  String get slotFront => 'Перед';

  @override
  String get slotLeft => 'Ліво';

  @override
  String get slotRight => 'Право';

  @override
  String get slotGen => 'Ген';

  @override
  String get power => 'ЕН';

  @override
  String get launchMission => 'ПОЧАТИ МІСІЮ';

  @override
  String get startMission => 'РОЗПОЧАТИ МІСІЮ';

  @override
  String get continueMission => 'ПРОДОВЖИТИ МІСІЮ';

  @override
  String get padControlsHint =>
      '[↑↓] Ряд   [←→] Вибір   [B] Купити/Покращити/Змінити   [X/Y] Продати   [OPTIONS] Продовжити місію';

  @override
  String get host => 'ХОСТ';

  @override
  String hostingAs(String name) {
    return 'ХОСТ як $name';
  }

  @override
  String get join => 'ПРИЄДНАТИСЯ';

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
  String get overload => 'ПЕРЕВАНТАЖЕННЯ';

  @override
  String weaponOff(String weapon) {
    return '$weapon ВИМК. — слабкий генератор';
  }

  @override
  String unlocksAt(String points) {
    return 'Відкриється на $points оч.';
  }

  @override
  String joinConnecting(String target) {
    return 'Підключення до $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Хост не відповів: $reason.\n\nОбидва гравці мають бути в одній Wi-Fi (Режим модема теж підходить), а хост має натиснути ХОСТ. Перевірте адресу й спробуйте знову.';
  }

  @override
  String get lanJoinNoAnswer => 'немає відповіді';

  @override
  String objBossUnder(int seconds) {
    return 'Знищте ядро боса за $seconds с після його появи';
  }

  @override
  String get sectionHangar => 'АНГАР';

  @override
  String get sectionVault => 'СХОВИЩЕ';

  @override
  String get rackSide => 'Бік';

  @override
  String get rackHull => 'Корпус';

  @override
  String get rarityCommon => 'ЗВИЧАЙНИЙ';

  @override
  String get rarityRare => 'РІДКІСНИЙ';

  @override
  String get rarityMythic => 'МІФІЧНИЙ';

  @override
  String get curse => 'ПРОКЛЯТТЯ';

  @override
  String get modFit => 'ВСТАНОВИТИ';

  @override
  String get modUnfit => 'ЗНЯТИ';

  @override
  String get modForge => 'КУЗНЯ';

  @override
  String get forgeHint =>
      'Виберіть 3 однієї рідкісності, щоб викувати 1 наступної';

  @override
  String get vaultEmpty =>
      'Модів поки немає. Пройдіть вузол на всі зірки, швидко переможіть боса або збийте боса в нескінченному режимі.';

  @override
  String modNeeds(String families) {
    return 'Працює з: $families';
  }

  @override
  String get modRackFull => 'Стійка заповнена';

  @override
  String get modAlreadyFitted => 'Уже встановлено';

  @override
  String get modWrongRack => 'Не підходить до цієї стійки';

  @override
  String modsSpilled(int n) {
    return 'Модів повернуто в сховище: $n';
  }

  @override
  String get hullLocked => 'Заблоковано';

  @override
  String hullUnlockBoss(int n) {
    return 'Переможіть боса кампанії $n';
  }

  @override
  String get hullUnlockFinish => 'Пройдіть кампанію або досягніть сектора 30';

  @override
  String get statAgility => 'СПР';

  @override
  String get statHitbox => 'ВРАЗ';

  @override
  String get perkNone => 'Серійний корабель';

  @override
  String get perkAfterimage => 'Завмріть: постріли ×1,5';

  @override
  String get perkBulwark => 'Шкода крізь щит удвічі менша';

  @override
  String get perkOverclock => 'Стріляє до 130 % потужності, повільніше';

  @override
  String get perkBattery => 'З вами летить безкоштовний бойовий дрон';

  @override
  String get rewardTitle => 'НАГОРОДА';

  @override
  String newHull(String name) {
    return 'Новий корпус: $name';
  }

  @override
  String get socketEmpty => 'порожньо';

  @override
  String fxStreams(int n) {
    return 'Паралельних потоків: $n';
  }

  @override
  String fxFan(int n) {
    return 'Віяло з $n пострілів';
  }

  @override
  String fxSalvo(int n) {
    return 'Залп із $n пострілів';
  }

  @override
  String fxFireRate(String x) {
    return 'Скорострільність ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Шкода ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Швидкість пострілів ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Розмір пострілів ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Витрата енергії ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Наведення +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Пробиває цілей: $n';
  }

  @override
  String get fxPierceAll => 'Пробиває все';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % шанс на шкоду ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Крити ×$x по босах';
  }

  @override
  String fxFork(int n) {
    return 'Знищення розкидають $n пострілів';
  }

  @override
  String get fxChain => 'Розкидані постріли розкидаються знову';

  @override
  String get fxSplit => 'При влучанні ділиться надвоє';

  @override
  String get fxFrost => 'Влучання сповільнюють ворогів';

  @override
  String get fxCrossfire => 'Бічні гармати цілять усередину';

  @override
  String get fxRearguard => 'Бічні гармати стріляють і назад';

  @override
  String get fxOrbit => 'Постріли петляють';

  @override
  String fxBounce(int n) {
    return 'Відбивається від стін $n×';
  }

  @override
  String get fxBounceTop => '…і від верху';

  @override
  String get fxOverdrive => 'Стріляє в борг енергії';

  @override
  String get fxReactor => 'Перевантажена зброя все одно стріляє, повільно';

  @override
  String fxGenPower(String x) {
    return 'Заряджання генератора ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Ємність генератора ×$x';
  }

  @override
  String get fxSurge => 'Повний генератор: постріли ×2';

  @override
  String fxSiphon(int pct) {
    return 'Знищення відновлюють $pct % енергії';
  }

  @override
  String fxHp(String x) {
    return 'Корпус ×$x';
  }

  @override
  String fxShield(String x) {
    return 'Щит ×$x';
  }

  @override
  String fxRegen(String x) {
    return 'Регенерація щита ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Знищення лікують $n МЦ';
  }

  @override
  String get fxMagnet => 'Притягує бонуси';

  @override
  String get fxMagnetAll => 'Притягує всі бонуси';

  @override
  String fxReflect(int pct) {
    return '$pct % пострілів відбиваються від щита назад';
  }

  @override
  String get fxReflectGuided => 'Відбиті постріли самонавідні';

  @override
  String fxGhost(String sec) {
    return 'Невразливість $sec с після влучання в корпус';
  }

  @override
  String get fxNova => 'Щит пробито: вибух на весь екран';

  @override
  String fxAgility(String x) {
    return 'Спритність ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Зона ураження ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Кредити ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Рахунок ×$x';
  }

  @override
  String get fxSatellite => 'З вами летить бойовий дрон';

  @override
  String get fxTimewarp => 'Влучання в корпус сповільнює час';

  @override
  String get fxGambler => 'Кожен постріл — випадкова зброя';

  @override
  String get vaultAll => 'УСІ';

  @override
  String get sigilMissUnknown => 'невідома форма';

  @override
  String get sigilMissTooSlow => 'надто повільно';

  @override
  String get sigilMissSkippedDot => 'пропущено точку';

  @override
  String get sigilMissLeftRimEarly => 'відпущено зарано';

  @override
  String get sigilMissWrongDirection => 'намальовано навпаки';

  @override
  String get sigilMissWrongLayer => 'не та плечова кнопка';

  @override
  String get sigilDry => 'замало заряду';

  @override
  String get sigilBusy => 'попередній ще діє';

  @override
  String get arena => 'АРЕНА';

  @override
  String get arenaBossParts => 'ЧАСТИНИ БОСА';

  @override
  String get arenaBareCore => 'оголене ядро';

  @override
  String get arenaCompanions => 'СУПУТНИКИ';

  @override
  String get arenaCharge => 'ЗАРЯД';

  @override
  String get arenaChargeNormal => 'ЗВИЧАЙНИЙ';

  @override
  String get arenaSpeed => 'ШВИДКІСТЬ СВІТУ';

  @override
  String get arenaDrill => 'ТРЕНУВАННЯ';

  @override
  String get arenaFreePlay => 'ВІЛЬНА ГРА';

  @override
  String get arenaFight => 'БІЙ';

  @override
  String get arenaNewBoss => 'НОВИЙ БОС';

  @override
  String get arenaLeave => 'ПОКИНУТИ АРЕНУ';

  @override
  String get arenaHint =>
      'Бос повертається, щойно гине. Тут нічого не зберігається.';

  @override
  String get arenaColCast => 'ЗАСТОСУВ.';

  @override
  String get arenaColMiss => 'ПРОМАХИ';

  @override
  String get arenaColAvg => 'СЕРЕД.';

  @override
  String get arenaColBest => 'НАЙКРАЩЕ';

  @override
  String get arenaColTime => 'НАЙШВИДШЕ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Боси $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ГЕЙМПАД: СИГІЛИ';

  @override
  String get padSchemeClassic => 'ГЕЙМПАД: КЛАСИКА';

  @override
  String get padSouthpawOn => 'ЛІВША: УВІМК.';

  @override
  String get padSouthpawOff => 'ЛІВША: ВИМК.';

  @override
  String get sigilDescHop => 'Швидкий стрибок у бік ривка';

  @override
  String get sigilDescSidestep => 'Довгий крок убік через поле';

  @override
  String get sigilDescStrike =>
      'Випад уперед із трьома важкими пострілами й назад';

  @override
  String get sigilDescRetreat =>
      'Відступ, поки прикривальний вогонь летить уперед';

  @override
  String get sigilDescDash =>
      'Діагональний ривок крізь вогонь, невразливий посередині';

  @override
  String get sigilDescRoll => 'Бочка вбік, невразливий';

  @override
  String get sigilDescShadow => 'Зачепися під найближчим ворогом і стріляй';

  @override
  String get sigilDescEcho =>
      'Тінь повторює твої останні дві секунди з половинною шкодою';

  @override
  String get sigilDescLoop => 'Петля згори: постріли проходять під тобою';

  @override
  String get sigilDescSlalom => 'S-подібна крива через поле з віялом вогню';

  @override
  String get sigilDescCorkscrew =>
      'Штопор уперед із вогнем довкола, невразливий';

  @override
  String get sigilDescSnapshot => 'Один важкий постріл у бік ривка';

  @override
  String get sigilDescBroadside => 'Залп з обох флангів';

  @override
  String get sigilDescVolley => 'П\'ять заряджених променів уперед';

  @override
  String get sigilDescCaltrop => 'Скинь міну, що ковтає постріли й вибухає';

  @override
  String get sigilDescFrenzy => 'Гармати кілька секунд стріляють швидше';

  @override
  String get sigilDescStasis => 'Вороги та їхні постріли сповільнюються вдвічі';

  @override
  String get sigilDescHalo =>
      'Щит заряджається вчетверо швидше й нічого не проходить';

  @override
  String get sigilDescRadial => 'Кільце з шістнадцяти пострілів';

  @override
  String get sigilDescStorm => 'Усі гармати на повну, безкоштовно';

  @override
  String get sigilDescPing => 'Супутники зосереджують вогонь у бік ривка';

  @override
  String get sigilDescWingman => 'Виклич веденого на фланг, куди малював';

  @override
  String get sigilDescHunter =>
      'Виклич мисливця, що летить попереду й обирає цілі';

  @override
  String get sigilDescWarden =>
      'Виклич вартового, що приймає постріли замість тебе';

  @override
  String get sigilDescFormation =>
      'Супутники перемикаються між широким строєм і клином';

  @override
  String get sigilDescWhirl =>
      'Супутники кружляють довкола й поглинають постріли';

  @override
  String get sigilDescSacrifice =>
      'Супутники пікірують і вибухають, повертаючи заряд';

  @override
  String get grimoire => 'ГРИМУАР';

  @override
  String get grimoireHint =>
      'Малюй правим стіком. LB — ЗБРОЯ, RB — КРИЛО, обидві — МЕГАВИБУХ.';

  @override
  String sigilCost(int cost) {
    return 'ціна $cost';
  }

  @override
  String get sigilUntouchable => 'невразливий';

  @override
  String get lessonWatch => 'ДИВИСЬ';

  @override
  String get lessonTrace => 'ОБВЕДИ';

  @override
  String get lessonSlow => 'ПОВІЛЬНО';

  @override
  String get lessonLive => 'ПОВНА ШВИДКІСТЬ';

  @override
  String get lessonStreak => 'П\'ЯТЬ ПОСПІЛЬ';

  @override
  String get lessonLearned => 'ВИВЧЕНО';

  @override
  String lessonTempo(int pct) {
    return 'ТЕМП $pct %';
  }

  @override
  String get hintHop => 'Різко хитни правий стік';

  @override
  String get hintLoop => 'Намалюй коло: ти пролетиш над пострілами';

  @override
  String get hintStream => 'Натисни LT: два або три потоки';

  @override
  String get arenaKata => 'КАТА';

  @override
  String get arenaKataOff => 'НЕМАЄ';

  @override
  String kataNext(String sigil, String secs) {
    return 'наступний $sigil за $secs с';
  }

  @override
  String get arenaGauntlet => 'ВИПРОБУВАННЯ';

  @override
  String get arenaOn => 'УВІМК.';

  @override
  String get arenaOff => 'ВИМК.';

  @override
  String gauntletRating(int rating, int best) {
    return 'Рейтинг $rating · рекорд $best';
  }

  @override
  String get duelWarning => 'УВАГА';

  @override
  String get duelHintPad1 => 'Правий стік цілиться й стріляє';

  @override
  String get duelHintPad2Rt => 'Тримай RT, LB або RB: правий стік малює сигіли';

  @override
  String get duelHintPad2Lt => 'Тримай LT, LB або RB: правий стік малює сигіли';

  @override
  String get duelHintClassic =>
      'Лівий стік — політ · B, RB або RT стріляють, куди дивиться ніс';

  @override
  String get duelHintKeys1 => 'Стрілки цілять і стріляють · WASD — політ';

  @override
  String get duelHintKeys2 =>
      'Пробіл стріляє, куди дивиться ніс · цифрова клавіатура малює сигіли';

  @override
  String get arenaDuelBinding => 'ДУЕЛЬНА СТІЙКА';

  @override
  String get duelBindingRt => 'RT + СТІК';

  @override
  String get duelBindingLt => 'LT + СТІК';

  @override
  String get arenaDuelFrame => 'ВПЕРЕД НА ГЕЙМПАДІ';

  @override
  String get duelFrameNose => 'НІС';

  @override
  String get duelFrameUp => 'ВГОРУ';

  @override
  String get arenaDuelAimFires => 'ПРИЦІЛ СТРІЛЯЄ';

  @override
  String get duelCutInFirst => 'КРУПНИЙ ПЛАН БОСА: УПЕРШЕ';

  @override
  String get duelCutInAlways => 'КРУПНИЙ ПЛАН БОСА: ЗАВЖДИ';

  @override
  String get duelCutInNever => 'КРУПНИЙ ПЛАН БОСА: НІКОЛИ';

  @override
  String get arenaDuelDrill => 'ДУЕЛЬНЕ ТРЕНУВАННЯ';

  @override
  String get duelDrillOff => 'НЕМАЄ';

  @override
  String get duelDrillAim => 'ЦІЛЬСЯ Й СТРІЛЯЙ';

  @override
  String get duelDrillAimHow => 'Наведи правий стік на боса й влуч';

  @override
  String get duelDrillHold => 'ТРИМАЙ НІС';

  @override
  String get duelDrillHoldHow =>
      'Тримай кнопку стійки й лети: ніс не рухається';

  @override
  String get duelDrillDraw => 'МАЛЮЙ УПЕРЕД';

  @override
  String get duelDrillDrawHow => 'У стійці намалюй сигіл у бік боса';

  @override
  String get duelDrillTurn => 'РОЗВЕРНИСЬ';

  @override
  String get duelDrillTurnHow => 'Бос під тобою: розверни ніс і влуч';

  @override
  String get duelDrillDone => 'ГОТОВО';

  @override
  String get swapHint => 'Торкнись другим пальцем, щоб змінити зброю';
}
