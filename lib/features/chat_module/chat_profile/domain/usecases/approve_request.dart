import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_profile_repository.dart';

class ApproveRequest implements UseCase<void, ApproveRequestParams> {
  final ChatProfileRepository repository;

  ApproveRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(ApproveRequestParams params) async {
    return await repository.approveRequest(
      params.communityId,
      params.requestId,
    );
  }
}

class ApproveRequestParams {
  final String communityId;
  final String requestId;

  ApproveRequestParams({required this.communityId, required this.requestId});
}
