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

  // Vizzle Endpoints
  static const String getVizzleHome = 'user/getVizzleHome';
  static const String getCitySectionAndCategories = 'user/getCities';
  static const String createAd = 'user/createAd';
  static const String createJobAd = 'user/createJobAd';
  static const String getAds = 'user/getAds';
  static const String getSavedAds = 'user/savedAds';
  static const String addToFavorite = 'user/saveFeed/';
  static const String shareFeed = 'user/shareFeed/';
  static const String deleteAd = 'user/deleteAd/';
  static const String editAd = 'user/editAd/';
  static const String searchAll = 'user/searchAll';
  static const String setFilters = 'user/setFilters';
  static const String getSubSubCategories = 'user/getSubSubCategories/';
}
