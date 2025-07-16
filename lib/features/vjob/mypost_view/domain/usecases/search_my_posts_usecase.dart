import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_post_entity.dart';
import '../repositories/my_post_repository.dart';

class SearchMyPostsUseCase
    implements UseCase<List<MyPostEntity>, SearchMyPostsParams> {
  final MyPostRepository repository;

  SearchMyPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyPostEntity>>> call(
    SearchMyPostsParams params,
  ) async {
    return await repository.searchMyPosts(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchMyPostsParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchMyPostsParams({
    required this.query,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [query, page, limit];
}
