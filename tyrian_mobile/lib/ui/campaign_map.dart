import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../input/gamepad_input.dart';
import '../services/asset_library.dart';
import '../systems/campaign.dart';
import 'campaign_result.dart';
import 'ui_theme.dart';

/// Vertical spacing between nodes on the route.
const double _nodeGap = 96;

/// Padding above the first node and below the last.
const double _routePad = 70;

/// Where node [i] sits on a canvas [size] wide and tall.
///
/// The route runs bottom to top: the first node is at the bottom of the
/// scroll, deep space is up. X serpentines so the line has somewhere to bend,
/// which is what makes it read as a route rather than a list.
Offset _nodeCenter(int i, Size size) {
  final y = size.height - _routePad - i * _nodeGap;
  final x = size.width / 2 + sin(i * 0.9) * (size.width * 0.27);
  return Offset(x, y);
}

double _routeHeight(int count) => _routePad * 2 + (count - 1) * _nodeGap;

/// The campaign route between missions: what is cleared, what is open, what
/// is still dark. Pick a node to read its briefing, then launch it through
/// the Com Center.
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
  final _scroll = ScrollController();

  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevUp = false, _prevDown = false;
  // Start true so a button still held from the last mission is not a press.
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocus(false));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _scroll.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _moveFocus(int delta) {
    final next = (_focus + delta).clamp(0, kCampaignNodes.length - 1);
    if (next == _focus) return;
    setState(() => _focus = next);
    _scrollToFocus(true);
  }

  /// Keep the focused node near the middle of the viewport. The route is
  /// painted bottom-up, so node 0 sits at the far end of the scroll extent.
  void _scrollToFocus(bool animate) {
    if (!_scroll.hasClients) return;
    final viewport = _scroll.position.viewportDimension;
    final total = max(_routeHeight(kCampaignNodes.length), viewport);
    final target = (total - _routePad - _focus * _nodeGap - viewport / 2)
        .clamp(0.0, _scroll.position.maxScrollExtent);
    if (animate) {
      _scroll.animateTo(target,
          duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    } else {
      _scroll.jumpTo(target);
    }
  }

  void _launchFocused() {
    if (!_state.isUnlocked(_focus)) return;
    widget.onLaunch(_focus);
  }

  /// Focus whichever node was tapped. Launching stays on its own button so a
  /// stray tap on the route cannot throw the pilot into a mission.
  void _tapAt(Offset local, Size canvas) {
    for (var i = 0; i < kCampaignNodes.length; i++) {
      final c = _nodeCenter(i, canvas);
      if ((local - c).distance <= 30) {
        setState(() => _focus = i);
        return;
      }
    }
  }

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    final gp = _gamepad.primary;
    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final confirm = gp.buttonB || gp.start;
    final back = gp.buttonA || gp.back;
    // Up the screen is forward along the route.
    if (up && !_prevUp) _moveFocus(1);
    if (down && !_prevDown) _moveFocus(-1);
    if (confirm && !_prevConfirm) _launchFocused();
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
      _moveFocus(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown || k == LogicalKeyboardKey.keyS) {
      _moveFocus(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      _launchFocused();
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
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, _theme.surfaceDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(state),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final canvas = Size(
                      constraints.maxWidth,
                      max(_routeHeight(kCampaignNodes.length),
                          constraints.maxHeight),
                    );
                    return SingleChildScrollView(
                      controller: _scroll,
                      child: GestureDetector(
                        onTapUp: (d) => _tapAt(d.localPosition, canvas),
                        child: CustomPaint(
                          size: canvas,
                          painter: _RoutePainter(
                            theme: _theme,
                            state: state,
                            focus: _focus,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildBriefing(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CampaignState state) {
    var stars = 0;
    for (final s in state.stars.values) {
      stars += s.length;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back, color: _theme.accent),
            tooltip: 'Main menu',
          ),
          Expanded(
            child: Text(
              'CAMPAIGN',
              style: _theme.styled(TextStyle(
                color: _theme.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              )),
            ),
          ),
          Text(
            '${state.completed.length}/${kCampaignNodes.length}   ★ $stars',
            style: _theme.styled(TextStyle(
              color: _theme.textSecondary,
              fontSize: 12,
              letterSpacing: 1,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefing(CampaignState state) {
    final node = kCampaignNodes[_focus];
    final open = state.isUnlocked(_focus);
    final done = state.isCompleted(_focus);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: _theme.surfaceMid,
        border: Border(top: BorderSide(color: _theme.accent.withAlpha(90))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_focus + 1}. ${node.caption}',
                  style: _theme.styled(TextStyle(
                    color: _theme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  )),
                ),
              ),
              Text(
                node.isBoss
                    ? 'LEVEL ${node.level} · BOSS ${'I' * node.bossOrdinal!}'
                    : 'LEVEL ${node.level}',
                style: _theme.styled(TextStyle(
                  color: node.isBoss ? _theme.danger : _theme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (open)
            ObjectiveLines.briefing(node.objectives, theme: _theme)
          else
            Text(
              'Locked. Clear the node before it.',
              style: _theme.styled(TextStyle(
                color: _theme.textSecondary,
                fontSize: 12,
              )),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: open ? _launchFocused : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: open ? _theme.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(_theme.cornerRadius),
                  border: Border.all(
                    color: open ? _theme.accent : _theme.accentDim,
                    width: open ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    open ? (done ? 'FLY AGAIN' : 'LAUNCH') : 'LOCKED',
                    style: _theme.styled(TextStyle(
                      color: open ? _theme.accent : _theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the route: the line between nodes, a marker per node, and a band
/// wherever the art zone changes.
class _RoutePainter extends CustomPainter {
  final UiTheme theme;
  final CampaignState state;
  final int focus;

  _RoutePainter({
    required this.theme,
    required this.state,
    required this.focus,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintZoneBands(canvas, size);
    _paintRoute(canvas, size);
    for (var i = 0; i < kCampaignNodes.length; i++) {
      _paintNode(canvas, size, i);
    }
  }

  /// A faint stripe behind each run of nodes that shares a backdrop, so the
  /// route reads as passing through places rather than along a ruler.
  void _paintZoneBands(Canvas canvas, Size size) {
    var start = 0;
    for (var i = 1; i <= kCampaignNodes.length; i++) {
      final ends = i == kCampaignNodes.length ||
          kCampaignNodes[i].zone != kCampaignNodes[start].zone;
      if (!ends) continue;

      final top = _nodeCenter(i - 1, size).dy - _nodeGap * 0.5;
      final bottom = _nodeCenter(start, size).dy + _nodeGap * 0.5;
      final zone = kCampaignNodes[start].zone;
      canvas.drawRect(
        Rect.fromLTRB(0, top, size.width, bottom),
        Paint()..color = theme.accent.withAlpha(zone.isEven ? 10 : 20),
      );
      final label = TextPainter(
        text: TextSpan(
          text: 'ZONE ${zone + 1}',
          style: TextStyle(
            color: theme.accent.withAlpha(90),
            fontSize: 10,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, Offset(10, top + 6));
      start = i;
    }
  }

  void _paintRoute(Canvas canvas, Size size) {
    for (var i = 0; i < kCampaignNodes.length - 1; i++) {
      final a = _nodeCenter(i, size);
      final b = _nodeCenter(i + 1, size);
      // Reached track is lit; the rest is the dark road ahead.
      final lit = state.isUnlocked(i + 1);
      final paint = Paint()
        ..color = lit ? theme.accent.withAlpha(140) : theme.accentDim
        ..strokeWidth = lit ? 3 : 2
        ..style = PaintingStyle.stroke;
      // Bend through the midpoint so consecutive segments meet smoothly
      // instead of showing the serpentine's corners.
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(a.dx, (a.dy + b.dy) / 2, (a.dx + b.dx) / 2,
            (a.dy + b.dy) / 2)
        ..quadraticBezierTo(b.dx, (a.dy + b.dy) / 2, b.dx, b.dy);
      canvas.drawPath(path, paint);
    }
  }

  void _paintNode(Canvas canvas, Size size, int i) {
    final node = kCampaignNodes[i];
    final c = _nodeCenter(i, size);
    final done = state.isCompleted(i);
    final open = state.isUnlocked(i);
    final focused = i == focus;
    final r = node.isBoss ? 26.0 : 19.0;

    final Color edge;
    if (done) {
      edge = theme.success;
    } else if (open) {
      edge = theme.accent;
    } else {
      edge = theme.accentDim;
    }

    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = done
              ? theme.success.withAlpha(45)
              : (open ? theme.surfaceLight : theme.surfaceDark));
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = edge
          ..strokeWidth = focused ? 3 : 2
          ..style = PaintingStyle.stroke);

    // A boss wears a second ring, so the four of them stand out down the
    // whole route.
    if (node.isBoss) {
      canvas.drawCircle(
          c,
          r + 5,
          Paint()
            ..color = (open ? theme.danger : theme.accentDim).withAlpha(160)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke);
    }

    if (focused) {
      canvas.drawCircle(
          c,
          r + 10,
          Paint()
            ..color = theme.accent.withAlpha(60)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke);
    }

    _text(canvas, c, open ? '${i + 1}' : '🔒',
        color: open ? theme.textPrimary : theme.textSecondary,
        size: open ? 15 : 12);

    // Stars sit under the marker, as many pips as the node awards.
    final earned = state.starsFor(i);
    final total = node.starObjectives.length;
    if (done && total > 0) {
      _text(canvas, Offset(c.dx, c.dy + r + 10),
          '${'★' * earned}${'·' * (total - earned)}',
          color: earned > 0 ? theme.upgrade : theme.textSecondary, size: 11);
    }
  }

  void _text(Canvas canvas, Offset center, String s,
      {required Color color, required double size}) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
            color: color, fontSize: size, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.focus != focus ||
      old.state.currentNode != state.currentNode ||
      old.state.completed.length != state.completed.length;
}
