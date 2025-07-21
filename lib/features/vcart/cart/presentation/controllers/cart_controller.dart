import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/cart_data.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/get_cart_data.dart';
import '../../domain/usecases/manage_coupon.dart';
import '../../domain/usecases/move_to_wishlist.dart';
import '../../domain/usecases/update_cart_item.dart';

class VCartCartController extends GetxController {
  final GetCartData getCartDataUseCase;
  final UpdateCartItem updateCartItemUseCase;
  final MoveToWishlist moveToWishlistUseCase;
  final ApplyCoupon applyCouponUseCase;
  final RemoveCoupon removeCouponUseCase;

  VCartCartController({
    required this.getCartDataUseCase,
    required this.updateCartItemUseCase,
    required this.moveToWishlistUseCase,
    required this.applyCouponUseCase,
    required this.removeCouponUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _isUpdating = false.obs;
  final _cartData = Rxn<CartData>();
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isUpdating => _isUpdating.value;
  CartData? get cartData => _cartData.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;

  // Computed properties
  List<CartItem> get cartItems => cartData?.items ?? [];
  bool get isEmpty => cartData?.isEmpty ?? true;
  bool get isNotEmpty => cartData?.isNotEmpty ?? false;
  bool get hasCoupon => cartData?.hasCoupon ?? false;
  int get totalItems => cartData?.totalItems ?? 0;
  double get subTotal => cartData?.finalSubTotal ?? 0.0;
  double get shippingCharge => cartData?.shippingCharge ?? 0.0;
  double get tax => cartData?.tax ?? 0.0;
  double get discount => cartData?.discount ?? 0.0;
  double get couponDiscount => cartData?.couponDiscount ?? 0.0;
  double get total => cartData?.finalTotal ?? 0.0;
  double get totalSavings => cartData?.totalSavings ?? 0.0;
  double get walletAmount => cartData?.walletAmount ?? 0.0;

  @override
  void onInit() {
    super.onInit();
    loadCartData();
  }

  @override
  void onReady() {
    super.onReady();
    loadCartData();
  }

  void onPageFocus() {
    loadCartData();
  }

  Future<void> loadCartData() async {
    try {
      _setLoading(true);
      _clearError();

      final result = await getCartDataUseCase(NoParams());
      result.fold((failure) => _handleFailure(failure), (data) {
        _cartData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> refreshCartData() async {
    await loadCartData();
  }

  Future<void> incrementQuantity(CartItem item, BuildContext context) async {
    await _updateItemQuantity(item, 'increment', context);
  }

  Future<void> decrementQuantity(CartItem item, BuildContext context) async {
    if (item.quantity <= 1) {
      await removeItem(item, context);
    } else {
      await _updateItemQuantity(item, 'decrement', context);
    }
  }

  Future<void> removeItem(CartItem item, BuildContext context) async {
    await _updateItemQuantity(item, 'decrement', context);
  }

  Future<void> _updateItemQuantity(
    CartItem item,
    String action,
    BuildContext context,
  ) async {
    try {
      _setUpdating(true);
      _updateCartItemOptimistically(item, action);
      final result = await updateCartItemUseCase(
        UpdateCartItemParams(
          productId: item.productId,
          sizeId: item.sizeId,
          action: action,
        ),
      );

      result.fold(
        (failure) async {
          await loadCartData();
          _setUpdating(false);
        },
        (updatedCartData) {
          _cartData.value = updatedCartData;
          _setUpdating(false);
        },
      );
    } catch (e) {
      _setUpdating(false);
      await loadCartData();
    }
  }

  void _updateCartItemOptimistically(CartItem item, String action) {
    if (cartData == null) return;

    final updatedItems = cartData!.items
        .map((cartItem) {
          if (cartItem.productId == item.productId &&
              cartItem.sizeId == item.sizeId) {
            switch (action) {
              case 'increment':
                return cartItem.copyWith(quantity: cartItem.quantity + 1);
              case 'decrement':
                return cartItem.copyWith(quantity: cartItem.quantity - 1);
              default:
                return cartItem;
            }
          }
          return cartItem;
        })
        .where((item) => item.quantity > 0)
        .cast<CartItem>()
        .toList();

    // Create updated cart data with new items list
    final updatedCartData = CartData(
      success: cartData!.success,
      message: cartData!.message,
      items: updatedItems,
      subTotal: cartData!.subTotal,
      offerPrice: cartData!.offerPrice,
      commission: cartData!.commission,
      shippingCharge: cartData!.shippingCharge,
      tax: cartData!.tax,
      discount: cartData!.discount,
      couponDiscount: cartData!.couponDiscount,
      total: cartData!.total,
      walletAmount: cartData!.walletAmount,
      couponData: cartData!.couponData,
    );

    _cartData.value = updatedCartData;
  }

  Future<void> moveItemToWishlist(CartItem item, BuildContext context) async {
    try {
      _setUpdating(true);

      final result = await moveToWishlistUseCase(
        MoveToWishlistParams(productId: item.productId),
      );

      result.fold(
        (failure) {
          _setUpdating(false);
        },
        (success) {
          _setUpdating(false);
          if (success) {
            loadCartData();
          }
        },
      );
    } catch (e) {
      _setUpdating(false);
    }
  }

  Future<void> applyCouponWithId(String couponId, BuildContext context) async {
    try {
      _setUpdating(true);
      final result = await applyCouponUseCase(
        ApplyCouponParams(couponId: couponId),
      );
      result.fold(
        (failure) {
          _setUpdating(false);
        },
        (updatedCartData) {
          _cartData.value = updatedCartData;
          _setUpdating(false);
        },
      );
    } catch (e) {
      _setUpdating(false);
    }
  }

  Future<void> removeCouponFromCart(BuildContext context) async {
    try {
      _setUpdating(true);
      final result = await removeCouponUseCase(NoParams());
      result.fold(
        (failure) {
          _setUpdating(false);
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (updatedCartData) {
          _cartData.value = updatedCartData;
          _setUpdating(false);
          context.showVCartSnackBar('Coupon removed successfully');
        },
      );
    } catch (e) {
      _setUpdating(false);
      context.showVCartSnackBar(
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setUpdating(bool value) {
    _isUpdating.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }
}
