import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/ui/pass_through.dart';

/// The HUD lets the finger through to the game, except on its buttons.
void main() {
  testWidgets('a touch on the HUD reaches the game; a button still taps', (
    tester,
  ) async {
    var game = 0;
    var button = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (_) => game++,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PassThrough(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0x80000000)),
                  child: Row(
                    children: [
                      const Text('HP 125', key: Key('bar')),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => button++,
                        child: const Text('PAUSE', key: Key('button')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bar')), warnIfMissed: false);
    expect(game, 1, reason: 'the bars let the touch through');
    final backdrop =
        tester.getTopLeft(find.byType(Container)) + const Offset(2, 2);
    await tester.tapAt(backdrop);
    expect(game, 2, reason: 'so does the backdrop');
    expect(button, 0);

    await tester.tap(find.byKey(const Key('button')));
    expect(button, 1, reason: 'a button still takes its tap');
    expect(game, 2, reason: 'and keeps it from the game');
  });
}
