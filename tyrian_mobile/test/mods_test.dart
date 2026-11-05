import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/campaign_tracker.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/mods/hull_spec.dart';
import 'package:tyrian_mobile/systems/mods/mod_rack.dart';
import 'package:tyrian_mobile/systems/mods/mod_rewards.dart';
import 'package:tyrian_mobile/systems/mods/mod_spec.dart';
import 'package:tyrian_mobile/systems/mods/mods_state.dart';
import 'package:tyrian_mobile/systems/mods/shot_plan.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

/// Mods, racks, hulls and where mods come from (Prompts/27). Everything here
/// is headless: the shot geometry is checked on the plan, not on a game.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ModsState.instance.reset();
  });

  ModEffects fx(List<String> ids) =>
      ModEffects.combine([for (final id in ids) ModSpec.byId(id)!.effects]);

  Device gun(DevType t, [WeaponSlot slot = WeaponSlot.frontGun]) =>
      Device.fromType(t, slot);

  ModInstance inst(String id, [String? uid]) => ModInstance(uid ?? id, id);

  group('catalogue', () {
    test('ids are unique and every mod has a scope', () {
      final ids = {for (final m in kMods) m.id};
      expect(ids.length, kMods.length);
      for (final m in kMods) {
        expect(m.scopes, isNotEmpty, reason: m.id);
      }
    });

    test('names fit a chip: at most nine characters', () {
      for (final m in kMods) {
        expect(m.name.length, lessThanOrEqualTo(9), reason: m.id);
      }
    });

    test('every rarity has mods for every rack', () {
      for (final r in RackKind.values) {
        for (final rarity in [ModRarity.common, ModRarity.rare]) {
          expect(
            kMods.any((m) => m.rarity == rarity && m.fitsRack(r)),
            isTrue,
            reason: '$rarity $r',
          );
        }
        expect(
          kMods.any((m) => m.rarity == ModRarity.mythic && m.fitsRack(r)),
          isTrue,
          reason: 'mythic $r',
        );
      }
    });

    test('three curses, all rare', () {
      final curses = kMods.where((m) => m.curse).toList();
      expect(curses.length, 3);
      expect(curses.every((m) => m.rarity == ModRarity.rare), isTrue);
    });
  });

  group('shot plan', () {
    test('no mods reproduces the device exactly', () {
      for (final t in [...DevType.frontWeapons, ...DevType.sideWeapons]) {
        final d = gun(t);
        final p = ShotPlan.of(d, ModEffects.none);
        expect(p.shotsPerPull, 1, reason: t.name);
        expect(p.damage, d.damage);
        expect(p.cooldown, d.cooldown);
        expect(p.pwrNeed, d.pwrNeed);
        expect(p.speed, d.speed);
        expect(p.guide, d.guide);
        expect(p.dpsFor(d), closeTo(d.dps, 1e-9), reason: t.name);
      }
    });

    test('DOUBLE is two parallel streams, TRIPLE a fan of three', () {
      final d = gun(DevType.bubbleGun);
      final dbl = ShotPlan.of(d, fx(['double']));
      expect(dbl.streams, 2);
      expect([dbl.streamOffset(0), dbl.streamOffset(1)], [-5.0, 5.0]);
      final tri = ShotPlan.of(d, fx(['triple']));
      expect(tri.fan, 3);
      expect(
        [tri.fanVxAt(0), tri.fanVxAt(1), tri.fanVxAt(2)],
        [-3.0, 0.0, 3.0],
      );
    });

    test('side guns fan two thirds as wide', () {
      final p = ShotPlan.of(
        gun(DevType.smallBubble, WeaponSlot.leftGun),
        fx(['triple']),
      );
      expect(p.fanVxAt(2), closeTo(2.0, 1e-9));
    });

    test('TRIPLE + SALVO×2 is the 3×3 of the plan', () {
      final p = ShotPlan.of(
        gun(DevType.vulcanCannon),
        ModEffects.combine([
          ModSpec.byId('triple')!.effects,
          ModSpec.byId('salvo')!.effects,
          ModSpec.byId('salvo')!.effects,
        ]),
      );
      expect(p.fan, 3);
      expect(p.salvo, 3, reason: '2 × 2 = 4, capped at 3');
      expect(p.shotsPerPull, 9);
    });

    test('HYDRA beats TRIPLE: the widest fan wins', () {
      final p = ShotPlan.of(gun(DevType.bubbleGun), fx(['triple', 'hydra']));
      expect(p.fan, 5);
      expect(p.fanVxAt(4), 6.0);
    });

    test('caps hold however much is stacked', () {
      final e = ModEffects.combine(
        List.filled(6, ModSpec.byId('double')!.effects),
      );
      expect(e.streams, ModEffects.maxStreams);
    });

    test('power is the price: multipliers stack', () {
      final d = gun(DevType.bubbleGun);
      final p = ShotPlan.of(d, fx(['double', 'rate']));
      expect(p.pwrNeed, closeTo(d.pwrNeed * 1.6 * 1.15, 1e-9));
      expect(p.cooldown, closeTo(d.cooldown / 1.25, 1e-9));
    });

    test('a laser turns streams and fans into rays, at most five', () {
      final d = gun(DevType.laser);
      expect(ShotPlan.of(d, fx(['wide'])).rays, 2);
      expect(ShotPlan.of(d, fx(['double', 'hydra'])).rays, ShotPlan.maxRays);
    });
  });

  group('racks', () {
    test('a mod only goes where its scope says, once unless stackable', () {
      final r = ModRack(RackKind.front, 3);
      expect(r.refusal(ModSpec.byId('coil')!), FitRefusal.wrongRack);
      r.fitted.add(inst('triple'));
      expect(r.refusal(ModSpec.byId('triple')!), FitRefusal.duplicate);
      r.fitted.add(inst('double', 'd1'));
      expect(r.refusal(ModSpec.byId('double')!), isNull, reason: 'stackable');
      r.fitted.add(inst('double', 'd2'));
      expect(r.refusal(ModSpec.byId('rate')!), FitRefusal.full);
    });

    test('family-bound mods do nothing next to another gun', () {
      final r = ModRack(RackKind.front, 2)..fitted.add(inst('wide'));
      expect(r.combined(WeaponFamily.laser).streams, 2);
      expect(r.combined(WeaponFamily.bubble).streams, 1);
    });
  });

  group('hulls', () {
    test('FALCON is the stock ship: every multiplier 1', () {
      const f = HullSpec.falcon;
      expect([
        f.hpMul,
        f.shieldMul,
        f.genPowerMul,
        f.genMaxMul,
        f.agility,
        f.hitbox,
      ], everyElement(1.0));
      expect(HullSpec.byId('nope'), same(HullSpec.falcon));
    });

    test('a stock vessel keeps the VB6 numbers', () {
      final v = Vessel()..newGame();
      expect(v.hpMax, 125);
      expect(v.shieldMax, 100);
      expect(v.genMax, 100);
      expect(v.genPower, 4);
    });

    test('a hull scales the stats and changing back restores them', () {
      final v = Vessel()..newGame();
      v.setHull(HullSpec.byId('bastion'));
      expect(v.hpMax, 200);
      expect(v.shieldMax, closeTo(160, 1e-9));
      v.setHull(HullSpec.falcon);
      expect(v.hpMax, 125);
      expect(v.shieldMax, closeTo(100, 1e-9));
    });

    test('a smaller hull spills the extra mods', () {
      final v = Vessel()..newGame();
      v.setHull(HullSpec.byId('colossus'));
      for (final id in ['double', 'rate', 'heavy']) {
        expect(v.fitMod(inst(id), RackKind.front), isNull, reason: id);
      }
      final spill = v.setHull(HullSpec.byId('bastion'));
      expect(spill.length, 2);
      expect(v.racks[RackKind.front]!.fitted.length, 1);
    });
  });

  group('vessel', () {
    test('hull mods rescale stats; unfitting puts them back', () {
      final v = Vessel()..newGame();
      final plate = inst('plate');
      v.fitMod(plate, RackKind.hull);
      expect(v.hpMax, (125 * 1.25).round());
      v.unfitMod(plate);
      expect(v.hpMax, 125);
    });

    test('the save stores base stats and the racks; load restores both', () {
      final v = Vessel()..newGame();
      v.setHull(HullSpec.byId('dynamo'));
      v.fitMod(inst('cell'), RackKind.gen);
      final genMax = v.genMax;
      final save = v.toSaveMap();
      expect(save['genMax'], closeTo(100, 1e-9), reason: 'base, not modded');
      expect(save['hull'], 'dynamo');

      final w = Vessel()..loadFromSave(save);
      expect(w.hull.id, 'dynamo');
      expect(w.racks[RackKind.gen]!.fitted.single.modId, 'cell');
      expect(w.genMax, closeTo(genMax, 1e-6));
    });

    test('a save without mod keys loads the stock hull and empty racks', () {
      final v = Vessel()..newGame();
      final save = v.toSaveMap()
        ..remove('hull')
        ..remove('racks');
      final w = Vessel()..loadFromSave(save);
      expect(w.hull, same(HullSpec.falcon));
      expect(w.fittedMods, isEmpty);
    });

    test('loading a ship takes its mods out of the vault', () {
      final m = inst('plate');
      final v = Vessel()..newGame();
      v.fitMod(m, RackKind.hull);
      final save = v.toSaveMap();
      ModsState.instance.vault.add(m);
      Vessel().loadFromSave(save);
      expect(ModsState.instance.vault, isEmpty);
    });

    test('a new game returns the mods to the vault and keeps the hull', () {
      final v = Vessel()..newGame();
      v.setHull(HullSpec.byId('dart'));
      v.fitMod(inst('double'), RackKind.front);
      v.newGame();
      expect(v.fittedMods, isEmpty);
      expect(ModsState.instance.vault.single.modId, 'double');
      expect(v.hull.id, 'dart');
      expect(v.hpMax, (125 * 0.72).round());
    });

    test('FLUX in the GEN rack cheapens every gun', () {
      final v = Vessel()..newGame();
      final d = v.getDevice(WeaponSlot.frontGun)!;
      final before = v.effectivePwrNeed(d);
      v.fitMod(inst('flux'), RackKind.gen);
      expect(v.effectivePwrNeed(d), closeTo(before * 0.6, 1e-9));
    });

    test('REACTOR lets an over-capacity gun fire; DYNAMO up to 130 %', () {
      final v = Vessel()..newGame();
      expect(v.overreach(v.genMax * 2), isNull);
      v.fitMod(inst('reactor'), RackKind.gen);
      expect(v.overreach(v.genMax * 2), isNotNull);
      final w = Vessel()..newGame();
      w.setHull(HullSpec.byId('dynamo'));
      expect(w.overreach(w.genMax * 1.2), isNotNull);
      expect(w.overreach(w.genMax * 1.5), isNull);
    });

    test('SATELLITE flies a half-strength copy of the front gun', () {
      final v = Vessel()..newGame();
      expect(v.satellite, isNull);
      v.fitMod(inst('satellite'), RackKind.hull);
      final s = v.satellite!;
      expect(s.name, DevType.bubbleGun.name);
      expect(s.slot, WeaponSlot.satellite);
      expect(s.pwrNeed, 0);
      expect(v.guns.length, v.devices.length + 1);
      expect(v.devices.contains(s), isFalse);
    });

    test('mod DPS shows up in the ship DPS', () {
      final v = Vessel()..newGame();
      final base = v.totalDps;
      v.fitMod(inst('double'), RackKind.front);
      expect(v.totalDps, greaterThan(base));
    });
  });

  group('drops', () {
    test('the same seed gives the same drop', () {
      final s = ModsState.instance;
      s.seed = 42;
      final a = s.drop(DropTable.mid).modId;
      s.reset();
      s.seed = 42;
      expect(s.drop(DropTable.mid).modId, a);
    });

    test('a mythic-only table only drops mythics', () {
      for (var i = 0; i < 20; i++) {
        expect(
          ModsState.instance.drop(DropTable.mythicOnly).spec!.rarity,
          ModRarity.mythic,
        );
      }
    });

    test('mods held twice are skipped while others are left', () {
      final s = ModsState.instance;
      final mythics = ModSpec.ofRarity(ModRarity.mythic);
      for (final m in mythics.skip(1)) {
        s.vault.addAll([inst(m.id, '${m.id}1'), inst(m.id, '${m.id}2')]);
      }
      expect(s.dropRarity(ModRarity.mythic).modId, mythics.first.id);
    });

    test('forge: three of a rarity make one of the next', () {
      final s = ModsState.instance;
      final three = [inst('rate', 'a'), inst('heavy', 'b'), inst('crit', 'c')];
      s.vault.addAll(three);
      final made = s.forge(three)!;
      expect(made.spec!.rarity, ModRarity.rare);
      expect(s.vault.single, made);
    });

    test('forge refuses mixed rarities and three mythics make another', () {
      final s = ModsState.instance;
      final mixed = [inst('rate', 'a'), inst('triple', 'b'), inst('crit', 'c')];
      s.vault.addAll(mixed);
      expect(s.forge(mixed), isNull);
      s.reset();
      final myth = [inst('hydra', 'a'), inst('nova', 'b'), inst('flux', 'c')];
      s.vault.addAll(myth);
      final made = s.forge(myth)!;
      expect(made.spec!.rarity, ModRarity.mythic);
      expect(['hydra', 'nova', 'flux'], isNot(contains(made.modId)));
    });

    test('state round-trips through JSON', () {
      final s = ModsState.instance;
      s.vault.add(inst('rate', 'x1'));
      s.unlockedHulls.add('dart');
      s.claim('stars:3');
      s.seed = 99;
      final j = s.toJson();
      s.reset();
      s.loadJson(j);
      expect(s.vault.single.uid, 'x1');
      expect(s.unlockedHulls, containsAll(['falcon', 'dart']));
      expect(s.claimed, {'stars:3'});
      expect(s.seed, 99);
    });
  });

  group('rewards', () {
    NodeResult result(CampaignNode node, {Set<String> met = const {}}) =>
        NodeResult(node.index, [
          for (final o in node.objectives)
            ObjectiveStatus(o, 0, 1, o.required || met.contains(o.id)),
        ]);

    Set<String> allStars(CampaignNode n) => {
      for (final o in n.starObjectives) o.id,
    };

    test('full stars pay once', () {
      final s = ModsState.instance;
      final n = kCampaignNodes[0];
      final r1 = ModRewards.campaignNode(
        state: s,
        node: n,
        result: result(n, met: allStars(n)),
        campaignFinished: false,
      );
      expect(r1.mods.length, 1);
      final r2 = ModRewards.campaignNode(
        state: s,
        node: n,
        result: result(n, met: allStars(n)),
        campaignFinished: false,
      );
      expect(r2.isEmpty, isTrue);
    });

    test('a failed node pays nothing', () {
      final n = kCampaignNodes[0];
      final r = ModRewards.campaignNode(
        state: ModsState.instance,
        node: n,
        result: NodeResult(n.index, [
          for (final o in n.objectives) ObjectiveStatus(o, 0, 1, false),
        ]),
        campaignFinished: false,
      );
      expect(r.isEmpty, isTrue);
    });

    test(
      'boss nodes: a hull, a fast kill pays rare+, a perfect run a mythic',
      () {
        final s = ModsState.instance;
        final n = kCampaignNodes[4];
        final r = ModRewards.campaignNode(
          state: s,
          node: n,
          result: result(n, met: allStars(n)),
          campaignFinished: false,
        );
        expect(r.hulls, ['dart']);
        // full stars + fast kill + perfect
        expect(r.mods.length, 3);
        expect(
          r.mods.skip(1).every((m) => m.spec!.rarity != ModRarity.common),
          isTrue,
        );
        expect(r.mods.last.spec!.rarity, ModRarity.mythic);
      },
    );

    test(
      'the last boss fast kill is a sure mythic; finishing unlocks COLOSSUS',
      () {
        final s = ModsState.instance;
        final n = kCampaignNodes[19];
        final r = ModRewards.campaignNode(
          state: s,
          node: n,
          result: result(n, met: {'bossfast'}),
          campaignFinished: true,
        );
        expect(r.mods.first.spec!.rarity, ModRarity.mythic);
        expect(r.hulls, contains('colossus'));
      },
    );

    test('endless depth milestones pay once each', () {
      final s = ModsState.instance;
      expect(ModRewards.endlessDepth(state: s, cleared: 9).isEmpty, isTrue);
      expect(ModRewards.endlessDepth(state: s, cleared: 10).mods.length, 1);
      expect(ModRewards.endlessDepth(state: s, cleared: 10).isEmpty, isTrue);
      expect(ModRewards.endlessDepth(state: s, cleared: 30).hulls, [
        'colossus',
      ]);
    });

    test('every boss node offers the timed star', () {
      for (final n in kCampaignNodes.where((n) => n.isBoss)) {
        expect(
          n.objectives.any((o) => o.kind == ObjectiveKind.bossUnderTime),
          isTrue,
          reason: n.caption,
        );
      }
    });
  });

  group('tracker', () {
    test('boss kill time runs from the core spawn', () {
      final t = CampaignTracker()..beginNode(4);
      t.onBossSpawn(30);
      t.bossKilledAt = 52;
      expect(t.bossKillTime, 22);
      final node = kCampaignNodes[4];
      final spec = node.objectives.firstWhere(
        (o) => o.kind == ObjectiveKind.bossUnderTime,
      );
      final res = t.evaluate(node: node, vessel: Vessel(), hullDamage: true);
      final st = res.objectives.firstWhere((o) => o.spec.id == spec.id);
      expect(st.met, 22 <= spec.amount);
    });

    test('no boss kill, no star', () {
      final t = CampaignTracker()
        ..beginNode(4)
        ..onBossSpawn(30);
      final node = kCampaignNodes[4];
      final res = t.evaluate(node: node, vessel: Vessel(), hullDamage: false);
      expect(
        res.objectives.firstWhere((o) => o.spec.id == 'bossfast').met,
        isFalse,
      );
    });
  });
}
