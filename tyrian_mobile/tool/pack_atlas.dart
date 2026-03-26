// ignore_for_file: avoid_print
/// Build-time texture atlas packer.
///
/// Scans each skin's sprites/ directory, packs all PNGs into a single
/// atlas image using shelf-packing, and writes atlas.png + atlas.json.
///
/// Run via: dart run tool/pack_atlas.dart
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

/// 1 px padding between sprites to prevent texture bleeding.
const int kPadding = 1;

/// Minimum atlas dimension (power of 2).
const int kMinSize = 512;

/// Maximum atlas dimension (power of 2).
const int kMaxSize = 1024;

/// A loaded sprite ready for packing.
class _SpriteEntry {
  final String name;
  final img.Image image;
  _SpriteEntry(this.name, this.image);
}

/// A placed sprite within the atlas.
class _PlacedSprite {
  final String name;
  final int x, y, w, h;
  _PlacedSprite(this.name, this.x, this.y, this.w, this.h);
}

/// Try to shelf-pack sprites into an atlas of the given dimensions.
/// Returns placed sprites on success, or null if they don't fit.
List<_PlacedSprite>? _shelfPack(
  List<_SpriteEntry> sprites,
  int atlasW,
  int atlasH,
) {
  final placed = <_PlacedSprite>[];
  int shelfX = 0; // current x position on the shelf
  int shelfY = 0; // current shelf top-y
  int shelfH = 0; // tallest sprite on current shelf

  for (final entry in sprites) {
    final w = entry.image.width;
    final h = entry.image.height;

    // Does the sprite fit on the current shelf?
    if (shelfX + w > atlasW) {
      // Start a new shelf
      shelfY += shelfH + kPadding;
      shelfX = 0;
      shelfH = 0;
    }

    // Check vertical overflow
    if (shelfY + h > atlasH) {
      return null; // doesn't fit
    }

    placed.add(_PlacedSprite(entry.name, shelfX, shelfY, w, h));
    shelfX += w + kPadding;
    if (h > shelfH) shelfH = h;
  }

  return placed;
}

/// Pack a single skin's sprites into an atlas.
Future<bool> _packSkin(String skinId, Directory skinsRoot) async {
  final spritesDir =
      Directory('${skinsRoot.path}${Platform.pathSeparator}$skinId${Platform.pathSeparator}sprites');

  if (!spritesDir.existsSync()) {
    print('  [$skinId] No sprites/ directory — skipping.');
    return false;
  }

  // Collect all PNGs
  final pngFiles = spritesDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.png'))
      .toList();

  if (pngFiles.isEmpty) {
    print('  [$skinId] No PNG files found — skipping.');
    return false;
  }

  // Load all sprite images
  final sprites = <_SpriteEntry>[];
  for (final file in pngFiles) {
    try {
      final bytes = file.readAsBytesSync();
      final decoded = img.decodePng(bytes);
      if (decoded == null) {
        print('  [$skinId] WARNING: Could not decode ${file.path}');
        continue;
      }
      final name = file.uri.pathSegments.last.replaceAll('.png', '');
      sprites.add(_SpriteEntry(name, decoded));
    } catch (e) {
      print('  [$skinId] WARNING: Error loading ${file.path}: $e');
    }
  }

  if (sprites.isEmpty) {
    print('  [$skinId] No valid sprites loaded — skipping.');
    return false;
  }

  // Sort by height (tallest first) for better shelf packing
  sprites.sort((a, b) => b.image.height.compareTo(a.image.height));

  // Try power-of-2 sizes from kMinSize up to kMaxSize
  List<_PlacedSprite>? placed;
  int atlasW = kMinSize;
  int atlasH = kMinSize;

  // Try square sizes first, then rectangular
  for (int size = kMinSize; size <= kMaxSize; size *= 2) {
    // Try square
    placed = _shelfPack(sprites, size, size);
    if (placed != null) {
      atlasW = size;
      atlasH = size;
      break;
    }
    // Try wider rectangle
    if (size < kMaxSize) {
      placed = _shelfPack(sprites, size * 2, size);
      if (placed != null) {
        atlasW = size * 2;
        atlasH = size;
        break;
      }
      // Try taller rectangle
      placed = _shelfPack(sprites, size, size * 2);
      if (placed != null) {
        atlasW = size;
        atlasH = size * 2;
        break;
      }
    }
  }

  if (placed == null) {
    print('  [$skinId] ERROR: Sprites do not fit in ${kMaxSize}x$kMaxSize atlas!');
    return false;
  }

  // Compute the tight bounding box and round up to next power of 2
  int usedW = 0;
  int usedH = 0;
  for (final p in placed) {
    usedW = max(usedW, p.x + p.w);
    usedH = max(usedH, p.y + p.h);
  }
  atlasW = _nextPow2(usedW);
  atlasH = _nextPow2(usedH);

  // Create the atlas image (RGBA, transparent background)
  final atlas = img.Image(width: atlasW, height: atlasH, numChannels: 4);
  // Image is already zeroed (transparent)

  // Composite each sprite into the atlas
  final spriteMap = {for (final s in sprites) s.name: s};
  for (final p in placed) {
    final src = spriteMap[p.name]!.image;
    img.compositeImage(atlas, src, dstX: p.x, dstY: p.y);
  }

  // Write atlas.png
  final skinDir =
      Directory('${skinsRoot.path}${Platform.pathSeparator}$skinId');
  final atlasPng = File('${skinDir.path}${Platform.pathSeparator}atlas.png');
  final pngBytes = img.encodePng(atlas);
  atlasPng.writeAsBytesSync(pngBytes);

  // Write atlas.json
  final frames = <String, dynamic>{};
  for (final p in placed) {
    frames[p.name] = {
      'x': p.x,
      'y': p.y,
      'w': p.w,
      'h': p.h,
    };
  }
  final jsonData = {
    'width': atlasW,
    'height': atlasH,
    'frames': frames,
  };
  final atlasJson = File('${skinDir.path}${Platform.pathSeparator}atlas.json');
  atlasJson.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(jsonData),
  );

  final kb = (pngBytes.length / 1024).toStringAsFixed(1);
  print(
    '  [$skinId] ${sprites.length} sprites -> '
    '${atlasW}x$atlasH atlas ($kb KB)',
  );
  return true;
}

/// Round up to the next power of 2 (minimum 64).
int _nextPow2(int v) {
  if (v <= 64) return 64;
  v--;
  v |= v >> 1;
  v |= v >> 2;
  v |= v >> 4;
  v |= v >> 8;
  v |= v >> 16;
  v++;
  return v;
}

void main() async {
  // Determine project root (script is in tool/)
  final scriptFile = File(Platform.script.toFilePath());
  final projectRoot = scriptFile.parent.parent;
  final skinsRoot = Directory('${projectRoot.path}${Platform.pathSeparator}assets${Platform.pathSeparator}skins');

  if (!skinsRoot.existsSync()) {
    print('ERROR: assets/skins/ directory not found at ${skinsRoot.path}');
    exit(1);
  }

  print('Atlas Packer — scanning ${skinsRoot.path}');
  print('');

  // Discover skins from directory listing
  final skinDirs = skinsRoot
      .listSync()
      .whereType<Directory>()
      .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
      .toList()
    ..sort();

  int packed = 0;
  int failed = 0;

  for (final skinId in skinDirs) {
    final success = await _packSkin(skinId, skinsRoot);
    if (success) {
      packed++;
    } else {
      failed++;
    }
  }

  print('');
  print('Done: $packed atlases packed, $failed skipped/failed.');
}
