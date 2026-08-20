import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/death_effect_config.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

void main() {
  group('weaponFamilyFromImgName', () {
    test('maps every offensive DevType to its family', () {
      const expected = {
        'Bubble Gun': WeaponFamily.bubble,
        'Vulcan Cannon': WeaponFamily.vulcan,
        'Blaster': WeaponFamily.blaster,
        'Laser': WeaponFamily.laser,
        'Small Bubble': WeaponFamily.bubble,
        'Small Vulcan': WeaponFamily.vulcan,
        'Star Gun': WeaponFamily.starg,
        'Small Laser': WeaponFamily.laser,
      };
      final all = [...DevType.frontWeapons, ...DevType.sideWeapons];
      expect(all.length, expected.length,
          reason: 'new weapon added — extend the family map');
      for (final t in all) {
        expect(weaponFamilyFromImgName(t.imgName), expected[t.name],
            reason: t.name);
      }
    });

    test('generators and unknown names have no family', () {
      for (final g in DevType.generators) {
        expect(weaponFamilyFromImgName(g.imgName), isNull);
      }
      expect(weaponFamilyFromImgName('nonsense'), isNull);
    });

    test('every family has a death effect spec', () {
      for (final f in WeaponFamily.values) {
        expect(deathEffectSpecs[f], isNotNull, reason: f.name);
      }
    });
  });
}
