import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/spin_result_entity.dart';
import '../repositories/spin_repository.dart';

class ExecuteSpinUseCase {
  final SpinRepository repository;

  ExecuteSpinUseCase(this.repository);

  Future<Either<Failure, SpinResultEntity>> call(String optionId) async {
    if (optionId.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Option ID cannot be empty'),
      );
    }
    return await repository.executeSpin(optionId);
  }
}
