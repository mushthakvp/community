import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/home_data.dart';
//import '../repositories/home_repository.dart';
import 'package:livera/features/vcart/home/domain/repositories/home_repository.dart';
class GetHomeData implements UseCase<HomeData, NoParams> {
  final HomeRepository repository;

  GetHomeData(this.repository);

  @override
  Future<Either<Failure, HomeData>> call(NoParams params) async {
    return await repository.getHomeData();
  }
}
