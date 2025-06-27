import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetUserDetailsUseCase {
  final HomeRepository repository;

  GetUserDetailsUseCase(this.repository);

  Future<Either<Failure, UserDetailsEntity>> call() async {
    return await repository.getUserDetails();
  }
}
