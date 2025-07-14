import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/community_info_entity.dart';
import '../../domain/entities/community_member_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/entities/member_request_entity.dart';
import '../../domain/repositories/chat_profile_repository.dart';
import '../datasources/chat_profile_local_datasource.dart';
import '../datasources/chat_profile_remote_datasource.dart';

class ChatProfileRepositoryImpl implements ChatProfileRepository {
  final ChatProfileRemoteDataSource remoteDataSource;
  final ChatProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CommunityMemberEntity>>> getCommunityMembers(
    String communityId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMembers = await remoteDataSource.getCommunityMembers(
          communityId,
        );
        await localDataSource.cacheMembers(communityId, remoteMembers);
        return Right(remoteMembers);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedMembers = await localDataSource.getCachedMembers(
          communityId,
        );
        if (cachedMembers != null) {
          return Right(cachedMembers);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data',
            ),
          );
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> removeMember(
    String communityId,
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeMember(communityId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addMembers(
    String communityId,
    List<String> memberIds,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addMembers(communityId, memberIds);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, MemberRequestsEntity>> getMemberRequests(
    String communityId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requests = await remoteDataSource.getMemberRequests(communityId);
        return Right(requests);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> approveRequest(
    String communityId,
    String requestId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.approveRequest(communityId, requestId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectRequest(
    String communityId,
    String requestId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.rejectRequest(communityId, requestId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFriends = await remoteDataSource.getFriends();
        await localDataSource.cacheFriends(remoteFriends);
        return Right(remoteFriends);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedFriends = await localDataSource.getCachedFriends();
        if (cachedFriends != null) {
          return Right(cachedFriends);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data',
            ),
          );
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> sendFriendRequest(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendFriendRequest(userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CommunityInfoEntity>> getCommunityInfo(
    String communityId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final communityInfo = await remoteDataSource.getCommunityInfo(
          communityId,
        );
        return Right(communityInfo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCommunity(String communityId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.leaveCommunity(communityId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
