import '../weapon_family.dart';

/// How rare a mod is. Decides drop odds and how hard it hits; the effects
/// themselves are fixed per mod, never rolled per instance.
enum ModRarity { common, rare, mythic }

/// The four sets of sockets on a ship. SIDE is one rack shared by both side
/// guns: a mod there works on the left and the right gun alike.
enum RackKind { front, side, gen, hull }

/// What a mod does, as plain numbers. Nothing here has behaviour: ShotPlan,
/// Vessel and the hit path read these. Every default is the neutral value, so
/// a ship with empty racks plays exactly like one before mods existed — that
/// is where the VB6 parity tests live.
class ModEffects {
  // ── Shape of fire ──
  /// Parallel streams per shot. Multiplies across mods.
  final int streams;

  /// Shots in the fan (1 = straight, 3 = TRIPLE, 5 = HYDRA). The widest wins.
  final int fan;

  /// Outer fan shot's sideways speed in px/frame for the front gun; side guns
  /// get two thirds of it. The widest wins.
  final double fanVx;

  /// Shots per trigger pull, a few frames apart. Multiplies.
  final int salvo;

  // ── Numbers on the shot ──
  final double cooldownDiv;
  final double dmgMul;
  final double speedMul;
  final double projScaleMul;
  final double drawScaleAdd;
  final double pwrMul;
  final int guideAdd;

  /// Extra targets a shot passes through; -1 means no limit.
  final int pierce;

  /// Damage lost per pass-through (LANCE), floored at 30 %.
  final double pierceFalloff;
  final double critChance;
  final double critMul;

  /// Crit multiplier on boss parts and cores; 0 means use [critMul].
  final double bossCritMul;

  // ── What a shot does when it lands ──
  final int forkCount;
  final int forkDepth;
  final bool split;
  final double frostSec;

  // ── Flight path ──
  final bool crossfire;
  final bool rearguard;
  final bool orbit;
  final int bounces;
  final bool bounceTop;

  // ── Power ──
  final bool overdrive;
  final bool reactor;
  final double genPowerMul;
  final double genMaxMul;
  final bool surge;

  /// Fraction of genMax refilled per kill.
  final double siphon;

  // ── Hull ──
  final double hpMul;
  final double shieldMul;
  final double regenMul;
  final int leechHp;
  final double magnetRadius;
  final double reflectChance;
  final bool reflectGuided;
  final double ghostSec;
  final bool nova;
  final double agilityMul;
  final double hitboxMul;
  final double creditMul;
  final double scoreMul;
  final bool satellite;
  final bool timewarp;
  final bool gambler;

  const ModEffects({
    this.streams = 1,
    this.fan = 1,
    this.fanVx = 0,
    this.salvo = 1,
    this.cooldownDiv = 1,
    this.dmgMul = 1,
    this.speedMul = 1,
    this.projScaleMul = 1,
    this.drawScaleAdd = 0,
    this.pwrMul = 1,
    this.guideAdd = 0,
    this.pierce = 0,
    this.pierceFalloff = 0,
    this.critChance = 0,
    this.critMul = 1,
    this.bossCritMul = 0,
    this.forkCount = 0,
    this.forkDepth = 0,
    this.split = false,
    this.frostSec = 0,
    this.crossfire = false,
    this.rearguard = false,
    this.orbit = false,
    this.bounces = 0,
    this.bounceTop = false,
    this.overdrive = false,
    this.reactor = false,
    this.genPowerMul = 1,
    this.genMaxMul = 1,
    this.surge = false,
    this.siphon = 0,
    this.hpMul = 1,
    this.shieldMul = 1,
    this.regenMul = 1,
    this.leechHp = 0,
    this.magnetRadius = 0,
    this.reflectChance = 0,
    this.reflectGuided = false,
    this.ghostSec = 0,
    this.nova = false,
    this.agilityMul = 1,
    this.hitboxMul = 1,
    this.creditMul = 1,
    this.scoreMul = 1,
    this.satellite = false,
    this.timewarp = false,
    this.gambler = false,
  });

  static const none = ModEffects();

