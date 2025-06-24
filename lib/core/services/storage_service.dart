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
  static Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await setSecureString(StorageConstants.accessToken, accessToken);
    await setSecureString(StorageConstants.refreshToken, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await getSecureString(StorageConstants.accessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await getSecureString(StorageConstants.refreshToken);
  }

  static Future<void> clearAuthTokens() async {
    await deleteSecureString(StorageConstants.accessToken);
    await deleteSecureString(StorageConstants.refreshToken);
  }

  // User specific methods
  static Future<void> saveUserId(String userId) async {
    await setSecureString(StorageConstants.userId, userId);
  }

  static Future<String?> getUserId() async {
    return await getSecureString(StorageConstants.userId);
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await setBool(StorageConstants.isLoggedIn, isLoggedIn);
  }

  static bool isLoggedIn() {
    return getBool(StorageConstants.isLoggedIn);
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
}
