/// The duel's own lessons (Prompts/30 §9), first in the syllabus: nothing
/// else in the arena works until the stick's two roles are in the hand.
enum DuelDrillKind {
  /// Aim the right stick at the boss and hit it.
  aim,

  /// Hold a stance and fly: the nose stays put.
  hold,

  /// In the stance, draw a sigil toward the boss.
  draw,

  /// The boss is below: turn the nose round and hit it.
  turn,
}

/// One duel drill's count. Pure: the arena feeds it what happened.
class DuelDrill {
  DuelDrill(this.kind);

  final DuelDrillKind kind;
  int _count = 0;
  double _held = 0;

  int get needed => switch (kind) {
        DuelDrillKind.aim => 30,
        DuelDrillKind.hold => 4,
        DuelDrillKind.draw => 3,
        DuelDrillKind.turn => 20,
      };

  /// Hits, casts, or whole seconds held.
  int get progress =>
      kind == DuelDrillKind.hold ? _held.floor() : _count;

  bool get done => progress >= needed;

  /// A shot or a beam tick of the player's landed on the boss. [aiming]: the
  /// stick is aiming now; [noseDown]: the nose points down the screen.
  void onBossHit({required bool aiming, required bool noseDown}) {
    if (done) return;
    if (kind == DuelDrillKind.aim && aiming) _count++;
    if (kind == DuelDrillKind.turn && noseDown) _count++;
  }

  /// One frame: a stance is held, the ship is moving.
  void tick(double dt, {required bool stance, required bool moving}) {
    if (done) return;
    if (kind == DuelDrillKind.hold && stance && moving) _held += dt;
  }

  /// A sigil was cast; [towardBoss]: the nose had the boss ahead.
  void onCast({required bool towardBoss}) {
    if (done) return;
    if (kind == DuelDrillKind.draw && towardBoss) _count++;
  }
}
