/// The data model of a sigil (Prompts/28 §5.4). Pure Dart: no Flame, no
/// Flutter, so the catalogue, the recogniser and the run maths are testable
/// without a game.
library;

/// Which hand modifier was held when the stick left the centre.
enum SigilLayer {
  /// Nothing held: the hull moves.
  hull,

  /// LB held: the guns and the timed effects.
  arms,

  /// RB held: the companions.
  wing,
}

/// Every sigil there is. The caster switches on this; ids are the names.
enum SigilKind {
  // HULL
  hop,
  sidestep,
  strike,
  retreat,
  dash,
  roll,
  shadow,
  echo,
  loop,
  slalom,
  corkscrew,
  // ARMS
  snapshot,
  broadside,
  volley,
  caltrop,
  frenzy,
  stasis,
  halo,
  radial,
  storm,
  // WING
  ping,
  wingman,
  hunter,
  warden,
  formation,
  whirl,
  sacrifice,
}

/// How much of the left stick a running sigil leaves to the player.
enum SigilControl {
  /// The path flies the ship.
  none,

  /// The player steers as usual.
  full,

  /// SHADOW: the target sets x, the player still sets the height.
  verticalOnly,
}

/// One key of a hull path, relative to where the sigil began. x is ship
/// right, y is ship backward (game down), both px; a mirrored run negates x.
class SigilKey {
  final double t;
  final double dx;
  final double dy;

  /// Drawn size; LOOP climbs toward the camera.
  final double scale;

  /// Drawn roll in turns (1 = a full barrel roll).
  final double roll;

  const SigilKey(this.t, this.dx, this.dy, {this.scale = 1, this.roll = 0});
}

/// Where a fire cue's shots go.
enum CueAim {
  /// Straight ahead, fanned by [FireCue.spread].
  forward,

  /// Both flanks, fanned around ±90°.
  sides,

  /// A full ring.
  radial,

  /// The direction the stick was flicked.
  flick,
}

/// Shots a sigil fires at a moment of its run, through the front gun's plan.
class FireCue {
  /// Progress 0..1 at which it fires.
  final double t;
  final int shots;

  /// Total fan width, degrees.
  final double spread;
  final double damageMul;
  final CueAim aim;

  const FireCue(this.t,
      {this.shots = 1,
      this.spread = 0,
      this.damageMul = 1,
      this.aim = CueAim.forward});
}

class SigilSpec {
  final SigilKind kind;
  final SigilLayer layer;

  /// Dots of the grid, centre stripped. Null for a flick: any single rim
  /// dot, its direction the sigil's direction.
  final List<int>? shape;

  /// A left↔right mirrored drawing is the same sigil, mirrored.
  final bool mirrorable;

  /// How long it runs, ms. Zero for instant sigils.
  final int durationMs;
  final int cost;

  /// Unlock order, and the order the curriculum teaches (Prompts/29).
  final int tier;

  /// Untouchable window as fractions of the run, or null.
  final (double, double)? phase;
  final SigilControl control;
  final List<SigilKey> path;
  final List<FireCue> fire;

  const SigilSpec({
    required this.kind,
    required this.layer,
    required this.shape,
    this.mirrorable = false,
    this.durationMs = 0,
    required this.cost,
    required this.tier,
    this.phase,
    this.control = SigilControl.full,
    this.path = const [],
    this.fire = const [],
  });

  String get id => kind.name;

  /// The proper noun shown everywhere; never translated.
  String get name => kind.name.toUpperCase();

  bool get isFlick => shape == null;
  double get duration => durationMs / 1000.0;
}
