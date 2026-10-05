import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/game/challenge.dart';
import 'package:tyrian_mobile/systems/campaign.dart';

/// The contracts the difficulty system rests on. Normal must be a no-op so
/// every VB6-parity number survives; the tiers must order the way the labels
/// promise; and the campaign must carry its own challenge, surviving a save
/// and defaulting sanely for saves that predate it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Challenge.selected = Challenge.normal;
    Challenge.lordUnlocked = false;
  });

  test('normal scales nothing — VB6 parity holds at the default', () {
    const n = Challenge.normal;
    expect(n.hp, 1.0);
    expect(n.damage, 1.0);
    expect(n.cadence, 1.0);
    expect(n.score, 1.0);
  });

  test('tiers get harder in order: more HP, more damage, faster fire', () {
    final order = [Challenge.easy, Challenge.normal, Challenge.hard, Challenge.lord];
    for (var i = 1; i < order.length; i++) {
      final a = order[i - 1], b = order[i];
      expect(b.hp, greaterThan(a.hp), reason: '${b.label} hp');
      expect(b.damage, greaterThan(a.damage), reason: '${b.label} damage');
      expect(b.cadence, lessThan(a.cadence), reason: '${b.label} cadence');
      expect(b.score, greaterThan(a.score), reason: '${b.label} score');
    }
  });

  test('ids are stable save keys and unknown ids fall back to normal', () {
    for (final c in Challenge.values) {
      expect(Challenge.fromId(c.id), c);
    }
    expect(Challenge.fromId(null), Challenge.normal);
    expect(Challenge.fromId('nightmare'), Challenge.normal);
  });

  test('the hidden tier is not offered until unlocked', () async {
    expect(Challenge.offered, isNot(contains(Challenge.lord)));
    expect(Challenge.hard.next, Challenge.easy);
    await Challenge.unlockLord();
    expect(Challenge.offered, contains(Challenge.lord));
    expect(Challenge.hard.next, Challenge.lord);
    expect(Challenge.easy.previous, Challenge.lord);
  });

  test('init drops a persisted hidden pick when it is no longer unlocked',
      () async {
    SharedPreferences.setMockInitialValues({'challenge': 'lord'});
    await Challenge.init();
    expect(Challenge.selected, Challenge.normal);

    SharedPreferences.setMockInitialValues(
        {'challenge': 'lord', 'challenge_lord_unlocked': true});
    await Challenge.init();
    expect(Challenge.selected, Challenge.lord);
  });

  test('a campaign keeps its own challenge across a save', () {
    final c = CampaignState(challenge: Challenge.hard, currentNode: 2);
    final back = CampaignState.fromJson(c.toJson());
    expect(back.challenge, Challenge.hard);
    expect(back.currentNode, 2);
  });

  test('a pre-challenge campaign save loads as normal', () {
    final back = CampaignState.fromJson({
      'currentNode': 5,
      'completed': [0, 1, 2, 3, 4],
      'stars': {},
      'vessel': {},
    });
    expect(back.challenge, Challenge.normal);
  });
}
