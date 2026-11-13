import '../sigils/sigil_recognizer.dart';
import '../sigils/sigil_spec.dart';

/// A kata (Prompts/29 §5.4): a chain of sigils with a beat to hit each on,
/// graded D to S. Data, not code: a new kata is a new entry in [kKatas].
class Kata {
  final String id;

  /// Difficulty band 1..4, for the order they are offered in.
  final int band;
  final List<SigilKind> chain;

  /// Seconds between two steps at 100 % tempo.
  final double beat;

  const Kata(this.id, this.band, this.chain, {this.beat = 1.6});
}

/// The starting set: four bands, five each. Every chain alternates layers
/// and never repeats a sigil back to back, so a clean run also builds FLOW.
const List<Kata> kKatas = [
  // Band 1: flicks and strokes through the centre.
  Kata('first-steps', 1, [SigilKind.hop, SigilKind.sidestep, SigilKind.hop, SigilKind.strike]),
  Kata('fire-and-fall', 1, [SigilKind.snapshot, SigilKind.retreat, SigilKind.volley]),
  Kata('side-to-side', 1, [SigilKind.sidestep, SigilKind.broadside, SigilKind.sidestep]),
  Kata('call-and-strike', 1, [SigilKind.wingman, SigilKind.strike, SigilKind.ping]),
  Kata('mine-field', 1, [SigilKind.caltrop, SigilKind.hop, SigilKind.caltrop, SigilKind.retreat]),
  // Band 2: quarter circles and diagonals.
  Kata('barrel', 2, [SigilKind.roll, SigilKind.volley, SigilKind.dash]),
  Kata('frenzy-run', 2, [SigilKind.frenzy, SigilKind.strike, SigilKind.roll, SigilKind.snapshot]),
  Kata('wedge', 2, [SigilKind.wingman, SigilKind.formation, SigilKind.hunter, SigilKind.ping]),
  Kata('dash-dance', 2, [SigilKind.dash, SigilKind.sidestep, SigilKind.dash, SigilKind.hop]),
  Kata('cover-me', 2, [SigilKind.warden, SigilKind.retreat, SigilKind.volley, SigilKind.roll]),
  // Band 3: half circles.
  Kata('shadow-hunt', 3, [SigilKind.shadow, SigilKind.frenzy, SigilKind.strike], beat: 2.2),
  Kata('time-out', 3, [SigilKind.stasis, SigilKind.dash, SigilKind.volley, SigilKind.retreat]),
  Kata('echo-chamber', 3, [SigilKind.echo, SigilKind.broadside, SigilKind.roll], beat: 1.9),
  Kata('halo-hold', 3, [SigilKind.halo, SigilKind.warden, SigilKind.strike, SigilKind.hop]),
  Kata('last-stand', 3, [SigilKind.sacrifice, SigilKind.wingman, SigilKind.stasis]),
  // Band 4: circles and the double circle.
  Kata('first-s', 4, [SigilKind.loop, SigilKind.strike, SigilKind.volley, SigilKind.hop], beat: 2.0),
  Kata('wheel', 4, [SigilKind.radial, SigilKind.loop, SigilKind.whirl], beat: 2.0),
  Kata('slalom-storm', 4, [SigilKind.slalom, SigilKind.storm, SigilKind.dash], beat: 2.2),
  Kata('corkscrew', 4, [SigilKind.corkscrew, SigilKind.radial, SigilKind.roll], beat: 2.0),
  Kata('everything', 4, [
    SigilKind.loop, SigilKind.volley, SigilKind.wingman, SigilKind.shadow,
    SigilKind.stasis, SigilKind.corkscrew,
  ], beat: 2.2),
];

/// One go at a kata. The clock starts at the first cast; each step has a
/// window around its beat (±[window] s at 100 % tempo, scaled by tempo).
/// Wrong sigils and misses cost; hull hits are reported by the arena.
class KataRun {
  KataRun(this.kata, {this.tempo = 1.0});

  final Kata kata;
  final double tempo;
  static const double window = 0.25;

  int step = 0;
  double _t = 0;
  bool _started = false;
  int onBeat = 0, offBeat = 0, wrong = 0, hits = 0;
  double _accSum = 0;

  bool get done => step >= kata.chain.length;
  SigilKind? get next => done ? null : kata.chain[step];

  /// Seconds until the next step's beat (negative = late).
  double get dueIn => _started ? _due(step) - _t : 0;

  double _due(int i) => i * kata.beat / tempo;

  void tick(double dt) {
    if (_started && !done) _t += dt;
  }

  void onHullHit() {
    if (_started && !done) hits++;
  }

  /// A gesture. Returns true when it was the step it should be.
  bool onReading(SigilReading r) {
    if (done) return false;
    if (r.spec?.kind != next) {
      if (_started) wrong++;
      return false;
    }
    if (!_started) {
      _started = true;
      _t = 0;
    }
    final off = (_t - _due(step)).abs();
    if (step == 0 || off <= window / tempo) {
      onBeat++;
    } else {
      offBeat++;
    }
    _accSum += r.keyed ? 1.0 : r.accuracy;
    step++;
    return true;
  }

  double get meanAccuracy => step == 0 ? 0 : _accSum / step;

  /// D..S. S is every step on its beat, nothing wrong, no hit, and a clean
  /// hand (90 %+ precision).
  String get grade {
    if (!done) return '';
    final n = kata.chain.length;
    final beatShare = onBeat / n;
    final penalty = wrong * 0.15 + hits * 0.2;
    final score = beatShare * 0.7 + meanAccuracy * 0.3 - penalty;
    if (beatShare == 1 && wrong == 0 && hits == 0 && meanAccuracy >= 0.9) return 'S';
    if (score >= 0.8) return 'A';
    if (score >= 0.6) return 'B';
    if (score >= 0.4) return 'C';
    return 'D';
  }
}
