import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_job_entity.dart';
import '../repositories/search_repository.dart';

class SearchJobsUseCase
    implements UseCase<SearchJobsResponseEntity, SearchJobsParams> {
  final SearchRepository repository;

  SearchJobsUseCase(this.repository);

  @override
  Future<Either<Failure, SearchJobsResponseEntity>> call(
    SearchJobsParams params,
  ) async {
    return await repository.searchJobs(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchJobsParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchJobsParams({
    required this.query,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [query, page, limit];
}
