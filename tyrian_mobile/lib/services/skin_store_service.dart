import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'set_ladder.dart';
import 'skin_registry.dart';
import 'telemetry_service.dart';

/// The one place that talks to the platform store (StoreKit / Play Billing)
/// for per-skin non-consumable purchases. Skins without a
/// [SkinInfo.productId] are always free; on platforms without an IAP store
/// (macOS/Windows/Linux desktop builds) every skin is unlocked.
///
/// Besides the single skins it sells the "All skins" bundle as a
/// complete-the-set ladder ([kSkinsAllLadder]): owning any step unlocks every
/// paid skin, and the step on offer drops with each paid skin already owned.
///
/// Unlocked skin IDs are cached in SharedPreferences so the selector works
/// offline; the store itself stays the source of truth via Restore Purchases.
class SkinStoreService extends ChangeNotifier {
  SkinStoreService._(this._backend, this._supportedOverride);
  static final SkinStoreService instance =
      SkinStoreService._(const _PlatformStoreBackend(), null);

  /// A service on a fake store, with IAP gating switched on regardless of
  /// the host platform.
  @visibleForTesting
  SkinStoreService.withBackend(SkinStoreBackend backend)
      : this._(backend, true);

  static const _keyUnlocked = 'unlocked_skins';
  static const _keyBundles = 'owned_skin_bundles';

  final SkinStoreBackend _backend;
  final bool? _supportedOverride;

  final Set<String> _unlocked = {}; // skin IDs, not product IDs
  final Set<String> _bundles = {}; // owned "All skins" product IDs, any step
  Map<String, ProductDetails> _products = {}; // productId → store details
  String? _pendingSkinId;
  bool _bundlePending = false;
  String? _justPurchasedSkinId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  /// Tester builds (the Firebase App Distribution APK) unlock every skin:
  /// Play Billing only works for installs from Play, so a sideloaded tester
  /// could never reach a paid skin. Store and GitHub builds leave it false.
  static const testerUnlock = bool.fromEnvironment('TESTER_UNLOCK');

  /// Platforms where skins are actually gated behind IAP.
  bool get supported =>
      _supportedOverride ??
      ((Platform.isIOS || Platform.isAndroid) && !testerUnlock);

  /// Skin with a purchase flow currently in flight (spinner on its card).
  String? get pendingSkinId => _pendingSkinId;

  /// An "All skins" purchase is in flight.
  bool get bundlePending => _bundlePending;

  /// The player owns some step of the "All skins" bundle.
  bool get ownsAllSkins => _bundles.isNotEmpty;

  bool isUnlocked(String skinId) {
    if (!supported) return true;
    if (skinById(skinId)?.productId == null) return true;
    // Any step of the bundle unlocks every paid skin, including ones added
    // to kSkins after it was bought.
    return ownsAllSkins || _unlocked.contains(skinId);
  }

  /// Paid skins bought one by one: the count the bundle ladder credits.
  /// Free skins never count.
  int get ownedPaidSkins => kSkins
      .where((s) => s.productId != null && _unlocked.contains(s.id))
      .length;

  /// The "All skins" step to offer right now, or null when there is nothing
  /// to offer: store unsupported, bundle already owned, or the store did not
  /// return the offered step's product. Recomputed on every read, so a single
  /// skin purchase moves the offer down without a restart.
  SkinsAllOffer? get skinsAllOffer {
    if (!supported || ownsAllSkins) return null;
    final owned = ownedPaidSkins;
    final step = setLadderIndex(owned, kSkinsAllLadder);
    if (step < 0) return null;
    final offered = _products[kSkinsAllLadder[step].productId];
    if (offered == null) return null;
    return SkinsAllOffer(
      productId: offered.id,
      step: step,
      owned: owned,
      price: offered.price,
      // Step 0's price struck through next to a credited step; hidden when
      // the store did not return step 0.
      fullPrice:
          step == 0 ? null : _products[kSkinsAllLadder.first.productId]?.price,
    );
  }

