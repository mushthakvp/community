class ApiConstants {
  String baseUrlPro = 'https://api.app.liveraapp.com/';
  String baseUrlDev = 'http://192.168.3.115:3553/';

  // Base URL for API requests
  static String baseUrl = 'http://192.168.3.115:3553/';

  static const int timeoutDuration = 30;

  // Auth Endpoints
  static const String login = 'user/login';
  static const String register = 'user/signup';
  static const String logout = 'auth/logout';
  static const String verifyOtp = 'user/verifyOtp';
  static const String resendOtp = 'user/resentOtp';
  static const String forgotPassword = 'user/forgotPassword';
  static const String resetPassword = 'user/changePassword';
  static const String refreshToken = 'user/refresh-token';

  // User Endpoints
  static const String profile = 'user/profile';
  static const String updateProfile = 'user/update-profile';
  static const String uploadImage = 'user/upload-image';

  // Coupon Endpoints
  static const String getCoupons = 'user/getCoupons';
  static const String actionOnCoupons = 'user/actionOnCoupon/';
  static const String useCoupon = 'user/useCoupon/';

  // Location Endpoints
  static const String countries = 'location/countries';
  static const String states = 'location/states';
  static const String districts = 'location/districts';
}
