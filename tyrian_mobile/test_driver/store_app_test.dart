import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

/// Host side of `make store-screenshots`: walks the seeded app through the
/// scenes the store listing shows and captures each with `simctl` into
/// `$SHOTS_DIR/<name>.png`. Raw captures only — captions and store sizes are
/// added afterwards by `marketing/screenshots/compose.py`.
Future<void> main() async {
  final dir = Platform.environment['SHOTS_DIR'] ?? 'build/store_screenshots';
  final device = Platform.environment['SHOTS_DEVICE'] ?? 'booted';
  await Directory(dir).create(recursive: true);

  final driver = await FlutterDriver.connect();

  Future<void> shot(String name, {int settle = 2}) async {
    await Future<void>.delayed(Duration(seconds: settle));
    final r = await Process.run('xcrun', [
      'simctl',
      'io',
      device,
      'screenshot',
      '$dir/$name.png',
    ]);
    if (r.exitCode != 0) throw StateError('capture: ${r.stderr}');
    stdout.writeln('shot $name');
  }

  final grid = find.byType('GridView');
  final canvas = find.byType('GameWidget<TyrianGame>');

  /// From the main menu: pick a skin, land in the Com Center.
  Future<void> pickSkin(String name) async {
    await driver.scrollUntilVisible(grid, find.text(name), dyScroll: -300);
    await driver.tap(find.text(name));
    await driver.waitFor(
      find.text('CONTINUE MISSION'),
      timeout: const Duration(seconds: 60),
    );
  }

  /// From the Com Center: launch, switch auto-fire on, let a wave arrive.
  Future<void> fly(String name, {List<int> at = const [14, 8]}) async {
    await driver.tap(find.text('CONTINUE MISSION'));
    await Future<void>.delayed(const Duration(seconds: 2));
    await driver.tap(canvas); // a tap toggles fire
    for (var i = 0; i < at.length; i++) {
      await shot('${name}_$i', settle: at[i]);
    }
  }

  Future<void> toMainMenu() async {
    await driver.tap(find.text('PAUSE'));
    await driver.tap(find.text('MAIN MENU'));
    await driver.waitFor(find.text('SELECT SKIN'));
  }

  // Flame redraws every frame, so the driver's default frame sync — wait
  // until no frame is pending — would wait forever. And the seed runs before
  // runApp while the driver connects before either is done: until a root
  // widget exists every command, frame-sync toggling included, fails outright.
  for (var i = 0; ; i++) {
    try {
      await driver.runUnsynchronized(
        () => driver.waitFor(
          find.text('SELECT SKIN'),
          timeout: const Duration(minutes: 3),
        ),
      );
      break;
    } on DriverError {
      if (i == 60) rethrow;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  try {
    await driver.runUnsynchronized(() async {
      await shot('skins', settle: 4);

      await pickSkin('Kiran (2026)');
      await shot('comcenter_default');
      await fly('play_default', at: [12, 8, 8]);
      await toMainMenu();

      for (final (id, name) in const [
        ('neon_grid', 'Neon Grid (2003)'),
        ('dual_polarity', 'Dual-Polarity (2001)'),
        ('biomech', 'Biomech Cruiser (1987)'),
        ('pixel', 'Retro PC Pixel (1995)'),
      ]) {
        await pickSkin(name);
        await shot('comcenter_$id');
        await fly('play_$id');
        await toMainMenu();
      }

      await driver.tap(find.text('CAMPAIGN'));
      await shot('campaign', settle: 4);
    });
  } finally {
    await driver.close();
  }
}
