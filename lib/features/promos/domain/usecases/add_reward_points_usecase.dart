import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/promos_repository.dart';

class AddRewardPointsParams {
  final int points;
  final String action;

  const AddRewardPointsParams({required this.points, required this.action});
}

class AddRewardPointsUseCase {
  final PromosRepository repository;

  AddRewardPointsUseCase(this.repository);

  Future<Either<Failure, bool>> call(AddRewardPointsParams params) async {
    if (params.points <= 0) {
      return const Left(
        ValidationFailure(message: 'Points must be greater than 0'),
      );
    }

    if (params.action.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Action cannot be empty'));
    }

    return await repository.addRewardPoints(
      points: params.points,
      action: params.action,
    );
  }
}
