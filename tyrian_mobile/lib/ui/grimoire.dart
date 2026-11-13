import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/platform_config.dart' as platform;
import '../input/gamepad_input.dart';
import '../l10n/l10n.dart';
import '../rendering/sigil_hud.dart';
import '../systems/sigils/sigil_catalog.dart';
import '../systems/sigils/sigil_spec.dart';
import 'sigil_glyph.dart';

/// One line on what a sigil does, in the player's language. The name itself
/// is a proper noun and never translated.
String sigilDescription(SigilKind k, AppLocalizations l) => switch (k) {
      SigilKind.hop => l.sigilDescHop,
      SigilKind.sidestep => l.sigilDescSidestep,
      SigilKind.strike => l.sigilDescStrike,
      SigilKind.retreat => l.sigilDescRetreat,
      SigilKind.dash => l.sigilDescDash,
      SigilKind.roll => l.sigilDescRoll,
      SigilKind.shadow => l.sigilDescShadow,
      SigilKind.echo => l.sigilDescEcho,
      SigilKind.loop => l.sigilDescLoop,
      SigilKind.slalom => l.sigilDescSlalom,
      SigilKind.corkscrew => l.sigilDescCorkscrew,
      SigilKind.snapshot => l.sigilDescSnapshot,
      SigilKind.broadside => l.sigilDescBroadside,
      SigilKind.volley => l.sigilDescVolley,
      SigilKind.caltrop => l.sigilDescCaltrop,
      SigilKind.frenzy => l.sigilDescFrenzy,
      SigilKind.stasis => l.sigilDescStasis,
      SigilKind.halo => l.sigilDescHalo,
      SigilKind.radial => l.sigilDescRadial,
      SigilKind.storm => l.sigilDescStorm,
      SigilKind.ping => l.sigilDescPing,
      SigilKind.wingman => l.sigilDescWingman,
      SigilKind.hunter => l.sigilDescHunter,
      SigilKind.warden => l.sigilDescWarden,
      SigilKind.formation => l.sigilDescFormation,
      SigilKind.whirl => l.sigilDescWhirl,
      SigilKind.sacrifice => l.sigilDescSacrifice,
    };

/// Every sigil at a glance (Prompts/28 §10): the View button opens it over
/// a paused game. Three columns, one per layer, each sigil with its shape as
/// the thumb draws it on this screen, its cost and what it does.
class GrimoireOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const GrimoireOverlay({super.key, required this.onClose});

  @override
  State<GrimoireOverlay> createState() => _GrimoireOverlayState();
}

class _GrimoireOverlayState extends State<GrimoireOverlay> {
  final _focus = FocusNode();
  final GamepadInput _pad = GamepadInput();
  Timer? _poll;
  // Held at open: the press that opened it must be let go first.
  bool _prev = true;

  @override
  void initState() {
    super.initState();
    if (platform.isDesktop) {
      _poll = Timer.periodic(const Duration(milliseconds: 16), (_) => _pollPad());
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _pollPad() async {
    await _pad.poll();
    if (!mounted) return;
    final gp = _pad.primary;
    final any = gp.back || gp.buttonA || gp.buttonB || gp.start;
    if (any && !_prev) widget.onClose();
    _prev = any;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Positioned.fill(
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: (n, e) {
          if (e is KeyDownEvent &&
              (e.logicalKey == LogicalKeyboardKey.escape ||
                  e.logicalKey == LogicalKeyboardKey.enter ||
                  e.logicalKey == LogicalKeyboardKey.tab)) {
            widget.onClose();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTap: widget.onClose,
          child: Container(
            color: Colors.black.withValues(alpha: 0.82),
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.grimoire,
                    style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6)),
                const SizedBox(height: 4),
                Text(l.grimoireHint,
                    style: const TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 14),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final layer in SigilLayer.values)
                        Expanded(child: _column(context, layer)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _column(BuildContext context, SigilLayer layer) {
    final l = context.l10n;
    final col = SigilHud.layerColors[layer]!;
    final head = switch (layer) {
      SigilLayer.hull => 'HULL',
      SigilLayer.arms => 'ARMS · LB',
      SigilLayer.wing => 'WING · RB',
    };
    final sigils = SigilCatalog.inLayer(layer).toList()
      ..sort((a, b) => a.tier.compareTo(b.tier));
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(head,
              style: TextStyle(
                  color: col,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                for (final s in sigils)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SigilGlyph(spec: s, size: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(s.name,
                                    style: TextStyle(
                                        color: col,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5)),
                                const SizedBox(width: 8),
                                Text(l.sigilCost(s.cost),
                                    style: const TextStyle(
                                        color: Color(0xFFB98CFF), fontSize: 11)),
                                if (s.phase != null) ...[
                                  const SizedBox(width: 6),
                                  Text(l.sigilUntouchable,
                                      style: const TextStyle(
                                          color: Color(0xFF7CF0FF), fontSize: 11)),
                                ],
                              ]),
                              Text(sigilDescription(s.kind, l),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 11.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
