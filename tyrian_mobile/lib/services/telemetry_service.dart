import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'telemetry_dictionary.dart';

export 'telemetry_dictionary.dart';

/// Anonymous gameplay statistics (Prompts/33, `docs/telemetry.md`).
///
/// The rules, all enforced here:
/// - No persistent identifier. Each session gets a random id that lives in
///   memory (and on unsent queued events, until they go).
/// - Cohorts are computed on the device and leave only as bands.
/// - Only what [TelemetryDictionary] lists goes out; anything else is dropped.
/// - No key, no network: without `--dart-define=TELEMETRY_KEY` and
///   `TELEMETRY_HOST` the service never builds a sink and does nothing.
/// - The game never waits: [track] is synchronous and cheap, sending happens
///   on a timer with short timeouts, and every failure is swallowed.
/// - A bounded offline queue ([maxQueue], oldest dropped first); an event's
///   time is when it happened.
/// - Turning it off takes effect at once: the queue is wiped and nothing
///   further is sent.
/// - The receiver sits behind [TelemetrySink]; swapping it is one class.
///   Today it is the owner's own collector ([CollectorSink], protocol v1).
///
/// Measuring never steers the game: nothing here is read by gameplay code.
class TelemetryService {
  TelemetryService._();

  static TelemetryService _instance = TelemetryService._();
  static TelemetryService get instance => _instance;

  /// A fresh service for a test, installed as [instance].
  @visibleForTesting
  static TelemetryService resetForTest() {
    _instance.dispose();
    return _instance = TelemetryService._();
  }

  static const _key = String.fromEnvironment('TELEMETRY_KEY');
  static const _host = String.fromEnvironment('TELEMETRY_HOST');

  /// `--dart-define=TELEMETRY_DEBUG=true` prints events instead of sending
  /// them (local verification without a key).
  static const _debugLog = bool.fromEnvironment('TELEMETRY_DEBUG');

  static const maxQueue = 500;
  static const batchSize = 50;
  static const flushEvery = Duration(seconds: 30);

  /// A return after longer than this in the background starts a new session.
  static const sessionGap = Duration(minutes: 30);

  static const _kEnabled = 'telemetry_enabled';
  static const _kInstallDay = 'telemetry_install_day';
  static const _kLegacy = 'telemetry_legacy';
  static const _kSessions = 'telemetry_sessions';
  static const _kQueue = 'telemetry_queue';
  static const _kPending = 'telemetry_pending';
  static const _kDaysBand = 'telemetry_days_band';

  /// The app's id at the collector (protocol v1 envelope `app`).
  static const collectorApp = 'kirian';

  /// Keys only a pilot who played before measuring began can have.
  static const _legacyKeys = [
    'game_state',
    'selected_skin',
    'achievement_stats_v1',
    'campaign_state',
  ];

  /// The sink this build would use: none without a key and an https host.
  static TelemetrySink? defaultSink() {
    if (_debugLog) return const LogSink();
    if (_key.isEmpty || _host.isEmpty) return null;
    final uri = Uri.tryParse(_host);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return null;
    return CollectorSink(host: uri, app: collectorApp, key: _key);
  }

  /// Wall clock; replaced in tests.
  DateTime Function() now = DateTime.now;

  /// Skin, mode, difficulty and language at the time of an event. Bound by
  /// the game (TelemetryProbe); missing keys go out as their neutral value.
  Map<String, Object> Function()? context;

  TelemetrySink? _sink;
  SharedPreferences? _prefs;
  bool _ready = false;
  bool _started = false;
  bool _enabled = true;
  Timer? _timer;
  bool _flushing = false;
  bool _dirty = false;

  final List<TelemetryEvent> _queue = [];
  final List<TelemetryEvent> _early = [];

  // Session and cohort
  String _session = _newId();
  int _seq = 0; // order within the session (`i`), from 1
  int _sessionNumber = 1;
  String? _lastDaysBand; // the days band of the last app_open
  int _installDay = 0;
  bool _legacy = false;
  DateTime? _launchedAt;
  DateTime? _fgSince;
  Duration _active = Duration.zero;
  DateTime? _bgSince;
  int _sectors = 0;
  int _deaths = 0;
  bool _menuReadySent = false;

