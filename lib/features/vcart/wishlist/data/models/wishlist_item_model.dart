import '../../domain/entities/wishlist_item.dart';
import 'wishlist_product_model.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({required super.id, required super.product});

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['_id'] ?? '',
      product: WishlistProductModel.fromJson(json['productId'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'productId': (product as WishlistProductModel).toJson()};
  }
}
