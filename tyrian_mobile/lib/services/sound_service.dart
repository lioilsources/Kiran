import 'dart:async';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio_log.dart';
import 'music_service.dart';

enum SfxEvent {
  fireBullet,
  fireBeam,
  hitShield,
  hitHull,
  explosionSmall,
  explosionLarge,
  pickup,
  weaponUnlock,
  sectorComplete,
  gameOver,
}

/// Fire-and-forget SFX playback with per-skin sound packs.
/// Uses just_audio which supports .ogg on all platforms (incl. Windows).
class SoundService {
  static final instance = SoundService._();
  SoundService._();

  /// Players kept per event. Three lets fast weapons overlap cleanly.
  ///
  /// On the libmpv backend every player is a separate mpv instance holding
  /// its own AudioUnit, and an A10 iPad runs out well before 3 x 10 SFX plus
  /// the music bed — so that backend gets a leaner pool. The 70ms retrigger
  /// floor means two players still cover any realistic firing rate.
  static int get _poolSize => leanPools ? 2 : 3;

  /// Set for backends where each player costs a real audio device — see
  /// [MusicService.manualLoop], set from the same place in main().
  static bool leanPools = false;

  /// How long one setAsset may take before we stop waiting on it.
  ///
  /// This is a patience limit, never a verdict on the file. On an A10 iPad the
  /// first libmpv instances take seconds to come up (that backend is what iOS
  /// below 18.4 falls back to — see main.dart), and the old 2s budget expired
  /// on precisely the first sound of the pool: fire_bullet and fire_beam, the
  /// two most-played sounds in the game, went silent for the whole session
  /// while everything loaded after them worked. Timeouts no longer blacklist
  /// a path, so play() picks it up again once the backend is warm.
  static const _loadTimeout = Duration(seconds: 10);

  final _rnd = Random();

  /// Per-event base volume mix. The loudnorm pass equalizes perceived loudness
  /// across files, so this is the *relative* balance in-game: the frequent,
  /// low-stakes shots sit back so impacts and events cut through.
  static const _eventVolume = {
    SfxEvent.fireBullet: 0.5,
    SfxEvent.fireBeam: 0.6,
    SfxEvent.hitShield: 0.6,
    SfxEvent.hitHull: 0.7,
    SfxEvent.explosionSmall: 0.8,
    SfxEvent.explosionLarge: 1.0,
    SfxEvent.pickup: 0.75,
    SfxEvent.weaponUnlock: 0.85,
    SfxEvent.sectorComplete: 0.9,
    SfxEvent.gameOver: 0.9,
  };

  /// Per-play volume randomization so rapid repeats (bullets, hits) aren't
  /// machine-stamped. Pitch jitter was tried too but removed — see _playPlayer.
  static const _volumeJitter = 0.10; // ±10% around the event base

  String _skinId = 'default';
  bool _muted = false;
  bool _ready = false;
  bool _disabled = false;

  bool get muted => _muted;

  // Maps SfxEvent → asset path (relative, prefixed with assets/)
  final Map<SfxEvent, String> _paths = {};
  // Player pool per event: round-robin for overlapping sounds
  final Map<SfxEvent, List<AudioPlayer>> _pools = {};
  final Map<SfxEvent, int> _poolIndex = {};
  // Paths that have failed — never retry
  final Set<String> _failedPaths = {};
  int _failCount = 0;

  static const _eventFileNames = {
    SfxEvent.fireBullet: 'fire_bullet',
    SfxEvent.fireBeam: 'fire_beam',
    SfxEvent.hitShield: 'hit_shield',
    SfxEvent.hitHull: 'hit_hull',
    SfxEvent.explosionSmall: 'explosion_small',
    SfxEvent.explosionLarge: 'explosion_large',
    SfxEvent.pickup: 'pickup',
    SfxEvent.weaponUnlock: 'weapon_unlock',
    SfxEvent.sectorComplete: 'sector_complete',
    SfxEvent.gameOver: 'game_over',
  };

