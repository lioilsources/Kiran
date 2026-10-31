import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/services/review_prompt_service.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// When the rating request may fire: only on a level clear (part III and its
/// mini-boss), never on level 1, and at most once per 122 days.
void main() {
  final now = DateTime(2026, 11, 1);

  bool gate(int clearedIndex, {DateTime? last}) =>
      ReviewPromptService.shouldPrompt(
        clearedLevel: Sector.levelForIndex(clearedIndex),
        nextLevel: Sector.levelForIndex(clearedIndex + 1),
        now: now,
        lastPrompt: last,
      );

  test('only the last part of a level prompts', () {
    expect(gate(3), isFalse); // level 2, part I
    expect(gate(4), isFalse); // level 2, part II
    expect(gate(5), isTrue); // level 2, part III
  });

  test('clearing level 1 never prompts', () {
    for (var i = 0; i < 3; i++) {
      expect(gate(i), isFalse, reason: 'index $i');
    }
  });

  test('procedural sectors are each a level clear', () {
    expect(gate(18), isTrue);
    expect(gate(19), isTrue);
  });

  test('cooldown keeps it to three a year', () {
    expect(gate(5, last: now.subtract(const Duration(days: 121))), isFalse);
    expect(gate(5, last: now.subtract(const Duration(days: 122))), isTrue);
  });
}
