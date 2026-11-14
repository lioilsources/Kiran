import 'dart:math' as math;

import 'package:flame/components.dart';

import '../game/game_config.dart' as config;
import '../input/pad_scheme.dart';
import '../net/protocol.dart' show SigilSnap;
import '../systems/sigils/sigil_catalog.dart';
import '../services/sound_service.dart';
import '../services/telemetry_service.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../systems/mods/shot_plan.dart';
import '../systems/sigils/sigil_meter.dart';
import '../systems/sigils/sigil_recognizer.dart';
import '../systems/sigils/sigil_run.dart';
import '../systems/sigils/sigil_spec.dart';
import 'boss.dart';
import 'companion.dart';
import 'hostile.dart';
import 'ship_frame.dart';
import 'sigil_fx.dart';
import 'vessel.dart';

/// Everything the right stick and the shoulders do for one ship (Prompts/28):
/// CHARGE and FLOW, the running sigil, its untouchable phase, timed effects,
/// OVERSTREAM, MEGA BLAST, FOCUS, weapon swaps and the companions.
///
/// Owned by the [Vessel]. Idle unless [enabled]: a ship that never draws a
/// sigil plays exactly the pre-sigil game (VB6 parity at Challenge.normal).
class SigilCaster {
  SigilCaster(this.vessel);

  final Vessel vessel;

  /// Set by the game each frame: desktop, sigil scheme, not in co-op.
  bool enabled = false;

  final SigilRecognizer recognizer = SigilRecognizer();
  final SigilMeter meter = SigilMeter();

  /// The hull sigil in flight, if any.
  SigilRun? run;
  Vector2 _origin = Vector2.zero();

  /// The ship's frame when [run] was cast: its path and its shots are laid
  /// out in it, whatever the nose does meanwhile (Prompts/30 §6.4).
  ShipFrame _runFrame = ShipFrame.flight;

  /// The frame the pad is read in this frame: the stance's in a duel, the
  /// flight's otherwise. Set by the game before [input]; the HUD draws it.
  ShipFrame padFrame = ShipFrame.flight;

  /// A sigil drawn during the last stretch of [run], cast when it ends.
  SigilReading? _queued;

  /// The last gesture, cast or not — the HUD keeps it on screen until the
  /// next one starts.
  SigilReading? lastReading;

  /// Set when [lastReading] was a sigil the meter could not pay for.
  bool lastDry = false;

  /// Set when [lastReading] arrived while a sigil was running and was dropped.
  bool lastBusy = false;

  /// The arena's tracing step: gestures are read and reported, never flown.
  bool countOnly = false;

  /// Arena hook: every gesture as it is read, and every cast as it fires.
  void Function(SigilReading r)? onReading;
  void Function(SigilSpec s)? onCast;

  /// Timed effects still running, seconds left.
  final Map<SigilKind, double> effects = {};

  bool _inPhase = false;
  double _sincePhase = 99;
  double _killWindow = 0;

  /// OVERSTREAM gear, 1..3.
  int gear = 1;

  bool focus = false;

  // MEGA BLAST
  double _megaHeld = 0;
  bool megaCharging = false;
  double megaShield = 0, megaGen = 0;

  /// Where the beam goes, world space.
  double _megaAimX = 0, _megaAimY = -1;
  double _genLock = 0;

  // Weapon swap
  double _swapHeld = -1;
  bool _swapSidesDone = false;

  // Edges
  bool _prevBreak = false, _prevGrimoire = false;

  /// Asks the game to open the grimoire overlay.
  void Function()? onGrimoire;

  // Companions, mines, the echo.
  final List<Companion> companions = [];
  bool wideFormation = true;
  double _pingLeft = 0;
  double pingX = 0, pingY = -1;
  final List<Caltrop> caltrops = [];
  final EchoTrail echoTrail = EchoTrail();
  EchoGhost? echo;

  // ── Co-op: what the client draws (Prompts/28 §13) ──

  /// On a co-op client, the host's view of this ship's sigils. The client
  /// runs no sigils; it only draws what the host says.
  SigilSnap? mirror;

  /// The last MEGA BLAST while its light is up, for the client to draw.
  (double, double, double, double)? _beam;
  double _beamLeft = 0;

