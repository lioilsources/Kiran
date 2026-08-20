import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/ui/enemy_counter.dart';

void main() {
  testWidgets('seven segment paints every digit without throwing',
      (tester) async {
    // 1234567890 exercises all ten glyph masks in one paint.
    await tester.pumpWidget(const MaterialApp(
      home: ColoredBox(
        color: Colors.black,
        child: Center(
          child: SevenSegmentDisplay(
              value: 1234567890, height: 30, color: Colors.redAccent),
        ),
      ),
    ));
    expect(find.byType(SevenSegmentDisplay), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('width tracks the digit count', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Center(
        child: SevenSegmentDisplay(
            value: 7, height: 30, color: Colors.redAccent),
      ),
    ));
    final one = tester.getSize(find.byType(CustomPaint).last);
    await tester.pumpWidget(const MaterialApp(
      home: Center(
        child: SevenSegmentDisplay(
            value: 77, height: 30, color: Colors.redAccent),
      ),
    ));
    final two = tester.getSize(find.byType(CustomPaint).last);
    expect(two.width, greaterThan(one.width));
    expect(two.height, one.height);
  });
}
