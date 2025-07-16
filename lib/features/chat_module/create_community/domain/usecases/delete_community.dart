import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class DeleteCommunity implements UseCase<void, DeleteCommunityParams> {
  final CommunityRepository repository;

  DeleteCommunity(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCommunityParams params) async {
    return await repository.deleteCommunity(params.communityId);
  }
}

class DeleteCommunityParams {
  final String communityId;

  DeleteCommunityParams({required this.communityId});
}
