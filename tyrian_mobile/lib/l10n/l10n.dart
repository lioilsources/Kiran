import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Access to the UI strings from places that have no [BuildContext] — the
/// Flame world (float texts, boss part labels) and plain data classes.
///
/// [TyrianApp] keeps [current] in step with the app's resolved locale. Before
/// the first build, and in tests that pump a widget without the localization
/// delegates, it falls back to English.
abstract final class L10n {
  static AppLocalizations? _current;

  static AppLocalizations get current =>
      _current ?? lookupAppLocalizations(const Locale('en'));

  static set current(AppLocalizations value) => _current = value;
}

extension L10nContext on BuildContext {
  /// The strings for this subtree. Registers a dependency on [Localizations]
  /// when one is above, so the widget rebuilds on a locale change; otherwise
  /// (bare test harnesses) falls back to [L10n.current].
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      L10n.current;
}
