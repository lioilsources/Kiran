import 'dart:math' as math;

import '../../game/game_config.dart' as config;
import 'sigil_accuracy.dart';
import 'sigil_catalog.dart';
import 'sigil_grid.dart';
import 'sigil_spec.dart';

/// Why a drawing did not cast (Prompts/29 §3), for the arena's replay.
enum SigilMiss {
  /// No sigil looks like it.
  unknown,

  /// Took longer than [config.sigilMaxTime].
  tooSlow,

  /// The shape of a known sigil with one dot missing.
  skippedDot,

  /// The start of a known sigil; the stick came home too early.
  leftRimEarly,

  /// A known sigil drawn backwards.
  wrongDirection,

  /// A sigil of another layer: the wrong shoulder (or none) was held.
  wrongLayer,
}

class SigilDiagnosis {
  final SigilMiss reason;

  /// The sigil the drawing came closest to, if any.
  final SigilSpec? nearest;

  /// Index of the first dot that differs from [nearest]'s shape.
  final int? firstMismatchAt;

  const SigilDiagnosis(this.reason, {this.nearest, this.firstMismatchAt});
}

/// What one gesture came to.
class SigilReading {
  /// Null when the drawing did not cast; see [miss].
  final SigilSpec? spec;
  final bool mirrored;

  /// The flicked rim dot, for flick sigils.
  final int? flickDot;
  final List<int> drawn;
  final SigilLayer layer;

  /// Seconds from the stick leaving the centre to the recognition.
  final double drawTime;
  final SigilDiagnosis? miss;

  /// Every stick sample of the gesture, ship space — what was actually drawn.
  final List<(double, double)> trail;

  /// The dots of the line the stroke is judged against: the sigil as cast
  /// (mirrored, circles from where they began), or for a miss the nearest
  /// sigil. Empty when there is nothing to compare with.
  final List<int> ideal;

  /// 0..1, how closely [trail] followed [ideal] (see [SigilAccuracy]).
  final double accuracy;

  /// Typed on the keyboard: there is no stroke to judge.
  final bool keyed;

  const SigilReading({
    required this.spec,
    required this.drawn,
    required this.layer,
    required this.drawTime,
    this.mirrored = false,
    this.flickDot,
    this.miss,
    this.trail = const [],
    this.ideal = const [],
    this.accuracy = 0,
    this.keyed = false,
  });

  bool get cast => spec != null;
}

/// Turns a stream of right-stick samples into sigils (Prompts/28 §4).
///
/// A gesture starts when the stick leaves the centre and ends when it rests
/// in the centre for [config.sigilNeutralDwell] — the lift of the finger on
/// a touch lock screen. Dots are picked up on the rim as the stick sweeps its
/// sectors; a quick pass through the centre picks up dot 4. A drawing that no
/// longer sigil can extend casts at once, without waiting for the rest.
///
/// Samples are in ship space (x right, y backward), magnitude 0..1. Feed one
/// per frame with that frame's dt.
class SigilRecognizer {
  SigilRecognizer([Iterable<SigilSpec>? specs]) {
    setSpecs(specs ?? SigilCatalog.all);
  }

  final Map<SigilLayer, Map<String, SigilSpec>> _shapes = {};
  final Map<SigilLayer, SigilSpec> _flicks = {};
  final Map<SigilLayer, int> _circleTurns = {};
  final List<SigilSpec> _all = [];

  /// The sigils this recogniser knows — the unlocked ones.
  void setSpecs(Iterable<SigilSpec> specs) {
    _shapes.clear();
    _flicks.clear();
    _circleTurns.clear();
    _all
      ..clear()
      ..addAll(specs);
    for (final s in _all) {
      final shape = s.shape;
      if (shape == null) {
        _flicks[s.layer] = s;
        continue;
      }
      _shapes.putIfAbsent(s.layer, () => {})[_key(shape)] = s;
      final turns = _circleTurnsOf(shape);
      if (turns > (_circleTurns[s.layer] ?? 0)) _circleTurns[s.layer] = turns;
    }
  }

  // ── Live state, read by the HUD ──

  double stickX = 0, stickY = 0;

  /// True from the stick leaving the centre to the gesture's end.
  bool get drawing => _drawing;

