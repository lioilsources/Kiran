import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/input/touch_fingers.dart';

/// Plan 32 Q3: the first finger flies, a further finger swaps once.
void main() {
  test('one finger: a tap is the primary, as it always was', () {
    final f = TouchFingers();
    final a = f.down(1);
    expect(a.primary, isTrue);
    expect(a.landed, isTrue);
    f.up(1);
    expect(f.hasPrimary, isFalse);
    expect(f.down(2).primary, isTrue, reason: 'the next finger flies again');
  });

  test('one finger dragging: tap cancel then drag start is one finger', () {
    final f = TouchFingers();
    expect(f.down(1).landed, isTrue); // tap down
    f.tapCancelled(1); // the drag wins the arena
    final drag = f.down(1); // drag start, same pointer
    expect(drag.primary, isTrue);
    expect(drag.landed, isFalse, reason: 'not a second landing');
    f.flush(); // next frame
    expect(f.isPrimary(1), isTrue, reason: 'its drag kept it');
  });

  test('down A, down B, up B, up A', () {
    final f = TouchFingers();
    expect(f.down(1).primary, isTrue);
    final b = f.down(2);
    expect(b.primary, isFalse);
    expect(b.landed, isTrue, reason: 'B swaps, once');
    // B moves a little: its tap is cancelled and its drag starts.
    f.tapCancelled(2);
    expect(f.down(2).landed, isFalse, reason: 'no second swap from one finger');
    f.flush();
    f.up(2);
    expect(f.isPrimary(1), isTrue, reason: 'B lifting leaves A flying');
    f.up(1);
    expect(f.hasPrimary, isFalse);
  });

  test('down A, down B, up A, drag B: B does not take over', () {
    final f = TouchFingers();
    f.down(1);
    f.down(2);
    f.up(1);
    expect(f.hasPrimary, isFalse);
    final drag = f.down(2); // B's drag start
    expect(drag.primary, isFalse, reason: 'B stays a swap finger');
    expect(drag.landed, isFalse, reason: 'and does not swap again');
    expect(f.isPrimary(2), isFalse);
    // A new finger is the next primary.
    expect(f.down(3).primary, isTrue);
  });

  test('every further finger swaps once on landing', () {
    final f = TouchFingers();
    f.down(1);
    expect(f.down(2).landed, isTrue);
    expect(f.down(3).landed, isTrue);
    expect(f.down(3).landed, isFalse);
  });

  test('a cancelled tap whose drag never starts is released', () {
    final f = TouchFingers();
    f.down(1);
    f.tapCancelled(1); // finger gone (system gesture)
    f.flush();
    expect(f.hasPrimary, isFalse, reason: 'no stuck primary');
    expect(f.down(2).primary, isTrue);
  });

  test('lifting an unknown finger is harmless', () {
    final f = TouchFingers();
    f.up(7);
    f.tapCancelled(7);
    f.flush();
    expect(f.hasPrimary, isFalse);
  });
}
