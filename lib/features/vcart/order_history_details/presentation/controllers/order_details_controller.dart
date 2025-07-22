import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/get_order_details.dart';
import '../../domain/usecases/submit_review.dart';

class VCartOrderDetailsController extends GetxController {
  final GetOrderDetails getOrderDetailsUseCase;
  final SubmitReview submitReviewUseCase;

  VCartOrderDetailsController({
    required this.getOrderDetailsUseCase,
    required this.submitReviewUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final _orderDetails = Rxn<OrderDetails>();
  final _isSubmittingReview = false.obs;

  // Review form variables
  final reviewController = TextEditingController();
  final _rating = 0.0.obs;
  final _reviewImages = <String>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  OrderDetails? get orderDetails => _orderDetails.value;
  bool get isSubmittingReview => _isSubmittingReview.value;
  double get rating => _rating.value;
  List<String> get reviewImages => _reviewImages;

  // Computed properties
  OrderDetailsData? get order => orderDetails?.order;
  ShippingAddressDetails? get shippingAddress =>
      orderDetails?.shippingAddress?.shippingAddress;
  bool get canSubmitReview => order?.orderStatus?.toLowerCase() == 'delivered';
  String get orderId => order?.id ?? '';
  String get orderNumber => order?.orderId ?? '';

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  Future<void> loadOrderDetails(String orderId) async {
    _setLoading(true);
    _clearError();

    final result = await getOrderDetailsUseCase(orderId);

    result.fold(
      (failure) => _handleFailure(failure),
      (orderDetails) => _handleSuccess(orderDetails),
    );

    _setLoading(false);
  }

  Future<void> submitOrderReview(BuildContext context) async {
    if (!_isValidReview()) {
      context.showVCartSnackBar(
        'Please provide a rating and review',
        isError: true,
      );
      return;
    }

    _setSubmittingReview(true);

    final review = OrderReview(
      orderId: orderId,
      rating: _rating.value,
      review: reviewController.text,
      images: _reviewImages,
    );

    final result = await submitReviewUseCase(review);

    result.fold(
      (failure) {
        context.showVCartSnackBar(failure.message, isError: true);
      },
      (success) {
        if (success) {
          context.showVCartSnackBar('Review submitted successfully!');
          _clearReviewForm();
        } else {
          context.showVCartSnackBar('Failed to submit review', isError: true);
        }
      },
    );

    _setSubmittingReview(false);
  }

  void setRating(double newRating) {
    _rating.value = newRating;
  }

  void addReviewImage(String imageUrl) {
    if (!_reviewImages.contains(imageUrl)) {
      _reviewImages.add(imageUrl);
    }
  }

  void removeReviewImage(int index) {
    if (index >= 0 && index < _reviewImages.length) {
      _reviewImages.removeAt(index);
    }
  }

  void _clearReviewForm() {
    reviewController.clear();
    _rating.value = 0.0;
    _reviewImages.clear();
  }

  bool _isValidReview() {
    return _rating.value > 0 && reviewController.text.trim().isNotEmpty;
  }

  Color getStatusColor(String? status) {
    if (status == null) return VCartColors.textSecondary;

    switch (status.toLowerCase()) {
      case 'delivered':
        return VCartColors.success;
      case 'cancelled':
      case 'returned':
        return VCartColors.error;
      case 'shipped':
      case 'packed':
      case 'out for delivery':
        return VCartColors.warning;
      case 'order placed':
      default:
        return VCartColors.textPrimary;
    }
  }

  String getStatusDisplayName(String? status) {
    if (status == null) return 'Unknown';

    switch (status.toLowerCase()) {
      case 'order placed':
        return 'Order Placed';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'shipped':
        return 'Shipped';
      case 'packed':
        return 'Packed';
      case 'returned':
        return 'Returned';
      case 'out for delivery':
        return 'Out for Delivery';
      default:
        return status;
    }
  }

  void _handleSuccess(OrderDetails orderDetails) {
    _orderDetails.value = orderDetails;
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setSubmittingReview(bool value) {
    _isSubmittingReview.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _hasError.value = true;
    _errorMessage.value = failure.message;
    debugPrint('Order Details Error: ${failure.message}');
  }
}
