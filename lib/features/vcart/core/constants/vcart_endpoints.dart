import 'vcart_constants.dart';

class VCartEndpoints {
  // Base
  static const String baseUrl = VCartConstants.baseUrl;

  // Home
  static const String homeData = 'user/get-home-data';

  // Search
  static const String searchData = 'user/get-search-pageData';
  static const String productData = 'user/get-product';
  static const String filterProductData = 'user/get-filtered-product-count';

  // Product Detail
  static String productDetail(String productId) =>
      'user/get-product-detail?id=$productId';

  // Categories
  static const String sections = 'user/get-section';
  static const String categories = 'user/get-categories';
  static String subCategories(String categoryId) =>
      'user/getSubCategories?categoryId=$categoryId';

  // Cart
  static const String addToCart = 'user/add-to-cart';
  static const String getCart = 'user/get-cart';
  static String cartAction(String action) => 'user/cart-action?action=$action';
  static const String shippingAddress = 'user/get-shipping-address';

  // Wishlist
  static const String wishListAction = 'user/wish-list-action';
  static const String getWishList = 'user/get-wish-list';
  static const String moveToWishListFromCart =
      'user/move-to-wishList-from-cart';

  // Address
  static const String getAddress = 'user/get-shipping-address';
  static const String addAddress = 'user/add-shipping-address';
  static const String updateAddress = 'user/update-shipping-address';
  static const String deleteAddress = 'user/delete-shipping-address';

  // Checkout
  static const String verifyPayment = 'user/razorPay/success';
  static String initiateCheckout(String paymentType) =>
      'user/proceed-to-checkout?paymentType=$paymentType';

  // Filter
  static String filterPageData(String params) =>
      'user/get-filter-page-data?$params';

  // Orders
  static const String orderHistory = 'user/get-order-history';
  static String orderDetails(String orderId) =>
      'user/get-single-order-history/$orderId';
  static String trackingStatus(String orderId) =>
      'user/get-shipping-status?orderId=$orderId';

  // Coupons
  static const String getCoupons = 'user/get-coupons';
  static const String applyCoupon = 'user/apply-coupon';
  static const String removeCoupon = 'user/remove-coupon';

  // Reviews
  static String productReviews(String productId) =>
      'user/get-product-review?id=$productId';
  static const String addReview = 'user/add-review';

  // Profile
  static const String getProfile = 'user/get-profile';
}
