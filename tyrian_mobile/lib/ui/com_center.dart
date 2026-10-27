import 'dart:async';
import 'package:flame/components.dart' show Sprite;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../rendering/health_bar.dart';
import '../game/tyrian_game.dart';
import '../systems/sector.dart';
import 'credits_wave.dart';
import 'format.dart';
import '../game/platform_config.dart' as platform;
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../entities/vessel.dart';
import '../input/gamepad_input.dart';
import '../services/asset_library.dart';
import 'loadout_cursor.dart';
import 'ui_theme.dart';
import 'skin_painter.dart';
import 'skin_selector.dart' show SkinShopSection;
import '../l10n/l10n.dart';

/// Ported from ComCenter.cls — the between-sector equipment screen.
///
/// Loadout-first: there is no separate shop. Each of the four LOADOUT rows
/// (FRONT / LEFT / RIGHT / GEN) shows the weapon catalogue for that slot as
/// chips; the UPG/BUY and SELL buttons act on the selected chip. Owned
/// weapons that are not fitted wait in [Vessel.hangar] with their level, so
/// switching between them is a tap and costs nothing.
class ComCenterScreen extends StatefulWidget {
  final TyrianGame game;
  final VoidCallback onStart;
  final VoidCallback? onJoinIp;

  /// Start hosting a co-op game. Hosting is opt-in from here — it used to
  /// start on every PLAY, spamming the LAN and popping the Windows firewall
  /// prompt behind the fullscreen window for purely solo players.
  final VoidCallback? onHost;

  const ComCenterScreen({
    super.key,
    required this.game,
    required this.onStart,
    this.onJoinIp,
    this.onHost,
  });

  @override
  State<ComCenterScreen> createState() => _ComCenterScreenState();
}

/// One focusable cell of a loadout row, in left-to-right order.
sealed class _Cell {
  const _Cell();
}

class _ChipCell extends _Cell {
  final DevType type;
  const _ChipCell(this.type);
}

class _ActionCell extends _Cell {
  const _ActionCell();
}

class _SellCell extends _Cell {
  const _SellCell();
}

/// Weapon family of a [DevType], from its sprite key — the big and small
/// variant of a weapon share one (bubble, vulcan, laser).
enum _Family { bubble, vulcan, blaster, star, laser }

_Family? _familyOf(DevType t) => switch (t.imgName) {
  'bubble' => _Family.bubble,
  'vulcan' => _Family.vulcan,
  'blaster' => _Family.blaster,
  'starg' => _Family.star,
  'laser' => _Family.laser,
  _ => null,
};

const _familyColors = {
  _Family.bubble: Color(0xFF4FA8FF),
  _Family.vulcan: Color(0xFFFF8A3D),
  _Family.blaster: Color(0xFFB66DFF),
  _Family.star: Color(0xFFFFD84A),
  _Family.laser: Color(0xFF3DF2FF),
};

