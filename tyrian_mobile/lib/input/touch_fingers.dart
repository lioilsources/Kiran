/// Which finger does what on a touch screen (plan 32 Q3). Pure bookkeeping
/// over pointer ids, no Flame, so the sequences can be tested.
///
/// The first finger down is the **primary**: it moves the ship and holds the
/// fire, as one finger always has. Every further finger placed while the
/// primary is held is a **swap** finger: it fires the weapon swap once, when
/// it lands, and nothing else — it must not toggle fire, move the ship, or
/// stop the fire when it lifts. When the primary lifts there is no primary
/// until a new finger lands; a swap finger still down does not take over.
///
/// Flame reports a finger as a tap first (tap down at once), and as a drag
/// once it moves; the tap is cancelled just before the drag starts. A
/// cancelled tap therefore only marks the finger for release, and [flush]
/// (once a frame) drops it unless its drag picked it up in the meantime.
class TouchFingers {
  int? _primary;
  final Set<int> _swap = {};
  final Set<int> _pendingRelease = {};

  /// A finger was reported down — by its tap down or its drag start, which
  /// may both arrive for the same finger. [TouchDown.landed] is true only
  /// the first time.
  TouchDown down(int id) {
    _pendingRelease.remove(id);
    if (id == _primary) return const TouchDown(primary: true, landed: false);
    if (_swap.contains(id)) {
      return const TouchDown(primary: false, landed: false);
    }
    if (_primary == null) {
      _primary = id;
      return const TouchDown(primary: true, landed: true);
    }
    _swap.add(id);
    return const TouchDown(primary: false, landed: true);
  }

  bool isPrimary(int id) => id == _primary;

  /// Whether a primary finger is down.
  bool get hasPrimary => _primary != null;

  /// The finger lifted (tap up, drag end or drag cancel).
  void up(int id) {
    if (id == _primary) _primary = null;
    _swap.remove(id);
    _pendingRelease.remove(id);
  }

  /// The finger's tap was cancelled: either its drag is about to start, or
  /// the finger is gone. [flush] tells the two apart.
  void tapCancelled(int id) {
    if (id == _primary || _swap.contains(id)) _pendingRelease.add(id);
  }

  /// Release fingers whose tap was cancelled and whose drag never started.
  void flush() {
    if (_pendingRelease.isEmpty) return;
    for (final id in _pendingRelease.toList()) {
      up(id);
    }
  }
}

class TouchDown {
  /// The primary finger (moves and fires) rather than a swap finger.
  final bool primary;

  /// This is the finger landing, not a second report of the same finger.
  final bool landed;

  const TouchDown({required this.primary, required this.landed});
}
