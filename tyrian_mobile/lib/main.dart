import 'dart:async';
import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

import 'game/platform_config.dart' as platform;
import 'game/tyrian_game.dart';
import 'systems/sector.dart';
import 'input/gamepad_input.dart';
import 'ui/com_center.dart';
import 'ui/format.dart';
import 'ui/osd_panel.dart';
import 'ui/skin_selector.dart';
import 'services/achievement_service.dart';
import 'services/asset_library.dart';
import 'services/leaderboard_service.dart';
import 'services/skin_store_service.dart';
import 'services/sound_service.dart';
import 'services/music_service.dart';
import 'net/coop_host.dart';
import 'net/coop_client.dart';
import 'net/discovery.dart';
import 'net/protocol.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (platform.isDesktop) {
    // Route just_audio through media_kit (libmpv) on Linux and Windows.
    // Linux has no other backend at all — without this the game is silent on
    // Steam Deck. Windows nominally has just_audio_windows, but that decodes
    // through Media Foundation, which only handles our .ogg assets when the
    // removable "Web Media Extensions" store pack happens to be installed.
    // One backend removes the codec lottery. macOS/iOS/Android keep their
    // native just_audio implementations (App Store builds are unaffected).
    JustAudioMediaKit.ensureInitialized(linux: true, windows: true);
    await windowManager.ensureInitialized();
    await windowManager.setTitle('Kirian');
    // Fullscreen by default, but honour a windowed preference saved by the
    // F11/Alt+Enter toggle — before this there was no way out of fullscreen.
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('fullscreen') ?? true) {
      await windowManager.setFullScreen(true);
    }
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const TyrianApp());
}

class TyrianApp extends StatelessWidget {
  const TyrianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum _ScreenState { mainMenu, game }

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late TyrianGame _game;
  _ScreenState _screen = _ScreenState.mainMenu;

  /// True once a run exists that must not be wiped by pressing PLAY — either
  /// resumed from disk at startup or started in this session. The roguelike
  /// loop keeps weapons, credits and cumulative score across deaths, so the
  /// only thing that may reset them is an explicit fresh start.
  bool _runInProgress = false;
  bool _showComCenter = false;

  // Pause skin selector
  bool _showPauseSkinSelector = false;

  // Auto-host state (active from ComCenter through gameplay)
  CoopHost? _autoHost;
  CoopDiscovery? _autoDiscovery;