class _ComCenterScreenState extends State<ComCenterScreen>
    with SingleTickerProviderStateMixin {
  TyrianGame get game => widget.game;
  Vessel get vessel => game.vessel;
  AppLocalizations get _l => context.l10n;

  static const _rows = [
    WeaponSlot.frontGun,
    WeaponSlot.leftGun,
    WeaponSlot.rightGun,
    WeaponSlot.generator,
  ];

  /// A not-yet-owned chip the player tapped to see its BUY price, per slot.
  /// Null means the buttons act on the fitted weapon.
  final Map<WeaponSlot, DevType?> _pending = {};

  final LoadoutCursor _cursor = LoadoutCursor();

  // Pilot name field (persistent controller so the cursor doesn't reset)
  late final TextEditingController _pilotController;

  // Easter-egg cheats panel (toggled by long-pressing the title)
  bool _cheatsEnabled = false;

  // Animated background
  late AnimationController _bgAnim;
  int _bgPhase = 0;

  // Per-skin visual theme
  late UiTheme _theme;

  // Credit change animation
  int _creditDelta = 0;
  bool _showCreditDelta = false;

  // "Unlocks at …" toast throttle, so mashing a locked chip doesn't stack.
  DateTime _lastLockedToast = DateTime.fromMillisecondsSinceEpoch(0);

  // Gamepad polling
  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevUp = false, _prevDown = false;
  bool _prevLeft = false, _prevRight = false;
  bool _prevConfirm = false, _prevStart = false, _prevBack = false;
  bool _prevSell = false;
  bool _prevLb = false, _prevRb = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pilotController = TextEditingController(text: vessel.pilotName);
    _theme = UiTheme.forSkin(AssetLibrary.instance.skinId);
    _bgAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // 12 phases × ~67ms
    )..repeat();
    _bgAnim.addListener(() {
      final newPhase = (_bgAnim.value * 12).floor() % 12;
      if (newPhase != _bgPhase) {
        setState(() => _bgPhase = newPhase);
      }
    });
    if (platform.isDesktop) {
      _pollTimer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) => _pollGamepad(),
      );
    }
  }

  @override
  void dispose() {
    _bgAnim.dispose();
    _pollTimer?.cancel();
    _focusNode.dispose();
    _pilotController.dispose();
    super.dispose();
  }

  // ── Loadout model ──

  /// The catalogue shown in a weapon row, locked tiers included.
  List<DevType> _catalogue(WeaponSlot slot) =>
      slot == WeaponSlot.frontGun ? DevType.frontWeapons : DevType.sideWeapons;

  /// Tier i is offered once the score passed wepLevScores[i - 1] — the same
  /// rule as the old `sublist(0, nextWeaponLevel + 1)`.
  bool _unlocked(int index) => index <= vessel.nextWeaponLevel;

  /// Score that unlocks catalogue tier [index] (index ≥ 1).
  int _unlockScore(int index) =>
      Vessel.wepLevScores[(index - 1).clamp(0, Vessel.wepLevScores.length - 1)];

  /// The chip the buttons act on: a pending purchase, else the fitted weapon.
  DevType? _selected(WeaponSlot slot) {
    final pending = _pending[slot];
    if (pending != null) return pending;
    final fitted = vessel.getDevice(slot);
    if (fitted == null) return null;
    return DevType.byName(fitted.name);
  }

  List<_Cell> _cells(WeaponSlot slot) {
    if (slot == WeaponSlot.generator) {
      return vessel.getDevice(slot) == null ? const [] : const [_ActionCell()];
    }
    final cat = _catalogue(slot);
    final cells = <_Cell>[
      for (var i = 0; i < cat.length; i++)
        if (_unlocked(i)) _ChipCell(cat[i]),
    ];
    if (_selected(slot) != null) cells.add(const _ActionCell());
    if (_pending[slot] == null && vessel.getDevice(slot) != null) {
      cells.add(const _SellCell());
    }
    return cells;
  }

  List<int> get _cellCounts => [for (final s in _rows) _cells(s).length];

  /// Bottom-bar buttons in the order _buildBottomBar lays them out.
  List<String> get _bottomActions => [
    if (widget.onHost != null &&
        game.coopRole == CoopRole.none &&
        game.vessel2 == null)
      'host',
    if (widget.onJoinIp != null &&
        game.coopRole != CoopRole.client &&
        game.vessel2 == null)
      'join',
    'start',
  ];

  bool _cellFocused(WeaponSlot slot, _Cell cell) {
    if (!platform.isDesktop) return false;
    if (_cursor.region != LoadoutRegion.loadout) return false;
    if (_rows[_cursor.row] != slot) return false;
    final cells = _cells(slot);
    if (_cursor.cell >= cells.length) return false;
    final c = cells[_cursor.cell];
    return switch ((c, cell)) {
      (_ChipCell a, _ChipCell b) => a.type.name == b.type.name,
      (_ActionCell _, _ActionCell _) => true,
      (_SellCell _, _SellCell _) => true,
      _ => false,
    };
  }

  bool _bottomFocused(String action) {
    if (!platform.isDesktop) return false;
    if (_cursor.region != LoadoutRegion.bottomBar) return false;
    final actions = _bottomActions;
    return actions[_cursor.bottomIndex.clamp(0, actions.length - 1)] == action;
  }

  // ── Actions ──

  void _tapChip(WeaponSlot slot, int index) {
    final type = _catalogue(slot)[index];
    if (!_unlocked(index)) {
      final now = DateTime.now();
      if (now.difference(_lastLockedToast) > const Duration(seconds: 2)) {
        _lastLockedToast = now;
        game.showMessage(_l.unlocksAt(fmtNum(_unlockScore(index))));
      }
      return;
    }
    final fitted = vessel.getDevice(slot);
    setState(() {
      if (fitted?.name == type.name) {
        _pending[slot] = null;
      } else if (vessel.hangarEntry(type.name, slot) != null) {
        // Owned: switching is free and keeps the level.
        vessel.fitWeapon(type, slot);
        _pending[slot] = null;
        game.saveProgress();
      } else {
        _pending[slot] = type;
      }
    });
  }

  void _activateAction(WeaponSlot slot) {
    final pending = _pending[slot];
    if (pending != null) {
      _buy(pending, slot);
    } else {
      _upgradeSlot(slot);
    }
  }

  void _buy(DevType type, WeaponSlot slot) {
    if (vessel.credit < type.price) return;
    vessel.credit -= type.price;
    vessel.fitWeapon(type, slot);
    _pending[slot] = null;
    _animateCreditChange(-type.price);
    game.saveProgress();
  }

  void _upgradeSlot(WeaponSlot slot) {
    final device = vessel.getDevice(slot);
    if (device == null || device.level >= Device.maxLevel) return;
    final cost = device.price;
    if (vessel.credit < cost) return;
    vessel.credit -= cost;
    device.upgrade();
    _animateCreditChange(-cost);
    game.saveProgress();
  }

  /// Sell the fitted weapon. The slot stays empty even when the hangar holds
  /// something for it: switching is the player's call.
  void _sellSlot(WeaponSlot slot) {
    final gained = vessel.sellFitted(slot);
    if (gained == 0) return;
    _pending[slot] = null;
    _animateCreditChange(gained);
    game.saveProgress();
  }

  void _animateCreditChange(int delta) {
    setState(() {
      _creditDelta = delta;
      _showCreditDelta = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showCreditDelta = false);
    });
  }

  // ── Pad / keyboard ──

  void _moveRow(int delta) => setState(
    () => _cursor.moveRow(delta, _cellCounts, _bottomActions.length),
  );

  void _cycleRow(int delta) =>
      setState(() => _cursor.cycle(delta, _cellCounts, _bottomActions.length));

  void _moveCell(int delta) => setState(
    () => _cursor.moveCell(delta, _cellCounts, _bottomActions.length),
  );

  void _confirm() {
    if (_cursor.region == LoadoutRegion.bottomBar) {
      final actions = _bottomActions;
      switch (actions[_cursor.bottomIndex.clamp(0, actions.length - 1)]) {
        case 'host':
          widget.onHost?.call();
          setState(() {});
        case 'join':
          widget.onJoinIp?.call();
        default:
          widget.onStart();
      }
      return;
    }
    final slot = _rows[_cursor.row];
    final cells = _cells(slot);
    if (cells.isEmpty) return;
    switch (cells[_cursor.cell.clamp(0, cells.length - 1)]) {
      case _ChipCell(:final type):
        _tapChip(slot, _catalogue(slot).indexOf(type));
      case _ActionCell():
        _activateAction(slot);
      case _SellCell():
        _sellSlot(slot);
    }
    setState(() => _cursor.clamp(_cells(slot).length));
  }

  /// X/Y / Delete: sell the fitted weapon of the cursor's row, wherever in the
  /// row the cursor sits.
  void _sellShortcut() {
    if (_cursor.region != LoadoutRegion.loadout) return;
    final slot = _rows[_cursor.row];
    _sellSlot(slot);
    setState(() => _cursor.clamp(_cells(slot).length));
  }

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    final gp = _gamepad.primary;

    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final left = gp.dpadLeft || GamepadInput.deadzone(gp.leftStickX) < -0.5;
    final right = gp.dpadRight || GamepadInput.deadzone(gp.leftStickX) > 0.5;
    final confirm = gp.buttonB;
    final sell = gp.buttonX || gp.buttonY;
    final start = gp.start;
    final back = gp.back;
    final lb = gp.leftShoulder;
    final rb = gp.rightShoulder;

    if (up && !_prevUp) _moveRow(-1);
    if (down && !_prevDown) _moveRow(1);
    if (left && !_prevLeft) _moveCell(-1);
    if (right && !_prevRight) _moveCell(1);
    if (confirm && !_prevConfirm) _confirm();
    // X/Y = sell — a pad-only Steam Deck player must be able to sell.
    if (sell && !_prevSell) _sellShortcut();
    if ((start && !_prevStart) || (back && !_prevBack)) widget.onStart();
    if (lb && !_prevLb) _moveRow(-1);
    if (rb && !_prevRb) _moveRow(1);

    _prevUp = up;
    _prevDown = down;
    _prevLeft = left;
    _prevRight = right;
    _prevConfirm = confirm;
    _prevSell = sell;
    _prevStart = start;
    _prevBack = back;
    _prevLb = lb;
    _prevRb = rb;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    // Same cursor model as the pad — the two must not disagree.
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _moveRow(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      _moveRow(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      _moveCell(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      _moveCell(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab) {
      _cycleRow(HardwareKeyboard.instance.isShiftPressed ? -1 : 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _confirm();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      widget.onStart();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete ||
        key == LogicalKeyboardKey.backspace) {
      _sellShortcut();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Easter-egg cheats ──

  void _cheatMaxCredits() {
    vessel.credit = 999999999;
    // Unlock all weapon tiers so everything is buyable/upgradable.
    vessel.nextWeaponLevel = DevType.frontWeapons.length - 1;
    setState(() {});
    game.showMessage(_l.cheatsMaxed);
    game.saveProgress();
  }

  void _cheatJumpSector(int delta) {
    final target = game.currentSectorIndex + delta;
    if (target < 0) return;
    game.jumpToSector(target);
    setState(() {});
    game.saveProgress();
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        children: [
          _SkinBackground(phase: _bgPhase, theme: _theme),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                if (platform.isDesktop &&
                    MediaQuery.sizeOf(context).width >= 900)
                  // Two columns: ship + loadout on the left, the skin picker
                  // filling the right. A desktop window narrowed below that
                  // falls back to the one-column phone layout.
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 600,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_cheatsEnabled) _buildCheatBar(),
                                _sectionHeader(_l.sectionStats),
                                _buildStats(),
                                _sectionHeader(_l.sectionLoadout),
                                _buildLoadout(),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, color: _theme.accent.withAlpha(30)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionHeader(_l.skins),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(12),
                                  child: SkinShopSection(
                                    crossAxisCount: 5,
                                    onSkinChanged: _onSkinChanged,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cheatsEnabled) _buildCheatBar(),
                          _sectionHeader(_l.sectionStats),
                          _buildStats(),
                          _sectionHeader(_l.sectionLoadout),
                          _buildLoadout(),
                          _sectionHeader(_l.skins),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: SkinShopSection(
                              crossAxisCount: 2,
                              onSkinChanged: _onSkinChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section label — a short accent bar and near-white caps.
  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Row(
        children: [
          Container(width: 4, height: 12, color: _theme.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: _theme.styled(
              TextStyle(
                color: Colors.white.withAlpha(165),
                fontSize: _fs(10),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(height: 1, color: _theme.accent.withAlpha(50)),
          ),
        ],
      ),
    );
  }

  double _fs(double mobile) => platform.isDesktop ? mobile + 4 : mobile + 2;

  /// A skin was switched (or bought) from the SKINS section. The new skin's
  /// assets are already loaded; restyle this screen (chip icons come from the
  /// new atlas on the next build) and the game behind it.
  void _onSkinChanged(String id) {
    game.refreshSprites();
    setState(() => _theme = UiTheme.forSkin(AssetLibrary.instance.skinId));
  }

  // ── Header: title + pilot / credits + score ──

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _theme.accent.withAlpha(60))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // The title shrinks before it pushes the pilot name off a
              // narrow phone (long localized titles, wide pixel fonts).
              Flexible(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: // Long-press the title to toggle the hidden cheats panel.
                  GestureDetector(
                    onLongPress: () {
                      setState(() => _cheatsEnabled = !_cheatsEnabled);
                      game.showMessage(
                        _cheatsEnabled ? _l.cheatsEnabled : _l.cheatsDisabled,
                      );
                    },
                    child: Text(
                      _l.commandCenter,
                      style: _theme.styled(
                        TextStyle(
                          color: _theme.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildPilotName()),
            ],
          ),
          if (game.isCoop && game.vessel2 != null)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'P2: ${game.vessel2!.pilotName}',
                style: const TextStyle(color: Color(0xFF00FF80), fontSize: 12),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CreditsWave(
                        prefix: _l.creditsPrefix,
                        value: vessel.credit,
                        textAlign: TextAlign.left,
                        style: _theme.styled(
                          TextStyle(
                            color: _theme.success,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_showCreditDelta)
                        Positioned(
                          top: -16,
                          left: 0,
                          child: AnimatedOpacity(
                            opacity: _showCreditDelta ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              _creditDelta >= 0
                                  ? '+${fmtNum(_creditDelta)} cr'
                                  : '${fmtNum(_creditDelta)} cr',
                              style: TextStyle(
                                color: _creditDelta >= 0
                                    ? _theme.success
                                    : _theme.danger,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Score survives death and never resets: it is the weapon unlock
              // track and the leaderboard value.
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _l.scoreValue(fmtNum(vessel.score)),
                    style: _theme.styled(
                      TextStyle(
                        color: _theme.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (game.coopRole == CoopRole.host && game.hostIp != null)
            Text(
              _l.ipValue(game.hostIp!),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withAlpha(110),
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPilotName() {
    return TextField(
      controller: _pilotController,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: _l.pilot,
        hintStyle: TextStyle(color: _theme.accentDim, fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _theme.accentDim.withAlpha(120)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _theme.accent),
        ),
      ),
      onChanged: (v) {
        vessel.pilotName = v;
        game.saveProgress();
      },
      // Hand the keyboard back to the cursor model when editing ends.
      onSubmitted: (_) => _focusNode.requestFocus(),
    );
  }

  // ── STATS: HP / SH / GEN / PWR / DPS / NEXT WEAPON ──

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShipPreview(),
          const SizedBox(width: 12),
          Expanded(child: _buildStatValues()),
        ],
      ),
    );
  }

  Widget? _statIcon(String key, {double size = 16}) {
    final sprite = AssetLibrary.instance.getIcon(key);
    return sprite == null
        ? null
        : SizedBox(
            width: size,
            height: size,
            child: CustomPaint(painter: SpritePainter(sprite)),
          );
  }

  TextStyle _labelStyle(Color c) => _theme.styled(
    TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.bold),
  );

  /// Fitted weapons that draw more per shot than the generator can hold —
  /// they never fire. Before the loadout rewrite nothing on screen said so.
  List<Device> get _starved => [
    for (final d in vessel.devices)
      if (d.slot != WeaponSlot.generator && d.pwrNeed > vessel.genMax) d,
  ];

  Widget _buildStatValues() {
    final load = vessel.generatorLoad;
    final overload = load > 100;
    final pwrColor = overload
        ? _theme.danger
        : (load > 70 ? _theme.upgrade : _theme.success);
    final starved = _starved;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HealthBar(
          label: _l.hudHp,
          value: vessel.hp.toDouble(),
          maxValue: vessel.hpMax.toDouble(),
          color: _theme.danger,
          height: 12,
          icon: _statIcon('icon_life'),
          labelStyle: _labelStyle(_theme.danger),
        ),
        const SizedBox(height: 5),
        HealthBar(
          label: _l.hudShield,
          value: vessel.shield,
          maxValue: vessel.shieldMax,
          color: _theme.accent,
          height: 12,
          icon: _statIcon('icon_shield'),
          labelStyle: _labelStyle(_theme.accent),
        ),
        const SizedBox(height: 5),
        HealthBar(
          label: _l.hudGen,
          value: vessel.genValue,
          maxValue: vessel.genMax,
          color: _theme.upgrade,
          height: 12,
          icon: _statIcon('icon_gen'),
          labelStyle: _labelStyle(_theme.upgrade),
        ),
        const SizedBox(height: 5),
        _buildPowerRow(load, pwrColor, overload),
        for (final d in starved)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              _l.weaponOff(_familyLabel(DevType.byName(d.name)) ?? d.name),
              style: _theme.styled(
                TextStyle(
                  color: _theme.danger,
                  fontSize: _fs(9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('${_l.dps} ', style: _labelStyle(_theme.accent)),
            Text(
              vessel.totalDps.toStringAsFixed(1),
              style: _theme.styled(
                TextStyle(color: Colors.white70, fontSize: _fs(10)),
              ),
            ),
          ],
        ),
        ..._buildNextWeapon(),
      ],
    );
  }

  /// PWR = generator load. Above 100 % the weapons outdraw the generator and
  /// fire slower than their cooldown — red, full bar, OVERLOAD.
  Widget _buildPowerRow(double load, Color color, bool overload) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(_l.power, style: _labelStyle(color)),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Container(color: Colors.black45),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (load / 100).clamp(0.0, 1.0),
                    child: Container(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              overload
                  ? '${load.round()}%  ${_l.overload}'
                  : '${load.round()}%',
              style: _theme.styled(
                TextStyle(
                  color: color,
                  fontSize: _fs(9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// NEXT WEAPON: which family the next score threshold unlocks, how far off
  /// it is, and a bar from the previous threshold. Hidden once all is open.
  List<Widget> _buildNextWeapon() {
    final tier = vessel.nextWeaponLevel;
    final nextIndex = tier + 1;
    if (tier >= Vessel.wepLevScores.length ||
        nextIndex >= DevType.frontWeapons.length) {
      return const [];
    }
    final threshold = Vessel.wepLevScores[tier];
    final prev = tier > 0 ? Vessel.wepLevScores[tier - 1] : 0;
    final span = (threshold - prev).clamp(1, 1 << 62);
    final progress = ((vessel.score - prev) / span).clamp(0.0, 1.0);
    final front = DevType.frontWeapons[nextIndex];
    final side = DevType.sideWeapons[nextIndex];
    final families = {_familyOf(front), _familyOf(side)}.whereType<_Family>();
    return [
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${_l.nextWeapon} ', style: _labelStyle(_theme.upgrade)),
                  for (final f in families) ...[
                    _familyIcon(f == _familyOf(front) ? front : side, 14),
                    const SizedBox(width: 3),
                    Text(
                      _familyName(f),
                      style: _theme.styled(
                        TextStyle(
                          color: _familyColors[f],
                          fontSize: _fs(9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                _l.pointsValue(fmtNum(threshold - vessel.score)),
                style: _theme.styled(
                  TextStyle(color: Colors.white54, fontSize: _fs(9)),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 3),
      SizedBox(
        height: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black45,
            valueColor: AlwaysStoppedAnimation(_theme.upgrade),
          ),
        ),
      ),
    ];
  }

  // ── LOADOUT ──

  String _familyName(_Family f) => switch (f) {
    _Family.bubble => _l.familyBubble,
    _Family.vulcan => _l.familyVulcan,
    _Family.blaster => _l.familyBlaster,
    _Family.star => _l.familyStar,
    _Family.laser => _l.familyLaser,
  };

  String? _familyLabel(DevType? t) {
    final f = t == null ? null : _familyOf(t);
    return f == null ? null : _familyName(f);
  }

  Widget _familyIcon(DevType t, double size) {
    final sprite = AssetLibrary.instance.getSprite(t.imgName);
    return SizedBox(
      width: size,
      height: size,
      child: sprite == null
          ? Icon(
              Icons.circle,
              size: size * 0.6,
              color: _familyColors[_familyOf(t)],
            )
          : CustomPaint(painter: SpritePainter(sprite)),
    );
  }

  Widget _buildLoadout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWeaponRow(_l.slotFront, WeaponSlot.frontGun),
          _buildWeaponRow(_l.slotLeft, WeaponSlot.leftGun),
          _buildWeaponRow(_l.slotRight, WeaponSlot.rightGun),
          _buildGeneratorRow(),
        ],
      ),
    );
  }

  Widget _rowLabel(String label) => SizedBox(
    width: 56,
    // FittedBox, not wrap: Press Start 2P rendered labels as a
    // one-character-per-line ladder in narrow columns.
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        style: _theme.styled(
          TextStyle(
            color: Colors.white.withAlpha(170),
            fontSize: _fs(10),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  Widget _buildWeaponRow(String label, WeaponSlot slot) {
    final cat = _catalogue(slot);
    final fitted = vessel.getDevice(slot);
    final pending = _pending[slot];
    final starved = _starved;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _rowLabel(label),
          for (var i = 0; i < cat.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 3),
                child: _buildChip(
                  slot: slot,
                  index: i,
                  fitted: fitted?.name == cat[i].name ? fitted : null,
                  hangar: vessel.hangarEntry(cat[i].name, slot),
                  pending: pending?.name == cat[i].name,
                  starved:
                      fitted?.name == cat[i].name && starved.contains(fitted),
                ),
              ),
            ),
          const SizedBox(width: 3),
          _buildRowButtons(slot, fitted, pending),
        ],
      ),
    );
  }

  Widget _buildChip({
    required WeaponSlot slot,
    required int index,
    required Device? fitted,
    required Device? hangar,
    required bool pending,
    required bool starved,
  }) {
    final type = _catalogue(slot)[index];
    final family = _familyOf(type);
    final famColor = _familyColors[family] ?? _theme.accent;
    final unlocked = _unlocked(index);
    final owned = fitted ?? hangar;
    final affordable = vessel.credit >= type.price;
    final focused = _cellFocused(slot, _ChipCell(type));

    final String sub;
    Color subColor = Colors.white60;
    if (!unlocked) {
      sub = _l.pointsValue(fmtNum(_unlockScore(index)));
    } else if (owned != null) {
      sub = _l.levelShort(owned.level);
      subColor = fitted != null ? Colors.white : Colors.white70;
    } else {
      sub = fmtNum(type.price);
      subColor = affordable ? _theme.upgrade : _theme.danger;
    }

    final Color border;
    final double borderWidth;
    if (starved) {
      border = _theme.danger;
      borderWidth = 2;
    } else if (fitted != null) {
      border = famColor;
      borderWidth = 2;
    } else if (pending) {
      border = _theme.upgrade;
      borderWidth = 2;
    } else if (hangar != null) {
      border = famColor.withAlpha(150);
      borderWidth = 1;
    } else {
      border = Colors.white24;
      borderWidth = 1;
    }

    return GestureDetector(
      onTap: () => _tapChip(slot, index),
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.35,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          decoration: BoxDecoration(
            color: fitted != null
                ? famColor.withAlpha(45)
                : _theme.surfaceDark.withAlpha(170),
            border: Border.all(
              color: focused ? Colors.white : border,
              width: focused ? 2.5 : borderWidth,
            ),
            borderRadius: BorderRadius.circular(_theme.cornerRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (unlocked)
                    _familyIcon(type, 14)
                  else
                    const Icon(Icons.lock, size: 12, color: Colors.white54),
                  const SizedBox(width: 2),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        family == null ? type.name : _familyName(family),
                        maxLines: 1,
                        style: _theme.styled(
                          TextStyle(
                            color: famColor,
                            fontSize: _fs(8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  sub,
                  maxLines: 1,
                  style: _theme.styled(
                    TextStyle(color: subColor, fontSize: _fs(8)),
                  ),
                ),
              ),
              // Fitted marker — the line under the weapon that flies.
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 24,
                color: fitted != null ? famColor : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button({
    required String label,
    required Color color,
    required VoidCallback? onTap,
    required bool focused,
    String? hint,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 44pt-class touch target (iPhone 12 mini is the floor). Fixed width
        // so the chips keep their size whichever buttons the row shows.
        width: _buttonWidth,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        margin: const EdgeInsets.only(left: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withAlpha(enabled ? 45 : 15),
          border: Border.all(
            color: focused ? Colors.white : color.withAlpha(enabled ? 140 : 50),
            width: focused ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(_theme.cornerRadius),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            hint == null ? label : '$label$hint',
            textAlign: TextAlign.center,
            style: _theme.styled(
              TextStyle(
                color: enabled ? color : color.withAlpha(90),
                fontSize: _fs(9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const double _buttonWidth = 60;

  String? _padHint(String button) => platform.isDesktop ? ' [$button]' : null;

  Widget _buildRowButtons(WeaponSlot slot, Device? fitted, DevType? pending) {
    final List<Widget> buttons = [];
    if (pending != null) {
      final affordable = vessel.credit >= pending.price;
      buttons.add(
        _button(
          label: '${_l.buy}\n${fmtNum(pending.price)}',
          color: affordable ? _theme.success : _theme.danger,
          onTap: affordable ? () => _buy(pending, slot) : null,
          focused: _cellFocused(slot, const _ActionCell()),
          hint: _padHint('B'),
        ),
      );
    } else if (fitted != null) {
      buttons.add(_upgradeButton(slot, fitted));
      buttons.add(
        _button(
          label: '${_l.sell}\n${fmtNum(fitted.price)}',
          color: _theme.danger,
          onTap: () => _sellSlot(slot),
          focused: _cellFocused(slot, const _SellCell()),
          hint: _padHint('X'),
        ),
      );
    }
    // Always reserve room for two buttons: selecting an unowned chip swaps
    // UPG+SELL for a single BUY and the chips must not jump.
    return SizedBox(
      width: 2 * (_buttonWidth + 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: buttons),
    );
  }

  Widget _upgradeButton(WeaponSlot slot, Device device) {
    final atMax = device.level >= Device.maxLevel;
    final affordable = vessel.credit >= device.price;
    return _button(
      label: atMax ? _l.max : '${_l.upgradeShort}\n${fmtNum(device.price)}',
      color: _theme.upgrade,
      onTap: atMax || !affordable ? null : () => _upgradeSlot(slot),
      focused: _cellFocused(slot, const _ActionCell()),
      hint: atMax ? null : _padHint('B'),
    );
  }

  Widget _buildGeneratorRow() {
    final gen = vessel.getDevice(WeaponSlot.generator);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _rowLabel(_l.slotGen),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: _theme.upgrade.withAlpha(30),
                border: Border.all(color: _theme.upgrade.withAlpha(140)),
                borderRadius: BorderRadius.circular(_theme.cornerRadius),
              ),
              child: Row(
                children: [
                  _statIcon('icon_gen', size: 18) ?? const SizedBox(width: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      gen == null
                          ? '---'
                          : '${gen.name} ${_l.levelShort(gen.level)} · ${vessel.genMax.toInt()}',
                      overflow: TextOverflow.ellipsis,
                      style: _theme.styled(
                        TextStyle(
                          color: Colors.white,
                          fontSize: _fs(9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 2 * (_buttonWidth + 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (gen != null) _upgradeButton(WeaponSlot.generator, gen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipPreview() {
    final sprite = AssetLibrary.instance.vesselFrames.isNotEmpty
        ? AssetLibrary.instance.vesselFrames.first
        : AssetLibrary.instance.getSprite('vessel');
    return Container(
      width: platform.isDesktop ? 110 : 72,
      height: platform.isDesktop ? 85 : 56,
      decoration: BoxDecoration(
        border: Border.all(color: _theme.accent.withAlpha(40)),
        borderRadius: BorderRadius.circular(_theme.cornerRadius),
        color: _theme.surfaceDark,
      ),
      padding: const EdgeInsets.all(4),
      child: sprite != null
          ? CustomPaint(painter: _ShipPreviewPainter(sprite))
          : Center(
              child: Text(
                _l.levelShort(Sector.levelForIndex(game.currentSectorIndex)),
                style: _theme.styled(
                  TextStyle(
                    color: _theme.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCheatBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.deepPurple.withAlpha(70),
      child: Row(
        children: [
          Text(
            _l.cheats,
            style: const TextStyle(
              color: Colors.purpleAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _cheatMaxCredits,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(60),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                _l.maxCredits,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Sector jump stepper
          _cheatStepButton('◀', () => _cheatJumpSector(-1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _l.levelShort(Sector.levelForIndex(game.currentSectorIndex)),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _cheatStepButton('▶', () => _cheatJumpSector(1)),
        ],
      ),
    );
  }

  Widget _cheatStepButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(60),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(String label) {
    final btnSprite = AssetLibrary.instance.getIcon('ui_button');
    return GestureDetector(
      onTap: widget.onStart,
      child: spriteBox(
        sprite: btnSprite,
        child: Container(
          height: 48,
          decoration: btnSprite == null
              ? BoxDecoration(
                  color: _theme.accent,
                  borderRadius: BorderRadius.circular(_theme.cornerRadius),
                )
              : null,
          child: Center(
            child: Text(
              label,
              style: _theme.styled(
                TextStyle(
                  color: btnSprite != null ? _theme.accent : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom bar ──

  BoxDecoration _bottomDecoration(String action, Color color) => BoxDecoration(
    color: _bottomFocused(action) ? color.withAlpha(35) : null,
    border: Border.all(
      color: _bottomFocused(action) ? Colors.white : color.withAlpha(150),
      width: _bottomFocused(action) ? 2 : 1,
    ),
    borderRadius: BorderRadius.circular(_theme.cornerRadius),
  );

  Widget _buildBottomBar() {
    final label = game.currentSectorIndex == 0
        ? _l.startMission
        : _l.continueMission;
    final showJoin =
        widget.onJoinIp != null &&
        game.coopRole != CoopRole.client &&
        game.vessel2 == null;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _theme.accent.withAlpha(60))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (platform.isDesktop)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _l.padControlsHint,
                style: TextStyle(
                  color: _theme.accentDim.withAlpha(120),
                  fontSize: 12,
                ),
              ),
            ),
          Row(
            children: [
              if (widget.onHost != null &&
                  game.coopRole == CoopRole.none &&
                  game.vessel2 == null) ...[
                GestureDetector(
                  onTap: () {
                    widget.onHost!();
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: _bottomDecoration('host', _theme.accent),
                    child: Text(
                      _l.host,
                      style: _theme.styled(
                        TextStyle(
                          color: _theme.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (game.coopRole == CoopRole.host && game.vessel2 == null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    _l.hostingAt(game.hostIp ?? ''),
                    style: _theme.styled(
                      TextStyle(
                        color: _theme.accentDim,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
              if (showJoin) ...[
                GestureDetector(
                  onTap: widget.onJoinIp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: _bottomDecoration('join', _theme.upgrade),
                    child: Text(
                      _l.join,
                      style: _theme.styled(
                        TextStyle(
                          color: _theme.upgrade,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Container(
                  decoration: _bottomFocused('start')
                      ? BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(
                            _theme.cornerRadius,
                          ),
                        )
                      : null,
                  child: _buildStartButton(label),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Skin-aware background ──

/// Shows the skin's ComCenter background sprite when available,
/// otherwise falls back to a theme-coloured animated gradient.
class _SkinBackground extends StatelessWidget {
  final int phase;
  final UiTheme theme;
  const _SkinBackground({required this.phase, required this.theme});

  @override
  Widget build(BuildContext context) {
    final bgSprite = AssetLibrary.instance.getIcon('comcenter_bg');
    if (bgSprite != null) {
      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SpritePainter(bgSprite, darkOverlay: 0.55),
            ),
          ),
          CustomPaint(
            painter: _GridPainter(phase: phase, color: theme.accent),
            size: Size.infinite,
          ),
        ],
      );
    }

    // Fallback: animated gradient in skin's hue range
    final hue = HSLColor.fromColor(theme.accent).hue;
    final t = phase / 12.0;
    final c1 = HSLColor.fromAHSL(1, (hue + t * 20) % 360, 0.6, 0.08).toColor();
    final c2 = HSLColor.fromAHSL(
      1,
      (hue + 30 + t * 20) % 360,
      0.5,
      0.03,
    ).toColor();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c1, c2],
        ),
      ),
      child: CustomPaint(
        painter: _GridPainter(phase: phase, color: theme.accent),
        size: Size.infinite,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final int phase;
  final Color color;
  _GridPainter({required this.phase, this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(8 + (phase % 3) * 2)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.phase != phase || old.color != color;
}

// Renders the current skin's vessel sprite into the ComCenter ship preview box.
class _ShipPreviewPainter extends CustomPainter {
  final Sprite sprite;
  _ShipPreviewPainter(this.sprite);

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
      sprite.srcPosition.x,
      sprite.srcPosition.y,
      sprite.srcSize.x,
      sprite.srcSize.y,
    );
    // Fit the sprite into the box preserving aspect ratio.
    final scale = (size.width / src.width).clamp(0.0, size.height / src.height);
    final w = src.width * scale;
    final h = src.height * scale;
    final dst = Rect.fromLTWH(
      (size.width - w) / 2,
      (size.height - h) / 2,
      w,
      h,
    );
    canvas.drawImageRect(
      sprite.image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(_ShipPreviewPainter old) => old.sprite != sprite;
}
