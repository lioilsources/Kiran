import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/platform_config.dart' as platform;
import '../input/gamepad_input.dart';
import '../services/asset_library.dart';
import '../systems/campaign.dart';
import '../systems/campaign_tracker.dart';
import 'format.dart';
import 'ui_theme.dart';

/// The objective list, shown twice: as a briefing on the map (no progress
/// yet) and as the score sheet on the result card.
class ObjectiveLines extends StatelessWidget {
  final UiTheme theme;
  final List<ObjectiveSpec> specs;
  final List<ObjectiveStatus>? statuses;
  final bool compact;

  const ObjectiveLines.briefing(this.specs,
      {super.key, required this.theme, this.compact = true})
      : statuses = null;

  const ObjectiveLines.result(this.statuses,
      {super.key, required this.theme, this.compact = false})
      : specs = const [];

  @override
  Widget build(BuildContext context) {
    final rows = statuses ??
        [for (final s in specs) ObjectiveStatus(s, 0, s.amount, false)];
    final graded = statuses != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final o in rows)
          Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 1 : 3),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  child: Text(
                    graded ? (o.met ? '✓' : '✗') : (o.required ? '•' : '★'),
                    style: theme.styled(TextStyle(
                      color: graded
                          ? (o.met ? theme.success : theme.danger)
                          : (o.required ? theme.accent : theme.upgrade),
                      fontSize: compact ? 12 : 15,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
                Expanded(
                  child: Text(
                    o.spec.text,
                    style: theme.styled(TextStyle(
                      color: graded && !o.met
                          ? theme.textSecondary
                          : theme.textPrimary,
                      fontSize: compact ? 12 : 14,
                    )),
                  ),
                ),
                if (!o.required && !graded)
                  Text(
                    'STAR',
                    style: theme.styled(TextStyle(
                      color: theme.upgrade.withAlpha(170),
                      fontSize: compact ? 9 : 11,
                      letterSpacing: 1,
                    )),
                  ),
                if (graded && o.tally.isNotEmpty)
                  Text(
                    o.tally,
                    style: theme.styled(TextStyle(
                      color: o.met ? theme.success : theme.textSecondary,
                      fontSize: compact ? 11 : 13,
                    )),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// End-of-node score sheet: which tasks came in, how many stars, what the run
/// paid, and where to go next.
class CampaignResultCard extends StatefulWidget {
  final CampaignNode node;
  final NodeResult result;
  final int creditsEarned;

  /// Back to the map — only offered once the node is actually cleared.
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  const CampaignResultCard({
    super.key,
    required this.node,
    required this.result,
    required this.creditsEarned,
    required this.onContinue,
    required this.onRetry,
  });

  @override
  State<CampaignResultCard> createState() => _CampaignResultCardState();
}

class _CampaignResultCardState extends State<CampaignResultCard> {
  late UiTheme _theme;
  final _focusNode = FocusNode();
  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  int _index = 0;
  bool _prevUp = false, _prevDown = false;
  // Start true so the shot that killed the last enemy is not read as a press.
  bool _prevConfirm = true;

  List<(String, VoidCallback)> get _items => [
        if (widget.result.requiredMet) ('CONTINUE', widget.onContinue),
        (widget.result.requiredMet ? 'REPLAY NODE' : 'RETRY', widget.onRetry),
      ];

  @override
  void initState() {
    super.initState();
    _theme = UiTheme.forSkin(AssetLibrary.instance.skinId);
    if (platform.isDesktop) {
      _pollTimer = Timer.periodic(
          const Duration(milliseconds: 16), (_) => _pollGamepad());
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
    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final confirm = gp.buttonB || gp.buttonA || gp.start;
    final items = _items;
    if (up && !_prevUp) {
      setState(() => _index = (_index - 1).clamp(0, items.length - 1));
    }
    if (down && !_prevDown) {
      setState(() => _index = (_index + 1).clamp(0, items.length - 1));
    }
    if (confirm && !_prevConfirm) items[_index.clamp(0, items.length - 1)].$2();
    _prevUp = up;
    _prevDown = down;
    _prevConfirm = confirm;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    final items = _items;
    if (k == LogicalKeyboardKey.arrowUp) {
      setState(() => _index = (_index - 1).clamp(0, items.length - 1));
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      setState(() => _index = (_index + 1).clamp(0, items.length - 1));
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      items[_index.clamp(0, items.length - 1)].$2();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final cleared = r.requiredMet;
    final items = _items;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Container(
        color: Colors.black.withAlpha(220),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            padding: const EdgeInsets.all(22),
            constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
              color: _theme.surfaceDark,
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
              border: Border.all(
                  color: cleared ? _theme.success : _theme.danger, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cleared ? 'NODE CLEARED' : 'NODE FAILED',
                  style: _theme.styled(TextStyle(
                    color: cleared ? _theme.success : _theme.danger,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  )),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.node.index + 1}. ${widget.node.caption}',
                  style: _theme.styled(TextStyle(
                    color: _theme.textSecondary,
                    fontSize: 13,
                    letterSpacing: 1,
                  )),
                ),
                const SizedBox(height: 16),
                ObjectiveLines.result(r.objectives, theme: _theme),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      '★ ${r.starCount} / ${r.starTotal}',
                      style: _theme.styled(TextStyle(
                        color: _theme.upgrade,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    const Spacer(),
                    Text(
                      '+${fmtNum(widget.creditsEarned)} cr',
                      style: _theme.styled(TextStyle(
                        color: _theme.success,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ],
                ),
                if (!cleared) ...[
                  const SizedBox(height: 10),
                  Text(
                    'The required tasks decide the node. Fly it again — what '
                    'you earned stays with you.',
                    style: _theme.styled(TextStyle(
                      color: _theme.textSecondary,
                      fontSize: 12,
                    )),
                  ),
                ],
                const SizedBox(height: 18),
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: items[i].$2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: i == _index
                              ? _theme.surfaceLight
                              : _theme.surfaceMid,
                          borderRadius:
                              BorderRadius.circular(_theme.cornerRadius),
                          border: Border.all(
                            color: i == _index
                                ? _theme.accent
                                : _theme.accentDim.withAlpha(120),
                            width: i == _index ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            items[i].$1,
                            style: _theme.styled(TextStyle(
                              color: i == _index
                                  ? _theme.accent
                                  : _theme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
