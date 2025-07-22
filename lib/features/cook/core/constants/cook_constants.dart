class CookConstants {
  static const String moduleName = 'cook';
  static const String baseUrl = 'https://api.cook.liveraapp.com/user/';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Debounce
  static const int searchDebounceMs = 500;

  // Cache keys
  static const String homeCacheKey = 'cook_home_data';
  static const String myChallengesCacheKey = 'my_challenges_data';
}