  // Last input, last hull hit, in-flight weapon switches
  String _input = 'none';
  String _lastCause = 'none';
  int _switches = 0;

  // The sector being flown, if any
  ({int index, int level})? _sector;

  // ComCenter visit
  _Visit? _visit;
  _Visit? _visitAtPause;

  /// Why the next ComCenter opens; consumed by [comCenterOpened].
  String comCenterReason = 'first';

  /// How the open ComCenter will be left; reset at every open.
  String comCenterExit = 'start';

  /// Whether statistics are switched on (the in-game toggle).
  bool get enabled => _enabled;

  /// True when this build can send anything at all.
  bool get active => _sink != null;

  @visibleForTesting
  List<TelemetryEvent> get queued => List.unmodifiable(_queue);

  @visibleForTesting
  String get sessionId => _session;

  /// Load the cohort counters and the offline queue. Never throws; the game
  /// does not await it — events tracked before it finishes are held briefly.
  Future<void> init({
    DateTime? launchedAt,
    TelemetrySink? sink,
    SharedPreferences? prefs,
    bool useDefaultSink = true,
    bool startTimer = true,
  }) async {
    if (_started) return;
    _started = true;
    _launchedAt = launchedAt ?? now();
    _fgSince = now();
    try {
      _sink = sink ?? (useDefaultSink ? defaultSink() : null);
      if (_sink == null) {
        _early.clear();
        return;
      }
      final p = _prefs = prefs ?? await SharedPreferences.getInstance();
      _enabled = p.getBool(_kEnabled) ?? true;

      final today = _day(now());
      final install = p.getInt(_kInstallDay);
      if (install == null) {
        _legacy = _legacyKeys.any(p.containsKey);
        _installDay = today;
        await p.setInt(_kInstallDay, today);
        await p.setBool(_kLegacy, _legacy);
      } else {
        _installDay = install;
        _legacy = p.getBool(_kLegacy) ?? false;
      }
      _sessionNumber = (p.getInt(_kSessions) ?? 0) + 1;
      await p.setInt(_kSessions, _sessionNumber);
      _lastDaysBand = p.getString(_kDaysBand);

      if (_enabled) {
        _queue.addAll(_decode(p.getString(_kQueue)));
        _queue.addAll(_decode(p.getString(_kPending)));
        _trim();
      }
      await p.remove(_kPending);
      if (!_enabled) await p.remove(_kQueue);

      _listenForInput();
      if (startTimer) _timer = Timer.periodic(flushEvery, (_) => flush());
    } catch (_) {
      // Measuring is optional; a broken store just means no statistics.
      _sink = null;
    } finally {
      _ready = true;
      final early = List.of(_early);
      _early.clear();
      if (_sink != null && _enabled) early.forEach(_enqueue);
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    if (_listening) {
      try {
        HardwareKeyboard.instance.removeHandler(_onKey);
        GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
      } catch (_) {}
      _listening = false;
    }
  }

  /// Switch statistics on or off. Off wipes the queue and anything pending
  /// on disk at once; nothing more leaves the device.
  Future<void> setEnabled(bool on) async {
    _enabled = on;
    if (!on) {
      _queue.clear();
      _early.clear();
    }
    try {
      final p = _prefs ?? await SharedPreferences.getInstance();
      await p.setBool(_kEnabled, on);
      if (!on) {
        await p.remove(_kQueue);
        await p.remove(_kPending);
      }
    } catch (_) {}
  }

  /// Record an event. Synchronous, never throws, never waits.
  void track(String event, [Map<String, Object> props = const {}]) {
    if (!_started || !_enabled || (_ready && _sink == null)) return;
    try {
      final all = <String, Object>{...props, ..._context()};
      final e = TelemetryEvent(event, all, now(), _session, 0);
      if (!_ready) {
        if (_early.length < 50) _early.add(e);
        return;
      }
      _enqueue(e);
    } on AssertionError {
      rethrow; // debug builds: a dictionary mismatch is a bug, show it
    } catch (_) {}
  }

  void _enqueue(TelemetryEvent raw) {
    final props = {
      ...raw.props,
      ..._cohort(),
      if (raw.name == 'app_open' && raw.session == _session) ..._firsts(),
    };
    final ok = TelemetryDictionary.valid(raw.name, props);
    assert(ok, 'telemetry: ${raw.name} does not match the dictionary: $props');
    if (!ok) return;
    final seq = raw.session == _session ? ++_seq : raw.seq;
    _queue.add(TelemetryEvent(raw.name, props, raw.at, raw.session, seq));
    _trim();
    _dirty = true;
  }

  void _trim() {
    if (_queue.length > maxQueue) {
      _queue.removeRange(0, _queue.length - maxQueue);
    }
  }

  Map<String, Object> _context() {
    Map<String, Object> c = const {};
    try {
      c = context?.call() ?? const {};
    } catch (_) {}
    return {
      'app_version': kTelemetryAppVersion,
      'line': kTelemetryLine,
      'platform': _platform(),
      'lang': c['lang'] ?? 'en',
      'skin': c['skin'] ?? 'none',
      'mode': c['mode'] ?? 'endless',
      'difficulty': c['difficulty'] ?? 'normal',
      'tester': c['tester'] ?? false,
      'input': _input,
    };
  }

  Map<String, Object> _cohort() => {
        'session_band': TelemetryBands.session(_sessionNumber),
        'days_band': TelemetryBands.daysSince(_day(now()) - _installDay,
            legacy: _legacy),
        'first_session': _sessionNumber == 1 && !_legacy,
      };

  /// `app_open` only: is this the install's first session in its session
  /// band, and the first in its days band? Counted on the device, so the
  /// collector gets exact "reached session 2/3/6/11, day 1/2/7/30" numbers
  /// without any id (ol1n_telemetry, DevConventions plan 04 §6.2).
  Map<String, Object> _firsts() {
    final band = TelemetryBands.session(_sessionNumber);
    final sessionFirst = _sessionNumber <= 1 ||
        band != TelemetryBands.session(_sessionNumber - 1);
    final days =
        TelemetryBands.daysSince(_day(now()) - _installDay, legacy: _legacy);
    final daysFirst = days != _lastDaysBand;
    if (daysFirst) {
      _lastDaysBand = days;
      try {
        _prefs?.setString(_kDaysBand, days);
      } catch (_) {}
    }
    return {'session_band_first': sessionFirst, 'days_band_first': daysFirst};
  }

  static String _platform() {
    for (final p in const ['ios', 'android', 'macos', 'windows', 'linux']) {
      if (Platform.operatingSystem == p) return p;
    }
    return 'other';
  }

  // ── Session ──

  /// The main menu is usable; once per launch.
  void menuReady() {
    if (_menuReadySent) return;
    _menuReadySent = true;
    final ms = now().difference(_launchedAt ?? now()).inMilliseconds;
    track('menu_ready', {'ms': ms.clamp(0, 3600000)});
  }

  /// The app went to the background (or is about to close). Sent at once:
  /// the system may end the process from here.
  void appPaused({required String screen, required int index}) {
    if (_bgSince != null) return;
    final t = now();
    _bgSince = t;
    if (_fgSince != null) _active += t.difference(_fgSince!);
    _fgSince = null;

    final v = _visit;
    if (v != null) {
      comCenterExit = 'background';
      _closeVisit();
      _visitAtPause = v;
    }
    // A sector left open here only counts as abandoned if the process never
    // comes back to it; park its end on disk and drop it on resume.
    final s = _sector;
    if (s != null && _enabled && _sink != null) {
      var live = (secs: 0, part: 0, boss: false);
      try {
        live = _sectorLive?.call() ?? live;
      } catch (_) {}
      _savePending(_sectorEndEvent(s, 'background',
          secs: live.secs, part: live.part, boss: live.boss));
    }
    track('session_pause', {
      'active_secs': _active.inSeconds.clamp(0, 86400),
      'screen': screen,
      'index': index.clamp(0, 10000),
      'sectors': _sectors,
      'deaths': _deaths,
    });
    _persist();
    unawaited(flush());
  }

  /// Back in the foreground. After [sessionGap] this is a new session.
  void appResumed() {
    final bg = _bgSince;
    if (bg == null) return;
    _bgSince = null;
    final t = now();
    _fgSince = t;
    _clearPending();
    if (t.difference(bg) > sessionGap) {
      _session = _newId();
      _seq = 0;
      _sessionNumber++;
      _active = Duration.zero;
      _sectors = 0;
      _deaths = 0;
      try {
        _prefs?.setInt(_kSessions, _sessionNumber);
      } catch (_) {}
      track('app_open', {'start': 'resume'});
    }
    final v = _visitAtPause;
    _visitAtPause = null;
    if (v != null) {
      comCenterReason = 'resume';
      comCenterOpened(props: v.props, affordableLeft: v.affordableLeft);
    }
  }

  /// The player quit from the game's own menu, or the desktop window is
  /// closing: say goodbye and give the queue a brief, bounded chance to go.
  Future<void> appQuitting({required String screen, required int index}) async {
    appPaused(screen: screen, index: index);
    _clearPending();
    try {
      await flush().timeout(const Duration(milliseconds: 1500));
    } catch (_) {}
  }

  // ── Sectors ──

  ({int secs, int part, bool boss}) Function()? _sectorLive;

  /// A sector begins. Props: index, level, dps_band, front, front_level.
  /// [live] reports seconds, part and boss for an end the service has to
  /// write itself (the app went to the background mid-sector).
  void sectorStarted(Map<String, Object> props,
      {({int secs, int part, bool boss}) Function()? live}) {
    _sector = (
      index: props['index'] as int? ?? 0,
      level: props['level'] as int? ?? 1,
    );
    _sectorLive = live;
    _switches = 0;
    _lastCause = 'none';
    _sectors++;
    track('sector_start', props);
  }

  /// The sector being flown ends. No-op when none is open.
  void sectorEnded(String result,
      {required int secs, required int part, required bool boss}) {
    final s = _sector;
    if (s == null) return;
    _sector = null;
    _sectorLive = null;
    if (result == 'death') _deaths++;
    final e = _sectorEndEvent(s, result, secs: secs, part: part, boss: boss);
    track(e.name, e.props);
  }

  TelemetryEvent _sectorEndEvent(({int index, int level}) s, String result,
      {required int secs, required int part, required bool boss}) {
    return TelemetryEvent(
        'sector_end',
        {
          'index': s.index.clamp(0, 10000),
          'level': s.level.clamp(0, 10000),
          'result': result,
          'secs': secs.clamp(0, 86400),
          'part': part.clamp(0, 3),
          'cause': result == 'death' ? _lastCause : 'none',
          'boss': boss,
          'switches': _switches,
        },
        now(),
        _session,
        0);
  }

  /// What last hurt the hull; read only if that hit was fatal.
  void noteHit(String cause) => _lastCause = cause;

  /// A weapon was swapped in flight (sigil swap).
  void noteWeaponSwitch() => _switches++;

  /// The last input device the player touched.
  void noteInput(String kind) => _input = kind;

  // ── ComCenter ──

  /// The ComCenter is on screen. [props] supplies credits_band, index,
  /// buys_avail and upgrades_avail; [affordableLeft] is asked at close.
  void comCenterOpened({
    required Map<String, Object> Function() props,
    required bool Function() affordableLeft,
  }) {
    if (_visit != null) _closeVisit();
    final reason = comCenterReason;
    comCenterReason = 'sector';
    comCenterExit = 'start';
    _visit = _Visit(props, affordableLeft, now());
    Map<String, Object> p = const {};
    try {
      p = props();
    } catch (_) {}
    track('comcenter_open', {'reason': reason, ...p});
  }

  /// Count one ComCenter action.
  void comCenterAction(ComCenterAction a) {
    final v = _visit;
    if (v == null) return;
    switch (a) {
      case ComCenterAction.buy:
        v.buys++;
      case ComCenterAction.upgrade:
        v.upgrades++;
      case ComCenterAction.sell:
        v.sells++;
      case ComCenterAction.switchWeapon:
        v.switches++;
      case ComCenterAction.unavailable:
        v.unavailable++;
      case ComCenterAction.skin:
        v.skinChanged = true;
    }
  }

  /// The ComCenter left the screen.
  void comCenterClosed() => _closeVisit();

  void _closeVisit() {
    final v = _visit;
    if (v == null) return;
    _visit = null;
    var left = false;
    try {
      left = v.affordableLeft();
    } catch (_) {}
    track('comcenter_close', {
      'secs': now().difference(v.since).inSeconds.clamp(0, 86400),
      'buys': v.buys,
      'upgrades': v.upgrades,
      'sells': v.sells,
      'switches': v.switches,
      'unavailable': v.unavailable,
      'skin_changed': v.skinChanged,
      'exit': comCenterExit,
      'left_affordable': left,
    });
    comCenterExit = 'start';
  }

  // ── Sending ──

  /// Send what is queued, a few batches at most. Never throws.
  Future<void> flush() async {
    final sink = _sink;
    if (_flushing || !_ready || !_enabled || sink == null) return;
    _flushing = true;
    try {
      for (var round = 0; round < 4 && _queue.isNotEmpty; round++) {
        final batch = _queue.take(batchSize).toList();
        final r = await sink
            .send(batch)
            .timeout(const Duration(seconds: 12),
                onTimeout: () => SinkResult.retry)
            .catchError((Object _) => SinkResult.retry);
        if (!_enabled) break; // switched off mid-flight: already wiped
        if (r == SinkResult.retry) break;
        final sent = batch.toSet();
        _queue.removeWhere(sent.contains);
        _dirty = true;
      }
    } catch (_) {
    } finally {
      _flushing = false;
      _persist();
    }
  }

  void _persist() {
    final p = _prefs;
    if (p == null || !_dirty) return;
    _dirty = false;
    try {
      if (!_enabled || _queue.isEmpty) {
        p.remove(_kQueue);
      } else {
        p.setString(_kQueue, jsonEncode([for (final e in _queue) e.toJson()]));
      }
    } catch (_) {}
  }

  void _savePending(TelemetryEvent raw) {
    final props = {...raw.props, ..._context(), ..._cohort()};
    if (!TelemetryDictionary.valid(raw.name, props)) return;
    final e = TelemetryEvent(raw.name, props, raw.at, raw.session, ++_seq);
    try {
      _prefs?.setString(_kPending, jsonEncode([e.toJson()]));
    } catch (_) {}
  }

  void _clearPending() {
    try {
      _prefs?.remove(_kPending);
    } catch (_) {}
  }

  static List<TelemetryEvent> _decode(String? s) {
    if (s == null) return const [];
    try {
      final out = <TelemetryEvent>[];
      for (final m in jsonDecode(s) as List) {
        final e = TelemetryEvent.fromJson(Map<String, dynamic>.from(m as Map));
        if (e != null && TelemetryDictionary.valid(e.name, e.props)) out.add(e);
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  // ── Input ──

  bool _listening = false;

  void _listenForInput() {
    try {
      HardwareKeyboard.instance.addHandler(_onKey);
      GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
      _listening = true;
    } catch (_) {}
  }

  bool _onKey(KeyEvent e) {
    _input = 'keyboard';
    return false; // observe only
  }

  void _onPointer(PointerEvent e) {
    if (e is! PointerDownEvent) return;
    _input = switch (e.kind) {
      PointerDeviceKind.touch || PointerDeviceKind.stylus => 'touch',
      _ => 'mouse',
    };
  }

  static int _day(DateTime t) =>
      DateTime.utc(t.year, t.month, t.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  static String _newId() {
    final r = Random.secure();
    return [for (var i = 0; i < 16; i++) r.nextInt(256)]
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}

enum ComCenterAction { buy, upgrade, sell, switchWeapon, unavailable, skin }

class _Visit {
  final Map<String, Object> Function() props;
  final bool Function() affordableLeft;
  final DateTime since;
  int buys = 0, upgrades = 0, sells = 0, switches = 0, unavailable = 0;
  bool skinChanged = false;
  _Visit(this.props, this.affordableLeft, this.since);
}

/// One recorded event: name, dictionary properties, creation time, the
/// in-memory id of the session it belongs to and its order in that session.
class TelemetryEvent {
  final String name;
  final Map<String, Object> props;
  final DateTime at;
  final String session;

  /// Order in the session, from 1 (`i` in protocol v1); 0 until queued. The
  /// collector drops a repeated `(s, i)`, so a batch sent twice is stored
  /// once.
  final int seq;
  const TelemetryEvent(this.name, this.props, this.at, this.session,
      [this.seq = 0]);

  /// The wire and queue shape: `{n, t, s, i, p}` (`i` left out while 0).
  Map<String, Object> toJson() => {
        'n': name,
        't': at.toUtc().toIso8601String(),
        's': session,
        if (seq > 0) 'i': seq,
        'p': props,
      };

  static TelemetryEvent? fromJson(Map<String, dynamic> j) {
    final at = DateTime.tryParse(j['t'] as String? ?? '');
    final n = j['n'], s = j['s'], p = j['p'], i = j['i'];
    if (at == null || n is! String || s is! String || p is! Map) return null;
    return TelemetryEvent(
        n, Map<String, Object>.from(p), at, s, i is int && i > 0 ? i : 0);
  }
}

enum SinkResult {
  /// Accepted; drop from the queue.
  sent,

  /// Try again later (offline, timeout, throttled, server error).
  retry,

  /// Rejected for good (bad request, bad key); drop so it cannot jam.
  drop,
}

/// Where events go. Swapping the vendor means writing one of these.
abstract interface class TelemetrySink {
  Future<SinkResult> send(List<TelemetryEvent> batch);
}

/// The owner's own collector, protocol v1 (the `ol1n_telemetry` package's
/// `docs/protocol.md`): `POST {host}/v1/batch` with the app key in
/// `X-Telemetry-Key` and the body `{"v":1,"app":"kirian","events":[...]}`.
/// No identifier beyond the session's random id goes with it.
///
/// A batch over [maxEvents] events or [maxBodyBytes] is split. If any part
/// has to be retried the whole batch is retried; the collector skips what it
/// already stored by `(s, i)`.
class CollectorSink implements TelemetrySink {
  static const version = 1;
  static const path = '/v1/batch';
  static const keyHeader = 'X-Telemetry-Key';
  static const maxEvents = 100;
  static const maxBodyBytes = 64 * 1024;

  final Uri host;
  final String app;
  final String key;
  final Duration timeout;
  const CollectorSink(
      {required this.host,
      required this.app,
      required this.key,
      this.timeout = const Duration(seconds: 8)});

  /// `{host}/v1/batch`, keeping any path prefix of the host.
  Uri get endpoint {
    var p = host.path;
    while (p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return Uri(
      scheme: host.scheme,
      host: host.host,
      port: host.hasPort ? host.port : null,
      path: '$p$path',
    );
  }

  Map<String, Object> body(List<TelemetryEvent> batch) => {
        'v': version,
        'app': app,
        'events': [for (final e in batch) e.toJson()],
      };

  /// 2xx sent; 408, 429 and 5xx later; anything else dropped.
  static SinkResult resultFor(int status) {
    if (status >= 200 && status < 300) return SinkResult.sent;
    if (status == 408 || status == 429 || status >= 500) {
      return SinkResult.retry;
    }
    return SinkResult.drop;
  }

  @override
  Future<SinkResult> send(List<TelemetryEvent> batch) async {
    if (batch.isEmpty) return SinkResult.sent;
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5)
      ..userAgent = 'Kirian';
    try {
      return await _send(client, batch);
    } finally {
      client.close(force: true);
    }
  }

  Future<SinkResult> _send(HttpClient client, List<TelemetryEvent> batch) async {
    final bytes = utf8.encode(jsonEncode(body(batch)));
    if (bytes.length > maxBodyBytes || batch.length > maxEvents) {
      if (batch.length == 1) return SinkResult.drop;
      final half = batch.length ~/ 2;
      final a = await _send(client, batch.sublist(0, half));
      if (a == SinkResult.retry) return a;
      final b = await _send(client, batch.sublist(half));
      return b == SinkResult.retry ? b : SinkResult.sent;
    }
    try {
      final req = await client.postUrl(endpoint).timeout(timeout);
      req.headers.contentType = ContentType.json;
      req.headers.set(keyHeader, key);
      req.contentLength = bytes.length;
      req.add(bytes);
      final res = await req.close().timeout(timeout);
      await res.drain<void>().timeout(timeout);
      return resultFor(res.statusCode);
    } catch (_) {
      return SinkResult.retry;
    }
  }
}

/// `TELEMETRY_DEBUG`: print instead of send.
class LogSink implements TelemetrySink {
  const LogSink();
  @override
  Future<SinkResult> send(List<TelemetryEvent> batch) async {
    for (final e in batch) {
      debugPrint('telemetry ${e.at.toUtc().toIso8601String()} '
          'i=${e.seq} ${e.name} ${e.props}');
    }
    return SinkResult.sent;
  }
}
