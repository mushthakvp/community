import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_post_entity.dart';
import '../repositories/my_post_repository.dart';

class GetPostStatsUseCase implements UseCase<PostStatsEntity, NoParams> {
  final MyPostRepository repository;

  GetPostStatsUseCase(this.repository);

  @override
  Future<Either<Failure, PostStatsEntity>> call(NoParams params) async {
    return await repository.getPostStats();
  }
}
