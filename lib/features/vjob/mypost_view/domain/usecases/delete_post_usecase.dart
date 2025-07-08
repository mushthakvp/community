import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_post_repository.dart';

class DeleteMyPostUseCase implements UseCase<bool, DeleteMyPostParams> {
  final MyPostRepository repository;

  DeleteMyPostUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteMyPostParams params) async {
    return await repository.deletePost(params.postId);
  }
}

class DeleteMyPostParams extends Equatable {
  final String postId;

  const DeleteMyPostParams({required this.postId});

  @override
  List<Object> get props => [postId];
}