  /// The order both skin grids show (plan 32 Q2): skins the player owns —
  /// free or bought — first, then the locked ones. Within each group the
  /// order is [kSkins] itself, i.e. by release year. Where everything is
  /// unlocked (desktop, tester builds) this is [kSkins] unchanged.
  List<SkinInfo> get orderedSkins => ownedFirst(kSkins, isUnlocked);

  /// Stable split of [skins] into unlocked, then locked.
  static List<SkinInfo> ownedFirst(
          List<SkinInfo> skins, bool Function(String id) unlocked) =>
      [
        for (final s in skins)
          if (unlocked(s.id)) s,
        for (final s in skins)
          if (!unlocked(s.id)) s,
      ];

  /// Localized store price for a locked skin, or null when the product query
  /// failed / hasn't finished — the UI then shows the lock without a price.
  String? priceFor(String skinId) {
    final productId = skinById(skinId)?.productId;
    if (productId == null) return null;
    return _products[productId]?.price;
  }

  /// One-shot read of the skin whose user-initiated purchase just completed,
  /// so the selector can auto-select it. Cleared on read.
  String? takeJustPurchased() {
    final id = _justPurchasedSkinId;
    _justPurchasedSkinId = null;
    return id;
  }

  Future<void> init() async {
    if (!supported) return;

    final prefs = await SharedPreferences.getInstance();
    final bundles = prefs.getString(_keyBundles);
    if (bundles != null) {
      _bundles.addAll((jsonDecode(bundles) as List).cast<String>());
    }
    if (!prefs.containsKey(_keyUnlocked)) {
      // First launch of an IAP-aware version. A pre-existing skin selection
      // means an update over a version that shipped all skins free —
      // grandfather that install rather than lock away what it already had.
      if (prefs.containsKey('selected_skin')) {
        _unlocked.addAll(
            kSkins.where((s) => s.productId != null).map((s) => s.id));
      }
      await _persist(prefs);
    } else {
      final cached = jsonDecode(prefs.getString(_keyUnlocked)!) as List;
      _unlocked.addAll(cached.cast<String>());
    }

    // Subscribe before any store call so resumed/unfinished transactions
    // (iOS delivers them at launch) are not missed.
    _purchaseSub = _backend.purchaseStream.listen(_onPurchaseUpdates);

    try {
      if (!await _backend.isAvailable()) {
        notifyListeners();
        return;
      }
      final ids = {
        for (final s in kSkins)
          if (s.productId != null) s.productId!,
        for (final s in kSkinsAllLadder) s.productId,
      };
      final products = await _backend.queryProducts(ids);
      _products = {for (final p in products) p.id: p};
    } catch (_) {
      // No store / no network — locked skins show without a price and
      // buy() stays a no-op until the next launch.
    }
    notifyListeners();
  }

  Future<void> buy(String skinId) async {
    if (!supported || isUnlocked(skinId) || _busy) return;
    final productId = skinById(skinId)?.productId;
    final details = productId == null ? null : _products[productId];
    if (details == null) return;

    _pendingSkinId = skinId;
    notifyListeners();
    try {
      final launched = await _backend.buyNonConsumable(details);
      if (!launched) {
        _pendingSkinId = null;
        _trackPurchase(skinId, 'error');
        notifyListeners();
      }
    } catch (_) {
      _pendingSkinId = null;
      _trackPurchase(skinId, 'error');
      notifyListeners();
    }
  }

  bool get _busy => _pendingSkinId != null || _bundlePending;

  /// Buy the "All skins" step currently on offer.
  Future<void> buyAllSkins() async {
    final offer = skinsAllOffer;
    if (offer == null || _busy) return;
    final details = _products[offer.productId]!;

    _bundlePending = true;
    notifyListeners();
    try {
      if (!await _backend.buyNonConsumable(details)) {
        _bundlePending = false;
        notifyListeners();
      }
    } catch (_) {
      _bundlePending = false;
      notifyListeners();
    }
  }

