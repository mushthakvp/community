import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/spin_option_model.dart';
import '../models/spin_result_model.dart';

abstract class SpinLocalDataSource {
  Future<List<SpinOptionModel>> getCachedSpinOptions(String spinType);
  Future<void> cacheSpinOptions(String spinType, List<SpinOptionModel> options);
  Future<List<SpinResultModel>> getCachedSpinResults();
  Future<void> cacheSpinResult(SpinResultModel result);
  Future<void> clearCache();
  Future<DateTime?> getLastSpinDate(String spinType);
  Future<void> setLastSpinDate(String spinType, DateTime date);
  Future<int> getTodaySpinCount(String spinType);
  Future<void> incrementTodaySpinCount(String spinType);
  Future<void> resetDailySpinCount(String spinType);
}

class SpinLocalDataSourceImpl implements SpinLocalDataSource {
  final SharedPreferences sharedPreferences;

  SpinLocalDataSourceImpl({required this.sharedPreferences});

  static const String _spinOptionsPrefix = 'spin_options_';
  static const String _spinResultsKey = 'spin_results';
  static const String _lastSpinDatePrefix = 'last_spin_date_';
  static const String _todaySpinCountPrefix = 'today_spin_count_';

  @override
  Future<List<SpinOptionModel>> getCachedSpinOptions(String spinType) async {
    try {
      final jsonString = sharedPreferences.getString(
        '$_spinOptionsPrefix$spinType',
      );
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => SpinOptionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached spin options');
    }
  }

  @override
  Future<void> cacheSpinOptions(
    String spinType,
    List<SpinOptionModel> options,
  ) async {
    try {
      final jsonString = json.encode(
        options.map((option) => option.toJson()).toList(),
      );
      await sharedPreferences.setString(
        '$_spinOptionsPrefix$spinType',
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to cache spin options');
    }
  }

  @override
  Future<List<SpinResultModel>> getCachedSpinResults() async {
    try {
      final jsonString = sharedPreferences.getString(_spinResultsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => SpinResultModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached spin results');
    }
  }

  @override
  Future<void> cacheSpinResult(SpinResultModel result) async {
    try {
      final existingResults = await getCachedSpinResults();
      existingResults.add(result);

      // Keep only last 100 results
      if (existingResults.length > 100) {
        existingResults.removeRange(0, existingResults.length - 100);
      }

      final jsonString = json.encode(
        existingResults.map((result) => result.toJson()).toList(),
      );
      await sharedPreferences.setString(_spinResultsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache spin result');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final spinKeys = keys
          .where(
            (key) =>
                key.startsWith(_spinOptionsPrefix) ||
                key == _spinResultsKey ||
                key.startsWith(_lastSpinDatePrefix) ||
                key.startsWith(_todaySpinCountPrefix),
          )
          .toList();

      for (final key in spinKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<DateTime?> getLastSpinDate(String spinType) async {
    try {
      final dateString = sharedPreferences.getString(
        '$_lastSpinDatePrefix$spinType',
      );
      if (dateString != null) {
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setLastSpinDate(String spinType, DateTime date) async {
    try {
      await sharedPreferences.setString(
        '$_lastSpinDatePrefix$spinType',
        date.toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to set last spin date');
    }
  }

  @override
  Future<int> getTodaySpinCount(String spinType) async {
    try {
      final today = DateTime.now();
      final todayKey =
          '$_todaySpinCountPrefix${spinType}_${today.year}_${today.month}_${today.day}';
      return sharedPreferences.getInt(todayKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> incrementTodaySpinCount(String spinType) async {
    try {
      final today = DateTime.now();
      final todayKey =
          '$_todaySpinCountPrefix${spinType}_${today.year}_${today.month}_${today.day}';
      final currentCount = sharedPreferences.getInt(todayKey) ?? 0;
      await sharedPreferences.setInt(todayKey, currentCount + 1);
    } catch (e) {
      throw CacheException('Failed to increment spin count');
    }
  }

  @override
  Future<void> resetDailySpinCount(String spinType) async {
    try {
      final keys = sharedPreferences.getKeys();
      final spinCountKeys = keys
          .where((key) => key.startsWith('$_todaySpinCountPrefix$spinType'))
          .toList();

      for (final key in spinCountKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to reset daily spin count');
    }
  }
}
