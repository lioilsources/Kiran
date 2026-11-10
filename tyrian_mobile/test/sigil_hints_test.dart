import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_hints.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final h = SigilHints.instance;
    h.shown.clear();
    h.dismiss();
  });

  test('each hint shows once in the life of a save (Prompts/29 §5b)', () {
    final h = SigilHints.instance;
    expect(h.offer(SigilHint.hop), isTrue);
    h.dismiss();
    expect(h.offer(SigilHint.hop), isFalse);
    expect(h.offer(SigilHint.loop), isTrue);
  });

  test('one at a time', () {
    final h = SigilHints.instance;
    expect(h.offer(SigilHint.hop), isTrue);
    expect(h.offer(SigilHint.stream), isFalse);
    expect(h.shown.contains(SigilHint.stream), isFalse,
        reason: 'a hint refused for being busy is still owed');
  });

  test('the first hint slows the world, and it lapses on its own', () {
    final h = SigilHints.instance;
    h.offer(SigilHint.hop);
    expect(h.tick(0.1), SigilHints.hopSlow);
    expect(h.tick(SigilHints.duration), 1);
    expect(h.active, isNull);
  });

  test('other hints leave the world at full speed', () {
    final h = SigilHints.instance;
    h.offer(SigilHint.stream);
    expect(h.tick(0.1), 1);
  });

  test('remembered across sessions', () async {
    final h = SigilHints.instance;
    h.offer(SigilHint.loop);
    await Future<void>.delayed(Duration.zero);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('sigil_hints_shown'), contains('loop'));
  });
}
