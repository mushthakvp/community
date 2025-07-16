import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class GetVizzleHomeUseCase {
  final VizzleRepository repository;

  GetVizzleHomeUseCase(this.repository);

  Future<Either<Failure, VizzleHomeEntity>> call() async {
    return await repository.getVizzleHome();
  }
}
