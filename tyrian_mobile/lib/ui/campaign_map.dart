import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../input/gamepad_input.dart';
import '../services/asset_library.dart';
import '../systems/campaign.dart';
import 'campaign_result.dart';
import 'ui_theme.dart';

/// The campaign's node list between missions: what is cleared, what is open,
/// what is still locked. Tap (or confirm on) an open node to launch it via
/// the ComCenter. Navigable by pad and keyboard like every other overlay.
class CampaignMapScreen extends StatefulWidget {
  final TyrianGame game;
  final void Function(int nodeIndex) onLaunch;
  final VoidCallback onBack;

  const CampaignMapScreen({
    super.key,
    required this.game,
    required this.onLaunch,
    required this.onBack,
  });

  @override
  State<CampaignMapScreen> createState() => _CampaignMapScreenState();
}

class _CampaignMapScreenState extends State<CampaignMapScreen> {
  late UiTheme _theme;
  late int _focus;
  final _focusNode = FocusNode();
  final _rowKeys = List.generate(kCampaignNodes.length, (_) => GlobalKey());

  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevUp = false, _prevDown = false;
  // Start true so a button held while the map opens is not taken as a press.
  bool _prevConfirm = true, _prevBack = true;

  CampaignState get _state => widget.game.campaign ?? CampaignState();

  @override
  void initState() {
    super.initState();
    _theme = UiTheme.forSkin(AssetLibrary.instance.skinId);
    _focus = _state.currentNode.clamp(0, kCampaignNodes.length - 1);
    if (platform.isDesktop) {
      _pollTimer = Timer.periodic(
          const Duration(milliseconds: 16), (_) => _pollGamepad());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocus());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _moveFocus(int delta) {
    final next = (_focus + delta).clamp(0, kCampaignNodes.length - 1);
    if (next == _focus) return;
    setState(() => _focus = next);
    _scrollToFocus();
  }

  void _scrollToFocus() {
    final ctx = _rowKeys[_focus].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut);
  }

  void _launch(int index) {
    if (!_state.isUnlocked(index)) return;
    widget.onLaunch(index);
  }

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    final gp = _gamepad.primary;
    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final confirm = gp.buttonB || gp.start;
    final back = gp.buttonA || gp.back;
    if (up && !_prevUp) _moveFocus(-1);
    if (down && !_prevDown) _moveFocus(1);
    if (confirm && !_prevConfirm) _launch(_focus);
    if (back && !_prevBack) widget.onBack();
    _prevUp = up;
    _prevDown = down;
    _prevConfirm = confirm;
    _prevBack = back;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowUp || k == LogicalKeyboardKey.keyW) {
      _moveFocus(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown || k == LogicalKeyboardKey.keyS) {
      _moveFocus(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      _launch(_focus);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape) {
      widget.onBack();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    final cleared = state.completed.length;
    var stars = 0;
    for (final s in state.stars.values) {
      stars += s.length;
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_theme.surfaceDark, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(cleared, stars),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: kCampaignNodes.length,
                  itemBuilder: (_, i) => _buildRow(i, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int cleared, int stars) {
    final pilot = widget.game.vessel.pilotName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back, color: _theme.accent),
            tooltip: 'Main menu',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAMPAIGN',
                  style: _theme.styled(TextStyle(
                    color: _theme.accent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  )),
                ),
                Text(
                  '$pilot · $cleared/${kCampaignNodes.length} cleared'
                  '${stars > 0 ? ' · ★ $stars' : ''}',
                  style: _theme.styled(TextStyle(
                    color: _theme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int i, CampaignState state) {
    final node = kCampaignNodes[i];
    final done = state.isCompleted(i);
    final open = state.isUnlocked(i);
    final focused = i == _focus;
    final stars = state.starsFor(i);

    final Color edge;
    final Color text;
    if (done) {
      edge = _theme.success;
      text = _theme.textPrimary;
    } else if (open) {
      edge = _theme.accent;
      text = _theme.textPrimary;
    } else {
      edge = _theme.accentDim;
      text = _theme.textSecondary;
    }

    final String trailing;
    if (done) {
      trailing = stars > 0 ? '✓ ${'★' * stars}' : '✓';
    } else if (open) {
      trailing = '▶';
    } else {
      trailing = 'LOCKED';
    }

    return Padding(
      key: _rowKeys[i],
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: open ? () => _launch(i) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: focused ? _theme.surfaceLight : _theme.surfaceMid,
            borderRadius: BorderRadius.circular(_theme.cornerRadius),
            border: Border.all(
              color: focused ? _theme.accent : edge.withAlpha(140),
              width: focused ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      '${i + 1}'.padLeft(2, '0'),
                      style: _theme.styled(TextStyle(
                        color: edge,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          node.caption,
                          style: _theme.styled(TextStyle(
                            color: text,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          )),
                        ),
                        Text(
                          'Level ${node.level}'
                          '${node.isBoss ? ' · BOSS ${'I' * node.bossOrdinal!}' : ''}',
                          style: _theme.styled(TextStyle(
                            color: node.isBoss
                                ? _theme.danger
                                : _theme.textSecondary,
                            fontSize: 11,
                            letterSpacing: 1,
                          )),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    trailing,
                    style: _theme.styled(TextStyle(
                      color: edge,
                      fontSize: done ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )),
                  ),
                ],
              ),
              // Briefing: the focused node shows what it asks for, so the
              // pilot can shop for it before launching.
              if (focused && open) ...[
                const SizedBox(height: 8),
                Divider(height: 1, color: _theme.accentDim.withAlpha(120)),
                const SizedBox(height: 8),
                ObjectiveLines.briefing(node.objectives, theme: _theme),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
