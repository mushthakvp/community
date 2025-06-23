import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static const _userToken = "userToken";
  static const _usertier = "tier";
  static const _chatUserId = "chatUserId";
  static const _spinDate = "spinDate";
  static const _isLogined = "isLogined";
  static const _currentUserId = "currentUserId";
  static const _fcmToken = "fcmToken";
  static const _isVhubGetStarted = "isVhubGetStarted";

  static const _isSignedIn = 'isSignedIn';
  static const _isDark = "is_dark";
  static const String _country = 'country';

  static late SharedPreferences _preference;

  // Get Preef
  static SharedPreferences get pref => _preference;

  // Initialize shared preferences
  static Future<void> init() async {
    _preference = await SharedPreferences.getInstance();
  }

  // Reload shared preferences
  static Future<void> reloadPreference() async {
    await _preference.reload();
  }

  // Clear all shared preferences
  static Future<void> clear() async {
    await _preference.clear();
  }

  // User token
  static String get userToken => _preference.getString(_userToken) ?? "";
  static set userToken(String value) =>
      _preference.setString(_userToken, value);

  // User tier
  static String get userTier => _preference.getString(_usertier) ?? "";
  static set userTier(String value) => _preference.setString(_usertier, value);

  // Spin date
  static String get spinDate => _preference.getString(_spinDate) ?? "";
  static set spinDate(String value) => _preference.setString(_spinDate, value);

  // Login status
  static bool get isLogin => _preference.getBool(_isLogined) ?? false;
  static set isLogin(bool value) => _preference.setBool(_isLogined, value);

  // Current user ID
  static String get currentUserId =>
      _preference.getString(_currentUserId) ?? "";
  static set currentUserId(String value) =>
      _preference.setString(_currentUserId, value);

  // Chat user ID
  static String get chatUserId => _preference.getString(_chatUserId) ?? "";
  static set chatUserId(String value) =>
      _preference.setString(_chatUserId, value);

  // FCM token
  static String get fcmToken => _preference.getString(_fcmToken) ?? "";
  static set fcmToken(String value) => _preference.setString(_fcmToken, value);

  //User _usertier
  static String get uberties => _preference.getString(_usertier) ?? "";
  static set uberties(String value) => _preference.setString(_usertier, value);

  //User Is SignedIn or not
  static bool get isSignedIn => _preference.getBool(_isSignedIn) ?? true;
  static set isSignedIn(bool value) => _preference.setBool(_isSignedIn, value);

  //Theme prefference
  static bool get isDark => _preference.getBool(_isDark) ?? false;
  static set isDark(bool value) => _preference.setBool(_isDark, value);

  //country
  static String get country => _preference.getString(_country) ?? "";
  static set country(String value) => _preference.setString(_country, value);
  // V Hub Get Started
  static bool get isVhubGetStarted =>
      _preference.getBool(_isVhubGetStarted) ?? false;
  static set isVhubGetStarted(bool value) =>
      _preference.setBool(_isVhubGetStarted, value);
}