  /// Dots picked up so far in this gesture.
  List<int> get drawn => List.unmodifiable(_dots);

  /// The stroke so far, ship space.
  List<(double, double)> get trail => List.unmodifiable(_trail);

  /// The rim dot under the stick, or 4 at rest, or null in between.
  int? get hotDot => _onRim ? SigilGrid.ring[_sector] : (_inCenter ? 4 : null);

  SigilLayer get layer => _layer;

  // ── Internal state ──

  bool _inCenter = true;
  bool _onRim = false;
  int _sector = 0;
  bool _drawing = false;

  /// After a cast or a miss: nothing starts until the stick is home.
  bool _spent = false;
  double _lock = 0;
  final List<int> _dots = [];
  final List<(double, double)> _trail = [];
  final Map<int, double> _rimTime = {};
  double _elapsed = 0;
  double _dwell = 0;
  SigilLayer _layer = SigilLayer.hull;

  /// Rim dot the stick last left for the inside, for a chord across it.
  int? _leftRimAt;

  void reset() {
    _inCenter = true;
    _onRim = false;
    _drawing = false;
    _spent = false;
    _lock = 0;
    _dots.clear();
    _trail.clear();
    _rimTime.clear();
    _elapsed = 0;
    _dwell = 0;
    _leftRimAt = null;
    stickX = stickY = 0;
  }

  /// One sample. [layer] is what the shoulders say right now; only its value
  /// as the stick leaves the centre counts.
  SigilReading? feed(double x, double y, double dt, SigilLayer layer) {
    stickX = x;
    stickY = y;
    final mag = math.sqrt(x * x + y * y);
    if (_lock > 0) _lock -= dt;

    // Zones, with hysteresis.
    final wasCenter = _inCenter;
    _inCenter = _inCenter
        ? mag < config.sigilCenterLeave
        : mag < config.sigilCenterEnter;
    final wasRim = _onRim;
    _onRim = _onRim ? mag > config.sigilRimLeave : mag > config.sigilRimEnter;
    if (_onRim) _updateSector(x, y, fresh: !wasRim);

    if (_spent) {
      if (_inCenter) _spent = false;
      return null;
    }

    if (!_drawing) {
      if (_inCenter || _lock > 0) return null;
      _begin(layer);
    }

    _elapsed += dt;
    _trail.add((x, y));

    if (_inCenter) {
      _dwell += dt;
      if (_dwell >= config.sigilNeutralDwell) return _finish();
      return null;
    }

    // Left the centre again before the dwell ran out: dot 4 on the way.
    if (wasCenter && _dots.isNotEmpty) _add(4);
    _dwell = 0;

    if (_onRim) {
      final dot = SigilGrid.ring[_sector];
      _rimTime[dot] = (_rimTime[dot] ?? 0) + dt;
      if (!wasRim) {
        _enterRim(dot);
      } else if (_dots.isEmpty || _dots.last != dot) {
        _sweep(dot);
      }
      final early = _earlyCast();
      if (early != null) return early;
    } else if (wasRim && !_inCenter) {
      _leftRimAt = _dots.isNotEmpty ? _dots.last : null;
    }

    final limit = _isArc(_dots) && _dots.length >= 5
        ? config.sigilMaxTimeLong
        : config.sigilMaxTime;
    if (_elapsed > limit) {
      return _miss(const SigilDiagnosis(SigilMiss.tooSlow));
    }
    return null;
  }

  void _begin(SigilLayer layer) {
    _drawing = true;
    _layer = layer;
    _dots.clear();
    _trail.clear();
    _rimTime.clear();
    _elapsed = 0;
    _dwell = 0;
    _leftRimAt = null;
  }

  void _updateSector(double x, double y, {required bool fresh}) {
    final raw = SigilGrid.sectorFor(x, y);
    if (fresh || raw == _sector) {
      _sector = raw;
      return;
    }
    // Stay in the current sector until the stick is clearly past its border.
    var a = math.atan2(x, -y);
    if (a < 0) a += 2 * math.pi;
    var d = (a - SigilGrid.sectorAngle(_sector)).abs() % (2 * math.pi);
    if (d > math.pi) d = 2 * math.pi - d;
    if (d > math.pi / 8 + config.sigilSectorHysteresis) _sector = raw;
  }

