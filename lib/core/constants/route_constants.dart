class RouteConstants {
  // ==================== AUTH ROUTES ====================
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ==================== MAIN APP ROUTES ====================
  static const String home = '/home';
  static const String profile = '/profile';
  static const String promos = '/promos';
  static const String redemption = '/redemption';

  // ==================== FEATURE ROUTES ====================
  static const String coupons = '/coupons';
  static const String walletRecharge = '/redemption/recharge';
  static const String notifications = '/notifications';

  // ==================== VIZZLE MARKETPLACE ROUTES ====================

  // Vizzle Home & Core
  static const String vizzleHome = '/vizzle';
  static const String vizzleMarketplace = '/vizzle/marketplace';

  // Search Routes
  static const String vizzleSearch = '/vizzle/search';
  static const String vizzleSearchPage = '/vizzle/search';
  static const String vizzleAdvancedSearch = '/vizzle/search/advanced';
  static const String vizzleSearchFilters = '/vizzle/search/filters';
  static const String vizzleSearchHistory = '/vizzle/search/history';
  static const String vizzleSearchSuggestions = '/vizzle/search/suggestions';

  // Category Navigation Routes
  static const String vizzleCategory = '/vizzle/category';
  static const String vizzleSubCategory = '/vizzle/subcategory';
  static const String vizzleSubSubCategory = '/vizzle/sub-subcategory';
  static const String vizzleSubItems = '/vizzle/sub-items';

  // Product & Ads Routes
  static const String vizzleAdsListing = '/vizzle/ads';
  static const String vizzleProductDetails = '/vizzle/product';
  static const String vizzleAdDetails = '/vizzle/ad';

  // User Content Routes
  static const String vizzleFavorites = '/vizzle/favorites';
  static const String vizzleRecentlyViewed = '/vizzle/recently-viewed';
  static const String vizzleSavedAds = '/vizzle/saved';

  // ==================== COMMUNITY ROUTES ====================
  static const String communitySavedView = '/community/saved';
  static const String communityRecentlyViewed = '/community/recently-viewed';
  static const String communityManageFavorites = '/community/manage-favorites';
  static const String communityFeedActions = '/community/feed-actions';

  // Seller Routes
  static const String vizzleSellerDetails = '/vizzle/seller';
  static const String vizzleSellerProfile = '/vizzle/seller/profile';
  static const String vizzleSellerAds = '/vizzle/seller/ads';
  static const String vizzleSellerReviews = '/vizzle/seller/reviews';
  static const String vizzleSellerStats = '/vizzle/seller/stats';

  // Ad Management Routes (Future Implementation)
  static const String vizzleCreateAd = '/vizzle/create-ad';
  static const String vizzleEditAd = '/vizzle/edit-ad';
  static const String vizzleMyAds = '/vizzle/my-ads';
  static const String vizzleAdPreview = '/vizzle/ad-preview';

  // Specific Category Creation Routes (Future Implementation)
  static const String vizzleCreateMotorAd = '/vizzle/create/motor';
  static const String vizzleCreatePropertyAd = '/vizzle/create/property';
  static const String vizzleCreateClassifiedAd = '/vizzle/create/classified';
  static const String vizzleCreateFurnitureAd = '/vizzle/create/furniture';
  static const String vizzleCreateJobAd = '/vizzle/create/job';

  // Filter & Sort Routes
  static const String vizzleFilters = '/vizzle/filters';
  static const String vizzleSortOptions = '/vizzle/sort';

  // ==================== PROFILE ROUTES ====================
  static const String editProfile = '/profile/edit';
  static const String loyaltyPoints = '/profile/loyalty-points';
  static const String changePassword = '/profile/change-password';
  static const String helpSupport = '/profile/help-support';
  static const String contactUs = '/profile/contact-us';
  static const String settings = '/profile/settings';
  static const String privacy = '/profile/privacy';
  static const String termsConditions = '/profile/terms-conditions';
  static const String aboutApp = '/profile/about';

  // ==================== DYNAMIC ROUTE BUILDERS ====================

  /// Generate community saved view route
  static String communitySavedViewRoute() => communitySavedView;

  /// Generate community recently viewed route
  static String communityRecentlyViewedRoute() => communityRecentlyViewed;

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

  /// Generate seller stats route with seller ID
  static String sellerStatsWithId(String sellerId) =>
      '$vizzleSellerStats/$sellerId';

  /// Generate product details route with product ID
  static String productDetailsWithId(String productId) =>
      '$vizzleProductDetails/$productId';

  /// Generate ad details route with ad ID
  static String adDetailsWithId(String adId) => '$vizzleAdDetails/$adId';

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

  /// Generate sub-subcategory route with parameters
  static String subSubCategoryWithParams({
    required String categoryName,
    required String subCategoryId,
    required String subSubCategoryId,
    String? subSubCategoryName,
    String? categoryId,
  }) {
    String route =
        '$vizzleSubSubCategory/$categoryName/$subCategoryId/$subSubCategoryId';
    List<String> params = [];

    if (subSubCategoryName != null) {
      params.add(
        'subSubCategoryName=${Uri.encodeComponent(subSubCategoryName)}',
      );
    }
    if (categoryId != null) {
      params.add('categoryId=$categoryId');
    }

    return params.isNotEmpty ? '$route?${params.join('&')}' : route;
  }

  /// Generate sub items route with parameters
  static String subItemsWithParams({
    required String subSubCategoryId,
    String? subSubCategoryName,
    String? categoryName,
    String? subCategoryName,
    String? categoryId,
    String? subCategoryId,
    bool? isFromListAd,
  }) {
    String route = '$vizzleSubItems/$subSubCategoryId';
    List<String> params = [];

    if (subSubCategoryName != null) {
      params.add(
        'subSubCategoryName=${Uri.encodeComponent(subSubCategoryName)}',
      );
    }
    if (categoryName != null) {
      params.add('categoryName=${Uri.encodeComponent(categoryName)}');
    }
    if (subCategoryName != null) {
      params.add('subCategoryName=${Uri.encodeComponent(subCategoryName)}');
    }
    if (categoryId != null) params.add('categoryId=$categoryId');
    if (subCategoryId != null) params.add('subCategoryId=$subCategoryId');
    if (isFromListAd != null) params.add('isFromListAd=$isFromListAd');

    return params.isNotEmpty ? '$route?${params.join('&')}' : route;
  }

  /// Generate search route with query parameters
  static String searchWithQuery({
    String? keyword,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
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
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return params.isNotEmpty
        ? '$vizzleSearchPage?${params.join('&')}'
        : vizzleSearchPage;
  }

  /// Generate ads listing route with filters
  static String adsListingWithFilters({
    String? categoryId,
    String? subCategoryId,
    String? categoryName,
    String? subCategoryName,
    String? keyword,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  }) {
    List<String> params = [];

    if (categoryId != null) params.add('categoryId=$categoryId');
    if (subCategoryId != null) params.add('subCategoryId=$subCategoryId');
    if (categoryName != null) {
      params.add('categoryName=${Uri.encodeComponent(categoryName)}');
    }
    if (subCategoryName != null) {
      params.add('subCategoryName=${Uri.encodeComponent(subCategoryName)}');
    }
    if (keyword != null && keyword.isNotEmpty) {
      params.add('keyword=${Uri.encodeComponent(keyword)}');
    }
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');
    if (location != null) {
      params.add('location=${Uri.encodeComponent(location)}');
    }
    if (sortBy != null) params.add('sortBy=$sortBy');

    return params.isNotEmpty
        ? '$vizzleAdsListing?${params.join('&')}'
        : vizzleAdsListing;
  }

  // ==================== ROUTE VALIDATION HELPERS ====================

  /// Check if route is a Vizzle route
  static bool isVizzleRoute(String route) {
    return route.startsWith('/vizzle');
  }

  /// Check if route is a Community route
  static bool isCommunityRoute(String route) {
    return route.startsWith('/community');
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
      vizzleFavorites,
      vizzleMyAds,
      communitySavedView,
      communityRecentlyViewed,
      editProfile,
      loyaltyPoints,
      changePassword,
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
        route.startsWith(vizzleSellerReviews) ||
        route.startsWith(vizzleSellerStats);
  }

  /// Check if route is a search-related route
  static bool isSearchRoute(String route) {
    return route.startsWith(vizzleSearchPage) ||
        route.startsWith(vizzleAdvancedSearch) ||
        route.startsWith(vizzleSearchFilters) ||
        route.startsWith(vizzleSearchHistory);
  }

  /// Check if route is a category navigation route
  static bool isCategoryRoute(String route) {
    return route.startsWith(vizzleCategory) ||
        route.startsWith(vizzleSubCategory) ||
        route.startsWith(vizzleSubSubCategory) ||
        route.startsWith(vizzleSubItems);
  }

  /// Check if route is an ad management route
  static bool isAdManagementRoute(String route) {
    return route.startsWith(vizzleCreateAd) ||
        route.startsWith(vizzleEditAd) ||
        route.startsWith(vizzleMyAds) ||
        route.startsWith(vizzleAdPreview);
  }

  // ==================== ROUTE COLLECTIONS ====================

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
    vizzleCreateAd,
    vizzleMyAds,
  ];

  /// Get all Community feature routes
  static List<String> get communityRoutes => [
    communitySavedView,
    communityRecentlyViewed,
    communityManageFavorites,
    communityFeedActions,
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

  /// Get all seller-related routes
  static List<String> get sellerRoutes => [
    vizzleSellerDetails,
    vizzleSellerProfile,
    vizzleSellerAds,
    vizzleSellerReviews,
    vizzleSellerStats,
  ];

  /// Get all search-related routes
  static List<String> get searchRoutes => [
    vizzleSearchPage,
    vizzleAdvancedSearch,
    vizzleSearchFilters,
    vizzleSearchHistory,
    vizzleSearchSuggestions,
  ];

  // ==================== DEEP LINK HANDLING ====================

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

  /// Generate deep link for category
  static String generateCategoryDeepLink(String categoryName) {
    return 'community://category/${Uri.encodeComponent(categoryName)}';
  }

  /// Generate deep link for community saved view
  static String generateCommunitySavedDeepLink() {
    return 'community://saved';
  }

  /// Generate deep link for community recently viewed
  static String generateCommunityRecentlyViewedDeepLink() {
    return 'community://recently-viewed';
  }

  /// Parse deep link and return route
  static String parseDeepLink(String deepLink) {
    final uri = Uri.parse(deepLink);

    switch (uri.host) {
      case 'seller':
        if (uri.pathSegments.isNotEmpty) {
          return sellerDetailsWithId(uri.pathSegments.first);
        }
        break;
      case 'product':
        if (uri.pathSegments.isNotEmpty) {
          return productDetailsWithId(uri.pathSegments.first);
        }
        break;
      case 'search':
        final query = uri.queryParameters['q'] ?? '';
        return searchWithQuery(keyword: query);
      case 'category':
        if (uri.pathSegments.isNotEmpty) {
          return categoryWithName(uri.pathSegments.first);
        }
        break;
      case 'saved':
        return communitySavedView;
      case 'recently-viewed':
        return communityRecentlyViewed;
      default:
        return home;
    }

    return home;
  }

  // ==================== ANALYTICS HELPERS ====================

  /// Get route category for analytics
  static String getRouteCategory(String route) {
    if (isAuthRoute(route)) return 'auth';
    if (isVizzleRoute(route)) return 'vizzle';
    if (isCommunityRoute(route)) return 'community';
    if (isSellerRoute(route)) return 'seller';
    if (isSearchRoute(route)) return 'search';
    if (isCategoryRoute(route)) return 'category';
    if (isAdManagementRoute(route)) return 'ad_management';
    if (profileRoutes.contains(route)) return 'profile';
    if (mainNavigationRoutes.contains(route)) return 'main';
    return 'other';
  }

  /// Get readable route name for analytics
  static String getRouteName(String route) {
    return route.split('/').last.replaceAll('-', '_');
  }

  /// Get route hierarchy for breadcrumbs
  static List<String> getRouteHierarchy(String route) {
    final segments = route.split('/').where((s) => s.isNotEmpty).toList();
    final hierarchy = <String>[];

    String currentPath = '';
    for (final segment in segments) {
      currentPath += '/$segment';
      hierarchy.add(currentPath);
    }

    return hierarchy;
  }

  // ==================== FEATURE FLAGS ====================

  /// Check if Vizzle marketplace is enabled
  static bool get isVizzleEnabled => true;

  /// Check if Community features are enabled
  static bool get isCommunityEnabled => true;

  /// Check if seller features are enabled
  static bool get isSellerFeaturesEnabled => true;

  /// Check if ad creation is enabled
  static bool get isAdCreationEnabled => true;

  /// Check if search features are enabled
  static bool get isSearchEnabled => true;
}
