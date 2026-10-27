import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/fleet.dart';
import 'package:tyrian_mobile/systems/path_system.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// The wave-design rules shared by the endless parts and the campaign nodes.
/// Numbers here are the contracts the content was approved against; a test
/// failing on them means a part drifted from the design, not that the engine
/// broke.

const bossTier = {HostType.falconxb, HostType.falconxt, HostType.bouncer};

double fleetDuration(Fleet f) =>
    (f.path.nodes.length + (f.extraPath?.nodes.length ?? 0)) / 40.0;

/// When the last fleet has spawned, flown out and the completion delay ran.
double scriptEnd(Sector s) {
  var end = 0.0;
  for (final f in s.fleets) {
    final e = f.enterTime + f.count * f.triggerInterval + fleetDuration(f);
    if (e > end) end = e;
  }
  return end + config.delayOnComplete;
}

/// HP-weighted dominant enemy type.
HostType domType(Sector s) {
  final hp = <HostType, int>{};
  for (final f in s.fleets) {
    hp[f.hostType] =
        (hp[f.hostType] ?? 0) + f.count * Hostile.getHpMax(f.hostType);
  }
  return hp.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

/// Duration-weighted dominant path shape.
PathType domShape(Sector s) {
  final wgt = <PathType, double>{};
  for (final f in s.fleets) {
    wgt[f.pathType] = (wgt[f.pathType] ?? 0) + f.count * fleetDuration(f);
  }
  return wgt.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

/// Estimated peak number of enemies alive at once. Fleets that park
/// (anything but destroy) never leave, which is the conservative reading.
double peakConcurrency(Sector s) {
  var peak = 0.0;
  final end = scriptEnd(s);
  for (var t = 0.0; t <= end; t += 0.5) {
    var alive = 0.0;
    for (final f in s.fleets) {
      if (t < f.enterTime) continue;
      final spawned =
          ((t - f.enterTime) / f.triggerInterval + 1).clamp(0, f.count.toDouble());
      double exited = 0;
      if (f.defaultPathAction == PathAction.destroy) {
        final dur = fleetDuration(f);
        exited = ((t - f.enterTime - dur) / f.triggerInterval + 1)
            .clamp(0, f.count.toDouble());
      }
      alive += spawned - exited;
    }
    if (alive > peak) peak = alive;
  }
  return peak;
}
