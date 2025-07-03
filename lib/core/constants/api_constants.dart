class ApiConstants {
  // Base URLs
  String baseUrlPro = 'https://api.prod.liveraapp.com/';
  String baseUrlDev = 'http://192.168.3.6:3553/';
  static String baseUrl = 'https://api.prod.liveraapp.com/';

  // Request Configuration
  static const int timeoutDuration = 30;

  // ========== AUTH ENDPOINTS ==========
  static const String login = 'user/login';
  static const String register = 'user/signup';
  static const String logout = 'auth/logout';
  static const String verifyOtp = 'user/verifyOtp';
  static const String resendOtp = 'user/resentOtp';
  static const String forgotPassword = 'user/forgotPassword';
  static const String resetPassword = 'user/changePassword';

  // ========== USER ENDPOINTS ==========
  static const String profile = 'user/getProfile';
  static const String updateProfile = 'user/updateProfile';
  static const String changePassword = 'user/changePassword';

  // ========== COUPON ENDPOINTS ==========
  static const String getCoupons = 'user/getCoupons';
  static const String actionOnCoupons = 'user/actionOnCoupon/';
  static const String useCoupon = 'user/useCoupon/';

  // ========== PROMOS ENDPOINTS ==========
  static const String promosScreen = 'user/rewardsScreen';
  static const String addRewardPointsFromPromos = 'user/addRewardPoints';

  // ========== NOTIFICATIONS ENDPOINTS ==========
  static const String getNotifications = 'user/getNotification';

  // ========== HOME ENDPOINTS ==========
  static const String getHome = 'user/getHome';

  // ========== REDEMPTION ENDPOINTS ==========
  static const String getWalletTransactions = 'user/getWalletTransactions';

  // ========== PAYMENT ENDPOINTS ==========
  static const String initiatePayment = 'user/initiatePayment';
  static const String initiateTierUpgrade = 'user/paymentRegistration';
  static const String verifyPayment = 'user/verifyPayment';

  // ========== LOYALTY ENDPOINTS ==========
  static const String getLoyaltyCard = 'user/getLoyalityCard';
  static const String claimLoyaltyPoints = 'user/claimLoyalityPoints';
  static const String loyaltyPointHistory = 'user/loyalityPointHistory';
  static const String optOut = 'user/addOptItOut';

  // ========== COMMUNITY ENDPOINTS ==========
  static const String communitySavedAds = 'user/savedAds';
  static const String communityRecentlyViewed = 'user/recentlyViewedAds';
  static const String communityAddToFavorite = 'user/saveFeed';
  static const String communityRemoveFromFavorite = 'user/removeFeed';
  static const String communityShareFeed = 'user/shareFeed';
  static const String communityReportPost = 'user/reportPost';

  // ========== VIZZLE MARKETPLACE ENDPOINTS ==========

  // Core Vizzle
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

  // Saved & Recently Viewed
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

  // Seller Information
  static const String getSellerProfile = 'user/getProfile';
  static const String getSellerStats = 'user/getSellerStats';
  static const String getSellerReviews = 'user/getSellerReviews';

  // Search Enhancements
  static const String getSearchSuggestions = 'user/getSearchSuggestions';
  static const String getPopularSearches = 'user/getPopularSearches';
  static const String saveSearchHistory = 'user/saveSearchHistory';
  static const String getUserSearchHistory = 'user/getSearchHistory';
  static const String clearSearchHistory = 'user/clearSearchHistory';

  // Filter Options
  static const String getSearchFilters = 'user/getSearchFilters';
  static const String getSearchLocations = 'user/getSearchLocations';

  // ========== DYNAMIC ENDPOINT BUILDERS ==========

  // Community Management
  static String addCommunityToFavoriteById(String adId) =>
      '$communityAddToFavorite/$adId';
  static String removeCommunityFromFavoriteById(String adId) =>
      '$communityRemoveFromFavorite/$adId';
  static String shareCommunityFeedById(String adId) =>
      '$communityShareFeed/$adId';
  static String reportCommunityPostById(String adId) =>
      '$communityReportPost/$adId';

  // Category Hierarchy Navigation
  static String getVizzleSubSubCategoriesBySubCategory(String subCategoryId) =>
      '$vizzleSubSubCategories/$subCategoryId';

  static String getVizzleSubItemsBySubSubCategory(String subSubCategoryId) =>
      '$vizzleSubItems/$subSubCategoryId';

  // Ad Management
  static String editVizzleAdById(String adId) => '$vizzleEditAd/$adId';
  static String deleteVizzleAdById(String adId) => '$vizzleDeleteAd/$adId';

  // Favorites Management
  static String addVizzleToFavoriteById(String adId) =>
      '$vizzleAddToFavorite/$adId';
  static String removeVizzleFromFavoriteById(String adId) =>
      '$vizzleRemoveFromFavorite/$adId';

  // Social Actions
  static String shareVizzleFeedById(String adId) => '$vizzleShareFeed/$adId';
  static String reportVizzlePostById(String adId) => '$vizzleReportPost/$adId';

  // Filter & Search with Parameters
  static String setVizzleFiltersByCategory(String categoryId) =>
      '$vizzleSetFilters?categoryId=$categoryId';

  static String searchVizzleWithKeyword(String keyword) =>
      '$vizzleSearch?keyword=${Uri.encodeComponent(keyword)}';

  // Seller Information
  static String getSellerProfileWithId(String sellerId) =>
      '$getSellerProfile?userId=$sellerId';

  static String getSellerStatsWithId(String sellerId) =>
      '$getSellerStats?sellerId=$sellerId';

  static String getSellerReviewsWithId(String sellerId) =>
      '$getSellerReviews?sellerId=$sellerId';

  // Search Utilities
  static String getSearchSuggestionsWithQuery(String query) =>
      '$getSearchSuggestions?q=${Uri.encodeComponent(query)}';

  static String getCategoryPriceRange(String categoryId) =>
      'user/getCategoryPriceRange?categoryId=$categoryId';

  // ========== ADVANCED QUERY BUILDERS ==========

  /// Build comprehensive ads query with all possible filters
  static String getVizzleAdsWithFilters({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? condition,
    String? sortBy,
    List<String>? brands,
    List<String>? fuelTypes,
    List<String>? transmissions,
    List<String>? colors,
    List<String>? propertyTypes,
    List<String>? amenities,
    int? minYear,
    int? maxYear,
    int? minKilometers,
    int? maxKilometers,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
    double? minArea,
    double? maxArea,
    int? page,
    int? limit,
  }) {
    String endpoint = vizzleAds;
    List<String> params = [];

    // Basic filters
    if (categoryId != null) params.add('categoryId=$categoryId');
    if (subCategoryId != null) params.add('subCategoryId=$subCategoryId');
    if (subSubCategoryId != null) {
      params.add('subSubCategoryId=$subSubCategoryId');
    }
    if (subItemId != null) params.add('subItemId=$subItemId');
    if (searchQuery != null) {
      params.add('searchQuery=${Uri.encodeComponent(searchQuery)}');
    }
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');
    if (location != null) {
      params.add('location=${Uri.encodeComponent(location)}');
    }
    if (condition != null) params.add('condition=$condition');
    if (sortBy != null) params.add('sortBy=$sortBy');

    // Vehicle-specific filters
    if (brands != null && brands.isNotEmpty) {
      params.add('brands=${brands.join(',')}');
    }
    if (fuelTypes != null && fuelTypes.isNotEmpty) {
      params.add('fuelTypes=${fuelTypes.join(',')}');
    }
    if (transmissions != null && transmissions.isNotEmpty) {
      params.add('transmissions=${transmissions.join(',')}');
    }
    if (colors != null && colors.isNotEmpty) {
      params.add('colors=${colors.join(',')}');
    }
    if (minYear != null) params.add('minYear=$minYear');
    if (maxYear != null) params.add('maxYear=$maxYear');
    if (minKilometers != null) params.add('minKilometers=$minKilometers');
    if (maxKilometers != null) params.add('maxKilometers=$maxKilometers');

    // Property-specific filters
    if (propertyTypes != null && propertyTypes.isNotEmpty) {
      params.add('propertyTypes=${propertyTypes.join(',')}');
    }
    if (amenities != null && amenities.isNotEmpty) {
      params.add('amenities=${amenities.join(',')}');
    }
    if (minBedrooms != null) params.add('minBedrooms=$minBedrooms');
    if (maxBedrooms != null) params.add('maxBedrooms=$maxBedrooms');
    if (minBathrooms != null) params.add('minBathrooms=$minBathrooms');
    if (maxBathrooms != null) params.add('maxBathrooms=$maxBathrooms');
    if (minArea != null) params.add('minArea=$minArea');
    if (maxArea != null) params.add('maxArea=$maxArea');

    // Pagination
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    if (params.isNotEmpty) {
      endpoint += '?${params.join('&')}';
    }

    return endpoint;
  }

  /// Build advanced search query with comprehensive filters
  static String getAdvancedSearchEndpoint({
    String? keyword,
    String? categoryId,
    String? subCategoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? sortBy,
    List<String>? tags,
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
    if (tags != null && tags.isNotEmpty) {
      params.add('tags=${tags.join(',')}');
    }
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return params.isNotEmpty
        ? '$vizzleSearch?${params.join('&')}'
        : vizzleSearch;
  }

  /// Get seller's active ads with pagination
  static String getSellerAds(String sellerId, {int? page, int? limit}) {
    List<String> params = ['sellerId=$sellerId'];
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return '$vizzleAds?${params.join('&')}';
  }

  static String getSellerReviewsPagination(
    String sellerId, {
    int? page,
    int? limit,
  }) {
    List<String> params = ['sellerId=$sellerId'];
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');

    return '$getSellerReviews?${params.join('&')}';
  }

  // ========== UTILITY METHODS ==========

  /// Build complete URL with base URL
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';

  /// Encode search query for URL safety
  static String encodeSearchQuery(String query) => Uri.encodeComponent(query);

  /// Build standardized pagination parameters
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

  /// Build seller query parameters
  static Map<String, String> buildSellerParams(
    String sellerId, {
    int? page,
    int? limit,
  }) {
    final params = {'sellerId': sellerId};
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();
    return params;
  }

  /// Build search query parameters
  static Map<String, String> buildSearchParams({
    required String keyword,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) {
    final params = <String, String>{'keyword': keyword};

    if (categoryId != null) params['categoryId'] = categoryId;
    if (location != null) params['location'] = location;
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();

    return params;
  }

  // ========== VALIDATION HELPERS ==========

  /// Validate if endpoint is a Vizzle endpoint
  static bool isVizzleEndpoint(String endpoint) {
    return endpoint.contains('Vizzle') ||
        endpoint.contains('getAds') ||
        endpoint.contains('searchAll') ||
        endpoint.contains('getCities') ||
        endpoint.contains('getSubCategories');
  }

  /// Validate if endpoint is a Community endpoint
  static bool isCommunityEndpoint(String endpoint) {
    return endpoint.contains('savedAds') ||
        endpoint.contains('recentlyViewedAds') ||
        endpoint.contains('saveFeed') ||
        endpoint.contains('removeFeed') ||
        endpoint.contains('shareFeed') ||
        endpoint.contains('reportPost');
  }

  /// Validate required parameters for ads query
  static bool validateAdsQuery({String? categoryId, String? searchQuery}) {
    return (categoryId != null && categoryId.isNotEmpty) ||
        (searchQuery != null && searchQuery.isNotEmpty);
  }

  /// Validate seller ID format
  static bool validateSellerId(String? sellerId) {
    return sellerId != null && sellerId.isNotEmpty && sellerId.length >= 3;
  }

  ///
  ///

  // Add these constants to your existing ApiConstants class

  // ========== PLACE ADD ENDPOINTS ==========
  static const String createAd = 'user/createAd';
  static const String createJobAd = 'user/createJobAd';
  static const String editAd = 'user/editAd';
  static const String deleteAd = 'user/deleteAd';
  static const String uploadImages = 'upload/images';
  static const String getCities = 'user/getCities';
  static const String getCategories = 'user/getCategories';
  static const String reverseGeocode = 'geocoding/reverse';

  // ========== PRODUCT DETAIL ENDPOINTS ==========
  static const String getProductDetail = 'user/getProductDetail';
  static const String toggleProductFavorite = 'user/saveFeed';
  static const String shareProduct = 'user/shareFeed';
  static const String reportProduct = 'user/reportPost';
  static const String accessChat = 'user/accessChat';

  // ========== DYNAMIC ENDPOINT BUILDERS ==========

  // Place Add Management
  static String editAdById(String adId) => '$editAd/$adId';
  static String deleteAdById(String adId) => '$deleteAd/$adId';

  // Product Detail Actions
  static String toggleProductFavoriteById(String productId) =>
      '$toggleProductFavorite/$productId';
  static String shareProductById(String productId) =>
      '$shareProduct/$productId';

  // Chat Access
  static String accessChatWithParams(String friendId, String postId) =>
      '$accessChat?friendId=$friendId&postId=$postId';

  // Reverse Geocoding
  static String reverseGeocodeWithCoordinates(
    double latitude,
    double longitude,
  ) => '$reverseGeocode?lat=$latitude&lng=$longitude';

  // ========== PLACE ADD QUERY BUILDERS ==========

  /// Build comprehensive ad creation request
  static Map<String, dynamic> buildAdCreationRequest({
    required String title,
    required String description,
    required String phoneNumber,
    required String district,
    required String categoryId,
    required String subCategoryId,
    String? subSubCategoryId,
    required List<String> images,
    required double latitude,
    required double longitude,
    required String address,
    double? price,
    Map<String, dynamic> additionalFields = const {},
  }) {
    final request = <String, dynamic>{
      'title': title,
      'description': description,
      'phone': phoneNumber,
      'district': district,
      'category': categoryId,
      'subCategory': subCategoryId,
      'images': images,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'address': address,
    };

    if (price != null) {
      request['price'] = price;
    }

    if (subSubCategoryId != null) {
      request['subSubcategory'] = subSubCategoryId;
    }

    // Add all additional fields
    request.addAll(additionalFields);

    return request;
  }

  /// Build report product request
  static Map<String, dynamic> buildReportProductRequest({
    required String productId,
    required String reason,
    String postType = 'advertisement',
  }) {
    return {'postId': productId, 'postType': postType, 'reason': reason};
  }

  /// Build image upload request for Cloudinary
  static Map<String, dynamic> buildImageUploadRequest({
    required String folder,
    required List<String> imagePaths,
  }) {
    return {'folder': folder, 'images': imagePaths};
  }

  // ========== VALIDATION HELPERS ==========

  /// Validate ad creation request
  static bool validateAdCreationRequest(Map<String, dynamic> request) {
    final requiredFields = [
      'title',
      'description',
      'phone',
      'district',
      'category',
      'subCategory',
      'images',
      'latitude',
      'longitude',
      'address',
    ];

    for (final field in requiredFields) {
      if (!request.containsKey(field) ||
          request[field] == null ||
          request[field].toString().isEmpty) {
        return false;
      }
    }

    // Validate images array
    if (request['images'] is List && (request['images'] as List).isEmpty) {
      return false;
    }

    return true;
  }

  /// Validate product ID format
  static bool validateProductId(String? productId) {
    return productId != null && productId.isNotEmpty && productId.length >= 3;
  }

  /// Validate coordinates
  static bool validateCoordinates(double? latitude, double? longitude) {
    return latitude != null &&
        longitude != null &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  // ========== UTILITY METHODS ==========

  /// Clean phone number for API
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Format price for display
  static String formatPrice(double price, String currencyCode) {
    return '$currencyCode ${price.toStringAsFixed(2)}';
  }

  /// Build complete image URL
  static String buildImageUrl(String imagePath) {
    return imagePath.startsWith('http') ? imagePath : '$baseUrl$imagePath';
  }
}
