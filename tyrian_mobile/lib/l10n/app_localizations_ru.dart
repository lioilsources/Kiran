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
}
