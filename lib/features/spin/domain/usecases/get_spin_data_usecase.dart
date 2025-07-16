import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/spin_data_entity.dart';
import '../repositories/spin_repository.dart';

class GetSpinDataUseCase {
  final SpinRepository repository;

  GetSpinDataUseCase(this.repository);

  Future<Either<Failure, SpinDataEntity>> call(String spinType) async {
    if (spinType.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Spin type cannot be empty'),
      );
    }
    return await repository.getSpinData(spinType);
  }
}
