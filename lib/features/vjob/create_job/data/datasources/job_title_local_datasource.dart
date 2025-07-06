import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';
import '../models/job_title_model.dart';

abstract class JobTitleLocalDataSource {
  Future<List<JobTitleModel>> getCachedJobTitles();
  Future<void> cacheJobTitles(List<JobTitleModel> jobTitles);
  Future<void> clearJobTitlesCache();
}

class JobTitleLocalDataSourceImpl implements JobTitleLocalDataSource {
  static const String _jobTitlesCacheKey = 'cached_job_titles';
  static const String _cacheTimestampKey = 'job_titles_cache_timestamp';
  static const Duration _cacheExpiration = Duration(hours: 24);

  final SharedPreferences _sharedPreferences;

  JobTitleLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<List<JobTitleModel>> getCachedJobTitles() async {
    try {
      final cachedData = _sharedPreferences.getString(_jobTitlesCacheKey);
      final cacheTimestamp = _sharedPreferences.getInt(_cacheTimestampKey);

      if (cachedData == null || cacheTimestamp == null) {
        throw CacheException('No cached job titles found');
      }

      // Check if cache is expired
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
      final now = DateTime.now();

      if (now.difference(cacheDate) > _cacheExpiration) {
        throw CacheException('Cached job titles expired');
      }

      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList.map((json) => JobTitleModel.fromJson(json)).toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached job titles');
    }
  }

  @override
  Future<void> cacheJobTitles(List<JobTitleModel> jobTitles) async {
    try {
      final jsonList = jobTitles.map((title) => title.toJson()).toList();
      final jsonString = json.encode(jsonList);

      await _sharedPreferences.setString(_jobTitlesCacheKey, jsonString);
      await _sharedPreferences.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Failed to cache job titles');
    }
  }

  @override
  Future<void> clearJobTitlesCache() async {
    try {
      await _sharedPreferences.remove(_jobTitlesCacheKey);
      await _sharedPreferences.remove(_cacheTimestampKey);
    } catch (e) {
      throw CacheException('Failed to clear job titles cache');
    }
  }
}
