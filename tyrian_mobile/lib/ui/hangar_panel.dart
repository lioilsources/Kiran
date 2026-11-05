import 'package:flame/components.dart' show Sprite;
import 'package:flutter/material.dart';

import '../entities/vessel.dart';
import '../l10n/l10n.dart';
import '../services/asset_library.dart';
import '../systems/dev_type.dart';
import '../systems/mods/hull_spec.dart';
import '../systems/mods/mod_rack.dart';
import '../systems/mods/mod_spec.dart';
import '../systems/mods/mods_state.dart';
import '../systems/weapon_family.dart';
import 'mod_text.dart';
import 'ui_theme.dart';

/// The ComCenter's HANGAR and VAULT (Prompts/27 §6): the hull picker with the
/// ship drawn large, the four racks as rows of sockets, and the vault of
/// unfitted mods below with the forge.
///
/// Tap-first. A filled socket unfits on tap; an empty one filters the vault
/// to mods that fit it. A vault chip opens its card with a FIT button per
/// rack it can go in; long-press marks it for the forge.
class HangarPanel extends StatefulWidget {
  final Vessel vessel;
  final UiTheme theme;
  final double Function(double) fs;

  /// Something on the ship changed (stats, DPS, PWR): the ComCenter
  /// rebuilds and saves.
  final VoidCallback onChanged;
  final void Function(String) toast;

  /// The ComCenter's section header, for the VAULT heading between the two.
  final Widget Function(String) sectionHeader;

  const HangarPanel({
    required this.sectionHeader,
    super.key,
    required this.vessel,
    required this.theme,
    required this.fs,
    required this.onChanged,
    required this.toast,
  });

  @override
  State<HangarPanel> createState() => HangarPanelState();
}

class HangarPanelState extends State<HangarPanel> {
  Vessel get v => widget.vessel;
  UiTheme get t => widget.theme;
  AppLocalizations get _l => context.l10n;
  ModsState get _state => ModsState.instance;

  /// Index into [kHulls] being looked at; locked hulls can be looked at.
  late int _browse = kHulls.indexWhere((h) => h.id == v.hull.id);

  /// Vault filter; null = all.
  RackKind? _filter;
  final Set<ModInstance> _forgeSet = {};

  bool _unlocked(HullSpec h) => _state.unlockedHulls.contains(h.id);

  void _changed() {
    _state.save();
    widget.onChanged();
    setState(() {});
  }

  void _browseHull(int delta) {
    setState(() {
      _browse = (_browse + delta) % kHulls.length;
      if (_browse < 0) _browse += kHulls.length;
    });
    final h = kHulls[_browse];
    if (!_unlocked(h) || h.id == v.hull.id) return;
    final spill = v.setHull(h);
    if (spill.isNotEmpty) {
      _state.vault.addAll(spill);
      widget.toast(_l.modsSpilled(spill.length));
    }
    _changed();
  }

  void _unfit(ModInstance i) {
    if (v.unfitMod(i)) {
      _state.vault.add(i);
      _changed();
    }
  }

  String? _refusalText(FitRefusal r) => switch (r) {
    FitRefusal.wrongRack => _l.modWrongRack,
    FitRefusal.full => _l.modRackFull,
    FitRefusal.duplicate => _l.modAlreadyFitted,
  };

  void _fit(ModInstance i, RackKind r) {
    final why = v.fitMod(i, r);
    if (why != null) {
      widget.toast(_refusalText(why)!);
      return;
    }
    _state.vault.remove(i);
    _forgeSet.remove(i);
    _changed();
  }

  void _forge() {
    final made = _state.forge(_forgeSet.toList());
    _forgeSet.clear();
    if (made != null) {
      widget.toast('+ ${made.spec?.name ?? ''}');
      _changed();
    } else {
      setState(() {});
    }
  }

  void _toggleForge(ModInstance i) => setState(() {
    if (!_forgeSet.remove(i) && _forgeSet.length < 3) _forgeSet.add(i);
  });

  void _setFilter(RackKind? r) => setState(() => _filter = r);

  bool get _canForge {
    if (_forgeSet.length != 3) return false;
    return {for (final i in _forgeSet) i.spec?.rarity}.length == 1;
  }

  String _rackLabel(RackKind r) => switch (r) {
    RackKind.front => _l.slotFront,
    RackKind.side => _l.rackSide,
    RackKind.gen => _l.slotGen,
    RackKind.hull => _l.rackHull,
  };

