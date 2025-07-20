import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/cart_data_model.dart';

abstract class CartLocalDataSource {
  Future<CartDataModel?> getCachedCartData();
  Future<void> cacheCartData(CartDataModel cartData);
  Future<void> clearCartCache();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartDataKey =
      '${VCartConstants.cacheKeyPrefix}cart_data';
  static const String _timestampKey =
      '${VCartConstants.cacheKeyPrefix}cart_timestamp';

  @override
  Future<CartDataModel?> getCachedCartData() async {
    try {
      final timestampString = StorageService.getString(_timestampKey);
      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Cart data expires after 5 minutes
      if (now.difference(timestamp) > const Duration(minutes: 5)) {
        await clearCartCache();
        return null;
      }

      final cachedData = StorageService.getString(_cartDataKey);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return CartDataModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached cart data: $e');
    }
  }

  @override
  Future<void> cacheCartData(CartDataModel cartData) async {
    try {
      final jsonString = json.encode({
        'success': cartData.success,
        'message': cartData.message,
        'cart': cartData.items
            .map(
              (item) => {
                'productId': item.productId,
                'sizeId': item.sizeId,
                'name': item.name,
                'images': item.images,
                'size': item.size,
                'price': item.price,
                'offerPrice': item.offerPrice,
                'tax': item.tax,
                'quantity': item.quantity,
                'availableStock': item.availableStock,
                'isAvailable': item.isAvailable,
                'message': item.message,
                'couponDiscount': item.couponDiscount,
                'commission': item.commission,
              },
            )
            .toList(),
        'subTotal': cartData.subTotal,
        'offerPrice': cartData.offerPrice,
        'commission': cartData.commission,
        'shippingCharge': cartData.shippingCharge,
        'tax': cartData.tax,
        'discount': cartData.discount,
        'couponDiscount': cartData.couponDiscount,
        'total': cartData.total,
        'walletAmount': cartData.walletAmount,
        'couponData': cartData.couponData != null
            ? {
                '_id': cartData.couponData!.id,
                'couponName': cartData.couponData!.couponName,
                'minimumPrice': cartData.couponData!.minimumPrice,
                'description': cartData.couponData!.description,
                'useCountPerUser': cartData.couponData!.useCountPerUser,
                'maximumUsers': cartData.couponData!.maximumUsers,
                'discount': cartData.couponData!.discount,
                'discountType': cartData.couponData!.discountType,
                'startDate': cartData.couponData!.startDate.toIso8601String(),
                'endDate': cartData.couponData!.endDate.toIso8601String(),
                'isShowInUser': cartData.couponData!.isShowInUser,
                'createdBy': cartData.couponData!.createdBy,
                'vendorId': cartData.couponData!.vendorId,
                'totalUsageCount': cartData.couponData!.totalUsageCount,
                'usedUsers': cartData.couponData!.usedUsers,
                'isDeleted': cartData.couponData!.isDeleted,
                'createdAt': cartData.couponData!.createdAt.toIso8601String(),
                'updatedAt': cartData.couponData!.updatedAt.toIso8601String(),
              }
            : null,
      });

      await StorageService.setString(_cartDataKey, jsonString);
      await StorageService.setString(
        _timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache cart data: $e');
    }
  }

  @override
  Future<void> clearCartCache() async {
    try {
      await StorageService.remove(_cartDataKey);
      await StorageService.remove(_timestampKey);
    } catch (e) {
      throw CacheException('Failed to clear cart cache: $e');
    }
  }
}
