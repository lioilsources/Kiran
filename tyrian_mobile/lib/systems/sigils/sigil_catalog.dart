import 'sigil_grid.dart';
import 'sigil_spec.dart';

/// Every sigil, one table (Prompts/28 §5). The HUD, the grimoire, the
/// training arena, the tests and the tutorial videos all read this; a sigil
/// added here shows up in all of them.
///
/// The same shape means the same intent in every layer: through the centre
/// forward is attack, through the centre back is cover, a full circle is
/// "all around". Hull numbers follow the tuned OrbitronTactics maneuvers.
abstract final class SigilCatalog {
  // Shapes (dots, centre 4; dot 1 is forward).
  static const across = [3, 4, 5]; // left through the centre to the right
  static const forward = [7, 4, 1]; // back through the centre forward
  static const backward = [1, 4, 7];
  static const diagonal = [6, 4, 2]; // back-left through the centre, front-right
  static const quarter = [1, 2, 5]; // forward, clockwise to the right
  static const overTop = [3, 0, 1, 2, 5]; // half circle over the front
  static const underneath = [3, 6, 7, 8, 5]; // half circle under the back
  static const zed = [0, 1, 2, 4, 6, 7, 8];
  static const circle = SigilGrid.ring;
  static const doubleCircle = [...SigilGrid.ring, ...SigilGrid.ring];

