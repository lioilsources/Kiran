import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';

void main() {
  test('English is the fallback outside a widget tree', () {
    expect(L10n.current.localeName, 'en');
    expect(L10n.current.paused, 'PAUSED');
  });

  test('every supported locale renders the parameterised strings', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      expect(l.scoreValue('1 000'), contains('1 000'), reason: '$locale');
      expect(l.creditsValue('42'), contains('42'), reason: '$locale');
      expect(l.weaponLevelUnlocked('III'), contains('III'), reason: '$locale');
      expect(l.maxLevelSold('500'), contains('500'), reason: '$locale');
      expect(l.sectorUnknownSpace(7), contains('7'), reason: '$locale');
      expect(l.levelShort(3), contains('3'), reason: '$locale');
      expect(l.weaponOff('LASER'), contains('LASER'), reason: '$locale');
      expect(l.unlocksAt('400 000'), contains('400 000'), reason: '$locale');
      // Weapon family names are proper nouns: identical in every language.
      expect(
          [l.familyBubble, l.familyVulcan, l.familyBlaster, l.familyStar, l.familyLaser],
          ['BUBBLE', 'VULCAN', 'BLASTER', 'STAR', 'LASER'],
          reason: '$locale');
      expect(l.hostingAt('host.example'), contains('host.example'), reason: '$locale');
      expect(l.ipValue('host.example'), contains('host.example'), reason: '$locale');
      expect(l.connectToHost, isNotEmpty, reason: '$locale');
      expect(l.padControlsHint, contains('[OPTIONS]'), reason: '$locale');
    }
  });

  test('Traditional Chinese resolves by script code', () {
    final l = lookupAppLocalizations(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    expect(l.localeName, 'zh_Hant');
  });
}
