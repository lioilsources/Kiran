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
}
