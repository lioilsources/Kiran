import '../weapon_family.dart';
import 'mod_spec.dart';

/// One owned mod. The [uid] tells two copies of the same mod apart, so a
/// fitted DOUBLE and the spare in the vault are different things to save and
/// to the UI.
class ModInstance {
  final String uid;
  final String modId;

  const ModInstance(this.uid, this.modId);

  ModSpec? get spec => ModSpec.byId(modId);

  Map<String, dynamic> toJson() => {'uid': uid, 'id': modId};

  /// Null for an entry whose mod no longer exists in the catalogue.
  static ModInstance? fromJson(Map<String, dynamic> m) {
    final id = m['id'] as String?;
    final uid = m['uid'] as String?;
    if (id == null || uid == null || ModSpec.byId(id) == null) return null;
    return ModInstance(uid, id);
  }

  @override
  bool operator ==(Object other) => other is ModInstance && other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}

/// Why a mod cannot go into a rack, if it cannot.
enum FitRefusal { wrongRack, full, duplicate }

/// The sockets of one rack. [sockets] comes from the hull.
class ModRack {
  final RackKind kind;
  int sockets;
  final List<ModInstance> fitted = [];

  ModRack(this.kind, this.sockets);

  bool get isFull => fitted.length >= sockets;

  FitRefusal? refusal(ModSpec m) {
    if (!m.fitsRack(kind)) return FitRefusal.wrongRack;
    if (isFull) return FitRefusal.full;
    if (!m.stackable && fitted.any((i) => i.modId == m.id)) {
      return FitRefusal.duplicate;
    }
    if (m.stackable && fitted.where((i) => i.modId == m.id).length >= 2) {
      return FitRefusal.duplicate;
    }
    return null;
  }

  /// Everything in the rack, stacked. [family] filters out mods that only
  /// work with other guns; pass null for racks with no gun (GEN, HULL).
  ModEffects combined([WeaponFamily? family]) => ModEffects.combine([
    for (final i in fitted)
      if (i.spec?.worksWith(family) ?? false) i.spec!.effects,
  ]);

  /// Mods past [sockets], removed and returned — what a hull change spills.
  List<ModInstance> trim() {
    if (fitted.length <= sockets) return const [];
    final spill = fitted.sublist(sockets);
    fitted.removeRange(sockets, fitted.length);
    return spill;
  }

  List<Map<String, dynamic>> toJson() => [for (final i in fitted) i.toJson()];
}
