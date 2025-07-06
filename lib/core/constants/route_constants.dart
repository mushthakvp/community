class RouteConstants {
  // ==================== AUTH ROUTES ====================
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';

  // ==================== MAIN APP ROUTES ====================
  static const String home = '/home';
  static const String promos = '/promos';
  static const String redemption = '/redemption';
  static const String profile = '/profile';

  // ==================== SPIN GAME ROUTES ====================
  static const String spinMain = '/spin';
  static const String dailySpin = '/daily-spin';
  static const String spinAndWin = '/spin-and-win';
  static const String spinHistory = '/spin-history';

  // ==================== VHUB BUSINESS STARTUP ROUTES ====================
  static const String vhubHome = '/vhub';
  static const String vhubIdeas = '/vhub/ideas';
  static const String vhubCreateIdea = '/vhub/create-idea';
  static const String vhubIdeaDetails = '/vhub/idea-details';
  static const String vhubFaq = '/vhub/faq';
  static const String vhubMyProfile = '/vhub/my-profile';
  static const String vhubEditIdea = '/vhub/edit-idea';

  // ==================== VIZZLE MARKETPLACE ROUTES ====================
  static const String vizzleHome = '/vizzle';

  // ========== VIZZLE PROFILE ROUTES ==========
  static const String vizzleProfile = '/vizzle/profile';
  static const String vizzleMyProfile = '/vizzle/my-profile';

  // ========== PLACE ADD FLOW ROUTES ==========
  static const String selectCity = '/place-add/select-city';
  static const String selectCategory = '/place-add/select-category';
  static const String selectSubCategory = '/place-add/select-subcategory';
  static const String createAd = '/place-add/create-ad';
  static const String locationPicker = '/place-add/location-picker';

  // ========== CREATE AD CATEGORY SPECIFIC ROUTES ==========
  static const String createMotorAd = '/place-add/create-motor-ad';
  static const String createPropertyAd = '/place-add/create-property-ad';
  static const String createElectronicsAd = '/place-add/create-electronics-ad';
  static const String createFurnitureAd = '/place-add/create-furniture-ad';
  static const String createFarmFreshAd = '/place-add/create-farm-fresh-ad';
  static const String createCommunityAd = '/place-add/create-community-ad';

  // ========== PRODUCT DETAIL ROUTES ==========
  static const String productDetail = '/product-detail';
  static const String reportProduct = '/report-product';

  // ========== EDIT AD ROUTES ==========
  static const String editAd = '/edit-ad';

  // ========== SEARCH ROUTES ==========
  static const String vizzleSearch = '/vizzle/search';
  static const String vizzleAdvancedSearch = '/vizzle/search/advanced';
  static const String vizzleSearchFilters = '/vizzle/search/filters';
  static const String vizzleSearchHistory = '/vizzle/search/history';
  static const String vizzleSearchSuggestions = '/vizzle/search/suggestions';

  // ========== ADS LISTING ROUTES ==========
  static const String vizzleAdsListing = '/vizzle/ads';

  // ========== USER CONTENT ROUTES ==========
  static const String vizzleRecentlyViewed = '/vizzle/recently-viewed';
  static const String vizzleSavedAds = '/vizzle/saved-ads';
  static const String vizzleFavorites = '/vizzle/favorites';

  // ========== CATEGORY NAVIGATION ROUTES ==========
  static const String vizzleCategory = '/vizzle/category';
  static const String vizzleSubCategory = '/vizzle/subcategory';
  static const String vizzleSubSubCategory = '/vizzle/sub-subcategory';
  static const String vizzleSubItems = '/vizzle/sub-items';

  // ========== PRODUCT & AD DETAIL ROUTES ==========
  static const String vizzleProductDetails = '/vizzle/product';
  static const String vizzleAdDetails = '/vizzle/ad';

  // ========== SELLER ROUTES ==========
  static const String vizzleSellerDetails = '/vizzle/seller';
  static const String vizzleSellerProfile = '/vizzle/seller/profile';
  static const String vizzleSellerAds = '/vizzle/seller/ads';
  static const String vizzleSellerReviews = '/vizzle/seller/reviews';
  static const String vizzleSellerStats = '/vizzle/seller/stats';

  // ========== AD MANAGEMENT ROUTES ==========
  static const String vizzleCreateAd = '/vizzle/create-ad';
  static const String vizzleEditAd = '/vizzle/edit-ad';
  static const String vizzleMyAds = '/vizzle/my-ads';
  static const String vizzleAdPreview = '/vizzle/ad-preview';

  // ========== LEGACY CATEGORY SPECIFIC AD CREATION ==========
  static const String vizzleCreateMotorAd = '/vizzle/create/motor';
  static const String vizzleCreatePropertyAd = '/vizzle/create/property';
  static const String vizzleCreateClassifiedAd = '/vizzle/create/classified';
  static const String vizzleCreateFurnitureAd = '/vizzle/create/furniture';
  static const String vizzleCreateJobAd = '/vizzle/create/job';

  // ========== FILTER & SORT ROUTES ==========
  static const String vizzleFilters = '/vizzle/filters';
  static const String vizzleSortOptions = '/vizzle/sort';

  // ==================== STANDALONE PAGES ====================
  // ========== COUPONS ==========
  static const String coupons = '/coupons';

  // ========== REDEMPTION ==========
  static const String walletRecharge = '/wallet-recharge';

  // ========== PROFILE PAGES ==========
  static const String editProfile = '/edit-profile';
  static const String loyaltyPoints = '/loyalty-points';
  static const String changePassword = '/change-password';
  static const String notifications = '/notifications';
  static const String privacy = '/privacy';
  static const String termsConditions = '/terms-conditions';
  static const String aboutApp = '/about-app';
  static const String helpSupport = '/help-support';
  static const String contactUs = '/contact-us';

  // ==================== VJOB ROUTES ====================
  static const String vjobHome = '/v-job';
  static const String vjobJobDetails = '/v-job/job-details';
  static const String vjobCreateJob = '/v-job/create-job';
  static const String vjobMyJobs = '/v-job/my-jobs';
  static const String vjobApplications = '/v-job/applications';
  static const String vjobSavedJobs = '/v-job/saved-jobs';
  static const String vjobSearch = '/v-job/search';
  static const String vjobCompanies = '/v-job/companies';
  static const String vjobCreateCompany = '/v-job/create-company';
  static const String vjobPosts = '/v-job/posts';
  static const String vjobCreatePost = '/v-job/create-post';

  // ==================== HELPER METHODS ====================

  static String editAdWithId(String adId) {
    return '$editAd/$adId';
  }

  /// VHub dynamic routes
  static String vhubIdeaDetailsWithId(String ideaId) {
    return '$vhubIdeaDetails/$ideaId';
  }

  static String vhubEditIdeaWithId(String ideaId) {
    return '$vhubEditIdea/$ideaId';
  }

  static bool isVJobRoute(String route) {
    return route.startsWith('/v-job');
  }

  /// Check if route is protected (requires authentication)
  static bool isProtectedRoute(String route) {
    const protectedRoutes = [
      home,
      profile,
      editProfile,
      loyaltyPoints,
      changePassword,
      notifications,
      spinMain,
      dailySpin,
      spinAndWin,
      spinHistory,
      vizzleHome,
      vizzleProfile,
      vjobHome,
      vizzleMyProfile,
      vhubHome,
      vhubIdeas,
      vhubCreateIdea,
      vhubIdeaDetails,
      vhubFaq,
      vhubMyProfile,
      selectCity,
      selectCategory,
      createAd,
      editAd,
      coupons,
      redemption,
      walletRecharge,
    ];

    return protectedRoutes.any(
      (protectedRoute) => route.startsWith(protectedRoute),
    );
  }

  /// Check if route is auth related
  static bool isAuthRoute(String route) {
    const authRoutes = [login, register, otpVerification];
    return authRoutes.contains(route);
  }

  /// Check if route is a Vizzle route
  static bool isVizzleRoute(String route) {
    return route.startsWith('/vizzle') ||
        route.startsWith('/place-add') ||
        route.startsWith('/edit-ad');
  }

  /// Check if route is a VHub route
  static bool isVHubRoute(String route) {
    return route.startsWith('/vhub');
  }

  /// Check if route is a Spin route
  static bool isSpinRoute(String route) {
    return route.startsWith('/spin') ||
        route == dailySpin ||
        route == spinAndWin ||
        route == spinHistory;
  }

  /// Get route category for analytics
  static String getRouteCategory(String route) {
    if (route.startsWith('/vizzle') ||
        route.startsWith('/place-add') ||
        route.startsWith('/edit-ad')) {
      return 'Vizzle';
    } else if (route.startsWith('/vhub')) {
      return 'VHub';
    } else if (route.startsWith('/v-job')) {
      return 'VJob';
    } else if (isAuthRoute(route)) {
      return 'Auth';
    } else if (isSpinRoute(route)) {
      return 'Spin';
    } else if (route.startsWith('/profile') || route == editProfile) {
      return 'Profile';
    } else {
      return 'Main';
    }
  }

  // ==================== DYNAMIC ROUTE BUILDERS ====================

  /// Navigate to edit ad with ID
  static String editAdWithIdRoute(String adId) {
    return '$editAd/$adId';
  }

  /// Build seller details route with ID
  static String sellerDetailsWithId(String sellerId) {
    return '$vizzleSellerDetails/$sellerId';
  }

  /// Build product details route with ID
  static String productDetailsWithId(String productId) {
    return '$vizzleProductDetails/$productId';
  }

  /// Build category route with name
  static String categoryWithName(String categoryName) {
    return '$vizzleCategory/$categoryName';
  }

  /// Build subcategory route
  static String subCategoryWithParams(
    String categoryName,
    String subCategoryId,
  ) {
    return '$vizzleSubCategory/$categoryName/$subCategoryId';
  }
}
