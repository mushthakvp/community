import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/post_repository.dart';

class LikePostUseCase {
  final PostRepository repository;

  LikePostUseCase(this.repository);

  Future<Either<Failure, bool>> call(String postId) async {
    return await repository.likePost(postId);
  }
}
