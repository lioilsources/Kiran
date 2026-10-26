import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/challenge.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/systems/campaign.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  test('English objective text matches the spec text', () {
    for (final node in kCampaignNodes) {
      for (final o in node.objectives) {
        expect(o.localizedText(en), o.text, reason: '${node.caption}: ${o.id}');
      }
    }
  });

  test('every supported locale renders every objective and challenge', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      for (final node in kCampaignNodes) {
        for (final o in node.objectives) {
          expect(o.localizedText(l), isNotEmpty, reason: '$locale ${o.id}');
        }
      }
      for (final c in Challenge.values) {
        expect(c.localizedLabel(l), isNotEmpty, reason: '$locale ${c.id}');
      }
    }
  });

  test('Traditional Chinese resolves by script code', () {
    final l = lookupAppLocalizations(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    expect(l.localeName, 'zh_Hant');
  });
}
