/// The arena's endless boss run (Prompts/29 §5.5, as decided: the battle
/// arena is always against a boss). Every boss beaten brings the next with
/// one more part, up to all four, and more HP; the first knockout ends the
/// run. The rating has no ceiling: deeper bosses and a longer FLOW chain
/// pay more.
class Gauntlet {
  Gauntlet({this.startParts = 0});

  final int startParts;
  int round = 0;
  int rating = 0;
  bool over = false;

  /// Parts on this round's boss.
  int get parts => (startParts + round).clamp(0, 4);

  /// Boss toughness on top of the arena's own: +15 % per round.
  double get hpMul => 1 + 0.15 * round;

  /// The boss of this round went down with the player's chain at [flow].
  void bossDown(int flow) {
    rating += 100 * (round + 1) + 10 * flow;
    round++;
  }

  void knockout() => over = true;
}
