import 'package:intl/intl.dart' show Intl;

import '../l10n/app_localizations.dart';
import '../systems/dev_type.dart';
import 'skin_registry.dart';

/// The one event dictionary (Prompts/33 §4, §6). Everything the game sends
/// is listed here and mirrored, property by property, in `docs/telemetry.md`;
/// `test/telemetry_test.dart` fails when the code, this table and the doc
/// drift apart. [TelemetryService.track] drops any event that does not
/// validate against it, so a mistake costs an event, never a leak.
///
/// Adding an event or a property is a privacy-policy change: ask first.
///
/// Only three kinds of value exist — a bounded whole number, a yes/no, and a
/// value from a fixed list (catalogue names: skins, weapons, languages). No
/// free text, ever: the pilot name cannot pass [TelemetryDictionary.valid].

/// Version of the app this build reports. Kept in step with `pubspec.yaml`
/// by `test/telemetry_test.dart` (there is no package_info dependency).
const kTelemetryAppVersion = '2.10.7';

/// Product line: 3 is `main`, 2 is `release/2.9.x`.
const kTelemetryLine = '2';

sealed class TelemetryProp {
  const TelemetryProp();
  bool accepts(Object? value);
}

/// A whole number in `0..max`.
final class IntProp extends TelemetryProp {
  final int max;
  const IntProp([this.max = 1000000000]);
  @override
  bool accepts(Object? value) => value is int && value >= 0 && value <= max;
}

final class BoolProp extends TelemetryProp {
  const BoolProp();
  @override
  bool accepts(Object? value) => value is bool;
}

/// One value out of a closed list.
final class EnumProp extends TelemetryProp {
  final Set<String> values;
  const EnumProp(this.values);
  @override
  bool accepts(Object? value) => value is String && values.contains(value);
}

/// Weapon names as they go out: `Bubble Gun` → `bubble_gun`.
String telemetryWeaponId(String name) =>
    name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

/// The app's language as it goes out (`en`, `pt_PT`, `zh_Hant`).
String telemetryLocaleId(String localeName) =>
    Intl.canonicalizedLocale(localeName);

/// Bands (§4). Pure functions so the tests can pin every edge.
abstract final class TelemetryBands {
  static const sessions = ['1', '2', '3-5', '6-10', '11+'];
  static const days = ['0', '1', '2-6', '7-29', '30+', 'pre'];
  static const credits = ['0', '1-999', '1k-10k', '10k-100k', '100k-1m', '1m+'];
  static const dps = ['0-99', '100-299', '300-999', '1k-3k', '3k-10k', '10k+'];

  static String session(int n) => n <= 1
      ? '1'
      : n == 2
          ? '2'
          : n <= 5
              ? '3-5'
              : n <= 10
                  ? '6-10'
                  : '11+';

  /// Days since install; `pre` for a pilot who played before measuring began.
  static String daysSince(int d, {bool legacy = false}) => legacy
      ? 'pre'
      : d <= 0
          ? '0'
          : d == 1
              ? '1'
              : d <= 6
                  ? '2-6'
                  : d <= 29
                      ? '7-29'
                      : '30+';

  static String creditsOf(int c) => c <= 0
      ? '0'
      : c < 1000
          ? '1-999'
          : c < 10000
              ? '1k-10k'
              : c < 100000
                  ? '10k-100k'
                  : c < 1000000
                      ? '100k-1m'
                      : '1m+';

  static String dpsOf(double v) => v < 100
      ? '0-99'
      : v < 300
          ? '100-299'
          : v < 1000
              ? '300-999'
              : v < 3000
                  ? '1k-3k'
                  : v < 10000
                      ? '3k-10k'
                      : '10k+';
}

abstract final class TelemetryDictionary {
  static final Set<String> skins = {'none', for (final s in kSkins) s.id};

