import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/get_wishlist_data.dart';
import '../../domain/usecases/toggle_wishlist_item.dart';

class VCartWishlistController extends GetxController {
  final GetWishlistData getWishlistDataUseCase;
  final ToggleWishlistItem toggleWishlistItemUseCase;

  VCartWishlistController({
    required this.getWishlistDataUseCase,
    required this.toggleWishlistItemUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _wishlistItems = <WishlistItem>[].obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Pagination variables
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _itemsPerPage = 10;
  final _isPageDataEmpty = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<WishlistItem> get wishlistItems => _wishlistItems;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasMoreData => _hasMoreData.value;
  bool get isPageDataEmpty => _isPageDataEmpty.value;

  @override
  void onInit() {
    super.onInit();
    getWishlistData();
  }

  Future<void> getWishlistData({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage.value = 1;
        _wishlistItems.clear();
        _hasMoreData.value = true;
        _isPageDataEmpty.value = false;
      }

      if (!_hasMoreData.value) return;

      _setLoading(true);
      _clearError();

      final result = await getWishlistDataUseCase(
        GetWishlistParams(
          page: _currentPage.value,
          limit: _itemsPerPage,
          isLoadMore: isLoadMore,
        ),
      );

      result.fold((failure) => _handleFailure(failure), (data) {
        if (data.wishlistItems.isEmpty) {
          _isPageDataEmpty.value = true;
          _hasMoreData.value = false;
        } else {
          _wishlistItems.addAll(data.wishlistItems);
          _isPageDataEmpty.value = false;

          final totalPages = data.totalPages;
          _hasMoreData.value = _currentPage.value < totalPages;
          if (_hasMoreData.value) {
            _currentPage.value++;
          }
        }

        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> removeFromWishlist(
    BuildContext context,
    String productId,
    int index,
  ) async {
    try {
      final result = await toggleWishlistItemUseCase(
        ToggleWishlistParams(productId: productId),
      );

      result.fold(
        (failure) {
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (success) {
          if (success) {
            _wishlistItems.removeAt(index);
            context.showVCartSnackBar('Removed from wishlist');
          }
        },
      );
    } catch (e) {
      context.showVCartSnackBar(
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  void clearAllVariables() {
    _wishlistItems.clear();
    _isLoading.value = false;
    _hasMoreData.value = true;
    _currentPage.value = 1;
    _isPageDataEmpty.value = false;
    _clearError();
  }

  Future<void> refreshData() async {
    clearAllVariables();
    await getWishlistData();
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
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

  @override
  void onClose() {
    _wishlistItems.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    _hasMoreData.close();
    _currentPage.close();
    _isPageDataEmpty.close();
    super.onClose();
  }
}
