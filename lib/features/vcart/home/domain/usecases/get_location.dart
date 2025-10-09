import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
//import '../repositories/home_repository.dart';
import 'package:livera/features/vcart/home/domain/repositories/home_repository.dart';
class GetLocation implements UseCase<String, NoParams> {
  final HomeRepository repository;

  GetLocation(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}
