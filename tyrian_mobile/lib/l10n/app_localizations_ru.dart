// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'ОТМЕНА';

  @override
  String get connect => 'ПОДКЛЮЧИТЬ';

  @override
  String nearbyJoinFailedTitle(String hostName) {
    return 'Не удалось подключиться к $hostName';
  }

  @override
  String get nearbyJoinFailedBody =>
      'Хост был виден, но связь не установилась.\n\nДля игры рядом нужен Wi-Fi peer-to-peer, а iOS отключает его, пока включён режим модема. Выключите режим модема на обоих устройствах и попробуйте снова или подключите оба устройства к одной сети Wi-Fi.';

  @override
  String get gameOverCampaign =>
      'Миссия провалена — снаряжение и кредиты сохранены. Повторите из Командного центра.';

  @override
  String get gameOverEndless =>
      'Восстановление в секторе 1 — снаряжение и кредиты сохранены';

  @override
  String get waitingForHost => 'Ожидание хоста...';

  @override
  String get waitingForHostHint => 'Игра начнётся, когда хост будет готов';

  @override
  String get vesselLost => 'КОРАБЛЬ ПОТЕРЯН';

  @override
  String scoreValue(String score) {
    return 'Очки: $score';
  }

  @override
  String creditsValue(String credits) {
    return 'Кредиты: $credits';
  }

  @override
  String get creditsPrefix => 'Кредиты: ';

  @override
  String get leaderboard => 'РЕЙТИНГ';

  @override
  String get achievements => 'ДОСТИЖЕНИЯ';

  @override
  String get redeploy => 'СНОВА В БОЙ';

  @override
  String get resume => 'ПРОДОЛЖИТЬ';

  @override
  String get pause => 'ПАУЗА';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get skins => 'СКИНЫ';

  @override
  String get skin => 'СКИН';

  @override
  String get soundOn => 'ЗВУК: ВКЛ';

  @override
  String get soundOff => 'ЗВУК: ВЫКЛ';

  @override
  String get musicOn => 'МУЗЫКА: ВКЛ';

  @override
  String get musicOff => 'МУЗЫКА: ВЫКЛ';

  @override
  String get mainMenu => 'ГЛАВНОЕ МЕНЮ';

  @override
  String get quitToDesktop => 'ВЫЙТИ ИЗ ИГРЫ';

  @override
  String get selectSkin => 'ВЫБОР СКИНА';

  @override
  String get difficulty => 'СЛОЖНОСТЬ';

  @override
  String get difficultyEasy => 'ЛЕГКО';

  @override
  String get difficultyNormal => 'НОРМАЛЬНО';

  @override
  String get difficultyHard => 'СЛОЖНО';

  @override
  String get difficultyLord => 'ЛОРД';

  @override
  String get campaign => 'КАМПАНИЯ';

  @override
  String get quit => 'ВЫХОД';

  @override
  String get restorePurchases => 'ВОССТАНОВИТЬ ПОКУПКИ';

  @override
  String get locked => 'ЗАКРЫТО';

  @override
  String get mainMenuTooltip => 'Главное меню';

  @override
  String nodeLevel(int level) {
    return 'УРОВЕНЬ $level';
  }

  @override
  String nodeLevelBoss(int level, String ordinal) {
    return 'УРОВЕНЬ $level · БОСС $ordinal';
  }

  @override
  String get nodeLockedHint => 'Закрыто. Сначала пройдите предыдущую миссию.';

  @override
  String get flyAgain => 'ЛЕТЕТЬ СНОВА';

  @override
  String get launch => 'СТАРТ';

  @override
  String zoneLabel(int zone) {
    return 'ЗОНА $zone';
  }

  @override
  String get objectiveStar => 'ЗВЕЗДА';

  @override
  String get continueButton => 'ДАЛЕЕ';

  @override
  String get replayNode => 'ПОВТОРИТЬ МИССИЮ';

  @override
  String get retry => 'ЕЩЁ РАЗ';

  @override
  String get nodeCleared => 'МИССИЯ ПРОЙДЕНА';

  @override
  String get nodeFailed => 'МИССИЯ ПРОВАЛЕНА';

  @override
  String get weaponTierUnlocked => 'НОВЫЙ УРОВЕНЬ ОРУЖИЯ';

  @override
  String get onSaleInComCenter => 'Уже в продаже в Командном центре.';

  @override
  String get requiredTasksHint =>
      'Исход миссии решают обязательные задачи. Пролетите её снова — заработанное останется с вами.';

  @override
  String get objClear => 'Зачистите сектор';

  @override
  String objKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сбейте $count врага',
      many: 'Сбейте $count врагов',
      few: 'Сбейте $count врагов',
      one: 'Сбейте $count врага',
    );
    return '$_temp0';
  }

  @override
  String get objUntouched => 'Не получите урона по корпусу';

  @override
  String objHull(int percent) {
    return 'Завершите с корпусом выше $percent%';
  }

  @override
  String objWeaponKills(int count, String weapon) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уничтожьте $count врага оружием $weapon',
      many: 'Уничтожьте $count врагов оружием $weapon',
      few: 'Уничтожьте $count врагов оружием $weapon',
      one: 'Уничтожьте $count врага оружием $weapon',
    );
    return '$_temp0';
  }

  @override
  String objSideGunKills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уничтожьте $count врага боковыми орудиями',
      many: 'Уничтожьте $count врагов боковыми орудиями',
      few: 'Уничтожьте $count врагов боковыми орудиями',
      one: 'Уничтожьте $count врага боковыми орудиями',
    );
    return '$_temp0';
  }

  @override
  String objFlyWithFront(String weapon) {
    return 'Вылетите с $weapon спереди';
  }

  @override
  String objFlyWithSide(String weapon) {
    return 'Вылетите с $weapon на боковом креплении';
  }

  @override
  String get objBuySideGun => 'Купите боковое орудие в Командном центре';

  @override
  String objUpgradeGenerator(int level) {
    return 'Улучшите генератор до уровня $level';
  }

  @override
  String objUpgradeFrontGun(int level) {
    return 'Улучшите переднее орудие до уровня $level';
  }

  @override
  String objUpgradeSideGun(int level) {
    return 'Улучшите боковое орудие до уровня $level';
  }

  @override
  String objPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подберите $count бонуса',
      many: 'Подберите $count бонусов',
      few: 'Подберите $count бонуса',
      one: 'Подберите $count бонус',
    );
    return '$_temp0';
  }

  @override
  String objFleets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уничтожьте $count формации целиком',
      many: 'Уничтожьте $count формаций целиком',
      few: 'Уничтожьте $count формации целиком',
      one: 'Уничтожьте $count формацию целиком',
    );
    return '$_temp0';
  }

  @override
  String get objNoRam => 'Не тараньте астероиды';

  @override
  String objUnderTime(int seconds) {
    return 'Уложитесь в $seconds с';
  }

  @override
  String get objStripBoss => 'Уничтожьте все части босса раньше ядра';

  @override
  String get joinCoopTitle => 'Присоединиться к кооперативу';

  @override
  String get cannotSearchNetwork => 'Поиск в этой сети невозможен';

  @override
  String get joinHintNearby =>
      'Одна сеть Wi-Fi работает на любом устройстве. iPhone, iPad и Mac находят друг друга рядом и без неё, если на обоих выключен режим модема.';

  @override
  String get joinHintWifi =>
      'Оба игрока должны быть в одной сети Wi-Fi — режим модема тоже подойдёт.';

  @override
  String noHostsYet(String hint) {
    return 'Хостов пока нет. $hint';
  }

  @override
  String get lookingForHosts => 'Поиск хостов в этой сети Wi-Fi и рядом…';

  @override
  String get hostNearby => 'Рядом · Bluetooth / Wi-Fi peer-to-peer';

  @override
  String hostSameWifi(String address) {
    return '$address · та же Wi-Fi';
  }

  @override
  String get enterIpManually => 'Ввести IP вручную';

  @override
  String get hudHp => 'ОЗ';

  @override
  String get hudShield => 'ЩИТ';

  @override
  String get hudPower => 'ЭН';

  @override
  String get hudGen => 'ГЕН';

  @override
  String bossShielded(String name) {
    return '$name — ПОД ЩИТОМ';
  }

  @override
  String get bossPartTurret => 'Турель';

  @override
  String get bossPartShieldPod => 'Щитовой модуль';

  @override
  String get bossPartThruster => 'Двигатель';

  @override
  String get bossPartCannon => 'Пушка';

  @override
  String sectorUnknownSpace(int level) {
    return 'Сектор $level — Неизведанный космос';
  }

  @override
  String get player2Joined => 'Игрок 2 присоединился!';

  @override
  String get player2Disconnected => 'Игрок 2 отключился';

  @override
  String get hostDisconnected => 'Хост отключился';

  @override
  String maxLevelSold(String amount) {
    return 'Макс. уровень! Продано за \$$amount';
  }

  @override
  String weaponLevelUnlocked(String tier) {
    return 'Открыт уровень оружия $tier';
  }

  @override
  String get cheatsEnabled => 'Читы включены';

  @override
  String get cheatsDisabled => 'Читы выключены';

  @override
  String get cheatsMaxed => 'ЧИТ: кредиты на максимум, всё оружие открыто';

  @override
  String get cheats => 'ЧИТЫ';

  @override
  String get maxCredits => 'МАКС. КРЕДИТЫ';

  @override
  String get sectionStats => 'ПАРАМЕТРЫ';

  @override
  String get sectionLoadout => 'ВООРУЖЕНИЕ';

  @override
  String levelShort(int level) {
    return 'Ур.$level';
  }

  @override
  String get max => 'МАКС';

  @override
  String get upgradeShort => 'УЛУЧ';

  @override
  String get sell => 'ПРОДАТЬ';

  @override
  String get buy => 'КУПИТЬ';

  @override
  String get commandCenter => 'КОМАНДНЫЙ ЦЕНТР';

  @override
  String get pilot => 'Пилот';

  @override
  String get dps => 'УВС';

  @override
  String get score => 'ОЧКИ';

  @override
  String get nextWeapon => 'СЛЕД. ОРУЖИЕ';

  @override
  String pointsValue(String points) {
    return '$points очк.';
  }

  @override
  String get slotFront => 'Перед';

  @override
  String get slotLeft => 'Лево';

  @override
  String get slotRight => 'Право';

  @override
  String get slotGen => 'Ген';

  @override
  String get power => 'ЭН';

  @override
  String get launchMission => 'НАЧАТЬ МИССИЮ';

  @override
  String get startMission => 'НАЧАТЬ МИССИЮ';

  @override
  String get continueMission => 'ПРОДОЛЖИТЬ МИССИЮ';

  @override
  String get padControlsHint =>
      '[↑↓] Ряд   [←→] Выбор   [B] Купить/Улучшить/Сменить   [X/Y] Продать   [OPTIONS] Продолжить';

  @override
  String get host => 'СОЗДАТЬ';

  @override
  String hostingAs(String name) {
    return 'ХОСТ: $name';
  }

  @override
  String get join => 'ВОЙТИ';

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
  String get overload => 'ПЕРЕГРУЗКА';

  @override
  String weaponOff(String weapon) {
    return '$weapon ОТКЛ. — генератор слишком слаб';
  }

  @override
  String unlocksAt(String points) {
    return 'Откроется при $points очк.';
  }

  @override
  String joinConnecting(String target) {
    return 'Подключение к $target…';
  }

  @override
  String lanJoinFailedBody(String reason) {
    return 'Хост не ответил: $reason.\n\nОба игрока должны быть в одной сети Wi-Fi (подойдёт и режим модема), а хост должен нажать HOST. Проверьте адрес и попробуйте снова.';
  }

  @override
  String get lanJoinNoAnswer => 'нет ответа';

  @override
  String objBossUnder(int seconds) {
    return 'Уничтожь ядро босса за $seconds с после его появления';
  }

  @override
  String get sectionHangar => 'АНГАР';

  @override
  String get sectionVault => 'ХРАНИЛИЩЕ';

  @override
  String get rackSide => 'Борт';

  @override
  String get rackHull => 'Корпус';

  @override
  String get rarityCommon => 'ОБЫЧНЫЙ';

  @override
  String get rarityRare => 'РЕДКИЙ';

  @override
  String get rarityMythic => 'МИФИЧЕСКИЙ';

  @override
  String get curse => 'ПРОКЛЯТИЕ';

  @override
  String get modFit => 'УСТАНОВИТЬ';

  @override
  String get modUnfit => 'СНЯТЬ';

  @override
  String get modForge => 'КУЗНЯ';

  @override
  String get forgeHint => 'Выбери 3 одной редкости, чтобы выковать 1 следующей';

  @override
  String get vaultEmpty =>
      'Модов пока нет. Пройди узел на все звёзды, быстро убей босса или сбей босса в бесконечном режиме.';

  @override
  String modNeeds(String families) {
    return 'Работает с $families';
  }

  @override
  String get modRackFull => 'Стойка заполнена';

  @override
  String get modAlreadyFitted => 'Уже установлен';

  @override
  String get modWrongRack => 'Не подходит для этой стойки';

  @override
  String modsSpilled(int n) {
    return '$n модов вернулись в хранилище';
  }

  @override
  String get hullLocked => 'Закрыто';

  @override
  String hullUnlockBoss(int n) {
    return 'Победи босса кампании $n';
  }

  @override
  String get hullUnlockFinish => 'Пройди кампанию или дойди до сектора 30';

  @override
  String get statAgility => 'ЛОВ';

  @override
  String get statHitbox => 'ПОП';

  @override
  String get perkNone => 'Стандартный корабль';

  @override
  String get perkAfterimage => 'Замри: выстрелы ×1,5';

  @override
  String get perkBulwark => 'Урон за щитом вдвое меньше';

  @override
  String get perkOverclock => 'Стреляет оружием до 130 % мощности, медленнее';

  @override
  String get perkBattery => 'С тобой летит бесплатный дрон';

  @override
  String get rewardTitle => 'НАГРАДА';

  @override
  String newHull(String name) {
    return 'Новый корпус: $name';
  }

  @override
  String get socketEmpty => 'пусто';

  @override
  String fxStreams(int n) {
    return '$n параллельных потока';
  }

  @override
  String fxFan(int n) {
    return 'Веер из $n выстрелов';
  }

  @override
  String fxSalvo(int n) {
    return 'Очередь из $n выстрелов';
  }

  @override
  String fxFireRate(String x) {
    return 'Скорострельность ×$x';
  }

  @override
  String fxDamage(String x) {
    return 'Урон ×$x';
  }

  @override
  String fxShotSpeed(String x) {
    return 'Скорость выстрела ×$x';
  }

  @override
  String fxShotSize(String x) {
    return 'Размер выстрела ×$x';
  }

  @override
  String fxPower(String x) {
    return 'Расход энергии ×$x';
  }

  @override
  String fxHoming(int n) {
    return 'Наведение +$n';
  }

  @override
  String fxPierce(int n) {
    return 'Пробивает $n цели';
  }

  @override
  String get fxPierceAll => 'Пробивает всё';

  @override
  String fxCrit(int pct, String x) {
    return '$pct % шанс на урон ×$x';
  }

  @override
  String fxBossCrit(String x) {
    return 'Криты ×$x по боссам';
  }

  @override
  String fxFork(int n) {
    return 'Убийства разбрасывают $n выстрела';
  }

  @override
  String get fxChain => 'Осколки разлетаются снова';

  @override
  String get fxSplit => 'При попадании делится надвое';

  @override
  String get fxFrost => 'Попадания замедляют врага';

  @override
  String get fxCrossfire => 'Бортовые пушки бьют к центру';

  @override
  String get fxRearguard => 'Бортовые пушки стреляют и назад';

  @override
  String get fxOrbit => 'Выстрелы виляют';

  @override
  String fxBounce(int n) {
    return 'Отскакивает от стен $n×';
  }

  @override
  String get fxBounceTop => '…и от верхнего края';

  @override
  String get fxOverdrive => 'Стреляет даже в долг по энергии';

  @override
  String get fxReactor => 'Перегруженное оружие стреляет, но медленно';

  @override
  String fxGenPower(String x) {
    return 'Зарядка генератора ×$x';
  }

  @override
  String fxGenMax(String x) {
    return 'Ёмкость генератора ×$x';
  }

  @override
  String get fxSurge => 'Полный генератор: выстрелы ×2';

  @override
  String fxSiphon(int pct) {
    return 'Убийства восполняют $pct % энергии';
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
    return 'Восстановление щита ×$x';
  }

  @override
  String fxLeech(int n) {
    return 'Убийства лечат $n ОЗ';
  }

  @override
  String get fxMagnet => 'Притягивает бонусы';

  @override
  String get fxMagnetAll => 'Притягивает все бонусы';

  @override
  String fxReflect(int pct) {
    return '$pct % выстрелов отражаются от щита';
  }

  @override
  String get fxReflectGuided => 'Отражённые выстрелы самонаводятся';

  @override
  String fxGhost(String sec) {
    return 'Неуязвимость $sec с после удара по корпусу';
  }

  @override
  String get fxNova => 'Щит пробит: взрыв на весь экран';

  @override
  String fxAgility(String x) {
    return 'Ловкость ×$x';
  }

  @override
  String fxHitbox(String x) {
    return 'Зона попадания ×$x';
  }

  @override
  String fxCredits(String x) {
    return 'Кредиты ×$x';
  }

  @override
  String fxScore(String x) {
    return 'Очки ×$x';
  }

  @override
  String get fxSatellite => 'С тобой летит боевой дрон';

  @override
  String get fxTimewarp => 'Удар по корпусу замедляет время';

  @override
  String get fxGambler => 'Каждый выстрел — случайное оружие';

  @override
  String get vaultAll => 'ВСЕ';

  @override
  String get sigilMissUnknown => 'неизвестная фигура';

  @override
  String get sigilMissTooSlow => 'слишком медленно';

  @override
  String get sigilMissSkippedDot => 'пропущена точка';

  @override
  String get sigilMissLeftRimEarly => 'отпущено слишком рано';

  @override
  String get sigilMissWrongDirection => 'нарисовано задом наперёд';

  @override
  String get sigilMissWrongLayer => 'не та плечевая кнопка';

  @override
  String get sigilDry => 'мало заряда';

  @override
  String get sigilBusy => 'предыдущий ещё идёт';

  @override
  String get arena => 'АРЕНА';

  @override
  String get arenaBossParts => 'ЧАСТИ БОССА';

  @override
  String get arenaBareCore => 'голое ядро';

  @override
  String get arenaCompanions => 'КОМПАНЬОНЫ';

  @override
  String get arenaCharge => 'ЗАРЯД';

  @override
  String get arenaChargeNormal => 'ОБЫЧНЫЙ';

  @override
  String get arenaSpeed => 'СКОРОСТЬ МИРА';

  @override
  String get arenaDrill => 'ОТРАБОТКА';

  @override
  String get arenaFreePlay => 'СВОБОДНО';

  @override
  String get arenaFight => 'В БОЙ';

  @override
  String get arenaNewBoss => 'НОВЫЙ БОСС';

  @override
  String get arenaLeave => 'ПОКИНУТЬ АРЕНУ';

  @override
  String get arenaHint =>
      'Босс возвращается, как только падёт. Здесь ничего не сохраняется.';

  @override
  String get arenaColCast => 'ЕСТЬ';

  @override
  String get arenaColMiss => 'МИМО';

  @override
  String get arenaColAvg => 'СРЕДН.';

  @override
  String get arenaColBest => 'ЛУЧШ.';

  @override
  String get arenaColTime => 'БЫСТРЕЕ';

  @override
  String arenaSummary(int bosses, int knockouts) {
    return 'Боссов $bosses · K.O. $knockouts';
  }

  @override
  String get padSchemeSigil => 'ГЕЙМПАД: СИГИЛЫ';

  @override
  String get padSchemeClassic => 'ГЕЙМПАД: КЛАССИКА';

  @override
  String get padSouthpawOn => 'ЛЕВША: ВКЛ';

  @override
  String get padSouthpawOff => 'ЛЕВША: ВЫКЛ';

  @override
  String get sigilDescHop => 'Быстрый скачок туда, куда дёрнешь стик';

  @override
  String get sigilDescSidestep => 'Длинный шаг в сторону через всё поле';

  @override
  String get sigilDescStrike =>
      'Выпад вперёд с тремя тяжёлыми выстрелами и назад';

  @override
  String get sigilDescRetreat => 'Отход, пока прикрывающий огонь идёт вперёд';

  @override
  String get sigilDescDash =>
      'Рывок по диагонали сквозь огонь, на полпути неуязвим';

  @override
  String get sigilDescRoll => 'Бочка в сторону, неуязвим';

  @override
  String get sigilDescShadow =>
      'Зацепись под ближайшим врагом и стреляй дальше';

  @override
  String get sigilDescEcho =>
      'Тень повторяет твои последние две секунды с половинным уроном';

  @override
  String get sigilDescLoop => 'Петля через верх: выстрелы проходят под тобой';

  @override
  String get sigilDescSlalom => 'Змейка через поле с веерным огнём';

  @override
  String get sigilDescCorkscrew =>
      'Штопор вперёд с огнём во все стороны, неуязвим';

  @override
  String get sigilDescSnapshot =>
      'Один тяжёлый выстрел туда, куда дёрнешь стик';

  @override
  String get sigilDescBroadside => 'Залп с обоих бортов';

  @override
  String get sigilDescVolley => 'Пять заряженных лучей вперёд';

  @override
  String get sigilDescCaltrop =>
      'Брось мину, что глотает выстрелы и взрывается';

  @override
  String get sigilDescFrenzy => 'Оружие несколько секунд стреляет быстрее';

  @override
  String get sigilDescStasis => 'Враги и их выстрелы замедляются вдвое';

  @override
  String get sigilDescHalo =>
      'Щит заряжается вчетверо быстрее и ничего не пропускает';

  @override
  String get sigilDescRadial => 'Кольцо из шестнадцати выстрелов';

  @override
  String get sigilDescStorm => 'Все пушки бьют на полную, бесплатно';

  @override
  String get sigilDescPing => 'Компаньоны бьют туда, куда дёрнешь стик';

  @override
  String get sigilDescWingman =>
      'Вызови ведомого на фланг, к которому ты чертил';

  @override
  String get sigilDescHunter =>
      'Вызови охотника, что летит впереди и выбирает цели';

  @override
  String get sigilDescWarden =>
      'Вызови стража, что ловит выстрелы, летящие в тебя';

  @override
  String get sigilDescFormation =>
      'Компаньоны переключаются между широким строем и клином';

  @override
  String get sigilDescWhirl =>
      'Компаньоны кружат вокруг тебя и глотают выстрелы';

  @override
  String get sigilDescSacrifice =>
      'Компаньоны пикируют и взрываются, возвращая заряд';

  @override
  String get grimoire => 'ГРИМУАР';

  @override
  String get grimoireHint =>
      'Рисуй правым стиком. Держи LB для ARMS, RB для WING, обе для MEGA BLAST.';

  @override
  String sigilCost(int cost) {
    return 'цена $cost';
  }

  @override
  String get sigilUntouchable => 'неуязвим';

  @override
  String get lessonWatch => 'СМОТРИ';

  @override
  String get lessonTrace => 'ОБВЕДИ';

  @override
  String get lessonSlow => 'МЕДЛЕННО';

  @override
  String get lessonLive => 'В ПОЛНУЮ СИЛУ';

  @override
  String get lessonStreak => 'ПЯТЬ ПОДРЯД';

  @override
  String get lessonLearned => 'ОСВОЕНО';

  @override
  String lessonTempo(int pct) {
    return 'ТЕМП $pct %';
  }
}
