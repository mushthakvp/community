import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/promos_data.dart';
import '../repositories/promos_repository.dart';

class GetPromosUseCase {
  final PromosRepository repository;

  GetPromosUseCase(this.repository);

  Future<Either<Failure, PromosData>> call() async {
    return await repository.getPromos();
  }
}
