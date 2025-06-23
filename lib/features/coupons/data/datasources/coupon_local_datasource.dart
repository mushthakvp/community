// lib/features/coupons/data/datasources/coupon_local_datasource.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/coupon_model.dart';

abstract class CouponLocalDataSource {
  Future<GetCouponsModel> getCachedCoupons();
  Future<void> cacheCoupons(GetCouponsModel coupons);
  Future<void> clearCache();
}

class CouponLocalDataSourceImpl implements CouponLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedCouponsKey = 'CACHED_COUPONS';
  static const String cacheTimeKey = 'CACHE_TIME';
  static const Duration cacheValidDuration = Duration(hours: 1);

  CouponLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<GetCouponsModel> getCachedCoupons() async {
    try {
      final cachedDataString = sharedPreferences.getString(cachedCouponsKey);
      final cacheTimeString = sharedPreferences.getString(cacheTimeKey);

      if (cachedDataString == null || cacheTimeString == null) {
        throw const CacheException('No cached data found');
      }

      final cacheTime = DateTime.parse(cacheTimeString);
      if (DateTime.now().difference(cacheTime) > cacheValidDuration) {
        throw const CacheException('Cached data expired');
      }

      final cachedData = json.decode(cachedDataString);
      return GetCouponsModel.fromJson(cachedData);
    } catch (e) {
      throw const CacheException('Failed to load cached coupons');
    }
  }

  @override
  Future<void> cacheCoupons(GetCouponsModel coupons) async {
    try {
      final dataString = json.encode(coupons.toJson());
      final timeString = DateTime.now().toIso8601String();

      await Future.wait([
        sharedPreferences.setString(cachedCouponsKey, dataString),
        sharedPreferences.setString(cacheTimeKey, timeString),
      ]);
    } catch (e) {
      throw const CacheException('Failed to cache coupons');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Future.wait([
        sharedPreferences.remove(cachedCouponsKey),
        sharedPreferences.remove(cacheTimeKey),
      ]);
    } catch (e) {
      throw const CacheException('Failed to clear cache');
    }
  }
}
