import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/seller_profile.dart';

abstract class SellerRepository {
  Future<Either<Failure, SellerProfile>> getSellerProfile(String sellerId);
}
