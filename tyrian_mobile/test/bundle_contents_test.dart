import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The bundle must never regain the per-sprite PNGs.
///
/// They are the masters `tool/pack_atlas.dart` packs into each skin's atlas,
/// and the game only ever reads the atlas — shipping both cost 75 MB. A stray
/// `- assets/skins/<id>/sprites/` line in pubspec.yaml would silently put it
/// all back, and nothing else in the suite would notice.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('no individual skin sprites are bundled', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final offenders = manifest
        .listAssets()
        .where((a) => RegExp(r'assets/skins/[^/]+/sprites/').hasMatch(a))
        .toList();
    expect(offenders, isEmpty,
        reason: 'sprites/ is atlas input, not a runtime asset');
  });

  test('every skin still ships an atlas', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets();
    final skins = assets
        .map((a) => RegExp(r'assets/skins/([^/]+)/').firstMatch(a)?.group(1))
        .whereType<String>()
        .toSet();
    expect(skins, isNotEmpty);
    for (final skin in skins) {
      expect(assets.any((a) => RegExp('assets/skins/$skin/atlas\\.(png|webp)\$').hasMatch(a)),
          isTrue, reason: '$skin has no atlas — it would render nothing');
    }
  });
}
