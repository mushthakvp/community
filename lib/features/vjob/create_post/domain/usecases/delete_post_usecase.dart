import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/create_post_repository.dart';

class DeletePostUseCase {
  final CreatePostRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, bool>> call(String postId) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Post ID is required'));
    }

    return await repository.deletePost(postId.trim());
  }
}
