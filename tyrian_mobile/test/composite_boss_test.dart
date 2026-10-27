import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/boss.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// The composite boss: a core plus the pieces bolted onto it. The rules that
/// matter are the ones that can break a run — a shield the core hides behind,
/// a piece outliving its core (which would leave the sector unfinishable),
/// and each piece paying its own bounty rather than the whole boss's.
void main() {
  // The damage path never reads the game instance, so an unloaded one is
  // enough to satisfy the signature.
  final game = TyrianGame();

  Boss coreWith(List<PartKind> parts, {int hp = 10000, int bounty = 5000}) {
    final b = Boss(
      caption: 'Rododendron',
      id: 0,
      spec: BossSpec(
        ordinal: parts.length,
        weapDamage: 60,
        rechargeFrames: 120,
        parts: parts,
      ),
      hp: hp,
      hpMax: hp,
      collisionDmg: 20,
    );
    b.creditValue = bounty;
    b.createParts();
    return b;
  }

  group('assembly', () {
    test('bosses gain one piece at a time, keeping the earlier ones', () {
      expect(bossPartsForOrdinal(1), [PartKind.turret]);
      expect(bossPartsForOrdinal(2), [PartKind.turret, PartKind.shieldPod]);
      expect(bossPartsForOrdinal(3),
          [PartKind.turret, PartKind.shieldPod, PartKind.thruster]);
      expect(bossPartsForOrdinal(4), kBossPartProgression);
      // Past the authored set it stops growing rather than throwing.
      expect(bossPartsForOrdinal(9), kBossPartProgression);
    });

    test('the endless boss stays a bare core', () {
      expect(coreWith(const []).parts, isEmpty);
    });

    test('pieces are built once, with ids clear of the core', () {
      final core = coreWith([PartKind.turret, PartKind.shieldPod]);
      final again = core.createParts();

      expect(core.parts, hasLength(2));
      expect(again, same(core.parts));
      expect(core.parts.map((p) => p.id), everyElement(greaterThan(core.id)));
      expect(core.parts.map((p) => p.id).toSet(), hasLength(2));
    });

    test('a piece is never reaped as stranded — it has no path of its own',
        () {
      final core = coreWith([PartKind.turret]);
      expect(core.parts.single.trace, isNull);
      expect(core.parts.single.reapWhenStranded, isFalse);
      expect(core.reapWhenStranded, isTrue);
    });
  });

  group('shield gate', () {
    test('the core takes nothing while a pod is up, then takes damage', () {
      final core = coreWith([PartKind.turret, PartKind.shieldPod]);
      final pod =
          core.parts.firstWhere((p) => p.kind == PartKind.shieldPod);

      expect(core.shielded, isTrue);
      core.takeDamage(3000, game);
      expect(core.hp, core.hpMax, reason: 'shielded core must not lose HP');
      expect(core.hit, greaterThan(0), reason: 'the hit still has to read');

      pod.hp = 0;
      expect(core.shielded, isFalse);
      core.takeDamage(3000, game);
      expect(core.hp, core.hpMax - 3000);
    });

    test('a turret alone does not shield the core', () {
      final core = coreWith([PartKind.turret]);
      core.takeDamage(1000, game);
      expect(core.hp, core.hpMax - 1000);
    });
  });

  test('killing the core takes every remaining piece with it', () {
    // Without this the fleet never depletes: Fleet waits for an empty hostile
    // list, and Sector waits for the fleet.
    final core = coreWith(kBossPartProgression);
    core.parts.first.hp = 0; // one already shot off
    final pod = core.parts.firstWhere((p) => p.kind == PartKind.shieldPod);
    pod.hp = 0; // drop the shield so the core is reachable

    core.takeDamage(core.hpMax, game);

    expect(core.isDead, isTrue);
    expect(core.parts.every((p) => p.isDead), isTrue);
  });

  test('a piece pays its own bounty, not the whole boss bounty', () {
    final core = coreWith([PartKind.turret], bounty: 5000);
    final part = core.parts.single;

    expect(part.creditValue, isNotNull);
    expect(part.creditValue, lessThan(5000));
    expect(core.creditValue, 5000);
    // Fleet pays h.creditValue ?? creditOverride ?? hpMax, so an unset value
    // on the core is what lets the fleet's own bounty through.
    expect(part.hpMax, lessThan(core.hpMax));
  });

  test('a live thruster makes the core strafe quicker', () {
    final with_ = coreWith([PartKind.turret, PartKind.shieldPod, PartKind.thruster]);
    expect(with_.strafeStepsMult, lessThan(1.0));

    with_.parts.firstWhere((p) => p.kind == PartKind.thruster).hp = 0;
    expect(with_.strafeStepsMult, 1.0);

    expect(coreWith([PartKind.turret]).strafeStepsMult, 1.0);
  });

  group('boss waves on the map', () {
    test('a campaign boss node carries the ordinal it is drawn for', () {
      for (final node in kCampaignNodes.where((n) => n.isBoss)) {
        expect(bossPartsForOrdinal(node.bossOrdinal!), hasLength(node.bossOrdinal!),
            reason: node.caption);
      }
    });

    test('the boss enters after the last wave has flown', () {
      final s = Campaign.buildNodeContent(4);
      final lastWaveEnd = s.fleets
          .map((f) =>
              f.enterTime +
              f.count * f.triggerInterval +
              f.path.nodes.length / 40.0)
          .reduce((a, b) => a > b ? a : b);

      Sector.addBossWave(s,
          ordinal: 1,
          dps: 500,
          ttk: 19,
          hpFloor: 10000,
          parts: bossPartsForOrdinal(1));

      final boss = s.fleets.last;
      expect(boss.bossSpec, isNotNull);
      expect(boss.count, 1);
      expect(boss.enterTime, greaterThan(lastWaveEnd));
      expect(boss.bossSpec!.parts, [PartKind.turret]);
    });

    test('boss HP is rubber-banded to DPS but never below its floor', () {
      Sector bossAt({required double dps}) {
        final s = Sector(caption: 't', level: 5);
        Sector.addBossWave(s, ordinal: 2, dps: dps, ttk: 20, hpFloor: 14000);
        return s;
      }

      expect(bossAt(dps: 100).fleets.single.hpOverride, 14000);
      expect(bossAt(dps: 2000).fleets.single.hpOverride, 40000);
    });
  });
}
