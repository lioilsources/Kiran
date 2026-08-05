import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'skin_registry.dart';

/// The one place that talks to the platform store (StoreKit / Play Billing)
/// for per-skin non-consumable purchases. Skins without a
/// [SkinInfo.productId] are always free; on platforms without an IAP store
/// (macOS/Windows/Linux desktop builds) every skin is unlocked.
///
/// Unlocked skin IDs are cached in SharedPreferences so the selector works
/// offline; the store itself stays the source of truth via Restore Purchases.
class SkinStoreService extends ChangeNotifier {
  SkinStoreService._();
  static final SkinStoreService instance = SkinStoreService._();

  static const _keyUnlocked = 'unlocked_skins';

  final Set<String> _unlocked = {}; // skin IDs, not product IDs
  Map<String, ProductDetails> _products = {}; // productId → store details
  String? _pendingSkinId;
  String? _justPurchasedSkinId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  /// Platforms where skins are actually gated behind IAP.
  bool get supported => Platform.isIOS || Platform.isAndroid;

  /// Skin with a purchase flow currently in flight (spinner on its card).
  String? get pendingSkinId => _pendingSkinId;

  bool isUnlocked(String skinId) {
    if (!supported) return true;
    if (skinById(skinId)?.productId == null) return true;
    return _unlocked.contains(skinId);
  }

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
    _purchaseSub =
        InAppPurchase.instance.purchaseStream.listen(_onPurchaseUpdates);

    try {
      if (!await InAppPurchase.instance.isAvailable()) {
        notifyListeners();
        return;
      }
      final ids = kSkins
          .where((s) => s.productId != null)
          .map((s) => s.productId!)
          .toSet();
      final response = await InAppPurchase.instance.queryProductDetails(ids);
      _products = {for (final p in response.productDetails) p.id: p};
    } catch (_) {
      // No store / no network — locked skins show without a price and
      // buy() stays a no-op until the next launch.
    }
    notifyListeners();
  }

  Future<void> buy(String skinId) async {
    if (!supported || isUnlocked(skinId) || _pendingSkinId != null) return;
    final productId = skinById(skinId)?.productId;
    final details = productId == null ? null : _products[productId];
    if (details == null) return;

    _pendingSkinId = skinId;
    notifyListeners();
    try {
      final launched = await InAppPurchase.instance.buyNonConsumable(
          purchaseParam: PurchaseParam(productDetails: details));
      if (!launched) {
        _pendingSkinId = null;
        notifyListeners();
      }
    } catch (_) {
      _pendingSkinId = null;
      notifyListeners();
    }
  }

  /// Re-deliver past purchases (new device, reinstall). Apple review
  /// requires this to be reachable from the UI.
  Future<void> restore() async {
    if (!supported) return;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (_) {}
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    var unlockedChanged = false;
    for (final purchase in purchases) {
      final skin = _skinForProduct(purchase.productID);
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (skin != null && _unlocked.add(skin.id)) unlockedChanged = true;
          if (skin != null && skin.id == _pendingSkinId) {
            _justPurchasedSkinId = skin.id;
            _pendingSkinId = null;
          }
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          if (skin != null && skin.id == _pendingSkinId) _pendingSkinId = null;
          break;
        case PurchaseStatus.pending:
          // Store dialog still up (or deferred parental approval) — keep the
          // spinner; a terminal status follows on the same stream.
          break;
      }
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
    if (unlockedChanged) {
      _persist(await SharedPreferences.getInstance());
    }
    notifyListeners();
  }

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
