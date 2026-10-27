// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get cancel => 'ОТМЕНА';

  @override
  String get connect => 'ПОДКЛЮЧИТЬ';

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
  String get quitToDesktop => 'ВЫЙТИ ИЗ ИГРЫ';

  @override
  String get selectSkin => 'ВЫБОР СКИНА';

  @override
  String get quit => 'ВЫХОД';

  @override
  String get restorePurchases => 'ВОССТАНОВИТЬ ПОКУПКИ';

  @override
  String get locked => 'ЗАКРЫТО';

  @override
  String get hudHp => 'ОЗ';

  @override
  String get hudShield => 'ЩИТ';

  @override
  String get hudPower => 'ЭН';

  @override
  String get hudGen => 'ГЕН';

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
  String get startMission => 'НАЧАТЬ МИССИЮ';

  @override
  String get continueMission => 'ПРОДОЛЖИТЬ МИССИЮ';

  @override
  String get padControlsHint =>
      '[↑↓] Ряд   [←→] Выбор   [B] Купить/Улучшить/Сменить   [X/Y] Продать   [OPTIONS] Продолжить';

  @override
  String get host => 'СОЗДАТЬ';

  @override
  String get connectToHost => 'Подключение к хосту';

  @override
  String hostingAt(String ip) {
    return 'ХОСТ  $ip';
  }

  @override
  String ipValue(String ip) {
    return 'IP: $ip';
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