  /// Back on the rim after the inside: a chord from where it left.
  void _enterRim(int dot) {
    final from = _leftRimAt;
    _leftRimAt = null;
    if (from != null && _dots.isNotEmpty && _dots.last == from && from != dot) {
      final ia = SigilGrid.ring.indexOf(from), ib = SigilGrid.ring.indexOf(dot);
      final span = math.min((ia - ib).abs(), 8 - (ia - ib).abs());
      if (span >= 3) {
        // Across, or nearly: a straight line between them crosses the centre.
        _add(4);
      } else {
        // A corner cut short: the arc it meant.
        for (final g in SigilGrid.ringGap(from, dot)) {
          _add(g);
        }
      }
    }
    _add(dot);
  }

  /// Along the rim: fill a sector the stick jumped over between samples.
  void _sweep(int dot) {
    final last = _dots.isEmpty ? null : _dots.last;
    if (last != null && last != 4) {
      for (final g in SigilGrid.ringGap(last, dot)) {
        _add(g);
      }
    }
    _add(dot);
  }

  void _add(int dot) {
    if (_dots.isNotEmpty && _dots.last == dot) return;
    _dots.add(dot);
  }

  /// Cast now when the drawing is a sigil nothing longer starts with.
  SigilReading? _earlyCast() {
    final hit = _match(_dots, _layer);
    if (hit == null || hit.$1.isFlick) return null;
    if (_couldGrow(_dots, _layer)) return null;
    return _cast(hit.$1, hit.$2);
  }

  SigilReading? _finish() {
    if (_dots.isEmpty) {
      // A wobble that never reached the rim: nothing was drawn.
      _drawing = false;
      return null;
    }
    final hit = _resolve(_dots, _layer);
    if (hit != null) return _cast(hit.$1, hit.$2, flickDot: hit.$3);
    return _miss(diagnose(_dots, _layer));
  }

  SigilReading _cast(SigilSpec spec, bool mirrored, {int? flickDot}) {
    final ideal = idealFor(spec, mirrored: mirrored, flickDot: flickDot, drawn: _dots);
    final trail = List.of(_trail);
    final r = SigilReading(
      spec: spec,
      mirrored: mirrored,
      flickDot: flickDot,
      drawn: List.of(_dots),
      layer: _layer,
      drawTime: _elapsed,
      trail: trail,
      ideal: ideal,
      accuracy: SigilAccuracy.score(trail, ideal),
    );
    _end();
    return r;
  }

  SigilReading _miss(SigilDiagnosis why) {
    final near = why.nearest;
    final ideal = near == null || near.isFlick
        ? const <int>[]
        : idealFor(near, mirrored: _mirroredCloser(near, _dots), drawn: _dots);
    final trail = List.of(_trail);
    final r = SigilReading(
      spec: null,
      drawn: List.of(_dots),
      layer: _layer,
      drawTime: _elapsed,
      miss: why,
      trail: trail,
      ideal: ideal,
      accuracy: ideal.isEmpty ? 0 : SigilAccuracy.score(trail, ideal),
    );
    _end();
    _lock = config.sigilFizzleLock;
    return r;
  }

  void _end() {
    _drawing = false;
    _spent = !_inCenter;
    _dots.clear();
    _trail.clear();
    _rimTime.clear();
  }

  /// The line [spec] should have been drawn along, oriented like [drawn]:
  /// mirrored if it was, a circle from where it began and the way it went.
  static List<int> idealFor(SigilSpec spec,
      {bool mirrored = false, int? flickDot, List<int> drawn = const []}) {
    final shape = spec.shape;
    if (shape == null) return [flickDot ?? 1];
    final circle = _circleTurnsOf(shape) > 0;
    if (circle && drawn.isNotEmpty && drawn.first != 4) {
      final dir = mirrored ? -1 : 1;
      final start = SigilGrid.ring.indexOf(drawn.first);
      return [
        for (var i = 0; i < shape.length; i++)
          SigilGrid.ring[((start + dir * i) % 8 + 8) % 8],
      ];
    }
    return mirrored ? SigilGrid.mirrorShape(shape) : List.of(shape);
  }

