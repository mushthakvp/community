import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/vjob_home_repository.dart';

class GetPostsUseCase implements UseCase<List<PostEntity>, GetPostsParams> {
  final VJobHomeRepository repository;

  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(GetPostsParams params) async {
    return await repository.getPosts(page: params.page, limit: params.limit);
  }
}

class GetPostsParams extends Equatable {
  final int page;
  final int limit;

  const GetPostsParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
