import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/l10n/l10n.dart';
import 'package:tyrian_mobile/services/skin_registry.dart';
import 'package:tyrian_mobile/services/skin_store_service.dart';
import 'package:tyrian_mobile/ui/skin_selector.dart';

/// The "All skins" complete-the-set ladder (Pass repo, Prompts/01 §4 A2),
/// run against a fake store.
void main() {
  final paid = [
    for (final s in kSkins)
      if (s.productId != null) s,
  ];
  final ladderIds = [for (final s in kSkinsAllLadder) s.productId];

  // Store prices are opaque strings to the app; these are what the fake
  // store returns, and the tests check they come through untouched.
  const ladderPrices = ['\$4.99', '\$3.99', '\$2.99', '\$1.99', '\$0.99'];
  Map<String, String> allPrices() => {
        for (final s in paid) s.productId!: '\$0.99',
        for (final (i, id) in ladderIds.indexed) id: ladderPrices[i],
      };

  /// A service whose cached state already holds the first [owned] paid skins.
  Future<(SkinStoreService, FakeStore)> start(
    int owned, {
    Map<String, String>? prices,
    Set<String> storeOwns = const {},
  }) async {
    SharedPreferences.setMockInitialValues({
      'unlocked_skins':
          jsonEncode([for (final s in paid.take(owned)) s.id]),
    });
    final store = FakeStore(prices ?? allPrices())..owned.addAll(storeOwns);
    final service = SkinStoreService.withBackend(store);
    await service.init();
    return (service, store);
  }

  test('the ladder is skins_all plus four credited steps', () {
    expect(ladderIds, [
      'com.ol1n.kiran.skins_all',
      'com.ol1n.kiran.skins_all_s1',
      'com.ol1n.kiran.skins_all_s2',
      'com.ol1n.kiran.skins_all_s3',
      'com.ol1n.kiran.skins_all_s4',
    ]);
    expect([for (final s in kSkinsAllLadder) s.threshold], [0, 1, 2, 3, 4]);
    expect(paid.length, greaterThan(4),
        reason: 'the last step must be reachable before owning everything');
  });

  group('offer by owned paid skins', () {
    const table = <(int owned, int step)>[
      (0, 0),
      (1, 1),
      (3, 3),
      (4, 4),
      (9, 4),
    ];
    for (final (owned, step) in table) {
      test('$owned owned → step $step', () async {
        final (service, _) = await start(owned);
        final offer = service.skinsAllOffer!;
        expect(service.ownedPaidSkins, owned);
        expect(offer.step, step);
        expect(offer.productId, ladderIds[step]);
        expect(offer.price, ladderPrices[step]);
        expect(offer.owned, owned);
        expect(offer.fullPrice, step == 0 ? isNull : ladderPrices[0]);
      });
    }

    test('free skins do not count', () async {
      SharedPreferences.setMockInitialValues({
        'unlocked_skins': jsonEncode(['default', 'galaga', 'geometry_wars']),
      });
      final service = SkinStoreService.withBackend(FakeStore(allPrices()));
      await service.init();
      expect(service.ownedPaidSkins, 0);
      expect(service.skinsAllOffer!.step, 0);
    });
  });

  test('buying single skins moves the offer down without a restart',
      () async {
    final (service, store) = await start(0);
    var notified = 0;
    service.addListener(() => notified++);

    await service.buy(paid[0].id);
    await pumpEventQueue();
    expect(service.skinsAllOffer!.step, 1);

    await service.buy(paid[1].id);
    await pumpEventQueue();
    final offer = service.skinsAllOffer!;
    expect(offer.productId, 'com.ol1n.kiran.skins_all_s2');
    expect(offer.price, '\$2.99');
    expect(offer.fullPrice, '\$4.99');
    expect(store.bought, [paid[0].productId, paid[1].productId]);
    expect(notified, greaterThan(0));
  });

  test('any step unlocks every paid skin and survives a relaunch', () async {
    final (service, store) = await start(3);
    await service.buyAllSkins();
    await pumpEventQueue();

    expect(store.bought, ['com.ol1n.kiran.skins_all_s3']);
    expect(service.ownsAllSkins, isTrue);
    expect(service.bundlePending, isFalse);
    expect(paid.every((s) => service.isUnlocked(s.id)), isTrue);
    expect(service.skinsAllOffer, isNull);
    // Single skins can no longer be bought.
    await service.buy(paid.last.id);
    expect(store.bought, hasLength(1));

    // Relaunch on the same device, without touching the store.
    final again = SkinStoreService.withBackend(FakeStore(allPrices()));
    await again.init();
    expect(again.ownsAllSkins, isTrue);
    expect(paid.every((s) => again.isUnlocked(s.id)), isTrue);
  });

  test('restore brings back a credited step on a fresh install', () async {
    final (service, _) = await start(0,
        storeOwns: {'com.ol1n.kiran.skins_all_s2'});
    expect(service.isUnlocked(paid.first.id), isFalse);

    await service.restore();
    await pumpEventQueue();

    expect(service.ownsAllSkins, isTrue);
    expect(paid.every((s) => service.isUnlocked(s.id)), isTrue);
    expect(service.skinsAllOffer, isNull);
  });

  test('restore brings back single skins and recomputes the offer', () async {
    final (service, _) = await start(0,
        storeOwns: {paid[0].productId!, paid[1].productId!, paid[2].productId!});
    await service.restore();
    await pumpEventQueue();
    expect(service.ownsAllSkins, isFalse);
    expect(service.skinsAllOffer!.step, 3);
  });

  group('missing prices', () {
    test('no step 0 price: offer stays, strike-through goes', () async {
      final (service, _) = await start(2,
          prices: allPrices()..remove('com.ol1n.kiran.skins_all'));
      final offer = service.skinsAllOffer!;
      expect(offer.step, 2);
      expect(offer.price, '\$2.99');
      expect(offer.fullPrice, isNull);
    });

    test('offered step not returned by the store: no bundle at all',
        () async {
      final (service, store) = await start(2,
          prices: allPrices()..remove('com.ol1n.kiran.skins_all_s2'));
      expect(service.skinsAllOffer, isNull);
      await service.buyAllSkins();
      expect(store.bought, isEmpty);
    });

    test('no bundle products at all: no bundle', () async {
      final (service, _) = await start(1,
          prices: allPrices()..removeWhere((id, _) => isSkinsAllProduct(id)));
      expect(service.skinsAllOffer, isNull);
    });

    test('store unavailable: no bundle', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SkinStoreService.withBackend(
          FakeStore(allPrices(), available: false));
      await service.init();
      expect(service.skinsAllOffer, isNull);
    });
  });

  test('desktop and tester builds never offer the bundle', () {
    expect(SkinStoreService.instance.supported, isFalse);
    expect(SkinStoreService.instance.skinsAllOffer, isNull);
  });

  group('UI', () {
    Widget host(Widget child, {Locale locale = const Locale('en')}) =>
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Column(children: [child])),
        );

    const credited = SkinsAllOffer(
        productId: 'com.ol1n.kiran.skins_all_s2',
        step: 2,
        owned: 2,
        price: '\$2.99',
        fullPrice: '\$4.99');

    testWidgets('credited step: store price, struck full price, credit line',
        (tester) async {
      await tester.pumpWidget(host(const Column(children: [
        SkinsAllChip(offer: credited, buying: false),
        SkinsAllCredit(offer: credited),
      ])));
      final rich = tester.widget<Text>(find.byType(Text).first);
      final spans = (rich.textSpan! as TextSpan).children!.cast<TextSpan>();
      expect(spans.first.text, 'ALL SKINS \$2.99');
      expect(spans.last.text, ' \$4.99');
      expect(spans.last.style!.decoration, TextDecoration.lineThrough);
      expect(find.text("You already own 2 skins, we've credited them"),
          findsOneWidget);
    });

    testWidgets('missing full price hides the strike-through',
        (tester) async {
      const noFull = SkinsAllOffer(
          productId: 'com.ol1n.kiran.skins_all_s2',
          step: 2,
          owned: 2,
          price: '\$2.99',
          fullPrice: null);
      await tester.pumpWidget(
          host(const SkinsAllChip(offer: noFull, buying: false)));
      final rich = tester.widget<Text>(find.byType(Text));
      final spans = (rich.textSpan! as TextSpan).children!;
      expect(spans, hasLength(1));
    });

    testWidgets('step 0 shows no credit line', (tester) async {
      const full = SkinsAllOffer(
          productId: 'com.ol1n.kiran.skins_all',
          step: 0,
          owned: 0,
          price: '\$4.99',
          fullPrice: null);
      await tester.pumpWidget(host(const SkinsAllCredit(offer: full)));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('Czech credit line', (tester) async {
      await tester.pumpWidget(host(const SkinsAllCredit(offer: credited),
          locale: const Locale('cs')));
      expect(find.text('Už máš 2 skiny, odečetli jsme je'), findsOneWidget);
    });

    test('every locale has the bundle strings', () {
      for (final locale in AppLocalizations.supportedLocales) {
        final l = lookupAppLocalizations(locale);
        expect(l.allSkins, isNotEmpty, reason: '$locale');
        expect(l.allSkinsCredited(3), contains('3'), reason: '$locale');
      }
    });
  });
}

/// A store account in memory: [owned] is what it has bought, [bought] what
/// the app asked it to sell during the test.
class FakeStore implements SkinStoreBackend {
  FakeStore(this.prices, {this.available = true});

  final Map<String, String> prices;
  final bool available;
  final Set<String> owned = {};
  final List<String> bought = [];
  final _updates = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _updates.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> ids) async => [
        for (final id in ids)
          if (prices.containsKey(id))
            ProductDetails(
                id: id,
                title: id,
                description: '',
                price: prices[id]!,
                rawPrice: 0,
                currencyCode: 'USD'),
      ];

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async {
    bought.add(product.id);
    owned.add(product.id);
    scheduleMicrotask(
        () => _updates.add([_details(product.id, PurchaseStatus.purchased)]));
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    final restored = [
      for (final id in owned) _details(id, PurchaseStatus.restored),
    ];
    scheduleMicrotask(() => _updates.add(restored));
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  static PurchaseDetails _details(String id, PurchaseStatus status) =>
      PurchaseDetails(
        productID: id,
        verificationData: PurchaseVerificationData(
            localVerificationData: '', serverVerificationData: '', source: ''),
        transactionDate: null,
        status: status,
      );
}
