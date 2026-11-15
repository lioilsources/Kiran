import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/input/touch_fingers.dart';

/// Plan 34: the fingers on the screen, from Flame's two unrelated id series.
/// A tap carries Flutter's pointer number, a drag Flame's own counter, so
/// these use different numbers for the tap and the drag of one finger — the
/// assumption that they match is what broke plan 32's version.
void main() {
  test('one finger: tap, then its drag — one finger throughout', () {
    final f = TouchFingers();
    f.tapDown(7); // Flutter's pointer number
    expect(f.count, 1);
    expect(f.steering, isNull, reason: 'a resting finger steers nothing');
    f.tapUp(7); // the drag wins: the tap is cancelled …
    f.dragStart(0); // … and the drag starts, under Flame's own id
    expect(f.count, 1);
    expect(f.steering, 0);
    f.dragEnd(0);
    expect(f.count, 0);
    expect(f.dragging, isFalse);
  });

  test('a lone tap is one finger until it lifts', () {
    final f = TouchFingers();
    f.tapDown(3);
    expect(f.count, 1);
    f.tapUp(3);
    expect(f.count, 0);
  });

  test('A drags, B rests: two fingers, A steers', () {
    final f = TouchFingers()
      ..tapDown(5)
      ..tapUp(5)
      ..dragStart(0)
      ..tapDown(6);
    expect(f.count, 2);
    expect(f.steering, 0);
    f.tapUp(6);
    expect(f.count, 1);
  });

  test('the oldest drag steers; when it lifts the next takes over', () {
    final f = TouchFingers()
      ..dragStart(4)
      ..dragStart(5);
    expect(f.count, 2);
    expect(f.steering, 4);
    f.dragEnd(4);
    expect(f.steering, 5);
    expect(f.count, 1);
  });

  test('a tap id equal to another finger\'s drag id is a different finger', () {
    final f = TouchFingers()
      ..dragStart(2) // finger A, moving, drag id 2
      ..tapDown(2); // finger B lands, pointer number 2
    expect(f.count, 2);
    f.tapUp(2); // B lifts
    expect(f.count, 1);
    expect(f.steering, 2, reason: 'A still flies');
  });

  test('a drag reported twice counts once', () {
    final f = TouchFingers()
      ..dragStart(1)
      ..dragStart(1);
    expect(f.count, 1);
  });

  test('lifting an unknown finger is harmless; clear forgets all', () {
    final f = TouchFingers()
      ..tapUp(9)
      ..dragEnd(9);
    expect(f.count, 0);
    f
      ..tapDown(1)
      ..dragStart(0)
      ..clear();
    expect(f.count, 0);
    expect(f.steering, isNull);
  });
}
