class ApiConstants {
  String baseUrlPro = 'https://api.app.liveraapp.com/';
  String baseUrlDev = 'http://192.168.3.115:3553/';

  static String baseUrl = 'http://192.168.3.6:3553/';

  static const int timeoutDuration = 30;

  // Auth Endpoints
  static const String login = 'user/login';
  static const String register = 'user/signup';
  static const String logout = 'auth/logout';
  static const String verifyOtp = 'user/verifyOtp';
  static const String resendOtp = 'user/resentOtp';
  static const String forgotPassword = 'user/forgotPassword';
  static const String resetPassword = 'user/changePassword';

  // User Endpoints
  static const String profile = 'user/getProfile';

  // Coupon Endpoints
  static const String getCoupons = 'user/getCoupons';
  static const String actionOnCoupons = 'user/actionOnCoupon/';
  static const String useCoupon = 'user/useCoupon/';

  // Promos Endpoints
  static const String promosScreen = 'user/rewardsScreen';
  static const String addRewardPointsFromPromos = 'user/addRewardPoints';

  // Notifications Endpoints
  static const String getNotifications = 'user/getNotification';

  // Home Endpoints
  static const String getHome = 'user/getHome';

  // Redemption Endpoints
  static const String getWalletTransactions = 'user/getWalletTransactions';

  // Payment Endpoints
  static const String initiatePayment = 'user/initiatePayment';
  static const String initiateTierUpgrade = 'user/paymentRegistration';
  static const String verifyPayment = 'user/verifyPayment';

  // Profile Endpoints
  static const String getProfile = 'user/getHome';
  static const String updateProfile = 'user/updateProfile';
  static const String changePassword = 'user/changePassword';
  static const String getLoyaltyCard = 'user/getLoyalityCard';
  static const String claimLoyaltyPoints = 'user/claimLoyalityPoints';
  static const String loyaltyPointHistory = 'user/loyalityPointHistory';
  static const String optOut = 'user/addOptItOut';

  // Vizzle Home
  static const String vizzleHome = 'user/getVizzleHome';

  // Categories & Hierarchical Data
  static const String vizzleCategories = 'user/getCities';
  static const String vizzleSubCategories = 'user/getSubCategories';
  static const String vizzleSubSubCategories = 'user/getSubSubCategories';
  static const String vizzleSubItems = 'user/getSubItems';

  // Ads Management
  static const String vizzleAds = 'user/getAds';
  static const String vizzleCreateAd = 'user/createAd';
  static const String vizzleCreateJobAd = 'user/createJobAd';
  static const String vizzleEditAd = 'user/editAd';
  static const String vizzleDeleteAd = 'user/deleteAd';
  static const String vizzleSavedAds = 'user/savedAds';
  static const String vizzleRecentlyViewed = 'user/recentlyViewedAds';

  // Search & Filters
  static const String vizzleSearch = 'user/searchAll';
  static const String vizzleSetFilters = 'user/setFilters';

  // Favorites & Actions
  static const String vizzleAddToFavorite = 'user/saveFeed';
  static const String vizzleRemoveFromFavorite = 'user/removeFeed';
  static const String vizzleShareFeed = 'user/shareFeed';
  static const String vizzleReportPost = 'user/reportPost';

  // Profile & User Data
  static const String vizzleProfile = 'user/getProfile';

  // Seller Details Endpoints
  static const String getSellerProfile = 'user/getProfile';

  // Search Endpoints
  static const String searchAllAds = 'user/searchAll';

  // Helper methods for dynamic endpoints
  static String getVizzleSubSubCategoriesBySubCategory(String subCategoryId) =>
      '$vizzleSubSubCategories/$subCategoryId';

  static String getVizzleSubItemsBySubSubCategory(String subSubCategoryId) =>
      '$vizzleSubItems/$subSubCategoryId';

  static String editVizzleAdById(String adId) => '$vizzleEditAd/$adId';

  static String deleteVizzleAdById(String adId) => '$vizzleDeleteAd/$adId';

  static String addVizzleToFavoriteById(String adId) =>
      '$vizzleAddToFavorite/$adId';

  static String removeVizzleFromFavoriteById(String adId) =>
      '$vizzleRemoveFromFavorite/$adId';

  static String shareVizzleFeedById(String adId) => '$vizzleShareFeed/$adId';

