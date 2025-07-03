import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spin_config_entity.dart';
import '../repositories/spin_repository.dart';

class GetSpinConfigUseCase implements UseCase<SpinConfigEntity, String> {
  final SpinRepository repository;

  GetSpinConfigUseCase(this.repository);

  @override
  Future<Either<Failure, SpinConfigEntity>> call(String spinType) async {
    return await repository.getSpinConfig(spinType);
  }
}
