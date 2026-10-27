import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/death_effect.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/entities/shard.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/net/protocol.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

void main() {
  group('Hostile.deathFamily', () {
    late TyrianGame game;
    late Hostile h;
    final vulcan = Device.fromType(DevType.vulcanCannon, WeaponSlot.frontGun);

    setUp(() {
      game = TyrianGame();
      h = Hostile(
          caption: '', id: 1, hostType: HostType.falcon1, hp: 100, hpMax: 100);
    });

    test('is not recorded on a non-lethal hit', () {
      h.takeDamage(30, game, source: vulcan);
      expect(h.isDead, isFalse);
      expect(h.deathFamily, isNull);
    });

    test('is recorded only on the killing blow', () {
      h.takeDamage(30, game, source: vulcan);
      h.takeDamage(100, game, source: vulcan);
      expect(h.isDead, isTrue);
      expect(h.deathFamily, WeaponFamily.vulcan);
    });

    test('stays null when the killing blow has no weapon source', () {
      h.takeDamage(200, game);
      expect(h.isDead, isTrue);
      expect(h.deathFamily, isNull);
    });

    test('stays null on path-destroy style hp zeroing', () {
      h.takeDamage(30, game, source: vulcan); // weapon hit earlier…
      h.hp = 0; // …then PathAction.destroy / off-field reap
      expect(h.isDead, isTrue);
      expect(h.deathFamily, isNull);
    });
  });

  group('DeathEffectRenderer pools', () {
    // Neither spawn() nor update() touches the game reference, so the
    // renderer is testable unmounted.
    DeathEffectRenderer renderer() => DeathEffectRenderer();

    void drain(DeathEffectRenderer r) {
      for (int i = 0; i < 20; i++) {
        r.update(0.5);
      }
    }

    test('every family spawns particles and a flash', () {
      for (final f in WeaponFamily.values) {
        final r = renderer();
        r.spawn(f, 100, 100, 40, 40);
        expect(r.activeParticleCount, greaterThan(0), reason: f.name);
        expect(r.activeFlashCount, 1, reason: f.name);
      }
    });

    test('water and plasma spawn rings, electric spawns arcs', () {
      final water = renderer()..spawn(WeaponFamily.bubble, 0, 0, 40, 40);
      expect(water.activeRingCount, 1);
      final plasma = renderer()..spawn(WeaponFamily.blaster, 0, 0, 40, 40);
      expect(plasma.activeRingCount, 2); // nova stroke + fill
      final electric = renderer()..spawn(WeaponFamily.laser, 0, 0, 40, 40);
      expect(electric.activeArcCount, greaterThanOrEqualTo(3));
    });

    test('everything expires', () {
      final r = renderer();
      for (final f in WeaponFamily.values) {
        r.spawn(f, 100, 100, 40, 40);
      }
      drain(r);
      expect(r.activeParticleCount, 0);
      expect(r.activeRingCount, 0);
      expect(r.activeArcCount, 0);
      expect(r.activeFlashCount, 0);
    });

    test('pool exhaustion skips silently', () {
      final r = renderer();
      for (int i = 0; i < 100; i++) {
        r.spawn(WeaponFamily.starg, 0, 0, 40, 40);
      }
      expect(r.activeParticleCount,
          lessThanOrEqualTo(DeathEffectRenderer.particlePoolSize));
      expect(r.activeFlashCount,
          lessThanOrEqualTo(DeathEffectRenderer.flashPoolSize));
    });

    test('clearAll deactivates everything', () {
      final r = renderer();
      r.spawn(WeaponFamily.laser, 0, 0, 40, 40);
      r.clearAll();
      expect(r.activeParticleCount, 0);
      expect(r.activeArcCount, 0);
      expect(r.activeFlashCount, 0);
    });
  });

  group('ShardPreset physics in ShardPool.update', () {
    test('gravity field drives vertical acceleration', () {
      final pool = ShardPool();
      final s = pool.shards[0]
        ..active = true
        ..life = 1
        ..totalLife = 1
        ..vy = 0
        ..gravity = 500;
      pool.update(0.1);
      expect(s.vy, closeTo(50, 1e-6));
    });

    test('non-shrinking shards keep their scale (ice chunks)', () {
      final pool = ShardPool();
      final s = pool.shards[0]
        ..active = true
        ..life = 1
        ..totalLife = 2
        ..baseScale = 2
        ..scale = 2
        ..shrink = false;
      pool.update(0.5);
      expect(s.scale, 2.0);

      final s2 = pool.shards[1]
        ..active = true
        ..life = 1
        ..totalLife = 2
        ..baseScale = 2
        ..scale = 2
        ..shrink = true;
      pool.update(0.0);
      expect(s2.scale, lessThan(2.0)); // default path still shrinks
    });
  });

  group('explosion event codec', () {
    // frameMessage prefixes [4B length][1B msgType]; decodeGameEvent takes
    // the bare payload.
    ({int eventType, double x, double y, String text}) roundTrip(String text) {
      final framed =
          encodeGameEvent(EventType.explosion, x: 120.5, y: 300.25, text: text);
      return decodeGameEvent(framed.sublist(5));
    }

    test('carries the weapon family and hostile key in text', () {
      final e = roundTrip('vulcan:12:3');
      expect(e.eventType, EventType.explosion);
      expect(e.x, 120.5);
      expect(e.y, 300.25);
      expect(e.text, 'vulcan:12:3');
      expect(WeaponFamily.values.asNameMap()[e.text.split(':')[0]],
          WeaponFamily.vulcan);
    });

    test('empty text (generic death) survives the round trip', () {
      expect(roundTrip('').text, isEmpty);
    });
  });
}
