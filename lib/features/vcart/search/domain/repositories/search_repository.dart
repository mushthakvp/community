import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/search_data.dart';
import '../entities/search_results.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchData>> getSearchData();
  Future<Either<Failure, SearchResults>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, void>> cacheSearchData(SearchData searchData);
  Future<Either<Failure, SearchData?>> getCachedSearchData();
}
