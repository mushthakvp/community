import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class SearchChallengesUseCase
    implements UseCase<SearchResult, SearchChallengesParams> {
  final SearchRepository repository;

  SearchChallengesUseCase(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(
    SearchChallengesParams params,
  ) async {
    if (params.query.trim().isNotEmpty) {
      await repository.saveRecentSearch(params.query);
    }
    return await repository.searchChallenges(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchChallengesParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchChallengesParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object> get props => [query, page, limit];
}