  static final Set<String> weapons = {
    'none',
    for (final t in [...DevType.frontWeapons, ...DevType.sideWeapons])
      telemetryWeaponId(t.name),
  };

  static final Set<String> languages = {
    for (final l in AppLocalizations.supportedLocales)
      telemetryLocaleId(l.toString()),
  };

  /// Sent with every event.
  static final Map<String, TelemetryProp> common = {
    'app_version': const EnumProp({kTelemetryAppVersion}),
    'line': const EnumProp({kTelemetryLine}),
    'platform':
        const EnumProp({'ios', 'android', 'macos', 'windows', 'linux', 'other'}),
    'lang': EnumProp(languages),
    'skin': EnumProp(skins),
    'input': const EnumProp({'touch', 'mouse', 'pad', 'keyboard', 'none'}),
    'session_band': EnumProp(TelemetryBands.sessions.toSet()),
    'days_band': EnumProp(TelemetryBands.days.toSet()),
    'first_session': const BoolProp(),
    // The 2.x line has one mode and one difficulty. Both stay in the
    // schema so the two lines read the same in the dashboards.
    'mode': const EnumProp({'endless'}),
    'difficulty': const EnumProp({'normal'}),
    'tester': const BoolProp(),
  };

  static const _ms = IntProp(3600000);
  static const _secs = IntProp(86400);
  static const _count = IntProp(100000);
  static const _index = IntProp(10000);

  /// Event name → its own properties (on top of [common]).
  static final Map<String, Map<String, TelemetryProp>> events = {
    'app_open': {
      'start': const EnumProp({'cold', 'resume'}),
    },
    'menu_ready': {
      'ms': _ms,
    },
    'skin_tap': {
      'target': EnumProp(skins),
      'owned': const BoolProp(),
      'result': const EnumProp({'play', 'purchase'}),
      'load_ms': _ms,
      'where': const EnumProp({'menu', 'pause'}),
    },
    'purchase': {
      'target': EnumProp(skins),
      'result': const EnumProp({'ok', 'cancel', 'error'}),
    },
    'comcenter_open': {
      'reason': const EnumProp({'first', 'sector', 'death', 'resume'}),
      'credits_band': EnumProp(TelemetryBands.credits.toSet()),
      'index': _index,
      'buys_avail': _count,
      'upgrades_avail': _count,
    },
    'comcenter_close': {
      'secs': _secs,
      'buys': _count,
      'upgrades': _count,
      'sells': _count,
      'switches': _count,
      'unavailable': _count,
      'skin_changed': const BoolProp(),
      'exit': const EnumProp({'start', 'menu', 'background'}),
      'left_affordable': const BoolProp(),
    },
    'sector_start': {
      'index': _index,
      'level': _index,
      'dps_band': EnumProp(TelemetryBands.dps.toSet()),
      'front': EnumProp(weapons),
      'front_level': const IntProp(100),
    },
    'sector_end': {
      'index': _index,
      'level': _index,
      'result':
          const EnumProp({'completed', 'death', 'menu', 'background', 'quit'}),
      'secs': _secs,
      'part': const IntProp(3),
      'cause': const EnumProp({'none', 'shot', 'ram', 'asteroid', 'other'}),
      'boss': const BoolProp(),
      'switches': _count,
    },
    'session_pause': {
      'active_secs': _secs,
      'screen': const EnumProp(
          {'menu', 'comcenter', 'game', 'pause', 'game_over'}),
      'index': _index,
      'sectors': _count,
      'deaths': _count,
    },
  };

  /// True when [props] are exactly the event's own plus the common ones, and
  /// every value is one the dictionary allows.
  static bool valid(String event, Map<String, Object?> props) {
    final own = events[event];
    if (own == null) return false;
    if (props.length != own.length + common.length) return false;
    for (final e in props.entries) {
      final p = own[e.key] ?? common[e.key];
      if (p == null || !p.accepts(e.value)) return false;
    }
    return true;
  }
}
