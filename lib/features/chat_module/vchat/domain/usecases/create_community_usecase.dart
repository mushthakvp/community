import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/community_entity.dart';
import '../repositories/chat_repository.dart';

class CreateCommunityUseCase {
  final ChatRepository repository;

  CreateCommunityUseCase(this.repository);

  Future<Either<Failure, CommunityEntity>> call({
    required String name,
    String? description,
    String? profileImage,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Community name is required'),
      );
    }

    return await repository.createCommunity(
      name: name.trim(),
      description: description?.trim(),
      profileImage: profileImage,
    );
  }
}
