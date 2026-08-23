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
import 'ui_theme.dart';
import 'skin_painter.dart';
import 'skin_selector.dart' show SkinShopSection;

/// Ported from ComCenter.cls — the shop/equipment screen.
/// Aligned with original VBA layout: ship stats + scores left, weapon cards right.
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

class _ComCenterScreenState extends State<ComCenterScreen>
    with SingleTickerProviderStateMixin {
  TyrianGame get game => widget.game;
  Vessel get vessel => game.vessel;

  // Weapon selection
  int _selectedWeaponIndex = 0;

  /// Desktop weapon-list scroll + per-card keys so gamepad focus can call
  /// Scrollable.ensureVisible — same pattern as SkinSelector._scrollToFocus.
  /// Without it the pad selection walks off-screen with no way back.
  final ScrollController _weaponScroll = ScrollController();
  final Map<int, GlobalKey> _weaponCardKeys = {};
  int _sectionIndex = 0; // 0=front, 1=side, 2=gen

  // Side slot target for buy (LB/RB gamepad or tap →L/→R)
  WeaponSlot _targetSideSlot = WeaponSlot.leftGun;

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
    _weaponScroll.dispose();
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
    final confirm = gp.buttonB;
    final sell = gp.buttonX || gp.buttonY;
    final start = gp.start;
    final back = gp.back;
    final lb = gp.leftShoulder;
    final rb = gp.rightShoulder;

    if (up && !_prevUp) _moveWeapon(-1);
    if (down && !_prevDown) _moveWeapon(1);
    // D-pad left/right: switch side gun slot when in Side tab
    if (left && !_prevLeft && _showingSide) setState(() => _targetSideSlot = WeaponSlot.leftGun);
    if (right && !_prevRight && _showingSide) setState(() => _targetSideSlot = WeaponSlot.rightGun);
    if (confirm && !_prevConfirm) _confirmAction();
    // X/Y = sell — previously keyboard-only (Delete/Backspace), which left a
    // pad-only Steam Deck player unable to sell anything (Steam plan, Fix 6).
    if (sell && !_prevSell) _sellAction();
    if ((start && !_prevStart) || (back && !_prevBack)) widget.onStart();
    // LB/RB: switch between Front / Side / Generator tabs
    if (lb && !_prevLb) _switchSection((_sectionIndex - 1).clamp(0, 2));
    if (rb && !_prevRb) _switchSection((_sectionIndex + 1).clamp(0, 2));

    _prevUp = up; _prevDown = down;
    _prevLeft = left; _prevRight = right;
    _prevConfirm = confirm;
    _prevSell = sell; _prevStart = start;
    _prevBack = back;
    _prevLb = lb; _prevRb = rb;
  }

  void _moveWeapon(int delta) {
    final weapons = _currentWeapons;
    if (weapons.isEmpty) return;
    setState(() {
      _selectedWeaponIndex = (_selectedWeaponIndex + delta).clamp(0, weapons.length - 1);
    });
    _scrollWeaponIntoView();
  }

  void _scrollWeaponIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _weaponCardKeys[_selectedWeaponIndex]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: 0.5);
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
      if (_showingSide) {
        setState(() { _targetSideSlot = WeaponSlot.leftGun; _selectedWeaponIndex = 0; });
      } else {
        _switchSection((_sectionIndex - 1).clamp(0, 2));
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      if (_showingSide) {
        setState(() { _targetSideSlot = WeaponSlot.rightGun; _selectedWeaponIndex = 0; });
      } else {
        _switchSection((_sectionIndex + 1).clamp(0, 2));
      }
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

  void _animateCreditChange(int delta) {
    setState(() {
      _creditDelta = delta;
      _showCreditDelta = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showCreditDelta = false);
    });
  }

  void _buyWeapon(DevType weapon) {
    if (vessel.credit < weapon.price) return;
    final slot = _showingSide ? _targetSideSlot : WeaponSlot.frontGun;
    vessel.credit -= weapon.price;
    vessel.equipWeapon(weapon, slot);
    _animateCreditChange(-weapon.price);
    game.saveProgress();
  }

  /// Buy a side weapon directly into a specific slot (used by →L / →R tap buttons).
  void _buyWeaponToSlot(DevType weapon, WeaponSlot slot) {
    if (vessel.credit < weapon.price) return;
    vessel.credit -= weapon.price;
    vessel.equipWeapon(weapon, slot);
    _animateCreditChange(-weapon.price);
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
    _animateCreditChange(-cost);
    game.saveProgress();
  }

  void _sellWeapon(DevType weapon) {
    final device = vessel.devices.firstWhere((d) => d.name == weapon.name);
    final gained = device.price;
    vessel.credit += gained;
    vessel.removeWeapon(device.slot);
    _animateCreditChange(gained);
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
    _animateCreditChange(-cost);
    game.saveProgress();
  }

  /// Slot-based sell — operates on the exact slot, not the first name match.
  void _sellSlot(WeaponSlot slot) {
    if (slot == WeaponSlot.generator) return; // generator cannot be sold
    final device = vessel.getDevice(slot);
    if (device == null) return;
    final gained = device.price;
    vessel.credit += gained;
    vessel.removeWeapon(slot);
    _animateCreditChange(gained);
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
                if (platform.isDesktop)
                  // Two real columns: outfitting on the left, the skin picker
                  // filling the right — previously the right ~2/3 of a 1080p
                  // screen was a blank Expanded (Steam plan, Fix 5). SKINS no
                  // longer sits under the OUTFITTING header: in a paid build
                  // skins are a cosmetic picker, not merchandise (Fix 9/de-store).
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 560,
                          child: Column(
                            children: [
                              if (_cheatsEnabled) _buildCheatBar(),
                              _sectionHeader('STATS'),
                              _buildStatsAndSlots(),
                              _sectionHeader('LOADOUT'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: _buildSlotList(),
                              ),
                              _sectionHeader('OUTFITTING'),
                              _buildSectionTabs(),
                              Container(height: 1, color: _theme.accent.withAlpha(30)),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _weaponScroll,
                                  padding: const EdgeInsets.all(12),
                                  child: _buildActiveSection(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, color: _theme.accent.withAlpha(30)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionHeader('SKINS'),
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
                else ...[
                  // Whole content scrolls as one unit — stats/progress bars and
                  // section tabs scroll away with the weapon list so the list
                  // gets the full screen height instead of the cramped leftover.
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cheatsEnabled) _buildCheatBar(),
                          _sectionHeader('STATS'),
                          _buildStatsAndSlots(),
                          _sectionHeader('LOADOUT'),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: _buildSlotList(),
                          ),
                          _sectionHeader('SHOP'),
                          _buildSectionTabs(),
                          Container(height: 1, color: _theme.accent.withAlpha(30)),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildActiveSection(),
                              ],
                            ),
                          ),
                          _sectionHeader('SKINS'),
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
                ],
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsAndSlots() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPilotName()),
              const SizedBox(width: 12),
              Flexible(child: _buildGenInfo()),
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
        ],
      ),
    );
  }

  /// Section label — a short accent bar and near-white caps. The shop is where
  /// the player parks between sectors; the three zones (ship stats, current
  /// loadout, shop) need to read as zones at a glance.
  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Row(
        children: [
          Container(width: 4, height: 12, color: _theme.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: _theme.styled(TextStyle(
              color: Colors.white.withAlpha(165),
              fontSize: _fs(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )),
          ),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: _theme.accent.withAlpha(50))),
        ],
      ),
    );
  }

  double _fs(double mobile) => platform.isDesktop ? mobile + 4 : mobile + 2;

  /// A skin was switched (or bought) from the SKINS section below the shop.
  /// The new skin's assets are already loaded; restyle this screen and the
  /// game behind it now — the player gets back into the game only when they
  /// tap Continue Mission, same as before.
  void _onSkinChanged(String id) {
    game.refreshSprites();
    setState(() => _theme = UiTheme.forSkin(AssetLibrary.instance.skinId));
  }

  Widget _buildSectionTabs() {
    return Row(
      children: [
        _buildTab('FRONT', 0),
        Container(width: 1, color: _theme.accentDim),
        _buildTab('SIDE', 1),
        Container(width: 1, color: _theme.accentDim),
        _buildTab('GEN', 2),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _sectionIndex == index;
    // No ui_tab_active sprite here on purpose: its glowing accent stripe runs
    // straight through the label and reads as strikethrough.
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _sectionIndex = index;
          _selectedWeaponIndex = 0;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? _theme.accent.withAlpha(36) : Colors.transparent,
            // The active marker is a thick accent underline — visible on any
            // skin. Inactive labels use near-white, never accentDim: the dim
            // shades (e.g. 0xFF004411) vanish against the dark backgrounds.
            border: Border(
              bottom: BorderSide(
                color: isActive ? _theme.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          // FittedBox: Press Start 2P is the widest face in the game — labels
          // must shrink, never wrap.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _theme.styled(TextStyle(
                color: isActive ? _theme.accent : Colors.white.withAlpha(165),
                fontSize: _fs(12),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
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
    return Column(
      children: [
        for (int i = 0; i < weapons.length; i++)
          Padding(
            key: _weaponCardKeys.putIfAbsent(i, () => GlobalKey()),
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildWeaponCard(weapons[i], i),
          ),
      ],
    );
  }

  Widget _buildSideSection() {
    final slotDevice = vessel.devices.cast<Device?>().firstWhere(
      (d) => d?.slot == _targetSideSlot,
      orElse: () => null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildSideSubTab(WeaponSlot.leftGun, 'LEFT'),
            Container(width: 1, color: _theme.accentDim),
            _buildSideSubTab(WeaponSlot.rightGun, 'RIGHT'),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: _theme.surfaceDark,
          child: Text(
            slotDevice != null
                ? '${slotDevice.name} Lv.${slotDevice.level}'
                : 'NO WEAPON INSTALLED',
            style: _theme.styled(TextStyle(
              color: slotDevice != null
                  ? _theme.success
                  : Colors.white.withAlpha(120),
              fontSize: 11,
            )),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < _sideWeapons.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSlotWeaponCard(_sideWeapons[i], i, _targetSideSlot, true),
          ),
      ],
    );
  }

  Widget _buildSideSubTab(WeaponSlot slot, String label) {
    final isActive = _targetSideSlot == slot;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _targetSideSlot = slot;
          _selectedWeaponIndex = 0;
        }),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color:
                  isActive ? _theme.accent.withAlpha(36) : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: isActive ? _theme.accent : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _theme.styled(TextStyle(
                color: isActive ? _theme.accent : Colors.white.withAlpha(165),
                fontSize: _fs(11),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              )),
            )),
      ),
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

    final cardSprite = AssetLibrary.instance.getIcon('ui_card_bg');
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
        child: spriteCardBox(
          sprite: cardSprite,
          darkOverlay: isSelected ? 0.0 : (!owned && !canAfford ? 0.6 : 0.35),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: cardSprite != null
                  ? Colors.transparent
                  : (isSelected ? _theme.surfaceLight : _theme.surfaceMid),
              border: cardSprite != null
                  ? null
                  : Border.all(color: borderColor, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owned ? '${weapon.name} ${_romanLevel(slotDevice!.level)}' : weapon.name,
                  style: _theme.styled(TextStyle(
                    color: owned ? _theme.success : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'DMG:${weapon.damage} SPD:${weapon.speed}',
                  style: _theme.styled(TextStyle(color: _theme.accentDim, fontSize: 11)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'PWR:${weapon.pwrNeed.toInt()}${weapon.beam > 0 ? " BEAM" : ""}',
                  style: _theme.styled(TextStyle(
                    color: weapon.beam > 0 ? _theme.accent : _theme.accentDim,
                    fontSize: 11,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
                if (weapon.guide > 0)
                  Text(
                    'GUIDED',
                    style: _theme.styled(TextStyle(color: _theme.accent, fontSize: 10, letterSpacing: 0.5)),
                  ),
                const SizedBox(height: 4),
                if (owned)
                  Row(
                    children: [
                      Text('OWNED', style: _theme.styled(TextStyle(color: _theme.success, fontSize: 11))),
                      const Spacer(),
                      if (slotDevice!.level < Device.maxLevel)
                        Text(
                          '${fmtNum(slotDevice.price)}cr',
                          style: _theme.styled(TextStyle(
                              color: _theme.upgrade,
                              fontSize: _fs(13),
                              fontWeight: FontWeight.bold)),
                        ),
                    ],
                  )
                else
                  Text(
                    '${fmtNum(weapon.price)} cr',
                    style: _theme.styled(TextStyle(
                      color: canAfford
                          ? _theme.upgrade
                          : _theme.danger.withAlpha(150),
                      fontSize: _fs(14),
                      fontWeight: FontWeight.bold,
                    )),
                    overflow: TextOverflow.ellipsis,
                  ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: isSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 4),
                            _buildSlotCardAction(weapon, owned, canAfford, slotDevice, slot),
                          ],
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
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
                // 44pt-class touch target (iPhone 12 mini is the floor).
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: atMax ? Colors.white10 : _theme.upgrade.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: atMax
                          ? Colors.white12
                          : _theme.upgrade.withAlpha(130)),
                ),
                child: Text(
                  atMax ? 'MAX' : 'UPGRADE',
                  textAlign: TextAlign.center,
                  style: _theme.styled(TextStyle(
                    color: atMax ? _theme.accentDim : _theme.upgrade,
                    fontSize: _fs(13),
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _sellSlot(slot),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: _theme.danger.withAlpha(50),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _theme.danger.withAlpha(130)),
              ),
              child: Text(
                'SELL',
                style: _theme.styled(TextStyle(
                    color: _theme.danger,
                    fontSize: _fs(13),
                    fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: canAfford ? _theme.success.withAlpha(50) : Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color:
                    canAfford ? _theme.success.withAlpha(130) : Colors.white12),
          ),
          child: Text(
            canAfford ? 'BUY' : 'NO CREDITS',
            textAlign: TextAlign.center,
            style: _theme.styled(TextStyle(
              color: canAfford ? _theme.success : Colors.white.withAlpha(140),
              fontSize: _fs(13),
              fontWeight: FontWeight.bold,
            )),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: title + P2 name (co-op)
          Row(
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
              if (game.isCoop && game.vessel2 != null) ...[
                const Spacer(),
                Text(
                  'P2: ${game.vessel2!.pilotName}',
                  style: const TextStyle(color: Color(0xFF00FF80), fontSize: 12),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          // Row 2: credits (with delta animation) + IP on same line, no overlap
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CreditsWave(
                    prefix: 'Credits: ',
                    value: vessel.credit,
                    textAlign: TextAlign.left,
                    style: _theme.styled(TextStyle(
                      color: _theme.success,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
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
                            color: _creditDelta >= 0 ? _theme.success : _theme.danger,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (game.coopRole == CoopRole.host && game.hostIp != null) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'IP: ${game.hostIp}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withAlpha(110), fontSize: 10),
                  ),
                ),
              ],
            ],
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
                'Lv ${Sector.levelForIndex(game.currentSectorIndex)}',
                style: _theme.styled(TextStyle(
                  color: _theme.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
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
              'Lv ${Sector.levelForIndex(game.currentSectorIndex)}',
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
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Pilot',
        labelStyle: TextStyle(color: _theme.accentDim, fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _theme.accentDim),
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

  Widget _buildStatValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HealthBar(
          label: 'HP',
          value: vessel.hp.toDouble(),
          maxValue: vessel.hpMax.toDouble(),
          color: _theme.danger,
          height: 12,
          icon: _statIcon('icon_life'),
          labelStyle: _theme.styled(TextStyle(color: _theme.danger, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        HealthBar(
          label: 'SH',
          value: vessel.shield,
          maxValue: vessel.shieldMax,
          color: _theme.accent,
          height: 12,
          icon: _statIcon('icon_shield'),
          labelStyle: _theme.styled(TextStyle(color: _theme.accent, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        HealthBar(
          label: 'GEN',
          value: vessel.genValue,
          maxValue: vessel.genMax,
          color: _theme.upgrade,
          height: 12,
          icon: _statIcon('icon_gen'),
          labelStyle: _theme.styled(TextStyle(color: _theme.upgrade, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('DPS ', style: _theme.styled(TextStyle(color: _theme.accent, fontSize: _fs(10), fontWeight: FontWeight.bold))),
            Text(vessel.totalDps.toStringAsFixed(1), style: _theme.styled(TextStyle(color: Colors.white70, fontSize: _fs(10)))),
          ],
        ),
        const SizedBox(height: 4),
        // Score survives death and never resets, so it doubles as the weapon
        // unlock track and the leaderboard value — the player has to be able
        // to see it and the next tier they are working toward.
        Row(
          children: [
            Text('SCORE ', style: _theme.styled(TextStyle(color: _theme.accent, fontSize: _fs(10), fontWeight: FontWeight.bold))),
            Text(fmtNum(vessel.score), style: _theme.styled(TextStyle(color: Colors.white70, fontSize: _fs(10)))),
          ],
        ),
        if (_nextUnlockScore != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Text('NEXT WEAPON ', style: _theme.styled(TextStyle(color: _theme.upgrade, fontSize: _fs(9), fontWeight: FontWeight.bold))),
              Text('${fmtNum(_nextUnlockScore! - vessel.score)} pts',
                  style: _theme.styled(TextStyle(color: Colors.white54, fontSize: _fs(9)))),
            ],
          ),
        ],
      ],
    );
  }

  /// Score needed for the next weapon tier, or null once everything is
  /// unlocked. [Vessel.wepLevScores] is indexed by the tier being worked on.
  int? get _nextUnlockScore {
    final tier = vessel.nextWeaponLevel;
    if (tier >= Vessel.wepLevScores.length) return null;
    if (tier >= DevType.frontWeapons.length) return null;
    return Vessel.wepLevScores[tier];
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
    final color = device != null ? _theme.success : _theme.accentDim;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            // FittedBox, not wrap: Press Start 2P rendered 'Front:' as a
            // one-character-per-line ladder in a 42px column.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '$label:',
                maxLines: 1,
                style: _theme.styled(TextStyle(
                    color: Colors.white.withAlpha(150), fontSize: _fs(10))),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(name, style: _theme.styled(TextStyle(color: color, fontSize: _fs(10)))),
          ),
          if (device != null && slot != WeaponSlot.generator) ...[
            GestureDetector(
              onTap: device.level >= Device.maxLevel
                  ? null
                  : () => _upgradeSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: _theme.upgrade.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  device.level >= Device.maxLevel ? 'MAX' : 'UPG',
                  style: _theme.styled(
                      TextStyle(color: _theme.upgrade, fontSize: _fs(11))),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _sellSlot(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: _theme.danger.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'SELL',
                  style: _theme.styled(
                      TextStyle(color: _theme.danger, fontSize: _fs(11))),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: _theme.upgrade.withAlpha(40),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  device.level >= Device.maxLevel ? 'MAX' : 'UPG',
                  style: _theme.styled(
                      TextStyle(color: _theme.upgrade, fontSize: _fs(11))),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenInfo() {
    final load = vessel.generatorLoad;
    final color = load > 100 ? _theme.danger : (load > 70 ? _theme.upgrade : _theme.success);
    final barRatio = (load / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PWR ', style: _theme.styled(TextStyle(color: _theme.accentDim, fontSize: _fs(9)))),
            Text('${load.round()}%', style: _theme.styled(TextStyle(color: color, fontSize: _fs(9), fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 64,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(color: Colors.black45),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: barRatio,
                  child: Container(color: color),
                ),
              ],
            ),
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

    final cardSprite = AssetLibrary.instance.getIcon('ui_card_bg');
    return GestureDetector(
      onTap: () => setState(() => _selectedWeaponIndex = index),
      onDoubleTap: () {
        setState(() => _selectedWeaponIndex = index);
        _confirmAction();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: spriteCardBox(
          sprite: cardSprite,
          darkOverlay: isSelected ? 0.0 : (!owned && !canAfford ? 0.6 : 0.35),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: cardSprite != null
                  ? Colors.transparent
                  : (isSelected ? _theme.surfaceLight : _theme.surfaceMid),
              border: cardSprite != null
                  ? null
                  : Border.all(color: borderColor, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owned ? '${weapon.name} ${_romanLevel(device!.level)}' : weapon.name,
                  style: _theme.styled(TextStyle(
                    color: owned ? _theme.success : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'DMG:${weapon.damage} SPD:${weapon.speed}',
                  style: _theme.styled(TextStyle(color: _theme.accentDim, fontSize: 11)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'PWR:${weapon.pwrNeed.toInt()}${weapon.beam > 0 ? " BEAM" : ""}',
                  style: _theme.styled(TextStyle(
                    color: weapon.beam > 0 ? _theme.accent : _theme.accentDim,
                    fontSize: 11,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
                if (weapon.guide > 0)
                  Text(
                    'GUIDED',
                    style: _theme.styled(TextStyle(color: _theme.accent, fontSize: 10, letterSpacing: 0.5)),
                  ),
                const SizedBox(height: 4),
                if (owned)
                  Row(
                    children: [
                      Text('OWNED', style: _theme.styled(TextStyle(color: _theme.success, fontSize: 11))),
                      const Spacer(),
                      if (device!.level < Device.maxLevel)
                        Text(
                          '${fmtNum(device.price)}cr',
                          style: _theme.styled(TextStyle(
                              color: _theme.upgrade,
                              fontSize: _fs(13),
                              fontWeight: FontWeight.bold)),
                        ),
                    ],
                  )
                else
                  Text(
                    '${fmtNum(weapon.price)} cr',
                    style: _theme.styled(TextStyle(
                      color: canAfford
                          ? _theme.upgrade
                          : _theme.danger.withAlpha(150),
                      fontSize: _fs(14),
                      fontWeight: FontWeight.bold,
                    )),
                    overflow: TextOverflow.ellipsis,
                  ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: isSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 4),
                            _buildCardAction(weapon, owned, canAfford, device),
                          ],
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
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
                // 44pt-class touch target (iPhone 12 mini is the floor).
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: atMax ? Colors.white10 : _theme.upgrade.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: atMax
                          ? Colors.white12
                          : _theme.upgrade.withAlpha(130)),
                ),
                child: Text(
                  atMax ? 'MAX' : 'UPGRADE',
                  textAlign: TextAlign.center,
                  style: _theme.styled(TextStyle(
                    color: atMax ? _theme.accentDim : _theme.upgrade,
                    fontSize: _fs(13),
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _sellWeapon(weapon),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: _theme.danger.withAlpha(50),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _theme.danger.withAlpha(130)),
              ),
              child: Text(
                'SELL',
                style: _theme.styled(TextStyle(
                    color: _theme.danger,
                    fontSize: _fs(13),
                    fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: canAfford ? _theme.success.withAlpha(50) : Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color:
                    canAfford ? _theme.success.withAlpha(130) : Colors.white12),
          ),
          child: Text(
            canAfford ? 'BUY' : 'NO CREDITS',
            textAlign: TextAlign.center,
            style: _theme.styled(TextStyle(
              color: canAfford ? _theme.success : Colors.white.withAlpha(140),
              fontSize: _fs(13),
              fontWeight: FontWeight.bold,
            )),
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
    final cardSprite = AssetLibrary.instance.getIcon('ui_card_bg');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENERATOR',
          style: _theme.styled(TextStyle(
            color: isFocused ? _theme.accent : _theme.accentDim,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          )),
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
          child: spriteCardBox(
            sprite: cardSprite,
            darkOverlay: isFocused ? 0.0 : 0.35,
            child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: cardSprite != null
                  ? Colors.transparent
                  : (isFocused ? _theme.surfaceLight : _theme.surfaceMid),
              border: cardSprite != null
                  ? null
                  : Border.all(
                      color: isFocused ? _theme.accent : _theme.success.withAlpha(120),
                      width: isFocused ? 2 : 1,
                    ),
              borderRadius: BorderRadius.circular(_theme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device != null
                      ? '${gen.name} ${_romanLevel(device.level)}'
                      : gen.name,
                  style: _theme.styled(TextStyle(
                    color: _theme.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'PWR: +${(device?.pwrGen ?? gen.pwrGen).toStringAsFixed(2)}/fr',
                  style: _theme.styled(TextStyle(color: _theme.accentDim, fontSize: 9)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Cap: ${vessel.genMax.toInt()}',
                  style: _theme.styled(TextStyle(color: _theme.accentDim, fontSize: 9)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('OWNED', style: _theme.styled(TextStyle(color: _theme.success, fontSize: 9))),
                    const Spacer(),
                    if (device != null && device.level < Device.maxLevel)
                      Text(
                        '${fmtNum(device.price)}cr',
                        style: _theme.styled(TextStyle(
                            color: _theme.upgrade,
                            fontSize: _fs(12),
                            fontWeight: FontWeight.bold)),
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
                            : _theme.upgrade.withAlpha(40),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        device.level >= Device.maxLevel ? 'MAX' : 'UPGRADE',
                        textAlign: TextAlign.center,
                        style: _theme.styled(TextStyle(
                          color: device.level >= Device.maxLevel
                              ? _theme.accentDim
                              : _theme.upgrade,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ),
        ),
      ],
    );
  }

  String _romanLevel(int level) => 'Lv.$level';

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
                '[B] Buy/Upgrade   [X/Y] Sell   [LB/RB] Tabs   [OPTIONS] Continue mission',
                style: TextStyle(color: _theme.accentDim.withAlpha(120), fontSize: 12),
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
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: _theme.accent.withAlpha(150)),
                      borderRadius: BorderRadius.circular(_theme.cornerRadius),
                    ),
                    child: Text(
                      'HOST',
                      style: _theme.styled(TextStyle(
                        color: _theme.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (game.coopRole == CoopRole.host && game.vessel2 == null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'HOSTING  ${game.hostIp ?? ''}',
                    style: _theme.styled(TextStyle(
                      color: _theme.accentDim,
                      fontSize: 11,
                      letterSpacing: 1,
                    )),
                  ),
                ),
              ],
              if (showJoin) ...[
                GestureDetector(
                  onTap: widget.onJoinIp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: _theme.upgrade.withAlpha(150)),
                      borderRadius: BorderRadius.circular(_theme.cornerRadius),
                    ),
                    child: Text(
                      'JOIN',
                      style: _theme.styled(TextStyle(
                        color: _theme.upgrade,
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
