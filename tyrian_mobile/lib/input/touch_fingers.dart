/// Which fingers are on the screen (plan 34). Pure bookkeeping over the ids
/// Flame reports, no Flame, so the sequences can be tested.
///
/// Flame reports a finger first as a tap and, once it moves past the touch
/// slop, as a drag: the tap is cancelled and the drag starts within the same
/// pointer event. The two ids come from unrelated counters — a tap carries
/// Flutter's pointer number, a drag Flame's own drag counter — so one finger
/// has two ids, and a tap's id may equal another finger's drag id. The taps
/// and the drags are therefore kept apart and never compared.
///
/// A finger on the screen is in exactly one of the two: still resting (a
/// tap) or moving (a drag). Their sum is the number of fingers. Read it once
/// a frame, not inside an event, where a tap may be gone and its drag not
/// yet begun.
class TouchFingers {
  final Set<int> _taps = {};
  final List<int> _drags = [];

  /// A finger landed (tap down).
  void tapDown(int id) => _taps.add(id);

  /// A resting finger lifted, or its tap was cancelled — by its own drag
  /// starting, or by the system.
  void tapUp(int id) => _taps.remove(id);

  /// A finger began to move (drag start).
  void dragStart(int id) {
    if (!_drags.contains(id)) _drags.add(id);
  }

  /// A moving finger lifted, or the system cancelled its drag.
  void dragEnd(int id) => _drags.remove(id);

  /// Fingers on the screen, resting or moving.
  int get count => _taps.length + _drags.length;

  /// Whether any finger is moving.
  bool get dragging => _drags.isNotEmpty;

  /// The finger that steers: the oldest drag still going. Null while no
  /// finger moves — a resting finger steers nothing.
  int? get steering => _drags.isEmpty ? null : _drags.first;

  /// Forget every finger: a guard against one whose end never came.
  void clear() {
    _taps.clear();
    _drags.clear();
  }
}
