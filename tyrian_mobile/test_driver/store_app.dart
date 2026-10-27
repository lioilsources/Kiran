import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/main.dart' as app;
import 'package:tyrian_mobile/services/save_service.dart';
import 'package:tyrian_mobile/services/skin_registry.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';

/// App side of `make store-screenshots`: the real app with the driver
/// extension on, launched over a seeded save so the shots show a run in
/// progress rather than a stock Bubble Gun on sector 1.
///
/// The seed is a pilot mid-run: every skin owned (the simulator has no store
/// to buy from), a level-10 Laser / Star Gun / Small Vulcan loadout with the
/// generator to feed it, and a sector deep enough for the later zone art.
const _sectorIndex = 9;
const _weaponLevel = 10;

Map<String, dynamic> _device(DevType type, WeaponSlot slot) {
  final d = Device.fromType(type, slot);
  // No parentVessel, so upgrade() skips the achievement and generator side
  // effects; the generator's own growth is applied by hand below.
  for (var i = 1; i < _weaponLevel; i++) {
    d.upgrade();
    d.pwrGen *= config.upgPwrGenMultiplier;
  }
  return d.toJson();
}

Future<void> _seed() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.setString(
    'unlocked_skins',
    jsonEncode([
      for (final s in kSkins)
        if (s.productId != null) s.id,
    ]),
  );
  await prefs.setString('selected_skin', 'default');

  final generator = _device(DevType.generatorBasic, WeaponSlot.generator);
  var genMax = 100.0;
  for (var i = 1; i < _weaponLevel; i++) {
    genMax *= config.upgGenMaxMultiplier;
  }
  await SaveService.saveGameState(
    pilotName: 'KIRIAN',
    credit: 184250,
    score: 2486300,
    hp: 125,
    hpMax: 125,
    shield: 100,
    shieldMax: 100,
    genMax: genMax,
    genPower: (generator['pwrGen'] as num).toDouble(),
    level: _sectorIndex,
    nextWeaponLevel: DevType.frontWeapons.length - 1,
    weapons: [
      _device(DevType.laser, WeaponSlot.frontGun),
      _device(DevType.starGun, WeaponSlot.leftGun),
      _device(DevType.smallVulcan, WeaponSlot.rightGun),
      generator,
    ],
  );
}

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await _seed();
  app.showFpsOverlay = false;
  app.main();
}
