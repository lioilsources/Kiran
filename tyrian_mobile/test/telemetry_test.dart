import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/services/pilot_name_generator.dart';
import 'package:tyrian_mobile/services/telemetry_service.dart';

/// Prompts/33 §4, §7 T1: bands, queue and its limit, no key → no network,
/// off → nothing, the dictionary covers everything the code sends, no
/// property is free text.

class FakeSink implements TelemetrySink {
  final List<List<TelemetryEvent>> batches = [];
  SinkResult result = SinkResult.sent;
  @override
  Future<SinkResult> send(List<TelemetryEvent> batch) async {
    batches.add(List.of(batch));
    return result;
  }

  List<TelemetryEvent> get sent => [for (final b in batches) ...b];
}

class _RealHttp extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime clock;
  late FakeSink sink;

  Future<TelemetryService> start(
      {Map<String, Object> prefs = const {}, bool resetPrefs = true}) async {
    if (resetPrefs) SharedPreferences.setMockInitialValues(prefs);
    final t = TelemetryService.resetForTest()..now = () => clock;
    await t.init(
        sink: sink,
        prefs: await SharedPreferences.getInstance(),
        startTimer: false);
    return t;
  }

  setUp(() {
    clock = DateTime(2026, 11, 14, 12);
    sink = FakeSink();
  });

  tearDown(() => TelemetryService.resetForTest());

  group('bands', () {
    test('sessions', () {
      expect([for (final n in [1, 2, 3, 5, 6, 10, 11, 500]) TelemetryBands.session(n)],
          ['1', '2', '3-5', '3-5', '6-10', '6-10', '11+', '11+']);
    });
    test('days since install', () {
      expect([for (final d in [0, 1, 2, 6, 7, 29, 30, 400]) TelemetryBands.daysSince(d)],
          ['0', '1', '2-6', '2-6', '7-29', '7-29', '30+', '30+']);
      expect(TelemetryBands.daysSince(0, legacy: true), 'pre');
    });
    test('credits and DPS', () {
      expect([for (final c in [0, 1, 999, 1000, 9999, 10000, 99999, 100000, 999999, 1000000])
          TelemetryBands.creditsOf(c)],
          ['0', '1-999', '1-999', '1k-10k', '1k-10k', '10k-100k', '10k-100k',
           '100k-1m', '100k-1m', '1m+']);
      expect([for (final v in [0.0, 99.9, 100.0, 299.0, 300.0, 999.0, 1000.0, 2999.0, 3000.0, 9999.0, 10000.0])
          TelemetryBands.dpsOf(v)],
          ['0-99', '0-99', '100-299', '100-299', '300-999', '300-999', '1k-3k',
           '1k-3k', '3k-10k', '3k-10k', '10k+']);
    });
  });

  group('dictionary', () {
    test('every value is a whole number, a yes/no or a token from a fixed list', () {
      final token = RegExp(r'^[A-Za-z0-9_.+\-]{1,32}$');
      final all = {
        ...TelemetryDictionary.common,
        for (final e in TelemetryDictionary.events.values) ...e,
      };
      for (final MapEntry(:key, :value) in all.entries) {
        switch (value) {
          case EnumProp(:final values):
            expect(values, isNotEmpty, reason: key);
            for (final v in values) {
              expect(token.hasMatch(v), isTrue, reason: '$key: "$v"');
            }
          case IntProp(:final max):
            expect(max, lessThanOrEqualTo(1000000000), reason: key);
          case BoolProp():
            break;
        }
      }
    });

    test('no pilot name, no free text, no unknown key gets through', () {
      final props = <String, Object>{
        'app_version': kTelemetryAppVersion,
        'line': kTelemetryLine,
        'platform': 'ios',
        'lang': 'en',
        'skin': 'default',
        'input': 'touch',
        'session_band': '1',
        'days_band': '0',
        'first_session': true,
        'mode': 'endless',
        'difficulty': 'normal',
        'tester': false,
        'start': 'cold',
      };
      expect(TelemetryDictionary.valid('app_open', props), isTrue);
      for (var i = 0; i < 20; i++) {
        final name = PilotNameGenerator.randomCodename();
        expect(TelemetryDictionary.valid('app_open', {...props, 'start': name}),
            isFalse, reason: name);
        expect(TelemetryDictionary.valid('app_open', {...props, 'skin': name}),
            isFalse, reason: name);
      }
      expect(TelemetryDictionary.valid('app_open', {...props, 'pilot': 'x'}), isFalse);
      expect(TelemetryDictionary.valid('app_open', {...props}..remove('start')), isFalse);
      expect(TelemetryDictionary.valid('pilot_renamed', props), isFalse);
      expect(TelemetryDictionary.valid('app_open', {...props, 'start': 3}), isFalse);
    });

    test('languages are the shipped locales, as the app names them', () {
      for (final l in AppLocalizations.supportedLocales) {
        final name = lookupAppLocalizations(l).localeName;
        expect(TelemetryDictionary.languages, contains(telemetryLocaleId(name)),
            reason: '$l');
      }
      expect(TelemetryDictionary.languages, containsAll(['en', 'pt_PT', 'zh_Hant']));
    });

    test('docs/telemetry.md lists exactly the dictionary', () {
      final doc = File('../docs/telemetry.md').readAsStringSync();
      final sections = doc.split(RegExp(r'^### ', multiLine: true));
      final documented = <String, Set<String>>{};
      final row = RegExp(r'^\| `([a-z_]+)` \|', multiLine: true);
      for (final s in sections.skip(1)) {
        final name = RegExp(r'^`([a-z_]+)`').firstMatch(s)?.group(1);
        if (name == null) continue;
        documented[name] = {for (final m in row.allMatches(s)) m.group(1)!};
      }
      expect(documented.keys.toSet(), TelemetryDictionary.events.keys.toSet());
      for (final e in TelemetryDictionary.events.entries) {
        expect(documented[e.key], e.value.keys.toSet(), reason: e.key);
      }
      final common = doc
          .split('## Common properties')[1]
          .split('## Events')[0];
      expect({for (final m in row.allMatches(common)) m.group(1)!},
          TelemetryDictionary.common.keys.toSet());
    });

    test('the code sends only dictionary events, and every one of them', () {
      final sent = <String>{};
      final literal = RegExp(r"""(?:track|TelemetryEvent)\(\s*'([a-z_]+)'""");
      final anyTrack = RegExp(r'\.track\(');
      for (final f in Directory('lib').listSync(recursive: true)) {
        if (f is! File || !f.path.endsWith('.dart')) continue;
        final src = f.readAsStringSync();
        for (final m in literal.allMatches(src)) {
          sent.add(m.group(1)!);
        }
        if (f.path.endsWith('telemetry_service.dart')) continue;
        // Outside the service, every call names its event literally, so
        // this scan sees all of them.
        final calls = anyTrack.allMatches(src).length;
        final literals = RegExp(r"\.track\(\s*'").allMatches(src).length;
        expect(literals, calls, reason: '${f.path}: track() needs a literal name');
      }
      expect(sent, TelemetryDictionary.events.keys.toSet());
    });

    test('app version matches pubspec.yaml', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final v = RegExp(r'^version:\s*([0-9.]+)', multiLine: true)
          .firstMatch(pubspec)!
          .group(1);
      expect(kTelemetryAppVersion, v);
    });

    test('every release build gets the key and host from secrets', () {
      for (final f in const [
        'release-ios.yml',
        'release-android.yml',
        'release-macos.yml',
        'release-windows.yml',
        'release-linux.yml',
        'steam-deploy.yml',
      ]) {
        final src = File('../.github/workflows/$f').readAsStringSync();
        final builds =
            RegExp(r'flutter build \w+ --release[^\n]*').allMatches(src).toList();
        expect(builds, isNotEmpty, reason: f);
        for (final b in builds) {
          expect(
              b.group(0),
              allOf(contains(r'TELEMETRY_KEY=${{ secrets.TELEMETRY_KEY }}'),
                  contains(r'TELEMETRY_HOST=${{ secrets.TELEMETRY_HOST }}')),
              reason: f);
        }
      }
    });

    test('every locale translates the toggle', () {
      final en = lookupAppLocalizations(const Locale('en'));
      for (final l in AppLocalizations.supportedLocales) {
        final s = lookupAppLocalizations(l);
        expect(s.statsOn, isNotEmpty);
        expect(s.statsOn, isNot(s.statsOff), reason: '$l');
        if (l.languageCode != 'en') {
          expect(s.statsOn, isNot(en.statsOn), reason: '$l');
        }
      }
    });
  });

  group('no key, no network', () {
    test('a build without TELEMETRY_KEY has no sink', () {
      expect(TelemetryService.defaultSink(), isNull);
    });

    test('tracking without a sink touches neither the network nor the disk', () async {
      var clients = 0;
      await HttpOverrides.runZoned(() async {
        SharedPreferences.setMockInitialValues({});
        final t = TelemetryService.resetForTest();
        await t.init(startTimer: false);
        expect(t.active, isFalse);
        t.track('app_open', {'start': 'cold'});
        t.appPaused(screen: 'menu', index: 0);
        await t.flush();
        expect(t.queued, isEmpty);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getKeys(), isEmpty);
      }, createHttpClient: (_) {
        clients++;
        throw StateError('network');
      });
      expect(clients, 0);
    });

    test('a service nobody initialised records nothing', () {
      final t = TelemetryService.resetForTest();
      t.track('app_open', {'start': 'cold'});
      expect(t.queued, isEmpty);
    });
  });

  group('queue', () {
    test('keeps at most 500, dropping the oldest; time is creation time', () async {
      final t = await start();
      for (var i = 0; i < 600; i++) {
        clock = clock.add(const Duration(seconds: 1));
        t.track('menu_ready', {'ms': i});
      }
      expect(t.queued.length, TelemetryService.maxQueue);
      expect(t.queued.first.props['ms'], 100);
      expect(t.queued.last.at, clock);
    });

    test('sends in batches of 50 and keeps what failed', () async {
      final t = await start();
      for (var i = 0; i < 120; i++) {
        t.track('menu_ready', {'ms': i});
      }
      sink.result = SinkResult.retry;
      await t.flush();
      expect(sink.batches.length, 1);
      expect(t.queued.length, 120);

      sink.result = SinkResult.sent;
      await t.flush();
      expect([for (final b in sink.batches.skip(1)) b.length], [50, 50, 20]);
      expect(t.queued, isEmpty);
    });

    test('a rejected batch is dropped, not retried forever', () async {
      final t = await start();
      t.track('menu_ready', {'ms': 1});
      sink.result = SinkResult.drop;
      await t.flush();
      expect(t.queued, isEmpty);
    });

    test('survives a restart, still validated', () async {
      final t = await start();
      sink.result = SinkResult.retry; // offline
      t.track('menu_ready', {'ms': 7});
      t.appPaused(screen: 'menu', index: 0); // persists
      await Future<void>.delayed(Duration.zero);
      final t2 = await start(resetPrefs: false);
      expect([for (final e in t2.queued) e.name],
          containsAllInOrder(['menu_ready', 'session_pause']));
    });

    test('events are validated: a bad one is refused', () async {
      final t = await start();
      expect(() => t.track('menu_ready', {'ms': 'fast'}), throwsA(isA<AssertionError>()));
      expect(() => t.track('nope'), throwsA(isA<AssertionError>()));
    });
  });

  group('off', () {
    test('switching off wipes the queue and stops sending at once', () async {
      final t = await start();
      t.track('menu_ready', {'ms': 1});
      t.appPaused(screen: 'menu', index: 0);
      await t.setEnabled(false);
      expect(t.queued, isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('telemetry_queue'), isNull);
      expect(prefs.getString('telemetry_pending'), isNull);
      expect(prefs.getBool('telemetry_enabled'), isFalse);

      final before = sink.sent.length;
      t.appResumed();
      t.track('menu_ready', {'ms': 2});
      await t.flush();
      expect(t.queued, isEmpty);
      expect(sink.sent.length, before);
    });

    test('stays off across launches', () async {
      final t = await start();
      await t.setEnabled(false);
      final t2 = await start(resetPrefs: false);
      expect(t2.enabled, isFalse);
      t2.track('app_open', {'start': 'cold'});
      expect(t2.queued, isEmpty);
    });
  });

  group('sessions', () {
    test('a fresh install: session 1, day 0, first session', () async {
      final t = await start();
      t.track('app_open', {'start': 'cold'});
      final p = t.queued.single.props;
      expect(p['session_band'], '1');
      expect(p['days_band'], '0');
      expect(p['first_session'], isTrue);
    });

    test('a pilot who played before measuring is not new', () async {
      final t = await start(prefs: {'game_state': '{}'});
      t.track('app_open', {'start': 'cold'});
      final p = t.queued.single.props;
      expect(p['days_band'], 'pre');
      expect(p['first_session'], isFalse);
    });

    test('second launch three days later', () async {
      await start();
      clock = clock.add(const Duration(days: 3));
      final t = await start(resetPrefs: false);
      t.track('app_open', {'start': 'cold'});
      final p = t.queued.single.props;
      expect(p['session_band'], '2');
      expect(p['days_band'], '2-6');
      expect(p['first_session'], isFalse);
    });

    test('more than 30 minutes away starts a new session; less does not', () async {
      final t = await start();
      final first = t.sessionId;
      clock = clock.add(const Duration(minutes: 5));
      t.appPaused(screen: 'menu', index: 0);
      clock = clock.add(const Duration(minutes: 10));
      t.appResumed();
      expect(t.sessionId, first);

      t.appPaused(screen: 'game', index: 3);
      clock = clock.add(const Duration(minutes: 31));
      t.appResumed();
      expect(t.sessionId, isNot(first));
      final open = t.queued.last;
      expect(open.name, 'app_open');
      expect(open.props['start'], 'resume');
      expect(open.props['session_band'], '2');
      expect(open.session, t.sessionId);
    });

    test('session_pause reports foreground time, sectors and deaths', () async {
      final t = await start();
      t.sectorStarted(_sector(0));
      clock = clock.add(const Duration(seconds: 70));
      t.noteHit('shot');
      t.sectorEnded('death', secs: 65, part: 1, boss: false);
      t.appPaused(screen: 'game_over', index: 0);
      final end = t.queued.firstWhere((e) => e.name == 'sector_end').props;
      expect(end['result'], 'death');
      expect(end['cause'], 'shot');
      final pause = t.queued.last.props;
      expect(pause['active_secs'], 70);
      expect(pause['sectors'], 1);
      expect(pause['deaths'], 1);
      expect(pause['screen'], 'game_over');
    });

    test('the session id never reaches the disk outside unsent events', () async {
      final t = await start();
      t.track('app_open', {'start': 'cold'});
      t.appPaused(screen: 'menu', index: 0);
      await t.flush();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), {
        'telemetry_install_day',
        'telemetry_legacy',
        'telemetry_sessions',
      });
      for (final k in prefs.getKeys()) {
        expect('${prefs.get(k)}', isNot(contains(t.sessionId)), reason: k);
      }
    });
  });

  group('sectors left in the background', () {
    test('coming back drops the parked end', () async {
      final t = await start();
      t.sectorStarted(_sector(4), live: () => (secs: 30, part: 2, boss: false));
      t.appPaused(screen: 'game', index: 4);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('telemetry_pending'), isNotNull);
      t.appResumed();
      expect(prefs.getString('telemetry_pending'), isNull);
      t.sectorEnded('completed', secs: 60, part: 2, boss: false);
      expect([for (final e in t.queued) if (e.name == 'sector_end') e.props['result']],
          ['completed']);
    });

    test('a process that never comes back reports it on the next launch', () async {
      final t = await start();
      final session = t.sessionId;
      t.sectorStarted(_sector(4), live: () => (secs: 30, part: 2, boss: true));
      clock = clock.add(const Duration(seconds: 30));
      t.appPaused(screen: 'game', index: 4);
      final pausedAt = clock;
      clock = clock.add(const Duration(hours: 5));
      final t2 = await start(resetPrefs: false);
      final end = t2.queued.lastWhere((e) => e.name == 'sector_end');
      expect(end.props['result'], 'background');
      expect(end.props['secs'], 30);
      expect(end.props['part'], 2);
      expect(end.at.isAtSameMomentAs(pausedAt), isTrue);
      expect(end.session, session);
    });
  });

  group('ComCenter', () {
    test('a visit is counted and closed with how it was left', () async {
      final t = await start();
      t.comCenterReason = 'sector';
      t.comCenterOpened(
          props: () => {
                'credits_band': '1k-10k',
                'index': 3,
                'buys_avail': 2,
                'upgrades_avail': 1,
              },
          affordableLeft: () => true);
      t.comCenterAction(ComCenterAction.buy);
      t.comCenterAction(ComCenterAction.unavailable);
      t.comCenterAction(ComCenterAction.unavailable);
      clock = clock.add(const Duration(seconds: 42));
      t.comCenterClosed();
      final open = t.queued[0].props, close = t.queued[1].props;
      expect(open['reason'], 'sector');
      expect(close['secs'], 42);
      expect(close['buys'], 1);
      expect(close['unavailable'], 2);
      expect(close['exit'], 'start');
      expect(close['left_affordable'], isTrue);
    });

    test('the background closes a visit and coming back reopens it', () async {
      final t = await start();
      t.comCenterOpened(
          props: () => {
                'credits_band': '0',
                'index': 0,
                'buys_avail': 0,
                'upgrades_avail': 0,
              },
          affordableLeft: () => false);
      t.appPaused(screen: 'comcenter', index: 0);
      t.appResumed();
      t.comCenterClosed();
      expect([
        for (final e in t.queued)
          if (e.name.startsWith('comcenter'))
            '${e.name}:${e.props['reason'] ?? e.props['exit']}'
      ], [
        'comcenter_open:first',
        'comcenter_close:background',
        'comcenter_open:resume',
        'comcenter_close:start',
      ]);
    });
  });

  group('PostHog sink', () {
    test('anonymous batch: session id as distinct_id, no person profile', () async {
      await HttpOverrides.runWithHttpOverrides(() async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final bodies = <Map<String, dynamic>>[];
        var status = 200;
        server.listen((req) async {
          bodies.add(jsonDecode(await utf8.decodeStream(req)) as Map<String, dynamic>);
          expect(req.uri.path, '/batch/');
          req.response.statusCode = status;
          await req.response.close();
        });
        final s = PostHogSink(
            host: Uri.parse('http://127.0.0.1:${server.port}'), apiKey: 'k');
        final e = TelemetryEvent('menu_ready', const {'ms': 5},
            DateTime.utc(2026, 11, 14, 12), 'abc');
        expect(await s.send([e]), SinkResult.sent);
        final b = bodies.single;
        expect(b['api_key'], 'k');
        final ev = (b['batch'] as List).single as Map;
        expect(ev['event'], 'menu_ready');
        expect(ev['timestamp'], '2026-11-14T12:00:00.000Z');
        expect(ev['properties'], {
          'ms': 5,
          'distinct_id': 'abc',
          r'$process_person_profile': false,
          r'$lib': 'kirian',
        });

        status = 400;
        expect(await s.send([e]), SinkResult.drop);
        status = 503;
        expect(await s.send([e]), SinkResult.retry);
        await server.close(force: true);
        expect(await s.send([e]), SinkResult.retry); // nobody listening
      }, _RealHttp());
    });
  });
}

Map<String, Object> _sector(int index) => {
      'index': index,
      'level': 1,
      'dps_band': '0-99',
      'front': 'bubble_gun',
      'front_level': 0,
    };
