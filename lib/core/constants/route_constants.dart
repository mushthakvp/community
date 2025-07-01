class RouteConstants {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main Routes
  static const String home = '/home';
  static const String profile = '/profile';

  // Feature Routes
  static const String coupons = '/coupons';
  static const String promos = '/promos';
  static const String redemption = '/redemption';
  static const String walletRecharge = '/redemption/recharge';

  // Vizzle Routes
  static const String vizzleHome = '/vizzle';
  static const String vizzleSearch = '/vizzle/search';
  static const String vizzleCategory = '/vizzle/category';
  static const String vizzleSubCategory = '/vizzle/subcategory';
  static const String vizzleSubSubCategory = '/vizzle/sub-subcategory';
  static const String vizzleSubItems = '/vizzle/sub-items';
  static const String vizzleProductDetails = '/vizzle/product';
  static const String vizzleAdsListing = '/vizzle/ads';
  static const String vizzleFavorites = '/vizzle/favorites';
  static const String vizzleRecentlyViewed = '/vizzle/recently-viewed';

  // Seller Details Routes
  static const String vizzleSellerDetails = '/vizzle/seller';
  static const String vizzleSellerProfile = '/vizzle/seller/profile';
  static const String vizzleSellerAds = '/vizzle/seller/ads';
  static const String vizzleSellerReviews = '/vizzle/seller/reviews';

  // Search Routes
  static const String vizzleSearchPage = '/vizzle/search';
  static const String vizzleAdvancedSearch = '/vizzle/search/advanced';
  static const String vizzleSearchFilters = '/vizzle/search/filters';
  static const String vizzleSearchHistory = '/vizzle/search/history';
  static const String vizzleSearchSuggestions = '/vizzle/search/suggestions';

  // Profile Routes
  static const String editProfile = '/profile/edit';
  static const String loyaltyPoints = '/profile/loyalty-points';
  static const String changePassword = '/profile/change-password';
  static const String helpSupport = '/profile/help-support';
  static const String contactUs = '/profile/contact-us';
  static const String settings = '/profile/settings';
  static const String notifications = '/profile/notifications';
  static const String privacy = '/profile/privacy';
  static const String termsConditions = '/profile/terms-conditions';
  static const String aboutApp = '/profile/about';

  /// Generate seller details route with seller ID
  static String sellerDetailsWithId(String sellerId) =>
      '$vizzleSellerDetails/$sellerId';

  /// Generate seller profile route with seller ID
  static String sellerProfileWithId(String sellerId) =>
      '$vizzleSellerProfile/$sellerId';

  /// Generate seller ads route with seller ID
  static String sellerAdsWithId(String sellerId) =>
      '$vizzleSellerAds/$sellerId';

  /// Generate seller reviews route with seller ID
  static String sellerReviewsWithId(String sellerId) =>
      '$vizzleSellerReviews/$sellerId';

  /// Generate product details route with product ID
  static String productDetailsWithId(String productId) =>
      '$vizzleProductDetails/$productId';

  /// Generate category route with category name
  static String categoryWithName(String categoryName) =>
      '$vizzleCategory/$categoryName';

  /// Generate subcategory route with parameters
  static String subCategoryWithParams({
    required String categoryName,
    required String subCategoryId,
    String? subCategoryName,
    String? categoryId,
  }) {
    String route = '$vizzleSubCategory/$categoryName/$subCategoryId';
    List<String> params = [];

    if (subCategoryName != null) {
      params.add('subCategoryName=${Uri.encodeComponent(subCategoryName)}');
    }
    if (categoryId != null) {
      params.add('categoryId=$categoryId');
    }

    return params.isNotEmpty ? '$route?${params.join('&')}' : route;
  }

  /// Generate search route with query parameters
  static String searchWithQuery({
    String? keyword,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) {
    List<String> params = [];

    if (keyword != null && keyword.isNotEmpty) {
      params.add('q=${Uri.encodeComponent(keyword)}');
    }
    if (categoryId != null) params.add('categoryId=$categoryId');
    if (location != null) {
      params.add('location=${Uri.encodeComponent(location)}');
    }
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');

    return params.isNotEmpty
        ? '$vizzleSearchPage?${params.join('&')}'
        : vizzleSearchPage;
  }

  /// Check if route is a Vizzle route
  static bool isVizzleRoute(String route) {
    return route.startsWith('/vizzle');
  }

  /// Check if route is an auth route
  static bool isAuthRoute(String route) {
    const authRoutes = [
      login,
      register,
      otpVerification,
      forgotPassword,
      resetPassword,
    ];
    return authRoutes.any((authRoute) => route.startsWith(authRoute));
  }

  /// Check if route is a protected route (requires authentication)
  static bool isProtectedRoute(String route) {
    const protectedRoutes = [
      home,
      profile,
      coupons,
      promos,
      redemption,
      walletRecharge,
      vizzleHome,
      vizzleSellerDetails,
      vizzleSearchPage,
    ];
    return protectedRoutes.any(
      (protectedRoute) => route.startsWith(protectedRoute),
    );
  }

  /// Check if route is a seller-related route
  static bool isSellerRoute(String route) {
    return route.startsWith(vizzleSellerDetails) ||
        route.startsWith(vizzleSellerProfile) ||
        route.startsWith(vizzleSellerAds) ||
        route.startsWith(vizzleSellerReviews);
  }

  /// Check if route is a search-related route
  static bool isSearchRoute(String route) {
    return route.startsWith(vizzleSearchPage) ||
        route.startsWith(vizzleAdvancedSearch) ||
        route.startsWith(vizzleSearchFilters) ||
        route.startsWith(vizzleSearchHistory);
  }

  /// Get all main navigation routes
  static List<String> get mainNavigationRoutes => [
    home,
    promos,
    redemption,
    profile,
    vizzleHome,
  ];

  /// Get all auth routes
  static List<String> get authRoutes => [
    login,
    register,
    otpVerification,
    forgotPassword,
    resetPassword,
  ];

  /// Get all Vizzle feature routes
  static List<String> get vizzleRoutes => [
    vizzleHome,
    vizzleSearchPage,
    vizzleSellerDetails,
    vizzleCategory,
    vizzleSubCategory,
    vizzleProductDetails,
    vizzleAdsListing,
    vizzleFavorites,
    vizzleRecentlyViewed,
  ];

  /// Get all profile-related routes
  static List<String> get profileRoutes => [
    profile,
    editProfile,
    loyaltyPoints,
    changePassword,
    helpSupport,
    contactUs,
    settings,
    notifications,
    privacy,
    termsConditions,
    aboutApp,
  ];

  /// Generate deep link for seller profile
  static String generateSellerDeepLink(String sellerId) {
    return 'community://seller/$sellerId';
  }

  /// Generate deep link for product
  static String generateProductDeepLink(String productId) {
    return 'community://product/$productId';
  }

  /// Generate deep link for search with query
  static String generateSearchDeepLink(String query) {
    return 'community://search?q=${Uri.encodeComponent(query)}';
  }

  /// Parse deep link and return route
  static String parseDeepLink(String deepLink) {
    final uri = Uri.parse(deepLink);

    switch (uri.host) {
      case 'seller':
        return sellerDetailsWithId(uri.pathSegments.first);
      case 'product':
        return productDetailsWithId(uri.pathSegments.first);
      case 'search':
        final query = uri.queryParameters['q'] ?? '';
        return searchWithQuery(keyword: query);
      default:
        return home;
    }
  }

  /// Get route category for analytics
  static String getRouteCategory(String route) {
    if (isAuthRoute(route)) return 'auth';
    if (isVizzleRoute(route)) return 'vizzle';
    if (isSellerRoute(route)) return 'seller';
    if (isSearchRoute(route)) return 'search';
    if (profileRoutes.contains(route)) return 'profile';
    return 'main';
  }

  /// Get readable route name for analytics
  static String getRouteName(String route) {
    return route.split('/').last.replaceAll('-', '_');
  }
}
