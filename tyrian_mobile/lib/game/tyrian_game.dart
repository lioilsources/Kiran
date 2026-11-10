import 'dart:async' show unawaited;
import 'dart:math' show exp, min;
import 'dart:typed_data';
import 'package:cute_kid_fonts/cute_kid_fonts.dart' show KidPalette;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'challenge.dart';
import 'capture_director.dart';
import 'frame_capture.dart';
import 'game_config.dart' as config;
import 'platform_config.dart' as platform;
import '../input/keyboard_input.dart';
import '../input/gamepad_input.dart';
import '../input/pad_scheme.dart';
import '../input/keyboard_sigils.dart';
import '../rendering/sigil_hud.dart';
import '../systems/sigils/sigil_catalog.dart';
import '../systems/sigils/sigil_recognizer.dart';
import '../systems/sigils/sigil_hints.dart';
import '../systems/sigils/sigil_spec.dart';
import '../systems/training/arena.dart';
import '../systems/training/arena_ghost.dart';
import '../systems/training/lesson.dart';
import '../systems/training/kata.dart';
import '../systems/training/gauntlet.dart';
import '../rendering/starfield.dart';
import '../rendering/parallax_bg.dart';
import '../rendering/offscreen_markers.dart';
import '../rendering/bg_zones.dart';
import '../entities/vessel.dart';
import '../entities/boss.dart';
import '../entities/explosion.dart';
import '../entities/death_effect.dart';
import '../entities/collectable.dart';
import '../entities/structure.dart';
import '../entities/hostile.dart';
import '../systems/sector.dart';
import '../systems/campaign.dart';
import '../systems/campaign_tracker.dart';
import '../systems/fleet.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../systems/weapon_family.dart';
import 'death_effect_config.dart';
import '../entities/projectile.dart';
import '../services/achievement_service.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../services/music_service.dart';
import '../systems/music_director.dart';
import '../rendering/batch_renderer.dart';
import '../entities/shard.dart';
import '../rendering/beam_renderer.dart';
import '../rendering/shader_pipeline.dart';
import '../services/skin_registry.dart';
import '../ui/float_text.dart';
import '../net/protocol.dart';
import '../net/coop_host.dart';
import '../net/coop_client.dart';
import '../services/save_service.dart';
import '../l10n/l10n.dart';
import '../systems/mods/mod_rewards.dart';
import '../systems/mods/mods_state.dart';
import '../systems/mods/hull_spec.dart';

enum GameState { comCenter, playing, paused, gameOver }
enum CoopRole { none, host, client }

/// Endless is the roguelike run; campaign is the node map with its own vessel
/// and save; training is the sigil arena (Prompts/29), which borrows the
/// endless ship and writes nothing back. Everything keyed on a sector index —
/// level, art zone, which content loads, where progress is written —
/// dispatches on this.
enum GameMode { endless, campaign, training }