  /// A pooled one-shot player that keeps its hands off the audio session.
  ///
  /// just_audio's default is for *every* player to call `setActive(true)` on
  /// the shared session on each play() and to subscribe to interruptions.
  /// Across this pool that is thirty players activating the session several
  /// times a second during a firefight; on iOS the session answers with
  /// interruptions, and the music bed — a different player, but the same
  /// session — got paused with nothing to resume it. The session is owned
  /// once, centrally, in main().
  AudioPlayer _newPlayer() => AudioPlayer(
        handleInterruptions: false,
        handleAudioSessionActivation: false,
      );

  /// Load mute state from prefs. Call once at app start.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool('sfx_muted') ?? false;
  }

  /// Load SFX paths for the given skin, falling back to default.
  Future<void> loadSkin(String skinId) async {
    _skinId = skinId;
    _paths.clear();
    _failedPaths.clear();
    _failCount = 0;
    _disabled = false;
    _ready = false;

    // Dispose old players — and *wait* for them. Unawaited, thirty teardowns
    // ran concurrently with the thirty fresh players created right below, so
    // for a moment the process held twice the audio devices it needs. On the
    // iOS 17 iPad that was enough to take the whole output down: the music
    // bed, mid-playback on its own players, went silent while every Dart-side
    // field still read playing/ready, and only a manual resume brought it
    // back. Old devices go away before new ones are asked for.
    await Future.wait([
      for (final pool in _pools.values)
        for (final player in pool) player.dispose(),
    ]);
    _pools.clear();
    _poolIndex.clear();

    for (final entry in _eventFileNames.entries) {
      final skinPath = 'assets/skins/$skinId/sfx/${entry.value}.ogg';
      final defaultPath = 'assets/skins/default/sfx/${entry.value}.ogg';
      _paths[entry.key] = skinId == 'default' ? defaultPath : skinPath;

      // Create player pool for this event
      final players = <AudioPlayer>[];
      for (int i = 0; i < _poolSize; i++) {
        players.add(_newPlayer());
      }
      _pools[entry.key] = players;
      _poolIndex[entry.key] = 0;
    }

    _ready = true;

    // Preload in background — don't block skin loading
    _preloadAll();
  }

  Future<void> _preloadAll() async {
    var ok = 0;
    var failed = 0;
    for (final entry in _paths.entries) {
      if (!_ready) return; // skin changed mid-preload
      if (await _preload(entry.key, entry.value)) {
        ok++;
      } else {
        failed++;
      }
    }
    // The one line that says whether this device can decode our assets at
    // all: on an iOS build without an Ogg demuxer every single one fails.
    audioLog('sfx skin=$_skinId — $ok/${ok + failed} preloaded'
        '${failed > 0 ? ', $failed failed' : ''}');
  }

  /// Returns true if [event] ended up with a playable source (either [path]
  /// or the default-skin fallback).
  Future<bool> _preload(SfxEvent event, String path) async {
    final pool = _pools[event];
    if (pool == null) return false;
    try {
      // Only preload the first player; others load lazily on play().
      // Volume/speed are set per-play in _playPlayer, not here.
      await pool[0].setAsset(path).timeout(_loadTimeout);
      return true;
    } on TimeoutException catch (e) {
      // Slow, not broken. Leave the path playable: the lazy setAsset in
      // _playPlayer will try it again against a warmed-up backend.
      audioLogFailure('sfx preload timed out (kept for retry)', path, e);
      return false;
    } catch (e) {
      _failedPaths.add(path);
      audioLogFailure('sfx preload', path, e);
      // Try default fallback
      if (_skinId != 'default') {
        final fallback = 'assets/skins/default/sfx/${_eventFileNames[event]}.ogg';
        _paths[event] = fallback;
        try {
          await pool[0].setAsset(fallback).timeout(_loadTimeout);
          return true;
        } catch (e) {
          _failedPaths.add(fallback);
          audioLogFailure('sfx preload fallback', fallback, e);
        }
      }
      return false;
    }
  }

  /// Event's base volume, or muted (0). Per-play jitter is applied on top.
  double _baseVolume(SfxEvent event) =>
      _muted ? 0.0 : (_eventVolume[event] ?? 1.0);

  /// Shortest gap between two plays of the same event.
  ///
  /// The pool round-robins over three players with no floor on the rate, so a
  /// fast weapon stacked 0.5s one-shots on top of each other several times a
  /// second and the result smeared into a wash that buried everything else.
  /// One retrigger every 70ms is still far quicker than the ear resolves as
  /// separate hits, and it leaves room for impacts to be heard.
  static const _minRetrigger = Duration(milliseconds: 70);
  final Map<SfxEvent, int> _lastPlayMs = {};

  /// Play a sound effect (fire-and-forget).
  void play(SfxEvent event) {
    if (_muted || !_ready || _disabled) return;
    final path = _paths[event];
    if (path == null || _failedPaths.contains(path)) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _lastPlayMs[event];
    if (last != null && now - last < _minRetrigger.inMilliseconds) return;
    _lastPlayMs[event] = now;

    // Big explosions duck the music bed so the crack lands on top of it
    // instead of inside it — the files are already normalised to the ceiling,
    // so this is the only lever that makes them read louder. Small explosions
    // deliberately don't: every routine kill dipping the bed made the melody
    // pump in dense combat (dips chained faster than the 0.6s recovery).
    if (event == SfxEvent.explosionLarge) {
      MusicService.instance.duck();
    }

    final pool = _pools[event];
    if (pool == null || pool.isEmpty) return;

    final idx = _poolIndex[event] ?? 0;
    _poolIndex[event] = (idx + 1) % pool.length;
    final player = pool[idx];

    _playPlayer(player, event, path);
  }

  /// Symmetric jitter in [-amount, +amount].
  double _jitter(double amount) => (_rnd.nextDouble() * 2 - 1) * amount;

  void _playPlayer(AudioPlayer player, SfxEvent event, String path) async {
    try {
      // If player has no source yet, set it first
      if (player.audioSource == null) {
        await player.setAsset(path).timeout(_loadTimeout);
      }
      // Per-play variation: base mix ± volume jitter so consecutive shots
      // aren't machine-stamped. NOTE: no setSpeed() here — changing playback
      // speed forces media3 out of the opus offload/bypass path through the
      // Sonic processor, reconfiguring the AudioTrack on every shot; across the
      // pooled players that thrashed the sink into `AudioTrack write failed: -6`
      // on Android. setVolume alone doesn't reconfigure the track, so it's safe.
      final vol =
          (_baseVolume(event) * (1 + _jitter(_volumeJitter))).clamp(0.0, 1.0);
      player.setVolume(vol);
      // A one-shot that ran to the end is `completed`, but just_audio still
      // reports it as `playing`, and play() is a no-op on a playing player.
      // The native iOS/Android backends happen to resume on the seek alone;
      // libmpv (iOS < 18.4, Linux, Windows) parks at EOF paused and needs
      // the play() to actually go through — without this pause every pool
      // player fired exactly once per session and then went silent, most
      // frequent sounds first. Only done when completed: pausing a player
      // that is mid-clip would restart the audio track on every retrigger.
      if (player.processingState == ProcessingState.completed) {
        await player.pause();
      }
      await player.seek(Duration.zero);
      player.play();
      _failCount = 0;
    } on TimeoutException catch (e) {
      // Neither blacklist nor breaker fuel — a slow cold load on an old
      // device says nothing about whether the asset is playable.
      audioLogFailure('sfx play timed out (kept for retry)', path, e);
    } catch (e) {
      _failedPaths.add(path);
      audioLogFailure('sfx play', path, e);
      _failCount++;
      if (_failCount >= 5) {
        _disabled = true;
        audioLog('sfx DISABLED after $_failCount consecutive failures');
      }
    }
  }

  /// Toggle mute on/off and persist.
  Future<void> toggleMute() async {
    _muted = !_muted;
    // Update currently-loaded players. On unmute, restore each event's base
    // volume (not a flat 1.0); the next play re-applies jitter on top.
    for (final entry in _pools.entries) {
      for (final player in entry.value) {
        player.setVolume(_baseVolume(entry.key));
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sfx_muted', _muted);
  }
}
