import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/ui/format.dart';

void main() {
  test('groups thousands with a space', () {
    expect(fmtNum(0), '0');
    expect(fmtNum(999), '999');
    expect(fmtNum(1000), '1 000');
    expect(fmtNum(621142), '621 142');
    expect(fmtNum(5000000), '5 000 000');
  });

  test('rounds doubles — prices come in as double', () {
    expect(fmtNum(12500.0), '12 500');
    expect(fmtNum(999.6), '1 000');
  });

  test('keeps the sign in front of the groups', () {
    expect(fmtNum(-2500), '-2 500');
  });
}