  /// Hard caps on the shape of fire. 4 × 5 × 3 = 60 shots per pull is
  /// already more than a phone wants on screen from one gun.
  static const maxStreams = 4;
  static const maxFan = 5;
  static const maxSalvo = 3;
  static const maxForkDepth = 3;

  /// Stack effects the way a rack does: counts and multipliers multiply,
  /// fan and pierce take the widest, additive numbers add, flags OR.
  static ModEffects combine(Iterable<ModEffects> all) {
    var streams = 1, fan = 1, salvo = 1, guideAdd = 0, pierce = 0;
    var forkCount = 0, forkDepth = 0, bounces = 0, leechHp = 0;
    double fanVx = 0, cooldownDiv = 1, dmgMul = 1, speedMul = 1;
    double projScaleMul = 1, drawScaleAdd = 0, pwrMul = 1, pierceFalloff = 0;
    double critChance = 0, critMul = 1, bossCritMul = 0, frostSec = 0;
    double genPowerMul = 1, genMaxMul = 1, siphon = 0, hpMul = 1;
    double shieldMul = 1, regenMul = 1, magnetRadius = 0, reflectChance = 0;
    double ghostSec = 0, agilityMul = 1, hitboxMul = 1, creditMul = 1;
    double scoreMul = 1;
    var split = false, crossfire = false, rearguard = false, orbit = false;
    var bounceTop = false, overdrive = false, reactor = false, surge = false;
    var reflectGuided = false, nova = false, satellite = false;
    var timewarp = false, gambler = false;
    for (final e in all) {
      streams *= e.streams;
      if (e.fan > fan) fan = e.fan;
      if (e.fanVx > fanVx) fanVx = e.fanVx;
      salvo *= e.salvo;
      cooldownDiv *= e.cooldownDiv;
      dmgMul *= e.dmgMul;
      speedMul *= e.speedMul;
      projScaleMul *= e.projScaleMul;
      drawScaleAdd += e.drawScaleAdd;
      pwrMul *= e.pwrMul;
      guideAdd += e.guideAdd;
      if (e.pierce < 0 || pierce < 0) {
        pierce = -1;
      } else if (e.pierce > pierce) {
        pierce = e.pierce;
      }
      if (e.pierceFalloff > pierceFalloff) pierceFalloff = e.pierceFalloff;
      critChance += e.critChance;
      if (e.critMul > critMul) critMul = e.critMul;
      if (e.bossCritMul > bossCritMul) bossCritMul = e.bossCritMul;
      if (e.forkCount > forkCount) forkCount = e.forkCount;
      if (e.forkDepth > forkDepth) forkDepth = e.forkDepth;
      split |= e.split;
      if (e.frostSec > frostSec) frostSec = e.frostSec;
      crossfire |= e.crossfire;
      rearguard |= e.rearguard;
      orbit |= e.orbit;
      if (e.bounces > bounces) bounces = e.bounces;
      bounceTop |= e.bounceTop;
      overdrive |= e.overdrive;
      reactor |= e.reactor;
      genPowerMul *= e.genPowerMul;
      genMaxMul *= e.genMaxMul;
      surge |= e.surge;
      siphon += e.siphon;
      hpMul *= e.hpMul;
      shieldMul *= e.shieldMul;
      regenMul *= e.regenMul;
      leechHp += e.leechHp;
      if (e.magnetRadius > magnetRadius) magnetRadius = e.magnetRadius;
      reflectChance += e.reflectChance;
      reflectGuided |= e.reflectGuided;
      if (e.ghostSec > ghostSec) ghostSec = e.ghostSec;
      nova |= e.nova;
      agilityMul *= e.agilityMul;
      hitboxMul *= e.hitboxMul;
      creditMul *= e.creditMul;
      scoreMul *= e.scoreMul;
      satellite |= e.satellite;
      timewarp |= e.timewarp;
      gambler |= e.gambler;
    }
    return ModEffects(
      streams: streams.clamp(1, maxStreams),
      fan: fan.clamp(1, maxFan),
      fanVx: fanVx,
      salvo: salvo.clamp(1, maxSalvo),
      cooldownDiv: cooldownDiv,
      dmgMul: dmgMul,
      speedMul: speedMul,
      projScaleMul: projScaleMul,
      drawScaleAdd: drawScaleAdd,
      pwrMul: pwrMul,
      guideAdd: guideAdd,
      pierce: pierce,
      pierceFalloff: pierceFalloff,
      critChance: critChance.clamp(0.0, 0.9),
      critMul: critMul,
      bossCritMul: bossCritMul,
      forkCount: forkCount,
      forkDepth: forkDepth.clamp(0, maxForkDepth),
      split: split,
      frostSec: frostSec,
      crossfire: crossfire,
      rearguard: rearguard,
      orbit: orbit,
      bounces: bounces,
      bounceTop: bounceTop,
      overdrive: overdrive,
      reactor: reactor,
      genPowerMul: genPowerMul,
      genMaxMul: genMaxMul,
      surge: surge,
      siphon: siphon,
      hpMul: hpMul,
      shieldMul: shieldMul,
      regenMul: regenMul,
      leechHp: leechHp,
      magnetRadius: magnetRadius,
      reflectChance: reflectChance.clamp(0.0, 0.9),
      reflectGuided: reflectGuided,
      ghostSec: ghostSec,
      nova: nova,
      agilityMul: agilityMul,
      hitboxMul: hitboxMul,
      creditMul: creditMul,
      scoreMul: scoreMul,
      satellite: satellite,
      timewarp: timewarp,
      gambler: gambler,
    );
  }
}