class TyrianGame extends FlameGame
    with DragCallbacks, TapCallbacks, KeyboardEvents {
  TyrianGame();

  final KeyboardInput keyboardInput = KeyboardInput();
  final GamepadInput gamepadInput = GamepadInput();
  double _gamepadPollTimer = 0;

  late Starfield starfield;
  late ParallaxBackground parallaxBg;
  late Vessel vessel;
  Vessel? vessel2; // null = solo mode
  late BeamRenderer beamRenderer;
  late ShaderPipeline shaderPipeline;

  bool get isCoop => vessel2 != null;

  /// Purely visual horizontal world shift (opposite of the local vessel's
  /// bank) — read by world renderers at draw time; never touches positions.
  double worldShiftX = 0;

  Vessel get _bankVessel =>
      coopRole == CoopRole.client ? (vessel2 ?? vessel) : vessel;

  void _updateWorldShift(double dt) {
    final target = state == GameState.playing
        ? -_bankVessel.bank * config.bankWorldShift
        : 0.0;
    // Slower easing than the vessel roll — the world visibly trails the ship
    worldShiftX =
        target + (worldShiftX - target) * exp(-config.bankWorldResponse * dt);
    if (worldShiftX.abs() < 0.01) worldShiftX = 0;
  }

  // Co-op networking
  CoopRole coopRole = CoopRole.none;
  CoopHost? coopHost;
  CoopClient? coopClient;
  String? hostIp; // Display to user for manual connect
  /// Callback when a client joins (for UI notification)
  VoidCallback? onClientJoined;

  /// Callback when the client drops — the seat is free again.
  VoidCallback? onClientLeft;

  /// All active (visible) vessels for collision iteration
  List<Vessel> get allVessels => [
        vessel,
        if (vessel2 != null) vessel2!,
      ];

  // Client-side entity cache for snapshot rendering
  final Map<int, Hostile> clientHostiles = {};
  final Map<int, Structure> clientStructures = {};
  final List<Projectile> clientPlayerProjectiles = [];

  GameState state = GameState.comCenter;
  bool isLoaded = false;

  // Active game objects
  final List<Fleet> activeFleets = [];
  final List<Structure> activeStructures = [];
  final List<Collectable> activeCollectables = [];
  final ShardPool shardPool = ShardPool();
  late ExplosionRenderer explosionRenderer;
  late DeathEffectRenderer deathEffects;
  final List<Projectile> enemyProjectiles = [];

  Sector? currentSector;
  int currentSectorIndex = 0;

  GameMode mode = GameMode.endless;

  /// The challenge in force right now. A campaign carries its own, fixed at
  /// creation; endless follows the menu selection live, so changing it in
  /// the main menu takes effect from the next sector of the current run.
  Challenge get challenge => mode == GameMode.campaign
      ? (campaign?.challenge ?? Challenge.normal)
      : Challenge.selected;
  CampaignState? campaign;

  /// Counts objective progress through a campaign node. Null in endless, which
  /// is what keeps the hooks in Fleet and Vessel free.
  CampaignTracker? campaignTracker;

  /// How the node that just finished was graded — read by the result card.
  NodeResult? lastNodeResult;

  /// Weapons a boss kill just opened up, for the result card to announce.
  /// Null when the node opened nothing.
  String? lastNodeUnlock;

  /// Mods and hulls the node that just finished paid out, for the result card.
  ModReward lastNodeReward = ModReward.nothing;

  /// Enemy clock: 1 normally, below 1 while a TIMEWARP runs. Read by fleets,
  /// hostiles, the boss and enemy shots; the player's side ignores it.
  double enemyTimeScale = 1.0;
  double _timewarpLeft = 0;

  void startTimewarp(double scale, double seconds) {
    enemyTimeScale = scale;
    _timewarpLeft = seconds;
  }

  /// A boss core went down. Endless pays a mod for every one; the campaign
  /// pays at the end of the node, from its objectives.
  void onBossKilled(Hostile boss) {
    if (mode != GameMode.endless || coopRole == CoopRole.client) return;
    final r = ModRewards.endlessBoss(
        state: ModsState.instance,
        challengeId: challenge.id,
        fitted: vessel.fittedMods);
    _announceReward(r);
  }

  void _announceReward(ModReward r) {
    if (r.isEmpty) return;
    ModsState.instance.save();
    for (final m in r.mods) {
      final spec = m.spec;
      if (spec != null) showMessage('+ ${spec.name}');
    }
    for (final h in r.hulls) {
      showMessage('+ ${h.toUpperCase()}');
    }
  }

  /// VB6 difficulty level of a sector index in the current mode. The campaign
  /// tables its own levels: Sector.levelForIndex would read node 19 as the
  /// second procedural level (8) and pay the max-level bounty for it.
  int levelForIndex(int index) => mode == GameMode.campaign
      ? Campaign.levelForNode(index)
      : Sector.levelForIndex(index);

  int zoneForIndex(int index) => mode == GameMode.training
      ? BgZones.forLevel(arena.level)
      : BgZones.forLevel(levelForIndex(index));

  // ── Training arena (Prompts/29 §3) ──

  final ArenaSettings arena = ArenaSettings();
  final ArenaStats arenaStats = ArenaStats();

  /// The endless ship as it was before the arena, put back on the way out.
  Map<String, dynamic>? _arenaReturn;

  /// Fired when the arena wants its panel (pause, or after leaving).
  VoidCallback? onArenaChanged;

  /// The View button asked for the grimoire; main.dart shows it.
  VoidCallback? onGrimoireRequested;
  bool grimoireOpen = false;

  void openGrimoire() {
    if (state != GameState.playing || grimoireOpen) return;
    grimoireOpen = true;
    togglePause();
    onGrimoireRequested?.call();
  }

  void closeGrimoire() {
    if (!grimoireOpen) return;
    grimoireOpen = false;
    suppressStartEdge();
    if (state == GameState.paused) togglePause();
  }

  /// A pad that plays itself in the arena (demo and video capture).
  static const bool sigilDemo = bool.fromEnvironment('SIGIL_DEMO');
  ArenaGhost? ghost;

  /// The drilled sigil's lesson (Prompts/29 §4), or null in free play.
  Lesson? lesson;

  /// The kata in progress (Prompts/29 §5.4), and how the last one went.
  KataRun? kataRun;
  String lastKataGrade = '';
  double _kataRestart = 0;

  /// Best grade per kata, kept across sessions.
  static const _kataKey = 'kata_best';
  final Map<String, String> kataBest = {};

  static const _gradeOrder = ['', 'D', 'C', 'B', 'A', 'S'];

  Future<void> _loadKataBest() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in prefs.getStringList(_kataKey) ?? const <String>[]) {
      final i = e.indexOf('=');
      if (i > 0) kataBest[e.substring(0, i)] = e.substring(i + 1);
    }
  }

  void _kataFinished(KataRun run) {
    lastKataGrade = run.grade;
    showMessage('${run.kata.id.toUpperCase()} ${run.grade}');
    final id = run.kata.id;
    if (_gradeOrder.indexOf(run.grade) > _gradeOrder.indexOf(kataBest[id] ?? '')) {
      kataBest[id] = run.grade;
      SharedPreferences.getInstance().then((p) => p.setStringList(
          _kataKey, [for (final e in kataBest.entries) '${e.key}=${e.value}']));
    }
    _kataRestart = 2.0;
  }

  /// World speed the arena runs at now: a filmed take's, the lesson's
  /// step, or the dial.
  double get arenaSpeed =>
      capture?.speed ?? lesson?.worldSpeed ?? arena.speed;

  /// Filming a lesson for the tutorial videos (Prompts/29 §6.3).
  CaptureDirector? capture;

  /// Set up the drill's lesson and the ghost that goes with it.
  void _setupDrill() {
    if (capture != null) return; // the director drives the ghost
    final k = arena.kata;
    if (k == null) {
      kataRun = null;
    } else if (kataRun?.kata != k) {
      kataRun = KataRun(k, tempo: 1.0);
      lastKataGrade = '';
    }
    vessel.caster.onHullHitHook = kataRun == null ? null : () => kataRun?.onHullHit();
    final d = arena.drill;
    if (d == null) {
      lesson = null;
      ghost = sigilDemo ? ArenaGhost.catalogue() : null;
    } else {
      final m = SigilMastery.instance.of(d);
      if (lesson?.spec.kind != d) {
        lesson = Lesson(SigilCatalog.of(d), learned: m.learned);
      }
      _syncGhost();
    }
    vessel.caster.countOnly = lesson?.countOnly ?? false;
  }

  /// The ghost plays while the lesson says watch (and always in demo mode).
  void _syncGhost() {
    final l = lesson;
    if (l == null) return;
    if (l.ghostPlays || sigilDemo) {
      if (ghost?.sigils.singleOrNull?.kind != l.spec.kind) {
        ghost = ArenaGhost([l.spec])..onDrawn = _onGhostDrawn;
      }
    } else {
      ghost = null;
    }
  }

  void _onGhostDrawn() {
    lesson?.onDemo();
    _syncGhost();
    vessel.caster.countOnly = lesson?.countOnly ?? false;
  }

  /// Every gesture in the arena: the scoreboard, the lesson, the records.
  void _onArenaReading(SigilReading r) {
    if (ghost != null && !sigilDemo) return; // the ghost's own drawing
    arenaStats.onReading(r);
    final kr = kataRun;
    if (kr != null && !kr.done) {
      kr.onReading(r);
      if (kr.done) _kataFinished(kr);
    }
    final l = lesson;
    if (l != null) {
      final was = l.phase;
      l.onReading(r);
      if (l.phase != was) {
        _syncGhost();
        vessel.caster.countOnly = l.countOnly;
        if (l.learned) {
          SigilMastery.instance.of(l.spec.kind).learned = true;
          SigilMastery.instance.save();
        }
      }
      final m = SigilMastery.instance.of(l.spec.kind);
      if (l.bestTempo > m.bestTempo) m.bestTempo = l.bestTempo;
    }
    if (r.spec != null) SigilMastery.instance.of(r.spec!.kind).record(r, field: false);
  }

  /// Every gesture in real play: what the mastery ranks count.
  void _onFieldReading(SigilReading r) {
    final s = r.spec;
    if (s != null) SigilMastery.instance.of(s.kind).record(r, field: true);
    final h = SigilHints.instance.active;
    if ((h == SigilHint.hop && s?.kind == SigilKind.hop) ||
        (h == SigilHint.loop && s?.kind == SigilKind.loop)) {
      SigilHints.instance.dismiss();
    }
  }

  double _streamHintT = 0;

  /// Real play only: offer each one-time hint when its moment comes
  /// (Prompts/29 §5b). Returns the world speed factor (the first one slows
  /// time so the player can read it).
  double _sigilHints(double realDt) {
    final hints = SigilHints.instance;
    if (mode == GameMode.training || !sigilsEnabled || state != GameState.playing) {
      return 1;
    }
    final c = vessel.caster;
    if (c.meter.charge >= config.chargeMax) hints.offer(SigilHint.hop);
    var ahead = 0;
    for (final p in enemyProjectiles) {
      final dx = p.position.x - vessel.position.x;
      final dy = vessel.position.y - p.position.y;
      if (dx.abs() < 120 && dy > 0 && dy < 260) ahead++;
    }
    if (ahead >= 8) hints.offer(SigilHint.loop);
    final full = vessel.fire && vessel.genValue >= vessel.genMax * 0.999;
    _streamHintT = full && c.gear == 1 ? _streamHintT + realDt : 0;
    if (_streamHintT > 1.5) hints.offer(SigilHint.stream);
    if (hints.active == SigilHint.stream && c.gear > 1) hints.dismiss();
    return hints.tick(realDt);
  }

  /// Into the arena with the endless ship. Nothing it does is saved.
  void enterArena() {
    if (mode == GameMode.campaign) return;
    _arenaReturn = vessel.toSaveMap();
    mode = GameMode.training;
    arenaStats.reset();
    vessel.caster.onReading = _onArenaReading;
    state = GameState.playing;
    vessel.visible = true;
    vessel.resetVessel();
    vessel.resetPosition();
    vessel.caster.meter.reset();
    lesson = null;
    // The demo shows every sigil, so it must be able to pay for every one.
    if (sigilDemo) arena.infiniteCharge = true;
    _startArenaRound();
    _startSectorMusic();
  }

  /// Apply changed dials: a fresh boss, the ship patched up.
  void restartArenaRound() {
    if (mode != GameMode.training) return;
    vessel.resetVessel();
    vessel.resetPosition();
    _startArenaRound();
  }

  void _startArenaRound() {
    if (arena.gauntlet && capture == null) {
      gauntlet ??= Gauntlet(startParts: arena.bossParts);
    } else {
      gauntlet = null;
    }
    loadSector(0);
    vessel.caster.meter.infinite = arena.infiniteCharge;
    vessel.caster.grantCompanions(arena.companions);
    _setupDrill();
  }

  /// The boss beaten: the next one, straight away.
  void _arenaBossDown() {
    arenaStats.bossDown();
    gauntlet?.bossDown(vessel.caster.meter.flow);
    showMessage('${arenaStats.bosses}×');
    vessel.shield = vessel.shieldMax;
    _startArenaRound();
  }

  /// The ship would have died. The arena patches it up and counts it.
  bool arenaKnockout(Vessel v) {
    if (mode != GameMode.training) return false;
    arenaStats.knockouts++;
    if (gauntlet != null) {
      _gauntletOver();
      return true;
    }
    v.hp = v.hpMax;
    v.shield = v.shieldMax;
    v.dmgTaken = 4;
    showMessage('K.O. ${arenaStats.knockouts}');
    return true;
  }

  /// Back to the endless ship, exactly as it went in.
  void leaveArena() {
    if (mode != GameMode.training) return;
    _leaveMission();
    vessel.caster.onReading = _onFieldReading;
    vessel.caster.meter.infinite = false;
    vessel.caster.countOnly = false;
    ghost = null;
    lesson = null;
    SigilMastery.instance.save();
    final back = _arenaReturn;
    if (back != null) vessel.loadFromSave(back);
    _arenaReturn = null;
    mode = GameMode.endless;
    MusicService.instance.setPaused(false);
    MusicService.instance.stop();
    state = GameState.comCenter;
  }

  Sector _arenaSector() {
    final g = gauntlet;
    return g == null
        ? arena.sector(Campaign.poweredDps(vessel))
        : arena.sector(Campaign.poweredDps(vessel), parts: g.parts, hpMul: g.hpMul);
  }

  /// The endless boss run, when the dial is on.
  Gauntlet? gauntlet;
  int gauntletBest = 0;
  static const _gauntletKey = 'gauntlet_best';

  void _gauntletOver() {
    final g = gauntlet!;
    g.knockout();
    if (g.rating > gauntletBest) {
      gauntletBest = g.rating;
      SharedPreferences.getInstance().then((p) => p.setInt(_gauntletKey, gauntletBest));
    }
    showMessage('GAUNTLET ${g.rating}');
    gauntlet = Gauntlet(startParts: arena.bossParts);
    vessel.resetVessel();
    vessel.resetPosition();
    _startArenaRound();
  }

  /// Sector.complete is a one-way latch and the ComCenter only opens two
  /// seconds later, so without this the whole end-of-sector block ran on every
  /// frame of that window — ~120 times at 60fps, ~240 on a 120Hz display. That
  /// paid the sector bonus and queued advanceToNextSector once per frame, so
  /// finishing sector 1 landed the player at sector ~121 with ~120x the
  /// credits, and restarted the victory fanfare every 70ms. Reset in
  /// [loadSector], which is the only way a new sector begins.
  bool _sectorCompleteFired = false;

  /// Any hull HP lost during the current sector — the "untouchable"
  /// achievement checks this on sector completion. Set by Vessel.
  bool sectorHullDamage = false;
  double elapsed = 0;
  double _osdTimer = 0;

  // FPS counter support
  int frameCount = 0;

  int get hostileCount {
    int count = 0;
    for (final f in activeFleets) {
      count += f.hostiles.length;
    }
    return count;
  }

  /// True while any active fleet has a living boss-tier hostile (boss music).
  bool get bossActive {
    for (final f in activeFleets) {
      if (f.hasActiveBoss) return true;
    }
    return false;
  }

  /// The living phased boss, if one is on the field (drives the boss HP bar).
  Boss? get activeBoss {
    for (final f in activeFleets) {
      for (final h in f.hostiles) {
        if (h is Boss && !h.isDead) return h;
      }
    }
    return null;
  }

  /// That boss's pieces, dead ones included — the HP bar shows one pip each
  /// so the player can see what is still bolted on.
  List<BossPart> get activeBossParts => activeBoss?.parts ?? const [];

  /// Adaptive-music director — created in onLoad, ticked while playing.
  MusicDirector? musicDirector;

  int get projectileCount {
    int count = enemyProjectiles.length;
    for (final v in allVessels) {
      for (final d in v.allGuns) {
        count += d.projectiles.length;
      }
    }
    return count;
  }

  int get explosionCount => explosionRenderer.activeCount;

  // Callbacks for Flutter overlay UI
  VoidCallback? onOsdUpdate;
  VoidCallback? onGameOver;
  VoidCallback? onShowComCenter;
  VoidCallback? onSectorComplete;
  VoidCallback? onLoaded;
  VoidCallback? onPauseToggle;
  VoidCallback? onSkinRequested;
  bool skinSelectorOpen = false;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {
    _applyViewportLayout();

    await AssetLibrary.instance.loadAll();

    starfield = Starfield();
    world.add(starfield);

    parallaxBg = ParallaxBackground();
    parallaxBg.loadLayers();
    world.add(parallaxBg);

    // Batch renderers — draw entities via canvas.drawAtlas() instead of
    // individual sprite.render() calls. Order = visual layering.
    world.add(StructureBatchRenderer());
    world.add(HostileBatchRenderer());
    world.add(ProjectileBatchRenderer());
    world.add(ShardBatchRenderer());

    beamRenderer = BeamRenderer();
    world.add(beamRenderer);

    explosionRenderer = ExplosionRenderer();
    world.add(explosionRenderer);

    deathEffects = DeathEffectRenderer();
    world.add(deathEffects);

    vessel = Vessel();
    await vessel.init();
    world.add(vessel);
    vessel.caster.onGrimoire = openGrimoire;
    vessel.caster.onReading = _onFieldReading;

    // Debug: screen/viewport info
    print('[LAYOUT] FlameGame.size: ${size.x} x ${size.y}');
    print('[LAYOUT] gameWidth: ${config.gameWidth}, gameHeight: ${config.gameHeight}');
    print('[LAYOUT] landscape: ${platform.isLandscape}');

    // Shader pipeline
    shaderPipeline = ShaderPipeline();
    final skinId = AssetLibrary.instance.skinId;
    final skinInfo = kSkins.firstWhere((s) => s.id == skinId,
        orElse: () => kSkins.first);
    shaderPipeline.configure(skinInfo.shaderConfig);
    camera.postProcess = shaderPipeline.build();

    // Start in comCenter state
    state = GameState.comCenter;
    vessel.visible = false;
    musicDirector = MusicDirector(this);

    // Re-point every live entity the instant a skin's atlas is swapped.
    // Registered last, because refreshSprites touches `vessel` and the
    // parallax, which only exist by this point.
    AssetLibrary.instance.onSkinAssetsChanged = refreshSprites;

    isLoaded = true;
    onLoaded?.call();
  }

  /// (Re)compute the aspect-dependent play-field height + camera viewport from
  /// the current [size].
  ///
  /// On iOS cold start the very first layout pass can report a 0×0 game size.
  /// Deriving `gameHeight = gameWidth * size.y / size.x` from it yields NaN
  /// (0/0), which corrupts the viewport and the vessel spawn — `resetPosition`
  /// then places the ship at (300, NaN), collapsing its transform to (0,0) so it
  /// renders in the top-left corner, off-screen. Android reports a valid size
  /// immediately, hence iOS-only. We only overwrite `gameHeight` when the size
  /// is valid; [onGameResize] re-runs this once a real size arrives.
  void _applyViewportLayout() {
    final valid = size.x > 0 && size.y > 0;
    if (platform.isLandscape) {
      // Desktop landscape: game height scales with screen WIDTH (fills after -90° rotation)
      if (valid) config.gameHeight = config.gameWidth * (size.x / size.y);

      camera.viewport = FixedResolutionViewport(
        resolution: Vector2(config.gameHeight, config.gameWidth), // landscape dims
      );
      camera.viewfinder.anchor = Anchor.center;
      camera.viewfinder.position =
          Vector2(config.gameWidth / 2, config.gameHeight / 2);
      // Game UP → screen LEFT: the ship flies right to left.
      camera.viewfinder.angle = platform.landscapeCameraAngle;
    } else {
      // Mobile portrait: width=600, height scaled to device aspect ratio
      if (valid) {
        config.gameHeight = config.gameWidth * (size.y / size.x);
        if (config.gameHeight < config.gameWidth) {
          config.gameHeight = config.gameWidth;
        }
      }

      camera.viewport = FixedResolutionViewport(
        resolution: Vector2(config.gameWidth, config.gameHeight),
      );
      if (config.immersiveCameraEnabled) {
        // Immersive experiment: zoom in so only ~immersiveVisibleFraction of the
        // play field is visible; the field stays gameWidth wide (VB6 parity), the
        // camera pans within it (see _updateImmersiveCamera). Centre anchor makes
        // the follow math symmetric.
        camera.viewfinder.anchor = Anchor.center;
        camera.viewfinder.zoom = 1.0 / config.immersiveVisibleFraction;
        camera.viewfinder.position =
            Vector2(config.gameWidth / 2, config.gameHeight / 2);
      } else {
        camera.viewfinder.anchor = Anchor.topLeft;
        camera.viewfinder.position = Vector2.zero();
      }
    }

    // Both branches above replace the viewport object outright, which discards
    // whatever was attached to the old one — so anything living in the viewport
    // has to be re-attached here rather than once in onLoad. On iOS the cold
    // start always lands here a second time (see the 0x0 guard), which is how
    // the edge markers silently disappeared.
    camera.viewport.add(OffscreenEnemyMarkers());
    camera.viewport.add(SigilHud());
  }

  /// Sigils exist on this machine with this pad scheme — the arena is offered.
  bool get sigilsAvailable =>
      platform.isDesktop && PadSettings.scheme == PadScheme.sigil;

  /// Right-stick combat is on (Prompts/28): desktop, the sigil scheme, solo.
  /// Co-op keeps the classic pad until the protocol carries sigil state.
  bool get sigilsEnabled =>
      platform.isDesktop &&
      PadSettings.scheme == PadScheme.sigil &&
      coopRole == CoopRole.none &&
      vessel2 == null;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Re-apply the aspect-dependent layout once a real size arrives — covers the
    // iOS cold-start case where onLoad computed the play field from a 0×0 size
    // (see _applyViewportLayout). Never mid-play, to avoid snapping the live
    // camera/vessel; the idle vessel is re-homed so the next startGame spawns it
    // correctly.
    if (!isLoaded) return;
    if (size.x <= 0 || size.y <= 0) return;
    if (state == GameState.playing || state == GameState.paused) return;
    _applyViewportLayout();
    if (!vessel.visible) vessel.resetPosition();
  }

  /// Re-fetch sprites on all entities after a skin change.
  void refreshSprites() {
    vessel.refreshSprite();
    vessel2?.refreshSprite();
    // Covers a skin change made from the main menu, before any sector loaded.
    requestZoneBackgrounds(currentSectorIndex);
    parallaxBg.setLevel(levelForIndex(currentSectorIndex));
    parallaxBg.loadLayers();

    // Refresh all live entities
    for (final f in activeFleets) {
      for (final h in f.hostiles) {
        h.refreshSprite();
      }
    }
    for (final s in activeStructures) {
      s.refreshSprite();
    }
    for (final v in allVessels) {
      for (final d in v.allGuns) {
        for (final p in d.projectiles) {
          p.refreshSprite();
        }
      }
    }
    for (final p in enemyProjectiles) {
      p.refreshSprite();
    }
    // Pickups are fetched once at spawn and were never on this list, so any
    // still falling kept a Sprite whose image loadSkin had just disposed.
    // Drawing that throws, the world render catch swallows it, and the game
    // ran on as a black screen with a live HUD until the pickup scrolled off
    // — which is why a pause/resume seemed to "fix" it. Reported on the iPad
    // after a switch to the default skin from the pause menu.
    for (final c in activeCollectables) {
      c.refreshSprite();
    }
    // Shards snapshot the dying entity's Sprite (image + source rect) at spawn
    // and cannot be re-pointed at the new atlas, so drop them. A skin switch
    // is already a full stall; nobody misses a second of debris.
    shardPool.clearAll();

    // Reconfigure shaders for new skin
    final skinId = AssetLibrary.instance.skinId;
    final skinInfo = kSkins.firstWhere((s) => s.id == skinId,
        orElse: () => kSkins.first);
    shaderPipeline.configure(skinInfo.shaderConfig);
  }

  void startGame() {
    state = GameState.playing;
    vessel.visible = true;
    vessel.resetPosition();
    if (vessel2 != null) {
      // Re-clone P1 stats onto P2 before each sector
      _cloneVesselStats(vessel, vessel2!);
      vessel2!.visible = true;
      vessel2!.resetPosition();
      // Offset P2 slightly to the right of P1
      vessel2!.position.x += 60;
    }
    // Notify client that game is starting
    if (coopRole == CoopRole.host && coopHost != null && coopHost!.hasClient) {
      coopHost!.sendEvent(EventType.gameStart);
    }
    loadSector(currentSectorIndex);
    _startSectorMusic();
    // After loadSector, which resets the node's counters.
    campaignTracker?.onLaunch(vessel);
    AchievementService.instance
        .onMissionStarted(AssetLibrary.instance.skinId, isCoop: isCoop);
  }

  /// Kick off the heroic intro + reset the adaptive-music director for a sector.
  void _startSectorMusic() {
    musicDirector?.reset();
    MusicService.instance.startSector();
  }

  void loadSector(int index) {
    _sectorCompleteFired = false;
    // Clean up previous sector
    _clearActiveObjects();
    currentSector?.removeFromParent();

    currentSector = switch (mode) {
      GameMode.campaign => Campaign.buildNode(index, this),
      GameMode.training => _arenaSector(),
      GameMode.endless => Sector.create(index, this),
    };
    if (currentSector != null) {
      world.add(currentSector!);
    }
    currentSectorIndex = index;
    // Difficulty level, not sector index — several sectors can share a level.
    // lvlNum feeds the max-level weapon payout (sectorLevel * 125000 in
    // Device), so paying it out per index would inflate the economy.
    final level = currentSector?.level ?? levelForIndex(index);
    vessel.lvlNum = level;
    if (vessel2 != null) vessel2!.lvlNum = level;
    requestZoneBackgrounds(index);
    parallaxBg.setLevel(level);
    sectorHullDamage = false;
    elapsed = 0;
    campaignTracker?.beginNode(index, credits: vessel.credit);
  }

  /// Fire-and-forget background zone swap. Deliberately not awaited: loadSector
  /// is synchronous and must stay that way, and ParallaxBackground keeps
  /// rendering the previous zone until the new images decode. The ComCenter
  /// sits between sectors, so in practice the load always finishes unseen.
  /// Takes a sector index and resolves the art zone here, so every caller can
  /// keep passing the index it already has.
  void requestZoneBackgrounds(int sectorIndex) {
    unawaited(AssetLibrary.instance.loadZoneBackgrounds(zoneForIndex(sectorIndex)));
  }

  void _clearActiveObjects() {
    enemyTimeScale = 1.0;
    _timewarpLeft = 0;
    for (final f in [...activeFleets]) {
      // Remove hostiles first — they're world children, not fleet children
      for (final h in [...f.hostiles]) {
        h.removeFromParent();
      }
      f.hostiles.clear();
      f.removeFromParent();
    }
    activeFleets.clear();
    for (final s in [...activeStructures]) {
      s.removeFromParent();
    }
    activeStructures.clear();
    for (final c in [...activeCollectables]) {
      c.removeFromParent();
    }
    activeCollectables.clear();
    explosionRenderer.clearAll();
    deathEffects.clearAll();
    shardPool.clearAll();
    for (final p in [...enemyProjectiles]) {
      p.removeFromParent();
    }
    enemyProjectiles.clear();
    // Clear player projectiles (world children via devices)
    for (final v in allVessels) {
      v.caster.reset();
      for (final d in v.allGuns) {
        for (final p in [...d.projectiles]) {
          p.removeFromParent();
        }
        d.clearProjectiles();
      }
    }
  }

  /// One throwing component aborts the whole world render: update() keeps
  /// running (HUD counters tick) while the canvas stays black — reported once
  /// on Android after a death redeploy, unreproducible from code reading.
  /// Catching here keeps the next frame trying instead of freezing black, and
  /// the throttled print reaches adb logcat in release builds, so if it ever
  /// happens again the stack finally names the culprit.
  double _lastRenderErrorLog = 0;

  @override
  void render(Canvas canvas) {
    try {
      super.render(canvas);
    } catch (e, st) {
      if (elapsed - _lastRenderErrorLog > 5.0 || _lastRenderErrorLog == 0) {
        _lastRenderErrorLog = elapsed == 0 ? 0.001 : elapsed;
        // ignore: avoid_print
        print('[RENDER] world render threw: $e\n$st');
      }
    }
  }

  late final FrameCapture? _capture =
      FrameCapture.enabled ? FrameCapture(this) : null;

  @override
  void update(double dt) {
    frameCount++;
    _capture?.tick(dt);
    // Filming runs off the wall clock: one fixed step per frame on disk.
    final cap = capture;
    if (cap != null) {
      if (cap.busy || cap.finished) return;
      dt = CaptureDirector.step;
    }
    // The pad is polled on the wall clock; the arena's world runs at its own.
    _pollPad(dt);
    var inputDt = dt;
    final hintSlow = _sigilHints(dt);
    if (hintSlow != 1) {
      dt *= hintSlow;
      inputDt = dt;
    }
    if (mode == GameMode.training) {
      final s = arenaSpeed;
      dt *= s;
      // A standing world still reads the stick, at the wall clock.
      inputDt = s > 0 ? dt : inputDt;
      if (state == GameState.playing) {
        arenaStats.tick(dt);
        kataRun?.tick(dt);
        if (_kataRestart > 0) {
          _kataRestart -= dt;
          if (_kataRestart <= 0 && arena.kata != null) {
            kataRun = KataRun(arena.kata!);
          }
        }
      }
    }
    // Client mode: apply snapshots, then call super.update for component mounting/rendering
    if (coopRole == CoopRole.client) {
      final snap = coopClient?.latestSnapshot;
      if (snap != null) {
        try {
          applySnapshot(snap);
        } catch (_) {}
        coopClient!.latestSnapshot = null;
      }
      super.update(dt);
      shardPool.update(dt);
      _updateWorldShift(dt);
      return;
    }

    // Desktop keyboard + gamepad input (handles pause toggle even when paused)
    _processDesktopInput(inputDt);

    // Only the `playing` state runs the full simulation. paused, comCenter AND
    // gameOver keep just the visual backdrop alive — previously gameOver was
    // missing here, so after death enemies kept spawning and firing (audible
    // SFX "as if the game continued") and the loop ran forever, flooding the
    // audio sink with AudioTrack write failures even in the background.
    if (state != GameState.playing) {
      starfield.update(dt);
      parallaxBg.update(dt);
      return;
    }

    if (_timewarpLeft > 0) {
      _timewarpLeft -= dt;
      if (_timewarpLeft <= 0) enemyTimeScale = 1.0;
    }
    super.update(dt);
    elapsed += dt;
    if (mode != GameMode.training) AchievementService.instance.addPlayTime(dt);
    shardPool.update(dt);
    _updateWorldShift(dt);

    // Update beam renderer with vessel data
    beamRenderer.vessel = vessel;
    beamRenderer.vessel2 = vessel2;
    beamRenderer.activeFleets = activeFleets;
    beamRenderer.worldShiftX = worldShiftX;

    // Periodic OSD refresh (~4Hz)
    _osdTimer += dt;
    if (_osdTimer >= 0.25) {
      _osdTimer = 0;
      onOsdUpdate?.call();
    }

    // Update enemy projectiles — collision with vessel
    _updateEnemyProjectiles();

    // Collectable pickup — manual AABB (replaces Flame CollisionCallbacks)
    _checkCollectablePickup();

    // Feed damage flash into shader pipeline (after projectile collision)
    double maxFlash = 0;
    for (final v in allVessels) {
      if (v.dmgTaken > 0) {
        final flash = v.dmgTaken / 4.0; // 4 = max dmgTaken frames
        if (flash > maxFlash) maxFlash = flash;
      }
    }
    shaderPipeline.setDamageFlash(maxFlash);

    // Adaptive music: re-evaluate intensity and advance tier crossfades.
    musicDirector?.update(dt);
    MusicService.instance.update(dt);

    // Immersive experiment: pan the zoomed-in camera to follow the vessel.
    _updateImmersiveCamera(dt);

    // Check sector completion — once per sector, see _sectorCompleteFired.
    if (currentSector != null &&
        currentSector!.isComplete &&
        !_sectorCompleteFired) {
      _sectorCompleteFired = true;
      _onSectorComplete();
    }

    // Host mode: send snapshot to client after each frame
    if (coopRole == CoopRole.host && coopHost != null && coopHost!.hasClient) {
      try {
        coopHost!.sendSnapshot(extractSnapshot());
      } catch (_) {}
    }

    capture?.afterStep();
  }

  /// Immersive experiment (Feature 1): dead-zone camera follow.
  ///
  /// The play field stays [config.gameWidth]×[config.gameHeight] (VB6 parity);
  /// the zoomed-in viewfinder pans within it so the visible window never leaves
  /// the field (background always covers, no empty edges). Motion is primarily
  /// horizontal — the vertical dead zone is larger so it only nudges the ship
  /// back into frame near the top/bottom. Portrait only; landscape unchanged.
  void _updateImmersiveCamera(double dt) {
    if (!config.immersiveCameraEnabled || platform.isLandscape) return;

    final zoom = camera.viewfinder.zoom;
    final halfW = (config.gameWidth / zoom) / 2;
    final halfH = (config.gameHeight / zoom) / 2;
    final cam = camera.viewfinder.position;

    // Dead zone: only chase the vessel once it strays beyond a central box.
    final dzx = config.immersiveDeadZoneX * halfW;
    double targetX = cam.x;
    final dxOff = vessel.position.x - cam.x;
    if (dxOff > dzx) {
      targetX = vessel.position.x - dzx;
    } else if (dxOff < -dzx) {
      targetX = vessel.position.x + dzx;
    }

    final dzy = config.immersiveDeadZoneY * halfH;
    double targetY = cam.y;
    final dyOff = vessel.position.y - cam.y;
    if (dyOff > dzy) {
      targetY = vessel.position.y - dzy;
    } else if (dyOff < -dzy) {
      targetY = vessel.position.y + dzy;
    }

    // Clamp the window inside the field.
    targetX = targetX.clamp(halfW, config.gameWidth - halfW);
    targetY = targetY.clamp(halfH, config.gameHeight - halfH);

    // Smooth ease toward the target. NOTE: viewfinder.position's getter returns
    // a *copy* (`-transform.offset`), so mutating it in place is a no-op — we
    // must assign a fresh Vector2 to invoke the setter.
    final t = min(1.0, config.immersiveCameraLerp * dt);
    camera.viewfinder.position = Vector2(
      cam.x + (targetX - cam.x) * t,
      cam.y + (targetY - cam.y) * t,
    );
  }

  void _onSectorComplete() {
    if (mode == GameMode.training) return _arenaBossDown();
    SoundService.instance.play(SfxEvent.sectorComplete);
    MusicService.instance.stop(); // duck soundtrack for the victory fanfare + ComCenter

    if (mode == GameMode.campaign) {
      final node = kCampaignNodes[currentSectorIndex];
      final result = campaignTracker!.evaluate(
        node: node,
        vessel: vessel,
        hullDamage: sectorHullDamage,
        elapsed: elapsed,
      );
      lastNodeResult = result;
      lastNodeUnlock = null;
      lastNodeReward = ModReward.nothing;
      if (result.requiredMet) {
        lastNodeUnlock = Campaign.applyBossUnlock(node, vessel);
        final c = campaign;
        final finishes = c != null &&
            {...c.completed, currentSectorIndex}.length >= Campaign.nodeCount;
        lastNodeReward = ModRewards.campaignNode(
          state: ModsState.instance,
          node: node,
          result: result,
          campaignFinished: finishes,
          challengeId: challenge.id,
          fitted: vessel.fittedMods,
        );
        if (!lastNodeReward.isEmpty) ModsState.instance.save();
        // The first successful clear pays the sector bonus; a replay for stars
        // earns only what it shoots down, or the bonus would be farmable. A
        // run that reached the end without its required tasks pays nothing —
        // it did not clear the node. Endless achievements and the depth board
        // stay out of the campaign entirely.
        if (!(campaign?.isCompleted(currentSectorIndex) ?? false)) {
          vessel.credit += currentSector!.sectorBonus;
        }
      }
      onSectorComplete?.call();
      return;
    }

    AchievementService.instance.onSectorCompleted(
      // Level of the sector the player advances to — with three parts per
      // level, finishing Inner Zone II must not claim "reached sector 3".
      // Under the old one-sector-per-level table this equals the old
      // completedSector + 1, so pre-v2.4 progress semantics are unchanged.
      Sector.levelForIndex(currentSectorIndex + 1),
      tookHullDamage: sectorHullDamage,
    );
    vessel.credit += currentSector!.sectorBonus;
    if (vessel2 != null) vessel2!.credit += currentSector!.sectorBonus;
    if (coopRole != CoopRole.client) {
      _announceReward(ModRewards.endlessDepth(
          state: ModsState.instance,
          cleared: currentSectorIndex + 1,
          fitted: vessel.fittedMods));
    }

    // Revive dead vessels for ComCenter
    if (isCoop) {
      if (!vessel.visible || vessel.hp <= 0) {
        vessel.visible = true;
        vessel.hp = 1; // Barely alive — player should heal in shop
      }
      if (vessel2 != null && (!vessel2!.visible || vessel2!.hp <= 0)) {
        vessel2!.visible = true;
        vessel2!.hp = 1;
      }
    }

    if (coopRole == CoopRole.host && coopHost != null) {
      coopHost!.sendEvent(EventType.sectorComplete);
    }

    onSectorComplete?.call();
  }

  void advanceToNextSector() {
    currentSectorIndex++;
    loadSector(currentSectorIndex);
  }

  /// Easter-egg sector jump from the ComCenter. Rebuilds the target sector so
  /// the next "start mission" plays it. Indices beyond the defined sectors
  /// generate random sectors (handled by Sector.create).
  void jumpToSector(int index) {
    if (index < 0) return;
    if (mode == GameMode.campaign && index >= Campaign.nodeCount) return;
    loadSector(index);
  }

  /// Persist the player's between-sector progress (credits, weapons, stats,
  /// pilot name, current sector). Fire-and-forget from the ComCenter.
  ///
  /// Dispatches on [mode] first: the ComCenter and main.dart call this from
  /// a dozen places, and every one of them would otherwise write the campaign
  /// vessel over the endless run's save.
  Future<void> saveProgress() async {
    if (coopRole == CoopRole.client) return; // client mirrors host, never owns state
    if (mode == GameMode.training) return; // the arena borrows; it never writes
    if (mode == GameMode.campaign) return _saveCampaignProgress();
    final m = vessel.toSaveMap();
    await SaveService.saveGameState(
      pilotName: m['pilotName'] as String,
      credit: m['credit'] as int,
      score: m['score'] as int,
      hp: m['hp'] as int,
      hpMax: m['hpMax'] as int,
      shield: (m['shield'] as num).toDouble(),
      shieldMax: (m['shieldMax'] as num).toDouble(),
      genMax: (m['genMax'] as num).toDouble(),
      genPower: (m['genPower'] as num).toDouble(),
      level: currentSectorIndex,
      nextWeaponLevel: m['nextWeaponLevel'] as int,
      weapons: List<Map<String, dynamic>>.from(m['weapons'] as List),
      hangar: List<Map<String, dynamic>>.from(m['hangar'] as List),
    );
  }

  /// Restore saved progress at startup. Returns true if a saved game was loaded.
  Future<bool> loadProgress() async {
    // Awaited once at startup; from here on Challenge.selected is a plain
    // static read on the hot path.
    await Challenge.init();
    await PadSettings.init();
    await SigilMastery.instance.load();
    await SigilHints.instance.load();
    await _loadKataBest();
    gauntletBest =
        (await SharedPreferences.getInstance()).getInt(_gauntletKey) ?? 0;
    // Before any ship loads: a ship's racks take their mods out of the vault.
    await ModsState.instance.load();
    final state = await SaveService.loadGameState();
    if (state == null) return false;
    vessel.loadFromSave(state);
    final rawIndex = (state['level'] as num?)?.toInt() ?? 0;
    final version = (state['saveVersion'] as num?)?.toInt() ?? 1;
    // v1 saves predate the 18-part table: 'level' held one-sector-per-level
    // indices, so an old run resumes at the first part of its level.
    currentSectorIndex =
        version >= SaveService.saveVersion ? rawIndex : Sector.migrateLegacyIndex(rawIndex);
    // onLoad's loadLayers() ran before the save was read, so a run resumed deep
    // in the game would otherwise come back with zone 0's art. Awaiting is free
    // here — loadProgress is already awaited during startup.
    await AssetLibrary.instance
        .loadZoneBackgrounds(Sector.zoneForIndex(currentSectorIndex));
    parallaxBg.setLevel(Sector.levelForIndex(currentSectorIndex));
    return true;
  }

  /// Roguelike death: rewind to the first sector while keeping everything the
  /// pilot earned — weapons, credits, cumulative score, upgraded stats and the
  /// codename. Contrast [resetForNewGame], which wipes the vessel back to a
  /// stock Bubble Gun and is only for starting over from nothing.
  void restartRun() {
    _clearActiveObjects();
    currentSector?.removeFromParent();
    currentSector = null;
    currentSectorIndex = 0;
    requestZoneBackgrounds(0);
    parallaxBg.setLevel(1);
    vessel.resetVessel();
    vessel.resetPosition();
    elapsed = 0;
  }

  /// Reset all game state for a fresh new game.
  void resetForNewGame() {
    _clearActiveObjects();
    currentSector?.removeFromParent();
    currentSector = null;
    currentSectorIndex = 0;
    requestZoneBackgrounds(0);
    parallaxBg.setLevel(1);
    vessel.newGame();
    elapsed = 0;
  }

  // ── Campaign ──

  Future<void> _saveCampaignProgress() async {
    final c = campaign;
    if (c == null) return;
    c.vessel = vessel.toSaveMap();
    await SaveService.saveCampaignState(c.toJson());
  }

  /// Switch to the campaign: its own vessel and progress, restored from the
  /// campaign save or started from a stock ship. The endless vessel state is
  /// simply replaced — it lives in its own save and returns via
  /// [enterEndless].
  Future<void> enterCampaign() async {
    _leaveMission();
    mode = GameMode.campaign;
    campaignTracker = CampaignTracker();
    lastNodeResult = null;
    final saved = await SaveService.loadCampaignState();
    if (saved == null) {
      // newGame() also rolls a fresh codename; the pilot is the same person.
      final name = vessel.pilotName;
      vessel.newGame(returnMods: false);
      vessel.pilotName = name;
      // The menu's current pick becomes this campaign's challenge for good.
      campaign = CampaignState(
          vessel: vessel.toSaveMap(), challenge: Challenge.selected);
    } else {
      campaign = CampaignState.fromJson(saved);
      vessel.loadFromSave(campaign!.vessel);
    }
    currentSectorIndex = campaign!.currentNode;
    requestZoneBackgrounds(currentSectorIndex);
    parallaxBg.setLevel(levelForIndex(currentSectorIndex));
    state = GameState.comCenter;
  }

  /// Back to the endless run. Returns whether a saved run was restored; with
  /// nothing restored the caller starts from stock via [resetForNewGame].
  Future<bool> enterEndless() async {
    _leaveMission();
    mode = GameMode.endless;
    campaign = null;
    campaignTracker = null;
    lastNodeResult = null;
    return loadProgress();
  }

  /// Build a campaign node and open the shop in front of it; the ComCenter's
  /// START then resumes into the already-built sector.
  void launchCampaignNode(int index) {
    currentSectorIndex = index;
    loadSector(index);
    vessel.resetPosition();
    openComCenter();
  }

  /// Campaign death: the same node again, through the shop, keeping what the
  /// attempt earned. No rewind — that is the endless loop's rule.
  void retryNode() {
    _leaveMission();
    loadSector(currentSectorIndex);
    vessel.resetVessel();
    vessel.resetPosition();
    state = GameState.comCenter;
  }

  /// Close out a finished node: a cleared one is recorded and opens the next,
  /// a failed one leaves the campaign where it was. Either way the field is
  /// cleared, because the result card takes the screen from here.
  void finishCampaignNode(NodeResult result) {
    if (result.requiredMet) {
      campaign?.markCompleted(currentSectorIndex,
          starsEarned: result.starsEarned);
    }
    _leaveMission();
    state = GameState.comCenter;
  }

  /// Leave whatever is on the field, for the main menu or a mode switch.
  /// Progress since the last save is dropped, exactly as a death drops it.
  void abandonMission() {
    _leaveMission();
    vessel.resetVessel();
    MusicService.instance.setPaused(false);
    MusicService.instance.stop();
    state = GameState.comCenter;
  }

  void _leaveMission() {
    _clearActiveObjects();
    currentSector?.removeFromParent();
    currentSector = null;
    elapsed = 0;
  }

  void openComCenter() {
    state = GameState.comCenter;
    onShowComCenter?.call();
  }

  void resumeFromComCenter() {
    // Re-clone P1 stats onto P2 before each sector (host upgraded in ComCenter)
    if (vessel2 != null && coopRole == CoopRole.host) {
      _cloneVesselStats(vessel, vessel2!);
      vessel2!.visible = true;
      vessel2!.resetPosition();
      vessel2!.position.x += 60;
    }
    state = GameState.playing;
    // Notify client that game is starting
    if (coopRole == CoopRole.host && coopHost != null && coopHost!.hasClient) {
      coopHost!.sendEvent(EventType.gameStart);
    }
    _startSectorMusic();
    // The shop has just closed, so this is the loadout the node is flown with
    // — what every loadout task is graded against.
    campaignTracker?.onLaunch(vessel);
  }

  void togglePause() {
    if (state == GameState.playing) {
      state = GameState.paused;
      MusicService.instance.setPaused(true);
      if (coopRole == CoopRole.host && coopHost != null) {
        coopHost!.sendEvent(EventType.paused);
      }
    } else if (state == GameState.paused) {
      state = GameState.playing;
      MusicService.instance.setPaused(false);
      if (coopRole == CoopRole.host && coopHost != null) {
        coopHost!.sendEvent(EventType.resumed);
      }
    }
    onPauseToggle?.call();
  }

  void triggerGameOver() {
    SoundService.instance.play(SfxEvent.gameOver);
    MusicService.instance.stop();
    state = GameState.gameOver;
    onGameOver?.call();
  }

  /// In co-op: game over only when both vessels are dead
  void checkCoopGameOver() {
    final p1Dead = !vessel.visible || vessel.hp <= 0;
    final p2Dead = vessel2 == null || !vessel2!.visible || vessel2!.hp <= 0;
    if (p1Dead && p2Dead) {
      triggerGameOver();
    }
  }

  /// Returns X position of nearest visible vessel to a point (for structure targeting)
  double nearestVesselX(double x, double y) {
    if (vessel2 == null || !vessel2!.visible) return vessel.position.x;
    if (!vessel.visible) return vessel2!.position.x;
    final d1 = (vessel.position.x - x).abs() + (vessel.position.y - y).abs();
    final d2 = (vessel2!.position.x - x).abs() + (vessel2!.position.y - y).abs();
    return d1 <= d2 ? vessel.position.x : vessel2!.position.x;
  }

  // Touch input — delta-based so finger and vessel move in sync
  Vector2? _prevDragPos;

  // Client touch target position (for sending to host)
  double _clientTargetX = config.gameWidth / 2;
  double _clientTargetY = config.gameHeight * 0.75;
  bool _clientFire = false;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (state != GameState.playing) return;
    _prevDragPos = event.canvasPosition.clone();

    if (coopRole == CoopRole.client) {
      _clientFire = true;
    } else {
      vessel.fire = true;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (state != GameState.playing || _prevDragPos == null) return;
    final pos = event.canvasEndPosition;
    final delta = pos - _prevDragPos!;
    _prevDragPos = pos.clone();

    // Divide by camera zoom so a finger drag still moves the vessel 1:1 on screen
    // when the immersive camera is zoomed in (zoom is 1.0 otherwise → no-op).
    final scale = config.gameWidth / size.x / camera.viewfinder.zoom;

    if (coopRole == CoopRole.client) {
      // Client: compute target and send to host
      _clientTargetX += delta.x * scale;
      _clientTargetY += delta.y * scale;
      // Clamp to screen
      _clientTargetX = _clientTargetX.clamp(0, config.gameWidth);
      _clientTargetY = _clientTargetY.clamp(0, config.gameHeight);
      coopClient?.sendInput(_clientTargetX, _clientTargetY, _clientFire);
    } else {
      vessel.adjustPosition(
        vessel.position.x + delta.x * scale,
        vessel.position.y + delta.y * scale,
      );
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (state != GameState.playing) return;
    _prevDragPos = null;

    if (coopRole == CoopRole.client) {
      _clientFire = false;
      coopClient?.sendInput(_clientTargetX, _clientTargetY, false);
    } else {
      vessel.fire = false;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (state != GameState.playing) return;

    if (coopRole == CoopRole.client) {
      _clientFire = !_clientFire;
      coopClient?.sendInput(_clientTargetX, _clientTargetY, _clientFire);
    } else {
      vessel.fire = !vessel.fire;
    }
  }

  // ── Keyboard input (desktop) ──────────────────────────────

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    keyboardInput.handleKeyEvent(event);
    return KeyEventResult.handled;
  }

  /// Desktop movement speed (game units per second).
  static const double _kbSpeed = 300.0;

  bool _prevPauseKey = false;
  bool _prevSkinGp = false;

  /// Call after ComCenter's Start button triggers game launch so TyrianGame
  /// doesn't also interpret that same press as "open skin selector".
  void suppressStartEdge() => _prevSkinGp = true;

  /// Apply screen-space input to vessel (handles landscape inverse rotation).
  void _applyMovement(Vessel v, double screenDx, double screenDy, double speed, double dt) {
    speed *= v.agility;
    final (gx, gy) = platform.screenToGame(screenDx, screenDy);
    v.adjustPosition(
      v.position.x + gx * speed * dt,
      v.position.y + gy * speed * dt,
    );
  }

  /// Poll the gamepad (~60Hz to avoid MethodChannel overhead).
  void _pollPad(double realDt) {
    if (!platform.isDesktop) return;
    _gamepadPollTimer += realDt;
    if (_gamepadPollTimer >= 1 / 60) {
      _gamepadPollTimer = 0;
      gamepadInput.poll(); // fire-and-forget async
    }
  }

  /// Process keyboard + gamepad input — called at the start of update().
  void _processDesktopInput(double dt) {
    if (!platform.isDesktop) return;


    // ── Keyboard pause (Escape) ──
    final pauseKb = keyboardInput.pause;
    if (pauseKb && !_prevPauseKey && !skinSelectorOpen) {
      if (state == GameState.playing || state == GameState.paused) togglePause();
    }
    _prevPauseKey = pauseKb;

    // ── Gamepad pause (Start/Option) ──
    // Plain pause toggle; the pause menu overlay in main.dart offers Skins,
    // mute and Quit from there. Previously Start force-opened the skin
    // selector, so a pad had no way to simply pause (Steam plan, Fix 6).
    final skinGp = gamepadInput.primary.pause; // Start = Option on PS, Menu on Xbox
    if (skinGp && !_prevSkinGp && !skinSelectorOpen) {
      if (state == GameState.playing || state == GameState.paused) togglePause();
    }
    _prevSkinGp = skinGp;

    if (state == GameState.paused) return;

    if (state != GameState.playing) return;

    // ── Gamepad P1 (takes priority over keyboard) ──
    final gp = gamepadInput.primary;
    final sigils = sigilsEnabled;
    vessel.caster.enabled = sigils;
    if (sigils) {
      _processSigilPad(gp, dt);
      return;
    }
    final gpDx = GamepadInput.deadzone(gp.leftStickX);
    final gpDy = GamepadInput.deadzone(gp.leftStickY);
    final gpActive = gpDx != 0 || gpDy != 0 || gp.fire;

    if (gpActive) {
      _applyMovement(vessel, gpDx, gpDy, _kbSpeed, dt);
      vessel.fire = gp.fire;
      vessel.fireRateMult = gp.fireRate;
    } else {
      vessel.fireRateMult = 1.0;
      // ── Keyboard fallback ──
      final kbDx = keyboardInput.dx;
      final kbDy = keyboardInput.dy;
      if (kbDx != 0 || kbDy != 0) {
        _applyMovement(vessel, kbDx, kbDy, _kbSpeed, dt);
      }
      vessel.fire = keyboardInput.fire;
    }

    // ── Gamepad P2 (local co-op) ──
    if (vessel2 != null && vessel2!.visible && gamepadInput.controllers.length > 1) {
      final gp2 = gamepadInput.secondary;
      final gp2Dx = GamepadInput.deadzone(gp2.leftStickX);
      final gp2Dy = GamepadInput.deadzone(gp2.leftStickY);
      _applyMovement(vessel2!, gp2Dx, gp2Dy, _kbSpeed, dt);
      vessel2!.fire = gp2.fire;
      vessel2!.fireRateMult = gp2.fireRate;
    }
  }

  final KeyboardSigils _keySigils = KeyboardSigils();

  /// The pad in the sigil scheme (Prompts/28 §3): the left stick or the
  /// keyboard flies, as far as a running sigil leaves the stick free; the
  /// right stick draws; RT fires with its analog cadence.
  void _processSigilPad(GamepadState gp, double dt) {
    final g = mode == GameMode.training ? ghost : null;
    final f = g != null
        ? g.frame(dt)
        : (gamepadInput.isConnected
            ? PadFrame.read(gp, southpaw: PadSettings.southpaw)
            : PadFrame.idle);
    final caster = vessel.caster;
    final typed = _keySigils.update(keyboardInput, dt);
    final both = f.merge(_keySigils.frame(keyboardInput));
    final (sx, sy) = platform.screenToGame(both.drawX, both.drawY);
    caster.input(both, sx, sy, dt);
    if (typed != null) caster.inputDots(typed.$1, typed.$2, typed.$3);

    final padMoves = f.moveX != 0 || f.moveY != 0;
    final mx = padMoves ? f.moveX : keyboardInput.dx;
    final my = padMoves ? f.moveY : keyboardInput.dy;
    final speed = _kbSpeed * (caster.focus ? config.focusSpeed : 1.0);
    switch (caster.control) {
      case SigilControl.none:
        break;
      case SigilControl.verticalOnly:
        final (_, gy) = platform.screenToGame(mx, my);
        vessel.adjustPosition(vessel.position.x,
            vessel.position.y + gy * speed * vessel.agility * dt);
      case SigilControl.full:
        if (mx != 0 || my != 0) _applyMovement(vessel, mx, my, speed, dt);
    }
    vessel.fire = f.fire || keyboardInput.fire;
    vessel.fireRateMult = f.fire ? f.fireRate : 1.0;
  }

  void showMessage(String msg) {
    world.add(FloatText(
      text: msg,
      color: const Color(0xFF00FFFF),
      palette: KidPalette.sky,
      fontSize: 18,
      position: Vector2(config.gameWidth / 2, config.gameHeight * 0.3),
    ));
  }

  bool _projectileHitsVessel(Projectile p, Vessel v) {
    const cf = 0.7; // collision fraction — shrink vessel hitbox for fairness
    final vhx = v.size.x / 2 * cf * v.hitboxScale;
    final vhy = v.size.y / 2 * cf * v.hitboxScale;
    return v.visible &&
        p.position.x < v.position.x + vhx &&
        p.position.x + p.size.x > v.position.x - vhx &&
        p.position.y < v.position.y + vhy &&
        p.position.y + p.size.y > v.position.y - vhy;
  }

  void _updateEnemyProjectiles() {
    for (int i = enemyProjectiles.length - 1; i >= 0; i--) {
      final p = enemyProjectiles[i];
      if (!p.active) {
        enemyProjectiles.removeAt(i);
        continue;
      }
      // Off-screen check
      if (p.position.y > config.gameHeight + 50 || p.position.y < -50) {
        p.removeFromParent();
        enemyProjectiles.removeAt(i);
        continue;
      }
      // Companions that shield the ship take the shot first.
      bool hit = _companionAbsorbs(p);
      // AABB collision with all vessels
      for (final v in allVessels) {
        if (hit) break;
        if (_projectileHitsVessel(p, v)) {
          // A sigil's phase: the shot flies on under the ship, and pays.
          if (v.caster.untouchable) {
            if (!p.grazed) {
              p.grazed = true;
              v.caster.onGraze(phase: true);
            }
            continue;
          }
          if (!v.tryReflect(p)) v.takeDamage(p.damage.toInt());
          hit = true;
          break;
        }
        if (!p.grazed && v.caster.enabled && v.visible && _grazes(p, v)) {
          p.grazed = true;
          v.caster.onGraze(phase: false);
        }
      }
      if (hit) {
        p.removeFromParent();
        enemyProjectiles.removeAt(i);
      }
    }
  }

  /// A miss close enough to count as a graze (Prompts/28 §6.1).
  bool _grazes(Projectile p, Vessel v) {
    final dx = p.position.x + p.size.x / 2 - v.position.x;
    final dy = p.position.y + p.size.y / 2 - v.position.y;
    final r = v.grazeRadius;
    return dx * dx + dy * dy <= r * r;
  }

  bool _companionAbsorbs(Projectile p) {
    for (final v in allVessels) {
      for (final c in v.caster.companions) {
        if (!c.absorbs || c.gone) continue;
        final hx = c.size.x * 0.6, hy = c.size.y * 0.6;
        if (p.position.x < c.position.x + hx &&
            p.position.x + p.size.x > c.position.x - hx &&
            p.position.y < c.position.y + hy &&
            p.position.y + p.size.y > c.position.y - hy) {
          c.takeHit();
          return true;
        }
      }
    }
    return false;
  }

  void _checkCollectablePickup() {
    for (int i = activeCollectables.length - 1; i >= 0; i--) {
      final c = activeCollectables[i];
      for (final v in allVessels) {
        if (!v.visible) continue;
        // Simple AABB overlap
        if (c.position.x < v.position.x + v.size.x / 2 &&
            c.position.x + c.size.x > v.position.x - v.size.x / 2 &&
            c.position.y < v.position.y + v.size.y / 2 &&
            c.position.y + c.size.y > v.position.y - v.size.y / 2) {
          c.applyEffect(v, this);
          campaignTracker?.onPickup();
          break; // applyEffect calls removeCollectable, which removes from list
        }
      }
    }
  }

  /// Spawn an enemy projectile (called from Hostile firing logic)
  void spawnEnemyProjectile(double x, double y, int dmg, double scale,
      {double vx = 0, double speed = 15.0}) {
    final proj = Projectile(
      imgName: 'bubble',
      position: Vector2(x, y),
      speed: speed, // positive = downward
      vx: vx,
      // Every enemy shot in the game is born here — fleets, boss core, boss
      // parts — which is what makes this the one place challenge scales damage.
      damage: dmg * challenge.damage,
      scale: scale,
    )..isEnemy = true;
    enemyProjectiles.add(proj);
    world.add(proj);
  }

  // Spawn helpers used by Sector/Fleet
  void addExplosion(double x, double y, int size) {
    explosionRenderer.acquire(x, y, size);
  }

  /// Client-side death effect from a host explosion event. Empty/legacy text
  /// degrades to the generic explosion. The hostile is looked up before the
  /// removing snapshot lands (the event is sent mid-frame, the snapshot at
  /// frame end, and snapshots apply deferred), so its sprite is still
  /// available for shards; if it is already gone, particles-only.
  void spawnRemoteDeathEffect(double x, double y, String text) {
    if (text.isEmpty) {
      addExplosion(x, y, 2);
      return;
    }
    final parts = text.split(':');
    final family = WeaponFamily.values.asNameMap()[parts[0]];
    if (family == null) {
      addExplosion(x, y, 2);
      return;
    }
    Hostile? h;
    if (parts.length >= 3) {
      final fleetId = int.tryParse(parts[1]);
      final hostileId = int.tryParse(parts[2]);
      if (fleetId != null && hostileId != null) {
        h = clientHostiles[fleetId * 1000 + hostileId];
      }
    }
    deathEffects.spawn(family, x, y, h?.size.x ?? 40.0, h?.size.y ?? 40.0,
        hitX: x, hitY: y);
    if (h != null && h.sprite != null) {
      shardPool.spawn(h.sprite!, x, y, x, y, h.size.x, h.size.y, h.spriteName,
          deathEffectSpecs[family]!.shardPreset);
    }
  }

  void addCollectable(Collectable c) {
    activeCollectables.add(c);
    world.add(c);
  }

  void removeCollectable(Collectable c) {
    activeCollectables.remove(c);
    c.removeFromParent();
  }

  // ==== Co-op setup ====

  /// Initialize as auto-host (every solo game). Vessel2 created on client connect.
  void setupAutoHost(CoopHost host) {
    coopRole = CoopRole.host;
    coopHost = host;

    // Wire up callbacks — vessel2 created lazily on connect
    host.onClientInput = (dx, dy, fire) {
      if (vessel2 != null && vessel2!.visible) {
        vessel2!.adjustPosition(dx, dy);
        vessel2!.fire = fire;
      }
    };

    host.onClientConnected = (pilotName) async {
      print('Host: handshake from $pilotName');
      // Create vessel2 on first connect (or re-use if client reconnects)
      if (vessel2 == null) {
        vessel2 = Vessel(playerIndex: 1);
        vessel2!.pilotName = pilotName;
        await vessel2!.init();
        world.add(vessel2!);
      } else {
        vessel2!.pilotName = pilotName;
      }

      // Clone P1 stats onto P2
      _cloneVesselStats(vessel, vessel2!);

      if (state == GameState.playing) {
        // Mid-game join: spawn visible immediately
        vessel2!.visible = true;
        vessel2!.resetPosition();
        vessel2!.position.x += 60;
      } else {
        // In ComCenter: keep invisible until host starts
        vessel2!.visible = false;
      }

      showMessage(L10n.current.player2Joined);
      onClientJoined?.call();
    };

    host.onClientDisconnected = () {
      vessel2?.visible = false;
      showMessage(L10n.current.player2Disconnected);
      onClientLeft?.call();
    };
  }

  /// Deep-copy stats and weapons from source vessel to target
  void _cloneVesselStats(Vessel src, Vessel dst) {
    // P2 flies the stock hull with empty racks, so it takes P1's stats with
    // P1's mod multipliers divided back out.
    final base = src.toSaveMap();
    dst.hpMax = base['hpMax'] as int;
    dst.hp = base['hp'] as int;
    dst.shieldMax = base['shieldMax'] as double;
    dst.shield = base['shield'] as double;
    dst.shieldRegen = base['shieldRegen'] as double;
    dst.genMax = base['genMax'] as double;
    dst.genPower = base['genPower'] as double;
    dst.genValue = dst.genMax;
    dst.credit = src.credit;
    dst.score = src.score;
    dst.nextWeaponLevel = src.nextWeaponLevel;
    dst.lastMaxDps = src.lastMaxDps;
    dst.lvlNum = src.lvlNum;

    // Clone weapons: clear existing, recreate from same DevTypes at same levels
    for (final d in dst.devices) {
      d.clearProjectiles();
    }
    dst.devices.clear();
    dst.guidedWeapon = false;

    for (final srcDev in src.devices) {
      final wt = _findWeaponType(srcDev.name);
      if (wt == null) continue;
      final newDev = dst.equipWeapon(wt, srcDev.slot);
      for (int i = 0; i < srcDev.level; i++) {
        newDev.upgrade();
      }
    }
    dst.hangar.clear();
    for (final srcDev in src.hangar) {
      final wt = _findWeaponType(srcDev.name);
      if (wt == null) continue;
      final newDev = Device.fromType(wt, srcDev.slot)..parentVessel = dst;
      for (int i = 0; i < srcDev.level; i++) {
        newDev.upgrade();
      }
      dst.hangar.add(newDev);
    }
  }

  /// Initialize co-op as client. Call after onLoad.
  Future<void> setupCoopClient(CoopClient client) async {
    coopRole = CoopRole.client;
    coopClient = client;

    // Set callbacks FIRST (before async gap) to avoid race conditions
    client.onConnected = (hostPilotName) {
      // Connection confirmed by host handshake
    };

    client.onGameEvent = (eventType, x, y, text) {
      switch (eventType) {
        case EventType.explosion:
          spawnRemoteDeathEffect(x, y, text);
        case EventType.message:
          showMessage(text);
        case EventType.sectorComplete:
          onSectorComplete?.call();
        case EventType.gameOver:
          triggerGameOver();
        case EventType.paused:
          state = GameState.paused;
          onOsdUpdate?.call();
        case EventType.resumed:
          state = GameState.playing;
          onOsdUpdate?.call();
        case EventType.gameStart:
          state = GameState.playing;
          onRemoteStart?.call();
      }
    };

    client.onDisconnected = () {
      showMessage(L10n.current.hostDisconnected);
      onDisconnected?.call();
    };

    // Now do async work — callbacks already wired
    vessel2 = Vessel(playerIndex: 1);
    await vessel2!.init();
    world.add(vessel2!);
    vessel2!.visible = false;
  }

  /// Callback when remote peer disconnects
  VoidCallback? onDisconnected;

  /// Fires on client when host signals game start
  VoidCallback? onRemoteStart;

  // ==== Host: snapshot extraction ====

  /// Extract current game state as a framed snapshot message
  Uint8List extractSnapshot() {
    // Vessel data helper
    List<double> vesselDoubles(Vessel v) => [
          v.position.x, v.position.y,
          v.shield, v.shieldMax,
          v.genValue, v.genMax,
        ];
    List<int> vesselInts(Vessel v) => [
          v.hp, v.hpMax, v.score, v.credit,
          v.fire ? 1 : 0, v.dmgTaken, v.visible ? 1 : 0,
          kHulls.indexWhere((h) => h.id == v.hull.id),
        ];

    // Hostiles
    final hostileSnaps = <HostileSnap>[];
    for (final fleet in activeFleets) {
      for (final h in fleet.hostiles) {
        if (h.isDead) continue;
        hostileSnaps.add(HostileSnap(
          fleetId: fleet.id,
          hostileId: h.id,
          x: h.position.x, y: h.position.y,
          hp: h.hp, hit: h.hit,
          sizeX: h.size.x, sizeY: h.size.y,
          hostType: h.hostType.index,
        ));
      }
    }

    // Enemy projectiles
    final eProjSnaps = <ProjSnap>[];
    for (final p in enemyProjectiles) {
      if (!p.active) continue;
      eProjSnaps.add(ProjSnap(
        x: p.position.x, y: p.position.y,
        sizeX: p.size.x, sizeY: p.size.y,
        speed: p.speed,
      ));
    }

    // Player projectiles (from both vessels)
    final pProjSnaps = <ProjSnap>[];
    for (final v in allVessels) {
      for (final d in v.guns) {
        for (final p in d.projectiles) {
          if (!p.active) continue;
          final img = projSnapImgs.indexOf(p.imgName);
          pProjSnaps.add(ProjSnap(
            x: p.position.x, y: p.position.y,
            sizeX: p.size.x, sizeY: p.size.y,
            speed: p.speed,
            img: img < 0 ? 0 : img,
            side: d.slot != WeaponSlot.frontGun,
          ));
        }
      }
    }

    // Collectables
    final collSnaps = <CollSnap>[];
    for (final c in activeCollectables) {
      collSnaps.add(CollSnap(
        x: c.position.x, y: c.position.y,
        type: c.cType.index,
      ));
    }

    // Beams
    final beamSnaps = <BeamSnap>[];
    for (final v in allVessels) {
      for (final d in v.guns) {
        if (d.beamActive > 0 && d.beam > 0) {
          beamSnaps.add(BeamSnap(
            sx: d.sx, sy: d.sy,
            dx: d.dx, dy: d.dy,
            active: true,
          ));
          for (final t in d.extraBeamTargets) {
            beamSnaps.add(BeamSnap(
              sx: d.sx, sy: d.sy,
              dx: t.x, dy: t.y,
              active: true,
            ));
          }
        }
      }
    }

    // Structures (asteroids)
    final structSnaps = <StructSnap>[];
    for (final s in activeStructures) {
      if (s.isDead) continue;
      structSnaps.add(StructSnap(
        id: s.id,
        x: s.position.x, y: s.position.y,
        sizeX: s.size.x, sizeY: s.size.y,
        hp: s.hp, hit: s.hit,
        structType: s.structType.index,
        imgName: s.imgName,
      ));
    }

    final v2 = vessel2 ?? vessel; // Fallback if no vessel2

    return encodeGameSnapshot(
      gameState: state.index,
      sectorIndex: currentSectorIndex,
      elapsed: elapsed,
      v1Data: vesselDoubles(vessel),
      v1Ints: vesselInts(vessel),
      v2Data: vesselDoubles(v2),
      v2Ints: vesselInts(v2),
      hostiles: hostileSnaps,
      enemyProjs: eProjSnaps,
      playerProjs: pProjSnaps,
      collectables: collSnaps,
      beams: beamSnaps,
      structures: structSnaps,
    );
  }

  // ==== Client: apply snapshot ====

  void applySnapshot(GameSnapshot snap) {
    // Update vessel stats from snapshot
    _applyVesselSnap(vessel, snap.vessel1);
    if (vessel2 != null) {
      _applyVesselSnap(vessel2!, snap.vessel2);
    }

    // Update game state (don't let snapshot downgrade playing→comCenter on client —
    // gameStart event may arrive before first snapshot with playing state)
    if (snap.gameState < GameState.values.length) {
      final newState = GameState.values[snap.gameState];
      if (!(coopRole == CoopRole.client && state == GameState.playing && newState == GameState.comCenter)) {
        state = newState;
      }
    }
    // Guard on change: snapshots arrive continuously, and an unguarded call
    // would allocate a Future per snapshot. The client's zone follows the host;
    // nothing in gameplay reads it, so a few frames of lag are invisible.
    if (snap.sectorIndex != currentSectorIndex) {
      requestZoneBackgrounds(snap.sectorIndex);
      parallaxBg.setLevel(Sector.levelForIndex(snap.sectorIndex));
    }
    currentSectorIndex = snap.sectorIndex;
    elapsed = snap.elapsed;

    // Update hostiles
    final seenKeys = <int>{};
    for (final hs in snap.hostiles) {
      final key = hs.fleetId * 1000 + hs.hostileId;
      seenKeys.add(key);

      var hostile = clientHostiles[key];
      if (hostile == null) {
        // Create new hostile for rendering
        hostile = Hostile(
          caption: '',
          id: hs.hostileId,
          hostType: HostType.values[hs.hostType.clamp(0, HostType.values.length - 1)],
          hp: hs.hp,
          hpMax: hs.hp,
        );
        clientHostiles[key] = hostile;
        world.add(hostile);
      }
      hostile.position.setValues(hs.x, hs.y);
      hostile.hp = hs.hp;
      hostile.hit = hs.hit;
    }

    // Remove hostiles no longer in snapshot
    final toRemove = clientHostiles.keys.where((k) => !seenKeys.contains(k)).toList();
    for (final k in toRemove) {
      final h = clientHostiles.remove(k);
      h?.removeFromParent();
    }

    // Structures (asteroids)
    final seenStructIds = <int>{};
    for (final ss in snap.structures) {
      seenStructIds.add(ss.id);
      var structure = clientStructures[ss.id];
      if (structure == null) {
        structure = Structure(
          caption: '',
          structType: StructType.values[ss.structType.clamp(0, StructType.values.length - 1)],
          hp: ss.hp,
          hpMax: ss.hp,
          imgName: ss.imgName,
        );
        clientStructures[ss.id] = structure;
        world.add(structure);
      }
      structure.position.setValues(ss.x, ss.y);
      structure.hp = ss.hp;
      structure.hit = ss.hit;
    }
    final structToRemove = clientStructures.keys.where((k) => !seenStructIds.contains(k)).toList();
    for (final k in structToRemove) {
      final s = clientStructures.remove(k);
      s?.removeFromParent();
    }

    // Enemy projectiles — recreate each frame (simple, since they're cheap)
    for (final p in enemyProjectiles) {
      p.removeFromParent();
    }
    enemyProjectiles.clear();
    for (final ps in snap.enemyProjectiles) {
      final proj = Projectile(
        imgName: 'bubble',
        position: Vector2(ps.x, ps.y),
        speed: ps.speed,
        damage: 0,
      );
      proj.size = Vector2(ps.sizeX, ps.sizeY);
      enemyProjectiles.add(proj);
      world.add(proj);
    }

    // Player projectiles
    for (final p in clientPlayerProjectiles) {
      p.removeFromParent();
    }
    clientPlayerProjectiles.clear();
    for (final ps in snap.playerProjectiles) {
      final proj = Projectile(
        imgName: projSnapImgs[ps.img],
        position: Vector2(ps.x, ps.y),
        speed: ps.speed,
        damage: 0,
      )..drawScaleOverride =
          ps.side ? config.sideShotDrawScale : config.frontShotDrawScale;
      proj.size = Vector2(ps.sizeX, ps.sizeY);
      clientPlayerProjectiles.add(proj);
      world.add(proj);
    }

    onOsdUpdate?.call();
  }

  void _applyVesselSnap(Vessel v, VesselSnap snap) {
    v.position.setValues(snap.x, snap.y);
    v.hp = snap.hp;
    v.hpMax = snap.hpMax;
    v.shield = snap.shield;
    v.shieldMax = snap.shieldMax;
    v.genValue = snap.gen;
    v.genMax = snap.genMax;
    v.score = snap.score;
    v.credit = snap.credit;
    v.fire = snap.fire;
    v.dmgTaken = snap.dmgTaken;
    v.visible = snap.visible;
    final hull = kHulls[snap.hull.clamp(0, kHulls.length - 1)];
    if (hull.id != v.hull.id) {
      // The client only draws the host's hull; stats come from the snapshot.
      v.hull = hull;
      v.refreshSprite();
    }
  }

  DevType? _findWeaponType(String name) {
    for (final w in DevType.frontWeapons) {
      if (w.name == name) return w;
    }
    for (final w in DevType.sideWeapons) {
      if (w.name == name) return w;
    }
    return null;
  }

  // ==== Cleanup ====

  Future<void> disposeCoop() async {
    await coopHost?.dispose();
    await coopClient?.dispose();
    coopHost = null;
    coopClient = null;
    coopRole = CoopRole.none;
    onClientJoined = null;
    onClientLeft = null;

    if (vessel2 != null) {
      vessel2!.removeFromParent();
      vessel2 = null;
    }

    // Clean up client-side entities
    for (final h in clientHostiles.values) {
      h.removeFromParent();
    }
    clientHostiles.clear();
    for (final s in clientStructures.values) {
      s.removeFromParent();
    }
    clientStructures.clear();
    for (final p in clientPlayerProjectiles) {
      p.removeFromParent();
    }
    clientPlayerProjectiles.clear();
  }
}
