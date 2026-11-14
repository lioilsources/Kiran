import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/mods/hull_spec.dart';
import 'package:tyrian_mobile/systems/mods/mod_rack.dart';
import 'package:tyrian_mobile/systems/mods/mod_spec.dart';
import 'package:tyrian_mobile/systems/mods/mods_state.dart';
import 'package:tyrian_mobile/ui/com_center.dart';

/// The loadout rows put four chips and two buttons side by side. The floor is
/// a 375pt-wide phone (iPhone mini / SE); a RenderFlex overflow there fails
/// the test through FlutterError.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ModsState.instance.reset();
  });

  Future<TyrianGame> pump(
    WidgetTester tester,
    Locale locale, {
    Size size = const Size(375, 812),
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final game = TyrianGame()..vessel = Vessel();
    final v = game.vessel;
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun).upgrade();
    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    v.nextWeaponLevel = 2;
    v.credit = 123456789;
    v.score = 1234567;

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: ComCenterScreen(game: game, onStart: () {}),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    return game;
  }

  for (final locale in const [
    Locale('en'),
    Locale('cs'),
    Locale('de'),
    Locale('ru'),
    Locale('ja'),
  ]) {
    testWidgets('loadout fits a 375pt phone ($locale)', (tester) async {
      await pump(tester, locale);
      expect(find.text('BUBBLE'), findsNWidgets(3));
      expect(find.text('VULCAN'), findsNWidgets(3));
    });
  }

  // On a desktop host the wide window gets the two-column layout.
  testWidgets('desktop two-column layout fits 1280x720', (tester) async {
    await pump(tester, const Locale('en'), size: const Size(1280, 720));
    expect(find.text('BUBBLE'), findsNWidgets(3));
  });

  // Plan 32 Q4: +DPS under the chips, damage × rate under each fitted row.
  testWidgets('chips show their DPS delta and rows their breakdown',
      (tester) async {
    await pump(tester, const Locale('en'));
    expect(find.textContaining('/s'), findsNWidgets(2),
        reason: 'FRONT and LEFT have a gun fitted, RIGHT is empty');
    expect(find.textContaining(RegExp(r'^\+\d')), findsWidgets);
  });

  testWidgets('tapping a hangar chip switches for free', (tester) async {
    final game = await pump(tester, const Locale('en'));
    final credit = game.vessel.credit;
    await tester.tap(find.text('BUBBLE').first);
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      game.vessel.getDevice(WeaponSlot.frontGun)!.name,
      DevType.bubbleGun.name,
    );
    expect(game.vessel.getDevice(WeaponSlot.frontGun)!.level, 1);
    expect(game.vessel.credit, credit);
  });

  testWidgets('tapping an unowned chip arms BUY, which fits it', (
    tester,
  ) async {
    final game = await pump(tester, const Locale('en'));
    await tester.tap(find.text('VULCAN').at(1)); // LEFT row
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      game.vessel.getDevice(WeaponSlot.leftGun)!.name,
      DevType.smallBubble.name,
      reason: 'selecting does not buy',
    );
    await tester.tap(find.textContaining('BUY'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      game.vessel.getDevice(WeaponSlot.leftGun)!.name,
      DevType.smallVulcan.name,
    );
    expect(
      game.vessel.hangarEntry(DevType.smallBubble.name, WeaponSlot.leftGun),
      isNotNull,
    );
    await tester.pump(const Duration(seconds: 2));
  });

  // HANGAR + VAULT with the widest hull and every mod in the vault: the rack
  // rows and the vault grid must fit the same 375pt floor.
  for (final locale in const [Locale('en'), Locale('de'), Locale('ru')]) {
    testWidgets('hangar and a full vault fit a 375pt phone ($locale)',
        (tester) async {
      final s = ModsState.instance;
      s.unlockedHulls.addAll([for (final h in kHulls) h.id]);
      for (final m in kMods) {
        s.vault.add(ModInstance('u_${m.id}', m.id));
      }
      final game = await pump(tester, locale);
      game.vessel.setHull(HullSpec.byId('colossus'));
      final fit = s.vault.firstWhere((i) => i.modId == 'hydra');
      s.vault.remove(fit);
      game.vessel.fitMod(fit, RackKind.front);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('TRIPLE'), findsWidgets);
    });
  }

  testWidgets('a vault card fits its mod; tapping the socket takes it off',
      (tester) async {
    final s = ModsState.instance;
    s.vault.add(const ModInstance('u1', 'triple'));
    final game = await pump(tester, const Locale('en'));
    await tester.scrollUntilVisible(find.text('TRIPLE'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('TRIPLE'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.textContaining('FIT → FRONT'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.vessel.racks[RackKind.front]!.fitted.single.modId, 'triple');
    expect(s.vault, isEmpty);

    await tester.ensureVisible(find.text('TRIPLE').first);
    await tester.pump();
    await tester.tap(find.text('TRIPLE').first);
    await tester.pump();
    expect(game.vessel.fittedMods, isEmpty);
    expect(s.vault.single.modId, 'triple');
  });
}
