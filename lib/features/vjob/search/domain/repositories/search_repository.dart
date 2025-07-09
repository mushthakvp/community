import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/recent_search_entity.dart';
import '../entities/search_job_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, RecentSearchesResponseEntity>> getRecentSearches();
  Future<Either<Failure, SearchJobsResponseEntity>> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  });
}
