import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_overview_data.dart';
import '../../domain/entities/product_size.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/get_product_detail.dart';
import '../../domain/usecases/get_product_reviews.dart';
import '../../domain/usecases/toggle_wishlist.dart';

class VCartProductOverviewController extends GetxController {
  final GetProductDetail getProductDetailUseCase;
  final GetProductReviews getProductReviewsUseCase;
  final AddToCart addToCartUseCase;
  final ToggleWishlist toggleWishlistUseCase;

  VCartProductOverviewController({
    required this.getProductDetailUseCase,
    required this.getProductReviewsUseCase,
    required this.addToCartUseCase,
    required this.toggleWishlistUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _isReviewLoading = false.obs;
  final _isAddingToCart = false.obs;
  final _isToggling = false.obs;
  final _productOverviewData = Rxn<ProductOverviewData>();
  final _selectedSize = Rxn<ProductSize>();
  final _reviews = <Review>[].obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Review pagination variables
  final _hasMoreReviews = true.obs;
  final _currentReviewPage = 1.obs;
  final _itemsPerPage = 10;
  final _isReviewsEmpty = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isReviewLoading => _isReviewLoading.value;
  bool get isAddingToCart => _isAddingToCart.value;
  bool get isToggling => _isToggling.value;
  ProductOverviewData? get productOverviewData => _productOverviewData.value;
  ProductDetail? get productDetail => productOverviewData?.productDetail;
  ProductSize? get selectedSize => _selectedSize.value;
  List<Review> get reviews => _reviews;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasMoreReviews => _hasMoreReviews.value;
  bool get isReviewsEmpty => _isReviewsEmpty.value;
  bool get isAddedWishList => productOverviewData?.isAddedWishList ?? false;

  // Computed properties
  String get productId => productDetail?.id ?? '';
  List<String> get productImages => productDetail?.images ?? [];
  String get productName => productDetail?.name ?? '';
  String get productDescription => productDetail?.description ?? '';
  double get productPrice => selectedSize?.price ?? 0.0;
  double get productOfferPrice => selectedSize?.offerPrice ?? 0.0;
  double get commission => productDetail?.commission ?? 0.0;
  double get finalPrice => productPrice + commission;
  double get finalOfferPrice => productOfferPrice + commission;
  bool get hasDiscount => productOfferPrice < productPrice;
  double get discountPercentage => selectedSize?.offerPercentage ?? 0.0;
  List<ProductSize> get productSizes => productDetail?.sizes ?? [];
  bool get hasVariants => productDetail?.hasVariants ?? false;
  bool get hasSizes => productDetail?.hasSizes ?? false;

  Future<void> initialize(String productId) async {
    await Future.wait([
      getProductDetail(productId),
      getProductReviews(productId),
    ]);
  }

  Future<void> getProductDetail(String productId) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await getProductDetailUseCase(
        GetProductDetailParams(productId: productId),
      );

      result.fold((failure) => _handleFailure(failure), (data) {
        _productOverviewData.value = data;

        // Auto-select first size if available
        if (data.productDetail.sizes.isNotEmpty) {
          _selectedSize.value = data.productDetail.sizes.first;
        }

        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> getProductReviews(
    String productId, {
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        _currentReviewPage.value = 1;
        _reviews.clear();
        _hasMoreReviews.value = true;
        _isReviewsEmpty.value = false;
      }

      if (!_hasMoreReviews.value) return;

      _setReviewLoading(true);

      final result = await getProductReviewsUseCase(
        GetProductReviewsParams(
          productId: productId,
          page: _currentReviewPage.value,
          limit: _itemsPerPage,
        ),
      );

      result.fold((failure) => _handleReviewFailure(failure), (newReviews) {
        if (newReviews.isEmpty) {
          _isReviewsEmpty.value = true;
          _hasMoreReviews.value = false;
        } else {
          _reviews.addAll(newReviews);
          _isReviewsEmpty.value = false;

          if (newReviews.length < _itemsPerPage) {
            _hasMoreReviews.value = false;
          } else {
            _currentReviewPage.value++;
          }
        }

        _setReviewLoading(false);
      });
    } catch (e) {
      _handleReviewError('Failed to load reviews: $e');
    }
  }

  Future<void> addToCart(BuildContext context) async {
    if (selectedSize == null) {
      context.showVCartSnackBar('Please select a size', isError: true);
      return;
    }

    try {
      _isAddingToCart.value = true;

      final result = await addToCartUseCase(
        AddToCartParams(productId: productId, sizeId: selectedSize!.id),
      );

      result.fold(
        (failure) {
          _isAddingToCart.value = false;
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (success) {
          _isAddingToCart.value = false;
          if (success) {
            // Update the selected size cart status
            _selectedSize.value = selectedSize!.copyWith(
              isAddedCart: !selectedSize!.isAddedCart,
            );

            // Update the product detail sizes list
            final updatedSizes =
                productDetail?.sizes.map((size) {
                  if (size.id == selectedSize!.id) {
                    return size.copyWith(isAddedCart: !size.isAddedCart);
                  }
                  return size;
                }).toList() ??
                [];

            // Update the product overview data
            if (productOverviewData != null && productDetail != null) {
              final updatedProductDetail = ProductDetail(
                id: productDetail!.id,
                name: productDetail!.name,
                description: productDetail!.description,
                images: productDetail!.images,
                price: productDetail!.price,
                offerPrice: productDetail!.offerPrice,
                commission: productDetail!.commission,
                offerPercentage: productDetail!.offerPercentage,
                specifications: productDetail!.specifications,
                returnPolicy: productDetail!.returnPolicy,
                brand: productDetail!.brand,
                isReturn: productDetail!.isReturn,
                returnDuration: productDetail!.returnDuration,
                sizes: updatedSizes,
                variants: productDetail!.variants,
                rating: productDetail!.rating,
                reviewCount: productDetail!.reviewCount,
              );

              _productOverviewData.value = ProductOverviewData(
                success: productOverviewData!.success,
                message: productOverviewData!.message,
                productDetail: updatedProductDetail,
                isAddedWishList: productOverviewData!.isAddedWishList,
                reviews: productOverviewData!.reviews,
                averageRating: productOverviewData!.averageRating,
                totalReviews: productOverviewData!.totalReviews,
              );
            }

            context.showVCartSnackBar(
              selectedSize!.isAddedCart ? 'Added to cart' : 'Removed from cart',
            );
          }
        },
      );
    } catch (e) {
      _isAddingToCart.value = false;
      context.showVCartSnackBar(
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  Future<void> toggleWishlist(BuildContext context) async {
    try {
      // Optimistically update UI first
      final currentWishlistState = isAddedWishList;
      _updateWishlistState(!currentWishlistState);

      _isToggling.value = true;

      final result = await toggleWishlistUseCase(
        ToggleWishlistParams(productId: productId),
      );

      result.fold(
        (failure) {
          // Revert the optimistic update on failure
          _updateWishlistState(currentWishlistState);
          _isToggling.value = false;
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (success) {
          _isToggling.value = false;
          if (success) {
            context.showVCartSnackBar(
              !currentWishlistState
                  ? 'Added to wishlist'
                  : 'Removed from wishlist',
            );
          } else {
            // Revert if the operation wasn't successful
            _updateWishlistState(currentWishlistState);
          }
        },
      );
    } catch (e) {
      _isToggling.value = false;
      context.showVCartSnackBar(
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  void _updateWishlistState(bool isWishlisted) {
    if (productOverviewData != null) {
      final updatedData = ProductOverviewData(
        success: productOverviewData!.success,
        message: productOverviewData!.message,
        productDetail: productOverviewData!.productDetail,
        isAddedWishList: isWishlisted,
        reviews: productOverviewData!.reviews,
        averageRating: productOverviewData!.averageRating,
        totalReviews: productOverviewData!.totalReviews,
      );

      _productOverviewData.value = updatedData;
    }
  }

  void selectSize(ProductSize size) {
    _selectedSize.value = size;
  }

  void clearReviewVariables() {
    _reviews.clear();
    _isReviewLoading.value = false;
    _hasMoreReviews.value = true;
    _currentReviewPage.value = 1;
    _isReviewsEmpty.value = false;
  }

  Future<void> refreshData(String productId) async {
    clearReviewVariables();
    await initialize(productId);
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setReviewLoading(bool value) {
    _isReviewLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleReviewFailure(Failure failure) {
    _setReviewLoading(false);
    _handleReviewError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }

  void _handleReviewError(String message) {
    _setReviewLoading(false);
  }
}