/// A mod in the catalogue. [name] is a proper noun and never translated, like
/// the weapon family names; what it does is described from [effects].
class ModSpec {
  /// Stable save key. Never derive it from [name].
  final String id;
  final String name;
  final ModRarity rarity;
  final Set<RackKind> scopes;

  /// Weapon families the mod works with; null means all. A mod fitted next to
  /// a gun outside its families stays in the socket and does nothing until a
  /// matching gun is fitted.
  final Set<WeaponFamily>? families;

  /// May sit twice in one rack.
  final bool stackable;

  /// A curse: a big bonus with a real price, drawn red in the vault.
  final bool curse;
  final ModEffects effects;

  const ModSpec(
    this.id,
    this.name,
    this.rarity,
    this.scopes,
    this.effects, {
    this.families,
    this.stackable = false,
    this.curse = false,
  });

  bool fitsRack(RackKind r) => scopes.contains(r);
  bool worksWith(WeaponFamily? f) =>
      families == null || (f != null && families!.contains(f));

  static ModSpec? byId(String id) => _byId[id];
  static final Map<String, ModSpec> _byId = {for (final m in kMods) m.id: m};

  static List<ModSpec> ofRarity(ModRarity r) => [
    for (final m in kMods)
      if (m.rarity == r) m,
  ];
}

const _guns = {RackKind.front, RackKind.side};
const _side = {RackKind.side};
const _gen = {RackKind.gen};
const _hull = {RackKind.hull};

