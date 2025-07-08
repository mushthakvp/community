import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/create_post_repository.dart';

class DeletePostUseCase implements UseCase<bool, DeletePostParams> {
  final CreatePostRepository repository;

  DeletePostUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeletePostParams params) async {
    return await repository.deletePost(params.postId);
  }
}

class DeletePostParams extends Equatable {
  final String postId;

  const DeletePostParams({required this.postId});

  @override
  List<Object> get props => [postId];
}