  static String setVizzleFiltersByCategory(String categoryId) =>
      '$vizzleSetFilters?categoryId=$categoryId';

  static String searchVizzleWithKeyword(String keyword) =>
      '$vizzleSearch?keyword=$keyword';

  /// Get seller profile by seller ID
  static String getSellerProfileWithId(String sellerId) =>
      '$getSellerProfile?userId=$sellerId';

  /// Search ads with keyword
  static String searchAdsWithKeyword(String keyword) =>
      '$searchAllAds?keyword=$keyword';

  // Helper methods for query parameters
  static String getVizzleAdsWithFilters({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? location,
    int? page,
    int? limit,
  }) {
    String endpoint = vizzleAds;
    List<String> params = [];

    if (categoryId != null) params.add('categoryId=$categoryId');
    if (subCategoryId != null) params.add('subCategoryId=$subCategoryId');
    if (subSubCategoryId != null) {
      params.add('subSubCategoryId=$subSubCategoryId');
    }
    if (subItemId != null) params.add('subItemId=$subItemId');
    if (searchQuery != null) params.add('searchQuery=$searchQuery');
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');
    if (location != null) params.add('location=$location');
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    if (params.isNotEmpty) {
      endpoint += '?${params.join('&')}';
    }

    return endpoint;
  }

  static String getVizzleSearchWithFilters({
    required String keyword,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) {
    List<String> params = ['keyword=$keyword'];

    if (categoryId != null) params.add('categoryId=$categoryId');
    if (location != null) params.add('location=$location');
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return '$vizzleSearch?${params.join('&')}';
  }

  static String getAdvancedSearchEndpoint({
    String? keyword,
    String? categoryId,
    String? subCategoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? sortBy,
    int? page,
    int? limit,
  }) {
    List<String> params = [];

    if (keyword != null && keyword.isNotEmpty) {
      params.add('keyword=${Uri.encodeComponent(keyword)}');
    }
    if (categoryId != null) params.add('categoryId=$categoryId');
    if (subCategoryId != null) params.add('subCategoryId=$subCategoryId');
    if (location != null) {
      params.add('location=${Uri.encodeComponent(location)}');
    }
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');
    if (condition != null) params.add('condition=$condition');
    if (sortBy != null) params.add('sortBy=$sortBy');
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return params.isNotEmpty
        ? '$vizzleSearch?${params.join('&')}'
        : vizzleSearch;
  }

  /// Get seller's active ads
  static String getSellerAds(String sellerId, {int? page, int? limit}) {
    List<String> params = ['sellerId=$sellerId'];
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return '$vizzleAds?${params.join('&')}';
  }

  /// Get seller statistics
  static String getSellerStats(String sellerId) =>
      'user/getSellerStats?sellerId=$sellerId';

  /// Get seller reviews
  static String getSellerReviews(String sellerId, {int? page, int? limit}) {
    List<String> params = ['sellerId=$sellerId'];
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return 'user/getSellerReviews?${params.join('&')}';
  }

  /// Get search suggestions
  static String getSearchSuggestions(String query) =>
      'user/getSearchSuggestions?q=${Uri.encodeComponent(query)}';

  /// Get popular searches
  static const String getPopularSearches = 'user/getPopularSearches';

  /// Save search history
  static const String saveSearchHistory = 'user/saveSearchHistory';

  /// Get user search history
  static const String getUserSearchHistory = 'user/getSearchHistory';

  /// Clear search history
  static const String clearSearchHistory = 'user/clearSearchHistory';

  /// Get available filter options for search
  static const String getSearchFilters = 'user/getSearchFilters';

  /// Get price range for category
  static String getCategoryPriceRange(String categoryId) =>
      'user/getCategoryPriceRange?categoryId=$categoryId';

  /// Get locations for search
  static const String getSearchLocations = 'user/getSearchLocations';

  /// Build URL with base URL
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';

  /// Encode search query for URL
  static String encodeSearchQuery(String query) => Uri.encodeComponent(query);

  /// Build pagination parameters
  static Map<String, String> buildPaginationParams({
    int? page,
    int? limit,
    int defaultPage = 1,
    int defaultLimit = 20,
  }) {
    return {
      'page': (page ?? defaultPage).toString(),
      'limit': (limit ?? defaultLimit).toString(),
    };
  }
}
