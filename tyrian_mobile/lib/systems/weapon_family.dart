/// Weapon families for death-effect selection, keyed off [DevType.imgName] —
/// the sprite key already collapses big/small variants into one family
/// (Bubble Gun + Small Bubble → bubble, Vulcan Cannon + Small Vulcan →
/// vulcan, Laser + Small Laser → laser).
enum WeaponFamily { bubble, vulcan, blaster, laser, starg }

/// Null for generators and unknown names — those deaths keep the generic
/// explosion.
WeaponFamily? weaponFamilyFromImgName(String imgName) {
  for (final f in WeaponFamily.values) {
    if (f.name == imgName) return f;
  }
  return null;
}