  /// Re-deliver past purchases (new device, reinstall). Apple review
  /// requires this to be reachable from the UI.
  Future<void> restore() async {
    if (!supported) return;
    try {
      await _backend.restorePurchases();
    } catch (_) {}
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    var unlockedChanged = false;
    var bundlesChanged = false;
    for (final purchase in purchases) {
      final skin = _skinForProduct(purchase.productID);
      final bundle = isSkinsAllProduct(purchase.productID);
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (skin != null && _unlocked.add(skin.id)) unlockedChanged = true;
          if (bundle) {
            if (_bundles.add(purchase.productID)) bundlesChanged = true;
            _bundlePending = false;
          }
          if (skin != null && skin.id == _pendingSkinId) {
            _justPurchasedSkinId = skin.id;
            _pendingSkinId = null;
            _trackPurchase(skin.id, 'ok');
          }
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          if (bundle) _bundlePending = false;
          if (skin != null && skin.id == _pendingSkinId) {
            _pendingSkinId = null;
            _trackPurchase(skin.id,
                purchase.status == PurchaseStatus.canceled ? 'cancel' : 'error');
          }
          break;
        case PurchaseStatus.pending:
          // Store dialog still up (or deferred parental approval) — keep the
          // spinner; a terminal status follows on the same stream.
          break;
      }
      if (purchase.pendingCompletePurchase) {
        await _backend.completePurchase(purchase);
      }
    }
    if (unlockedChanged) {
      await _persist(await SharedPreferences.getInstance());
    }
    if (bundlesChanged) {
      await (await SharedPreferences.getInstance())
          .setString(_keyBundles, jsonEncode(_bundles.toList()));
    }
    notifyListeners();
  }

  /// The end of a purchase the player started (Prompts/33 §6).
  static void _trackPurchase(String skinId, String result) => TelemetryService
      .instance
      .track('purchase', {'target': skinId, 'result': result});

  SkinInfo? _skinForProduct(String productId) {
    for (final s in kSkins) {
      if (s.productId == productId) return s;
    }
    return null;
  }

  Future<void> _persist(SharedPreferences prefs) =>
      prefs.setString(_keyUnlocked, jsonEncode(_unlocked.toList()));

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }
}

/// The "All skins" step on offer, with prices exactly as the store returned
/// them — nothing here is computed.
class SkinsAllOffer {
  final String productId;

  /// Index into [kSkinsAllLadder]; 0 is the full price.
  final int step;

  /// Paid skins the player owns, i.e. what this step credits.
  final int owned;

  /// Store price of the offered step.
  final String price;

  /// Store price of step 0, to show struck through. Null on step 0 itself
  /// and whenever the store did not return step 0.
  final String? fullPrice;

  const SkinsAllOffer({
    required this.productId,
    required this.step,
    required this.owned,
    required this.price,
    required this.fullPrice,
  });
}

/// The store calls [SkinStoreService] makes — a seam so tests can run the
/// service against a fake store.
abstract class SkinStoreBackend {
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<bool> isAvailable();
  Future<List<ProductDetails>> queryProducts(Set<String> ids);
  Future<bool> buyNonConsumable(ProductDetails product);
  Future<void> restorePurchases();
  Future<void> completePurchase(PurchaseDetails purchase);
}

/// StoreKit / Play Billing through the in_app_purchase plugin.
class _PlatformStoreBackend implements SkinStoreBackend {
  const _PlatformStoreBackend();

  InAppPurchase get _iap => InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> ids) async =>
      (await _iap.queryProductDetails(ids)).productDetails;

  @override
  Future<bool> buyNonConsumable(ProductDetails product) =>
      _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) =>
      _iap.completePurchase(purchase);
}
