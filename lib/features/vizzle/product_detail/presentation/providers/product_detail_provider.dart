import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/result.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/usecases/access_chat_usecase.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/report_product_usecase.dart';
import '../../domain/usecases/share_product_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

class ProductDetailProvider extends ChangeNotifier {
  final GetProductDetailUseCase getProductDetailUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final ShareProductUseCase shareProductUseCase;
  final ReportProductUseCase reportProductUseCase;
  final AccessChatUseCase accessChatUseCase;

  ProductDetailProvider({
    required this.getProductDetailUseCase,
    required this.toggleFavoriteUseCase,
    required this.shareProductUseCase,
    required this.reportProductUseCase,
    required this.accessChatUseCase,
  });

  // State
  Result<ProductDetail>? _productDetailResult;
  bool _isLoading = false;
  bool _isFavoriteLoading = false;
  bool _isShareLoading = false;
  bool _isReportLoading = false;
  int _currentImageIndex = 0;

  // Getters
  Result<ProductDetail>? get productDetailResult => _productDetailResult;
  ProductDetail? get productDetail => _productDetailResult?.data;
  bool get isLoading => _isLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  bool get isShareLoading => _isShareLoading;
  bool get isReportLoading => _isReportLoading;
  int get currentImageIndex => _currentImageIndex;

  // Methods
  Future<void> getProductDetail(String shareUrl) async {
    _isLoading = true;
    notifyListeners();

    final result = await getProductDetailUseCase(shareUrl);

    result.fold(
      (failure) => _productDetailResult = Error(message: failure.message),
      (product) => _productDetailResult = Success(product),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final product = productDetail;
    if (product == null) return;

    _isFavoriteLoading = true;
    notifyListeners();

    final result = await toggleFavoriteUseCase(product.id);

    result.fold(
      (failure) {
        // Handle error - could show snackbar
      },
      (success) {
        // Update local state
        _updateProductFavoriteStatus(!product.isSaved);
      },
    );

    _isFavoriteLoading = false;
    notifyListeners();
  }

  Future<void> shareProduct() async {
    final product = productDetail;
    if (product == null) return;

    _isShareLoading = true;
    notifyListeners();

    final result = await shareProductUseCase(product.id);

    result.fold(
      (failure) {
        // Handle error
      },
      (shareLink) {
        Share.share(shareLink, subject: 'Check out this product!');
      },
    );

    _isShareLoading = false;
    notifyListeners();
  }

  Future<void> reportProduct(String reason) async {
    final product = productDetail;
    if (product == null) return;

    _isReportLoading = true;
    notifyListeners();

    final params = ReportProductParams(productId: product.id, reason: reason);
    final result = await reportProductUseCase(params);

    result.fold(
      (failure) {
        // Handle error
      },
      (success) {
        // Handle success
      },
    );

    _isReportLoading = false;
    notifyListeners();
  }

  Future<String?> accessChat() async {
    final product = productDetail;
    if (product == null) return null;

    final params = AccessChatParams(
      friendId: product.user.id,
      postId: product.id,
    );
    final result = await accessChatUseCase(params);

    return result.fold((failure) => null, (chatId) => chatId);
  }

  Future<void> launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> launchWhatsApp(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  void updateImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }

  void _updateProductFavoriteStatus(bool isSaved) {
    if (_productDetailResult?.data != null) {
      final currentProduct = _productDetailResult!.data!;
      final updatedProduct = ProductDetail(
        id: currentProduct.id,
        title: currentProduct.title,
        description: currentProduct.description,
        price: currentProduct.price,
        currencyCode: currentProduct.currencyCode,
        images: currentProduct.images,
        user: currentProduct.user,
        category: currentProduct.category,
        subCategory: currentProduct.subCategory,
        address: currentProduct.address,
        latitude: currentProduct.latitude,
        longitude: currentProduct.longitude,
        phone: currentProduct.phone,
        age: currentProduct.age,
        usage: currentProduct.usage,
        condition: currentProduct.condition,
        sellerType: currentProduct.sellerType,
        brand: currentProduct.brand,
        model: currentProduct.model,
        color: currentProduct.color,
        shareLink: currentProduct.shareLink,
        createdAt: currentProduct.createdAt,
        isSaved: isSaved,
        isCurrentUser: currentProduct.isCurrentUser,
        relatedProducts: currentProduct.relatedProducts,
      );
      _productDetailResult = Success(updatedProduct);
    }
  }

  String calculateTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void clearData() {
    _productDetailResult = null;
    _isLoading = false;
    _isFavoriteLoading = false;
    _isShareLoading = false;
    _isReportLoading = false;
    _currentImageIndex = 0;
    notifyListeners();
  }
}
