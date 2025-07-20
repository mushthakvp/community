import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/cart_data.dart';
import '../repositories/cart_repository.dart';

class GetCartData implements UseCase<CartData, NoParams> {
  final CartRepository repository;

  GetCartData(this.repository);

  @override
  Future<Either<Failure, CartData>> call(NoParams params) async {
    return await repository.getCartData();
  }
}
