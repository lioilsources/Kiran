import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('headless probe', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2;
    final game = TyrianGame();
    await tester.runAsync(() async {
      game.onGameResize(Vector2(400, 800));
      await game.load();
      game.mount(); // ignore: invalid_use_of_internal_member
      await game.ready();
    });
    print('loaded state=${game.state} size=${game.size} mounted=${game.isMounted} worldMounted=${game.world.isMounted} children=${game.children.length} world=${game.world.children.length}');
    game.botInput = () => (dx: 0.0, dy: 0.0, fire: true);
    game.startGame();
    final sw = Stopwatch()..start();
    var n = 0;
    await tester.runAsync(() async {
    for (; n < 6000 && game.state == GameState.playing; n++) {
      game.vessel.fire = true;
      if (n % 600 == 0) { var h = 0; for (final f in game.activeFleets) { h += f.hostiles.where((x) => !x.isDead).length; } var pp = 0; for (final d in game.vessel.devices) { pp += d.projectiles.where((p) => p.active).length; } print('t=${n ~/ 60}s fleets=${game.activeFleets.length} hostiles=$h eproj=${game.enemyProjectiles.where((p) => p.active).length} pproj=$pp devices=${game.vessel.devices.length} pos=${game.vessel.position} hp=${game.vessel.hp} score=${game.vessel.score}'); }
      try { game.update(1 / 60); await Future<void>.delayed(Duration.zero); } catch (e, st) { print('step $n: $e'); print(st.toString().split('\n').take(4).join(' / ')); break; }
    }
    });
    print('steps=$n ms=${sw.elapsedMilliseconds} state=${game.state} hp=${game.vessel.hp} score=${game.vessel.score} sector=${game.currentSectorIndex}');
  });
}
