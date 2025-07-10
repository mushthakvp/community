import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/community_entity.dart';
import '../repositories/chat_repository.dart';

class GetCommunitiesUseCase {
  final ChatRepository repository;

  GetCommunitiesUseCase(this.repository);

  Future<Either<Failure, List<CommunityEntity>>> call({
    String? status,
    String? type,
  }) async {
    return await repository.getCommunities(status: status, type: type);
  }
}