  static const List<SigilSpec> all = [
    // ── HULL ────────────────────────────────────────────────────────────
    SigilSpec(
      kind: SigilKind.hop,
      layer: SigilLayer.hull,
      shape: null,
      durationMs: 250,
      cost: 12,
      tier: 1,
      control: SigilControl.none,
      // Unit path; the run scales it along the flick direction.
      path: [SigilKey(0, 0, 0), SigilKey(1, 0, -90)],
    ),
    SigilSpec(
      kind: SigilKind.sidestep,
      layer: SigilLayer.hull,
      shape: across,
      mirrorable: true,
      durationMs: 500,
      cost: 25,
      tier: 2,
      control: SigilControl.none,
      path: [SigilKey(0, 0, 0), SigilKey(1, 240, 0, roll: 0.15)],
    ),
    SigilSpec(
      kind: SigilKind.strike,
      layer: SigilLayer.hull,
      shape: forward,
      durationMs: 900,
      cost: 35,
      tier: 2,
      control: SigilControl.none,
      path: [SigilKey(0, 0, 0), SigilKey(0.4, 0, -220), SigilKey(1, 0, 0)],
      fire: [
        FireCue(0.35, damageMul: 1.5),
        FireCue(0.45, damageMul: 1.5),
        FireCue(0.55, damageMul: 1.5),
      ],
    ),
    SigilSpec(
      kind: SigilKind.retreat,
      layer: SigilLayer.hull,
      shape: backward,
      durationMs: 700,
      cost: 20,
      tier: 2,
      control: SigilControl.none,
      path: [SigilKey(0, 0, 0), SigilKey(1, 0, 200)],
      fire: [
        FireCue(0.2, shots: 2, spread: 12),
        FireCue(0.5, shots: 2, spread: 12),
        FireCue(0.8, shots: 2, spread: 12),
      ],
    ),
    SigilSpec(
      kind: SigilKind.dash,
      layer: SigilLayer.hull,
      shape: diagonal,
      mirrorable: true,
      durationMs: 1000,
      cost: 40,
      tier: 3,
      phase: (0.2, 0.5),
      control: SigilControl.none,
      path: [SigilKey(0, 0, 0), SigilKey(0.5, 150, -240), SigilKey(1, 220, 0)],
    ),
    SigilSpec(
      kind: SigilKind.roll,
      layer: SigilLayer.hull,
      shape: quarter,
      mirrorable: true,
      durationMs: 700,
      cost: 30,
      tier: 3,
      phase: (0.15, 0.65),
      control: SigilControl.none,
      path: [SigilKey(0, 0, 0), SigilKey(1, 120, 0, roll: 1)],
    ),
    SigilSpec(
      kind: SigilKind.shadow,
      layer: SigilLayer.hull,
      shape: overTop,
      mirrorable: true,
      durationMs: 2000,
      cost: 45,
      tier: 4,
      control: SigilControl.verticalOnly,
      fire: [
        FireCue(0.10),
        FireCue(0.25),
        FireCue(0.40),
        FireCue(0.55),
        FireCue(0.70),
        FireCue(0.85),
      ],
    ),
    SigilSpec(
      kind: SigilKind.echo,
      layer: SigilLayer.hull,
      shape: underneath,
      mirrorable: true,
      durationMs: 4000,
      cost: 45,
      tier: 4,
    ),
    SigilSpec(
      kind: SigilKind.loop,
      layer: SigilLayer.hull,
      shape: circle,
      mirrorable: true,
      durationMs: 1800,
      cost: 50,
      tier: 5,
      phase: (0.25, 0.55),
      control: SigilControl.none,
      path: [
        SigilKey(0, 0, 0),
        SigilKey(0.25, 0, -140, scale: 1.2),
        SigilKey(0.5, 0, -200, scale: 1.35),
        SigilKey(0.75, 0, -90, scale: 1.2),
        SigilKey(1, 0, 0),
      ],
      fire: [FireCue(0.5, shots: 3, spread: 20, damageMul: 1.5)],
    ),
    SigilSpec(
      kind: SigilKind.slalom,
      layer: SigilLayer.hull,
      shape: zed,
      mirrorable: true,
      durationMs: 1600,
      cost: 45,
      tier: 5,
      control: SigilControl.none,
      path: [
        SigilKey(0, 0, 0),
        SigilKey(0.25, 160, -60),
        SigilKey(0.5, 0, -120),
        SigilKey(0.75, -160, -60),
        SigilKey(1, 0, 0),
      ],
      fire: [
        FireCue(0.2, shots: 3, spread: 30),
        FireCue(0.4, shots: 3, spread: 30),
        FireCue(0.6, shots: 3, spread: 30),
        FireCue(0.8, shots: 3, spread: 30),
      ],
    ),
    SigilSpec(
      kind: SigilKind.corkscrew,
      layer: SigilLayer.hull,
      shape: doubleCircle,
      mirrorable: true,
      durationMs: 1500,
      cost: 50,
      tier: 5,
      phase: (0.3, 0.7),
      control: SigilControl.none,
      path: [
        SigilKey(0, 0, 0),
        SigilKey(0.25, 60, -130, roll: 0.5),
        SigilKey(0.5, 0, -260, scale: 1.2, roll: 1),
        SigilKey(0.75, -60, -130, roll: 1.5),
        SigilKey(1, 0, 0, roll: 2),
      ],
      fire: [
        FireCue(0.35, shots: 8, aim: CueAim.radial),
        FireCue(0.65, shots: 8, aim: CueAim.radial),
      ],
    ),

    // ── ARMS (LB) ───────────────────────────────────────────────────────
    SigilSpec(
      kind: SigilKind.snapshot,
      layer: SigilLayer.arms,
      shape: null,
      cost: 10,
      tier: 1,
      fire: [FireCue(0, damageMul: 1.5, aim: CueAim.flick)],
    ),
    SigilSpec(
      kind: SigilKind.broadside,
      layer: SigilLayer.arms,
      shape: across,
      cost: 25,
      tier: 2,
      fire: [FireCue(0, shots: 5, spread: 40, aim: CueAim.sides)],
    ),
    SigilSpec(
      kind: SigilKind.volley,
      layer: SigilLayer.arms,
      shape: forward,
      cost: 40,
      tier: 2,
      fire: [FireCue(0, shots: 5, spread: 40, damageMul: 2)],
    ),
    SigilSpec(
      kind: SigilKind.caltrop,
      layer: SigilLayer.arms,
      shape: backward,
      cost: 20,
      tier: 2,
    ),
    SigilSpec(
      kind: SigilKind.frenzy,
      layer: SigilLayer.arms,
      shape: quarter,
      mirrorable: true,
      durationMs: 3000,
      cost: 35,
      tier: 3,
    ),
    SigilSpec(
      kind: SigilKind.stasis,
      layer: SigilLayer.arms,
      shape: overTop,
      mirrorable: true,
      durationMs: 2500,
      cost: 50,
      tier: 4,
    ),
    SigilSpec(
      kind: SigilKind.halo,
      layer: SigilLayer.arms,
      shape: underneath,
      mirrorable: true,
      durationMs: 3000,
      cost: 40,
      tier: 4,
    ),
    SigilSpec(
      kind: SigilKind.radial,
      layer: SigilLayer.arms,
      shape: circle,
      mirrorable: true,
      cost: 55,
      tier: 5,
      fire: [FireCue(0, shots: 16, aim: CueAim.radial, damageMul: 1.2)],
    ),
    SigilSpec(
      kind: SigilKind.storm,
      layer: SigilLayer.arms,
      shape: doubleCircle,
      mirrorable: true,
      durationMs: 4000,
      cost: 70,
      tier: 5,
    ),

    // ── WING (RB) ───────────────────────────────────────────────────────
    SigilSpec(
      kind: SigilKind.ping,
      layer: SigilLayer.wing,
      shape: null,
      durationMs: 2000,
      cost: 5,
      tier: 1,
    ),
    SigilSpec(
      kind: SigilKind.wingman,
      layer: SigilLayer.wing,
      shape: across,
      mirrorable: true,
      cost: 40,
      tier: 2,
    ),
    SigilSpec(
      kind: SigilKind.hunter,
      layer: SigilLayer.wing,
      shape: forward,
      cost: 40,
      tier: 2,
    ),
    SigilSpec(
      kind: SigilKind.warden,
      layer: SigilLayer.wing,
      shape: backward,
      cost: 40,
      tier: 2,
    ),
    SigilSpec(
      kind: SigilKind.formation,
      layer: SigilLayer.wing,
      shape: quarter,
      mirrorable: true,
      cost: 10,
      tier: 3,
    ),
    SigilSpec(
      kind: SigilKind.whirl,
      layer: SigilLayer.wing,
      shape: circle,
      mirrorable: true,
      durationMs: 3000,
      cost: 35,
      tier: 4,
    ),
    SigilSpec(
      kind: SigilKind.sacrifice,
      layer: SigilLayer.wing,
      shape: underneath,
      mirrorable: true,
      cost: 0,
      tier: 4,
    ),
  ];

  static final Map<SigilKind, SigilSpec> _byKind = {
    for (final s in all) s.kind: s,
  };

  static SigilSpec of(SigilKind k) => _byKind[k]!;

  static SigilSpec? byId(String? id) {
    for (final s in all) {
      if (s.id == id) return s;
    }
    return null;
  }

  static Iterable<SigilSpec> inLayer(SigilLayer l) =>
      all.where((s) => s.layer == l);
}
