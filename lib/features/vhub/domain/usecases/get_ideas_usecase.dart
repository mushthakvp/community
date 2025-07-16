import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/idea_entity.dart';
import '../repositories/vhub_repository.dart';

class GetIdeasUseCase {
  final VHubRepository repository;

  GetIdeasUseCase(this.repository);

  Future<Either<Failure, List<IdeaEntity>>> call({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getIdeas(status: status, page: page, limit: limit);
  }
}
