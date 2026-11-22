import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tyrian_mobile/systems/mods/mod_spec.dart';

/// Every skin's mod icon sheet (pipeline/cmd/modicons) must match what
/// AssetLibrary reads: known mod ids, cells inside the image, both files
/// present together. A skin without a sheet is fine: it borrows default's.
void main() {
  final ids = {for (final m in kMods) m.id};
  final sheets = Directory('assets/skins')
      .listSync()
      .whereType<Directory>()
      .map((d) => File('${d.path}/ui/mod_icons.json'))
      .where((f) => f.existsSync())
      .toList();

  for (final json in sheets) {
    final skin = json.parent.parent.uri.pathSegments
        .where((s) => s.isNotEmpty)
        .last;
    test('$skin mod icon sheet', () {
      final meta = jsonDecode(json.readAsStringSync()) as Map<String, dynamic>;
      final cell = meta['cell'] as int;
      final cols = meta['cols'] as int;
      final icons = (meta['icons'] as Map<String, dynamic>).cast<String, int>();

      final unknown = icons.keys.where((k) => !ids.contains(k)).toList();
      expect(unknown, isEmpty, reason: 'ids that are not a ModSpec');
      expect(icons.values.toSet().length, icons.length, reason: 'shared cells');

      final webp = File(json.path.replaceFirst('.json', '.webp'));
      expect(webp.existsSync(), isTrue);
      final sheet = img.decodeWebP(webp.readAsBytesSync())!;
      for (final e in icons.entries) {
        final x = (e.value % cols) * cell, y = (e.value ~/ cols) * cell;
        expect(
          x + cell <= sheet.width && y + cell <= sheet.height,
          isTrue,
          reason: '${e.key} lies outside the sheet',
        );
      }
    });
  }

  test('every skin with icons declares its ui/ folder', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final json in sheets) {
      final skin = json.parent.parent.uri.pathSegments
          .where((s) => s.isNotEmpty)
          .last;
      expect(pubspec, contains('assets/skins/$skin/ui/'));
    }
  });
}
