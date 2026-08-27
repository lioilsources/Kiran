import 'dart:async';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_config.dart' as config;
import 'audio_log.dart';

/// Adaptive soundtrack playback with per-skin music packs.
///
/// Layout per skin: `assets/skins/<id>/music/intro.ogg` (one-shot heroic
/// mission start) + `theme_1.ogg`..`theme_N.ogg` (looping intensity tiers,
/// calm → boss). All theme players run continuously; switching tiers is an
/// immediate equal-power crossfade driven from [update]. [MusicDirector]
/// decides which tier is active from live gameplay threat.
///
/// Mirrors [SoundService]: just_audio (cross-platform .ogg), graceful fallback
/// to the `default` skin, and a hard disable after repeated load failures.
class MusicService {
  static final instance = MusicService._();
  MusicService._();

  static const int _tierCount = config.musicTierCount;

  String _skinId = 'default';
  bool _muted = false;
  bool _ready = false;
  bool _disabled = false;
  int _failCount = 0;

  AudioPlayer? _intro;
  final List<AudioPlayer> _themes = [];
  final List<double> _vol = []; // current per-theme gain 0..1 (pre equal-power)
  StreamSubscription<PlayerState>? _introSub;

  int _targetTier = 1; // 1..N — the tier MusicService is fading toward
  bool _introPlaying = false;
  double _introElapsed = 0; // safety timeout if the intro never reports completion

  bool get muted => _muted;
  int get currentTier => _targetTier;