/// The catalogue (Prompts/27 §2). Order is the vault's display order.
const List<ModSpec> kMods = [
  // ── Shape of fire ──
  ModSpec(
    'double',
    'DOUBLE',
    ModRarity.common,
    _guns,
    ModEffects(streams: 2, pwrMul: 1.6),
    stackable: true,
  ),
  ModSpec(
    'triple',
    'TRIPLE',
    ModRarity.rare,
    _guns,
    ModEffects(fan: 3, fanVx: 3, pwrMul: 2.0),
  ),
  ModSpec(
    'hydra',
    'HYDRA',
    ModRarity.mythic,
    _guns,
    ModEffects(fan: 5, fanVx: 6, pwrMul: 2.6),
  ),
  ModSpec(
    'salvo',
    'SALVO',
    ModRarity.rare,
    _guns,
    ModEffects(salvo: 2, pwrMul: 1.5),
    stackable: true,
  ),
  ModSpec(
    'wide',
    'WIDE',
    ModRarity.common,
    _guns,
    ModEffects(streams: 2, dmgMul: 1.2, pwrMul: 1.5),
    families: {WeaponFamily.laser},
  ),
  ModSpec(
    'crossfire',
    'CROSSFIRE',
    ModRarity.rare,
    _side,
    ModEffects(crossfire: true, pwrMul: 1.2),
  ),
  ModSpec(
    'rearguard',
    'REARGUARD',
    ModRarity.mythic,
    _side,
    ModEffects(rearguard: true, pwrMul: 1.4),
  ),
  ModSpec(
    'orbit',
    'ORBIT',
    ModRarity.mythic,
    _guns,
    ModEffects(orbit: true, pwrMul: 1.3),
    families: {WeaponFamily.bubble},
  ),

  // ── Cadence, power, shot behaviour ──
  ModSpec(
    'rate',
    'RATE',
    ModRarity.common,
    _guns,
    ModEffects(cooldownDiv: 1.25, pwrMul: 1.15),
  ),
  ModSpec(
    'rate_plus',
    'RATE+',
    ModRarity.rare,
    _guns,
    ModEffects(cooldownDiv: 1.6, pwrMul: 1.2),
  ),
  ModSpec(
    'overdrive',
    'OVERDRIVE',
    ModRarity.mythic,
    _guns,
    ModEffects(cooldownDiv: 2.2, pwrMul: 1.25, overdrive: true),
  ),
  ModSpec(
    'heavy',
    'HEAVY',
    ModRarity.common,
    _guns,
    ModEffects(dmgMul: 1.25, speedMul: 0.85, drawScaleAdd: 0.2, pwrMul: 1.3),
  ),
  ModSpec(
    'heavy_plus',
    'HEAVY+',
    ModRarity.rare,
    _guns,
    ModEffects(dmgMul: 1.5, speedMul: 0.8, projScaleMul: 1.25, pwrMul: 1.6),
  ),
  ModSpec(
    'crit',
    'CRIT',
    ModRarity.common,
    _guns,
    ModEffects(critChance: 0.12, critMul: 3),
  ),
  ModSpec(
    'crit_plus',
    'CRIT+',
    ModRarity.rare,
    _guns,
    ModEffects(critChance: 0.25, critMul: 3),
  ),
  ModSpec(
    'deadeye',
    'DEADEYE',
    ModRarity.mythic,
    _guns,
    ModEffects(critChance: 0.40, critMul: 3, bossCritMul: 5),
  ),
  ModSpec(
    'pierce',
    'PIERCE',
    ModRarity.rare,
    _guns,
    ModEffects(pierce: 2, pwrMul: 1.2),
  ),
  ModSpec(
    'lance',
    'LANCE',
    ModRarity.mythic,
    _guns,
    ModEffects(pierce: -1, pierceFalloff: 0.1, pwrMul: 1.3),
  ),
  ModSpec(
    'homing',
    'HOMING',
    ModRarity.common,
    _guns,
    ModEffects(guideAdd: 3, pwrMul: 1.1),
  ),
  ModSpec(
    'seeker',
    'SEEKER',
    ModRarity.rare,
    _guns,
    ModEffects(guideAdd: 8, pwrMul: 1.2),
  ),
  ModSpec('swift', 'SWIFT', ModRarity.common, _guns, ModEffects(speedMul: 1.3)),
  ModSpec(
    'fork',
    'FORK',
    ModRarity.rare,
    _guns,
    ModEffects(forkCount: 2, forkDepth: 1),
  ),
  ModSpec(
    'chain',
    'CHAIN',
    ModRarity.mythic,
    _guns,
    ModEffects(forkCount: 3, forkDepth: 3),
  ),
  ModSpec(
    'split',
    'SPLIT',
    ModRarity.rare,
    _guns,
    ModEffects(split: true, pwrMul: 1.1),
    families: {WeaponFamily.bubble},
  ),
  ModSpec('bounce', 'BOUNCE', ModRarity.rare, _guns, ModEffects(bounces: 1)),
  ModSpec(
    'pinball',
    'PINBALL',
    ModRarity.mythic,
    _guns,
    ModEffects(bounces: 3, bounceTop: true),
  ),
  ModSpec(
    'frost',
    'FROST',
    ModRarity.rare,
    _guns,
    ModEffects(frostSec: 1.0, pwrMul: 1.1),
  ),
  ModSpec(
    'bigshot',
    'BIGSHOT',
    ModRarity.common,
    _guns,
    ModEffects(projScaleMul: 1.2, drawScaleAdd: 0.2, pwrMul: 1.1),
  ),
  ModSpec(
    'furnace',
    'FURNACE',
    ModRarity.rare,
    _guns,
    ModEffects(dmgMul: 1.8, pwrMul: 2.4),
    curse: true,
  ),

  // ── Generator ──
  ModSpec(
    'coil',
    'COIL',
    ModRarity.common,
    _gen,
    ModEffects(genPowerMul: 1.25),
  ),
  ModSpec(
    'coil_plus',
    'COIL+',
    ModRarity.rare,
    _gen,
    ModEffects(genPowerMul: 1.6),
  ),
  ModSpec(
    'reactor',
    'REACTOR',
    ModRarity.mythic,
    _gen,
    ModEffects(genPowerMul: 2.2, reactor: true),
  ),
  ModSpec('cell', 'CELL', ModRarity.common, _gen, ModEffects(genMaxMul: 1.3)),
  ModSpec(
    'cell_plus',
    'CELL+',
    ModRarity.rare,
    _gen,
    ModEffects(genMaxMul: 1.7),
  ),
  ModSpec('surge', 'SURGE', ModRarity.rare, _gen, ModEffects(surge: true)),
  ModSpec('siphon', 'SIPHON', ModRarity.rare, _gen, ModEffects(siphon: 0.08)),
  ModSpec('flux', 'FLUX', ModRarity.mythic, _gen, ModEffects(pwrMul: 0.6)),

  // ── Hull ──
  ModSpec('plate', 'PLATE', ModRarity.common, _hull, ModEffects(hpMul: 1.25)),
  ModSpec(
    'aegis',
    'AEGIS',
    ModRarity.common,
    _hull,
    ModEffects(shieldMul: 1.3),
  ),
  ModSpec('regen', 'REGEN', ModRarity.rare, _hull, ModEffects(regenMul: 2.0)),
  ModSpec('leech', 'LEECH', ModRarity.rare, _hull, ModEffects(leechHp: 1)),
  ModSpec(
    'magnet',
    'MAGNET',
    ModRarity.common,
    _hull,
    ModEffects(magnetRadius: 160),
  ),
  ModSpec(
    'magnet_plus',
    'MAGNET+',
    ModRarity.rare,
    _hull,
    ModEffects(magnetRadius: 4000),
  ),
  ModSpec(
    'reflect',
    'REFLECT',
    ModRarity.rare,
    _hull,
    ModEffects(reflectChance: 0.2),
  ),
  ModSpec(
    'mirror',
    'MIRROR',
    ModRarity.mythic,
    _hull,
    ModEffects(reflectChance: 0.6, reflectGuided: true),
  ),
  ModSpec('ghost', 'GHOST', ModRarity.rare, _hull, ModEffects(ghostSec: 1.5)),
  ModSpec('nova', 'NOVA', ModRarity.mythic, _hull, ModEffects(nova: true)),
  ModSpec(
    'afterburn',
    'AFTERBURN',
    ModRarity.common,
    _hull,
    ModEffects(agilityMul: 1.2, hitboxMul: 0.9),
  ),
  ModSpec(
    'scavenger',
    'SCAVENGER',
    ModRarity.common,
    _hull,
    ModEffects(creditMul: 1.25),
  ),
  ModSpec(
    'bounty',
    'BOUNTY',
    ModRarity.rare,
    _hull,
    ModEffects(scoreMul: 1.25),
  ),
  ModSpec(
    'satellite',
    'SATELLITE',
    ModRarity.mythic,
    _hull,
    ModEffects(satellite: true),
  ),
  ModSpec(
    'timewarp',
    'TIMEWARP',
    ModRarity.mythic,
    _hull,
    ModEffects(timewarp: true),
  ),
  ModSpec(
    'gambler',
    'GAMBLER',
    ModRarity.mythic,
    _hull,
    ModEffects(gambler: true),
  ),
  ModSpec(
    'glass',
    'GLASS',
    ModRarity.rare,
    _hull,
    ModEffects(dmgMul: 2.0, hpMul: 0.5),
    curse: true,
  ),
  ModSpec(
    'anchor',
    'ANCHOR',
    ModRarity.rare,
    _hull,
    ModEffects(hpMul: 1.6, shieldMul: 1.6, agilityMul: 0.6, hitboxMul: 1.2),
    curse: true,
  ),
];