  /// Whether [drawn] looks more like the mirror image of [spec].
  static bool _mirroredCloser(SigilSpec spec, List<int> drawn) {
    final shape = spec.shape;
    if (shape == null || !spec.mirrorable) return false;
    return _editDistance(drawn, SigilGrid.mirrorShape(shape)) <
        _editDistance(drawn, shape);
  }

  /// A drawing that came as dots, not as a stick — the keyboard's. The same
  /// matching as a stroke, with no trail and so no precision.
  SigilReading resolveDots(List<int> dots, SigilLayer layer, {double time = 0}) {
    _rimTime.clear();
    final hit = _resolve(dots, layer);
    if (hit != null) {
      return SigilReading(
        spec: hit.$1,
        mirrored: hit.$2,
        flickDot: hit.$3,
        drawn: List.of(dots),
        layer: layer,
        drawTime: time,
        ideal: idealFor(hit.$1, mirrored: hit.$2, flickDot: hit.$3, drawn: dots),
        keyed: true,
      );
    }
    final why = diagnose(dots, layer);
    final near = why.nearest;
    return SigilReading(
      spec: null,
      drawn: List.of(dots),
      layer: layer,
      drawTime: time,
      miss: why,
      ideal: near == null || near.isFlick
          ? const []
          : idealFor(near, mirrored: _mirroredCloser(near, dots), drawn: dots),
      keyed: true,
    );
  }

  // ── Matching ──

  /// The sigil a finished drawing is, with the leniencies of §4.3: a circle
  /// begun anywhere, a two-dot flick, one dot of overshoot.
  (SigilSpec, bool, int?)? _resolve(List<int> dots, SigilLayer layer) {
    if (dots.length <= 2 && dots.every((d) => d != 4)) {
      final flick = _flicks[layer];
      if (flick != null) {
        if (dots.length == 1) return (flick, false, dots.first);
        if (SigilGrid.adjacentOnRing(dots[0], dots[1])) {
          final a = _rimTime[dots[0]] ?? 0, b = _rimTime[dots[1]] ?? 0;
          return (flick, false, a > b ? dots[0] : dots[1]);
        }
      }
    }
    final m = _match(dots, layer);
    if (m != null) return (m.$1, m.$2, null);
    if (dots.length >= 4) {
      final trimmed = dots.sublist(0, dots.length - 1);
      final last = dots.last, prev = trimmed.last;
      if (last != 4 && prev != 4 && SigilGrid.adjacentOnRing(prev, last)) {
        final t = _match(trimmed, layer);
        if (t != null) return (t.$1, t.$2, null);
      }
    }
    return null;
  }

  /// Exact match of [dots] in [layer]: as drawn, mirrored, or as a circle.
  (SigilSpec, bool)? _match(List<int> dots, SigilLayer layer) {
    final table = _shapes[layer];
    if (table == null || dots.isEmpty) return null;
    if (_isArc(dots) && dots.length >= 7) {
      final maxTurns = _circleTurns[layer] ?? 0;
      if (maxTurns == 0) return null;
      final turns = ((dots.length + 1) ~/ 8).clamp(1, maxTurns);
      final canon = [for (var i = 0; i < turns; i++) ...SigilGrid.ring];
      final s = table[_key(canon)] ??
          (turns > 1 ? table[_key(SigilGrid.ring)] : null);
      if (s == null) return null;
      final ccw = SigilGrid.circleDirection(dots) < 0;
      if (ccw && !s.mirrorable) return null;
      return (s, ccw);
    }
    final direct = table[_key(dots)];
    if (direct != null) return (direct, false);
    final mirrored = table[_key(SigilGrid.mirrorShape(dots))];
    if (mirrored != null && mirrored.mirrorable) return (mirrored, true);
    return null;
  }

  /// Whether some sigil of [layer] is longer than [dots] and starts with it,
  /// so a cast now could steal a longer drawing.
  bool _couldGrow(List<int> dots, SigilLayer layer) {
    final maxTurns = _circleTurns[layer] ?? 0;
    if (maxTurns > 0 && _isArc(dots) && dots.length < 8 * maxTurns + 6) {
      return true;
    }
    for (final s in _all) {
      final shape = s.shape;
      if (s.layer != layer || shape == null) continue;
      if (shape.length <= dots.length) continue;
      if (_startsWith(shape, dots)) return true;
      if (s.mirrorable && _startsWith(SigilGrid.mirrorShape(shape), dots)) {
        return true;
      }
    }
    return false;
  }

