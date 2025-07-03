import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/spin_repository.dart';

class GetRemainingSpinsUseCase implements UseCase<int, String> {
  final SpinRepository repository;

  GetRemainingSpinsUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(String spinType) async {
    return await repository.getRemainingSpins(spinType);
  }
}
