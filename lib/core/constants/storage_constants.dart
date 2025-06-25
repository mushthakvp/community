class StorageConstants {
  // Secure Storage Keys
  static const String accessToken = 'access_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  // Shared Preferences Keys
  static const String isFirstLaunch = 'is_first_launch';
  static const String isLoggedIn = 'is_logged_in';
  static const String selectedLanguage = 'selected_language';
  static const String themeMode = 'theme_mode';
  static const String cacheTimestamp = 'cache_timestamp';

  // User Data Keys
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String communityId = 'community_id';
  static const String userTier = 'user_tier';
  static const String loyaltyPoints = 'loyalty_points';
  static const String walletAmount = 'wallet_amount';
  static const String currencyCode = 'currency_code';
  static const String joinedDate = 'joined_date';

  // Cache Keys
  static const String couponsCache = 'coupons_cache';
  static const String categoriesCache = 'categories_cache';
  static const String userProfileCache = 'user_profile_cache';

  // Cache Duration (in hours)
  static const int defaultCacheDuration = 24;
  static const int shortCacheDuration = 1;
  static const int longCacheDuration = 168;

  // Country Codes
  static const String countryCode = 'country_code';
  static const String countryName = 'country_name';
}
