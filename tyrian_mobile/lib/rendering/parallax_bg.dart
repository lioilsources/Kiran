import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import 'bg_zones.dart';

/// Vertically scrolling parallax background from skin layer images.
/// Layers scroll at different speeds for depth effect.
/// Falls back gracefully when no layers are available (default skin).
class ParallaxBackground extends Component
    with HasGameReference<TyrianGame> {
  List<ui.Image> _layers = [];
  List<double> _offsets = [];

  // Scroll speeds in VB6-frame units (multiplied by dt * originalFps)
  static const _speeds = [0.5, 1.0, 2.0, 3.5];

  // Layers are overscanned horizontally by the max banking shift on each side
  // so the world-shift translate never exposes a bare strip at the edges.
  static const _pad = config.bankParallaxShift;

  void loadLayers() {
    _layers = AssetLibrary.instance.bgLayers;
    // Carry scroll positions across a reload so a skin change cuts cleanly
    // instead of snapping every layer back to the top.
    final old = _offsets;
    _offsets = List<double>.generate(
        _layers.length, (i) => i < old.length ? old[i] : 0.0);
  }

  /// Re-derive the escalating background tint for [level] (1-based). Idempotent
  /// and cheap; call it whenever the sector changes.
  void setLevel(int level) {
    if (level == _tintLevel) return;
    _tintLevel = level;
    final c = BgZones.tintFor(level);
    // modulate multiplies source RGBA by the filter colour, and the filter's
    // alpha is 0xFF so it does not compound with the paint's 0x99 dim.
    _bgPaint.colorFilter =
        c == null ? null : ui.ColorFilter.mode(c, ui.BlendMode.modulate);
  }

  int _tintLevel = -1;

  double _layerScale(ui.Image img) =>
      (config.gameWidth + 2 * _pad) / img.width;

  @override
  void update(double dt) {
    if (_layers.isEmpty) return;
    if (_offsets.length != _layers.length) {
      _offsets = List.filled(_layers.length, 0.0);
    }
    final scaledDt = dt * config.originalFps * game.duel.bgSpeed;
    for (int i = 0; i < _layers.length; i++) {
      _offsets[i] += _speeds[min(i, _speeds.length - 1)] * scaledDt;
      final imgH = _layers[i].height * _layerScale(_layers[i]);
      if (_offsets[i] >= imgH) _offsets[i] -= imgH;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (_offsets.length != _layers.length) return;
    final angle = game.duel.frameAngle;
    if (angle != 0) return _renderTurned(canvas, angle);
    // Banking world shift, scaled by layer depth (slower = farther = less)
    final t = game.worldShiftX / config.bankWorldShift;
    for (int i = 0; i < _layers.length; i++) {
      final img = _layers[i];
      final scale = _layerScale(img);
      final imgH = img.height * scale;
      final offset = _offsets[i];
      final xShift = t *
          config.bankParallaxShift *
          (_speeds[min(i, _speeds.length - 1)] / _speeds.last);

      // Two copies for seamless vertical tiling
      _drawLayer(canvas, img, scale, offset - imgH, xShift);
      _drawLayer(canvas, img, scale, offset, xShift);
    }
  }

  // 0x99 alpha = 60% opacity (background dimmed 40% for entity visibility).
  // Instance-level rather than static: colorFilter carries the per-level
  // danger escalation set by [setLevel]. Note drawImage ignores Paint.color's
  // RGB and honours only its alpha, so the tint has to ride the colour filter.
  final _bgPaint = ui.Paint()..color = const ui.Color(0x99FFFFFF);

  /// The duel's frame (Prompts/30 §8.3): the layers turned about the field's
  /// centre with the ship. Upright, the field is as wide as it is long, so
  /// each layer is enlarged to span it in one piece; mid-turn the corners are
  /// filled with neighbouring tiles, every other one mirrored so they meet
  /// without a seam.
  void _renderTurned(ui.Canvas canvas, double angle) {
    final w = config.gameWidth, h = config.gameHeight;
    final r = sqrt(w * w + h * h) / 2;
    final enlarge = (h + 2 * _pad) / (w + 2 * _pad);
    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(angle);
    canvas.translate(-w / 2, -h / 2);
    for (int i = 0; i < _layers.length; i++) {
      final img = _layers[i];
      final scale = _layerScale(img) * enlarge;
      final tileW = img.width * scale;
      final imgH = img.height * scale;
      // The scroll keeps its pace in screen pixels.
      final offset = _offsets[i] * enlarge % imgH;
      final x0 = w / 2 - tileW / 2;
      final cols = ((r - w / 2) / tileW).ceil() + 1;
      final rowFrom = ((h / 2 - r - offset) / imgH).floor();
      final rowTo = ((h / 2 + r - offset) / imgH).ceil();
      for (var c = -cols; c <= cols; c++) {
        final x = x0 + c * tileW;
        for (var row = rowFrom; row <= rowTo; row++) {
          final y = offset + row * imgH;
          canvas.save();
          if (c.isOdd) {
            canvas.translate(x + tileW, y);
            canvas.scale(-scale, scale);
          } else {
            canvas.translate(x, y);
            canvas.scale(scale);
          }
          canvas.drawImage(img, ui.Offset.zero, _bgPaint);
          canvas.restore();
        }
      }
    }
    canvas.restore();
  }

  void _drawLayer(
      ui.Canvas canvas, ui.Image img, double scale, double y, double xShift) {
    canvas.save();
    canvas.translate(-_pad + xShift, y);
    canvas.scale(scale);
    canvas.drawImage(img, ui.Offset.zero, _bgPaint);
    canvas.restore();
  }
}
