import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/spin_repository.dart';

class CheckCanSpinUseCase implements UseCase<bool, String> {
  final SpinRepository repository;

  CheckCanSpinUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String spinType) async {
    return await repository.canUserSpin(spinType);
  }
}
