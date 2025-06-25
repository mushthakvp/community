// lib/core/services/storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_constants.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Initialize storage
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods
  static Future<void> setSecureString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getSecureString(String key) async {
    return _prefs.getString(key);
  }

  static Future<void> deleteSecureString(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clearSecureStorage() async {
    await _prefs.clear();
  }

  // Shared Preferences Methods
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  static Future<void> setObject(String key, Map<String, dynamic> value) async {
    await setString(key, json.encode(value));
  }

  static Map<String, dynamic>? getObject(String key) {
    final jsonString = getString(key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
    await clearSecureStorage();
  }

  // Auth specific methods

  static Future<String?> getToken() async {
    return await getSecureString(StorageConstants.accessToken);
  }

  static Future<void> saveToken(String token) async {
    await setSecureString(StorageConstants.accessToken, token);
  }

  static Future<void> clearAuthTokens() async {
    await deleteSecureString(StorageConstants.accessToken);
  }

  // User specific methods
  static Future<void> saveUserId(String userId) async {
    await setSecureString(StorageConstants.userId, userId);
  }

  static Future<String?> getUserId() async {
    return await getSecureString(StorageConstants.userId);
  }

  static Future<void> saveUserEmail(String email) async {
    await setSecureString(StorageConstants.userEmail, email);
  }

  static Future<String?> getUserEmail() async {
    return await getSecureString(StorageConstants.userEmail);
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await setBool(StorageConstants.isLoggedIn, isLoggedIn);
  }

  static bool isLoggedIn() {
    return getBool(StorageConstants.isLoggedIn);
  }

  // New methods for additional user data
  static Future<void> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String communityId,
    required String tier,
    required int loyaltyPoints,
    required double walletAmount,
    required String currencyCode,
    String? joinedDate,
  }) async {
    await setString(StorageConstants.userName, name);
    await setSecureString(StorageConstants.userEmail, email);
    await setString(StorageConstants.userPhone, phone);
    await setString(StorageConstants.communityId, communityId);
    await setString(StorageConstants.userTier, tier);
    await setInt(StorageConstants.loyaltyPoints, loyaltyPoints);
    await setDouble(StorageConstants.walletAmount, walletAmount);
    await setString(StorageConstants.currencyCode, currencyCode);
    if (joinedDate != null) {
      await setString(StorageConstants.joinedDate, joinedDate);
    }
  }

  static Future<Map<String, dynamic>> getUserData() async {
    return {
      'name': getString(StorageConstants.userName) ?? '',
      'email': await getUserEmail() ?? '',
      'phone': getString(StorageConstants.userPhone) ?? '',
      'communityId': getString(StorageConstants.communityId) ?? '',
      'tier': getString(StorageConstants.userTier) ?? '',
      'loyaltyPoints': getInt(StorageConstants.loyaltyPoints),
      'walletAmount': getDouble(StorageConstants.walletAmount),
      'currencyCode': getString(StorageConstants.currencyCode) ?? '',
      'joinedDate': getString(StorageConstants.joinedDate) ?? '',
    };
  }

  // Cache methods with expiration
  static Future<void> setCacheWithExpiry(
    String key,
    Map<String, dynamic> data, {
    Duration? expiry,
  }) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry':
          expiry?.inMilliseconds ??
          (Duration(
            hours: StorageConstants.defaultCacheDuration,
          ).inMilliseconds),
    };
    await setObject(key, cacheData);
  }

  static Map<String, dynamic>? getCacheIfValid(String key) {
    final cacheData = getObject(key);
    if (cacheData == null) return null;

    final timestamp = cacheData['timestamp'] as int?;
    final expiry = cacheData['expiry'] as int?;

    if (timestamp == null || expiry == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiryTime = timestamp + expiry;

    if (now > expiryTime) {
      remove(key); // Remove expired cache
      return null;
    }

    return cacheData['data'] as Map<String, dynamic>?;
  }

  // Country Code and Name methods
  static Future<void> setCountryCode(String countryCode) async {
    await setString(StorageConstants.countryCode, countryCode);
  }

  static String? getCountryCode() {
    return getString(StorageConstants.countryCode);
  }

  static Future<void> setCountryName(String countryName) async {
    await setString(StorageConstants.countryName, countryName);
  }

  static String? getCountryName() {
    return getString(StorageConstants.countryName);
  }
}
