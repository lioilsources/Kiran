import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/telemetry_probe.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/services/telemetry_service.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/mods/mods_state.dart';
import 'package:tyrian_mobile/ui/com_center.dart';

/// The game's own hooks (Prompts/33 T2) produce events that pass the
/// dictionary — `TelemetryService` asserts on every mismatch — and measure
/// what they claim to, without touching the game.

class _Sink implements TelemetrySink {
  @override
  Future<SinkResult> send(List<TelemetryEvent> batch) async => SinkResult.retry;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TelemetryService t;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    ModsState.instance.reset();
    t = TelemetryService.resetForTest();
    await t.init(
        sink: _Sink(),
        prefs: await SharedPreferences.getInstance(),
        startTimer: false);
  });

  tearDown(() => TelemetryService.resetForTest());

  TyrianGame game() {
    final g = TyrianGame()..vessel = Vessel();
    final v = g.vessel;
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun).upgrade();
    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    v.nextWeaponLevel = 2;
    v.credit = 123456789;
    TelemetryProbe.bind(g);
    return g;
  }

  Map<String, Object> last(String name) =>
      t.queued.lastWhere((e) => e.name == name).props;

  test('common properties come from the bound game', () {
    final g = game();
    t.track('app_open', {'start': 'cold'});
    final p = last('app_open');
    expect(p['mode'], 'endless');
    expect(p['difficulty'], g.challenge.id);
    expect(p['lang'], 'en');
  });

  test('sector start and end read the loadout and the field', () {
    final g = game();
    final credit = g.vessel.credit;
    TelemetryProbe.sectorStart(g);
    final s = last('sector_start');
    expect(s['front'], 'vulcan_cannon');
    expect(s['index'], 0);
    expect(s['level'], 1);
    t.noteHit('ram');
    TelemetryProbe.sectorEnd(g, 'death');
    final e = last('sector_end');
    expect(e['result'], 'death');
    expect(e['cause'], 'ram');
    expect(e['part'], 1);
    // A second end for the same sector is not a second death.
    TelemetryProbe.sectorEnd(g, 'menu');
    expect(t.queued.where((e) => e.name == 'sector_end'), hasLength(1));
    expect(g.vessel.credit, credit, reason: 'measuring changes nothing');
  });

  test('affordable counts what the ComCenter would sell', () {
    final v = Vessel()..nextWeaponLevel = 0;
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    v.credit = 0;
    expect(TelemetryProbe.affordable(v), (buys: 0, upgrades: 0));
    v.credit = 1 << 30;
    final a = TelemetryProbe.affordable(v);
    // Tier 0 only: the left and right small bubble; the bubble gun is owned.
    expect(a.buys, 2);
    expect(a.upgrades, 1);
  });

  testWidgets('a ComCenter visit is measured from the real screen',
      (tester) async {
    tester.view.physicalSize = const Size(375, 812) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final g = game();
    t.comCenterReason = 'sector';
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ComCenterScreen(game: g, onStart: () {})),
    ));
    await tester.pump(const Duration(milliseconds: 50));
    final open = last('comcenter_open');
    expect(open['reason'], 'sector');
    expect(open['credits_band'], '1m+');

    await tester.tap(find.text('BUBBLE').first); // hangar: free switch
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('VULCAN').at(1)); // LEFT row, unowned
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.textContaining('BUY'));
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpWidget(const SizedBox());
    final close = last('comcenter_close');
    expect(close['switches'], 1);
    expect(close['buys'], 1);
    expect(close['exit'], 'start');
    expect(close['left_affordable'], isTrue);
  });
}
