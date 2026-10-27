import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/rendering/shader_config.dart';
import 'package:tyrian_mobile/services/skin_registry.dart';
import 'package:tyrian_mobile/ui/ui_theme.dart';

/// Every skin must be fully registered everywhere, not just in kSkins.
///
/// Both lookups fall back silently — ShaderConfig.defaults[id] to a bare
/// config, UiTheme.forSkin to the default theme — so a skin added to kSkins
/// and forgotten elsewhere ships looking subtly wrong with nothing to show
/// for it. river_raid was in exactly that state until this test was written.
void main() {
  test('every skin has a shader preset', () {
    final missing = [
      for (final s in kSkins)
        if (!ShaderConfig.defaults.containsKey(s.id)) s.id,
    ];
    expect(missing, isEmpty,
        reason: 'these skins would silently render with no post-processing');
  });

  test('every skin has a UI theme', () {
    final missing = [
      for (final s in kSkins)
        if (UiTheme.forSkin(s.id) == UiTheme.forSkin('__nonexistent__') &&
            s.id != 'default')
          s.id,
    ];
    expect(missing, isEmpty,
        reason: 'these skins fall through to the default ComCenter theme');
  });

  // App Store Connect reserves a product id permanently the moment it is first
  // saved, and deleting the product does not give it back. An id burned by a
  // mistyped entry — wrong type, wrong price, a typo — is gone for that app
  // forever, so the skin has to ship under a different one. Each exception
  // records why, because the deviation is otherwise indistinguishable from a
  // typo and someone will 'fix' it back to the dead id.
  const burnedProductIds = <String, String>{
    'fantasy_zone': 'com.ol1n.kiran.skin_candy_drift',
    // skin_fantasy_zone was saved as Consumable by mistake; deleting it did
    // not release the id. Renamed to the skin's public name, Candy Drift.
  };

  test('paid skins use the canonical product id', () {
    for (final s in kSkins) {
      if (s.productId == null) continue;
      final want = burnedProductIds[s.id] ?? 'com.ol1n.kiran.skin_${s.id}';
      expect(s.productId, want,
          reason: 'product ids can never be renamed once published');
    }
  });

  test('skin ids are unique', () {
    final ids = kSkins.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length);
  });
}