  // Client waiting overlay (P2 waiting for host to start)
  bool _clientWaiting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (platform.isDesktop) {
      HardwareKeyboard.instance.addHandler(_handleGlobalKey);
    }
    _game = TyrianGame();
    _setupGameCallbacks();
    // Achievements piggyback on the leaderboard's sign-in, so init them after
    // it settles — the first flush then pushes any progress accumulated
    // while signed out.
    LeaderboardService.instance
        .init()
        .then((_) => AchievementService.instance.init());
    SoundService.instance.init();
    SoundService.instance.loadSkin('default');
    MusicService.instance.init();
    MusicService.instance.loadSkin('default');
    SkinStoreService.instance.init();
  }

  void _setupGameCallbacks() {
    _game.onLoaded = () async {
      // Resume saved progress if present; otherwise start a fresh run, which
      // assigns a generated Ubuntu-style codename (player can rename later).
      final resumed = await _game.loadProgress();
      if (!resumed) {
        _game.vessel.newGame();
      }
      _runInProgress = resumed;
      if (mounted) setState(() {});
    };

    _game.onShowComCenter = () {
      setState(() => _showComCenter = true);
    };

    _game.onPauseToggle = () {
      if (mounted) setState(() {});
    };

    _game.onSkinRequested = () {
      if (mounted) {
        _game.skinSelectorOpen = true;
        setState(() => _showPauseSkinSelector = true);
      }
    };

    _game.onGameOver = () async {
      // Rebuild so _GameOverOverlay actually appears. Nothing else will do it:
      // the only thing driving setState during a run is onOsdUpdate, and that
      // fires from inside update() *after* the `state != playing` early-return
      // — which triggerGameOver has just armed. Without this the run freezes
      // mid-frame with no overlay, which is exactly what it looks like: a hang.
      // Must come before the await; the submit below can take seconds.
      if (mounted) setState(() {});

      // Submit to both native leaderboards (Game Center / Play Games). No-op
      // on Windows/Linux or when not signed in — there is no local table
      // anymore. The overlay stays up; the player opens the board from its
      // button if one is available.
      AchievementService.instance.onGameOver();
      await LeaderboardService.instance.submitScore(_game.vessel.score);
      await LeaderboardService.instance
          .submitDepth(AchievementService.instance.maxSectorLevel);

      if (_game.coopRole == CoopRole.host && _game.coopHost != null) {
        _game.coopHost!.sendEvent(EventType.gameOver);
      }
    };

    _game.onSectorComplete = () {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          if (_game.coopRole != CoopRole.client) {
            _game.advanceToNextSector();
            _game.openComCenter();
            _game.saveProgress(); // persist advanced sector + current loadout
            // Post progress now too: the run has no end, and both boards keep
            // the player's best, so a session killed mid-run still counts.
            LeaderboardService.instance.submitScore(_game.vessel.score);
            LeaderboardService.instance
                .submitDepth(AchievementService.instance.maxSectorLevel);
          } else {
            // P2: show waiting overlay while host shops
            setState(() => _clientWaiting = true);
          }
        }
      });
    };

    _game.onOsdUpdate = () {
      if (mounted) setState(() {});
    };

    // Co-op client: when host signals game start
    _game.onRemoteStart = () {
      if (mounted) {
        setState(() {
          _showComCenter = false;
          _clientWaiting = false;
        });
      }
    };

    // Co-op: remote peer disconnected
    _game.onDisconnected = () {
      if (mounted) {
        // Client in waiting state → return to menu
        if (_clientWaiting || _game.state == GameState.comCenter) {
          _returnToMainMenu();
        }
        // If playing, just show message (already done in setupCoopClient)
      }
    };
  }

  /// F11 or Alt+Enter toggles fullscreen anywhere — menu, shop, mid-game.
  /// Registered on HardwareKeyboard so it works regardless of widget focus.
  bool _handleGlobalKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final isToggle = event.logicalKey == LogicalKeyboardKey.f11 ||
        (HardwareKeyboard.instance.isAltPressed &&
            event.logicalKey == LogicalKeyboardKey.enter);
    if (!isToggle) return false;
    () async {
      final fs = await windowManager.isFullScreen();
      await windowManager.setFullScreen(!fs);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fullscreen', !fs);
    }();
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AchievementService.instance.flush();
      if (_game.state == GameState.playing) {
        _game.togglePause(); // co-op events handled inside togglePause()
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void dispose() {
    if (platform.isDesktop) {
      HardwareKeyboard.instance.removeHandler(_handleGlobalKey);
    }
    WidgetsBinding.instance.removeObserver(this);
    _disposeAutoHost();
    _game.disposeCoop();
    super.dispose();
  }

  /// Get the device's WiFi IP for display
  Future<String> _getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      for (final iface in interfaces) {
        // Prefer WiFi interface (en0 on iOS, wlan0 on Android)
        if (iface.name.startsWith('en') || iface.name.startsWith('wlan')) {
          for (final addr in iface.addresses) {
            if (!addr.isLoopback) return addr.address;
          }
        }
      }
      // Fallback: any non-loopback address
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) return addr.address;
        }
      }
    } catch (_) {}
    return '?';
  }

  void _showManualIpDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Connect to host', style: TextStyle(color: Colors.cyanAccent)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: '192.168.x.x',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              final ip = controller.text.trim();
              if (ip.isNotEmpty) {
                Navigator.pop(ctx);
                _joinAsClient(ip, CoopHost.defaultPort);
              }
            },
            child: const Text('CONNECT', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> _startAsAutoHost() async {
    // Only a pilot with nothing to lose gets a clean slate. Resetting a run
    // that already exists would wipe the weapons, credits and cumulative
    // score the roguelike loop is built on — and cumulative score is what
    // unlocks the higher weapon tiers.
    if (!_runInProgress) _game.resetForNewGame();
    _runInProgress = true;

    _autoHost = CoopHost();
    final port = await _autoHost!.start(_game.vessel.pilotName);

    _game.setupAutoHost(_autoHost!);
    _game.hostIp = await _getLocalIp();
    print('Host: local IP = ${_game.hostIp}, TCP port = $port');

    // Wire up client-joined notification for UI
    _game.onClientJoined = () {
      if (mounted) setState(() {});
    };

    // Start UDP broadcast
    _autoDiscovery = CoopDiscovery();
    await _autoDiscovery!.startBroadcast(port, _game.vessel.pilotName);

    if (mounted) {
      setState(() {
        _screen = _ScreenState.game;
        _showComCenter = true;
      });
    }
  }

  Future<void> _joinAsClient(String ip, int port) async {
    _game.resetForNewGame();
    print('Joining $ip:$port');
    final client = CoopClient();
    final ok = await client.connect(ip, port, _game.vessel.pilotName);
    if (!ok) {
      // Connection failed → fall back to auto-host
      if (mounted) await _startAsAutoHost();
      return;
    }

    await _game.setupCoopClient(client);

    if (mounted) {
      setState(() {
        _screen = _ScreenState.game;
        _clientWaiting = true;
      });
    }
  }

  void _disposeAutoHost() {
    _autoDiscovery?.dispose();
    _autoDiscovery = null;
    // Don't dispose _autoHost here — it's owned by _game.coopHost after setupAutoHost
    _autoHost = null;
  }

  /// Solo death is not the end of the game. The pilot keeps weapons, credits
  /// and cumulative score and is rewound to sector 1, landing in the shop so
  /// the losses can be spent before the next attempt.
  void _respawnAtFirstSector() {
    _game.restartRun();
    _game.state = GameState.comCenter;
    _game.saveProgress();
    if (mounted) {
      setState(() {
        _showComCenter = true;
      });
    }
  }

  void _returnToMainMenu() async {
    _disposeAutoHost();
    await _game.disposeCoop();
    // A run now survives death and app restarts, so this path — reachable only
    // when a co-op peer drops — must not discard it. Reload the pilot's own
    // save over whatever co-op mirrored into the vessel; only a pilot with no
    // save at all gets a fresh codename and a stock loadout.
    _runInProgress = await _game.loadProgress();
    if (!_runInProgress) {
      _game.vessel.newGame();
      _game.currentSectorIndex = 0;
      _game.requestZoneBackgrounds(0);
      _game.parallaxBg.setLevel(1);
    }
    _game.state = GameState.comCenter;
    if (mounted) {
      setState(() {
        _screen = _ScreenState.mainMenu;
        _showComCenter = false;
        _clientWaiting = false;
      });
    }
  }

  /// After game over with co-op: revive vessels, return to ComCenter
  void _returnToCoopComCenter() {
    _game.vessel.resetVessel();
    _game.vessel.resetPosition();
    _game.vessel2?.resetVessel();
    _game.vessel2?.resetPosition();
    _game.state = GameState.comCenter;
    if (mounted) {
      setState(() {
        _showComCenter = true;
      });
    }
  }

  /// ComCenter START button handler (host/solo)
  Future<void> _onComCenterStart() async {
    _game.saveProgress(); // persist final loadout before the mission
    // Prevent the same Start press that closed ComCenter from also
    // triggering the skin selector in TyrianGame's _processDesktopInput.
    // Must stay ahead of the first await, or the edge leaks through the yield.
    _game.suppressStartEdge();
    setState(() => _showComCenter = false);
    // ComCenter is an unbounded UI screen, so the zone load kicked off by
    // advanceToNextSector has almost certainly finished — this is the backstop
    // for when it has not. Costs a single microtask when already loaded.
    await AssetLibrary.instance
        .loadZoneBackgrounds(Sector.zoneForIndex(_game.currentSectorIndex));
    if (!mounted) return;
    if (_game.currentSector == null) {
      _game.startGame();
    } else {
      _game.vessel.resetVessel();
      _game.vessel2?.resetVessel();
      _game.resumeFromComCenter(); // handles P2 clone + gameStart event
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game canvas (always renders — starfield visible behind menus)
          GameWidget(game: _game),

          // Main menu with skin selector
          if (_game.isLoaded && _screen == _ScreenState.mainMenu)
            SkinSelector(
                showQuit: true,
                onPlay: () {
                  _game.refreshSprites();
                  _startAsAutoHost();
                }),

          // Game screen overlays
          if (_game.isLoaded && _screen == _ScreenState.game) ...[
            // Dimming overlay when paused
            if (_game.state == GameState.paused && !_showPauseSkinSelector)
              Container(color: Colors.black26),

            // Boss HP bar (visible while a phased boss is on the field)
            if (!_showComCenter && !_clientWaiting &&
                _game.state != GameState.gameOver)
              BossHealthBar(game: _game),

            // OSD HUD
            if (!_showComCenter && !_clientWaiting &&
                _game.state != GameState.gameOver)
              OsdPanel(
                game: _game,
                onMuteToggle: () => setState(() {}),
                onSkinSelect: () {
                  _game.skinSelectorOpen = true;
                  if (_game.state == GameState.playing) _game.togglePause();
                  setState(() => _showPauseSkinSelector = true);
                },
              ),

            // Skin selector during pause
            if (_game.state == GameState.paused && _showPauseSkinSelector)
              SkinSelector(
                onPlay: () {
                  _game.refreshSprites();
                  _game.skinSelectorOpen = false;
                  if (_game.state == GameState.paused) _game.togglePause();
                  setState(() => _showPauseSkinSelector = false);
                },
                onDiscard: () {
                  _game.skinSelectorOpen = false;
                  if (_game.state == GameState.paused) _game.togglePause();
                  setState(() => _showPauseSkinSelector = false);
                },
              ),

            // ComCenter (host/solo only — P2 never sees this)
            if (_showComCenter)
              ComCenterScreen(
                game: _game,
                onStart: _onComCenterStart,
                onJoinIp: _showManualIpDialog,
              ),

            // Client waiting overlay (P2)
            if (_clientWaiting)
              _buildWaitingOverlay(),

            // Game Over
            if (_game.state == GameState.gameOver)
              _GameOverOverlay(
                credit: _game.vessel.credit,
                score: _game.vessel.score,
                credit2: _game.isCoop && _game.vessel2 != null ? _game.vessel2!.credit : null,
                onClose: _game.isCoop ? _returnToCoopComCenter : _respawnAtFirstSector,
              ),
          ],

          // FPS overlay (visible during gameplay)
          if (_game.isLoaded && _screen == _ScreenState.game)
            _FpsOverlay(game: _game),
        ],
      ),
    );
  }

  Widget _buildWaitingOverlay() {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.cyanAccent),
            SizedBox(height: 16),
            Text(
              'Waiting for host...',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Game will start when host is ready',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lightweight FPS + entity count overlay (Flutter widget, outside game render).
class _FpsOverlay extends StatefulWidget {
  final TyrianGame game;
  const _FpsOverlay({required this.game});
  @override
  State<_FpsOverlay> createState() => _FpsOverlayState();
}

class _FpsOverlayState extends State<_FpsOverlay> {
  Timer? _timer;
  int _lastFrameCount = 0;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _lastFrameCount = widget.game.frameCount;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = widget.game.frameCount;
      final fps = current - _lastFrameCount;
      _lastFrameCount = current;
      final g = widget.game;
      setState(() {
        _text = '${fps}fps | H:${g.hostileCount} P:${g.projectileCount} E:${g.explosionCount}';
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      bottom: 4,
      child: IgnorePointer(
        child: Text(
          _text,
          style: const TextStyle(
            color: Color(0x99FFFFFF),
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

/// Game over panel with gamepad/keyboard navigation.
class _GameOverOverlay extends StatefulWidget {
  final int credit;
  final int score;
  final int? credit2;

  /// Leave the death screen — back to sector 1 via the shop (solo), or the
  /// co-op ComCenter.
  final VoidCallback onClose;

  const _GameOverOverlay({
    required this.credit,
    required this.score,
    this.credit2,
    required this.onClose,
  });

  @override
  State<_GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<_GameOverOverlay> {
  final _focusNode = FocusNode();
  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevConfirm = false, _prevBack = false;

  @override
  void initState() {
    super.initState();
    if (platform.isDesktop) {
      _pollTimer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) => _pollGamepad(),
      );
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    final gp = _gamepad.primary;

    final confirm = gp.buttonA || gp.buttonX;
    final back = gp.buttonB;

    if ((confirm && !_prevConfirm) || (back && !_prevBack)) {
      widget.onClose();
    }

    _prevConfirm = confirm;
    _prevBack = back;
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.escape) {
      widget.onClose();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withAlpha(150)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'VESSEL LOST',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rebuilding at Sector 1 — loadout and credits retained',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Text(
                'Score: ${fmtNum(widget.score)}',
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Credits: ${fmtNum(widget.credit)}',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 18),
              ),
              if (widget.credit2 != null) ...[
                const SizedBox(height: 4),
                Text(
                  'P2: ${fmtNum(widget.credit2!)}',
                  style: const TextStyle(color: Color(0xFF00FF80), fontSize: 16),
                ),
              ],
              const SizedBox(height: 16),
              // Native leaderboard button — only on a platform with Game Center
              // / Play Games and a signed-in player (hidden on Windows/Linux
              // and when sign-in failed). There is no local score table.
              if (LeaderboardService.instance.available) ...[
                ElevatedButton(
                  onPressed: LeaderboardService.instance.showLeaderboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('LEADERBOARD'),
                ),
                const SizedBox(height: 8),
              ],
              if (AchievementService.instance.available) ...[
                ElevatedButton(
                  onPressed: AchievementService.instance.showAchievements,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('ACHIEVEMENTS'),
                ),
                const SizedBox(height: 8),
              ],
              ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
                child: const Text('REDEPLOY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
