import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../services/music_service.dart';
import '../services/skin_registry.dart';
import '../services/skin_store_service.dart';
import '../game/platform_config.dart' as platform;
import '../input/gamepad_input.dart';

/// Full-screen skin selection overlay (dark gradient, cyan accents).
class SkinSelector extends StatefulWidget {
  final VoidCallback onPlay;
  final VoidCallback? onDiscard;

  const SkinSelector({super.key, required this.onPlay, this.onDiscard});

  @override
  State<SkinSelector> createState() => _SkinSelectorState();
}

class _SkinSelectorState extends State<SkinSelector> {
  int _focusIndex = 0;
  Map<String, ui.Image> _previews = {};
  bool _loading = true;

  // Gamepad polling for menu navigation
  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevLeft = false;
  bool _prevRight = false;
  bool _prevUp = false;
  bool _prevDown = false;
  // Start true so the first poll ignores any button held at the time the selector opens.
  bool _prevConfirm = true;
  bool _prevDiscard = true;

  final FocusNode _focusNode = FocusNode();
  final List<GlobalKey> _cardKeys = List.generate(kSkins.length, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _loadState();
    SkinStoreService.instance.addListener(_onStoreChanged);
    if (platform.isDesktop) {
      _pollTimer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) => _pollGamepad(),
      );
    }
  }

  @override
  void dispose() {
    SkinStoreService.instance.removeListener(_onStoreChanged);
    _pollTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (!mounted) return;
    // A purchase started from this selector just completed — jump straight
    // into the freshly bought skin.
    final purchased = SkinStoreService.instance.takeJustPurchased();
    if (purchased != null) {
      _selectAndPlay(purchased);
      return;
    }
    setState(() {}); // prices arrived / pending state changed
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('selected_skin') ?? 'default';
    final previews = await AssetLibrary.instance.loadPreviews();
    if (mounted) {
      final idx = kSkins.indexWhere((s) => s.id == saved);
      setState(() {
        _focusIndex = idx >= 0 ? idx : 0;
        _previews = previews;
        _loading = false;
      });
    }
  }

  Future<void> _selectAndPlay(String id) async {
    if (_loading) return;
    // Locked skin: every input path (tap, keyboard, gamepad) converges here,
    // so this one gate turns "select" into "buy" for skins not yet owned.
    if (!SkinStoreService.instance.isUnlocked(id)) {
      SkinStoreService.instance.buy(id);
      return;
    }
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_skin', id);
    await AssetLibrary.instance.loadSkin(id);
    await SoundService.instance.loadSkin(id);
    await MusicService.instance.loadSkin(id);
    widget.onPlay();
  }

  void _moveFocus(int dx, int dy) {
    if (_loading) return;
    final cols = platform.isLandscape ? 4 : 2;
    final count = kSkins.length;
    int row = _focusIndex ~/ cols;
    int col = _focusIndex % cols;
    col += dx;
    row += dy;
    final maxRow = (count - 1) ~/ cols;
    col = col.clamp(0, cols - 1);
    row = row.clamp(0, maxRow);
    final newIndex = (row * cols + col).clamp(0, count - 1);
    if (newIndex != _focusIndex) {
      setState(() {
        _focusIndex = newIndex;
      });
      _scrollToFocus();
    }
  }

  void _scrollToFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _cardKeys[_focusIndex].currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut);
    });
  }

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    // Don't consume edges while loading — otherwise edge detection
    // is "spent" before the UI is ready to act on it.
    if (_loading) return;
    final gp = _gamepad.primary;

    // D-pad navigation (edge-triggered)
    final left = gp.dpadLeft || GamepadInput.deadzone(gp.leftStickX) < -0.5;
    final right = gp.dpadRight || GamepadInput.deadzone(gp.leftStickX) > 0.5;
    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final confirm = gp.buttonB || gp.start; // B or Option/Start
    final discard = gp.buttonA || gp.back;

    if (left && !_prevLeft) _moveFocus(-1, 0);
    if (right && !_prevRight) _moveFocus(1, 0);
    if (up && !_prevUp) _moveFocus(0, -1);
    if (down && !_prevDown) _moveFocus(0, 1);
    if (confirm && !_prevConfirm) _selectAndPlay(kSkins[_focusIndex].id);
    if (discard && !_prevDiscard) widget.onDiscard?.call();

    _prevLeft = left;
    _prevRight = right;
    _prevUp = up;
    _prevDown = down;
    _prevConfirm = confirm;
    _prevDiscard = discard;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      _moveFocus(-1, 0);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      _moveFocus(1, 0);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _moveFocus(0, -1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      _moveFocus(0, 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _selectAndPlay(kSkins[_focusIndex].id);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0a0a2e), Color(0xFF000010)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'SELECT SKIN',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.cyanAccent),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          crossAxisCount: platform.isLandscape ? 4 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: platform.isLandscape ? 1.0 : 0.85,
                          children: List.generate(kSkins.length, (i) => _buildSkinCard(i)),
                        ),
                      ),
              ),
              if (SkinStoreService.instance.supported)
                TextButton(
                  onPressed: SkinStoreService.instance.restore,
                  child: const Text(
                    'RESTORE PURCHASES',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkinCard(int index) {
    final skin = kSkins[index];
    final focused = index == _focusIndex;
    final preview = _previews[skin.id];
    final key = _cardKeys[index];
    final store = SkinStoreService.instance;
    final unlocked = store.isUnlocked(skin.id);
    final buying = store.pendingSkinId == skin.id;
    final price = store.priceFor(skin.id);

    return GestureDetector(
      key: key,
      onTap: () {
        setState(() {
          _focusIndex = index;
        });
        _selectAndPlay(skin.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: focused ? const Color(0xFF1a1a4e) : const Color(0xFF0d0d20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: focused ? Colors.cyanAccent : Colors.white24,
            width: focused ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(9)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: unlocked ? 1.0 : 0.35,
                      child: preview != null
                          ? RawImage(
                              image: preview,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Container(
                              color: Colors.black26,
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.white24, size: 40),
                              ),
                            ),
                    ),
                    if (!unlocked)
                      Center(
                        child: buying
                            ? const CircularProgressIndicator(
                                color: Colors.amberAccent)
                            : const Icon(Icons.lock,
                                color: Colors.amberAccent, size: 36),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: focused ? Colors.cyanAccent.withAlpha(80) : Colors.white10,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    skin.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: focused ? Colors.cyanAccent : Colors.white70,
                      fontSize: 13,
                      fontWeight: focused ? FontWeight.bold : FontWeight.normal,
                      letterSpacing: 1,
                    ),
                  ),
                  if (!unlocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        price ?? 'LOCKED',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
