import 'package:equatable/equatable.dart';

import 'wishlist_item.dart';

class WishlistData extends Equatable {
  final bool success;
  final List<WishlistItem> wishlistItems;
  final int total;
  final int totalPages;

  const WishlistData({
    required this.success,
    required this.wishlistItems,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [success, wishlistItems, total, totalPages];
}
