class VCartConstants {
  // App Info
  static const String appName = 'VCart';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://192.168.3.6:8003/';
  static const int timeoutDuration = 30;
  static const int retryAttempts = 3;

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Cache
  static const Duration cacheValidDuration = Duration(hours: 1);
  static const String cacheKeyPrefix = 'vcart_';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;

  // Grid Configuration
  static const int categoriesPerRow = 5;
  static const int productsPerRow = 2;
  static const int brandsPerRow = 4;

  // Image Configuration
  static const String placeholderImageUrl =
      'https://via.placeholder.com/200x200/2A2A2A/FFFFFF?text=VCart';
  static const String errorImageUrl =
      'https://via.placeholder.com/200x200/F75555/FFFFFF?text=Error';

  // Navigation
  static const List<String> bottomNavIcons = [
    '🏠', // Home
    '📂', // Categories
    '🛒', // Cart
    '👤', // Profile
  ];

  static const List<String> bottomNavLabels = [
    'Home',
    'Categories',
    'Cart',
    'Profile',
  ];

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String unknownError = 'An unexpected error occurred';
  static const String noDataError = 'No data available';
  static const String locationError = 'Unable to get your location';
}
