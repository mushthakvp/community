import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_profile_repository.dart';

class RejectRequest implements UseCase<void, RejectRequestParams> {
  final ChatProfileRepository repository;

  RejectRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(RejectRequestParams params) async {
    return await repository.rejectRequest(params.communityId, params.requestId);
  }
}

class RejectRequestParams {
  final String communityId;
  final String requestId;

  RejectRequestParams({required this.communityId, required this.requestId});
}
