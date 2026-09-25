import 'dart:async';
import 'dart:io' show exit;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
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

  /// Adds a CAMPAIGN entry under the grid — the main menu's way into the
  /// campaign with whatever skin is currently loaded. Absent in the pause-time
  /// selector.
  final VoidCallback? onCampaign;

  /// Show a QUIT entry under the grid. Only the desktop main menu sets this:
  /// phones have a home button, and the pause-time selector must not offer a
  /// second, confusing exit.
  final bool showQuit;

  const SkinSelector(
      {super.key,
      required this.onPlay,
      this.onDiscard,
      this.onCampaign,
      this.showQuit = false});

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
    // loadSkin re-points the game's live entities itself (see
    // AssetLibrary.onSkinAssetsChanged) — it must not wait for the audio
    // below, which can spend tens of seconds in setAsset timeouts.
    await AssetLibrary.instance.loadSkin(id);
    await SoundService.instance.loadSkin(id);
    await MusicService.instance.loadSkin(id);
    widget.onPlay();
  }

  bool get _hasQuit => widget.showQuit && platform.isDesktop;
  bool get _hasCampaign => widget.onCampaign != null;

  /// Pseudo focus indices for the entries under the grid: CAMPAIGN first,
  /// then QUIT, each one past the last.
  int get _campaignIndex => kSkins.length;
  int get _quitIndex => kSkins.length + (_hasCampaign ? 1 : 0);

  /// The entries below the grid, top to bottom.
  List<int> get _footer => [
        if (_hasCampaign) _campaignIndex,
        if (_hasQuit) _quitIndex,
      ];

  Future<void> _quit() async {
    await windowManager.destroy();
    exit(0);
  }

  /// Confirm on whatever has focus: a skin card plays, the footer entries
  /// do their own thing.
  void _activateFocus() {
    if (_hasQuit && _focusIndex == _quitIndex) {
      _quit();
    } else if (_hasCampaign && _focusIndex == _campaignIndex) {
      widget.onCampaign!();
    } else {
      _selectAndPlay(kSkins[_focusIndex].id);
    }
  }

  void _moveFocus(int dx, int dy) {
    if (_loading) return;
    final cols = platform.isLandscape ? 4 : 2;
    final count = kSkins.length;
    final footer = _footer;

    // The footer is a vertical list below the grid: down from the last row
    // lands on its first entry, up from that entry returns to the last row.
    // Left/right on it stay put.
    final fi = footer.indexOf(_focusIndex);
    if (fi >= 0) {
      if (dy < 0) {
        setState(() => _focusIndex = fi == 0 ? count - 1 : footer[fi - 1]);
        if (fi == 0) _scrollToFocus();
      } else if (dy > 0 && fi + 1 < footer.length) {
        setState(() => _focusIndex = footer[fi + 1]);
      }
      return;
    }

    int row = _focusIndex ~/ cols;
    int col = _focusIndex % cols;
    final maxRow = (count - 1) ~/ cols;
    if (footer.isNotEmpty && dy > 0 && row == maxRow) {
      setState(() => _focusIndex = footer.first);
      return;
    }
    col += dx;
    row += dy;
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
      if (_focusIndex >= _cardKeys.length) return; // QUIT entry has no card
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
    if (confirm && !_prevConfirm) _activateFocus();
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
      _activateFocus();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape && _hasQuit) {
      _quit();
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
              if (_hasCampaign)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: InkWell(
                    onTap: () => widget.onCampaign!(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _focusIndex == _campaignIndex
                              ? Colors.cyanAccent
                              : Colors.cyanAccent.withAlpha(110),
                          width: _focusIndex == _campaignIndex ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CAMPAIGN',
                        style: TextStyle(
                          color: _focusIndex == _campaignIndex
                              ? Colors.cyanAccent
                              : Colors.cyanAccent.withAlpha(200),
                          fontSize: 14,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_hasQuit)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: InkWell(
                    onTap: _quit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _focusIndex == _quitIndex
                              ? Colors.cyanAccent
                              : Colors.white24,
                          width: _focusIndex == _quitIndex ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'QUIT',
                        style: TextStyle(
                          color: _focusIndex == _quitIndex
                              ? Colors.cyanAccent
                              : Colors.white54,
                          fontSize: 14,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    final store = SkinStoreService.instance;
    return SkinCard(
      key: _cardKeys[index],
      skin: skin,
      preview: _previews[skin.id],
      highlighted: index == _focusIndex,
      unlocked: store.isUnlocked(skin.id),
      buying: store.pendingSkinId == skin.id,
      price: store.priceFor(skin.id),
      onTap: () {
        setState(() {
          _focusIndex = index;
        });
        _selectAndPlay(skin.id);
      },
    );
  }
}

/// One skin card — preview, name, lock/price state. Shared between the
/// full-screen [SkinSelector] and the embeddable [SkinShopSection].
class SkinCard extends StatelessWidget {
  final SkinInfo skin;
  final ui.Image? preview;

  /// Focused (selector) or currently active (shop section).
  final bool highlighted;

  /// The gamepad cursor is on this card. Separate from [highlighted] because in
  /// the shop section that already means "this is the skin you are wearing" —
  /// the pad has to be able to point at a card without claiming it is active.
  final bool padFocused;
  final bool unlocked;
  final bool buying;
  final String? price;
  final VoidCallback onTap;

  const SkinCard({
    super.key,
    required this.skin,
    required this.preview,
    required this.highlighted,
    this.padFocused = false,
    required this.unlocked,
    required this.buying,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFF1a1a4e) : const Color(0xFF0d0d20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: padFocused
                ? Colors.white
                : (highlighted ? Colors.cyanAccent : Colors.white24),
            width: padFocused ? 3 : (highlighted ? 2 : 1),
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
                    color: highlighted
                        ? Colors.cyanAccent.withAlpha(80)
                        : Colors.white10,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    skin.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: highlighted ? Colors.cyanAccent : Colors.white70,
                      fontSize: 13,
                      fontWeight:
                          highlighted ? FontWeight.bold : FontWeight.normal,
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

/// Embeddable version of the selector's skin grid for hosting inside other
/// scrollable screens — currently the bottom of the ComCenter page. Same
/// cards and buy/unlock behaviour as [SkinSelector], but switching a skin
/// only reloads assets and reports back via [onSkinChanged]; the caller
/// decides when the player actually returns to the game.
class SkinShopSection extends StatefulWidget {
  final int crossAxisCount;
  final ValueChanged<String> onSkinChanged;

  const SkinShopSection({
    super.key,
    required this.crossAxisCount,
    required this.onSkinChanged,
  });

  @override
  SkinShopSectionState createState() => SkinShopSectionState();
}

/// Public so the embedding screen can drive the pad cursor through a
/// GlobalKey. The grid owns its own scroll-into-view and buy/select rules, so
/// the host only says "move", "activate" or "the pad went somewhere else"
/// rather than reimplementing any of it — see ComCenter's _PadRegion.skins.
class SkinShopSectionState extends State<SkinShopSection> {
  Map<String, ui.Image> _previews = {};
  bool _switching = false;
  final Map<String, GlobalKey> _cardKeys = {
    for (final s in kSkins) s.id: GlobalKey(),
  };

  /// Index of the pad cursor, or null while the pad is in another region.
  int? _padFocus;

  /// Where the cursor sits (or would sit), regardless of whether it is shown.
  int get padFocusIndex => _padFocus ?? 0;

  int get cardCount => kSkins.length;

  /// Show the cursor at [index], or hide it with null.
  void setPadFocus(int? index) {
    if (!mounted) return;
    setState(() => _padFocus = index?.clamp(0, kSkins.length - 1));
    if (index != null) _scrollPadFocusIntoView();
  }

  /// Step the cursor by [delta] cards. Returns false when the move would run
  /// off the grid, which is the host's cue to hand focus to another region.
  bool movePadFocus(int delta) {
    if (!mounted) return false;
    final next = padFocusIndex + delta;
    if (next < 0 || next >= kSkins.length) return false;
    setState(() => _padFocus = next);
    _scrollPadFocusIntoView();
    return true;
  }

  /// Select (or buy) the card under the cursor.
  void activatePadFocus() {
    final i = _padFocus;
    if (i == null) return;
    _select(kSkins[i].id);
  }

  void _scrollPadFocusIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final i = _padFocus;
      if (i == null) return;
      final ctx = _cardKeys[kSkins[i].id]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: 0.5);
    });
  }

  @override
  void initState() {
    super.initState();
    SkinStoreService.instance.addListener(_onStoreChanged);
    AssetLibrary.instance.loadPreviews().then((p) {
      if (mounted) setState(() => _previews = p);
    });
  }

  @override
  void dispose() {
    SkinStoreService.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (!mounted) return;
    // A purchase started from this section just completed — switch straight
    // into the freshly bought skin.
    final purchased = SkinStoreService.instance.takeJustPurchased();
    if (purchased != null) {
      _select(purchased);
      return;
    }
    setState(() {}); // prices arrived / pending state changed
  }

  Future<void> _select(String id) async {
    if (_switching) return;
    // Same gate as the selector: "select" becomes "buy" for skins not owned.
    if (!SkinStoreService.instance.isUnlocked(id)) {
      SkinStoreService.instance.buy(id);
      return;
    }
    if (id == AssetLibrary.instance.skinId) return;
    // Previews live outside Flame's image cache (see loadPreviews), so they
    // survive the loadSkin cache clear and the cards never flicker.
    setState(() => _switching = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_skin', id);
    // As in _selectAndPlay: the graphics swap re-points the game on its own.
    // onSkinChanged below is only the ComCenter's re-theme, so it is safe for
    // it to sit behind the audio and the mounted check — the ship is not.
    await AssetLibrary.instance.loadSkin(id);
    await SoundService.instance.loadSkin(id);
    await MusicService.instance.loadSkin(id);
    if (!mounted) return;
    setState(() => _switching = false);
    widget.onSkinChanged(id);
    // The host re-themes on the callback above and the sections above this
    // grid change height with the new skin's fonts, dragging the cards away
    // from where the user just tapped. Re-anchor the switched card once the
    // re-themed layout is done.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _cardKeys[id]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx, alignment: 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = SkinStoreService.instance;
    final active = AssetLibrary.instance.skinId;
    return Column(
      children: [
        GridView.count(
          crossAxisCount: widget.crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: widget.crossAxisCount >= 4 ? 1.0 : 0.85,
          children: [
            for (final (i, skin) in kSkins.indexed)
              SkinCard(
                key: _cardKeys[skin.id],
                skin: skin,
                preview: _previews[skin.id],
                highlighted: skin.id == active,
                padFocused: _padFocus == i,
                unlocked: store.isUnlocked(skin.id),
                buying: store.pendingSkinId == skin.id,
                price: store.priceFor(skin.id),
                onTap: () => _select(skin.id),
              ),
          ],
        ),
        if (store.supported)
          TextButton(
            onPressed: store.restore,
            child: const Text(
              'RESTORE PURCHASES',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ),
      ],
    );
  }
}
