import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/vjob_home_repository.dart';

class LikePostUseCase implements UseCase<bool, LikePostParams> {
  final VJobHomeRepository repository;

  LikePostUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LikePostParams params) async {
    return await repository.likePost(params.postId);
  }
}

class LikePostParams extends Equatable {
  final String postId;

  const LikePostParams({required this.postId});

  @override
  List<Object> get props => [postId];
}
