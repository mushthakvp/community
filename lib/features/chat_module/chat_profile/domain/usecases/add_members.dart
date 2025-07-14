import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_profile_repository.dart';

class AddMembers implements UseCase<void, AddMembersParams> {
  final ChatProfileRepository repository;

  AddMembers(this.repository);

  @override
  Future<Either<Failure, void>> call(AddMembersParams params) async {
    return await repository.addMembers(params.communityId, params.memberIds);
  }
}

class AddMembersParams {
  final String communityId;
  final List<String> memberIds;

  AddMembersParams({required this.communityId, required this.memberIds});
}
