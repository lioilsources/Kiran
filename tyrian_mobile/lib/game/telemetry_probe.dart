import 'dart:math';

import '../entities/vessel.dart';
import '../l10n/l10n.dart';
import '../services/asset_library.dart';
import '../services/telemetry_service.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../systems/sector.dart';
import 'tyrian_game.dart';

/// Reads the game for [TelemetryService] — the only place that knows both.
/// Every call is read-only: measuring must never change the game.
abstract final class TelemetryProbe {
  static TyrianGame? _game;
  static TelemetryService get _t => TelemetryService.instance;

  /// Bind the running game; common properties are read from it from here on.
  static void bind(TyrianGame game) {
    _game = game;
    _t.context = () => {
          'skin': AssetLibrary.instance.skinId,
          'lang': telemetryLocaleId(L10n.current.localeName),
        };
  }

  static int _index(TyrianGame g) => max(0, g.currentSectorIndex);

  /// Part of its level (1–3) for a hand-authored sector; 0 for the
  /// generated ones, which have one sector per level.
  static int partOf(TyrianGame g) {
    final i = _index(g);
    final first = Sector.firstIndexForLevel(Sector.levelForIndex(i));
    final authored = Sector.levelForIndex(first + 2) == Sector.levelForIndex(i);
    return authored ? i - first + 1 : 0;
  }

  static void sectorStart(TyrianGame g) {
    final front = g.vessel.getDevice(WeaponSlot.frontGun);
    final i = _index(g);
    _t.sectorStarted({
      'index': i,
      'level': g.currentSector?.level ?? Sector.levelForIndex(i),
      'dps_band': TelemetryBands.dpsOf(g.vessel.totalDps),
      'front': front == null ? 'none' : telemetryWeaponId(front.name),
      'front_level': front?.level ?? 0,
    }, live: () => (secs: g.elapsed.round(), part: partOf(g), boss: g.bossActive));
  }

  static void sectorEnd(TyrianGame g, String result) => _t.sectorEnded(result,
      secs: g.elapsed.round(), part: partOf(g), boss: g.bossActive);

  /// Buys and upgrades the pilot could pay for right now.
  static ({int buys, int upgrades}) affordable(Vessel v) {
    var buys = 0, upgrades = 0;
    for (final slot in const [
      WeaponSlot.frontGun,
      WeaponSlot.leftGun,
      WeaponSlot.rightGun,
    ]) {
      final cat = slot == WeaponSlot.frontGun
          ? DevType.frontWeapons
          : DevType.sideWeapons;
      for (var i = 0; i < cat.length && i <= v.nextWeaponLevel; i++) {
        final t = cat[i];
        if (!v.ownsWeapon(t.name, slot) && v.credit >= t.price) buys++;
      }
    }
    // The ComCenter's four loadout rows.
    for (final slot in const [
      WeaponSlot.frontGun,
      WeaponSlot.leftGun,
      WeaponSlot.rightGun,
      WeaponSlot.generator,
    ]) {
      final d = v.getDevice(slot);
      if (d != null && d.level < Device.maxLevel && v.credit >= d.price) {
        upgrades++;
      }
    }
    return (buys: buys, upgrades: upgrades);
  }

  static void comCenterOpened(TyrianGame g) => _t.comCenterOpened(
        props: () {
          final a = affordable(g.vessel);
          return {
            'credits_band': TelemetryBands.creditsOf(g.vessel.credit),
            'index': _index(g),
            'buys_avail': a.buys,
            'upgrades_avail': a.upgrades,
          };
        },
        affordableLeft: () {
          final a = affordable(g.vessel);
          return a.buys + a.upgrades > 0;
        },
      );

  static void comCenterClosed() => _t.comCenterClosed();

  static void comCenterAction(ComCenterAction a) => _t.comCenterAction(a);

  /// The app is leaving the foreground.
  static void paused(String screen) =>
      _t.appPaused(screen: screen, index: _game == null ? 0 : _index(_game!));

  /// Quit from a menu or the window closing: end the sector, then the session.
  static Future<void> quit(String screen) async {
    final g = _game;
    if (g != null) sectorEnd(g, 'quit');
    await _t.appQuitting(screen: screen, index: g == null ? 0 : _index(g));
  }
}
