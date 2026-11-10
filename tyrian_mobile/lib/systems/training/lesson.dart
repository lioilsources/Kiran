import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../sigils/sigil_recognizer.dart';
import '../sigils/sigil_spec.dart';

/// The steps of learning one sigil (Prompts/29 §4.1).
enum LessonPhase {
  /// The ghost draws it, slowed, twice.
  watch,

  /// The world stands still; draw the shape until it reads three times.
  trace,

  /// Half speed, three times, for real.
  slow,

  /// Full speed, three times.
  live,

  /// Five in a row, alternating sides; a miss starts the count again.
  streak,

  /// Learned. From here the drill's tempo climbs with no ceiling (§5.1).
  done,
}

/// One sigil's lesson and, once learned, its endless drill. Pure: the arena
/// feeds it readings and reads back the world speed, whether the ghost
/// plays, and whether casts should only be counted.
class Lesson {
  Lesson(this.spec, {bool learned = false, this.tempo = 1.0})
      : phase = learned ? LessonPhase.done : LessonPhase.watch;

  final SigilSpec spec;
  LessonPhase phase;
  int count = 0;

  /// The drill's world speed once learned: +5 % for every five in a row,
  /// −5 % on a miss, never under half.
  double tempo;
  int _run = 0;
  double bestTempo = 1.0;

  static const double tempoStep = 0.05;
  static const double tempoFloor = 0.5;

  int get needed => switch (phase) {
        LessonPhase.watch => 2,
        LessonPhase.trace || LessonPhase.slow || LessonPhase.live => 3,
        LessonPhase.streak => 5,
        LessonPhase.done => 5,
      };

  double get worldSpeed => switch (phase) {
        LessonPhase.watch => 0.5,
        LessonPhase.trace => 0.0,
        LessonPhase.slow => 0.5,
        LessonPhase.live || LessonPhase.streak => 1.0,
        LessonPhase.done => tempo,
      };

  bool get ghostPlays => phase == LessonPhase.watch;

  /// While tracing, a drawing is counted, not flown.
  bool get countOnly => phase == LessonPhase.trace;

  bool get learned => phase == LessonPhase.done;

  /// The ghost finished one demonstration.
  void onDemo() {
    if (phase != LessonPhase.watch) return;
    if (++count >= needed) _next();
  }

  /// A gesture of the player's. Returns true when it advanced the lesson.
  bool onReading(SigilReading r) {
    if (phase == LessonPhase.watch) return false;
    final hit = r.spec?.kind == spec.kind;
    if (phase == LessonPhase.done) {
      if (hit) {
        if (++_run >= needed) {
          _run = 0;
          tempo += tempoStep;
          if (tempo > bestTempo) bestTempo = tempo;
        }
      } else if (r.spec == null || r.spec!.layer == spec.layer) {
        _run = 0;
        tempo = (tempo - tempoStep).clamp(tempoFloor, double.infinity);
      }
      return hit;
    }
    if (hit) {
      if (++count >= needed) _next();
      return true;
    }
    if (phase == LessonPhase.streak) count = 0;
    return false;
  }

  void _next() {
    count = 0;
    phase = LessonPhase.values[phase.index + 1];
  }
}

/// What the player has made of each sigil, kept across sessions (Prompts/29
/// §5.2): learned or not, the best precision and drawing time, the record
/// tempo, and how often it was cast for real.
class SigilMastery {
  SigilMastery._();
  static final SigilMastery instance = SigilMastery._();

  static const _key = 'sigil_mastery';
  final Map<SigilKind, MasteryEntry> entries = {};
  bool _loaded = false;

  MasteryEntry of(SigilKind k) => entries.putIfAbsent(k, MasteryEntry.new);

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      for (final e in m.entries) {
        final k = SigilKind.values.where((v) => v.name == e.key).firstOrNull;
        if (k != null) {
          entries[k] = MasteryEntry.fromJson(e.value as Map<String, dynamic>);
        }
      }
    } catch (_) {
      // A broken entry costs the history, never the game.
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode({for (final e in entries.entries) e.key.name: e.value.toJson()}));
  }
}

class MasteryEntry {
  bool learned = false;

  /// Casts in real play (not the arena): what the rank counts.
  int fieldCasts = 0;
  double bestAccuracy = 0;
  double? bestTime;
  double bestTempo = 1.0;

  MasteryEntry();

  /// 0 below ten real casts, then one rank per power of ten, unbounded.
  int get rank {
    var r = 0;
    for (var n = 10; fieldCasts >= n; n *= 10) {
      r++;
    }
    return r;
  }

  void record(SigilReading r, {required bool field}) {
    if (!r.cast) return;
    if (field) fieldCasts++;
    if (!r.keyed) {
      if (r.accuracy > bestAccuracy) bestAccuracy = r.accuracy;
      if (bestTime == null || r.drawTime < bestTime!) bestTime = r.drawTime;
    }
  }

  Map<String, dynamic> toJson() => {
        'learned': learned,
        'field': fieldCasts,
        'acc': bestAccuracy,
        if (bestTime != null) 'time': bestTime,
        'tempo': bestTempo,
      };

  factory MasteryEntry.fromJson(Map<String, dynamic> j) => MasteryEntry()
    ..learned = j['learned'] as bool? ?? false
    ..fieldCasts = (j['field'] as num?)?.toInt() ?? 0
    ..bestAccuracy = (j['acc'] as num?)?.toDouble() ?? 0
    ..bestTime = (j['time'] as num?)?.toDouble()
    ..bestTempo = (j['tempo'] as num?)?.toDouble() ?? 1.0;
}
