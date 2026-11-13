import 'dart:math' as math;

import '../../game/game_config.dart' as config;
import 'sigil_spec.dart';

/// CHARGE and FLOW (Prompts/28 §6): what sigils cost and what playing them
/// well earns. Pure; the vessel feeds it generator surplus, grazes, kills and
/// hits.
class SigilMeter {
  double charge = config.chargeStart;

  /// The training arena's endless charge: everything is affordable and
  /// nothing is spent.
  bool infinite = false;

  int flow = 0;
  double _idle = 0;
  double _decay = 0;
  final List<SigilKind> _recent = [];

  void reset() {
    charge = config.chargeStart;
    flow = 0;
    _idle = 0;
    _decay = 0;
    _recent.clear();
  }

  bool canPay(num cost) => infinite || charge >= cost;

  /// Spend [cost]; false (and nothing spent) when it is not there.
  bool pay(num cost) {
    if (infinite) return true;
    if (charge < cost) return false;
    charge -= cost;
    return true;
  }

  /// Income, raised by FLOW.
  void add(double v) {
    if (v <= 0) return;
    final mul = 1 + flow * config.flowChargePerStep;
    charge = math.min(config.chargeMax, charge + v * mul);
  }

  /// Generator output the generator had no room for.
  void addSurplus(double gen) => add(gen * config.chargePerGen);

  /// A sigil went off. FLOW grows when it differs from the two before it;
  /// a mirrored one is the same sigil.
  void onCast(SigilKind k) {
    if (!_recent.contains(k)) flow = math.min(config.flowMax, flow + 1);
    _recent.add(k);
    if (_recent.length > 2) _recent.removeAt(0);
    _idle = 0;
    _decay = 0;
  }

  /// The hull was hit: the chain breaks. A shield hit does not.
  void onHullHit() {
    flow = 0;
    _recent.clear();
  }

  /// [busy] while a sigil runs; FLOW only drains between sigils.
  void tick(double dt, {bool busy = false}) {
    if (busy) {
      _idle = 0;
      return;
    }
    _idle += dt;
    if (_idle <= config.flowWindow || flow == 0) return;
    _decay += dt * config.flowDecay;
    while (_decay >= 1 && flow > 0) {
      _decay -= 1;
      flow--;
    }
  }

  double get scoreMul => 1 + flow * config.flowScorePerStep;

  /// The letter on the HUD; empty with no chain.
  String get grade => switch (flow) {
        0 => '',
        1 || 2 => 'D',
        3 || 4 => 'C',
        5 || 6 => 'B',
        7 || 8 => 'A',
        _ => 'S',
      };
}
