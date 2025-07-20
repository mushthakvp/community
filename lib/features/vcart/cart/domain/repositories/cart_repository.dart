import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/cart_data.dart';

abstract class CartRepository {
  Future<Either<Failure, CartData>> getCartData();
  Future<Either<Failure, CartData>> updateItemQuantity({
    required String productId,
    required String sizeId,
    required String action, // 'increment', 'decrement', 'remove'
  });
  Future<Either<Failure, bool>> moveToWishlist({required String productId});
  Future<Either<Failure, CartData>> applyCoupon({required String couponId});
  Future<Either<Failure, CartData>> removeCoupon();
}
