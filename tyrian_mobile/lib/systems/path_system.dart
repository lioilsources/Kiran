import 'dart:math';
import 'package:flutter/foundation.dart';
import '../game/game_config.dart' as config;

/// Path types from VBA PathType enum
enum PathType { linear, cosinus, sinCos, sinus }

/// What happens when a path ends (VBA PathAction enum)
enum PathAction { destroy, freezeFleet, noop, replacePath, stay }

/// A single node in the path linked list.
/// Ported from Position.cls — but stored in a List for Dart.
class PathNode {
  final double x;
  final double y;
  const PathNode(this.x, this.y);
}

/// Ported from Path.cls — generates movement trajectories.
class PathSystem {
  final List<PathNode> nodes = [];
  int currentIndex = 0;
  PathAction onExit = PathAction.destroy;
  bool cycled = false;

  PathNode? get current =>
      nodes.isNotEmpty && currentIndex < nodes.length
          ? nodes[currentIndex]
          : null;

  bool get isComplete => currentIndex >= nodes.length;

  /// Fractional progress from [current] toward the next node, 0..1. Non-zero
  /// only when advancing by fractional steps, i.e. whenever the refresh rate
  /// differs from the 40fps the node spacing was authored for.
  double _frac = 0.0;

  /// Position along the path including the fractional remainder.
  ///
  /// Node spacing encodes 40fps, so a 120Hz frame covers a third of a node.
  /// Snapping to whole nodes would make motion visibly step at 40Hz; lerping
  /// between them keeps it smooth at any refresh rate.
  PathNode? get interpolated {
    final a = current;
    if (a == null) return null;
    if (_frac <= 0) return a;
    final nextIndex = currentIndex + 1;
    final PathNode b;
    if (nextIndex < nodes.length) {
      b = nodes[nextIndex];
    } else if (cycled && nodes.isNotEmpty) {
      b = nodes[0];
    } else {
      return a;
    }
    return PathNode(a.x + (b.x - a.x) * _frac, a.y + (b.y - a.y) * _frac);
  }

  /// Stop dead: the path completes where it stands and never resumes.
  /// Used by freezeFleet so a formation freezes strung out along its line
  /// instead of collapsing onto the shared final node.
  void halt() {
    currentIndex = nodes.length;
    _frac = 0.0;
    cycled = false;
    onExit = PathAction.stay;
  }

  /// Advance to next node. Returns true if still has nodes.
  bool advance() => advanceBy(1.0);

  /// Advance along the path by [steps] node-steps, fractions allowed.
  ///
  /// Callers pass `dt * config.originalFps` so travel takes the wall-clock time
  /// the script intended, rather than one node per rendered frame — which made
  /// every enemy 1.5x faster at 60Hz and 3x at 120Hz while the player's
  /// weapons, timed in seconds, stayed put.
  ///
  /// Returns false once a non-cycled path has run out.
  bool advanceBy(double steps) {
    if (nodes.isEmpty) return false;
    if (steps <= 0) return !isComplete;

    _frac += steps;
    final whole = _frac.floor();
    _frac -= whole;
    if (whole == 0) return !isComplete;

    currentIndex += whole;
    if (currentIndex >= nodes.length) {
      if (cycled) {
        // Wrap, preserving overshoot so a slow frame does not lose distance.
        currentIndex %= nodes.length;
        return true;
      }
      _frac = 0.0;
      return false;
    }
    return true;
  }

  /// Port of Path.Generate (Path.cls)
  /// Generates path nodes from (sx,sy) to (dx,dy) with given type.
  void generate(
    int steps,
    double sx,
    double sy,
    double dx,
    double dy,
    PathType type, {
    double amplitude = 100,
    int cycles = 4,
    double amplMultiplier = 1.0,
  }) {
    if (steps <= 0) return;
    // Debug only: every fleet generates one of these at sector build time, and
    // slicing sectors into parts rebuilds the parent each time.
    if (kDebugMode) {
      debugPrint('[PATH] generate ${type.name} steps=$steps '
          'from=(${sx.toStringAsFixed(0)}, ${sy.toStringAsFixed(0)}) '
          'to=(${dx.toStringAsFixed(0)}, ${dy.toStringAsFixed(0)}) '
          'ampl=$amplitude cycles=$cycles amplMul=$amplMultiplier');
    }

    final length = sqrt((dx - sx) * (dx - sx) + (dy - sy) * (dy - sy));
    final angStep =
        length > 0 ? (2 * config.pi * cycles) / length : 0.0;

    // Axis direction components
    final ax = (dx - sx) / steps;
    final ay = (dy - sy) / steps;

    // Direction vector normalized (VB6 Path.cls lines 55-56)
    double xs = 0, ys = 0;
    if (length > 0) {
      xs = (dx - sx) / length;
      ys = (dy - sy) / length;
    }

    double cx = sx;
    double cy = sy;
    double ang = 0;
    double ampl = amplitude;

    for (int i = 0; i <= steps; i++) {
      double px, py;
      switch (type) {
        case PathType.linear:
          px = cx;
          py = cy;
        case PathType.cosinus:
          px = cx + sin(ang) * ampl * ys;
          py = cy;
        case PathType.sinus:
          px = cx;
          py = cy + sin(ang) * ampl * xs;
        case PathType.sinCos:
          px = cx + sin(ang) * ampl * ys;
          py = cy + cos(ang) * ampl * xs;
      }

      nodes.add(PathNode(px, py));

      cx += ax;
      cy += ay;
      ang += angStep;
      ampl *= amplMultiplier;
    }
  }

  /// Jump to the last node (VB6 Path.Finish)
  void finish() {
    if (nodes.isNotEmpty) {
      currentIndex = nodes.length - 1;
    }
  }

  /// Append another path's nodes (onExit from appended path overrides)
  void addPath(PathSystem other) {
    nodes.addAll(other.nodes);
    onExit = other.onExit;
  }

  /// Make path cyclic (last -> first)
  void encycle() {
    cycled = true;
  }

  /// Clone: new PathSystem sharing the same node data, starting at 0
  PathSystem clone() {
    final p = PathSystem();
    p.nodes.addAll(nodes);
    p.onExit = onExit;
    p.cycled = cycled;
    return p;
  }

  /// Generate a cycle path (out and back) and loop it
  static PathSystem createCyclePath(
    int steps,
    double x,
    double y,
    double dx,
    double dy,
    PathType type, {
    double amplitude = 100,
    int cycles = 4,
    double amplMultiplier = 1.0,
  }) {
    final path = PathSystem();
    path.generate(steps, x, y, x + dx, y + dy, type,
        amplitude: amplitude,
        cycles: cycles,
        amplMultiplier: amplMultiplier);
    final returnPath = PathSystem();
    returnPath.generate(steps, x + dx, y + dy, x, y, type,
        amplitude: amplitude,
        cycles: cycles,
        amplMultiplier: amplMultiplier);
    path.addPath(returnPath);
    path.encycle();
    return path;
  }
}
