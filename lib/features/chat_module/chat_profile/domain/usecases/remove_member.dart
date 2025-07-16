import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_profile_repository.dart';

class RemoveMember implements UseCase<void, RemoveMemberParams> {
  final ChatProfileRepository repository;

  RemoveMember(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveMemberParams params) async {
    return await repository.removeMember(params.communityId, params.userId);
  }
}

class RemoveMemberParams {
  final String communityId;
  final String userId;

  RemoveMemberParams({required this.communityId, required this.userId});
}
