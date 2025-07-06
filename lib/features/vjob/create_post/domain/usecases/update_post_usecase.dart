import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_post_entity.dart';
import '../entities/post_response_entity.dart';
import '../repositories/create_post_repository.dart';

class UpdatePostUseCase {
  final CreatePostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Either<Failure, PostResponseEntity>> call({
    required String postId,
    required CreatePostEntity post,
  }) async {
    // Validate the post data
    if (!post.isValid) {
      final errors = post.validationErrors.entries
          .where((entry) => entry.value != null)
          .map((entry) => entry.value!)
          .join(', ');
      return Left(ValidationFailure(message: errors));
    }

    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Post ID is required'));
    }

    return await repository.updatePost(
      postId: postId.trim(),
      title: post.title.trim(),
      description: post.description.trim(),
      image: post.image.trim(),
    );
  }
}
