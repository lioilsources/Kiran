import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/sector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('sector completion is a one-way latch', () {
    // Why this matters: TyrianGame.update polls currentSector.isComplete, and
    // the ComCenter only opens two seconds later. If the call site does not
    // guard, the end-of-sector block runs on every frame of that window — it
    // paid the sector bonus and queued advanceToNextSector ~120 times, so
    // finishing sector 1 landed the player at sector ~121.
    test('stays complete once set, so the caller must fire only once', () {
      final s = Sector(caption: 'test', level: 1);
      expect(s.isComplete, isFalse);

      s.complete = true;
      for (var i = 0; i < 120; i++) {
        s.update(1 / 60);
      }
      expect(s.isComplete, isTrue);
    });

    test('a freshly built sector starts uncompleted', () {
      // loadSector clears TyrianGame's guard; that is only sound because every
      // new sector really does start false.
      for (final i in [0, 5, 17]) {
        expect(Sector.buildPart(i).isComplete, isFalse, reason: 'part $i');
      }
    });
  });

  group('generator upgrades stay in sync with the device', () {
    Device generatorOn(Vessel v) {
      final d = Device.fromType(DevType.generatorBasic, WeaponSlot.generator);
      d.parentVessel = v;
      v.devices.add(d);
      return d;
    }

    test('a shop upgrade publishes the device power onto the vessel', () {
      final v = Vessel();
      final d = generatorOn(v);
      d.upgrade();
      expect(v.genPower, d.pwrGen);
      expect(d.pwrGen, closeTo(4.35 * config.upgPwrGenMultiplier, 1e-9));
    });

    test('a pickup routed through the device survives the next shop upgrade',
        () {
      // The old pickup raised vessel.genPower directly, leaving device.pwrGen
      // behind; the next upgrade assigns genPower from the device and wiped
      // the gain, while genMax kept compounding. That desync is the bug.
      final v = Vessel();
      final d = generatorOn(v);

      d.upgrade(); // pickup, via the same path Collectable now takes
      final afterPickup = v.genPower;
      d.upgrade(); // shop purchase

      expect(v.genPower, greaterThan(afterPickup),
          reason: 'the pickup must still be compounded in');
      expect(v.genPower, d.pwrGen, reason: 'no desync');
      expect(d.pwrGen,
          closeTo(4.35 * config.upgPwrGenMultiplier * config.upgPwrGenMultiplier, 1e-9));
    });

    test('capacity and power compound the same number of times', () {
      final v = Vessel();
      final d = generatorOn(v);
      final gen0 = v.genMax;
      for (var i = 0; i < 5; i++) {
        d.upgrade();
      }
      expect(d.level, 5);
      expect(v.genMax, closeTo(gen0 * 1.2 * 1.2 * 1.2 * 1.2 * 1.2, 1e-6));
      expect(v.genPower, closeTo(4.35 * 1.255 * 1.255 * 1.255 * 1.255 * 1.255, 1e-9));
    });
  });
}
