import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/product_overview_response_model.dart';

abstract class ProductOverviewLocalDataSource {
  Future<ProductOverviewResponseModel?> getCachedProductDetail(
    String productId,
  );
  Future<void> cacheProductDetail(
    String productId,
    ProductOverviewResponseModel productDetail,
  );
  Future<void> clearCache();
}

class ProductOverviewLocalDataSourceImpl
    implements ProductOverviewLocalDataSource {
  static const String _productDetailPrefix =
      '${VCartConstants.cacheKeyPrefix}product_detail_';
  static const String _timestampPrefix =
      '${VCartConstants.cacheKeyPrefix}product_timestamp_';

  @override
  Future<ProductOverviewResponseModel?> getCachedProductDetail(
    String productId,
  ) async {
    try {
      final timestampKey = '$_timestampPrefix$productId';
      final timestampString = StorageService.getString(timestampKey);

      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > VCartConstants.cacheValidDuration) {
        await _clearProductCache(productId);
        return null;
      }

      final key = '$_productDetailPrefix$productId';
      final cachedData = StorageService.getString(key);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return ProductOverviewResponseModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached product detail: $e');
    }
  }

  @override
  Future<void> cacheProductDetail(
    String productId,
    ProductOverviewResponseModel productDetail,
  ) async {
    try {
      final key = '$_productDetailPrefix$productId';
      final timestampKey = '$_timestampPrefix$productId';

      final jsonString = json.encode({
        'success': productDetail.success,
        'message': productDetail.message,
        'data': (productDetail.productDetail as dynamic).toJson(),
        'isAddedWishList': productDetail.isAddedWishList,
      });

      await StorageService.setString(key, jsonString);
      await StorageService.setString(
        timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache product detail: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Note: This is a simplified implementation
      // In a real app, you might want to iterate through all product cache keys
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  Future<void> _clearProductCache(String productId) async {
    try {
      final key = '$_productDetailPrefix$productId';
      final timestampKey = '$_timestampPrefix$productId';

      await StorageService.remove(key);
      await StorageService.remove(timestampKey);
    } catch (e) {
      throw CacheException('Failed to clear product cache: $e');
    }
  }
}
