import 'dart:math';

/// Generates Ubuntu-style alliterative pilot codenames (e.g. "Juicy Gunner",
/// "Bouncing Blaster"). Used when starting a fresh game — the player can still
/// rename in the ComCenter.
class PilotNameGenerator {
  PilotNameGenerator._();

  static final Random _rng = Random();

  static const List<String> _adjectives = [
    'Juicy', 'Bouncing', 'Galactic', 'Blazing', 'Vicious', 'Stellar',
    'Savage', 'Cosmic', 'Brave', 'Bold', 'Lucky', 'Lethal',
    'Mighty', 'Quantum', 'Radiant', 'Reckless', 'Swift', 'Solar',
    'Grim', 'Gnarly', 'Nimble', 'Neon', 'Plucky', 'Phantom',
    'Daring', 'Dizzy', 'Frosty', 'Fearless', 'Turbo', 'Wicked',
    'Atomic', 'Astral', 'Crimson', 'Cocky', 'Brisk', 'Bionic',
  ];

  static const List<String> _nouns = [
    'Gunner', 'Blaster', 'Bomber', 'Buccaneer', 'Gladiator', 'Guardian',
    'Striker', 'Stardust', 'Vanguard', 'Voyager', 'Comet', 'Cobra',
    'Ranger', 'Raider', 'Nova', 'Nomad', 'Pilot', 'Phoenix',
    'Drifter', 'Dragon', 'Falcon', 'Fury', 'Tempest', 'Talon',
    'Wraith', 'Wanderer', 'Avenger', 'Ace', 'Bandit', 'Bullet',
    'Corsair', 'Crusader', 'Gambit', 'Ghost', 'Reaper', 'Rocketeer',
  ];

  /// Returns an alliterative "Adjective Noun" codename when possible,
  /// otherwise a random pairing.
  static String randomCodename() {
    final adj = _adjectives[_rng.nextInt(_adjectives.length)];
    final initial = adj.isNotEmpty ? adj[0].toUpperCase() : '';
    final matches =
        _nouns.where((n) => n.isNotEmpty && n[0].toUpperCase() == initial).toList();
    final noun = matches.isNotEmpty
        ? matches[_rng.nextInt(matches.length)]
        : _nouns[_rng.nextInt(_nouns.length)];
    return '$adj $noun';
  }
}
