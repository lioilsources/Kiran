import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';

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

  /// True when playback goes through libmpv (iOS below 18.4, Linux, Windows).
  ///
  /// That backend does not deliver a usable loop: asked for `LoopMode.one` it
  /// sets mpv's `loop-file`, and the tier still stops after one pass — while
  /// `just_audio_media_kit` reports `completed` only for a player whose loop
  /// mode is *off*, so nothing downstream can even notice. On this backend we
  /// therefore run the tiers unlooped and rewind them ourselves; the native
  /// backends keep their gapless engine-level loop.
  static bool manualLoop = false;

  /// Patience limit for one setAsset, not a verdict on the file. The first
  /// track loaded pays libmpv's cold start on iOS below 18.4 (see main.dart)
  /// and on an A10 iPad that took longer than the old 3s, so `intro.ogg`
  /// silently never loaded. Tracks that time out are repaired at the next
  /// startSector, by which point the backend is warm.
  static const _loadTimeout = Duration(seconds: 12);

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

  /// Music players, like the SFX pool, leave the shared audio session alone —
  /// see SoundService._newPlayer for what thirty self-managing players did to
  /// it. Interruptions are handled once, here, in [init].
  AudioPlayer _newPlayer() => AudioPlayer(
        handleInterruptions: false,
        handleAudioSessionActivation: false,
      );

  /// True between [startSector] and [stop] — i.e. whenever the bed is meant
  /// to be running. Needed to decide whether an ending interruption should
  /// bring the music back or leave it off (ComCenter, game over).
  bool _sectorActive = false;
  bool _paused = false;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSub;

  /// Load mute state from prefs, and take ownership of interruption policy.
  /// Call once at app start.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool('music_muted') ?? false;

    // Every player in the app is built with handleInterruptions:false, so
    // this is the only interruption handler. Before it existed each of the
    // thirty-six players paused itself on the same event and none of them
    // reliably came back: the bed stayed silent until the player hit resume
    // by hand (reported from the iOS 17 iPad after a skin change).
    final session = await AudioSession.instance;
    await _interruptionSub?.cancel(); // init() twice must not stack handlers
    _interruptionSub = session.interruptionEventStream.listen((event) {
      audioLog('session interruption ${event.begin ? 'begin' : 'end'} '
          '(${event.type})');
      if (event.begin) {
        for (final p in _themes) {
          _safe(() => p.pause());
        }
        _safe(() => _intro?.pause());
      } else if (_sectorActive && !_paused) {
        for (final p in _themes) {
          _safe(() => p.play());
        }
        if (_introPlaying) _safe(() => _intro?.play());
      }
    });
  }

  /// Load music for the given skin, falling back to `default` per track.
  Future<void> loadSkin(String skinId) async {
    _logState('loadSkin($skinId) enter');
    _skinId = skinId;
    _ready = false;
    _disabled = false;
    _failCount = 0;
    _introPlaying = false;
    _targetTier = 1;

    await _disposePlayers();

    _intro = _newPlayer();
    // A fresh AudioPlayer starts at volume 1.0. Every gain this class writes
    // goes through _applyTheme or startSector, and both are allowed to
    // conclude "no change needed" — so a player nobody ever wrote to keeps
    // full volume. Born silent; the real gain arrives before it is heard.
    await _intro!.setVolume(0.0);
    _introSub = _intro!.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        _introPlaying = false;
      }
    });
    var ok = 0;
    if (await _setAssetWithFallback(_intro!, 'intro')) ok++;

    for (int i = 0; i < _tierCount; i++) {
      final p = _newPlayer();
      await p.setVolume(0.0); // see the intro above — never born loud
      if (await _setAssetWithFallback(p, 'theme_${i + 1}')) ok++;
      // Loop mode is set *after* the source is open: asked for beforehand it
      // has no platform player to reach. On libmpv we ask for no loop at all
      // and rewind in update() instead — see [manualLoop].
      await p.setLoopMode(manualLoop ? LoopMode.off : LoopMode.one);
      _themes.add(p);
      _vol.add(0.0);
    }

    _ready = !_disabled;
    audioLog('music skin=$skinId — $ok/${_tierCount + 1} loaded'
        '${_disabled ? ', DISABLED' : ''}');
    _logState('loadSkin($skinId) done');
  }

  /// Begin a sector: play the heroic intro and (re)start the theme loops muted,
  /// letting the director fade the right tier in once the intro finishes.
  void startSector() {
    if (!_ready || _disabled) return;
    _sectorActive = true;
    _paused = false;
    _logState('startSector');
    _repairMissingSources();
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
      // The intro is a one-shot: after the previous sector it sits in
      // `completed` while just_audio still counts it as playing, so play()
      // alone is a no-op and libmpv would leave it paused at EOF (see the
      // same dance in SoundService). pause() is free if nothing is playing.
      await _intro?.pause();
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
      final intro = _intro;
      // Hand over the moment the intro is no longer actually producing sound,
      // not just when it says `completed` or the 20s cap expires. Every tier
      // is pinned to silence while this flag is up, so an intro that dies
      // early (seen on the iOS 17 iPad) used to buy twenty seconds of nothing
      // — the player heard "the music stopped" and only a resume fixed it.
      // A short grace period keeps a still-starting player from tripping it.
      final stalled = intro == null ||
          (_introElapsed > 0.5 &&
              (_atEnd(intro) ||
                  !intro.playing ||
                  intro.processingState == ProcessingState.idle ||
                  intro.processingState == ProcessingState.completed));
      if (stalled) {
        audioLog('intro over after ${_introElapsed.toStringAsFixed(1)}s '
            '(${intro == null ? 'no player' : 'playing=${intro.playing} '
                'state=${intro.processingState.name}'}) — tiers take over');
        _introPlaying = false;
      } else if (_introElapsed >= config.musicMaxIntroSeconds) {
        audioLog('intro hit the ${config.musicMaxIntroSeconds}s cap');
        _introPlaying = false;
      }
    }

    // Duck recovery. While recovering, volumes must be re-applied even for
    // themes whose crossfade level is otherwise at rest.
    final ducking = _duck < 1.0;
    if (ducking) {
      _duck = min(1.0, _duck + dt / config.musicDuckRecoverSeconds);
    }

    // Drive the loop for backends that cannot ([manualLoop]): rewind any tier
    // that has reached the end of its clip. Costs one field read per tier.
    for (int i = 0; i < _themes.length; i++) {
      // Position is the only trustworthy end signal here. `processingState`
      // is *sticky*: once this backend has set `completed` it never clears
      // it, not even after a seek back to zero and a fresh play — so testing
      // it rewound every tier once a second forever and chopped the music
      // into 0.7s fragments. Where the engine loops for us (native backends)
      // there is nothing to do at all.
      if (!manualLoop) continue;
      final p = _themes[i];
      if (!_atEnd(p)) continue;
      // The seek takes a moment to show up in `position`; without this the
      // same tier would be rewound on every frame of that window.
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - (_lastRestartMs[i] ?? 0) < 1000) continue;
      _lastRestartMs[i] = now;
      audioLog('music tier ${i + 1} reached its end — rewinding');
      _restartTheme(i);
    }

    _watchTier();

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
    _paused = paused;
    _logState('setPaused($paused)');
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
    _sectorActive = false;
    _logState('stop');
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

  /// One-line state of the tier that should be audible right now.
  ///
  /// Temporary instrumentation for the iPad dropout after a skin change: the
  /// bed goes silent and only a manual resume revives it, and neither the
  /// load summary nor the interruption log explains why.
  String _tierState() {
    final i = _targetTier - 1;
    if (i < 0 || i >= _themes.length) return 'tier=$_targetTier <no player>';
    final p = _themes[i];
    final gain = i < _appliedGain.length ? _appliedGain[i] : double.nan;
    final it = _intro;
    final intro = it == null
        ? 'intro=<none>'
        : 'intro[playing=${it.playing} state=${it.processingState.name} '
            'pos=${it.position.inMilliseconds}ms src=${it.audioSource != null}]';
    return 'tier=$_targetTier playing=${p.playing} '
        'state=${p.processingState.name} '
        'pos=${p.position.inMilliseconds}ms '
        'vol=${_vol[i].toStringAsFixed(2)} gain=${gain.toStringAsFixed(2)} '
        'src=${p.audioSource != null} $intro';
  }

  void _logState(String where) => audioLog('$where — ${_tierState()} '
      'sectorActive=$_sectorActive paused=$_paused ready=$_ready '
      'intro=$_introPlaying');

  String _lastWatch = '';

  /// Log the audible tier whenever its player state changes.
  void _watchTier() {
    final i = _targetTier - 1;
    if (i < 0 || i >= _themes.length) return;
    final p = _themes[i];
    final it = _intro;
    final key = '$_targetTier/${p.playing}/${p.processingState.name}/'
        '${p.audioSource != null}/$_introPlaying/'
        '${it?.playing}/${it?.processingState.name}';
    if (key == _lastWatch) return;
    _lastWatch = key;
    _logState('tier state changed');
  }

  /// How close to the end counts as "at the end".
  static const _endEpsilon = Duration(milliseconds: 150);

  /// True once [p] has reached the end of its clip.
  ///
  /// On the libmpv backend a player that hits EOF *parks* there: it goes on
  /// reporting `playing=true` and `processingState=ready` while its position
  /// stops dead at the clip duration. Neither `completed` nor `playing=false`
  /// ever arrives, so every state-based check is blind to it — which is why
  /// the earlier loop watchdog never fired once. Measured on the iOS 17 iPad:
  /// the 12.106s intro froze at pos=12106ms and the tiers stayed muted for
  /// the whole 20s intro cap. The position is the only signal that shows up.
  bool _atEnd(AudioPlayer p) {
    final d = p.duration;
    if (d == null || d <= _endEpsilon) return false;
    return p.position >= d - _endEpsilon;
  }

  /// Guards against re-firing a rewind before the seek has been reflected.
  final Map<int, int> _lastRestartMs = {};

  /// Rewind a tier that ran to the end and start it over.
  ///
  /// just_audio still reports a completed player as `playing`, so a bare
  /// play() is a no-op — the pause() is what lets the restart through. Same
  /// dance as SoundService does for one-shots.
  void _restartTheme(int i) {
    final p = _themes[i];
    _safe(() async {
      // pause() first: a parked player still calls itself `playing`, and
      // just_audio makes play() a no-op on one of those.
      await p.pause();
      await p.seek(Duration.zero);
      p.play();
    });
  }

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
      await player.setAsset(wanted).timeout(_loadTimeout);
      return true;
    } on TimeoutException catch (e) {
      // Slow, not missing: leave the breaker alone and let the next
      // startSector re-attempt it against a warm backend.
      audioLogFailure('music load timed out (retried at sector start)',
          wanted, e);
      return false;
    } catch (e) {
      audioLogFailure('music load', wanted, e);
      if (_skinId != 'default') {
        try {
          await player.setAsset(defaultPath).timeout(_loadTimeout);
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

  /// Re-attempt any track that has no source yet.
  ///
  /// Unlike SFX, a music player has no lazy path that would pick a missed
  /// track up on its own: whatever failed to load at startup stays silent for
  /// the rest of the run. A sector start is the natural moment to retry —
  /// the player is about to be needed and the backend is long warm.
  void _repairMissingSources() {
    final intro = _intro;
    if (intro != null && intro.audioSource == null) {
      _setAssetWithFallback(intro, 'intro');
    }
    for (int i = 0; i < _themes.length; i++) {
      if (_themes[i].audioSource == null) {
        _setAssetWithFallback(_themes[i], 'theme_${i + 1}');
      }
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
    // The gain cache belongs to the players that just died. Left behind, it
    // makes _applyTheme skip the very first write to each *new* player — and
    // a fresh AudioPlayer starts at volume 1.0, so after a skin change every
    // tier came up at full blast at once instead of silent.
    _appliedGain.fillRange(0, _appliedGain.length, -1.0);
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