  /// Load mute state from prefs. Call once at app start.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool('music_muted') ?? false;
  }

  /// Load music for the given skin, falling back to `default` per track.
  Future<void> loadSkin(String skinId) async {
    _skinId = skinId;
    _ready = false;
    _disabled = false;
    _failCount = 0;
    _introPlaying = false;
    _targetTier = 1;

    await _disposePlayers();

    _intro = AudioPlayer();
    _introSub = _intro!.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        _introPlaying = false;
      }
    });
    var ok = 0;
    if (await _setAssetWithFallback(_intro!, 'intro')) ok++;

    for (int i = 0; i < _tierCount; i++) {
      final p = AudioPlayer();
      await p.setLoopMode(LoopMode.one);
      if (await _setAssetWithFallback(p, 'theme_${i + 1}')) ok++;
      _themes.add(p);
      _vol.add(0.0);
    }

    _ready = !_disabled;
    audioLog('music skin=$skinId — $ok/${_tierCount + 1} loaded'
        '${_disabled ? ', DISABLED' : ''}');
  }

  /// Begin a sector: play the heroic intro and (re)start the theme loops muted,
  /// letting the director fade the right tier in once the intro finishes.
  void startSector() {
    if (!_ready || _disabled) return;
    _introPlaying = true;
    _introElapsed = 0;
    _targetTier = 1;
    for (int i = 0; i < _themes.length; i++) {
      _vol[i] = 0.0;
      _applyTheme(i);
      _safe(() => _themes[i].play());
    }
    _intro?.setVolume(_muted ? 0.0 : config.musicMasterVolume);
    _safe(() async {
      await _intro?.seek(Duration.zero);
      _intro?.play();
    });
  }

  /// Set the intensity tier to crossfade toward (1..N).
  void setTier(int tier) {
    _targetTier = tier.clamp(1, _tierCount);
  }

  /// Sidechain-style duck: 1.0 = no duck, [config.musicDuckFloor] right after
  /// an explosion. Recovers linearly; while below 1.0 every theme's volume is
  /// re-applied each frame.
  double _duck = 1.0;

  /// Momentarily push the music bed down so a transient can land on top.
  ///
  /// The SFX files cannot get louder — they are already normalised to the
  /// ceiling — and a continuous music bed masks a half-second burst even when
  /// the burst peaks higher. Dipping the bed for a beat is how games make
  /// impacts read as loud; the dip itself is short enough that the ear hears
  /// "big explosion", not "quiet music".
  void duck() {
    if (!_ready || _disabled || _muted) return;
    _duck = config.musicDuckFloor;
  }

  /// Advance crossfades. Call every frame while the game is playing.
  void update(double dt) {
    if (!_ready || _disabled) return;
    // Safety net: if the intro never fires a completion event (e.g. its asset
    // failed to load), hand over to the tiers anyway so music doesn't stall.
    if (_introPlaying) {
      _introElapsed += dt;
      if (_introElapsed >= config.musicMaxIntroSeconds) _introPlaying = false;
    }

    // Duck recovery. While recovering, volumes must be re-applied even for
    // themes whose crossfade level is otherwise at rest.
    final ducking = _duck < 1.0;
    if (ducking) {
      _duck = min(1.0, _duck + dt / config.musicDuckRecoverSeconds);
    }

    final step = dt / config.musicCrossfadeSeconds;
    for (int i = 0; i < _themes.length; i++) {
      // During the intro all themes stay silent; afterwards only the active
      // tier rises to full gain.
      final wantActive = !_introPlaying && (i + 1) == _targetTier;
      final target = wantActive ? 1.0 : 0.0;
      if (_vol[i] < target) {
        _vol[i] = min(target, _vol[i] + step);
      } else if (_vol[i] > target) {
        _vol[i] = max(target, _vol[i] - step);
      } else if (!ducking) {
        continue;
      }
      _applyTheme(i);
    }
  }

  /// Pause/resume everything (game pause).
  void setPaused(bool paused) {
    if (!_ready) return;
    for (final p in _themes) {
      _safe(() => paused ? p.pause() : p.play());
    }
    if (_introPlaying) {
      _safe(() => paused ? _intro?.pause() : _intro?.play());
    }
  }

  /// Stop all music (ComCenter / game over). Loops are paused and faded to 0 so
  /// the next [startSector] begins cleanly.
  void stop() {
    if (!_ready) return;
    _introPlaying = false;
    _safe(() => _intro?.pause());
    for (int i = 0; i < _themes.length; i++) {
      _vol[i] = 0.0;
      _applyTheme(i);
      _safe(() => _themes[i].pause());
    }
  }

  /// Toggle music mute and persist.
  Future<void> toggleMute() async {
    _muted = !_muted;
    _intro?.setVolume(_muted ? 0.0 : config.musicMasterVolume);
    for (int i = 0; i < _themes.length; i++) {
      _applyTheme(i);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_muted', _muted);
  }

  // --- internals ------------------------------------------------------------

  /// Last gain actually pushed to each theme player. setVolume is a platform
  /// channel round trip, and duck recovery re-applies every theme every frame:
  /// in combat an explosion re-ducks before the 0.6s recovery finishes, so
  /// ducking is effectively always on and all five themes were being written
  /// 60 times a second forever. Inaudible deltas are not worth that.
  final List<double> _appliedGain = List.filled(config.musicTierCount, -1.0);

  void _applyTheme(int i) {
    if (i >= _themes.length) return;
    // Equal-power curve so a rising + falling pair sums to ~constant loudness.
    final gain =
        _muted ? 0.0 : sqrt(_vol[i]) * config.musicMasterVolume * _duck;
    // 1/512 is well under one step of any platform's volume resolution.
    if (i < _appliedGain.length) {
      if ((gain - _appliedGain[i]).abs() < 0.002) return;
      _appliedGain[i] = gain;
    }
    _safe(() => _themes[i].setVolume(gain));
  }

  /// Returns true if [player] ended up with a source, from the skin or from
  /// the `default` fallback.
  Future<bool> _setAssetWithFallback(AudioPlayer player, String name) async {
    final skinPath = 'assets/skins/$_skinId/music/$name.ogg';
    final defaultPath = 'assets/skins/default/music/$name.ogg';
    final wanted = _skinId == 'default' ? defaultPath : skinPath;
    try {
      await player.setAsset(wanted).timeout(const Duration(seconds: 3));
      return true;
    } catch (e) {
      audioLogFailure('music load', wanted, e);
      if (_skinId != 'default') {
        try {
          await player.setAsset(defaultPath).timeout(const Duration(seconds: 3));
          return true;
        } catch (e) {
          audioLogFailure('music load fallback', defaultPath, e);
        }
      }
      _failCount++;
      if (_failCount >= _tierCount) {
        _disabled = true;
        audioLog('music DISABLED after $_failCount load failures');
      }
      return false;
    }
  }

  Future<void> _disposePlayers() async {
    await _introSub?.cancel();
    _introSub = null;
    await _intro?.dispose();
    _intro = null;
    for (final p in _themes) {
      await p.dispose();
    }
    _themes.clear();
    _vol.clear();
  }

  void _safe(FutureOr<void> Function() action) {
    try {
      final r = action();
      if (r is Future) {
        r.catchError((Object e) => audioLogFailure('music playback',
            'skin=$_skinId', e));
      }
    } catch (e) {
      audioLogFailure('music playback', 'skin=$_skinId', e);
    }
  }
}