  /// Draw the sigil effects: the ship runs them, or mirrors a host that does.
  bool get showsFx => enabled || (mirror?.enabled ?? false);

  static const _effectOrder = [
    SigilKind.frenzy,
    SigilKind.stasis,
    SigilKind.halo,
    SigilKind.storm,
    SigilKind.echo,
    SigilKind.whirl,
  ];

  /// This ship's sigils as the co-op client should see them.
  SigilSnap get snap {
    if (!enabled) return SigilSnap.none;
    return SigilSnap(
      enabled: true,
      untouchable: untouchable,
      focus: focus,
      megaCharging: megaCharging,
      poseScale: poseScale,
      poseRoll: poseRoll,
      gear: gear,
      flow: meter.flow,
      charge: meter.charge.round(),
      megaProgress: megaProgress,
      effects: [
        for (final k in _effectOrder)
          (effects[k] ?? 0) / SigilCatalog.of(k).duration,
      ],
      companions: [
        for (final c in companions.take(2))
          (c.role.index + 1, c.position.x, c.position.y, c.absorbs),
      ],
      echo: echo == null ? null : (echo!.position.x, echo!.position.y),
      caltrops: [for (final m in caltrops.take(2)) (m.position.x, m.position.y)],
      beam: _beamLeft > 0 ? _beam : null,
    );
  }

  /// Client: take the host's view. Effects, focus and gear are copied into
  /// the fields the ship's own drawing reads.
  void applyMirror(SigilSnap s) {
    mirror = s;
    focus = s.focus;
    gear = s.gear;
    megaCharging = s.megaCharging;
    effects.clear();
    for (var i = 0; i < _effectOrder.length && i < s.effects.length; i++) {
      if (s.effects[i] > 0) {
        effects[_effectOrder[i]] = s.effects[i] * SigilCatalog.of(_effectOrder[i]).duration;
      }
    }
  }

  // ── Queries the ship and the game ask ──

  bool get untouchable => mirror?.untouchable ?? (enabled && _inPhase);

  /// What the left stick may do this frame.
  SigilControl get control =>
      run == null ? SigilControl.full : run!.spec.control;

  bool get halo => (effects[SigilKind.halo] ?? 0) > 0;
  bool get frenzy => (effects[SigilKind.frenzy] ?? 0) > 0;
  bool get storm => (effects[SigilKind.storm] ?? 0) > 0;
  bool get whirl => (effects[SigilKind.whirl] ?? 0) > 0;
  bool get echoing => (effects[SigilKind.echo] ?? 0) > 0;
  bool get pinging => _pingLeft > 0;

  /// The generator is dead for a moment after a MEGA BLAST.
  bool get genLocked => _genLock > 0;

  /// Drawn size of the ship: LOOP climbs toward the camera.
  double get poseScale => mirror?.poseScale ?? run?.pose.scale ?? 1;
  double get poseRoll => mirror?.poseRoll ?? run?.pose.roll ?? 0;

  /// MEGA BLAST charge so far, 0..1 of what the ship could pour in.
  double get megaProgress {
    final m = mirror;
    if (m != null) return m.megaProgress;
    final cap = vessel.shieldMax + vessel.genMax;
    return cap <= 0 ? 0 : ((megaShield + megaGen) / cap).clamp(0.0, 1.0);
  }

  /// Guns that are not the ship's: the companions' and the echo's. Their
  /// shots fly and hit through the ship like any other.
  Iterable<Device> get extraGuns sync* {
    for (final c in companions) {
      final d = c.gun;
      if (d != null) yield d;
    }
    final e = echo?.gun;
    if (e != null) yield e;
  }

  // ── Lifecycle ──

  /// The running sigil stops here, unpaid for and unrefunded: a duel's
  /// doors open (Prompts/30 §8.5).
  void endRun() {
    run = null;
    _queued = null;
    _inPhase = false;
  }