  TextStyle _text(Color c, double size, {bool bold = false}) => t.styled(
    TextStyle(
      color: c,
      fontSize: widget.fs(size),
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _hullPicker(),
              const SizedBox(height: 6),
              for (final r in RackKind.values) _rackRow(r),
            ],
          ),
        ),
        widget.sectionHeader(_l.sectionVault),
        _VaultSection(state: this),
      ],
    );
  }

  Widget _hullPicker() {
    final h = kHulls[_browse];
    final unlocked = _unlocked(h);
    final flying = h.id == v.hull.id;
    return Row(
      children: [
        _arrow(Icons.chevron_left, () => _browseHull(-1)),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 92,
                child: Opacity(
                  opacity: unlocked ? 1 : 0.35,
                  child: CustomPaint(
                    size: const Size(double.infinity, 92),
                    painter: _HullPainter(h),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!unlocked)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.lock, size: 12, color: Colors.white54),
                    ),
                  Text(
                    h.name,
                    style: _text(
                      flying ? t.accent : Colors.white,
                      11,
                      bold: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                unlocked
                    ? ModText.perk(h.perk, _l)
                    : ModText.hullUnlock(h.id, _l),
                textAlign: TextAlign.center,
                style: _text(unlocked ? Colors.white70 : t.danger, 8),
              ),
              const SizedBox(height: 2),
              Text(
                '${_l.hudHp} ×${h.hpMul}  ${_l.hudShield} ×${h.shieldMul}  '
                '${_l.hudGen} ×${h.genMaxMul}  ${_l.statAgility} ×${h.agility}  '
                '${_l.statHitbox} ×${h.hitbox}',
                textAlign: TextAlign.center,
                style: _text(Colors.white54, 7),
              ),
            ],
          ),
        ),
        _arrow(Icons.chevron_right, () => _browseHull(1)),
      ],
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 92,
      alignment: Alignment.center,
      child: Icon(icon, color: t.accent, size: 28),
    ),
  );

  Widget _rackRow(RackKind r) {
    final rack = v.racks[r]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _rackLabel(r).toUpperCase(),
                maxLines: 1,
                style: _text(Colors.white70, 10, bold: true),
              ),
            ),
          ),
          if (rack.sockets == 0)
            Text('—', style: _text(Colors.white30, 10))
          else
            for (var s = 0; s < rack.sockets; s++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: s < rack.fitted.length
                      ? _modChip(
                          rack.fitted[s],
                          onTap: () => _unfit(rack.fitted[s]),
                          inactive: !_worksHere(rack.fitted[s], r),
                        )
                      : _emptySocket(r),
                ),
              ),
        ],
      ),
    );
  }

  /// A gun mod whose family list leaves out the gun in its slot does nothing.
  bool _worksHere(ModInstance i, RackKind r) {
    final fam = i.spec?.families;
    if (fam == null) return true;
    final guns = r == RackKind.front
        ? [v.getDevice(WeaponSlot.frontGun)]
        : [v.getDevice(WeaponSlot.leftGun), v.getDevice(WeaponSlot.rightGun)];
    return guns.any(
      (d) => d != null && i.spec!.worksWith(weaponFamilyFromImgName(d.imgName)),
    );
  }

  Widget _emptySocket(RackKind r) {
    final selected = _filter == r;
    return GestureDetector(
      onTap: () => setState(() => _filter = selected ? null : r),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.surfaceDark.withAlpha(150),
          border: Border.all(
            color: selected ? t.accent : Colors.white24,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(t.cornerRadius),
        ),
        child: Text('+', style: _text(Colors.white38, 12, bold: true)),
      ),
    );
  }

  Widget _modChip(
    ModInstance i, {
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    bool inactive = false,
    bool marked = false,
  }) {
    final spec = i.spec!;
    final c = ModText.colorOf(spec);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Opacity(
        opacity: inactive ? 0.45 : 1,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.withAlpha(marked ? 90 : 35),
            border: Border.all(
              color: marked ? Colors.white : c,
              width: spec.rarity == ModRarity.mythic || marked ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(t.cornerRadius),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(spec.name, maxLines: 1, style: _text(c, 9, bold: true)),
          ),
        ),
      ),
    );
  }

  Future<void> _showCard(ModInstance i) async {
    final spec = i.spec!;
    final c = ModText.colorOf(spec);
    final lines = ModText.effectLines(spec.effects, _l);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.surfaceDark,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: c, width: 2),
          borderRadius: BorderRadius.circular(t.cornerRadius + 2),
        ),
        title: Text(spec.name, style: _text(c, 14, bold: true)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spec.curse
                  ? '${ModText.rarity(spec.rarity, _l)} · ${_l.curse}'
                  : ModText.rarity(spec.rarity, _l),
              style: _text(c, 9, bold: true),
            ),
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('• $line', style: _text(Colors.white, 9)),
              ),
            if (spec.families != null)
              Text(
                _l.modNeeds(ModText.families(spec.families!)),
                style: _text(t.upgrade, 9),
              ),
          ],
        ),
        actions: [
          for (final r in RackKind.values)
            if (spec.fitsRack(r))
              TextButton(
                onPressed: v.racks[r]!.refusal(spec) == null
                    ? () {
                        Navigator.of(ctx).pop();
                        _fit(i, r);
                      }
                    : null,
                child: Text(
                  '${_l.modFit} → ${_rackLabel(r).toUpperCase()}',
                  style: _text(
                    v.racks[r]!.refusal(spec) == null
                        ? t.success
                        : Colors.white30,
                    9,
                    bold: true,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// The VAULT: a filter row and the grid of unfitted mods, with the forge.
/// Built as its own section so the ComCenter can place it under LOADOUT.
class _VaultSection extends StatelessWidget {
  final HangarPanelState state;
  const _VaultSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = state;
    final l = context.l10n;
    final all = ModsState.instance.vault;
    final shown =
        [
          for (final i in all)
            if (i.spec != null &&
                (s._filter == null || i.spec!.fitsRack(s._filter!)))
              i,
        ]..sort((a, b) {
          final r = b.spec!.rarity.index.compareTo(a.spec!.rarity.index);
          return r != 0
              ? r
              : kMods.indexOf(a.spec!).compareTo(kMods.indexOf(b.spec!));
        });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _filterChip(s, null, l.vaultAll),
              for (final r in RackKind.values)
                _filterChip(s, r, s._rackLabel(r).toUpperCase()),
              Text('  ${all.length}', style: s._text(Colors.white54, 9)),
            ],
          ),
          const SizedBox(height: 6),
          if (all.isEmpty)
            Text(l.vaultEmpty, style: s._text(Colors.white54, 8))
          else
            LayoutBuilder(
              builder: (context, c) {
                final w = (c.maxWidth - 4 * 3) / 4;
                return Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final i in shown)
                      SizedBox(
                        width: w,
                        child: s._modChip(
                          i,
                          onTap: () => s._showCard(i),
                          onLongPress: () => s._toggleForge(i),
                          marked: s._forgeSet.contains(i),
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(l.forgeHint, style: s._text(Colors.white38, 7)),
              ),
              GestureDetector(
                onTap: s._canForge ? s._forge : null,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: s.t.upgrade.withAlpha(s._canForge ? 50 : 12),
                    border: Border.all(
                      color: s.t.upgrade.withAlpha(s._canForge ? 160 : 50),
                    ),
                    borderRadius: BorderRadius.circular(s.t.cornerRadius),
                  ),
                  child: Text(
                    '${l.modForge} ${s._forgeSet.length}/3',
                    style: s._text(
                      s._canForge ? s.t.upgrade : Colors.white30,
                      9,
                      bold: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(HangarPanelState s, RackKind? r, String label) {
    final on = s._filter == r;
    return GestureDetector(
      onTap: () => s._setFilter(r),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? s.t.accent.withAlpha(50) : Colors.transparent,
          border: Border.all(color: on ? s.t.accent : Colors.white24),
          borderRadius: BorderRadius.circular(s.t.cornerRadius),
        ),
        child: Text(label, style: s._text(on ? s.t.accent : Colors.white60, 8)),
      ),
    );
  }
}

/// The hull in the current skin, large; tinted when the skin has no art for
/// it yet, as in the game.
class _HullPainter extends CustomPainter {
  final HullSpec hull;
  final int generation;

  _HullPainter(this.hull) : generation = AssetLibrary.instance.generation;

  @override
  void paint(Canvas canvas, Size size) {
    if (AssetLibrary.instance.generation != generation) return;
    final frames = AssetLibrary.instance.vesselFramesFor(hull.id);
    final Sprite? sprite = frames.isNotEmpty
        ? frames.first
        : AssetLibrary.instance.getSprite('vessel');
    if (sprite == null) return;
    final src = Rect.fromLTWH(
      sprite.srcPosition.x,
      sprite.srcPosition.y,
      sprite.srcSize.x,
      sprite.srcSize.y,
    );
    // Hulls of different sizes keep their relative size on screen.
    final scale =
        (size.height / src.height).clamp(0.0, size.width / src.width) *
        (hull.hitbox.clamp(0.7, 1.3) / 1.3);
    final w = src.width * scale, h = src.height * scale;
    final dst = Rect.fromLTWH(
      (size.width - w) / 2,
      (size.height - h) / 2,
      w,
      h,
    );
    final paint = Paint()..filterQuality = FilterQuality.medium;
    if (!AssetLibrary.instance.hasHullArt(hull.id)) {
      paint.colorFilter = ColorFilter.mode(
        Color(hull.tint),
        BlendMode.modulate,
      );
    }
    canvas.drawImageRect(sprite.image, src, dst, paint);
  }

  @override
  bool shouldRepaint(_HullPainter old) =>
      old.hull != hull || old.generation != generation;
}
