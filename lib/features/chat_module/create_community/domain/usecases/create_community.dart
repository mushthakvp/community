import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_entity.dart';
import '../repositories/community_repository.dart';

class CreateCommunity
    implements UseCase<CommunityEntity, CreateCommunityParams> {
  final CommunityRepository repository;

  CreateCommunity(this.repository);

  @override
  Future<Either<Failure, CommunityEntity>> call(
    CreateCommunityParams params,
  ) async {
    return await repository.createCommunity(
      name: params.name,
      description: params.description,
      profileImage: params.profileImage,
    );
  }
}

class CreateCommunityParams {
  final String name;
  final String? description;
  final String? profileImage;

  CreateCommunityParams({
    required this.name,
    this.description,
    this.profileImage,
  });
}