  /// A new sector or a fresh ship: nothing carries over but the meter.
  void reset({bool meterToo = false}) {
    run = null;
    _queued = null;
    effects.clear();
    _inPhase = false;
    _sincePhase = 99;
    _killWindow = 0;
    gear = 1;
    focus = false;
    megaCharging = false;
    _megaHeld = 0;
    megaShield = megaGen = 0;
    _genLock = 0;
    _swapHeld = -1;
    _pingLeft = 0;
    for (final c in companions) {
      c.gun?.clearProjectiles();
      c.removeFromParent();
    }
    companions.clear();
    for (final m in caltrops) {
      m.removeFromParent();
    }
    caltrops.clear();
    echo?.gun?.clearProjectiles();
    echo?.removeFromParent();
    echo = null;
    echoTrail.clear();
    recognizer.reset();
    lastReading = null;
    if (meterToo) meter.reset();
  }

  // ── Input (once per frame, before the ship updates) ──

  /// [f] is this frame's pad; ([drawX], [drawY]) its sigil stick in ship space.
  void input(PadFrame f, double drawX, double drawY, double dt) {
    if (!enabled) return;
    focus = f.focus;
    _updateGear(f.stream);

    // MEGA BLAST: both shoulders. The stick aims instead of drawing.
    if (f.arms && f.wing) {
      _megaHeld += dt;
      if (drawX * drawX + drawY * drawY > 0.25) {
        final l = math.sqrt(drawX * drawX + drawY * drawY);
        final (ax, ay) = padFrame.toWorld(drawX / l, drawY / l);
        _megaAimX = ax;
        _megaAimY = ay;
      }
      if (!megaCharging && _megaHeld >= config.megaArm) _startMega();
      if (megaCharging) _chargeMega(dt);
      recognizer.reset();
    } else {
      if (megaCharging) _releaseMega();
      _megaHeld = 0;
      final layer = f.arms
          ? SigilLayer.arms
          : (f.wing ? SigilLayer.wing : SigilLayer.hull);
      final reading = recognizer.feed(drawX, drawY, dt, layer);
      if (reading != null) _onReading(reading);
    }

    if (f.breakSigil && !_prevBreak) _break();
    _prevBreak = f.breakSigil;

    if (f.grimoire && !_prevGrimoire) onGrimoire?.call();
    _prevGrimoire = f.grimoire;

    _updateSwap(f.swap, dt);
  }

  /// Dots typed on the keyboard (Prompts/28 §12), matched like a stroke.
  void inputDots(List<int> dots, SigilLayer layer, double time) {
    if (!enabled || megaCharging) return;
    _onReading(recognizer.resolveDots(dots, layer, time: time));
  }

  void _updateGear(double t) {
    const h = config.overstreamHysteresis;
    final up3 = config.overstreamGear3 + (gear >= 3 ? -h : h);
    final up2 = config.overstreamGear2 + (gear >= 2 ? -h : h);
    gear = t >= up3 ? 3 : (t >= up2 ? 2 : 1);
  }

  void _onReading(SigilReading r) {
    lastReading = r;
    lastDry = false;
    lastBusy = false;
    onReading?.call(r);
    if (!r.cast) {
      SoundService.instance.play(SfxEvent.hitShield);
      return;
    }
    if (countOnly) {
      SoundService.instance.play(SfxEvent.pickup);
      return;
    }
    final spec = r.spec!;
    if (spec.layer == SigilLayer.hull && run != null && spec.path.isNotEmpty) {
      if (run!.progress >= config.sigilBufferFrom) {
        _queued = r;
      } else {
        lastBusy = true;
      }
      return;
    }
    _cast(r);
  }

  void _cast(SigilReading r) {
    final spec = r.spec!;
    if (!meter.pay(spec.cost)) {
      lastDry = true;
      return;
    }
    meter.onCast(spec.kind);
    _killWindow = spec.duration + config.chargeKillWindow;
    SoundService.instance.play(SfxEvent.pickup);
    onCast?.call(spec);
    switch (spec.layer) {
      case SigilLayer.hull:
        _castHull(spec, r);
      case SigilLayer.arms:
        _castArms(spec, r);
      case SigilLayer.wing:
        _castWing(spec, r);
    }
  }

