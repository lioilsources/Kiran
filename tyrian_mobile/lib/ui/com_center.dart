import 'dart:async';
import 'package:flame/components.dart' show Sprite;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/tyrian_game.dart';
import '../game/platform_config.dart' as platform;
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../entities/vessel.dart';
import '../input/gamepad_input.dart';
import '../services/save_service.dart';
import '../services/asset_library.dart';
import 'high_scores.dart';
import 'ui_theme.dart';
import 'skin_painter.dart';

/// Ported from ComCenter.cls — the shop/equipment screen.
/// Aligned with original VBA layout: ship stats + scores left, weapon cards right.
class ComCenterScreen extends StatefulWidget {
  final TyrianGame game;
  final VoidCallback onStart;
  final VoidCallback? onJoinIp;

  const ComCenterScreen({
    super.key,
    required this.game,
    required this.onStart,
    this.onJoinIp,
  });

  @override
  State<ComCenterScreen> createState() => _ComCenterScreenState();
}

class _ComCenterScreenState extends State<ComCenterScreen>
    with SingleTickerProviderStateMixin {
  TyrianGame get game => widget.game;
  Vessel get vessel => game.vessel;

  // Weapon selection
  int _selectedWeaponIndex = 0;
  int _sectionIndex = 0; // 0=front, 1=side, 2=gen

  // Side slot target for buy (LB/RB gamepad or tap →L/→R)
  WeaponSlot _targetSideSlot = WeaponSlot.leftGun;

  // High scores
  List<HighScoreEntry> _highScores = [];
  bool _showScores = false;

  // Pilot name field (persistent controller so the cursor doesn't reset)
  late final TextEditingController _pilotController;

  // Easter-egg cheats panel (toggled by long-pressing the title)
  bool _cheatsEnabled = false;

  // Animated background
  late AnimationController _bgAnim;
  int _bgPhase = 0;

  // Per-skin visual theme
  late UiTheme _theme;

  // Gamepad polling
  final GamepadInput _gamepad = GamepadInput();
  Timer? _pollTimer;
  bool _prevUp = false, _prevDown = false;
  bool _prevLeft = false, _prevRight = false;
  bool _prevConfirm = false, _prevStart = false, _prevBack = false;
  bool _prevSell = false;
  bool _prevLb = false, _prevRb = false;
  final FocusNode _focusNode = FocusNode();

  // ── Computed section state ──
  bool get _showingSide => _sectionIndex == 1;
  bool get _showingGen => _sectionIndex == 2;

  List<DevType> get _frontWeapons {
    final maxIdx = vessel.nextWeaponLevel.clamp(0, DevType.frontWeapons.length - 1);
    return DevType.frontWeapons.sublist(0, maxIdx + 1);
  }

  List<DevType> get _sideWeapons {
    final maxIdx = vessel.nextWeaponLevel.clamp(0, DevType.sideWeapons.length - 1);
    return DevType.sideWeapons.sublist(0, maxIdx + 1);
  }

  List<DevType> get _currentWeapons {
    if (_sectionIndex == 0) return _frontWeapons;
    if (_sectionIndex == 1) return _sideWeapons;
    return [DevType.generatorBasic];
  }

  @override
  void initState() {
    super.initState();
    _pilotController = TextEditingController(text: vessel.pilotName);
    _theme = UiTheme.forSkin(AssetLibrary.instance.skinId);
    _loadScores();
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

  Future<void> _loadScores() async {
    final scores = await SaveService.loadHighScores();
    if (mounted) setState(() => _highScores = scores);
  }

  @override
  void dispose() {
    _bgAnim.dispose();
    _pollTimer?.cancel();
    _focusNode.dispose();
    _pilotController.dispose();
    super.dispose();
  }

  // ── Gamepad ──

  void _pollGamepad() async {
    await _gamepad.poll();
    if (!mounted) return;
    final gp = _gamepad.primary;

    final up = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final down = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final left = gp.dpadLeft || GamepadInput.deadzone(gp.leftStickX) < -0.5;
    final right = gp.dpadRight || GamepadInput.deadzone(gp.leftStickX) > 0.5;
    final confirm = gp.buttonA || gp.buttonX;
    final start = gp.start;
    final back = gp.buttonB;
    final sell = gp.buttonY;
    final lb = gp.leftShoulder;
    final rb = gp.rightShoulder;

    if (up && !_prevUp) _moveWeapon(-1);
    if (down && !_prevDown) _moveWeapon(1);
    if (left && !_prevLeft) _switchSection((_sectionIndex - 1).clamp(0, 2));
    if (right && !_prevRight) _switchSection((_sectionIndex + 1).clamp(0, 2));
    if (confirm && !_prevConfirm) _confirmAction();
    if (sell && !_prevSell) _sellAction();
    if ((start && !_prevStart) || (back && !_prevBack)) widget.onStart();
    // LB/RB: choose which side slot to buy into
    if (lb && !_prevLb && _showingSide) setState(() => _targetSideSlot = WeaponSlot.leftGun);
    if (rb && !_prevRb && _showingSide) setState(() => _targetSideSlot = WeaponSlot.rightGun);

    _prevUp = up; _prevDown = down;
    _prevLeft = left; _prevRight = right;
    _prevConfirm = confirm; _prevStart = start;
    _prevBack = back; _prevSell = sell;
    _prevLb = lb; _prevRb = rb;
  }

  void _moveWeapon(int delta) {
    final weapons = _currentWeapons;
    if (weapons.isEmpty) return;
    setState(() {
      _selectedWeaponIndex = (_selectedWeaponIndex + delta).clamp(0, weapons.length - 1);
    });
  }

  void _switchSection(int section) {
    if (section != _sectionIndex) {
      setState(() {
        _sectionIndex = section;
        _selectedWeaponIndex = 0;
      });
    }
  }

  void _confirmAction() {
    if (_currentWeapons.isEmpty) return;
    final weapon = _currentWeapons[_selectedWeaponIndex];
    if (_showingGen) {
      _upgradeSlot(WeaponSlot.generator);
      return;
    }
    if (_showingSide) {
      final slot = _targetSideSlot;
      final slotDevice = vessel.devices.cast<Device?>().firstWhere(
        (d) => d?.slot == slot, orElse: () => null);
      if (slotDevice != null && slotDevice.name == weapon.name) {
        _upgradeSlot(slot);
      } else {
        _buyWeaponToSlot(weapon, slot);
      }
      return;
    }
    final owned = vessel.devices.any((d) => d.name == weapon.name);
    if (owned) {
      _upgradeWeapon(weapon);
    } else {
      _buyWeapon(weapon);
    }
  }

  void _sellAction() {
    if (_showingGen) return;
    if (_currentWeapons.isEmpty) return;
    if (_showingSide) {
      _sellSlot(_targetSideSlot);
      return;
    }
    final weapon = _currentWeapons[_selectedWeaponIndex];
    final owned = vessel.devices.any((d) => d.name == weapon.name);
    if (owned) _sellWeapon(weapon);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _moveWeapon(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      _moveWeapon(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      _switchSection((_sectionIndex - 1).clamp(0, 2));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      _switchSection((_sectionIndex + 1).clamp(0, 2));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _confirmAction();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      widget.onStart();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete || key == LogicalKeyboardKey.backspace) {
      _sellAction();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Buy / Upgrade / Sell ──

  void _buyWeapon(DevType weapon) {
    if (vessel.credit < weapon.price) return;
    final slot = _showingSide ? _targetSideSlot : WeaponSlot.frontGun;
    vessel.credit -= weapon.price;
    vessel.equipWeapon(weapon, slot);
    setState(() {});
    game.saveProgress();
  }

  /// Buy a side weapon directly into a specific slot (used by →L / →R tap buttons).
  void _buyWeaponToSlot(DevType weapon, WeaponSlot slot) {
    if (vessel.credit < weapon.price) return;
    vessel.credit -= weapon.price;
    vessel.equipWeapon(weapon, slot);
    setState(() => _targetSideSlot = slot);
    game.saveProgress();
  }

  void _upgradeWeapon(DevType weapon) {
    final device = vessel.devices.firstWhere((d) => d.name == weapon.name);
    if (device.level >= Device.maxLevel) return;
    final cost = device.price;
    if (vessel.credit < cost) return;

    vessel.credit -= cost;
    device.upgrade();
    setState(() {});
    game.saveProgress();
  }

  void _sellWeapon(DevType weapon) {
    final device = vessel.devices.firstWhere((d) => d.name == weapon.name);
    vessel.credit += device.price;
    vessel.removeWeapon(device.slot);
    setState(() {});
    game.saveProgress();
  }

  /// Slot-based upgrade — reliable even when the same side weapon occupies both
  /// left and right slots (name-based lookup would only hit the first one).
  void _upgradeSlot(WeaponSlot slot) {
    final device = vessel.getDevice(slot);
    if (device == null || device.level >= Device.maxLevel) return;
    final cost = device.price;
    if (vessel.credit < cost) return;
    vessel.credit -= cost;
    device.upgrade();
    setState(() {});
    game.saveProgress();
  }

  /// Slot-based sell — operates on the exact slot, not the first name match.
  void _sellSlot(WeaponSlot slot) {
    if (slot == WeaponSlot.generator) return; // generator cannot be sold
    final device = vessel.getDevice(slot);
    if (device == null) return;
    vessel.credit += device.price;
    vessel.removeWeapon(slot);
    setState(() {});
    game.saveProgress();
  }

  // ── Easter-egg cheats ──

  void _cheatMaxCredits() {
    vessel.credit = 999999999;
    // Unlock all weapon tiers so everything is buyable/upgradable.
    vessel.nextWeaponLevel = DevType.frontWeapons.length - 1;
    setState(() {});
    game.showMessage('CHEAT: credits maxed, all weapons unlocked');
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
                if (_cheatsEnabled) _buildCheatBar(),
                // Compact stats strip
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildPilotName()),
                          const SizedBox(width: 12),
                          _buildGenInfo(),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildShipPreview(),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStatValues()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildSlotList(),
                    ],
                  ),
                ),
                Container(height: 1, color: _theme.accent.withAlpha(30)),
                // Section tabs
                _buildSectionTabs(),
                Container(height: 1, color: _theme.accent.withAlpha(30)),
                // Weapon cards — selected section only, full width
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActiveSection(),
                        const SizedBox(height: 16),
                        _buildScoresPanel(),
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

  Widget _buildSectionTabs() {
    return Row(
      children: [
        _buildTab('FRONT', 0),
        Container(width: 1, color: _theme.accentDim),
        _buildTab('SIDE', 1),
        Container(width: 1, color: _theme.accentDim),
        _buildTab('GENERATOR', 2),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _sectionIndex == index;
    final tabSprite = isActive ? AssetLibrary.instance.getIcon('ui_tab_active') : null;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _sectionIndex = index;
          _selectedWeaponIndex = 0;
        }),
        child: spriteBox(
          sprite: tabSprite,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: tabSprite != null
                ? Colors.transparent
                : (isActive ? _theme.surfaceLight : Colors.transparent),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _theme.styled(TextStyle(
                color: isActive ? _theme.accent : _theme.accentDim,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 1,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSection() {
    Widget section;
    if (_sectionIndex == 2) {
      section = _buildGeneratorSection();
    } else if (_sectionIndex == 1) {
      section = _buildSideSection();
    } else {
      section = _buildWeaponGrid(_frontWeapons);
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(key: ValueKey(_sectionIndex), child: section),
    );
  }

  Widget _buildWeaponGrid(List<DevType> weapons) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < weapons.length; i++)
              SizedBox(
                width: cardWidth,
                child: _buildWeaponCard(weapons[i], i),
              ),
          ],
        );
      },
    );
  }

  // Two independent columns — one per side slot.
  Widget _buildSideSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSlotColumn(WeaponSlot.leftGun, 'LEFT')),
        const SizedBox(width: 8),
        Expanded(child: _buildSlotColumn(WeaponSlot.rightGun, 'RIGHT')),
      ],
    );
  }

  Widget _buildSlotColumn(WeaponSlot slot, String label) {
    final isActive = _targetSideSlot == slot;
    final slotDevice = vessel.devices.cast<Device?>().firstWhere(
      (d) => d?.slot == slot,
      orElse: () => null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _targetSideSlot = slot),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF1a1a4e) : Colors.transparent,
              border: Border.all(
                color: isActive ? Colors.cyanAccent : Colors.white24,
                width: isActive ? 1.5 : 0.5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.cyanAccent : Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.black26,
          child: Text(
            slotDevice != null
                ? '${slotDevice.name} Lv.${slotDevice.level}'
                : '— empty —',
            style: TextStyle(
              color: slotDevice != null ? Colors.greenAccent : Colors.white24,
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        for (int i = 0; i < _sideWeapons.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _buildSlotWeaponCard(_sideWeapons[i], i, slot, isActive),
          ),
      ],
    );
  }

  Widget _buildSlotWeaponCard(DevType weapon, int index, WeaponSlot slot, bool columnActive) {
    final isSelected = columnActive && _selectedWeaponIndex == index;
    final slotDevice = vessel.devices.cast<Device?>().firstWhere(
      (d) => d?.slot == slot,
      orElse: () => null,
    );
    final owned = slotDevice?.name == weapon.name;
    final canAfford = vessel.credit >= weapon.price;

    Color borderColor;
    if (isSelected) {
      borderColor = _theme.accent;
    } else if (owned) {
      borderColor = _theme.success.withAlpha(120);
    } else {
      borderColor = _theme.accentDim.withAlpha(60);
    }

    final cardSprite = isSelected ? null : AssetLibrary.instance.getIcon('ui_card_bg');
    return GestureDetector(
      onTap: () => setState(() {
        _targetSideSlot = slot;
        _selectedWeaponIndex = index;
      }),
      onDoubleTap: () {
        setState(() {
          _targetSideSlot = slot;
          _selectedWeaponIndex = index;
        });
        if (owned) {
          _upgradeSlot(slot);
        } else if (canAfford) {
          _buyWeaponToSlot(weapon, slot);
        }
      },
      child: AnimatedScale(
        scale: isSelected ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: spriteBox(
          sprite: cardSprite,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardSprite != null
                  ? Colors.transparent
                  : (isSelected ? _theme.surfaceLight : _theme.surfaceMid),
              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owned ? '${weapon.name} ${_romanLevel(slotDevice!.level)}' : weapon.name,
                  style: TextStyle(
                    color: owned ? _theme.success : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'DMG:${weapon.damage} SPD:${weapon.speed}',
                  style: const TextStyle(color: Colors.white54, fontSize: 9),
                ),
                Text(
                  'PWR:${weapon.pwrNeed.toInt()}${weapon.beam > 0 ? " BEAM" : ""}',
                  style: TextStyle(
                    color: weapon.beam > 0 ? Colors.purpleAccent : Colors.white38,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                if (owned)
                  Row(
                    children: [
                      Text('OWNED', style: TextStyle(color: _theme.success, fontSize: 9)),
                      const Spacer(),
                      if (slotDevice!.level < Device.maxLevel)
                        Text(
                          '${slotDevice.price.toInt()}cr',
                          style: TextStyle(color: _theme.upgrade, fontSize: 8),
                        ),
                    ],
                  )
                else
                  Text(
                    '${weapon.price} cr',
                    style: TextStyle(
                      color: canAfford ? _theme.upgrade : _theme.danger.withAlpha(150),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  _buildSlotCardAction(weapon, owned, canAfford, slotDevice, slot),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCardAction(DevType weapon, bool owned, bool canAfford, Device? device, WeaponSlot slot) {
    if (owned) {
      final atMax = device!.level >= Device.maxLevel;
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: atMax ? null : () => _upgradeSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: atMax ? Colors.white10 : Colors.blue.withAlpha(60),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  atMax ? 'MAX' : 'UPGRADE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: atMax ? Colors.white24 : Colors.lightBlueAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _sellSlot(slot),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(40),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'SELL',
                style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: canAfford ? () => _buyWeaponToSlot(weapon, slot) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: canAfford ? Colors.green.withAlpha(60) : Colors.white10,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            canAfford ? 'BUY' : 'NO CREDITS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: canAfford ? Colors.greenAccent : Colors.white24,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _theme.accent.withAlpha(60))),
      ),
      child: Row(
        children: [
          // Long-press the title to toggle the hidden cheats panel (easter egg).
          GestureDetector(
            onLongPress: () {
              setState(() => _cheatsEnabled = !_cheatsEnabled);
              game.showMessage(
                  _cheatsEnabled ? 'Cheats enabled' : 'Cheats disabled');
            },
            child: Text(
              'COMMAND CENTER',
              style: _theme.styled(TextStyle(
                color: _theme.accent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              )),
            ),
          ),
          const Spacer(),
          Text(
            'Credits: ${vessel.credit}',
            style: _theme.styled(TextStyle(
              color: _theme.success,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
          ),
          if (game.isCoop && game.vessel2 != null) ...[
            const SizedBox(width: 12),
            Text(
              'P2: ${game.vessel2!.pilotName}',
              style: const TextStyle(color: Color(0xFF00FF80), fontSize: 12),
            ),
          ],
          if (game.coopRole == CoopRole.host && game.hostIp != null) ...[
            const SizedBox(width: 12),
            Text(
              'IP: ${game.hostIp}',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShipPreview() {
    final sprite = AssetLibrary.instance.vesselFrames.isNotEmpty
        ? AssetLibrary.instance.vesselFrames.first
        : AssetLibrary.instance.getSprite('vessel');
    return Container(
      width: 72,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: _theme.accent.withAlpha(40)),
        borderRadius: BorderRadius.circular(_theme.cornerRadius),
        color: Colors.black26,
      ),
      padding: const EdgeInsets.all(4),
      child: sprite != null
          ? CustomPaint(painter: _ShipPreviewPainter(sprite))
          : Center(
              child: Text(
                'Lv ${game.currentSectorIndex + 1}',
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
          const Text(
            'CHEATS',
            style: TextStyle(
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
              child: const Text(
                'MAX CREDITS',
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
          // Sector jump stepper
          _cheatStepButton('◀', () => _cheatJumpSector(-1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Lv ${game.currentSectorIndex + 1}',
              style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
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
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPilotName() {
    return TextField(
      controller: _pilotController,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: 'Pilot',
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _theme.accent),
        ),
      ),
      onChanged: (v) {
        vessel.pilotName = v;
        game.saveProgress();
      },
    );
  }

  Widget _buildStatValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _statChip('HP', '${vessel.hp}/${vessel.hpMax}', Colors.redAccent),
            const SizedBox(width: 8),
            _statChip('SH', '${vessel.shield.toInt()}/${vessel.shieldMax.toInt()}', Colors.cyanAccent),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _statChip('GEN', '${vessel.genValue.toInt()}/${vessel.genMax.toInt()}', Colors.yellowAccent),
            const SizedBox(width: 8),
            _statChip('DPS', vessel.totalDps.toStringAsFixed(1), Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Expanded(
      child: Row(
        children: [
          Text('$label ', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSlotList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlotRow('Front', WeaponSlot.frontGun),
        _buildSlotRow('Left', WeaponSlot.leftGun),
        _buildSlotRow('Right', WeaponSlot.rightGun),
        _buildSlotRow('Gen', WeaponSlot.generator),
      ],
    );
  }

  Widget _buildSlotRow(String label, WeaponSlot slot) {
    final device = vessel.devices.cast<Device?>().firstWhere(
      (d) => d?.slot == slot,
      orElse: () => null,
    );
    final name = device != null ? '${device.name} Lv.${device.level}' : '---';
    final color = device != null ? Colors.greenAccent : Colors.white24;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ),
          Expanded(
            child: Text(name, style: TextStyle(color: color, fontSize: 10)),
          ),
          if (device != null && slot != WeaponSlot.generator) ...[
            GestureDetector(
              onTap: device.level >= Device.maxLevel
                  ? null
                  : () => _upgradeSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  device.level >= Device.maxLevel ? 'MAX' : 'UPG',
                  style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 8),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _sellSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'SELL',
                  style: TextStyle(color: Colors.redAccent, fontSize: 8),
                ),
              ),
            ),
          ],
          if (device != null && slot == WeaponSlot.generator)
            GestureDetector(
              onTap: device.level >= Device.maxLevel
                  ? null
                  : () => _upgradeSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  device.level >= Device.maxLevel ? 'MAX' : 'UPG',
                  style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenInfo() {
    return Text(
      vessel.genInfo,
      style: TextStyle(
        color: vessel.generatorLoad > 100 ? Colors.redAccent : Colors.yellowAccent,
        fontSize: 10,
      ),
    );
  }

  /// Collapsible TOP SCORES section shown below the weapon grid (VBA Top-10 panel).
  Widget _buildScoresPanel() {
    if (_highScores.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: Colors.white12),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _showScores = !_showScores),
          child: Row(
            children: [
              Text(
                _showScores ? '▼ TOP SCORES' : '▶ TOP SCORES',
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        if (_showScores) ...[
          const SizedBox(height: 6),
          _buildScoreTable(),
        ],
      ],
    );
  }

  Widget _buildScoreTable() {
    if (_highScores.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _highScores.length && i < 10; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  child: Text(
                    '${i + 1}.',
                    style: TextStyle(
                      color: i < 3 ? Colors.cyanAccent : Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _highScores[i].name,
                    style: TextStyle(
                      color: i < 3 ? Colors.cyanAccent : Colors.white54,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Lv${_highScores[i].level}',
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_highScores[i].score}',
                  style: TextStyle(
                    color: i < 3 ? Colors.yellowAccent : Colors.white54,
                    fontSize: 9,
                    fontWeight: i < 3 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Weapon card ──

  Widget _buildWeaponCard(DevType weapon, int index) {
    final isSelected = !_showingGen && _selectedWeaponIndex == index;
    final owned = vessel.devices.any((d) => d.name == weapon.name);
    final canAfford = vessel.credit >= weapon.price;
    final device = owned
        ? vessel.devices.firstWhere((d) => d.name == weapon.name)
        : null;

    Color borderColor;
    if (isSelected) {
      borderColor = _theme.accent;
    } else if (owned) {
      borderColor = _theme.success.withAlpha(120);
    } else {
      borderColor = _theme.accentDim.withAlpha(60);
    }

    final cardSprite = isSelected ? null : AssetLibrary.instance.getIcon('ui_card_bg');
    return GestureDetector(
      onTap: () => setState(() => _selectedWeaponIndex = index),
      onDoubleTap: () {
        setState(() => _selectedWeaponIndex = index);
        _confirmAction();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: spriteBox(
          sprite: cardSprite,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardSprite != null
                  ? Colors.transparent
                  : (isSelected ? _theme.surfaceLight : _theme.surfaceMid),
              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owned ? '${weapon.name} ${_romanLevel(device!.level)}' : weapon.name,
                  style: TextStyle(
                    color: owned ? _theme.success : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'DMG:${weapon.damage} SPD:${weapon.speed}',
                  style: const TextStyle(color: Colors.white54, fontSize: 9),
                ),
                Text(
                  'PWR:${weapon.pwrNeed.toInt()}${weapon.beam > 0 ? " BEAM" : ""}',
                  style: TextStyle(
                    color: weapon.beam > 0 ? Colors.purpleAccent : Colors.white38,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                if (owned)
                  Row(
                    children: [
                      Text('OWNED', style: TextStyle(color: _theme.success, fontSize: 9)),
                      const Spacer(),
                      if (device!.level < Device.maxLevel)
                        Text(
                          '${device.price}cr',
                          style: TextStyle(color: _theme.upgrade, fontSize: 8),
                        ),
                    ],
                  )
                else
                  Text(
                    '${weapon.price} cr',
                    style: TextStyle(
                      color: canAfford ? _theme.upgrade : _theme.danger.withAlpha(150),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 4),
                if (isSelected) _buildCardAction(weapon, owned, canAfford, device),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardAction(DevType weapon, bool owned, bool canAfford, Device? device) {
    if (owned) {
      final atMax = device!.level >= Device.maxLevel;
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: atMax ? null : () => _upgradeWeapon(weapon),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: atMax ? Colors.white10 : Colors.blue.withAlpha(60),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  atMax ? 'MAX' : 'UPGRADE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: atMax ? Colors.white24 : Colors.lightBlueAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _sellWeapon(weapon),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(40),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'SELL',
                style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: canAfford ? () => _buyWeapon(weapon) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: canAfford ? Colors.green.withAlpha(60) : Colors.white10,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            canAfford ? 'BUY' : 'NO CREDITS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: canAfford ? Colors.greenAccent : Colors.white24,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  // ── Generator section ──

  Widget _buildGeneratorSection() {
    final isFocused = _showingGen;
    final gen = DevType.generatorBasic;
    final device = vessel.devices.cast<Device?>().firstWhere(
      (d) => d?.slot == WeaponSlot.generator,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENERATOR',
          style: TextStyle(
            color: isFocused ? Colors.cyanAccent : Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() {
            _sectionIndex = 2;
            _selectedWeaponIndex = 0;
          }),
          onDoubleTap: () {
            setState(() {
              _sectionIndex = 2;
              _selectedWeaponIndex = 0;
            });
            _confirmAction();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFocused ? const Color(0xFF1a1a4e) : const Color(0xFF0a0a1e),
              border: Border.all(
                color: isFocused ? Colors.cyanAccent : Colors.greenAccent.withAlpha(120),
                width: isFocused ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device != null
                      ? '${gen.name} ${_romanLevel(device.level)}'
                      : gen.name,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'PWR: +${gen.pwrGen.toStringAsFixed(2)}/fr',
                  style: const TextStyle(color: Colors.white54, fontSize: 9),
                ),
                Text(
                  'Cap: ${vessel.genMax.toInt()}',
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('OWNED', style: TextStyle(color: Colors.greenAccent, fontSize: 9)),
                    const Spacer(),
                    if (device != null && device.level < Device.maxLevel)
                      Text(
                        '${device.price.toInt()}cr',
                        style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 8),
                      ),
                  ],
                ),
                if (isFocused && device != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: device.level >= Device.maxLevel
                        ? null
                        : () => _upgradeSlot(WeaponSlot.generator),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: device.level >= Device.maxLevel
                            ? Colors.white10
                            : Colors.blue.withAlpha(60),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        device.level >= Device.maxLevel ? 'MAX' : 'UPGRADE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: device.level >= Device.maxLevel
                              ? Colors.white24
                              : Colors.lightBlueAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _romanLevel(int level) {
    const numerals = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX',
      'XXI', 'XXII', 'XXIII', 'XXIV', 'XXV'];
    return level >= 0 && level < numerals.length ? numerals[level] : '$level';
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
              style: _theme.styled(TextStyle(
                color: btnSprite != null ? _theme.accent : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final label = game.currentSectorIndex == 0 ? 'START MISSION' : 'CONTINUE MISSION';
    final showJoin = widget.onJoinIp != null &&
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
                '[OPTIONS / B]  Continue mission     [LB / RB]  Side slot L / R',
                style: TextStyle(color: _theme.accentDim.withAlpha(120), fontSize: 9),
              ),
            ),
          Row(
            children: [
              if (showJoin) ...[
                GestureDetector(
                  onTap: widget.onJoinIp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orangeAccent.withAlpha(150)),
                      borderRadius: BorderRadius.circular(_theme.cornerRadius),
                    ),
                    child: Text(
                      'JOIN',
                      style: _theme.styled(const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(child: _buildStartButton(label)),
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
      return Stack(children: [
        Positioned.fill(
          child: CustomPaint(
            painter: SpritePainter(bgSprite, darkOverlay: 0.55),
          ),
        ),
        CustomPaint(
          painter: _GridPainter(phase: phase, color: theme.accent),
          size: Size.infinite,
        ),
      ]);
    }

    // Fallback: animated gradient in skin's hue range
    final hue = HSLColor.fromColor(theme.accent).hue;
    final t = phase / 12.0;
    final c1 = HSLColor.fromAHSL(1, (hue + t * 20) % 360, 0.6, 0.08).toColor();
    final c2 = HSLColor.fromAHSL(1, (hue + 30 + t * 20) % 360, 0.5, 0.03).toColor();
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
  bool shouldRepaint(_GridPainter old) => old.phase != phase || old.color != color;
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
    canvas.drawImageRect(sprite.image, src, dst, Paint()..filterQuality = FilterQuality.none);
  }

  @override
  bool shouldRepaint(_ShipPreviewPainter old) => old.sprite != sprite;
}
