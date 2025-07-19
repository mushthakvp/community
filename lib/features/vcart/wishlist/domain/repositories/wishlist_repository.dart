import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/wishlist_data.dart';

abstract class WishlistRepository {
  Future<Either<Failure, WishlistData>> getWishlistData({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, bool>> toggleWishlistItem(String productId);
}
