import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/seller_profile.dart';
import '../repositories/seller_repository.dart';

class GetSellerProfileUseCase implements UseCase<SellerProfile, String> {
  final SellerRepository repository;

  GetSellerProfileUseCase(this.repository);

  @override
  Future<Either<Failure, SellerProfile>> call(String sellerId) async {
    return await repository.getSellerProfile(sellerId);
  }
}
