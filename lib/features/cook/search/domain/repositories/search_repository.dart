import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchChallenges({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, List<String>>> getSearchSuggestions(String query);

  Future<void> saveRecentSearch(String query);

  Future<List<String>> getRecentSearches();

  Future<void> clearRecentSearches();
}
