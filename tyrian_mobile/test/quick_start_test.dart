import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/services/comcenter_gate.dart';
import 'package:tyrian_mobile/services/save_service.dart';
import 'package:tyrian_mobile/services/skin_registry.dart';
import 'package:tyrian_mobile/services/skin_store_service.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/ui/com_center.dart';

/// Plan 32 Q1 (first launch skips the ComCenter) and Q2 (owned skins first).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const saveJson =
      '{"saveVersion":2,"pilotName":"Fable","credit":777,"score":42,'
      '"hp":125,"hpMax":125,"shield":100.0,"shieldMax":100.0,"genMax":100.0,'
      '"genPower":4.0,"level":0,"nextWeaponLevel":1,"weapons":[]}';

  /// What main.dart does at startup: a save found or not, then the gate.
  Future<void> startup() async {
    ComCenterGate.reset();
    final hasSave = await SaveService.loadGameState() != null;
    await ComCenterGate.load(hasSave: hasSave);
  }

  group('ComCenter gate', () {
    test('a new pilot (no flag, no save) skips the ComCenter', () async {
      SharedPreferences.setMockInitialValues({});
      await startup();
      expect(ComCenterGate.skipComCenter, isTrue);
    });

    test('an existing pilot (no flag, a save) sees the ComCenter', () async {
      SharedPreferences.setMockInitialValues({'game_state': saveJson});
      await startup();
      expect(ComCenterGate.skipComCenter, isFalse);
    });

    test('a pilot who quit during the first sector skips it again', () async {
      SharedPreferences.setMockInitialValues({});
      await startup();
      // The skipped START saves progress before the sector.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('game_state', saveJson);
      await startup(); // next launch
      expect(ComCenterGate.skipComCenter, isTrue,
          reason: 'the save made by the skipped start must not count');
    });

    test('once shown, it is shown from then on', () async {
      SharedPreferences.setMockInitialValues({});
      await startup();
      ComCenterGate.markSeen();
      expect(ComCenterGate.skipComCenter, isFalse);
      await Future<void>.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(ComCenterGate.prefsKey), isTrue);
      await startup(); // next launch
      expect(ComCenterGate.skipComCenter, isFalse);
    });

    testWidgets('opening the ComCenter marks it seen', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await startup();
      expect(ComCenterGate.skipComCenter, isTrue);
      tester.view.physicalSize = const Size(375, 812) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final game = TyrianGame()..vessel = Vessel();
      game.vessel.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
      game.vessel.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ComCenterScreen(game: game, onStart: () {})),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      expect(ComCenterGate.skipComCenter, isFalse);
    });
  });

  group('skin order', () {
    const owned = {'galaga', 'geometry_wars', 'default', 'rtype', 'axelay'};

    test('owned skins first, kSkins order inside both groups', () {
      final ordered =
          SkinStoreService.ownedFirst(kSkins, (id) => owned.contains(id));
      expect(ordered.length, kSkins.length);
      expect(ordered.map((s) => s.id).take(owned.length),
          ['galaga', 'rtype', 'axelay', 'geometry_wars', 'default']);
      final locked = ordered.skip(owned.length).map((s) => s.id).toList();
      expect(locked,
          [for (final s in kSkins) if (!owned.contains(s.id)) s.id]);
    });

    test('everything unlocked keeps kSkins as it is', () {
      expect(SkinStoreService.ownedFirst(kSkins, (_) => true), kSkins);
      expect(SkinStoreService.ownedFirst(kSkins, (_) => false), kSkins);
    });

    test('without a store (desktop, tests) the grid is kSkins', () {
      expect(SkinStoreService.instance.supported, isFalse);
      expect(SkinStoreService.instance.orderedSkins, kSkins);
    });
  });
}
