// Converts BMP files from ../img/ to PNG with alpha channel.
// The original VBA game uses magenta (0xFF00FF) or pure black (0x000000)
// as the mask/transparent color. This script reads BMPs and creates PNGs
// with those colors made transparent.
//
// Usage: dart run tool/convert_bmp.dart

// ignore_for_file: avoid_print
import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final srcDir = Directory('../img');
  final dstDir = Directory('assets/sprites');

  if (!srcDir.existsSync()) {
    print('Source directory ${srcDir.path} not found');
    exit(1);
  }

  if (!dstDir.existsSync()) {
    dstDir.createSync(recursive: true);
  }

  final files = srcDir.listSync().whereType<File>().where(
    (f) => f.path.toLowerCase().endsWith('.bmp'),
  );

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final baseName = name.replaceAll(RegExp(r'\.bmp$', caseSensitive: false), '');
    final outPath = '${dstDir.path}/${baseName.toLowerCase()}.png';

    print('Converting $name -> ${baseName.toLowerCase()}.png');

    try {
      final bytes = file.readAsBytesSync();
      final image = img.decodeBmp(bytes);
      if (image == null) {
        print('  Failed to decode $name');
        continue;
      }

      // Make magenta (255,0,255) and pure black (0,0,0) transparent
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();

          // Magenta mask color
          if (r >= 250 && g <= 5 && b >= 250) {
            image.setPixelRgba(x, y, 0, 0, 0, 0);
          }
          // Pure black (often background)
          else if (r == 0 && g == 0 && b == 0) {
            image.setPixelRgba(x, y, 0, 0, 0, 0);
          }
        }
      }

      final png = img.encodePng(image);
      File(outPath).writeAsBytesSync(png);
      print('  OK (${image.width}x${image.height})');
    } catch (e) {
      print('  Error: $e');
    }
  }

  // Also need falcon1-6 variants (scaled from base falcon in VBA)
  // These are loaded as separate files in the VBA img dir - check if they exist
  final variants = ['falcon1', 'falcon2', 'falcon3', 'falcon4', 'falcon5', 'falcon6',
                    'falconx2', 'falconx3'];
  for (final v in variants) {
    final src = File('${srcDir.path}/$v.bmp');
    if (!src.existsSync()) {
      // Create from base falcon/falconx
      final base = v.startsWith('falconx') ? 'falconx' : 'falcon';
      final baseFile = File('${dstDir.path}/$base.png');
      if (baseFile.existsSync()) {
        print('Creating $v.png from $base.png (copy)');
        baseFile.copySync('${dstDir.path}/$v.png');
      }
    }
  }

  print('\nDone! Converted ${files.length} files.');
}
