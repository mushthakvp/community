class ApiConstants {
  String baseUrlPro = 'https://api.app.liveraapp.com/';
  String baseUrlDev = 'http://192.168.3.242:3553/';

  // Base URL for API requests
  static String baseUrl = 'http://172.20.10.4:3553/';

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
}
