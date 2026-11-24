import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/services/set_ladder.dart';

// The same table test goes with every copy of set_ladder.dart; only the
// package import above differs between apps.
void main() {
  const ladder = <SetLadderStep>[
    (threshold: 0, productId: 'all'),
    (threshold: 1, productId: 'all_s1'),
    (threshold: 2, productId: 'all_s2'),
    (threshold: 3, productId: 'all_s3'),
    (threshold: 4, productId: 'all_s4'),
  ];

  const table = <(int owned, String? offer, int index)>[
    (0, 'all', 0),
    (1, 'all_s1', 1),
    (2, 'all_s2', 2),
    (3, 'all_s3', 3),
    (4, 'all_s4', 4),
    (5, 'all_s4', 4),
    (9, 'all_s4', 4),
    (100, 'all_s4', 4),
  ];

  for (final (owned, offer, index) in table) {
    test('owning $owned offers $offer', () {
      expect(setLadderOffer(owned, ladder), offer);
      expect(setLadderIndex(owned, ladder), index);
    });
  }

  test('an empty ladder offers nothing', () {
    expect(setLadderOffer(3, const []), isNull);
    expect(setLadderIndex(3, const []), -1);
  });

  test('nothing is offered below the lowest threshold', () {
    const credit = <SetLadderStep>[
      (threshold: 10, productId: 'pass_s1'),
      (threshold: 20, productId: 'pass_s2'),
    ];
    expect(setLadderOffer(9, credit), isNull);
    expect(setLadderOffer(10, credit), 'pass_s1');
    expect(setLadderOffer(19, credit), 'pass_s1');
    expect(setLadderOffer(25, credit), 'pass_s2');
  });

  test('negative counts offer nothing', () {
    expect(setLadderOffer(-1, ladder), isNull);
  });
}
