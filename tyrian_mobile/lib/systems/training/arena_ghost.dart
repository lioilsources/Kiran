import '../../entities/ship_frame.dart';
import '../../game/platform_config.dart' as platform;
import '../../input/pad_scheme.dart';
import '../sigils/sigil_catalog.dart';
import '../sigils/sigil_grid.dart';
import '../sigils/sigil_spec.dart';
import '../sigils/stick_trace.dart';

/// A pad that plays itself: it draws sigils the way a thumb would, holding
/// the right shoulder for each layer. The arena's demonstration ("watch",
/// Prompts/29 §4.1) and the capture mode for the tutorial videos both run
/// on it; with `--dart-define=SIGIL_DEMO=true` it flies the arena.
class ArenaGhost {
  ArenaGhost(this.sigils,
      {this.rest = 1.4, this.mirrorEvery = 2, this.once = false, double lead = 0.8})
      : _wait = lead;

  /// Every sigil in teaching order, flicks drawn forward.
  factory ArenaGhost.catalogue() => ArenaGhost([
        for (final s in [...SigilCatalog.all]
          ..sort((a, b) => a.tier.compareTo(b.tier)))
          s,
      ]);

  final List<SigilSpec> sigils;

  /// Seconds at rest between two sigils.
  final double rest;

  /// Every n-th drawing is mirrored, to show both sides.
  final int mirrorEvery;

  /// Draw one sigil and then rest for good (a filmed take).
  final bool once;

  int _next = 0;
  int _drawn = 0;
  List<StickSample> _trace = const [];
  SigilLayer _layer = SigilLayer.hull;
  double _t = 0;
  double _wait;

  /// The sigil being drawn now, for a caption.
  SigilSpec? current;

  /// One demonstration has been drawn to the end.
  void Function()? onDrawn;

  // ── In a duel (Prompts/30 §9) ──

  /// Set while the arena duels: between sigils the ghost aims at the boss,
  /// and it holds the stance's modifier while it draws.
  bool duel = false;

  /// Unit screen direction to aim at, or null to hold the nose.
  (double, double)? Function()? aimAt;

  /// The frame the game reads the stroke in, once the stance is open.
  ShipFrame Function()? strokeFrame;

  DuelBinding binding = DuelBinding.rtStance;

  /// Stick at rest with the modifier held, before the stroke: the stance
  /// opens with the stick in the centre.
  static const double _settle = 0.12;
  ShipFrame? _strokeFrame;
  bool _release = false;

  PadFrame _rest() {
    if (!duel) return const PadFrame(fire: true);
    if (_release) {
      // One frame in the centre, so the stick may aim again.
      _release = false;
      return const PadFrame();
    }
    final a = aimAt?.call();
    if (a == null) return const PadFrame();
    return PadFrame(drawX: a.$1 * 0.95, drawY: a.$2 * 0.95);
  }

  /// The stance's modifier for [layer], held.
  PadFrame _held({double drawX = 0, double drawY = 0}) {
    final hull = _layer == SigilLayer.hull;
    return PadFrame(
      drawX: drawX,
      drawY: drawY,
      fire: !duel || (hull && binding == DuelBinding.rtStance),
      fireRate: 1,
      stream: duel && hull && binding == DuelBinding.ltStance ? 0.2 : 0,
      arms: _layer == SigilLayer.arms,
      wing: _layer == SigilLayer.wing,
    );
  }

  /// This frame of the ghost's pad, screen space like a real one.
  PadFrame frame(double dt) {
    if (_wait > 0) {
      _wait -= dt;
      if (_wait <= 0) _start();
      return _rest();
    }
    _t += dt;
    if (_trace.isEmpty || _t > _trace.last.$1 + (duel ? _settle : 0)) {
      _wait = once ? double.infinity : rest;
      if (current != null) onDrawn?.call();
      current = null;
      _release = duel;
      return _rest();
    }
    final t = duel ? _t - _settle : _t;
    if (t < 0) return _held();
    var x = 0.0, y = 0.0;
    for (final s in _trace) {
      if (s.$1 >= t) {
        x = s.$2;
        y = s.$3;
        break;
      }
    }
    var (wx, wy) = (x, y);
    if (duel) {
      final f = _strokeFrame ??= strokeFrame?.call() ?? ShipFrame.flight;
      (wx, wy) = f.toWorld(x, y);
    }
    final (sx, sy) = platform.gameToScreen(wx, wy);
    return _held(drawX: sx, drawY: sy);
  }

  void _start() {
    if (sigils.isEmpty) return;
    final s = sigils[_next % sigils.length];
    _next++;
    _drawn++;
    current = s;
    _layer = s.layer;
    var dots = s.shape ?? const [1];
    if (s.mirrorable && mirrorEvery > 0 && _drawn % mirrorEvery == 0) {
      dots = SigilGrid.mirrorShape(dots);
    }
    _trace = StickTrace(arcStep: 0.045, stroke: 0.07).draw(dots, hold: 0.2);
    _t = 0;
    _strokeFrame = null;
  }
}
