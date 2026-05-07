import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const lifetimeUnlockProductId = 'snorvy_lifetime_unlock';

class UnlockState {
  const UnlockState({
    required this.isUnlocked,
    required this.isPending,
    required this.isStoreAvailable,
    required this.productConfigured,
    required this.priceLabel,
    this.message,
  });

  const UnlockState.initial()
    : isUnlocked = false,
      isPending = false,
      isStoreAvailable = false,
      productConfigured = false,
      priceLabel = '\$9.99',
      message = null;

  final bool isUnlocked;
  final bool isPending;
  final bool isStoreAvailable;
  final bool productConfigured;
  final String priceLabel;
  final String? message;

  UnlockState copyWith({
    bool? isUnlocked,
    bool? isPending,
    bool? isStoreAvailable,
    bool? productConfigured,
    String? priceLabel,
    String? message,
  }) {
    return UnlockState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isPending: isPending ?? this.isPending,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      productConfigured: productConfigured ?? this.productConfigured,
      priceLabel: priceLabel ?? this.priceLabel,
      message: message,
    );
  }
}

abstract interface class UnlockRepository {
  Stream<UnlockState> get updates;
  Future<UnlockState> load();
  Future<void> buyLifetimeUnlock();
  Future<void> restorePurchases();
  Future<void> dispose();
}

class InAppPurchaseUnlockRepository implements UnlockRepository {
  InAppPurchaseUnlockRepository({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  static const _unlockedPrefsKey = 'snorvy_lifetime_unlocked';

  final InAppPurchase _inAppPurchase;
  final StreamController<UnlockState> _updatesController =
      StreamController<UnlockState>.broadcast();

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  ProductDetails? _productDetails;
  UnlockState _state = const UnlockState.initial();

  @override
  Stream<UnlockState> get updates => _updatesController.stream;

  @override
  Future<UnlockState> load() async {
    _purchaseSubscription ??= _inAppPurchase.purchaseStream.listen(
      (purchases) => unawaited(_handlePurchaseUpdates(purchases)),
      onError: (Object error, StackTrace stackTrace) {
        _emit(
          _state.copyWith(
            isPending: false,
            message: 'Purchase service returned an error.',
          ),
        );
      },
    );

    final prefs = await SharedPreferences.getInstance();
    final isUnlocked = prefs.getBool(_unlockedPrefsKey) ?? false;
    final isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      _emit(
        _state.copyWith(
          isUnlocked: isUnlocked,
          isPending: false,
          isStoreAvailable: false,
          productConfigured: false,
          priceLabel: '\$9.99',
          message: isUnlocked ? null : 'Play Store billing is unavailable.',
        ),
      );
      return _state;
    }

    final response = await _inAppPurchase.queryProductDetails({
      lifetimeUnlockProductId,
    });

    _productDetails = response.productDetails.isEmpty
        ? null
        : response.productDetails.first;
    _emit(
      _state.copyWith(
        isUnlocked: isUnlocked,
        isPending: false,
        isStoreAvailable: true,
        productConfigured: _productDetails != null,
        priceLabel: _productDetails?.price ?? '\$9.99',
        message: response.error?.message,
      ),
    );

    return _state;
  }

  @override
  Future<void> buyLifetimeUnlock() async {
    if (_state.isUnlocked) {
      _emit(_state.copyWith(message: 'Lifetime unlock is already active.'));
      return;
    }

    final productDetails = _productDetails;
    if (productDetails == null) {
      _emit(
        _state.copyWith(
          message: 'Lifetime unlock is not configured in Play Console yet.',
        ),
      );
      return;
    }

    _emit(_state.copyWith(isPending: true, message: null));
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> restorePurchases() async {
    _emit(_state.copyWith(isPending: true, message: null));
    await _inAppPurchase.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != lifetimeUnlockProductId) {
        continue;
      }

      if (purchase.status == PurchaseStatus.pending) {
        _emit(_state.copyWith(isPending: true, message: null));
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        _emit(
          _state.copyWith(
            isPending: false,
            message: purchase.error?.message ?? 'Purchase failed.',
          ),
        );
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_unlockedPrefsKey, true);
        _emit(
          _state.copyWith(
            isUnlocked: true,
            isPending: false,
            message: 'Lifetime unlock is active.',
          ),
        );
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  void _emit(UnlockState state) {
    _state = state;
    if (!_updatesController.isClosed) {
      _updatesController.add(state);
    }
  }

  @override
  Future<void> dispose() async {
    await _purchaseSubscription?.cancel();
    await _updatesController.close();
  }
}
