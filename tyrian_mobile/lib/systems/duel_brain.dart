import 'dart:math' as math;

/// One move of a duel boss (Prompts/30 §7.2).
enum DuelMove {
  /// Down from above the screen to its home. Every duel starts with it.
  enter,

  /// Bobs about a point.
  hover,

  /// Across the top, one side to the other: the flight's strafe, in the duel.
  sweep,

  /// A tell (tentacles twitch, a flash), then a lunge at the ship and back.
  dive,

  /// Settles at a flank and fires across.
  perch,

  /// An arc about the middle of the screen.
  orbit,

  /// Through the middle into the lower half: the ship has to turn round.
  cross,
}

/// How a duel boss shoots during its current move.
enum DuelVolley {
  /// The flight's volley for the phase: aimed, then fans — at the ship.
  phase,

  /// The fan's shots spread all round.
  ring,
}

/// Where a duel boss goes (Prompts/30 §7.2). Pure and seeded: no Flame, the
/// same moves for the same seed, so a duel replays and tests the same.
///
/// Works in duel screen pixels: x 0..[width] left to right, y 0..[height]
/// top to bottom, (x, y) the boss's centre. The boss turns them into game
/// space with `duelToGame`.
class DuelBrain {
  DuelBrain({
    required this.ordinal,
    required this.width,
    required this.height,
    this.keepOut = 140,
    this.homeV = 0.28,
    this.calm = false,
    this.bandTop,
    this.bandBottom,
    int seed = 0,
  })  : _rng = math.Random(seed),
        x = width / 2,
        y = -height * 0.3 {
    _start(DuelMove.enter, toX: width / 2, toY: height * homeV, len: 1.5);
  }

  /// Boss ordinal: 1 flies hover, sweep and dive; 2 adds perch; 3 orbit;
  /// 4 cross.
  final int ordinal;
  final double width, height;
  final double keepOut;
  final double homeV;

  /// Only hovers: the arena is teaching something.
  final bool calm;

  /// A band of the screen to keep to, 0..1 of its height, instead of the
  /// phase's.
  final double? bandTop, bandBottom;
  final math.Random _rng;

  /// The boss's centre now.
  double x, y;

  DuelMove move = DuelMove.enter;
  double _t = 0, _len = 1;
  double _fromX = 0, _fromY = 0, _toX = 0, _toY = 0;

  // Hover and perch bob about (_toX, _toY); orbit turns about the middle.
  double _arc0 = 0, _arcSpan = 0, _arcR = 0;

  /// A dive's tell: the boss shakes before it lunges.
  static const double diveTell = 0.6;
  static const double _diveLunge = 0.5;
  static const double _diveBack = 0.8;

  /// Base speed of the moves, px/s; the phase and the thruster scale it.
  static const double speed = 150;

  static const Map<DuelMove, int> minOrdinal = {
    DuelMove.hover: 1,
    DuelMove.sweep: 1,
    DuelMove.dive: 1,
    DuelMove.perch: 2,
    DuelMove.orbit: 3,
    DuelMove.cross: 4,
  };

  static const Map<DuelMove, int> minPhase = {
    DuelMove.hover: 1,
    DuelMove.sweep: 1,
    DuelMove.dive: 2,
    DuelMove.perch: 2,
    DuelMove.orbit: 3,
    DuelMove.cross: 3,
  };

  /// Moves this boss may pick in [phase].
  List<DuelMove> movesFor(int phase) => calm
      ? const [DuelMove.hover]
      : [
        for (final m in minOrdinal.keys)
          if (ordinal >= minOrdinal[m]! && phase >= minPhase[m]!) m,
      ];

  /// The lowest the boss's centre goes in [phase]: the top third, the top
  /// two thirds, then all of it.
  double floorFor(int phase) => bandBottom != null
      ? height * bandBottom!
      : switch (phase) {
          1 => height / 3,
          2 => height * 2 / 3,
          _ => height * 0.88,
        };

  bool get telling => move == DuelMove.dive && _t < diveTell;

  /// The dive's lunge is under way: the boss's body is the weapon.
  bool get lunging =>
      move == DuelMove.dive && _t >= diveTell && _t < diveTell + _diveLunge;

  DuelVolley get volley => move == DuelMove.perch || move == DuelMove.orbit
      ? DuelVolley.ring
      : DuelVolley.phase;

