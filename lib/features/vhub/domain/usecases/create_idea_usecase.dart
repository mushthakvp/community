import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/idea_entity.dart';
import '../repositories/vhub_repository.dart';

class CreateIdeaUseCase {
  final VHubRepository repository;

  CreateIdeaUseCase(this.repository);

  Future<Either<Failure, IdeaEntity>> call(CreateIdeaParams params) async {
    return await repository.createIdea(params);
  }
}
