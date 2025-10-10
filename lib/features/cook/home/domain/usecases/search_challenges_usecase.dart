import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/cooking_home.dart';
import '../repositories/home_repository.dart';
import 'get_cooking_home_usecase.dart';

class SearchChallengesUseCase
    implements UseCase<CookingHome, GetCookingHomeParams> {
  final CookHomeRepository repository;

  SearchChallengesUseCase(this.repository);

  @override
  Future<Either<Failure, CookingHome>> call(GetCookingHomeParams params) async {
    return await repository.getCookingHome(
      search: params.search,
      currentPage: params.currentPage,
      currentLimit: params.currentLimit,
      upcomingPage: params.upcomingPage,
      upcomingLimit: params.upcomingLimit,
    );
  }
}
