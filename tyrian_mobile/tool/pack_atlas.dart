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

/// Default number of Voronoi seed points per fragmentable sprite.
const int kDefaultFragmentCount = 6;

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

/// Returns true if the sprite name is fragmentable (enemies + structures).
bool _isFragmentable(String name) {
  final lower = name.toLowerCase();
  return lower.startsWith('falcon') ||
      lower.startsWith('falconx') ||
      lower.startsWith('bouncer') ||
      lower.startsWith('asteroid');
}

/// For each non-transparent pixel, find the nearest seed (by squared distance).
int _assignCell(int px, int py, List<Point<double>> seeds) {
  int nearest = 0;
  double minDist = double.infinity;
  for (int i = 0; i < seeds.length; i++) {
    final dx = px - seeds[i].x;
    final dy = py - seeds[i].y;
    final d = dx * dx + dy * dy;
    if (d < minDist) {
      minDist = d;
      nearest = i;
    }
  }
  return nearest;
}

/// Returns true if the pixel at (x, y) in [image] is non-transparent (alpha > 0).
bool _isOpaque(img.Image image, int x, int y) {
  return image.getPixel(x, y).a > 0;
}

/// Generate Voronoi seed points biased toward center. Seeds that land on fully
/// transparent pixels are regenerated. Returns [count] valid seeds.
List<Point<double>> _generateSeeds(
  img.Image image,
  Random rng, {
  int count = kDefaultFragmentCount,
}) {
  final w = image.width.toDouble();
  final h = image.height.toDouble();
  final seeds = <Point<double>>[];

  int attempts = 0;
  while (seeds.length < count && attempts < count * 20) {
    attempts++;
    // Bias toward center: average two uniform samples
    final rx = (rng.nextDouble() + rng.nextDouble()) / 2.0;
    final ry = (rng.nextDouble() + rng.nextDouble()) / 2.0;
    final sx = rx * w;
    final sy = ry * h;
    final px = sx.floor().clamp(0, image.width - 1);
    final py = sy.floor().clamp(0, image.height - 1);
    if (_isOpaque(image, px, py)) {
      seeds.add(Point<double>(sx, sy));
    }
  }

  // Fallback: if we couldn't find enough opaque pixels, place remaining seeds
  // uniformly (even if on transparent pixels).
  while (seeds.length < count) {
    seeds.add(Point<double>(rng.nextDouble() * w, rng.nextDouble() * h));
  }

  return seeds;
}

/// Generate Voronoi fragments for a single sprite image.
/// Returns a list of fragment _SpriteEntry plus metadata.
({List<_SpriteEntry> entries, Map<String, dynamic> meta}) _generateFragments(
  String spriteName,
  img.Image image,
) {
  final rng = Random(spriteName.hashCode);
  final seeds = _generateSeeds(image, rng);
  final numCells = seeds.length;

  // Check if sprite has any non-transparent pixels at all
  bool hasOpaquePixel = false;
  for (int y = 0; y < image.height && !hasOpaquePixel; y++) {
    for (int x = 0; x < image.width && !hasOpaquePixel; x++) {
      if (_isOpaque(image, x, y)) hasOpaquePixel = true;
    }
  }
  if (!hasOpaquePixel) {
    return (entries: <_SpriteEntry>[], meta: <String, dynamic>{});
  }

  // Assign every non-transparent pixel to the nearest seed cell.
  // Store per-cell pixel lists and compute bounding boxes.
  final cellPixels = List<List<Point<int>>>.generate(numCells, (_) => []);
  final cellMinX = List<int>.filled(numCells, image.width);
  final cellMinY = List<int>.filled(numCells, image.height);
  final cellMaxX = List<int>.filled(numCells, -1);
  final cellMaxY = List<int>.filled(numCells, -1);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      if (!_isOpaque(image, x, y)) continue;
      final cell = _assignCell(x, y, seeds);
      cellPixels[cell].add(Point<int>(x, y));
      if (x < cellMinX[cell]) cellMinX[cell] = x;
      if (y < cellMinY[cell]) cellMinY[cell] = y;
      if (x > cellMaxX[cell]) cellMaxX[cell] = x;
      if (y > cellMaxY[cell]) cellMaxY[cell] = y;
    }
  }

  // Extract fragment images
  final entries = <_SpriteEntry>[];
  final pieces = <Map<String, dynamic>>[];
  final seedsList = <List<double>>[];

  for (int i = 0; i < numCells; i++) {
    if (cellPixels[i].isEmpty) continue; // skip empty cells

    final fragW = cellMaxX[i] - cellMinX[i] + 1;
    final fragH = cellMaxY[i] - cellMinY[i] + 1;
    final fragImg = img.Image(width: fragW, height: fragH, numChannels: 4);

    for (final pt in cellPixels[i]) {
      fragImg.setPixel(
        pt.x - cellMinX[i],
        pt.y - cellMinY[i],
        image.getPixel(pt.x, pt.y),
      );
    }

    final fragName = '${spriteName}_frag_$i';
    entries.add(_SpriteEntry(fragName, fragImg));
    pieces.add({
      'name': fragName,
      'seedX': double.parse(seeds[i].x.toStringAsFixed(1)),
      'seedY': double.parse(seeds[i].y.toStringAsFixed(1)),
    });
    seedsList.add([
      double.parse(seeds[i].x.toStringAsFixed(1)),
      double.parse(seeds[i].y.toStringAsFixed(1)),
    ]);
  }

  final meta = <String, dynamic>{
    'count': pieces.length,
    'seeds': seedsList,
    'pieces': pieces,
  };

  return (entries: entries, meta: meta);
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

  // Generate Voronoi fragments for fragmentable sprites (enemies + structures)
  final fragmentsMeta = <String, dynamic>{};
  final fragmentEntries = <_SpriteEntry>[];
  for (final sprite in List<_SpriteEntry>.from(sprites)) {
    if (!_isFragmentable(sprite.name)) continue;
    final result = _generateFragments(sprite.name, sprite.image);
    if (result.entries.isNotEmpty) {
      fragmentEntries.addAll(result.entries);
      fragmentsMeta[sprite.name] = result.meta;
    }
  }
  if (fragmentEntries.isNotEmpty) {
    sprites.addAll(fragmentEntries);
    print(
      '  [$skinId] Generated ${fragmentEntries.length} Voronoi fragments '
      'for ${fragmentsMeta.length} sprites.',
    );
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
  final jsonData = <String, dynamic>{
    'width': atlasW,
    'height': atlasH,
    'frames': frames,
    if (fragmentsMeta.isNotEmpty) 'fragments': fragmentsMeta,
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
