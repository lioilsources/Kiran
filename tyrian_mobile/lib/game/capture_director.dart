import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'duel_space.dart';
import '../systems/sigils/sigil_catalog.dart';
import '../systems/sigils/sigil_spec.dart';
import '../systems/training/arena_ghost.dart';
import 'tyrian_game.dart';

/// One stretch of tutorial footage: the ghost draws [sigil] at world
/// [speed], and the take runs on for [tail] seconds of game time after the
/// drawing so the move itself is in the shot.
class CaptureSegment {
  final String name;
  final SigilKind sigil;
  final double speed;
  final double lead;
  final double tail;
  final bool mirrored;

  const CaptureSegment(this.name, this.sigil,
      {this.speed = 1, this.lead = 0.6, this.tail = 2.2, this.mirrored = false});
}

/// Films a lesson for the tutorial videos (Prompts/29 §6.3), off real time:
/// the game advances one fixed 1/60 s step, the frame is rendered to PNG,
/// and the next step waits until the file is written — no dropped frames,
/// whatever the machine. Slow motion is filmed slow (world speed ¼ at a full
/// 60 frames a second), not stretched afterwards.
///
/// Alongside the frames it writes `events.json`: per frame the stick in
/// ship space, the dots drawn, whether the ship was untouchable, and every
/// reading — what the assembler needs to draw the input panel and place
/// the freeze frames. With `--dart-define=LESSON_CAPTURE=loop` the app
/// films that sigil and quits.
class CaptureDirector {
  CaptureDirector(this.game, this.segments);

  static const String sigilId = String.fromEnvironment('LESSON_CAPTURE');
  static bool get requested => sigilId.isNotEmpty;

  /// The standard take of a sigil: full speed, a quarter speed, full speed.
  factory CaptureDirector.standard(TyrianGame game, SigilKind k) =>
      CaptureDirector(game, [
        CaptureSegment('hook', k, lead: 1.2),
        CaptureSegment('slow', k, speed: 0.25, tail: 2.6),
        CaptureSegment('use', k, mirrored: true, tail: 2.6),
      ]);

  final TyrianGame game;
  final List<CaptureSegment> segments;

  static const double step = 1 / 60;

  int _seg = -1;
  int _frame = 0;
  double _segT = 0;
  bool _drawn = false;
  double _afterDrawn = 0;
  bool busy = false;
  bool finished = false;
  late final Directory _root;
  final List<Map<String, dynamic>> _log = [];
  List<Map<String, dynamic>> _frames = [];
  List<Map<String, dynamic>> _readings = [];

  CaptureSegment? get current =>
      _seg >= 0 && _seg < segments.length ? segments[_seg] : null;

  /// World speed for the take in progress.
  double get speed => current?.speed ?? 1;

  void start() {
    final base = Platform.environment['KIRIAN_CAPTURE_DIR'];
    _root = Directory(base ?? '${Directory.systemTemp.path}/kirian_capture/$sigilId')
      ..createSync(recursive: true);
    // ignore: avoid_print
    print('[CAPTURE] lesson $sigilId → ${_root.path}');
    game.vessel.caster.onReading = (r) => _readings.add({
          'f': _frame,
          'sigil': r.spec?.id,
          'mirrored': r.mirrored,
          'acc': r.accuracy,
          'ms': (r.drawTime * 1000).round(),
          'miss': r.miss?.reason.name,
          'nearest': r.miss?.nearest?.id,
        });
    _nextSegment();
  }

  void _nextSegment() {
    if (current != null) {
      _log.add({
        'name': current!.name,
        'sigil': current!.sigil.name,
        'speed': current!.speed,
        'frames': _frame,
        'stick': _frames,
        'readings': _readings,
      });
    }
    _seg++;
    if (current == null) {
      _finish();
      return;
    }
    _frame = 0;
    _segT = 0;
    _drawn = false;
    _afterDrawn = 0;
    _frames = [];
    _readings = [];
    Directory('${_root.path}/${current!.name}').createSync(recursive: true);
    final spec = SigilCatalog.of(current!.sigil);
    game.ghost = ArenaGhost([spec],
        lead: current!.lead, once: true, mirrorEvery: current!.mirrored ? 1 : 0)
      ..onDrawn = () => _drawn = true;
  }

  /// After one fixed step was simulated: record it and film it.
  void afterStep() {
    final seg = current;
    if (seg == null) return;
    final caster = game.vessel.caster;
    final rec = caster.recognizer;
    _frames.add({
      'x': double.parse(rec.stickX.toStringAsFixed(3)),
      'y': double.parse(rec.stickY.toStringAsFixed(3)),
      'd': rec.drawing ? rec.drawn : const <int>[],
      'u': caster.untouchable,
      'l': rec.drawing ? rec.layer.name : null,
      // In a duel the pad turns with the nose: the angle to turn the panel
      // by so the stroke shows where the thumb made it (Prompts/30 §10).
      if (game.duel.geometry)
        'a': double.parse(
            (caster.padFrame.heading - uprightAngle).toStringAsFixed(4)),
    });
    _shoot('${_root.path}/${seg.name}/frame_${_frame.toString().padLeft(5, '0')}.png');
    _frame++;
    _segT += step;
    if (_drawn) {
      _afterDrawn += step * seg.speed;
      if (_afterDrawn >= seg.tail) {
        game.ghost = null;
        _nextSegment();
      }
    } else if (_segT > 60) {
      // The ghost never finished: film nothing more of this take.
      _nextSegment();
    }
  }

  Future<void> _shoot(String path) async {
    busy = true;
    try {
      // The canvas, not game.size: that is the viewport's virtual size, and
      // filming it cut the right and bottom off every frame.
      final w = game.canvasSize.x.round(), h = game.canvasSize.y.round();
      final rec = ui.PictureRecorder();
      game.render(ui.Canvas(rec));
      final img = await rec.endRecording().toImage(w, h);
      final png = await img.toByteData(format: ui.ImageByteFormat.png);
      img.dispose();
      if (png != null) await File(path).writeAsBytes(png.buffer.asUint8List());
    } finally {
      busy = false;
    }
  }

  Future<void> _finish() async {
    finished = true;
    while (busy) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    await File('${_root.path}/events.json').writeAsString(const JsonEncoder.withIndent(' ')
        .convert({
      'sigil': sigilId,
      'fps': 60,
      // The arena is a duel: the field is filmed upright, not on its side.
      'orientation': game.duel.geometry ? 'duel' : 'flight',
      'width': game.canvasSize.x.round(),
      'height': game.canvasSize.y.round(),
      'segments': _log,
    }));
    // ignore: avoid_print
    print('[CAPTURE] done: ${_log.length} takes');
    exit(0);
  }
}
