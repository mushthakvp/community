import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/idea_entity.dart';
import '../repositories/vhub_repository.dart';

class GetFaqsUseCase {
  final VHubRepository repository;

  GetFaqsUseCase(this.repository);

  Future<Either<Failure, List<FaqEntity>>> call({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getFaqs(search: search, page: page, limit: limit);
  }
}
