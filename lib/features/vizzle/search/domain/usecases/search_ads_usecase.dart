import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class SearchAdsUseCase implements UseCase<SearchResult, String> {
  final SearchRepository repository;

  SearchAdsUseCase(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(String keyword) async {
    return await repository.searchAds(keyword);
  }
}
