import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_entity.dart';
import '../repositories/community_repository.dart';

class UpdateCommunity
    implements UseCase<CommunityEntity, UpdateCommunityParams> {
  final CommunityRepository repository;

  UpdateCommunity(this.repository);

  @override
  Future<Either<Failure, CommunityEntity>> call(
    UpdateCommunityParams params,
  ) async {
    return await repository.updateCommunity(
      communityId: params.communityId,
      name: params.name,
      description: params.description,
      profileImage: params.profileImage,
    );
  }
}

class UpdateCommunityParams {
  final String communityId;
  final String? name;
  final String? description;
  final String? profileImage;

  UpdateCommunityParams({
    required this.communityId,
    this.name,
    this.description,
    this.profileImage,
  });
}
