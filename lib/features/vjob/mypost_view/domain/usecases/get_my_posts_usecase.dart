import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_post_entity.dart';
import '../repositories/my_post_repository.dart';

class GetMyPostsUseCase
    implements UseCase<List<MyPostEntity>, GetMyPostsParams> {
  final MyPostRepository repository;

  GetMyPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyPostEntity>>> call(
    GetMyPostsParams params,
  ) async {
    return await repository.getMyPosts(page: params.page, limit: params.limit);
  }
}

class GetMyPostsParams extends Equatable {
  final int page;
  final int limit;

  const GetMyPostsParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