  /// Why [dots] cast nothing in [layer].
  SigilDiagnosis diagnose(List<int> dots, SigilLayer layer) {
    for (final l in SigilLayer.values) {
      if (l == layer) continue;
      final m = _match(dots, l);
      if (m != null) {
        return SigilDiagnosis(SigilMiss.wrongLayer, nearest: m.$1);
      }
    }
    final rev = dots.reversed.toList();
    final back = _match(rev, layer);
    if (back != null && rev.length > 1) {
      return SigilDiagnosis(SigilMiss.wrongDirection,
          nearest: back.$1, firstMismatchAt: 0);
    }
    SigilSpec? best;
    var bestCost = 1 << 30;
    List<int>? bestShape;
    for (final s in _all) {
      final shape = s.shape;
      if (s.layer != layer || shape == null) continue;
      for (final variant in [
        shape,
        if (s.mirrorable) SigilGrid.mirrorShape(shape),
      ]) {
        if (variant.length > dots.length && _startsWith(variant, dots)) {
          return SigilDiagnosis(SigilMiss.leftRimEarly,
              nearest: s, firstMismatchAt: dots.length);
        }
        if (variant.length == dots.length + 1 && _oneInserted(dots, variant)) {
          return SigilDiagnosis(SigilMiss.skippedDot,
              nearest: s, firstMismatchAt: _firstDiff(dots, variant));
        }
        final c = _editDistance(dots, variant);
        if (c < bestCost) {
          bestCost = c;
          best = s;
          bestShape = variant;
        }
      }
    }
    return SigilDiagnosis(SigilMiss.unknown,
        nearest: best,
        firstMismatchAt: bestShape == null ? null : _firstDiff(dots, bestShape));
  }

  // ── Helpers ──

  static String _key(List<int> dots) => dots.join();

  static int _circleTurnsOf(List<int> shape) {
    if (shape.length % 8 != 0 || shape.isEmpty) return 0;
    for (var i = 0; i < shape.length; i += 8) {
      if (!SigilGrid.isCircle(shape.sublist(i, i + 8))) return 0;
    }
    return shape.length ~/ 8;
  }

  /// All rim dots, each next to the one before, one way round.
  static bool _isArc(List<int> dots) {
    if (dots.length < 2 || dots.contains(4)) return false;
    final dir = SigilGrid.circleDirection(dots);
    if (dir == 0) return false;
    for (var i = 1; i < dots.length; i++) {
      final a = SigilGrid.ring.indexOf(dots[i - 1]);
      final b = SigilGrid.ring.indexOf(dots[i]);
      if ((b - a + 8) % 8 != (dir > 0 ? 1 : 7)) return false;
    }
    return true;
  }

  static bool _startsWith(List<int> whole, List<int> part) {
    if (part.length > whole.length) return false;
    for (var i = 0; i < part.length; i++) {
      if (whole[i] != part[i]) return false;
    }
    return true;
  }

  static bool _oneInserted(List<int> short, List<int> long) {
    for (var skip = 0; skip < long.length; skip++) {
      var ok = true;
      for (var i = 0, j = 0; i < short.length; i++, j++) {
        if (j == skip) j++;
        if (short[i] != long[j]) {
          ok = false;
          break;
        }
      }
      if (ok) return true;
    }
    return false;
  }

  static int _firstDiff(List<int> a, List<int> b) {
    final n = math.min(a.length, b.length);
    for (var i = 0; i < n; i++) {
      if (a[i] != b[i]) return i;
    }
    return n;
  }

  static int _editDistance(List<int> a, List<int> b) {
    var prev = List<int>.generate(b.length + 1, (j) => j);
    for (var i = 1; i <= a.length; i++) {
      final cur = List<int>.filled(b.length + 1, 0)..[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final sub = prev[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1);
        cur[j] = math.min(sub, math.min(prev[j] + 1, cur[j - 1] + 1));
      }
      prev = cur;
    }
    return prev[b.length];
  }
}
