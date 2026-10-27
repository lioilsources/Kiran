import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/services/asset_library.dart';

/// Switching skins must always leave the player's ship drawable.
///
/// Reported from the game: coming back to the Kirian/default skin from the
/// ComCenter after a level left the ship invisible. The ship comes from
/// AssetLibrary.vesselFrames, which loadAll() only rebuilds on the
/// atlas-success path — so any path that leaves it stale or empty is a
/// vanished ship, and default is one of the three free skins everyone tries.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Flame.images = Images(prefix: 'assets/');
  });

  Future<void> expectShipDrawable(String skin) async {
    final lib = AssetLibrary.instance;
    await lib.loadSkin(skin);
    expect(lib.vesselFrames, isNotEmpty,
        reason: '$skin: no vessel frames — the ship would be invisible');
    expect(lib.getSprite('falcon1'), isNotNull,
        reason: '$skin: no enemies either — the atlas did not load');
  }

  test('default loads on its own', () async {
    await expectShipDrawable('default');
  });

  test('another skin then back to default', () async {
    await expectShipDrawable('rtype');
    await expectShipDrawable('default');
  });

  test('live entities are re-pointed inside loadSkin, before any audio load',
      () async {
    // The bug this guards: the ComCenter swapped graphics first, then spent
    // up to tens of seconds loading audio, and only then asked the game to
    // re-point its entities — behind a `if (!mounted) return`. Close the
    // ComCenter in that window and the ship kept drawing from an image
    // clearCache had already disposed, which throws and takes the rest of the
    // world render with it. The re-point has to happen inside loadSkin.
    final lib = AssetLibrary.instance;
    await lib.loadSkin('default');

    var refreshes = 0;
    var framesAtRefresh = -1;
    lib.onSkinAssetsChanged = () {
      refreshes++;
      framesAtRefresh = lib.vesselFrames.length;
    };
    addTearDown(() => lib.onSkinAssetsChanged = null);

    await lib.loadSkin('rtype');
    expect(refreshes, 1, reason: 'loadSkin must notify exactly once');
    expect(framesAtRefresh, greaterThan(0),
        reason: 'the new frames must already be in place when it fires');
  });

  test('repeated switches never lose the ship', () async {
    for (final skin in ['default', 'galaga', 'default', 'rtype', 'default']) {
      await expectShipDrawable(skin);
    }
  });
}
