import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_post_repository.dart';

class LikeMyPostUseCase implements UseCase<bool, LikeMyPostParams> {
  final MyPostRepository repository;

  LikeMyPostUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LikeMyPostParams params) async {
    return await repository.likePost(params.postId);
  }
}

class LikeMyPostParams extends Equatable {
  final String postId;

  const LikeMyPostParams({required this.postId});

  @override
  List<Object> get props => [postId];
}
