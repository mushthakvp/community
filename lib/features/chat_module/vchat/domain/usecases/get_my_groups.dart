import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_entity.dart';
import '../repositories/community_repository.dart';

class GetMyGroups implements UseCase<List<CommunityEntity>, GetMyGroupsParams> {
  final CommunityRepository repository;

  GetMyGroups(this.repository);

  @override
  Future<Either<Failure, List<CommunityEntity>>> call(
    GetMyGroupsParams params,
  ) async {
    return await repository.getMyGroups(params.type);
  }
}

class GetMyGroupsParams {
  final String type;

  GetMyGroupsParams({required this.type});
}
