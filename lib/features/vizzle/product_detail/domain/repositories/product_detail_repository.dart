import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/product_detail.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(String shareUrl);
  Future<Either<Failure, bool>> toggleFavorite(String productId);
  Future<Either<Failure, String>> shareProduct(String productId);
  Future<Either<Failure, bool>> reportProduct(String productId, String reason);
  Future<Either<Failure, String>> accessChat(String friendId, String postId);
}
