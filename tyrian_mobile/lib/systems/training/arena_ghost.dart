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
  ArenaGhost(this.sigils, {this.rest = 1.4, this.mirrorEvery = 2});

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

  int _next = 0;
  int _drawn = 0;
  List<StickSample> _trace = const [];
  SigilLayer _layer = SigilLayer.hull;
  double _t = 0;
  double _wait = 0.8;

  /// The sigil being drawn now, for a caption.
  SigilSpec? current;

  /// This frame of the ghost's pad, screen space like a real one.
  PadFrame frame(double dt) {
    if (_wait > 0) {
      _wait -= dt;
      if (_wait <= 0) _start();
      return const PadFrame(fire: true);
    }
    _t += dt;
    if (_trace.isEmpty || _t > _trace.last.$1) {
      _wait = rest;
      current = null;
      return const PadFrame(fire: true);
    }
    var x = 0.0, y = 0.0;
    for (final s in _trace) {
      if (s.$1 >= _t) {
        x = s.$2;
        y = s.$3;
        break;
      }
    }
    final (sx, sy) = platform.gameToScreen(x, y);
    return PadFrame(
      drawX: sx,
      drawY: sy,
      fire: true,
      arms: _layer == SigilLayer.arms,
      wing: _layer == SigilLayer.wing,
    );
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
  }
}
