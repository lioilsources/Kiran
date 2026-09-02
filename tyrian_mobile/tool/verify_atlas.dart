// ignore_for_file: avoid_print
/// Compares a freshly packed atlas.webp against the atlas.png it was encoded
/// from and reports what the lossy step actually cost, per sprite.
///
/// A whole-image average hides the thing that matters: a single small enemy
/// sprite degrading badly is invisible in the mean and very visible in game.
/// So the error is measured per frame from atlas.json, weighted by alpha (a
/// transparent pixel's RGB is never drawn, and PNG and WebP disagree about it
/// freely), and the frames are reported worst-first.
///
/// Usage: dart run tool/verify_atlas.dart [skinId ...]
///        (no arguments = every skin)
library;

import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;

/// Above this mean alpha-weighted RGB error a frame is worth looking at.
///
/// near_lossless keeps every frame measured so far under 1/255, so 2.0 is a
/// tripwire for "the encoder settings changed", not a quality judgement. Plain
/// lossy q92 put the default skin's vulcan bullet at 17/255 with visible
/// smearing; that is the regression this number exists to catch.
const double kWarnMean = 2.0;

/// Alpha levels near_lossless is allowed to move. 2/255 is 0.8% opacity.
const int kAlphaTolerance = 2;

void main(List<String> args) {
  final root = Directory('assets/skins');
  if (!root.existsSync()) {
    stderr.writeln('Run from tyrian_mobile/.');
    exit(1);
  }
  final skins = args.isNotEmpty
      ? args
      : (root.listSync().whereType<Directory>().map((d) => d.uri.pathSegments
          .where((s) => s.isNotEmpty)
          .last).toList()
        ..sort());

  var worstOverall = 0.0;
  var alphaClean = true;
  for (final skin in skins) {
    final webpFile = File('assets/skins/$skin/atlas.webp');
    final pngFile = File('assets/skins/$skin/atlas.png');
    if (!webpFile.existsSync()) {
      print('$skin: no atlas.webp — skipped');
      continue;
    }
    if (!pngFile.existsSync()) {
      print('$skin: no atlas.png to compare against (packer deletes it; '
          'run pack_atlas with the PNG kept to verify)');
      continue;
    }
    final a = img.decodePng(pngFile.readAsBytesSync());
    final b = img.decodeWebP(webpFile.readAsBytesSync());
    if (a == null || b == null) {
      print('$skin: decode failed');
      continue;
    }
    if (a.width != b.width || a.height != b.height) {
      print('$skin: SIZE MISMATCH ${a.width}x${a.height} vs ${b.width}x${b.height}');
      continue;
    }

    final frames = (jsonDecode(
            File('assets/skins/$skin/atlas.json').readAsStringSync())
        as Map<String, dynamic>)['frames'] as Map<String, dynamic>;

    var alphaDiffs = 0;
    var alphaWorst = 0;
    final perFrame = <String, double>{};
    frames.forEach((name, raw) {
      final f = raw as Map<String, dynamic>;
      final x0 = f['x'] as int, y0 = f['y'] as int;
      final w = f['w'] as int, h = f['h'] as int;
      var sum = 0.0;
      var n = 0;
      for (var y = y0; y < y0 + h; y++) {
        for (var x = x0; x < x0 + w; x++) {
          final pa = a.getPixel(x, y), pb = b.getPixel(x, y);
          if (pa.a != pb.a) {
            alphaDiffs++;
            final d = (pa.a - pb.a).abs().round();
            if (d > alphaWorst) alphaWorst = d;
          }
          if (pa.a <= 8) continue; // never drawn
          final d = ((pa.r - pb.r).abs() +
                  (pa.g - pb.g).abs() +
                  (pa.b - pb.b).abs()) /
              3 *
              (pa.a / 255);
          sum += d;
          n++;
        }
      }
      if (n > 0) perFrame[name] = sum / n;
    });

    final worst = perFrame.entries.toList()
      ..sort((p, q) => q.value.compareTo(p.value));
    final skinWorst = worst.isEmpty ? 0.0 : worst.first.value;
    worstOverall = skinWorst > worstOverall ? skinWorst : worstOverall;
    // near_lossless preprocesses every channel including alpha, so a delta of
    // 1-2 levels is expected and imperceptible (2/255 is 0.8% opacity). Only a
    // bigger shift means the encoder settings drifted into real lossy mode.
    if (alphaWorst > kAlphaTolerance) alphaClean = false;

    final flag = skinWorst > kWarnMean ? '  <-- REVIEW' : '';
    print('${skin.padRight(16)} alpha max-delta: $alphaWorst (${alphaDiffs}px)   '
        'worst frame: ${worst.isEmpty ? "-" : worst.first.key} '
        '(${skinWorst.toStringAsFixed(2)}/255)$flag');
    for (final e in worst.take(3).skip(1)) {
      print('${" " * 18}${e.key} (${e.value.toStringAsFixed(2)}/255)');
    }
  }

  print('');
  print(alphaClean
      ? 'Alpha: within +/-$kAlphaTolerance everywhere (imperceptible).'
      : 'Alpha: SHIFT BEYOND +/-$kAlphaTolerance — the encoder is losing more '
          'than near_lossless should.');
  print('Worst frame across all skins: ${worstOverall.toStringAsFixed(2)}/255 '
      '(threshold $kWarnMean)');
  if (!alphaClean || worstOverall > kWarnMean) exit(1);
}
