import 'dart:math' show pi, exp, min;
import 'dart:typed_data';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_config.dart' as config;
import 'platform_config.dart' as platform;
import '../input/keyboard_input.dart';
import '../input/gamepad_input.dart';
import '../rendering/starfield.dart';
import '../rendering/parallax_bg.dart';
import '../entities/vessel.dart';
import '../entities/boss.dart';
import '../entities/explosion.dart';
import '../entities/collectable.dart';
import '../entities/structure.dart';
import '../entities/hostile.dart';
import '../systems/sector.dart';
import '../systems/fleet.dart';
import '../systems/dev_type.dart';
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

enum GameState { comCenter, playing, paused, gameOver }
enum CoopRole { none, host, client }

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
  final List<Projectile> enemyProjectiles = [];

  Sector? currentSector;
  int currentSectorIndex = 0;

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

  /// Adaptive-music director — created in onLoad, ticked while playing.
  MusicDirector? musicDirector;

  int get projectileCount {
    int count = enemyProjectiles.length;
    for (final v in allVessels) {
      for (final d in v.devices) {
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

    vessel = Vessel();
    await vessel.init();
    world.add(vessel);

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
      camera.viewfinder.angle = -pi / 2; // CCW: game UP → screen RIGHT
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
  }

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
      for (final d in v.devices) {
        for (final p in d.projectiles) {
          p.refreshSprite();
        }
      }
    }
    for (final p in enemyProjectiles) {
      p.refreshSprite();
    }

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
    AchievementService.instance
        .onMissionStarted(AssetLibrary.instance.skinId, isCoop: isCoop);
  }

  /// Kick off the heroic intro + reset the adaptive-music director for a sector.
  void _startSectorMusic() {
    musicDirector?.reset();
    MusicService.instance.startSector();
  }

  void loadSector(int index) {
    // Clean up previous sector
    _clearActiveObjects();
    currentSector?.removeFromParent();

    currentSector = Sector.create(index, this);
    if (currentSector != null) {
      world.add(currentSector!);
    }
    currentSectorIndex = index;
    vessel.lvlNum = index + 1;
    if (vessel2 != null) vessel2!.lvlNum = index + 1;
    sectorHullDamage = false;
    elapsed = 0;
  }

  void _clearActiveObjects() {
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
    shardPool.clearAll();
    for (final p in [...enemyProjectiles]) {
      p.removeFromParent();
    }
    enemyProjectiles.clear();
    // Clear player projectiles (world children via devices)
    for (final v in allVessels) {
      for (final d in v.devices) {
        for (final p in [...d.projectiles]) {
          p.removeFromParent();
        }
        d.clearProjectiles();
      }
    }
  }

  @override
  void update(double dt) {
    frameCount++;
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
      _updateWorldShift(dt);
      return;
    }

    // Desktop keyboard + gamepad input (handles pause toggle even when paused)
    _processDesktopInput(dt);

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

    super.update(dt);
    elapsed += dt;
    AchievementService.instance.addPlayTime(dt);
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

    // Check sector completion
    if (currentSector != null && currentSector!.isComplete) {
      _onSectorComplete();
    }

    // Host mode: send snapshot to client after each frame
    if (coopRole == CoopRole.host && coopHost != null && coopHost!.hasClient) {
      try {
        coopHost!.sendSnapshot(extractSnapshot());
      } catch (_) {}
    }
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
    AchievementService.instance.onSectorCompleted(
      currentSectorIndex + 1,
      tookHullDamage: sectorHullDamage,
    );
    SoundService.instance.play(SfxEvent.sectorComplete);
    MusicService.instance.stop(); // duck soundtrack for the victory fanfare + ComCenter
    vessel.credit += currentSector!.sectorBonus;
    if (vessel2 != null) vessel2!.credit += currentSector!.sectorBonus;

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
    loadSector(index);
  }

  /// Persist the player's between-sector progress (credits, weapons, stats,
  /// pilot name, current sector). Fire-and-forget from the ComCenter.
  Future<void> saveProgress() async {
    if (coopRole == CoopRole.client) return; // client mirrors host, never owns state
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
      weapons: List<Map<String, dynamic>>.from(m['weapons'] as List),
    );
  }

  /// Restore saved progress at startup. Returns true if a saved game was loaded.
  Future<bool> loadProgress() async {
    final state = await SaveService.loadGameState();
    if (state == null) return false;
    vessel.loadFromSave(state);
    currentSectorIndex = (state['level'] as num?)?.toInt() ?? 0;
    return true;
  }

  /// Reset all game state for a fresh new game.
  void resetForNewGame() {
    _clearActiveObjects();
    currentSector?.removeFromParent();
    currentSector = null;
    currentSectorIndex = 0;
    vessel.newGame();
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
    if (platform.isLandscape) {
      // Inverse rotation: screen → game space
      // Screen RIGHT = game UP (−Y), Screen DOWN = game RIGHT (+X)
      v.adjustPosition(
        v.position.x + screenDy * speed * dt,
        v.position.y - screenDx * speed * dt,
      );
    } else {
      v.adjustPosition(
        v.position.x + screenDx * speed * dt,
        v.position.y + screenDy * speed * dt,
      );
    }
  }

  /// Process keyboard + gamepad input — called at the start of update().
  void _processDesktopInput(double dt) {
    if (!platform.isDesktop) return;

    // Poll gamepad (~60Hz to avoid MethodChannel overhead)
    _gamepadPollTimer += dt;
    if (_gamepadPollTimer >= 1 / 60) {
      _gamepadPollTimer = 0;
      gamepadInput.poll(); // fire-and-forget async
    }

    // ── Keyboard pause (Escape) ──
    final pauseKb = keyboardInput.pause;
    if (pauseKb && !_prevPauseKey && !skinSelectorOpen) {
      if (state == GameState.playing || state == GameState.paused) togglePause();
    }
    _prevPauseKey = pauseKb;

    // ── Skin selector: Start/Option opens it, auto-pauses game ──
    final skinGp = gamepadInput.primary.pause; // Start = Option on PS, Menu on Xbox
    if (skinGp && !_prevSkinGp && !skinSelectorOpen) {
      if (state == GameState.playing) togglePause();
      if (state == GameState.paused) onSkinRequested?.call();
    }
    _prevSkinGp = skinGp;

    if (state == GameState.paused) return;

    if (state != GameState.playing) return;

    // ── Gamepad P1 (takes priority over keyboard) ──
    final gp = gamepadInput.primary;
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

  void showMessage(String msg) {
    world.add(FloatText(
      text: msg,
      color: const Color(0xFF00FFFF),
      fontSize: 18,
      position: Vector2(config.gameWidth / 2, config.gameHeight * 0.3),
    ));
  }

  bool _projectileHitsVessel(Projectile p, Vessel v) {
    const cf = 0.7; // collision fraction — shrink vessel hitbox for fairness
    final vhx = v.size.x / 2 * cf;
    final vhy = v.size.y / 2 * cf;
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
      // AABB collision with all vessels
      bool hit = false;
      for (final v in allVessels) {
        if (_projectileHitsVessel(p, v)) {
          v.takeDamage(p.damage.toInt());
          hit = true;
          break;
        }
      }
      if (hit) {
        p.removeFromParent();
        enemyProjectiles.removeAt(i);
      }
    }
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
      damage: dmg.toDouble(),
      scale: scale,
    );
    enemyProjectiles.add(proj);
    world.add(proj);
  }

  // Spawn helpers used by Sector/Fleet
  void addExplosion(double x, double y, int size) {
    explosionRenderer.acquire(x, y, size);
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

      showMessage('Player 2 joined!');
      onClientJoined?.call();
    };

    host.onClientDisconnected = () {
      vessel2?.visible = false;
      showMessage('Player 2 disconnected');
    };
  }

  /// Deep-copy stats and weapons from source vessel to target
  void _cloneVesselStats(Vessel src, Vessel dst) {
    dst.hpMax = src.hpMax;
    dst.hp = src.hp;
    dst.shieldMax = src.shieldMax;
    dst.shield = src.shield;
    dst.shieldRegen = src.shieldRegen;
    dst.genMax = src.genMax;
    dst.genPower = src.genPower;
    dst.genValue = src.genValue;
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
          addExplosion(x, y, 2);
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
      showMessage('Host disconnected');
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
      for (final d in v.devices) {
        for (final p in d.projectiles) {
          if (!p.active) continue;
          pProjSnaps.add(ProjSnap(
            x: p.position.x, y: p.position.y,
            sizeX: p.size.x, sizeY: p.size.y,
            speed: p.speed,
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
      for (final d in v.devices) {
        if (d.beamActive > 0 && d.beam > 0) {
          beamSnaps.add(BeamSnap(
            sx: d.sx, sy: d.sy,
            dx: d.dx, dy: d.dy,
            active: true,
          ));
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
        imgName: 'bubble',
        position: Vector2(ps.x, ps.y),
        speed: ps.speed,
        damage: 0,
      );
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
