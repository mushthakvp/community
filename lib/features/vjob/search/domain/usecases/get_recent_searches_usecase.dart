import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/recent_search_entity.dart';
import '../repositories/search_repository.dart';

class GetRecentSearchesUseCase
    implements UseCase<RecentSearchesResponseEntity, NoParams> {
  final SearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  @override
  Future<Either<Failure, RecentSearchesResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getRecentSearches();
  }
}
