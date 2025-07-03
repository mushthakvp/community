import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spin_option_entity.dart';
import '../repositories/spin_repository.dart';

class GetSpinOptionsUseCase implements UseCase<List<SpinOptionEntity>, String> {
  final SpinRepository repository;

  GetSpinOptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpinOptionEntity>>> call(String spinType) async {
    return await repository.getSpinOptions(spinType);
  }
}
