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

  test('paid skins use the canonical product id', () {
    for (final s in kSkins) {
      if (s.productId == null) continue;
      expect(s.productId, 'com.ol1n.kiran.skin_${s.id}',
          reason: 'product ids can never be renamed once published');
    }
  });

  test('skin ids are unique', () {
    final ids = kSkins.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length);
  });
}
