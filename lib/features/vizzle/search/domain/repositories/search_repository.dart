import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchAds(String keyword);
}
