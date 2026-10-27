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
    final scaledDt = dt * config.originalFps;
    for (int i = 0; i < _layers.length; i++) {
      _offsets[i] += _speeds[min(i, _speeds.length - 1)] * scaledDt;
      final imgH = _layers[i].height * _layerScale(_layers[i]);
      if (_offsets[i] >= imgH) _offsets[i] -= imgH;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (_offsets.length != _layers.length) return;
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

  void _drawLayer(
      ui.Canvas canvas, ui.Image img, double scale, double y, double xShift) {
    canvas.save();
    canvas.translate(-_pad + xShift, y);
    canvas.scale(scale);
    canvas.drawImage(img, ui.Offset.zero, _bgPaint);
    canvas.restore();
  }
}
