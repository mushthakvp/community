import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/spin_repository.dart';

class GetUserLoyaltyPointsUseCase implements UseCase<int, NoParams> {
  final SpinRepository repository;

  GetUserLoyaltyPointsUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getUserLoyaltyPoints();
  }
}
