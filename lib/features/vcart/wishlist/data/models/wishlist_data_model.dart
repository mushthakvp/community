import '../../domain/entities/wishlist_data.dart';
import 'wishlist_item_model.dart';

class WishlistDataModel extends WishlistData {
  const WishlistDataModel({
    required super.success,
    required super.wishlistItems,
    required super.total,
    required super.totalPages,
  });

  factory WishlistDataModel.fromJson(Map<String, dynamic> json) {
    return WishlistDataModel(
      success: json['success'] ?? false,
      wishlistItems:
          (json['wishList'] as List<dynamic>?)
              ?.map(
                (e) => WishlistItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'wishList': wishlistItems
          .map((e) => (e as WishlistItemModel).toJson())
          .toList(),
      'total': total,
      'totalPages': totalPages,
    };
  }
}
