import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_results.dart';
import '../repositories/search_repository.dart';

class SearchProducts implements UseCase<SearchResults, SearchProductsParams> {
  final SearchRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, SearchResults>> call(
    SearchProductsParams params,
  ) async {
    return await repository.searchProducts(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchProductsParams {
  final String query;
  final int page;
  final int limit;
  final bool isLoadMore;

  const SearchProductsParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
  });
}
