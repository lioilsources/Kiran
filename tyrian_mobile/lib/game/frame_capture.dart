import 'dart:io';
import 'dart:ui' as ui;

import 'package:flame/game.dart';

/// Renders the game into PNG files on disk (Prompts/29 §6.3): the capture
/// path for tutorial footage and for looking at a build nobody is watching.
/// Draws the Flame tree only — the Flutter overlays (OSD, panels) are not in
/// the picture; the sigil pad is, because it lives in the camera viewport.
///
/// On with `--dart-define=FRAME_DUMP=true`; frames land in the system temp
/// directory (inside the app's container on a sandboxed macOS build), and
/// the path is printed once.
class FrameCapture {
  FrameCapture(this.game, {this.every = 1.0, this.limit = 40});

  static const bool enabled = bool.fromEnvironment('FRAME_DUMP');

  final FlameGame game;

  /// Seconds between two frames, and how many to keep at most.
  final double every;
  final int limit;

  double _t = 0;
  int _n = 0;
  bool _busy = false;
  Directory? _dir;

  void tick(double dt) {
    if (_n >= limit || _busy) return;
    _t += dt;
    if (_t < every) return;
    _t = 0;
    _grab();
  }

  Future<void> _grab() async {
    _busy = true;
    try {
      final dir = _dir ??= () {
        final d = Directory('${Directory.systemTemp.path}/kirian_frames')
          ..createSync(recursive: true);
        // ignore: avoid_print
        print('[CAPTURE] frames → ${d.path}');
        return d;
      }();
      final w = game.size.x.round(), h = game.size.y.round();
      if (w <= 0 || h <= 0) return;
      final rec = ui.PictureRecorder();
      final canvas = ui.Canvas(rec);
      game.render(canvas);
      final img = await rec.endRecording().toImage(w, h);
      final png = await img.toByteData(format: ui.ImageByteFormat.png);
      img.dispose();
      if (png == null) return;
      final name = 'frame_${(_n++).toString().padLeft(4, '0')}.png';
      await File('${dir.path}/$name').writeAsBytes(png.buffer.asUint8List());
    } finally {
      _busy = false;
    }
  }
}
