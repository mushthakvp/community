import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    int page = 1,
    int limit = 10,
    String type = 'all',
  }) async {
    return await repository.getPosts(page: page, limit: limit, type: type);
  }
}
