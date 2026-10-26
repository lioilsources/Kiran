// Headless RL environment server for Kiran (UC4 of the GPU sandbox plan).
//
// Runs the real TyrianGame without a window, inside `flutter test`, and serves
// it over TCP as JSON lines so a Python agent can play it:
//
//   RL_PORT=7000 flutter test test/rl/rl_server_test.dart
//
// Protocol (one JSON object per line, one reply per request):
//   {"cmd":"reset","sector":3}           → observation
//   {"cmd":"step","a":[dx,dy,fire],"k":4} → observation after k frames of 1/60 s
//   {"cmd":"next"}                       → after a completed sector: advance and open the shop, as the app does
//   {"cmd":"shop","op":i}                → one shop action (see _shop), → observation
//   {"cmd":"launch"}                     → close the shop: full repair, fly the loaded sector
//   {"cmd":"close"}                      → ends the test
// Observation: {"v":[x,y,hp,hpMax,shield,shieldMax,gen,genMax],"h":[[x,y,hp,w,h],…],
//   "p":[[x,y,w,h,speed],…],"c":[[x,y,type],…],"score":n,"t":s,"over":b,"done":b,
//   "sector":i,"field":[w,h],"k":[kills,count,fleetsCleared,fleetsFinished,fleets,escaped]}
// k sums the current sector's fleets: a fleet is finished once all its enemies
// were spawned and none is alive, and cleared if every one of them was shot down;
// the rest of a finished fleet flew off screen (escaped).
// "shop":{"credit":n,"unlock":i,"front":[tier,level,price],"left":…,"right":…,"gen":…,"mask":[8 × 0/1]}
// describes the loadout (tier -1 = empty slot) and which shop actions are affordable now.
// The game is stepped synchronously by the server, never by a vsync, so a
// headless env runs hundreds of times faster than real time.
import 'dart:convert';
import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/fleet.dart';
import 'package:tyrian_mobile/systems/sector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('rl env server', (tester) async {
    final port = int.parse(Platform.environment['RL_PORT'] ?? '7000');
    final game = TyrianGame();
    var action = (dx: 0.0, dy: 0.0, fire: false);
    await tester.runAsync(() async {
      game.onGameResize(Vector2(400, 800));
      await game.load();
      game.mount(); // ignore: invalid_use_of_internal_member
      await game.ready();
      game.botInput = () => action;

      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
      stdout.writeln('RL_READY $port parts=${Sector.partCount}');
      final client = await server.first;
      final lines = client.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter());

      // Shop actions mirror the ComCenter's buy/upgrade buttons (no selling):
      // 0 launch, 1 upgrade front gun, 2 buy next front weapon, 3/4 left/right side gun
      // (buy the cheapest if empty, else upgrade), 5 upgrade generator, 6/7 left/right next side weapon.
      int tierOf(Device? d, List<DevType> list) =>
          d == null ? -1 : list.indexWhere((t) => t.name == d.name);
      int maxTier(List<DevType> list) => game.vessel.nextWeaponLevel.clamp(0, list.length - 1);
      DevType? nextType(Device? d, List<DevType> list) {
        final t = tierOf(d, list) + 1;
        return t <= maxTier(list) ? list[t] : null;
      }

      bool shop(int op, {bool apply = false}) {
        final v = game.vessel;
        bool upgrade(WeaponSlot slot) {
          final d = v.getDevice(slot);
          if (d == null || d.level >= Device.maxLevel || v.credit < d.price) return false;
          if (apply) {
            v.credit -= d.price;
            d.upgrade();
          }
          return true;
        }

        bool buy(DevType? t, WeaponSlot slot) {
          if (t == null || v.credit < t.price) return false;
          if (apply) {
            v.credit -= t.price;
            v.equipWeapon(t, slot);
          }
          return true;
        }

        switch (op) {
          case 0:
            return true;
          case 1:
            return upgrade(WeaponSlot.frontGun);
          case 2:
            return buy(nextType(v.getDevice(WeaponSlot.frontGun), DevType.frontWeapons), WeaponSlot.frontGun);
          case 3:
          case 4:
            final slot = op == 3 ? WeaponSlot.leftGun : WeaponSlot.rightGun;
            return v.getDevice(slot) == null ? buy(DevType.sideWeapons.first, slot) : upgrade(slot);
          case 5:
            return upgrade(WeaponSlot.generator);
          case 6:
          case 7:
            final slot = op == 6 ? WeaponSlot.leftGun : WeaponSlot.rightGun;
            return buy(nextType(v.getDevice(slot), DevType.sideWeapons), slot);
        }
        return false;
      }

      List<num> slotState(WeaponSlot slot, List<DevType> list) {
        final d = game.vessel.getDevice(slot);
        return d == null ? [-1, 0, 0] : [tierOf(d, list), d.level, d.price];
      }

      Map<String, Object?> observe() {
        final v = game.vessel;
        final hostiles = <List<num>>[];
        for (final f in game.activeFleets) {
          for (final h in f.hostiles) {
            if (h.isDead) continue;
            hostiles.add([h.position.x, h.position.y, h.hp, h.size.x, h.size.y]);
          }
        }
        var kills = 0, count = 0, cleared = 0, finished = 0, fleets = 0, escaped = 0;
        for (final Fleet f in game.currentSector?.fleets ?? const <Fleet>[]) {
          fleets++;
          kills += f.kills;
          count += f.count;
          if (f.started && !f.active) {
            finished++;
            if (f.kills >= f.count) cleared++;
            if (f.count > f.kills) escaped += f.count - f.kills;
          }
        }
        return {
          'v': [v.position.x, v.position.y, v.hp, v.hpMax, v.shield, v.shieldMax, v.genValue, v.genMax],
          'h': hostiles,
          'p': [
            for (final p in game.enemyProjectiles)
              if (p.active) [p.position.x, p.position.y, p.size.x, p.size.y, p.speed]
          ],
          'c': [for (final c in game.activeCollectables) [c.position.x, c.position.y, c.cType.index]],
          'score': v.score,
          't': game.elapsed,
          'over': game.state == GameState.gameOver || v.hp <= 0,
          'done': game.currentSector?.isComplete ?? false,
          'sector': game.currentSectorIndex,
          'field': [config.gameWidth, config.gameHeight],
          'k': [kills, count, cleared, finished, fleets, escaped],
          'shop': {
            'credit': v.credit,
            'unlock': v.nextWeaponLevel,
            'front': slotState(WeaponSlot.frontGun, DevType.frontWeapons),
            'left': slotState(WeaponSlot.leftGun, DevType.sideWeapons),
            'right': slotState(WeaponSlot.rightGun, DevType.sideWeapons),
            'gen': slotState(WeaponSlot.generator, DevType.generators),
            'mask': [for (var i = 0; i < 8; i++) shop(i) ? 1 : 0],
          },
        };
      }

      await for (final line in lines) {
        final req = jsonDecode(line) as Map<String, dynamic>;
        switch (req['cmd']) {
          case 'reset':
            game.resetForNewGame();
            game.currentSectorIndex = (req['sector'] as num?)?.toInt() ?? 0;
            action = (dx: 0.0, dy: 0.0, fire: false);
            game.startGame();
            await Future<void>.delayed(Duration.zero);
          case 'step':
            final a = (req['a'] as List).cast<num>();
            action = (dx: a[0].toDouble(), dy: a[1].toDouble(), fire: a[2] != 0);
            final k = (req['k'] as num?)?.toInt() ?? 4;
            for (var i = 0; i < k && game.state == GameState.playing; i++) {
              game.update(1 / 60);
              // Components finish their async onLoad between frames.
              await Future<void>.delayed(Duration.zero);
            }
          case 'next':
            game.advanceToNextSector();
            game.openComCenter();
            await Future<void>.delayed(Duration.zero);
          case 'shop':
            shop((req['op'] as num).toInt(), apply: true);
          case 'launch':
            game.vessel.resetVessel();
            game.vessel.resetPosition();
            game.resumeFromComCenter();
            await Future<void>.delayed(Duration.zero);
          case 'close':
            client.writeln('{}');
            await client.close();
            await server.close();
            return;
        }
        client.writeln(jsonEncode(observe()));
      }
    });
  }, timeout: Timeout.none);
}