  void _castHull(SigilSpec spec, SigilReading r) {
    if (spec.kind == SigilKind.echo) {
      effects[SigilKind.echo] = spec.duration;
      _spawnEcho();
      return;
    }
    run = SigilRun(spec, mirrored: r.mirrored, flickDot: r.flickDot);
    _origin = vessel.position.clone();
    _runFrame = vessel.frame;
  }

  void _castArms(SigilSpec spec, SigilReading r) {
    final dir = SigilRun(spec, flickDot: r.flickDot);
    for (final c in spec.fire) {
      _fireCue(c, flickX: dir.dirX, flickY: dir.dirY);
    }
    switch (spec.kind) {
      case SigilKind.caltrop:
        final m = Caltrop(caster: this, position: vessel.position.clone());
        caltrops.add(m);
        vessel.game.world.add(m);
      case SigilKind.stasis:
        vessel.game.startTimewarp(config.stasisScale, spec.duration);
        effects[spec.kind] = spec.duration;
      case SigilKind.frenzy || SigilKind.halo || SigilKind.storm:
        effects[spec.kind] = spec.duration;
      default:
        break;
    }
  }

  void _castWing(SigilSpec spec, SigilReading r) {
    switch (spec.kind) {
      case SigilKind.ping:
        final d = SigilRun(spec, flickDot: r.flickDot);
        final (px, py) = vessel.frame.toWorld(d.dirX, d.dirY);
        pingX = px;
        pingY = py;
        _pingLeft = spec.duration;
      case SigilKind.wingman:
        // Drawn left to right: the wingman takes the right flank.
        _summon(CompanionRole.wingman, side: r.mirrored ? -1 : 1);
      case SigilKind.hunter:
        _summon(CompanionRole.hunter);
      case SigilKind.warden:
        _summon(CompanionRole.warden);
      case SigilKind.formation:
        wideFormation = !wideFormation;
      case SigilKind.whirl:
        effects[spec.kind] = spec.duration;
      case SigilKind.sacrifice:
        for (final c in companions) {
          c.sacrifice();
        }
      default:
        break;
    }
  }

  /// BREAK: end the running sigil now, or failing that every timed effect.
  void _break() {
    final hasRun = run != null;
    final hasFx = effects.values.any((t) => t > 0);
    if (!hasRun && !hasFx) return;
    if (!meter.pay(config.sigilBreakCost)) {
      lastDry = true;
      return;
    }
    if (hasRun) {
      run = null;
      _queued = null;
    } else {
      if (effects.containsKey(SigilKind.stasis)) {
        vessel.game.startTimewarp(1.0, 0);
      }
      effects.clear();
    }
  }

  // ── The frame (host only, from Vessel.update) ──

  void update(double dt) {
    if (!enabled) {
      if (run != null || companions.isNotEmpty || effects.isNotEmpty) reset();
      return;
    }
    meter.tick(dt, busy: run != null);
    if (_killWindow > 0) _killWindow -= dt;
    if (_beamLeft > 0) _beamLeft -= dt;
    if (_genLock > 0) {
      _genLock -= dt;
      vessel.genValue = 0;
    }
    if (_pingLeft > 0) _pingLeft -= dt;

    final r = run;
    if (r != null) {
      r.advance(dt);
      _fly(r, dt);
      for (final c in r.dueCues()) {
        _fireCue(c, flickX: r.dirX, flickY: r.dirY, frame: _runFrame);
      }
      if (r.done) {
        run = null;
        final q = _queued;
        _queued = null;
        if (q != null) _cast(q);
      }
    }
    _updatePhase(dt);

    for (final k in [...effects.keys]) {
      final left = effects[k]! - dt;
      if (left <= 0) {
        effects.remove(k);
        if (k == SigilKind.echo) _dropEcho();
      } else {
        effects[k] = left;
      }
    }

    echoTrail.record(vessel.position.x, vessel.position.y, vessel.fire, dt,
        heading: vessel.heading);
    companions.removeWhere((c) => c.isRemoved || c.gone);
    caltrops.removeWhere((m) => m.isRemoved);
  }

