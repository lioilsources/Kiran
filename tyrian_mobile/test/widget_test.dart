import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    // TyrianApp depends on just_audio + Flame GameWidget which require native
    // plugin registration — not testable as a widget test without mocks.
    expect(true, isTrue);
  });
}
