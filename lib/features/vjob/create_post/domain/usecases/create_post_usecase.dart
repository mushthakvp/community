import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_post_entity.dart';
import '../entities/post_response_entity.dart';
import '../repositories/create_post_repository.dart';

class CreatePostUseCase {
  final CreatePostRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, PostResponseEntity>> call(
    CreatePostEntity post,
  ) async {
    // Validate the post data
    if (!post.isValid) {
      final errors = post.validationErrors.entries
          .where((entry) => entry.value != null)
          .map((entry) => entry.value!)
          .join(', ');
      return Left(ValidationFailure(message: errors));
    }

    return await repository.createPost(
      title: post.title.trim(),
      description: post.description.trim(),
      image: post.image.trim(),
    );
  }
}