  void _fly(SigilRun r, double dt) {
    final p = r.pose;
    final f = _runFrame;
    switch (r.spec.control) {
      case SigilControl.none:
        final (wx, wy) = f.toWorld(p.dx, p.dy);
        vessel.adjustPosition(_origin.x + wx, _origin.y + wy);
      case SigilControl.verticalOnly:
        final t = _shadowTarget(r.mirrored);
        if (t != null) {
          final k = 1 - math.exp(-8 * dt);
          if (f.isIdentity) {
            vessel.adjustPosition(
                vessel.position.x + (t.hostCenter.x - vessel.position.x) * k,
                vessel.position.y);
          } else {
            // Across the nose only: SHADOW keeps its line, sideways.
            final (lx, _) = f.toShip(t.hostCenter.x - vessel.position.x,
                t.hostCenter.y - vessel.position.y);
            vessel.adjustPosition(vessel.position.x + f.rx * lx * k,
                vessel.position.y + f.ry * lx * k);
          }
        }
      case SigilControl.full:
        break;
    }
  }

  /// SHADOW's mark: the nearest living hostile ahead, on the side it was
  /// drawn toward when there is a choice.
  Hostile? _shadowTarget(bool mirrored) {
    Hostile? best;
    var bestD = double.infinity;
    final fr = _runFrame;
    for (final f in vessel.game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead || h.offField) continue;
        final c = h.hostCenter;
        // Ship space; at heading 0 these are the flight's own numbers.
        final (lx, ly) = fr.toShip(c.x - vessel.position.x, c.y - vessel.position.y);
        if (ly > 0) continue;
        var d = lx.abs() + (-ly) * 0.3;
        final side = lx;
        if ((mirrored && side > 0) || (!mirrored && side < 0)) d *= 1.4;
        if (d < bestD) {
          bestD = d;
          best = h;
        }
      }
    }
    return best;
  }

  void _updatePhase(double dt) {
    final want = run?.untouchable ?? false;
    if (want && !_inPhase && _sincePhase >= config.phaseGap) {
      _inPhase = true;
    } else if (!want && _inPhase) {
      _inPhase = false;
      _sincePhase = 0;
    }
    if (!_inPhase) _sincePhase += dt;
  }

  // ── Fire ──

  /// Shots of [c] from the front gun, through its plan (mods apply), laid
  /// out in [frame] — the run's, or the ship's now.
  void _fireCue(FireCue c,
      {double flickX = 0, double flickY = -1, ShipFrame? frame}) {
    final f = frame ?? vessel.frame;
    final gun = vessel.getDevice(WeaponSlot.frontGun);
    if (gun == null) return;
    var live = 0;
    for (final d in vessel.allGuns) {
      live += d.projectiles.length;
    }
    if (live + c.shots > ShotPlan.maxLiveShots) return;
    final plan = vessel.planFor(gun);
    final dmg = plan.damage * c.damageMul;
    final speed = plan.speed;
    final img = gun.beam > 0 ? 'bubble' : null;
    final n = vessel.nozzle;
    final dirs = cueDirections(c, flickX: flickX, flickY: flickY);
    for (final (ux, uy) in dirs) {
      final (vx, vy) = f.toWorld(speed * ux, speed * uy);
      gun.spawnShot(n.x, n.y,
          vx: vx,
          speed: vy,
          damage: dmg,
          scale: 1.0,
          plan: plan,
          img: img,
          centred: !f.isIdentity);
    }
    SoundService.instance.play(SfxEvent.fireBullet);
  }

  /// Unit directions of a cue's shots, ship space.
  static List<(double, double)> cueDirections(FireCue c,
      {double flickX = 0, double flickY = -1}) {
    final out = <(double, double)>[];
    double base;
    switch (c.aim) {
      case CueAim.radial:
        for (var i = 0; i < c.shots; i++) {
          final a = 2 * math.pi * i / c.shots;
          out.add((math.sin(a), -math.cos(a)));
        }
        return out;
      case CueAim.sides:
        for (final side in const [-1.0, 1.0]) {
          out.addAll(_fan(side * math.pi / 2, c.shots, c.spread));
        }
        return out;
      case CueAim.flick:
        base = math.atan2(flickX, -flickY);
      case CueAim.forward:
        base = 0;
    }
    out.addAll(_fan(base, c.shots, c.spread));
    return out;
  }

  static List<(double, double)> _fan(double centre, int n, double spreadDeg) {
    final spread = spreadDeg * math.pi / 180;
    return [
      for (var i = 0; i < n; i++)
        () {
          final a = n == 1 ? centre : centre - spread / 2 + spread * i / (n - 1);
          return (math.sin(a), -math.cos(a));
        }(),
    ];
  }

  /// The plan [d] fires with this frame: OVERSTREAM on the front gun,
  /// FRENZY's cadence, STORM's free power.
  ShotPlan firePlan(Device d, ShotPlan base) {
    if (!enabled) return base;
    final front = d.slot == WeaponSlot.frontGun;
    final g = front ? gear : 1;
    final cdMul = frenzy ? config.frenzyCooldown : 1.0;
    final pwrMul = storm ? 0.0 : 1.0;
    if (g == 1 && cdMul == 1 && pwrMul == 1) return base;
    return base.shifted(gear: g, cooldownMul: cdMul, pwrMul: pwrMul);
  }

  // ── Income ──

  void onGenSurplus(double units) {
    if (enabled) meter.addSurplus(units);
  }

  void onGraze({required bool phase}) {
    if (!enabled) return;
    meter.add(phase ? config.chargePhaseGraze : config.chargeGraze);
  }

  void onKill() {
    if (enabled && _killWindow > 0) meter.add(config.chargeKill);
  }

  /// The arena's kata counts hull hits against the grade.
  void Function()? onHullHitHook;

  void onHullHit() {
    if (!enabled) return;
    meter.onHullHit();
    onHullHitHook?.call();
  }

  // ── MEGA BLAST ──

  void _startMega() {
    if (vessel.shield < vessel.shieldMax * config.megaMinShield) {
      lastDry = true;
      _megaHeld = -999; // not again until the shoulders are released
      return;
    }
    megaCharging = true;
    megaShield = megaGen = 0;
    // Straight ahead until the stick says otherwise.
    _megaAimX = vessel.frame.fx;
    _megaAimY = vessel.frame.fy;
  }

  void _chargeMega(double dt) {
    var budget = (vessel.shieldMax + vessel.genMax) / config.megaChargeTime * dt;
    final s = math.min(budget, vessel.shield);
    vessel.shield -= s;
    megaShield += s;
    budget -= s;
    if (budget > 0) {
      final g = math.min(budget, math.max(0.0, vessel.genValue));
      vessel.genValue -= g;
      megaGen += g;
    }
  }

  void _releaseMega() {
    megaCharging = false;
    final dmg = config.megaBase +
        megaShield * config.megaShieldDmg +
        megaGen * config.megaGenDmg;
    final width = config.megaWidthMin +
        (config.megaWidthMax - config.megaWidthMin) * megaProgress;
    final n = vessel.nozzle;
    final beam = MegaBeam(
        x: n.x, y: n.y, dirX: _megaAimX, dirY: _megaAimY, width: width);
    vessel.game.world.add(beam);
    _beam = (n.x, n.y, math.atan2(_megaAimX, -_megaAimY), width);
    _beamLeft = config.megaFlash;
    _hitAlong(n.x, n.y, _megaAimX, _megaAimY, width, dmg.round());
    _genLock = config.megaGenLock;
    megaShield = megaGen = 0;
    vessel.game.shaderPipeline.triggerAberration();
    SoundService.instance.play(SfxEvent.explosionLarge);
  }

  /// Damage every hostile whose centre lies within the beam, and wipe the
  /// enemy shots in it.
  void _hitAlong(double x, double y, double ux, double uy, double width, int dmg) {
    final game = vessel.game;
    final half = width / 2;
    bool inBeam(double px, double py) {
      final rx = px - x, ry = py - y;
      final along = rx * ux + ry * uy;
      if (along < 0) return false;
      final across = (rx * uy - ry * ux).abs();
      return across <= half;
    }

    for (final f in [...game.activeFleets]) {
      for (final h in [...f.hostiles]) {
        if (h.isDead || h.offField) continue;
        final c = h.hostCenter;
        if (!inBeam(c.x, c.y)) continue;
        final boss = h is Boss || h is BossPart;
        h.takeDamage(boss ? (dmg * config.megaBossShare).round() : dmg, game,
            attacker: vessel);
        if (h.isDead) f.onHostileKilled(h, game, attacker: vessel);
      }
    }
    for (final p in [...game.enemyProjectiles]) {
      if (inBeam(p.position.x + p.size.x / 2, p.position.y + p.size.y / 2)) {
        p.removeFromParent();
        game.enemyProjectiles.remove(p);
      }
    }
  }

  /// Hostiles within [radius] of (x, y) take [dmg]; enemy shots there vanish.
  void blastAt(double x, double y, double radius, int dmg) {
    final game = vessel.game;
    final r2 = radius * radius;
    for (final f in [...game.activeFleets]) {
      for (final h in [...f.hostiles]) {
        if (h.isDead || h.offField) continue;
        final c = h.hostCenter;
        final dx = c.x - x, dy = c.y - y;
        if (dx * dx + dy * dy > r2) continue;
        final boss = h is Boss || h is BossPart;
        h.takeDamage(boss ? (dmg * config.megaBossShare).round() : dmg, game,
            attacker: vessel);
        if (h.isDead) f.onHostileKilled(h, game, attacker: vessel);
      }
    }
    for (final p in [...game.enemyProjectiles]) {
      final dx = p.position.x + p.size.x / 2 - x;
      final dy = p.position.y + p.size.y / 2 - y;
      if (dx * dx + dy * dy <= r2) {
        p.removeFromParent();
        game.enemyProjectiles.remove(p);
      }
    }
    game.addExplosion(x, y, 3);
    SoundService.instance.play(SfxEvent.explosionLarge);
  }

  // ── Swap ──

  void _updateSwap(bool held, double dt) {
    if (held) {
      if (_swapHeld < 0) {
        _swapHeld = 0;
        _swapSidesDone = false;
      } else {
        _swapHeld += dt;
      }
      if (!_swapSidesDone && _swapHeld >= config.swapHoldSides) {
        _swapSidesDone = true;
        _swapSides();
      }
    } else if (_swapHeld >= 0) {
      if (!_swapSidesDone) _swapFront();
      _swapHeld = -1;
    }
  }

  void _swapFront() {
    final next = vessel.hangar
        .where((d) => d.slot == WeaponSlot.frontGun)
        .firstOrNull;
    if (next == null) return;
    _fit(next, WeaponSlot.frontGun);
  }

  void _swapSides() {
    for (final slot in const [WeaponSlot.leftGun, WeaponSlot.rightGun]) {
      final next = vessel.hangar.where((d) => d.slot == slot).firstOrNull;
      if (next != null) _fit(next, slot);
    }
  }

  void _fit(Device d, WeaponSlot slot) {
    final type = DevType.byName(d.name);
    if (type == null) return;
    final fitted = vessel.fitWeapon(type, slot);
    TelemetryService.instance.noteWeaponSwitch();
    fitted.cd = fitted.cooldown + config.swapDelay;
    vessel.game.showMessage(fitted.displayName.toUpperCase());
  }

  // ── Companions and the echo ──

  void _summon(CompanionRole role, {int side = 1}) {
    if (companions.length >= config.companionMax) {
      final oldest = companions.removeAt(0);
      oldest.gun?.clearProjectiles();
      oldest.removeFromParent();
    }
    if (role == CompanionRole.wingman &&
        companions.any((c) => c.role == CompanionRole.wingman && c.side == side)) {
      side = -side;
    }
    final c = Companion(caster: this, role: role, side: side);
    companions.add(c);
    vessel.game.world.add(c);
  }

  /// The arena's head start: [n] wingmen, one per flank.
  void grantCompanions(int n) {
    for (var i = 0; i < n; i++) {
      _summon(CompanionRole.wingman, side: i.isEven ? 1 : -1);
    }
  }

  void _spawnEcho() {
    _dropEcho();
    final front = vessel.getDevice(WeaponSlot.frontGun);
    final e = EchoGhost(caster: this, front: front);
    echo = e;
    vessel.game.world.add(e);
  }

  void _dropEcho() {
    echo?.gun?.clearProjectiles();
    echo?.removeFromParent();
    echo = null;
  }
}