  /// One step. [shipX], [shipY]: the ship, duel pixels. [speedMul]: the
  /// phase and the thruster.
  void step(double dt,
      {required int phase,
      required double shipX,
      required double shipY,
      double speedMul = 1}) {
    _t += dt;
    switch (move) {
      case DuelMove.enter:
      case DuelMove.sweep:
      case DuelMove.cross:
        _glide();
      case DuelMove.hover:
      case DuelMove.perch:
        final bob = move == DuelMove.hover ? 1.0 : 0.4;
        final settle = math.min(1.0, _t / 0.6);
        x = _lerp(_fromX, _toX, _ease(settle)) + math.sin(_t * 1.3) * 34 * bob;
        y = _lerp(_fromY, _toY, _ease(settle)) + math.sin(_t * 2.1) * 16 * bob;
      case DuelMove.dive:
        if (_t < diveTell) {
          x = _fromX + math.sin(_t * 60) * 4;
          y = _fromY;
        } else if (_t < diveTell + _diveLunge) {
          final k = _ease((_t - diveTell) / _diveLunge);
          x = _lerp(_fromX, _toX, k);
          y = _lerp(_fromY, _toY, k);
        } else {
          final k = _ease(
              ((_t - diveTell - _diveLunge) / _diveBack).clamp(0.0, 1.0).toDouble());
          x = _lerp(_toX, _fromX, k);
          y = _lerp(_toY, _fromY, k);
        }
      case DuelMove.orbit:
        final k = _ease((_t / _len).clamp(0.0, 1.0).toDouble());
        final a = _arc0 + _arcSpan * k;
        final cx = width / 2 + math.cos(a) * _arcR * _aspect;
        final cy = height / 2 + math.sin(a) * _arcR;
        // Onto the circle from wherever the last move left it.
        final s = _ease(math.min(1.0, _t / 0.6));
        x = _lerp(_fromX, cx, s);
        y = _lerp(_fromY, cy, s);
    }
    if (_t >= _len) _next(phase, shipX, shipY, speedMul);
  }

  double get _aspect => (width / height).clamp(1.0, 2.0).toDouble();

  void _glide() {
    final k = _ease((_t / _len).clamp(0.0, 1.0).toDouble());
    x = _lerp(_fromX, _toX, k);
    y = _lerp(_fromY, _toY, k);
  }

  void _start(DuelMove m,
      {required double toX, required double toY, required double len}) {
    move = m;
    _t = 0;
    _len = len;
    _fromX = x;
    _fromY = y;
    _toX = toX;
    _toY = toY;
  }

  double _travel(double tx, double ty, double speedMul) {
    final d = math.sqrt((tx - x) * (tx - x) + (ty - y) * (ty - y));
    return (d / (speed * speedMul)).clamp(0.6, 4.0).toDouble();
  }

  /// A point in the phase's band, clear of the ship by [keepOut].
  (double, double) _spot(int phase, double shipX, double shipY) {
    final top = bandTop ?? 0.14;
    final floor = floorFor(phase);
    var best = (width / 2, height * homeV);
    var bestD = -1.0;
    for (var i = 0; i < 8; i++) {
      final px = width * (0.14 + 0.72 * _rng.nextDouble());
      final py = height * top + (floor - height * top) * _rng.nextDouble();
      final d = math.sqrt((px - shipX) * (px - shipX) + (py - shipY) * (py - shipY));
      if (d >= keepOut) return (px, py);
      if (d > bestD) {
        bestD = d;
        best = (px, py);
      }
    }
    return best;
  }

  void _next(int phase, double shipX, double shipY, double speedMul) {
    final moves = movesFor(phase);
    // Never the same move twice running, unless it is the only one.
    final pool = moves.length > 1 && moves.contains(move)
        ? [for (final m in moves) if (m != move) m]
        : moves;
    final m = pool[_rng.nextInt(pool.length)];
    switch (m) {
      case DuelMove.hover:
        final (px, py) = _spot(phase, shipX, shipY);
        _start(m, toX: px, toY: py, len: 2.0 + _rng.nextDouble() * 1.5);
      case DuelMove.sweep:
        final row = math.min(
            y.clamp(height * 0.14, floorFor(phase)).toDouble(), height * 0.3);
        final toX = x < width / 2 ? width * 0.84 : width * 0.16;
        _start(m, toX: toX, toY: row, len: _travel(toX, row, speedMul));
      case DuelMove.dive:
        // At where the ship is now, not through it: it stops short.
        final dx = shipX - x, dy = shipY - y;
        final d = math.sqrt(dx * dx + dy * dy);
        final reach = d <= 1 ? 0.0 : math.max(0.0, d - 40) / d;
        _start(m,
            toX: x + dx * reach,
            toY: (y + dy * reach).clamp(height * 0.1, height * 0.92).toDouble(),
            len: diveTell + _diveLunge + _diveBack);
      case DuelMove.perch:
        final left = shipX > width / 2;
        final px = left ? width * 0.1 : width * 0.9;
        final py = math.min(height * 0.45, floorFor(phase));
        _start(m, toX: px, toY: py, len: 3.0);
      case DuelMove.orbit:
        _arcR = height * 0.32;
        final sx = (x - width / 2) / _aspect;
        _arc0 = math.atan2(y - height / 2, sx);
        _arcSpan = (_rng.nextBool() ? 1 : -1) * math.pi;
        _start(m, toX: x, toY: y, len: 4.0 / speedMul);
      case DuelMove.cross:
        var px = width * (0.2 + 0.6 * _rng.nextDouble());
        final py = height * 0.74;
        if ((px - shipX).abs() < keepOut && (py - shipY).abs() < keepOut) {
          px = shipX < width / 2 ? width * 0.8 : width * 0.2;
        }
        _start(m, toX: px, toY: py, len: _travel(px, py, speedMul));
      case DuelMove.enter:
        break;
    }
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
  static double _ease(double t) => t * t * (3 - 2 * t);
}
