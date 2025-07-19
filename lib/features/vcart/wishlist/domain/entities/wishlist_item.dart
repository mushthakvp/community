import 'package:equatable/equatable.dart';

import 'wishlist_product.dart';

class WishlistItem extends Equatable {
  final String id;
  final WishlistProduct product;

  const WishlistItem({required this.id, required this.product});

  @override
  List<Object?> get props => [id, product];
}
