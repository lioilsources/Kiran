/// Number formatting shared by every HUD/UI surface.
///
/// Credits run into six figures within a few sectors, and an unbroken
/// `621142` stops being readable at a glance. One formatter, used everywhere
/// a credit, price or score is shown, so the game never mixes styles.
library;

/// Group thousands with a space: `621142` → `621 142`.
///
/// A space rather than a comma or dot: it reads unambiguously in both the
/// English UI and the Czech player base (where a dot *is* a thousands
/// separator and a comma is decimal), and it matches SI style.
String fmtNum(num n) {
  final neg = n < 0;
  final digits = n.abs().round().toString();
  final out = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(' ');
    out.write(digits[i]);
  }
  return neg ? '-$out' : out.toString();
}
